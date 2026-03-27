local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LogSharedTypes = require(ReplicatedStorage.Shared.Core.LoggerManager.LogSharedTypes)

local IrisTypes = require(ReplicatedStorage.Packages._Index["sirmallard_iris@2.5.0"].iris.Types)
local OrderedCollections =
	require(ReplicatedStorage.Packages._Index["hgta1287dev_ordered-collections@1.0.0"]["ordered-collections"])
local DevFilterManager = require(ReplicatedStorage.Shared.Core.DevPanel.DevCommon.DevFilterManager)
local LoggerManager = require(ReplicatedStorage.Shared.Core.LoggerManager)

-- * Types
type Set<T> = OrderedCollections.Set<T>
type State<T> = IrisTypes.State<T>

type LogEntry = LogSharedTypes.LogEntry
type LogLevel = LogSharedTypes.LogLevel
type FilterManager = DevFilterManager.StateManager

-- * Constants
local MAX_LOGS = 300
local MAX_OUTPUT = 10

-- * Constructor
local DevConsole = {
	levelFilterManager = DevFilterManager.new() :: FilterManager,
	categoryFilterManager = DevFilterManager.new() :: FilterManager,
	entries = OrderedCollections.Set.new() :: OrderedCollections.Set<LogEntry>,
}

-- * Private
-- Binding
function DevConsole:_onMessageOut(entry: LogEntry)
	self:Log(entry)
end

-- Update
function DevConsole:_addToEntries(entry: LogEntry)
	self.entries:PushFront(entry)
	if self.entries:Size() > MAX_LOGS then
		self.entries:PopBack()
	end
end

-- * Public
-- Pass through
function DevConsole:Filter(entry: LogEntry): boolean
	local levelState = self.levelFilterManager:GetState(entry.level)
	if not levelState or not levelState:get() then
		return false
	end

	local categoryState = self.categoryFilterManager:GetState(entry.category)
	if not categoryState or not categoryState:get() then
		return false
	end

	return true
end

-- Log Methods
function DevConsole:Log(entry: LogEntry)
	self:_addToEntries(entry)
end

function DevConsole:Clear()
	self.entries:Clear()
end

-- Getters
function DevConsole:GetEntriesSet(): Set<LogEntry>
	return self.entries
end

function DevConsole:EachEntry(callback: (entry: LogEntry) -> boolean?)
	local outputs = 0
	self.entries:Each(function(entry: LogEntry)
		if not self:Filter(entry) then
			return
		end

		outputs += 1
		if outputs > MAX_OUTPUT then
			return false
		end

		return callback(entry)
	end)
end

-- Lifecycle
function DevConsole:Init()
	-- Level filter manager
	for _, level in ipairs(LogSharedTypes.LogLevelNames) do
		self.levelFilterManager:AddState(level, true)
	end

	-- Category filter manager
	for _, category in pairs(LogSharedTypes.LogCategories) do
		self.categoryFilterManager:AddState(category, true)
	end

	-- Bind MessageOut
	LoggerManager:ConnectMessageOut(function(message: string, entryBuffer: buffer)
		self:_onMessageOut(LoggerManager:DeserializeEntry(entryBuffer))
	end)
end

return DevConsole
