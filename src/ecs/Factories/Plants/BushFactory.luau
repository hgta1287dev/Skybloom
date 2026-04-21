--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ModelComponent = require(ReplicatedStorage.Shared.Ecs.Components.ModelComponent)
local GrowthComponent = require(ReplicatedStorage.Shared.Ecs.Components.Plants.GrowthComponent)
local PlantNodeComponent = require(ReplicatedStorage.Shared.Ecs.Components.Plants.PlantNodeComponent)
local PlantTagComponent = require(ReplicatedStorage.Shared.Ecs.Components.Plants.PlantTagComponent)
local TransformComponent = require(ReplicatedStorage.Shared.Ecs.Components.TransformComponent)

local BushFactory = {}

export type BushProps = {
	position: CFrame,
	modelTemplate: Model,
}

function BushFactory.create(world, props: BushProps): number
	local bushId = world:spawn(
		PlantTagComponent(),
		TransformComponent({
			cframe = props.position,
		}),
		ModelComponent({
			instance = props.modelTemplate:Clone(),
		}),
		GrowthComponent()
	)

	-- root node
	world:spawn(
		PlantNodeComponent({
			parent = bushId,
			depth = 0,
			length = 1,
		}),
		TransformComponent({
			cframe = props.position,
		})
	)

	return bushId
end
