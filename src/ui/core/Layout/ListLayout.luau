local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Theme = require(ReplicatedStorage.UI.core.Theme)
local React = require(ReplicatedStorage.Packages.React)
local BaseComponent = require(ReplicatedStorage.UI.core.Foundations.BaseComponent)
local e = React.createElement

export type ListLayoutProps = {
	SortOrder: Enum.SortOrder?,
	Spacing: number?,
	HorizontalAlignment: Enum.HorizontalAlignment?,
	VerticalAlignment: Enum.VerticalAlignment?,
	FillDirection: Enum.FillDirection?,
	HorizontalFlex: Enum.UIFlexAlignment?,
	VerticalFlex: Enum.UIFlexAlignment?,
	Wraps: boolean?,

	[any]: any,
}
local UIListLayoutComponent = BaseComponent.new("UIListLayout")
local ListLayout = React.forwardRef(function(props: ListLayoutProps, ref)
	local style = Theme.Components.ListLayout
	return e(UIListLayoutComponent, {
		SortOrder = props.SortOrder or style.SortOrder,
		Padding = UDim.new(0, props.Spacing ~= nil and props.Spacing or style.Spacing),
		HorizontalAlignment = props.HorizontalAlignment or style.HorizontalAlignment,
		VerticalAlignment = props.VerticalAlignment or style.VerticalAlignment,
		FillDirection = props.FillDirection or style.FillDirection,
		HorizontalFlex = props.HorizontalFlex or style.HorizontalFlex,
		VerticalFlex = props.VerticalFlex or style.VerticalFlex,
		Wraps = props.Wraps ~= nil and props.Wraps or style.Wraps,
		ref = ref,
	})
end)

return ListLayout
