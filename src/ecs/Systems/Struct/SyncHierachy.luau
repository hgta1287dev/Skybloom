local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HierarchyComponent = require(ReplicatedStorage.Shared.Ecs.Components.Struct.HierarchyComponent)
local ECS = require(ReplicatedStorage.Shared.Ecs.ECS)
local Events = require(ReplicatedStorage.Shared.Ecs.Events.Events)

local function isAncestor(world, ancestorId, nodeId)
	local current = nodeId

	while current do
		if current == ancestorId then
			return true
		end

		local hierarchy = world:get(current, HierarchyComponent)
		if not hierarchy then
			break
		end

		current = hierarchy.parent
	end

	return false
end

local function addChild(children, childId)
	local newChildren = table.clone(children or {})

	if not table.find(newChildren, childId) then
		table.insert(newChildren, childId)
	end

	return newChildren
end

local function removeChild(children, childId)
	local newChildren = table.clone(children or {})
	local index = table.find(newChildren, childId)

	if index then
		table.remove(newChildren, index)
	end

	return newChildren
end

local function discard(world, eventId)
	world:despawn(eventId)
end

local function system(world: ECS.World)
	for eventId, event in world:query(Events.ParentChanged):snapshot() do
		local childId = event.child
		local newParentId = event.newParent

		local child = world:get(childId, HierarchyComponent)
		if not child then
			discard(world, eventId)
			continue
		end

		local oldParentId = child.parent

		-- no-op
		if oldParentId == newParentId then
			discard(world, eventId)
			continue
		end

		-- self-parent
		if newParentId == childId then
			warn("Hierarchy: self-parent", childId)
			discard(world, eventId)
			continue
		end

		-- get new parent once
		local newParent = newParentId and world:get(newParentId, HierarchyComponent)

		-- invalid parent
		if newParentId and not newParent then
			warn("Hierarchy: invalid parent", newParentId)
			discard(world, eventId)
			continue
		end

		-- cycle check
		if newParentId and isAncestor(world, childId, newParentId) then
			warn("Hierarchy: cycle detected", childId, newParentId)
			discard(world, eventId)
			continue
		end

		if oldParentId then
			local oldParent = world:get(oldParentId, HierarchyComponent)
			if oldParent then
				world:insert(
					oldParentId,
					oldParent:patch({
						children = removeChild(oldParent.children, childId),
					})
				)
			end
		end

		if newParent then
			world:insert(
				newParentId,
				newParent:patch({
					children = addChild(newParent.children, childId),
				})
			)
		end

		world:insert(
			childId,
			child:patch({
				parent = newParentId,
			})
		)

		discard(world, eventId)
	end
end

ECS.CreateSystem({
	name = "SyncHierarchy",
	system = system,
	priority = 2,
})
