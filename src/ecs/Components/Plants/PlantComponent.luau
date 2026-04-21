local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Matter = require(ReplicatedStorage.Packages.Matter)

export type PlantComponent = {
	seed: number,
}

return Matter.component("Plant")
