local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)
local Components = require(ReplicatedStorage.Shared.Ecs.Components.Components)
local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)
local Events = require(ReplicatedStorage.Shared.Ecs.Events.Events)

local Logger = LoggerManager:CreateLogger("HandlePlantGrowSystem", "System")

-- TODDO Model grow

return ECS.CreateSystem({
	name = "HandleGrown",
	system = function(world: ECS.World, state)
		for grownId, grown in world:query(Events.Plant.Grown) do
			-- ! should let cleanup event system handle
			-- world:despawn(grownId)

			local plantId = grown.id
			local model = world:get(plantId, Components.Model)
			local plant = world:get(plantId, Components.Plant.Plant)

			if not model.instance then
				Logger:Error(`Plant {plantId} has no model instance`)
				continue
			end
		end
	end,
	after = { "Growth" },
})
