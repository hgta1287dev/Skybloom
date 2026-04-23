local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Matter = require(ReplicatedStorage.Packages._Index["matter-ecs_matter@0.8.5"].matter)

export type World = Matter.World
export type Loop = Matter.Loop

export type Dependency = string | { name: string }

export type System = {
	name: string,
	system: (world: World, state: any) -> (),
	priority: number,
	event: string?,
	after: { Dependency }?,
	before: { Dependency }?,
	order: number, -- internal stable ordering
}

export type SystemDef = {
	name: string,
	system: (world: World, state: any) -> (),
	priority: number?,
	event: string?,
	after: { Dependency }?,
	before: { Dependency }?,
}

local DEFAULT_PRIORITY = 0

local ECS = {}
ECS.world = Matter.World.new() :: World
ECS.World = ECS.world :: World
ECS.loop = Matter.Loop.new(ECS.world) :: Loop

local container = {} :: { [string]: System }
local started = false
local nextOrder = 0

local loaded = setmetatable({}, { __mode = "k" })
local loading = setmetatable({}, { __mode = "k" })

local function getDepName(dep: any): string
	if type(dep) == "string" then
		return dep
	end

	assert(type(dep) == "table", `Invalid dependency type: {type(dep)}`)
	assert(type(dep.name) == "string", "Invalid system reference: missing .name")
	return dep.name
end

local function resolveDependency(dep: Dependency, systemMap: { [string]: System }, owner: System): System
	local depName = getDepName(dep)
	local target = systemMap[depName]
	assert(target, `System {depName} not found (required by {owner.name})`)
	return target
end

local function addUnique(list: { System }, system: System)
	for _, existing in ipairs(list) do
		if existing == system then
			return
		end
	end

	table.insert(list, system)
end

local function sortByLoadOrder(a: System, b: System): boolean
	if a.order == b.order then
		return a.name < b.name
	end
	return a.order < b.order
end

local function collectModules(parent: Instance, deep: boolean): { ModuleScript }
	local result = {} :: { ModuleScript }
	local source = if deep then parent:GetDescendants() else parent:GetChildren()

	for _, inst in ipairs(source) do
		if inst:IsA("ModuleScript") then
			table.insert(result, inst)
		end
	end

	table.sort(result, function(a, b)
		return a:GetFullName() < b:GetFullName()
	end)

	return result
end

local function loadModule(mod: ModuleScript)
	if loaded[mod] then
		return
	end

	assert(not loading[mod], `Circular module dependency detected while loading {mod:GetFullName()}`)
	loading[mod] = true

	local ok, result = pcall(require, mod)
	loading[mod] = nil

	if not ok then
		error(result, 2)
	end

	loaded[mod] = true
	return result
end

function ECS.CreateSystem(systemDef: SystemDef): System
	assert(type(systemDef) == "table", `System must be a table; got {type(systemDef)}`)
	assert(type(systemDef.name) == "string", `System.Name must be a string; got {type(systemDef.name)}`)
	assert(#systemDef.name > 0, "System.Name must be a non-empty string")
	assert(not container[systemDef.name], `System {systemDef.name} already exists`)
	assert(type(systemDef.system) == "function", `System.Update must be a function; got {type(systemDef.system)}`)
	assert(not started, `Systems cannot be created after calling "ECS.Start()"`)

	local system: System = {
		name = systemDef.name,
		system = systemDef.system,
		priority = systemDef.priority or DEFAULT_PRIORITY,
		event = systemDef.event,
		after = systemDef.after,
		before = systemDef.before,
		order = nextOrder,
	}

	nextOrder += 1
	container[systemDef.name] = system
	return system
end

function ECS.Start()
	assert(not started, "ECS has already started")

	local all = {} :: { System }
	for _, system in pairs(container) do
		table.insert(all, system)
	end
	table.sort(all, sortByLoadOrder)

	local systemMap = {} :: { [string]: System }
	for _, sys in ipairs(all) do
		assert(not systemMap[sys.name], `Duplicate system name: {sys.name}`)
		systemMap[sys.name] = sys
	end

	-- Normalize all `after` deps to actual system refs first.
	for _, sys in ipairs(all) do
		local normalizedAfter = {} :: { System }

		if sys.after then
			for _, dep in ipairs(sys.after) do
				local target = resolveDependency(dep, systemMap, sys)
				assert(target ~= sys, `System {sys.name} cannot depend on itself`)
				addUnique(normalizedAfter, target)
			end
		end

		sys.after = normalizedAfter
	end

	-- Convert `before` into extra `after` edges on the target systems.
	for _, sys in ipairs(all) do
		if sys.before then
			for _, dep in ipairs(sys.before) do
				local target = resolveDependency(dep, systemMap, sys)
				assert(target ~= sys, `System {sys.name} cannot depend on itself`)
				addUnique(target.after or {}, sys)
				target.after = target.after or {}
			end
		end
	end

	-- Clear `before` since Matter only schedules `after`.
	for _, sys in ipairs(all) do
		sys.before = nil
	end

	-- Let Matter do the actual scheduling/sorting.
	ECS.loop:setWorlds({ ECS.world })
	ECS.loop:scheduleSystems(all)

	started = true

	if RunService:IsServer() then
		ECS.loop:begin({
			default = RunService.Heartbeat,
			Heartbeat = RunService.Heartbeat,
			Stepped = RunService.Stepped,
		})
	else
		ECS.loop:begin({
			default = RunService.RenderStepped,
			RenderStepped = RunService.RenderStepped,
			Heartbeat = RunService.Heartbeat,
			Stepped = RunService.Stepped,
		})
	end
end

function ECS.AddSystems(parent: Instance)
	assert(not started, `Systems cannot be added after calling "ECS.Start()"`)

	for _, mod in ipairs(collectModules(parent, false)) do
		loadModule(mod)
	end
end

function ECS.AddSystemsDeep(parent: Instance)
	assert(not started, `Systems cannot be added after calling "ECS.Start()"`)

	for _, mod in ipairs(collectModules(parent, true)) do
		loadModule(mod)
	end
end

return ECS
