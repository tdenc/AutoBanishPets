local stringsEN = {
    -- Name
    ABP_NOTIFICATION_NAME = GetString(SI_MAIN_MENU_NOTIFICATIONS),
    ABP_PETS_NAME = zo_strformat(SI_INTERACT_OPTION_DISMISS_ASSISTANT, GetString(SI_OUTFITSLOT30)),
    ABP_VANITY_PETS_NAME = zo_strformat(SI_INTERACT_OPTION_DISMISS_ASSISTANT, GetString(SI_COLLECTIBLECATEGORYTYPE3)),
    ABP_ASSISTANTS_NAME = zo_strformat(SI_INTERACT_OPTION_DISMISS_ASSISTANT, GetString(SI_COLLECTIBLECATEGORYTYPE8)),
    ABP_COMPANIONS_NAME = zo_strformat(SI_INTERACT_OPTION_DISMISS_ASSISTANT, GetString(SI_COLLECTIBLECATEGORYTYPE27)),
    ABP_BANK_NAME = GetString(SI_INTERACT_OPTION_BANK),
    ABP_GUILD_BANK_NAME = GetString(SI_INTERACT_OPTION_GUILDBANK),
    ABP_STORE_NAME = GetString(SI_INTERACT_OPTION_STORE),
    ABP_GUILD_STORE_NAME = GetString(SI_INTERACT_OPTION_TRADING_HOUSE),
    ABP_FENCE_NAME = "Fence",
    ABP_CRAFT_STATION_NAME = GetString(SI_SPECIALIZEDITEMTYPE213),
    ABP_RETRAIT_STATION_NAME = "Transmute station",
    ABP_DYEING_STATION_NAME = GetString(SI_RESTYLE_STATION_MENU_ROOT_TITLE),
    ABP_WAYSHRINE_NAME = GetString(SI_MAPFILTER8),
    ABP_QUEST_NAME = string.format("%s (%s)", GetString(SI_ITEMTYPEDISPLAYCATEGORY8), GetString(SI_QUESTREPEATABLETYPE2)),
    ABP_BEFORE_COMBAT_NAME = GetString(SI_AUDIO_OPTIONS_COMBAT),
    ABP_AFTER_COMBAT_NAME = GetString(SI_AUDIO_OPTIONS_COMBAT),
    ABP_LOGOUT_NAME = GetString(SI_GAME_MENU_LOGOUT),
    -- Tooltip
    ABP_BANK_TOOLTIP = "When you open a bank",
    ABP_GUILD_BANK_TOOLTIP = "When you open a guild bank",
    ABP_STORE_TOOLTIP = "When you open a store",
    ABP_GUILD_STORE_TOOLTIP = "When you open a guild store",
    ABP_FENCE_TOOLTIP = "When you open a fence",
    ABP_CRAFT_STATION_TOOLTIP = "When you interact with a craft station",
    ABP_RETRAIT_STATION_TOOLTIP = "When you interact with a retrait station",
    ABP_DYEING_STATION_TOOLTIP = "When you interact with a dyeing station",
    ABP_WAYSHRINE_TOOLTIP = "When you interact with a wayshrine",
    ABP_QUEST_TOOLTIP = "When you recieve/complete a daily quest",
    ABP_BEFORE_COMBAT_TOOLTIP = "When you go into combat",
    ABP_AFTER_COMBAT_TOOLTIP = "When you finish combat",
    ABP_LOGOUT_TOOLTIP = "When you logout",
    -- Setting
    ABP_SELECT_OPTION1 = GetString(SI_CHECK_BUTTON_OFF),
    ABP_SELECT_OPTION2 = GetString(SI_CHECK_BUTTON_ON),
    ABP_SELECT_OPTION3 = GetString(SI_GAMEPAD_TOGGLE_OPTION),
    ABP_NOTIFICATION_PETS = "Your combat pets were banished!",
    ABP_NOTIFICATION_VANITY_PETS = "Your non-combat pets were banished!",
    ABP_NOTIFICATION_ASSISTANTS = "Your assistants were banished!",
    ABP_NOTIFICATION_COMPANIONS = "Your companions were banished!",
    ABP_NOTIFICATION_RESUMMON_VANITY_PETS = "Your non-combat pets are back!",
    ABP_NOTIFICATION_RESUMMON_ASSISTANTS = "Your assistants are back!",
    -- Keybind
    SI_BINDING_NAME_BANISH_ALL = "Banish all",
    SI_BINDING_NAME_BANISH_PETS = "Banish combat pets",
    SI_BINDING_NAME_BANISH_VANITY_PETS = "Banish non-combat pets",
    SI_BINDING_NAME_BANISH_ASSISTANTS = "Banish assistants",
    SI_BINDING_NAME_BANISH_COMPANIONS = "Banish companions",
}

for stringId, stringValue in pairs(stringsEN) do
    ZO_CreateStringId(stringId, stringValue)
    SafeAddVersion(stringId, 1)
end