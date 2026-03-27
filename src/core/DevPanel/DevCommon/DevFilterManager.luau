local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Iris = require(ReplicatedStorage.Packages.Iris)
local OrderedCollections =
	require(ReplicatedStorage.Packages._Index["hgta1287dev_ordered-collections@1.0.0"]["ordered-collections"])

local Manager = {}
Manager.__index = Manager

-- * Types
type Map<K, V> = OrderedCollections.Map<K, V>
type State = typeof(Iris.State(true))

export type StateName = string | "All"
export type StateManagerDef = {
	[string]: boolean,
}
export type StateManagerData = {
	_states: Map<string, State>,
	_masterState: State,

	_updatingMaster: boolean,
	_updatingNormal: boolean,
}
export type StateManager = typeof(setmetatable({} :: StateManagerData, Manager))

-- * Constructor
function Manager.new(def: StateManagerDef?): StateManager
	-- * Define data
	local data: StateManagerData = {
		_states = OrderedCollections.Map.new(),
		_masterState = Iris.State(true),

		_updatingMaster = false,
		_updatingNormal = false,
	}

	-- * Set metatable
	local self = setmetatable(data, Manager) :: StateManager

	-- * Define states
	if def ~= nil then
		for name, defaultValue in pairs(def) do
			self:AddState(name, defaultValue)
		end
	end

	-- * Bind
	self._masterState:onChange(function()
		self:_onMasterStateChange()
	end)

	return self
end

-- * Private Methods
-- * Binding
function Manager:_onMasterStateChange()
	if self._updatingMaster then
		return
	end
	self._updatingNormal = true

	local masterState = self:GetMasterState()
	self:EachState(function(name: string, state: State)
		state:set(masterState:get())
	end)

	self._updatingNormal = false
end

function Manager:_onStateChange(state: State)
	if self._updatingNormal then
		return
	end
	self._updatingMaster = true

	local masterState = self:GetMasterState()

	local full = true
	self:EachState(function(name: string, state: State)
		if not state:get() then
			full = false
			return false
		end
		return true
	end)

	masterState:set(full)

	self._updatingMaster = false
end

-- * Public
-- Each State
function Manager:EachState(callback: (name: string, state: State) -> boolean?)
	(self._states :: Map<string, State>):Each(callback)
end

-- State Getters
function Manager:GetState(name: StateName): State?
	if name == "All" then
		return self:GetMasterState()
	end
	return self._states:Get(name)
end

function Manager:GetMasterState(): State
	return self._masterState
end

-- State Mangement
function Manager:AddState(name: StateName, defaultValue: boolean?): State
	-- * Check if state already exists
	local state = self:GetState(name)
	if state then
		return state
	end

	-- * Define state
	state = Iris.State(defaultValue ~= nil and defaultValue or true)

	-- * Add state
	self._states:Set(name, state)

	-- * Bind
	state:onChange(function()
		self:_onStateChange(state)
	end)

	return state
end

return Manager
