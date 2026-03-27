local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Iris = require(ReplicatedStorage.Packages.Iris)

return {
	ShowDate = Iris.State(true),
	ShowRunSide = Iris.State(true),
	ShowRunScope = Iris.State(true),
	ShowRunContent = Iris.State(true),
}
