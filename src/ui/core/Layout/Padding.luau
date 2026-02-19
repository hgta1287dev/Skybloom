local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Theme = require(ReplicatedStorage.UI.core.Theme)
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
	local style = Theme.Components.Padding
	return e("UIPadding", {
		PaddingLeft = UDim.new(0, props.LeftSpacing or props.HorizontalSpacing or style.HorizontalSpacing),
		PaddingRight = UDim.new(0, props.RightSpacing or props.HorizontalSpacing or style.HorizontalSpacing),
		PaddingTop = UDim.new(0, props.TopSpacing or props.VerticalSpacing or style.VerticalSpacing),
		PaddingBottom = UDim.new(0, props.BottomSpacing or props.VerticalSpacing or style.VerticalSpacing),
	})
end

return Padding
