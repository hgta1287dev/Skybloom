RunService = game:GetService("RunService")

local Refs = {
	testSpace = workspace:WaitForChild("TestSpace"),
	mainSpace = workspace:WaitForChild("MainSpace"),
}
Refs.map = Refs.mainSpace:WaitForChild("Map")

if RunService:IsServer() then
	Refs.testSpace:Destroy()
	Refs.testSpace = nil
end

return Refs
