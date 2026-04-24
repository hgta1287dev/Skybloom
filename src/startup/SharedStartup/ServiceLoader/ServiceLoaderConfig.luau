-- * Types
export type LoaderConfig = {
	Common: { string },
	Client: { string },
	Server: { string },
}

-- * Constant
local Configs = {
	Testing = false,
	Main = {
		Common = {
			"DevLogService",
			-- "CameraProxyService",
			"MapService",
			-- "WindService",
			-- "TestService",
			-- "RoomService",
			-- "CharacterService",
		},
		Client = {
			"CameraService",
			"LightingService",
		},
		Server = {},
	},

	Test = {
		Common = {
			"TestService",
			"ECSService",
			-- "CloudLayerService",
		},
		Client = {},
		Server = {},
	},
}

return Configs
