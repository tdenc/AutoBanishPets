AutoBanishPets = AutoBanishPets or {}
local AutoBanishPets = AutoBanishPets

----------------------
--INITIATE VARIABLES--
----------------------
AutoBanishPets.name = "AutoBanishPets"
AutoBanishPets.version = "0.0.10"
AutoBanishPets.variableVersion = 7

AutoBanishPets.defaultSettings = {
    ["notification"] = true,
    ["interval"] = {
        ["vanityPets"] = 2,
        ["assistants"] = 3,
        -- ["companions"] = 5,
    } ,
    ["bank"] = {
        ["pets"] = true,
        ["vanityPets"] = false,
        ["assistants"] = false,
        [9245] = false,
        [9353] = false,
    },
    ["guildBank"] = {
        ["pets"] = true,
        ["vanityPets"] = false,
        ["assistants"] = true,
        [9245] = false,
        [9353] = false,
    },
    ["store"] = {
        ["pets"] = true,
        ["vanityPets"] = false,
        ["assistants"] = false,
        [9245] = false,
        [9353] = false,
    },
    ["guildStore"] = {
        ["pets"] = true,
        ["vanityPets"] = false,
        ["assistants"] = false,
        [9245] = false,
        [9353] = false,
    },
    ["fence"] = {
        ["pets"] = true,
        ["vanityPets"] = false,
        ["assistants"] = false,
        [9245] = true,
        [9353] = true,
    },
    ["craftStation"] = {
        ["pets"] = true,
        ["vanityPets"] = false,
        ["assistants"] = true,
        [9245] = true,
        [9353] = false,
    },
    ["dyeingStation"] = {
        ["pets"] = true,
        ["vanityPets"] = false,
        ["assistants"] = true,
        [9245] = false,
        [9353] = false,
    },
    ["retraitStation"] = {
        ["pets"] = true,
        ["vanityPets"] = false,
        ["assistants"] = true,
        [9245] = false,
        [9353] = false,
    },
    ["wayshrine"] = {
        ["pets"] = false,
        ["vanityPets"] = false,
        ["assistants"] = false,
        [9245] = false,
        [9353] = false,
    },
    ["quest"] = {
        ["pets"] = false,
        ["vanityPets"] = false,
        ["assistants"] = false,
        [9245] = false,
        [9353] = false,
    },
    ["combat"] = {
        -- ["pets"] = false,
        ["vanityPets"] = 2,
        ["assistants"] = 2,
        -- [9245] = 1,
        -- [9353] = 1,
    },
}
AutoBanishPets.messages = {
    ["pets"] = GetString(ABP_NOTIFICATION_PETS),
    ["vanityPets"] = GetString(ABP_NOTIFICATION_VANITY_PETS),
    ["assistants"] = GetString(ABP_NOTIFICATION_ASSISTANTS),
    ["companions"] = GetString(ABP_NOTIFICATION_COMPANIONS),
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
-- Banish combat pets
function AutoBanishPets.BanishPets()
    local unitClassId = AutoBanishPets.unitClassId
    local abilities = AutoBanishPets.abilities -- AutoBanishPetsAbilities.lua
    if not abilities[unitClassId] then return end

    local isBanished = false
	for i = 1, GetNumBuffs("player") do
		local _, _, _, buffSlot, _, _, _, _, _, _, abilityId, _ = GetUnitBuffInfo("player", i)
        if abilities[unitClassId][abilityId] then
            isBanished = true
            CancelBuff(buffSlot)
        end
	end
    -- Notify once
    if isBanished then
        if AutoBanishPets.savedVariables.notification then
            df("[%s] %s", AutoBanishPets.name, AutoBanishPets.messages["pets"])
        end
    end
end

-- RegisterForUpdate
function AutoBanishPets.RegisterUpdate(collectibleId, toggle, key, second)
    local ns = AutoBanishPets.name .. "_" .. tostring(toggle) .. "_" .. tostring(collectibleId)
    EVENT_MANAGER:UnregisterForUpdate(ns)
    EVENT_MANAGER:RegisterForUpdate(ns, second,
        function() AutoBanishPets.ToggleCollectible(collectibleId, toggle, key) end
    )
end

-- UnregisterForUpdate
function AutoBanishPets.UnregisterUpdate(collectibleId, toggle, key)
    EVENT_MANAGER:UnregisterForUpdate(
        AutoBanishPets.name .. "_" .. tostring(toggle) .. "_" .. tostring(collectibleId)
    )
    AutoBanishPets.isToggling[key] = false
end

-- Toggle collectible
-- Activate collectible if toggle == true, inactivate if toggle == false
function AutoBanishPets.ToggleCollectible(collectibleId, toggle, key)
    -- get active collectibleId
    local activeId
    if (key == "vanityPets") then
        activeId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_VANITY_PET)
    elseif (key == "assistants") then
        activeId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_ASSISTANT)
    elseif (key == "companions") then
        activeId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COMPANION)
    end
    if (toggle and activeId ~= 0) then -- already active
        AutoBanishPets.UnregisterUpdate(collectibleId, toggle, key)
        AutoBanishPets.queuedId[key] = 0
    elseif (not toggle and activeId == 0) then --already inactive
        AutoBanishPets.UnregisterUpdate(collectibleId, toggle, key)
    elseif (activeId ~= 0 and activeId ~= collectibleId) then -- player changed collectible manually during cooldown
        AutoBanishPets.UnregisterUpdate(collectibleId, toggle, key)
        AutoBanishPets.queuedId[key] = activeId
    elseif (IsCollectibleActive(collectibleId) ~= toggle and not AutoBanishPets.isToggling[key]) then
        UseCollectible(collectibleId)
        AutoBanishPets.isToggling[key] = true
    else
        -- do nothing (repeat update)
    end
