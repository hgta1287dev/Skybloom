local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local MountUI = require(script.Parent.MountUI)

-- React Mount
MountUI()

-- Knit Setup
Knit.AddControllersDeep(ReplicatedStorage.Shared)
Knit.Start()
	:andThen(function()
		warn("Knit Started!")
	end)
	:catch(error)
