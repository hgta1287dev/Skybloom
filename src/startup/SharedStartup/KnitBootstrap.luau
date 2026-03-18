local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LoggerBootstap = require(script.Parent.LoggerBootstap)
local Knit = require(ReplicatedStorage.Packages.Knit)

local KnitBootstrap = {}
local Logger = LoggerBootstap:GetLogger()

function KnitBootstrap:Init()
	task.wait(5)
	warn(Logger:Format(`Knit Starting!`))
	Knit.Start()
		:andThen(function()
			warn(Logger:Format(`Knit Started Successfully!`))
		end)
		:catch(function(...)
			error(Logger:Format(...))
		end)
		:await()
end

return KnitBootstrap
