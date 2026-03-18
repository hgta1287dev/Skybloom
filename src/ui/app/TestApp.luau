local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)
local Button = require(ReplicatedStorage.UI.core.Components.Button)

local e = React.createElement

local function TestApp()
	return e(Button, {
		Text = "Button",
	})
end

return TestApp
