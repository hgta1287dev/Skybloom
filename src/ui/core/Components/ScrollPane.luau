local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)
local BaseSurface = require(ReplicatedStorage.UI.core.Foundations.SurfaceCore)
local ListLayout = require(ReplicatedStorage.UI.core.Layout.ListLayout)
local Padding = require(ReplicatedStorage.UI.core.Layout.Padding)
local Theme = require(ReplicatedStorage.UI.core.Theme)

local e = React.createElement

export type ScrollPaneProps = {
	ScrollBarColor: Color3?,
	ScrollBarTransparency: number?,
	ScrollBarThickness: number?,
	ScrollingDirection: Enum.ScrollingDirection?,

	CanvasSize: UDim2?,
} & BaseSurface.SurfaceProps & ListLayout.ListLayoutProps

local ScrollingFrameComponent = BaseSurface.new("ScrollingFrame", "ScrollPane")
local ScrollPane = React.forwardRef(function(props: ScrollPaneProps, ref)
	-- * Effects
	local style = Theme.Components.ScrollPane

	local containerRef = React.useRef(nil)
	local layoutRef = React.useRef(nil)

	React.useImperativeHandle(ref, function()
		return containerRef.current
	end)

	React.useEffect(function()
		local container = containerRef.current :: ScrollingFrame?
		local layout = layoutRef.current :: UIListLayout?

		if not (container and layout) then
			return
		end

		local function updateCanvas()
			container.CanvasSize = UDim2.fromOffset(layout.AbsoluteContentSize.X, layout.AbsoluteContentSize.Y)
		end
		updateCanvas()

		local contentSizeChangedConn = layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

		return function()
			contentSizeChangedConn:Disconnect()
		end
	end)

	-- * Children
	local children = table.clone(props.children or {})

	-- padding
	children.Padding = e(Padding, props)
	props.Radius = nil

	-- list layout
	local layoutStyle = Theme.Components.ListLayout
	local layoutProps = table.clone(layoutStyle)
	for key, value in pairs(layoutProps) do
		if props[key] ~= nil then
			layoutProps[key] = props[key]
			props[key] = nil
		end
	end
	layoutProps.ref = layoutRef
	children.ListLayout = e(ListLayout, layoutProps)

	-- * Props
	local newProps = TableUtil.Assign(props, {
		ScrollBarImageColor3 = props.ScrollBarColor or style.ScrollBarColor,
		ScrollBarThickness = props.ScrollBarThickness ~= nil and props.ScrollBarThickness or style.ScrollBarThickness,
		ScrollBarImageTransparency = props.ScrollBarTransparency ~= nil and props.ScrollBarTransparency
			or style.ScrollBarTransparency,
		ScrollingDirection = props.ScrollingDirection or style.ScrollingDirection,
		CanvasSize = props.CanvasSize or style.CanvasSize,

		ref = ref,
	})

	return e(ScrollingFrameComponent, newProps, children)
end)

return ScrollPane
