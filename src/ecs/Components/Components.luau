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
		Plant = Matter.component("Plant",{
			plantType = "None",
		}),
		Tag = Matter.component("PlantTag"),
		Age = Matter.component("PlantAge", {
			age = 0,
			started = 0,
		}),
		Growth = Matter.component("PlantGrowth", {
			stage = 1,
			maxStage = 3,
		}),
	},
}
