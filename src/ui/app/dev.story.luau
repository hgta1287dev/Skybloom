local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function(parent)
	local disconnect = require(ReplicatedStorage.UI.dev.DevConsole)

	return function()
		disconnect()
	end
end
