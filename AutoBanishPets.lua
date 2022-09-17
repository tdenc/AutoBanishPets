AutoBanishPets = AutoBanishPets or {}
local AutoBanishPets = AutoBanishPets

----------------------
--INITIATE VARIABLES--
----------------------
AutoBanishPets.name = "AutoBanishPets"
AutoBanishPets.version = "0.1.1"
AutoBanishPets.variableVersion = 8

AutoBanishPets.defaultSettings = {
    ["notification"] = true,
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
        ["assistants"] = true,
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
        ["pets"] = true,
        ["vanityPets"] = false,
        ["assistants"] = false,
        [9245] = false,
        [9353] = false,
    },
    ["combat"] = {
        ["pets"] = false,
        ["vanityPets"] = 2,
        ["assistants"] = 2,
        ["companions"] = {
            [9245] = 1,
            [9353] = 1,
        },
    },
    ["logout"] = {
        ["pets"] = false,
        ["vanityPets"] = false,
        ["assistants"] = false,
        [9245] = false,
        [9353] = false,
    },
}
AutoBanishPets.messages = {
    ["pets"] = GetString(ABP_NOTIFICATION_PETS),
    ["vanityPets"] = GetString(ABP_NOTIFICATION_VANITY_PETS),
    ["assistants"] = GetString(ABP_NOTIFICATION_ASSISTANTS),
    ["companions"] = GetString(ABP_NOTIFICATION_COMPANIONS),
}

---------------------
--WRAPPER FUNCTIONS--
---------------------
-- Return true if daily
local function isDaily(journalIndex)
    return (GetJournalQuestRepeatType(journalIndex) == QUEST_REPEAT_DAILY)
end

-- RegisterForUpdate
function AutoBanishPets.RegisterUpdate(collectibleId, toggle, key, second)
    local delay
    local cooldownRemaining, cooldownDuration = GetCollectibleCooldownAndDuration(collectibleId)
    if (cooldownRemaining > second) then
        delay = cooldownRemaining
    else
        delay = second
    end

    local ns = string.format("%s_%s", AutoBanishPets.name, key)
    zo_callLater(
        function()
            EVENT_MANAGER:UnregisterForUpdate(ns)
            EVENT_MANAGER:RegisterForUpdate(ns, 100, function() AutoBanishPets.ToggleCollectible(collectibleId, toggle, key) end)
        end, delay)
end

-- UnregisterForUpdate
function AutoBanishPets.UnregisterUpdate(key)
    local ns = string.format("%s_%s", AutoBanishPets.name, key)
    EVENT_MANAGER:UnregisterForUpdate(ns)
    AutoBanishPets.isToggling[key] = false
end

-- Toggle collectible
-- Activate collectible if toggle == true, inactivate if toggle == false
function AutoBanishPets.ToggleCollectible(collectibleId, toggle, key)
    -- Get active collectibleId
    local activeId
    if (key == "vanityPets") then
        activeId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_VANITY_PET)
    elseif (key == "assistants") then
        activeId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_ASSISTANT)
    elseif (key == "companions") then
        activeId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COMPANION)
    end
    if (toggle and activeId ~= 0) then -- Already active
        AutoBanishPets.UnregisterUpdate(key)
    elseif (not toggle and activeId == 0) then -- Already inactive
        AutoBanishPets.UnregisterUpdate(key)
    elseif (activeId ~= 0 and activeId ~= collectibleId) then -- Player changed collectible manually during cooldown
        AutoBanishPets.UnregisterUpdate(key)
    elseif (toggle and IsUnitInCombat("player")) then -- Do not summon in combat
        AutoBanishPets.UnregisterUpdate(key)
    elseif (IsCollectibleActive(collectibleId) ~= toggle and not IsCollectibleBlocked(collectibleId) and not AutoBanishPets.isToggling[key]) then
        UseCollectible(collectibleId)
        if toggle then
            AutoBanishPets.queuedId[key] = 0
        end
        AutoBanishPets.isToggling[key] = true
        -- Notify only banishment
        if not toggle then
            df("[%s] %s", AutoBanishPets.name, AutoBanishPets.messages[key])
        end
    else
        AutoBanishPets.UnregisterUpdate(key)
    end
end

---------------------
--DISMISS FUNCTIONS--
---------------------
-- Dismiss combat pets
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

-- Dismiss vanity pets
function AutoBanishPets.BanishVanityPets(collectibleId)
    local targetId
    local activeId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_VANITY_PET)
    if (activeId == 0) then return end -- No active non-combat pet

    if not collectibleId then -- Manual banishment
        targetId = activeId
    else
        targetId = collectibleId
    end
    AutoBanishPets.RegisterUpdate(targetId, false, "vanityPets", 0)
end

-- Dismiss assistants
function AutoBanishPets.BanishAssistants(collectibleId)
    local targetId
    local activeId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_ASSISTANT)
    if (activeId == 0) then return end -- No active assistant

    if not collectibleId then -- Manual banishment
        targetId = activeId
    else
        targetId = collectibleId
    end
    AutoBanishPets.RegisterUpdate(targetId, false, "assistants", 0)
