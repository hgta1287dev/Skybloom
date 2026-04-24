local TweenService = game:GetService("TweenService")
local BaseSoundChannel = require(script.Parent.BaseSoundChannel)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenUtils = require(ReplicatedStorage.Shared.Utils.TweenUtils)

local MusicChannel = {}
MusicChannel.__index = MusicChannel
setmetatable(MusicChannel, { __index = BaseSoundChannel })

type BaseChannel = BaseSoundChannel.BaseChannel
export type MusicChannel =
	typeof(setmetatable(
		{} :: {
			currentName: string?,
			currentSound: Sound?,
		},
		MusicChannel
	))
	& BaseChannel

type TweenInfoOption = TweenUtils.TweenInfoOption

function MusicChannel.new(): MusicChannel
	local self = BaseSoundChannel.new("Music")
	setmetatable(self, MusicChannel)

	self.currentName = nil
	self.currentSound = nil
	return self
end

function MusicChannel:GetCurrentName(): string?
	return self.currentName
end

function MusicChannel:GetCurrentSound(): Sound?
	return self.currentSound
end

function MusicChannel:Play(name: string): Sound
	local sound = self:RequireSound(name)

	if self.currentSound and self.currentSound ~= sound then
		self.currentSound:Stop()
	end

	self.currentName = name
	self.currentSound = sound
	sound:Play()
	return sound
end

function MusicChannel:StopCurrent()
	if self.currentSound then
		self.currentSound:Stop()
	end

	self.currentName = nil
	self.currentSound = nil
end

function MusicChannel:Crossfade(fromName: string?, toName: string, duration: number?, info: TweenInfoOption?): Sound
	local toSound = self:RequireSound(toName)
	local fromSound = fromName and self:GetSound(fromName) or self.currentSound

	-- * Helpers
	local function fade(sound: Sound, isFrom: boolean): Tween
		local startVolume = if isFrom then sound.Volume else 0
		local targetVolume = if isFrom then 0 else self:GetBaseVolume(toName) -- auto equal to base volume if not set
		local tweenInfo = TweenUtils.createInfo(info or {
			Time = duration or 1,
		})

		sound.Volume = startVolume
		local tween = TweenService:Create(sound, tweenInfo, { Volume = targetVolume })
		tween:Play()

		if isFrom then
			self.fromSoundTween = tween
		else
			self.toSoundTween = tween
		end

		task.delay(tweenInfo.Time, function()
			if isFrom and self.fromSoundTween == tween then
				self.fromSoundTween = nil
				if sound then
					sound:Stop()
					sound.Volume = self:GetBaseVolume(fromName) --! reset volume for next time
				end
			elseif not isFrom and self.toSoundTween == tween then
				self.toSoundTween = nil -- current playing does not need to reset volume
			end
		end)

		return tween
	end

	-- If same sound, just continue it without crossfade
	if fromSound == toSound then
		self:CancelCrossfade()

		if not toSound.IsPlaying then
			fade(toSound, false)
		end

		self.currentName = toName
		self.currentSound = toSound

		return toSound
	end

	if fromSound and fromSound.IsPlaying then
		fade(fromSound, true)
	end
	fade(toSound, false)

	return toSound
end

-- ! Only cancels the crossfade tweens, does not stop any sounds
function MusicChannel:CancelCrossfade()
	if self.toSoundTween then
		self.toSoundTween:Cancel()
		self.toSoundTween = nil
	end

	if self.fromSoundTween then
		self.fromSoundTween:Cancel()
		self.fromSoundTween = nil
	end
end

return MusicChannel
