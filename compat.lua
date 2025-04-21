-- Note: Jen's dependencies will also have to be updated to not display as incompatible.

-- Things that are not yet included:
-- Banned cards in challenges (I think these need a full update anyway)
-- POINTER changes (I want to make an easier way for mods to update these)
-- Gameset patches

-- Take ownership calls
SMODS.Back:take_ownership("b_cry_encoded", {
	apply = function(self)
		G.GAME.joker_rate = 1
		G.GAME.planet_rate = 1
		G.GAME.tarot_rate = 1
		G.GAME.code_rate = 1e100
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.jokers then
					if
						G.P_CENTERS["j_cry_CodeJoker"]
						and (G.GAME.banned_keys and not G.GAME.banned_keys["j_cry_CodeJoker"])
					then
						local card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_cry_CodeJoker")
						card:add_to_deck()
						card:start_materialize()
						G.jokers:emplace(card)
					end
					return true
				end
			end,
		}))
	end,
})
SMODS.ConsumableType:take_ownership("cry_code", {
    default = "c_cry_oboe",
})
SMODS.Consumable:take_ownership("c_cry_pointer", {
    loc_vars = function(self, info_queue, center)
        print("m")
        return {key = "jen_pointer", set = "Other"}
    end
})
SMODS.Consumable:take_ownership("c_cry_gateway", {
    can_use = function(self, card)
		if (#SMODS.find_card("j_jen_saint") + #SMODS.find_card("j_jen_saint_attuned")) > 0 then
			return #G.jokers.cards < G.jokers.config.card_limit
		else
			--Don't allow use if everything is eternal and there is no room
			return #Cryptid.advanced_find_joker(nil, nil, nil, { "eternal" }, true, "j") < G.jokers.config.card_limit
		end
	end,
	use = function(self, card, area, copier)
		if (#SMODS.find_card("j_jen_saint") + #SMODS.find_card("j_jen_saint_attuned")) <= 0 then
			local deletable_jokers = {}
			for k, v in pairs(G.jokers.cards) do
				if not v.ability.eternal then
					deletable_jokers[#deletable_jokers + 1] = v
				end
			end
			local _first_dissolve = nil
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 0.75,
				func = function()
					for k, v in pairs(deletable_jokers) do
						if v.config.center.rarity == "cry_exotic" then
							check_for_unlock({ type = "what_have_you_done" })
						end
						v:start_dissolve(nil, _first_dissolve)
						_first_dissolve = true
					end
					return true
				end,
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.4,
			func = function()
				play_sound("timpani")
				local card = create_card("Joker", G.jokers, nil, "cry_exotic", nil, nil, nil, "cry_gateway")
				card:add_to_deck()
				G.jokers:emplace(card)
				card:juice_up(0.3, 0.5)
				return true
			end,
		}))
		delay(0.6)
	end,
})
SMODS.Event:take_ownership("ev_cry_choco1", {
    start = function(self)
		G.GAME.events[self.key] = true
		local areas = { "jokers", "deck", "hand", "play", "discard" }
		for k, v in pairs(areas) do
			for i = 1, #G[v].cards do
				if pseudorandom(pseudoseed("cry_choco_possession")) < G.GAME.probabilities.normal / 3 then
					SMODS.Stickers.cry_flickering:apply(G[v].cards[i], true)
				end
			end
		end
		--DON'T create a ghost
		if G.GAME.dollars ~= 0 then
            ease_dollars((-G.GAME.dollars - 1e6), true)
        end
	end,
})

function Cryptid.gameset(card, center)
    return "madness"
end

-- This will have to get added to Jen's process_loc_text function
function SMODS.current_mod.process_loc_text()
    G.localization.descriptions.Other["jen_pointer"] = {
        name = "POINTER://",
        text = {
            "Create a card",
            "of {C:cry_code}your choice",
            "{C:inactive,s:0.8}(Exotic Jokers and OMEGA consumables excluded)",
        },
    }
end
local aliases = {
	kosmos = "",
	freddy = "freddy snowshoe",
	paupovlin = "paupovlin revere",
	poppin = "paupovlin revere",
	dandy = 'Dandicus "Dandy" Dancifer',
	jen = "jen walter",
	jen2 = "Jen Walter the Wondergeist",
	jen3 = "Jen Walter the Wondergeist (Ascended)",
	survivor = "the survivor",
	monk = "the monk",
	hunter = "the hunter",
	gourmand = "the gourmand",
	saint = "the saint",
	genius = "the genius",
	r_fool = "the genius",
	scientist = "the scientist",
	r_magician = "the scientist",
	lowlaywoman = "the low laywoman",
	laywoman = "the low laywoman",
	r_priestess = "the low laywoman",
	peasant = "the peasant",
	r_empress = "the peasant",
	servant = "the servant",
	r_emperor = "the servant",
	adversary = "the adversary",
	r_hierophant = "the adversary",
	rivals = "the rivals",
	r_lovers = "the rivals",
	hitchhiker = "the hitchhiker",
	r_chariot = "the hitchhiker",
	injustice = "c_jen_reverse_justice",
	r_justice = "c_jen_reverse_justice",
	extrovert = "the extrovert",
	r_hermit = "the extrovert",
	discofpenury = "the disc of penury",
	r_wheeloffortune = "the disc of penury",
	r_wof = "the disc of penury",
	infirmity = "infirmity",
	r_strength = "infirmity",
	zen = "zen",
	r_hangedman = "zen",
	life = "life",
	r_death = "life",
	prodigality = "prodigality",
	r_temperance = "prodigality",
	angel = "the angel",
	r_devil = "the angel",
	collapse = "the collapse",
	r_tower = "the collapse",
	flash = "the flash",
	r_star = "the flash",
	eclipsespectral = "c_jen_reverse_moon",
	eclipsetorat = "c_jen_reverse_moon",
	r_moon = "c_jen_reverse_moon",
	darkness = "the darkness",
	r_sun = "the darkness",
	cunctation = "cunctation",
	r_judgement = "cunctation",
	desolate = "desolate",
	r_world = "desolate",
	-- jen tokens
	topuptoken = "top-up token",
	sagittarius = "sagittarius a*",
	["sagitarius a*"] = "sagittarius a*", --minor spelling mistakes are forgiven
	sagitarius = "sagittarius a*", --minor spelling mistakes are forgiven
}
for k, v in pairs(aliases) do
	Cryptid.aliases[k] = v
end
