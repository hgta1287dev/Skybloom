local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Components = require(ReplicatedStorage.Shared.Ecs.Components.Components)
local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)
local Events = require(ReplicatedStorage.Shared.Ecs.Events.Events)

-- TODDO Model grow

return ECS.CreateSystem({
	name = "HandlePlantGrow",
	system = function (world: ECS.World, state)
		for grownId, grown in world:query(Events.Plant.Grown):snapshot() do
			-- ! should let cleanup event system handle
			-- world:despawn(grownId)

			-- * collect data
			local plantId = grown.id

			-- * change model
			local model = world:get(plantId, Components.Model)
		end
	end,
	after = { "Growth" },
})
