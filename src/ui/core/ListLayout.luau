local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Theme = require(script.Parent.Theme)
local React = require(ReplicatedStorage.Packages.React)
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
}
function ListLayout(props: ListLayoutProps)
	return e("UIListLayout", {
		SortOrder = props.SortOrder or Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, props.Spacing or Theme.Spacing.XS),
		HorizontalAlignment = props.HorizontalAlignment or Enum.HorizontalAlignment.Center,
		VerticalAlignment = props.VerticalAlignment or Enum.VerticalAlignment.Center,
		FillDirection = props.FillDirection or Enum.FillDirection.Vertical,
		HorizontalFlex = props.HorizontalFlex or Enum.UIFlexAlignment.Fill,
		VerticalFlex = props.VerticalFlex or Enum.UIFlexAlignment.Fill,
		Wraps = props.Wraps or false,
	})
end

return ListLayout
