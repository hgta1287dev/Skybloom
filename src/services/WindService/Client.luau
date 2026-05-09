local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local WindShake = require(script.Parent.WindShakeModule)

local WindController = Knit.CreateController({
	Name = "WindController",
})

-- * Knit
function WindController:KnitStart()
	WindShake:Init()
end

-- * Public
function WindController:GetWindShaker()
	return WindShake
end

return WindShake
