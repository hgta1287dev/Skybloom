local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Iris = require(ReplicatedStorage.Packages.Iris)

Iris.Init()
Iris.UpdateGlobalConfig({ Iris.TemplateConfig.colorLight })
return Iris:Connect(function()
	local windowSize = Iris.State(Vector2.new(300, 400))

	Iris.Window({ "My Second Window" }, { size = windowSize })
	do
		Iris.Text({ "The current time is: " .. time() })

		Iris.InputText({ "Enter Text" })

		if Iris.Button({ "Click me" }).clicked() then
			print("button was clicked")
		end

		Iris.InputColor4()

		Iris.Tree()
		for i = 1, 8 do
			Iris.Text({ "Text in a loop: " .. i })
		end
		Iris.End()
	end
	Iris.End()
end)
