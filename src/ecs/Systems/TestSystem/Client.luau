local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)

function System(world: ECS.World, state)
	for id, health in world:query(Components.Model) do
		if health.current < health.max then
			world:replace(
				id,
				health:patch({
					-- Regenerate 0.1% of maximum health per frame
					current = math.min(health.max, health.current + (health.max * 0.001)),
				})
			)
		end
	end
end

-- return ECS.CreateSystem({
-- 	name = "TestSytem",
-- 	system = System,
-- })
