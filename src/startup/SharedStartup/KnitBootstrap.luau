local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LoggerBootstap = require(script.Parent.LoggerBootstap)
local Knit = require(ReplicatedStorage.Packages.Knit)

local KnitBootstrap = {}
local Logger = LoggerBootstap:GetLogger()

function KnitBootstrap:Init()
	Logger:Warn(`Knit Starting!`)
	Knit.Start()
		:andThen(function()
			Logger:Info(`Knit Started Successfully!`)
		end)
		:catch(function(...)
			error(Logger:Format(...))
		end)
		:await()
end

return KnitBootstrap
