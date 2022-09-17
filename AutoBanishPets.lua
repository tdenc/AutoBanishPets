AutoBanishPets = AutoBanishPets or {}
local AutoBanishPets = AutoBanishPets

----------------------
--INITIATE VARIABLES--
----------------------
AutoBanishPets.name = "AutoBanishPets"
AutoBanishPets.version = "0.0.8"
AutoBanishPets.variableVersion = 6

AutoBanishPets.defaultSettings = {
    ["notification"] = true,
    ["pets"] = {
        ["bank"] = true,
        ["guildBank"] = true,
        ["store"] = true,
        ["guildStore"] = true,
        ["fence"] = true,
        ["craftStation"] = true,
        ["dyeingStation"] = true,
        ["retraitStation"] = true,
        ["wayshrine"] = false,
        ["quest"] = true,
    },
    ["vanityPets"] = {
        ["bank"] = false,
        ["guildBank"] = false,
        ["store"] = false,
        ["guildStore"] = false,
        ["fence"] = false,
        ["craftStation"] = false,
        ["dyeingStation"] = false,
        ["retraitStation"] = false,
        ["wayshrine"] = false,
        ["quest"] = false,
        ["combat"] = 3,
    },
    ["assistants"] = {
        ["guildStore"] = true,
        ["craftStation"] = true,
        ["dyeingStation"] = true,
        ["retraitStation"] = true,
        ["wayshrine"] = false,
        ["quest"] = false,
        ["combat"] = 3,
    },
    ["companions"] = {
        ["bank"] = {
            [9245] = false,
            [9353] = false,
        },
        ["guildBank"] = {
            [9245] = false,
            [9353] = false,
        },
        ["store"] = {
            [9245] = false,
            [9353] = false,
        },
        ["guildStore"] = {
            [9245] = false,
            [9353] = false,
        },
        ["fence"] = {
            [9245] = true,
            [9353] = true,
        },
        ["craftStation"] = {
            [9245] = true,
            [9353] = false,
        },
        ["dyeingStation"] = {
            [9245] = false,
            [9353] = false,
        },
        ["retraitStation"] = {
            [9245] = false,
            [9353] = false,
        },
        ["wayshrine"] = {
            [9245] = false,
            [9353] = false,
        },
        ["quest"] = {
            [9245] = false,
            [9353] = false,
        },
    },
}

--------------------------
--DEFINE LOCAL FUNCTIONS--
--------------------------
local function isDaily(journalIndex)
    return (GetJournalQuestRepeatType(journalIndex) == QUEST_REPEAT_DAILY)
end


--------------------------
--DEFINE ADDON FUNCTIONS--
--------------------------
-- Banish combat pets only
function AutoBanishPets.BanishPets(eventCode, arg)
    -- EVENT_QUEST_ADDED (number eventCode, number journalIndex, string questName, string objectiveName)
    -- EVENT_QUEST_COMPLETE_DIALOG (number eventCode, number journalIndex)
    if (eventCode == EVENT_QUEST_ADDED or eventCode == EVENT_QUEST_COMPLETE_DIALOG) then
        if not isDaily(arg) then return end
    end

    local numBuffs = GetNumBuffs("player")
    local unitClassId = AutoBanishPets.unitClassId
    local abilities = AutoBanishPets.abilities -- AutoBanishPetsAbilities.lua
    if not abilities[unitClassId] then return end

    local isBanished = false
	for i = 1, numBuffs do
		local _, _, _, buffSlot, _, _, _, _, _, _, abilityId, _ = GetUnitBuffInfo("player", i)
        if abilities[unitClassId][abilityId] then
            isBanished = true
            CancelBuff(buffSlot)
        end
	end
    -- Notify once
    if isBanished then
        if AutoBanishPets.savedVariables.notification then
            df("[%s] %s", AutoBanishPets.name, GetString(ABP_NOTIFICATION_PETS))
        end
    end
end

-- Banish vanity pets only
function AutoBanishPets.BanishVanityPets(eventCode, arg)
    -- EVENT_PLAYER_COMBAT_STATE (number eventCode, boolean inCombat)
    if (eventCode == EVENT_PLAYER_COMBAT_STATE) then
        if not arg then return end
    elseif (eventCode == EVENT_QUEST_ADDED or eventCode == EVENT_QUEST_COMPLETE_DIALOG) then
        if not isDaily(arg) then return end
    end

    local activeId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_VANITY_PET)
    if (activeId ~= 0) then
        local collectibleData = ZO_COLLECTIBLE_DATA_MANAGER:GetCollectibleDataById(activeId)
        if not IsCollectibleBlocked(activeId) then
            collectibleData:Use()
            AutoBanishPets.isAutoBanished.vanityPets[activeId] = true
            if AutoBanishPets.savedVariables.notification then
                df("[%s] %s", AutoBanishPets.name, GetString(ABP_NOTIFICATION_VANITY_PETS))
            end
        end
    end
