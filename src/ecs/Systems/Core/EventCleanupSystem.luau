local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)
local Events = require(ReplicatedStorage.Shared.Ecs.Events.Events)

local function system(world: ECS.World)
	for eventId, _ in world:query(Events.Event):snapshot() do
		print(`destroying event {eventId}`)
		world:despawn(eventId)
	end
end

return ECS.CreateSystem({
	name = "EventCleanup",
	system = system,
	priority = math.huge,
})
