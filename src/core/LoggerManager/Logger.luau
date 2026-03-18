local Logger = {}
Logger.__index = Logger

--* Types
export type LogLevel = number
export type Logger = {
	_scope: string,
	_manager: any,
	_prefix: string,
	_levels: { [string]: number },

	Debug: (self: Logger, ...any) -> string,
	Info: (self: Logger, ...any) -> string,
	Warn: (self: Logger, ...any) -> string,
	Error: (self: Logger, ...any) -> string,
	Format: (self: Logger, ...any) -> string,
}

--* Constructor
function Logger.new(manager: any, sidePrefix: string, scope: string?, logLevels: { [string]: number })
	return setmetatable({
		_scope = scope,
		_manager = manager,
		_prefix = sidePrefix,
		_levels = logLevels,
	}, Logger)
end

function Logger:Destroy()
	self._manager._loggers[self._scope] = nil
	self._manager = nil
	table.clear(self)
	setmetatable(self, nil)
end

--* Private
function Logger:_format(...)
	local header

	if self._scope and self._scope ~= "" then
		header = string.format("[%s][%s]: ", self._prefix, self._scope)
	else
		header = string.format("[%s]: ", self._prefix)
	end

	local parts = table.pack(...)
	for i = 1, parts.n do
		parts[i] = tostring(parts[i])
	end

	return header .. table.concat(parts, " ")
end

function Logger:_log(level: LogLevel, ...)
	local message = self:_format(...)
	self._manager:_dispatch(level, message)
	return message
end

--* Public
function Logger:Format(...)
	return self:_format(...)
end

function Logger:Debug(...)
	return self:_log(self._levels.Debug, ...)
end

function Logger:Info(...)
	return self:_log(self._levels.Info, ...)
end

function Logger:Warn(...)
	return self:_log(self._levels.Warn, ...)
end

function Logger:Error(...)
	return self:_log(self._levels.Error, ...)
end

return Logger
