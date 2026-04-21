local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)

local Logger = LoggerManager:CreateLogger(script.Name, "System")

local TEST = false

--  * TESTING *
local TEST_CONTROLLERS = {
	-- "CloudLayerService",
	"ECSService",
}

local TEST_SERVICES = {}

-- * MAIN *
local SHARED = {
	"DevLogService",
	-- "CameraProxyService",
	"MapService",
	-- "WindService",
	-- "TestService",
	-- "RoomService",
	-- "CharacterService",
}

local SERVICES = {
	"TestService",
}
local CONTROLLERS = {
	"CameraService",
	"LightingService",
	"TestService",
}

-- * Loader
local ServiceLoader = {
	controllers = {},
	services = {},
}

-- * Helpers
local function LoadService(name)
	local serviceFolder = ServerScriptService.Services:FindFirstChild(name)
	local server = serviceFolder and serviceFolder:FindFirstChild(`{name}Server`)
	if not serviceFolder then
		Logger:Warn(`There is no Service name {name}`)
		return
	end
	local success, res = pcall(require, server)
	if not success then
		Logger:Error(res)
		return
	end
	ServiceLoader.services[name] = res
	Logger:Debug(`Loaded service: {name}`)
end

local function LoadController(name)
	local serviceFolder = ReplicatedStorage.Shared.Services:FindFirstChild(name)
	local client = serviceFolder and serviceFolder:FindFirstChild(`{name}Client`)
	if not client then
		Logger:Warn(`There is no Controller name {name}`)
		return
	end
	local success, res = pcall(require, client)
	if not success then
		Logger:Error(res)
		return
	end
	ServiceLoader.controllers[name] = require(client)
	Logger:Debug(`Loaded controller: {name}`)
end

function ServiceLoader:Init()
	Logger:Debug("System", "Initialization Started!")

	if RunService:IsStudio() and TEST and (next(TEST_CONTROLLERS) or next(TEST_SERVICES)) then
		if RunService:IsServer() then
			for _, name in ipairs(TEST_SERVICES) do
				LoadService(name)
			end
		else
			for _, name in ipairs(TEST_CONTROLLERS) do
				LoadController(name)
			end
		end
	else
		if RunService:IsServer() then
			for _, name in ipairs(SERVICES) do
				LoadService(name)
			end
		else
			for _, name in ipairs(CONTROLLERS) do
				LoadController(name)
			end
		end

		for _, name in ipairs(SHARED) do
			if not ServiceLoader.services[name] and RunService:IsServer() then
				LoadService(name)
			elseif not ServiceLoader.controllers[name] and RunService:IsClient() then
				LoadController(name)
			end
		end
	end

	Logger:Debug("Initialization Completed!")
end

return ServiceLoader
