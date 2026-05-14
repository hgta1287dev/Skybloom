local LinkedCollection = require(script.Parent.Parent.Core.LinkedCollection)
local Nodes = require(script.Parent.Parent.Core.Nodes)
local Iter = require(script.Parent.Parent.Core.Iter)

local Stack = {}
Stack.__index = Stack
setmetatable(Stack, { __index = LinkedCollection })

type Node<T> = Nodes.Node<T>

export type Stack<T> = {
	Push: (self: Stack<T>, value: T) -> boolean,
	Pop: (self: Stack<T>) -> T?,
	Peek: (self: Stack<T>) -> T?,
	Top: (self: Stack<T>) -> T?,

	Iter: (self: Stack<T>, reverse: boolean?) -> () -> T?,
	Empty: (self: Stack<T>) -> boolean,
	Size: (self: Stack<T>) -> number,
	Clear: (self: Stack<T>) -> (),
} & LinkedCollection.LinkedCollection

function Stack.new<T>(): Stack<T>
	local self = setmetatable(LinkedCollection.new(), Stack)
	return self
end

local function clearLinks(self: Stack<any>)
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

function Stack.Clear<T>(self: Stack<T>)
	clearLinks(self)
end

function Stack.Push<T>(self: Stack<T>, value: T): boolean
	assert(value ~= nil, "Stack does not support nil values")

	local node = Nodes.value(value)
	LinkedCollection._linkBack(self, node)
	self._size += 1
	return true
end

function Stack.Pop<T>(self: Stack<T>): T?
	local node: Node<T>? = LinkedCollection._popBackNode(self)
	if not node then
		return nil
	end

	self._size -= 1
	return node.value
end

function Stack.Peek<T>(self: Stack<T>): T?
	return self._tail and self._tail.value or nil
end

function Stack.Top<T>(self: Stack<T>): T?
	return Stack.Peek(self)
end

function Stack.Iter<T>(self: Stack<T>, reverse: boolean?): () -> T?
	if reverse then
		return Iter.values(self._head, false)
	end

	return Iter.values(self._tail, true)
end

function Stack.Empty<T>(self: Stack<T>): boolean
	return self._size == 0
end

function Stack.Size<T>(self: Stack<T>): number
	return self._size
end

return Stack
