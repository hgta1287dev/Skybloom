local LinkedCollection = require(script.Parent.Parent.Core.LinkedCollection)
local Nodes = require(script.Parent.Parent.Core.Nodes)
local Iter = require(script.Parent.Parent.Core.Iter)

local Set = {}
Set.__index = Set
setmetatable(Set, { __index = LinkedCollection })

type Node<T> = Nodes.Node<T>

export type Set<T> = {
	_map: { [T]: Node<T> },
	_head: Node<T>?,
	_tail: Node<T>?,

	PushFront: (self: Set<T>, value: T) -> boolean,
	PushBack: (self: Set<T>, value: T) -> boolean,

	Pop: (self: Set<T>, value: T) -> T?,
	PopFront: (self: Set<T>) -> T?,
	PopBack: (self: Set<T>) -> T?,

	Has: (self: Set<T>, value: T) -> boolean,
	Get: (self: Set<T>, value: T) -> T?,
	PeekFront: (self: Set<T>) -> T?,
	PeekBack: (self: Set<T>) -> T?,

	Values: (self: Set<T>, reverse: boolean?) -> () -> T?,
	Iter: (self: Set<T>, reverse: boolean?) -> Iter.Iter<T>,

	Clone: (self: Set<T>) -> Set<T>,
	ToArray: (self: Set<T>) -> { T },
	ToMap: (self: Set<T>) -> { [T]: boolean },
} & LinkedCollection.LinkedCollection

function Set.new<T>(): Set<T>
	local self = setmetatable(LinkedCollection.new(), Set)
	self._map = {}
	return self
end

function Set.fromArray<T>(arr: { T }): Set<T>
	local set = Set.new()
	for _, v in ipairs(arr) do
		set:PushBack(v)
	end
	return set
end

function Set.PushFront<T>(self: Set<T>, value: T): boolean
	assert(value ~= nil, "Set does not support nil values")

	if self._map[value] then
		return false
	end

	local node = {
		value = value,
		prev = nil,
		next = nil,
	}

	LinkedCollection._linkFront(self, node)
	self._map[value] = node
	self._size += 1

	return true
end

function Set.PushBack<T>(self: Set<T>, value: T): boolean
	assert(value ~= nil, "Set does not support nil values")

	if self._map[value] then
		return false
	end

	local node = {
		value = value,
		prev = nil,
		next = nil,
	}

	LinkedCollection._linkBack(self, node)
	self._map[value] = node
	self._size += 1

	return true
end

function Set.Pop<T>(self: Set<T>, value: T): T?
	local node = self._map[value]
	if not node then
		return nil
	end

	LinkedCollection._unlink(self, node)
	self._map[value] = nil
	self._size -= 1

	return node.value
end

function Set.PopFront<T>(self: Set<T>): T?
	local node = LinkedCollection._popFrontNode(self)
	if not node then
		return nil
	end

	self._map[node.value] = nil
	self._size -= 1

	return node.value
end

function Set.PopBack<T>(self: Set<T>): T?
	local node = LinkedCollection._popBackNode(self)
	if not node then
		return nil
	end

	self._map[node.value] = nil
	self._size -= 1
	return node.value
end

function Set.Has<T>(self: Set<T>, value: T): boolean
	return self._map[value] ~= nil
end

function Set.Get<T>(self: Set<T>, value: T): T?
	return self._map[value] and self._map[value].value or nil
end

function Set.PeekFront<T>(self: Set<T>): T?
	return self._head and self._head.value or nil
end

function Set.PeekBack<T>(self: Set<T>): T?
	return self._tail and self._tail.value or nil
end

function Set.Values<T>(self: Set<T>, reverse: boolean?): () -> T?
	return Iter.values(reverse and self._tail or self._head, reverse)
end

function Set.Iter<T>(self: Set<T>, reverse: boolean?): Iter.Iter<T>
	return Iter.new(Iter.values(reverse and self._tail or self._head, reverse))
end

function Set.Clear<T>(self: Set<T>)
	LinkedCollection.Clear(self)
	self._map = {}
end

function Set.ToArray<T>(self: Set<T>): { T }
	local arr = table.create(self:Size())
	local i = 0

	for v in self:Values() do
		i += 1
		arr[i] = v
	end

	return arr
end

function Set.ToMap<T>(self: Set<T>): { [T]: boolean }
	local map = {}

	for v in self:Values() do
		map[v] = true
	end

	return map
end

function Set.Clone<T>(self: Set<T>): Set<T>
	local newSet = Set.new()

	for v in self:Values() do
		newSet:PushBack(v)
	end

	return newSet
end

return Set
