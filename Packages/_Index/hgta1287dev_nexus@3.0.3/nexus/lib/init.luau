local Map = require(script.Nexus.Map)
local PriorityQueue = require(script.Nexus.PriorityQueue)
local Queue = require(script.Nexus.Queue)
local Set = require(script.Nexus.Set)
local Stack = require(script.Nexus.Stack)

export type Set<T> = Set.Set<T>
export type Map<K, V> = Map.Map<K, V>
export type Queue<T> = Queue.Queue<T>
export type PriorityQueue<T> = PriorityQueue.PriorityQueue<T>
export type Stack<T> = Stack.Stack<T>

local Nexus = {
	Set = Set,
	Map = Map,
	Queue = Queue,
	PriorityQueue = PriorityQueue,
	Stack = Stack,
}

return Nexus
