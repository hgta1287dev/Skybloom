local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local HoenKnit = require(ReplicatedStorage.Shared.Core.HoenKnit)
local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)

local ECSService = HoenKnit.CreateService({
	Name = "ECSService",
	Client = {},
})

function ECSService:KnitInit()
	ECS.AddSystemsDeep(ServerScriptService.Ecs.Systems)
end

function ECSService:KnitStart()
	ECS.Start()
end

return ECSService
