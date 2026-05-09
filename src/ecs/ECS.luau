local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local ECSState = require(script.Parent.ECSState)
local Matter = require(ReplicatedStorage.Packages._Index["matter-ecs_matter@0.8.5"].matter)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)
local Logger = LoggerManager:CreateLogger(script.Name, "System")

export type World = Matter.World
export type Loop = Matter.Loop
export type State = typeof(ECSState)
export type SystemFn = (world: World, state: State) -> ()

export type Dependency = string | System

export type SystemMatter = {
	name: string,
	system: SystemFn,
	priority: number?,
	event: string?,
	after: { SystemMatter }?,
}
export type System = {
	name: string,
	system: SystemFn,
	priority: number?,
	event: string?,
	after: { Dependency }?,
}

export type SystemDef = {
	name: string,
	system: SystemFn,
	priority: number?,
	event: string?,
	after: { Dependency }?,
}

local FIRST = 1
local DEFAULT = 100
local LAST = 10000

local state = ECSState
local world = Matter.World.new()
local loop = Matter.Loop.new(world, state)

local ECS = {
	Priority = {
		First = FIRST,
		Default = DEFAULT,
		Last = LAST,
	},
	world = world :: World,
	loop = loop :: Loop,
	systems = {} :: { [string]: System },
	resolved = {} :: { SystemMatter },
	_running = false,
	_connections = {} :: { [string]: RBXScriptConnection },
}

-- * BUILDERS
function ECS.ResolveSystem(
	system: System,
	res: { [string]: SystemMatter },
	_visited: { [string]: boolean }?
): SystemMatter?
	local visited = _visited or {}

	if visited[system.name] then
		Logger:Fatal(`Circular Dependency found in System {system.name}`)
		return nil
	end
	visited[system.name] = true

	if res[system.name] then
		return res[system.name]
	end

	local useAfter = not system.priority and (system.after and next(system.after))
	local after = {}
	local success = true

	if useAfter then
		for _, dep in ipairs(system.after or {}) do
			local depSystem = ECS.GetSystem(dep)

			if not depSystem then
				Logger:Fatal(`System Dependency {dep} does not exist in System {system.name}`)
				success = false
				break
			end

			local depMatter = ECS.ResolveSystem(depSystem, res, visited)
			if not depMatter then
				success = false
				break
			end

			table.insert(after, depMatter)
		end
	end

	if not success then
		return nil
	end

	local systemMatter: SystemMatter = {
		name = system.name,
		system = system.system,
		priority = system.priority,
		event = system.event,
		after = useAfter and after or nil,
	}

	res[systemMatter.name] = systemMatter
	visited[systemMatter.name] = nil

	return systemMatter
end

function ECS.ResolveDependencies()
	ECS.UnsolveDependencies()

	local resolved = {}
	for _, system in pairs(ECS.systems) do
		ECS.ResolveSystem(system, resolved)
	end

	local res = {}
	for _, matter in pairs(resolved) do
		table.insert(res, matter)
	end

	ECS.resolved = res
	ECS.loop:scheduleSystems(ECS.resolved)
end

function ECS.UnsolveDependencies()
	for _, system in pairs(ECS.resolved) do
		ECS.loop:evictSystem(system)
	end
end

-- * CREATE SYSTEM
function ECS.CreateSystem(systemDef: SystemDef): System
	local system: System = {
		name = systemDef.name,
		system = systemDef.system,
		priority = systemDef.priority,
		event = systemDef.event,
		after = systemDef.after,
	}

	ECS.AddSystem(system)

	return system
end

-- * SYSTEM MANAGEMENT
function ECS.GetSystem(ref: string | System): System?
	local name = if type(ref) == "string" then ref else ref.name
	return ECS.systems[name]
end

function ECS.AddSystem(system: System)
	local name = system.name
	if ECS.systems[name] then
		Logger:Warn(`System already exists: {name}`)
		return --! do not overwrite because it maybe a double called
	end
	ECS.systems[name] = system

	if ECS._running then
		ECS.ResolveDependencies()
	end
end

function ECS.RemoveSystem(ref: string | System)
	local system = ECS.GetSystem(ref)
	if not system then
		return
	end

	ECS.systems[system.name] = nil

	if ECS._running then
		ECS.ResolveDependencies()
	end
end

-- * RUNNING
function ECS.Start()
	if ECS._running then
		return
	end

	ECS._running = true
	ECS.ResolveDependencies()

	if RunService:IsServer() then
		ECS._connections = ECS.loop:begin({
			default = RunService.Heartbeat,
			Heartbeat = RunService.Heartbeat,
			Stepped = RunService.Stepped,
		})
	else
		ECS._connections = ECS.loop:begin({
			default = RunService.RenderStepped,
			RenderStepped = RunService.RenderStepped,
			Heartbeat = RunService.Heartbeat,
			Stepped = RunService.Stepped,
		})
	end
end

function ECS.Stop()
	if not ECS._running then
		return
	end
	ECS._running = false

	for _, conn in pairs(ECS._connections) do
		conn:Disconnect()
	end
	table.clear(ECS._connections)

	ECS.UnsolveDependencies()
end

-- * LOADERS
local function collectModules(parent: Instance, deep: boolean): { ModuleScript }
	local result = {} :: { ModuleScript }
	local source = if deep then parent:GetDescendants() else parent:GetChildren()

	for _, inst in ipairs(source) do
		if inst:IsA("ModuleScript") then
			table.insert(result, inst)
		end
	end

	return result
end

local function loadModule(mod: ModuleScript)
	local success, res = pcall(require, mod)
	if not success then
		Logger:Error(res)
	end
end

function ECS.AddSystems(parent: Instance)
	for _, mod in ipairs(collectModules(parent, false)) do
		loadModule(mod)
	end
end

function ECS.AddSystemsDeep(parent: Instance)
	for _, mod in ipairs(collectModules(parent, true)) do
		loadModule(mod)
	end
end

return ECS
