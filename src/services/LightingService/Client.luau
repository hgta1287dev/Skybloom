local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LightingManager = require(script.Parent.LightingManager)
local LightingPresets = require(script.Parent.LightingPresets)
local HoenKnit = require(ReplicatedStorage.Shared.Core.HoenKnit)

local LightingController = HoenKnit.CreateController({
	Name = "LightingController",
})
local Logger = LightingController._logger

-- * Pulbic API
function LightingController:SetPreset(name: string)
	local preset = LightingPresets[name]
	if not preset then
		Logger:Warn(`Preset "{name}" not found!`)
		return
	end
	LightingManager:Apply(preset)
end

-- * Knit API
function LightingController:KnitInit()
	warn("INITINGGG")
end
function LightingController:KnitStart()
	warn("STARTTT")
	task.wait(3)
	LightingManager:Apply(LightingPresets.Default)
	warn("LIGHTING APPLIEDD")
end

return LightingController
