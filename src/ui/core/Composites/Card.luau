local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Pane = require(ReplicatedStorage.UI.core.Components.Pane)
local e = React.createElement

local function Card(props)
	return e(Pane, {
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromScale(1, 1),
	})
end
