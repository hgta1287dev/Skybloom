local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LogSharedTypes = require(script.LogSharedTypes)
local Logger = require(script.Logger)
local Signal = require(ReplicatedStorage.Packages.Signal)

local LoggerManager = {}
LoggerManager.__index = LoggerManager

-- * Types
type Signal = typeof(Signal.new())

export type LogLevel = LogSharedTypes.LogLevel
export type LogEntry = LogSharedTypes.LogEntry
export type Logger = Logger.Logger

export type LoggerManagerData = {
	_started: boolean,
	_enabled: boolean,
	_loggers: { [string]: Logger },
	_buffer: { LogEntry },

	MessageOut: Signal,
}
export type LoggerManager = typeof(setmetatable({} :: LoggerManagerData, LoggerManager))

-- * Constructor
function LoggerManager.new(): LoggerManager
	local self = setmetatable(
		{
			_started = false,
			_enabled = false,
			_loggers = {},
			_buffer = {},
			MessageOut = Signal.new(),
		} :: LoggerManagerData,
		LoggerManager
	)

	return self
end

-- * Helper
local function format(entry: LogEntry): string
	-- local side = `[{string.upper(entry._side)}]` --! not used
	local category = entry.category and `[{string.upper(entry.category)}]` or ""
	local scope = entry.scope and `[{entry.scope}]` or ""
	local content = entry.content
	local message = `{category}{scope}: {content}`
	return message
end

-- * Private
function LoggerManager:_dispatch(entry: LogEntry): (string, LogEntry)
	return self:Log(entry)
end

function LoggerManager:_output(message: string, level: LogLevel)
	local levels = LogSharedTypes.LogLevels
	if levels[level] >= levels.Error then
		error(message, 3)
	elseif level == "Warn" then
		warn(message)
	else
		print(message)
	end
end

-- * Public
-- State management
function LoggerManager:Toggle(state: boolean)
	self._enabled = state
end

function LoggerManager:Enable()
	self:Toggle(true)
end

function LoggerManager:Disable()
	self:Toggle(false)
end

-- Signal
function LoggerManager:ConnectMessageOut(fn: (message: string, entryBuffer: buffer) -> ())
	return self.MessageOut:Connect(fn)
end

-- Serialize
function LoggerManager:SerializeEntry(entry: LogEntry): buffer
	local safeEntry: LogEntry & { _timestamp: number } = {
		level = entry.level,
		content = entry.content,
		category = entry.category,
		scope = entry.scope,
		_side = entry._side,
		_timestamp = entry._timestamp,
		_source = entry._source,
		_stack = entry._stack,
	}
	return buffer.fromstring(HttpService:JSONEncode(safeEntry))
end

function LoggerManager:DeserializeEntry(entryBuffer: buffer): LogEntry
	local json = buffer.tostring(entryBuffer)
	local data = HttpService:JSONDecode(json)
	return data
end

-- Log
function LoggerManager:Log(entry: LogEntry, output: boolean?): (string, LogEntry)
	local message = format(entry)

	if not self._enabled then
		table.insert(self._buffer, entry)
		return message, entry
	end

	if output ~= false then
		self:_output(message, entry.level)
	end

	local bufferEntry = self:SerializeEntry(entry)
	self.MessageOut:Fire(message, bufferEntry)

	return message, entry
end

-- Lifecycle
function LoggerManager:Init()
	-- Check if already started
	if self._started then
		return
	end
	self._started = true

	-- Initializing
	self:Enable()

	-- buffer flush
	for _, entry in ipairs(self._buffer) do
		self:Log(entry)
	end
end

-- Logger Factory
function LoggerManager:CreateLogger(scope: string?, key: string?): Logger
	local id = scope or key

	if id and self._loggers[id] then
		return self._loggers[id]
	end

	local logger = Logger.new(function(logEntry: LogEntry): (string, LogEntry)
		return self:_dispatch(logEntry)
	end, scope)

	if id then
		self._loggers[id] = logger
	end

	return logger
end

return LoggerManager.new()
