local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HoenKnit = require(ReplicatedStorage.Shared.Core.HoenKnit)
local TestController = HoenKnit.CreateController({ Name = "TestController" })

-- * Constants

-- * Knit
function TestController:HoenInit()
	print(self._logger:Format("Init Testinggggggg"))
end

function TestController:HoenStart()
	print(self._logger:Format("Start Testinggggggg"))
end

return TestController
