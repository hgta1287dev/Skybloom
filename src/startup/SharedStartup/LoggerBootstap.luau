local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)

local LoggerBootstrap = {}
LoggerBootstrap.LoggerManager = LoggerManager
LoggerBootstrap.Logger = LoggerManager:CreateLogger("Boostrap")

function LoggerBootstrap:Init()
	LoggerManager:Init()
end

function LoggerBootstrap:GetLogger()
	return self.Logger
end

return LoggerBootstrap
