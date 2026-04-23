local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Components = require(ReplicatedStorage.Shared.Ecs.Components.Components)
local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)
local Events = require(ReplicatedStorage.Shared.Ecs.Events.Events)

function System(world: ECS.World, state)
	local dt = state.deltaTime or 0.016

	for id, growth in world:query(Components.Plant.Growth) do
		-- update age
		growth:patch({
			age = growth.age + dt,
		})

		-- check growth stage
		if growth.stage >= growth.maxStage then
			continue
		end

		-- update growth state
		world:replace(
			id,
			growth:patch({
				stage = growth.stage + 1,
			})
		)

		-- fire grown event
		Events.spawn(world, Events.Plant.Grown, { id = id })
	end
end

return ECS.CreateSystem({
	name = "Growth",
	system = System,
})
