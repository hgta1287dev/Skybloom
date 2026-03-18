local Promise = require(script.Parent.Parent.Promise)
local Signal = require(script.Parent.Parent.Signal)

type Signal = typeof(Signal.new())
type Promise = typeof(Promise.new())

export type State = {
	Name: string,

	CanEnter: ((machine: StateMachine, fromState: string?, data: any?) -> boolean)?,
	CanExit: ((machine: StateMachine, toState: string, data: any?) -> boolean)?,

	-- May return Promise or nil
	Enter: ((machine: StateMachine, previousState: string?, data: any?) -> Promise?)?,
	Exit: ((machine: StateMachine, nextState: string, data: any?) -> Promise?)?,
}

export type StateMachine = {
	_states: { [string]: State },
	_current: string?,
	_transitioning: boolean,
	_destroyed: boolean,
	_signal: Signal,

	AddState: (self: StateMachine, state: State) -> (),
	ChangeState: (self: StateMachine, newState: string, data: any?) -> Promise,
	IsTransitioning: (self: StateMachine) -> boolean,
	GetSignal: (self: StateMachine) -> Signal,
	SetInitialState: (self: StateMachine, stateName: string, data: any?) -> Promise,
	GetState: (self: StateMachine) -> string?,
	GetStateObject: (self: StateMachine) -> State?,
	OnStateChanged: (
		self: StateMachine,
		callback: (newState: string, oldState: string?, data: any?) -> ()
	) -> RBXScriptConnection,
	Destroy: (self: StateMachine) -> (),
}

local StateMachine = {}
StateMachine.__index = StateMachine

-- Constructor
function StateMachine.new(): StateMachine
	local self = setmetatable({
		_states = {},
		_current = nil,
		_transitioning = false,
		_destroyed = false,
		_signal = Signal.new(),
	}, StateMachine)

	return self :: any
end

-- Add state
function StateMachine:AddState(state: State)
	assert(not self._destroyed, "StateMachine is destroyed")
	assert(state.Name, "State must have Name")
	assert(not self._states[state.Name], "State already exists: " .. state.Name)

	self._states[state.Name] = state
end

function StateMachine:GetState(): string?
	return self._current
end

function StateMachine:IsTransitioning()
	return self._transitioning
end

function StateMachine:GetStateObject(): State?
	if not self._current then
		return nil
	end
	return self._states[self._current]
end

function StateMachine:OnStateChanged(callback: (newState: string, oldState: string?, data: any?) -> ())
	return self._signal:Connect(callback)
end

function StateMachine:GetSignal()
	return self._signal
end

function StateMachine:SetInitialState(stateName: string, data: any?)
	assert(not self._current, "Initial state already set")
	return self:ChangeState(stateName, data)
end

-- Core async transition
function StateMachine:ChangeState(newState: string, data: any?)
	assert(not self._destroyed, "StateMachine is destroyed")

	if self._transitioning then
		return Promise.reject("StateMachine is transitioning")
	end

	if self._current == newState then
		return Promise.resolve()
	end

	local nextState = self._states[newState]
	assert(nextState, "State does not exist: " .. newState)

	local prevName = self._current
	local prevState = prevName and self._states[prevName]

	self._transitioning = true

	local function unlock()
		self._transitioning = false
	end

	-- Guards
	if prevState and prevState.CanExit and not prevState.CanExit(self, newState, data) then
		unlock()
		return Promise.reject("Cannot exit state: " .. prevName)
	end

	if nextState.CanEnter and not nextState.CanEnter(self, prevName, data) then
		unlock()
		return Promise.reject("Cannot enter state: " .. newState)
	end

	local exitPromise = Promise.resolve()

	if prevState and prevState.Exit then
		exitPromise = Promise.try(function()
			return prevState.Exit(self, newState, data)
		end)
	end

	return exitPromise
		:andThen(function()
			if nextState.Enter then
				return Promise.try(function()
					return nextState.Enter(self, prevName, data)
				end)
			end
			return
		end)
		:andThen(function()
			self._current = newState
			if self._destroyed then
				return Promise.reject("StateMachine destroyed during transition")
			end

			self._signal:Fire(newState, prevName, data)
			unlock()
			return
		end)
		:catch(function(err)
			unlock()
			return Promise.reject(err)
		end)
end

function StateMachine:Destroy()
	if self._destroyed then
		return
	end

	self._destroyed = true
	self._transitioning = false
	self._signal:Destroy()
	table.clear(self._states)
	self._current = nil
end

return StateMachine
