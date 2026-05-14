--[=[
    OrderedMap maintains:
    - Unique keys
    - Insertion order (by key)
    - O(1) set / remove / lookup

    Differences from OrderedSet:
    - OrderedSet stores only values
    - OrderedMap stores key -> value pairs
]=]

local OrderedMap = {}
OrderedMap.__index = OrderedMap

--* Types

type Node<K, V> = {
	key: K,
	value: V,
	prev: Node<K, V>?,
	next: Node<K, V>?,
}

export type OrderedMap<K, V> = {
	_map: { [K]: Node<K, V> },
	_head: Node<K, V>?,
	_tail: Node<K, V>?,
	_size: number,

	Set: (self: OrderedMap<K, V>, key: K, value: V) -> boolean,
	Get: (self: OrderedMap<K, V>, key: K) -> V?,
	Pop: (self: OrderedMap<K, V>, key: K) -> V?,
	Clear: (self: OrderedMap<K, V>) -> (),

	Has: (self: OrderedMap<K, V>, key: K) -> boolean,
	Iter: (self: OrderedMap<K, V>) -> () -> (K, V?),
	Each: (self: OrderedMap<K, V>, func: (K, V) -> boolean?) -> (),

	Keys: (self: OrderedMap<K, V>) -> { K },
	Values: (self: OrderedMap<K, V>) -> { V },

	Front: (self: OrderedMap<K, V>) -> (K, V)?,
	Back: (self: OrderedMap<K, V>) -> (K, V)?,

	Empty: (self: OrderedMap<K, V>) -> boolean,
	Size: (self: OrderedMap<K, V>) -> number,
}

--* Constructor

--[=[
	Creates a new OrderedMap

	```lua
	local OrderedMap = require(path.to.OrderedMap)
	local map = OrderedMap.new<string, number>()
	```
]=]
function OrderedMap.new<K, V>(): OrderedMap<K, V>
	local self = setmetatable({
		_map = {} :: { [K]: Node<K, V> },
		_head = nil :: Node<K, V>?,
		_tail = nil :: Node<K, V>?,
		_size = 0,
	}, OrderedMap)

	return self :: OrderedMap<K, V>
end

--* Core Operations

--[=[
	@param key
	@param value
	@return boolean

	If key does not exist:
	    - Adds to the back
	    - Returns true

	If key exists:
	    - Updates value
	    - Keeps position
	    - Returns false
]=]
function OrderedMap.Set<K, V>(self: OrderedMap<K, V>, key: K, value: V): boolean
	assert(key ~= nil, "OrderedMap does not support nil keys")

	local existing = self._map[key]
	if existing then
		existing.value = value
		return false
	end

	local node = {
		key = key,
		value = value,
		prev = self._tail,
		next = nil,
	}

	if self._tail then
		self._tail.next = node
	else
		self._head = node
	end

	self._tail = node
	self._map[key] = node
	self._size += 1

	return true
end

--[=[
	@param key
	@return V?
	Gets the value associated with the key.
]=]
function OrderedMap.Get<K, V>(self: OrderedMap<K, V>, key: K): V?
	local node = self._map[key]
	return node and node.value
end

--[=[
	@param key
	@return V?

	Removes the key and returns its value.
	Returns nil if key does not exist.
]=]
function OrderedMap.Pop<K, V>(self: OrderedMap<K, V>, key: K): V?
	local node = self._map[key]
	if not node then
		return nil
	end

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

	self._map[key] = nil
	self._size -= 1

	node.prev = nil
	node.next = nil

	return node.value
end

--[=[
	Clears the map.
]=]
function OrderedMap.Clear<K, V>(self: OrderedMap<K, V>)
	local cur = self._head
	while cur do
		local nxt = cur.next
		cur.prev = nil
		cur.next = nil
		cur = nxt
	end

	table.clear(self._map)
	self._head = nil
	self._tail = nil
	self._size = 0
end

--* Query

function OrderedMap.Has<K, V>(self: OrderedMap<K, V>, key: K): boolean
	return self._map[key] ~= nil
end

function OrderedMap.Size<K, V>(self: OrderedMap<K, V>): number
	return self._size
end

function OrderedMap.Empty<K, V>(self: OrderedMap<K, V>): boolean
	return self._size == 0
end

--* Iteration

--[=[
	@return () -> (K, V)?

	Iterates in insertion order.

	```lua
	for key, value in map:Iter() do
		print(key, value)
	end
	```
]=]
function OrderedMap.Iter<K, V>(self: OrderedMap<K, V>): () -> (K?, V?)
	local current = self._head
	return function()
		if not current then
			return nil
		end

		local k = current.key
		local v = current.value
		current = current.next

		return k, v
	end
end

--[=[
	@param callback (key, value) -> boolean?
	Stops early if callback returns false.
]=]
function OrderedMap.Each<K, V>(self: OrderedMap<K, V>, callback: (K, V) -> boolean?)
	local current = self._head
	while current do
		if callback(current.key, current.value) == false then
			break
		end
		current = current.next
	end
end

--* Helpers
function OrderedMap.ToTable<K, V>(self: OrderedMap<K, V>): { [K]: V }
	local result = table.create(self._size)

	for key, value in self:Iter() do
		result[key] = value
	end

	return result
end

function OrderedMap.Keys<K, V>(self: OrderedMap<K, V>): { K }
	local result = table.create(self._size)
	for key in self:Iter() do
		table.insert(result, key)
	end
	return result
end

function OrderedMap.Values<K, V>(self: OrderedMap<K, V>): { V }
	local result = table.create(self._size)
	for _, value in self:Iter() do
		table.insert(result, value)
	end
	return result
end

function OrderedMap.Front<K, V>(self: OrderedMap<K, V>): (K?, V?)
	if not self._head then
		return nil, nil
	end
	return self._head.key, self._head.value
end

function OrderedMap.Back<K, V>(self: OrderedMap<K, V>): (K?, V?)
	if not self._tail then
		return nil, nil
	end
	return self._tail.key, self._tail.value
end

return OrderedMap