end

-- Banish vanity pets
function AutoBanishPets.BanishVanityPets(collectibleId)
    local targetId = collectibleId
    -- Need for manual banishment
    if not targetId then
        targetId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_VANITY_PET)
    end

    if (targetId == 0) then return end -- no active non-combat pet

    AutoBanishPets.RegisterUpdate(targetId, false, "vanityPets", 100)
    df("[%s] %s", AutoBanishPets.name, AutoBanishPets.messages["vanityPets"])
end

-- Banish assistants
function AutoBanishPets.BanishAssistants(collectibleId)
    local targetId = collectibleId
    -- Need for manual banishment
    if not targetId then
        targetId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_ASSISTANT)
    end

    if (targetId == 0) then return end -- no active assistant

    AutoBanishPets.RegisterUpdate(targetId, false, "assistants", 100)
    df("[%s] %s", AutoBanishPets.name, AutoBanishPets.messages["assistants"])
end

-- Banish companions
function AutoBanishPets.BanishCompanions(collectibleId)
    local targetId = collectibleId
    -- Need for manual banishment
    if not targetId then
        targetId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COMPANION)
    end

    if (targetId == 0) then return end -- no active companion
    -- TODO: Manage pending

    AutoBanishPets.RegisterUpdate(targetId, false, "companions", 100)
    df("[%s] %s", AutoBanishPets.name, AutoBanishPets.messages["companions"])
end

-- Resummon vanity pets
function AutoBanishPets.ResummonVanityPets(collectibleId)
    AutoBanishPets.RegisterUpdate(collectibleId, true, "vanityPets", AutoBanishPets.savedVariables.interval.vanityPets * 1000)
end

-- Resummon assistants
function AutoBanishPets.ResummonAssistants(collectibleId)
    -- Manage conflict between assistants and companions
    local activeCompanionId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COMPANION)
    if (activeCompanionId ~= 0) then return end

    AutoBanishPets.RegisterUpdate(collectibleId, true, "assistants", AutoBanishPets.savedVariables.interval.assistants * 1000)
end

