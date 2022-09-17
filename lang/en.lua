local stringsEN = {
    ABP_WHEN_NAME = "When to banish:",
    ABP_PETS_NAME = "Combat pets",
    ABP_ASSISTANTS_NAME = "Assistants",
    ABP_BANK_NAME = "Bank",
    ABP_BANK_TOOLTIP = "When you open a bank",
    ABP_GUILD_BANK_NAME = "Guild bank",
    ABP_GUILD_BANK_TOOLTIP = "When you open a guild bank",
    ABP_STORE_NAME = "Store",
    ABP_STORE_TOOLTIP = "When you open a store",
    ABP_GUILD_STORE_NAME = "Guild store",
    ABP_GUILD_STORE_TOOLTIP = "When you open a guild store",
    ABP_FENCE_NAME = "Fence",
    ABP_FENCE_TOOLTIP = "When you open a fence",
    ABP_CRAFT_STATION_NAME = "Craft station",
    ABP_CRAFT_STATION_TOOLTIP = "When you interact with a craft station",
    ABP_RETRAIT_STATION_NAME = "Retrait station",
    ABP_RETRAIT_STATION_TOOLTIP = "When you interact with a retrait station",
    ABP_DYEING_STATION_NAME = "Dyeing station",
    ABP_DYEING_STATION_TOOLTIP = "When you interact with a dyeing station",
    ABP_WAYSHRINE_NAME = "Wayshrine",
    ABP_WAYSHRINE_TOOLTIP = "When you interact with a wayshrine",
    ABP_QUEST_NAME = "Daily quest",
    ABP_QUEST_TOOLTIP = "When you recieve/complete a daily quest",
    ABP_COMBAT_NAME = "Combat",
    ABP_COMBAT_TOOLTIP = "When you go into combat",
    ABP_NOTIFICATION_NAME = "Notification",
    ABP_NOTIFICATION_TOOLTIP = "Notify messages in chat when banished",
    ABP_NOTIFICATION_PETS = "Your pets were banished!",
    ABP_NOTIFICATION_ASSISTANTS = "Your assistants were banished!",
    SI_BINDING_NAME_BANISH_ALL = "Banish all manually",
    SI_BINDING_NAME_BANISH_PETS = "Banish pets manually",
    SI_BINDING_NAME_BANISH_ASSISTANTS = "Banish assistants manually",
}

for stringId, stringValue in pairs(stringsEN) do
    ZO_CreateStringId(stringId, stringValue)
    SafeAddVersion(stringId, 1)
end