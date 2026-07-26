obj
	/*
	.:Ideas for personal quests:.

	--------------------------------------------------------------------------------------------
	- Perhaps they should be daily, or something you can do/repeat?
	- Similar to rumours, in that the player doesn't need to speak with anyone to start them
	- Some ideas of personal quests could be
	     - Travel somewhere new
	     - Win a battle
	     - Psiforge/Upgrade a bodypart x num of times
	     - Gather x ammount of resources
	     - Get x amount of lvls in any research
	     - Experience peace and tranquility for a time
	     - Experience chaos and noise for a time
	     - Have a rest day/month, do nothing and relax
	     - Endure extreme enviromental effect for a time (perhaps as part of training/setting record)
	          - How long can they hold their breath?
	          - How much gravity can they take, and for how long?
	          - How long can they sit in heat/cold? ect
	     - Test your STAT
	          - Test how fast you can move, from point a - b
	          - See how strong you are, see how far you can throw, how hard you can punch
	          - Check how durable you are to melee, get hit, ect
	          - See how potent your force is
	          - Test how well you resist force attacks
	          - Check how quickly you can recover when tired
	          - See how fast you heal
	          - Test your offensive ability
	          - Test your defensive ability
	     - Needs Related
	          - Stay up all night
	          - Fast until hungry
	          - Become really thirsty
	          - Have a good nights rest
	          - Eat a healthly meal
	          - Drink plenty and stay hydrated
	          - Consume a RARITY food here
	     - General
	          - Discover the true nature of the universe
	          - Learn about the true nature of life and death (Learn/visit the psi realms)
	          - Write a scientific paper
	          - Teach someone something new
	          - Write a manual on martial arts
	          - Gain access to a higher realm (Psi Realm)
	          - Gain access to an even greater realm (Divine/Dark Energy Realm)
	          - Unlock an ascension
	          - Become a Psiforged
	     - Race specific
	          .:Human:.
	               - Learn more about Earth's fate
	               - Unlock your Third Eye
	               - Become an immortal

	          .:Cerebroid:.
	               - Learn more about your peoples past
	               - Repair your ship
	               - Unlock the full potential of your brain

	          .:Demon:.
	               - Take a title for yourself
	               - Create a body

	          .:Celestial:.
	               - Earn a title for yourself
	               - Create a body

	          .:Yukopian:.
	               - Learn to listen/speak to the Great Tree
	               - Cultivate the lands
	               - Help or hinder the Great Tree

	          .:Android:.
	               - Learn why you were created (Player gets to choose a reason from a list, each with their own benefits)

	          .:Imp:.
	               - Write a special chronical of your lifes journey (Player can write whatever, then choose a reward once enough text is written)
*/
	quests
		icon = 'help_expand_buttons.dmi'
		icon_state = "expanded"
		maptext_width = 320
		maptext_height = 16
		plane = 29
		layer = 34
		blend_mode = BLEND_INSET_OVERLAY
		appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
		hud_x = 10
		MouseWheel(delta_x,delta_y,location,control,params)
			var/obj/hud/menus/contacts_background/s = usr.hud_contacts
			var/obj/sc = s.scroller_main
			usr.check_mouse_loc(params)
			var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
			usr.mouse_y_true = true_y
			var/wheel_move = 0
			if(delta_y > 0) wheel_move = 16
			else if(delta_y < 0) wheel_move = -16
			var/result = sc.translated_y+wheel_move
			result = clamp(result,0,-263)
			var/matrix/m = matrix()
			m.Translate(0,result)
			sc.transform = m
			sc.translated_y = result

			s.scroller_transforms_main[s.selected] = m

			var/ratio = -1 + ((-263 + result) / -263)
			ratio = clamp(ratio,0,1)

			var/size = 0
			if(s.selected == 1) size = s.players_size
			else if(s.selected == 2) size = s.contacts_size
			else if(s.selected == 4) size = s.quest_size
			var/scroll_y = round(size*ratio)

			s.bar_pos_y_main[s.selected] = scroll_y

			for(var/obj/o in s.holder_main.vis_contents)
				var/matrix/m2 = matrix()
				m2.Translate(o.hud_x,o.hud_y+scroll_y)
				o.transform = m2
		var
			setup = 0
			setup_part = null
			opened = 0
			steps_needed = 1
			steps_completed = 0
			increase_steps = 0 //If the steps needed to complete this quest should increase or not
			repeatable = 0
			completed = 0
			time = 0
			time_highest = 0
			available = 0 //The year this quest can be done/re-done.
			txt
			txt_reward
			txt_title
			mob
				player = null
			obj
				rum = null
				lor = null
				menu = null
			list/rewards = list()
			list/buttons

			psi_talent_gain = 0
			eng_talent_gain = 0
			str_talent_gain = 0
			end_talent_gain = 0
			spd_talent_gain = 0
			res_talent_gain = 0
			force_talent_gain = 0
			off_talent_gain = 0
			def_talent_gain = 0
			regen_talent_gain = 0
			recov_talent_gain = 0
			combat_talent_gain = 0

			psi_forge_speed_gain = 0

			rsc_gain = 0
			psi_gain = 0
			eng_gain = 0
			str_gain = 0
			end_gain = 0
			spd_gain = 0
			res_gain = 0
			force_gain = 0
			off_gain = 0
			def_gain = 0
			regen_gain = 0
			recov_gain = 0
			int_gain = 0
			lifespan_gain = 0
			rads_gain = 0
			cold_gain = 0
			heat_gain = 0
			toxin_gain = 0
			gravity_gain = 0
			micro_gain = 0
			divine_eng_gain = 0
			dark_matter_gain = 0
			divine_mod_gain = 0
			dark_matter_mod_gain = 0
			o2_gain = 0
			eng_mod_gain = 0
			psi_mod_gain = 0
			metab_gain = 0
			hydro_gain = 0
			tiredness_gain = 0
			lvl_rand_part = 0 // Whether this item lvls random parts or not
			lvl_rand_num = 0 //How many times this item lvls up a rand part
			list/lvl_parts = null //List of parts to lvl
			lvl_parts_num = 0 //How many levels to give the parts in lvl_parts list
		MouseEntered()
			if(src.icon_state != "plus" && src.icon_state != "minus" && src.icon_state != "expanded moused") src.icon_state = "expanded selected"
		MouseExited()
			if(src.icon_state != "plus" && src.icon_state != "minus" && src.icon_state != "expanded moused") src.icon_state = "expanded"
		Click()
			if(src.icon_state == "plus" || src.icon_state == "minus")
				if(src.opened == 0)
					src.opened = 1
					src.icon_state = "minus"
				else
					src.opened = 0
					src.icon_state = "plus"
			src.quest_txt(usr)
			if(usr.hud_contacts)
				var/obj/hud/menus/contacts_background/bg = usr.hud_contacts
				if(bg.quest_selected) bg.quest_selected.icon_state = "expanded"
				if(src.icon_state != "plus" && src.icon_state != "minus")
					src.icon_state = "expanded moused"
					bg.quest_selected = src
				bg.holder_info.vis_contents = null
				bg.holder_info.vis_contents += bg.txt_name
				bg.holder_info.vis_contents += bg.txt_info
				bg.quests(usr)
				bg.txt_name.maptext = "[css_outline]<font size = 2><center>[src.txt_title]"
				bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.txt]"

				var/matrix/m = matrix()
				m.Translate(bg.txt_name.hud_x-16,bg.txt_name.hud_y+20)
				bg.txt_name.transform = m

				var/matrix/m2 = matrix()
				m2.Translate(bg.txt_info.hud_x,bg.txt_info.hud_y+64)
				bg.txt_info.transform = m2

				bg.txt_info.maptext_width = 210
		proc
			quest_set_bodypart(var/mob/m)
				if(src.setup_part == null)
					if(m.race == "Demon" || m.race == "Kai") return
					//var/obj/part = pick(section.contents)
					//src.info_name = "Level [part]"
				//	src.txt_title = "Level [part]"
				//	col = "<font color = yellow>[round(src.available-global.year,0.1)] Years<font color = white>"
				//	src.txt = "[src.txt_reward]\n\nQuest Available: [col]\n\nLevel [part]"
					//src.setup_part = part.type
			quest_increase_rewards()
				if(src.increase_steps && src.steps_needed > 0) src.steps_needed += round(src.steps_needed/2)
				src.rsc_gain += src.rsc_gain
				src.psi_gain += src.psi_gain
				src.eng_gain += src.eng_gain
				src.str_gain += src.str_gain
				src.end_gain += src.end_gain
				if(src.psi_forge_speed_gain) src.psi_forge_speed_gain += 0.01
				if(src.spd_gain) src.spd_gain += 0.1
				src.res_gain += src.res_gain
				src.force_gain += src.force_gain
				src.off_gain += src.off_gain
				src.def_gain += src.def_gain
				if(src.regen_gain) src.regen_gain += 0.1
				if(src.recov_gain) src.recov_gain += 0.1
				if(src.int_gain) src.int_gain += 0.1
				src.lifespan_gain += src.lifespan_gain
				if(src.rads_gain) src.rads_gain += 0.1
				if(src.cold_gain) src.cold_gain += 0.1
				if(src.heat_gain) src.heat_gain += 0.1
				if(src.toxin_gain) src.toxin_gain += 0.1
				if(src.gravity_gain) src.gravity_gain += 0.1
				if(src.micro_gain) src.micro_gain += 0.1
				src.divine_eng_gain += src.divine_eng_gain
				src.dark_matter_gain += src.dark_matter_gain
				if(src.divine_mod_gain) src.divine_mod_gain += 0.1
				if(src.dark_matter_mod_gain) src.dark_matter_mod_gain += 0.1
				src.o2_gain += src.o2_gain
				if(src.eng_mod_gain) src.eng_mod_gain += 0.1
				if(src.psi_mod_gain) src.psi_mod_gain += 0.1
				if(src.lvl_parts_num) src.lvl_parts_num += 1
				src.lvl_rand_num += src.lvl_rand_num
				if(src.lvl_rand_num >= 80) src.lvl_rand_num = 80
			apply_reward_stats(var/mob/m,var/cd = 0)
				if(src.completed) return
				if(src.steps_completed >= src.steps_needed)
					m.set_alert("Quest Completed: [src]",'alert.dmi',"alert")

					src.completed = 1
					src.available = cd
					src.time = 0
					if(m.hud_contacts)
						m.hud_contacts.quests(m)
						m.hud_contacts.sort_quests()
					var/multi = 1
					m.icon_state = m.state()
					//if(src.lifespan_gain != 0)
					//	m.lifespan += src.lifespan_gain*multi
					//	m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.lifespan_gain*multi] Lifespan")
					//	m.set_decline()
					//if(src.lvl_rand_part)
					//	var/n = src.lvl_rand_num
					//	while(n)
					//		n -= 1
						//	m.lvl_rand_bodypart()
					//if(src.lvl_parts != null)
					//	m.lvl_typesof_bodypart(src.lvl_parts,src.lvl_parts_num*100,0,0,1)
					if(src.rsc_gain != 0)
						//m.resources += src.rsc_gain
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.rsc_gain*multi] Resources")
					//Talent point rewards
					/*if(src.psi_talent_gain != 0)
						m.skill_points_power += src.psi_talent_gain
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.psi_talent_gain*multi] Psi Power Skill Points")
					if(src.eng_talent_gain != 0)
						m.skill_points_energy += src.eng_talent_gain
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.eng_talent_gain*multi] Energy Skill Points")
					if(src.str_talent_gain != 0)
						m.skill_points_strength += src.str_talent_gain
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.str_talent_gain*multi] Strength Skill Points")
					if(src.end_talent_gain != 0)
						m.skill_points_endurance += src.end_talent_gain
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.end_talent_gain*multi] Endurance Skill Points")
					if(src.force_talent_gain != 0)
						m.skill_points_force += src.force_talent_gain
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.force_talent_gain*multi] Force Skill Points")
					if(src.spd_talent_gain != 0)
						m.skill_points_agility += src.spd_talent_gain
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.spd_talent_gain*multi] Agility Skill Points")
					if(src.off_talent_gain != 0)
						m.skill_points_offence += src.off_talent_gain
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.off_talent_gain*multi] Offence Skill Points")
					if(src.def_talent_gain != 0)
						m.skill_points_defence += src.def_talent_gain
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.def_talent_gain*multi] Defence Skill Points")
					if(src.recov_talent_gain != 0)
						m.skill_points_recovery += src.recov_talent_gain
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.recov_talent_gain*multi] Recovery Skill Points")
					if(src.combat_talent_gain != 0)
						m.skill_points_combat += src.combat_talent_gain
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.combat_talent_gain*multi] Combat Skill Points")
					//Core stat rewards
					if(src.psi_forge_speed_gain != 0)
						m.psiforging_speed += src.psi_forge_speed_gain*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[(src.psi_forge_speed_gain*multi)*100]% Toning Speed")
					if(src.psi_mod_gain != 0)
						m.gains_trained_power_mod += src.psi_mod_gain*multi
						m.mod_psionic_power += src.psi_mod_gain*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.psi_mod_gain*multi] Power Mod")
					if(src.psi_gain != 0)
						m.gains_trained_power += src.psi_gain*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.psi_gain*multi] Power")
					if(src.eng_mod_gain != 0)
						m.gains_trained_energy_mod += src.eng_mod_gain*multi
						m.mod_energy += src.eng_mod_gain*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.eng_mod_gain*multi] Energy Mod")
					if(src.eng_gain != 0)
						m.gains_trained_energy += src.eng_gain*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.eng_gain*multi] Energy")
					if(src.divine_eng_gain != 0)
						m.divine_energy += (src.divine_eng_gain*m.divine_energy_mod)*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[(src.divine_eng_gain*m.divine_energy_mod)*multi] Divine Energy")
						if(islist(m.tutorials))
							var/obj/help_topics/H = m.tutorials[7]
							if(H.seen == 0)
								H.seen = 1
								H.skill_up(m)
					if(src.dark_matter_gain != 0)
						m.dark_matter += (src.dark_matter_gain*m.dark_matter_mod)*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[(src.dark_matter_gain*m.dark_matter_mod)*multi] Dark Matter")
						if(islist(m.tutorials))
							var/obj/help_topics/H = m.tutorials[15]
							if(H.seen == 0)
								H.seen = 1
								H.skill_up(m)
					if(src.str_gain != 0)
						m.gains_trained_strength += src.str_gain*multi
						//m.strength += (src.str_gain*m.mod_strength)*multi
						//m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[(src.str_gain*m.mod_strength)*multi] Strength")
					if(src.spd_gain != 0)
						m.gains_trained_agility_mod += src.spd_gain*multi
						//m.mod_agility += src.spd_gain*multi
					//	m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.spd_gain*multi] Agility Mod")
					if(src.end_gain != 0)
						m.gains_trained_endurance += src.end_gain*multi
						//m.endurance += (src.end_gain*m.mod_endurance)*multi
						//m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[(src.end_gain*m.mod_endurance)*multi] Endurance")
					if(src.res_gain != 0)
						m.gains_trained_resistance += src.res_gain*multi
					//	m.resistance += (src.res_gain*m.mod_resistance)*multi
					//	m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[(src.res_gain*m.mod_resistance)*multi] Resistance")
					if(src.force_gain != 0)
						m.gains_trained_force += src.force_gain*multi
						m.force += (src.force_gain*m.mod_force)*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[(src.force_gain*m.mod_force)*multi] Force")
					if(src.off_gain != 0)
						m.gains_trained_off += src.off_gain*multi
						m.offence += (src.off_gain*m.mod_offence)*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[(src.off_gain*m.mod_offence)*multi] Offence")
					if(src.def_gain != 0)
						m.gains_trained_def += src.def_gain*multi
						m.defence += (src.def_gain*m.mod_defence)*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[(src.def_gain*m.mod_defence)*multi] Defence")
					if(src.regen_gain != 0)
						m.gains_trained_regen_mod += src.regen_gain*multi
						m.mod_regeneration += src.regen_gain*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.regen_gain*multi] Regeneration Mod")
					if(src.recov_gain != 0)
						m.gains_trained_recov_mod += src.recov_gain*multi
						m.mod_recovery += src.recov_gain*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.recov_gain*multi] Recovery Mod")
					if(src.rads_gain != 0)
						m.mod_immune_rads += src.rads_gain*multi
						m.immune_rads_trained += src.rads_gain*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[(src.rads_gain*multi)*100]% Radiation Tolerance")
					if(src.cold_gain != 0)
						m.mod_immune_cold += src.cold_gain*multi
						m.immune_cold_trained += src.cold_gain*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[(src.cold_gain*multi)*100]% Cold Tolerance")
					if(src.heat_gain != 0)
						m.mod_immune_heat += src.heat_gain*multi
						m.immune_heat_trained += src.heat_gain*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[(src.heat_gain*multi)*100]% Heat Tolerance")
					if(src.gravity_gain != 0)
						m.mod_immune_gravity += src.gravity_gain*multi
						m.immune_gravity_trained += src.gravity_gain*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[(src.gravity_gain*multi)*100]% Gravity Tolerance")
					if(src.micro_gain != 0)
						m.mod_immune_microwaves += src.micro_gain*multi
						m.immune_microwaves_trained += src.micro_gain*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[(src.micro_gain*multi)*100]% Microwaves Tolerance")
					if(src.toxin_gain != 0)
						m.mod_immune_toxins += src.toxin_gain*multi
						m.immune_toxins_trained += src.toxin_gain*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[(src.toxin_gain*multi)*100]% Toxic Tolerance")
					if(src.divine_mod_gain != 0)
						m.divine_energy_mod += src.divine_mod_gain*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.divine_mod_gain*multi] Divine Energy Mod")
					if(src.dark_matter_mod_gain != 0)
						m.dark_matter_mod += src.dark_matter_mod_gain*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.dark_matter_mod_gain*multi] Dark Matter Mod")
					if(src.o2_gain != 0)
						m.o2_max += src.o2_gain*multi
						m.gains_trained_o2 += src.o2_gain*multi
						m.create_chat_entry("system","Quest Reward <font color = yellow>[src]<font color = white>: +[src.o2_gain*multi] Max Oxygen")
					*/

				if(src.steps_completed >= src.steps_needed)
					if(cd > 0)
						src.steps_completed = 0
						src.quest_increase_rewards()
						src.create_reward_desc()
						if(src.setup_part)
							src.setup_part = null
							//src.quest_set_bodypart(m)

				src.quest_txt(m)

			quest_txt(var/mob/m)
				//Check specific quests
				var/col = "<font color = green>Now<font color = white>"
				if(src.available-global.year > 0) col = "<font color = yellow>[round(src.available-global.year,0.1)] Years<font color = white>"
				var/t = src.type
				switch(t)
					//Environmental quests
					if(/obj/quests/personal/quests_environmental/env_grav)
						src.txt = "[src.txt_reward]\n\nQuest Available: [col]\n\nHighest Gravity Experienced: [m.grav_highest]\n\nHighest Time: [src.time_highest] seconds\n\nCurrent Time: [src.time] seconds\n\nTime Needed: [src.steps_needed] seconds"
						if(m.open_contacts)
							var/obj/hud/menus/contacts_background/bg = m.hud_contacts
							if(bg.quest_selected == src)
								bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.txt]"
					if(/obj/quests/personal/quests_environmental/env_micro)
						src.txt = "[src.txt_reward]\n\nQuest Available: [col]\n\nHighest Microwaves Experienced: [m.micro_highest]\n\nHighest Time: [src.time_highest] seconds\n\nCurrent Time: [src.time] seconds\n\nTime Needed: [src.steps_needed] seconds"
						if(m.open_contacts)
							var/obj/hud/menus/contacts_background/bg = m.hud_contacts
							if(bg.quest_selected == src)
								bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.txt]"
					if(/obj/quests/personal/quests_environmental/env_heat)
						src.txt = "[src.txt_reward]\n\nQuest Available: [col]\n\nHighest Time: [src.time_highest] seconds\n\nCurrent Time: [src.time] seconds\n\nTime Needed: [src.steps_needed] seconds"
						if(m.open_contacts)
							var/obj/hud/menus/contacts_background/bg = m.hud_contacts
							if(bg.quest_selected == src)
								bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.txt]"
					if(/obj/quests/personal/quests_environmental/env_cold)
						src.txt = "[src.txt_reward]\n\nQuest Available: [col]\n\nHighest Time: [src.time_highest] seconds\n\nCurrent Time: [src.time] seconds\n\nTime Needed: [src.steps_needed] seconds"
						if(m.open_contacts)
							var/obj/hud/menus/contacts_background/bg = m.hud_contacts
							if(bg.quest_selected == src)
								bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.txt]"
					if(/obj/quests/personal/quests_environmental/env_rads)
						src.txt = "[src.txt_reward]\n\nQuest Available: [col]\n\nHighest Time: [src.time_highest] seconds\n\nCurrent Time: [src.time] seconds\n\nTime Needed: [src.steps_needed] seconds"
						if(m.open_contacts)
							var/obj/hud/menus/contacts_background/bg = m.hud_contacts
							if(bg.quest_selected == src)
								bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.txt]"
					if(/obj/quests/personal/quests_environmental/env_breath)
						src.txt = "[src.txt_reward]\n\nQuest Available: [col]\n\nHighest Time: [src.time_highest] seconds\n\nCurrent Time: [src.time] seconds\n\nTime Needed: [src.steps_needed] seconds"
						if(m.open_contacts)
							var/obj/hud/menus/contacts_background/bg = m.hud_contacts
							if(bg.quest_selected == src)
								bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.txt]"
					//Body part quests
					if(/obj/quests/personal/quests_bodyparts/lvl_bodypart)
						src.txt = "[src.txt_reward]\n\nQuest Available: [col]\n\nLevel any body part: [src.steps_completed]/[src.steps_needed]"
						if(m.open_contacts)
							var/obj/hud/menus/contacts_background/bg = m.hud_contacts
							if(bg.quest_selected == src)
								bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.txt]"
					if(/obj/quests/personal/quests_bodyparts/lvl_bodypart_specific)
						src.txt = "[src.txt_reward]\n\nQuest Available: [col]\n\n[src.txt_title]"
						if(m.open_contacts)
							var/obj/hud/menus/contacts_background/bg = m.hud_contacts
							if(bg.quest_selected == src)
								bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.txt]"
					//General quests
					if(/obj/quests/personal/quests_general/gen_meditate)
						src.txt = "[src.txt_reward]\n\nQuest Available: [col]\n\nHighest Time: [src.time_highest] seconds\n\nCurrent Time: [src.time] seconds\n\nTime Needed: [src.steps_needed] seconds"
						if(m.open_contacts)
							var/obj/hud/menus/contacts_background/bg = m.hud_contacts
							if(bg.quest_selected == src)
								bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.txt]"
					if(/obj/quests/personal/quests_general/gen_lvl_research)
						src.txt = "[src.txt_reward]\n\nQuest Available: [col]\n\nResearch any technology: [src.steps_completed]/[src.steps_needed]"
						if(m.open_contacts)
							var/obj/hud/menus/contacts_background/bg = m.hud_contacts
							if(bg.quest_selected == src)
								bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.txt]"
					//Needs
					if(/obj/quests/personal/quest_needs/needs_rare_food)
						src.txt = "[src.txt_reward]\n\nQuest Available: [col]\n\nEat rare food: [src.steps_completed]/[src.steps_needed]"
						if(m.open_contacts)
							var/obj/hud/menus/contacts_background/bg = m.hud_contacts
							if(bg.quest_selected == src)
								bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.txt]"
					if(/obj/quests/personal/quest_needs/needs_hunger_high)
						src.txt = "[src.txt_reward]\n\nQuest Available: [col]\n\nGain the Well Fed status: [src.steps_completed]/[src.steps_needed]"
						if(m.open_contacts)
							var/obj/hud/menus/contacts_background/bg = m.hud_contacts
							if(bg.quest_selected == src)
								bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.txt]"
					if(/obj/quests/personal/quest_needs/needs_thirst_high)
						src.txt = "[src.txt_reward]\n\nQuest Available: [col]\n\nGain the Hydrated status: [src.steps_completed]/[src.steps_needed]"
						if(m.open_contacts)
							var/obj/hud/menus/contacts_background/bg = m.hud_contacts
							if(bg.quest_selected == src)
								bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.txt]"
					if(/obj/quests/personal/quest_needs/needs_thirst_low)
						src.txt = "[src.txt_reward]\n\nQuest Available: [col]\n\nGain the Thirsty status: [src.steps_completed]/[src.steps_needed]"
						if(m.open_contacts)
							var/obj/hud/menus/contacts_background/bg = m.hud_contacts
							if(bg.quest_selected == src)
								bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.txt]"
					if(/obj/quests/personal/quest_needs/needs_hunger_low)
						src.txt = "[src.txt_reward]\n\nQuest Available: [col]\n\nGain the Hungry status: [src.steps_completed]/[src.steps_needed]"
						if(m.open_contacts)
							var/obj/hud/menus/contacts_background/bg = m.hud_contacts
							if(bg.quest_selected == src)
								bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.txt]"
					if(/obj/quests/personal/quest_needs/needs_rest_low)
						src.txt = "[src.txt_reward]\n\nQuest Available: [col]\n\nGain the Tired status: [src.steps_completed]/[src.steps_needed]"
						if(m.open_contacts)
							var/obj/hud/menus/contacts_background/bg = m.hud_contacts
							if(bg.quest_selected == src)
								bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.txt]"
					if(/obj/quests/personal/quest_needs/needs_rest_high)
						src.txt = "[src.txt_reward]\n\nQuest Available: [col]\n\nGain the Well Rested status: [src.steps_completed]/[src.steps_needed]"
						if(m.open_contacts)
							var/obj/hud/menus/contacts_background/bg = m.hud_contacts
							if(bg.quest_selected == src)
								bg.txt_info.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.txt]"
			create_reward_desc()
				var/txt = "Rewards: "
				var/txt_c = null
				var/txt_green = "<font color = green>+"
				var/txt_red = "<font color = red>"
				if(src.rsc_gain != 0)
					if(src.rsc_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][Commas(src.rsc_gain)] Resources</font>"
				txt_c = txt_green
				//Talent points
				if(src.psi_talent_gain != 0)
					if(src.psi_talent_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.psi_talent_gain] Psi Power Skill Points</font>"
				txt_c = txt_green
				if(src.eng_talent_gain != 0)
					if(src.eng_talent_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.eng_talent_gain] Energy Skill Points</font>"
				txt_c = txt_green
				if(src.str_talent_gain != 0)
					if(src.str_talent_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.str_talent_gain] Strength Skill Points</font>"
				txt_c = txt_green
				if(src.spd_talent_gain != 0)
					if(src.spd_talent_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.spd_talent_gain] Agility Skill Points</font>"
				txt_c = txt_green
				if(src.end_talent_gain != 0)
					if(src.end_talent_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.end_talent_gain] Endurance Skill Points</font>"
				txt_c = txt_green
				if(src.res_talent_gain != 0)
					if(src.res_talent_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.res_talent_gain] Resistance Skill Points</font>"
				txt_c = txt_green
				if(src.force_talent_gain != 0)
					if(src.force_talent_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.force_talent_gain] Force Skill Points</font>"
				txt_c = txt_green
				if(src.off_talent_gain != 0)
					if(src.off_talent_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.off_talent_gain] Offence Skill Points</font>"
				txt_c = txt_green
				if(src.def_talent_gain != 0)
					if(src.def_talent_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.def_talent_gain] Defence Skill Points</font>"
				txt_c = txt_green
				if(src.regen_talent_gain != 0)
					if(src.regen_talent_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.regen_talent_gain] Regeneration Skill Points</font>"
				txt_c = txt_green
				if(src.recov_talent_gain != 0)
					if(src.recov_talent_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.recov_talent_gain] Recovery Skill Points</font>"
				txt_c = txt_green
				if(src.combat_talent_gain != 0)
					if(src.combat_talent_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.combat_talent_gain] Combat Skill Points</font>"
				txt_c = txt_green
				//Core stats
				if(src.psi_forge_speed_gain != 0)
					if(src.psi_forge_speed_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.psi_forge_speed_gain*100]% Toning Speed</font>"
				txt_c = txt_green
				if(src.psi_mod_gain != 0)
					if(src.psi_mod_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.psi_mod_gain] Power Mod</font>"
				txt_c = txt_green
				if(src.psi_gain != 0)
					if(src.psi_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.psi_gain] Power</font>"
				txt_c = txt_green
				if(src.eng_mod_gain != 0)
					if(src.eng_mod_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.eng_mod_gain] Energy Mod</font>"
				txt_c = txt_green
				if(src.eng_gain != 0)
					if(src.eng_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.eng_gain] Max Energy</font>"
				txt_c = txt_green
				if(src.str_gain != 0)
					if(src.str_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.str_gain] Strength</font>"
				txt_c = txt_green
				if(src.spd_gain != 0)
					if(src.spd_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.spd_gain] Agility Mod</font>"
				txt_c = txt_green
				if(src.end_gain != 0)
					if(src.end_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.end_gain] Endurance</font>"
				txt_c = txt_green
				if(src.res_gain != 0)
					if(src.res_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.res_gain] Resistance</font>"
				txt_c = txt_green
				if(src.force_gain != 0)
					if(src.force_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.force_gain] Force</font>"
				txt_c = txt_green
				if(src.off_gain != 0)
					if(src.off_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.off_gain] Offence</font>"
				txt_c = txt_green
				if(src.def_gain != 0)
					if(src.def_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.def_gain] Defence</font>"
				txt_c = txt_green
				if(src.regen_gain != 0)
					if(src.regen_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.regen_gain] Regeneration Mod</font>"
				txt_c = txt_green
				if(src.recov_gain != 0)
					if(src.recov_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.recov_gain] Recovery Mod</font>"
				txt_c = txt_green
				if(src.rads_gain != 0)
					if(src.rads_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.rads_gain] Radiation Tolerance</font>"
				txt_c = txt_green
				if(src.cold_gain != 0)
					if(src.cold_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.cold_gain] Cold Tolerance</font>"
				txt_c = txt_green
				if(src.heat_gain != 0)
					if(src.heat_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.heat_gain] Heat Tolerance</font>"
				txt_c = txt_green
				if(src.gravity_gain != 0)
					if(src.gravity_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.gravity_gain] Gravity Tolerance</font>"
				txt_c = txt_green
				if(src.micro_gain != 0)
					if(src.micro_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.micro_gain] Microwave Tolerance</font>"
				txt_c = txt_green
				if(src.toxin_gain != 0)
					if(src.toxin_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.toxin_gain] Toxin Tolerance</font>"
				txt_c = txt_green
				if(src.divine_mod_gain != 0)
					if(src.divine_mod_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.divine_mod_gain] Divine Energy Mod</font>"
				txt_c = txt_green
				if(src.divine_eng_gain != 0)
					if(src.divine_eng_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.divine_eng_gain] Divine Energy</font>"
				txt_c = txt_green
				if(src.dark_matter_mod_gain != 0)
					if(src.dark_matter_mod_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.dark_matter_mod_gain] Dark Matter Mod</font>"
				txt_c = txt_green
				if(src.dark_matter_gain != 0)
					if(src.dark_matter_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.dark_matter_gain] Dark Matter</font>"
				txt_c = txt_green
				if(src.lifespan_gain != 0)
					if(src.lifespan_gain > 0) txt_c = txt_green
					else txt_c = txt_red
					txt = "[txt]\n[txt_c][src.lifespan_gain] Lifespan</font>"
				txt_c = txt_green
				if(src.metab_gain != 0)
					if(src.metab_gain > 0) txt_c = "<font color = green>+"
					else txt_c = "<font color = red>"
					txt = "[txt]\n[txt_c][src.metab_gain]% Satiation</font>"
				txt_c = txt_green
				if(src.hydro_gain != 0)
					if(src.hydro_gain > 0) txt_c = "<font color = green>+"
					else txt_c = "<font color = red>"
					txt = "[txt]\n[txt_c][src.hydro_gain]% Hydration</font>"
				txt_c = txt_green
				if(src.tiredness_gain != 0)
					if(src.tiredness_gain > 0) txt_c = "<font color = green>+"
					else txt_c = "<font color = red>"
					txt = "[txt]\n[txt_c][src.tiredness_gain]% Restedness</font>"
				txt_c = txt_green
				if(src.lvl_rand_part != 0)
					if(src.lvl_rand_num > 0) txt_c = "<font color = green>+"
					else txt_c = "<font color = red>"
					txt = "[txt]\n[txt_c]1 lvl in [src.lvl_rand_num] random body parts</font>"
				txt_c = txt_green
				if(src.lvl_parts != null)
					if(src.lvl_parts_num > 0) txt_c = "<font color = green>+"
					else txt_c = "<font color = red>"
					for(var/t in src.lvl_parts)
						txt = "[txt]\n[txt_c][src.lvl_parts_num] lvl in [t]s </font>"
				for(var/atom/a in src.rewards)
					txt = "[txt]\n[txt_c][a.name]</font>"
				src.txt_reward = txt
				return txt
		tutorials
			info_name = "Tutorials"
			txt_title = "Tutorials"
			txt = "These tutorial quests may be helpful in understanding some of the games core concepts, in most cases offering a step-by-step guide on how various mechanics work and can be used.\n\nThey also give some rewards to help get new players started."
			plane=29
			New()
				spawn(10)
					if(src && src.setup == 0)
						src.name = src.info_name
						src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
						src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
						src.setup = 1
						src.available = global.year
						src.buttons = list(new /:tutorial_eat,new /:tutorial_drink,new /:tutorial_sleep,new /:tutorial_psiforge,new /:tutorial_infuse,new /:tutorial_use_skill,new /:tutorial_unlock_skill,new /:tutorial_environmentals,new /:tutorial_lifespan)
			tutorial_use_skill
				info_name = "Using skills"
				txt_title = "Use a Skill"
				eng_gain = 10
				force_gain = 5
				hud_x = 26
				txt = "- Open up the Skills(s) menu\n\n- Drag the skill to the Skillbar\n\n- Activate the skill"
				New()
					spawn(10)
						if(src && src.setup == 0)
							src.name = src.info_name
							src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
							src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
							src.setup = 1
							src.available = global.year

			tutorial_drink
				info_name = "Drinking"
				txt_title = "Drink Something"
				eng_gain = 5
				res_gain = 5
				force_gain = 5
				hud_x = 26
				txt = "- Search around for something to drink\n\n- Click the drink to pick it up\n\n- Open up your inventory(i)\n\n- Double click the drink\n\nLiquid takes a few moments to consume which can be canceled by moving. It's also a good idea to keep in mind that taking damage or being stunned will also cancel drinking."
				New()
					spawn(10)
						if(src && src.setup == 0)
							src.name = src.info_name
							src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
							src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
							src.setup = 1
							src.available = global.year
			tutorial_sleep
				info_name = "Sleeping"
				txt_title = "Get Some Sleep"
				eng_gain = 5
				off_gain = 5
				def_gain = 5
				hud_x = 26
				txt = "- Open up the Skills(s) menu\n\n- Drag the Sleep skill to the Skillbar\n\n- Activate the Sleep skill"
				New()
					spawn(10)
						if(src && src.setup == 0)
							src.name = src.info_name
							src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
							src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
							src.setup = 1
							src.available = global.year
			tutorial_eat
				info_name = "Eating"
				txt_title = "Eat Some Food"
				txt = "- Search around for some food\n\n- Click the food to pick it up\n\n- Open up your inventory(i)\n\n- Double click the food\n\nFood takes a few moments to consume which can be canceled by moving. It's also a good idea to keep in mind that taking damage or being stunned will also cancel eating."
				eng_gain = 5
				str_gain = 5
				end_gain = 5
				hud_x = 26
				New()
					spawn(10)
						if(src && src.setup == 0)
							src.name = src.info_name
							src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
							src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
							src.setup = 1
							src.available = global.year
			tutorial_psiforge
				info_name = "Toning"
				txt_title = "Tone a Body Part"
				psi_gain = 10
				lvl_rand_part = 1
				lvl_rand_num = 1
				hud_x = 26
				txt = "- Open up the Toning(p) menu\n\n- Click a body section\n\n- Click a body part inside that section\n\n- Click the Tone button\n\n- Use meditation or other source of training\n\n- Wait for part to level up\n\n- Or eat items that grant body part lvls\n\n- Or train inside environmentals to lvl a part"
				New()
					spawn(10)
						if(src && src.setup == 0)
							src.name = src.info_name
							src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
							src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
							src.setup = 1
							src.available = global.year
			tutorial_unlock_skill
				info_name = "Unlocking skills"
				txt_title = "Unlock a Skill"
				eng_gain = 10
				force_gain = 5
				hud_x = 26
				txt = "- Open up the Unlocks(u) menu\n\n- Click a skill to select it\n\n- Click the Unlock button"
				New()
					spawn(10)
						if(src && src.setup == 0)
							src.name = src.info_name
							src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
							src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
							src.setup = 1
							src.available = global.year
			tutorial_lifespan
				info_name = "Lifespan"
				txt_title = "Increase Your Lifespan"
				lifespan_gain = 10
				hud_x = 26
				txt = "- Increase your Lifespan through any means\n\n- Some body parts give Lifespan\n\n- Some Quests give Lifespan\n\n- Some rare items give Lifespan"
				New()
					spawn(10)
						if(src && src.setup == 0)
							src.name = src.info_name
							src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
							src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
							src.setup = 1
							src.available = global.year
			tutorial_environmentals
				info_name = "Environmentals"
				txt_title = "Train Using Environmentals"
				txt = "- Search for an uncomfortable environment\n\n- Enter one of the following\n\n- Train underwater\n\n- Train in a desert\n\n- Train in the snow\n\n- Train near a source of raditation\n\n- Train inside a gravity field\n\n- Train inside a microwave field"
				rads_gain = 0.01
				cold_gain = 0.01
				heat_gain = 0.01
				gravity_gain = 0.01
				micro_gain = 0.01
				hud_x = 26
				New()
					spawn(10)
						if(src && src.setup == 0)
							src.name = src.info_name
							src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
							src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
							src.setup = 1
							src.available = global.year
			tutorial_infuse
				info_name = "Infusing"
				txt_title = "Infuse a Body Part"
				lvl_rand_part = 1
				lvl_rand_num = 1
				eng_gain = 10
				hud_x = 26
				txt = "- Open up the Unlocks(u) menu\n\n- Click an infusion skill to select it\n\n- Click the Unlock button\n\n- Open up the Skills(s) menu\n\n- Drag an infusion skill to the Skillbar\n\n- Activate the infusion skill\n\n- Select a body part to infuse"
				New()
					spawn(10)
						if(src && src.setup == 0)
							src.name = src.info_name
							src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
							src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
							src.setup = 1
							src.available = global.year
			/*
			.:Ideas for tutorial quests:.
			     - Psiforge/Upgrade a bodypart
			     - Use a skill
			     - Eat some food
			     - Drink
			     - Sleep
			     - Complete a step toward a milestone/soul/ascension
			     - Research a tech
			     - Build tech
			          - Build a powerline
			          - Create a powersource
			          - Place a tech
			          - Press V to toggle detailed info
			     - Unlock a skill
			     - Infuse a bodypart
			     - Train using one or more environmental effects
			     - Increase your lifespan
			     - Recover health (Once it drops below 10%, trigger quest)
			     - Recruit a follower
			     - Gain a contact
			     - Set a relation

			*/
		completed
			info_name = "Completed"
			completed = 1
		factions
		/*Titanius80 - A faction loyalty point curency they can offer for task or any mission and they offer things in there store for said points and it's
		faction exclusive currency and if you have better rewards the loyalty point is valued more.

		- So basically, have a bunch of factions associated with various things/apsects
		- Have those factions/sects have npc you can speak to and do quests for
		- Gain faction-based loyalty currency, and/or get faction-based rewards

		*/
		personal
			info_name = "Personal"
			txt_title = "Personal Quests and Records"
			repeatable = 1
			increase_steps = 1
			New()
				spawn(10)
					if(src && src.setup == 0)
						src.name = src.info_name
						src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
						src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
						src.setup = 1
						src.available = global.year
						src.buttons = list(new /:quest_needs,new /:quest_stats,new /:quests_bodyparts,new /:quests_environmental,new /:quests_general)
						for(var/obj/b in src.buttons)
							b.icon_state = "plus"


			quests_bodyparts
				info_name = "Body Parts"
				txt_title = "Body Part Quests"
				hud_x = 26
				New()
					spawn(10)
						if(src && src.setup == 0)
							src.name = src.info_name
							src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
							src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
							src.setup = 1
							src.available = global.year
							src.buttons = list(new /:lvl_bodypart,new /:lvl_bodypart_specific)
				lvl_bodypart
					info_name = "Level Body Parts"
					txt_title = "Level Body Parts"
					hud_x = 42
					icon = 'tech_expand_buttons_large.dmi'
					txt = "Quest Available: <font color = green>Now<font color = white>\n\nLevel any body part: 0/5"
					steps_needed = 5
					lvl_rand_part = 1
					lvl_rand_num = 2
					combat_talent_gain = 1
					psi_forge_speed_gain = 0.01
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				lvl_bodypart_specific
					hud_x = 42
					icon = 'tech_expand_buttons_large.dmi'
					steps_needed = 1
					info_name = "Level Specific Body Part"
					combat_talent_gain = 1
					increase_steps = 0
					psi_forge_speed_gain = 0.01
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year

			quests_environmental
				info_name = "Enviromental"
				txt_title = "Enviromental Tests"
				hud_x = 26
				New()
					spawn(10)
						if(src && src.setup == 0)
							src.name = src.info_name
							src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
							src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
							src.setup = 1
							src.available = global.year
							src.buttons = list(new /:env_breath,new /:env_cold,new /:env_grav,new /:env_heat,new /:env_micro,new /:env_rads)
				/*
				- Have the Gravity and Micro quests increase in difficulty over time infinitely
				- With other env quests, have them cap, because of the 200% immunity
				*/
				env_grav
					info_name = "Endure Gravity"
					txt_title = "Endure High Gravity"
					hud_x = 42
					icon = 'tech_expand_buttons_large.dmi'
					txt = "Quest Available: <font color = green>Now<font color = white>\n\nHighest Gravity Experienced: 0\n\nHighest Time: 0 seconds\n\nCurrent Time: 0 seconds\n\nTime Needed: 30 seconds"
					steps_needed = 30
					str_talent_gain = 1
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.lvl_parts = list("Bone")
								src.lvl_parts_num = 1
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				env_cold
					info_name = "Endure Cold"
					txt_title = "Endure the Cold"
					hud_x = 42
					icon = 'tech_expand_buttons_large.dmi'
					txt = "Quest Available: <font color = green>Now<font color = white>\n\nHighest Time: 0 seconds\n\nCurrent Time: 0 seconds\n\nTime Needed: 30 seconds"
					steps_needed = 30
					end_talent_gain = 1
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.lvl_parts = list("Skin")
								src.lvl_parts_num = 1
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				env_heat
					info_name = "Endure Heat"
					txt_title = "Endure the Heat"
					hud_x = 42
					icon = 'tech_expand_buttons_large.dmi'
					txt = "Quest Available: <font color = green>Now<font color = white>\n\nHighest Time: 0 seconds\n\nCurrent Time: 0 seconds\n\nTime Needed: 30 seconds"
					steps_needed = 30
					recov_talent_gain = 1
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.lvl_parts = list("Skin")
								src.lvl_parts_num = 1
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				env_breath
					info_name = "Hold Breath"
					txt_title = "Hold Your Breath"
					hud_x = 42
					icon = 'tech_expand_buttons_large.dmi'
					txt = "Quest Available: <font color = green>Now<font color = white>\n\nHighest Time: 0 seconds\n\nCurrent Time: 0 seconds\n\nTime Needed: 30 seconds"
					steps_needed = 30
					eng_talent_gain = 1
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.lvl_parts = list("Lung")
								src.lvl_parts_num = 1
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				env_micro
					info_name = "Endure Microwaves"
					txt_title = "Endure the Microwave Radiation"
					hud_x = 42
					icon = 'tech_expand_buttons_large.dmi'
					txt = "Quest Available: <font color = green>Now<font color = white>\n\nHighest Microwaves Experienced: 0\n\nHighest Time: 0 seconds\n\nCurrent Time: 0 seconds\n\nTime Needed: 30 seconds"
					steps_needed = 30
					force_talent_gain = 1
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.lvl_parts = list("Organ")
								src.lvl_parts_num = 1
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				env_rads
					info_name = "Endure Radiation"
					txt_title = "Endure the Radiation"
					hud_x = 42
					icon = 'tech_expand_buttons_large.dmi'
					txt = "Quest Available: <font color = green>Now<font color = white>\n\nHighest Time: 0 seconds\n\nCurrent Time: 0 seconds\n\nTime Needed: 30 seconds"
					steps_needed = 30
					regen_talent_gain = 1
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.lvl_parts = list("Skin")
								src.lvl_parts_num = 1
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year

			quest_stats
				info_name = "Core Stats"
				txt_title = "Core Stat Quests"
				hud_x = 26
				New()
					spawn(10)
						if(src && src.setup == 0)
							src.name = src.info_name
							src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
							src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
							src.setup = 1
							src.available = global.year
				test_energy
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				test_power
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				test_strength
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				test_endurance
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				test_agility
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				test_force
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				test_resistance
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				test_offence
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				test_defence
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				test_regen
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				test_recovery
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year

			quest_needs
				info_name = "Survival"
				txt_title = "Survival Quests"
				hud_x = 26
				increase_steps = 0
				New()
					spawn(10)
						if(src && src.setup == 0)
							src.name = src.info_name
							src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
							src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
							src.setup = 1
							src.available = global.year
							src.buttons = list(new /:needs_hunger_high,new /:needs_hunger_low,new /:needs_rare_food,new /:needs_rest_high,new /:needs_rest_low,new /:needs_thirst_high,new /:needs_thirst_low)
				needs_hunger_high
					hud_x = 42
					info_name = "Well Fed"
					txt_title = "Become Well Fed"
					icon = 'tech_expand_buttons_large.dmi'
					txt = "Quest Available: <font color = green>Now<font color = white>\n\nGain the Well Fed status: 0/1"
					steps_needed = 1
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				needs_hunger_low
					hud_x = 42
					info_name = "Hungry"
					txt_title = "Become Hungry"
					icon = 'tech_expand_buttons_large.dmi'
					txt = "Quest Available: <font color = green>Now<font color = white>\n\nGain the Hungry status: 0/1"
					steps_needed = 1
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				needs_thirst_high
					hud_x = 42
					info_name = "Hydrated"
					txt_title = "Become Hydrated"
					icon = 'tech_expand_buttons_large.dmi'
					txt = "Quest Available: <font color = green>Now<font color = white>\n\nGain the Hydrated status: 0/1"
					steps_needed = 1
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				needs_thirst_low
					hud_x = 42
					info_name = "Thirsty"
					txt_title = "Become Thirsty"
					icon = 'tech_expand_buttons_large.dmi'
					txt = "Quest Available: <font color = green>Now<font color = white>\n\nGain the Thirsty status: 0/1"
					steps_needed = 1
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				needs_rest_high
					hud_x = 42
					info_name = "Well Rested"
					txt_title = "Become Well Rested"
					icon = 'tech_expand_buttons_large.dmi'
					txt = "Quest Available: <font color = green>Now<font color = white>\n\nGain the Well Rested status: 0/1"
					steps_needed = 1
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				needs_rest_low
					hud_x = 42
					info_name = "Tired"
					txt_title = "Become Tired"
					icon = 'tech_expand_buttons_large.dmi'
					txt = "Quest Available: <font color = green>Now<font color = white>\n\nGain the Tired status: 0/1"
					steps_needed = 1
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				needs_rare_food
					hud_x = 42
					info_name = "Rare Food"
					txt_title = "Consume Rare Food"
					icon = 'tech_expand_buttons_large.dmi'
					txt = "Quest Available: <font color = green>Now<font color = white>\n\nEat rare food: 0/1"
					steps_needed = 1
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year

			quests_general
				info_name = "Misc"
				txt_title = "Personal Misc Quests"
				hud_x = 26
				New()
					spawn(10)
						if(src && src.setup == 0)
							src.name = src.info_name
							src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
							src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
							src.setup = 1
							src.available = global.year
							src.buttons = list(new /:gen_meditate,new /:gen_win_battle,new /:gen_teach,new /:gen_build,new /:gen_travel,new /:gen_ascend,new /:gen_gather_resources,new /:gen_life_and_death,new /:gen_lvl_research,new /:gen_lvl_research_specific,new /:gen_scientific_paper,new /:gen_higher_realm,new /:gen_highest_realms,new /:gen_rest_month,new /:gen_true_nature,new /:gen_xp_peace,new /:gen_xp_chaos,new /:gen_write_manual,new /:gen_psiforged)
				gen_lvl_research
					hud_x = 42
					info_name = "Research"
					txt_title = "Research a Technology"
					icon = 'tech_expand_buttons_large.dmi'
					txt = "Quest Available: <font color = green>Now<font color = white>\n\nResearch any technology: 0/1"
					rsc_gain = 100000
					steps_needed = 1
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				gen_lvl_research_specific
					hud_x = 42
					icon = 'tech_expand_buttons_large.dmi'
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				gen_gather_resources
					hud_x = 42
					info_name = "Gather Resources"
					txt_title = "Gather Resources"
					icon = 'tech_expand_buttons_large.dmi'
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				gen_xp_peace
					hud_x = 42
					info_name = "Experience Tranquility"
					txt_title = "Experience Tranquility"
					icon = 'tech_expand_buttons_large.dmi'
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				gen_xp_chaos
					hud_x = 42
					info_name = "Experience Chaos"
					txt_title = "Experience Chaos"
					icon = 'tech_expand_buttons_large.dmi'
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				gen_travel
					hud_x = 42
					info_name = "Travel"
					txt_title = "Explore a World"
					icon = 'tech_expand_buttons_large.dmi'
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				gen_win_battle
					hud_x = 42
					info_name = "Battle"
					txt_title = "Win a Battle"
					icon = 'tech_expand_buttons_large.dmi'
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				gen_rest_month
					hud_x = 42
					info_name = "Rest Month"
					txt_title = "Have a Rest Month"
					icon = 'tech_expand_buttons_large.dmi'
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				gen_true_nature
					hud_x = 42
					info_name = "True Nature"
					txt_title = "Discover Your True Self"
					icon = 'tech_expand_buttons_large.dmi'
					repeatable = 0
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				gen_life_and_death
					hud_x = 42
					info_name = "Life & Death"
					txt_title = "Understand Life & Death"
					icon = 'tech_expand_buttons_large.dmi'
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				gen_scientific_paper
					hud_x = 42
					info_name = "Write Paper"
					txt_title = "Write a Scientific Paper"
					icon = 'tech_expand_buttons_large.dmi'
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				gen_teach
					hud_x = 42
					info_name = "Teach"
					txt_title = "Teach Someone"
					icon = 'tech_expand_buttons_large.dmi'
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				gen_write_manual
					hud_x = 42
					info_name = "Write Manual"
					txt_title = "Write a Manual"
					icon = 'tech_expand_buttons_large.dmi'
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				gen_higher_realm
					hud_x = 42
					info_name = "Higher Realm"
					txt_title = "Reach a Higher Realm"
					icon = 'tech_expand_buttons_large.dmi'
					repeatable = 0
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				gen_highest_realms
					info_name = "Highest Realms"
					txt_title = "Reach the Highest Realms"
					icon = 'tech_expand_buttons_large.dmi'
					repeatable = 0
					hud_x = 42
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				gen_meditate
					hud_x = 42
					info_name = "Meditate"
					txt_title = "Deep Meditate"
					icon = 'tech_expand_buttons_large.dmi'
					txt = "Quest Available: <font color = green>Now<font color = white>\n\nHighest Time: 0 seconds\n\nCurrent Time: 0 seconds\n\nTime Needed: 30 seconds"
					steps_needed = 60
					eng_gain = 100
					divine_eng_gain = 50
					dark_matter_gain = 25
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				gen_ascend
					hud_x = 42
					info_name = "Ascend"
					txt_title = "Ascend"
					icon = 'tech_expand_buttons_large.dmi'
					repeatable = 0
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				gen_build
					hud_x = 42
					info_name = "Build"
					txt_title = "Build a Home"
					icon = 'tech_expand_buttons_large.dmi'
					steps_needed = 30
					rsc_gain = 10000
					str_gain = 10
					repeatable = 0
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year
				gen_psiforged
					hud_x = 42
					info_name = "Psiforged"
					txt_title = "Become Psiforged"
					icon = 'tech_expand_buttons_large.dmi'
					repeatable = 0
					New()
						spawn(10)
							if(src && src.setup == 0)
								src.name = src.info_name
								src.maptext = "[css_outline]<font size = 2><text align=left valign=top>[src.info_name]"
								src.txt = "[src.create_reward_desc()]\n\n[src.txt]"
								src.setup = 1
								src.available = global.year

		race_specific
			info_name = "Racial"

		world_quests
			info_name = "World"
			r_lich
				layer = 102
				maptext = "Danse Macabre"
				Click()
					for(var/obj/quests/r in usr.quests)
						usr.client.screen -= r.rum
						usr.client.screen -= r.lor
					usr.client.screen += src.rum
					usr.client.screen += src.lor
				New()
					spawn(10)
						if(src.player)
							var/obj/hud/menus/menu_text/rumour = new
							rumour.maptext_height = 250;
							rumour.maptext_x = 112;
							rumour.maptext_y = 132;
							rumour.screen_loc = "1,1"
							rumour.maptext = "<font face = 'Arial'><font size = 1.5><text valign=top><text halign=left>\
							Rumour has it...That a cold and most unatural wind blows in the North, perpetuated by some, as of yet, unforseen hand. \
							Tales speak of an ancient temple, perhaps a tomb, half-buried in the snow. \
							<p>None can easily survive long in this dreaded land, an everwinter hellscape protected by razor-wind storms of a omnious nature."
							src.rum = rumour

							var/obj/hud/menus/menu_text/lore = new
							lore.maptext_x = 220
							lore.maptext_y = 280
							lore.maptext_width = 432;
							lore.screen_loc = "1,1"
							lore.maptext = "<text valign=top><text halign=left>\
							A cold wind on Earth flows like frostborne death incarnate, permafrost made manifest unto unlife upon the foundations of that lightless tomb. \
							Psionic razor-wind flows, flecks like blades, giving way to an ethereal coalescing of a spirit most unfathomable. \
							Bathed in time immemorial, the ancient one slumbers, skeletal-horror of ages; incarnation of entropy-defiant."
							src.lor = lore
			r_demon_lord
				layer = 102
				Click()
					for(var/obj/quests/r in usr.quests)
						usr.client.screen -= r.rum
						usr.client.screen -= r.lor
					usr.client.screen += src.rum
					usr.client.screen += src.lor
				New()
					spawn(10)
						if(src.player)
							var/obj/hud/menus/menu_text/rumour = new
							rumour.maptext_height = 250;
							rumour.maptext_x = 112;
							rumour.maptext_y = 132;
							rumour.screen_loc = "1,1"
							rumour.maptext = "<font size = 1><text valign=top><text halign=left>\
							Rumour has it...Through a feeling that transcends time, space and all reasoning, you feel in your very bones a terrible evil festering in some far off place or realm.<p>\
							Like a baleful beacon that beckons as a challenge to all the universe, it thums with psionic power the likes you have never sensed. \
							<p><br>Purest malice and negative energy, emotion ingited into a furious and condensed form. <p><br>Whatever it is, it is old and it is powerful.\
							  Perhaps there is a way you know to find this being, within a realm of pure psionic power..."
							src.rum = rumour

							var/obj/hud/menus/menu_text/lore = new
							lore.maptext_x = 220
							lore.maptext_y = 280
							lore.maptext_width = 432
							lore.screen_loc = "1,1"
							lore.maptext = "<font size = 1><text valign=top><text halign=left>\
							Doom come calling, tempered in fires of rage, quenched in shadow-black emotion.<br>\
							Mark of the beast, entwined within psiforged-flesh, coiling tendril that strangles the soul.<br>\
							Master of the dammed, puppeteer string-manipulator of the strands of fate.<br>\
							Quicksilver swirl of sudden death within the thrice-cursed storm of creation unending."
							src.lor = lore
