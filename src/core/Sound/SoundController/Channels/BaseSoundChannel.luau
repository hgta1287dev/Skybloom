local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local TweenUtils = require(ReplicatedStorage.Shared.Utils.TweenUtils)

local BaseChannel = {}
BaseChannel.__index = BaseChannel

type TweenInfoOption = TweenUtils.TweenInfoOption

export type BaseChannel = typeof(setmetatable(
	{} :: {
		group: SoundGroup,
		sounds: { [string]: Sound },
		volume: number,
	},
	BaseChannel
))

local function createGroup(name: string)
	local group = Instance.new("SoundGroup")
	group.Name = name
	group.Parent = SoundService
	return group
end

function BaseChannel.new(name: string): BaseChannel
	local self = setmetatable({
		group = createGroup(name),
		sounds = {},
		volume = 1,
	}, BaseChannel) :: BaseChannel

	self:Init()
	return self
end

function BaseChannel:GetBaseVolume(name: string): number
	local sound = self:RequireSound(name)
	local att = sound:GetAttribute("BaseVolume")
	if typeof(att) == "number" then
		return att
	else
		sound:SetAttribute("BaseVolume", sound.Volume)
		return sound.Volume
	end
end

function BaseChannel:FindSound(name: string): Sound?
	return self.sounds[name]
end

function BaseChannel:GetSound(name: string): Sound?
	local sound = self:FindSound(name)
	if not sound then
		warn(`Sound {name} not found in channel`)
	end
	return sound
end

function BaseChannel:RequireSound(name: string): Sound
	local sound = self:FindSound(name)
	if not sound then
		error(`Sound {name} not found in channel`)
	end
	return sound
end

function BaseChannel:AddSound(name: string, sound: Sound)
	if self.sounds[name] then
		warn(`Sound {name} already exists in channel, overwriting`)
	end

	self.sounds[name] = sound
	sound.Parent = self.group
	sound.SoundGroup = self.group
	sound:SetAttribute("BaseVolume", sound.Volume)

	ContentProvider:PreloadAsync({ sound })
end

function BaseChannel:AddSounds(sounds: { [string]: Sound })
	for name, sound in pairs(sounds) do
		self:AddSound(name, sound)
	end
end

function BaseChannel:AddSoundFromContainer(parent: Instance, defineFilter: ((Sound) -> string?)?)
	for _, instance in ipairs(parent:GetDescendants()) do
		if instance:IsA("Sound") then
			local sound = instance :: Sound
			if defineFilter then
				local newName = defineFilter(sound)
				if newName then
					self:AddSound(newName, sound)
				end
			else
				self:AddSound(sound.Name, sound)
			end
		end
	end
end

function BaseChannel:SetSoundVolume(name: string, volume: number, info: TweenInfoOption?): Tween
	local sound = self:RequireSound(name)
	local tweenInfo = TweenUtils.createInfo(info)
	local tween = TweenService:Create(sound, tweenInfo, { Volume = volume })
	tween:Play()
	return tween
end

function BaseChannel:SetChannelVolume(volume: number, info: TweenInfoOption?): Tween
	self.volume = volume
	local tweenInfo = TweenUtils.createInfo(info)
	local tween = TweenService:Create(self.group, tweenInfo, { Volume = volume })
	tween:Play()
	return tween
end

function BaseChannel:SetOutputVolume(volume: number, info: TweenInfoOption?): Tween
	local tweenInfo = TweenUtils.createInfo(info)
	local tween = TweenService:Create(self.group, tweenInfo, { Volume = volume })
	tween:Play()
	return tween
end

function BaseChannel:Play(name: string): Sound
	local sound = self:RequireSound(name)
	sound:Play()
	return sound
end

function BaseChannel:Stop(name: string)
	local sound = self:RequireSound(name)
	sound:Stop()
end

function BaseChannel:StopAll()
	for _, sound in pairs(self.sounds) do
		sound:Stop()
	end
end

function BaseChannel:Pause(name: string)
	local sound = self:RequireSound(name)
	sound:Pause()
end

function BaseChannel:Resume(name: string)
	local sound = self:RequireSound(name)
	sound:Resume()
end

return BaseChannel
