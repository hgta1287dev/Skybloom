local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextSurface = require(ReplicatedStorage.UI.core.Foundations.TextSurface)

export type TextProps = TextSurface.TextSurfaceProps
return TextSurface.new("TextLabel", "Text")
