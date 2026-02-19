local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RoomInfo = require(script.Parent.RoomInfo)
local RoomList = require(script.Parent.RoomList)
local React = require(ReplicatedStorage.Packages.React)
local Divider = require(ReplicatedStorage.UI.core.Divider)
local Theme = require(ReplicatedStorage.UI.core.Theme)
local Widget = require(ReplicatedStorage.UI.core.Widget)
local e = React.createElement

function LobbyMenu()
	return e(Widget, {
		Title = "Lobby Menu",
		TitleDivider = true,
		Shadow = true,
		Size = UDim2.fromOffset(950, 500),
	}, {
		UIListLayout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, Theme.Spacing.XS),
			Wraps = false,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			VerticalFlex = Enum.UIFlexAlignment.Fill,
		}),
		RoomList = e(RoomList, {
			Visible = true,
			Size = UDim2.fromScale(0.35, 1),
			LayoutOrder = 1,
		}),
		Divider = e(Divider, {
			Visible = true,
			Vertical = true,
			Length = UDim.new(0.6, 0),
			Thickness = 2,
			Transparency = 0.9,
			LayoutOrder = 2,
		}),
		RoomInfo = e(RoomInfo, {
			Visible = true,
			Size = UDim2.fromScale(0.65, 1),
			LayoutOrder = 3,
		}),
	})
end

return LobbyMenu
