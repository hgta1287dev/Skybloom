local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Iris = require(ReplicatedStorage.Packages.Iris)
local DevPanelState = require(ReplicatedStorage.Shared.Core.DevPanel.DevCommon.DevPanelState)

local ControlPanel = {}

function ControlPanel:Render()
	Iris.Window({ "Controller Panel" }, { isOpened = DevPanelState.ShowControllerPanel })
	do
		Iris.MenuBar()
		do
			Iris.Menu({ "Tools" })
			do
				Iris.MenuToggle({ "Console Panel" }, { isChecked = DevPanelState.ShowConsolePanel })
			end
			Iris.End()
		end
		Iris.End()
	end
	Iris.End()
end

return ControlPanel
