local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Theme = require(script.Parent.Theme)
local React = require(ReplicatedStorage.Packages.React)

local e = React.createElement

export type DeviderProps = {
	Length: UDim?,
	AnchorPoint: Vector2?,
	Position: UDim2?,
	Vertical: boolean?,
	Thickness: number?,
	Color: Color3?,
	Radius: UDim?,
	Transparency: number?,
	LayoutOrder: number?,
	UseContainer: boolean?,
	Visible: boolean?,
}
local Divider = function(props: DeviderProps)
	return e("Frame", {
		Size = props.Vertical and UDim2.new(
			0,
			props.Thickness or 1,
			props.Length and props.Length.Scale or 1,
			props.Length and props.Length.Offset or 0
		) or UDim2.new(
			props.Length and props.Length.Scale or 1,
			props.Length and props.Length.Offset or 0,
			0,
			props.Thickness or 1
		),
		Position = props.Position or UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = props.Color or Theme.Colors.Secondary,
		BorderSizePixel = 0,
		BackgroundTransparency = props.Transparency or 0.2,
		LayoutOrder = props.LayoutOrder or 0,
	}, {
		UICorner = e("UICorner", {
			CornerRadius = props.Radius or Theme.Radius.Pill,
		}),
	})
end

return function(props: DeviderProps)
	if props.Visible == false then
		return nil
	end

	local useCon = props.UseContainer or true

	local lo = props.LayoutOrder
	if lo and useCon then
		props.LayoutOrder = 0
	end

	if useCon then
		return e("Frame", {
			Size = props.Vertical and UDim2.new(0, props.Thickness or 1, 1, 0)
				or UDim2.new(1, 0, 0, props.Thickness or 1),
			BackgroundTransparency = 1,
			LayoutOrder = lo,
		}, {
			DividerContent = e(Divider, props),
		})
	else
		return e(Divider, props)
	end
end
