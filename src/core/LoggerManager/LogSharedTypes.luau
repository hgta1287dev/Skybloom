-- * Types
export type LogCategory =
	"None"
	| "System" -- init, lifecycle
	| "Network" -- remote, http
	| "Data" -- datastore
	| "UI" -- interface
	| "Gameplay" -- game logic

export type LogLevel =
	"Trace" -- trace back caller
	| "Debug" -- some debug info
	| "Info" -- some normal info
	| "Warn" -- something might be wrong
	| "Error" -- something went wrong
	| "Fatal" -- game is crashing and cant play anymore

export type LogSide = "Server" | "Client"
export type LogEntry = {
	content: string,
	level: LogLevel,
	category: LogCategory,
	scope: string?,
	_side: LogSide,
	_source: string?,
	_stack: string?,
	_timestamp: string,
}

export type LogFn = (self: any, categoryOrContent: LogCategory? | string, ...any) -> (string, LogEntry)

-- * Constants
local Sides = {
	Server = "Server",
	Client = "Client",
}

local Levels: { [LogLevel]: number } = {
	Trace = 1,
	Debug = 2,
	Info = 3,
	Warn = 4,
	Error = 5,
	Fatal = 6,
}

local LevelNames: { [number]: LogLevel } = {}
for name, value in Levels do
	LevelNames[value] = name
end

local Categories: { [LogCategory]: LogCategory } = {
	None = "None",
	System = "System",
	Network = "Network",
	Data = "Data",
	UI = "UI",
	Gameplay = "Gameplay",
}

-- * Exports
return {
	LogSides = Sides,
	LogLevels = Levels,
	LogLevelNames = LevelNames,
	LogCategories = Categories,
}
