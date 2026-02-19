local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Knit = require(ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"]["knit"]["KnitClient"])
local RoomTypes = require(ReplicatedStorage.Shared.Services.RoomService.RoomTypes)

local function useRooms()
	local controller = Knit.GetController("RoomController")
	local rooms: RoomTypes.SerializedRoomData?, setRooms = React.useState(controller:GetRooms())

	React.useEffect(function()
		local conn = controller.RoomsChanged:Connect(function(newRooms: RoomTypes.SerializedRoomData)
			setRooms(table.clone(newRooms))
		end)
		return function()
			conn:Disconnect()
		end
	end, {})

	return rooms
end

return useRooms
