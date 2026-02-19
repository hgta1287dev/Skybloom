local BaseComponent = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.Packages.React)

local e = React.createElement

function BaseComponent.new(instanceType: string, createApi: ((instance: Instance) -> any)?)
	return React.forwardRef(function(props, ref)
		local innerRef = React.useRef(nil)

		if createApi then
			React.useImperativeHandle(ref, function()
				return createApi(innerRef.current)
			end)
		else
			React.useImperativeHandle(ref, function()
				return innerRef.current
			end)
		end

		local newProps = table.clone(props)
		newProps.ref = innerRef

		return e(instanceType, newProps, props.children)
	end)
end

return BaseComponent
