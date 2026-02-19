local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local Theme = require(ReplicatedStorage.UI.core.Theme)
local e = React.createElement

export type CornerProps = {
	Radius: UDim?,
}
local function Corner(props: CornerProps)
	local style = Theme.Components.Corner
	return e("UICorner", {
		CornerRadius = props.Radius or style.Radius,
	})
end

return Corner
