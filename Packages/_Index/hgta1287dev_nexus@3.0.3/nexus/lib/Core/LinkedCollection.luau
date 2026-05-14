local BaseCollection = require(script.Parent.BaseCollection)

local LinkedCollection = {}
LinkedCollection.__index = LinkedCollection
setmetatable(LinkedCollection, { __index = BaseCollection })

export type LinkedCollection = BaseCollection.Collection & {
	_head: any?,
	_tail: any?,
}

function LinkedCollection.new(): LinkedCollection
	local self = setmetatable(BaseCollection.new(), LinkedCollection)
	self._head = nil
	self._tail = nil

	return self
end

function LinkedCollection.Clear(self: LinkedCollection)
	BaseCollection.Clear(self)
	self._head = nil
	self._tail = nil
end

function LinkedCollection._linkFront(self: LinkedCollection, node: any)
	node.prev = nil
	node.next = self._head

	if self._head then
		self._head.prev = node
	else
		self._tail = node
	end

	self._head = node
end

function LinkedCollection._linkBack(self: LinkedCollection, node: any)
	node.next = nil
	node.prev = self._tail

	if self._tail then
		self._tail.next = node
	else
		self._head = node
	end

	self._tail = node
end

function LinkedCollection._unlink(self: LinkedCollection, node: any)
	if node.prev then
		node.prev.next = node.next
	else
		self._head = node.next
	end

	if node.next then
		node.next.prev = node.prev
	else
		self._tail = node.prev
	end

	node.prev = nil
	node.next = nil
end

function LinkedCollection._popFrontNode(self: LinkedCollection)
	local node = self._head
	if not node then
		return nil
	end

	LinkedCollection._unlink(self, node)
	return node
end

function LinkedCollection._popBackNode(self: LinkedCollection)
	local node = self._tail
	if not node then
		return nil
	end

	LinkedCollection._unlink(self, node)
	return node
end

return LinkedCollection
