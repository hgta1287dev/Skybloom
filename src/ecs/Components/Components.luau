local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Matter = require(ReplicatedStorage.Packages.Matter)

return {
	Hierarchy = Matter.component("Hierarchy", {
		parent = nil :: number?,
		children = {} :: { number },
	}),

	Model = Matter.component("Model", {
		instance = nil :: Instance?,
		parent = nil :: Instance?,
	}),
	Transform = Matter.component("Transform", { cframe = CFrame.new() :: CFrame }),

	Plant = {
		Plant = Matter.component("Plant", {
			species = "Unknown",
			nodes = {
				{ -- * Root
					parent = nil :: number?,
					position = Vector3.zero,
					direction = Vector3.zero,
					instance = nil :: Model?,
					started = 0,
					kind = "Root",
				},
			},
			root = 1,
			config = {
				nodeTemplate = nil :: Model?,
			},
		}),
		Age = Matter.component("PlantAge", {
			age = 0,
			started = 0,
		}),
		Growth = Matter.component("PlantGrowth", {
			progress = 0,
			maxStage = 30,

			lastGrowth = 0,
			cooldown = 2,
		}),
		Behaviors = {
			Branching = Matter.component("PlantBranching", {
				ageWeight = 0.1,
				lightWeight = 0.3,
				scaleWeight = 0.2,

				directionNoise = 0.5,

				attempts = 8,
				surfaceOffset = 0.5,

				plantCount = 2,
				plantRadius = 1,
				climbRadius = 4,
				obstacleRadius = 0.5,
				obstacleCount = 2,
			}),
			LightSeeking = Matter.component("PlantLightSeeking", {
				strength = 1,
			}),
		},
	},
}
