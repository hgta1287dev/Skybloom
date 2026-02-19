local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestApp = require(script.Parent.TestApp)
local React = require(ReplicatedStorage.Packages.React)
-- local LobbyMenu = require(ReplicatedStorage.UI.features.Lobby.LobbyMenu)
local e = React.createElement

local function RootUI()
	return {
		-- LobbyMenu = e(LobbyMenu),
		TestApp = e(TestApp),
	}
end

return RootUI
