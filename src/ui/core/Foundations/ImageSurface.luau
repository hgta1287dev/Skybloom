-- ImageSurface.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SurfaceCore = require(script.Parent.SurfaceCore)
local React = require(ReplicatedStorage.Packages.React)
local Theme = require(ReplicatedStorage.UI.core.Theme)

local e = React.createElement

export type ImageSurfaceProps = {
	Image: string?,
	ImageColor: Color3?,
	ImageTransparency: number?,
	TileSize: UDim2?,
	ScaleType: Enum.ScaleType?,
	SliceCenter: Rect?,
	SliceScale: number?,
} & SurfaceCore.SurfaceProps

local ImageSurface = {}

function ImageSurface.new(className: string, themeName: string?)
	local resolvedTheme = themeName or "Image"
	local Base = SurfaceCore.new(className, resolvedTheme)

	return React.forwardRef(function(props: ImageSurfaceProps, ref)
		local style = Theme.Components[resolvedTheme] or {}

		local newProps = table.clone(props)

		-- * Image behavior
		newProps.Image = props.Image or style.Image
		newProps.ImageColor3 = props.ImageColor or style.ImageColor
		newProps.ImageTransparency = props.ImageTransparency ~= nil and props.ImageTransparency
			or style.ImageTransparency

		newProps.TileSize = props.TileSize or style.TileSize
		newProps.ScaleType = props.ScaleType or style.ScaleType
		newProps.SliceCenter = props.SliceCenter or style.SliceCenter
		newProps.SliceScale = props.SliceScale or style.SliceScale

		newProps.ref = ref

		-- cleanup custom props
		newProps.ImageColor = nil
		newProps.ImageTransparency = nil

		return e(Base, newProps, props.children)
	end)
end

return ImageSurface
