local stringsDE = {
    -- Name
    ABP_FENCE_NAME = "Hehler",
    ABP_RETRAIT_STATION_NAME = "Transmutationsstelle",
    -- Tooltip
    ABP_BANK_TOOLTIP = "Wenn du eine Bank öffnest",
    ABP_GUILD_BANK_TOOLTIP = "Wenn du eine Gilden Bank öffnest",
    ABP_STORE_TOOLTIP = "Wenn du mit einen Händler interagierst",
    ABP_GUILD_STORE_TOOLTIP = "Wenn du mit einem Gilden Laden interagierst",
    ABP_FENCE_TOOLTIP = "Wenn du mit einem Hehler interagierst",
    ABP_CRAFT_STATION_TOOLTIP = "Wenn du mit einer Handwerksstation interagierst",
    ABP_RETRAIT_STATION_TOOLTIP = "Wenn du mit einer Transmuations-Station interagierst",
    ABP_DYEING_STATION_TOOLTIP = "Wenn du mit einer Montur/Färber Station interagierst",
    ABP_WAYSHRINE_TOOLTIP = "Wenn du mit einem Wegschrein interagierst",
    ABP_QUEST_TOOLTIP = "Beim Erhalten/abschließen einer täglichen Quest",
    ABP_STEALTH_TOOLTIP = "Wenn du schleichen",
    ABP_BEFORE_COMBAT_TOOLTIP = "Wenn du in den Kampf ziehst",
    ABP_AFTER_COMBAT_TOOLTIP = "Wenn du fertig Kampf ziehst",
    ABP_LOGOUT_TOOLTIP = "Wenn du dich ausloggst",
    -- ABP_AFTER_COMBAT_TOOLTIP = "",
    -- Setting
    ABP_NOTIFICATION_PETS = "Deine Kampf Begleiter wurden verbannt!",
    ABP_NOTIFICATION_VANITY_PETS = "Deine Friedliche Begleiter wurden verbannt!",
    ABP_NOTIFICATION_ASSISTANTS = "Deine Assistenten wurden verbannt!",
    ABP_NOTIFICATION_COMPANIONS = "Deine Gefährten wurden verbannt!",
    ABP_NOTIFICATION_RESUMMON_VANITY_PETS = "Deine Friedliche Begleiter sind zurück!",
    ABP_NOTIFICATION_RESUMMON_ASSISTANTS = "Deine Assistenten sind zurück!",
    -- Keybind
    SI_BINDING_NAME_BANISH_ALL = "Verbanne alle",
    SI_BINDING_NAME_BANISH_PETS = "Verbanne Kampf Begleiter",
    SI_BINDING_NAME_BANISH_VANITY_PETS = "Verbanne Kampf Begleiter",
    SI_BINDING_NAME_BANISH_ASSISTANTS = "Verbanne Assistenten",
    SI_BINDING_NAME_BANISH_COMPANIONS = "Verbanne Gefährten",
}

for stringId, stringValue in pairs(stringsDE) do
    SafeAddString(_G[stringId], stringValue, 1)
end