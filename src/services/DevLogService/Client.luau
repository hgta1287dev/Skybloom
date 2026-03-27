local LogService = game:GetService("LogService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Janitor = require(ReplicatedStorage.Packages.Janitor)
local Knit = require(ReplicatedStorage.Packages.Knit)
local HoenKnit = require(ReplicatedStorage.Shared.Core.HoenKnit)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)

local DevLogController = HoenKnit.CreateController({
	Name = "DevLogController",
	janitor = Janitor.new(),
})

-- * Config
local AUTOCLEAR = false

-- * Public
function DevLogController:GetManager()
	return LoggerManager
end

-- Auto cleaner
function DevLogController:ToggleAutoCleaner(active: boolean)
	local shouldActive = RunService:IsStudio() and active
	if self._autoCleaner == shouldActive then
		return
	end

	self._autoCleaner = shouldActive
	self.janitor:Remove("autoCleaner")

	if not shouldActive then
		return
	end

	self.janitor:Add(
		LogService.MessageOut:Connect(function(a0: string, a1: Enum.MessageType)
			LogService:ClearOutput()
		end),
		"Disconnect",
		"autoCleaner"
	)
end

-- * Knit
function DevLogController:KnitInit()
	LoggerManager:Init()
	self:ToggleAutoCleaner(AUTOCLEAR) --auto clear logs
end

function DevLogController:KnitStart()
	local DevLogService = Knit.GetService("DevLogService")
	DevLogService.MessageOut:Connect(function(_message: string, entryBuffer: buffer)
		local entry = LoggerManager:DeserializeEntry(entryBuffer)
		LoggerManager:Log(entry, false)
	end)
end

return DevLogController
