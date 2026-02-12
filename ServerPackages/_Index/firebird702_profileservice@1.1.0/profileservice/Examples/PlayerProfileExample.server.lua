-- ProfileTemplate table is what empty profiles will default to.
-- Updating the template will not include missing template values in existing player profiles!
local ProfileTemplate = {
	Cash = 0,
	Items = {},
	LogInTimes = 0,
}

----- Services -----

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

----- Loaded Modules -----

local ProfileService = require(ServerScriptService.ProfileService)

----- Private Variables -----

local GameProfileStore = ProfileService.GetProfileStore("PlayerData", ProfileTemplate)
local Profiles = {} -- [player] = profile

----- Private Functions -----

local function giveCash(profile, amount)
	-- If "Cash" was not defined in the ProfileTemplate at game launch, you will have to perform the following:
	if profile.Data.Cash == nil then
		profile.Data.Cash = 0
	end

	-- Increment the "Cash" value:
	profile.Data.Cash = profile.Data.Cash + amount
end

local function doSomethingWithALoadedProfile(player, profile)
	profile.Data.LogInTimes = profile.Data.LogInTimes + 1
	print(string.format("%s has logged in %s time%s", player.Name, tostring(profile.Data.LogInTimes), ((profile.Data.LogInTimes > 1) and "s" or "")))
	giveCash(profile, 100)
	print(string.format("%s owns %s now!", player.Name, tostring(profile.Data.Cash)))
end

local function playerAdded(player)
	local profile = GameProfileStore:LoadProfileAsync("Player_" .. player.UserId)

	if profile ~= nil then
		profile:AddUserId(player.UserId) -- GDPR compliance
		profile:Reconcile() -- Fill in missing variables from ProfileTemplate (optional)
		profile:ListenToRelease(function()
			Profiles[player] = nil
			-- The profile could've been loaded on another Roblox server:
			player:Kick()
		end)

		if player:IsDescendantOf(Players) == true then
			Profiles[player] = profile
			-- A profile has been successfully loaded:
			doSomethingWithALoadedProfile(player, profile)
		else
			-- Player left before the profile loaded:
			profile:Release()
		end
	else
		-- The profile couldn't be loaded possibly due to other
		--   Roblox servers trying to load this profile at the same time:
		player:Kick()
	end
end

----- Initialize -----

-- In case Players have joined the server earlier than this script ran:
for _, player in Players:GetPlayers() do
	task.spawn(playerAdded, player)
end

----- Connections -----

Players.PlayerAdded:Connect(playerAdded)

Players.PlayerRemoving:Connect(function(player)
	local profile = Profiles[player]

	if profile ~= nil then
		profile:Release()
	end
end)
