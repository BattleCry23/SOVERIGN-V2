mob
	proc
		set_stats(var/pp=1,var/eng=1,var/str=1,var/end=1,var/pot=1,var/res=1,var/acc=1,var/ref=1)
			src.energy = eng
			src.energy_max = eng
			src.psionic_power = pp
			src.strength = str
			src.endurance = end
			src.force = pot
			src.resistance = res
			src.offence = acc
			src.defence = ref
		Celestial_Wings()
			src.wings = global.celestial_wings[1]
			add_overlay(src, src.wings, TRUE)
			add_overlay(src, new/obj/effects/celestial_energy, TRUE)

mob
	races
		Human

			race = "Human"
			icon = 'NewMalesWhite(faceless).dmi'
			home_planet = "Earth"
			mortal = 1
			pixel_x_og = 0
			pixel_y_og = 0
			divine_energy_mod = 1
			dark_matter_mod = 1
			human_dna = 100
			mod_culinary = 0.4
			mod_zenkai = 0.5


			need_food = "Yes"
			need_water = "Yes"
			need_o2 = "Yes"
			need_sleep = "Yes"
			tiredness_rate = 0.1
			metabolic_rate = 0.1
			dehydration_rate = 0.1
			has_stomach = 1

			mod_psionic_power = 1
			psionic_power = 1


			percent_health = 100
			lifespan_gain = 2.4

			strength = 1
			endurance = 1
			force = 1
			resistance = 1
			offence = 1
			defence = 1
			psionic_power_base =1
			strength_base = 1
			endurance_base = 1
			force_base = 1
			resistance_base = 1
			offence_base = 1
			defence_base = 1
			mod_rating = 1
			mod_energy = 2
			mod_strength = 2
			mod_agility = 1.25
			mod_endurance = 2
			mod_force = 2
			mod_resistance = 2
			mod_offence = 2
			mod_defence = 2
			mod_regeneration = 1.5
			mod_recovery = 1.5
			mod_sense = 2
			mod_tech_potential = 1.45

			//Used to calculate the plus and minus of stats, when creating a char.
			gains_trained_power_mod = 1
			gains_trained_energy_mod = 1.5
			gains_trained_strength_mod = 1.
			gains_trained_endurance_mod = 1
			gains_trained_agility_mod = 1
			gains_trained_force_mod = 1
			gains_trained_resistance_mod = 1
			gains_trained_off_mod = 1
			gains_trained_def_mod = 1
			gains_trained_regen_mod = 1
			gains_trained_recov_mod = 1

			mod_immune_rads = 0
			mod_immune_cold = 0.1
			mod_immune_heat = 0.1
			mod_immune_gravity = 0
			mod_immune_microwaves = 0
			mod_immune_toxins = 0
			drug_tolerances = 100

			lifespan = 75
			has_hair = 1
			has_eyes = 1
			gains_trained_energy = 1
			New()
				..()
				lifespan = rand (52,62)
				oldage = lifespan
				prime=25
				max_anger = rand(125,145)

		Custom_Race
			race = "Human"
			icon = 'Human_Base_Male.dmi'
			mortal = 1
			pixel_x_og = 0
			pixel_y_og = 0
			divine_energy_mod = 1
			dark_matter_mod = 1

			need_food = "Yes"
			need_water = "Yes"
			need_o2 = "Yes"
			need_sleep = "Yes"
			tiredness_rate = 0.1
			metabolic_rate = 0.1
			dehydration_rate = 0.1
			has_stomach = 1

			mod_psionic_power = 1

			percent_health = 100

			strength = 10
			endurance = 10
			force = 10
			resistance = 10
			offence = 10
			defence = 10

			strength_base = 10
			endurance_base = 10
			force_base = 10
			resistance_base = 10
			offence_base = 10
			defence_base = 10
			mod_rating = 1
			mod_energy = 20
			mod_strength = 10
			mod_agility = 10
			mod_endurance = 10
			mod_force = 10
			mod_resistance = 10
			mod_offence = 10
			mod_defence = 10
			mod_regeneration = 10
			mod_recovery = 10
			mod_sense = 2
			mod_tech_potential = 4

			//Used to calculate the plus and minus of stats, when creating a char.


			mod_immune_rads = 0
			mod_immune_cold = 0.1
			mod_immune_heat = 0.1
			mod_immune_gravity = 0
			mod_immune_microwaves = 0
			mod_immune_toxins = 0

			lifespan = 80

			gains_trained_energy = 1
			New()
				..()
				prime = lifespan / 5

		Yukopian
			/*
			Namekian-style race
			- No bones, entirely plant-based
			- Stronger in sun light, get energy faster from it being daytime?
			- Weak to Cold/Heat
			- Regenerate from death when killed, so long as their seed-pod they were born in is still intact
			- Lay seed pods, instead of eggs
			- Their world can become thick with spores and de-buff others who visit, if they're not careful
			- Their heart is a seed and they can plant themselves into the ground. When they die, they also grow.
			- Can sprout into a mini world-tree using their heart-seed, which will power their plant-vine-network.

			Story goes their world was flooded, and it took years for their mega-world-tree to suck up all the water.
			Now the surviors must go about and cultivate the land once more, planting seeds and tending to the world.
			The more plants and trees that are created, the stronger their race becomes.
			*/
			race = "Namekian"
			icon = 'Yukopian_male_green.dmi'
			home_planet = "Namek"
			mortal = 1
			pixel_x_og = 0
			pixel_y_og = 0
			divine_energy_mod = 1
			dark_matter_mod = 1
			namekian_dna = 100
			lifespan_gain = 2
			mod_culinary = 0.2
			mod_zenkai = 0.8

			need_food = "No"
			need_water = "Yes"
			need_o2 = "Yes"
			need_sleep = "Yes"
			tiredness_rate = 0.075
			metabolic_rate = 0.1
			dehydration_rate = 0.1
			has_stomach = 0

			mod_psionic_power = 1.5
			mod_psionic_power_base = 1.5

			percent_health = 100

			strength = 1
			endurance = 1
			force = 1
			resistance = 1
			offence = 1
			defence = 1
			psionic_power_base =1
			strength_base = 1
			endurance_base = 1
			force_base = 1
			resistance_base = 1
			offence_base = 1
			defence_base = 1
			mod_rating = 1
			mod_energy = 2.8
			mod_strength = 1.3
			mod_agility = 1.2
			mod_endurance = 1
			mod_force = 1.8
			mod_resistance = 1.2
			mod_offence = 1
			mod_defence = 1
			mod_regeneration = 2
			mod_recovery = 1.6
			mod_sense = 4
			mod_tech_potential = 1.15

			//Used to calculate the plus and minus of stats, when creating a char.
			gains_trained_power_mod = 1.5
			gains_trained_energy_mod = 2.8
			gains_trained_strength_mod = 1
			gains_trained_endurance_mod = 1
			gains_trained_agility_mod = 1
			gains_trained_force_mod = 1
			gains_trained_resistance_mod = 1
			gains_trained_off_mod = 1
			gains_trained_def_mod = 2
			gains_trained_regen_mod = 2
			gains_trained_recov_mod = 1

			mod_immune_rads = 0
			mod_immune_cold = 2.5
			mod_immune_heat = 2.5
			mod_immune_gravity = 0
			mod_immune_microwaves = 0
			mod_immune_toxins = 0.5

			drug_tolerances = 75

			immune_cold_trained = 0.5
			immune_heat_trained = 0.5
			immune_toxins_trained = 0.5

			has_hair = 0
			has_eyes = 1

			lifespan = 125
			gains_trained_energy = 1
			New()
				..()
				lifespan = rand (102,112)
				oldage = lifespan
				prime=25
				src.max_anger = rand(125,140)

				/*src.ascensions = list()
				src.ascensions = list(new /:petrified_body,new /:dark_soul,new /:divine_body,new /:balanced_soul,new /:divine_mind,new /:namekian_ascension)
				for(var/obj/a in src.ascensions)
					a.name = a.info_name

				src.milestones = list()
				src.milestones = list(new /:microcosmic_orbit,new /:resilient_hide,new /:herculean_muscles,new /:unified_organs,new /:obliteration_fists, new/:dragonball_progenitor, new/:dragon_clan_awaken)
				for(var/obj/p in src.milestones)
					p.name = p.info_name

				src.soul = list()
				src.soul = list(new /:the_soul,new /:envy,new /:gluttony,new /:greed,new /:lust,new /:pride,new /:sloth,new /:wrath,new /:charity,new /:chastity,new /:diligence,new /:humility,new /:kindness,new /:patience,new /:temperance)
				for(var/obj/p in src.soul)
					p.name = p.info_name
					*/


		Changeling
			//Thanos style race
			race = "Changeling"
			icon = 'Frieza_1st_form.dmi'
			home_planet = "Icer"
			mortal = 1
			pixel_x_og = 0
			pixel_y_og = 0
			divine_energy_mod = 1
			dark_matter_mod = 1
			changeling_dna = 100
			lifespan_gain = 4
			mod_culinary = 0.1
			lifespan = 90
			need_food = "Yes"
			need_water = "Yes"
			need_o2 = "No"
			need_sleep = "Yes"
			tiredness_rate = 0.1
			metabolic_rate = 0.1
			dehydration_rate = 0.1
			has_stomach = 1
			mod_zenkai = 1

			mod_psionic_power = 15

			percent_health = 100

			strength = 1
			endurance = 1
			force = 2
			resistance = 2
			offence = 1
			defence = 1
			psionic_power_base =1
			strength_base = 1
			endurance_base = 1
			force_base = 1
			resistance_base = 1
			offence_base = 1
			defence_base = 1
			mod_rating = 1
			mod_energy = 1
			mod_strength = 1
			mod_agility = 1
			mod_endurance = 1
			mod_force = 1
			mod_resistance = 1
			mod_offence = 1
			mod_defence = 1
			mod_regeneration = 1
			mod_recovery = 1
			mod_sense = 2
			mod_tech_potential = 1

			drug_tolerances = 100

			//Used to calculate the plus and minus of stats, when creating a char

			mod_immune_rads = 0
			mod_immune_cold = 2
			mod_immune_heat = 0.1
			mod_immune_gravity = 0
			mod_immune_microwaves = 0
			mod_immune_toxins = 0
			gains_trained_energy_mod = 1.7
			gains_trained_energy = 1
			New()
				..()
				lifespan = rand (62,72)
				oldage = lifespan
				prime=25
				src.max_anger = rand(150,165)

			/*	src.ascensions = list()
				src.ascensions = list(new /:divine_body,new /:balanced_soul,new /:divine_mind,new /:petrified_body,new /:dark_soul)
				for(var/obj/a in src.ascensions)
					a.name = a.info_name

				src.milestones = list()
				src.milestones = list(new /:microcosmic_orbit,new /:resilient_hide,new /:herculean_muscles,new /:hardened_bones,new /:unified_organs, new /:obliteration_fists, new /:fused_ribcage,new /:limit_breaker)
				for(var/obj/p in src.milestones)
					p.name = p.info_name

				src.soul = list()
				src.soul = list(new /:the_soul,new /:envy,new /:gluttony,new /:greed,new /:lust,new /:pride,new /:sloth,new /:wrath,new /:charity,new /:chastity,new /:diligence,new /:humility,new /:kindness,new /:patience,new /:temperance,new /:nirvana)
				for(var/obj/p in src.soul)
					p.name = p.info_name
					*/
		Celestial
			race = "Kai"
			icon = 'humanoid_no_colour2.dmi'
			home_planet = "Heaven"
			pixel_x_og = 0
			pixel_y_og = 0
			divine_energy_mod = 1
			dark_matter_mod = 1
			kai_dna = 100
			need_food = "Yes"
			need_water = "Yes"
			need_o2 = "No"
			need_sleep = "Yes"
			tiredness_rate = 0.075
			metabolic_rate = 0.05
			dehydration_rate = 0.1
			has_stomach = 1
			lifespan_gain = 2.8
			mod_culinary = 0.2
			lifespan = 150
			mod_zenkai = 0.8

			mod_psionic_power = 2
			mod_psionic_power_base = 2

			percent_health = 100

			strength = 1
			endurance = 1
			force = 1
			resistance = 1
			offence = 1
			defence = 1
			psionic_power_base =1
			strength_base = 1
			endurance_base = 1
			force_base = 1
			resistance_base = 1
			offence_base = 1
			defence_base = 1
			mod_rating = 1
			mod_energy = 2.25
			mod_strength = 1.4
			mod_agility = 1.2
			mod_endurance = 1.4
			mod_force = 2
			mod_resistance = 1.4
			mod_offence = 1.2
			mod_defence = 1.2
			mod_regeneration = 1.3
			mod_recovery = 1.3
			mod_sense = 2
			mod_tech_potential = 1.15
			mod_skill = 1.35

			//Used to calculate the plus and minus of stats, when creating a char.
			gains_trained_power_mod = 2
			gains_trained_energy_mod = 2.5
			gains_trained_strength_mod = 1
			gains_trained_endurance_mod = 1
			gains_trained_agility_mod = 1
			gains_trained_force_mod = 1
			gains_trained_resistance_mod = 1
			gains_trained_off_mod = 1
			gains_trained_def_mod = 1
			gains_trained_regen_mod = 1
			gains_trained_recov_mod = 1

			mod_immune_rads = 1
			mod_immune_cold = 1
			mod_immune_heat = 0.1
			mod_immune_gravity = 0
			mod_immune_microwaves = 0
			mod_immune_toxins = 0

			drug_tolerances = 50

			mortal = 1
			has_hair = 1
			has_eyes = 1
			gains_trained_energy = 1
			New()
				..()
				lifespan = rand (112,500)
				oldage = lifespan
				prime=25
				src.max_anger = rand(140,150)

			/*	src.ascensions = list()
				src.ascensions = list(new /:whole_body,new /:divine_body,new /:divine_soul,new /:celestial_ascension)
				for(var/obj/a in src.ascensions)
					a.name = a.info_name

				src.milestones = list()
				src.milestones = list(new /:microcosmic_orbit,new /:resilient_hide,new /:herculean_muscles,new /:hardened_bones,new /:unified_organs,new /:obliteration_fists, new /:fused_ribcage, new/:wisdom, new/:radiance)
				for(var/obj/p in src.milestones)
					p.name = p.info_name

				src.soul = list()
				src.soul = list(new /:the_soul,new /:envy,new /:gluttony,new /:greed,new /:lust,new /:pride,new /:sloth,new /:wrath,new /:charity,new /:chastity,new /:diligence,new /:humility,new /:kindness,new /:patience,new /:temperance)
				for(var/obj/p in src.soul)
					p.name = p.info_name

				total_organs = length(global.grow_order)
				*/

		Tuffle
			race = "Tuffle"
			icon = 'NewMalesWhite(faceless).dmi'
			home_planet = "Vegeta"
			mortal = 1
			pixel_x_og = 0
			pixel_y_og = 0
			divine_energy_mod = 1
			dark_matter_mod = 1
			tuffle_dna = 100
			lifespan_gain = 2.8
			mod_culinary = 0.1
			mod_zenkai = 0.3

			mod_psionic_power = 1
			percent_health = 100
			strength = 1
			endurance = 1
			force = 1
			resistance = 2
			offence = 1
			defence = 1
			psionic_power_base =1
			strength_base = 1
			endurance_base = 1
			force_base = 1
			resistance_base = 2
			offence_base = 1
			defence_base = 1
			mod_rating = 1
			mod_energy = 1
			mod_strength = 1
			mod_agility = 1
			mod_endurance = 1
			mod_force = 1
			mod_resistance = 1
			mod_offence = 1
			mod_defence = 1
			mod_regeneration = 1
			mod_recovery = 1
			mod_sense = 2
			mod_tech_potential = 5
			gains_trained_energy_mod = 1.3
			//Used to calculate the plus and minus of stats, when creating a char.

			mod_immune_rads = 0
			mod_immune_cold = 0.1
			mod_immune_heat = 0.1
			mod_immune_gravity = 0
			mod_immune_microwaves = 0
			mod_immune_toxins = 0

			drug_tolerances = 75

			lifespan = 75

			has_stomach = 1

			gains_trained_energy = 1
			New()
				..()
				lifespan = rand (52,62)
				oldage = lifespan
				prime=25
				src.max_anger = rand(125,130)

			/*	src.ascensions = list()
				src.ascensions = list(new /:divine_body,new /:balanced_soul,new /:divine_mind,new /:human_ascension,new /:petrified_body,new /:dark_soul,new /:lichdom)
				for(var/obj/a in src.ascensions)
					a.name = a.info_name

				src.milestones = list()
				src.milestones = list(new /:microcosmic_orbit,new /:resilient_hide,new /:herculean_muscles,new /:hardened_bones,new /:unified_organs, new /:obliteration_fists, new /:fused_ribcage)
				for(var/obj/p in src.milestones)
					p.name = p.info_name

				src.soul = list()
				src.soul = list(new /:the_soul,new /:envy,new /:gluttony,new /:greed,new /:lust,new /:pride,new /:sloth,new /:wrath,new /:charity,new /:chastity,new /:diligence,new /:humility,new /:kindness,new /:patience,new /:temperance,new /:nirvana)
				for(var/obj/p in src.soul)
					p.name = p.info_name

			*/

		Alien
			//Aliens
			race = "Alien"
			pixel_x_og = 0
			pixel_y_og = 0
			skin_pos = 1
			mortal = 1
			divine_energy_mod = 1
			dark_matter_mod = 1
			alien_dna = 100
			lifespan_gain = 2.6
			mod_culinary = 0.25
			mod_zenkai = 0.5
			psionic_power_base =1
			need_food = "Yes"
			need_water = "Yes"
			need_o2 = "Yes"
			need_sleep = "Yes"
			tiredness_rate = 0
			metabolic_rate = 0.05
			dehydration_rate = 0.05
			has_stomach = 1

			mod_psionic_power = 1
			psionic_power = 1

			percent_health = 100

			strength = 1
			endurance = 1
			force = 1
			resistance = 1
			offence = 1
			defence = 1
			drug_tolerances = 100
			strength_base = 1
			endurance_base = 1
			force_base = 1
			resistance_base = 1
			offence_base = 1
			defence_base = 1
			mod_rating = 1
			mod_energy = 2
			mod_strength = 1.1
			mod_agility = 1.1
			mod_endurance = 1.1
			mod_force = 1.1
			mod_resistance = 1.1
			mod_offence = 1.1
			mod_defence = 1.1
			mod_regeneration = 1.1
			mod_recovery = 1.1
			mod_sense = 2
			mod_tech_potential = 2

			//Used to calculate the plus and minus of stats, when creating a char.
			gains_trained_power_mod = 1
			gains_trained_energy_mod = 1.4
			gains_trained_strength_mod = 1
			gains_trained_endurance_mod = 1
			gains_trained_agility_mod = 1
			gains_trained_force_mod = 1
			gains_trained_resistance_mod = 1
			gains_trained_off_mod = 1
			gains_trained_def_mod = 1
			gains_trained_regen_mod = 1
			gains_trained_recov_mod = 1

			mod_immune_rads = 0
			mod_immune_cold = 0.1
			mod_immune_heat = 0.1
			mod_immune_gravity = 0
			mod_immune_microwaves = 0
			mod_immune_toxins = 0.5

			immune_toxins_trained = 0.5

			lifespan = 90
			has_hair = 0
			has_eyes = 0
			gains_trained_energy = 1
			New()
				..()
				lifespan = rand (72,82)
				oldage = lifespan
				prime=25
				src.max_anger = rand(125,135)
			/*	src.ascensions = list()

				src.milestones = list()
				src.milestones = list(new /:microcosmic_orbit,new /:resilient_hide,new /:herculean_muscles,new /:hardened_bones,new /:unified_organs, new /:obliteration_fists, new /:fused_ribcage, new /:galatic_survivor)

				src.soul = list()
				src.soul = list(new /:the_soul,new /:envy,new /:gluttony,new /:greed,new /:lust,new /:pride,new /:sloth,new /:wrath,new /:charity,new /:chastity,new /:diligence,new /:humility,new /:kindness,new /:patience,new /:temperance)
				for(var/obj/p in src.soul)
					p.name = p.info_name
					*/
		HalfGod
			//Demi-gods?
			race = "Half God"
			icon = 'NewMalesWhite(faceless).dmi'
			mortal = 1
			pixel_x_og = 0
			pixel_y_og = 0
			divine_energy_mod = 1
			dark_matter_mod = 1
			half_god_dna = 100
			mod_psionic_power = 2

			percent_health = 100

			strength = 1
			endurance = 1
			force = 1
			resistance = 1
			offence = 1
			defence = 1
			psionic_power_base =1
			strength_base = 1
			endurance_base = 1
			force_base = 1
			resistance_base = 1
			offence_base = 1
			defence_base = 1
			mod_rating = 1
			mod_energy = 1
			mod_strength = 1
			mod_agility = 1
			mod_endurance = 1
			mod_force = 1
			mod_resistance = 1
			mod_offence = 1
			mod_defence = 1
			mod_regeneration = 1
			mod_recovery = 1
			mod_sense = 2
			mod_tech_potential = 1

			//Used to calculate the plus and minus of stats, when creating a char.
			gains_trained_energy_mod = 1.5
			mod_immune_rads = 0
			mod_immune_cold = 0.1
			mod_immune_heat = 0.1
			mod_immune_gravity = 0
			mod_immune_microwaves = 0
			mod_immune_toxins = 0

			mortal = 1
			lifespan = 46
			has_eyes = 1
			has_stomach = 1
			gains_trained_energy = 1
			New()
				..()
				prime = lifespan / rand(3,4.5)
				max_anger = rand(135,150)

		Imp
			race = "Oni"
			icon = 'oni_male_light.dmi'
			home_planet = "Checkpoint"
			skin_pos = 3
			mortal = 1
			pixel_x_og = 0
			pixel_y_og = 0
			divine_energy_mod = 1
			dark_matter_mod = 1
			oni_dna = 100
			lifespan_gain = 2.8
			mod_culinary = 0.1
			mod_zenkai = 0.3

			need_food = "Yes"
			need_water = "Yes"
			need_o2 = "Yes"
			need_sleep = "Yes"
			tiredness_rate = 0.05
			metabolic_rate = 0.05
			dehydration_rate = 0.05
			has_stomach = 1

			mod_psionic_power = 2

			percent_health = 100

			strength = 1
			endurance = 1
			force = 1
			resistance = 1
			offence = 1
			defence = 1
			psionic_power_base =1
			strength_base = 1
			endurance_base = 1
			force_base = 1
			resistance_base = 1
			offence_base = 1
			defence_base = 1
			mod_rating = 1
			mod_energy = 1.8
			mod_strength = 1.1
			mod_agility = 1.1
			mod_endurance = 1.1
			mod_force = 1.1
			mod_resistance = 1.1
			mod_offence = 1.1
			mod_defence = 1.1
			mod_regeneration = 1.2
			mod_recovery = 1.2
			mod_sense = 2
			mod_tech_potential = 4

			//Used to calculate the plus and minus of stats, when creating a char.
			gains_trained_power_mod = 2
			gains_trained_energy_mod = 1.4
			gains_trained_strength_mod = 1
			gains_trained_endurance_mod = 1
			gains_trained_agility_mod = 1
			gains_trained_force_mod = 1
			gains_trained_resistance_mod = 1
			gains_trained_off_mod = 1
			gains_trained_def_mod = 1
			gains_trained_regen_mod = 1
			gains_trained_recov_mod = 1

			mod_immune_rads = 0
			mod_immune_cold = 1
			mod_immune_heat = 1
			mod_immune_gravity = 0
			mod_immune_microwaves = 0
			mod_immune_toxins = 0
			drug_tolerances = 75
			lifespan = 90
			has_hair = 0
			has_eyes = 1
			gains_trained_energy = 1
			var/obj/onihornz = null

			New()
				..()
				lifespan = rand (102,112)
				oldage = lifespan
				prime=25
				src.max_anger = rand(125,135)
				var/obj/t = new /obj/overlay/horns/oni
				onihornz = t
				//onihornz.icon = 'OniHorns.dmi'
				onihornz.appearance_flags = t.appearance_flags
				onihornz.layer = t.layer
				//tailz.pixel_x = -12
				src.body_horns = onihornz
				add_overlay(src, body_horns)
			/*	src.ascensions = list()
				src.ascensions = list(new /:divine_mind,new /:petrified_body,new /:dark_soul)
				for(var/obj/a in src.ascensions)
					a.name = a.info_name

				src.milestones = list()
				src.milestones = list(new /:microcosmic_orbit,new /:resilient_hide,new /:herculean_muscles,new /:hardened_bones,new /:unified_organs,new /:obliteration_fists, new /:fused_ribcage)
				for(var/obj/p in src.milestones)
					p.name = p.info_name

				src.soul = list()
				src.soul = list(new /:the_soul,new /:envy,new /:gluttony,new /:greed,new /:lust,new /:pride,new /:sloth,new /:wrath,new /:charity,new /:chastity,new /:diligence,new /:humility,new /:kindness,new /:patience,new /:temperance)
				for(var/obj/p in src.soul)
					p.name = p.info_name

					*/
		Makyo
			race = "Makyo"
			icon = 'makyo.dmi'
			home_planet = "Earth"
			mortal = 1
			pixel_x_og = 0
			pixel_y_og = 0
			divine_energy_mod = 1
			dark_matter_mod = 1
			makyo_dna = 100
			mod_psionic_power = 1
			lifespan_gain = 2.2
			mod_culinary = 0.1
			mod_zenkai = 0.5

			percent_health = 100

			strength = 1
			endurance = 1
			force = 2
			resistance = 1
			offence = 1
			defence = 1
			psionic_power_base =1
			strength_base = 1
			endurance_base = 1
			force_base = 2
			resistance_base = 1
			offence_base = 1
			defence_base = 1
			mod_rating = 1
			mod_energy = 1.6
			mod_strength = 1.5
			mod_agility = 1.2
			mod_endurance = 2.5
			mod_force = 1.1
			mod_resistance = 1.1
			mod_offence = 1.4
			mod_defence = 1.4
			mod_regeneration = 1
			mod_recovery = 1
			mod_sense = 2
			mod_tech_potential = 1
			gains_trained_energy_mod = 1.4
			//Used to calculate the plus and minus of stats, when creating a char.
			drug_tolerances = 100
			mod_immune_rads = 0
			mod_immune_cold = 0.1
			mod_immune_heat = 0.1
			mod_immune_gravity = 1
			mod_immune_microwaves = 0
			mod_immune_toxins = 0
			lifespan = 80
			has_stomach = 1
			gains_trained_energy = 1
			New()
				..()
				lifespan = rand (59,70)
				oldage = lifespan
				prime=25
				src.max_anger = rand(135,150)

			/*	src.ascensions = list()
				src.ascensions = list(new /:divine_mind,new /:petrified_body,new /:dark_soul)
				for(var/obj/a in src.ascensions)
					a.name = a.info_name

				src.milestones = list()
				src.milestones = list(new /:microcosmic_orbit,new /:resilient_hide,new /:herculean_muscles,new /:hardened_bones,new /:unified_organs,new /:obliteration_fists, new /:fused_ribcage, new/:stars_favorite)
				for(var/obj/p in src.milestones)
					p.name = p.info_name

				src.soul = list()
				src.soul = list(new /:the_soul,new /:envy,new /:gluttony,new /:greed,new /:lust,new /:pride,new /:sloth,new /:wrath,new /:charity,new /:chastity,new /:diligence,new /:humility,new /:kindness,new /:patience,new /:temperance)
				for(var/obj/p in src.soul)
					p.name = p.info_name
					*/

		Spiritdoll
			race = "Spirit Doll"
			icon = 'spiritdoll.dmi'
			home_planet = "Earth"
			mortal = 1
			pixel_x_og = 0
			pixel_y_og = 0
			divine_energy_mod = 1
			dark_matter_mod = 1
			spirit_doll_dna = 100
			lifespan_gain = 2.2
			mod_culinary = 0.1
			mod_zenkai = 0.5

			mod_psionic_power = 1

			percent_health = 100

			strength = 1
			endurance = 1
			force = 2
			resistance = 1
			offence = 1
			defence = 1
			psionic_power_base =1
			strength_base = 1
			endurance_base = 1
			force_base = 1
			resistance_base = 1
			offence_base = 1
			defence_base = 1
			mod_rating = 1
			mod_energy = 2
			mod_strength = 1.2
			mod_agility = 1.3
			mod_endurance = 1
			mod_force = 2
			mod_resistance = 1.5
			mod_offence = 1
			mod_defence = 1
			mod_regeneration = 1.2
			mod_recovery = 1.2
			mod_sense = 2
			mod_tech_potential = 1
			gains_trained_energy_mod = 1.5
			//Used to calculate the plus and minus of stats, when creating a char.
			drug_tolerances = 100
			mod_immune_rads = 0
			mod_immune_cold = 0.1
			mod_immune_heat = 0.1
			mod_immune_gravity = 0
			mod_immune_microwaves = 0
			mod_immune_toxins = 0
			lifespan = 80
			has_stomach = 1
			gains_trained_energy = 1
			New()
				..()
				lifespan = rand (59,70)
				oldage = lifespan
				prime=25
				src.max_anger = rand(125,140)

			/*	src.ascensions = list()
				src.ascensions = list(new /:divine_mind,new /:petrified_body,new /:dark_soul)
				for(var/obj/a in src.ascensions)
					a.name = a.info_name

				src.milestones = list()
				src.milestones = list(new /:microcosmic_orbit,new /:resilient_hide,new /:herculean_muscles,new /:hardened_bones,new /:unified_organs,new /:obliteration_fists, new /:fused_ribcage, new/:spirit_shield)
				for(var/obj/p in src.milestones)
					p.name = p.info_name

				src.soul = list()
				src.soul = list(new /:the_soul,new /:envy,new /:gluttony,new /:greed,new /:lust,new /:pride,new /:sloth,new /:wrath,new /:charity,new /:chastity,new /:diligence,new /:humility,new /:kindness,new /:patience,new /:temperance)
				for(var/obj/p in src.soul)
					p.name = p.info_name

					*/
		Saiyan
			race = "Saiyan"
			icon = 'NewMalesWhite(faceless).dmi'
			home_planet = "Vegeta"
			mortal = 1
			pixel_x_og = 0
			pixel_y_og = 0
			divine_energy_mod = 1
			dark_matter_mod = 1
			looking_at_moon = 1
			saiyan_dna = 100
			lifespan_gain = 2.4
			mod_culinary = 0.1
			mod_zenkai = 1.4
			psionic_power_base =1
			need_food = "Yes"
			need_water = "Yes"
			need_o2 = "Yes"
			need_sleep = "Yes"
			tiredness_rate = 0.1
			metabolic_rate = 0.1
			dehydration_rate = 0.1
			has_stomach = 1

			mod_psionic_power = 2

			percent_health = 100

			strength = 1
			endurance = 1
			force = 1
			resistance = 1
			offence = 1
			defence = 1
			drug_tolerances = 100
			strength_base = 1
			endurance_base = 1
			force_base = 1
			resistance_base = 1
			offence_base = 1
			defence_base = 1
			mod_rating = 1
			mod_energy = 1.5
			mod_strength = 1.5
			mod_agility = 1.2
			mod_endurance = 1.5
			mod_force = 1.5
			mod_resistance = 1.5
			mod_offence = 1.8
			mod_defence = 1.8
			mod_regeneration = 1.2
			mod_recovery = 1.5
			mod_sense = 2
			mod_tech_potential = 1
			mod_skill = 1.5

			//Used to calculate the plus and minus of stats, when creating a char.

			gains_trained_energy_mod = 1.5

			mod_immune_rads = 0
			mod_immune_cold = 0.1
			mod_immune_heat = 0.1
			mod_immune_gravity = 0
			mod_immune_microwaves = 0
			mod_immune_toxins = 0

			lifespan = 95
			has_hair = 1
			has_eyes = 1
			gains_trained_energy = 1
			var/obj/tailz = null
			New()
				..()
				lifespan = rand (52,62)
				oldage = lifespan
				prime=25
				src.max_anger = rand(150,175)
				if(prob(25))
					src.max_anger += 25
					if(src.max_anger>=200) src.max_anger = 200

				var/obj/t = new /obj/overlay/tails/saiyan
				tailz = t
				switch(rand(1,3))
					if(1) tailz.icon = new /obj/overlay/tails/saiyan/black_tail
					if(2) tailz.icon = new /obj/overlay/tails/saiyan/brown_tail
					if(3) tailz.icon = new /obj/overlay/tails/saiyan/black_tail

				tailz.appearance_flags = t.appearance_flags
				tailz.layer = t.layer
				tailz.pixel_x = -12
				src.tail = tailz
				add_overlay(src, tailz)
			/*	src.ascensions = list()
				src.ascensions = list(new /:divine_mind,new /:petrified_body,new /:dark_soul)
				for(var/obj/a in src.ascensions)
					a.name = a.info_name

				src.milestones = list()
				src.milestones = list(new /:microcosmic_orbit,new /:resilient_hide,new /:herculean_muscles,new /:hardened_bones,new /:unified_organs,new /:obliteration_fists, new /:fused_ribcage, new/:ape_mastery, new/:battle_rage)
				for(var/obj/p in src.milestones)
					p.name = p.info_name

				src.soul = list()
				src.soul = list(new /:the_soul,new /:envy,new /:gluttony,new /:greed,new /:lust,new /:pride,new /:sloth,new /:wrath,new /:charity,new /:chastity,new /:diligence,new /:humility,new /:kindness,new /:patience,new /:temperance)
				for(var/obj/p in src.soul)
					p.name = p.info_name

					*/
		Android
			race = "Android"
			icon = 'android_default.dmi'
			mortal = 1
			pixel_x_og = 0
			pixel_y_og = 0
			divine_energy_mod = 0
			dark_matter_mod = 1
			lifespan_gain = 1
			mod_culinary = 0.1

			need_food = "No"
			need_water = "No"
			need_o2 = "No"
			need_sleep = "No"
			tiredness_rate = 0
			metabolic_rate = 0
			dehydration_rate = 0
			has_stomach = 0

			radius = 1

			mod_psionic_power = 3

			percent_health = 100

			strength = 1
			endurance = 1
			force = 1
			resistance = 1
			offence = 1
			defence = 1
			psionic_power_base =1
			strength_base = 1
			endurance_base = 1
			force_base = 1
			resistance_base = 1
			offence_base = 1
			defence_base = 1
			mod_rating = 1
			mod_energy = 2.5
			mod_strength = 1
			mod_agility = 1
			mod_endurance = 1
			mod_force = 1
			mod_resistance = 1
			mod_offence = 1
			mod_defence = 1
			mod_regeneration = 1
			mod_recovery = 1
			mod_sense = 2
			mod_tech_potential = 4

			//Used to calculate the plus and minus of stats, when creating a char.
			gains_trained_power_mod = 3
			gains_trained_energy_mod = 3
			gains_trained_strength_mod = 1
			gains_trained_endurance_mod = 1
			gains_trained_agility_mod = 1
			gains_trained_force_mod = 1
			gains_trained_resistance_mod = 1
			gains_trained_off_mod = 1
			gains_trained_def_mod = 1
			gains_trained_regen_mod = 1
			gains_trained_recov_mod = 1

			mod_immune_rads = 1
			mod_immune_cold = 1
			mod_immune_heat = 1
			mod_immune_gravity = 0.5
			mod_immune_microwaves = -0.5
			mod_immune_toxins = 2

			immune_rads_trained = 50
			immune_cold_trained = 50
			immune_heat_trained = 50
			immune_gravity_trained = 0.5
			immune_microwaves_trained = -0.5
			immune_toxins_trained = 2
			drug_tolerances = 0
			has_hair = 1
			has_eyes = 1
			lifespan = 1000
			gains_trained_energy = 1
			gains_trained_o2 = 0
			New()
				..()
				lifespan = rand (1000,2000)
				oldage = lifespan
				prime=25
			/*	src.soul = list()

				src.milestones = list()

				src.ascensions = list()
				src.ascensions = list(new /:robotic_ascension)
				for(var/obj/p in src.ascensions)
					p.name = p.info_name

					*/
				prime = lifespan / 5

		Demon
			/*
			Maybe give them the ability to manifest a sword made from bone.
			The more bodyparts they have, the longer they can remain in the mortal realms? Since they are made from ectoplasm, the more parts they have, the better than can remain.

			When they ascend, they can choose an aspect. So if they choose shadow/fire/diamond for example, their flesh becomes infused with shadow/fire/diamond.
			*/
			race = "Demon"
			icon = 'demon_default_male.dmi'
			home_planet = "Hell"
			pixel_x_og = 0
			pixel_y_og = 0
			divine_energy_mod = 1
			dark_matter_mod = 1
			psiforging_speed = 2
			demon_dna = 100
			lifespan_gain = 2.8
			mod_culinary = 0.2
			mod_zenkai = 0.8

			need_food = "Yes"
			need_water = "Yes"
			need_o2 = "No"
			need_sleep = "Yes"
			tiredness_rate = 0.075
			metabolic_rate = 0.1
			dehydration_rate = 0.05
			has_stomach = 1


			mod_psionic_power = 1.5

			percent_health = 100

			strength = 1
			endurance = 1
			force = 1
			resistance = 1
			offence = 1
			defence = 1
			psionic_power_base =1
			strength_base = 1
			endurance_base = 1
			force_base = 1
			resistance_base = 1
			offence_base = 1
			defence_base = 1
			mod_rating = 1
			mod_energy = 2
			mod_strength = 2.5
			mod_agility = 1.1
			mod_endurance = 1.4
			mod_force = 1.4
			mod_resistance = 1.2
			mod_offence = 1.2
			mod_defence = 1.2
			mod_regeneration = 1.5
			mod_recovery = 1.5
			mod_sense = 2
			mod_tech_potential = 1.18
			mod_skill = 3
			drug_tolerances = 75
			//Used to calculate the plus and minus of stats, when creating a char.
			gains_trained_power_mod = 1.5
			gains_trained_energy_mod = 2.3
			gains_trained_strength_mod = 1
			gains_trained_endurance_mod = 1
			gains_trained_agility_mod = 1
			gains_trained_force_mod = 1
			gains_trained_resistance_mod = 1
			gains_trained_off_mod = 1
			gains_trained_def_mod = 1
			gains_trained_regen_mod = 1
			gains_trained_recov_mod = 1

			mod_immune_rads = 1
			mod_immune_cold = 0.1
			mod_immune_heat = 1
			mod_immune_gravity = 0
			mod_immune_microwaves = 0
			mod_immune_toxins = 0

			immune_heat_trained = 1
			lifespan = 110
			mortal = 1
			has_hair = 1
			has_eyes = 1
			gains_trained_energy = 1
			var/obj/demonhornz = null
			New()
				..()
				lifespan = rand (112,122)
				oldage = lifespan
				aura_alignment = -1
			//	var/PPP=lifespan
				//PPP/=lifespan_gain
				prime=25
			//	prime = lifespan / rand(1.1,2)
				max_anger = rand(135,150)
				var/obj/t = new /obj/overlay/horns/demon/demon_2
				demonhornz = t
				//demonhornz.icon = 'Demonic Horns.dmi'
				demonhornz.appearance_flags = t.appearance_flags
				demonhornz.layer = t.layer
				//tailz.pixel_x = -12
				src.body_horns = demonhornz
				add_overlay(src, body_horns)
			/*	src.ascensions = list()
				src.ascensions = list(new /:whole_body,new /:dark_body,new /:dark_soul,new /:demonic_ascension, new/:lichdom)
				for(var/obj/a in src.ascensions)
					a.name = a.info_name

				src.milestones = list()
				src.milestones = list(new /:microcosmic_orbit,new /:resilient_hide,new /:herculean_muscles,new /:hardened_bones,new /:unified_organs,new /:obliteration_fists, new /:fused_ribcage, new/:dark_pact, new/:demonic_aura)
				for(var/obj/p in src.milestones)
					p.name = p.info_name

				src.soul = list()
				src.soul = list(new /:the_soul,new /:envy,new /:gluttony,new /:greed,new /:lust,new /:pride,new /:sloth,new /:wrath,new /:charity,new /:chastity,new /:diligence,new /:humility,new /:kindness,new /:patience,new /:temperance)
				for(var/obj/p in src.soul)
					p.name = p.info_name

				total_organs = length(global.grow_order)

				*/
