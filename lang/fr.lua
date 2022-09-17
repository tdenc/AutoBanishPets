local stringsFR = {
    -- Name
    ABP_FENCE_NAME = "Receleur",
    ABP_RETRAIT_STATION_NAME = "Atelier de transmutation",
    -- Tooltip
    --ABP_BANK_TOOLTIP = "When you open a bank",
    --ABP_GUILD_BANK_TOOLTIP = "When you open a guild bank",
    --ABP_STORE_TOOLTIP = "When you open a store",
    --ABP_GUILD_STORE_TOOLTIP = "When you open a guild store",
    --ABP_FENCE_TOOLTIP = "When you open a fence",
    --ABP_CRAFT_STATION_TOOLTIP = "When you interact with a craft station",
    --ABP_RETRAIT_STATION_TOOLTIP = "When you interact with a retrait station",
    --ABP_DYEING_STATION_TOOLTIP = "When you interact with a dyeing station",
    --ABP_WAYSHRINE_TOOLTIP = "When you interact with a wayshrine",
    --ABP_QUEST_TOOLTIP = "When you recieve/complete a daily quest",
    --ABP_BEFORE_COMBAT_TOOLTIP = "When you go into combat",
    --ABP_AFTER_COMBAT_TOOLTIP = "When you finish combat",
    --ABP_LOGOUT_TOOLTIP = "When you logout",
    -- Setting
    --ABP_NOTIFICATION_PETS = "Your combat pets were banished!",
    --ABP_NOTIFICATION_VANITY_PETS = "Your non-combat pets were banished!",
    --ABP_NOTIFICATION_ASSISTANTS = "Your assistants were banished!",
    --ABP_NOTIFICATION_COMPANIONS = "Your companions were banished!",
    --ABP_NOTIFICATION_RESUMMON_VANITY_PETS = "Your non-combat pets are back!",
    --ABP_NOTIFICATION_RESUMMON_ASSISTANTS = "Your assistants are back!",
    -- Keybind
    --SI_BINDING_NAME_BANISH_ALL = "Banish all",
    --SI_BINDING_NAME_BANISH_PETS = "Banish combat pets",
    --SI_BINDING_NAME_BANISH_VANITY_PETS = "Banish non-combat pets",
    --SI_BINDING_NAME_BANISH_ASSISTANTS = "Banish assistants",
    --SI_BINDING_NAME_BANISH_COMPANIONS = "Banish companions",
}

for stringId, stringValue in pairs(stringsFR) do
    SafeAddString(_G[stringId], stringValue, 1)
end