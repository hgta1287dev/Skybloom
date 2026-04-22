local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Matter = require(ReplicatedStorage.Packages._Index["matter-ecs_matter@0.8.5"].matter)

export type World = Matter.World
export type Loop = Matter.Loop

type MatterSystem = {}

export type System = {
	name: string,
	system: (world: Matter.World, state: any) -> any,
	priority: number,
	after: { string }?,
	before: { string }?,
}

type SystemDef = {
	name: string,
	system: (world: World, state: any) -> any,
	priority: number?,
	after: { string }?,
	before: { string }?,
}

local DEFAULT_PRIORITY = 10

local ECS = {}
ECS.world = Matter.World.new() :: World
ECS.World = ECS.world :: World
ECS.loop = Matter.Loop.new(ECS.world) :: Loop

local container = {} :: { [string]: System }
local started = false
local loaded = {}

local function topoSort(systems: { System })
	local graph = {}
	local indegree = {}
	local map = {}

	for _, sys in ipairs(systems) do
		graph[sys.name] = {}
		indegree[sys.name] = 0
		map[sys.name] = sys
	end

	for _, sys in ipairs(systems) do
		if sys.after then
			for _, dep in ipairs(sys.after) do
				assert(map[dep], `System {dep} not found`)
				assert(map[dep].priority == sys.priority, `System {sys.name} cannot depend on {dep} across priorities`)
				table.insert(graph[dep], sys.name)
				indegree[sys.name] += 1
			end
		end

		if sys.before then
			for _, dep in ipairs(sys.before) do
				assert(map[dep], `System {dep} not found`)
				assert(map[dep].priority == sys.priority, `System {sys.name} cannot depend on {dep} across priorities`)
				table.insert(graph[sys.name], dep)
				indegree[dep] += 1
			end
		end
	end

	local queue = {}
	for name, deg in pairs(indegree) do
		if deg == 0 then
			table.insert(queue, name)
		end
	end

	local result = {}
	local head = 1

	while head <= #queue do
		local name = queue[head]
		head += 1

		table.insert(result, map[name])

		for _, nei in ipairs(graph[name]) do
			indegree[nei] -= 1
			if indegree[nei] == 0 then
				table.insert(queue, nei)
			end
		end
	end

	assert(#result == #systems, "Cycle detected in system dependencies")
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
		after = systemDef.after,
		before = systemDef.before,
	}
	container[systemDef.name] = system

	return system :: System
end

function ECS.Start()
	assert(not started, "ECS has already started")
	local loop = ECS.loop

	-- collect
	local all = {}
	for _, system in pairs(container) do
		table.insert(all, system)
	end

	--! validate
	for _, sys in ipairs(all) do
		for _, dep in ipairs(sys.after or {}) do
			local target = container[dep]
			assert(target, "missing system: " .. dep)
			assert(target.priority == sys.priority, "cross priority forbidden")
		end

		for _, dep in ipairs(sys.before or {}) do
			local target = container[dep]
			assert(target, "missing system: " .. dep)
			assert(target.priority == sys.priority, "cross priority forbidden")
		end
	end

	-- group by priority
	local groups = {}

	for _, sys in ipairs(all) do
		local p = sys.priority
		groups[p] = groups[p] or {}
		table.insert(groups[p], sys)
	end

	-- sort priorities
	local priorities = {}
	for p in pairs(groups) do
		table.insert(priorities, p)
	end
	table.sort(priorities)

	-- build final list
	local systemList = {}

	for _, p in ipairs(priorities) do
		local sorted = topoSort(groups[p])

		for _, sys in ipairs(sorted) do
			table.insert(systemList, sys.system) -- function only
		end
	end

	started = true
	loop:scheduleSystems(systemList)

	if RunService:IsServer() then
		loop:begin({
			default = RunService.Heartbeat,
			Heartbeat = RunService.Heartbeat,
			RenderStepped = RunService.RenderStepped,
			Stepped = RunService.Stepped,
		})
	else
		loop:begin({
			default = RunService.RenderStepped,
			RenderStepped = RunService.RenderStepped,
			Stepped = RunService.Stepped,
		})
	end
end

function ECS.AddSystems(parent: Instance)
	assert(not started, `Systems cannot be added after calling "ECS.Start()"`)

	for _, v in pairs(parent:GetChildren()) do
		if not v:IsA("ModuleScript") then
			continue
		end

		require(v)
	end
end

function ECS.AddSystemsDeep(parent: Instance)
	for _, v in pairs(parent:GetDescendants()) do
		if not v:IsA("ModuleScript") then
			continue
		end

		if loaded[v] then
			continue
		end

		loaded[v] = true
		require(v)
	end
end
return ECS
