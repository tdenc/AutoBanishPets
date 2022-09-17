AutoBanishPets = AutoBanishPets or {}
local AutoBanishPets = AutoBanishPets

local function getHeader(name)
    return {
        ["type"] = "header",
        ["name"] = name,
        ["width"] = "full",
    }
end

local function getCheckBox(name, tooltip, default, requiresReload, settingVariable, width)
    return {
        ["type"] = "checkbox",
        ["name"] = name,
        ["tooltip"] = tooltip,
        ["default"] = default,
        ["requiresReload"] = requiresReload,
        ["getFunc"] = function() return settingVariable end,
        ["setFunc"] = function(newValue) settingVariable = newValue end,
        ["width"] = width,
    }
end

local function getDropDown(name, tooltip, default, requiresReload, choices, choicesValues, settingVariable, width)
    return {
        ["type"] = "dropdown",
        ["name"] = name,
        ["tooltip"] = tooltip,
        ["default"] = default,
        ["requiresReload"] = requiresReload,
        ["choices"] = choices,
        ["choicesValues"] = choicesValues,
        ["getFunc"] = function() return settingVariable end,
        ["setFunc"] = function(newValue) settingVariable = newValue end,
        ["width"] = width,
    }
end

function AutoBanishPets.CreateSettingsWindow()
    local LAM2 = LibAddonMenu2
    local panelData = {
        type = "panel",
        name = "Auto Banish Pets",
        displayName = "Auto Banish Pets/Assistants/Companions",
        author = "@tdenc",
        version = AutoBanishPets.version,
        slashCommand = "/abpsetting",
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

    local dislikeLocationNames = {
        [1] = "",
        [2] = "",
    }
    for index, id in pairs(AutoBanishPets.companions) do
        for zoneId, _ in pairs(AutoBanishPets.dislikeLocations[id]) do
            dislikeLocationNames[index] = string.format("%s %s,", dislikeLocationNames[index], GetZoneNameById(zoneId))
        end
        if dislikeLocationNames[index] ~= "" then
            dislikeLocationNames[index] = string.sub(dislikeLocationNames[index], 2, -2) -- strip
        end
    end

    local dS = AutoBanishPets.defaultSettings
    local sV = AutoBanishPets.savedVariables
    local optionsData = {
        {
            type = "submenu", name = GetString(ABP_PETS_NAME), controls = {
                getCheckBox(GetString(ABP_BANK_NAME), GetString(ABP_BANK_TOOLTIP), dS.bank.pets, false, sV.bank.pets, "full"),
                getCheckBox(GetString(ABP_GUILD_BANK_NAME), GetString(ABP_GUILD_BANK_TOOLTIP), dS.guildBank.pets, false, sV.guildBank.pets, "full"),
                getCheckBox(GetString(ABP_STORE_NAME), GetString(ABP_STORE_TOOLTIP), dS.store.pets, false, sV.store.pets, "full"),
                getCheckBox(GetString(ABP_GUILD_STORE_NAME), GetString(ABP_GUILD_STORE_TOOLTIP), dS.guildStore.pets, false, sV.guildStore.pets, "full"),
                getCheckBox(GetString(ABP_FENCE_NAME), GetString(ABP_FENCE_TOOLTIP), dS.fence.pets, false, sV.fence.pets, "full"),
                getCheckBox(GetString(ABP_CRAFT_STATION_NAME), GetString(ABP_CRAFT_STATION_TOOLTIP), dS.craftStation.pets, false, sV.craftStation.pets, "full"),
                getCheckBox(GetString(ABP_RETRAIT_STATION_NAME), GetString(ABP_RETRAIT_STATION_TOOLTIP), dS.retraitStation.pets, false, sV.retraitStation.pets, "full"),
                getCheckBox(GetString(ABP_DYEING_STATION_NAME), GetString(ABP_DYEING_STATION_TOOLTIP), dS.dyeingStation.pets, false, sV.dyeingStation.pets, "full"),
                getCheckBox(GetString(ABP_WAYSHRINE_NAME), GetString(ABP_WAYSHRINE_TOOLTIP), dS.wayshrine.pets, false, sV.wayshrine.pets, "full"),
                getCheckBox(GetString(ABP_QUEST_NAME), GetString(ABP_QUEST_TOOLTIP), dS.quest.pets, false, sV.quest.pets, "full"),
                getCheckBox(GetString(ABP_STEALTH_NAME), GetString(ABP_STEALTH_TOOLTIP), dS.stealth.pets, false, sV.stealth.pets, "full"),
                getCheckBox(GetString(ABP_AFTER_COMBAT_NAME), GetString(ABP_AFTER_COMBAT_TOOLTIP), dS.combat.pets, false, sV.combat.pets, "full"),
                getCheckBox(GetString(ABP_LOGOUT_NAME), GetString(ABP_LOGOUT_TOOLTIP), dS.logout.pets, false, sV.logout.pets, "full"),
            }
        },
        {
            type = "submenu", name = GetString(ABP_VANITY_PETS_NAME), controls = {
                getCheckBox(GetString(ABP_BANK_NAME), GetString(ABP_BANK_TOOLTIP), dS.bank.vanityPets, false, sV.bank.vanityPets, "full"),
                getCheckBox(GetString(ABP_GUILD_BANK_NAME), GetString(ABP_GUILD_BANK_TOOLTIP), dS.guildBank.vanityPets, false, sV.guildBank.vanityPets, "full"),
                getCheckBox(GetString(ABP_STORE_NAME), GetString(ABP_STORE_TOOLTIP), dS.store.vanityPets, false, sV.store.vanityPets, "full"),
                getCheckBox(GetString(ABP_GUILD_STORE_NAME), GetString(ABP_GUILD_STORE_TOOLTIP), dS.guildStore.vanityPets, false, sV.guildStore.vanityPets, "full"),
                getCheckBox(GetString(ABP_FENCE_NAME), GetString(ABP_FENCE_TOOLTIP), dS.fence.vanityPets, false, sV.fence.vanityPets, "full"),
                getCheckBox(GetString(ABP_CRAFT_STATION_NAME), GetString(ABP_CRAFT_STATION_TOOLTIP), dS.craftStation.vanityPets, false, sV.craftStation.vanityPets, "full"),
                getCheckBox(GetString(ABP_RETRAIT_STATION_NAME), GetString(ABP_RETRAIT_STATION_TOOLTIP), dS.retraitStation.vanityPets, false, sV.retraitStation.vanityPets, "full"),
                getCheckBox(GetString(ABP_DYEING_STATION_NAME), GetString(ABP_DYEING_STATION_TOOLTIP), dS.dyeingStation.vanityPets, false, sV.dyeingStation.vanityPets, "full"),
                getCheckBox(GetString(ABP_WAYSHRINE_NAME), GetString(ABP_WAYSHRINE_TOOLTIP), dS.wayshrine.vanityPets, false, sV.wayshrine.vanityPets, "full"),
                getCheckBox(GetString(ABP_QUEST_NAME), GetString(ABP_QUEST_TOOLTIP), dS.quest.vanityPets, false, sV.quest.vanityPets, "full"),
                getDropDown(GetString(ABP_STEALTH_NAME), GetString(ABP_STEALTH_TOOLTIP), dS.stealth.vanityPets, false, selectOptions, selectOptionValues, sV.stealth.vanityPets, "full"),
                getDropDown(GetString(ABP_BEFORE_COMBAT_NAME), GetString(ABP_BEFORE_COMBAT_TOOLTIP), dS.combat.vanityPets, false, selectOptions, selectOptionValues, sV.combat.vanityPets, "full"),
            }
        },
        {
            type = "submenu", name = GetString(ABP_ASSISTANTS_NAME), controls = {
                getCheckBox(GetString(ABP_GUILD_BANK_NAME), GetString(ABP_GUILD_BANK_TOOLTIP), dS.guildBank.assistants, false, sV.guildBank.assistants, "full"),
                getCheckBox(GetString(ABP_GUILD_STORE_NAME), GetString(ABP_GUILD_STORE_TOOLTIP), dS.guildStore.assistants, false, sV.guildStore.assistants, "full"),
                getCheckBox(GetString(ABP_CRAFT_STATION_NAME), GetString(ABP_CRAFT_STATION_TOOLTIP), dS.craftStation.assistants, false, sV.craftStation.assistants, "full"),
                getCheckBox(GetString(ABP_RETRAIT_STATION_NAME), GetString(ABP_RETRAIT_STATION_TOOLTIP), dS.retraitStation.assistants, false, sV.retraitStation.assistants, "full"),
                getCheckBox(GetString(ABP_DYEING_STATION_NAME), GetString(ABP_DYEING_STATION_TOOLTIP), dS.dyeingStation.assistants, false, sV.dyeingStation.assistants, "full"),
                getCheckBox(GetString(ABP_WAYSHRINE_NAME), GetString(ABP_WAYSHRINE_TOOLTIP), dS.wayshrine.assistants, false, sV.wayshrine.assistants, "full"),
                getCheckBox(GetString(ABP_QUEST_NAME), GetString(ABP_QUEST_TOOLTIP), dS.quest.assistants, false, sV.quest.assistants, "full"),
                getDropDown(GetString(ABP_STEALTH_NAME), GetString(ABP_STEALTH_TOOLTIP), dS.stealth.assistants, false, selectOptions, selectOptionValues, sV.stealth.assistants, "full"),
                getDropDown(GetString(ABP_BEFORE_COMBAT_NAME), GetString(ABP_BEFORE_COMBAT_TOOLTIP), dS.combat.assistants, false, selectOptions, selectOptionValues, sV.combat.assistants, "full"),
            }
        },
        {
            type = "submenu", name = GetString(ABP_COMPANIONS_NAME), controls = {
                getHeader(GetString(ABP_BANK_NAME)),
                getCheckBox(companionNames[1], GetString(ABP_BANK_TOOLTIP), dS.bank[AutoBanishPets.companions[1]], false, sV.bank[AutoBanishPets.companions[1]], "half"),
                getCheckBox(companionNames[2], GetString(ABP_BANK_TOOLTIP), dS.bank[AutoBanishPets.companions[2]], false, sV.bank[AutoBanishPets.companions[2]], "half"),
                getHeader(GetString(ABP_GUILD_BANK_NAME)),
                getCheckBox(companionNames[1], GetString(ABP_GUILD_BANK_TOOLTIP), dS.guildBank[AutoBanishPets.companions[1]], false, sV.guildBank[AutoBanishPets.companions[1]], "half"),
                getCheckBox(companionNames[2], GetString(ABP_GUILD_BANK_TOOLTIP), dS.guildBank[AutoBanishPets.companions[2]], false, sV.guildBank[AutoBanishPets.companions[2]], "half"),
                getHeader(GetString(ABP_STORE_NAME)),
                getCheckBox(companionNames[1], GetString(ABP_STORE_TOOLTIP), dS.store[AutoBanishPets.companions[1]], false, sV.store[AutoBanishPets.companions[1]], "half"),
                getCheckBox(companionNames[2], GetString(ABP_STORE_TOOLTIP), dS.store[AutoBanishPets.companions[2]], false, sV.store[AutoBanishPets.companions[2]], "half"),
                getHeader(GetString(ABP_GUILD_STORE_NAME)),
                getCheckBox(companionNames[1], GetString(ABP_GUILD_STORE_TOOLTIP), dS.guildStore[AutoBanishPets.companions[1]], false, sV.guildStore[AutoBanishPets.companions[1]], "half"),
                getCheckBox(companionNames[2], GetString(ABP_GUILD_STORE_TOOLTIP), dS.guildStore[AutoBanishPets.companions[2]], false, sV.guildStore[AutoBanishPets.companions[2]], "half"),
                getHeader(GetString(ABP_FENCE_NAME)),
                getCheckBox(companionNames[1], GetString(ABP_FENCE_TOOLTIP), dS.fence[AutoBanishPets.companions[1]], false, sV.fence[AutoBanishPets.companions[1]], "half"),
                getCheckBox(companionNames[2], GetString(ABP_FENCE_TOOLTIP), dS.fence[AutoBanishPets.companions[2]], false, sV.fence[AutoBanishPets.companions[2]], "half"),
                getHeader(GetString(ABP_CRAFT_STATION_NAME)),
                getCheckBox(companionNames[1], GetString(ABP_CRAFT_STATION_TOOLTIP), dS.craftStation[AutoBanishPets.companions[1]], false, sV.craftStation[AutoBanishPets.companions[1]], "half"),
                getCheckBox(companionNames[2], GetString(ABP_CRAFT_STATION_TOOLTIP), dS.craftStation[AutoBanishPets.companions[2]], false, sV.craftStation[AutoBanishPets.companions[2]], "half"),
                getHeader(GetString(ABP_RETRAIT_STATION_NAME)),
                getCheckBox(companionNames[1], GetString(ABP_RETRAIT_STATION_TOOLTIP), dS.retraitStation[AutoBanishPets.companions[1]], false, sV.retraitStation[AutoBanishPets.companions[1]], "half"),
                getCheckBox(companionNames[2], GetString(ABP_RETRAIT_STATION_TOOLTIP), dS.retraitStation[AutoBanishPets.companions[2]], false, sV.retraitStation[AutoBanishPets.companions[2]], "half"),
                getHeader(GetString(ABP_DYEING_STATION_NAME)),
                getCheckBox(companionNames[1], GetString(ABP_DYEING_STATION_TOOLTIP), dS.dyeingStation[AutoBanishPets.companions[1]], false, sV.dyeingStation[AutoBanishPets.companions[1]], "half"),
                getCheckBox(companionNames[2], GetString(ABP_DYEING_STATION_TOOLTIP), dS.dyeingStation[AutoBanishPets.companions[2]], false, sV.dyeingStation[AutoBanishPets.companions[2]], "half"),
                getHeader(GetString(ABP_WAYSHRINE_NAME)),
                getCheckBox(companionNames[1], GetString(ABP_WAYSHRINE_TOOLTIP), dS.wayshrine[AutoBanishPets.companions[1]], false, sV.wayshrine[AutoBanishPets.companions[1]], "half"),
                getCheckBox(companionNames[2], GetString(ABP_WAYSHRINE_TOOLTIP), dS.wayshrine[AutoBanishPets.companions[2]], false, sV.wayshrine[AutoBanishPets.companions[2]], "half"),
                getHeader(GetString(ABP_THIEVESTROVE_NAME)),
                getCheckBox(companionNames[1], GetString(ABP_THIEVESTROVE_TOOLTIP), dS.thievesTrove[AutoBanishPets.companions[1]], false, sV.thievesTrove[AutoBanishPets.companions[1]], "half"),
                getCheckBox(companionNames[2], GetString(ABP_THIEVESTROVE_TOOLTIP), dS.thievesTrove[AutoBanishPets.companions[2]], false, sV.thievesTrove[AutoBanishPets.companions[2]], "half"),
                getHeader(GetString(ABP_STEAL_NAME)),
                getCheckBox(companionNames[1], GetString(ABP_STEAL_TOOLTIP), dS.steal[AutoBanishPets.companions[1]], false, sV.steal[AutoBanishPets.companions[1]], "half"),
                getCheckBox(companionNames[2], GetString(ABP_STEAL_TOOLTIP), dS.steal[AutoBanishPets.companions[2]], false, sV.steal[AutoBanishPets.companions[2]], "half"),
                getHeader(GetString(ABP_ARRESTED_NAME)),
                getCheckBox(companionNames[1], GetString(ABP_ARRESTED_TOOLTIP), dS.arrested[AutoBanishPets.companions[1]], false, sV.arrested[AutoBanishPets.companions[1]], "half"),
                getCheckBox(companionNames[2], GetString(ABP_ARRESTED_TOOLTIP), dS.arrested[AutoBanishPets.companions[2]], false, sV.arrested[AutoBanishPets.companions[2]], "half"),
                getHeader(GetString(ABP_TORCHBUG_NAME)),
                getCheckBox(companionNames[1], GetString(ABP_TORCHBUG_TOOLTIP), dS.torchbug[AutoBanishPets.companions[1]], false, sV.torchbug[AutoBanishPets.companions[1]], "half"),
                getCheckBox(companionNames[2], GetString(ABP_TORCHBUG_TOOLTIP), dS.torchbug[AutoBanishPets.companions[2]], false, sV.torchbug[AutoBanishPets.companions[2]], "half"),
                getHeader(GetString(ABP_LOCATION_NAME)),
                {
                    type = "checkbox",
                    name = companionNames[1],
                    tooltip = dislikeLocationNames[1],
                    default = dS.location[AutoBanishPets.companions[1]],
                    requiresReload = false,
                    disabled = function() return dislikeLocationNames[1] == "" end,
                    getFunc = function() return sV.location[AutoBanishPets.companions[1]] end,
                    setFunc = function(newValue) sV.location[AutoBanishPets.companions[1]] = newValue end,
                    width = "half",
                },
                {
                    type = "checkbox",
                    name = companionNames[2],
                    tooltip = dislikeLocationNames[2],
                    default = dS.location[AutoBanishPets.companions[2]],
                    requiresReload = false,
                    disabled = function() return dislikeLocationNames[2] == "" end,
                    getFunc = function() return sV.location[AutoBanishPets.companions[2]] end,
                    setFunc = function(newValue) sV.location[AutoBanishPets.companions[2]] = newValue end,
                    width = "half",
                },
                getHeader(GetString(ABP_QUEST_NAME)),
                getCheckBox(companionNames[1], GetString(ABP_QUEST_TOOLTIP), dS.quest[AutoBanishPets.companions[1]], false, sV.quest[AutoBanishPets.companions[1]], "half"),
                getCheckBox(companionNames[2], GetString(ABP_QUEST_TOOLTIP), dS.quest[AutoBanishPets.companions[2]], false, sV.quest[AutoBanishPets.companions[2]], "half"),
                getHeader(GetString(ABP_STEALTH_NAME)),
                getDropDown(companionNames[1], GetString(ABP_STEALTH_TOOLTIP), dS.stealth.companions[AutoBanishPets.companions[1]], false, selectOptions, selectOptionValues, sV.stealth.companions[AutoBanishPets.companions[1]], "half"),
                getDropDown(companionNames[2], GetString(ABP_STEALTH_TOOLTIP), dS.stealth.companions[AutoBanishPets.companions[2]], false, selectOptions, selectOptionValues, sV.stealth.companions[AutoBanishPets.companions[2]], "half"),
                getHeader(GetString(ABP_AFTER_COMBAT_NAME)),
                getDropDown(companionNames[1], GetString(ABP_AFTER_COMBAT_TOOLTIP), dS.combat.companions[AutoBanishPets.companions[1]], false, selectOptions, selectOptionValues, sV.combat.companions[AutoBanishPets.companions[1]], "half"),
                getDropDown(companionNames[2], GetString(ABP_AFTER_COMBAT_TOOLTIP), dS.combat.companions[AutoBanishPets.companions[2]], false, selectOptions, selectOptionValues, sV.combat.companions[AutoBanishPets.companions[2]], "half"),
            },
        },
        getHeader(GetString(ABP_GENERAL_NAME)),
        getCheckBox(GetString(ABP_NOTIFICATION_NAME), "", dS.notification, false, sV.notification, "full"),
    }
    LAM2:RegisterOptionControls("AutoBanishPets_Settings", optionsData)
end