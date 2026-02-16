local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)
local WindShake = require(script.Parent.WindShake)
local WindController = Knit.CreateController({ Name = "WindController" })

function WindController:KnitInit() end
function WindController:KnitStart()
	WindShake:Init()
end

function WindController:GetWindShaker()
	return WindShake
end

return WindShake
