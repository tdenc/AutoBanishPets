AutoBanishPets = AutoBanishPets or {}
local AutoBanishPets = AutoBanishPets

local LAM2 = LibAddonMenu2

function AutoBanishPets.CreateSettingsWindow()
	local panelData = {
		type = "panel",
		name = "Auto Banish Pets",
		displayName = "Auto Banish Pets",
		author = "@tdenc",
		version = AutoBanishPets.version,
		registerForRefresh = true,
		registerForDefaults = true,
	}
    local cntrlOptionsPanel = LAM2:RegisterAddonPanel("AutoBanishPets_Settings", panelData)

    local savedVariables = AutoBanishPets.savedVariables
    local optionsData = {
        {
            type = "header",
            name = GetString(ABP_NOTIFICATION_NAME),
            width = "full",
        },
        {
			type = "checkbox",
			name = GetString(ABP_NOTIFICATION_NAME),
			tooltip = GetString(ABP_NOTIFICATION_TOOLTIP),
			default = true,
            requiresReload = false,
			getFunc = function() return savedVariables.notification end,
			setFunc = function(newValue)
				AutoBanishPets.savedVariables.notification = newValue
			end,
		},
        {
            type = "header",
            name = GetString(ABP_WHEN_NAME),
            width = "full",
        },
        {
			type = "checkbox",
			name = GetString(ABP_BANK_NAME),
			default = true,
            requiresReload = true,
			getFunc = function() return savedVariables.bank end,
			setFunc = function(newValue)
				AutoBanishPets.savedVariables.bank = newValue
			end,
		},
        {
			type = "checkbox",
			name = GetString(ABP_GUILD_BANK_NAME),
			default = true,
            requiresReload = true,
			getFunc = function() return savedVariables.guildBank end,
			setFunc = function(newValue)
				AutoBanishPets.savedVariables.guildBank = newValue
			end,
		},
        {
			type = "checkbox",
			name = GetString(ABP_STORE_NAME),
			default = true,
            requiresReload = true,
			getFunc = function() return savedVariables.store end,
			setFunc = function(newValue)
				AutoBanishPets.savedVariables.store = newValue
			end,
		},
        {
			type = "checkbox",
			name = GetString(ABP_GUILD_STORE_NAME),
			default = true,
            requiresReload = true,
			getFunc = function() return savedVariables.guildStore end,
			setFunc = function(newValue)
				AutoBanishPets.savedVariables.guildStore = newValue
			end,
		},
        {
			type = "checkbox",
			name = GetString(ABP_FENCE_NAME),
			default = true,
            requiresReload = true,
			getFunc = function() return savedVariables.fence end,
			setFunc = function(newValue)
				AutoBanishPets.savedVariables.fence = newValue
			end,
		},
        {
			type = "checkbox",
			name = GetString(ABP_CRAFT_STATION_NAME),
			default = true,
            requiresReload = true,
			getFunc = function() return savedVariables.craftStation end,
			setFunc = function(newValue)
				AutoBanishPets.savedVariables.craftStation = newValue
			end,
		},
        {
			type = "checkbox",
			name = GetString(ABP_RETRAIT_STATION_NAME),
			default = true,
            requiresReload = true,
			getFunc = function() return savedVariables.retraitStation end,
			setFunc = function(newValue)
				AutoBanishPets.savedVariables.retraitStation = newValue
			end,
		},
        {
			type = "checkbox",
			name = GetString(ABP_DYEING_STATION_NAME),
			default = true,
            requiresReload = true,
			getFunc = function() return savedVariables.dyeingStation end,
			setFunc = function(newValue)
				AutoBanishPets.savedVariables.dyeingStation = newValue
			end,
		},
        {
			type = "checkbox",
			name = GetString(ABP_WAYSHRINE_NAME),
			default = false,
            requiresReload = true,
			getFunc = function() return savedVariables.wayshrine end,
			setFunc = function(newValue)
				AutoBanishPets.savedVariables.wayshrine = newValue
			end,
		},
        {
            type = "header",
			name = GetString(ABP_EXPERIMENTAL_NAME),
            width = "full",
        },
        {
			type = "checkbox",
			name = GetString(ABP_LOGON_NAME),
			tooltip = GetString(ABP_LOGON_TOOLTIP),
			default = false,
            requiresReload = true,
			getFunc = function() return savedVariables.logon end,
			setFunc = function(newValue)
				AutoBanishPets.savedVariables.logon = newValue
			end,
		},
    }
    LAM2:RegisterOptionControls("AutoBanishPets_Settings", optionsData)
end