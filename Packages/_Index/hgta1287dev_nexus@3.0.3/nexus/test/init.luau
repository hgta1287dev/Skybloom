-- * Modules
local OrderedSet = require(script.OrderedSet)
local OrderedMap = require(script.OrderedMap)

-- * Types
export type Set<T> = OrderedSet.OrderedSet<T>
export type Map<K, V> = OrderedMap.OrderedMap<K, V>

-- * Collections
local collections = {
	Set = OrderedSet :: typeof(OrderedSet),
	Map = OrderedMap :: typeof(OrderedMap),
}

return collections
