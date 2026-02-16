--[=[
    OrderedSet maintains:
    - Unique values
    - Insertion order
    - O(1) add / remove / lookup
]=]

local OrderedSet = {}
OrderedSet.__index = OrderedSet

--* Types
-- Generic node type
type Node<T> = {
	value: T,
	prev: Node<T>?,
	next: Node<T>?,
}

-- Public generic type
export type OrderedSet<T> = {
	_map: { [T]: Node<T> },
	_head: Node<T>?,
	_tail: Node<T>?,
	_size: number,

	PushFront: (self: OrderedSet<T>, val: T) -> boolean,
	PushBack: (self: OrderedSet<T>, val: T) -> boolean,

	Pop: (self: OrderedSet<T>, val: T) -> T?,
	PopFront: (self: OrderedSet<T>) -> T?,
	PopBack: (self: OrderedSet<T>) -> T?,
	Clear: (self: OrderedSet<T>) -> (),

	Has: (self: OrderedSet<T>, val: T) -> boolean,
	Iter: (self: OrderedSet<T>) -> () -> T?,
	Each: (self: OrderedSet<T>, func: (T) -> boolean?) -> (),
	Map: <U>(self: OrderedSet<T>, func: (T) -> U) -> { U },
	Front: (self: OrderedSet<T>) -> T?,
	Back: (self: OrderedSet<T>) -> T?,

	Empty: (self: OrderedSet<T>) -> boolean,
	Size: (self: OrderedSet<T>) -> number,

	ToArray: (self: OrderedSet<T>) -> { T },
	ToMap: (self: OrderedSet<T>) -> { [T]: boolean },
	Clone: (self: OrderedSet<T>) -> OrderedSet<T>,
}

--* Constructor
--[=[
    Constructs a new OrderedSet
	```lua
	local OrderedSet = require(path.to.OrderedSet)
	local set = OrderedSet.new()
	@return OrderedSet
	```
]=]
function OrderedSet.new<T>(): OrderedSet<T>
	local self = setmetatable({
		_map = {} :: { [T]: Node<T> },
		_head = nil :: Node<T>?,
		_tail = nil :: Node<T>?,
		_size = 0,
	}, OrderedSet)

	return self :: OrderedSet<T>
end

--[=[
	@param arr {T}
	@return OrderedSet<T>
	Creates a new OrderedSet from an array.

	```lua
	local OrderedSet = require(path.to.OrderedSet)
	local set = OrderedSet.fromArray({"a", "b", "c"})
	```
	--> Order: **a, b, c**
]=]
function OrderedSet.fromArray<T>(arr: { T }): OrderedSet<T>
	local set = OrderedSet.new()
	for _, v in arr do
		set:PushBack(v)
	end
	return set
end

--* Methods
-- Value operations
-- Pusher
--[=[
	@param val -- value that you want to push to the front
	@return boolean -- true if the value was added
	Pushes a value to the front of the set.
	
	```lua
	local OrderedSet = require(path.to.OrderedSet)
	local set = OrderedSet.new()

	set:PushFront("a")

	```
	--> Order: **a**

	```lua
	set:PushFront("b")
	```
	--> Order: **b, a**
]=]
function OrderedSet.PushFront<T>(self: OrderedSet<T>, val: T): boolean
	assert(val ~= nil, "OrderedSet does not support nil values")

	if self._map[val] then
		return false
	end

	local node = {
		value = val,
		prev = nil,
		next = self._head,
	}

	if self._head then
		self._head.prev = node
	else
		self._tail = node
	end

	self._head = node
	self._map[val] = node
	self._size += 1

	return true
end

--[=[
	@param val -- value that you want to push to the back
	@return boolean -- true if the value was added
	Pushes a value to the back of the set.
	
	```lua
	local OrderedSet = require(path.to.OrderedSet)
	local set = OrderedSet.new()

	set:PushBack("a")
	```
	--> Order: **a**

	```lua
	set:PushBack("b")
	```
	--> Order: **a, b**
]=]
function OrderedSet.PushBack<T>(self: OrderedSet<T>, val: T): boolean
	assert(val ~= nil, "OrderedSet does not support nil values")

	if self._map[val] then
		return false
	end

	local node = {
		value = val,
		prev = self._tail,
		next = nil,
	}

	if self._tail then
		self._tail.next = node
	else
		self._head = node
	end

	self._tail = node
	self._map[val] = node
	self._size += 1

	return true
