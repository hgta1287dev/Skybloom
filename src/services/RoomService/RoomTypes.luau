local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OrderedSet = require(ReplicatedStorage.Packages._Index["hgta1287dev_ordered-set@1.2.0"]["ordered-set"])

export type RoomVisibility = "Public" | "Private"
export type RoomState = "Waiting" | "Playing"
export type RoomConfig = {
	MaxPlayers: number?,
	Visibility: RoomVisibility?,
}
export type RoomData = {
	Id: string,
	Host: Player,
	Players: OrderedSet.OrderedSet<Player>,
	MaxPlayers: number,
	Visibility: RoomVisibility,
	State: RoomState,
	Ready: OrderedSet.OrderedSet<Player>,
}

export type SerializedRoomData = {
	Id: string,
	HostId: string?,
	PlayerIds: { string },
	ReadyIds: { string },
	PlayerCount: number,
	MaxPlayers: number,
	Visibility: RoomVisibility,
	State: RoomState,
}

return {}
