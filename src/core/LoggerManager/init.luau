local RunService = game:GetService("RunService")
local Logger = require(script.Logger)

local LoggerManager = {}
LoggerManager.__index = LoggerManager

-- * Types
export type LogLevelName = "Debug" | "Info" | "Warn" | "Error"
export type LogLevel = number
export type Handler = (level: LogLevel, message: string) -> ()
export type Logger = Logger.Logger

-- * Constants
local IS_SERVER = RunService:IsServer()
local SIDE_PREFIX = IS_SERVER and "SERVER" or "CLIENT"

local LogLevels = {
	Debug = 1,
	Info = 2,
	Warn = 3,
	Error = 4,
}

-- * Constructor
function LoggerManager.new()
	local self = setmetatable({}, LoggerManager)

	self._started = false
	self._enabled = true
	self._level = LogLevels.Info
	self._loggers = {}
	self._handlers = {}
	self._buffer = {}

	-- default console handler
	self:AddHandler(function(level, message)
		if level == LogLevels.Warn then
			warn(message)
		elseif level == LogLevels.Error then
			error(message, 2)
		else
			print(message)
		end
	end)

	return self
end

-- * Private
function LoggerManager:_shouldLog(level: LogLevel)
	return self._enabled and level >= self._level
end

function LoggerManager:_dispatch(level: LogLevel, message: string)
	if not self:_shouldLog(level) then
		return
	end

	if not self._started then
		table.insert(self._buffer, { level = level, message = message })
		return
	end

	for _, handler in ipairs(self._handlers) do
		handler(level, message)
	end
end

-- * Public
function LoggerManager:SetLevel(levelName: LogLevelName)
	local level = LogLevels[levelName]
	if level then
		self._level = level
	end
end

function LoggerManager:Enable(state: boolean)
	self._enabled = state
end

function LoggerManager:AddHandler(handler: Handler)
	table.insert(self._handlers, handler)
end

function LoggerManager:Init()
	if self._started then
		return
	end

	self._started = true

	for _, entry in ipairs(self._buffer) do
		if self:_shouldLog(entry.level) then
			for _, handler in ipairs(self._handlers) do
				handler(entry.level, entry.message)
			end
		end
	end

	table.clear(self._buffer)
end

-- Logger Factory
function LoggerManager:CreateLogger(scope: string?): Logger
	if scope and self._loggers[scope] then
		return self._loggers[scope]
	end

	local logger = Logger.new(self, SIDE_PREFIX, scope, LogLevels)

	if not scope then
		logger._isTemporary = true
		return logger
	end

	self._loggers[scope] = logger
	return logger
end

return LoggerManager.new()
