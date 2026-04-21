local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HoenKnit = require(ReplicatedStorage.Shared.Core.HoenKnit)
local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)

local ECSController = HoenKnit.CreateController({
	Name = "ECSController",
})

function ECSController:KnitInit()
	ECS.AddSystemsDeep(ReplicatedStorage.Shared.Ecs.Systems)
end

function ECSController:KnitStart()
	ECS.Start()
end

return ECSController
