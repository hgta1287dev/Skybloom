-- TextSurface.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local SurfaceCore = require(script.Parent.SurfaceCore)
local Theme = require(ReplicatedStorage.UI.core.Theme)

local e = React.createElement

export type TextSurfaceProps = {
	Text: string?,
	Variant: ("Display" | "Heading" | "Title" | "Body" | "Caption" | "Button")?,

	TextFont: Enum.Font?,
	TextSize: number?,
	TextColor: Color3?,
	TextTransparency: number?,
	RichText: boolean?,

	TextXAlignment: Enum.TextXAlignment?,
	TextYAlignment: Enum.TextYAlignment?,
	TextWrapped: boolean?,
	TextTruncate: Enum.TextTruncate?,

	[any]: any,
} & SurfaceCore.SurfaceProps

local TextSurface = {}

function TextSurface.new(className: string, themeName: string)
	local Base = SurfaceCore.new(className, themeName)

	return React.forwardRef(function(props: TextSurfaceProps, ref)
		local style = Theme.Components[themeName] or {}
		local variant = props.Variant or style.Variant or "Body"

		local typo = Theme.Semantic.Typography[variant]

		local newProps = {}

		-- * Surface props pass-through
		for key, value in pairs(props) do
			newProps[key] = value
		end

		-- * Typography
		newProps.Text = props.Text or style.Text
		newProps.Font = props.TextFont or typo.Font
		newProps.TextSize = props.TextSize or typo.Size

		newProps.TextColor3 = props.TextColor or style.TextColor
		newProps.TextTransparency = props.TextTransparency ~= nil and props.TextTransparency or style.TextTransparency

		newProps.RichText = props.RichText ~= nil and props.RichText or style.RichText

		newProps.TextXAlignment = props.TextXAlignment or style.TextXAleignment
		newProps.TextYAlignment = props.TextYAlignment or style.TextYAlignment

		newProps.TextWrapped = props.TextWrapped ~= nil and props.TextWrapped or style.TextWrapped

		newProps.TextTruncate = props.TextTruncate ~= nil and props.TextTruncate or style.TextTruncate

		newProps.ref = ref

		-- cleanup custom props
		newProps.Variant = nil
		newProps.TextFont = nil
		newProps.TextSize = nil
		newProps.TextColor = nil
		newProps.TextTransparency = nil

		return e(Base, newProps, props.children)
	end)
end

return TextSurface
