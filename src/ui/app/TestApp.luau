local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Pane = require(ReplicatedStorage.UI.core.Components.Pane)

local e = React.createElement
local function _()
	local children = {}
	for i = 1, 100 do
		local color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
		children[`Pane{i}`] = e(
			Pane,
			{
				Size = UDim2.new(1, 0, 0, 100),
				Color = color,
			} :: Pane.PaneProps
		)
	end
	return {}
end

local function TestApp()
	return e(Pane, {
		Shadow = true,
		Size = UDim2.fromOffset(200, 120),
	})
end

return TestApp
