-- SurfaceCore.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local Shadow = require(ReplicatedStorage.UI.core.Components.Shadow)
local BaseComponent = require(script.Parent.BaseComponent)
local Corner = require(ReplicatedStorage.UI.core.Layout.Corner)
local Theme = require(ReplicatedStorage.UI.core.Theme)

local e = React.createElement

export type SurfaceProps = {
	-- Transform
	Size: UDim2?,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	Rotation: number?,

	-- Visual
	Color: Color3?,
	BorderSize: number?,
	Transparency: number?,
	Clips: boolean?,

	-- Decoration
	Shadow: boolean?,
	Radius: UDim?, -- semantic radius
	Elevation: number?, -- semantic elevation

	-- Layout
	ZIndex: number?,
	Visible: boolean?,
	LayoutOrder: number?,

	[any]: any,
}

local SurfaceCore = {}

function SurfaceCore.new(className: string, themeName: string)
	local Primitive = BaseComponent.new(className)

	return React.forwardRef(function(props: SurfaceProps, ref)
		local style = Theme.Components[themeName]
		if not style then
			warn("No theme found for " .. themeName)
			style = {}
		end

		local frameProps = {} :: SurfaceProps

		-- * Transform
		frameProps.Size = props.Size or style.Size
		frameProps.Position = props.Position or style.Position
		frameProps.AnchorPoint = props.AnchorPoint or style.AnchorPoint
		frameProps.Rotation = props.Rotation ~= nil and props.Rotation or style.Rotation

		-- * Visual
		frameProps.BackgroundColor3 = props.Color or style.Color
		frameProps.BorderSizePixel = props.BorderSize ~= nil and props.BorderSize or style.BorderSize
		frameProps.BackgroundTransparency = props.Transparency ~= nil and props.Transparency or style.Transparency
		frameProps.ClipsDescendants = props.Clips ~= nil and props.Clips or style.Clips

		-- * Layout
		frameProps.ZIndex = props.ZIndex ~= nil and props.ZIndex or style.ZIndex
		frameProps.Visible = props.Visible ~= nil and props.Visible or style.Visible
		frameProps.LayoutOrder = props.LayoutOrder ~= nil and props.LayoutOrder or style.LayoutOrder

		frameProps.ref = ref

		-- * Decoration injection
		local children = table.clone(props.children or {})

		local radius = props.Radius or style.Radius or Theme.Components.Corner.Radius
		children.Corner = e(Corner, {
			Radius = radius,
		})

		if props.Shadow then
			local containerProps = {
				Size = frameProps.Size,
				AnchorPoint = frameProps.AnchorPoint,
				Position = frameProps.Position,
				Rotation = frameProps.Rotation,
				BackgroundTransparency = 1,
				ZIndex = frameProps.ZIndex,
				Visible = frameProps.Visible,
				LayoutOrder = frameProps.LayoutOrder,
			}

			frameProps.Size = UDim2.fromScale(1, 1)
			frameProps.Position = UDim2.fromScale(0.5, 0.5)
			frameProps.AnchorPoint = Vector2.new(0.5, 0.5)
			frameProps.Rotation = 0
			frameProps.ZIndex = 0

			return e("Frame", containerProps, {
				Shadow = e(
					Shadow,
					{
						Elevation = props.Elevation,
						ZIndex = frameProps.ZIndex,
						Radius = radius,
					} :: Shadow.ShadownProps
				),

				Content = e(Primitive, frameProps, children),
			})
		end

		print(frameProps)
		return e(Primitive, frameProps, children)
	end)
end

return SurfaceCore
