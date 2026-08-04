#define SMALL 1
#define MEDIUM 2
#define LARGE 3
/*
.:Cheat sheet for character creation:.

create_research()
	- Creates all the research for a player and puts it into their technology list

create_body()
	- Creates the players body, first creating the bodyparts list, then adding bodyparts(head,torso,leftarm,rightarm,rightleg,leftleg)
	- head
	- torso
	- leftarm
	- rightarm
	- rightleg
	- leftleg

create_menus()
	- Creates all the main menus for the player
	- Is activated on world startup, using the empty player shells that are stored

create_races()
	- Only used once and on world creation
	- Creates 100 of each race and stores them in a list
	- Player then gets made into one of these empty shells, filling them

set_lists()
	- A special proc run only once per race, that sets up all their lists to = list()
	- Supposed to help with game memory allocation, especially on objects
	- Reason being because when you assign a list() in vars, then use new to create a mob/obj, it will use resources to allocate a new list
	- Using list = list() is supposed to help stop unneeded allocation

.:Things that share a loc with a player:.
    --- i.e, Meditation.loc = usr ---

	- All skills are inside the player
	- All menus are inside the player
	- All inventory objs are inside the player
	- Avatar/Player portrait

.:Player tech buttons:.
	- The button codes are located at /obj/hud/buttons/expand_buttons/tech_expand_buttons, which consist of engineering, genetics and physics
	- The buttons are actually the ones responsible/setup for creating what tech is displayed when clicked or first opening the menus
	- The expand_button is the one responsible for setting up what is displayed under the "Build Tech" tab
	- Excpand buttons uses create_expand_buttons() to create all the tech that can be clicked on, which the player has already researched
	- The create_expand_buttons() proc makes sure to link the button for that tech with the actual tech, using the tech_ref var
*/

