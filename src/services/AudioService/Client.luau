local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HoenKnit = require(ReplicatedStorage.Shared.Core.HoenKnit)
local MusicSystem = require(ReplicatedStorage.Shared.Core.Sound.MusicSystem)
local SoundController = require(ReplicatedStorage.Shared.Core.Sound.SoundController)
local AudioController = HoenKnit.CreateController({
	Name = "AudioController",
	SoundController = SoundController,
	MusicSystem = MusicSystem,
})

function AudioController:GetSoundController()
	return SoundController
end

function AudioController:GetMusicSystem()
	return MusicSystem
end

function AudioController:KnitStart()
	SoundController.channels.Music:AddSoundFromContainer(ReplicatedStorage.Assets.Sounds.Music)
	SoundController.channels.SFX:AddSoundFromContainer(ReplicatedStorage.Assets.Sounds.SFX)

	MusicSystem:AddPlaylist("test", {
		"Infinite Focus Ambient Drone",
		"Deep Work Ambient Drone Soundscape",
		"Steady Mind Ambient Drone",
		"Focus Enhancing Drone Frequencies",
		"Deep Space Concentration",
		"Calm Field Without Pulse",
		"Low Sine Meditation",
	})

	MusicSystem:SetRepeatMode("All")
	MusicSystem:SetShuffle(true)
	MusicSystem:PlayPlaylist("test")
end

function AudioController:KnitInit() end

return AudioController
