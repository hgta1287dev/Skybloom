local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Pane = require(script.Parent.Pane)
local React = require(ReplicatedStorage.Packages.React)
local BaseComponent = require(ReplicatedStorage.UI.utils.BaseComponent)
local e = React.createElement

export type ButtonProps = {
	-- UsePrompt: boolean?, --? Visble prompt for sure if true
	UseEffect: boolean?,
	HoverSizeOffset: UDim2?,
	ClickSizeOffset: UDim2?,

	HoverColor: Color3?,
	ClickColor: Color3?,

	HoverText: string?,
	ClickText: string?,

	HoverTextColor: Color3?,
	ClickTextColor: Color3?,

	HoverProps: { [string]: any }?,
	ClickProps: { [string]: any }?,

	HoverTweenInfo: TweenInfo?,
	ClickTweenInfo: TweenInfo?,
	DefaultTweenInfo: TweenInfo?,

	OnAtiveCallback: () -> ()?,
	OnClickCallback: () -> ()?,
	OnDownCallback: () -> ()?,
	OnUpCallback: () -> ()?,
	OnEnterCallback: () -> ()?,
	OnLeaveCallback: () -> ()?,
} & Pane.PaneProps

local TextButtonComponent = BaseComponent.new("TextButton")
function Button(props: ButtonProps)
	local buttonRef = React.useRef(nil)

	React.useEffect(function()
		-- check button existence
		local button = buttonRef.current :: TextButton?

		if not button then
			return
		end

		-- variables
		local defaultProps = {}
		local hovering = false

		local function setDefaults(props)
			for name, value in pairs(props) do
				defaultProps[name] = button[name]
			end
		end

		setDefaults(props.ClickProps)
		setDefaults(props.HoverProps)

		-- effect
		local function clickEffect()
			TweenService:Create(button, props.ClickTweenInfo, props.ClickProps):Play()
		end

		local function hoverEffect()
			TweenService:Create(button, props.HoverTweenInfo, props.HoverProps):Play()
		end

		local function resetEffect()
			TweenService:Create(button, props.DefaultTweenInfo, defaultProps):Play()
		end

		-- connections
		local activeConn = button.Activated:Connect(function(...)
			if props.OnAtiveCallback then
				props.OnAtiveCallback(...)
			end
		end)

		local clickConn = button.MouseButton1Click:Connect(function(...)
			if props.OnClickCallback then
				props.OnClickCallback(...)
			end
		end)

		local downConn = button.MouseButton1Down:Connect(function(...)
			if props.UseEffect then
				clickEffect()
			end

			if props.OnDownCallback then
				props.OnDownCallback(...)
			end
		end)

		local upConn = button.MouseButton1Up:Connect(function(...)
			if props.UseEffect then
				if hovering then
					hoverEffect()
				else
					resetEffect()
				end
			end

			if props.OnUpCallback then
				props.OnUpCallback(...)
			end
		end)

		local enterConn = button.MouseEnter:Connect(function(...)
			hovering = true

			if props.UseEffect then
				hoverEffect()
			end

			if props.OnEnterCallback then
				props.OnEnterCallback(...)
			end
		end)

		local leaveConn = button.MouseLeave:Connect(function(...)
			hovering = false

			if props.UseEffect then
				resetEffect()
			end

			if props.OnLeaveCallback then
				props.OnLeaveCallback(...)
			end
		end)

		return function()
			activeConn:Disconnect()
			clickConn:Disconnect()
			downConn:Disconnect()
			upConn:Disconnect()
			enterConn:Disconnect()
			leaveConn:Disconnect()
		end
	end)

	local style = Theme.Components.Button
	return e(Pane, {
		Size = props.Size or style.Size,
		Position = props.Position or style.Position,
		AnchorPoint = props.AnchorPoint or style.AnchorPoint,
		Rotation = props.Rotation ~= nil and props.Rotation or style.Rotation,

		Color = props.Color or backgroundColor,
		BorderSize = props.BorderSize ~= nil and props.BorderSize or style.BorderSize,
		Transparency = props.Transparency ~= nil and props.Transparency or style.Transparency,
		Clips = props.Clips ~= nil and props.Clips or style.Clips,

		LayoutOrder = props.LayoutOrder or style.LayoutOrder,
		Visible = props.Visible ~= nil and props.Visible or style.Visible,
	}, {
		ButtonSurface = e(TextButtonComponent, {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = props.Text or "",
			TextColor3 = style.TextColor,
			TextSize = style.TextSize,

			AutoButtonColor = false,
			Active = not disabled,
			Selectable = not disabled,

			[React.Event.MouseEnter] = function()
				setHovered(true)
			end,

			[React.Event.MouseLeave] = function()
				setHovered(false)
				setPressed(false)
			end,

			[React.Event.MouseButton1Down] = function()
				setPressed(true)
			end,

			[React.Event.MouseButton1Up] = function()
				setPressed(false)
			end,

			[React.Event.Activated] = function()
				if not disabled and props.OnActivated then
					props.OnActivated()
				end
			end,

			ref = ref,
		}, children),
	})
end

return function(props: ButtonProps)
	if props.Visible == false then
		return nil
	end
	return Button(props)
end
