local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Components = require(ReplicatedStorage.Shared.Ecs.Components.Components)

local PlantFactory = {}

function PlantFactory.create(world, species: string, position: Vector3, config: any): number
	local rootNode = {
		parent = nil,
		position = position,
		direction = Vector3.yAxis,
		started = time(),
		kind = "Root",
		instance = nil,
	}

	local id = world:spawn(
		Components.Plant.Plant({
			species = species,
			nodes = { rootNode },
			root = 1,
			config = config,
		}),

		Components.Plant.Growth({
			started = time(),
		}),

		Components.Plant.Behaviors.Branching()
	)

	return id
end

return PlantFactory
