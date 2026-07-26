mob
	verb
		adjust_strength()
			set hidden = 1
			set name = ".adjust_strength"
			var/v = winget(usr,"stats_other.bar_adjust_strength","value")
			v = round(text2num(v))
			if(v < 0.01) v = 0.01
			usr.mod_str_usage = v / 100
			winset(usr,"stats_other.str_adjust_percent","text=[v]%")
			if(usr.skill_psi_clone)
				for(var/mob/m in usr.skill_psi_clone.active_splits)
					m.mod_str_usage = v / 100
			if(usr.skill_divine_weapon)
				for(var/mob/m in usr.skill_divine_weapon.active_splits)
					m.mod_str_usage = v / 100
		adjust_force()
			set hidden = 1
			set name = ".adjust_force"
			var/v = winget(usr,"stats_other.bar_adjust_force","value")
			v = round(text2num(v))
			if(v < 0.01) v = 0.01
			usr.mod_force_usage = v / 100
			winset(usr,"stats_other.force_adjust_percent","text=[v]%")
			if(usr.skill_psi_clone)
				for(var/mob/m in usr.skill_psi_clone.active_splits)
					m.mod_force_usage = v / 100
			if(usr.skill_divine_weapon)
				for(var/mob/m in usr.skill_divine_weapon.active_splits)
					m.mod_force_usage = v / 100
