local Collection = {}
Collection.__index = Collection

export type Collection = {
	_size: number,
	Size: (self: Collection) -> number,
	Empty: (self: Collection) -> boolean,
	Clear: (self: Collection) -> (),
	Destroy: (self: Collection) -> (),
}

function Collection.new(): Collection
	local self = setmetatable({
		_size = 0,
	}, Collection)

	return self
end

function Collection.Size(self: Collection): number
	return self._size
end

function Collection.Empty(self: Collection): boolean
	return self._size == 0
end

function Collection.Clear(self: Collection)
	self._size = 0
end

function Collection.Destroy(self: Collection)
	table.clear(self)
	setmetatable(self, nil)
end

return Collection
