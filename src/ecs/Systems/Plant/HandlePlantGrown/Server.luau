local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local GrowthSystemServer = require(ServerScriptService.Ecs.Systems.Plant.GrowthSystem.GrowthSystemServer)
local Components = require(ReplicatedStorage.Shared.Ecs.Components.Components)
local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)
local Events = require(ReplicatedStorage.Shared.Ecs.Events.Events)

local function system(world: ECS.World, state)
	for grownId, grown in world:query(Events.Plant.Grown):snapshot() do
		-- * cleanup grown event
		world:despawn(grownId)

		-- * collect data
		local plantId = grown.id

		-- * handle
		-- change model
		local model = world:get(plantId, Components.Model)
	end
end

return ECS.CreateSystem({
	name = "HandlePlantGrow",
	system = system,
	after = { GrowthSystemServer },
	priority = 1,
})
