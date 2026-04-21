local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ModelComponent = require(ReplicatedStorage.Shared.Ecs.Components.ModelComponent)
local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)

function System(world: ECS.World)
	for id, model in world:query(ModelComponent) do
	end
end

return ECS.CreateSystem({
	name = "ModelSystem",
	system = System,
})