mob
	proc
		check_quest(var/t,var/add_steps = 0,var/add_time = 0,var/cd = 0,var/obj/o)
			if(src.hud_contacts && src.started)
				var/obj/hud/menus/contacts_background/c = src.hud_contacts
				var/obj/quests/q = c.organized_quests[t]
				if(q && q.available-global.year <= 0)
					if(q.setup_part && o && o.type == q.setup_part)
						q.steps_completed += add_steps
					else q.steps_completed += add_steps
					q.time += add_time
					if(q.time > q.time_highest) q.time_highest = q.time
					q.apply_reward_stats(src,global.year+cd)
				if(src && src.HUD)
					src.HUD.Rescale_HUD(src)
		check_quest_availability()
			if(src.hud_contacts && src.started)
				var/obj/hud/menus/contacts_background/c = src.hud_contacts
				for(var/obj/quests/q in c.total_quests)
					q.quest_txt(src)
					if(q.repeatable && global.year >= q.available && q.completed)
						q.completed = 0
						q.time = 0
						q.steps_completed = 0
						q.hud_x = initial(q.hud_x)
						//src.set_alert("Quest Available: [q]",'alert.dmi',"alert")
						//src.create_chat_entry("alerts","Quest Available: <font color = yellow>[q]<font color = white>")
						if(src.open_contacts) src.hud_contacts.quests(src)
				//if(src && src.HUD)
				//	src.HUD.Rescale_HUD(src)
