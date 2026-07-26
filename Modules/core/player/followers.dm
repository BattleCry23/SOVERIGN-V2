/*
Ideas for followers

Control

- Can switch between them like in Kenshi


Saving

- Either have them all save at once inside a list
- Or have them save one at a time, in their own seperate .sav


Mechanics

- Maybe have the player character contain a special var that marks them as different
- This is to make sure the player is the leader and the only one who can do certain things?
 - Like ascend
 - Make important decisions
- Would have to go through several procs and make sure they do a if(client) check
- Make the mobs used for the followers be pulled from the world mob creation proc
*/

mob
	proc
		create_follower(var/race,var/looks,var/stats,var/skills,var/obj/skills/skill_used)
			spawn(0)
				if(src)
					/*
					This should be where, and only where, the creation of other mobs is done. Be it Psi-clones, NPC, even divine weapons.
					*/

					//If race is null, use the creators race
					if(race == null)
						race = src.race

					var/mob/s
					switch(race)
						if("Makyo")
							if(races_makyos.len > 0)
								s = races_makyos[1]
								races_makyos -= s
						if("Saiyan")
							if(races_saiyans.len > 0)
								s = races_saiyans[1]
								races_saiyans -= s
						if("Human")
							if(races_humans.len > 0)
								s = races_humans[1]
								races_humans -= s
						if("Demon")
							if(races_demons.len > 0)
								s = races_demons[1]
								races_demons -= s
						if("Kai")
							if(races_celestials.len > 0)
								s = races_celestials[1]
								races_celestials -= s
						if("Changeling")
							if(races_changelings.len > 0)
								s = races_changelings[1]
								races_changelings -= s
						if("Tuffle")
							if(races_tuffles.len > 0)
								s = races_tuffles[1]
								races_tuffles -= s
						if("Half God")
							if(races_halfgods.len > 0)
								s = races_halfgods[1]
								races_halfgods -= s
						if("Spirit Doll")
							if(races_spiritdolls.len > 0)
								s = races_spiritdolls[1]
								races_spiritdolls -= s
						if("Oni")
							if(races_imps.len > 0)
								s = races_imps[1]
								races_imps -= s
						if("Namekian")
							if(races_yukopians.len > 0)
								s = races_yukopians[1]
								races_yukopians -= s
						if("Alien")
							if(races_aliens.len > 0)
								s = races_aliens[1]
								races_aliens -= s
						if("Android")
							if(races_androids.len > 0)
								s = races_androids[1]
								races_androids -= s
					if(looks == "Clone")
						if(skill_used && skill_used.type == /obj/skills/Split_Form)
							src.skill_psi_clone.icon_state = "Psi Clone off"
							s.name = "{[length(src.skill_psi_clone.active_splits)]}"
							//s.ai_name = "Psi Clone [length(src.skill_psi_clone.active_splits)]"
						else
							s.name = "{NPC} [s.race]"
						s.icon = src.icon
						s.loc = get_step(src,src.dir)
						s.dir = get_dir(s,src)
						s.pixel_x = src.pixel_x
						s.pixel_y = src.pixel_y
						s.step_x = src.step_x;
						s.step_y = src.step_y;
						s.density_factor = 0
						s.icon +=rgb(125,125,125)
						s.alpha = 55
						s.dir = SOUTH
						s.tmp_lists()
						s.eye_c = src.eye_c
						s.hair_c = src.hair_c
						s.hair_pos = src.hair_pos
						s.ear_pos = src.ear_pos
						s.skin_pos = src.skin_pos
						s.horn_pos = src.horn_pos
						s.expand_icon = src.expand_icon
						s.eye_pos = src.eye_pos
						s.nose_pos = src.nose_pos
						s.mouth_pos = src.mouth_pos
						s.body_pos = src.body_pos
						s.save_icon = src.save_icon
						s.started = 1
						s.choosing_character = 0
						if(!(skill_used && skill_used.type == /obj/skills/Split_Form))
							s.create_login_menus()
							//s.confirm_new_character()
						//s.create_login_menus()

						var/image/sel = image('select.dmi',s,null,10,pixel_y = 8)
						sel.appearance_flags = KEEP_APART | RESET_TRANSFORM
						s.target_img = sel

						s.accessing = s
						if(!(skill_used && skill_used.type == /obj/skills/Split_Form))

							s.confirm_new_character()

						if(skill_used && skill_used.type == /obj/skills/Split_Form)
							animate(s,alpha = 255, time = 7)
							src.skill_psi_clone.active_splits += s
							sleep(5)
							if(s && src) s.shockwave()
							sleep(3)
					if(s && src)
						if(stats == "Clone")
							s.name_txt()
							s.icon = src.icon
							s.appearance_flags = KEEP_TOGETHER
							s.overlays = src.overlays
							s.mod_psionic_power = src.mod_psionic_power
							s.gains_trained_power = src.gains_trained_power
							s.gains_psiforged_power = src.gains_psiforged_power
							s.dead = src.dead

							if(s.dead) s.psionic_power /= 2
							if(src.wings_hidden == 0) s.wings = src.wings

							s.halo = src.halo
							s.eyes = src.eyes
							s.eyes_white = src.eyes_white
							s.vis_contents += s.eyes
							s.vis_contents += s.eyes_white
							s.strength = src.strength
							s.endurance = src.endurance
							s.force = src.force
							s.mod_str_usage = src.mod_str_usage
							s.mod_force_usage = src.mod_force_usage
							s.mod_agility = src.mod_agility
							s.resistance = src.resistance
							s.offence = src.offence
							s.defence = src.defence
							s.vigour = src.vigour
							s.owner = src.real_name
							s.gains_trained_energy = src.gains_trained_energy
							s.gains_psiforged_energy = src.gains_psiforged_energy
							s.Move(s.loc,SOUTH,s.step_x,s.step_y)
							s.filters = src.filters
						if(skills == "Clone")
							for(var/obj/skills/sk in src)
								if(sk.type == /obj/skills/Split_Form)
									continue
								new sk.type(s)
							//	world << "DEBUG - Cloned [src]'s [sk] for [s]"
						//sleep(10)
						//Debug test
						//for(var/obj/o in src.client.screen)
							//src.client.screen -= o
						//s.key = src.key