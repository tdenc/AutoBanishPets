AutoBanishPets = AutoBanishPets or {}
local AutoBanishPets = AutoBanishPets

AutoBanishPets.abilities = {
    [SKILL_TYPE_CLASS] = {
        [2] = { -- Sorcerer
            -- Familiars and Clannfears
            [23304] = true, [30631] = true, [30636] = true, [30641] = true,
            [23319] = true, [30647] = true, [30652] = true, [30657] = true,
            [23316] = true, [30664] = true, [30669] = true, [30674] = true,
            -- Twilights
            [24613] = true, [30581] = true, [30584] = true, [30587] = true,
            [24636] = true, [30592] = true, [30595] = true, [30598] = true,
            [24639] = true, [30618] = true, [30622] = true, [30626] = true,
        },
        [4] = { -- Warden
            -- Bears
            [85982] = true, [85983] = true, [85984] = true, [85985] = true,
            [85986] = true, [85987] = true, [85988] = true, [85989] = true,
            [85990] = true, [85991] = true, [85992] = true, [85993] = true,
        },
    },
    [SKILL_TYPE_WORLD] = {
        [5] = { -- Vampire
            [32624] = true, [32624] = true, [32624] = true, [32624] = true,
	    	[38932] = true, [38932] = true, [38932] = true, [38932] = true,
	        [38931] = true, [38931] = true, [38931] = true, [38931] = true,
        },
        [6] = { -- Werewolf
		    [32455] = true, [32455] = true, [32455] = true, [32455] = true,
		    [39075] = true, [39075] = true, [39075] = true, [39075] = true,
		    [39076] = true, [39076] = true, [39076] = true, [39076] = true,
        }
    }
}

AutoBanishPets.companions = {
    [1] = 9245, -- Bastian
    [2] = 9353, -- Mirri
}

AutoBanishPets.bankers = {
    [267] = true, -- Tythis
    [6376] = true, -- Ezabi
    [8994] = true, -- Baron
}

AutoBanishPets.merchants = {
    [301] = true, -- Nuzhimeh
    [6378] = true, -- Fezez
    [8995] = true, -- Peddler
}

AutoBanishPets.armoryAssistants = {
    [9745] = true, -- Ghrasharog
}

AutoBanishPets.fences = {
    [300] = true, -- Pirharri
}

AutoBanishPets.dislikeLocations = {
    [9245] = {},
    [9353] = {
        [826] = true, -- Dark Brotherhood Sanctuary
    },
}

AutoBanishPets.thievesTrove = {
    ["Thieves Trove"] = true, ["Diebesgut^ns"] = true, ["trésor des voleurs^m"] = true, ["Воровской клад"] = true, ["盗賊の宝"] = true,
}

AutoBanishPets.torchbug = {
    ["Butterfly"] = true, ["Schmetterling"] = true, ["papillon"] = true, ["Бабочка"] = true, ["蝶"] = true,
    ["Torchbug"] = true, ["Fackelkäfer"] = true, ["flammouche"] = true, ["Светлячок"] = true, ["ホタル"] = true,
}