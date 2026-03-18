local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(ReplicatedStorage.Packages.Signal)
local OrderedSet = require(ReplicatedStorage.Packages._Index["hgta1287dev_ordered-set@1.2.0"]["ordered-set"])
local HoenKnit = require(ReplicatedStorage.Shared.Core.HoenKnit)
local MapContainer = require(ReplicatedStorage.Shared.Services.MapService.MapContainer)
local MapFactory = require(ReplicatedStorage.Shared.Services.MapService.MapFactory)
local MapModulesManager = require(ReplicatedStorage.Shared.Services.MapService.MapModulesManager)
local GameTypes = require(ReplicatedStorage.Shared.Types.GameTypes)

local MapService = HoenKnit.CreateService({
	Name = "MapService",

	Client = {
		MapUpdated = Knit.CreateSignal(),

		TransitionFinished = function(self, player, transitionId)
			self.Server:_onTransitionFinished(player, transitionId)
		end,

		GetCurrentMapAddress = function(self)
			local map = self.Server:GetCurrentMap()
			return map and map.Name, self.Server:GetCurrentTransitionId()
		end,
	},

	MapUpdated = Signal.new(),

	CurrentMap = nil :: Model?,
	_pendingMap = nil :: Model?,
	_currentModulesManager = nil :: any,
	_pendingModulesManager = nil :: any,

	_playersAtTransition = OrderedSet.new() :: OrderedSet.OrderedSet<Player>,
	_finishedPlayers = OrderedSet.new() :: OrderedSet.OrderedSet<Player>,

	_currentTransitionId = 0,
})
local Logger = MapService._logger

-- * Types
export type Mode = GameTypes.Mode
export type MapModulesManager = MapModulesManager.MapModulesManager

-- * Constants
local LOAD_MAP_TIMEOUT = 10
local TRANISTION_TIMEOUT = 30
local TRANISTION_FINISHED_DELAY = 5

-- * Private
function MapService:_destroyPending()
	if self._pendingModulesManager then
		self._pendingModulesManager:Destroy()
		self._pendingModulesManager = nil
	end

	if self._pendingMap then
		self._pendingMap:Destroy()
		self._pendingMap = nil
	end
end

function MapService:_completeTransition(transitionId)
	if transitionId ~= self._currentTransitionId then
		return
	end

	task.delay(TRANISTION_FINISHED_DELAY, function()
		if transitionId ~= self._currentTransitionId then
			return
		end

		self:_destroyPending()
	end)
end

function MapService:_onTransitionFinished(player: Player, transitionId: number)
	if transitionId ~= self._currentTransitionId then
		return
	end

	if not self._playersAtTransition:Has(player) then
		return
	end

	if self._finishedPlayers:PushBack(player) then
		if self._finishedPlayers:Size() >= self._playersAtTransition:Size() then
			self:_completeTransition(transitionId)
		end
	end
end

-- * Public
function MapService:CreateMap(mode: Mode, mapName: string, timeout: number?)
	self:_destroyPending()

	self._currentTransitionId += 1
	local transitionId = self._currentTransitionId

	-- Reset state
	self._playersAtTransition:Clear()
	self._finishedPlayers:Clear()

	-- Snapshot current players
	for _, player in Players:GetPlayers() do
		self._playersAtTransition:PushBack(player)
	end

	-- Load map
	local oldMap = self.CurrentMap
	local newMap, err = MapFactory.CreateMap(mode :: Mode, mapName, timeout or LOAD_MAP_TIMEOUT)

	if not newMap then
		Logger:Error(err)
		return
	end

	self.CurrentMap = newMap
	self._pendingMap = oldMap

	-- Load modules
	local oldModulesManager = self._currentModulesManager
	local newModulesManager = MapModulesManager.new(newMap)
	newModulesManager:RegisterAll((newMap.Modules :: Folder):GetChildren())

	self._pendingModulesManager = oldModulesManager
	self._currentModulesManager = newModulesManager

	-- start modules
	if self._currentModulesManager then
		self._currentModulesManager:Start()
	end

	-- Fire map updated
	self.MapUpdated:Fire(mapName, transitionId)
	self.Client.MapUpdated:FireAll(mapName, transitionId)

	-- Timeout fallback
	task.delay(TRANISTION_TIMEOUT, function()
		if transitionId == self._currentTransitionId then
			Logger:Warn(`Transition timeout. Forcing complete.`)
			self:_completeTransition(transitionId)
		end
	end)

	-- If no players at all
	if self._playersAtTransition:Empty() then
		self:_completeTransition(transitionId)
	end
end

function MapService:GetCurrentMap(): Instance?
	return self.CurrentMap
end

function MapService:GetCurrentTransitionId(): number
	return self._currentTransitionId
end

-- * Knit
function MapService:KnitInit()
	MapContainer.CreateContainer()
end

function MapService:KnitStart()
	Players.PlayerRemoving:Connect(function(player)
		if self._playersAtTransition:Has(player) then
			self:_onTransitionFinished(player, self._currentTransitionId)
		end
	end)
end

return MapService
