local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local MountUI = require(script.Parent.MountUI)

local function init()
	MountUI()
end

-- Knit Setup
Knit.AddControllersDeep(ReplicatedStorage.Shared)
Knit:Start()
	:andThen(function()
		warn("[CLIENT]: Knit Started!")
		init()
	end)
	:catch(error)
