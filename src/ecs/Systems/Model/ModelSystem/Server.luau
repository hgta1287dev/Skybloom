local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local SyncHierachyServer = require(ServerScriptService.Ecs.Systems.Struct.SyncHierachy.SyncHierachyServer)
local Components = require(ReplicatedStorage.Shared.Ecs.Components.Components)
local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)

function System(world: ECS.World)
	for id, model in world:query(Components.Model) do
		if not model.instance then
			warn("Model instance is nil")
		end

		model.instance.Parent = model.parent
	end
end

return ECS.CreateSystem({
	name = "ModelSystem",
	system = System,
	before = { SyncHierachyServer },
})