-- TODO: Resummon companions

-- Start combat
function AutoBanishPets.onStartCombat(eventCode, inCombat)
    if not inCombat then return end

    local activeId, queuedId
    local sV = AutoBanishPets.savedVariables

    -- non-combat pets
    if (sV.combat.vanityPets > 1) then
        activeId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_VANITY_PET)
        queuedId = AutoBanishPets.queuedId.vanityPets
        if (activeId ~= 0 and queuedId == 0) then -- first encounter
            AutoBanishPets.queuedId.vanityPets = activeId
        elseif (activeId == 0 and queuedId ~= 0) then -- in cooldown
            AutoBanishPets.UnregisterUpdate(queuedId, true, "vanityPets")
            activeId = queuedId
        elseif (activeId ~= 0 and queuedId ~= 0) then -- player changed collectible during cooldown
            AutoBanishPets.UnregisterUpdate(queuedId, true, "vanityPets")
            AutoBanishPets.queuedId.vanityPets = activeId
        end
        AutoBanishPets.BanishVanityPets(activeId)
    end

    -- assistants
    if (sV.combat.assistants > 1) then
        activeId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_ASSISTANT)
        queuedId = AutoBanishPets.queuedId.assistants
        if (activeId ~= 0 and queuedId == 0) then -- first encounter
            AutoBanishPets.queuedId.assistants = activeId
        elseif (activeId == 0 and queuedId ~= 0) then -- in cooldown
            AutoBanishPets.UnregisterUpdate(queuedId, true, "assistants")
            activeId = queuedId
        elseif (activeId ~= 0 and queuedId ~= 0) then -- player changed collectible during cooldown
            AutoBanishPets.UnregisterUpdate(queuedId, true, "assistants")
            AutoBanishPets.queuedId.assistants = activeId
        end
        AutoBanishPets.BanishAssistants(activeId)
    end
end

-- End combat
function AutoBanishPets.onEndCombat(eventCode, inCombat)
    if inCombat then return end

    local targetId
    local sV = AutoBanishPets.savedVariables

    -- TODO: combat pets
    -- if sV.combat.pets then
    -- end

    -- non-combat pets
    if (sV.combat.vanityPets > 2) then
        targetId = AutoBanishPets.queuedId.vanityPets
        if (targetId ~= 0) then
            AutoBanishPets.ResummonVanityPets(targetId)
        end
    end

    -- assistants
    if (sV.combat.assistants > 2) then
        targetId = AutoBanishPets.queuedId.assistants
        if (targetId ~= 0) then
            AutoBanishPets.ResummonAssistants(targetId)
        end
    end

    -- TODO: companions
    -- if (sV.combat.companions > 1) then
    -- end

end

