local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)

return ECS.CreateSystem({
	name = "Test",
	system = function(world: ECS.World) end,
})
