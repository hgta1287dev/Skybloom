local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.Matter)
local Components = require(ReplicatedStorage.Shared.Ecs.Components.Components)
local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)
local Events = require(ReplicatedStorage.Shared.Ecs.Events.Events)

function System(world: ECS.World, state)
	local dt = Matter.useDeltaTime()
	for eventId, stateChanged in world:query(Events.Plant.GrownStateChanged) do
		local oldState = stateChanged.oldState
		local newState = stateChanged.newState
		
		local id = stateChanged.id
		local growth = world:get(stateChanged.id, Components.Plant.Growth)

		-- final age
		local targetState = math.clamp(newState, 0, growth.maxAge)

		-- check should change
		if targetState == oldState then continue end
		
		-- update growth state
		world:replace(
			id,
			growth:patch({
				stage = targetState,
			})
		)

		-- fire grown event
		Events.spawn(world, Events.Plant.Grown, { id = id })
	end
end

return ECS.CreateSystem({
	name = "Growth",
	system = System,
})
