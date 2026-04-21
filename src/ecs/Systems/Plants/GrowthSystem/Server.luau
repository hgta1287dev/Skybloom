-- src/ecs/Systems/Plants/GrowthSystem/Server.luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)
local GrowthComponent = require(ReplicatedStorage.Shared.Ecs.Components.Plants.GrowthComponent)

function System(world: ECS.World, state)
	local dt = state.deltaTime or 0.016

	for id, growth in world:query(GrowthComponent) do
		growth.age += dt

		if growth.stage >= growth.maxStage then
			continue
		end

		local nextStage = growth.stage + 1
		world:replace(
			id,
			growth:patch({
				stage = nextStage,
			})
		)

		-- Spawn branches if we haven't already for this stage
		if growth.lastSpawnStage < nextStage then
			growth.lastSpawnStage = nextStage
			growth.growing = true
		end
	end
end

return ECS.CreateSystem({
	name = "GrowthSystem",
	system = System,
})
