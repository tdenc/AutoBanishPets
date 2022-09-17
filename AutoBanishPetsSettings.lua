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
        website = "https://www.esoui.com/downloads/info3099-AutoBanishPets.html",
    }
    local cntrlOptionsPanel = LAM2:RegisterAddonPanel("AutoBanishPets_Settings", panelData)

    local selectOptions = {
        [1] = GetString(ABP_SELECT_OPTION1),
        [2] = GetString(ABP_SELECT_OPTION2),
        [3] = GetString(ABP_SELECT_OPTION3),
    }
    local selectOptionValues = {
        [1] = 1,
        [2] = 2,
        [3] = 3,
    }
    local companionNames = {
        [1] = GetCollectibleName(AutoBanishPets.companions[1]),
        [2] = GetCollectibleName(AutoBanishPets.companions[2]),
    }

    local sV = AutoBanishPets.savedVariables
    local optionsData = {
        {
            type = "header",
            name = GetString(ABP_WHEN_NAME),
            width = "full",
        },
        {
            type = "submenu", name = GetString(ABP_PETS_NAME), controls = {
                {
                    type = "checkbox",
                    name = GetString(ABP_BANK_NAME),
                    tooltip = GetString(ABP_BANK_TOOLTIP),
                    default = true,
                    requiresReload = false,
                    getFunc = function() return sV.bank.pets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.bank.pets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_GUILD_BANK_NAME),
                    tooltip = GetString(ABP_GUILD_BANK_TOOLTIP),
                    default = true,
                    requiresReload = false,
                    getFunc = function() return sV.guildBank.pets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.guildBank.pets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_STORE_NAME),
                    tooltip = GetString(ABP_STORE_TOOLTIP),
                    default = true,
                    requiresReload = false,
                    getFunc = function() return sV.store.pets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.store.pets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_GUILD_STORE_NAME),
                    tooltip = GetString(ABP_GUILD_STORE_TOOLTIP),
                    default = true,
                    requiresReload = false,
                    getFunc = function() return sV.guildStore.pets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.guildStore.pets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_FENCE_NAME),
                    tooltip = GetString(ABP_FENCE_TOOLTIP),
                    default = true,
                    requiresReload = false,
                    getFunc = function() return sV.fence.pets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.fence.pets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_CRAFT_STATION_NAME),
                    tooltip = GetString(ABP_CRAFT_STATION_TOOLTIP),
                    default = true,
                    requiresReload = false,
                    getFunc = function() return sV.craftStation.pets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.craftStation.pets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_RETRAIT_STATION_NAME),
                    tooltip = GetString(ABP_RETRAIT_STATION_TOOLTIP),
                    default = true,
                    requiresReload = false,
                    getFunc = function() return sV.retraitStation.pets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.retraitStation.pets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_DYEING_STATION_NAME),
                    tooltip = GetString(ABP_DYEING_STATION_TOOLTIP),
                    default = true,
                    requiresReload = false,
                    getFunc = function() return sV.dyeingStation.pets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.dyeingStation.pets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_WAYSHRINE_NAME),
                    tooltip = GetString(ABP_WAYSHRINE_TOOLTIP),
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.wayshrine.pets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.wayshrine.pets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_QUEST_NAME),
                    tooltip = GetString(ABP_QUEST_TOOLTIP),
                    default = true,
                    requiresReload = false,
                    getFunc = function() return sV.quest.pets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.quest.pets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_STEALTH_NAME),
                    tooltip = GetString(ABP_STEALTH_TOOLTIP),
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.stealth.pets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.stealth.pets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_AFTER_COMBAT_NAME),
                    tooltip = GetString(ABP_AFTER_COMBAT_TOOLTIP),
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.combat.pets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.combat.pets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_LOGOUT_NAME),
                    tooltip = GetString(ABP_LOGOUT_TOOLTIP),
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.logout.pets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.logout.pets = newValue
                    end,
                },
            }
        },
        {
            type = "submenu", name = GetString(ABP_VANITY_PETS_NAME), controls = {
                {
                    type = "checkbox",
                    name = GetString(ABP_BANK_NAME),
                    tooltip = GetString(ABP_BANK_TOOLTIP),
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.bank.vanityPets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.bank.vanityPets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_GUILD_BANK_NAME),
                    tooltip = GetString(ABP_GUILD_BANK_TOOLTIP),
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.guildBank.vanityPets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.guildBank.vanityPets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_STORE_NAME),
                    tooltip = GetString(ABP_STORE_TOOLTIP),
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.store.vanityPets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.store.vanityPets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_GUILD_STORE_NAME),
                    tooltip = GetString(ABP_GUILD_STORE_TOOLTIP),
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.guildStore.vanityPets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.guildStore.vanityPets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_FENCE_NAME),
                    tooltip = GetString(ABP_FENCE_TOOLTIP),
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.fence.vanityPets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.fence.vanityPets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_CRAFT_STATION_NAME),
                    tooltip = GetString(ABP_CRAFT_STATION_TOOLTIP),
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.craftStation.vanityPets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.craftStation.vanityPets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_RETRAIT_STATION_NAME),
                    tooltip = GetString(ABP_RETRAIT_STATION_TOOLTIP),
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.retraitStation.vanityPets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.retraitStation.vanityPets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_DYEING_STATION_NAME),
                    tooltip = GetString(ABP_DYEING_STATION_TOOLTIP),
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.dyeingStation.vanityPets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.dyeingStation.vanityPets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_WAYSHRINE_NAME),
                    tooltip = GetString(ABP_WAYSHRINE_TOOLTIP),
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.wayshrine.vanityPets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.wayshrine.vanityPets = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_QUEST_NAME),
                    tooltip = GetString(ABP_QUEST_TOOLTIP),
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.quest.vanityPets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.quest.vanityPets = newValue
                    end,
                },
                {
                    type = "dropdown",
                    name = GetString(ABP_STEALTH_NAME),
                    tooltip = GetString(ABP_STEALTH_TOOLTIP),
                    default = 1,
                    requiresReload = false,
                    choices = selectOptions,
                    choicesValues = selectOptionValues,
                    getFunc = function() return sV.stealth.vanityPets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.vanityPets.pets = newValue
                    end,
                },
                {
                    type = "dropdown",
                    name = GetString(ABP_BEFORE_COMBAT_NAME),
                    tooltip = GetString(ABP_BEFORE_COMBAT_TOOLTIP),
                    default = 2,
                    requiresReload = false,
                    choices = selectOptions,
                    choicesValues = selectOptionValues,
                    getFunc = function() return sV.combat.vanityPets end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.combat.vanityPets = newValue
                    end,
                },
            }
        },
        {
            type = "submenu", name = GetString(ABP_ASSISTANTS_NAME), controls = {
                {
                    type = "checkbox",
                    name = GetString(ABP_GUILD_BANK_NAME),
                    tooltip = GetString(ABP_GUILD_BANK_TOOLTIP),
                    default = true,
                    requiresReload = false,
                    getFunc = function() return sV.guildBank.assistants end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.guildBank.assistants = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_GUILD_STORE_NAME),
                    tooltip = GetString(ABP_GUILD_STORE_TOOLTIP),
                    default = true,
                    requiresReload = false,
                    getFunc = function() return sV.guildStore.assistants end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.guildStore.assistants = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_CRAFT_STATION_NAME),
                    tooltip = GetString(ABP_CRAFT_STATION_TOOLTIP),
                    default = true,
                    requiresReload = false,
                    getFunc = function() return sV.craftStation.assistants end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.craftStation.assistants = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_RETRAIT_STATION_NAME),
                    tooltip = GetString(ABP_RETRAIT_STATION_TOOLTIP),
                    default = true,
                    requiresReload = false,
                    getFunc = function() return sV.retraitStation.assistants end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.retraitStation.assistants = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_DYEING_STATION_NAME),
                    tooltip = GetString(ABP_DYEING_STATION_TOOLTIP),
                    default = true,
                    requiresReload = false,
                    getFunc = function() return sV.dyeingStation.assistants end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.dyeingStation.assistants = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_WAYSHRINE_NAME),
                    tooltip = GetString(ABP_WAYSHRINE_TOOLTIP),
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.wayshrine.assistants end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.wayshrine.assistants = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = GetString(ABP_QUEST_NAME),
                    tooltip = GetString(ABP_QUEST_TOOLTIP),
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.quest.assistants end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.quest.assistants = newValue
                    end,
                },
                {
                    type = "dropdown",
                    name = GetString(ABP_STEALTH_NAME),
                    tooltip = GetString(ABP_STEALTH_TOOLTIP),
                    default = 1,
                    requiresReload = false,
                    choices = selectOptions,
                    choicesValues = selectOptionValues,
                    getFunc = function() return sV.stealth.assistants end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.stealth.assistants = newValue
                    end,
                },
                {
                    type = "dropdown",
                    name = GetString(ABP_BEFORE_COMBAT_NAME),
                    tooltip = GetString(ABP_BEFORE_COMBAT_TOOLTIP),
                    default = 2,
                    requiresReload = false,
                    choices = selectOptions,
                    choicesValues = selectOptionValues,
                    getFunc = function() return sV.combat.assistants end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.combat.assistants = newValue
                    end,
                },
            }
        },
        {
            type = "submenu", name = GetString(ABP_COMPANIONS_NAME), controls = {
                {
                    type = "header",
                    name = GetString(ABP_BANK_NAME),
                    width = "full",
                },
                {
                    type = "checkbox",
                    name = companionNames[1],
                    tooltip = GetString(ABP_BANK_TOOLTIP),
                    width = "half",
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.bank[AutoBanishPets.companions[1]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.bank[AutoBanishPets.companions[1]] = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = companionNames[2],
                    tooltip = GetString(ABP_BANK_TOOLTIP),
                    width = "half",
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.bank[AutoBanishPets.companions[2]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.bank[AutoBanishPets.companions[2]] = newValue
                    end,
                },
                {
                    type = "header",
                    name = GetString(ABP_GUILD_BANK_NAME),
                    width = "full",
                },
                {
                    type = "checkbox",
                    name = companionNames[1],
                    tooltip = GetString(ABP_GUILD_BANK_TOOLTIP),
                    width = "half",
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.guildBank[AutoBanishPets.companions[1]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.guildBank[AutoBanishPets.companions[1]] = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = companionNames[2],
                    tooltip = GetString(ABP_GUILD_BANK_TOOLTIP),
                    width = "half",
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.guildBank[AutoBanishPets.companions[2]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.guildBank[AutoBanishPets.companions[2]] = newValue
                    end,
                },
                {
                    type = "header",
                    name = GetString(ABP_STORE_NAME),
                    width = "full",
                },
                {
                    type = "checkbox",
                    name = companionNames[1],
                    tooltip = GetString(ABP_STORE_TOOLTIP),
                    width = "half",
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.store[AutoBanishPets.companions[1]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.store[AutoBanishPets.companions[1]] = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = companionNames[2],
                    tooltip = GetString(ABP_STORE_TOOLTIP),
                    width = "half",
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.store[AutoBanishPets.companions[2]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.store[AutoBanishPets.companions[2]] = newValue
                    end,
                },
                {
                    type = "header",
                    name = GetString(ABP_GUILD_STORE_NAME),
                    width = "full",
                },
                {
                    type = "checkbox",
                    name = companionNames[1],
                    tooltip = GetString(ABP_GUILD_STORE_TOOLTIP),
                    width = "half",
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.guildStore[AutoBanishPets.companions[1]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.guildStore[AutoBanishPets.companions[1]] = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = companionNames[2],
                    tooltip = GetString(ABP_GUILD_STORE_TOOLTIP),
                    width = "half",
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.guildStore[AutoBanishPets.companions[2]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.guildStore[AutoBanishPets.companions[2]] = newValue
                    end,
                },
                {
                    type = "header",
                    name = GetString(ABP_FENCE_NAME),
                    width = "full",
                },
                {
                    type = "checkbox",
                    name = companionNames[1],
                    tooltip = GetString(ABP_FENCE_TOOLTIP),
                    width = "half",
                    default = true,
                    requiresReload = false,
                    getFunc = function() return sV.fence[AutoBanishPets.companions[1]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.fence[AutoBanishPets.companions[1]] = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = companionNames[2],
                    tooltip = GetString(ABP_FENCE_TOOLTIP),
                    width = "half",
                    default = true,
                    requiresReload = false,
                    getFunc = function() return sV.fence[AutoBanishPets.companions[2]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.fence[AutoBanishPets.companions[2]] = newValue
                    end,
                },
                {
                    type = "header",
                    name = GetString(ABP_CRAFT_STATION_NAME),
                    width = "full",
                },
                {
                    type = "checkbox",
                    name = companionNames[1],
                    tooltip = GetString(ABP_CRAFT_STATION_TOOLTIP),
                    width = "half",
                    default = true,
                    requiresReload = false,
                    getFunc = function() return sV.craftStation[AutoBanishPets.companions[1]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.craftStation[AutoBanishPets.companions[1]] = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = companionNames[2],
                    tooltip = GetString(ABP_CRAFT_STATION_TOOLTIP),
                    width = "half",
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.craftStation[AutoBanishPets.companions[2]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.craftStation[AutoBanishPets.companions[2]] = newValue
                    end,
                },
                {
                    type = "header",
                    name = GetString(ABP_RETRAIT_STATION_NAME),
                    width = "full",
                },
                {
                    type = "checkbox",
                    name = companionNames[1],
                    tooltip = GetString(ABP_RETRAIT_STATION_TOOLTIP),
                    width = "half",
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.retraitStation[AutoBanishPets.companions[1]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.retraitStation[AutoBanishPets.companions[1]] = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = companionNames[2],
                    tooltip = GetString(ABP_RETRAIT_STATION_TOOLTIP),
                    width = "half",
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.retraitStation[AutoBanishPets.companions[2]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.retraitStation[AutoBanishPets.companions[2]] = newValue
                    end,
                },
                {
                    type = "header",
                    name = GetString(ABP_DYEING_STATION_NAME),
                    width = "full",
                },
                {
                    type = "checkbox",
                    name = companionNames[1],
                    tooltip = GetString(ABP_DYEING_STATION_TOOLTIP),
                    width = "half",
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.dyeingStation[AutoBanishPets.companions[1]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.dyeingStation[AutoBanishPets.companions[1]] = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = companionNames[2],
                    tooltip = GetString(ABP_DYEING_STATION_TOOLTIP),
                    width = "half",
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.dyeingStation[AutoBanishPets.companions[2]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.dyeingStation[AutoBanishPets.companions[2]] = newValue
                    end,
                },
                {
                    type = "header",
                    name = GetString(ABP_WAYSHRINE_NAME),
                    width = "full",
                },
                {
                    type = "checkbox",
                    name = companionNames[1],
                    tooltip = GetString(ABP_WAYSHRINE_TOOLTIP),
                    width = "half",
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.wayshrine[AutoBanishPets.companions[1]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.wayshrine[AutoBanishPets.companions[1]] = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = companionNames[2],
                    tooltip = GetString(ABP_WAYSHRINE_TOOLTIP),
                    width = "half",
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.wayshrine[AutoBanishPets.companions[2]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.wayshrine[AutoBanishPets.companions[2]] = newValue
                    end,
                },
                {
                    type = "header",
                    name = GetString(ABP_QUEST_NAME),
                    width = "full",
                },
                {
                    type = "checkbox",
                    name = companionNames[1],
                    tooltip = GetString(ABP_QUEST_TOOLTIP),
                    width = "half",
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.quest[AutoBanishPets.companions[1]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.quest[AutoBanishPets.companions[1]] = newValue
                    end,
                },
                {
                    type = "checkbox",
                    name = companionNames[2],
                    tooltip = GetString(ABP_QUEST_TOOLTIP),
                    width = "half",
                    default = false,
                    requiresReload = false,
                    getFunc = function() return sV.quest[AutoBanishPets.companions[2]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.quest[AutoBanishPets.companions[2]] = newValue
                    end,
                },
                {
                    type = "header",
                    name = GetString(ABP_STEALTH_NAME),
                    width = "full",
                },
                {
                    type = "dropdown",
                    name = companionNames[1],
                    tooltip = GetString(ABP_STEALTH_TOOLTIP),
                    width = "half",
                    default = 2,
                    requiresReload = false,
                    choices = selectOptions,
                    choicesValues = selectOptionValues,
                    getFunc = function() return sV.stealth.companions[AutoBanishPets.companions[1]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.stealth.companions[AutoBanishPets.companions[1]] = newValue
                    end,
                },
                {
                    type = "dropdown",
                    name = companionNames[2],
                    tooltip = GetString(ABP_STEALTH_TOOLTIP),
                    width = "half",
                    default = 2,
                    requiresReload = false,
                    choices = selectOptions,
                    choicesValues = selectOptionValues,
                    getFunc = function() return sV.stealth.companions[AutoBanishPets.companions[2]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.stealth.companions[AutoBanishPets.companions[2]] = newValue
                    end,
                },
                {
                    type = "header",
                    name = GetString(ABP_AFTER_COMBAT_NAME),
                    width = "full",
                },
                {
                    type = "dropdown",
                    name = companionNames[1],
                    tooltip = GetString(ABP_AFTER_COMBAT_TOOLTIP),
                    width = "half",
                    default = 1,
                    requiresReload = false,
                    choices = selectOptions,
                    choicesValues = selectOptionValues,
                    getFunc = function() return sV.combat.companions[AutoBanishPets.companions[1]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.combat.companions[AutoBanishPets.companions[1]] = newValue
                    end,
                },
                {
                    type = "dropdown",
                    name = companionNames[2],
                    tooltip = GetString(ABP_AFTER_COMBAT_TOOLTIP),
                    width = "half",
                    default = 1,
                    requiresReload = false,
                    choices = selectOptions,
                    choicesValues = selectOptionValues,
                    getFunc = function() return sV.combat.companions[AutoBanishPets.companions[2]] end,
                    setFunc = function(newValue)
                        AutoBanishPets.savedVariables.combat.companions[AutoBanishPets.companions[2]] = newValue
                    end,
                },
            },
        },
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
            getFunc = function() return sV.notification end,
            setFunc = function(newValue)
                AutoBanishPets.savedVariables.notification = newValue
            end,
        },
    }
    LAM2:RegisterOptionControls("AutoBanishPets_Settings", optionsData)
end