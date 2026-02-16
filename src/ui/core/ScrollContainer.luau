local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ListLayout = require(script.Parent.ListLayout)
local Padding = require(script.Parent.Padding)
local Theme = require(script.Parent.Theme)
local React = require(ReplicatedStorage.Packages.React)

local e = React.createElement

export type ScrollContainerProps = {
	Size: UDim2?,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	BackgroundColor3: Color3?,
	BackgroundTransparency: number?,

	ScrollBarTransparency: number?,
	ScrollBarThickness: number?,

	LayoutOrder: number?,

	children: any,
} & ListLayout.ListLayoutProps & Padding.PaddingProps

function ScrollContainer(props: ScrollContainerProps)
	local containerRef = React.useRef(nil)
	local uiListRef = React.useRef(nil)

	React.useEffect(function()
		local container = containerRef.current :: ScrollingFrame?
		local uiList = uiListRef.current :: UIListLayout?

		if not (container and uiList) then
			return
		end

		local function updateCanvas()
			container.CanvasSize = UDim2.fromOffset(uiList.AbsoluteContentSize.X, uiList.AbsoluteContentSize.Y)
		end

		updateCanvas()

		local contentSizeChangedConn = uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

		return function()
			contentSizeChangedConn:Disconnect()
		end
	end)

	props.children.UIPadding = e(Padding, props)
	props.children.UIListLayout = e(
		"UIListLayout",
		{
			SortOrder = props.SortOrder or Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, props.Spacing or Theme.Spacing.XS),
			HorizontalAlignment = props.HorizontalAlignment or Enum.HorizontalAlignment.Center,
			VerticalAlignment = props.VerticalAlignment or Enum.VerticalAlignment.Top,
			FillDirection = props.FillDirection or Enum.FillDirection.Vertical,
			HorizontalFlex = props.HorizontalFlex or Enum.UIFlexAlignment.Fill,
			VerticalFlex = props.VerticalFlex or Enum.UIFlexAlignment.None,
			Wraps = props.Wraps or false,
			ref = uiListRef,
		} :: ListLayout.ListLayoutProps
	)

	return e("ScrollingFrame", {
		Size = props.Size or UDim2.fromScale(1, 1),
		Position = props.Position or UDim2.fromScale(0.5, 0.5),
		AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),

		BackgroundColor3 = props.BackgroundColor3 or Theme.Colors.SubBackground,
		BackgroundTransparency = props.BackgroundTransparency or 1,
		BorderSizePixel = 0,

		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.fromScale(0, 0),

		ScrollBarImageTransparency = props.ScrollBarTransparency or 0.4,
		ScrollBarImageColor3 = Theme.Colors.Primary,
		ScrollBarThickness = props.ScrollBarThickness or 4,

		ScrollingDirection = Enum.ScrollingDirection.Y,
		LayoutOrder = props.LayoutOrder or 0,

		ref = containerRef,
	}, props.children)
end

return ScrollContainer