-- Events except combat
function AutoBanishPets.onEventTriggered(eventCode, arg)
    local sV = AutoBanishPets.savedVariables

    -- Bank
    if (eventCode == EVENT_OPEN_BANK) then
        for k, v in pairs(sV.bank) do
            if v then
                if (k == "pets") then
                    AutoBanishPets.BanishPets()
                elseif (k == "vanityPets") then
                    AutoBanishPets.BanishVanityPets()
                elseif (k == "assistants") then
                    -- do nothing
                else
                    AutoBanishPets.BanishCompanions()
                end
            end
        end
    -- Guild bank
    elseif (eventCode == EVENT_OPEN_GUILD_BANK) then
        for k, v in pairs(sV.guildBank) do
            if v then
                if (k == "pets") then
                    AutoBanishPets.BanishPets()
                elseif (k == "vanityPets") then
                    AutoBanishPets.BanishVanityPets()
                elseif (k == "assistants") then
                    -- do nothing
                else
                    AutoBanishPets.BanishCompanions()
                end
            end
        end
    -- Store
    elseif (eventCode == EVENT_OPEN_STORE) then
        for k, v in pairs(sV.store) do
            if v then
                if (k == "pets") then
                    AutoBanishPets.BanishPets()
                elseif (k == "vanityPets") then
                    AutoBanishPets.BanishVanityPets()
                elseif (k == "assistants") then
                    -- do nothing
                else
                    AutoBanishPets.BanishCompanions()
                end
            end
        end
    -- Guild store
    elseif (eventCode == EVENT_OPEN_TRADING_HOUSE) then
        for k, v in pairs(sV.guildStore) do
            if v then
                if (k == "pets") then
                    AutoBanishPets.BanishPets()
                elseif (k == "vanityPets") then
                    AutoBanishPets.BanishVanityPets()
                elseif (k == "assistants") then
                    AutoBanishPets.BanishAssistants()
                else
                    AutoBanishPets.BanishCompanions()
                end
            end
        end
    -- Fence
    elseif (eventCode == EVENT_OPEN_FENCE) then
        for k, v in pairs(sV.fence) do
            if v then
                if (k == "pets") then
                    AutoBanishPets.BanishPets()
                elseif (k == "vanityPets") then
                    AutoBanishPets.BanishVanityPets()
                elseif (k == "assistants") then
                    -- do nothing
                else
                    AutoBanishPets.BanishCompanions()
                end
            end
        end
    -- Craft station
    elseif (eventCode == EVENT_CRAFTING_STATION_INTERACT) then
        for k, v in pairs(sV.craftStation) do
            if v then
                if (k == "pets") then
                    AutoBanishPets.BanishPets()
                elseif (k == "vanityPets") then
                    AutoBanishPets.BanishVanityPets()
                elseif (k == "assistants") then
                    AutoBanishPets.BanishAssistants()
                else
                    AutoBanishPets.BanishCompanions()
                end
            end
        end
    -- Dyeing station
    elseif (eventCode == EVENT_DYEING_STATION_INTERACT_START) then
        for k, v in pairs(sV.dyeingStation) do
            if v then
                if (k == "pets") then
                    AutoBanishPets.BanishPets()
                elseif (k == "vanityPets") then
                    AutoBanishPets.BanishVanityPets()
                elseif (k == "assistants") then
                    AutoBanishPets.BanishAssistants()
                else
                    AutoBanishPets.BanishCompanions()
                end
            end
        end
    -- Retrait station
    elseif (eventCode == EVENT_RETRAIT_STATION_INTERACT_START) then
        for k, v in pairs(sV.retraitStation) do
            if v then
                if (k == "pets") then
                    AutoBanishPets.BanishPets()
                elseif (k == "vanityPets") then
                    AutoBanishPets.BanishVanityPets()
                elseif (k == "assistants") then
                    AutoBanishPets.BanishAssistants()
                else
                    AutoBanishPets.BanishCompanions()
                end
            end
        end
    -- Wayshrine
    elseif (eventCode == EVENT_START_FAST_TRAVEL_INTERACTION) then
        for k, v in pairs(sV.wayshrine) do
            if v then
                if (k == "pets") then
                    AutoBanishPets.BanishPets()
                elseif (k == "vanityPets") then
                    AutoBanishPets.BanishVanityPets()
                elseif (k == "assistants") then
                    AutoBanishPets.BanishAssistants()
                else
                    AutoBanishPets.BanishCompanions()
                end
            end
        end
    -- Dailies
    -- EVENT_QUEST_ADDED (number eventCode, number journalIndex, string questName, string objectiveName)
    -- EVENT_QUEST_COMPLETE_DIALOG (number eventCode, number journalIndex)
    elseif (eventCode == EVENT_QUEST_ADDED or eventCode == EVENT_QUEST_COMPLETE_DIALOG) then
        for k, v in pairs(sV.quest) do
            if (v and isDaily(arg)) then
                if (k == "pets") then
                    AutoBanishPets.BanishPets()
                elseif (k == "vanityPets") then
                    AutoBanishPets.BanishVanityPets()
                elseif (k == "assistants") then
                    AutoBanishPets.BanishAssistants()
                else
                    AutoBanishPets.BanishCompanions()
                end
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

    -- Unregister and clear queue
    for k, v in pairs(AutoBanishPets.queuedId) do
        AutoBanishPets.UnregisterUpdate(v, true, k)
        AutoBanishPets.UnregisterUpdate(v, false, k)
        AutoBanishPets.queuedId[k] = 0
    end
