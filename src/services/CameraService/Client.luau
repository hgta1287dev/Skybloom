local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ExternalCameraService = require(ReplicatedStorage.Shared.Services.CameraService.ExternalCameraService)
local Knit = require(ReplicatedStorage.Packages.Knit)

local CameraController = Knit.CreateController({
	Name = "CameraController",
})

function CameraController:KnitInit() end

function CameraController:KnitStart() end

return CameraController
