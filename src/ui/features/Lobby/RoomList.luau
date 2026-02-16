local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoomCard = require(script.Parent.RoomCard)
local React = require(ReplicatedStorage.Packages.React)
local ScrollContainer = require(ReplicatedStorage.UI.core.ScrollContainer)
local Widget = require(ReplicatedStorage.UI.core.Widget)
local e = React.createElement

export type RoomListProps = {
	Size: UDim2?,
	Visible: boolean?,
	LayoutOrder: number?,
}

function GetTestRooms()
	local rooms = {}
	for i = 1, 100 do
		rooms[`Room {i}`] = e(RoomCard)
	end
	return rooms
end

function RoomList(props: RoomListProps)
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
				LayoutOrder = 0,
			} :: ScrollContainer.ScrollContainerProps,
			GetTestRooms()
		),
	})
end

return function(props: RoomListProps)
	if props.Visible == false then
		return nil
	end
	return RoomList(props)
end