end


-------------------
--REGISTER EVENTS--
-------------------
function AutoBanishPets:RegisterEvents()
    local EM = EVENT_MANAGER
    local ns = AutoBanishPets.name
    -- Combat events
    EM:RegisterForEvent(ns .. "_COMBAT_START", EVENT_PLAYER_COMBAT_STATE, AutoBanishPets.onStartCombat)
    EM:RegisterForEvent(ns .. "_COMBAT_END", EVENT_PLAYER_COMBAT_STATE, AutoBanishPets.onEndCombat)
    -- Other events
    EM:RegisterForEvent(ns .. "_BANK", EVENT_OPEN_BANK, AutoBanishPets.onEventTriggered)
    EM:RegisterForEvent(ns .. "_GUILD_BANK", EVENT_OPEN_GUILD_BANK, AutoBanishPets.onEventTriggered)
    EM:RegisterForEvent(ns .. "_STORE", EVENT_OPEN_STORE, AutoBanishPets.onEventTriggered)
    EM:RegisterForEvent(ns .. "_GUILD_STORE", EVENT_OPEN_TRADING_HOUSE, AutoBanishPets.onEventTriggered)
    EM:RegisterForEvent(ns .. "_FENCE", EVENT_OPEN_FENCE, AutoBanishPets.onEventTriggered)
    EM:RegisterForEvent(ns .. "_CRAFT_STATION", EVENT_CRAFTING_STATION_INTERACT, AutoBanishPets.onEventTriggered)
    EM:RegisterForEvent(ns .. "_DYEING_STATION", EVENT_DYEING_STATION_INTERACT_START, AutoBanishPets.onEventTriggered)
    EM:RegisterForEvent(ns .. "_RETRAIT_STATION", EVENT_RETRAIT_STATION_INTERACT_START, AutoBanishPets.onEventTriggered)
    EM:RegisterForEvent(ns .. "_WAYSHRINE", EVENT_START_FAST_TRAVEL_INTERACTION, AutoBanishPets.onEventTriggered)
    EM:RegisterForEvent(ns .. "_QUEST_ADDED", EVENT_QUEST_ADDED, AutoBanishPets.onEventTriggered)
    EM:RegisterForEvent(ns .. "_QUEST_COMPLETE", EVENT_QUEST_COMPLETE_DIALOG, AutoBanishPets.onEventTriggered)
end

function AutoBanishPets:Initialize()
    AutoBanishPets.savedVariables = ZO_SavedVars:NewAccountWide("AutoBanishPetsSavedVars", AutoBanishPets.variableVersion, nil, AutoBanishPets.defaultSettings)
    AutoBanishPets.queuedId = { -- Table for resummoning
        ["vanityPets"] = 0,
        ["assistants"] = 0,
        -- ["companions"] = 0,
    }
    AutoBanishPets.isToggling = { -- we need this for lagging :(
        ["vanityPets"] = false,
        ["assistants"] = false,
    }
    AutoBanishPets.unitClassId = GetUnitClassId("player")
    AutoBanishPets.CreateSettingsWindow() -- AutoBanishPetsSettings.lua
    AutoBanishPets:RegisterEvents()

    EVENT_MANAGER:UnregisterForEvent(AutoBanishPets.name, EVENT_ADD_ON_LOADED)
end

function AutoBanishPets.OnAddOnLoaded(event, addonName)
    if (addonName == AutoBanishPets.name) then
        AutoBanishPets:Initialize()
    end
end

EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name, EVENT_ADD_ON_LOADED, AutoBanishPets.OnAddOnLoaded)