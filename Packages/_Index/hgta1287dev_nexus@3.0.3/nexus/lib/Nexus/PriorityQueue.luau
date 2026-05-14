local PriorityQueue = {}
PriorityQueue.__index = PriorityQueue

type Node<T> = {
	value: T,
	priority: number,
	order: number,
}

export type Compare<T> = (a: Node<T>, b: Node<T>) -> boolean

export type PriorityQueue<T> = {
	_heap: { Node<T> },
	_size: number,
	_order: number,
	_compare: Compare<T>,

	Push: (self: PriorityQueue<T>, value: T, priority: number?) -> boolean,
	Pop: (self: PriorityQueue<T>) -> (T?, number?),
	Peek: (self: PriorityQueue<T>) -> (T?, number?),

	Iter: (self: PriorityQueue<T>) -> () -> (T?, number?),
	Clear: (self: PriorityQueue<T>) -> (),
	Empty: (self: PriorityQueue<T>) -> boolean,
	Size: (self: PriorityQueue<T>) -> number,
}

local function defaultCompare<T>(a: Node<T>, b: Node<T>): boolean
	if a.priority == b.priority then
		return a.order < b.order
	end

	return a.priority < b.priority
end

local function swap<T>(heap: { Node<T> }, i: number, j: number)
	heap[i], heap[j] = heap[j], heap[i]
end

local function siftUp<T>(self: PriorityQueue<T>, index: number)
	local heap = self._heap

	while index > 1 do
		local parent = math.floor(index / 2)
		if not self._compare(heap[index], heap[parent]) then
			break
		end

		swap(heap, index, parent)
		index = parent
	end
end

local function siftDown<T>(self: PriorityQueue<T>, index: number)
	local heap = self._heap
	local size = self._size

	while true do
		local left = index * 2
		local right = left + 1
		local best = index

		if left <= size and self._compare(heap[left], heap[best]) then
			best = left
		end

		if right <= size and self._compare(heap[right], heap[best]) then
			best = right
		end

		if best == index then
			break
		end

		swap(heap, index, best)
		index = best
	end
end

function PriorityQueue.new<T>(compare: Compare<T>?): PriorityQueue<T>
	local self = setmetatable({
		_heap = {},
		_size = 0,
		_order = 0,
		_compare = compare or defaultCompare,
	}, PriorityQueue)

	return self :: PriorityQueue<T>
end

function PriorityQueue.Clear<T>(self: PriorityQueue<T>)
	table.clear(self._heap)
	self._size = 0
	self._order = 0
end

function PriorityQueue.Push<T>(self: PriorityQueue<T>, value: T, priority: number?): boolean
	assert(value ~= nil, "PriorityQueue does not support nil values")

	local node: Node<T> = {
		value = value,
		priority = priority or 0,
		order = self._order,
	}

	self._order += 1
	self._size += 1
	self._heap[self._size] = node

	siftUp(self, self._size)
	return true
end

function PriorityQueue.Peek<T>(self: PriorityQueue<T>): (T?, number?)
	local node = self._heap[1]
	if not node then
		return nil, nil
	end

	return node.value, node.priority
end

function PriorityQueue.Pop<T>(self: PriorityQueue<T>): (T?, number?)
	local heap = self._heap
	local root = heap[1]
	if not root then
		return nil, nil
	end

	local last = heap[self._size]
	heap[self._size] = nil
	self._size -= 1

	if self._size > 0 and last then
		heap[1] = last
		siftDown(self, 1)
	end

	return root.value, root.priority
end

function PriorityQueue.Iter<T>(self: PriorityQueue<T>): () -> (T?, number?)
	local snapshot: { Node<T> } = table.create(self._size)
	for i = 1, self._size do
		snapshot[i] = self._heap[i]
	end

	table.sort(snapshot, self._compare)

	local index = 0
	return function()
		index += 1
		local node = snapshot[index]
		if not node then
			return nil, nil
		end

		return node.value, node.priority
	end
end

function PriorityQueue.Empty<T>(self: PriorityQueue<T>): boolean
	return self._size == 0
end

function PriorityQueue.Size<T>(self: PriorityQueue<T>): number
	return self._size
end

return PriorityQueue