end

-- Banish assistants only
function AutoBanishPets.BanishAssistants(eventCode, arg)
    -- EVENT_PLAYER_COMBAT_STATE (number eventCode, boolean inCombat)
    if (eventCode == EVENT_PLAYER_COMBAT_STATE) then
        if not arg then return end
    elseif (eventCode == EVENT_QUEST_ADDED or eventCode == EVENT_QUEST_COMPLETE_DIALOG) then
        if not isDaily(arg) then return end
    end

    local activeId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_ASSISTANT)
    if (activeId ~= 0) then
        local collectibleData = ZO_COLLECTIBLE_DATA_MANAGER:GetCollectibleDataById(activeId)
        if not IsCollectibleBlocked(activeId) then
            collectibleData:Use()
            AutoBanishPets.isAutoBanished.assistants[activeId] = true
            if AutoBanishPets.savedVariables.notification then
                df("[%s] %s", AutoBanishPets.name, GetString(ABP_NOTIFICATION_ASSISTANTS))
            end
        end
    end
end

-- Banish companions only
function AutoBanishPets.BanishCompanions(eventCode, arg)
    local activeId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COMPANION)
    if (activeId == 0) then
        return
    end

    local savedVariables = AutoBanishPets.savedVariables.companions
    -- EVENT_QUEST_ADDED (number eventCode, number journalIndex, string questName, string objectiveName)
    -- EVENT_QUEST_COMPLETE_DIALOG (number eventCode, number journalIndex)
    if (eventCode == EVENT_QUEST_ADDED or eventCode == EVENT_QUEST_COMPLETE_DIALOG) then
        if not isDaily(arg) then return end
    elseif (eventCode == EVENT_OPEN_BANK) then
        if not savedVariables.bank[activeId] then return end
    elseif (eventCode == EVENT_OPEN_GUILD_BANK) then
        if not savedVariables.guildBank[activeId] then return end
    elseif (eventCode == EVENT_OPEN_STORE) then
        if not savedVariables.store[activeId] then return end
    elseif (eventCode == EVENT_OPEN_TRADING_HOUSE) then
        if not savedVariables.guildStore[activeId] then return end
    elseif (eventCode == EVENT_OPEN_FENCE) then
        if not savedVariables.fence[activeId] then return end
    elseif (eventCode == EVENT_CRAFTING_STATION_INTERACT) then
        if not savedVariables.craftStation[activeId] then return end
    elseif (eventCode == EVENT_DYEING_STATION_INTERACT_START) then
        if not savedVariables.dyeingStation[activeId] then return end
    elseif (eventCode == EVENT_RETRAIT_STATION_INTERACT_START) then
        if not savedVariablesretraitStation[activeId] then return end
    elseif (eventCode == EVENT_START_FAST_TRAVEL_INTERACTION) then
        if not savedVariables.wayshrine[activeId] then return end
    end

    if not IsCollectibleBlocked(activeId) then
        UseCollectible(activeId)
        if AutoBanishPets.savedVariables.notification then
            df("[%s] %s", AutoBanishPets.name, GetString(ABP_NOTIFICATION_COMPANIONS))
        end
    end
end

-- Resummon vanity pets
function AutoBanishPets.ResummonVanityPets(eventCode, arg)
    -- EVENT_PLAYER_COMBAT_STATE (number eventCode, boolean inCombat)
    if arg then return end

    for k, v in pairs(AutoBanishPets.isAutoBanished.vanityPets) do
        if (v and not IsCollectibleActive(k)) then
            UseCollectible(k)
            AutoBanishPets.isAutoBanished.assistants[k] = false -- Reset status
            if AutoBanishPets.savedVariables.notification then
                df("[%s] %s", AutoBanishPets.name, GetString(ABP_NOTIFICATION_RESUMMON_VANITY_PETS))
            end
        end
    end
end

-- Resummon assistants
function AutoBanishPets.ResummonAssistants(eventCode, arg)
    -- EVENT_PLAYER_COMBAT_STATE (number eventCode, boolean inCombat)
    if arg then return end

    for k, v in pairs(AutoBanishPets.isAutoBanished.assistants) do
        if (v and not IsCollectibleActive(k)) then
            UseCollectible(k)
            AutoBanishPets.isAutoBanished.assistants[k] = false -- Reset status
            if AutoBanishPets.savedVariables.notification then
                df("[%s] %s", AutoBanishPets.name, GetString(ABP_NOTIFICATION_RESUMMON_ASSISTANTS))
            end
        end
    end
end

