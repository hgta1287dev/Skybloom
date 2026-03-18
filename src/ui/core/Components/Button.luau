local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local React = require(ReplicatedStorage.Packages.React)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)
local TextSurface = require(ReplicatedStorage.UI.core.Foundations.TextSurface)
local Theme = require(ReplicatedStorage.UI.core.Theme)

local e = React.createElement

-- * Types
export type ButtonProps = {
	Interactable: boolean?,
	UseEffect: boolean?,

	HoverStyleProps: { [string]: any }?,
	ClickStyleProps: { [string]: any }?,

	HoverStyleInfo: TweenInfo?,
	ClickStyleInfo: TweenInfo?,

	OnMouseEnter: (() -> ())?,
	OnMouseLeave: (() -> ())?,
	OnMouseButton1Down: (() -> ())?,
	OnMouseButton1Up: (() -> ())?,
	OnActivated: (() -> ())?,
} & TextSurface.TextSurfaceProps

-- * Utils
local function GetDefaultStyle(instance: GuiButton, ...)
	local style = TableUtil.Assign(...)
	local finalStyle = {}

	for key, _ in pairs(style) do
		local success, value = pcall(function()
			return instance[key]
		end)

		if success then
			finalStyle[key] = value
		end
	end

	return finalStyle
end

-- * Elements
local TextButtonComponent = TextSurface.new("TextButton", "Button")
local Button = React.forwardRef(function(props: ButtonProps, ref)
	local themeStyle = Theme.Components.Button

	local buttonRef = React.useRef(nil)
	local defaultStyleRef = React.useRef(nil)

	local hovered, setHovered = React.useState(false)
	local pressed, setPressed = React.useState(false)

	-- * Ref
	React.useImperativeHandle(ref, function()
		return buttonRef.current
	end)

	-- * Effect
	React.useEffect(function()
		if props.UseEffect == false then
			return
		end

		local button = buttonRef.current
		if not button then
			return
		end

		local hoverStyle = props.HoverStyleProps or themeStyle.HoverStyleProps
		local clickStyle = props.ClickStyleProps or themeStyle.ClickStyleProps

		local hoverTween = props.HoverStyleInfo or themeStyle.HoverStyleInfo
		local clickTween = props.ClickStyleInfo or themeStyle.ClickStyleInfo

		if not defaultStyleRef.current then
			defaultStyleRef.current = GetDefaultStyle(button, hoverStyle, clickStyle)
		end

		local defaultStyle = defaultStyleRef.current

		local targetStyle
		local tweenInfo

		if pressed then
			targetStyle = clickStyle
			tweenInfo = clickTween
		elseif hovered then
			targetStyle = hoverStyle
			tweenInfo = hoverTween
		else
			targetStyle = defaultStyle
			tweenInfo = hoverTween
		end

		local tween = TweenService:Create(button, tweenInfo, targetStyle)
		tween:Play()
		return function()
			tween:Cancel()
			tween:Destroy()
		end
	end, { hovered, pressed })

	-- * Events
	local function onEnter()
		setHovered(true)
		print("enter")
		local callback = props.OnMouseEnter
		if callback then
			callback()
		end
	end

	local function onLeave()
		setHovered(false)
		setPressed(false)

		local callback = props.OnMouseLeave
		if callback then
			callback()
		end
	end

	local function on1Down()
		setPressed(true)

		local callback = props.OnMouseButton1Down
		if callback then
			callback()
		end
	end

	local function on1Up()
		setPressed(false)

		local callback = props.OnMouseButton1Up
		if callback then
			callback()
		end
	end

	local function onActive()
		local callback = props.OnActivated
		if callback then
			callback()
		end
	end

	-- * Children
	local children = table.clone(props.children or {})

	-- * Props
	local newProps = TableUtil.Assign({}, props, {
		Interactable = props.Interactable or themeStyle.Interactable,

		[React.Event.MouseButton1Down] = on1Down,
		[React.Event.MouseButton1Up] = on1Up,
		[React.Event.MouseEnter] = onEnter,
		[React.Event.MouseLeave] = onLeave,
		[React.Event.Activated] = onActive,

		ref = buttonRef,
	})

	print(newProps)
	return e("TextButton", newProps, children)
end)

return Button
