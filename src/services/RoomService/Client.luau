local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local RoomController = Knit.CreateController({
	Name = "RoomController",
})

function RoomController:KnitStart()
	self.RoomServices = Knit.GetService("RoomService")

	self.RoomServices.RoomJoined:Connect(function(room)
		print("Joined room:", room.Id)
	end)

	self.RoomServices.RoomUpdated:Connect(function(room)
		print("Room updated:", room.PlayerCount)
	end)

	self.RoomServices.RoomLeft:Connect(function(room)
		print("Left room")
	end)

	self.RoomServices.RoomStarted:Connect(function(room)
		print("Game started!")
	end)
end

return RoomController
