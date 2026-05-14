local LinkedCollection = require(script.Parent.Parent.Core.LinkedCollection)
local Nodes = require(script.Parent.Parent.Core.Nodes)
local Iter = require(script.Parent.Parent.Core.Iter)

local Queue = {}
Queue.__index = Queue
setmetatable(Queue, { __index = LinkedCollection })

type Node<T> = Nodes.Node<T>

export type Queue<T> = {
	Enqueue: (self: Queue<T>, value: T) -> boolean,
	Dequeue: (self: Queue<T>) -> T?,

	PushFront: (self: Queue<T>, value: T) -> boolean,
	PushBack: (self: Queue<T>, value: T) -> boolean,
	PopFront: (self: Queue<T>) -> T?,
	PopBack: (self: Queue<T>) -> T?,

	PeekFront: (self: Queue<T>) -> T?,
	PeekBack: (self: Queue<T>) -> T?,
	Front: (self: Queue<T>) -> T?,
	Back: (self: Queue<T>) -> T?,

	Iter: (self: Queue<T>, reverse: boolean?) -> () -> T?,
	Empty: (self: Queue<T>) -> boolean,
	Size: (self: Queue<T>) -> number,
	Clear: (self: Queue<T>) -> (),
} & LinkedCollection.LinkedCollection

function Queue.new<T>(): Queue<T>
	local self = setmetatable(LinkedCollection.new(), Queue)
	return self
end

local function clearLinks(self: Queue<any>)
	local current = self._head
	while current do
		local nextNode = current.next
		current.prev = nil
		current.next = nil
		current = nextNode
	end
	self._head = nil
	self._tail = nil
	self._size = 0
end

function Queue.Clear<T>(self: Queue<T>)
	clearLinks(self)
end

function Queue.PushBack<T>(self: Queue<T>, value: T): boolean
	assert(value ~= nil, "Queue does not support nil values")

	local node = Nodes.value(value)
	LinkedCollection._linkBack(self, node)
	self._size += 1
	return true
end

function Queue.PushFront<T>(self: Queue<T>, value: T): boolean
	assert(value ~= nil, "Queue does not support nil values")

	local node = Nodes.value(value)
	LinkedCollection._linkFront(self, node)
	self._size += 1
	return true
end

function Queue.Enqueue<T>(self: Queue<T>, value: T): boolean
	return Queue.PushBack(self, value)
end

function Queue.PopFront<T>(self: Queue<T>): T?
	local node: Node<T>? = LinkedCollection._popFrontNode(self)
	if not node then
		return nil
	end

	self._size -= 1
	return node.value
end

function Queue.PopBack<T>(self: Queue<T>): T?
	local node: Node<T>? = LinkedCollection._popBackNode(self)
	if not node then
		return nil
	end

	self._size -= 1
	return node.value
end

function Queue.Dequeue<T>(self: Queue<T>): T?
	return Queue.PopFront(self)
end

function Queue.PeekFront<T>(self: Queue<T>): T?
	return self._head and self._head.value or nil
end

function Queue.PeekBack<T>(self: Queue<T>): T?
	return self._tail and self._tail.value or nil
end

function Queue.Front<T>(self: Queue<T>): T?
	return Queue.PeekFront(self)
end

function Queue.Back<T>(self: Queue<T>): T?
	return Queue.PeekBack(self)
end

function Queue.Iter<T>(self: Queue<T>, reverse: boolean?): () -> T?
	return Iter.values(if reverse then self._tail else self._head, reverse)
end

return Queue
