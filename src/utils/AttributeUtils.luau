local AttributeUtils = {}

function AttributeUtils.exists(instance: Instance, name: string): boolean
	return instance:GetAttribute(name) ~= nil
end

function AttributeUtils.get(instance: Instance, name: string, default: any?)
	local value = instance:GetAttribute(name)

	if value == nil then
		return default
	end

	return value
end

function AttributeUtils.set(instance: Instance, name: string, value: any): any
	instance:SetAttribute(name, value)
	return value
end

function AttributeUtils.apply(instance: Instance, data: { [string]: any })
	for name, value in pairs(data) do
		instance:SetAttribute(name, value)
	end
end

function AttributeUtils.forEach(instance: Instance, callback: (string, any) -> ())
	local attributes = instance:GetAttributes()

	for name, value in pairs(attributes) do
		callback(name, value)
	end
end

function AttributeUtils.increment(instance: Instance, name: string, amount: number?, default: any?): number
	local current = AttributeUtils.get(instance, name, default or 0)
	local new = current + amount or 1

	instance:SetAttribute(name, new)

	return new
end

function AttributeUtils.toggle(instance: Instance, name: string): boolean
	local value = instance:GetAttribute(name)

	if typeof(value) ~= "boolean" then
		value = false
	end

	value = not value

	instance:SetAttribute(name, value)

	return value
end

return AttributeUtils
