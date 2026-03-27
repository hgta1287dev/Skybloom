local RunService = game:GetService("RunService")
local LogSharedTypes = require(script.Parent.LogSharedTypes)
local Logger = {}
Logger.__index = Logger

--* Types
export type LogSide = LogSharedTypes.LogSide
export type LogLevel = LogSharedTypes.LogLevel
export type LogEntry = LogSharedTypes.LogEntry
export type LogCategory = LogSharedTypes.LogCategory
export type LogFn = LogSharedTypes.LogFn
export type LogDispatchFn = (logEntry: LogEntry) -> (string, LogEntry)
export type LoggerData = {
	_scope: string?,
	_dispatch: LogDispatchFn,

	Trace: LogFn,
	Debug: LogFn,
	Info: LogFn,
	Warn: LogFn,
	Error: LogFn,
	Fatal: LogFn,
}
export type Logger = typeof(setmetatable({} :: LoggerData, Logger))

-- * Helpers
local function getSidePrefix(): string
	local sidePrefix = RunService:IsServer() and LogSharedTypes.LogSides.Server or LogSharedTypes.LogSides.Client
	return string.upper(sidePrefix)
end

local function convertCategory(string): LogCategory
	return string ~= nil and string or "None"
end

local function convertContent(...)
	local parts = table.pack(...)
	for i = 1, parts.n do
		parts[i] = tostring(parts[i] or "nil")
	end
	return table.concat(parts, " ")
end

--* Private
local function _entry(self: any, level: LogLevel, category: LogCategory?, ...): (string, LogEntry)
	local content = convertContent(...)
	local source = debug.info(2, "s")
	local stack = debug.traceback(nil, 3)

	local logEntry: LogEntry = {
		content = content,
		level = level,
		scope = self._scope,
		category = convertCategory(category),

		_side = self._side,
		_timestamp = tostring(os.clock()),
		_source = (level == "Trace" or level == "Debug" or level == "Error" or level == "Fatal") and source or nil,
		_stack = (level == "Trace" or level == "Error" or level == "Fatal") and stack or nil, --? traceback here
	}

	return self._dispatch(logEntry)
end

--* Constructor
function Logger.new(dispatchFn: LogDispatchFn, scope: string?): Logger
	-- create log functions
	local function isValidCategory(value: any): boolean
		return LogSharedTypes.LogCategories[value] ~= nil
	end

	local function createLogFn(level: LogLevel): LogFn
		return function(self: any, ...): (string, LogEntry)
			local args = table.pack(...)
			local category = nil

			if args.n == 0 then
				error("Log args is nil", 3)
			elseif args.n >= 2 and isValidCategory(args[1]) then
				category = args[1]
				return _entry(self, level, category, table.unpack(args, 2, args.n))
			end

			return _entry(self, level, category, table.unpack(args, 1, args.n))
		end
	end

	local loggerData = {
		_dispatch = dispatchFn,
		_side = getSidePrefix(),
		_scope = scope,

		Trace = createLogFn("Trace"),
		Debug = createLogFn("Debug"),
		Info = createLogFn("Info"),
		Warn = createLogFn("Warn"),
		Error = createLogFn("Error"),
		Fatal = createLogFn("Fatal"),
	} :: LoggerData

	local self = setmetatable(loggerData, Logger)
	return self
end

function Logger:Destroy()
	self._manager = nil
	table.clear(self)
	setmetatable(self, nil)
end

return Logger
