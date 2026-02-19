local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SurfaceCore = require(ReplicatedStorage.UI.core.Foundations.SurfaceCore)

export type PaneProps = SurfaceCore.SurfaceProps
return SurfaceCore.new("Frame", "Pane")
