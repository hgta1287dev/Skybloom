local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Matter = require(ReplicatedStorage.Packages.Matter)
local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)

local Events = {
	Event = Matter.component("Event"),
	ParentChanged = Matter.component("ParentChanged", {
		child = 0,
		newParent = 0,
	}),
	Plant = {
		Grown = Matter.component("PlantGrown", {
			id = 0,
		}),
	},
}

function Events.spawn(world: ECS.World, component: any, data: any): number
	return world:spawn(Events.Event(), component(data))
end

return Events
