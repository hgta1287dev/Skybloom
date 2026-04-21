local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HoenKnit = require(ReplicatedStorage.Shared.Core.HoenKnit)
local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)

local ECSService = HoenKnit.CreateService({
	Name = "ECSService",
	Client = {},
})

function ECSService:KnitInit()
	ECS.AddSystemsDeep(ReplicatedStorage.Shared.Ecs.Systems)
end

function ECSService:KnitStart()
	ECS.Start()
end

return ECSService
