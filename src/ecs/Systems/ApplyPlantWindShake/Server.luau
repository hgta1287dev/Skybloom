local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Components = require(ReplicatedStorage.Shared.Ecs.Components.Components)
local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)
local Events = require(ReplicatedStorage.Shared.Ecs.Events.Events)
local WindShakeModule = require(ReplicatedStorage.Shared.Services.WindService.WindShakeModule)

return ECS.CreateSystem({
	name = "AddPlantWindShake",
	priority = ECS.Priority.Default,
	system = function(world: ECS.World, state: ECS.State)
		for idEvent, windShakeEvent in world:query(Events.Plant.AppliedWindShake) do
			local id = windShakeEvent.id
			local model = world:get(id, Components.Model)
			local instance = model.instance :: Instance?

			if instance then
				instance:AddTag(WindShakeModule.CollectionTag)
			end
		end
	end,
})
