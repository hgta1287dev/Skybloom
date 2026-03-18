local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

--  * Config
local SERVICES = {
	-- "LightingService",
	-- "CameraProxyService",
	-- "MapService",
	-- "CameraService", --! Have problems with this one
	-- "WindService",
	"TestService",
	-- "RoomService",
	-- "CharacterService",
}

-- * Loader
local ServiceLoader = {
	controllers = {},
	services = {},
}

function ServiceLoader:Init()
	for _, name in SERVICES do
		if RunService:IsClient() then
			ServiceLoader.controllers[name] = require(ReplicatedStorage.Shared.Services[name][`{name}Client`])
		else
			ServiceLoader.services[name] = require(ServerScriptService.Services[name][`{name}Server`])
		end
	end
end

return ServiceLoader
