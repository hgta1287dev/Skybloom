local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local KnitMessageConfig = require(ReplicatedStorage.Shared.Configs.KnitMessageConfig)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)
local WindShake = require(script.Parent.WindShakeModule)

local Logger = LoggerManager:CreateLogger("WindController")
local WindController = Knit.CreateController({
	Name = "WindController",
})

-- * Knit
function WindController:KnitInit()
	Logger:Info(KnitMessageConfig.Initializing)
	Logger:Info(KnitMessageConfig.Initialized)
end

function WindController:KnitStart()
	Logger:Info(KnitMessageConfig.Starting)
	WindShake:Init()
	Logger:Info(KnitMessageConfig.Started)
end

-- * Public
function WindController:GetWindShaker()
	return WindShake
end

return WindShake