end

-- Popper
--[=[
	@param val -- value that you want to remove
	@return T? -- value that was removed
	Pops a value from the set.
	
	```lua
	local OrderedSet = require(path.to.OrderedSet)
	local set = OrderedSet.new()

	set:PushBack("a")
	set:PushBack("b")
	```

	--> Order: **a, b**

	```lua
	set:Pop("a")
	```

	--> Order: **b**
]=]
function OrderedSet.Pop<T>(self: OrderedSet<T>, val: T): T?
	local node = self._map[val]
	if not node then
		return
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

	self._map[val] = nil
	self._size -= 1

	node.prev = nil
	node.next = nil

	return val
end

--[=[
	@return T? -- return the first value in the set
	Removes and returns the first value in the set.
	Returns nil if the set is empty.

	```lua
	local OrderedSet = require(path.to.OrderedSet)
	local set = OrderedSet.new()

	set:PushBack("a")
	set:PushBack("b")
	```
	--> Order: **a, b**
	```lua
	set:PopFront()
	```
	--> Order: **b**
]=]
function OrderedSet.PopFront<T>(self: OrderedSet<T>): T?
	local head = self._head
	if not head then
		return nil
	end

	local val = head.value

	if head.next then
		head.next.prev = nil
	else
		self._tail = nil
	end

	self._head = head.next
	self._map[val] = nil
	self._size -= 1

	head.next = nil

	return val
end

--[=[
	@return T? -- return the last value in the set
	Removes and returns the last value in the set.
	Returns nil if the set is empty.

	```lua
	local OrderedSet = require(path.to.OrderedSet)
	local set = OrderedSet.new()

	set:PushBack("a")
	set:PushBack("b")
	```
	--> Order: **a, b**
	```lua
	set:PopBack()
	```
	--> Order: **a**
]=]
function OrderedSet.PopBack<T>(self: OrderedSet<T>): T?
	local tail = self._tail
	if not tail then
		return nil
	end

	local val = tail.value

	if tail.prev then
		tail.prev.next = nil
	else
		self._head = nil
	end

	self._tail = tail.prev
	self._map[val] = nil
	self._size -= 1

	tail.prev = nil

	return val
end

--[=[
	Clears the set.
	```lua
	local OrderedSet = require(path.to.OrderedSet)
	local set = OrderedSet.new()

	set:PushBack("a")
	set:PushBack("b")
	```
	--> Order: **a, b**
	```lua
	set:Clear()
	```
	--> Order: **NONE**
]=]
function OrderedSet.Clear<T>(self: OrderedSet<T>)
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

-- Getters
--[=[
	@return {T}
	Returns the set as an array in insertion order.
	```lua
	local OrderedSet = require(path.to.OrderedSet)
	local set = OrderedSet.new()

	set:PushBack("a")
	set:PushBack("b")
	```
	--> Order: **a, b**
	```lua
	set:ToArray()
	```
	--> **{"a", "b"}**
]=]
function OrderedSet.ToArray<T>(self: OrderedSet<T>): { T }
	local result = table.create(self._size)
	for value in self:Iter() do
		table.insert(result, value)
	end
	return result
end

--[=[
	@return {T}
	Returns the set as a hash map where each key maps to true.
	Iteration order of the returned table is not guaranteed.
	```lua
	local OrderedSet = require(path.to.OrderedSet)
	local set = OrderedSet.new()

	set:PushBack("a")
	set:PushBack("b")

	set:ToMap()
	```
	--> **{ ["a"] = true, ["b"] = true }**
]=]
function OrderedSet.ToMap<T>(self: OrderedSet<T>): { [T]: boolean }
	local result = {}
	for value in self:Iter() do
		result[value] = true
	end
	return result
end

--[=[
	@return OrderedSet<T>
	Returns a clone of the set.
	```lua
	local OrderedSet = require(path.to.OrderedSet)
	local set = OrderedSet.new()

	set:PushBack("a")
	set:PushBack("b")
	```
	--> Order: **a, b**
	```lua
	set:Clone()
	```
	--> Order: **a, b**
]=]
function OrderedSet.Clone<T>(self: OrderedSet<T>): OrderedSet<T>
	local newSet = OrderedSet.new()
	for value in self:Iter() do
		newSet:PushBack(value)
	end
	return newSet
end

