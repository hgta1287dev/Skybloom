local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MapContainer = require(script.Parent.MapContainer)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Knit = require(ReplicatedStorage.Packages.Knit)
local HoenKnit = require(ReplicatedStorage.Shared.Core.HoenKnit)

local MapController = HoenKnit.CreateController({
	Name = "MapController",

	TransitionReady = Signal.new(),
	MapUpdated = Signal.new(),
	CurrentMap = nil,
})

-- * Constants
local LOADMAPTIMEOUT = 5

-- * Private
function MapController:_getMap(mapName: string)
	local mapsFolder = MapContainer.GetContainer()
	if not mapsFolder then
		self._logger:Warn("Maps folder not found!")
		return nil
	end

	local map = mapsFolder:WaitForChild(mapName, LOADMAPTIMEOUT)
	if not map then
		self._logger:Warn(`Map not found: "{mapName}"`)
		return nil
	end

	return map
end

function MapController:_applyMap(mapName: string?, transitionId: number?)
	-- Apply when no map
	if not mapName then
		self.CurrentMap = nil
		self.MapUpdated:Fire(nil, transitionId)
		return
	end

	-- Current map is the same
	if self.CurrentMap and self.CurrentMap.Name == mapName then
		return
	end

	-- Get map
	local map = self:_getMap(mapName)
	if not map then
		return
	end

	-- Preload
	task.spawn(function()
		ContentProvider:PreloadAsync((map :: Instance):GetDescendants())
	end)

	-- Apply
	self.CurrentMap = map
	self.MapUpdated:Fire(mapName, transitionId)
end

-- * Public
function MapController:GetCurrentMap()
	return self.CurrentMap
end

-- * Knit
function MapController:KnitStart()
	local MapService = Knit.GetService("MapService")

	-- * Init
	MapService:GetCurrentMapAddress()
		:andThen(function(mapName: string?, transitionId: number)
			if mapName then
				self:_applyMap(mapName, transitionId)
			end
			self._logger:Info(`Init map {mapName} successfully!`)
		end)
		:catch(function(err)
			self._logger:Error("Init map error!:", err)
		end)

	-- * Connections
	MapService.MapUpdated:Connect(function(mapName: string, transitionId: number)
		self:_applyMap(mapName, transitionId)
	end)

	self.TransitionReady:Connect(function(transitionId: number)
		MapService:TransitionFinished(transitionId)
			:andThen(function()
				self._logger:Info(`Send transition finished successfully!`)
			end)
			:catch(function(err)
				self._logger:Error("Send transition finished error!:", err)
			end)
	end)
end

return MapController
