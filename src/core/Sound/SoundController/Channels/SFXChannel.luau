local SoundService = game:GetService("SoundService")
local BaseSoundChannel = require(script.Parent.BaseSoundChannel)

local SFXChannel = {}
SFXChannel.__index = SFXChannel
setmetatable(SFXChannel, { __index = BaseSoundChannel })

export type PlayOptions = {
	parent: Instance?,
	volume: number?,
	playbackSpeed: number?,
	loop: boolean?,
	rolloffMaxDistance: number?,
	rolloffMinDistance: number?,
}

type BaseChannel = BaseSoundChannel.BaseChannel
export type SFXChannel =
	typeof(setmetatable(
		{} :: {
			activeSounds: { Sound },
		},
		SFXChannel
	))
	& BaseChannel

function SFXChannel.new(): SFXChannel
	local self = BaseSoundChannel.new("SFX")
	setmetatable(self, SFXChannel)
	self.activeSounds = {}
	return self
end

function SFXChannel:_track(sound: Sound)
	table.insert(self.activeSounds, sound)

	sound.Ended:Connect(function()
		for i, item in ipairs(self.activeSounds) do
			if item == sound then
				table.remove(self.activeSounds, i)
				break
			end
		end
	end)
end

function SFXChannel:Play(name: string, _options: PlayOptions?): Sound
	local options = _options or {}

	local template = self:RequireSound(name)
	local sound = template:Clone()

	sound.SoundGroup = self.group
	sound.Parent = options.parent or self.group

	if options.volume ~= nil then
		sound.Volume = options.volume
	end
	if options.playbackSpeed ~= nil then
		sound.PlaybackSpeed = options.playbackSpeed
	end
	if options.loop ~= nil then
		sound.Looped = options.loop
	end
	if options.rolloffMaxDistance ~= nil then
		sound.RollOffMaxDistance = options.rolloffMaxDistance
	end
	if options.rolloffMinDistance ~= nil then
		sound.RollOffMinDistance = options.rolloffMinDistance
	end

	sound:Play()
	self:_track(sound)

	if not sound.Looped then
		sound.Ended:Connect(function()
			if sound.Parent then
				sound:Destroy()
			end
		end)
	end

	return sound
end

function SFXChannel:PlayAtPosition(name: string, position: Vector3, _options: PlayOptions?): Sound
	local options = _options or {}

	local holder = Instance.new("Part")
	holder.Name = "SFXEmitter"
	holder.Anchored = true
	holder.CanCollide = false
	holder.CanTouch = false
	holder.CanQuery = false
	holder.Transparency = 1
	holder.Size = Vector3.new(0.2, 0.2, 0.2)
	holder.CFrame = CFrame.new(position)
	holder.Parent = SoundService

	options.parent = holder
	local sound = self:Play(name, options)

	sound.Ended:Connect(function()
		if holder.Parent then
			holder:Destroy()
		end
	end)

	return sound
end

function SFXChannel:AttachToPart(name: string, part: BasePart, _options: PlayOptions?): Sound
	local options = _options or {}
	options.parent = part
	return self:Play(name, options)
end

function SFXChannel:StopAll()
	for i = #self.activeSounds, 1, -1 do
		local sound = self.activeSounds[i]
		if sound.Parent then
			sound:Stop()
			sound:Destroy()
		end
	end

	table.clear(self.activeSounds)
end

return SFXChannel