mob
	proc
		stats_mods()
			/*
			.:So how this work is:.

			mod_base
				- gains_trained + gains_psiforged + gains_items = mod_base

			gains_temp_mod
				- mod_current - mod_base = gains_temp_mod

			stat_base
				- gains_trained + gains_psiforged + gains_items x mod_base = stat_base

			gains_temp_stat
				- stat - stat_base = gains_temp_stat

			gains_temp_stat vars are NOT used to calculate power/energy, and should NOT be used to do so
				- Only for visual representation
				- The actual temp stats are baked into the real stat calculations by default
			*/

			//Mods
			src.mod_psionic_power_base = src.gains_trained_power_mod + src.gains_psiforged_power_mod + src.gains_items_power_mod
			src.gains_temp_power_mod = round(src.mod_psionic_power - src.mod_psionic_power_base,0.01)

			src.mod_energy_base = src.gains_trained_energy_mod + src.gains_psiforged_energy_mod + src.gains_items_energy_mod
			src.gains_temp_energy_mod = round(src.mod_energy - src.mod_energy_base,0.01)

			src.mod_strength_base = src.gains_trained_strength_mod + src.gains_psiforged_strength_mod + src.gains_items_strength_mod
			src.gains_temp_strength_mod = round(src.mod_strength - src.mod_strength_base,0.01)

			src.mod_endurance_base = src.gains_trained_endurance_mod + src.gains_psiforged_endurance_mod + src.gains_items_endurance_mod
			src.gains_temp_endurance_mod = round(src.mod_endurance - src.mod_endurance_base,0.01)

			src.mod_force_base = src.gains_trained_force_mod + src.gains_psiforged_force_mod + src.gains_items_force_mod
			src.gains_temp_force_mod = round(src.mod_force - src.mod_force_base,0.01)

			src.mod_resistance_base = src.gains_trained_resistance_mod + src.gains_psiforged_resistance_mod + src.gains_items_resistance_mod
			src.gains_temp_resistance_mod = round(src.mod_resistance - src.mod_resistance_base,0.01)

			src.mod_agility_base = src.gains_trained_agility_mod + src.gains_psiforged_agility_mod + src.gains_items_agility_mod
			src.gains_temp_agility_mod = round(src.mod_agility - src.mod_agility_base,0.01)

			src.mod_offence_base = src.gains_trained_off_mod + src.gains_psiforged_off_mod + src.gains_items_off_mod
			src.gains_temp_off_mod = round(src.mod_offence - src.mod_offence_base,0.01)

			src.mod_defence_base = src.gains_trained_def_mod + src.gains_psiforged_def_mod + src.gains_items_def_mod
			src.gains_temp_def_mod = round(src.mod_defence - src.mod_defence_base,0.01)

			src.mod_regeneration_base = src.gains_trained_regen_mod + src.gains_psiforged_regen_mod + src.gains_items_regen_mod
			src.gains_temp_regen_mod = round(src.mod_regeneration - src.mod_regeneration_base,0.01)

			src.mod_recovery_base = src.gains_trained_recov_mod + src.gains_psiforged_recov_mod + src.gains_items_recov_mod
			src.gains_temp_recov_mod = round(src.mod_recovery - src.mod_recovery_base,0.01)

			//Tolerances
			src.immune_rads_base = src.immune_rads_trained + src.immune_rads_psiforged + src.immune_rads_items
			src.immune_rads_temp = round(src.mod_immune_rads - src.immune_rads_base,0.01)

			src.immune_cold_base = src.immune_cold_trained + src.immune_cold_psiforged + src.immune_cold_items
			src.immune_cold_temp = round(src.mod_immune_cold - src.immune_cold_base,0.01)

			src.immune_heat_base = src.immune_heat_trained + src.immune_heat_psiforged + src.immune_heat_items
			src.immune_heat_temp = round(src.mod_immune_heat - src.immune_heat_base,0.01)

			src.immune_gravity_base = src.immune_gravity_trained + src.immune_gravity_psiforged + src.immune_gravity_items
			src.immune_gravity_temp = round(src.mod_immune_gravity - src.immune_gravity_base,0.01)

			src.immune_microwaves_base = src.immune_microwaves_trained + src.immune_microwaves_psiforged + src.immune_microwaves_items
			src.immune_microwaves_temp = round(src.mod_immune_microwaves - src.immune_microwaves_base,0.01)

			src.immune_toxins_base = src.immune_toxins_trained + src.immune_toxins_psiforged + src.immune_toxins_items
			src.immune_toxins_temp = round(src.mod_immune_toxins - src.immune_toxins_base,0.01)

			//Stats
			//src.psionic_power_base = (src.gains_trained_power + src.gains_psiforged_power + src.gains_items_power - src.injury_power)*src.mod_psionic_power_base
			src.gains_temp_power = round(src.psionic_power - src.psionic_power_base,0.01)

			//if(src.energy_max < 0) src.energy_max = 100
			//src.energy_max = (src.gains_trained_energy + src.gains_psiforged_energy + src.gains_items_energy - src.injury_energy)*10

			src.energy_base = (src.gains_trained_energy + src.gains_psiforged_energy + src.gains_items_energy - src.injury_energy)*src.mod_energy_base
			src.gains_temp_energy = round(src.energy_max - src.energy_base,0.01)
			/*
			world << "DEBUG - trained: [src.gains_trained_energy]"
			world << "DEBUG - psiforged: [src.gains_psiforged_energy]"
			world << "DEBUG - items: [src.gains_items_energy]"
			world << "DEBUG - injury: [src.injury_energy]"
			world << "DEBUG - energy_mod_base: [src.mod_energy_base]"
			*/

			src.strength_base = (src.gains_trained_strength + src.gains_psiforged_strength + src.gains_items_strength - src.injury_strength)*src.mod_strength_base
			src.gains_temp_strength = round(src.strength - src.strength_base,0.01)

			src.endurance_base = (src.gains_trained_endurance + src.gains_psiforged_endurance + src.gains_items_endurance - src.injury_endurance)*src.mod_endurance_base
			src.gains_temp_endurance = round(src.endurance - src.endurance_base,0.01)

			src.force_base = (src.gains_trained_force + src.gains_psiforged_force + src.gains_items_force - src.injury_force)*src.mod_force_base
			src.gains_temp_force = round(src.force - src.force_base,0.01)

			src.resistance_base = (src.gains_trained_resistance + src.gains_psiforged_resistance + src.gains_items_resistance - src.injury_resistance)*src.mod_resistance_base
			src.gains_temp_resistance = round(src.resistance - src.resistance_base,0.01)

			src.offence_base = (src.gains_trained_off + src.gains_psiforged_off + src.gains_items_off - src.injury_off)*src.mod_offence_base
			src.gains_temp_off = round(src.offence - src.offence_base,0.01)

			src.defence_base = (src.gains_trained_def + src.gains_psiforged_def + src.gains_items_def - src.injury_def)*src.mod_defence_base
			src.gains_temp_def = round(src.defence - src.defence_base,0.01)
		stats()
			//if(src.energy_max < 0) src.energy_max = 100
			src.energy_max = (src.gains_trained_energy + src.gains_psiforged_energy + src.gains_items_energy - src.injury_energy)
			if(percent_energy<=30 && !fatiguealert)
				view(src)<<output("<font color=#e6b800>[src] looks fatigued!</font>","actionoutput")
				fatiguealert=1
			if(percent_health<=30 && !unconsciousalert)
				view(src)<<output("<font color=#e6b800>[src] looks almost unconscious!","actionoutput")
				unconsciousalert=1
			if(percent_health>30 && unconsciousalert) unconsciousalert=0
			if(percent_energy>30 && fatiguealert) fatiguealert=0
			//src.stats_mods()
			//Health recovery & Energy recovery
			//Anger Stuff
			//movement_speed = (10/src.mod_agility)/(weight/100)

			//src.create_chat_entry("local","Movement Speed:[movement_speed] , Agility Mod: [mod_agility], Weight: [weight]",0,1)
			src.get_anger_power_boost()
			src.fplm_checker()
			//movement_speed = max(0.1, min(1.3, 1.3 - ((src.mod_agility ** 1.4) * 0.25) + (sqrt(weight) * 0.03)))
			//movement_speed = max(0.6, min(1.12, 1.12 - ((src.mod_agility ** 1.4) * 0.25) + (sqrt(weight) * 0.03) + ((100 - src.hp) * 0.006)))
			//movement_speed = clamp(3.5 - (mod_agility * 0.05), 0.6, 3.8)
			//movement_speed = clamp(3.8 - (mod_agility * 0.1), 0.6, 3.8)
			//movement_speed = clamp((3 + mod_agility) * 0.1,0.8,5)
			var/lift_raw = src.strength + (src.endurance * 4)
			var/lift_kg = round(4.5 + lift_raw * 0.45359237 * 0.01, 0.01)
			var/lift_lbs = round(4.5 + lift_raw * 0.01, 0.01)
			src.lift_raw = lift_raw
			src.lift_kg = lift_kg
			src.lift_lbs = lift_lbs
			//src<<"Lift KG: [lift_kg] | Lift LB: [lift_lbs] | Lift Raw: [lift_raw]"
			if(src.KB <= 0)
				if(src.koed == 0)
					if(src.percent_health <= 0)
						src.KO() // Checked V 0.10 for crashes
						src.percent_health = 0
					else
						//Regenerate health
						if(percent_health < 100 && percent_health >0)
							if(icon_state == "Meditate" && skill_meditation && skill_meditation.active || icon_state == "Meditate" && skill_sleep && skill_sleep.active ) percent_health += 0.65*mod_regeneration
							else
								if(rp_mode == null || !rp_mode) percent_health += 0.3*mod_regeneration
								//if(rp_mode == "Roleplay") continue
								else if(rp_mode == "Phase") percent_health += 0.1*mod_regeneration

							if(anger >100 )
								anger -= 0.3
								if(anger<100) anger = 100
								if(anger_phase == null ) anger_check()
						if(percent_health > 100) percent_health = 100
						//Flush toxins slowly
						if(src.toxicity > 0)
							src.toxicity -= (0.01*mod_regeneration)*(1+src.mod_immune_toxins)
							if(src.toxicity <= 0) src.toxicity = 0
							if(src.toxicity >= 200)
								src.KO() // Checked V 0.10 for crashes
								src.percent_health = 0
						//Energy recovery
						if(percent_energy<100)
							var/gain_eng = 0
							if(mortal) gain_eng = 1
							else if(z == 2 || z == 6) gain_eng = 1
							else gain_eng = (src.organ_grow/src.total_organs)+0.1
							if(icon_state == "Meditate" && skill_sleep && skill_sleep.active) energy += (0.2*energy_max*mod_recovery)*gain_eng
							else if(icon_state == "Meditate" && skill_meditation && skill_meditation.active) energy += (0.1*energy_max*mod_recovery)*gain_eng
							else
								if(rp_mode == null || !rp_mode) energy += (0.005*energy_max*mod_recovery)*gain_eng
							//	else if(rp_mode == "Roleplay") continue
								else if(rp_mode == "Phase") energy += (0.001*energy_max*mod_recovery)*gain_eng
						if(energy > energy_max) energy = energy_max
						if(energy < 0) energy = 0
						//Divine energy recovery
						divine_energy += 0.01*divine_energy_mod
						if(src.skill_meditation && src.skill_meditation.active || src.skill_active_meditation && src.skill_active_meditation.active) divine_energy += 0.01*divine_energy_mod
						if(divine_energy < 0) divine_energy = 0
						//Heal limbs over time
						// =============================
						// Limb Regeneration (New System)
						// =============================
						src.check_body_health()










					/*	for(var/obj/body_related/p in src.hurt_limbs)
							if(p.disabled_perma == 0)
								if(src.bandaged == 0)
									p.hp += (0.06*mod_regeneration)*rand(1,1.3)
									if(icon_state == "Meditate") p.hp += (0.08*mod_regeneration)*rand(1,1.5)
								if(src.bandaged == 1)
									p.hp += (0.1*mod_regeneration)*rand(1,1.5)
									if(icon_state == "Meditate") p.hp += (0.1*mod_regeneration)*rand(1,2)
								p.set_part_color()
								if(src.hud_body) src.hud_body.color_paperdoll(src)
								//if(src.hud_paperdoll) src.hud_paperdoll.color_paperdoll(src)
								if(p.hp >= 100)
									p.hp = 100
									if(p.damaged)
										src.damage_part(p, 0)
										//If its a bone, find all the parts connected to it and enable them also.
										if(p.bodypart_type == "Bone" && src.has_body)
											var/list/extensions = list()
											for(var/obj/body_related/x in p.loc)
												if(x.part_hierarchy < p.part_hierarchy)
													extensions += x
											src.disable_parts(extensions,0,0)
									src.hurt_limbs -= p*/
				else if(src.toxicity >= 200)
					src.Death("Toxicity buildup",1)
			//Dynamically adjust hp bars
			if(src.change_hp != src.percent_health && src.hud_hp_bar_inner)
				var/obj/bar_hp = src.hud_hp_bar_inner
				var/matrix/m = matrix()
				m.Scale(src.percent_health*2,1)
				m.Translate(src.percent_health,0)
				bar_hp.transform = m
				var/obj/hud/bars/player_hp/hp = bar_hp.loc
				if(hp && hp.txt_percent) hp.txt_percent.maptext = "<font size = 1> <text align=center valign=top>[css_outline][round(src.percent_health)]%"

			//Power Calculations
			//percent_power = (percent_health*0.01)*100
			percent_energy = (energy/energy_max)*100
			if(percent_energy > 100) percent_energy = 100
			var/Health_Multiplier=percent_health/100
			var/Energy_Multiplier=percent_energy/100

			var/chosen_pp = 1
			var/ppcent = round((hp*0.01)*(energy/energy_max)*(power_percent)*(anger/100))
			if(icon_state == "KO") Health_Multiplier=1
			if(origin && istype(origin,/obj/origins/chosen_one))
				if(chosen_ones <= 0) chosen_ones = 1
				chosen_pp = 1+(1/chosen_ones)





		//	src.bodyhealth = 100
			//src.bodypcnt = (round(percent_power*0.01) + round(percent_energy)) - 1 //- 100
			if(src.Body) src.BodyPcnt()
			if(src.dead && !src.has_body)
				src.psionic_power = ((src.psionic_power_base*0.125)+((src.gains_trained_power + src.gains_psiforged_power + src.gains_items_power - src.injury_power)+gravity_mastered+current_transformation_boost)*chosen_pp*Energy_Multiplier*Health_Multiplier*anger_phase*kaioken_pl)*Body/weight*(power_percent/100)*0.1
			else
				src.psionic_power = ((src.psionic_power_base*0.125)+((src.gains_trained_power + src.gains_psiforged_power + src.gains_items_power - src.injury_power)+gravity_mastered+current_transformation_boost)*chosen_pp*Energy_Multiplier*Health_Multiplier*anger_phase*kaioken_pl)*Body/weight*(power_percent/100)
		//	src.create_chat_entry("alerts","PL: [src.psionic_power]")
		//	src.create_chat_entry("alerts","Prime: [src.prime]")
			if(psionic_power <= 0) psionic_power = 1;
			//if(dead) psionic_power /= 2
			if(src.hud_pp) src.hud_pp.maptext = "<font size = 1> <text align=left>[css_outline]Power: [Commas(ppcent)]%"
			//if(percent_power<0.01) percent_power=0.01
			//KO Recovery
			if(ko_time_max && ko_time)
				ko_time -= 10
				if(ko_time < 0) ko_time = 0
				if(ko_time > 0) percent_ko = (ko_time/ko_time_max)*100
			//Dynamically adjust eng bars
			if(race=="Namekian" && hunger <200) hunger = 200

			if(src.change_eng != src.percent_energy && src.hud_eng_bar_inner)
				var/obj/bar_eng = src.hud_eng_bar_inner
				var/matrix/m = matrix()
				m.Scale(src.percent_energy*2,1)
				m.Translate(src.percent_energy,0)
				bar_eng.transform = m
				var/obj/hud/bars/player_eng/eng = bar_eng.loc
				if(eng && eng.txt_percent) eng.txt_percent.maptext = "<font size = 1> <text align=center valign=top>[css_outline][round(src.percent_energy)]%"
			src.change_eng = src.percent_energy
			src.change_hp = src.percent_health
			src.tech_unlocking(src)

		check_body_health()
			set background = 1
			var/limb_updated = FALSE
			for(var/obj/body_related/bodyparts/limb in src.body)

				if(!limb) continue
				if(limb.disabled_perma) continue
				if(limb.hp >= limb.hp_max) continue

				var/heal_amount = 0

			    // Base regen
				if(src.bandaged)
					heal_amount = 0.10 * src.mod_regeneration
				else
					heal_amount = 0.025 * src.mod_regeneration

			    // Meditation bonus
				if(icon_state == "Meditate")
					heal_amount *= 1.1

			    // Slight variance for organic feel (optional but safe)
				heal_amount *= rand(100,130) / 100

				limb.hp += heal_amount

				if(limb.hp >= limb.hp_max)
					limb.hp = limb.hp_max

					 // Restore state if fully healed
					if(limb.damaged || limb.disabled)
						limb.damaged = 0
						limb.disabled = 0

				limb_updated = TRUE


			// Update HUD only once if needed
			if(limb_updated)
				if(src.hud_body)
					src.hud_body.color_paperdoll(src)

				src.update_limb_hud()
		gain_stat(var/stat,var/multi=1,var/exp = 25,var/source,var/remove_source = 0,var/divider = 1)
			var/traintype
			if(src.part_focus) //Finish training limb part and adjust stats as reward.
				var/obj/body_related/bodyparts/part = src.part_focus
				//Can train a Dantian without a body, but only if meditating.
				if(part.type == /obj/body_related/bodyparts/meridians/dantian)
					if(src.skill_meditation && src.skill_meditation.active)
						part.part_reward(src,exp)
					else if(src.skill_active_meditation && src.skill_active_meditation.active)
						part.part_reward(src,exp)
				//Otherwise, probably training a bodypart instead.
				else part.part_reward(src,exp)
			// **HTT Factor: Determines gain bonuses or penalties**
			var/htt_multiplier = 2
			//src.create_chat_entry("local","Pre: [htt_multiplier] - HTT (Current HTT: [src.HTT])",0,1)
			if(src.HTT >=215)
				htt_multiplier = 3
			if(src.HTT < 125)
				htt_multiplier = 1
				multi = 1 // Below 100 HTT? No gains at all.
			//src.create_chat_entry("local","Post: [htt_multiplier] - HTT (Current HTT: [src.HTT])",0,1)
			if(htt_multiplier !=0)
				exp = exp * (htt_multiplier)
				multi = multi * (htt_multiplier)

			if(src.trait_prodigy) exp *=1.25 //Put this here, because we want this trait to increase combat stat gains, and not both psiforging exp AND combat stat gains
			if(!src.cycle_free_time)
				if(source == "Meditation" && !src.cycle_free_time)
					if(src.medres>=src.max_medres && !cycle_free_time)
						if(prob(50))src <<"<font color = white>You have become resilient to this form of training. (Meditating)"
						call(src.skill_meditation.act)(src,src.skill_meditation)
						//src << "<font color = white>You have become resilient to this form of training. (Meditating)"
						//src.set_alert("You have become resilient to this form of training. (Meditating)",'alert.dmi',"alert")
						return

					else
						traintype=src.medres
						if(src.med_ressed==0)
							if(!src.cycle_free_time)
								if(src.medres<src.max_medres)
								//	switch(src.bodysize)

									//	if(3) src.medres+=1.5
									src.medres+=1.3
									//	if(1) src.medres+=1.1
									//src.medres += max(2.5 / (1 + (src.mod_agility * 3.5)), 0.2)//2.5 / (1 + (src.mod_agility * 3.5))
								//	src.create_chat_entry("local","[max(2.5 / (1 + (src.mod_agility * 3.5)), 0.2)] - Res Gain (Med Res:[src.medres])",0,1)
									if(src.medres>=src.max_medres)
										src.medres=100
								if(src.medres>=src.max_medres && !cycle_free_time)
									src.med_ressed=1
									src.sparres=0
									if(src.spar_ressed==1)
										src.spar_ressed=0
									//alerts
									if(src.race == "Changeling") exp = (exp/2)
									else exp *=0.100
									src << "<font color = white>You have become resilient to this form of training. (Meditating)"
									src.set_alert("You have become resilient to this form of training. (Meditating)",'alert.dmi',"alert")
									if(src.skill_meditation && src.skill_meditation.active) call(src.skill_meditation.act)(src,src.skill_meditation)

						else if(!cycle_free_time)
							if(src.race == "Changeling" ) exp = (exp/2)
							else exp *=0.100
						//	exp*=0.125
							if(prob(1))
								src << "<font color = white>You have become resilient to this form of training. (Meditating)"
								if(prob(10)) src.set_alert("You have become resilient to this form of training. (Meditating)",'alert.dmi',"alert")
								if(src.skill_meditation && src.skill_meditation.active) call(src.skill_meditation.act)(src,src.skill_meditation)


				if(source == "Self Train" && !src.cycle_free_time)
					if(!src.cycle_free_time)
						if(src.trainres>=src.max_trainres && !src.cycle_free_time)
							if(prob(50))src <<"<font color = white>You have become resilient to this form of training. (Training)"
							if(src.skill_selftrain && src.skill_selftrain.active)
								call(src.skill_selftrain.act)(src,src.skill_selftrain)
							//src <<"<font color = white>You have become resilient to this form of training. (Training)"
							//src.set_alert("You have become resilient to this form of training. (Training)",'alert.dmi',"alert")
							//return

						traintype=src.trainres
						if(src.train_ressed==0)
							if(!src.cycle_free_time)
								if(src.trainres<src.max_trainres)
									//switch(src.bodysize)

									//	if(3) src.trainres+=0.7
									src.trainres+=0.5
									//	if(1) src.trainres+=0.3
									//src.trainres+= max(2.5 / (1 + (src.mod_agility * 3.5)), 0.2)//2.5 / (1 + (src.mod_agility * 3.5))
								//	src.create_chat_entry("local","[max(2.5 / (1 + (src.mod_agility * 3.5)), 0.2)] - Res Gain (Train Res:[src.trainres])",0,1)

									if(src.trainres>=src.max_trainres)
										src.trainres=100
								if(src.trainres>=src.max_trainres)

									src.blastres=0
									src.medres=0
									if(src.blast_ressed==1) src.blast_ressed=0
									if(src.med_ressed==1) src.med_ressed=0
									src.train_ressed=1
									//alerts
									if(src.race == "Changeling") exp = (exp/2)
									else exp *=0.100
									//exp *=0.125
									src <<"<font color = white>You have become resilient to this form of training. (Training)"
									src.set_alert("You have become resilient to this form of training. (Training)",'alert.dmi',"alert")


									if(src.skill_selftrain && src.skill_selftrain.active) call(src.skill_selftrain.act)(src,src.skill_selftrain)

						else if(!cycle_free_time)
							if(src.race == "Changeling") exp = (exp/2)
							else exp *=0.100
							//exp*=0.125
							if(prob(2))
								src <<"<font color = white>You have become resilient to this form of training. (Training)"
								src.set_alert("You have become resilient to this form of training. (Training)",'alert.dmi',"alert")
								if(src.skill_selftrain && src.skill_selftrain.active) call(src.skill_selftrain.act)(src,src.skill_selftrain)

				if(source == "From Blast skill" && !src.cycle_free_time || source == "From Charge Blast skill" && !src.cycle_free_time || source == "From Destructo Disk skill" && !src.cycle_free_time )
					traintype=src.blastres
					if(src.blast_ressed==0 )
						if(!src.cycle_free_time)
							if(src.blastres<src.max_blastres)
								//switch(src.bodysize)

								//	if(3) src.blastres+=1.5
								src.blastres+=1.3
								//	if(1) src.blastres+=1.1
								//src.blastres+=max(5.0 / (1 + (src.mod_agility * 3.5)), 0.5)//5.0 / (1 + (src.mod_agility * 3.5))
							//	src.create_chat_entry("local","[max(5.0 / (1 + (src.mod_agility * 3.5)), 0.2)] - Res Gain (Blast Res:[src.blastres])",0,1)

								if(src.blastres>=src.max_blastres)
									src.blastres=100
							if(src.blastres>=src.max_blastres)
								src.blast_ressed=1
								src.trainres=0
								src.medres=0
								if(src.train_ressed==1) src.train_ressed=0
								if(src.med_ressed==1) src.med_ressed=0
								//alerts
								if(src.race == "Changeling") exp = (exp/2)
								else exp *=0.100
								//exp *=0.125
								src << "<font color = white>You have become resilient to this form of training. (Blasting)"
								src.set_alert("You have become resilient to this form of training. (Blasting)",'alert.dmi',"alert")

					else if(!cycle_free_time)
						if(src.race == "Changeling") exp = (exp/2)
						else exp *=0.100
					//	exp*=0.125
						if(prob(1))
							src << "<font color = white>You have become resilient to this form of training. (Blasting)"
							src.set_alert("You have become resilient to this form of training. (Blasting)",'alert.dmi',"alert")


				if( source == "Attacking in melee" && !src.cycle_free_time || source == "Defending in melee" && !src.cycle_free_time || source == "Taking melee damage" && !src.cycle_free_time)
					traintype=src.sparres
					if(src.spar_ressed==0)
						if(!src.cycle_free_time)
							if(src.sparres<src.max_sparres)
								//switch(src.bodysize)
									//if(3) src.sparres+=1.5
								src.sparres+=1.3
									//if(1) src.sparres+=1.1
								//src.sparres+= max(2.0 / (1 + (src.mod_agility * 3.5)), 0.2)//2.0 / (1 + (src.mod_agility * 3.5))
							//	src.create_chat_entry("local","[max(2.0 / (1 + (src.mod_agility * 3.5)), 0.2)] - Res Gain (Train Res:[src.sparres])",0,1)
								if(src.sparres>=src.max_sparres)
									src.sparres=100
							if(src.sparres>=src.max_sparres)
								src.spar_ressed=1
								src.blastres=0
								src.trainres=0
								if(src.blast_ressed==1) src.blast_ressed=0
								if(src.train_ressed==1) src.train_ressed=0
								//alerts
								if(src.race == "Changeling") exp = (exp/2)
								else exp *=0.100
							//	exp *=0.125
								src << "<font color = white>You have become resilient to this form of training. (Sparring)"
								src.set_alert("You have become resilient to this form of training. (Sparring)",'alert.dmi',"alert")

					else if(!src.cycle_free_time)
						if(src.race == "Changeling") exp = (exp/2)
						else exp *=0.100
					//	exp*=0.125
						if(prob(1))
							src << "<font color = white>You have become resilient to this form of training. (Sparring)"
							src.set_alert("You have become resilient to this form of training. (Sparring)",'alert.dmi',"alert")

			//200% gains for Celestial, but only if they're meditating.
			//if(src.race == "Kai")
			//	if(src.skill_meditation && src.skill_meditation.active) exp *= 2
			//	else if(src.skill_active_meditation && src.skill_active_meditation.active) exp *= 2
			if(stat == "power")
				if(src.cycle_free_time)
					if(!cftglobal) src.cycle_free_time -= 0.015
					if(src.cycle_free_time <= -0.1 || src.cycle_free_time <= 0.1)
						src.remove_cft()

				else if(offline_gains && !standing_gains_timer)
					src.offline_gains -= 0.01
					if(src.offline_gains <= -0.1)
						src.offline_gains = 0
					else
						exp *= 2
						multi *= 2
				if(standing_gains_timer)
					src.standing_gains_timer --
					exp *= 1.1
					multi *= 1.05
				if(inside_hbtc)
					exp *= 3
					multi *= 3

				src.gaining_power = 1;
				//Update buff obj to display correct info and sources
				if(src.buff_power)
					var/obj/buffs_and_debuffs/b = src.buff_power
					b.active = 1;
					if(source)
						if(src.power_sources && islist(src.power_sources) && src.power_sources.Find(source) == 0) src.power_sources += source
					var/txt = "<br><u>Sources</u>"
					for(var/t in src.power_sources)
						txt = "[txt]<br>[t]."
					b.info_txt.maptext = "<font size = 1><text align=center valign=top>[b.desc][txt]"
					if(remove_source == 1)
						spawn(10)
							if(src && b)
								src.power_sources -= source
				//Proceed with gaining the stat
				src.power_exp += (src.mod_psionic_power+(exp*0.50))
			//	src.create_chat_entry("alerts","+[((exp/4)+(src.gravity_mastered/100)/src.mod_psionic_power)] Power Exp !")
			//	src.create_chat_entry("alerts"," #2ND VERSION - +[((exp/4)+src.mod_psionic_power)] Power Exp !")
				if(src.power_exp >= 10000) src.power_exp = 10000 //Makes sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.xp_power >= 10000) src.xp_power = 10000 //Makes sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.power_exp >= 100)
					while(src.power_exp >= 100)
						src.power_exp = src.power_exp-100
						var/growth_mult = clamp(1 + (src.PG), 1, 10) // PG gives modest scaling
						var/rating_mult = clamp(1 + log(1 + src.rating / 50000), 1, 10) // slows over time
						if(src.in_fplm) src.psionic_power_base += (mod_psionic_power * growth_mult * rating_mult) + src.current_weight_gain
						else src.psionic_power_base += (mod_psionic_power * growth_mult) + src.current_weight_gain
						//src<<"[(mod_psionic_power * growth_mult) + src.current_weight_gain ]+ PL"
						src.gains_trained_power += multi
						src.xp_power += 1;
				if(src.xp_power >= 100)
					while(src.xp_power >= 100)
						src.xp_power = src.xp_power-100
						//if(prob(src.generation_lvl*10))src.passive_points+=1;
					//	if(src.client) winset(src,"skill_pane_power.label_points","text=\"Power Points: [src.skill_points_power]\"")
						//src.set_alert("+1 Power Skill Points",'stat_power.dmi',null)
						//src.create_chat_entry("alerts","+1 Passive Points")

			if(stat == "energy")
				if(src.cycle_free_time)
					if(!cftglobal) src.cycle_free_time -= 0.01
					if(src.cycle_free_time <= -0.1)
						src.remove_cft()

				else if(offline_gains && !standing_gains_timer)
					src.offline_gains -= 0.01
					if(src.offline_gains <= -0.1)
						src.offline_gains = 0
					else
						exp *= 3
						multi *= 3
				if(standing_gains_timer)
					src.standing_gains_timer --
					exp *= 1.35
					multi *= 1.35
				if(inside_hbtc)
					exp *= 4
					multi *= 4
				src.gaining_energy = 1;
				//Update buff obj to display correct info and sources
				if(src.buff_energy)
					var/obj/buffs_and_debuffs/b = src.buff_energy
					b.active = 1;
					if(source)
						if(src.energy_sources && islist(src.energy_sources) && src.energy_sources.Find(source) == 0) src.energy_sources += source
					var/txt = "<br><u>Sources</u>"
					for(var/t in src.energy_sources)
						txt = "[txt]<br>[t]."
					b.info_txt.maptext = "<font size = 1><text align=center valign=top>[b.desc][txt]"
					if(remove_source == 1)
						spawn(10)
							if(src && b)
								src.energy_sources -= source
				//Proceed with gaining the stat
				src.energy_exp += (src.mod_energy+(exp*0.50))//((exp/4)+src.mod_energy)
				//src<<"Gaining Energy"
				if(src.energy_exp >= 10000) src.energy_exp = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.xp_energy >= 10000) src.xp_energy = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.energy_exp >= 100)
					while(src.energy_exp >= 100)
						src.energy_exp = src.energy_exp-100
						var/growth_mult = clamp(1 + (src.PG), 1, 10) // PG gives modest scaling
						src.gains_trained_energy += (exp * mod_energy * growth_mult)
						//src.gains_trained_energy += 1
						src.xp_energy += 1;
				if(src.energy_exp < 0) src.energy_exp = 0
				if(src.xp_energy >= 100)

					while(src.xp_energy >= 100)
						src.xp_energy = src.xp_energy-100

						//if(src.client) winset(src,"skill_pane_engery.label_points","text=\"Energy Points: [src.skill_points_energy]\"")
					//	src.set_alert("+1 Energy Skill Points",'stat_energy.dmi',"energy")
					//	src.create_chat_entry("alerts","+1 Energy Skill Points")

			if(stat == "divine")
				src.gaining_divine = 1;
				//Update buff obj to display correct info and sources
				if(src.buff_divine)
					var/obj/buffs_and_debuffs/b = src.buff_divine
					b.active = 1;
					if(source)
						if(src.divine_sources && islist(src.divine_sources) && src.divine_sources.Find(source) == 0) src.divine_sources += source
					var/txt = "<br><u>Sources</u>"
					for(var/t in src.divine_sources)
						txt = "[txt]<br>[t]."
					b.info_txt.maptext = "<font size = 1><text align=center valign=top>[b.desc][txt]"
					if(remove_source == 1)
						spawn(10)
							if(src && b)
								src.divine_sources -= source
			if(stat == "dark matter")
				src.gaining_dark_matter = 1;
				//Update buff obj to display correct info and sources
				if(src.buff_dark_matter)
					var/obj/buffs_and_debuffs/b = src.buff_dark_matter
					b.active = 1;
					if(source)
						if(src.dark_matter_sources && islist(src.dark_matter_sources) && src.dark_matter_sources.Find(source) == 0) src.dark_matter_sources += source
					var/txt = "<br><u>Sources</u>"
					for(var/t in src.dark_matter_sources)
						txt = "[txt]<br>[t]."
					b.info_txt.maptext = "<font size = 1><text align=center valign=top>[b.desc][txt]"
					if(remove_source == 1)
						spawn(10)
							if(src && b)
								src.dark_matter_sources -= source

			if(stat == "strength")
				if(src.cycle_free_time)
					if(!cftglobal) src.cycle_free_time -= 0.015
					if(src.cycle_free_time <= -0.1)
						src.remove_cft()

				else if(offline_gains && !standing_gains_timer)
					src.offline_gains -= 0.01
					if(src.offline_gains <= -0.1)
						src.offline_gains = 0
					else
						exp *= 3
						multi *= 3
				if(standing_gains_timer)
					src.standing_gains_timer --
					exp *= 1.35
					multi *= 1.35
				if(inside_hbtc)
					exp *= 4
					multi *= 4
				src.gaining_strength = 1;
				//Update buff obj to display correct info and sources
				if(src.buff_strength)
					var/obj/buffs_and_debuffs/b = src.buff_strength
					b.active = 1;
					if(source)
						if(src.strength_sources && islist(src.strength_sources) && src.strength_sources.Find(source) == 0) src.strength_sources += source
					var/txt = "<br><u>Sources</u>"
					for(var/t in src.strength_sources)
						txt = "[txt]<br>[t]."
					b.info_txt.maptext = "<font size = 1><text align=center valign=top>[b.desc][txt]"
					if(remove_source == 1)
						spawn(10)
							if(src && b)
								src.strength_sources -= source
				//Proceed with gaining the stat
				var/experience_pts
				switch(src.bodysize)
					if(1)
						experience_pts = 20
					if(2)
						experience_pts = 15
					if(3)
						experience_pts = 10
				src.strength_exp += experience_pts+(exp*multi)//(exp+multi)///(src.mod_strength) * 1.25
				if(src.strength_exp >= 10000) src.strength_exp = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.xp_strength >= 10000) src.xp_strength = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.strength_exp >= 100)
					while(src.strength_exp >= 100)
						src.strength_exp = src.strength_exp-100
						src.strength_base += multi*src.mod_strength
						var/growth_mult = clamp(1 + (src.PG), 1, 10) // PG gives modest scaling
						var/rating_mult = clamp(1 + log(1 + src.rating / 50000), 1, 10) // slows over time
						src.strength += (exp+multi) * (mod_strength * growth_mult) / rating_mult
						src.gains_trained_strength += multi
						//src.movelvl_exp += 10
						src.xp_strength += 2;
						//src.display_gain(stat)
					src.update_weight()
				if(src.xp_strength >= 100)

					while(src.xp_strength >= 100)
						src.xp_strength = src.xp_strength-100

						//if(src.client) winset(src,"skill_pane_strength.label_points","text=\"Strength Points: [src.skill_points_strength]\"")
						//src.set_alert("+1 Strength Skill Points",'stat_strength.dmi',"strength")
						//src.create_chat_entry("alerts","+1 Strength Skill Points")

			if(stat == "endurance")
				if(src.cycle_free_time)
					if(!cftglobal) src.cycle_free_time -= 0.015
					if(src.cycle_free_time <= -0.1)
						src.remove_cft()

				else if(offline_gains && !standing_gains_timer)
					src.offline_gains -=  0.01//0.01
					if(src.offline_gains <= -0.1)
						src.offline_gains = 0
					else
						exp *= 3
						multi *= 3
				if(standing_gains_timer)
					src.standing_gains_timer --
					exp *=1.35
					multi *= 1.35
				if(inside_hbtc)
					exp *= 4
					multi *= 4
				src.gaining_endurance = 1;
				//Update buff obj to display correct info and sources
				if(src.buff_endurance)
					var/obj/buffs_and_debuffs/b = src.buff_endurance
					b.active = 1;
					if(source)
						if(src.endurance_sources && islist(src.endurance_sources) && src.endurance_sources.Find(source) == 0) src.endurance_sources += source
					var/txt = "<br><u>Sources</u>"
					for(var/t in src.endurance_sources)
						txt = "[txt]<br>[t]."
					b.info_txt.maptext = "<font size = 1><text align=center valign=top>[b.desc][txt]"
					if(remove_source == 1)
						spawn(10)
							if(src && b)
								src.endurance_sources -= source
				//Proceed with gaining the stat
				var/experience_pts
				switch(src.bodysize)
					if(1)
						experience_pts = 20
					if(2)
						experience_pts = 15
					if(3)
						experience_pts = 10
				src.endurance_exp += experience_pts+(exp*multi)//(exp+multi)///(src.mod_endurance) * 1.25
				if(src.endurance_exp >= 10000) src.endurance_exp = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.xp_endurance >= 10000) src.xp_endurance = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.endurance_exp >= 100)
					while(src.endurance_exp >= 100)
						src.endurance_exp = src.endurance_exp-100
						src.endurance_base += multi*src.mod_endurance
						var/growth_mult = clamp(1 + (src.PG), 1, 10) // PG gives modest scaling
						var/rating_mult = clamp(1 + log(1 + src.rating / 50000), 1, 10) // slows over time
						src.endurance += (multi * mod_endurance * growth_mult) / rating_mult
						src.gains_trained_endurance += multi
						//src.movelvl_exp += 10
						src.xp_endurance += 2;
						//src.display_gain(stat)
					src.update_weight()
				if(src.xp_endurance >= 100)

					while(src.xp_endurance >= 100)
						src.xp_endurance = src.xp_endurance-100
						//if(prob(src.generation_lvl*10)) src.passive_points+=1;
						//if(src.client) winset(src,"skill_pane_endurance.label_points","text=\"Endurance Points: [src.skill_points_endurance]\"")
						//src.set_alert("+1 Endurance Skill Points",'stat_endurance.dmi',"endurance")
						//src.create_chat_entry("alerts","+1 Endurance Skill Points")

			if(stat == "force")
				if(src.cycle_free_time)
					if(!cftglobal) src.cycle_free_time -= 0.015
					if(src.cycle_free_time <= -0.1)
						src.remove_cft()

				else if(offline_gains && !standing_gains_timer)
					src.offline_gains -= 0.03 //0.01
					if(src.offline_gains <= -0.1)
						src.offline_gains = 0
					else
						exp *= 3
						multi *= 3
				if(standing_gains_timer)
					src.standing_gains_timer --
					exp *= 1.35
					multi *= 1.35
				if(inside_hbtc)
					exp *= 4
					multi *= 4
				src.gaining_force = 1;
				//Update buff obj to display correct info and sources
				if(src.buff_force)
					var/obj/buffs_and_debuffs/b = src.buff_force
					b.active = 1;
					if(source)
						if(src.force_sources && islist(src.force_sources) && src.force_sources.Find(source) == 0) src.force_sources += source
					var/txt = "<br><u>Sources</u>"
					for(var/t in src.force_sources)
						txt = "[txt]<br>[t]."
					b.info_txt.maptext = "<font size = 1><text align=center valign=top>[b.desc][txt]"
					if(remove_source == 1)
						spawn(10)
							if(src && b)
								src.force_sources -= source
				//Proceed with gaining the stat
				var/experience_pts
				switch(src.bodysize)
					if(1)
						experience_pts = 10
					if(2)
						experience_pts = 15
					if(3)
						experience_pts = 20
				if(source == "Meditation")
					experience_pts = 5
					src.force_exp += experience_pts+(exp*multi)
				else src.force_exp += experience_pts+(exp*multi)//(exp+multi)//(src.force/src.mod_force)
				if(src.force_exp >= 10000) src.force_exp = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.xp_force >= 10000) src.xp_force = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.force_exp >= 100)
					while(src.force_exp >= 100)
						src.force_exp = src.force_exp-100
						src.force_base += multi*src.mod_force
						var/growth_mult = clamp(1 + (src.PG), 1, 10) // PG gives modest scaling
						var/rating_mult = clamp(1 + log(1 + src.rating / 50000), 1, 10) // slows over time

						src.force += (multi * mod_force * growth_mult) / rating_mult
						src.gains_trained_force += multi
					//	src.movelvl_exp += 10
						src.xp_force += 2;
					//	src.display_gain(stat)
				if(src.xp_force >= 100)

					while(src.xp_force >= 100)
						src.xp_force = src.xp_force-100
						//if(prob(src.generation_lvl*10)) src.passive_points+=1;
						//if(src.client) winset(src,"skill_pane_force.label_points","text=\"Force Points: [src.skill_points_force]\"")
						//src.set_alert("+1 Force Skill Points",'stat_potency.dmi',"potency")
						//src.create_chat_entry("alerts","+1 Force Skill Points")

			if(stat == "resistance")
				if(src.cycle_free_time)
					if(!cftglobal) src.cycle_free_time -= 0.015
					if(src.cycle_free_time <= -0.1)
						src.remove_cft()

				else if(offline_gains && !standing_gains_timer)
					src.offline_gains -= 0.01 //0.01
					if(src.offline_gains <= -0.1)
						src.offline_gains = 0
					else
						exp *= 3
						multi *= 3
				if(standing_gains_timer)
					src.standing_gains_timer --
					exp *= 1.35
					multi *= 1.35
				if(inside_hbtc)
					exp *= 4
					multi *= 4
				src.gaining_resistance = 1;
				//Update buff obj to display correct info and sources
				if(src.buff_resistance)
					var/obj/buffs_and_debuffs/b = src.buff_resistance
					b.active = 1;
					if(source)
						if(src.resistance_sources && islist(src.resistance_sources) && src.resistance_sources.Find(source) == 0) src.resistance_sources += source
					var/txt = "<br><u>Sources</u>"
					for(var/t in src.resistance_sources)
						txt = "[txt]<br>[t]."
					b.info_txt.maptext = "<font size = 1><text align=center valign=top>[b.desc][txt]"
					if(remove_source == 1)
						spawn(10)
							if(src && b)
								src.resistance_sources -= source
				//Proceed with gaining the stat
				src.resistance_exp += 15+(exp*multi)//(exp+multi)//(src.resistance/src.mod_resistance)
				if(src.resistance_exp >= 10000) src.resistance_exp = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.xp_resistance >= 10000) src.xp_resistance = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.resistance_exp > 100)
					while(src.resistance_exp >= 100)
						src.resistance_exp = src.resistance_exp-100
						src.resistance_base += multi*src.mod_resistance
						var/growth_mult = clamp(1 + (src.PG), 1, 10) // PG gives modest scaling
						var/rating_mult = clamp(1 + log(1 + src.rating / 50000), 1, 10) // slows over time
						src.resistance += (multi * mod_resistance * growth_mult) / rating_mult
					//	src.resistance += multi+src.mod_resistance
						src.gains_trained_resistance += multi
					//	src.movelvl_exp += 10
						src.xp_resistance += 2;
					//	src.display_gain(stat)
				if(src.xp_resistance >= 100)

					while(src.xp_resistance >= 100)
						src.xp_resistance = src.xp_resistance-100

						//if(src.client) winset(src,"skill_pane_resistance.label_points","text=\"resistance Points: [src.skill_points_resistance]\"")
						//src.set_alert("+1 Resistance Skill Points",'stat_resistence.dmi',"resistance")
						//src.create_chat_entry("alerts","+1 Resistance Skill Points")

			if(stat == "offence")
				if(src.cycle_free_time)
					if(!cftglobal) src.cycle_free_time -= 0.015
					if(src.cycle_free_time <= -0.1)
						src.remove_cft()

				else if(offline_gains && !standing_gains_timer)
					src.offline_gains -= 0.03 //0.01
					if(src.offline_gains <= -0.1)
						src.offline_gains = 0
					else
						exp *= 3
						multi *= 3
				if(standing_gains_timer)
					src.standing_gains_timer --
					exp *= 1.35
					multi *= 1.35
				if(inside_hbtc)
					exp *= 4
					multi *= 4
				src.gaining_offence = 1;
				//Update buff obj to display correct info and sources
				if(src.buff_offence)
					var/obj/buffs_and_debuffs/b = src.buff_offence
					b.active = 1;
					if(source)
						if(src.offence_sources && islist(src.offence_sources) && src.offence_sources.Find(source) == 0) src.offence_sources += source
					var/txt = "<br><u>Sources</u>"
					for(var/t in src.offence_sources)
						txt = "[txt]<br>[t]."
					b.info_txt.maptext = "<font size = 1><text align=center valign=top>[b.desc][txt]"
					if(remove_source == 1)
						spawn(10)
							if(src && b)
								src.offence_sources -= source
				//Proceed with gaining the stat
				src.offence_exp += 15+(exp*multi)//(exp+multi)//(src.offence/src.mod_offence)
				if(src.offence_exp >= 10000) src.offence_exp = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.xp_offence >= 10000) src.xp_offence = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.offence_exp >= 100)
					while(src.offence_exp >= 100)
						src.offence_exp = src.offence_exp-100
						src.offence_base += multi*src.mod_offence
						var/growth_mult = clamp(1 + (src.PG), 1, 10) // PG gives modest scaling
						var/rating_mult = clamp(1 + log(1 + src.rating / 50000), 1, 10) // slows over time
						//src.resistance += (multi * mod_resistance * growth_mult) / rating_mult
						src.offence += (multi * mod_offence * growth_mult) / rating_mult
						src.gains_trained_off += multi
					//	src.movelvl_exp += 10
						src.xp_offence += 2;
						//src.display_gain(stat)
				if(src.xp_offence >= 100)

					while(src.xp_offence >= 100)
						src.xp_offence = src.xp_offence-100
						//if(prob(src.generation_lvl*10)) src.passive_points+=1;
						//if(src.client) winset(src,"skill_pane_offence.label_points","text=\"Offence Points: [src.skill_points_offence]\"")
					//	src.set_alert("+1 Offence Skill Points",'stat_accuracy.dmi',"accuracy")
					//	src.create_chat_entry("alerts","+1 Offence Skill Points")

			if(stat == "defence")
				if(src.cycle_free_time)
					if(!cftglobal) src.cycle_free_time -= 0.015
					if(src.cycle_free_time <= -0.1)
						src.remove_cft()

				else if(offline_gains && !standing_gains_timer)
					src.offline_gains -= 0.03 //0.01
					if(src.offline_gains <= -0.1)
						src.offline_gains = 0
					else
						exp *= 3
						multi *= 3
				if(standing_gains_timer)
					src.standing_gains_timer --
					exp *= 1.35
					multi *= 1.35
				if(inside_hbtc)
					exp *= 4
					multi *= 4
				src.gaining_defence = 1;
				//Update buff obj to display correct info and sources
				if(src.buff_defence)
					var/obj/buffs_and_debuffs/b = src.buff_defence
					b.active = 1;
					if(source)
						if(src.defence_sources && islist(src.defence_sources) && src.defence_sources.Find(source) == 0) src.defence_sources += source
					var/txt = "<br><u>Sources</u>"
					for(var/t in src.defence_sources)
						txt = "[txt]<br>[t]."
					b.info_txt.maptext = "<font size = 1><text align=center valign=top>[b.desc][txt]"
					if(remove_source == 1)
						spawn(10)
							if(src && b)
								src.defence_sources -= source
				//Proceed with gaining the stat
				src.defence_exp += 15+(exp*multi)//(exp+multi)//(src.defence/src.mod_defence)
				if(src.defence_exp >= 10000) src.defence_exp = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.xp_defence >= 10000) src.xp_defence = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.defence_exp >= 100)
					while(src.defence_exp >= 100)
						src.defence_exp = src.defence_exp-100
						src.defence_base += multi*src.mod_defence
						var/growth_mult = clamp(1 + (src.PG), 1, 10) // PG gives modest scaling
						var/rating_mult = clamp(1 + log(1 + src.rating / 50000), 1, 10) // slows over time
						src.defence += (multi * mod_defence * growth_mult) / rating_mult
						//src.defence += multi+src.mod_defence
						src.gains_trained_def += multi
					//	src.movelvl_exp += 10
						src.xp_defence += 2;
						//src.display_gain(stat)
				if(src.xp_defence >= 100)

					while(src.xp_defence >= 100)
						src.xp_defence = src.xp_defence-100
						//if(prob(src.generation_lvl*10)) src.passive_points+=1;
						//if(src.client) winset(src,"skill_pane_defence.label_points","text=\"Defence Points: [src.skill_points_defence]\"")
					//	src.set_alert("+1 Defence Skill Points",'stat_reflexes.dmi',"reflexes")
						//src.create_chat_entry("alerts","+1 Defence Skill Points")

			if(stat == "regen")

				src.xp_regen += 1;
				if(src.xp_regen >= 10000) src.xp_regen = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.xp_regen >= 100)
					while(src.xp_regen >= 100)
						src.xp_regen = src.xp_regen-100
					//	src.set_alert("+1 Regen Skill Points",'stat_regen.dmi',"regen")
					//	src.create_chat_entry("alerts","+1 Regeneration Skill Points")

			if(stat == "recovery")
				src.xp_recovery += 1;
				if(src.xp_recovery >= 10000) src.xp_recovery = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.xp_recovery >= 100)
					while(src.xp_recovery >= 100)
						src.xp_recovery = src.xp_recovery-100
					//	src.set_alert("+1 Recov Skill Points",'stat_recovery.dmi',"recovery")
					//	src.create_chat_entry("alerts","+1 Recovery Skill Points")

			if(stat == "agility")
				if(src.cycle_free_time)
					if(!cftglobal) src.cycle_free_time -= 0.015
					if(src.cycle_free_time <= -0.1)
						src.remove_cft()

				else if(offline_gains && !standing_gains_timer)
					src.offline_gains -=  0.03 //0.01
					if(src.offline_gains <= -0.1)
						src.offline_gains = 0
					else
						exp *= 1.3
						multi *= 1.3
				if(standing_gains_timer)
					src.standing_gains_timer --
					exp *= 1.05
					multi *= 1.05
				if(inside_hbtc)
					exp *= 1.45
					multi *= 1.45
				var/experience_pts
				switch(src.bodysize)
					if(1)
						experience_pts = 10
					if(2)
						experience_pts = 15
					if(3)
						experience_pts = 20
				src.xp_agility += experience_pts+(exp*multi);
				if(src.xp_agility >= 10000) src.xp_agility = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.xp_agility >= 100)
					while(src.xp_agility >= 100)
						src.xp_agility = src.xp_agility-100
						var/growth_mult = clamp(0.15 + (src.PG), 0.1, 0.5) // PG gives modest scaling
						var/rating_mult = clamp(1 + log(1 + src.rating / 50000), 1, 10) // slows over time
						src.mod_agility += (multi * 1 * growth_mult) / rating_mult

						//src.mod_agility += 0.01
						//src.set_alert("+1 Agility Skill Points",'stat_agility.dmi',"agility")
						//src.create_chat_entry("alerts","+1 Agility Skill Points")
			if(stat == "rating")
				var/BaseXP = 110 // 150
				var/curve_strength = 0.1 // tweak this to control taper speed
				var/minXP = 1
				var/res = (traintype + 1)
				var/curve = log(1 + src.rating / 100000) / 10


				var/final_mult = (1 + curve) * src.rating_mult  // Combined curve and your scaling
				if(src.icon_state == "Meditate" && src.skill_study && src.skill_study.active==1 || src.icon_state == "Meditate" && src.skill_hone && src.skill_hone.active == 1)

					res = 35
					curve_strength = 0.08
				else
					res = (traintype + 1)
				if(res < 1)
					res = 1

				if(src.cycle_free_time>=1 )
					res = 35
					curve_strength = 0.08

				if(res >= 75)
					curve_strength = 0.01
				// Gradual diminishing curve

				var/factor =  max( 1 - ((res / 100) ** curve_strength), 0.1)
				var/diminish = clamp(BaseXP * factor, minXP, 9999999)
				// Optional: hard nerf past 90+

				if(res >= 100)
				//	diminish = 1
					final_mult = 1

				if(src.cycle_free_time)
					if(!cftglobal) src.cycle_free_time -= 0.00667
					if(src.cycle_free_time <= -0.1)
						src.remove_cft()

				else if(offline_gains && !standing_gains_timer)
					src.offline_gains -= 0.01
					if(src.offline_gains <= -0.1)
						src.offline_gains = 0
					else
						exp *= 3
						multi *= 3
				if(standing_gains_timer)
					src.standing_gains_timer --
					exp *= 1.35
					multi *= 1.35
				if(inside_hbtc)
					exp *= 4
					multi *= 4
				src.gaining_rating = 1

				src.rating_exp += 50+(src.rating_mult * src.mod_rating)
				if(src.rating_exp >= 10000) src.rating_exp = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
				if(src.rating_exp >= 100)
					while(src.rating_exp >= 100)
						src.rating +=(multi * final_mult * diminish) * src.PG
						src.rating_exp = src.rating_exp-100
						src.gains_trained_rating += 1
						src.movelvl_exp += 0.3 + round((src.rating * 0.000001),0.01)
					//	src<< "move lvl xp + [0.3 + round((src.rating * 0.000001),0.01)]"
					//	src<<"[src.mod_rating]"
						//sleep(0.1)
				if(src.rating_exp < 0) src.rating_exp = 0
			src.PG = 1 + round((src.rating * 0.000001),0.01) + (src.generational_pg)//1 + ((src.move_lvl - 1) * 0.05)

			//src<< "PG+ [1 + round((src.rating * 0.000001),0.01)]"
		/*	if(src.movelvl_exp >= 100)
				if(islist(src.tutorials))
					var/obj/help_topics/H = src.tutorials[9]
					if(H.seen == 0)
						H.seen = 1
						H.skill_up(src)
						*/
			if(src.movelvl_exp >= 880 && !src.move880_rewarded)
				src.passive_points += 1
				src.move880_rewarded = 1

			while(src.movelvl_exp >= 1000)
				src.move_lvl += 1
				src.movelvl_exp = src.movelvl_exp-1000
				src.move880_rewarded = 0   // reset for next level

				// Every Move Level increases PG by 0.5
				//src.PG = 0.1 + ((src.move_lvl - 1) * 0.5)
				if(src.PG < 1)
					src.PG = 1
				//sleep(0.1)
			//	src.movelvl_exp = 0

					//src.trait_exp += 1
				//	src.display_gain("combat")

				//src.set_alert("Move Level reached [src.move_lvl]",'stat_lvl.dmi',"lvl")
				//src.create_chat_entry("alerts","Move Level reached [src.move_lvl]")

		//	if(src.trait_exp >= 10)
			//	if(src.trait_exp >= 10000) src.trait_exp = 10000 //Make sure the while() stuff doesn't hang or crash, because too high a number will throw an inf loop error.
			//	while(src.trait_exp >= 10)
				//	src.trait_exp = src.trait_exp-10
				//	src.stance_points+=1
				//src.set_alert("+1 Trait points",'stat_recovery.dmi',"recovery")
				//src.create_chat_entry("alerts","+1 Stance points")
			//apply_rating_multiplier(src)

