AutoBanishPets = AutoBanishPets or {}
local AutoBanishPets = AutoBanishPets

----------------------
--INITIATE VARIABLES--
----------------------
AutoBanishPets.name = "AutoBanishPets"
AutoBanishPets.version = "0.0.6"
AutoBanishPets.variableVersion = 4

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
        ["combat"] = false,
    },
    ["assistants"] = {
        ["craftStation"] = true,
        ["dyeingStation"] = true,
        ["retraitStation"] = true,
        ["wayshrine"] = false,
        ["quest"] = true,
        ["combat"] = true,
    },
    ["companions"] = {
        ["bank"] = false,
        ["guildBank"] = false,
        ["store"] = false,
        ["guildStore"] = false,
        ["fence"] = true,
        ["craftStation"] = true,
        ["dyeingStation"] = false,
        ["retraitStation"] = false,
        ["wayshrine"] = false,
        ["quest"] = false,
    },
}


--------------------------
--DEFINE LOCAL FUNCTIONS--
--------------------------
local function isDaily(journalIndex)
    return (GetJournalQuestRepeatType(journalIndex) == QUEST_REPEAT_DAILY)
end

local function register(namespace, eventCode, func)
    EVENT_MANAGER:RegisterForEvent(namespace, eventCode, func)
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

	for i = 1, numBuffs do
		local _, _, _, buffSlot, _, _, _, _, _, _, abilityId, _ = GetUnitBuffInfo("player", i)
        if abilities[unitClassId][abilityId] then
            CancelBuff(buffSlot)
            if AutoBanishPets.savedVariables.notification then
                df("[%s] %s", AutoBanishPets.name, GetString(ABP_NOTIFICATION_PETS))
            end
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
        collectibleData:Use()
        if AutoBanishPets.savedVariables.notification then
            df("[%s] %s", AutoBanishPets.name, GetString(ABP_NOTIFICATION_PETS))
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
        collectibleData:Use()
        if AutoBanishPets.savedVariables.notification then
            df("[%s] %s", AutoBanishPets.name, GetString(ABP_NOTIFICATION_ASSISTANTS))
        end
    end
end

-- Banish assistants only
function AutoBanishPets.BanishCompanions(eventCode, arg)
    -- EVENT_QUEST_ADDED (number eventCode, number journalIndex, string questName, string objectiveName)
    -- EVENT_QUEST_COMPLETE_DIALOG (number eventCode, number journalIndex)
    if (eventCode == EVENT_QUEST_ADDED or eventCode == EVENT_QUEST_COMPLETE_DIALOG) then
        if not isDaily(arg) then return end
    end

    local activeId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COMPANION)
    if (activeId ~= 0) then
        local collectibleData = ZO_COLLECTIBLE_DATA_MANAGER:GetCollectibleDataById(activeId)
        collectibleData:Use()
        if AutoBanishPets.savedVariables.notification then
            df("[%s] %s", AutoBanishPets.name, GetString(ABP_NOTIFICATION_COMPANIONS))
        end
    end
end

-- For Bindings.xml
function AutoBanishPets.BanishAll()
    AutoBanishPets.BanishPets()
    AutoBanishPets.BanishVanityPets()
    AutoBanishPets.BanishAssistants()
    AutoBanishPets.BanishCompanions()
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

    local savedVariables = AutoBanishPets.savedVariables.pets
    local namespace = AutoBanishPets.name .. "_PETS"
    if savedVariables.bank then
        register(namespace, EVENT_OPEN_BANK, AutoBanishPets.BanishPets)
    end
    if savedVariables.guildBank then
        register(namespace, EVENT_OPEN_GUILD_BANK, AutoBanishPets.BanishPets)
    end
    if savedVariables.store then
        register(namespace, EVENT_OPEN_STORE, AutoBanishPets.BanishPets)
    end
    if savedVariables.guildStore then
        register(namespace, EVENT_OPEN_TRADING_HOUSE, AutoBanishPets.BanishPets)
    end
    if savedVariables.fence then
        register(namespace, EVENT_OPEN_FENCE, AutoBanishPets.BanishPets)
    end
    if savedVariables.craftStation then
        register(namespace, EVENT_CRAFTING_STATION_INTERACT, AutoBanishPets.BanishPets)
    end
    if savedVariables.dyeingStation then
        register(namespace, EVENT_DYEING_STATION_INTERACT_START, AutoBanishPets.BanishPets)
    end
    if savedVariables.retraitStation then
        register(namespace, EVENT_RETRAIT_STATION_INTERACT_START, AutoBanishPets.BanishPets)
    end
    if savedVariables.wayshrine then
        register(namespace, EVENT_START_FAST_TRAVEL_INTERACTION, AutoBanishPets.BanishPets)
    end
    if savedVariables.quest then
        register(namespace, EVENT_QUEST_ADDED, AutoBanishPets.BanishPets)
        register(namespace, EVENT_QUEST_COMPLETE_DIALOG, AutoBanishPets.BanishPets)
    end
end

