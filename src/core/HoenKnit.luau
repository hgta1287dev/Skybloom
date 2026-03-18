local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)

local HoenLogger = LoggerManager:CreateLogger("HoenKnit")
local HoenKnit = {}

-- * Types
-- Knit
type ServerMiddlewareFn = (player: Player, args: { any }) -> (boolean, ...any)
type ServerMiddleware = { ServerMiddlewareFn }
type Middleware = {
	Inbound: ServerMiddleware?,
	Outbound: ServerMiddleware?,
}
export type KnitServiceDef = {
	Name: string,
	Client: { [any]: any }?,
	Middleware: Middleware?,
	[any]: any,
}

export type KnitControllerDef = {
	Name: string,
}

type KnitObject = {
	Name: string,
	[any]: any,
}

export type KnitController = KnitObject
type KnitServiceClient = {
	Server: KnitService,
	[any]: any,
}
export type KnitService = {
	Name: string,
	Client: KnitServiceClient,
	KnitComm: any,
	[any]: any,
} & KnitObject

-- Hoen
type HoenObjectState = "Created" | "Initialized" | "Started" | "Destroyed"
type HoenObject = {
	Name: string,
	_logger: LoggerManager.Logger,
	_createTime: number,
	_state: HoenObjectState,
}

export type HoenService = HoenObject & KnitService
export type HoenController = HoenObject & KnitController

-- * Constants
local MESSAGES = {
	Init = {
		Started = "Init started",
		Success = "Init completed",
		Failed = "Init failed",
	},

	Start = {
		Started = "Start started",
		Success = "Start completed",
		Failed = "Start failed",
	},
}
local ACTION_STATES = {
	Started = "Started",
	Success = "Success",
	Failed = "Failed",
}
local ACTIONS = {
	Init = "Init",
	Start = "Start",
}

local STATES = {
	Create = "Created",
	Init = "Initialized",
	Start = "Started",
}

local KEYS = {
	Init = "KnitInit",
	Start = "KnitStart",
}

HoenKnit.Keys = KEYS

-- * Helpers
-- Measure time message
local function measureTime(st)
	local delta = (os.clock() - st) * 1000 -- ms
	local measure
	if delta < 0.01 then
		measure = "< 0.01 ms"
	else
		measure = string.format("%.2f ms", delta)
	end
	return `({measure})`
end

local function info(action: string, state: string, measure: number?)
	return `{MESSAGES[action][state]} {if measure then measureTime(measure) else ""}`
end

-- Error messages
local function errInvalidState(expected, got)
	return `Invalid state: expected state: "{expected}", got: "{got}".`
end

-- Lifecycle setup
local function setupLifecycle(object: KnitObject)
	-- * Handle functions
	local originalInit = object.KnitInit
	local originalStart = object.KnitStart

	-- * State
	object._state = STATES.Create

	-- * Timers
	object._createTime = os.clock()

	-- * Logger
	local logger = LoggerManager:CreateLogger(object.Name)
	object._logger = logger

	-- * Init
	function object:KnitInit()
		print(originalInit)
		-- Error handling
		if self._state ~= STATES.Create then
			logger:Warn(errInvalidState(STATES.Create, self._state))
			return
		end

		-- Notify
		logger:Info(info(ACTIONS.Init, ACTION_STATES.Started))

		-- Init
		local st = os.clock()
		local success, err = true, nil
		warn(originalInit)
		if typeof(originalInit) == "function" then
			warn("PCALLLLL")
			success, err = pcall(originalInit, self)
		end

		warn("NOTIFY")
		if success then
			self._state = STATES.Init
			logger:Info(info(ACTIONS.Init, ACTION_STATES.Success, st))
		else
			error(logger:Format(info(ACTIONS.Init, ACTION_STATES.Failed, st), err))
		end
	end

	-- * Start
	function object:KnitStart()
		warn(originalStart)
		if self._state ~= STATES.Init then
			logger:Warn(errInvalidState(STATES.Init, self._state))
			return
		end

		-- Log Start
		logger:Info(info(ACTIONS.Start, ACTION_STATES.Started))

		-- Start
		local st = os.clock()
		local success, err = true, nil
		if typeof(originalStart) == "function" then
			success, err = pcall(originalStart, self)
		end

		if success then
			self._state = STATES.Start
			logger:Info(info(ACTIONS.Start, ACTION_STATES.Success, st))
		else
			error(logger:Format(info(ACTIONS.Start, ACTION_STATES.Failed, st), err))
		end
	end

	-- * Meta
	setmetatable(object, {
		__newindex = function(self, key, value)
			if key == "KnitInit" then
				originalInit = value
			elseif key == "KnitStart" then
				originalStart = value
			else
				rawset(self, key, value)
			end
		end,
	})
end

-- * Public
-- Controller
function HoenKnit.CreateController(def: any): HoenController
	if RunService:IsServer() then
		HoenLogger:Warn("Controllers should only be created on the Client.")
	end
	local controller = Knit.CreateController(def)
	setupLifecycle(controller)
	return controller
end

-- Service
function HoenKnit.CreateService(def: any): HoenService
	if RunService:IsClient() then
		HoenLogger:Warn("Services should only be created on the Server.")
	end
	local service = Knit.CreateService(def)
	setupLifecycle(service)
	return service
end

return HoenKnit
