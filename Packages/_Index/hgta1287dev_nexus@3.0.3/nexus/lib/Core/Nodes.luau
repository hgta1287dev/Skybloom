--* Types
export type Node<T> = {
	value: T,
	prev: Node<T>?,
	next: Node<T>?,
}

export type NodeKey<K, V> = Node<V> & {
	key: K,
}

local Nodes = {}

function Nodes.new<K, V>(value: V, key: K?): Node<V> | NodeKey<K, V>
	if key ~= nil then
		return Nodes.keyValue(key, value)
	else
		return Nodes.value(value)
	end
end

function Nodes.value<T>(value: T): Node<T>
	return {
		value = value,
		prev = nil,
		next = nil,
	}
end

function Nodes.keyValue<K, V>(key: K, value: V): NodeKey<K, V>
	return {
		key = key,
		value = value,
		prev = nil,
		next = nil,
	}
end

return Nodes
