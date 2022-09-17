AutoBanishPets = AutoBanishPets or {}
local AutoBanishPets = AutoBanishPets

AutoBanishPets.name = "AutoBanishPets"
AutoBanishPets.version = "0.0.1"
AutoBanishPets.variableVersion = 1

AutoBanishPets.Default = {
    bank = true,
    guildBank = true,
    store = true,
    guildStore = true,
    fence = true,
	craftStation = true,
	dyeingStation = true,
	retraitStation = true,
	wayshrine = false,
    logon = false,
    notification = true,
}

local function contains(list, value)
    for _, v in ipairs(list) do
        if v == value then
            return true
        end
    end
end

function AutoBanishPets:Banish(list)
    local numBuffs = GetNumBuffs("player")
	for i = 1, numBuffs do
		local _, _, _, buffSlot, _, _, _, _, _, _, abilityId, _ = GetUnitBuffInfo("player", i)
        if contains(list, abilityId) then
            CancelBuff(buffSlot)
            if (AutoBanishPets.savedVariables.notification) then
                df("[%s] %s", AutoBanishPets.name, GetString(ABP_NOTIFICATION_STRING))
            end
        end
	end
end

function AutoBanishPets:Initialize()
    AutoBanishPets.savedVariables = ZO_SavedVars:NewAccountWide("AutoBanishPetsSavedVars", AutoBanishPets.variableVersion, nil, AutoBanishPets.Default)
    AutoBanishPets.CreateSettingsWindow()

    AutoBanishPets.unitClassId = GetUnitClassId("player")

    if AutoBanishPets.savedVariables.bank then
        EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name, EVENT_OPEN_BANK, AutoBanishPets.Trigger)
    end
    if AutoBanishPets.savedVariables.guildBank then
        EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name, EVENT_OPEN_GUILD_BANK, AutoBanishPets.Trigger)
    end
    if AutoBanishPets.savedVariables.store then
        EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name, EVENT_OPEN_STORE, AutoBanishPets.Trigger)
    end
    if AutoBanishPets.savedVariables.guildStore then
        EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name, EVENT_OPEN_TRADING_HOUSE, AutoBanishPets.Trigger)
    end
    if AutoBanishPets.savedVariables.fence then
        EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name, EVENT_OPEN_FENCE, AutoBanishPets.Trigger)
    end
    if AutoBanishPets.savedVariables.craftStation then
        EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name, EVENT_CRAFTING_STATION_INTERACT, AutoBanishPets.Trigger)
    end
    if AutoBanishPets.savedVariables.dyeingStation then
        EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name, EVENT_DYEING_STATION_INTERACT_START, AutoBanishPets.Trigger)
    end
    if AutoBanishPets.savedVariables.retraitStation then
        EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name, EVENT_RETRAIT_STATION_INTERACT_START, AutoBanishPets.Trigger)
    end
    if AutoBanishPets.savedVariables.wayshrine then
        EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name, EVENT_START_FAST_TRAVEL_INTERACTION, AutoBanishPets.Trigger)
    end
    if AutoBanishPets.savedVariables.logon then
        EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name, EVENT_PLAYER_ACTIVATED, AutoBanishPets.PlayerLoaded)
    end

    EVENT_MANAGER:UnregisterForEvent(AutoBanishPets.name, EVENT_ADD_ON_LOADED)
end

function AutoBanishPets.Trigger()
    if (AutoBanishPets.unitClassId == 2) then
        AutoBanishPets:Banish(AutoBanishPets.abilities.sorcerer)
    elseif (AutoBanishPets.unitClassId == 4) then
        AutoBanishPets:Banish(AutoBanishPets.abilities.warden)
    else
        return
    end
end

function AutoBanishPets.PlayerLoaded(_, initial)
    if (initial) then
        AutoBanishPets:Trigger()
    end
end

function AutoBanishPets.OnAddOnLoaded(event, addonName)
    if (addonName == AutoBanishPets.name) then
        AutoBanishPets:Initialize()
    end
end

EVENT_MANAGER:RegisterForEvent(AutoBanishPets.name, EVENT_ADD_ON_LOADED, AutoBanishPets.OnAddOnLoaded)