local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Matter = require(ReplicatedStorage.Packages.Matter)

export type GrowthComponent = {
	age: number,
	stage: number,
	maxStage: number,
	timer: number,
	lastSpawnStage: number,
	growing: boolean,
}

return Matter.component(
	"Growth",
	{
		age = 0,
		stage = 1,
		maxStage = 3,
		lastSpawnStage = 0,
		growing = false,
	} :: GrowthComponent
)