-- For Bindings.xml
function AutoBanishPets.BanishAll()
    AutoBanishPets.BanishPets()
    AutoBanishPets.BanishVanityPets()
    AutoBanishPets.BanishAssistants()
    AutoBanishPets.BanishCompanions()

    -- Clear table when manually banished
    AutoBanishPets.isAutoBanished = {
        ["vanityPets"] = {},
        ["assistants"] = {},
    }
end

-------------------
--REGISTER EVENTS--
-------------------
-- Combat pets
function AutoBanishPets:RegisterPetsEvents()
    local unitClassId = AutoBanishPets.unitClassId
    if not (unitClassId == 2 or unitClassId == 4) then -- 2: Sorcerer, 4: Warden
        return
    end

    local namespace = AutoBanishPets.name .. "_PETS"
    AutoBanishPets:Register(namespace, EVENT_OPEN_BANK, "pets", "bank")
    AutoBanishPets:Register(namespace, EVENT_OPEN_GUILD_BANK, "pets", "guildBank")
    AutoBanishPets:Register(namespace, EVENT_OPEN_STORE, "pets", "store")
    AutoBanishPets:Register(namespace, EVENT_OPEN_TRADING_HOUSE, "pets", "guildStore")
    AutoBanishPets:Register(namespace, EVENT_OPEN_FENCE, "pets", "fence")
    AutoBanishPets:Register(namespace, EVENT_CRAFTING_STATION_INTERACT, "pets", "craftStation")
    AutoBanishPets:Register(namespace, EVENT_DYEING_STATION_INTERACT_START, "pets", "dyeingStation")
    AutoBanishPets:Register(namespace, EVENT_RETRAIT_STATION_INTERACT_START, "pets", "retraitStation")
    AutoBanishPets:Register(namespace, EVENT_START_FAST_TRAVEL_INTERACTION, "pets", "wayshrine")
    AutoBanishPets:Register(namespace, EVENT_QUEST_ADDED, "pets", "quest")
    AutoBanishPets:Register(namespace, EVENT_QUEST_COMPLETE_DIALOG, "pets", "quest")
    -- AutoBanishPets:Register(namespace, EVENT_PLAYER_COMBAT_STATE, "pets", "combat")
end

-- Vanity pets
function AutoBanishPets:RegisterVanityPetsEvents()
    local namespace = AutoBanishPets.name .. "_VANITY_PETS"
    AutoBanishPets:Register(namespace, EVENT_OPEN_BANK, "vanityPets", "bank")
    AutoBanishPets:Register(namespace, EVENT_OPEN_GUILD_BANK, "vanityPets", "guildBank")
    AutoBanishPets:Register(namespace, EVENT_OPEN_STORE, "vanityPets", "store")
    AutoBanishPets:Register(namespace, EVENT_OPEN_TRADING_HOUSE, "vanityPets", "guildStore")
    AutoBanishPets:Register(namespace, EVENT_OPEN_FENCE, "vanityPets", "fence")
    AutoBanishPets:Register(namespace, EVENT_CRAFTING_STATION_INTERACT, "vanityPets", "craftStation")
    AutoBanishPets:Register(namespace, EVENT_DYEING_STATION_INTERACT_START, "vanityPets", "dyeingStation")
    AutoBanishPets:Register(namespace, EVENT_RETRAIT_STATION_INTERACT_START, "vanityPets", "retraitStation")
    AutoBanishPets:Register(namespace, EVENT_START_FAST_TRAVEL_INTERACTION, "vanityPets", "wayshrine")
    AutoBanishPets:Register(namespace, EVENT_QUEST_ADDED, "vanityPets", "quest")
    AutoBanishPets:Register(namespace, EVENT_QUEST_COMPLETE_DIALOG, "vanityPets", "quest")
    AutoBanishPets:Register(namespace, EVENT_PLAYER_COMBAT_STATE, "vanityPets", "combat")
end

-- Assistants
function AutoBanishPets:RegisterAssistantsEvents()
    local namespace = AutoBanishPets.name .. "_ASSISTANTS"
    AutoBanishPets:Register(namespace, EVENT_OPEN_TRADING_HOUSE, "assistants", "guildStore")
    AutoBanishPets:Register(namespace, EVENT_CRAFTING_STATION_INTERACT, "assistants", "craftStation")
    AutoBanishPets:Register(namespace, EVENT_DYEING_STATION_INTERACT_START, "assistants", "dyeingStation")
    AutoBanishPets:Register(namespace, EVENT_RETRAIT_STATION_INTERACT_START, "assistants", "retraitStation")
    AutoBanishPets:Register(namespace, EVENT_START_FAST_TRAVEL_INTERACTION, "assistants", "wayshrine")
    AutoBanishPets:Register(namespace, EVENT_QUEST_ADDED, "assistants", "quest")
    AutoBanishPets:Register(namespace, EVENT_QUEST_COMPLETE_DIALOG, "assistants", "quest")
    AutoBanishPets:Register(namespace, EVENT_PLAYER_COMBAT_STATE, "assistants", "combat")
