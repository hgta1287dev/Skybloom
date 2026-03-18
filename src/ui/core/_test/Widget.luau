local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local Shadow = require(script.Parent.Shadow)
local Divider = require(script.Parent.Divider)
local Shadow = require(script.Parent.Shadow)
local Theme = require(script.Parent.Theme)
local React = require(ReplicatedStorage.Packages.React)
local e = React.createElement

export type WidgetProps = {
	Shadow: boolean?,

	Color: Color3?,
	Corner: UDim?,
	Size: UDim2?,
	Position: UDim2?,
	AnchorPoint: Vector2?,

	HorizontalPadding: number?,
	VerticalPadding: number?,
	LeftPadding: number?,
	RightPadding: number?,
	TopPadding: number?,
	BottomPadding: number?,

	Title: string?,
	TitleSize: UDim2?,
	TitleFont: Enum.Font?,
	TitleFontSize: number?,
	TitleDivider: boolean?,
	TitleXAlignment: Enum.TextXAlignment?,
	TitleYAlignment: Enum.TextYAlignment?,

	Visible: boolean?,
	LayoutOrder: number?,

	children: any,
}
function Widget(props: WidgetProps)
	return e("Frame", {
		Size = props.Size or UDim2.fromOffset(850, 500),
		Position = props.Position or UDim2.fromScale(0.5, 0.5),
		AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
		BackgroundColor3 = props.Color or Theme.Colors.MainBackground,
		BackgroundTransparency = 0,
		LayoutOrder = props.LayoutOrder or 0,
	}, {
		UICorner = e("UICorner", {
			CornerRadius = props.Corner or Theme.Radius.Default,
		}),
		UIPadding = e("UIPadding", {
			PaddingLeft = UDim.new(0, props.LeftPadding or props.HorizontalPadding or Theme.Spacing.DefaultHorizontal),
			PaddingRight = UDim.new(
				0,
				props.RightPadding or props.HorizontalPadding or Theme.Spacing.DefaultHorizontal
			),
			PaddingTop = UDim.new(0, props.TopPadding or props.VerticalPadding or Theme.Spacing.DefaultVertical),
			PaddingBottom = UDim.new(0, props.BottomPadding or props.VerticalPadding or Theme.Spacing.DefaultVertical),
		}),
		UIListLayout = e("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, Theme.Spacing.XS),
			Wraps = false,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			VerticalFlex = Enum.UIFlexAlignment.Fill,
		}),
		TitleLabel = props.Title and e("TextLabel", {
			Text = props.Title,
			TextSize = props.TitleFontSize or Theme.FontSize.Title,
			TextXAlignment = props.TitleXAlignment or Enum.TextXAlignment.Center,
			TextYAlignment = props.TitleYAlignment or Enum.TextYAlignment.Center,
			TextColor3 = Theme.Colors.MainText,
			Font = props.TitleFont or Theme.Fonts.MainText,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = props.TitleSize or UDim2.new(1, 0, 0, Theme.FontSize.Title),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			LayoutOrder = 0,
		}),
		TitleDivider = props.TitleDivider and e(Divider, {
			Length = UDim.new(0.7, 0),
			Thickness = 2,
			LayoutOrder = 1,
			Transparency = 0.5,
		}),
		Content = e("Frame", {
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new(0.47451, 0.392157, 0.392157),
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = 3,
		}, props.children),
	})
end

return function(props: WidgetProps)
	if props.Visible == false then
		return nil
	end

	if props.Shadow then
		return e(Shadow, {
			Size = props.Size or UDim2.fromOffset(850, 500),
		}, {
			Content = e(Widget, props),
		})
	else
		return e(Widget, props)
	end
end
