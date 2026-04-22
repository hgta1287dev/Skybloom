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
		Tag = Matter.component("Plant"),
		Growth = Matter.component("PlantGrowth", {
			age = 0,
			stage = 1,
			maxStage = 3,
			lastSpawnStage = 0,
		}),
	},
}
