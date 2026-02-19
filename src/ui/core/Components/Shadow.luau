local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local Theme = require(ReplicatedStorage.UI.core.Theme)

local e = React.createElement

local ElevationMap = { -- [1] transparency, [2] scale
	[Theme.Semantic.Elevation.None] = { 1, 1 },
	[Theme.Semantic.Elevation.Low] = { 0.98, 1.03 },
	[Theme.Semantic.Elevation.Medium] = { 0.96, 1.05 },
	[Theme.Semantic.Elevation.High] = { 0.94, 1.065 },
	[Theme.Semantic.Elevation.Overlay] = { 0.92, 1.08 },
}

export type ShadownProps = {
	Elevation: number,
	ZIndex: number,
	Radius: UDim2?,
}
local function Shadow(props: ShadownProps)
	local elevation = props.Elevation or Theme.Semantic.Elevation.Low
	local visual = ElevationMap[elevation]

	return e("ImageLabel", {
		BackgroundTransparency = 1,
		Image = "rbxassetid://1316045217",
		ImageColor3 = Color3.new(0, 0, 0),
		ImageTransparency = visual[1],

		Size = UDim2.fromScale(visual[2], visual[2]),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),

		ZIndex = (props.ZIndex or 0) - 1,
	}, {
		Corner = e("UICorner", {
			CornerRadius = props.Radius or 0,
		}),
	})
end

return Shadow
