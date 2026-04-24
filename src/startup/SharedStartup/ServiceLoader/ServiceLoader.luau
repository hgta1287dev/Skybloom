local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local ServiceLoaderConfig = require(script.Parent.ServiceLoaderConfig)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)

local Logger = LoggerManager:CreateLogger(script.Name, "System")

local SERVER_ROOT = ServerScriptService.Services
local CLIENT_ROOT = ReplicatedStorage.Shared.Services

-- * Loader
local ServiceLoader = {
	Client = {},
	Server = {},
}

-- * Helpers
local function Load(name)
	local isClient = RunService:IsClient()
	local prefix = isClient and "Client" or "Server"

	-- * Check if already loaded
	if ServiceLoader[prefix][name] then
		--? no need to warn here
		return
	end

	-- * Check root
	local root = isClient and CLIENT_ROOT or SERVER_ROOT
	if not root then
		Logger:Warn(`Missing {prefix} root`)
		return
	end

	-- * Check folder
	local folder = root:FindFirstChild(name)
	if not folder then
		Logger:Warn(`Missing {name} folder in {prefix} root`)
		return
	end

	-- * Check module
	local module = folder:FindFirstChild(`{name}{prefix}`)
	if not module then
		Logger:Warn(`Missing {name}{prefix} in {name} folder`)
		return
	end

	-- * Require
	local success, res = pcall(require, module)
	if not success then
		Logger:Error(res)
		return
	end

	ServiceLoader[prefix][name] = res
	Logger:Debug(`Loaded {prefix} module: {name}`)
end

local function AutoLoad(config: ServiceLoaderConfig.LoaderConfig)
	for _, name in ipairs(config.Common) do
		Load(name)
	end
	if RunService:IsClient() then
		for _, name in ipairs(config.Client) do
			Load(name)
		end
	else
		for _, name in ipairs(config.Server) do
			Load(name)
		end
	end
end

function ServiceLoader:Init()
	Logger:Debug("System", "Initialization Started!")

	if ServiceLoaderConfig.Testing and RunService:IsStudio() then
		AutoLoad(ServiceLoaderConfig.Test)
	else
		AutoLoad(ServiceLoaderConfig.Main)
	end

	Logger:Debug("Initialization Completed!")
end

return ServiceLoader