-- Vanity pets
function AutoBanishPets:RegisterVanityPetsEvents()
    local savedVariables = AutoBanishPets.savedVariables.vanityPets
    local namespace = AutoBanishPets.name .. "_VANITY_PETS"
    if savedVariables.bank then
        register(namespace, EVENT_OPEN_BANK, AutoBanishPets.BanishVanityPets)
    end
    if savedVariables.guildBank then
        register(namespace, EVENT_OPEN_GUILD_BANK, AutoBanishPets.BanishVanityPets)
    end
    if savedVariables.store then
        register(namespace, EVENT_OPEN_STORE, AutoBanishPets.BanishVanityPets)
    end
    if savedVariables.guildStore then
        register(namespace, EVENT_OPEN_TRADING_HOUSE, AutoBanishPets.BanishVanityPets)
    end
    if savedVariables.fence then
        register(namespace, EVENT_OPEN_FENCE, AutoBanishPets.BanishVanityPets)
    end
    if savedVariables.craftStation then
        register(namespace, EVENT_CRAFTING_STATION_INTERACT, AutoBanishPets.BanishVanityPets)
    end
    if savedVariables.dyeingStation then
        register(namespace, EVENT_DYEING_STATION_INTERACT_START, AutoBanishPets.BanishVanityPets)
    end
    if savedVariables.retraitStation then
        register(namespace, EVENT_RETRAIT_STATION_INTERACT_START, AutoBanishPets.BanishVanityPets)
    end
    if savedVariables.wayshrine then
        register(namespace, EVENT_START_FAST_TRAVEL_INTERACTION, AutoBanishPets.BanishVanityPets)
    end
    if savedVariables.quest then
        register(namespace, EVENT_QUEST_ADDED, AutoBanishPets.BanishVanityPets)
        register(namespace, EVENT_QUEST_COMPLETE_DIALOG, AutoBanishPets.BanishVanityPets)
    end
    if savedVariables.combat then
        register(namespace, EVENT_PLAYER_COMBAT_STATE, AutoBanishPets.BanishVanityPets)
    end
end

-- Assistants
function AutoBanishPets:RegisterAssistantsEvents()
    local savedVariables = AutoBanishPets.savedVariables.assistants
    local namespace = AutoBanishPets.name .. "_ASSISTANTS"
    if savedVariables.craftStation then
        register(namespace, EVENT_CRAFTING_STATION_INTERACT, AutoBanishPets.BanishAssistants)
    end
    if savedVariables.dyeingStation then
        register(namespace, EVENT_DYEING_STATION_INTERACT_START, AutoBanishPets.BanishAssistants)
    end
    if savedVariables.retraitStation then
        register(namespace, EVENT_RETRAIT_STATION_INTERACT_START, AutoBanishPets.BanishAssistants)
    end
    if savedVariables.wayshrine then
        register(namespace, EVENT_START_FAST_TRAVEL_INTERACTION, AutoBanishPets.BanishAssistants)
    end
    if savedVariables.quest then
        register(namespace, EVENT_QUEST_ADDED, AutoBanishPets.BanishAssistants)
        register(namespace, EVENT_QUEST_COMPLETE_DIALOG, AutoBanishPets.BanishAssistants)
    end
    if savedVariables.combat then
        register(namespace, EVENT_PLAYER_COMBAT_STATE, AutoBanishPets.BanishAssistants)
    end
end

-- Companions
function AutoBanishPets:RegisterCompanionsEvents()
    local savedVariables = AutoBanishPets.savedVariables.companions
    local namespace = AutoBanishPets.name .. "_COMPANIONS"
    if savedVariables.bank then
        register(namespace, EVENT_OPEN_BANK, AutoBanishPets.BanishCompanions)
    end
    if savedVariables.guildBank then
        register(namespace, EVENT_OPEN_GUILD_BANK, AutoBanishPets.BanishCompanions)
    end
    if savedVariables.store then
        register(namespace, EVENT_OPEN_STORE, AutoBanishPets.BanishCompanions)
    end
    if savedVariables.guildStore then
        register(namespace, EVENT_OPEN_TRADING_HOUSE, AutoBanishPets.BanishCompanions)
    end
    if savedVariables.fence then
        register(namespace, EVENT_OPEN_FENCE, AutoBanishPets.BanishCompanions)
    end
    if savedVariables.craftStation then
        register(namespace, EVENT_CRAFTING_STATION_INTERACT, AutoBanishPets.BanishCompanions)
    end
    if savedVariables.dyeingStation then
        register(namespace, EVENT_DYEING_STATION_INTERACT_START, AutoBanishPets.BanishCompanions)
    end
    if savedVariables.retraitStation then
        register(namespace, EVENT_RETRAIT_STATION_INTERACT_START, AutoBanishPets.BanishCompanions)
    end
    if savedVariables.wayshrine then
        register(namespace, EVENT_START_FAST_TRAVEL_INTERACTION, AutoBanishPets.BanishCompanions)
    end
    if savedVariables.quest then
        register(namespace, EVENT_QUEST_ADDED, AutoBanishPets.BanishCompanions)
        register(namespace, EVENT_QUEST_COMPLETE_DIALOG, AutoBanishPets.BanishCompanions)
    end
end

function AutoBanishPets:Initialize()
    AutoBanishPets.savedVariables = ZO_SavedVars:NewAccountWide("AutoBanishPetsSavedVars", AutoBanishPets.variableVersion, nil, AutoBanishPets.defaultSettings)
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