mob
	proc
		confirm_creation()
			src.confirm = "confirm char"
			src.confirm_text = "Confirm this character?"
			//var/t = winget(src,"char_creation.input_name","text")
			var/obj/n = src.hud_char.name_input
		//	var/obj/l = src.hud_char.string_full
			var/x = n.string_full
			var/t = n.maptext
			if(src.creature_started == 0)

				if(src.icon == null)
					src.confirm_text = "Dont try and bug abuse, choose a skin color now!."
					src.hud_confirm.confirm_text(1,"[src.confirm_text]",src)
					src.confirm = "cancel char"
					return

				if(src.mod_points_spent < 5)
					src.confirm_text = "Confirm this character? You still have points to spend."

				if(t == "" || t == null || t == " " || t == "[css_outline]<font size = 1><left>")
					t = "[src.key]"
					src.confirm_text = "Confirm this character? No name selected."
					t = src.key
				if(findtext(t, "[css_outline]<font size=1><left>"))
					// Remove everything up to and including "<left>"
					var/start_pos = findtext(t, "<left>")
					if (start_pos)
						t = copytext(t, start_pos + 6) // 6 is the length of "<left>"

				if(!t && src.mod_points_spent < 5)
					src.confirm_text = "Confirm? You still have points to spend and no name."
				if(global.names_taken.Find(t) || findtext(t,"npc") || findtext(t,"Name"))
					src.confirm_text = "That name is already taken."
					//winset(src,"confirm.label_confirm","text=\"[src.confirm_text]\"")
					//winset(src,"confirm.cross","is-disabled=true")
					//winshow(src,"confirm",1)
					src.hud_confirm.confirm_text(1,"[src.confirm_text]",src)
					src.confirm = "cancel char"
					return
				if(src.age==1 || !src.age|| !src.age_selected || src.age_selected == null )
					src.confirm_text = "You need to select an age."
					src.hud_confirm.confirm_text(1,"[src.confirm_text]",src)
					src.confirm ="cancel char"
					return
				src.name = x
				src.real_name = x
				src.fullname = x
		//	src.name = "[src.typing.string_full]"
		//	src.real_name = "[src.typing.string_full]"
		//	src.fullname = "[src.typing.string_full]"
			//src.ai_name = t
			//winset(src,"confirm.label_confirm","text=\"[src.confirm_text]\"")
			//winset(src,"confirm","pos=[src.scrwidth/2],[src.scrheight/2]")
			//winshow(src,"confirm",1)
			src.hud_confirm.confirm_text(1,"[src.confirm_text]",src)
		reset_modsages()
			src.mod_points_spent = 0
			if(src.race == "Alien") src.mod_points = 15
			else src.mod_points = 5
			src.mod_energy_points = 0
			src.mod_strength_points = 0
			src.mod_endurance_points = 0
			src.mod_agility_points = 0
			src.mod_force_points = 0
			src.mod_resistance_points = 0
			src.mod_offence_points = 0
			src.mod_defence_points = 0
			src.mod_regeneration_points = 0
			src.mod_recovery_points = 0

			src.mod_energy = initial(src.mod_energy)
			src.mod_strength = initial(src.mod_strength)
			src.mod_agility = initial(src.mod_agility)
			src.mod_endurance = initial(src.mod_endurance)
			src.mod_force = initial(src.mod_force)
			src.mod_resistance = initial(src.mod_resistance)
			src.mod_offence = initial(src.mod_offence)
			src.mod_defence = initial(src.mod_defence)
			src.mod_regeneration = initial(src.mod_regeneration)
			src.mod_recovery = initial(src.mod_recovery)
			src.mod_sense = initial(src.mod_sense)
			src.mod_tech_potential = initial(src.mod_tech_potential)

			src.mod_energy_base = initial(src.mod_energy_base)
			src.mod_strength_base = initial(src.mod_strength_base)
			src.mod_endurance_base = initial(src.mod_endurance_base)
			src.mod_agility_base = initial(src.mod_agility_base)
			src.mod_force_base = initial(src.mod_force_base)
			src.mod_resistance_base = initial(src.mod_resistance_base)
			src.mod_offence_base = initial(src.mod_offence_base)
			src.mod_defence_base = initial(src.mod_defence_base)
			src.mod_regeneration_base = initial(src.mod_regeneration_base)
			src.mod_recovery_base = initial(src.mod_recovery_base)

			src.gains_trained_power_mod = initial(src.gains_trained_power_mod)
			src.gains_trained_energy_mod = initial(src.gains_trained_energy_mod)
			src.gains_trained_strength_mod = initial(src.gains_trained_strength_mod)
			src.gains_trained_endurance_mod = initial(src.gains_trained_endurance_mod)
			src.gains_trained_agility_mod = initial(src.gains_trained_agility_mod)
			src.gains_trained_force_mod = initial(src.gains_trained_force_mod)
			src.gains_trained_resistance_mod = initial(src.gains_trained_resistance_mod)
			src.gains_trained_off_mod = initial(src.gains_trained_off_mod)
			src.gains_trained_def_mod = initial(src.gains_trained_def_mod)
			src.gains_trained_regen_mod = initial(src.gains_trained_regen_mod)
			src.gains_trained_recov_mod = initial(src.gains_trained_recov_mod)
		reset_mods()
			src.mod_points_spent = 0
			if(src.race == "Alien") src.mod_points = 15
			else src.mod_points = 5
			src.mod_energy_points = 0
			src.mod_strength_points = 0
			src.mod_endurance_points = 0
			src.mod_agility_points = 0
			src.mod_force_points = 0
			src.mod_resistance_points = 0
			src.mod_offence_points = 0
			src.mod_defence_points = 0
			src.mod_regeneration_points = 0
			src.mod_recovery_points = 0

			src.mod_energy = initial(src.mod_energy)
			src.mod_strength = initial(src.mod_strength)
			src.mod_agility = initial(src.mod_agility)
			src.mod_endurance = initial(src.mod_endurance)
			src.mod_force = initial(src.mod_force)
			src.mod_resistance = initial(src.mod_resistance)
			src.mod_offence = initial(src.mod_offence)
			src.mod_defence = initial(src.mod_defence)
			src.mod_regeneration = initial(src.mod_regeneration)
			src.mod_recovery = initial(src.mod_recovery)
			src.mod_sense = initial(src.mod_sense)
			src.mod_tech_potential = initial(src.mod_tech_potential)

			src.mod_energy_base = initial(src.mod_energy_base)
			src.mod_strength_base = initial(src.mod_strength_base)
			src.mod_endurance_base = initial(src.mod_endurance_base)
			src.mod_agility_base = initial(src.mod_agility_base)
			src.mod_force_base = initial(src.mod_force_base)
			src.mod_resistance_base = initial(src.mod_resistance_base)
			src.mod_offence_base = initial(src.mod_offence_base)
			src.mod_defence_base = initial(src.mod_defence_base)
			src.mod_regeneration_base = initial(src.mod_regeneration_base)
			src.mod_recovery_base = initial(src.mod_recovery_base)

			src.gains_trained_power_mod = initial(src.gains_trained_power_mod)
			src.gains_trained_energy_mod = initial(src.gains_trained_energy_mod)
			src.gains_trained_strength_mod = initial(src.gains_trained_strength_mod)
			src.gains_trained_endurance_mod = initial(src.gains_trained_endurance_mod)
			src.gains_trained_agility_mod = initial(src.gains_trained_agility_mod)
			src.gains_trained_force_mod = initial(src.gains_trained_force_mod)
			src.gains_trained_resistance_mod = initial(src.gains_trained_resistance_mod)
			src.gains_trained_off_mod = initial(src.gains_trained_off_mod)
			src.gains_trained_def_mod = initial(src.gains_trained_def_mod)
			src.gains_trained_regen_mod = initial(src.gains_trained_regen_mod)
			src.gains_trained_recov_mod = initial(src.gains_trained_recov_mod)

			src.hair_pos = 1
			src.eye_pos = 1
			src.mouth_pos = 1
			if(src.age>=13 || src.age == null || src.age == 1) src.horn_pos = 1
			else if(src.age <=4 && src.race !="Saiyan") src.horn_pos = 2
			src.nose_pos = 1
			src.skin_pos = 1
			src.body_pos = 1
			if(src.has_hair) src.hair_pos = 12
		set_info_box()
			if(src.info_box1) src.info_box1.destroy()
			if(src.info_box2) src.info_box2.destroy()
			if(src.info_box3) src.info_box3.destroy()

			var/obj/o1 = new
			o1.icon = 'new_hud_pixel.dmi'
			o1.plane = 40
			o1.layer = 40

			o1.appearance_flags = PIXEL_SCALE
			o1.mouse_opacity = 0
			src.info_box1 = o1

			var/obj/o2 = new
			o2.icon = 'new_hud_tiny_box.dmi'
			o2.plane = 40
			o2.layer = 41
			o2.appearance_flags = PIXEL_SCALE
			o2.mouse_opacity = 0
			src.info_box2 = o2

			var/obj/o3 = new
			o3.icon = null
			o3.plane = 40
			o3.layer = 42
			o3.maptext_x = 7
			o3.maptext_y = 1
			o3.appearance_flags = PIXEL_SCALE
			o3.mouse_opacity = 0
			src.info_box3 = o3
		apply_offspring_profile(datum/offspring_profile/O)
			if(!O)
				//CRASH("apply_offspring_profile() called without valid offspring profile")
				world<<"apply_offspring_profile() called without valid offspring profile"
			//world<<"INSTALLING BASIC IDENTITY"
				// === Basic Identity ===
			name = O.name
			real_name = O.real_name
			fullname = O.real_name
			gen = O.gen
			gender = lowertext(O.gen)
			Father = "[O.Father]"
			Mother = "[O.Mother]"
			generational_pg = O.PG
			generation_lvl = O.generation_lvl
			race = O.race
			if(O.recessive_race) recessive_race = O.recessive_race
			if(O.alien_dna) alien_dna = O.alien_dna
			if(O.makyo_dna) makyo_dna = O.makyo_dna
			if(O.tuffle_dna) tuffle_dna = O.tuffle_dna
			if(O.demon_dna) demon_dna = O.demon_dna
			if(O.kai_dna) kai_dna = O.kai_dna
			if(O.spirit_doll_dna) spirit_doll_dna = O.spirit_doll_dna
			if(O.oni_dna) oni_dna = O.oni_dna
			if(O.changeling_dna) changeling_dna = O.changeling_dna
			if(O.saiyan_dna) saiyan_dna = O.saiyan_dna
			if(O.namekian_dna) namekian_dna = O.namekian_dna

			// === Check for Hybrid Race ===
			var/dna_count = 0
			if(alien_dna) dna_count++
			if(makyo_dna) dna_count++
			if(tuffle_dna) dna_count++
			if(demon_dna) dna_count++
			if(kai_dna) dna_count++
			if(spirit_doll_dna) dna_count++
			if(oni_dna) dna_count++
			if(changeling_dna) dna_count++
			if(saiyan_dna) dna_count++
			if(namekian_dna) dna_count++
			if(human_dna) dna_count++
			if(recessive_race) dna_count++
			if(dna_count > 1)
				is_hybrid = 1


			//creature_started = 1
			offspring = 1
			//world<<"INSTALLING CORE MODS"
			// === Core Inherited Mods ===
			mod_strength     = O.mod_strength
			mod_energy       = O.mod_energy
			mod_agility      = O.mod_agility
			mod_endurance    = O.mod_endurance
			mod_defence      = O.mod_defence
			mod_force        = O.mod_force
			mod_recovery     = O.mod_recovery
			mod_regeneration = O.mod_regeneration
			mod_resistance   = O.mod_resistance
			mod_psionic_power = O.mod_psionic_power
			mod_psionic_power_base = O.mod_psionic_power_base
			energy_max = O.energy_max
			gains_trained_energy = O.gains_trained_energy
			//world<<"APPLYING STATS"
			// === START UP STATS ===

			strength = 200
			endurance = 200
			force = O.force
			resistance = O.resistance
			offence = O.offence
			defence = O.defence
			mod_agility = O.mod_agility
			psionic_power = O.psionic_power


			//world<<"APPLYING APPEARANCE"
			// === Appearance ===
			hair_c   = O.hair_c
			eye_c    = O.eye_c
			saved_hair_c = O.hair_c
			saved_eye_c = O.eye_c
			skin_pos = O.skin_pos
			hair_pos = O.hair_pos
			body_pos = O.body_pos
			nose_pos = O.nose_pos
			eye_pos = O.eye_pos
			bodysize = O.bodysize

			if(race == "Alien" || race == "Chageling" || race == "Namekian" || race == "Kai" || race == "Demon" || race == "Makyo")
				if(gen == "Female")
					icon = 'namekian_egg.dmi'
				else
					icon = 'alien_egg.dmi'
			// Give them a default baby icon if needed
			if(race == "Saiyan" || race == "Spirit Doll" || race == "Tuffle" || race == "Human")
				if(gen == "Female")
					icon = 'human_babyfemale.dmi'
				else
					icon = 'human_babymale.dmi'

			// === Mutations ===
			if(O.mutation_types)
				//world<<"Found mutations in [O.name]!"
				for(var/mutations/typepath in O.mutation_types)
				//	world<<"Applying Mutation [typepath]"
					mutations += typepath
					typepath.ApplyMutation(list(typepath), src)

			// === Final Cleanup ===
			age = 0.1
			age_soul = 0.1
			age_text = "Baby"
			sight = 0
			//Savable = 1
			//Hand = "Left"
			started = 0
			//choosing_character = 0
			savedloc = O.spawn_point
		//	creature_started = 1
		//	offspring = 1

			//MapZoom()
		//	src << "Finishing INHERITENCE!"
			// === Optional Visual Polish ===
			if(eyes)
				eyes.color = eye_c
			//if(overlays && hair_pos)
				//overlays += hair  // Just ensures they appear visually correct

			// === Log Output (debug mode) ===
		//	world << "<b>[src]</b> has inherited the genetics of [O.Father] and [O.Mother]!"


		start_newborn()
			set waitfor = FALSE
			set hidden = 1

			if(!ActiveChildren || !ActiveChildren.len)
				src << "There are no available offspring to be born into."
				return

			// === Select offspring profile ===
			var/datum/offspring_profile/profile = input(src, "Choose an offspring to be born as:") in ActiveChildren + list("Cancel")
			if(profile == "Cancel" || !profile)
				return

			// === Password check ===
			if(profile.password && profile.password != "")
				var/pw = input(src, "Enter the password for [profile.name]:") as text
				if(pw != profile.password)
					src << "Incorrect password."
					return

			// === Confirm details ===
			var/confirm = alert(src,
				"Child: [profile.name]\nRace: [profile.race]\nParents: [profile.Father] and [profile.Mother]\n\nContinue?",
				"Confirm Birth", "Continue", "Return")
			if(confirm != "Continue")
				return

		//	src << "Preparing to begin life as [profile.name]..."
			sleep(2)

			// === STEP 1: Create base race mob (the newborn body) ===
			var/mob/races/newborn = null
			switch(profile.race)
				if("Saiyan")     newborn = new /mob/races/Saiyan
				if("Human")      newborn = new /mob/races/Human
				if("Demon")      newborn = new /mob/races/Demon
				if("Kai")        newborn = new /mob/races/Celestial
				if("Namekian")   newborn = new /mob/races/Yukopian
				if("Oni")        newborn = new /mob/races/Imp
				if("Alien")      newborn = new /mob/races/Alien
				//if("Android")    m = new /mob/races/Android
				if("Tuffle")     newborn = new /mob/races/Tuffle
				if("Changeling") newborn = new /mob/races/Changeling
				if("Makyo") newborn = new /mob/races/Makyo
				if("Spirit Doll") newborn = new/mob/races/Spiritdoll
				/*if("Human")
					if(races_humans.len)
						newborn = races_humans[1]
						races_humans -= newborn
				if("Saiyan")
					if(races_saiyans.len)
						newborn = races_saiyans[1]
						races_saiyans -= newborn
				if("Tuffle")
					if(races_tuffles.len)
						newborn = races_tuffles[1]
						races_tuffles -= newborn
				if("Namekian")
					if(races_yukopians.len)
						newborn = races_yukopians[1]
						races_yukopians -= newborn
				if("Changeling")
					if(races_changelings.len)
						newborn = races_changelings[1]
						races_changelings -= newborn
				if("Spirit Doll")
					if(races_spiritdolls.len)
						newborn = races_spiritdolls[1]
						races_spiritdolls -= newborn
				if("Makyo")
					if(races_makyos.len)
						newborn = races_makyos[1]
						races_makyos -= newborn
				if("Demon")
					if(races_demons.len)
						newborn = races_demons[1]
						races_demons -= newborn
				if("Kai")
					if(races_celestials.len)
						src = races_celestials[1]
						races_celestials -= newborn
				if("Half God")
					if(races_halfgods.len)
						newborn = races_halfgods[1]
						races_halfgods -= newborn
				if("Alien")
					if(races_aliens.len)
						newborn = races_aliens[1]
						races_aliens -= newborn
				if("Oni")
					if(races_imps.len)
						newborn = races_imps[1]
						races_imps -= newborn
				if("Android")
					if(races_androids.len)
						newborn = races_androids[1]
						races_androids -= newborn*/
				else
					newborn = new /mob/races/Human // fallback if unknown race

			if(!newborn)
				src << "Error: Could not create race template for [profile.race]."
				return

			// === STEP 2: Transfer client control ===
			/*var/client/C = src.client
			if(C)
				C.mob = newborn
				newborn.client = C
			else
				src << "Error: No client detected."
				return*/

			// === STEP 3: Apply profile data ===
			newborn.apply_offspring_profile(profile)
			newborn.update_looks()
		//	src.creature_started = 1
			//src.offspring = 1
			newborn.key = src.key
			newborn.client.eye = newborn
			// === STEP 4: Spawn in and initialize ===
			//newborn.loc = newborn.savedloc
			//newborn.savedloc = newborn.loc
			//src.creature_started = 1
		//	src.offspring = 1
		//	newborn.key = src.key

			// === STEP 5: Clean up old creation menu ===
			//del(src)

			// === STEP 6: Run the character startup logic ===
			newborn.confirm_new_character()

			// === STEP 7: Remove profile from active list and save ===
			if(ActiveChildren.Find(profile))
				ActiveChildren -= profile
				var/savefile/F = new("saves/ChildrenandAndroids/ActiveChildren.sav")
				F["ActiveChildren"] << ActiveChildren

			//world << "[src.name] has been born into the world as a [src.race]!"
		switch_race(var/new_race)

			var/mob/old = src
			src.loc = null
			src.choosing_character = 0
			src.started = 0
			src.transform = null
			src.offspring = 0
			var/mob/races/m = null

			switch(new_race)
				if("Saiyan")     m = new /mob/races/Saiyan
				if("Human")      m = new /mob/races/Human
				if("Demon")      m = new /mob/races/Demon
				if("Kai")        m = new /mob/races/Celestial
				if("Namekian")   m = new /mob/races/Yukopian
				if("Oni")        m = new /mob/races/Imp
				if("Alien")      m = new /mob/races/Alien
				//if("Android")    m = new /mob/races/Android
				if("Tuffle")     m = new /mob/races/Tuffle
				if("Changeling") m = new /mob/races/Changeling
				if("Makyo") m = new /mob/races/Makyo
				if("Spirit Doll") m = new/mob/races/Spiritdoll

				/*if("Human")
					if(races_humans.len > 0) m = races_humans[1]; races_humans -= m
				if("Makyo")
					if(races_makyos.len > 0) m = races_makyos[1]; races_makyos -= m
				if("Half God")
					if(races_halfgods.len > 0) m = races_halfgods[1]; races_halfgods -= m
				if("Tuffle")
					if(races_tuffles.len > 0) m = races_tuffles[1]; races_tuffles -= m
				if("Spirit Doll")
					if(races_spiritdolls.len > 0) m = races_spiritdolls[1]; races_spiritdolls -= m
				if("Changeling")
					if(races_changelings.len > 0) m = races_changelings[1]; races_changelings -= m
				if("Saiyan")
					if(races_saiyans.len > 0) m = races_saiyans[1]; races_saiyans -= m

				if("Demon")
					if(races_demons.len > 0) m = races_demons[1]; races_demons -= m
				if("Kai")
					if(races_celestials.len > 0) m = races_celestials[1]; races_celestials -= m
				if("Android")
					if(races_androids.len > 0) m = races_androids[1]; races_androids -= m
				if("Alien")
					if(races_aliens.len > 0) m = races_aliens[1]; races_aliens -= m
				if("Oni")
					if(races_imps.len > 0) m = races_imps[1]; races_imps -= m
				if("Namekian")
					if(races_yukopians.len > 0) m = races_yukopians[1]; races_yukopians -= m*/
				if("Newborn")
					if(ActiveChildren && ActiveChildren.len)
						src.offspring = 1

						var/list/choices = list()
						for (var/datum/offspring_profile/O in ActiveChildren)
							choices["[O.name] ([O.race])"] = O
						choices["Cancel"] = null

						var/choice = input(src, "Choose an offspring to be born as:") in choices
						if(!choice || !choices[choice])
							src << "Selection canceled."
							return

						profile = choices[choice]
						if(!profile)
							src << "Error: invalid offspring selection."
							return


					//	profile = input(src, "Choose an offspring to be born as:") in ActiveChildren + list("Cancel")
						//if(profile == "Cancel" || !profile)
						//	return

						// === Password check ===
						if(profile.password && profile.password != "")
							var/pw = input(src, "Enter the password for [profile.name]:") as text
							if(pw != profile.password)
								src << "Incorrect password."
								return

						// === Confirm details ===
						var/confirm = alert(src,
							"Child: [profile.name]\nRace: [profile.race]\nParents: [profile.Father] and [profile.Mother]\n\nContinue?",
							"Confirm Birth", "Continue", "Return")
						if(confirm != "Continue")
							return

						src << "Preparing to begin life as [profile.name]..."
						sleep(2)

						// === STEP 1: Create base race mob (the newborn body) ===
						//var/mob/races/m = null
						switch(profile.race)
							if("Saiyan")     m = new /mob/races/Saiyan
							if("Human")      m = new /mob/races/Human
							if("Demon")      m = new /mob/races/Demon
							if("Kai")        m = new /mob/races/Celestial
							if("Namekian")   m = new /mob/races/Yukopian
							if("Oni")        m = new /mob/races/Imp
							if("Alien")      m = new /mob/races/Alien
							if("Android")    m = new /mob/races/Android
							if("Tuffle")     m = new /mob/races/Tuffle
							if("Changeling") m = new /mob/races/Changeling
							/*if("Human")
								if(races_humans.len > 0) m = races_humans[1]; races_humans -= m
							if("Makyo")
								if(races_makyos.len > 0) m = races_makyos[1]; races_makyos -= m
							if("Half God")
								if(races_halfgods.len > 0) m = races_halfgods[1]; races_halfgods -= m
							if("Tuffle")
								if(races_tuffles.len > 0) m = races_tuffles[1]; races_tuffles -= m
							if("Spirit Doll")
								if(races_spiritdolls.len > 0) m = races_spiritdolls[1]; races_spiritdolls -= m
							if("Changeling")
								if(races_changelings.len > 0) m = races_changelings[1]; races_changelings -= m
							if("Saiyan")
								if(races_saiyans.len > 0) m = races_saiyans[1]; races_saiyans -= m

							if("Demon")
								if(races_demons.len > 0) m = races_demons[1]; races_demons -= m
							if("Kai")
								if(races_celestials.len > 0) m = races_celestials[1]; races_celestials -= m
							if("Android")
								if(races_androids.len > 0) m = races_androids[1]; races_androids -= m
							if("Alien")
								if(races_aliens.len > 0) m = races_aliens[1]; races_aliens -= m
							if("Oni")
								if(races_imps.len > 0) m = races_imps[1]; races_imps -= m
							if("Namekian")
								if(races_yukopians.len > 0) m = races_yukopians[1]; races_yukopians -= m */
							//else
							//	newborn = new /mob/races/Human // fallback if unknown race

						if(!m)
							return
						m.creature_started = 1
						m.offspring = 1
						m.profile = src.profile

					else
						src << "There are no active children available to be born into."
						return
			players -= old


			if(m)

				if(src.hud_char)
					var/obj/txt = src.hud_char.ages_desc_txt
					txt.maptext = ""

				m.sav_active = src.sav_active
				m.hud_char = src.hud_char
				m.hud_updates = src.hud_updates
				m.hud_confirm = src.hud_confirm
				m.hud_confirm_nums = src.hud_confirm_nums

				src.hud_char.loc = m
				src.hud_updates.loc = m
				src.hud_confirm.loc = m
				src.hud_confirm_nums.loc = m

				src.hud_char = null
				src.hud_updates = null
				src.hud_confirm = null
				src.hud_confirm_nums = null

				src.clear_portrait()
				src.sav_active = 0

				//Reset some vars that might of been saved if another player was previously using this mob to assign mod points, age, ect.
				if(!m.creature_started)
					m.reset_mods()
					m.started = 0
					m.age = 4
					m.age_soul = 4
					m.birth_year = year-4
				else
					m.started = 0
					m.age = 0.1
					m.age_soul = 0.1
					m.birth_year = year
					src <<output("<b>Click Confirm to spawn in as [profile.name]</b>","actionoutput")
					//m << "<b>Click Confirm to spawn in as [profile.name]</b>"

				m.choosing_character = 1
				//m.loc = locate(260,260,19)
				//m.set_origins()
				m.update_looks()
				m.key = src.key
				m.client.eye = locate(250,250,19)
				m.set_lists()
				m.set_debuffs()
				m.create_body()
				m.create_menus()
				m.set_info_box()
				m.set_decline()
				//m.set_genetic_limits()
				m.set_path_type()
				m.name = "[m.key]"



				// === Transfer control and clean up the old mob ===
			//	if(src in players)
				//	players -= src

				//var/client/C = src.client
				//if(C)
				//	C.mob = m
					//m.client = C

				//del(src) // Fully remove the old mob

		/*switch_race(var/new_race)
			src.loc = null
			src.choosing_character = 0
			src.started = 0
			src.transform = null
			var/mob/races/m = null
			//If the player is trying to switch to a new race, make sure var/mob/m is correctly set to one of the mobs inside the corresponding race lists
			switch(new_race)
				if("Makyo")
					if(races_makyos.len > 0)
						m = races_makyos[1]
						races_makyos -= races_makyos[1]
				if("Half God")
					if(races_halfgods.len > 0)
						m = races_halfgods[1]
						races_halfgods -= races_halfgods[1]
				if("Tuffle")
					if(races_tuffles.len > 0)
						m = races_tuffles[1]
						races_tuffles -= races_tuffles[1]
				if("Spirit Doll")
					if(races_spiritdolls.len > 0)
						m = races_spiritdolls[1]
						races_spiritdolls -= races_spiritdolls[1]
				if("Changeling")
					if(races_changelings.len > 0)
						m = races_changelings[1]
						races_changelings -= races_changelings[1]
				if("Saiyan")
					if(races_saiyans.len > 0)
						m = races_saiyans[1]
						races_saiyans -= races_saiyans[1]
				if("Human")
					if(races_humans.len > 0)
						m = races_humans[1]
						races_humans -= races_humans[1]
				if("Demon")
					if(races_demons.len > 0)
						m = races_demons[1]
						races_demons -= races_demons[1]
				if("Kai")
					if(races_celestials.len > 0)
						m = races_celestials[1]
						races_celestials -= races_celestials[1]
				if("Android")
					if(races_androids.len > 0)
						m = races_androids[1]
						races_androids -= races_androids[1]
				if("Alien")
					if(races_aliens.len > 0)
						m = races_aliens[1]
						races_aliens -= races_aliens[1]
				if("Oni")
					if(races_imps.len > 0)
						m = races_imps[1]
						races_imps -= races_imps[1]
				if("Namekian")
					if(races_yukopians.len > 0)
						m = races_yukopians[1]
						races_yukopians -= races_yukopians[1]
			if(m)
				if(src.hud_char)
					var/obj/txt = src.hud_char.ages_desc_txt
					txt.maptext = ""

				m.sav_active = src.sav_active
				m.hud_char = src.hud_char
				m.hud_updates = src.hud_updates
				m.hud_confirm = src.hud_confirm
				m.hud_confirm_nums = src.hud_confirm_nums

				src.hud_char.loc = m
				src.hud_updates.loc = m
				src.hud_confirm.loc = m
				src.hud_confirm_nums.loc = m

				src.hud_char = null
				src.hud_updates = null
				src.hud_confirm = null
				src.hud_confirm_nums = null

				src.clear_portrait()
				src.sav_active = 0

				//Reset some vars that might of been saved if another player was previously using this mob to assign mod points, age, ect.
				m.started = 0
				//m.age = 20
			//	m.age_soul = 20
				//m.birth_year = year-20
				m.choosing_character = 1
				m.loc = locate(260,260,19)
				m.reset_mods()
				//m.set_origins()
				m.set_ages()
				m.update_looks()
				m.key = src.key
				m.client.eye = locate(250,250,19)

				*/
		set_ages()
			var/xx = 394
			var/yy = 516//-538
			var/obj/hud/menus/char_creation_background/bg = null
			if(src.hud_char) bg = src.hud_char
			//Checks to see if the players learnable_origins has 0 entries in it first.
			if(src.pickable_ages == null) src.pickable_ages = list()
			if(src.pickable_ages.len <= 0)
				for(var/x in ages)
					var/obj/ages/I = new x()
					src.pickable_ages += I
			//Clear the vis_contents of the menu first
			for(var/obj/ages/x in bg.ages_txt_holder.vis_contents)
				bg.ages_txt_holder.vis_contents -= x
			//Start populating the players char_creation_background with the origins
			for(var/obj/ages/x in src.pickable_ages)
				//Clear the origins when switching to another race.
				if(bg && bg.ages_txt_holder) bg.ages_txt_holder.vis_contents -= x
				//Now organise the origins based on if they're locked or not for that players race and apply them to the hud.
				var/matrix/m = matrix()
				yy -= 20
				x.hud_x = xx
				x.hud_y = yy
				m.Translate(x.hud_x,x.hud_y)
				x.transform = m
				if(bg && bg.ages_txt_holder) bg.ages_txt_holder.vis_contents += x
		set_origins()
			var/xx = 404
			var/yy = 516//-538
			var/obj/hud/menus/char_creation_background/bg = null
			if(src.hud_char) bg = src.hud_char
			//Checks to see if the players learnable_origins has 0 entries in it first.
			if(src.learnable_origins == null) src.learnable_origins = list()
			if(src.learnable_origins.len <= 0)
				for(var/x in origins)
					var/obj/origins/I = new x()
					src.learnable_origins += I
			//Clear the vis_contents of the menu first
			for(var/obj/origins/x in bg.origins_txt_holder.vis_contents)
				bg.origins_txt_holder.vis_contents -= x
			//Start populating the players char_creation_background with the origins
			var/allow_beast_potential = (src.saiyan_dna || src.human_dna || src.is_hybrid)
			var/allow_type_c = !(src.LSSJ || src.is_hybrid)
			var/has_beast_potential = FALSE
			for(var/obj/origins/mutations/beast_potential in src.learnable_origins)
				has_beast_potential = TRUE
				break
			var/has_type_c = FALSE
			for(var/obj/origins/mutations/type_c in src.learnable_origins)
				has_type_c = TRUE
				break
			for(var/obj/origins/x in src.learnable_origins)
				//Clear the origins when switching to another race.
				if(bg && bg.origins_txt_holder) bg.origins_txt_holder.vis_contents -= x
				//Now organise the origins based on if they're locked or not for that players race and apply them to the hud.
				var/learnable = 1
				if(src.race in x.banned_races || src.race_class in x.banned_class)
					learnable = 0
					//Ones not added -should- be collected by the garbage collector?
				if(has_beast_potential && !allow_beast_potential)
					learnable = 0
				if(has_type_c && !allow_type_c)
					learnable = 0 // just incase the above fails somehow
				if(learnable)
					var/matrix/m = matrix()
					yy -= 20
					x.hud_x = xx
					x.hud_y = yy
					m.Translate(x.hud_x,x.hud_y)
					x.transform = m
					if(bg && bg.origins_txt_holder) bg.origins_txt_holder.vis_contents += x
		clear_portrait()
			var/mob/target = src
			if(target.port)
				target.port.port_iris = null
				target.port.port_eyes = null
				for(var/obj/portrait/p in target.port)
					p.destroy()
				if(target.client) target.client.screen -= target.port
				if(target.hud_char) target.hud_char.vis_contents -= target.port
				if(target.hud_load) target.hud_load.vis_contents -= target.port
				target.port.destroy()
				target.port = null
		set_baby_icon(var/mob/target,var/ascend = 0)
			if(target)
				var/nose_count = length(nose_portrait_female)
				if(nose_count && (target.nose_pos < 1 || target.nose_pos > nose_count))
					target.nose_pos = 1
				var/mouth_count = length(mouth_portrait_female)
				if(mouth_count && (target.mouth_pos < 1 || target.mouth_pos > mouth_count))
					target.mouth_pos = 1
				if(target.port)
					if(target.age<4||target.age == 0.1)
						if(target.client) target.client.screen -= target.port
						if(target.hud_char) target.hud_char.vis_contents -= target.port
						if(target.hud_load) target.hud_load.vis_contents -= target.port
					target.babyport = new /obj/portrait/babybody
					target.port = target.babyport



					var/obj/portrait/portrait_part/portrait_babymouth = new(target.babyport)
					var/obj/portrait/portrait_part/portrait_babynose = new(target.babyport)
					var/obj/portrait/eyes/portrait_babyeyes = new(target.babyport)
					//var/obj/portrait/portrait_part/portrait_iris = new(target.babyport)

					target.babyport.plane = 25
					target.babyport.overlays += /obj/portrait/border
					target.babyport.underlays += /obj/portrait/background

					var/b_state = "body1"
					if(target.body_pos == 2) b_state = "body1"
					else if(target.body_pos == 3) b_state = "body1"
					target.vis_contents -= target.hair
					target.client.screen += target.port
					var/icon/P
					if(target.gen == "Male")

						switch(target.race)
							if("Demon")
								var/p_icon = 'portrait_newborn_egg.dmi'
								var/p_state
								var/list/eye_list
								if(target.skin_pos == 1)
									p_icon = 'portrait_newborn_egg.dmi'
									p_state = "[b_state] skin1"
									eye_list = eyes_portrait_female_demon
								if(target.skin_pos == 2)
									p_icon = 'portrait_newborn_egg.dmi'
									p_state = "[b_state] skin2"
									eye_list = eyes_portrait_female_demon
								if(target.skin_pos == 3)
									p_icon = 'portrait_newborn_egg.dmi'
									p_state = "[b_state] skin1"
									eye_list = eyes_portrait_female
								if(target.skin_pos == 4)
									p_icon = 'portrait_newborn_egg.dmi'
									p_state = "[b_state] skin2"
									eye_list = eyes_portrait_female
								if(target.skin_pos == 5)
									p_icon = 'portrait_newborn_egg.dmi'
									p_state = "[b_state] skin3"
									eye_list = eyes_portrait_female
								if(target.eye_pos > length(eye_list)) target.eye_pos = 1
								P = icon(p_icon,p_state,SOUTH,1,0)
								target.babyport.icon = P
							//	if(target.babyport.icon) target.babyport.icon = null
							if("Tuffle")
								var/p_state = 'portrait_baby_male.dmi'

								if(target.skin_pos == 1) p_state = "[b_state] skin1"
								if(target.skin_pos == 2) p_state = "[b_state] skin1"
								if(target.skin_pos == 3) p_state = "[b_state] skin1"
								P = icon('portrait_baby_male.dmi',p_state,SOUTH,1,0)
								target.babyport.icon = P
							//	if(target.babyport.icon) target.babyport.icon = null


								var/obj/eyes = eyes_portrait_female[target.eye_pos]
								portrait_babyeyes.icon = eyes.icon
								portrait_babyeyes.icon_state = eyes.icon_state



								var/obj/nose = nose_portrait_female[target.nose_pos]
								portrait_babynose.icon = nose.icon
								portrait_babynose.icon_state = nose.icon_state

								var/obj/mouth = mouth_portrait_female[target.mouth_pos]
								portrait_babymouth.icon = mouth.icon
								portrait_babymouth.icon_state = mouth.icon_state
							if("Human")
								var/p_state = 'portrait_baby_male.dmi'

								if(target.skin_pos == 1) p_state = "[b_state] skin1"
								if(target.skin_pos == 2) p_state = "[b_state] skin1"
								if(target.skin_pos == 3) p_state = "[b_state] skin1"
								P = icon('portrait_baby_male.dmi',p_state,SOUTH,1,0)
								target.babyport.icon = P
							//	if(target.babyport.icon) target.babyport.icon = null


								var/obj/eyes = eyes_portrait_female[target.eye_pos]
								portrait_babyeyes.icon = eyes.icon
								portrait_babyeyes.icon_state = eyes.icon_state



								var/obj/nose = nose_portrait_female[target.nose_pos]
								portrait_babynose.icon = nose.icon
								portrait_babynose.icon_state = nose.icon_state

								var/obj/mouth = mouth_portrait_female[target.mouth_pos]
								portrait_babymouth.icon = mouth.icon
								portrait_babymouth.icon_state = mouth.icon_state
							if("Saiyan")
								var/p_state = 'portrait_baby_male.dmi'

								if(target.skin_pos == 1) p_state = "[b_state] skin1"
								if(target.skin_pos == 2) p_state = "[b_state] skin1"
								if(target.skin_pos == 3) p_state = "[b_state] skin1"
								P = icon('portrait_baby_male.dmi',p_state,SOUTH,1,0)
								target.babyport.icon = P
							//	if(target.babyport.icon) target.babyport.icon = null


								var/obj/eyes = eyes_portrait_female[target.eye_pos]
								portrait_babyeyes.icon = eyes.icon
								portrait_babyeyes.icon_state = eyes.icon_state



								var/obj/nose = nose_portrait_female[target.nose_pos]
								portrait_babynose.icon = nose.icon
								portrait_babynose.icon_state = nose.icon_state

								var/obj/mouth = mouth_portrait_female[target.mouth_pos]
								portrait_babymouth.icon = mouth.icon
								portrait_babymouth.icon_state = mouth.icon_state
							if("Spirit Doll")
								var/p_state = 'portrait_baby_male.dmi'

								if(target.skin_pos == 1) p_state = "[b_state] skin1"
								if(target.skin_pos == 2) p_state = "[b_state] skin1"
								if(target.skin_pos == 3) p_state = "[b_state] skin1"
								P = icon('portrait_baby_male.dmi',p_state,SOUTH,1,0)
								target.babyport.icon = P
							//	if(target.babyport.icon) target.babyport.icon = null


								var/obj/eyes = eyes_portrait_female[target.eye_pos]
								portrait_babyeyes.icon = eyes.icon
								portrait_babyeyes.icon_state = eyes.icon_state



								var/obj/nose = nose_portrait_female[target.nose_pos]
								portrait_babynose.icon = nose.icon
								portrait_babynose.icon_state = nose.icon_state

								var/obj/mouth = mouth_portrait_female[target.mouth_pos]
								portrait_babymouth.icon = mouth.icon
								portrait_babymouth.icon_state = mouth.icon_state
							if("Kai")
								var/p_state = 'portrait_baby_male.dmi'

								if(target.skin_pos == 1) p_state = "[b_state] skin1"
								if(target.skin_pos == 2) p_state = "[b_state] skin1"
								if(target.skin_pos == 3) p_state = "[b_state] skin1"
								P = icon('portrait_baby_male.dmi',p_state,SOUTH,1,0)
								target.babyport.icon = P
							//	if(target.babyport.icon) target.babyport.icon = null


								var/obj/eyes = eyes_portrait_female[target.eye_pos]
								portrait_babyeyes.icon = eyes.icon
								portrait_babyeyes.icon_state = eyes.icon_state



								var/obj/nose = nose_portrait_female[target.nose_pos]
								portrait_babynose.icon = nose.icon
								portrait_babynose.icon_state = nose.icon_state

								var/obj/mouth = mouth_portrait_female[target.mouth_pos]
								portrait_babymouth.icon = mouth.icon
								portrait_babymouth.icon_state = mouth.icon_state
					if(target.gen == "Female")
						switch(target.race)
							if("Spirit Doll")
								var/p_state = 'portrait_baby_female.dmi'

								if(target.skin_pos == 1) p_state = "[b_state] skin1"
								if(target.skin_pos == 2) p_state = "[b_state] skin1"
								if(target.skin_pos == 3) p_state = "[b_state] skin1"
								P = icon('portrait_baby_female.dmi',p_state,SOUTH,1,0)
							//	if(target.babyport.icon) target.babyport.icon = null

								target.babyport.icon = P


								var/obj/eyes = eyes_portrait_female[target.eye_pos]
								portrait_babyeyes.icon = eyes.icon
								portrait_babyeyes.icon_state = eyes.icon_state



								var/obj/nose = nose_portrait_female[target.nose_pos]
								portrait_babynose.icon = nose.icon
								portrait_babynose.icon_state = nose.icon_state

								var/obj/mouth = mouth_portrait_female[target.mouth_pos]
								portrait_babymouth.icon = mouth.icon
								portrait_babymouth.icon_state = mouth.icon_state
							if("Kai")
								var/p_state = 'portrait_baby_female.dmi'

								if(target.skin_pos == 1) p_state = "[b_state] skin1"
								if(target.skin_pos == 2) p_state = "[b_state] skin1"
								if(target.skin_pos == 3) p_state = "[b_state] skin1"
								P = icon('portrait_baby_female.dmi',p_state,SOUTH,1,0)
							//	if(target.babyport.icon) target.babyport.icon = null

								target.babyport.icon = P
								//if(target.babyport.icon) target.babyport.icon = null


								var/obj/eyes = eyes_portrait_female[target.eye_pos]
								portrait_babyeyes.icon = eyes.icon
								portrait_babyeyes.icon_state = eyes.icon_state



								var/obj/nose = nose_portrait_female[target.nose_pos]
								portrait_babynose.icon = nose.icon
								portrait_babynose.icon_state = nose.icon_state

								var/obj/mouth = mouth_portrait_female[target.mouth_pos]
								portrait_babymouth.icon = mouth.icon
								portrait_babymouth.icon_state = mouth.icon_state
							if("Tuffle")
								var/p_state = 'portrait_baby_female.dmi'

								if(target.skin_pos == 1) p_state = "[b_state] skin1"
								if(target.skin_pos == 2) p_state = "[b_state] skin1"
								if(target.skin_pos == 3) p_state = "[b_state] skin1"
								P = icon('portrait_baby_female.dmi',p_state,SOUTH,1,0)
								target.babyport.icon = P
							//	if(target.babyport.icon) target.babyport.icon = null


								var/obj/eyes = eyes_portrait_female[target.eye_pos]
								portrait_babyeyes.icon = eyes.icon
								portrait_babyeyes.icon_state = eyes.icon_state



								var/obj/nose = nose_portrait_female[target.nose_pos]
								portrait_babynose.icon = nose.icon
								portrait_babynose.icon_state = nose.icon_state

								var/obj/mouth = mouth_portrait_female[target.mouth_pos]
								portrait_babymouth.icon = mouth.icon
								portrait_babymouth.icon_state = mouth.icon_state
							if("Saiyan")
								var/p_state = 'portrait_baby_female.dmi'

								if(target.skin_pos == 1) p_state = "[b_state] skin1"
								if(target.skin_pos == 2) p_state = "[b_state] skin1"
								if(target.skin_pos == 3) p_state = "[b_state] skin1"
								P = icon('portrait_baby_female.dmi',p_state,SOUTH,1,0)
								target.babyport.icon = P
							//	if(target.babyport.icon) target.babyport.icon = null


								var/obj/eyes = eyes_portrait_female[target.eye_pos]
								portrait_babyeyes.icon = eyes.icon
								portrait_babyeyes.icon_state = eyes.icon_state



								var/obj/nose = nose_portrait_female[target.nose_pos]
								portrait_babynose.icon = nose.icon
								portrait_babynose.icon_state = nose.icon_state

								var/obj/mouth = mouth_portrait_female[target.mouth_pos]
								portrait_babymouth.icon = mouth.icon
								portrait_babymouth.icon_state = mouth.icon_state
							if("Human")
								var/p_state = 'portrait_baby_female.dmi'

								if(target.skin_pos == 1) p_state = "[b_state] skin1"
								if(target.skin_pos == 2) p_state = "[b_state] skin1"
								if(target.skin_pos == 3) p_state = "[b_state] skin1"
								P = icon('portrait_baby_female.dmi',p_state,SOUTH,1,0)
								target.babyport.icon = P
								//if(target.babyport.icon) target.babyport.icon = null


								var/obj/eyes = eyes_portrait_female[target.eye_pos]
								portrait_babyeyes.icon = eyes.icon
								portrait_babyeyes.icon_state = eyes.icon_state



								var/obj/nose = nose_portrait_female[target.nose_pos]
								portrait_babynose.icon = nose.icon
								portrait_babynose.icon_state = nose.icon_state

								var/obj/mouth = mouth_portrait_female[target.mouth_pos]
								portrait_babymouth.icon = mouth.icon
								portrait_babymouth.icon_state = mouth.icon_state

							if("Demon")
								var/p_icon = 'portrait_newborn_egg.dmi'
								var/p_state
								var/list/eye_list
								if(target.skin_pos == 1)
									p_icon = 'portrait_newborn_egg.dmi'
									p_state = "[b_state] skin1"
									eye_list = eyes_portrait_female_demon
								if(target.skin_pos == 2)
									p_icon = 'portrait_newborn_egg.dmi'
									p_state = "[b_state] skin2"
									eye_list = eyes_portrait_female_demon
								if(target.skin_pos == 3)
									p_icon = 'portrait_newborn_egg.dmi'
									p_state = "[b_state] skin1"
									eye_list = eyes_portrait_female
								if(target.skin_pos == 4)
									p_icon = 'portrait_newborn_egg.dmi'
									p_state = "[b_state] skin2"
									eye_list = eyes_portrait_female
								if(target.skin_pos == 5)
									p_icon = 'portrait_newborn_egg.dmi'
									p_state = "[b_state] skin3"
									eye_list = eyes_portrait_female
								if(target.eye_pos > length(eye_list)) target.eye_pos = 1
								P = icon(p_icon,p_state,SOUTH,1,0)
								target.babyport.icon = P
								//if(target.babyport.icon) target.babyport.icon = null


		update_icon(var/mob/target,var/ascend = 0)
			if(target)
				//Clear the old portrait first, making sure to delete any obj/refs
				if(target.port)
					target.port.port_iris = null
					target.port.port_eyes = null
					for(var/obj/portrait/p in target.port)
						p.destroy()
					if(target.client) target.client.screen -= target.port
					if(target.hud_char) target.hud_char.vis_contents -= target.port
					if(target.hud_load) target.hud_load.vis_contents -= target.port
				//	if(target.hud_scouter) target.hud_scouter.vis_contents -= target.port

					target.port.destroy()

				//Then re-create the portrait
				target.port = new /obj/portrait/body

				var/obj/portrait/portrait_part/portrait_horns = new(target.port)
				var/obj/portrait/portrait_part/portrait_hair = new(target.port)
				var/obj/portrait/portrait_part/portrait_mouth = new(target.port)
				var/obj/portrait/portrait_part/portrait_nose = new(target.port)
				var/obj/portrait/eyes/portrait_eyes = new(target.port)
				var/obj/portrait/portrait_part/portrait_iris = new(target.port)
				for(var/obj/items/tech/Scouters/s in target)
					if(s.suffix == "worn")
						var/obj/portrait/portrait_scouter_base/scouterbase = new(target.port)
						var/obj/portrait/portrait_scouter_lens/scouterlens = new(target.port)
						if(s.lenscolor) scouterlens.icon *= s.lenscolor
						scouterbase.ScouterBase = s
						scouterlens.ScouterLens = s
						s.ScouterBase = scouterbase
						s.ScouterLens = scouterlens
				if(target.has_beard)
					switch(target.beard)
						if(1)
							var/obj/portrait/portrait_beard_moustache/moustache = new(target.port)
							if(target.hair_c)
								moustache.icon_state = "color"
								moustache.icon *= target.hair_c


						if(2)
							var/obj/portrait/portrait_beard_goatee/goatee = new(target.port)
							if(target.hair_c)
								goatee.icon_state = "color"
								goatee.icon *= target.hair_c
						if(3)
							var/obj/portrait/portrait_beard_short/short = new(target.port)
							if(target.hair_c)
								short.icon_state = "color"
								short.icon *= target.hair_c

						if(4)
							var/obj/portrait/portrait_beard_full/full = new(target.port)
							if(target.hair_c)
								full.icon_state = "color"
								full.icon *= target.hair_c
						if(5)
							var/obj/portrait/portrait_beard_big/big = new(target.port)
							if(target.hair_c)
								big.icon_state = "color"
								big.icon *= target.hair_c
							//var/icon/B = icon(beard_icon_portrait, "", SOUTH, 1, 0)
							//B.Scale(128, 128)
							//if(target.hair_c)
							//	B.Blend(target.hair_c, ICON_MULTIPLY)
							//I.Blend(B, ICON_OVERLAY, 1, 13)

						//target.port.
				//for(var/obj/p in target.port)
					//world << "DEBUG - Found [p] inside [target.port]"

				target.port.plane = 25
				portrait_iris.layer = 5.2
				portrait_hair.layer = 5.3

				target.port.overlays += /obj/portrait/border
				target.port.underlays += /obj/portrait/background

				portrait_eyes.p_owner = target
				portrait_iris.p_owner = target

				target.port.port_iris = portrait_iris
				target.port.port_eyes = portrait_eyes

				var/b_state = "body1"
				if(target.body_pos == 2) b_state = "body2"
				else if(target.body_pos == 3) b_state = "body3"

				//world << "DEBUG - created [src.port] for [src]"


				var/icon/P

				if(target.gen == "Female")
					switch(target.race)
						if("Demon")
							var/p_icon = 'portrait_demon_female.dmi'
							var/p_state
							var/list/eye_list
							if(target.skin_pos == 1)
								p_icon = 'portrait_demon_female.dmi'
								p_state = "[b_state] skin1"
								eye_list = eyes_portrait_female_demon
							if(target.skin_pos == 2)
								p_icon = 'portrait_demon_female.dmi'
								p_state = "[b_state] skin2"
								eye_list = eyes_portrait_female_demon
							if(target.skin_pos == 3)
								p_icon = 'portrait_human_female.dmi'
								p_state = "[b_state] skin1"
								eye_list = eyes_portrait_female
							if(target.skin_pos == 4)
								p_icon = 'portrait_human_female.dmi'
								p_state = "[b_state] skin2"
								eye_list = eyes_portrait_female
							if(target.skin_pos == 5)
								p_icon = 'portrait_human_female.dmi'
								p_state = "[b_state] skin3"
								eye_list = eyes_portrait_female
							if(target.eye_pos > length(eye_list)) target.eye_pos = 1
							P = icon(p_icon,p_state,SOUTH,1,0)
							target.port.icon = P



							if(target.body_pos != 3)
								var/obj/eyes = eye_list[target.eye_pos]
								portrait_eyes.icon = eyes.icon
								portrait_eyes.icon_state = eyes.icon_state

								var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
								if(target.eye_c) P_eyes_c.Blend(target.eye_c)
								else P_eyes_c.Blend(rgb(0,0,155))
								portrait_iris.icon = P_eyes_c
								P.Blend(P_eyes_c,ICON_OVERLAY)

								var/obj/nose = nose_portrait_female[target.nose_pos]
								portrait_nose.icon = nose.icon
								portrait_nose.icon_state = nose.icon_state

								var/obj/mouth = mouth_portrait_female[target.mouth_pos]
								portrait_mouth.icon = mouth.icon
								portrait_mouth.icon_state = mouth.icon_state

								if(target.hair_pos == 14) target.hair_pos = 1 //Added this here for npc's, ect. Just to make sure there's no out of bounds errors, since 11 for female doesn't exist.
								var/obj/hair = hairs_portrait_female[target.hair_pos]
								var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

								if(target.hair_c) P_hair_c.Blend(target.hair_c)
								P.Blend(P_hair_c,ICON_OVERLAY)
								portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")

						if("Kai")
							var/p_state = "[b_state] skin1"
							if(ascend) p_state = "[b_state] skin2"
							P = icon('portrait_celestial_female.dmi',p_state,SOUTH,1,0)
							target.port.icon = P

							var/icon/P_skin_c = icon(port.icon,"[port.icon_state]",SOUTH,1,0)
							if(P_skin_c)
								if(target.skin_c) P_skin_c.icon *= target.skin_c//P_skin_c.Blend(target.skin_c)
								else P_skin_c.Blend(rgb(0,0,155))
								port.icon = P_skin_c
								if(P)
									P.Blend(P_skin_c,ICON_OVERLAY)



							var/obj/eyes = eyes_portrait_female[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_female[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_female[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							if(target.hair_pos == 14) target.hair_pos = 1 //Added this here for npc's, ect. Just to make sure there's no out of bounds errors, since 11 for female doesn't exist.
							var/obj/hair = hairs_portrait_female[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")

						if("Tuffle")
							var/p_state = 'portrait_human_female.dmi'

							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"
							P = icon('portrait_human_female.dmi',p_state,SOUTH,1,0)
							target.port.icon = P


							var/obj/eyes = eyes_portrait_female[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_female[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_female[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							if(target.hair_pos == 14) target.hair_pos = 1 //Added this here for npc's, ect. Just to make sure there's no out of bounds errors, since 11 for female doesn't exist.
							var/obj/hair = hairs_portrait_female[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")

						if("Half God")
							var/p_state = 'portrait_human_female.dmi'

							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"
							P = icon('portrait_human_female.dmi',p_state,SOUTH,1,0)
							target.port.icon = P


							var/obj/eyes = eyes_portrait_female[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_female[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_female[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							if(target.hair_pos == 13) target.hair_pos = 1 //Added this here for npc's, ect. Just to make sure there's no out of bounds errors, since 11 for female doesn't exist.
							var/obj/hair = hairs_portrait_female[target.hair_pos]
							portrait_hair.icon = hair.icon
							portrait_hair.icon_state = hair.icon_state
						if("Human")
							var/p_state = 'portrait_human_female.dmi'

							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"
							P = icon('portrait_human_female.dmi',p_state,SOUTH,1,0)
							target.port.icon = P

							var/obj/eyes = eyes_portrait_female[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_female[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_female[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							if(target.hair_pos == 14) target.hair_pos = 1 //Added this here for npc's, ect. Just to make sure there's no out of bounds errors, since 11 for female doesn't exist.
							var/obj/hair = hairs_portrait_female[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")


						if("Saiyan")
							var/p_state = 'portrait_human_female.dmi'

							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"
							P = icon('portrait_human_female.dmi',p_state,SOUTH,1,0)
							target.port.icon = P


							var/obj/eyes = eyes_portrait_female[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_female[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_female[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							if(target.hair_pos == 14) target.hair_pos = 1 //Added this here for npc's, ect. Just to make sure there's no out of bounds errors, since 11 for female doesn't exist.
							var/obj/hair = hairs_portrait_female[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = hair.icon
							portrait_hair.icon_state = hair.icon_state
				if(target.gen == "Male")
					switch(target.race)
						if("Makyo")
							var/p_state = "skin1"
							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"
							if(target.skin_pos == 4) p_state = "[b_state] skin4"
							P = icon('portrait_makyo.dmi',p_state,SOUTH,1,0)
							target.port.icon = P


							var/obj/nose = nose_portrait_male[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/eyes = eyes_portrait_yuk[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/mouth = mouth_portrait_male[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							var/obj/hair = hairs_portrait_male[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")

						if("Spirit Doll")
							var/p_state = "skin1"
							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin1"
							P = icon('portrait_spiritdoll.dmi',p_state,SOUTH,1,0)
							target.port.icon = P

							var/obj/nose = nose_portrait_male[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/eyes = eyes_portrait_yuk[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/mouth = mouth_portrait_male[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							var/obj/hair = hairs_portrait_male[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")
						if("Changeling")
							var/p_state = "skin1"
							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"
							if(target.skin_pos == 4) p_state = "[b_state] skin4"
							if(target.skin_pos == 5) p_state = "[b_state] skin5"
							P = icon('portrait_changeling.dmi',p_state,SOUTH,1,0)
							target.port.icon = P



							var/obj/eyes = eyes_portrait_changeling[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)


							var/obj/mouth = mouth_portrait_male[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

						if("Demon")
							var/p_icon = 'portrait_demon_male.dmi'
							var/p_state
							var/list/eye_list

							if(target.skin_pos == 1)
								p_icon = 'portrait_demon_male.dmi'
								p_state = "[b_state] skin1"
								eye_list = eyes_portrait_male_demon
							if(target.skin_pos == 2)
								p_icon = 'portrait_demon_male.dmi'
								p_state = "[b_state] skin2"
								eye_list = eyes_portrait_male_demon
							if(target.skin_pos == 3)
								p_icon = 'portrait_human_male.dmi'
								p_state = "[b_state] skin1"
								eye_list = eyes_portrait_male_demon
							if(target.skin_pos == 4)
								p_icon = 'portrait_human_male.dmi'
								p_state = "[b_state] skin2"
								eye_list = eyes_portrait_male_demon
							if(target.skin_pos == 5)
								p_icon = 'portrait_human_male.dmi'
								p_state = "[b_state] skin3"
								eye_list = eyes_portrait_male_demon
							if(target.eye_pos > length(eye_list)) target.eye_pos = 1
							P = icon(p_icon,p_state,SOUTH,1,0)
							target.port.icon = P
							if(target.skin_pos == 2)
								var/icon/P_skin_c = icon(port.icon,"[port.icon_state]",SOUTH,1,0)
								if(target.skin_c) P_skin_c.Blend(target.skin_c)
								else P_skin_c.Blend(rgb(0,0,155))
								port.icon = P_skin_c
								P.Blend(P_skin_c,ICON_OVERLAY)


							if(target.body_pos != 3)
								var/obj/eyes = eye_list[target.eye_pos]
								portrait_eyes.icon = eyes.icon
								portrait_eyes.icon_state = eyes.icon_state


								var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
								if(target.eye_c) P_eyes_c.Blend(target.eye_c)
								else P_eyes_c.Blend(rgb(0,0,155))
								portrait_iris.icon = P_eyes_c
								P.Blend(P_eyes_c,ICON_OVERLAY)

								var/obj/nose = nose_portrait_male[target.nose_pos]
								portrait_nose.icon = nose.icon
								portrait_nose.icon_state = nose.icon_state

								var/obj/mouth = mouth_portrait_male[target.mouth_pos]
								portrait_mouth.icon = mouth.icon
								portrait_mouth.icon_state = mouth.icon_state

								var/obj/hair = hairs_portrait_male[target.hair_pos]
								var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

								if(target.hair_c) P_hair_c.Blend(target.hair_c)
								P.Blend(P_hair_c,ICON_OVERLAY)
								portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")
								//portrait_hair.icon_state =
								var/obj/horn = horns_portait_demon[target.horn_pos]
								portrait_horns.icon = horn.icon
								portrait_horns.icon_state = horn.icon_state

						if("Kai")
							var/p_state = "[b_state] skin1"
							//if(ascend) p_state = "[b_state] skin2"
							P = icon('portrait_celestial_male.dmi',p_state,SOUTH,1,0)
							target.port.icon = P

							var/icon/P_skin_c = icon(port.icon,"[port.icon_state]",SOUTH,1,0)
							if(target.skin_c) P_skin_c.Blend(target.skin_c)
							else P_skin_c.Blend(rgb(0,0,155))
							port.icon = P_skin_c
							P.Blend(P_skin_c,ICON_OVERLAY)

							var/obj/eyes = eyes_portrait_kai[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_male[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_male[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							var/obj/hair = hairs_portrait_male[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")
						if("Tuffle")
							var/p_state = 'portrait_human_male.dmi'
							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"
							P = icon('portrait_human_male.dmi',p_state,SOUTH,1,0)
							target.port.icon = P

							var/obj/eyes = eyes_portrait_kai[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_male[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_male[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							var/obj/hair = hairs_portrait_male[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")
						if("Half God")
							var/p_state = 'portrait_human_male.dmi'
							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"
							P = icon('portrait_human_male.dmi',p_state,SOUTH,1,0)
							target.port.icon = P


							var/obj/eyes = eyes_portrait_male[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_male[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_male[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							var/obj/hair = hairs_portrait_male[target.hair_pos]
							portrait_hair.icon = hair.icon
							portrait_hair.icon_state = hair.icon_state
						if("Human")
							var/p_state = 'portrait_human_male.dmi'
							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"

							P = icon('portrait_human_male.dmi',p_state,SOUTH,1,0)
							target.port.icon = P



							var/obj/eyes = eyes_portrait_male[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_male[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_male[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							var/obj/hair = hairs_portrait_male[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")

						if("Saiyan")
							var/p_state = 'portrait_human_male.dmi'
							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"
							P = icon('portrait_human_male.dmi',p_state,SOUTH,1,0)
							target.port.icon = P


							var/obj/eyes = eyes_portrait_male[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_male[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_male[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							var/obj/hair = hairs_portrait_male[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")

				if(target.race == "Oni")
					var/p_state = "skin1"
					if(target.skin_pos == 1) p_state = "[b_state] skin1"
					if(target.skin_pos == 2) p_state = "[b_state] skin2"
					if(target.skin_pos == 3) p_state = "[b_state] skin1"
					P = icon('portrait_oni.dmi',p_state,SOUTH,1,0)
					target.port.icon = P

					var/obj/nose = nose_portrait_male[target.nose_pos]
					portrait_nose.icon = nose.icon
					portrait_nose.icon_state = nose.icon_state

					var/obj/eyes = eyes_portrait_yuk[target.eye_pos]
					portrait_eyes.icon = eyes.icon
					portrait_eyes.icon_state = eyes.icon_state

					var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
					if(target.eye_c) P_eyes_c.Blend(target.eye_c)
					else P_eyes_c.Blend(rgb(0,0,155))
					portrait_iris.icon = P_eyes_c
					P.Blend(P_eyes_c,ICON_OVERLAY)

					var/obj/mouth = mouth_portrait_male[target.mouth_pos]
					portrait_mouth.icon = mouth.icon
					portrait_mouth.icon_state = mouth.icon_state

					var/obj/hair = hairs_portrait_male[target.hair_pos]
					var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

					if(target.hair_c) P_hair_c.Blend(target.hair_c)
					P.Blend(P_hair_c,ICON_OVERLAY)
					portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")

					var/obj/horn = horns_portrait_oni[target.horn_pos]
					portrait_horns.icon = horn.icon
					portrait_horns.icon_state = horn.icon_state
				//	P.Blend(horns_portrait_oni,ICON_OVERLAY)
				if(target.race == "Namekian")
					var/p_state = "skin1"
					if(target.skin_pos == 1) p_state = "[b_state] skin1"
					if(target.skin_pos == 2) p_state = "[b_state] skin2"
					if(target.skin_pos == 3) p_state = "[b_state] skin3"
					if(target.skin_pos == 3) p_state = "[b_state] skin4"
					P = icon('portrait_Namekian.dmi',p_state,SOUTH,1,0)
					target.port.icon = P


					var/obj/nose = nose_portrait_male[target.nose_pos]
					portrait_nose.icon = nose.icon
					portrait_nose.icon_state = nose.icon_state

					var/obj/eyes = eyes_portrait_yuk[target.eye_pos]
					portrait_eyes.icon = eyes.icon
					portrait_eyes.icon_state = eyes.icon_state

					var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
					if(target.eye_c) P_eyes_c.Blend(target.eye_c)
					else P_eyes_c.Blend(rgb(0,0,155))
					portrait_iris.icon = P_eyes_c
					P.Blend(P_eyes_c,ICON_OVERLAY)

					var/obj/mouth = mouth_portrait_male[target.mouth_pos]
					portrait_mouth.icon = mouth.icon
					portrait_mouth.icon_state = mouth.icon_state

				/*	var/obj/horn = horns_portrait_yuk[target.horn_pos]
					portrait_horns.icon = horn.icon
					portrait_horns.icon_state = horn.icon_state */
				if(target.race == "Alien")
					P = icon('portrait_cerebroid.dmi',"skin1",SOUTH,1,0)
					target.port.icon = P
					var/obj/eyes = eyes_portrait_cerebroid[target.eye_pos]
					portrait_eyes.icon = eyes.icon
					portrait_eyes.icon_state = eyes.icon_state
				for(var/obj/portrait/p in target.port)
					if(p.icon) target.port.vis_contents += p
					else
						//Purge any portrait parts that didn't get assigned an icon
						//No icon means its not used for that race for one reason or another
						p.p_owner = null
						if(p == target.port.port_eyes) target.port.port_eyes = null
						if(p == target.port.port_iris) target.port.port_iris = null
						p.destroy()

				if(portrait_iris.icon)
					if(target.race == "Alien" && target.skin_pos == 1)
						if(target.eye_c == null) target.eye_c = rgb(0,0,255)
						portrait_iris.filters += filter(type="drop_shadow", x=0, y=0, size=6, offset=1, color=src.eye_c)
						portrait_iris.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 1)
					target.port.vis_contents += portrait_iris
				if(target.race == "Demon")
					if(target.age>=13 || target.age == null || target.age == 1)
						target.overlays += 'Demonic Horns.dmi'
					else if(target.age<=4)
						target.overlays += 'demonic_horns_kid.dmi'
				else if(target.race == "Oni")
					if(target.age>=13 || target.age == null || target.age == 1)
						target.overlays += 'OniHorns.dmi'
					else if(target.age<=4)
						target.overlays += 'oni_horns_kid.dmi'
				target.client.screen += target.port
				target.port.transform = null
				if(target && target.HUD)
					target.HUD.Rescale_HUD(target)
		set_icon(var/mob/target,var/ascend = 0)
			if(target)
				//Clear the old portrait first, making sure to delete any obj/refs
				if(target.port)
					target.port.port_iris = null
					target.port.port_eyes = null
					for(var/obj/portrait/p in target.port)
						p.destroy()
					if(target.client) target.client.screen -= target.port
					if(target.hud_char) target.hud_char.vis_contents -= target.port
					if(target.hud_load) target.hud_load.vis_contents -= target.port
					target.port.destroy()

				//Then re-create the portrait
				target.port = new /obj/portrait/body

				var/obj/portrait/portrait_part/portrait_horns = new(target.port)
				var/obj/portrait/portrait_part/portrait_hair = new(target.port)
				var/obj/portrait/portrait_part/portrait_mouth = new(target.port)
				var/obj/portrait/portrait_part/portrait_nose = new(target.port)
				var/obj/portrait/eyes/portrait_eyes = new(target.port)
				var/obj/portrait/portrait_part/portrait_iris = new(target.port)

				//for(var/obj/p in target.port)
					//world << "DEBUG - Found [p] inside [target.port]"

				target.port.plane = 25
				portrait_iris.layer = 5.2
				portrait_hair.layer = 5.3

				target.port.overlays += /obj/portrait/border
				target.port.underlays += /obj/portrait/background

				portrait_eyes.p_owner = target
				portrait_iris.p_owner = target

				target.port.port_iris = portrait_iris
				target.port.port_eyes = portrait_eyes

				var/b_state = "body1"
				if(target.body_pos == 2) b_state = "body2"
				else if(target.body_pos == 3) b_state = "body3"

				//world << "DEBUG - created [src.port] for [src]"


				var/icon/P

				if(target.gen == "Female")
					switch(target.race)
						if("Demon")
							var/p_icon = 'portrait_demon_female.dmi'
							var/p_state
							var/list/eye_list
							if(target.skin_pos == 1)
								p_icon = 'portrait_demon_female.dmi'
								p_state = "[b_state] skin1"
								eye_list = eyes_portrait_female_demon
							if(target.skin_pos == 2)
								p_icon = 'portrait_demon_female.dmi'
								p_state = "[b_state] skin2"
								eye_list = eyes_portrait_female_demon
							if(target.skin_pos == 3)
								p_icon = 'portrait_human_female.dmi'
								p_state = "[b_state] skin1"
								eye_list = eyes_portrait_female
							if(target.skin_pos == 4)
								p_icon = 'portrait_human_female.dmi'
								p_state = "[b_state] skin2"
								eye_list = eyes_portrait_female
							if(target.skin_pos == 5)
								p_icon = 'portrait_human_female.dmi'
								p_state = "[b_state] skin3"
								eye_list = eyes_portrait_female
							if(target.eye_pos > length(eye_list)) target.eye_pos = 1
							P = icon(p_icon,p_state,SOUTH,1,0)
							target.port.icon = P



							if(target.body_pos != 3)
								var/obj/eyes = eye_list[target.eye_pos]
								portrait_eyes.icon = eyes.icon
								portrait_eyes.icon_state = eyes.icon_state

								var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
								if(target.eye_c) P_eyes_c.Blend(target.eye_c)
								else P_eyes_c.Blend(rgb(0,0,155))
								portrait_iris.icon = P_eyes_c
								P.Blend(P_eyes_c,ICON_OVERLAY)

								var/obj/nose = nose_portrait_female[target.nose_pos]
								portrait_nose.icon = nose.icon
								portrait_nose.icon_state = nose.icon_state

								var/obj/mouth = mouth_portrait_female[target.mouth_pos]
								portrait_mouth.icon = mouth.icon
								portrait_mouth.icon_state = mouth.icon_state

								if(target.hair_pos == 14) target.hair_pos = 1 //Added this here for npc's, ect. Just to make sure there's no out of bounds errors, since 11 for female doesn't exist.
								var/obj/hair = hairs_portrait_female[target.hair_pos]
								var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

								if(target.hair_c) P_hair_c.Blend(target.hair_c)
								P.Blend(P_hair_c,ICON_OVERLAY)
								portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")

						if("Kai")
							var/p_state = "[b_state] skin1"
							if(ascend) p_state = "[b_state] skin2"
							P = icon('portrait_celestial_female.dmi',p_state,SOUTH,1,0)
							target.port.icon = P

							var/icon/P_skin_c = icon(port.icon,"[port.icon_state]",SOUTH,1,0)
							if(P_skin_c)
								if(target.skin_c) P_skin_c.icon *= target.skin_c//P_skin_c.Blend(target.skin_c)
								else P_skin_c.Blend(rgb(0,0,155))
								port.icon = P_skin_c
								if(P)
									P.Blend(P_skin_c,ICON_OVERLAY)



							var/obj/eyes = eyes_portrait_female[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_female[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_female[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							if(target.hair_pos == 14) target.hair_pos = 1 //Added this here for npc's, ect. Just to make sure there's no out of bounds errors, since 11 for female doesn't exist.
							var/obj/hair = hairs_portrait_female[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")

						if("Tuffle")
							var/p_state = 'portrait_human_female.dmi'

							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"
							P = icon('portrait_human_female.dmi',p_state,SOUTH,1,0)
							target.port.icon = P


							var/obj/eyes = eyes_portrait_female[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_female[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_female[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							if(target.hair_pos == 14) target.hair_pos = 1 //Added this here for npc's, ect. Just to make sure there's no out of bounds errors, since 11 for female doesn't exist.
							var/obj/hair = hairs_portrait_female[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")

						if("Half God")
							var/p_state = 'portrait_human_female.dmi'

							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"
							P = icon('portrait_human_female.dmi',p_state,SOUTH,1,0)
							target.port.icon = P


							var/obj/eyes = eyes_portrait_female[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_female[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_female[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							if(target.hair_pos == 13) target.hair_pos = 1 //Added this here for npc's, ect. Just to make sure there's no out of bounds errors, since 11 for female doesn't exist.
							var/obj/hair = hairs_portrait_female[target.hair_pos]
							portrait_hair.icon = hair.icon
							portrait_hair.icon_state = hair.icon_state
						if("Human")
							var/p_state = 'portrait_human_female.dmi'

							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"
							P = icon('portrait_human_female.dmi',p_state,SOUTH,1,0)
							target.port.icon = P

							var/obj/eyes = eyes_portrait_female[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_female[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_female[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							if(target.hair_pos == 14) target.hair_pos = 1 //Added this here for npc's, ect. Just to make sure there's no out of bounds errors, since 11 for female doesn't exist.
							var/obj/hair = hairs_portrait_female[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")


						if("Saiyan")
							var/p_state = 'portrait_human_female.dmi'

							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"
							P = icon('portrait_human_female.dmi',p_state,SOUTH,1,0)
							target.port.icon = P


							var/obj/eyes = eyes_portrait_female[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_female[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_female[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							if(target.hair_pos == 14) target.hair_pos = 1 //Added this here for npc's, ect. Just to make sure there's no out of bounds errors, since 11 for female doesn't exist.
							var/obj/hair = hairs_portrait_female[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = hair.icon
							portrait_hair.icon_state = hair.icon_state
				if(target.gen == "Male")
					switch(target.race)
						if("Makyo")
							var/p_state = "skin1"
							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"
							if(target.skin_pos == 4) p_state = "[b_state] skin4"
							P = icon('portrait_makyo.dmi',p_state,SOUTH,1,0)
							target.port.icon = P


							var/obj/nose = nose_portrait_male[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/eyes = eyes_portrait_yuk[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/mouth = mouth_portrait_male[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							var/obj/hair = hairs_portrait_male[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")

						if("Spirit Doll")
							var/p_state = "skin1"
							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin1"
							P = icon('portrait_spiritdoll.dmi',p_state,SOUTH,1,0)
							target.port.icon = P

							var/obj/nose = nose_portrait_male[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/eyes = eyes_portrait_yuk[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/mouth = mouth_portrait_male[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							var/obj/hair = hairs_portrait_male[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")
						if("Changeling")
							var/p_state = "skin1"
							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin1"
							P = icon('portrait_changeling.dmi',p_state,SOUTH,1,0)
							target.port.icon = P



							var/obj/eyes = eyes_portrait_changeling[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)


							var/obj/mouth = mouth_portrait_male[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

						if("Demon")
							var/p_icon = 'portrait_demon_male.dmi'
							var/p_state
							var/list/eye_list

							if(target.skin_pos == 1)
								p_icon = 'portrait_demon_male.dmi'
								p_state = "[b_state] skin1"
								eye_list = eyes_portrait_male_demon
							if(target.skin_pos == 2)
								p_icon = 'portrait_demon_male.dmi'
								p_state = "[b_state] skin2"
								eye_list = eyes_portrait_male_demon
							if(target.skin_pos == 3)
								p_icon = 'portrait_human_male.dmi'
								p_state = "[b_state] skin1"
								eye_list = eyes_portrait_male_demon
							if(target.skin_pos == 4)
								p_icon = 'portrait_human_male.dmi'
								p_state = "[b_state] skin2"
								eye_list = eyes_portrait_male_demon
							if(target.skin_pos == 5)
								p_icon = 'portrait_human_male.dmi'
								p_state = "[b_state] skin3"
								eye_list = eyes_portrait_male_demon
							if(target.eye_pos > length(eye_list)) target.eye_pos = 1
							P = icon(p_icon,p_state,SOUTH,1,0)
							target.port.icon = P
							if(target.skin_pos == 2)
								var/icon/P_skin_c = icon(port.icon,"[port.icon_state]",SOUTH,1,0)
								if(target.skin_c) P_skin_c.Blend(target.skin_c)
								else P_skin_c.Blend(rgb(0,0,155))
								port.icon = P_skin_c
								P.Blend(P_skin_c,ICON_OVERLAY)


							if(target.body_pos != 3)
								var/obj/eyes = eye_list[target.eye_pos]
								portrait_eyes.icon = eyes.icon
								portrait_eyes.icon_state = eyes.icon_state


								var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
								if(target.eye_c) P_eyes_c.Blend(target.eye_c)
								else P_eyes_c.Blend(rgb(0,0,155))
								portrait_iris.icon = P_eyes_c
								P.Blend(P_eyes_c,ICON_OVERLAY)

								var/obj/nose = nose_portrait_male[target.nose_pos]
								portrait_nose.icon = nose.icon
								portrait_nose.icon_state = nose.icon_state

								var/obj/mouth = mouth_portrait_male[target.mouth_pos]
								portrait_mouth.icon = mouth.icon
								portrait_mouth.icon_state = mouth.icon_state

								var/obj/hair = hairs_portrait_male[target.hair_pos]
								var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

								if(target.hair_c) P_hair_c.Blend(target.hair_c)
								P.Blend(P_hair_c,ICON_OVERLAY)
								portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")
								//portrait_hair.icon_state =
								var/obj/horn = horns_portait_demon[target.horn_pos]
								portrait_horns.icon = horn.icon
								portrait_horns.icon_state = horn.icon_state

						if("Kai")
							var/p_state = "[b_state] skin1"
							//if(ascend) p_state = "[b_state] skin2"
							P = icon('portrait_celestial_male.dmi',p_state,SOUTH,1,0)
							target.port.icon = P

							var/icon/P_skin_c = icon(port.icon,"[port.icon_state]",SOUTH,1,0)
							if(target.skin_c) P_skin_c.Blend(target.skin_c)
							else P_skin_c.Blend(rgb(0,0,155))
							port.icon = P_skin_c
							P.Blend(P_skin_c,ICON_OVERLAY)

							var/obj/eyes = eyes_portrait_kai[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_male[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_male[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							var/obj/hair = hairs_portrait_male[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")
						if("Tuffle")
							var/p_state = 'portrait_human_male.dmi'
							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"
							P = icon('portrait_human_male.dmi',p_state,SOUTH,1,0)
							target.port.icon = P

							var/obj/eyes = eyes_portrait_kai[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_male[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_male[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							var/obj/hair = hairs_portrait_male[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")
						if("Half God")
							var/p_state = 'portrait_human_male.dmi'
							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"
							P = icon('portrait_human_male.dmi',p_state,SOUTH,1,0)
							target.port.icon = P


							var/obj/eyes = eyes_portrait_male[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_male[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_male[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							var/obj/hair = hairs_portrait_male[target.hair_pos]
							portrait_hair.icon = hair.icon
							portrait_hair.icon_state = hair.icon_state
						if("Human")
							var/p_state = 'portrait_human_male.dmi'
							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"
							P = icon('portrait_human_male.dmi',p_state,SOUTH,1,0)
							target.port.icon = P


							var/obj/eyes = eyes_portrait_male[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_male[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_male[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							var/obj/hair = hairs_portrait_male[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")

						if("Saiyan")
							var/p_state = 'portrait_human_male.dmi'
							if(target.skin_pos == 1) p_state = "[b_state] skin1"
							if(target.skin_pos == 2) p_state = "[b_state] skin2"
							if(target.skin_pos == 3) p_state = "[b_state] skin3"
							P = icon('portrait_human_male.dmi',p_state,SOUTH,1,0)
							target.port.icon = P


							var/obj/eyes = eyes_portrait_male[target.eye_pos]
							portrait_eyes.icon = eyes.icon
							portrait_eyes.icon_state = eyes.icon_state

							var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
							if(target.eye_c) P_eyes_c.Blend(target.eye_c)
							else P_eyes_c.Blend(rgb(0,0,155))
							portrait_iris.icon = P_eyes_c
							P.Blend(P_eyes_c,ICON_OVERLAY)

							var/obj/nose = nose_portrait_male[target.nose_pos]
							portrait_nose.icon = nose.icon
							portrait_nose.icon_state = nose.icon_state

							var/obj/mouth = mouth_portrait_male[target.mouth_pos]
							portrait_mouth.icon = mouth.icon
							portrait_mouth.icon_state = mouth.icon_state

							var/obj/hair = hairs_portrait_male[target.hair_pos]
							var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

							if(target.hair_c) P_hair_c.Blend(target.hair_c)
							P.Blend(P_hair_c,ICON_OVERLAY)
							portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")
				if(target.race == "Changeling")
					var/p_state = "skin1"
					var/p_icon = 'portrait_changeling.dmi'
					if(target.skin_pos == 1)
						p_icon = 'portrait_changeling.dmi'
						p_state = "[b_state] skin1"
					if(target.skin_pos == 2)
						p_icon = 'portrait_changeling.dmi'
						p_state = "[b_state] skin2"
					if(target.skin_pos == 3)
						p_icon = 'portrait_changeling.dmi'
						p_state = "[b_state] skin3"
					if(target.skin_pos == 4)
						p_icon = 'portrait_changeling.dmi'
						p_state = "[b_state] skin4"
					if(target.skin_pos == 5)
						p_icon = 'portrait_changeling.dmi'
						p_state = "[b_state] skin5"
					//if(target.skin_pos == 2) p_state = "[b_state] skin2"
					P = icon(p_icon,p_state,SOUTH,1,0)
					target.port.icon = P



					var/obj/eyes = eyes_portrait_changeling[target.eye_pos]
					portrait_eyes.icon = eyes.icon
					portrait_eyes.icon_state = eyes.icon_state

					var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
					if(target.eye_c) P_eyes_c.Blend(target.eye_c)
					else P_eyes_c.Blend(rgb(0,0,155))
					portrait_iris.icon = P_eyes_c
					P.Blend(P_eyes_c,ICON_OVERLAY)


					var/obj/mouth = mouth_portrait_male[target.mouth_pos]
					portrait_mouth.icon = mouth.icon
					portrait_mouth.icon_state = mouth.icon_state

				if(target.race == "Oni")
					var/p_state = "skin1"
					if(target.skin_pos == 1) p_state = "[b_state] skin1"
					if(target.skin_pos == 2) p_state = "[b_state] skin2"
					if(target.skin_pos == 3) p_state = "[b_state] skin1"
					P = icon('portrait_oni.dmi',p_state,SOUTH,1,0)
					target.port.icon = P

					var/obj/nose = nose_portrait_male[target.nose_pos]
					portrait_nose.icon = nose.icon
					portrait_nose.icon_state = nose.icon_state

					var/obj/eyes = eyes_portrait_yuk[target.eye_pos]
					portrait_eyes.icon = eyes.icon
					portrait_eyes.icon_state = eyes.icon_state

					var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
					if(target.eye_c) P_eyes_c.Blend(target.eye_c)
					else P_eyes_c.Blend(rgb(0,0,155))
					portrait_iris.icon = P_eyes_c
					P.Blend(P_eyes_c,ICON_OVERLAY)

					var/obj/mouth = mouth_portrait_male[target.mouth_pos]
					portrait_mouth.icon = mouth.icon
					portrait_mouth.icon_state = mouth.icon_state

					var/obj/hair = hairs_portrait_male[target.hair_pos]
					var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH,1,0)

					if(target.hair_c) P_hair_c.Blend(target.hair_c)
					P.Blend(P_hair_c,ICON_OVERLAY)
					portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")

					var/obj/horn = horns_portrait_oni[target.horn_pos]
					portrait_horns.icon = horn.icon
					portrait_horns.icon_state = horn.icon_state
				//	P.Blend(horns_portrait_oni,ICON_OVERLAY)
				if(target.race == "Namekian")
					var/p_state = "skin1"
					var/p_icon = 'portrait_Namekian.dmi'
					if(target.skin_pos == 1)
						p_icon = 'portrait_Namekian.dmi'
						p_state = "[b_state] skin1"
					if(target.skin_pos == 2)
						p_icon = 'portrait_Namekian.dmi'
						p_state = "[b_state] skin2"
					if(target.skin_pos == 3)
						p_icon = 'portrait_Namekian.dmi'
						p_state = "[b_state] skin3"
					if(target.skin_pos == 4)
						p_icon = 'portrait_Namekian.dmi'
						p_state = "[b_state] skin4"
					P = icon(p_icon,p_state,SOUTH,1,0)
					target.port.icon = P


					var/obj/nose = nose_portrait_male[target.nose_pos]
					portrait_nose.icon = nose.icon
					portrait_nose.icon_state = nose.icon_state

					var/obj/eyes = eyes_portrait_yuk[target.eye_pos]
					portrait_eyes.icon = eyes.icon
					portrait_eyes.icon_state = eyes.icon_state

					var/icon/P_eyes_c = icon(eyes.icon,"[eyes.icon_state] color",SOUTH,1,0)
					if(target.eye_c) P_eyes_c.Blend(target.eye_c)
					else P_eyes_c.Blend(rgb(0,0,155))
					portrait_iris.icon = P_eyes_c
					P.Blend(P_eyes_c,ICON_OVERLAY)

					var/obj/mouth = mouth_portrait_male[target.mouth_pos]
					portrait_mouth.icon = mouth.icon
					portrait_mouth.icon_state = mouth.icon_state

				/*	var/obj/horn = horns_portrait_yuk[target.horn_pos]
					portrait_horns.icon = horn.icon
					portrait_horns.icon_state = horn.icon_state */
				if(target.race == "Alien")
					P = icon('portrait_cerebroid.dmi',"skin1",SOUTH,1,0)
					target.port.icon = P
					var/obj/eyes = eyes_portrait_cerebroid[target.eye_pos]
					portrait_eyes.icon = eyes.icon
					portrait_eyes.icon_state = eyes.icon_state

				for(var/obj/portrait/p in target.port)
					if(p.icon) target.port.vis_contents += p
					else
						//Purge any portrait parts that didn't get assigned an icon
						//No icon means its not used for that race for one reason or another
						p.p_owner = null
						if(p == target.port.port_eyes) target.port.port_eyes = null
						if(p == target.port.port_iris) target.port.port_iris = null
						p.destroy()

				if(portrait_iris.icon)
					if(target.race == "Alien" && target.skin_pos == 1)
						if(target.eye_c == null) target.eye_c = rgb(0,0,255)
						portrait_iris.filters += filter(type="drop_shadow", x=0, y=0, size=6, offset=1, color=src.eye_c)
						portrait_iris.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 1)
					target.port.vis_contents += portrait_iris

				return P
		set_genetic_limits()
			src.gene_limit_psi = round(src.mod_psionic_power + src.gene_limit,0.1)
			src.gene_limit_energy = round(src.mod_energy + src.gene_limit,0.1)
			src.gene_limit_strength = round(src.mod_strength + src.gene_limit,0.1)
			src.gene_limit_endurance = round(src.mod_endurance + src.gene_limit,0.1)
			src.gene_limit_resistance = round(src.mod_resistance + src.gene_limit,0.1)
			src.gene_limit_force = round(src.mod_force + src.gene_limit,0.1)
			src.gene_limit_agility = round(src.mod_agility + src.gene_limit,0.1)
			src.gene_limit_offence = round(src.mod_offence + src.gene_limit,0.1)
			src.gene_limit_defence = round(src.mod_defence + src.gene_limit,0.1)
			src.gene_limit_regen = round(src.mod_regeneration + src.gene_limit,0.1)
			src.gene_limit_recov = round(src.mod_recovery + src.gene_limit,0.1)
		remove_player_blip()
			if(src.map_blip)
				for(var/mob/m in players)
					if(m.client) m.client.images -= src.map_blip
		create_player_blip()
			set background = 1
			set waitfor = 0
			if(maps_created && src.map_blip == null)
				var/image/map_blip/m_p = image('map_blip.dmi',map_master,"",10)
				if(src.client) m_p.ref = src.client.key
				m_p.pixel_x = src.x-3
				m_p.pixel_y = src.y-19
				src.map_blip = m_p
				if(src.client) src.client.images += m_p
		create_afterimages()
			src.afterimages = list()
			var num = 200;
			while(num > 0) {
				num -= 1;
				var/obj/effects/after_image/af = new
				af.hashadow = 0
				af.enable(src)
				src.afterimages.Add(af)
				//sleep(0.2)
			}
		create_main_bars()
			if(src.hud_hp_bar == null)
				//Create hp bars
				var/obj/hud/bars/player_hp/b = new
				src.hud_hp_bar = b

				var/obj/hud/bars/player_hp_inner/h = new
				var/matrix/m = matrix()
				m.Scale(src.percent_health*2,1)
				m.Translate(src.percent_health,0)
				h.transform = m
				h.loc = b
				src.hud_hp_bar_inner = h

			if(hud_eng_bar == null)
				//Create eng bars
				var/obj/hud/bars/player_eng/b2 = new
				src.hud_eng_bar = b2

				var/obj/hud/bars/player_eng_inner/m = new
				var/matrix/mt = matrix()
				mt.Scale(src.percent_health*2,1)
				mt.Translate(src.percent_health,0)
				m.transform = mt
				m.loc = b2
				src.hud_eng_bar_inner = m
			if(src.hud_passivetree == null)
				var/obj/hud/bars/passivetree/p1 = new
				src.hud_passivetree = p1
			if(src.hud_immersionshop == null)
				var/obj/hud/bars/immersionshop/is1 = new
				src.hud_immersionshop = is1
			if(src.hud_dokushop == null)
				var/obj/hud/bars/dokushop/ds1 = new
				src.hud_dokushop = ds1
			if(src.phase_icon == null)
				var/obj/effects/phase_icon/phaseicon = new
				src.phase_icon = phaseicon
			if(src.roleplaymode_icon == null)
				var/obj/effects/roleplaymode_icon/rpmicon = new
				src.roleplaymode_icon = rpmicon
			if(src.hud_cft == null)
				var/obj/hud/menus/cft_gains_txt/cftb = new
				src.hud_cft = cftb
				src.hud_cft.cycler = src
				if(src.cycle_free_time) src.client.screen += src.hud_cft



			if(src.hud_rptree == null)
				var/obj/hud/bars/rptree/p2 = new
				src.hud_rptree = p2
			if(src.hud_pp == null)
				//Create psionic power bars
				var/obj/pp = new
				pp.plane=29
				pp.maptext_width = 320
				pp.maptext = "<font size = 1> <text align=left>[css_outline]Power: N/A"
				pp.screen_loc = "3:-1,18:-13"
				src.hud_pp = pp

			if(src.hud_eat == null)
				//Create eating bar
				var/obj/hud/bars/player_eat/e = new
				src.hud_eat = e

			if(src.client)
				src.client.screen += src.hud_hp_bar
				src.client.screen += src.hud_hp_bar_inner
				src.client.screen += src.hud_immersionshop
				src.client.screen += src.hud_dokushop
				src.client.screen += src.hud_eng_bar
				src.client.screen += src.hud_eng_bar_inner
				src.client.screen += src.hud_pp
				src.client.screen += src.hud_passivetree
			//	src.client.screen += src.hud_rptree
			if(src && src.HUD)
				src.HUD.Rescale_HUD(src)
		stat_desc(var/stat)
			var/t
			if(stat == "Energy")
				t = text_eng
			if(stat == "Strength")
				t = text_str
			if(stat == "Endurance")
				t = text_end
			if(stat == "Agility")
				t = text_agil
			if(stat == "resistance")
				t = text_res
			if(stat == "Force")
				t = text_force
			if(stat == "Offence")
				t = text_acc
			if(stat == "Defence")
				t = text_reflex
			if(stat == "Recovery")
				t = text_recov
			if(stat == "Regeneration")
				t = text_regen
			winset(src,"char_creation.stat_info","text=\"[t]\"")
			winset(src,"char_creation.label_stat","text=\"[stat]\"")
		switch_character()
			src.client.screen += src.screen_text
			src.client.images += src.map_blip
			src.client.screen += src.hud_info
			src.enable_planes()
			src.create_main_bars()
			if(src.port)
				src.client.screen += src.port
				src.port.transform = null
		confirm_new_character()
			if(src.started) return
			src.confirming=1
			src.transform = null
			src.choosing_character = 0


			var/image/ko = image('bars_ko.dmi',src,"100",20)
			src.bar_ko = ko

			//if(src.vision == null)
			//	var/obj/effects/vision/v = new
			//	src.vision = v
				//if(src.client) src.client.screen += v

			src.tutorials = list(new /:Help_Meditation, /:Help_Grabbing,new /:Alert_Misc,new /:Help_Map,new /:Help_Gravity, new/:Help_New_Character_Grace_Period, new /:Help_Lethal_Combat, new/:Help_Roleplay_Mode, new/:Help_Phase_Mode, new/:Help_Personal_Gains, new/:Help_Cycling, new/:Help_Needs_HTT, new/:Help_Passive_Points, new/:Help_General_Information, new/:Help_Weekly_Resets, new/:Help_Rules, new/:Help_Rules2, new/:Help_Rules3, new/:Help_Rules4, new/:Help_Rules5, new/:Help_Rules6, new/:Help_General_FAQS)

			if(src.started == 0 && src.offspring == 0)
			//	src.vision.alpha = 255
			//	animate(src.vision,alpha = 0,time = 20)
				if(src.race == "Changeling")
					switch(input("Select a class as a Changeling.") in list ("Frieza","Kold","Cooler"))
						if("Frieza")
							src.race_class = "Frieza"
						if("Kold")
							src.race_class = "Kold"
						if("Cooler")
							src.race_class = "Cooler"
				if(src.race == "Alien")
					var/genderchoice = input("Asexual Choices") in list ("Yes","No")
					if(genderchoice == "Yes")
						src.gen = "Neuter"

					switch(input("Select an alien type.") in list ("Energy","Physical","Speed","Yardrat","Metamoran","Technician","Wizard/Witch"))
						if("Energy")
							src.race_class = "Energy"
						if("Physical")
							src.race_class = "Physical"
						if("Speed")
							src.race_class = "Speed"
						if("Yardrat")
							src.race_class = "Yardrat"
						if("Metamoran")
							src.race_class = "Metamoran"
						if("Technician")
							src.race_class = "Technician"
						if("Wizard/Witch")
							switch(alert(src,"Which mage style will you be going with?","","Wizard","Witch"))
								if("Wizard")
									src.race_class = "Wizard"
								if("Witch")
									src.race_class = "Witch"



				if(src.race == "Saiyan") src.rngSaiyanClass()
				if(src.key == "VOXTECH")
					src.starting_skills(1)
					//src.milestone_checked=1
					//src.show_milestones()
					src.show_adminpanel()
				else src.starting_skills(0) //Create any starting skills for the player

				//src.apply_size_speed(src)
				src.rng_mods_and_pg()


				src.real_name = "[src.name]"
				src.icon_original = src.icon
				src.enable_planes()
				src.create_main_bars()
				src.create_afterimages()
				src.apply_size_speed(src)
				src.round_mods()
				src.client.custom_view = 0
				src.client.setMap(1)
				if(!HUD)
					HUD = new
				HUD.Rescale_HUD(src)
				//save_map_screen(src.client)




				var/obj/effects/screen_text/st = new
				var/obj/effects/screen_text/st2 = new
				src.screen_text = st
				src.screen_text2 = st2
				var/obj/hud/menus/info/inf = new
				src.hud_info = inf
				//var/obj/hud/bars/name_bar/nb = new
				//src.hud_namebar = nb

				if(src.race == "Demon")
					src.gravity_mastered = 10
					src.loc = locate(450/rand(1,5),450/rand(1,5),6)
					src.home_planet = "Hell"
					if(src.eye_c)
						if(src.age<13 && src.age >3.9)
							src.eyes.icon = 'eye_pupils_kid.dmi'
							src.eyes_white.icon = 'eye_whites_kid.dmi'
						else
							src.eyes.icon = 'eye_pupils.dmi'
							src.eyes_white.icon = 'eye_whites.dmi'
						src.eyes.filters += filter(type="drop_shadow", x=0, y=0, size=5, offset=1, color=src.eye_c)
						src.eyes.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 5,offset=1,alpha = 5)
				else if(src.race == "Saiyan")
					src.loc = locate(450/rand(1,5),450/rand(1,5),10)
					src.gravity_mastered = 5
					src.home_planet = "Vegeta"

				else if(src.race == "Kai")
					src.loc = locate(130,449,11)
					src.gravity_mastered = 1
					src.home_planet = "Heaven"
					if(src.eye_c)
						if(src.age<13 && src.age >3.9)
							src.eyes.icon = 'eye_pupils_kid.dmi'
							src.eyes_white.icon = 'eye_whites_kid.dmi'
						else
							src.eyes.icon = 'eye_pupils.dmi'
							src.eyes_white.icon = 'eye_whites.dmi'
						src.eyes.filters += filter(type="drop_shadow", x=0, y=0, size=2, offset=1, color=src.eye_c)
						src.eyes.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 2,offset=1,alpha = 2)
					//spawn(20)
					//	if(src) src.Celestial_Wings()
				//	var/obj/skills/Hide_Wings/hw = new
					//hw.loc = src
				else if(src.race == "Oni")
					src.loc = locate(130,449,2)
					src.gravity_mastered = 9
					src.home_planet = "Checkpoint"

				else if(src.race == "Changeling")
					src.loc = locate(450/rand(1,5),450/rand(1,5),9)
					src.gravity_mastered = 20
					src.home_planet = "Icer"

				else if(src.race == "Namekian")

					src.loc = locate(450/rand(1,5),450/rand(1,5),4)
					src.gravity_mastered = 3
					src.home_planet = "Namek"
					//src.give_divine_seed()




				else if(src.race == "Alien")
					//src.total_organs += 1
					switch(input("Which planet will you be born on:") in list ("Icer","Vegeta","Namek","Earth"))
						if("Icer")
							src.loc = locate(450/rand(1,5),450/rand(1,5),9)
							src.gravity_mastered = 20
							src.home_planet = "Icer"
						if("Namek")
							src.loc = locate(450/rand(1,5),450/rand(1,5),4)
							src.gravity_mastered = 3
							src.home_planet = "Namek"
						if("Vegeta")
							src.loc = locate(450/rand(1,5),450/rand(1,5),10)
							src.gravity_mastered = 5
							src.home_planet = "Vegeta"
						if("Earth")
							src.loc = locate(450/rand(1,5),450/rand(1,5),1)
							src.gravity_mastered = 1
							src.home_planet = "Earth"
				else if(src.race == "Tuffle")
					src.loc = locate(450/rand(1,5),450/rand(1,5),10)
					src.gravity_mastered = 5
				else
					src.loc = locate(450/rand(1,5),450/rand(1,5),1)
					src.gravity_mastered = 1
				/*else if(src.race == "Android")
					src.rad_field()
					if(src.skin_pos == 1 && src.eyes)
						src.eyes.icon = 'humanoid_eyes_iris_android.dmi'
						if(src.eye_c == null) src.eye_c = rgb(0,0,255)
						src.eyes.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=src.eye_c)
						src.eyes.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)*/
			/*else if(src.creature_started == 1 && src.started ==0)
				//src.copy_mob_genetics(src.offspring_transport,1,1,0,0,"default")
				//src.offspring_transport.key = src.key
				//src.race=src.offspring_transport.race
				src.vision.alpha = 255
				animate(src.vision,alpha = 0,time = 20)
				//src.gen = src.offspring_transport.gen
				src<< "Generation: [src.gen](og:[src.offspring_transport.gen])"
				if(src.age<4||src.age==0.1) src.set_baby_icon()
				if(src.race == "Saiyan") src.rngSaiyanClass()
				if(src.key in StaffTeam)
					src.starting_skills(1)
					//src.milestone_checked=1
					//src.show_milestones()
					src.show_adminpanel()
				else src.starting_skills(0) //Create any starting skills for the player
				//src.rng_mods_and_pg()
				//src.confirm_stats()
				src.enable_planes()
				src.create_main_bars()
				src.create_afterimages()
			//	src.apply_size_speed(src)
				//src.round_mods()
			//	src.name = src.offspring_transport.name
				//src.real_name = src.offspring_transport.real_name
			//	src.fullname = src.offspring_transport.name
				src.icon_original = src.icon
				src<< "Details, planes, and main bars done."
				//src.apply_size_speed(src)
			//	src.loc=src.offspring_transport.savedloc
				src<< "Location finalized."

				var/obj/effects/screen_text/st = new
				src.screen_text = st
				var/obj/hud/menus/info/inf = new
				src.hud_info = inf
				//var/obj/hud/bars/name_bar/nb = new
				//src.hud_namebar = nb
				//ActiveChildren -= src.offspring_transport
				src<< "Menu hud, and Active Child deduction finalized."
				if(!HUD)
					HUD = new
				HUD.Rescale_HUD(src)*/

			if(src.offspring)
				var/obj/effects/screen_text/st = new
				src.screen_text = st
				var/obj/hud/menus/info/inf = new
				src.hud_info = inf
				src.create_main_bars()
				if(src.key == "VOXTECH")
					src.starting_skills(1)
					//src.milestone_checked=1
					//src.show_milestones()
					src.show_adminpanel()
				else src.starting_skills(0) //Create any starting skills for the player

				if(src.profile)
					//world<< "Appyling profile to [src]"
					src.apply_offspring_profile(src.profile)
					src.apply_size_speed(src)
					src.round_mods()
					src.loc = src.savedloc
				//	src.real_name = "[src.profile.name]"
					src.icon_original = src.icon
					//src.name = src.realname
					//src.fullname = src.realname
				if(ActiveChildren.Find(src.profile))
					ActiveChildren -= src.profile
					var/savefile/F = new("saves/ChildrenandAndroids/ActiveChildren.sav")
					F["ActiveChildren"] << ActiveChildren

				view(5,src)<<output("<b><font color=yellow>[src.name] was born!</b></font>","actionoutput")
			//src<< "Starting confirm new character extra!"
			if(isobj(src.loc))
				var/obj/o = src.loc
				src.loc = o.loc

			if(src.z == 2)
				src.apply_korintower_glow(0)
				src.apply_loginday_glow(0)
				src.apply_loginnight_glow(0)
				src.apply_afterlife_glow(1)
			else if(src.z == 6)
				src.apply_korintower_glow(0)
				src.apply_loginday_glow(0)
				src.apply_loginnight_glow(0)
				src.apply_hell_glow(1)
			else if(src.z == 12)
				src.apply_korintower_glow(0)
				src.apply_loginday_glow(0)
				src.apply_loginnight_glow(0)
				src.apply_demonrealm_glow(1)
			else
				src.apply_korintower_glow(0)
				src.apply_afterlife_glow(0)
				src.apply_loginday_glow(0)
				src.apply_loginnight_glow(0)
				src.apply_hell_glow(0)
				src.apply_demonrealm_glow(0)
			if(!players.Find(src)) players += src
			//if(src.client)
		//	src<< "Checking Client(Confirming Character)!"

			//src.show_worldtree(1)
			//if(src.client) winset(src,"chat","alpha=190")
			//if(src.client) winset(src,"chat.alpha","value=45")
			//if(src.client) winset(src,"chat.alpha","value=45")
			//if(src.client) winset(src, "chat", "size=600x500") // 600x500
			if(src.client)
			//	src<< "Checking Client(Confirming Character)!"

				//src.show_worldtree(1)
				//if(src.client) winset(src,"chat","alpha=190")
				//if(src.client) winset(src,"chat.alpha","value=45")
				//if(src.client) winset(src,"chat.alpha","value=45")
				//if(src.client) winset(src, "chat", "size=600x500") // 600x500
				src.client.screen += src.screen_text
			//	if(src.hud_chat) src.client.screen += src.hud_chat
			//	src<< "Hud chat and screen_txt created!"
				//Music
				//src.tracks()
				src.music_random = 0
				//src.StopMidi()
				//src.play_all_music()
				src.title(1)
			//	src<< "Title(1)!"
				src.client.screen += src.hud_info
				src.paper_doll()
			//	src<< "Paper doll created!"
				src.setup_alert_history()
				src.change_icon = 1
				src.byond_key = src.key
			//	src.new_contact_world()
				//src.gain_relations()
				src.show_ui()
			//	src<< "UI SHOWN!"
				//src.sight = SEE_BLACKNESS// | SEE_PIXELS
				src.online = 1
				if(src.eyes && src.age<13)
					src.vis_contents -= list(src.eyes, src.eyes_white)
					remove_overlays(src, list(src.eyes, src.eyes_white))
					src.eyes = null
					src.eyes_white = null
					//src.overlays -= src.eyes_white

			//	src<< "Checking Offspring!"
				if(src.offspring)
			//		src<< "Offspring HUD Scaled confirmed!"
					if(!HUD)
						HUD = new
					HUD.Rescale_HUD(src)
				//src.create_research() //Create all the tech for the player

			src.SAVEFILE_VERSION = game_version
			src.name_txt()
			src.create_player_blip()
		//	src<< "Blip created"
			src.log_year = global.year
			src.log_psi_year = global.psi_year
			if(global.names_taken.Find(src.real_name) == 0) global.names_taken += src.real_name
			//world.Save_Contacts()

			src.eyes_copy = src.eyes
			src.eyes_white_copy = src.eyes_white
			if(src.hud_body) src.hud_body.color_paperdoll(src)
			//if(src.hud_paperdoll) src.hud_paperdoll.color_paperdoll(src)
			src.started = 1

			src.can_save = 1
		//	src<< "Choosing character set to 0 "
			var/r
			var/g
			var/b
			switch(rand(1,14))
				if(1,11)
					r = rand(1,250); g = rand(1,200); b = rand(1,250)
				if(2)
					r = rand(20,80); g = rand(1,200); b = rand(1,255)
				if(3)
					r = 0; g = rand(80,200); b = rand(20,255)
				if(4)
					r = rand(1,255); g = rand(1,20); b = rand(56,175)
				if(5)
					r = rand(1,60); g = rand(1,80); b = rand(1,120)
				if(6)
					r = rand(80,155); g = 0; b = rand(1,80)
				if(7)
					r = rand(5,253); g = rand(5,253); b = rand(5,80)
				if(8)
					r = rand(5,80); g = rand(5,253); b = rand(5,253)
				if(9)
					r = rand(5,80); g = rand(5,80); b = rand(5,80)
				if(10)
					r = rand(35,153); g = rand(65,153); b = rand(95,153)
				if(12)
					r = rand(0,255); g = rand(200,255); b = rand(0,255)
				if(13)
					r = rand(200,255); g = rand(0,255); b = rand(0,255)
				if(14)
					r = rand(0,255); g = rand(0,255); b = rand(200,255)
			// Blend toward bright highlights so random aura colors look smoother and less muddy.
			r = round((r * 3 + rand(200,255)) / 4)
			g = round((g * 3 + rand(190,255)) / 4)
			b = round((b * 3 + rand(200,255)) / 4)
			src.auracolor = rgb(r,g,b)
			src.signature = rand(111111111,999999999)
			/*winset(src, null, {"
					ChatOut.is-visible      = "true";
					ActionOutputChild.is-visible      = "true";
					sayinput.is-visible      = "true";
					worldinput.is-visible      ="true";


				"})
			winset(src, "ActionOutputChild", "splitter=left;can-resize=true")*/
		//	winset(src, "ChatOut", "splitter=top;can-resize=true;size=85")
		//	winset(usr, "ActionOutputChild", "splitter=top;can-resize=true;size=150")

			src.known_people += src.real_name

			spawn(20)
				src.process_stats()
			spawn(10)
				src.process_HTT_decay()


			if(src.client)
		//		src<< "Client check- attempting save!"
				src.key_save()
		//		src<< "Key save finished!"
				//if(src.babyport)
				//	if(src.port) src.client.screen -= src.port
				//	src.client.screen += src.babyport
				//	src.babyport.transform = null
				//else
				if(src.port)
					src.client.screen += src.port
					src.port.transform = null

				spawn src.auto_skill_learning()
			for(var/obj/items/tech/t in global.tech)
				if(istype(t,/obj/items/tech/sub_tech/Engineering/))
					if(src.intxp < t.needed_qp)
						src.hud_tech.tree_engineering_list -= t
				else if(istype(t,/obj/items/tech/sub_tech/Physics/))
					if(src.intxp < t.needed_qp)
						src.hud_tech.tree_physics_list -= t

				else if(istype(t,/obj/items/tech/sub_tech/Genetics/))
					if(src.intxp < t.needed_qp)
						src.hud_tech.tree_genetics_list -= t
			if(src.hud_unlocks)
				src.hud_unlocks.check_status(src)
				src.hud_unlocks.switch_tab(src.hud_unlocks.selected,src)
			var/turf/t = src.loc
			src.loc.Enter(src)
			src.Move(t)
			src.grav = t.grav
			if(!src.offspring)
				var/mutations/Mutator = new /mutations()  // Create an instance of the mutation handler
				Mutator.Mutate(src)
			src.qp_me_generate()
			src<<sound(null)
			src.MapZoom()
			src << "<html><b><font color=#FFFF99>Patch 2.304</font></b></span></html>"
			src<<"<b><font color=yellow>Condolences to Akira Toriyama's family, Rest in peace to the legend.(1955-2024)</b></font>"
			src<<"<b>Type /help in the bottom say bar for extra commands!</b>"
			spawn() process_standing_gains()
			if(!src.hud_roleplayrank)
				var/obj/hud/menus/roleplay_rank_label/rprank = new
				src.hud_roleplayrank = rprank
				src.hud_roleplayrank.rankist = src
				src.client.screen += src.hud_roleplayrank
			var/music_file
			var/music_volume = 25
			switch(z)
				if(1)//earth
					music_file = pick('EarthMusic.ogg', 'BulmaAndTheFrog.ogg', 'TheSagaContinues.ogg')
				if(4)//namek
					music_file = pick('BulmaAndTheFrog.ogg', 'GokusNightmare.ogg', 'TheSagaContinues.ogg')
				if(10)//vegeta
					switch(rand(1,4))
						if(1)
							music_file = 'TheSagaContinues.ogg'
						if(2)
							music_file = 'KingKai.ogg'
							music_volume = 35
						if(3)
							music_file = 'SnakeWay.ogg'
							music_volume = 35
						if(4)
							music_file = 'PowerMusic.ogg'
				if(9)//icer
					music_file = pick('PowerMusic.ogg', 'GokusNightmare.ogg', 'TheSagaContinues.ogg')

				if(6)//hell
					switch(rand(1,3))
						if(1)
							music_file = 'HellTheme.ogg'
						if(2)
							music_file = 'FriezaBegs.ogg'
				if(12)//hell
					music_file = pick('HellTheme.ogg', 'FriezaBegs.ogg')

				if(11)//heaven
					music_file = pick('KingKai.ogg', 'OldKaisDance.ogg', 'BulmaAndTheFrog.ogg')
				if(2)//cp
					music_file = pick('KingKai.ogg', 'OldKaisDance.ogg', 'BulmaAndTheFrog.ogg')
			if(music_file)
				src << sound(music_file, 1, volume = music_volume)
			//if(src.age<=3.9) src.set_baby_icon(src)
			src.set_shadow()
			if(src.client)
				src.client.eye = src
				src.client.perspective = MOB_PERSPECTIVE

			src.confirm_stats()
			if(cftglobal)
				spawn(1)
					src.check_cft()
			if(!HUD)
				HUD = new
			HUD.Rescale_HUD(src)
			src.check_late_game_reward()
			if(src.hud_accelerator) src.client.screen -= src.hud_accelerator
			var/obj/hud/menus/accelerated_gains_txt/acceleration = new
			src.hud_accelerator = acceleration
			src.hud_accelerator.accelerator = src
			src.client.screen += src.hud_accelerator

			src.confirming=0



		check_late_game_reward()
			if(year>4)
				if(!src.offline_gains)
					src.offline_gains += (4*year)
					src<<"<i>You have been gifted some acceleration gains for joining late, enjoy!</i>"
					return

		qp_me_generate()
			if(src.race_class == "Wizard" ||src.race_class == "Witch" ||src.race == "Demon" ||src.race == "Kai"||src.race == "Oni"||src.race=="Spirit Doll")
				if(src.age_text == "Baby")
					src.magicxp = 30 + src.mod_tech_potential
				if(src.age_text == "Kid")
					src.magicxp = 50 + src.mod_tech_potential
				if(src.age_text == "Teen")
					src.magicxp = 50 + src.mod_tech_potential
				if(src.age_text == "Adult")
					src.magicxp = 75 + src.mod_tech_potential
			if(src.age_text == "Baby")
				src.intxp = 30 + src.mod_tech_potential
			if(src.age_text == "Kid")
				src.intxp = 50 + src.mod_tech_potential
			if(src.age_text == "Teen")
				src.intxp = 50 + src.mod_tech_potential
			if(src.age_text == "Adult")
				src.intxp = 75 + src.mod_tech_potential

		confirm_stats()
			//Set new character starting stats here based on their mods.
			if(src.race=="Changeling")
				//src.psionic_power_base =(src.mod_psionic_power*100)
				src.gains_trained_energy = 500*src.gains_trained_energy_mod
				src.energy = src.energy_max

			else
			//	src.psionic_power_base =src.age*(src.mod_psionic_power)
				src.gains_trained_energy = (500*src.gains_trained_energy_mod)
				src.energy = src.energy_max

			src.AddStatMod("Strength",src.mod_strength)
			src.AddStatMod("Endurance",src.mod_endurance)
			src.AddStatMod("Force",src.mod_force)
			src.AddStatMod("Resistance",src.mod_resistance)
			src.AddStatMod("Speed",src.mod_agility)
			src.AddStatMod("Offence",src.mod_offence)
			src.AddStatMod("Defence",src.mod_defence)
			//src<<"<center><b>Best Modifiers</b></center>"
			src.GetTopThreeMods()
			src.passive_points = 20 + round((year*0.125),1)
			if(src.age == 4) src.occupation = "Allowance"
			if(src.age <4) src.occupation = "Trust Funded"
			if(!src.open_menus) src.open_menus = list()
			src.open_help = 1
			src.open_menus.Add(".open_help")
			src.client.screen += src.hud_help
			winset(src,"map.map","focus=true")

		refresh_hud_menu(var/menu_type, var/slot_name)
			var/obj/existing = src.vars[slot_name]
			if(existing)
				qdel(existing)
				src.vars[slot_name] = null
			var/obj/menu = new menu_type
			src.vars[slot_name] = menu
			menu.loc = src
			call(menu, "menu_create")()
			return menu
		setup_hud_menus()
			var/list/menu_defs = list(
				list(/obj/hud/menus/core_stats_background, "hud_stats"),
				list(/obj/hud/menus/inventory_background, "hud_inv"),
				list(/obj/hud/menus/tech_background, "hud_tech"),
				list(/obj/hud/menus/unlocks_background, "hud_unlocks"),
				list(/obj/hud/menus/options_background, "hud_opt"),
				list(/obj/hud/menus/skills_background, "hud_skills")
			)
			for(var/list/menu_def in menu_defs)
				src.refresh_hud_menu(menu_def[1], menu_def[2])
			var/obj/hud/menus/bodyparts_background/bp = src.refresh_hud_menu(/obj/hud/menus/bodyparts_background, "hud_body")
			for(var/obj/hud/menus/bodyparts_background/bodypart/lb in bp.body)
				src.client.screen += lb
			src.refresh_hud_menu(/obj/hud/menus/contacts_background, "hud_contacts")
			src.refresh_hud_menu(/obj/hud/menus/build_background, "hud_build")
			src.refresh_hud_menu(/obj/hud/menus/help_background, "hud_help")
		rebuild_menus()
			src.setup_hud_menus()
		create_menus()
			src.setup_hud_menus()

			//var/obj/hud/menus/limb_paperdoll/pd = new
			//src.hud_paperdoll = pd
			//pd.loc = src
			//pd.menu_create()

			// bodyparts are handled in setup_hud_menus()


			// contacts/build/help are handled in setup_hud_menus()

			//var/obj/hud/menus/chat_background/ch = new
		//	src.hud_chat = ch
			//ch.loc = src
		//	ch.menu_create()

		grant_skill(var/skill_type, var/slot = 0)
			var/obj/skills/skill = new skill_type
			skill.loc = src
			if(slot)
				src.add_to_skillbar(skill, src.hud_skillbar[slot])
			return skill
		grant_skill_list(var/list/skill_types)
			for(var/path in skill_types)
				src.grant_skill(path)
			return
			
		starting_skills(var/all = 0)
			src.skill_meditation = src.grant_skill(/obj/skills/Meditate, 2)
			src.skill_selftrain = src.grant_skill(/obj/skills/Self_Train, 3)


			//var/obj/skills/Power_Control/pc = new
			//pc.loc = src
		//	src.skill_power_control = pc
			//src.add_to_skillbar(pc,src.hud_skillbar[5])
			src.skill_gather = src.grant_skill(/obj/skills/Gather)

			src.skill_run = src.grant_skill(/obj/skills/Toggle_Run, 5)


			src.skill_dig = src.grant_skill(/obj/skills/Dig, 4)

			src.grant_skill(/obj/skills/Sleep)

			src.grant_skill(/obj/skills/Attack, 1)


			var/obj/skills/Study/stdy = src.grant_skill(/obj/skills/Study)

			var/obj/skills/Research/rsrch = src.grant_skill(/obj/skills/Research)


			if(src.race == "Tuffle" ||src.race_class == "Technician")
				src.add_to_skillbar(stdy,src.hud_skillbar[6])


			if(src.race == "Tuffle" ||src.race_class == "Technician")
				src.add_to_skillbar(rsrch,src.hud_skillbar[7])
			if(src.race_class == "Wizard" ||src.race_class == "Witch" ||src.race == "Demon" ||src.race == "Kai"||src.race == "Oni"||src.race=="Spirit Doll"||src.race=="Namekian")
				src.grant_skill(/obj/skills/Hone, 6)
				src.grant_skill(/obj/skills/Harness, 7)

			if(src.race == "Saiyan")
				src.grant_skill(/obj/skills/Look_At_Moon, 6)



		//	var/obj/skills/Psi_Clone/psi_c = new
		//	psi_c.loc = src

			if(all)

				src.grant_skill_list(list(
					/obj/skills/Flight,
					/obj/skills/Divine_Weapon,
					/obj/skills/Germination,
					/obj/skills/Stunning_Blow,
					/obj/skills/Precision,
					/obj/skills/Dark_Petrifaction,
					/obj/skills/Dark_Transmutation,
					/obj/skills/Decline_Absorb,
					/obj/skills/Soul_Absorb,
					/obj/skills/Solar_Flare,
					/obj/skills/Psi_Lightning,
					/obj/skills/Psionic_Lance,
					/obj/skills/Astral_Projection,
					/obj/skills/Teleportation,
					/obj/skills/Reincarnation,
					/obj/skills/Ressurect,
					/obj/skills/Restoration,
					/obj/skills/Telepathy,
					/obj/skills/Beam,
					/obj/skills/Power_Control,
					/obj/skills/Ki_Blade,
					/obj/skills/Ki_Fist,
					/obj/skills/Blast,
					/obj/skills/Invisibility,
					/obj/skills/Expand,
					/obj/skills/Charge,
					/obj/skills/Self_Destruct,
					/obj/skills/Zanzoken,
					/obj/skills/Split_Form,
					/obj/skills/Telekinesis,
					/obj/skills/Energy_Shield,
					/obj/skills/Give_Power,
					/obj/skills/Kaiosoku,
					/obj/skills/Kaioken,
					/obj/skills/Kaioenjin,
					/obj/skills/Kaioryu,
					/obj/skills/Destructo_Disk,
					/obj/skills/Summon_Mage_Pot,
					/obj/skills/Create_Energy_Drainer,
					/obj/skills/Underworld_Portal,
					/obj/skills/Spirit_Reprieve,
					/obj/skills/Majinize,
					/obj/skills/Mysticize,
					/obj/skills/Conceive_Offspring,
					/obj/skills/UnlockPotential,
					/obj/skills/Create_Dragonballs,
					/obj/skills/Create_Namekian_Dragonballs
				))

				var/obj/skills/Sense/sn = src.grant_skill(/obj/skills/Sense)
				sn.super_sense = 1

				var/obj/skills/Remote_Viewing/rm = src.grant_skill(/obj/skills/Remote_Viewing)
				src.skill_remote_viewing = rm

			//	var/obj/skills/Evil_Containment_Wave/ew = new
			//	ew.loc = src





			//	var/obj/skills/Profusion/pf = new


			if(src.client)
				var/count = 0
				for(var/obj/skills/o in src)
					src << output(o,"skills.grid_skills:[++count]")
				winset(src, "skills.grid_skills", "cells=\"[count]\"")

		tmp_lists()
			set waitfor = 0
			reset_shared_runtime_lists()

		reset_shared_runtime_lists()
			remembers_strength = list()
			remembers_endurance = list()
			remembers_agility = list()
			remembers_resistance = list()
			remembers_force = list()
			remembers_offence = list()
			remembers_defence = list()
			remembers_recovery = list()
			remembers_regeneration = list()
			blips = list()
			open_menus = list()
			chat_see = list()
			hurt_limbs = list()

			restedness_sources = list()
			power_sources = list()
			energy_sources = list()
			divine_sources = list()
			dark_matter_sources = list()
			strength_sources = list()
			endurance_sources = list()
			resistance_sources = list()
			agility_sources = list()
			force_sources = list()
			offence_sources = list()
			defence_sources = list()
			regen_sources = list()
			recov_sources = list()
			
		set_lists()
			learnable_origins = list()
			options = list()
			habitats = list()
			debuffs = list()
			tech_lvls = list()
			tech_xp = list()
			tech_unlocked = list()
			bodyparts = list()
			RP_last = list()
			RP_last_100 = list()
			hud_map = list(new /:map_loc,new /:map_cords)
			RP_word_count = list()

			clones = list()

			sense_boxes = list()
			hud_skillbar = list(new /:skillbar_one,new /:skillbar_two,new /:skillbar_three,new /:skillbar_four,new /:skillbar_five,new /:skillbar_six,new /:skillbar_seven,new /:skillbar_eight,new /:skillbar_nine,new /:skillbar_zero)
			hud_main = list( new /:button_build,new /:button_emote,new /:button_inv,new /:button_options,new /:button_skills,new /:button_stats,new /:button_tech, new /:toggle_skillbar_button)
			hud_sub = list(new /:button_map)
			milestone_hud = list(new /:button_body)
			admin_panel = list(new /:button_admin)
			reset_shared_runtime_lists()
			tk_minigame = list()
			mobs_map = list()
			blips_map = list()
			mobs_map_mini = list()
			blips_map_mini = list()
			remote_viewer = list()
			player_contacts = list()

			one = list()
			two = list()
			three = list()
			four = list()
			five = list()
			six = list()
			seven = list()
			eight = list()
			nine = list()
			zero = list()
			minus = list()
			equal = list()
			traits = list()

		update_looks(var/t)
			//Find out if we're changing a clones appearance, a players, or the settings of a cloning tank.
			var/mob/target = src
			var/obj/items/tech/Vat/clone_tank = null
			if(target.tech_using)
				if(istype(target.tech_using,/obj/items/tech/Vat))
					clone_tank = target.tech_using
					target = null
					//if(v.in_use) target = v.in_use //Don't want to be able to make changes to a clone thats already grown.

			//if(target && target.race == "Alien")
			///	target.set_icon(target)
			//	return
			if(target) target.filters = null
			//Select sex
			if(t == "gender")
				if(target && target.race != "Oni" && target.race != "Changeling" && target.race != "Spirit Doll")
					if(target.gen == "Male")
						target.gen = "Female"
						target.skin_pos = 1
						target.hair_pos = 1 // 1
						target.eye_pos = 1
						target.nose_pos = 1
						target.mouth_pos = 1
					else
						target.gen = "Male"
						target.skin_pos = 1
						target.hair_pos = 13 // 13
						target.eye_pos = 1
						target.nose_pos = 1
						target.mouth_pos = 1
			//Portrait nose/eyes/mouth selection
			if(t == "+ mouth")
				if(target)
					var/mouth_max = 4
					if(target.race != "Namekian" && target.gen == "Female")
						mouth_max = 5
					target.mouth_pos += 1
					if(target.mouth_pos > mouth_max) target.mouth_pos = 1
			if(t == "- mouth")
				if(target)
					var/mouth_max = 4
					if(target.race != "Namekian" && target.gen == "Female")
						mouth_max = 5
					target.mouth_pos -= 1
					if(target.mouth_pos <= 0) target.mouth_pos = mouth_max
			if(t == "+ nose")
				if(target)
					target.nose_pos += 1
					if(target.nose_pos >= 4) target.nose_pos = 1
			if(t == "- nose")
				if(target)
					target.nose_pos -= 1
					if(target.nose_pos <= 0) target.nose_pos = 2
			if(t == "skin color" || t == "eye color")
				if(target)
					var/is_female = (target.gen == "Female")
					var/eye_limit = is_female ? 4 : 3
					if(target.race == "Demon" && (target.skin_pos == 1 || target.skin_pos == 2))
						target.eye_pos = 1
					else if(target.eye_pos >= eye_limit)
						target.eye_pos = 1
			if(t == "+ eyes")
				if(target)
					var/is_female = (target.gen == "Female")
					var/eye_limit = is_female ? 4 : 3
					target.eye_pos += 1
					if(target.race == "Demon" && (target.skin_pos == 1 || target.skin_pos == 2))
						target.eye_pos = 1
					else if(target.eye_pos >= eye_limit)
						target.eye_pos = 1
			if(t == "- eyes")
				if(target)
					var/is_female = (target.gen == "Female")
					target.eye_pos -= 1
					if(target.race == "Demon" && (target.skin_pos == 1 || target.skin_pos == 2))
						target.eye_pos = 1
					else if(target.eye_pos <= 0)
						target.eye_pos = is_female ? 3 : 2
			//Body type selection
			var/max_body = 3
			if(t == "+ body")
				target.body_pos += 1
				if(target.body_pos == max_body) target.body_pos = 1
				usr.bodysize("+")
			if(t == "- body")
				target.body_pos -= 1
				if(target.body_pos == 0) target.body_pos = max_body-1
				usr.bodysize("-")
			//Skin colour selection
			var/max_skin = 4
			if(target)
				switch(target.race)
					if("Demon", "Changeling")
						max_skin = 6
					if("Namekian", "Makyo")
						max_skin = 5
					if("Spirit Doll", "Oni")
						max_skin = 3
					if("Alien")
						max_skin = 9
			if(t == "+ skin" || t == "- skin")
				var/skin_delta = (t == "+ skin") ? 1 : -1
				if(clone_tank)
					clone_tank.vat_skin += skin_delta
					if(clone_tank.vat_skin == max_skin) clone_tank.vat_skin = 1
					else if(clone_tank.vat_skin == 0) clone_tank.vat_skin = max_skin-1

				if(target)
					target.skin_pos += skin_delta
					if(target.skin_pos == max_skin) target.skin_pos = 1
					else if(target.skin_pos == 0) target.skin_pos = max_skin-1
			if(t == "hair color")
				//Handle normal hair/ear selection
				if(target)
					//if(target.race == "Oni")
					//	target.ear_pos += 1
					//	if(target.ear_pos >= 4) target.ear_pos = 1;
					//else
					if(target.has_hair >= 1)
						if(target.hair_pos == 16 && target.gen == "Male" && target.age <13) target.hair_pos = 1
						else if(target.hair_pos == 17 && target.gen == "Male" && target.age >=13) target.hair_pos = 1
						if(target.hair_pos == 6 && target.gen == "Female" ) target.hair_pos = 1

			//Hair and Imp ear selection
			if(t == "+")
				//Handle normal hair/ear selection
				if(target)
					//if(target.race == "Oni")
					//	target.ear_pos += 1
					//	if(target.ear_pos >= 4) target.ear_pos = 1;
					//else
					if(target.has_hair >= 1)
						target.hair_pos += 1
						if(target.hair_pos == 16 && target.gen == "Male" && target.age<13) target.hair_pos = 1
						else if(target.hair_pos == 17 && target.gen == "Male" && target.age >=13) target.hair_pos = 1
						if(target.hair_pos == 6 && target.gen == "Female") target.hair_pos = 1
			if(t == "-")
				//Handle normal hair/ear selection
				if(target)
					//if(target.race == "Oni")
					//	target.ear_pos -= 1
					//	if(target.ear_pos <= 0) target.ear_pos = 3;
					if(target.has_hair >= 1)
						target.hair_pos -= 1
						if(target.hair_pos == 0)
							if(target.gen == "Male" && target.age <13) target.hair_pos = 15
							else if(target.gen == "Male" && target.age>=13) target.hair_pos = 16
							if(target.gen == "Female") target.hair_pos = 5

			if(target)
				var/nose_count = length(nose_portrait_female)
				if(nose_count && (target.nose_pos < 1 || target.nose_pos > nose_count))
					target.nose_pos = 1
				var/mouth_count = length(mouth_portrait_female)
				if(mouth_count && (target.mouth_pos < 1 || target.mouth_pos > mouth_count))
					target.mouth_pos = 1

			//Reset hair for some races, since they don't have any.
			var/obj/h = null
			if(target)
				/*if(target.race == "Saiyan" && target.skin_pos == 2)
					h = null
					if(target.hair)
						target.overlays -= target.hair
						target.hair = null
						target.hair_icon = null*/
				var/use_male_hair = (target.race == "Oni" || target.race == "Namekian" || target.gen == "Male")
				if(age >= 13)
					h = use_male_hair ? hairs_male[target.hair_pos] : hairs_female[target.hair_pos]
				else if(age < 13)
					h = use_male_hair ? kid_hairs_male[target.hair_pos] : kid_hairs_female[target.hair_pos]


			var/icon/i_race
		//	var/icon/i_age_race1
		//	var/icon/i_age_race2
			var/icon/i_horn
			var/obj/horn = new
			var/is_adult_age = (age>=13||age==null||age==1||age==21)
			var/is_kid_age = (age<13 && age>3.9)
			var/is_newborn_age = (age<=0||age==0.1)
			var/is_under4_age = (age<4||age==0.1)
			if(target)
				//Celestial icon creation

				if(target.race == "Spirit Doll")
					target.has_hair = 1
					if(target.skin_pos == 1)
						if(is_adult_age)
							i_race = 'spiritdoll.dmi'
						else if(is_kid_age)
							i_race= 'spiritdoll_kid.dmi'
							i_age_race2 = 'spiritdoll.dmi'
						else if(is_newborn_age)
							i_race ='human_babymale.dmi'
							i_age_race1 = 'spiritdoll_kid.dmi'
							i_age_race2 = 'spiritdoll.dmi'


					if(target.skin_pos == 2)
						if(age>=13||age==null||age==1)
							i_race = 'spiritdoll_tan.dmi'
						else if(is_kid_age)
							i_race= 'spiritdoll_kidtan.dmi'
							i_age_race2 = 'spiritdoll_tan.dmi'
						else if(is_newborn_age)
							i_race ='human_babymale.dmi'
							i_age_race1 = 'spiritdoll_kidtan.dmi'
							i_age_race2 = 'spiritdoll_tan.dmi'




				if(target.race == "Changeling")
					target.has_hair=0
					var/frieza_variants = alist(
						1 = list("adult" = "Frieza_1st_form.dmi", "kid" = "Frieza_1st_form_kid.dmi", "prefix" = "Frieza"),
						2 = list("adult" = "1stFriezaBlue.dmi", "kid" = "1stFriezaKid_Blue.dmi", "prefix" = "FriezaBlue"),
						3 = list("adult" = "1stFriezaGreen.dmi", "kid" = "1stFriezaKid_Green.dmi", "prefix" = "FriezaGreen"),
						4 = list("adult" = "1stFriezaOrange.dmi", "kid" = "1stFriezaKid_Orange.dmi", "prefix" = "FriezaOrange"),
						5 = list("adult" = "1stFriezaRed.dmi", "kid" = "1stFriezaKid_Red.dmi", "prefix" = "FriezaRed")
					)
					if(frieza_variants[target.skin_pos])
						var/variant = frieza_variants[target.skin_pos]
						if(is_adult_age)
							i_race = variant["adult"]
						else if(is_kid_age)
							i_race = variant["kid"]
							i_age_race2 = variant["adult"]
						else if(is_newborn_age)
							i_race = 'alien_egg.dmi'
							i_age_race1 = variant["kid"]
							i_age_race2 = variant["adult"]

					target.changeling_base_icon = target.get_changeling_base_icon()
					target.changeling_form2_icon = target.get_changeling_form_icon(1)
					target.changeling_form3_icon = target.get_changeling_form_icon(2)
					target.changeling_form4_icon = target.get_changeling_form_icon(3)





				if(target.race == "Makyo")
					target.has_hair = 1
					if(target.skin_pos == 1)
						if(is_adult_age)
							i_race = 'makyo.dmi'
						else if(is_kid_age)
							i_race= 'makyo_kid.dmi'
							i_age_race2 = 'makyo.dmi'
						else if(is_newborn_age)
							i_race = 'alien_egg.dmi'
							i_age_race1 = 'makyo_kid.dmi'
							i_age_race2 = 'makyo.dmi'

					if(target.skin_pos == 2)
						if(is_adult_age)
							i_race = 'makyo_red.dmi'
						else if(is_kid_age)
							i_race= 'makyo_kidred.dmi'
							i_age_race2 = 'makyo_red.dmi'
						else if(is_newborn_age)
							i_race = 'alien_egg.dmi'
							i_age_race1 = 'makyo_kidred.dmi'
							i_age_race2 = 'makyo_red.dmi'

					if(target.skin_pos == 3)
						if(is_adult_age)
							i_race = 'makyo_tan.dmi'
						else if(is_kid_age)
							i_race= 'makyo_kidtan.dmi'
							i_age_race2= 'makyo_tan.dmi'
						else if(is_newborn_age)
							i_race = 'alien_egg.dmi'
							i_age_race1 ='makyo_kidtan.dmi'
							i_age_race2 = 'makyo_tan.dmi'

					if(target.skin_pos == 4)
						if(is_adult_age)
							i_race = 'makyo_purple.dmi'
						else if(is_kid_age)
							i_race= 'makyo_kidpurple.dmi'
							i_age_race2 = 'makyo_purple.dmi'
						else if(is_under4_age)
							i_race = 'alien_egg.dmi'
							i_age_race1 = 'makyo_kidpurple.dmi'
							i_age_race2 = 'makyo_purple.dmi'





				if(target.race == "Kai")
					target.has_hair = 1
					if(target.gen == "Male")
						if(is_adult_age)
							i_race = 'humanoid_no_colour2.dmi'
						else if(is_kid_age)
							i_race= 'humanoid_no_colour2_kid.dmi'
							i_age_race2 = 'humanoid_no_colour2.dmi'
						else if(is_newborn_age)
							i_race = 'alien_egg.dmi'
							i_age_race1 = 'humanoid_no_colour2.dmi'
							i_age_race2 = 'humanoid_no_colour2.dmi'

					if(target.gen == "Female")
						if(is_adult_age)
							i_race = 'humanoid_no_colour_female2.dmi'
						else if(is_kid_age)
							i_race= 'humanoid_no_colour_female2_kid.dmi'
							i_age_race2 = 'humanoid_no_colour_female2.dmi'
						else if(is_under4_age)
							i_race = 'alien_egg.dmi'
							i_age_race1 = 'humanoid_no_colour_female2_kid.dmi'
							i_age_race2 = 'humanoid_no_colour_female2.dmi'



				if(target.race == "Alien")
					target.has_hair = 1
					if(target.skin_pos == 1)
						if(is_adult_age)
							i_race = 'Alien_Captin_Ginyu_Naked.dmi'
						else if(is_kid_age)
							i_race= 'alien_captginyu_kid.dmi'
							i_age_race2 = 'Alien_Captin_Ginyu_Naked.dmi'
						else if(is_under4_age)
							i_race = 'alien_egg.dmi'
							i_age_race1 = 'alien_captginyu_kid.dmi'
							i_age_race2 = 'Alien_Captin_Ginyu_Naked.dmi'

					if(target.skin_pos == 2)
						if(is_adult_age)
							i_race =  'Alien_Immecka_Naked.dmi'
						else if(is_kid_age)
							i_race = 'alien_immecka_kid.dmi'
							i_age_race2 = 'Alien_Immecka_Naked.dmi'
						else if(is_under4_age)
							i_race = 'alien_egg.dmi'
							i_age_race1 = 'alien_immecka_kid.dmi'
							i_age_race2 = 'Alien_Immecka_Naked.dmi'


					if(target.skin_pos == 3)
						if(is_adult_age)
							i_race = 'Alien_Kanassa_Naked.dmi'
						else if(is_kid_age)
							i_race = 'alien_kanassa_kid.dmi'
							i_age_race2 = 'Alien_Kanassa_Naked.dmi'
						else if(is_under4_age)
							i_race = 'alien_egg.dmi'
							i_age_race1 = 'alien_kanassa_kid.dmi'
							i_age_race2 = 'Alien_Kanassa_Naked.dmi'



					if(target.skin_pos == 4)
						if(is_adult_age)
							i_race ='Alien_Kui_Naked.dmi'
						else if(is_kid_age)
							i_race = 'alien_kui_kid.dmi'
							i_age_race2 = 'Alien_Kui_Naked.dmi'
						else if(is_under4_age)
							i_race = 'alien_egg.dmi'
							i_age_race1 = 'alien_kui_kid.dmi'
							i_age_race2 = 'Alien_Kui_Naked.dmi'

					if(target.skin_pos == 5)
						if(is_adult_age)
							i_race ='Alien_Yardrat_Naked.dmi'
						else if(is_kid_age)
							i_race = 'alien_yardrat_kid.dmi'
							i_age_race2 = 'Alien_Yardrat_Naked.dmi'
						else if(is_newborn_age)
							i_race = 'alien_egg.dmi'
							i_age_race1 = 'alien_yardrat_kid.dmi'
							i_age_race2 = 'Alien_Yardrat_Naked.dmi'

					if(target.skin_pos == 6)
						if(is_adult_age)
							i_race = 'NewMalesWhite.dmi'
						else if(is_kid_age)
							i_race = 'human_male_white_kid.dmi'
							i_age_race2 = 'NewMalesWhite.dmi'
						else if(is_under4_age)
							i_race = 'human_babymale.dmi'
							i_age_race1= 'human_male_white_kid.dmi'
							i_age_race2= 'NewMalesWhite.dmi'


					if(target.skin_pos == 7)
						if(is_adult_age)
							i_race = 'NewMalesTan.dmi'
						else if(is_kid_age)
							i_race = 'human_male_tan_kid.dmi'
							i_age_race2 = 'NewMalesTan.dmi'
						else if(is_under4_age)
							i_race = 'human_babymale_tan.dmi'
							i_age_race1 = 'human_male_tan_kid.dmi'
							i_age_race2 = 'NewMalesTan.dmi'


					if(target.skin_pos == 8)
						if(is_adult_age)
							i_race = 'NewMalesBlack.dmi'
						else if(is_kid_age)
							i_race = 'human_male_black_kid.dmi'
							i_age_race2 = 'NewMalesBlack.dmi'
						else if(is_under4_age)
							i_race = 'human_babymale_black.dmi'
							i_age_race1 = 'human_male_black_kid.dmi'
							i_age_race2 = 'NewMalesBlack.dmi'

				if(target.race == "Demon")
					target.has_hair =1
					target.horn_pos = 1
					if(is_adult_age)
						if(prob(50))
							i_horn = new /obj/overlay/horns/demon
							target.horn_pos = 1
						else
							i_horn = new /obj/overlay/horns/demon/demon_2
							target.horn_pos = 2
					else if(is_kid_age)
						i_horn = new /obj/overlay/horns/demon/kid_horn
						target.horn_pos = 2

					if(target.gen == "Male")
						if(target.skin_pos == 1)
							if(is_adult_age)
								i_race = 'demon_default_male.dmi'
							//	target.overlays += target.body_horns
							else if(is_kid_age)
								i_race = 'Humanoid_Kid_Colorable.dmi'
								i_age_race2= 'demon_default_male.dmi'
							else if(is_under4_age)
								i_race = 'alien_egg.dmi'
								i_age_race1 ='Humanoid_Kid_Colorable.dmi'
								i_age_race2 = 'demon_default_male.dmi'

						if(target.skin_pos == 2)
							if(is_adult_age)
								i_race = 'demon_male.dmi' // change to colorable skin
								//target.overlays += target.body_horns
							else if(is_kid_age)
								i_race = 'Humanoid_Kid_Colorable.dmi'
								i_age_race2 = 'demon_male.dmi'
							else if(is_under4_age)
								i_race = 'alien_egg.dmi'
								i_age_race1 = 'Humanoid_Kid_Colorable.dmi'
								i_age_race2 = 'demon_male.dmi'


						if(target.skin_pos == 3)
							if(is_adult_age)
								i_race = 'NewMalesWhite.dmi'
							//	target.overlays += target.body_horns
							else if(is_kid_age)
								i_race = 'human_male_white_kid.dmi'
								i_age_race2 = 'NewMalesWhite.dmi'
							else if(is_under4_age)
								i_race = 'human_babymale.dmi'
								i_age_race1 = 'human_male_white_kid.dmi'
								i_age_race2 = 'NewMalesWhite.dmi'

						if(target.skin_pos == 4)
							if(is_adult_age)
								i_race = 'NewMalesTan.dmi'
							//	target.overlays += target.body_horns
							else if(is_kid_age)
								i_race = 'human_male_tan_kid.dmi'
								i_age_race2 = 'NewMalesTan.dmi'
							else if(is_under4_age)
								i_race = 'human_babymale_tan.dmi'
								i_age_race1 ='human_male_tan_kid.dmi'
								i_age_race2 = 'NewMalesTan.dmi'


						if(target.skin_pos == 5)
							if(is_adult_age)
								i_race = 'NewMalesBlack.dmi'
								//target.overlays += target.body_horns
							else if(is_kid_age)
								i_race = 'human_male_black_kid.dmi'
								i_age_race2 = 'NewMalesBlack.dmi'
							else if(is_under4_age)
								i_race = 'human_babymale_black.dmi'
								i_age_race1 = 'human_male_black_kid.dmi'
								i_age_race2 = 'NewMalesBlack.dmi'

					if(target.gen == "Female")
						target.has_hair = 1
						if(target.skin_pos == 1)
							if(is_adult_age)
								i_race = 'demon_default_female.dmi'
								//target.overlays += target.body_horns
							else if(is_kid_age)
								i_race = 'humanoid_no_colour_female2_kid.dmi'
								i_age_race2 = 'demon_default_female.dmi'
							else if(is_under4_age)
								i_race = 'human_babyfemale.dmi'
								i_age_race1 = 'humanoid_no_colour_female2_kid.dmi'
								i_age_race2 = 'demon_default_female.dmi'
								target.has_hair = 1

						if(target.skin_pos == 2)
							if(is_adult_age)
								i_race = 'demon_female.dmi' // Change to colorable skin
								//target.overlays += target.body_horns
							else if(is_kid_age)
								i_race = 'humanoid_no_colour_female2_kid.dmi'
								i_age_race2 = 'demon_female.dmi'
							else if(is_under4_age)
								i_race = 'human_babyfemale.dmi'
								i_age_race1 = 'humanoid_no_colour_female2_kid.dmi'
								i_age_race2 = 'demon_female.dmi'
								target.has_hair = 1

						if(target.skin_pos == 3)
							if(is_adult_age)
								i_race = 'FemaleBaseWhite.dmi'
							//	target.overlays += target.body_horns
							else if(is_kid_age)
								i_race = 'human_female_white_kid.dmi'
								i_age_race2 = 'FemaleBaseWhite.dmi'
							else if(is_newborn_age)
								i_race = 'human_babyfemale.dmi'
								i_age_race1 = 'human_female_white_kid.dmi'
								i_age_race2 = 'FemaleBaseWhite.dmi'



						if(target.skin_pos == 4)
							if(is_adult_age)
								i_race = 'FemaleBaseTan.dmi'
							//	target.overlays += target.body_horns
							else if(is_kid_age)
								i_race = 'human_female_tan_kid.dmi'
								i_age_race2 = 'FemaleBaseTan.dmi'
							else if(is_under4_age)
								i_race = 'human_babyfemale_tan.dmi'
								i_age_race1 = 'human_female_tan_kid.dmi'
								i_age_race2 = 'FemaleBaseTan.dmi'

						if(target.skin_pos == 5)
							if(is_adult_age)
								i_race = 'FemaleBaseBlack.dmi'
							//	target.overlays += target.body_horns
							else if(is_kid_age)
								i_race = 'human_female_black_kid.dmi'
								i_age_race2 = 'FemaleBaseBlack.dmi'
							else if(is_under4_age)
								i_race = 'human_babyfemale_black.dmi'
								i_age_race1 = 'human_female_black_kid.dmi'


				//Yukopian horns
				if(target.race == "Namekian")
					/*if(target.horn_pos == 1) i_horn = 'horns_yukopian_01.dmi'
					if(target.horn_pos == 2) i_horn = 'horns_yukopian_02.dmi'
					if(target.horn_pos == 3) i_horn = 'horns_yukopian_03.dmi'
					if(target.horn_pos == 4) i_horn = 'horns_yukopian_04.dmi' */
					if(target.skin_pos == 1)
						if(is_adult_age)
							i_race = 'NewNamekianAdult4.dmi'
						else if(is_kid_age)
							i_race = 'NewKidNamekian4.dmi'
							i_age_race2 = 'NewNamekianAdult4.dmi'
						else if(is_under4_age)
							i_race = 'namekian_egg.dmi'
							i_age_race1 = 'NewKidNamekian4.dmi'
							i_age_race2 = 'NewNamekianAdult4.dmi'

					if(target.skin_pos == 2)
						if(is_adult_age)
							i_race = 'NewNamekianAdult3.dmi'
						else if(is_kid_age)
							i_race = 'NewKidNamekian3.dmi'
							i_age_race2 = 'NewNamekianAdult3.dmi'
						else if(is_under4_age)
							i_race = 'namekian_egg.dmi'
							i_age_race1 = 'NewKidNamekian3.dmi'
							i_age_race2 = 'NewNamekianAdult3.dmi'


					if(target.skin_pos == 3)
						if(is_adult_age)
							i_race = 'NewNamekianAdult2.dmi'
						else if(is_kid_age)
							i_race = 'NewKidNamekian2.dmi'
							i_age_race2 = 'NewNamekianAdult2.dmi'
						else if(is_under4_age)
							i_race = 'namekian_egg.dmi'
							i_age_race1 = 'NewKidNamekian2.dmi'
							i_age_race2 = 'NewNamekianAdult2.dmi'

					if(target.skin_pos == 4)
						if(is_adult_age)
							i_race = 'NewNamekianAdult1.dmi'
						else if(is_kid_age)
							i_race = 'NewKidNamekian1.dmi'
							i_age_race2 = 'NewNamekianAdult1.dmi'
						else if(is_under4_age)
							i_race = 'namekian_egg.dmi'
							i_age_race1 = 'NewKidNamekian1.dmi'
							i_age_race2 = 'NewNamekianAdult1.dmi'

			//Android icon creation
				if(target.race == "Saiyan")
					target.has_hair = 1
					if(target.is_hybrid)
						i_horn = new /obj/overlay/tails/saiyan/colorable_tail
						color_overlay(i_horn, target.hair_c, blend_mode = BLEND_MULTIPLY)
					else
						i_horn = new /obj/overlay/tails/saiyan/brown_tail
					add_overlay(target, i_horn)

					if(target.gen == "Male")
						if(target.skin_pos == 1)
							if(is_adult_age)
								i_race = 'NewMalesWhite.dmi'
							else if(is_kid_age)
								i_race = 'human_male_white_kid.dmi'
								i_age_race2 = 'NewMalesWhite.dmi'
							else if(is_newborn_age)
								i_race = 'human_babymale.dmi'
								i_age_race1 = 'human_male_white_kid.dmi'
								i_age_race2 = 'NewMalesWhite.dmi'

						if(target.skin_pos == 2)
							if(is_adult_age)
								i_race = 'NewMalesTan.dmi'
							else if(is_kid_age)
								i_race = 'human_male_tan_kid.dmi'
								i_age_race2 = 'NewMalesTan.dmi'
							else if(is_newborn_age)
								i_race = 'human_babymale_tan.dmi'
								i_age_race1 = 'human_male_tan_kid.dmi'
								i_age_race2 = 'NewMalesTan.dmi'

						if(target.skin_pos == 3)
							if(is_adult_age)
								i_race = 'NewMalesBlack.dmi'
							else if(is_kid_age)
								i_race = 'human_male_black_kid.dmi'
								i_age_race2 = 'NewMalesBlack.dmi'
							else if(is_newborn_age)
								i_race = 'human_babymale_black.dmi'
								i_age_race1 = 'human_male_black_kid.dmi'
								i_age_race2 = 'NewMalesBlack.dmi'

					if(target.gen == "Female")
						if(target.skin_pos == 1)
							if(is_adult_age)
								i_race = 'FemaleBaseWhite.dmi'
							else if(is_kid_age)
								i_race = 'human_female_white_kid.dmi'
								i_age_race2 = 'FemaleBaseWhite.dmi'
							else if(is_newborn_age)
								i_race = 'human_babyfemale.dmi'
								i_age_race1 = 'human_female_white_kid.dmi'
								i_age_race2 = 'FemaleBaseWhite.dmi'

						if(target.skin_pos == 2)
							if(is_adult_age)
								i_race = 'FemaleBaseTan.dmi'
							else if(is_kid_age)
								i_race = 'human_female_tan_kid.dmi'
								i_age_race2 = 'FemaleBaseTan.dmi'
							else if(is_newborn_age)
								i_race = 'human_babyfemale_tan.dmi'
								i_age_race1 = 'human_female_tan_kid.dmi'
								i_age_race2 = 'FemaleBaseTan.dmi'

						if(target.skin_pos == 3)
							if(is_adult_age)
								i_race = 'FemaleBaseBlack.dmi'
							else if(is_kid_age)
								i_race = 'human_female_black_kid.dmi'
								i_age_race2 = 'FemaleBaseBlack.dmi'
							else if(is_newborn_age)
								i_race = 'human_babyfemale_black.dmi'
								i_age_race1 = 'human_female_black_kid.dmi'
								i_age_race2 = 'FemaleBaseBlack.dmi'

				if(target.race == "Half God")
					target.has_hair = 1
					if(target.gen == "Male")
						if(target.skin_pos == 1) i_race = 'NewMalesWhite.dmi'
						if(target.skin_pos == 2) i_race = 'NewMalesTan.dmi'
						if(target.skin_pos == 3) i_race = 'NewMalesBlack.dmi'
					if(target.gen == "Female")
						if(target.skin_pos == 1) i_race = 'FemaleBaseWhite.dmi'
						if(target.skin_pos == 2) i_race = 'FemaleBaseTan.dmi'
						if(target.skin_pos == 3) i_race = 'FemaleBaseBlack.dmi'
				if(target.race == "Tuffle")
					target.has_hair = 1
					if(target.gen == "Male")
						if(target.skin_pos == 1)
							if(is_adult_age)
								i_race = 'NewMalesWhite.dmi'
							else if(is_kid_age)
								i_race = 'human_male_white_kid.dmi'
								i_age_race2= 'NewMalesWhite.dmi'
							else if(is_newborn_age)
								i_race = 'human_babymale.dmi'
								i_age_race1 = 'human_male_white_kid.dmi'
								i_age_race2 = 'NewMalesWhite.dmi'

						if(target.skin_pos == 2)
							if(is_adult_age)
								i_race = 'NewMalesTan.dmi'
							else if(is_kid_age)
								i_race = 'human_male_tan_kid.dmi'
								i_age_race2 = 'NewMalesTan.dmi'
							else if(is_newborn_age)
								i_race = 'human_babymale_tan.dmi'
								i_age_race1 = 'human_male_tan_kid.dmi'
								i_age_race2 = 'NewMalesTan.dmi'

						if(target.skin_pos == 3)
							if(is_adult_age)
								i_race = 'NewMalesBlack.dmi'
							else if(is_kid_age)
								i_race = 'human_male_black_kid.dmi'
								i_age_race2 = 'NewMalesBlack.dmi'
							else if(is_newborn_age)
								i_race = 'human_babymale_black.dmi'
								i_age_race1 = 'human_male_black_kid.dmi'
								i_age_race2 = 'NewMalesBlack.dmi'


					if(target.gen == "Female")
						if(target.skin_pos == 1)
							if(is_adult_age)
								i_race = 'FemaleBaseWhite.dmi'
							else if(is_kid_age)
								i_race = 'human_female_white_kid.dmi'
								i_age_race2 = 'FemaleBaseWhite.dmi'
							else if(is_newborn_age)
								i_race = 'human_babyfemale.dmi'
								i_age_race1 = 'human_female_white_kid.dmi'
								i_age_race2 = 'FemaleBaseWhite.dmi'

						if(target.skin_pos == 2)
							if(is_adult_age)
								i_race = 'FemaleBaseTan.dmi'
							else if(is_kid_age)
								i_race = 'human_female_tan_kid.dmi'
								i_age_race2 = 'FemaleBaseTan.dmi'
							else if(is_newborn_age)
								i_race = 'human_babyfemale_tan.dmi'
								i_age_race1 = 'human_female_tan_kid.dmi'
								i_age_race2 = 'FemaleBaseTan.dmi'

						if(target.skin_pos == 3)
							if(is_adult_age)
								i_race = 'FemaleBaseBlack.dmi'
							else if(is_kid_age)
								i_race = 'human_female_black_kid.dmi'
								i_age_race2 = 'FemaleBaseBlack.dmi'
							else if(is_newborn_age)
								i_race = 'human_babyfemale_black.dmi'
								i_age_race1 = 'human_female_black_kid.dmi'
								i_age_race2 = 'FemaleBaseBlack.dmi'
				//Human icon creation

				if(target.race == "Human")
					target.has_hair = 1
					if(target.gen == "Male")
						if(target.skin_pos == 1)
							if(is_adult_age)
								i_race = 'NewMalesWhite.dmi'
							else if(is_kid_age)
								i_race = 'human_male_white_kid.dmi'
								i_age_race2 = 'NewMalesWhite.dmi'
							else if(is_newborn_age)
								i_race = 'human_babymale.dmi'
								i_age_race1 = 'human_male_white_kid.dmi'
								i_age_race2 = 'NewMalesWhite.dmi'
						if(target.skin_pos == 2)
							if(is_adult_age)
								i_race = 'NewMalesTan.dmi'
							else if(is_kid_age)
								i_race = 'human_male_tan_kid.dmi'
								i_age_race2 = 'NewMalesTan.dmi'
							else if(is_newborn_age)
								i_race = 'human_babymale_tan.dmi'
								i_age_race1 = 'human_male_tan_kid.dmi'
								i_age_race2 = 'NewMalesTan.dmi'

						if(target.skin_pos == 3)
							if(is_adult_age)
								i_race = 'NewMalesBlack.dmi'
							else if(is_kid_age)
								i_race = 'human_male_black_kid.dmi'
								i_age_race2 = 'NewMalesBlack.dmi'
							else if(is_newborn_age)
								i_race = 'human_babymale_black.dmi'
								i_age_race1 ='human_male_black_kid.dmi'
								i_age_race2 = 'NewMalesBlack.dmi'

					if(target.gen == "Female")
						if(target.skin_pos == 1)
							if(is_adult_age)
								i_race = 'FemaleBaseWhite.dmi'
							else if(is_kid_age)
								i_race = 'human_female_white_kid.dmi'
								i_age_race2 = 'FemaleBaseWhite.dmi'
							else if(is_newborn_age)
								i_race = 'human_babyfemale.dmi'
								i_age_race1 = 'human_female_white_kid.dmi'
								i_age_race2 = 'FemaleBaseWhite.dmi'

						if(target.skin_pos == 2)
							if(is_adult_age)
								i_race = 'FemaleBaseTan.dmi'
							else if(is_kid_age)
								i_race = 'human_female_tan_kid.dmi'
								i_age_race2 = 'FemaleBaseTan.dmi'
							else if(is_newborn_age)
								i_race = 'human_babyfemale_tan.dmi'
								i_age_race1 = 'human_female_tan_kid.dmi'
								i_age_race2 = 'FemaleBaseTan.dmi'


						if(target.skin_pos == 3)
							if(is_adult_age)
								i_race = 'FemaleBaseBlack.dmi'
							else if(is_kid_age)
								i_race = 'human_female_black_kid.dmi'
								i_age_race2 = 'FemaleBaseBlack.dmi'
							else if(is_newborn_age)
								i_race = 'human_babyfemale_black.dmi'
								i_age_race1 = 'human_female_black_kid.dmi'
								i_age_race2 = 'FemaleBaseBlack.dmi'
				//Imp icon creation
				if(target.race == "Oni")
					if(is_adult_age)

						i_horn = new /obj/overlay/horns/oni
					else if(age==4)
						i_horn = new /obj/overlay/horns/oni/kid_horn
					if(target.skin_pos == 1)
						if(is_adult_age)
							i_race = 'oni_male_light.dmi'
							//target.overlays += target.body_horns
						else if(is_kid_age)
							i_race= 'oni_male_light_kid.dmi'
							i_age_race2 = 'oni_male_light.dmi'
						else if(is_under4_age)
							i_race = 'alien_egg.dmi'
							i_age_race1 = 'oni_male_light_kid.dmi'
							i_age_race2 = 'oni_male_light.dmi'
						target.has_hair = 1

					if(target.skin_pos == 2)
						if(is_adult_age)
							i_race = 'oni_male_dark.dmi'
						//	target.overlays += target.body_horns
						else if(is_kid_age)
							i_race= 'oni_male_dark_kid.dmi'
							i_age_race2 = 'oni_male_dark.dmi'
						else if(is_under4_age)
							i_race = 'alien_egg.dmi'
							i_age_race1 = 'oni_male_dark_kid.dmi'
							i_age_race2 = 'oni_male_dark.dmi'
						target.has_hair = 1
					if(target.skin_pos == 3)
						if(is_adult_age)
							i_race = 'oni_male_light.dmi'
						//	target.overlays += target.body_horns
						else if(is_kid_age)
							i_race= 'oni_male_light_kid.dmi'
							i_age_race2 = 'oni_male_light.dmi'
						else if(is_under4_age)
							i_race = 'alien_egg.dmi'
							i_age_race1 = 'oni_male_light_kid.dmi'
							i_age_race2 = 'oni_male_light.dmi'
						target.has_hair = 1


			if(target)
				target.icon = i_race
				if(target.race == "Changeling")
					if(target.changeling_base_icon)
						target.icon = target.changeling_base_icon
					target.icon_state = ""

			//world << "Debug - i_race = [i_race]"
			var/icon/I = icon(i_race,"",SOUTH,1,0)
			I.Scale(128,128)

			//Do hair and hair color
			if(h)
				var/icon/E = icon(h.icon,"",SOUTH,1,0)
				var/icon/E_hair = icon(h.icon)
				E.Scale(128,128)

				if(target && target.hair_c)
					E.Blend(target.hair_c)
					E_hair.Blend(target.hair_c)
				if(clone_tank && clone_tank.vat_hair_c)
					E.Blend(clone_tank.vat_hair_c)
					E_hair.Blend(clone_tank.vat_hair_c)
				I.Blend(E,ICON_OVERLAY,1,13)

				if(target && target.has_hair >= 1)
					var/obj/new_hair = new h.type
					//var/obj/new_age_hair = new h2.type
					var/obj/old_hair = target.hair

					new_hair.icon = E_hair
				//	target.age_hair = new_age_hair
				//	target.age_hair_icon = new_age_hair.icon

					target.hair_icon = new_hair.icon

					// Remove only previous hair safely
					if(old_hair)
						remove_overlay(target, old_hair)

					target.hair = new_hair
					if(target.started == 0 )target.overlays = null
					add_overlay(target, new_hair)
					target.vis_contents += E_hair





				/*	target.hair_icon = new_hair.icon
					target.overlays = null
					target.overlays += target.hair
					target.vis_contents += E_hair*/
			if(target.skin_c && target.race != "Changeling")
				target.icon *= target.skin_c
			target.set_icon(target)

			//Do eye color next
			if(target.eyes)
				remove_overlay(target, target.eyes)
			target.eyes = null
			if(target.eyes_white)
				remove_overlay(target, target.eyes_white)
			target.eyes_white = null
			var/obj/overlay/sclera/i_white = new /obj/overlay/sclera
			var/obj/overlay/eyes_iris/i_iris = new /obj/overlay/eyes_iris
			if(target.age<13 && target.age >3.9)
				i_white = new /obj/overlay/sclera/kid
				i_iris = new /obj/overlay/eyes_iris/kid
			/*if(target.race == "Android" && target.skin_pos == 1)
				i_white = 'humanoid_eyes_iris_android.dmi'
				i_iris = 'humanoid_eyes_iris_android.dmi'*/
			var/icon/P_white
			if(i_white && i_white.icon)
				P_white = icon(i_white.icon,"",SOUTH,1,0)
			var/icon/P_eyecolor
			if(i_iris && i_iris.icon)
				P_eyecolor = icon(i_iris.icon,"",SOUTH,1,0)
			if(target.has_eyes)
				var/proceed_eyes = 1
				if(target.race == "Android")
					if(target.skin_pos == 2)
						proceed_eyes = 0

				if(proceed_eyes)
					var/is_adult_eyes = (target.age >= 13)
					var/final_eye_c = target.eye_c
					if(target.race == "Saiyan" || (target.saiyan_dna && !target.is_hybrid))
						final_eye_c = rgb(0,0,0)
					if(!final_eye_c)
						final_eye_c = rgb(0,0,155)
					target.eye_c = final_eye_c
					//P_eyecolor = final_eye_c
					if(P_white)
						P_white.Scale(128,128)
						I.Blend(P_white,ICON_OVERLAY)

					if(P_eyecolor)
						P_eyecolor.Scale(128,128)
						P_eyecolor.Blend(final_eye_c, ICON_MULTIPLY)
						I.Blend(P_eyecolor,ICON_OVERLAY)
					target.saved_eye_c = final_eye_c

					var/obj/eye_white = new
					eye_white.icon = i_white.icon
					eye_white.layer = i_white.layer
					eye_white.vis_flags = i_white.vis_flags
					target.eyes_white = eye_white
					//add_overlay(target, target.eyes_white)
					var/obj/eye_iris = new
					eye_iris.icon = i_iris.icon
					var/icon/eye
					if(eye_iris.icon)
						eye = new(eye_iris.icon)
						//eye.Blend(target.eye_c)
					if(eye)
						eye.Blend(final_eye_c, ICON_MULTIPLY)
						eye_iris.icon = eye
					eye_iris.layer = i_iris.layer
					eye_iris.vis_flags = i_iris.vis_flags
					target.eyes = eye_iris
					if(is_adult_eyes)
						target.eyes.pixel_x = 0
						target.eyes_white.pixel_y = 0
					//target.vis_contents += target.eyes_white
					//target.vis_contents += target.eyes
					add_overlays(target, list(target.eyes_white, target.eyes))
					//add_overlay(target, target.eyes)
					//target.overlays += target.eyes

					//target.overlays += P_eyecolor

				/*
				if(target.race == "Android")
					if(target.skin_pos == 1 || target.skin_pos == 2)
						target.vis_contents -= target.eyes
						target.eyes = null
						target.vis_contents -= target.eyes_white
						target.eyes_white = null
				*/
			if(target.race == "Demon")
				if(is_adult_age || target.age == null || target.age == 1)
					add_overlay(target, i_horn)
				else if(is_under4_age)
					add_overlay(target, i_horn)

			//Now set the actual in game portrait
			if(i_horn)
				var/icon/race = icon(i_race,"",SOUTH,1,0)
				var/icon/horns = icon(i_horn,"Meditate",SOUTH,1,0)
				var/obj/hrn_chosen
				if(target.race == "Saiyan") hrn_chosen = saiyan_tails[target.horn_pos]
				if(target.race == "Oni") hrn_chosen = horns_oni[target.horn_pos]
				if(target.race == "Demon") hrn_chosen = body_horns[target.horn_pos]
				var/icon/hrn = icon(hrn_chosen.icon)
				horn.icon = hrn
				//horn.pixel_x = -8
				horn.layer = hrn_chosen.layer
			//	horn.plane=35
				race.Shift(EAST,8)
				horns.Blend(race,ICON_OVERLAY)
				P_white.Scale(88,88)
				P_eyecolor.Scale(88,88)
				P_white.Shift(EAST,20)
				P_eyecolor.Shift(EAST,20)
				P_white.Shift(SOUTH,2)
				P_eyecolor.Shift(SOUTH,2)
				horns.Scale(128,128)
				horns.Blend(P_white,ICON_OVERLAY)
				horns.Blend(P_eyecolor,ICON_OVERLAY)
				target.save_icon = horns
				//if(target.skin_c) target.icon *= target.skin_c

				target.horns = horn
				//target.overlays = null
				add_overlay(target, target.horns)
			//	target.vis_contents += target.horns
	proc
		ages(var/adjust as text)
			set name = ".ages"
			set hidden = 1
			if(src.started) return
			if(adjust == "+" || adjust == "-")
				switch(src.age_text)
					if("Teen")
						src.age_text = "Adult"
						src.age = 21
						src.age_soul = 21
						src.birth_year = year-21
					if("Adult")
						src.age_text = "Kid"
						src.age = 4
						src.age_soul = 4
						src.birth_year = year-4
					if("Kid")
						src.age_text = "Teen"
						src.age = 13
						src.age_soul = 13
						src.birth_year = year-13
			winset(src,"char_creation.label_age","text=\"[src.age_text]\"")

		apply_size_speed(var/mob/m)
			set hidden =1
			if(m.started) return
			if(m.bodysize== SMALL)
				//m.mod_agility += 0.5
				//m.mod_endurance -= rand(0.25,0.45)
				//m.mod_strength -= rand(0.25,0.45)
				//m.mod_resistance -= rand(0.1,0.35)

				if(m.race=="Human")
					m.mod_strength -= rand(1,1.15)
					m.mod_endurance -= rand(1,1.15)
					m.mod_offence += rand(0.15,0.45)
					m.mod_defence -= rand(1,1.1)
					m.mod_resistance -= rand(0.8,1.8)
					m.mod_force += rand(0.1,0.25)

				else if(m.race=="Saiyan")
					m.mod_endurance -= rand(0.25,0.6)
					m.mod_strength -= rand(0.3,0.6)
					//m.mod_resistance -= rand(0.1,0.35)
				//	m.mod_strength -= 0.25
				//	m.mod_endurance -= 0.25
				//	m.mod_offence += 0.25
				//	m.mod_defence -= 0.25
				//	m.mod_resistance -= 0.25
					m.mod_resistance -= rand(0.15,0.4)
					m.mod_force += rand(0.1,0.25)

				else if(m.race=="Namekian")
					m.mod_strength -= rand(0.15,0.35)
					m.mod_endurance -= rand(0.15,0.35)
				//	m.mod_offence += 0.25
				//	m.mod_defence -= 0.15
				//	m.mod_resistance -= 0.15
					m.mod_resistance -= rand(0.2,0.3)
					m.mod_force += rand(0.15,0.6)
				else if(m.race=="Changeling")
				//	m.mod_strength -= 0.15
				//	m.mod_endurance -= 0.15
				//	m.mod_offence += 0.15
				//	m.mod_defence -= 0.15
				//	m.mod_resistance -= 0.15

					m.mod_force += rand(0.1,0.25)

				else if(m.race=="Makyo")
					m.mod_endurance -= rand(0.25,0.5)
					m.mod_strength -= rand(0.3,0.6)
				//	m.mod_strength -= 0.1
				//	m.mod_endurance -= 0.5
				//	m.mod_offence += 0.25
				//	m.mod_defence -= 0.25
				//	m.mod_resistance -= 0.25
					m.mod_resistance -= rand(0.25,0.35)
					m.mod_force += rand(0.1,0.25)
				else if(m.race=="Spirit Doll")
					m.mod_endurance -= rand(0.15,0.35)
					m.mod_strength -= rand(0.1,0.25)
				//	m.mod_strength -= 0.10
				//	m.mod_endurance -= 0.10
					//m.mod_offence += 0.25
				//	m.mod_defence -= 0.25
				//	m.mod_resistance -= 0.1
					m.mod_resistance -= rand(0.2,0.25)
					m.mod_force += rand(0.15,0.4)

				else if(m.race=="Tuffle")

				//	m.mod_strength -= 0.5
				//	m.mod_endurance -= 0.5
				//	m.mod_offence += 0.20
				//	m.mod_defence -= 0.25
				//	m.mod_resistance -= 0.25
					m.mod_force += rand(0.1,0.25)
					m.mod_resistance -= rand(0.1,0.25)

				else if(m.race=="Kai")
					m.mod_endurance -= rand(0.25,0.5)
					m.mod_strength -= rand(0.2,0.4)
				//	m.mod_strength -= 0.25
				//	m.mod_endurance -= 0.25
					//m.mod_offence += 0.25
				//	m.mod_defence -= 0.25
				//	m.mod_resistance -= 0.15
					m.mod_force += rand(0.15,0.5)
					m.mod_resistance -= rand(0.25,0.35)

				else if(m.race=="Demon")
					m.mod_endurance -= rand(0.35,0.6)
					m.mod_strength -= rand(0.4,0.8)
				//	m.mod_strength -= 0.55
				//	m.mod_endurance -= 0.35
				//	m.mod_offence += 0.5
				//	m.mod_defence -= 0.25
				//	m.mod_resistance -= 0.25
					m.mod_force += rand(0.1,0.4)
					m.mod_resistance -= rand(0.25,0.35)

				else if(m.race=="Alien")
					if(m.class == "Metamorean")
					//	m.mod_strength -= 0.15
					//	m.mod_endurance -= 0.15
					//	m.mod_offence += 0.125
					//	m.mod_defence -= 0.1
					//	m.mod_resistance -= 0.1
						m.mod_force += rand(0.1,0.2)

					if(m.class == "Yardrat")
					//	m.mod_strength -= 0.15
					//	m.mod_endurance -= 0.15
					//	m.mod_offence += 0.125
					//	m.mod_defence -= 0.1
					//	m.mod_resistance -= 0.125
						m.mod_force += rand(0.1,0.2)

					if(m.class == "Energy")
					//	m.mod_strength -= 0.15
					//	m.mod_endurance -= 0.15
						m.mod_energy += rand(0.1,0.2)
					//	m.mod_offence += 0.125
					//	m.mod_defence -= 0.1
					//	m.mod_resistance -= 0.125
						m.mod_force += rand(0.1,0.15)

					if(m.class == "Physical")
						m.mod_endurance -= rand(0.1,0.35)
						m.mod_strength -= rand(0.2,0.4)
					//	m.mod_strength -= 0.1
					//	m.mod_endurance -= 0.1
					//	m.mod_offence += 0.125
					//	m.mod_defence -= 0.1
					//	m.mod_resistance -= 0.1
						m.mod_force += rand(0.1,0.18)

					if(m.class == "Speed")
						//m.mod_strength -= 0.1
						//m.mod_endurance -= 0.1
						m.mod_agility += rand(0.1,0.35)
					//	m.mod_offence += 0.3
					//	m.mod_defence -= 0.1
					//	m.mod_resistance -= 0.125
						m.mod_force += rand(0.1,0.18)
					if(m.class == "Technology")
					//	m.mod_strength -= 0.35
					//	m.mod_endurance -= 0.35
					//	m.mod_offence += 0.1
					//	m.mod_defence -= 0.3
					//	m.mod_resistance -= 0.35
						m.mod_force += rand(0.1,0.15)
					if(m.class == "Wizard" || m.class == "Witch")
					//	m.mod_strength -= 0.35
					//	m.mod_endurance -= 0.35
						m.mod_energy += rand(0.1,0.25)
					//	m.mod_offence += 0.1
					///	m.mod_defence -= 0.3
					//	m.mod_resistance -= 0.35
						m.mod_force += rand(0.1,0.15)

			if(m.bodysize == MEDIUM)
				m.mod_agility -= rand(0.25,0.45)
				if(m.mod_agility<=-0) m.mod_agility = 0.1

				switch(m.race)
					if("Alien")
						if(m.class == "Metamorean")
							m.mod_strength -= rand(0.15,0.2)
							m.mod_endurance -= rand(0.15,0.2)
							m.mod_offence += rand(0.1,0.125)
							m.mod_defence += rand(0.1,0.125)
							m.mod_resistance -= rand(0.1,0.2)
							m.mod_force -= rand(0.1,0.2)

						if(m.class == "Yardrat")
							m.mod_strength -= rand(0.15,0.2)
							m.mod_endurance -= rand(0.15,0.2)
							m.mod_offence += rand(0.1,0.125)
							m.mod_defence += rand(0.1,0.125)
							m.mod_resistance -= 0.125
							m.mod_force -= rand(0.1,0.2)

						if(m.class == "Energy")
							m.mod_strength -= rand(0.15,0.2)
							m.mod_endurance -= rand(0.15,0.2)
							m.mod_energy += rand(0.1,0.2)
							m.mod_offence += rand(0.1,0.125)
							m.mod_defence += rand(0.1,0.125)
							m.mod_resistance -= 0.125
							m.mod_force -= rand(0.1,0.15)

						if(m.class == "Physical")
							m.mod_endurance -= rand(0.1,0.25)
							m.mod_strength -= rand(0.2,0.3)
							m.mod_offence += rand(0.1,0.125)
							m.mod_defence += rand(0.1,0.125)
						//	m.mod_resistance -= 0.1
							m.mod_force -= rand(0.1,0.18)

						if(m.class == "Speed")
							m.mod_strength -= rand(0.1,0.15)
							m.mod_endurance -= rand(0.1,0.15)
							m.mod_agility += rand(0.15,0.3)
							m.mod_offence += rand(0.15,0.2)
							m.mod_defence += rand(0.1,0.2)
							m.mod_resistance -= 0.125
							m.mod_force -= rand(0.1,0.18)

					if("Demon")
						m.mod_endurance -= rand(0.3,0.4)
						m.mod_strength -= rand(0.25,0.5)
						m.mod_offence += rand(0.25,0.35)
						m.mod_defence += rand(0.25,0.35)
						m.mod_force -= rand(0.1,0.4)
						m.mod_resistance -= rand(0.15,0.35)
					if("Kai")
						m.mod_endurance -= rand(0.15,0.25)
						m.mod_strength -= rand(0.15,0.25)
						m.mod_offence += rand(0.15,0.3)
						m.mod_defence += rand(0.15,0.3)
						m.mod_force -= rand(0.15,0.35)
						m.mod_resistance -= rand(0.15,0.25)
					if("Spirit Doll")
						m.mod_endurance -= rand(0.1,0.2)
						m.mod_strength -= rand(0.1,0.2)
						m.mod_offence += rand(0.15,0.25)
						m.mod_defence += rand(0.15,0.25)
						m.mod_resistance -= rand(0.15,0.25)
						m.mod_force -= rand(0.15,0.25)
					if("Makyo")
						m.mod_endurance -= rand(0.25,0.35)
						m.mod_strength -= rand(0.25,0.35)
						m.mod_offence += rand(0.15,0.35)
						m.mod_defence += rand(0.15,0.35)
						m.mod_resistance -= rand(0.15,0.35)
						m.mod_force -= rand(0.1,0.25)
					if("Namekian")
						m.mod_strength -= rand(0.15,0.25)
						m.mod_endurance -= rand(0.15,0.25)
						m.mod_offence += rand(0.15,0.25)
						m.mod_defence += rand(0.15,0.25)
						m.mod_resistance -= rand(0.15,0.25)
						m.mod_force -= rand(0.15,0.35)
					if("Saiyan")
						m.mod_endurance -= rand(0.15,0.25)
						m.mod_strength -= rand(0.15,0.25)
						m.mod_resistance -= rand(0.2,0.3)
						m.mod_offence += rand(0.1,0.25)
						m.mod_defence += rand(0.1,0.25)
						m.mod_force -= rand(0.12,0.15)
					if("Human")
						m.mod_strength -= rand(0.5,1)
						m.mod_endurance -= rand(0.5,1)
						m.mod_offence += rand(0.15,0.25)
						m.mod_defence += rand(0.15,0.25)
						m.mod_resistance -= rand(0.4,0.8)
						m.mod_force -= rand(0.1,0.25)
					if("Changeling")
						m.mod_strength -= rand(0.1,0.15)
						m.mod_endurance -= rand(0.1,0.15)
						m.mod_energy -= rand(0.05,0.1)
					//	m.mod_offence -= 0.05
					//	m.mod_defence -= 0.1
						m.mod_resistance -= rand(0.1,0.15)
						m.mod_force -= rand(0.05,0.1)
			if(m.bodysize== LARGE)
			//m.mod_agility -= rand(0.25,0.5)
				//m.mod_endurance += rand(0.1,0.25)
				//m.mod_strength += rand(0.1,0.25)
				if(m.mod_agility<=-0) m.mod_agility = 0.1
				switch(m.race)
					if("Human")
						m.mod_strength += rand(0.15,0.45)
						m.mod_endurance += rand(0.15,0.45)
						m.mod_offence -= rand(0.8,1.5)
						m.mod_agility -= rand(0.35,0.8)
						m.mod_defence +=  rand(0.15,0.45)
						m.mod_resistance += rand(0.35,0.6)
						m.mod_force -= rand(1,1.25)
					if("Saiyan")
						m.mod_endurance += rand(0.15,0.35)
						m.mod_strength += rand(0.15,0.35)
						m.mod_agility -= rand(0.15,0.5)
					//	m.mod_strength += 0.5
					//	m.mod_endurance += 0.4
					//	m.mod_offence -= 0.4
					//	m.mod_defence += 0.5
						m.mod_resistance += rand(0.15,0.35)
						m.mod_force -= rand(0.1,0.25)
					if("Namekian")
						m.mod_endurance += rand(0.1,0.25)
						m.mod_strength += rand(0.1,0.25)
						m.mod_agility -= rand(0.25,0.5)
					//	m.mod_strength += 0.4
					//	m.mod_endurance += 0.3
					//	m.mod_offence -= 0.3
					//	m.mod_defence += 0.4
						m.mod_resistance += rand(0.2,0.4)
						m.mod_force -= rand(0.1,0.2)
					if("Changeling")
						m.mod_endurance += rand(0.1,0.25)
						m.mod_strength += rand(0.1,0.25)
						m.mod_agility -= rand(0.1,0.15)
					//	m.mod_strength += 0.15
					//	m.mod_endurance += 0.1
					//	m.mod_offence -= 0.15
					//	m.mod_defence += 0.054
						m.mod_resistance += rand(0.1,0.15)
						m.mod_force -= rand(0.08,0.25)
					if("Makyo")
						m.mod_endurance += rand(0.25,0.5)
						m.mod_strength += rand(0.1,0.2)
						m.mod_agility -= rand(0.25,0.45)
					//	m.mod_strength += 0.15
					//	m.mod_endurance += 0.15
					///	m.mod_offence -= 0.35
					//	m.mod_defence += 0.25
						m.mod_resistance += rand(0.1,0.25)
						m.mod_force -= rand(0.15,0.25)
					if("Spirit Doll")
						m.mod_endurance += rand(0.1,0.25)
						m.mod_strength += rand(0.1,0.25)
						m.mod_agility -= rand(0.25,0.45)
					//	m.mod_strength += 0.15
					//	m.mod_endurance += 0.15
					//	m.mod_offence -= 0.1
					//	m.mod_defence += 0.35
						m.mod_resistance += rand(0.2,0.4)
						m.mod_force -= rand(0.1,0.25)

					if("Tuffle")
						m.mod_endurance += rand(0.1,0.25)
						m.mod_strength += rand(0.1,0.25)
						m.mod_agility -= rand(0.25,0.45)
					//	m.mod_strength += 0.1
					//	m.mod_endurance += 0.1
					//	m.mod_offence -= 0.25
					//	m.mod_defence += 0.15
						m.mod_resistance += rand(0.1,0.15)
						m.mod_force -= rand(0.1,0.25)

					if("Kai")
						m.mod_endurance += rand(0.1,0.25)
						m.mod_strength += rand(0.1,0.25)
						m.mod_agility -= rand(0.25,0.45)
					//	m.mod_strength += 0.35
					//	m.mod_endurance += 0.25
					//	m.mod_offence -= 0.125
					//	m.mod_defence += 0.25
						m.mod_resistance += rand(0.3,0.5)
						m.mod_force -= rand(0.1,0.25)

					if("Demon")
						m.mod_endurance += rand(0.1,0.25)
						m.mod_strength += rand(0.3,0.5)
						m.mod_agility -= rand(0.25,0.45)
					//	m.mod_strength += 0.25
					//	m.mod_endurance += 0.25
					//	m.mod_offence -= 0.25
					//	m.mod_defence += 0.5
						m.mod_resistance += rand(0.1,0.2)
						m.mod_force -= rand(0.1,0.35)

					if("Alien")
						if(m.class == "Metamorean")
							m.mod_agility -= rand(0.25,0.45)
						//	m.mod_strength += 0.3
						//	m.mod_endurance += 0.25
					//		m.mod_offence -= 0.3
					//		m.mod_defence += 0.25
							m.mod_resistance += rand(0.1,0.15)
							m.mod_force -= rand(0.1,0.2)


						if(m.class == "Yardrat")
							m.mod_agility -= rand(0.25,0.45)
						//	m.mod_strength += 0.3
						//	m.mod_endurance += 0.25
					//		m.mod_offence -= 0.3
					//		m.mod_defence += 0.25
							m.mod_resistance += rand(0.1,0.15)
							m.mod_force -= rand(0.1,0.2)

						if(m.class == "Energy")
							m.mod_agility -= rand(0.25,0.45)
						//	m.mod_strength += 0.3
						//	m.mod_endurance += 0.25
							m.mod_energy += rand(0.1,0.3)
					//		m.mod_offence -= 0.3
					//		m.mod_defence += 0.2
							m.mod_resistance += rand(0.1,0.125)
							m.mod_force -= rand(0.1,0.25)

						if(m.class == "Physical")
							m.mod_agility -= rand(0.25,0.45)
						//	m.mod_strength += 0.35
						//	m.mod_endurance += 0.3
					//		m.mod_offence -= 0.3
						//	m.mod_defence += 0.12
							m.mod_resistance += rand(0.1,0.15)
							m.mod_force -= rand(0.1,0.2)

						if(m.class == "Speed")
							m.mod_agility -= rand(0.25,0.45)
						//	m.mod_strength += 0.25
						//	m.mod_endurance += 0.2
							m.mod_agility += rand(0.1,0.2)
						//	m.mod_offence -= 0.125
						//	m.mod_defence += 0.25
							m.mod_resistance += rand(0.1,0.15)
							m.mod_force -= rand(0.1,0.2)

						if(m.class == "Technology")
							m.mod_agility -= rand(0.25,0.45)
						//	m.mod_strength += 0.1
						//	m.mod_endurance += 0.1
							//m.mod_offence -= 0.25
						//	m.mod_defence += 0.25
							m.mod_resistance += rand(0.05,0.1)
							m.mod_force -= rand(0.1,0.25)

						if(m.class == "Wizard" || m.class == "Witch")
							m.mod_agility -= rand(0.25,0.45)
						//	m.mod_strength += 0.1
						//	m.mod_endurance += 0.1
							m.mod_energy += 0.3
							//m.mod_offence -= 0.25
						//	m.mod_defence += 0.25
							m.mod_resistance += rand(0.05,0.1)
							m.mod_force -= rand(0.1,0.25)
			if(m.mod_force < 0.01) m.mod_force = 0.1
			if(m.mod_resistance < 0.01) m.mod_resistance = 0.1
			if(m.mod_defence < 0.01) m.mod_defence = 0.1
			if(m.mod_offence < 0.01) m.mod_offence = 0.1
			if(m.mod_strength < 0.01) m.mod_strength = 0.1
			if(m.mod_endurance < 0.01) m.mod_endurance = 0.1
			if(m.mod_energy < 0.01) m.mod_energy = 0.1
			if(m.mod_regeneration < 0.01) m.mod_regeneration = 0.5
			if(m.mod_recovery < 0.01) m.mod_recovery = 0.5
			if(m.mod_agility < 0.01) m.mod_agility = 0.1


		bodysize(var/adjust as text, var/size_scale as num)
			set name = ".bodysize"
			set hidden = 1
			if(src.started) return
			if(adjust == "+")
				src.bodysize = (src.bodysize % 3) + 1
			if(adjust == "-")
				src.bodysize = ((src.bodysize + 1) % 3) + 1

			//var/size_scale = 1

			switch(src.bodysize)
				if(3)
					size_scale = 1.08
					winset(src,"char_creation.stat_info","text=\"[text_bodysize_large]\"")
					winset(src,"char_creation.label_size","text=\"Large\"")
				if(2)
					size_scale = 1
					winset(src,"char_creation.stat_info","text=\"[text_bodysize_medium]\"")
					winset(src,"char_creation.label_size","text=\"Medium\"")
				if(1)
					size_scale = 0.92
					winset(src,"char_creation.stat_info","text=\"[text_bodysize_small]\"")
					winset(src,"char_creation.label_size","text=\"Small\"")

			var/matrix/size_matrix = matrix()
			size_matrix.Scale(size_scale, size_scale)
			size_matrix.Translate((1 - size_scale) * 16, (1 - size_scale) * 16)
			src.transform = size_matrix
			
		//Plus/Minus adjustments
		mod_points(var/type,var/mod)
			if(src.started) return
			var/times = 1
			if(src.client.shift >= 1) times = 10;
			while(times)
				times -= 1
				if(src.mod_points > 0)
					if(src.mod_points_spent < 15)
						if(type == "+")
							if(mod == "energy")
								if(src.mod_energy_points < 15)
									if(src.race!="Alien")src.mod_energy += 0.125
									else if(src.race=="Alien")src.mod_energy += 0.055
									src.mod_energy_points += 1
									//src.gains_trained_energy_mod += 0.1
									src.mod_points -= 1
									src.mod_points_spent += 1
									src.stat_desc("Energy")
							if(mod == "strength")
								if(src.mod_strength_points < 15)
									//if(src.race!="Alien")src.mod_strength += 0.125
								//	else if(src.race=="Alien")src.mod_strength += 0.055
									src.mod_strength_points += 1
								//	src.gains_trained_strength_mod += 0.1
									src.mod_points -= 1
									src.mod_points_spent += 1
									src.stat_desc("Strength")
							if(mod == "endurance")
								if(src.mod_endurance_points < 15)
								//	if(src.race!="Alien")src.mod_endurance += 0.125
								//	else if(src.race=="Alien")src.mod_endurance += 0.055
									src.mod_endurance_points += 1
								//	src.gains_trained_endurance_mod += 0.1
									src.mod_points -= 1
									src.mod_points_spent += 1
									src.stat_desc("Endurance")
							if(mod == "agility")
								if(src.mod_agility_points < 15)
								//	if(src.race!="Alien")src.mod_agility += 0.125
								//	else if(src.race=="Alien")src.mod_agility += 0.055
									src.mod_agility_points += 1
								//	src.gains_trained_agility_mod += 0.1
									src.mod_points -= 1
									src.mod_points_spent += 1
									src.stat_desc("Agility")
							if(mod == "resistance")
								if(src.mod_resistance_points < 15)
								//	if(src.race!="Alien")src.mod_resistance += 0.125
								//	else if(src.race=="Alien")src.mod_resistance += 0.055
									src.mod_resistance_points += 1
									src.mod_points -= 1
									src.mod_points_spent += 1
									src.stat_desc("resistance")
							if(mod == "force")
								if(src.mod_force_points < 15)
								//	if(src.race!="Alien")src.mod_force += 0.125
								//	else if(src.race=="Alien")src.mod_force += 0.055
									src.mod_force_points += 1
								//	src.gains_trained_resistance_mod += 0.1
									src.mod_points -= 1
									src.mod_points_spent += 1
									src.stat_desc("Force")
							if(mod == "offence")
								if(src.mod_offence_points < 15)
								//	if(src.race!="Alien")src.mod_offence += 0.125
									//else if(src.race=="Alien")src.mod_offence += 0.055
									src.mod_offence_points += 1
								//	src.gains_trained_off_mod += 0.1
									src.mod_points -= 1
									src.mod_points_spent += 1
									src.stat_desc("Offence")
							if(mod == "defence")
								if(src.mod_defence_points < 15)
								//	if(src.race!="Alien")src.mod_defence += 0.125
								//	else if(src.race=="Alien")src.mod_defence += 0.055
									src.mod_defence_points += 1
								//	src.gains_trained_def_mod += 0.1
									src.mod_points -= 1
									src.mod_points_spent += 1
									src.stat_desc("Defence")
							if(mod == "recovery")
								if(src.mod_recovery_points < 15)
								//	if(src.race!="Alien")src.mod_recovery += 0.125
								//	else if(src.race=="Alien")src.mod_recovery += 0.055
									src.mod_recovery_points += 1
								//	src.gains_trained_recov_mod += 0.1
									src.mod_points -= 1
									src.mod_points_spent += 1
									src.stat_desc("Recovery")
							if(mod == "regen")
								if(src.mod_regeneration_points < 15)
								//	if(src.race!="Alien")src.mod_regeneration += 0.125
								//	else if(src.race=="Alien")src.mod_regeneration += 0.055
									src.mod_regeneration_points += 1
								//	src.gains_trained_regen_mod += 0.1
									src.mod_points -= 1
									src.mod_points_spent += 1
									src.stat_desc("Regeneration")
				if(type == "-")
					if(mod == "energy") if(src.mod_energy_points>-1)
					//	if(src.race!="Alien") src.mod_energy -= 0.125
					//	else if(src.race=="Alien")src.mod_energy -= 0.055
						src.mod_energy_points -= 1
					//	src.gains_trained_energy_mod -= 0.1
						src.mod_points += 1
						src.mod_points_spent -= 1
						src.stat_desc("Energy")
					if(mod == "strength") if(src.mod_strength_points>-1)
					//	if(src.race!="Alien")src.mod_strength -= 0.125
					//	else if(src.race=="Alien")src.mod_strength -= 0.055
						src.mod_strength_points -= 1
					//	src.gains_trained_strength_mod -= 0.1
						src.mod_points += 1
						src.mod_points_spent -= 1
						src.stat_desc("Strength")
					if(mod == "endurance") if(src.mod_endurance_points>-1)
					//	if(src.race!="Alien") src.mod_endurance -= 0.125
					//	else if(src.race=="Alien")src.mod_endurance -= 0.055
						src.mod_endurance_points -= 1
					//	src.gains_trained_endurance_mod -= 0.1
						src.mod_points += 1
						src.mod_points_spent -= 1
						src.stat_desc("Endurance")
					if(mod == "agility") if(src.mod_agility_points>-1)
					//	if(src.race!="Alien")src.mod_agility -= 0.125
					//	else if(src.race=="Alien")src.mod_agility -= 0.055
						src.mod_agility_points -= 1
					//	src.gains_trained_agility_mod -= 0.1
						src.mod_points += 1
						src.mod_points_spent -= 1
						src.stat_desc("Agility")
					if(mod == "resistance") if(src.mod_resistance_points>-1)
					//	if(src.race!="Alien") src.mod_resistance -= 0.125
					//	else if(src.race=="Alien") src.mod_resistance -= 0.055
						src.mod_resistance_points -= 1
					//	src.gains_trained_resistance_mod -= 0.1
						src.mod_points += 1
						src.mod_points_spent -= 1
						src.stat_desc("resistance")
					if(mod == "force") if(src.mod_force_points>-1)
					//	if(src.race!= "Alien") src.mod_force -= 0.125
					//	else if(src.race=="Alien")src.mod_force -= 0.055
						src.mod_force_points -= 1
					//	src.gains_trained_force_mod -= 0.1
						src.mod_points += 1
						src.mod_points_spent -= 1
						src.stat_desc("Force")
					if(mod == "offence") if(src.mod_offence_points>-1)
					//	if(src.race!="Alien") src.mod_offence -= 0.125
					//	else if(src.race=="Alien")src.mod_offence -= 0.055
						src.mod_offence_points -= 1
					//	src.gains_trained_off_mod -= 0.1
						src.mod_points += 1
						src.mod_points_spent -= 1
						src.stat_desc("Offence")
					if(mod == "defence") if(src.mod_defence_points>-1)
					//	if(src.race!="Alien") src.mod_defence -= 0.125
					//	else if(src.race=="Alien")src.mod_defence -= 0.055
						src.mod_defence_points -= 1
					//	src.gains_trained_def_mod -= 0.1
						src.mod_points += 1
						src.mod_points_spent -= 1
						src.stat_desc("Defence")
					if(mod == "recovery") if(src.mod_recovery_points>-1)
					//	if(src.race!="Alien") src.mod_recovery -= 0.125
					//	else if(src.race=="Alien")src.mod_recovery -= 0.055
						src.mod_recovery_points -= 1
					//	src.gains_trained_recov_mod -= 0.1
						src.mod_points += 1
						src.mod_points_spent -= 1
						src.stat_desc("Recovery")
					if(mod == "regen") if(src.mod_regeneration_points>-1)
					//	if(src.race!="Alien") src.mod_regeneration -= 0.125
					//	else if(src.race=="Alien")src.mod_regeneration -= 0.055
						src.mod_regeneration_points -= 1
					//	src.gains_trained_regen_mod -= 0.1
						src.mod_points += 1
						src.mod_points_spent -= 1
						src.stat_desc("Regeneration")
				//eep(0.2)
			if(src.hud_char)
				var/obj/p = src.hud_char.points
				p.maptext = "[css_outline]<font size = 1><center>[src.mod_points]"
		//This currently changes the players hair/skin when trying to use on a clone inside a tank, plus it needs a clear up anyway probably.
		create_cycle(var/t as text)
			set name = ".create_cycle"
			set hidden = 1
			src.update_looks(t)