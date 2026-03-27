local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- local DevConsolePanel = require(script.Parent.DevConsole.DevConsolePanel)
local Iris = require(ReplicatedStorage.Packages.Iris)
local DevPanelState = require(ReplicatedStorage.Shared.Core.DevPanel.DevCommon.DevPanelState)
local DevConsole = require(ReplicatedStorage.Shared.Core.DevPanel.DevConsole.DevConsole)
local DevConsolePanel = require(ReplicatedStorage.Shared.Core.DevPanel.DevConsole.DevConsolePanel)
local DevControllerPanel = require(ReplicatedStorage.Shared.Core.DevPanel.DevController.DevControllerPanel)

local DevPanel = {}

function DevPanel:Init()
	DevConsole:Init()

	Iris.Init()
	Iris:Connect(function()
		if not DevPanelState.ShowControllerPanel:get() then
			if Iris.Button({ "Open DevPanel" }):clicked() then
				local target = not DevPanelState.ShowControllerPanel:get()
				DevPanelState.ShowControllerPanel:set(target)
			end
		end

		DevControllerPanel:Render()
		DevConsolePanel:Render()
	end)
end

return DevPanel
