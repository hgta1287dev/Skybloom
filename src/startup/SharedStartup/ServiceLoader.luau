local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local LoggerBootstap = require(script.Parent.LoggerBootstap)

local Logger = LoggerBootstap:GetLogger()

--  * Config
local SERVICES = {
	-- "CameraProxyService",
	-- "MapService",
	-- "CameraService", --! Have problems with this one
	-- "WindService",
	"TestService",
	-- "RoomService",
	-- "CharacterService",
}

local CONTROLLERS = {
	"LightingService",
	"TestService",
}

-- * Loader
local ServiceLoader = {
	controllers = {},
	services = {},
}

function ServiceLoader:Init()
	warn(Logger:Format("ServiceLoader Starting!"))
	if RunService:IsServer() then
		for _, name in SERVICES do
			local serviceFolder = ServerScriptService.Services:WaitForChild(name)
			local server = serviceFolder and serviceFolder:WaitForChild(`{name}Server`)
			if serviceFolder then
				ServiceLoader.services[name] = require(server)
				print(Logger:Format(`ServiceLoader added {name}Server`))
			end
		end
	else
		for _, name in CONTROLLERS do
			local serviceFolder = ReplicatedStorage.Shared.Services:WaitForChild(name)
			local client = serviceFolder and serviceFolder:WaitForChild(`{name}Client`)
			if client then
				ServiceLoader.controllers[name] = require(client)
				print(Logger:Format(`ServiceLoader added {name}Client`))
			end
		end
	end
	warn(Logger:Format("ServiceLoader Started Successfully!"))
end

return ServiceLoader