mob/proc

	apply_c_type_mutation()
		if(!src) return
		src.mod_psionic_power = decimal_rand(5, 7)
		src.final_powerlevel_mod = 2400000
		src.psionic_power_base += ((src.age/src.mod_psionic_power) + random_mod_multiplier() + (src.final_powerlevel_mod * 0.0012)) * src.mod_psionic_power

		src.mod_rating = 1
		src.mod_energy = decimal_rand(1.9, 2.3)
		src.mod_strength = decimal_rand(1.9, 2.1)
		src.mod_endurance = decimal_rand(1.9, 2.2)
		src.mod_zenkai = decimal_rand(2.1, 2.4)
		src.mod_agility -= decimal_rand(1.4, 1.5)
		src.mod_force = decimal_rand(1.95, 2.15)
		src.mod_resistance = decimal_rand(1.25, 1.35)
		src.mod_offence = decimal_rand(1.7, 2.1)
		src.mod_defence = decimal_rand(1.5, 1.9)
		src.mod_regeneration = decimal_rand(1.25, 1.35)
		src.mod_recovery = decimal_rand(1.6, 1.85)
		src.mod_sense = 1.8
		src.mod_anger = decimal_rand(1.1, 1.3)
		src.mod_tech_potential = 1.1
		src.hidden_potential *= decimal_rand(1.5, 1.7)
		src.PG *= 2.2
		var/filter = add_filter(src, filter="outline", list("color" = rgb(202, 242, 127), "size" = 1, "alpha" = 0))
		animate(filter, alpha = 200, time = 0.5 * SECONDS, loop =-1)
		animate(filter, alpha = 0, time = 0.5 * SECONDS, loop =-1)
		spawn(1 * SECONDS)
			if(src)
				remove_filter(src, filter)
		src << "you were born with the C-type mutation."

	apply_lssj_gene()
		if(!src) return
		src.mod_psionic_power = decimal_rand(7, 9)
		src.final_powerlevel_mod = 3000000
		src.psionic_power_base += ((src.age/src.mod_psionic_power) + random_mod_multiplier() + (src.final_powerlevel_mod * 0.0015)) * src.mod_psionic_power

		src.mod_rating = 1
		src.mod_energy = decimal_rand(2.3, 2.5)
		src.mod_strength = decimal_rand(1.9, 2.1)
		src.mod_endurance = decimal_rand(1.9, 2.2)
		src.mod_zenkai = decimal_rand(1.9, 2.2)
		src.mod_agility += decimal_rand(1.4, 1.5)
		src.mod_force = decimal_rand(1.95, 2.15)
		src.mod_resistance = decimal_rand(1.35, 1.5)
		src.mod_offence = decimal_rand(1.7, 2.1)
		src.mod_defence = decimal_rand(1.5, 1.9)
		src.mod_regeneration = decimal_rand(1.35, 1.5)
		src.mod_recovery = decimal_rand(1.8, 2.0)
		src.mod_sense = 1.8
		src.mod_anger = decimal_rand(1.1, 1.3)
		src.mod_tech_potential = 1.1
		src.LSSJ = 1
		src.hidden_potential *= decimal_rand(1.1, 1.3)
		src.auracolor = rgb(202, 242, 127)
		var/filter = add_filter(src, filter="outline", list("color" = rgb(202, 242, 127), "size" = 1, "alpha" = 0))
		animate(filter, alpha = 200, time = 0.5 * SECONDS, loop =-1)
		animate(filter, alpha = 0, time = 0.5 * SECONDS, loop =-1)
		spawn(1 * SECONDS)
			if(src)
				remove_filter(src, filter)
		src << "You successfully activated the LSSJ gene in [src]."
		world.log << "(Admin Log): [src.client.admin_name] activated the LSSJ gene in [src]!"

	apply_beast_gene()
		if(!src) return
		//src.mod_psionic_power = decimal_rand(7, 9)
		//src.final_powerlevel_mod = 3000000
		//src.psionic_power_base += ((src.age/src.mod_psionic_power) + random_mod_multiplier() + (src.final_powerlevel_mod * 0.00015)) * src.mod_psionic_power

		src.mod_rating = 1
		src.mod_anger = decimal_rand(1.2, 1.4)
		src.hidden_potential *= decimal_rand(1.3, 1.6)
		src.PG *= 1.5

	apply_f_type_mutation()
		if(!src) return
		src.mod_psionic_power = decimal_rand(3, 6)
		src.final_powerlevel_mod = 1500000
		src.psionic_power_base += ((src.age/src.mod_psionic_power) + random_mod_multiplier() + (src.final_powerlevel_mod * 0.001)) * src.mod_psionic_power
		src.mod_rating = 1
		src.mod_energy = decimal_rand(1.5, 2.0)
		src.mod_endurance = decimal_rand(1.9, 2.2)
		src.hidden_potential *= decimal_rand(1.3, 1.5)
		src.PG *= 2.3

	apply_co_mutation()
		if(!src) return
		src.mod_psionic_power = decimal_rand(2, 4)
		src.final_powerlevel_mod = 1000000
		src.psionic_power_base += ((src.age/src.mod_psionic_power) + random_mod_multiplier() + (src.final_powerlevel_mod * 0.001)) * src.mod_psionic_power
		src.mod_rating = 1
		src.mod_energy = decimal_rand(1.2, 1.4)
		src.PG *= 1.3
