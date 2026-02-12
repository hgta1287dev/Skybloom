local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local MountUI = require(script.Parent.MountUI)

-- React
--! MountUI()

-- Knit Setup
Knit.AddControllers(ReplicatedStorage.Shared.Controllers)
Knit.Start()
	:andThen(function()
		warn("Knit Started!")
	end)
	:catch(error)
