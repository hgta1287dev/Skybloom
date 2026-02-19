local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Corner = require(script.Parent.Corner)
local React = require(ReplicatedStorage.Packages.React)
local Theme = require(ReplicatedStorage.UI.core.Theme)
local BaseComponent = require(ReplicatedStorage.UI.utils.BaseComponent)

local e = React.createElement

export type DividerProps = {
	Vertical: boolean?,

	Length: UDim?,
	Thickness: number?,
	AnchorPoint: Vector2?,
	Position: UDim2?,

	Color: Color3?,
	Radius: UDim?,
	BorderSize: number?,
	Transparency: number?,

	LayoutOrder: number?,
	Visible: boolean?,
}

local FrameComponent = BaseComponent.new("Frame")
local Divider = React.forwardRef(function(props: DividerProps, ref)
	local style = Theme.Components.Divider

	local vertical = if props.Vertical ~= nil then props.Vertical else style.Vertical
	local length = props.Length or style.Length
	local thickness = props.Thickness or style.Thickness
	local visible = if props.Visible ~= nil then props.Visible else style.Visible
	local transparency = if props.Transparency ~= nil then props.Transparency else style.Transparency

	local size = if vertical
		then UDim2.new(0, thickness, length.Scale, length.Offset)
		else UDim2.new(length.Scale, length.Offset, 0, thickness)

	return e("Frame", {
		Size = size,
		AnchorPoint = props.AnchorPoint or style.AnchorPoint,
		Position = props.Position or style.Position,
		BackgroundTransparency = 1,
	}, {
		e(FrameComponent, {
			Size = size,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),

			BackgroundColor3 = props.Color or style.Color,
			BackgroundTransparency = transparency,
			BorderSizePixel = props.BorderSize or style.BorderSize,

			LayoutOrder = props.LayoutOrder or style.LayoutOrder,
			Visible = visible,

			ref = ref,
		}, {
			Corner = e(Corner, {
				Radius = props.Radius or style.Radius,
			}),
		}),
	})
end)

return Divider
