local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Knit = require(ReplicatedStorage.Packages.Knit)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)

local Logger = LoggerManager:CreateLogger()
local Services

Knit.AddServicesDeep(ServerScriptService.Services)
Knit.Start()
	:andThen(function()
		Services = Knit.GetServices()
		Logger:Info(`Knit Started Successfully!`)
	end)
	:catch(function(...)
		Logger:Error(...)
	end)
	:await()

return Services
