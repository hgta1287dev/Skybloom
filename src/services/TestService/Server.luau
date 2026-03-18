local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local HoenKnit = require(ReplicatedStorage.Shared.Core.HoenKnit)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)
local GameTypes = require(ReplicatedStorage.Shared.Types.GameTypes)

local Logger = LoggerManager:CreateLogger("TestService")
local TestService = HoenKnit.CreateService({
	Name = "TestService",
	Client = {},
})

-- * Knit
function TestService:KnitInit()
	Logger:Info("Init Testtingg")
end

function TestService:KnitStart()
	if true then
		return
	end

	local Services = Knit.GetServices()
	local MapService = Services.MapService

	local mode: GameTypes.Mode = "Editor"
	local mapName: string = "Prototype01"

	task.wait(5)

	MapService:CreateMap(mode, mapName)

	MapService.MapUpdated:Connect(function(mapName: string)
		local CharacterService = Services.CharacterService
		CharacterService:Spawn()
	end)
end

return TestService
