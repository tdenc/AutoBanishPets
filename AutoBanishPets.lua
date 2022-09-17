AutoBanishPets = AutoBanishPets or {}
local AutoBanishPets = AutoBanishPets

AutoBanishPets.name = "AutoBanishPets"
AutoBanishPets.version = "0.0.3"
AutoBanishPets.variableVersion = 3

AutoBanishPets.Default = {
    notification = true,
    pets = {
        bank = true,
        guildBank = true,
        store = true,
        guildStore = true,
        fence = true,
        craftStation = true,
        dyeingStation = true,
        retraitStation = true,
        wayshrine = false,
    },
    assistants = {
        craftStation = true,
        dyeingStation = true,
        retraitStation = true,
        wayshrine = false,
        combat = true,
    },
}

local function contains(list, value)
    for _, v in ipairs(list) do
        if v == value then
            return true
        end
    end
end

function AutoBanishPets.BanishPets()
    local numBuffs = GetNumBuffs("player")
	for i = 1, numBuffs do
		local _, _, _, buffSlot, _, _, _, _, _, _, abilityId, _ = GetUnitBuffInfo("player", i)
        if contains(AutoBanishPets.abilities[AutoBanishPets.unitClassId], abilityId) then
            CancelBuff(buffSlot)
            if (AutoBanishPets.savedVariables.notification) then
                df("[%s] %s", AutoBanishPets.name, GetString(ABP_NOTIFICATION_PETS))
            end
        end
	end
end

function AutoBanishPets.BanishAssistants()
    local activeAssistantId = GetActiveCollectibleByType(COLLECTIBLE_CATEGORY_TYPE_ASSISTANT)
    if activeAssistantId ~= 0 then
        local collectibleData = ZO_COLLECTIBLE_DATA_MANAGER:GetCollectibleDataById(activeAssistantId)
        collectibleData:Use()
        if (AutoBanishPets.savedVariables.notification) then
            df("[%s] %s", AutoBanishPets.name, GetString(ABP_NOTIFICATION_ASSISTANTS))
        end
    end
end

function AutoBanishPets.BanishAll()
    AutoBanishPets.BanishPets()
    AutoBanishPets.BanishAssistants()
end

function AutoBanishPets.onPlayerCombat(_, inCombat)
    if (inCombat) then
        AutoBanishPets.BanishAssistants()
    end
end

function AutoBanishPets:RegisterPetsEvents(unitClassId)
    if (unitClassId == 2 or unitClassId == 4) then
        if AutoBanishPets.savedVariables.pets.bank then
            EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name .. "_PETS", EVENT_OPEN_BANK, AutoBanishPets.BanishPets)
        end
        if AutoBanishPets.savedVariables.pets.guildBank then
            EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name .. "_PETS", EVENT_OPEN_GUILD_BANK, AutoBanishPets.BanishPets)
        end
        if AutoBanishPets.savedVariables.pets.store then
            EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name .. "_PETS", EVENT_OPEN_STORE, AutoBanishPets.BanishPets)
        end
        if AutoBanishPets.savedVariables.pets.guildStore then
            EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name .. "_PETS", EVENT_OPEN_TRADING_HOUSE, AutoBanishPets.BanishPets)
        end
        if AutoBanishPets.savedVariables.pets.fence then
            EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name .. "_PETS", EVENT_OPEN_FENCE, AutoBanishPets.BanishPets)
        end
        if AutoBanishPets.savedVariables.pets.craftStation then
            EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name .. "_PETS", EVENT_CRAFTING_STATION_INTERACT, AutoBanishPets.BanishPets)
        end
        if AutoBanishPets.savedVariables.pets.dyeingStation then
            EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name .. "_PETS", EVENT_DYEING_STATION_INTERACT_START, AutoBanishPets.BanishPets)
        end
        if AutoBanishPets.savedVariables.pets.retraitStation then
            EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name .. "_PETS", EVENT_RETRAIT_STATION_INTERACT_START, AutoBanishPets.BanishPets)
        end
        if AutoBanishPets.savedVariables.pets.wayshrine then
            EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name .. "_PETS", EVENT_START_FAST_TRAVEL_INTERACTION, AutoBanishPets.BanishPets)
        end
    end
end

function AutoBanishPets:RegisterAssistantsEvents()
    if AutoBanishPets.savedVariables.assistants.craftStation then
        EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name .. "_ASSISTANTS", EVENT_CRAFTING_STATION_INTERACT, AutoBanishPets.BanishAssistants)
    end
    if AutoBanishPets.savedVariables.assistants.dyeingStation then
        EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name .. "_ASSISTANTS", EVENT_DYEING_STATION_INTERACT_START, AutoBanishPets.BanishAssistants)
    end
    if AutoBanishPets.savedVariables.assistants.retraitStation then
        EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name .. "_ASSISTANTS", EVENT_RETRAIT_STATION_INTERACT_START, AutoBanishPets.BanishAssistants)
    end
    if AutoBanishPets.savedVariables.assistants.wayshrine then
        EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name .. "_ASSISTANTS", EVENT_START_FAST_TRAVEL_INTERACTION, AutoBanishPets.BanishAssistants)
    end
    if AutoBanishPets.savedVariables.assistants.combat then
        EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name .. "_ASSISTANTS", EVENT_PLAYER_COMBAT_STATE, AutoBanishPets.onPlayerCombat)
    end
end

function AutoBanishPets:Initialize()
    AutoBanishPets.savedVariables = ZO_SavedVars:NewAccountWide("AutoBanishPetsSavedVars", AutoBanishPets.variableVersion, nil, AutoBanishPets.Default)
    AutoBanishPets.CreateSettingsWindow()

    AutoBanishPets.unitClassId = GetUnitClassId("player")
    AutoBanishPets:RegisterPetsEvents(AutoBanishPets.unitClassId)
    AutoBanishPets:RegisterAssistantsEvents()

    EVENT_MANAGER:UnregisterForEvent(AutoBanishPets.name, EVENT_ADD_ON_LOADED)
end

function AutoBanishPets.OnAddOnLoaded(event, addonName)
    if (addonName == AutoBanishPets.name) then
        AutoBanishPets:Initialize()
    end
end

EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name, EVENT_ADD_ON_LOADED, AutoBanishPets.OnAddOnLoaded)