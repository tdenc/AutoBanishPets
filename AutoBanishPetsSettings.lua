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
			type = "submenu", name = GetString(ABP_PETS_NAME), controls = {
				{
					type = "header",
					name = GetString(ABP_WHEN_NAME),
					width = "full",
				},
				{
					type = "checkbox",
					name = GetString(ABP_BANK_NAME),
					tooltip = GetString(ABP_BANK_TOOLTIP),
					default = true,
					requiresReload = true,
					getFunc = function() return savedVariables.pets.bank end,
					setFunc = function(newValue)
						AutoBanishPets.savedVariables.pets.bank = newValue
					end,
				},
				{
					type = "checkbox",
					name = GetString(ABP_GUILD_BANK_NAME),
					tooltip = GetString(ABP_GUILD_BANK_TOOLTIP),
					default = true,
					requiresReload = true,
					getFunc = function() return savedVariables.pets.guildBank end,
					setFunc = function(newValue)
						AutoBanishPets.savedVariables.pets.guildBank = newValue
					end,
				},
				{
					type = "checkbox",
					name = GetString(ABP_STORE_NAME),
					tooltip = GetString(ABP_STORE_TOOLTIP),
					default = true,
					requiresReload = true,
					getFunc = function() return savedVariables.pets.store end,
					setFunc = function(newValue)
						AutoBanishPets.savedVariables.pets.store = newValue
					end,
				},
				{
					type = "checkbox",
					name = GetString(ABP_GUILD_STORE_NAME),
					tooltip = GetString(ABP_GUILD_STORE_TOOLTIP),
					default = true,
					requiresReload = true,
					getFunc = function() return savedVariables.pets.guildStore end,
					setFunc = function(newValue)
						AutoBanishPets.savedVariables.pets.guildStore = newValue
					end,
				},
				{
					type = "checkbox",
					name = GetString(ABP_FENCE_NAME),
					tooltip = GetString(ABP_FENCE_TOOLTIP),
					default = true,
					requiresReload = true,
					getFunc = function() return savedVariables.pets.fence end,
					setFunc = function(newValue)
						AutoBanishPets.savedVariables.pets.fence = newValue
					end,
				},
				{
					type = "checkbox",
					name = GetString(ABP_CRAFT_STATION_NAME),
					tooltip = GetString(ABP_CRAFT_STATION_TOOLTIP),
					default = true,
					requiresReload = true,
					getFunc = function() return savedVariables.pets.craftStation end,
					setFunc = function(newValue)
						AutoBanishPets.savedVariables.pets.craftStation = newValue
					end,
				},
				{
					type = "checkbox",
					name = GetString(ABP_RETRAIT_STATION_NAME),
					tooltip = GetString(ABP_RETRAIT_STATION_TOOLTIP),
					default = true,
					requiresReload = true,
					getFunc = function() return savedVariables.pets.retraitStation end,
					setFunc = function(newValue)
						AutoBanishPets.savedVariables.pets.retraitStation = newValue
					end,
				},
				{
					type = "checkbox",
					name = GetString(ABP_DYEING_STATION_NAME),
					tooltip = GetString(ABP_DYEING_STATION_TOOLTIP),
					default = true,
					requiresReload = true,
					getFunc = function() return savedVariables.pets.dyeingStation end,
					setFunc = function(newValue)
						AutoBanishPets.savedVariables.pets.dyeingStation = newValue
					end,
				},
				{
					type = "checkbox",
					name = GetString(ABP_WAYSHRINE_NAME),
					tooltip = GetString(ABP_WAYSHRINE_TOOLTIP),
					default = false,
					requiresReload = true,
					getFunc = function() return savedVariables.pets.wayshrine end,
					setFunc = function(newValue)
						AutoBanishPets.savedVariables.pets.wayshrine = newValue
					end,
				},
				{
					type = "checkbox",
					name = GetString(ABP_QUEST_NAME),
					tooltip = GetString(ABP_QUEST_TOOLTIP),
					default = false,
					requiresReload = true,
					getFunc = function() return savedVariables.pets.quest end,
					setFunc = function(newValue)
						AutoBanishPets.savedVariables.pets.quest = newValue
					end,
				},
			}
		},
		{
			type = "submenu", name = GetString(ABP_ASSISTANTS_NAME), controls = {
				{
					type = "header",
					name = GetString(ABP_WHEN_NAME),
					width = "full",
				},
				{
					type = "checkbox",
					name = GetString(ABP_CRAFT_STATION_NAME),
					tooltip = GetString(ABP_CRAFT_STATION_TOOLTIP),
					default = true,
					requiresReload = true,
					getFunc = function() return savedVariables.assistants.craftStation end,
					setFunc = function(newValue)
						AutoBanishPets.savedVariables.assistants.craftStation = newValue
					end,
				},
				{
					type = "checkbox",
					name = GetString(ABP_RETRAIT_STATION_NAME),
					tooltip = GetString(ABP_RETRAIT_STATION_TOOLTIP),
					default = true,
					requiresReload = true,
					getFunc = function() return savedVariables.assistants.retraitStation end,
					setFunc = function(newValue)
						AutoBanishPets.savedVariables.assistants.retraitStation = newValue
					end,
				},
				{
					type = "checkbox",
					name = GetString(ABP_DYEING_STATION_NAME),
					tooltip = GetString(ABP_DYEING_STATION_TOOLTIP),
					default = true,
					requiresReload = true,
					getFunc = function() return savedVariables.assistants.dyeingStation end,
					setFunc = function(newValue)
						AutoBanishPets.savedVariables.assistants.dyeingStation = newValue
					end,
				},
				{
					type = "checkbox",
					name = GetString(ABP_WAYSHRINE_NAME),
					tooltip = GetString(ABP_WAYSHRINE_TOOLTIP),
					default = false,
					requiresReload = true,
					getFunc = function() return savedVariables.assistants.wayshrine end,
					setFunc = function(newValue)
						AutoBanishPets.savedVariables.assistants.wayshrine = newValue
					end,
				},
				{
					type = "checkbox",
					name = GetString(ABP_QUEST_NAME),
					tooltip = GetString(ABP_QUEST_TOOLTIP),
					default = false,
					requiresReload = true,
					getFunc = function() return savedVariables.assistants.quest end,
					setFunc = function(newValue)
						AutoBanishPets.savedVariables.assistants.quest = newValue
					end,
				},
				{
					type = "checkbox",
					name = GetString(ABP_COMBAT_NAME),
					tooltip = GetString(ABP_COMBAT_TOOLTIP),
					default = false,
					requiresReload = true,
					getFunc = function() return savedVariables.assistants.combat end,
					setFunc = function(newValue)
						AutoBanishPets.savedVariables.assistants.combat = newValue
					end,
				},
			}
		}
    }
    LAM2:RegisterOptionControls("AutoBanishPets_Settings", optionsData)
end