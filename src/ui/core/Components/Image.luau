local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ImageSurface = require(ReplicatedStorage.UI.core.Foundations.ImageSurface)

export type ImageProps = ImageSurface.ImageSurfaceProps
return ImageSurface.new("ImageLabel", "Pane")
