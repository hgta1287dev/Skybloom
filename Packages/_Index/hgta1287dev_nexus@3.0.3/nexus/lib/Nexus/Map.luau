local LinkedCollection = require(script.Parent.Parent.Core.LinkedCollection)
local Iter = require(script.Parent.Parent.Core.Iter)

local Map = {}
Map.__index = Map
setmetatable(Map, { __index = LinkedCollection })

type Node<K, V> = {
	key: K,
	value: V,
	prev: any?,
	next: any?,
}

export type MapData<K, V> = {
	_map: { [K]: Node<K, V> },
	_head: Node<K, V>?,
	_tail: Node<K, V>?,
}

export type Map<K, V> = {
	Has: (self: Map<K, V>, key: K) -> boolean,
	Get: (self: Map<K, V>, key: K) -> V?,

	SetFront: (self: Map<K, V>, key: K, value: V) -> boolean,
	SetBack: (self: Map<K, V>, key: K, value: V) -> boolean,
	Set: (self: Map<K, V>, key: K, value: V) -> (),

	Pop: (self: Map<K, V>, key: K) -> V?,
	PopFront: (self: Map<K, V>) -> (K?, V?),
	PopBack: (self: Map<K, V>) -> (K?, V?),

	PeekFront: (self: Map<K, V>) -> (K?, V?),
	PeekBack: (self: Map<K, V>) -> (K?, V?),
	Iter: (self: Map<K, V>, reverse: boolean?) -> () -> (K?, V?),

	Entries: (self: Map<K, V>) -> () -> (K, V),
} & LinkedCollection.LinkedCollection & MapData<K, V>

local function checkValidKey(key)
	if key == nil then
		error("Key cannot be nil", 2)
	end
end

local function checkValidValue(value)
	if value == nil then
		error("Value cannot be nil", 2)
	end
end

local function makeNode<K, V>(key: K, value: V): Node<K, V>
	return {
		key = key,
		value = value,
		prev = nil,
		next = nil,
	}
end

function Map.new<K, V>(): Map<K, V>
	local self = setmetatable(LinkedCollection.new(), Map)
	self._map = {}
	return self
end

function Map.Has<K, V>(self: Map<K, V>, key: K): boolean
	return self._map[key] ~= nil
end

function Map.Get<K, V>(self: Map<K, V>, key: K): V?
	local node = self._map[key]
	return node and node.value or nil
end

function Map.SetFront<K, V>(self: Map<K, V>, key: K, value: V): boolean
	checkValidKey(key)
	checkValidValue(value)
	local node = self._map[key]

	if node then
		node.value = value
		if node ~= self._head then
			LinkedCollection._unlink(self, node)
			LinkedCollection._linkFront(self, node)
		end
		return false
	end

	node = makeNode(key, value)
	LinkedCollection._linkFront(self, node)
	self._map[key] = node
	self._size += 1
	return true
end

function Map.SetBack<K, V>(self: Map<K, V>, key: K, value: V): boolean
	checkValidKey(key)
	checkValidValue(value)
	local node = self._map[key]

	if node then
		node.value = value
		if node ~= self._tail then
			LinkedCollection._unlink(self, node)
			LinkedCollection._linkBack(self, node)
		end
		return false
	end

	node = makeNode(key, value)
	LinkedCollection._linkBack(self, node)
	self._map[key] = node
	self._size += 1
	return true
end

function Map.Set<K, V>(self: Map<K, V>, key: K, value: V)
	checkValidKey(key)
	checkValidValue(value)
	local node = self._map[key]

	if node then
		node.value = value
		return
	end

	Map.SetBack(self, key, value)
end

function Map.Pop<K, V>(self: Map<K, V>, key: K): V?
	checkValidKey(key)
	local node = self._map[key]
	if not node then
		return nil
	end

	LinkedCollection._unlink(self, node)
	self._map[key] = nil
	self._size -= 1

	return node.value
end

function Map.PopFront<K, V>(self: Map<K, V>): (K?, V?)
	local node = LinkedCollection._popFrontNode(self)
	if not node then
		return nil, nil
	end

	self._map[node.key] = nil
	self._size -= 1
	return node.key, node.value
end

function Map.PopBack<K, V>(self: Map<K, V>): (K?, V?)
	local node = LinkedCollection._popBackNode(self)
	if not node then
		return nil, nil
	end

	self._map[node.key] = nil
	self._size -= 1
	return node.key, node.value
end

function Map.PeekFront<K, V>(self: Map<K, V>): (K?, V?)
	local node = self._head
	if not node then
		return nil, nil
	end
	return node.key, node.value
end

function Map.PeekBack<K, V>(self: Map<K, V>): (K?, V?)
	local node = self._tail
	if not node then
		return nil, nil
	end
	return node.key, node.value
end

function Map.Entries<K, V>(self: Map<K, V>, reverse: boolean?): () -> (K?, V?)
	return Iter.keyValues(reverse and self._tail or self._head, reverse)
end

function Map.Iter<K, V>(self: Map<K, V>, reverse: boolean?)
	return Iter.new(Iter.values(reverse and self._tail or self._head, reverse))
end

function Map.Clear<K, V>(self: Map<K, V>)
	LinkedCollection.Clear(self)
	self._map = {}
end

return Map
