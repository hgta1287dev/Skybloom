local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Matter = require(ReplicatedStorage.Packages.Matter)
export type PlantNodeComponent = {
	parent: number?,
}
return Matter.component("PlantNode")
