local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Matter = require(ReplicatedStorage.Packages.Matter)
local PlantEvents = {
	Grow = Matter.component("PlantGrow", {}),
	SpawnBranch = Matter.component("SpawnBranch", {}),
}
return PlantEvents
