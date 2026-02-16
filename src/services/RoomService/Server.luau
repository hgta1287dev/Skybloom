local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedRoomConfig = require(ReplicatedStorage.Shared.Services.RoomService.SharedRoomConfig)

local Knit = require(ReplicatedStorage.Packages.Knit)
local OrderedSet = require(ReplicatedStorage.Packages._Index["hgta1287dev_ordered-set@1.2.0"]["ordered-set"])

type OrderedSet<T> = OrderedSet.OrderedSet<T>

local RoomService = Knit.CreateService({
	Name = "RoomService",
	Client = {
		RoomUpdated = Knit.CreateSignal(),
		RoomJoined = Knit.CreateSignal(),
		RoomLeft = Knit.CreateSignal(),
		RoomStarted = Knit.CreateSignal(),
		RoomKicked = Knit.CreateSignal(),

		CreateRoom = function(self, player, config)
			return self.Server:CreateRoom(player, config)
		end,

		JoinRoom = function(self, player, roomId)
			return self.Server:JoinRoom(player, roomId)
		end,

		Ready = function(self, player)
			self.Server:Ready(player)
		end,

		Unready = function(self, player)
			self.Server:Unready(player)
		end,

		StartGame = function(self, player)
			return self.Server:StartGame(player)
		end,

		LeaveRoom = function(self, player)
			self.Server:LeaveRoom(player)
		end,

		Kick = function(self, host, target, reason)
			self.Server:Kick(host, target, reason)
		end,
	},
})

--*Types
export type RoomVisibility = "Public" | "Private"
export type RoomState = "Waiting" | "Playing"
export type RoomConfig = {
	MaxPlayers: number?,
	Visibility: RoomVisibility?,
}
export type RoomData = {
	Id: string,
	Host: Player,
	Players: OrderedSet<Player>,
	MaxPlayers: number,
	Visibility: RoomVisibility,
	State: RoomState,
	Ready: OrderedSet<Player>,
}

--* Knit
function RoomService:KnitInit()
	self.rooms = {} :: { [string]: RoomData }
	self.playerRoom = {} :: { [Player]: string }
end

function RoomService:KnitStart()
	game.Players.PlayerRemoving:Connect(function(player)
		self:LeaveRoom(player)
	end)
end

--* Methods
-- Room Management
function RoomService:CreateRoom(player, config: RoomConfig): (RoomData?, string?)
	if self.playerRoom[player] then
		return nil, "Already in a room"
	end

	local roomId = self:GenerateRoomId()
	local room: RoomData = {
		Id = roomId,
		Host = player,
		Players = OrderedSet.fromArray({ player }), -- player joins the room
		MaxPlayers = math.clamp(
			config.MaxPlayers or SharedRoomConfig.MaxPlayers,
			SharedRoomConfig.MinPlayers,
			SharedRoomConfig.MaxPlayers
		),
		Visibility = config.Visibility or "Public",
		State = "Waiting",
		Ready = OrderedSet.new(),
	}

	self.rooms[roomId] = room
	self.playerRoom[player] = roomId

	-- notify
	local snapshot = self:SerializeRoom(room)
	self.Client.RoomJoined:Fire(player, snapshot)
	self.Client.RoomUpdated:Fire(player, snapshot)

	return room
end

function RoomService:JoinRoom(player, roomId: string): (boolean, string?)
	if self.playerRoom[player] then
		return false, "Already in a room"
	end

	local room = self.rooms[roomId]
	if not room then
		return false, "Room not found"
	end
	if room.State ~= "Waiting" then
		return false, "Game already started"
	end
	if room.Players:Size() >= room.MaxPlayers then
		return false, "Room full"
	end

	room.Players:PushBack(player)
	self.playerRoom[player] = roomId

	-- notify
	local snapshot = self:SerializeRoom(room)
	self.Client.RoomJoined:Fire(player, snapshot)
	room.Players:Each(function(p)
		self.Client.RoomUpdated:Fire(p, snapshot)
	end)

	return true
end

function RoomService:LeaveRoom(player)
	local roomId = self.playerRoom[player]
	if not roomId then
		return
	end

	local room = self.rooms[roomId]
	if not room then
		return
	end

	room.Players:Pop(player)
	self.playerRoom[player] = nil

	-- host leaves
	if room.Host == player then
		room.Host = room.Players:Front()
	end

	-- clean up room
	if room.Players:Size() == 0 then
		self.rooms[roomId] = nil
		self.Client.RoomLeft:Fire(player) -- no fire snapshot here because the room is already gone
		return -- no notify because the room is already gone
	end

	-- notify
	local snapshot = self:SerializeRoom(room)
	self.Client.RoomLeft:Fire(player, snapshot)
	room.Players:Each(function(p)
		self.Client.RoomUpdated:Fire(p, snapshot)
	end)
end

function RoomService:Ready(player)
	local room = self:GetRoomOfPlayer(player)
	if not room then
		return
	end
	room.Ready:PushBack(player)
end

function RoomService:Unready(player)
	local room = self:GetRoomOfPlayer(player)
	if not room then
		return
	end
	room.Ready:Pop(player)
end

function RoomService:Kick(host, target, reason)
	local room = self:GetRoomOfPlayer(host)
	if not room then
		return
	end
	if self:GetRoomOfPlayer(target) ~= room then
		return
	end
	if host ~= room.Host then
		return
	end
	if target == room.Host then
		return
	end

	self:LeaveRoom(target)
	self.Client.RoomKicked:Fire(target, reason)
end

-- Room Actions
function RoomService:StartGame(player): (boolean, string?)
	local roomId = self.playerRoom[player]
	local room = self.rooms[roomId]
	if not room then
		return false, "Room not found"
	end

	if room.Players:Size() < SharedRoomConfig.MinPlayers then
		return false, "Not enough players"
	end

	if room.Host ~= player then
		return false, "Only host can start"
	end

	room.State = "Playing"

	-- notify
	local snapshot = self:SerializeRoom(room)
	room.Players:Each(function(p)
		self.Client.RoomStarted:Fire(p, snapshot)
	end)

	return true
end

-- Room Utils
function RoomService:GenerateRoomId()
	local id
	repeat
		id = tostring(math.random(100000, 999999))
	until not self.rooms[id]
	return id
end

function RoomService:GetRoomOfPlayer(player)
	local roomId = self.playerRoom[player]
	if not roomId then
		return nil
	end
	return self.rooms[roomId]
end

function RoomService:GetPublicRooms()
	local list = {}
	for _, room in pairs(self.rooms) do
		if room.Visibility == "Public" and room.State == "Waiting" then
			table.insert(list, room)
		end
	end
	return list
end

function RoomService:SerializeRoom(room: RoomData)
	local playerIds = room.Players:Map(function(p)
		return p.UserId
	end)
	local readyIds = room.Ready:Map(function(p)
		return p.UserId
	end)

	return {
		Id = room.Id,
		HostId = room.Host and room.Host.UserId or nil,
		PlayerIds = playerIds,
		ReadyIds = readyIds,
		PlayerCount = room.Players:Size(),
		MaxPlayers = room.MaxPlayers,
		Visibility = room.Visibility,
		State = room.State,
	}
end

return RoomService