-- Pointers
--[=[
	@param val -- value that you want to check
	@return boolean -- true if the value is in the set
	Checks if a value is in the set.
	```lua
	local OrderedSet = require(path.to.OrderedSet)
	local set = OrderedSet.new()

	set:PushBack("a")
	```
	--> Order: **a**
	```lua
	set:Has("a")
	```
	--> **true**
]=]
function OrderedSet.Has<T>(self: OrderedSet<T>, val: T): boolean
	return self._map[val] ~= nil
end

--[=[
	@return T?
	Returns the first value in the set.
	```lua
	local OrderedSet = require(path.to.OrderedSet)
	local set = OrderedSet.new()

	set:PushBack("a")
	set:PushBack("b")
	```
	--> Order: **a, b**
	```lua
	set:Front()
	```
	--> **a**
]=]
function OrderedSet.Front<T>(self: OrderedSet<T>): T?
	return self._head and self._head.value
end

--[=[
	@return T?
	Returns the last value in the set.
	```lua
	local OrderedSet = require(path.to.OrderedSet)
	local set = OrderedSet.new()

	set:PushBack("a")
	set:PushBack("b")
	```
	--> Order: **a, b**
	```lua
	set:Back()
	```
	--> **b**
]=]
function OrderedSet.Back<T>(self: OrderedSet<T>): T?
	return self._tail and self._tail.value
end

--[=[
	@return () -> T?
	Returns an iterator function that lets you loop through the set in insertion order.

	Usage:
	```lua
	local OrderedSet = require(path.to.OrderedSet)
	local set = OrderedSet.new()

	set:PushBack("a")
	set:PushBack("b")
	set:PushBack("c")
	```

	--> Order: **a, b, c**

	```lua
	for value in set:Iter() do
		print(value)
	end
	```

	--> **a**
	--> **b**
	--> **c**

	Notes:
	- The order is preserved.
	- The loop automatically stops when the set ends.
]=]
function OrderedSet.Iter<T>(self: OrderedSet<T>): () -> T?
	local current = self._head
	return function()
		if not current then
			return nil
		end
		local val = current.value
		current = current.next
		return val
	end
end

--[=[
	@param callback (value: T) -> boolean?
	Calls the callback for each value in the set.
	If the callback returns false, iteration stops early.

	Example:

	```lua
	local OrderedSet = require(path.to.OrderedSet)

	local set = OrderedSet.fromArray({1, 2, 3, 4})

	-- Print all values
	set:Each(function(v)
		print(v)
	end)

	-- Stop early
	set:Each(function(v)
		if v == 3 then
			print("Found 3, stopping")
			return false -- stop iteration
		end
	end)
	```
]=]
function OrderedSet.Each<T>(self: OrderedSet<T>, callback: (value: T) -> boolean?)
	local current = self._head
	while current do
		if callback(current.value) == false then
			break
		end
		current = current.next
	end
end

--[=[
	@param func (value: T) -> U
	@return {U}
	Returns an array of transformed values from the set.

	Example:

	```lua
	local OrderedSet = require(path.to.OrderedSet)
	local set = OrderedSet.fromArray({1, 2, 3})

	-- Square numbers
	local squared = set:Map(function(v)
		return v * v
	end)

	print(squared) -- {1, 4, 9}

	-- Convert Players to UserIds
	local playerSet = OrderedSet.new()
	playerSet:PushBack(player1)
	playerSet:PushBack(player2)

	local userIds = playerSet:Map(function(player)
		return player.UserId
	end)

	print(userIds) -- {12345, 67890}
	```

]=]
function OrderedSet.Map<T, U>(self: OrderedSet<T>, func: (T) -> U): { U }
	local result = {}
	local current = self._head

	while current do
		table.insert(result, func(current.value))
		current = current.next
	end

	return result
end

-- Stats
--[=[
	@return boolean -- true if the set is empty
	Checks if the set is empty.
	```lua
	local OrderedSet = require(path.to.OrderedSet)
	local set = OrderedSet.new()

	set:Empty()
	```
	--> **true**
]=]
function OrderedSet.Empty<T>(self: OrderedSet<T>): boolean
	return self._size == 0
end

--[=[
	@return number -- the size of the set
	Checks the size of the set.
	```lua
	local OrderedSet = require(path.to.OrderedSet)
	local set = OrderedSet.new()

	set:Size()
	```
	--> **0**
]=]
function OrderedSet.Size<T>(self: OrderedSet<T>): number
	return self._size
end

return OrderedSet
