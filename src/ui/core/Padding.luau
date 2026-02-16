local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Theme = require(script.Parent.Theme)
local React = require(ReplicatedStorage.Packages.React)
local e = React.createElement

export type PaddingProps = {
	HorizontalSpacing: number?,
	VerticalSpacing: number?,
	LeftSpacing: number?,
	RightSpacing: number?,
	TopSpacing: number?,
	BottomSpacing: number?,
}

function Padding(props: PaddingProps)
	return e("UIPadding", {
		PaddingLeft = UDim.new(0, props.LeftSpacing or props.HorizontalSpacing or Theme.Spacing.DefaultHorizontal),
		PaddingRight = UDim.new(0, props.RightSpacing or props.HorizontalSpacing or Theme.Spacing.DefaultHorizontal),
		PaddingTop = UDim.new(0, props.TopSpacing or props.VerticalSpacing or Theme.Spacing.DefaultVertical),
		PaddingBottom = UDim.new(0, props.BottomSpacing or props.VerticalSpacing or Theme.Spacing.DefaultVertical),
	})
end

return Padding
