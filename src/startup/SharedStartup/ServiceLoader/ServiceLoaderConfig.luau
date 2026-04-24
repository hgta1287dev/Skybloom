-- * Types
export type LoaderConfig = {
	Common: { string },
	Client: { string },
	Server: { string },
}

-- * Constant
local Configs = {
	Dev = {
		Common = {
			"DevLogService",
		},
		Client = {},
		Server = {},
	},
	Test = {
		Common = {
			"TestService",
			"ECSService",
			-- "CloudLayerService",
			-- "CameraProxyService",
			-- "WindService",
			-- "RoomService",
			-- "CharacterService",
		},
		Client = {},
		Server = {},
	},

	Main = {
		Common = {
			"MapService",
		},
		Client = {
			"CameraService",
			"LightingService",
		},
		Server = {},
	},
}

-- * Config
local Actives = {
	Configs.Dev,
	Configs.Test,
	Configs.Main,
}

return {
	Configs = Configs,
	Actives = Actives,
}
