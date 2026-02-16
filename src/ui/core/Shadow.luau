local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local e = React.createElement

export type ShadowProps = {
	Color: Color3?,
	Size: UDim2?,
	Pos: UDim2?,
	Anchor: Vector2?,
	children: any,
}
function Shadow(props: ShadowProps)
	local Content = props.children.Content
	return e("Frame", {
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Size = props.Size or Content.Size or UDim2.fromScale(1, 1),
		Position = props.Pos or Content.Position or UDim2.fromScale(0.5, 0.5),
		AnchorPoint = props.Anchor or Content.AnchorPoint or Vector2.new(0.5, 0.5),
		ZIndex = 1,
	}, {
		ShadowImage = e("ImageLabel", {
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = "rbxassetid://1316045217",
			ImageColor3 = props.Color or Color3.fromRGB(0, 0, 0),
			ImageTransparency = 0.8,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1.07, 1.07),
			ZIndex = -10, --? not sure
		}),

		Content = Content,
	})
end

return Shadow
