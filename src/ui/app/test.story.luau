local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestApp = require(script.Parent.TestApp)
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local e = React.createElement

return function(parent)
	local root = ReactRoblox.createRoot(parent)

	local app = e(TestApp)
	root:render(app)

	return function()
		root:unmount()
	end
end