end

-- Dismiss companions
function AutoBanishPets.BanishCompanions(collectibleId)
    local targetId
    local activeId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COMPANION)
    if (activeId == 0) then return end -- No active companion

    if not collectibleId then -- Manual banishment
        targetId = activeId
    else
        targetId = collectibleId
    end
    if (targetId ~= activeId) then return end -- Different companion
    -- TODO: Manage pending
    AutoBanishPets.RegisterUpdate(targetId, false, "companions", 0)
end

-- For Bindings.xml
function AutoBanishPets.BanishAll()
    AutoBanishPets.BanishPets()
    AutoBanishPets.BanishVanityPets()
    AutoBanishPets.BanishAssistants()
    AutoBanishPets.BanishCompanions()

    -- Clear queue
    for k, v in pairs(AutoBanishPets.queuedId) do
        AutoBanishPets.queuedId[k] = 0
    end
end

----------------------
--RESUMMON FUNCTIONS--
----------------------
-- Resummon vanity pets
function AutoBanishPets.ResummonVanityPets(collectibleId)
    if IsUnitInCombat("player") then
        AutoBanishPets.UnregisterUpdate("vanityPets")
        return
    end
    AutoBanishPets.RegisterUpdate(collectibleId, true, "vanityPets", 3000)
end

-- Resummon assistants
function AutoBanishPets.ResummonAssistants(collectibleId)
    if IsUnitInCombat("player") then
        AutoBanishPets.UnregisterUpdate("assistants")
        return
    end
    -- Manage conflict between assistants and companions
    local activeCompanionId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COMPANION)
    if (activeCompanionId ~= 0) then return end

    AutoBanishPets.RegisterUpdate(collectibleId, true, "assistants", 3000)
end

-- Resummon companions
function AutoBanishPets.ResummonCompanions(collectibleId)
    if IsUnitInCombat("player") then
        AutoBanishPets.UnregisterUpdate("vanityPets")
        return
    end
    -- Manage conflict between assistants and companions
    local activeAssistantId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_ASSISTANT)
    if (activeAssistantId ~= 0) then return end

    AutoBanishPets.RegisterUpdate(collectibleId, true, "companions", 3000)
end

-------------------
--EVENT FUNCTIONS--
-------------------
-- Start combat
function AutoBanishPets.onStartCombat(eventCode, inCombat)
    if not inCombat then return end

    local activeId, queuedId
    local sV = AutoBanishPets.savedVariables

    -- Non-combat pets
    if (sV.combat.vanityPets > 1) then
        activeId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_VANITY_PET)
        if (activeId ~= 0) then
            AutoBanishPets.queuedId.vanityPets = activeId
            AutoBanishPets.UnregisterUpdate("vanityPets")
            AutoBanishPets.BanishVanityPets(activeId)
        end
    end

    -- Assistants
    if (sV.combat.assistants > 1) then
        activeId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_ASSISTANT)
        if (activeId ~= 0) then
            AutoBanishPets.queuedId.assistants = activeId
            AutoBanishPets.UnregisterUpdate("assistants")
            AutoBanishPets.BanishAssistants(activeId)
        end
    end
end

-- End combat
function AutoBanishPets.onEndCombat(eventCode, inCombat)
    if inCombat then return end

    local targetId
    local sV = AutoBanishPets.savedVariables

    -- Dismiss combat pets
    if sV.combat.pets then
        AutoBanishPets.BanishPets()
    end

    -- Resummon non-combat pets
    if (sV.combat.vanityPets > 2) then
        targetId = AutoBanishPets.queuedId.vanityPets
        if (targetId ~= 0) then
            AutoBanishPets.ResummonVanityPets(targetId)
        end
    end

    -- Resummon assistants
    if (sV.combat.assistants > 2) then
        targetId = AutoBanishPets.queuedId.assistants
        if (targetId ~= 0) then
            AutoBanishPets.ResummonAssistants(targetId)
        end
    end

    -- Dismiss/Resummon companions
    for k, v in pairs(sV.combat.companions) do
        -- Dismiss
        if (v > 1) then
            local activeCompanionId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_COMPANION)
            if (activeCompanionId == k) then
                AutoBanishPets.BanishCompanions(k)
                AutoBanishPets.queuedId.companions = k
            end
        end
        -- Resummon
        if (v > 2) then
            targetId = AutoBanishPets.queuedId.companions
            if (targetId ~= 0) then
                AutoBanishPets.ResummonCompanions(targetId)
            end
        end
    end
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
                    -- Do nothing
                else
                    AutoBanishPets.BanishCompanions(k)
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
                    AutoBanishPets.BanishAssistants()
                else
                    AutoBanishPets.BanishCompanions(k)
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
                    -- Do nothing
                else
                    AutoBanishPets.BanishCompanions(k)
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
                    AutoBanishPets.BanishCompanions(k)
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
                    -- Do nothing
                else
                    AutoBanishPets.BanishCompanions(k)
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
                    AutoBanishPets.BanishCompanions(k)
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
                    AutoBanishPets.BanishCompanions(k)
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
                    AutoBanishPets.BanishCompanions(k)
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
                    AutoBanishPets.BanishCompanions(k)
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
                    AutoBanishPets.BanishCompanions(k)
                end
            end
        end
    end
