local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.AddServicesDeep(ServerScriptService)
Knit.Start()
	:andThen(function()
		local Services = Knit.GetServices()
		for name, _ in pairs(Services) do
			warn(`[SERVER]: Knit Service Loaded: {name}`)
		end
		warn("[SERVER]: Knit Started!")
	end)
	:catch(error)