end

-- Companions
function AutoBanishPets:RegisterCompanionsEvents()
    local namespace = AutoBanishPets.name .. "_COMPANIONS"
    AutoBanishPets:Register(namespace, EVENT_OPEN_BANK, "companions", "bank")
    AutoBanishPets:Register(namespace, EVENT_OPEN_GUILD_BANK, "companions", "guildBank")
    AutoBanishPets:Register(namespace, EVENT_OPEN_STORE, "companions", "store")
    AutoBanishPets:Register(namespace, EVENT_OPEN_TRADING_HOUSE, "companions", "guildStore")
    AutoBanishPets:Register(namespace, EVENT_OPEN_FENCE, "companions", "fence")
    AutoBanishPets:Register(namespace, EVENT_CRAFTING_STATION_INTERACT, "companions", "craftStation")
    AutoBanishPets:Register(namespace, EVENT_DYEING_STATION_INTERACT_START, "companions", "dyeingStation")
    AutoBanishPets:Register(namespace, EVENT_RETRAIT_STATION_INTERACT_START, "companions", "retraitStation")
    AutoBanishPets:Register(namespace, EVENT_START_FAST_TRAVEL_INTERACTION, "companions", "wayshrine")
    AutoBanishPets:Register(namespace, EVENT_QUEST_ADDED, "companions", "quest")
    AutoBanishPets:Register(namespace, EVENT_QUEST_COMPLETE_DIALOG, "companions", "quest")
    -- AutoBanishPets:Register(namespace, EVENT_PLAYER_COMBAT_STATE, "companions", "combat")
end


function AutoBanishPets:Register(namespace, eventCode, whoKey, whenKey)
    local banishFunc, resummonFunc
    if (whoKey == "pets") then
        banishFunc = AutoBanishPets.BanishPets
    elseif (whoKey == "vanityPets") then
        banishFunc = AutoBanishPets.BanishVanityPets
        resummonFunc = AutoBanishPets.ResummonVanityPets
    elseif (whoKey == "assistants") then
        banishFunc = AutoBanishPets.BanishAssistants
        resummonFunc = AutoBanishPets.ResummonAssistants
    elseif (whoKey == "companions") then
        banishFunc = AutoBanishPets.BanishCompanions
    else
        return
    end

    local value = AutoBanishPets.savedVariables[whoKey][whenKey]
    -- General option
    if (type(value) == "boolean") then
        if not value then return end
        EVENT_MANAGER:RegisterForEvent(namespace, eventCode, banishFunc)
    -- Combat option
    elseif (type(value) == "number") then
        if (value == 1) then return end
        if (value > 1) then
            EVENT_MANAGER:RegisterForEvent(namespace, eventCode, banishFunc)
        end
        if (value > 2 and not ressumonFunc) then
            EVENT_MANAGER:RegisterForEvent(namespace .. "_RESUMMON", eventCode, resummonFunc)
        end
    -- Companion option
    elseif (type(value) == "table") then
        local isChecked = false
        for _, v in pairs(value) do
            isChecked = isChecked or v
        end
        if isChecked then
            EVENT_MANAGER:RegisterForEvent(namespace, eventCode, banishFunc)
        end
    end
end


function AutoBanishPets:Initialize()
    AutoBanishPets.savedVariables = ZO_SavedVars:NewAccountWide("AutoBanishPetsSavedVars", AutoBanishPets.variableVersion, nil, AutoBanishPets.defaultSettings)
    AutoBanishPets.isAutoBanished = { -- Table for resummoning
        ["vanityPets"] = {},
        ["assistants"] = {},
    }
    AutoBanishPets.unitClassId = GetUnitClassId("player")
    AutoBanishPets.CreateSettingsWindow() -- AutoBanishPetsSettings.lua

    AutoBanishPets:RegisterPetsEvents()
    AutoBanishPets:RegisterVanityPetsEvents()
    AutoBanishPets:RegisterAssistantsEvents()
    AutoBanishPets:RegisterCompanionsEvents()

    EVENT_MANAGER:UnregisterForEvent(AutoBanishPets.name, EVENT_ADD_ON_LOADED)
end

function AutoBanishPets.OnAddOnLoaded(event, addonName)
    if (addonName == AutoBanishPets.name) then
        AutoBanishPets:Initialize()
    end
end

EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name, EVENT_ADD_ON_LOADED, AutoBanishPets.OnAddOnLoaded)