end

-- Trigger on Logout
function AutoBanishPets.onLogout()
    -- Dismiss combat pets
    if AutoBanishPets.savedVariables.logout.pets then
        AutoBanishPets.BanishPets()
    end
    -- Assistants are disabled automatically at logout.
    -- We can also dismiss non-combat pets and companions
    -- but they are resummoned like zombies at next login.
    -- I don't know the reason :(
end

-- Clear registers from time to time
function AutoBanishPets.onPlayerActivated()
    -- PVP/PVE zone detection
    if (IsPlayerInAvAWorld() or IsActiveWorldBattleground()) then
        if not AutoBanishPets.isInPVP then -- Zone changed from PVE to PVP
            AutoBanishPets:UnregisterEvents()
            AutoBanishPets.isInPVP = true
        end
    else
        if AutoBanishPets.isInPVP then -- Zone changed from PVP to PVE
            AutoBanishPets:RegisterEvents()
            AutoBanishPets.isInPVP = false
        end
    end

    -- Refresh registerUpdates
    for _, v in ipairs({"vanityPets", "assistants", "companions"}) do
        AutoBanishPets.UnregisterUpdate(v)
    end
end

-----------------------
--(UN)REGISTER EVENTS--
-----------------------
-- Register events
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
    -- Prehook
    ZO_PreHook("Logout", AutoBanishPets.onLogout)
end

-- Unregister events
function AutoBanishPets:UnregisterEvents()
    local EM = EVENT_MANAGER
    local ns = AutoBanishPets.name
    -- Combat events
    EM:UnregisterForEvent(ns .. "_COMBAT_START", EVENT_PLAYER_COMBAT_STATE)
    EM:UnregisterForEvent(ns .. "_COMBAT_END", EVENT_PLAYER_COMBAT_STATE)
    -- Other events
    EM:UnregisterForEvent(ns .. "_BANK", EVENT_OPEN_BANK)
    EM:UnregisterForEvent(ns .. "_GUILD_BANK", EVENT_OPEN_GUILD_BANK)
    EM:UnregisterForEvent(ns .. "_STORE", EVENT_OPEN_STORE)
    EM:UnregisterForEvent(ns .. "_GUILD_STORE", EVENT_OPEN_TRADING_HOUSE)
    EM:UnregisterForEvent(ns .. "_FENCE", EVENT_OPEN_FENCE)
    EM:UnregisterForEvent(ns .. "_CRAFT_STATION", EVENT_CRAFTING_STATION_INTERACT)
    EM:UnregisterForEvent(ns .. "_DYEING_STATION", EVENT_DYEING_STATION_INTERACT_START)
    EM:UnregisterForEvent(ns .. "_RETRAIT_STATION", EVENT_RETRAIT_STATION_INTERACT_START)
    EM:UnregisterForEvent(ns .. "_WAYSHRINE", EVENT_START_FAST_TRAVEL_INTERACTION)
    EM:UnregisterForEvent(ns .. "_QUEST_ADDED", EVENT_QUEST_ADDED)
    EM:UnregisterForEvent(ns .. "_QUEST_COMPLETE", EVENT_QUEST_COMPLETE_DIALOG)
    -- Prehook
    ZO_PreHook("Logout", function() end)
end

--------------------
--INITIALIZE ADDON--
--------------------
function AutoBanishPets:Initialize()
    AutoBanishPets.savedVariables = ZO_SavedVars:NewAccountWide("AutoBanishPetsSavedVars", AutoBanishPets.variableVersion, nil, AutoBanishPets.defaultSettings)
    AutoBanishPets.queuedId = { -- Table for resummoning
        ["vanityPets"] = 0,
        ["assistants"] = 0,
        ["companions"] = 0,
    }
    AutoBanishPets.isToggling = { -- We need this for lagging :(
        ["vanityPets"] = false,
        ["assistants"] = false,
        ["companions"] = false,
    }
    AutoBanishPets.unitClassId = GetUnitClassId("player")
    AutoBanishPets.isInPVP = false
    AutoBanishPets.CreateSettingsWindow() -- AutoBanishPetsSettings.lua
    AutoBanishPets:RegisterEvents()

    EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name, EVENT_PLAYER_ACTIVATED, AutoBanishPets.onPlayerActivated)

    EVENT_MANAGER:UnregisterForEvent(AutoBanishPets.name, EVENT_ADD_ON_LOADED)
end

function AutoBanishPets.OnAddOnLoaded(event, addonName)
    if (addonName == AutoBanishPets.name) then
        AutoBanishPets:Initialize()
    end
end

EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name, EVENT_ADD_ON_LOADED, AutoBanishPets.OnAddOnLoaded)