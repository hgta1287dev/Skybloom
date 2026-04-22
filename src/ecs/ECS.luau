local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Matter = require(ReplicatedStorage.Packages._Index["matter-ecs_matter@0.8.5"].matter)

export type World = Matter.World
export type Loop = Matter.Loop

export type System = {
	system: (world: Matter.World, state: any) -> any,
	priority: number,
}

type SystemDef = {
	name: string,
	system: (world: World, state: any) -> any,
	priority: number?,
}

local DEFAULT_PRIORITY = 10

local ECS = {}
ECS.world = Matter.World.new() :: World
ECS.World = ECS.world :: World
ECS.loop = Matter.Loop.new(ECS.world) :: Loop

local container = {} :: { [string]: System }
local started = false
local loaded = {}

function ECS.CreateSystem(systemDef: SystemDef): System
	assert(type(systemDef) == "table", `System must be a table; got {type(systemDef)}`)
	assert(type(systemDef.name) == "string", `System.Name must be a string; got {type(systemDef.name)}`)
	assert(#systemDef.name > 0, "System.Name must be a non-empty string")
	assert(not container[systemDef.name], `System {systemDef.name} already exists`)
	assert(type(systemDef.system) == "function", `System.Update must be a function; got {type(systemDef.system)}`)
	assert(not started, `Systems cannot be created after calling "ECS.Start()"`)

	local system: System = {
		system = systemDef.system,
		priority = systemDef.priority or DEFAULT_PRIORITY,
	}
	container[systemDef.name] = system

	return system :: System
end
function ECS.Start()
	assert(not started, "ECS has already started")

	local loop = ECS.loop
	local rawSystems = {}

	for _, system: System in pairs(container) do
		table.insert(rawSystems, system)
	end

	table.sort(rawSystems, function(a, b)
		return a.priority < b.priority
	end)

	local systemsList = {}

	for i, sys in ipairs(rawSystems) do
		systemsList[i] = sys.system
	end

	started = true
	loop:scheduleSystems(systemsList)

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
