local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoomCard = require(script.Parent.RoomCard)
local UseRooms = require(script.Parent.UseRooms)
local React = require(ReplicatedStorage.Packages.React)
local ScrollContainer = require(ReplicatedStorage.UI.core.ScrollContainer)
local Widget = require(ReplicatedStorage.UI.core.Widget)
local e = React.createElement

function GetTestRooms()
	local rooms = {}
	for i = 1, 19 do
		local id = math.random(10000000, 99999999)
		rooms[`Room{id}`] = e(RoomCard, { Name = id })
	end
	return rooms
end

export type RoomListProps = {
	Size: UDim2?,
	Visible: boolean?,
	LayoutOrder: number?,
}

function RoomList(props: RoomListProps)
	local children = {}

	if not Players.LocalPlayer then -- check not is plugin
		children = GetTestRooms()
	else
		local rooms = UseRooms()
		for id, room in pairs(rooms) do
			children[id] = e(RoomCard, {
				Name = tostring(room.HostId),
				LayoutOrder = 0,
			})
		end
	end

	return e(Widget, {
		Size = props.Size or UDim2.fromScale(0.3, 1),
		LayoutOrder = props.LayoutOrder or 0,
	}, {
		RoomContainer = e(
			ScrollContainer,
			{
				Size = UDim2.fromScale(1, 1),
				LeftSpacing = 0,
				VerticalSpacing = 0,
				SortOrder = Enum.SortOrder.Name,
				LayoutOrder = 0,
			} :: ScrollContainer.ScrollContainerProps,
			children
		),
	})
end

return function(props: RoomListProps)
	if props.Visible == false then
		return nil
	end

	return RoomList(props)
end
