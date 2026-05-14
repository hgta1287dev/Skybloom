local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Nexus = require(ReplicatedStorage.Packages.Nexus)

local TagRegistry = {}
TagRegistry.__index = TagRegistry

function TagRegistry.new()
	local self = setmetatable({
		data = {} :: { [string]: { Instance } },
		connections = {} :: { [string]: { add: RBXScriptConnection, remove: RBXScriptConnection } },
	}, TagRegistry)
	return self
end

function TagRegistry:Connect(tag)
	self.connections[tag].add = CollectionService:GetInstanceAddedSignal(tag):Connect(function(instance: Instance)
		table.insert(self.data[tag], instance)
	end)
	self.connections[tag].remove = CollectionService:GetInstanceRemovedSignal(tag):Connect(function(instance: Instance)
		table.remove(self.data[tag], table.find(self.data[tag], instance))
	end)
end

return TagRegistry.new()
