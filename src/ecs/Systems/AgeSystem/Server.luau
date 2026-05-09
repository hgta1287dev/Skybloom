local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Components = require(ReplicatedStorage.Shared.Ecs.Components.Components)
local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)

return ECS.CreateSystem({
	name = "Age",
	system = function(world: ECS.World, state: ECS.State) 
        for id, age in world:query(Components.Plant.Age) do
            local dt = state.DeltaTime
            local st = os.clock()
            world:replace(
                id,
                age:patch({
                    started = age.age == 0 and st or age.started,
                    age = age.age + dt,
                })
            ) 
        end
    end,
	priority = 1,
})
