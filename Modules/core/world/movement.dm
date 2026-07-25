#define get_opposite(x) __opposite_dirs[(x)]

var
	list/__opposite_dirs = list(2,1,null,8,null,null,null,4)    //used internally to assist with movement input keys


client
	var/tmp
		move_dir = 0
		input_dir = 0
		change = 0
		shift = 0;
		tmp/move_analog_x
		tmp/move_analog_y
	verb
		move_analog_input(X as num, Y as num)
			set hidden = TRUE,instant = TRUE
			move_analog_x = X
			move_analog_y = Y
		MoveKey(key as num,state as num)
			set hidden = 1
			set instant = 1
			if(usr.typing) return
			//usr.layer = 101 - usr.y
			. = input_dir==0
			//update the INPUT_DPAD status
			var/opposite = get_opposite(key)
			if(state)
				//if this is a keypress, turn on the key bit
				//if(usr.skill_flight && usr.skill_flight.active)
					//usr.client.screen -= usr.hud_liquid
				input_dir |= key
				move_dir |= key
				//turn off the opposite key bit
				if(opposite & input_dir)
					move_dir &= ~opposite
			else

				//if this is a keyrelease, turn off the key bit
				//usr.client.screen -= usr.hud_liquid
				//usr.client.screen += usr.hud_liquid
				input_dir &= ~key
				move_dir &= ~key
				//turn on the opposite key bit if it's being held
				if(opposite & input_dir)
					move_dir |= opposite
			if(usr.started) usr.MoveLoop()
			//usr.client.check_minigame()
mob
	proc
		MoveLoop()
			//var/spd = 1
			//var/controller = 0
			if(src.client)
				/*
				var/proceed = 0
				if(src.tk)
					if(istype(src.tk,/atom/movable)) proceed = 1
				if(proceed)
					var/atom/movable/a = src.tk
					if(ismob(a))
						var/mob/m = a
						if(m.afk) src.tk = null
					if(a.bolted > 2) src.tk = null
					if(src.tk && src.mouse_down)
						for(var/obj/skills/Telekinesis/t in src)
							var/steps = 0
							steps = a.step_size*1.5
							step_towards(src.tk,src.mouse_down,steps)
							a.set_shadow()
							//M.energy -= 0.01+((M.energy_max*0.25)/t.skill_lvl/M.mod_energy)
							var/removes = (0.5/src.mod_recovery) + (0.5/t.skill_lvl)
							src.energy -= removes
							//world << "[removes] removed by [t]"
							src.gain_stat("force",1,1,"Telekinesis")
							src.gain_stat("power",1,1,"Telekinesis")
							t.skill_exp += (10/t.skill_lvl)*src.mod_skill
							if(t.skill_exp >= 100)
								t.skill_exp = 1
								t.skill_lvl += 1
								t.skill_up(src)
					else src.drop_tk()
				*/
				//controller = 0
				if(src.grabbed_by)
					var/Evasion = src.evasion(src,src.grabbed_by)
					if(src.grabbed_by)
						if(Evasion&&prob(5))
							view(src)<<"[src] breaks free of [src.grabbed_by]!"
							src.grabbed_by.grab = null
							src.grabbed_by = null

						else
							view(src)<<"[src] struggles against [src.grabbed_by]"
						return 0
				if(src.Pod && src.Pod.manualtravel)
					if(src.koed == 0 && src.stunned == 0 && src.KB <=0 && src.selftraining == 0 && src.beaming == 0 && src.Pod.autotravel == 0 && src.moved == 0)
						if(src.client.move_dir) //if(controller == 0) if(src.client.move_dir) //if(!src.KB)
							src.moved=1
							src.face_angle = NumToAngle(src.dir)
							step(src.client.mob,src.client.move_dir,src.step_size)
							src.layer = MOB_LAYER + src.laymod - (src.y + src.step_y / 32) / world.maxy
							//src.set_shadow()
							src.lastloc = src.loc
							src.last_step_x = src.step_x
							src.last_step_y = src.step_y
							src.Pod.loc = src.loc
							if(src.Pod.autotravel ==1 ) src.Pod.autotravel = 0
							if(src.map_blip)
								src.map_blip.pixel_x = src.x-3
								src.map_blip.pixel_y = src.y-3

							sleep(src.Pod.Speed)
							src.moved=0
				else if(src.Ship && src.Ship.panel.manualtravel)
					if(src.koed == 0 && src.stunned == 0 && src.KB <=0 && src.selftraining == 0 && src.beaming == 0 && src.Ship.panel.autotravel == 0 && src.moved == 0)
						if(src.client.move_dir) //if(controller == 0) if(src.client.move_dir) //if(!src.KB)
							src.moved=1
							src.face_angle = NumToAngle(src.dir)
							step(src.client.mob,src.client.move_dir,src.step_size)
							src.layer = MOB_LAYER + src.laymod - (src.y + src.step_y / 32) / world.maxy
							//src.set_shadow()
							src.lastloc = src.loc
							src.last_step_x = src.step_x
							src.last_step_y = src.step_y
							src.Ship.loc = src.loc
							if(src.Ship.panel.autotravel ==1 ) src.Ship.panel.autotravel = 0
							if(src.map_blip)
								src.map_blip.pixel_x = src.x-3
								src.map_blip.pixel_y = src.y-3

							sleep(src.Ship.Speed)
							src.moved=0

				else if(!src.Ship && !src.Pod)
					if(src.in_oozaru_rampage) return // Disable manual movement entirely while in rampage

					if(src.eating) src.cancel_eat()
					if(src.projection)
						step(src.projection,src.client.move_dir,src.step_size)
						src.layer = MOB_LAYER + src.laymod - (src.y + src.step_y / 32) / world.maxy
					else if(src.koed == 0 && src.stunned == 0 && src.meditating == 0 && src.KB <= 0 && src.selftraining == 0 && src.beaming == 0 && src.can_move == 1 && src.moved == 0 && src.resting == 0 )
						/*
						if(src.client.move_analog_x && src.client.move_analog_y)
							controller = 1
							spd = src.step_size*2
							Translate(src.client.move_analog_x * spd,src.client.move_analog_y * spd)
							src.dir = Directions.FromOffset(src.client.move_analog_x, src.client.move_analog_y)
						*/
						if(src.client.move_dir) //if(controller == 0) if(src.client.move_dir) //if(!src.KB)
							src.face_angle = NumToAngle(src.dir)
							//Super quicksilver speed origin

							if(src.skill_quicksilver && src.skill_quicksilver.active)
								if(src.skill_quicksilver.speed_ramp < 8) src.skill_quicksilver.speed_ramp += 0.1
								var/removes = (2.5/src.mod_recovery) + (0.5/src.skill_quicksilver.skill_lvl)
								src.energy -= removes
								src.skill_quicksilver.skill_exp += (1/src.skill_quicksilver.skill_lvl)*src.mod_skill
								var/sr = round(src.skill_quicksilver.speed_ramp)
								while(sr)
									if(round(src.skill_quicksilver.speed_ramp) >= 3)
										for(var/obj/effects/after_image/af in src.afterimages)
											if(af.in_use == 0)
												af.loc = src.loc
												af.in_use = 1;
												af.icon_state = src.icon_state
												af.overlays = src.overlays
												af.alpha = 50
												af.step_x = src.step_x
												af.step_y = src.step_y
												af.dir = src.dir
												spawn(1.5)
													if(af)
														af.in_use = 0;
														af.loc = null
												break;

									step(src.client.mob,src.client.move_dir,src.step_size)
									if(round(src.skill_quicksilver.speed_ramp) >= 6)
										if(src.skill_quicksilver.speed)
											var/obj/h = src.skill_quicksilver.speed
											h.loc = src.loc
											h.dir = src.dir
											if(src.dir == SOUTH || src.dir == NORTH) h.pixel_x = -32
											else h.pixel_x = -40
											h.step_x = src.step_x
											h.step_y = src.step_y
										if(src.skill_quicksilver.speed_skip == 0)
											src.dust_and_furrows(pick(1,2,3,4,5,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
											src.icon_state = "Block"
											src.skill_quicksilver.speed_skip = 1
										else src.skill_quicksilver.speed_skip = 0
									sr -= 1
									sleep(0.1)
								if(src.skill_quicksilver.speed_ramp <= 0)
									src.skill_quicksilver.speed_ramp = 0
									src.icon_state = src.state()
									if(src.skill_focus == null || src.skill_focus && src.skill_focus.active == 0) src.overlays -= /obj/effects/elec
							if(src.skill_quicksilver && src.skill_quicksilver.active == 0 || !src.skill_quicksilver) src.moved = 1


							step(src.client.mob,src.client.move_dir,src.step_size)
							src.layer = MOB_LAYER + src.laymod - (src.y + src.step_y / 32) / world.maxy
							//src.set_shadow()
							src.lastloc = src.loc
							src.last_step_x = src.step_x
							src.last_step_y = src.step_y
							if(src.map_blip)
								src.map_blip.pixel_x = src.x-3
								src.map_blip.pixel_y = src.y-3
							/*var/delay = 2.8 - (src.mod_agility * 0.05)
							if(delay < 0.6) delay = 0.6
							if(delay > 2.8) delay = 2.8
							if(src.skill_run && src.skill_run.active) delay -= 0.4 //max(0.45, min(1, 1 - ((src.mod_agility ** 1.4) * 0.25) + (sqrt(weight) * 0.03) + ((100 - src.hp) * 0.006))) - 0.5
							if(src.skill_flight && src.skill_flight.active) delay -= 0.3
							if(src.skill_flight && src.skill_flight.active && src.super_fly) delay -= 0.3
							if(movement_speed <=0.1 || movement_speed <=-0) movement_speed = 0.5
							src.movement_speed = delay*/
							// --- BASE WALK ---
							var/delay = 1.8 - (src.mod_agility * 0.22)
							if(delay < 1.4) delay = 1.4
							if(delay > 1.8) delay = 1.8
							movement_speed = delay
							step_size = 8

							// --- RUN ---
							if(src.skill_run && src.skill_run.active)
								delay = 1.3 - (src.mod_agility * 0.22)
								if(delay < 0.7) delay = 0.7
								if(delay > 1.3) delay = 1.3
								movement_speed = delay
								step_size = 10

							// --- FLY ---
							if(src.skill_flight && src.skill_flight.active)
								delay = 0.6 - (src.mod_agility * 0.23)
								if(delay < 0.15) delay = 0.15
								if(delay > 0.6) delay = 0.6
								movement_speed = delay
								step_size = 12


							// --- SUPER FLY ---
							if(src.skill_flight && src.skill_flight.active && src.super_fly)
								delay = 0.45 - (src.mod_agility * 0.24)
								if(delay < 0.05) delay = 0.05
								if(delay > 0.45) delay = 0.45
								movement_speed = delay
								step_size = 14

							sleep(src.movement_speed)
							src.moved=0

						/*
						if(!src.skill_flight || src.skill_flight && !src.skill_flight.active)
							//lvl up leg muscles
							if(src.bodyparts)
								var/obj/body_related/bodyparts/right_leg/rl = src.bodyparts[5]
								for(var/obj/body_related/bodyparts/p in rl)
									if(p.bodypart_type == "Muscle")
										p.part_exp += 0.1
										p.part_reward(src,1,null,0)
								var/obj/body_related/bodyparts/left_leg/ll = src.bodyparts[6]
								for(var/obj/body_related/bodyparts/p in ll)
									if(p.bodypart_type == "Muscle")
										p.part_exp += 0.1
										p.part_reward(src,1,null,0)
						*/
						if(src.mouse_down && src.current_attack) src.dir = get_dir(src,src.mouse_down)
						if(src.mouse_down == null && src.current_attack == null && src.target && src.target != src.grab)
							//src.dir = get_dir(src,src.target)
							src.wings()

						//Player moves while afk
			//	if(src.afk)
				//	src.overlays -= /obj/effects/afk
				//	src.afk = 0
				//	winset(src,"chat.afk","is-checked=false")
				//	view(10,src) <<"([src] came back from afk.)"


					//src.build_marker.loc = locate(src.x-16,src.y-9,src.z)
					//src.build_marker.step_x = src.step_x
					//src.build_marker.step_y = src.step_y-12
					//src.build_marker.Move(locate(src.x-16,src.y-9,src.z),0,src.step_x,src.step_y-12)



	/*	if(istype(src,/obj/items/tech/doors/Security_Ship_Doors))
						var/obj/items/tech/doors/Security_Ship_Doors/s = src
						if(s.pass == null || s.pass == "")
							s.icon_state = "Opening"
							s.density_factor = 0
							s.opacity = 0
							spawn(60)
								if(s)
									s.icon_state = "Closing"
									s.density_factor = 2
									s.opacity = 1
						else if(m.client)
							winset(m,"numbers.label_numbers","text=\"Enter door password.\"")
							winshow(m,"numbers",1)
							m.numbers_text = "door password"
							m.left_click_ref = s
							return

						if(m.in_space_ship && density_factor == 0)
							m.loc=s.exit
							m.in_space_ship = 0

					else
					*/
atom/movable
	Cross(atom/movable/o)
		if(istype(src, /obj/items/Planets/Unknown_Planet))
			var/obj/items/Planets/Unknown_Planet/p = src
			if(ismob(o))
				var/mob/m = o


				if(p.planethub)
					m.loc = locate(p.planethub.x-rand(5,45), p.planethub.y - rand(1,40), p.interior_z)
				else
					m.loc = p.entry_location

				spawn(10)

					if(m) m.map_overlays()
				if(!m.Pod)
					spawn()
						if(m.z != initial(m.z) || !initial(m.z))
							m.crash_landing(1)
							spawn() p.rng_npcs(m)


					m.on_customplanet = p





					if(m.on_customplanet == p)
						m << output("<b><u><font color=red>WARNING:</u> [p.name]'s gravity levels are at [p.setgrav]</b>", "actionoutput")

				else if(m.Pod)
					if(p && p.planethub)
						m.Pod.loc = locate(p.planethub.x-rand(5,45), p.planethub.y - rand(1,40), p.interior_z)
						//if(m.Pod.z != initial(m.Pod.z)) m.Pod.Move(randomlocate)
					else
						m.Pod.loc = p.entry_location
					spawn() if(m.Pod.z != initial(m.Pod.z) || !initial(m.Pod.z)) m.crash_landing(2)
					m.on_customplanet = p
					if(m.client && m.on_customplanet == p)
						m<<output("<b><u><font color=red>WARNING:</u> [p.name]'s gravity levels are at [p.setgrav]</b>","actionoutput")

					spawn(10)
						if(m) m.map_overlays()
						if(!p.npcs_set && m.on_customplanet == p)
							spawn(5) p.rng_npcs(m)

		//Player moves into Planet
		if(istype(src,/obj/items/Planets/Mains/))
			if(ismob(o))
				var/mob/m = o
				var/obj/items/Planets/Mains/s = src
				var/randomlocate
				if(istype(src,/obj/items/Planets/Mains/Vegeta) || src.name == "Vegeta") randomlocate = locate(rand(2,450),rand(2,450),10)
				if(istype(src,/obj/items/Planets/Mains/Earth) || src.name == "Earth") randomlocate = locate(rand(2,450),rand(2,450),1)
				if(istype(src,/obj/items/Planets/Mains/Namek) || src.name == "Namek") randomlocate = locate(rand(2,450),rand(2,450),4)
				if(istype(src,/obj/items/Planets/Mains/Icer) || src.name == "Icer") randomlocate = locate(rand(2,450),rand(2,450),9)
				if(m.Pod==null || !m.Pod)

					if(s)
						m.loc = randomlocate
						if(m.z != initial(m.z)) m.Move(randomlocate)


						spawn(1) if(m.z != initial(m.z) || !initial(m.z)) m.crash_landing(1)


						if(m.client && m.on_customplanet == s)
							m<<output("<b><u><font color=red>WARNING:</u> [s.name]'s gravity levels are at [s.setgrav]</b>","actionoutput")
						m.on_customplanet = s
						spawn(10)
							if(m) m.map_overlays()
				else if(m.Pod)
					if(s)
						m.loc = randomlocate
						if(m.Pod.z != initial(m.Pod.z)) m.Pod.Move(randomlocate)

						spawn(1) if(m.Pod.z != initial(m.Pod.z) || !initial(m.Pod.z)) m.crash_landing(2)

						if(m.client && m.on_customplanet == s)
							m<<output("<b><u><font color=red>WARNING:</u> [s.name]'s gravity levels are at [s.setgrav]</b>","actionoutput")
						m.on_customplanet = s
						spawn(10)
							if(m) m.map_overlays()
				else if(m.Ship)
					if(s)
						m.loc = randomlocate
						if(m.Ship.z != initial(m.Ship.z)) m.Ship.Move(randomlocate)

						spawn(1) if(m.Ship.z != initial(m.Ship.z) || !initial(m.Ship.z)) m.crash_landing(3)

						if(m.client && m.on_customplanet == s)
							m<<output("<b><u><font color=red>WARNING:</u> [s.name]'s gravity levels are at [s.setgrav]</b>","actionoutput")
						m.on_customplanet = s
						spawn(10)
							if(m) m.map_overlays()



		//Player moves into Ship
		//if(istype(src,/obj/items/tech/ships/CC_Ship))
		if(istype(src,/obj/items/tech/ships/))
			if(ismob(o))
				var/mob/m = o
				//var/obj/items/tech/ships/CC_Ship/s = src
				var/obj/items/tech/ships/s = src
				if(m.Ship || m.Pod) return
				if(s.locked == 0)
					m.loc = s.entry_location
					m.in_space_ship = 1
					if(s.gravity_on)
						m.grav = s.setgrav
						m.apply_gravity_glow(1,s.setgrav)
				else if(s.locked ==1)
					m.set_alert("Ship is locked",'alert.dmi',"alert")
					.
		//Player moves into door

		//Player moves into warper
		if(src.go_x || src.go_y || src.go_z)
			if(o in players)
				if(ismob(o))
					var/mob/m = o
					if(src.go_x == 231)  // Dark Realm
						if(src.sealed == 0)
							m.apply_afterlife_glow(0)
							m.apply_hell_glow(0)
							m.apply_demonrealm_glow(1)
							o.loc = locate(src.go_x,src.go_y,src.go_z)
						else
							m.set_alert("This portal is sealed",'alert.dmi',"alert")
							return

					else if(src.go_x == 389) // Leaving Dark Realm
						if(src.sealed == 0)
							m.apply_afterlife_glow(0)
							m.apply_hell_glow(1)
							m.apply_demonrealm_glow(0)
							m.loc = locate(src.go_x,src.go_y,src.go_z)
						else
							m.set_alert("This portal is sealed",'alert.dmi',"alert")
							return
					else if(src.go_x == 64) // Leaving Hell
						if(m.judgement_bid)
							m.set_alert("An invisible barrier forbids your exit!",'alert.dmi',"alert")
							return
						if(m.aura_alignment <0)
							m.set_alert("An invisible barrier forbids your exit!",'alert.dmi',"alert")
							return

						else
							m.apply_afterlife_glow(1)
							m.apply_hell_glow(0)
							m.apply_demonrealm_glow(0)
							m.loc = locate(src.go_x,src.go_y,src.go_z)

					else
						if(src.go_x && src.go_y == null && src.go_z == null) m.loc=locate(src.go_x,m.y,m.z)
						if(src.go_x == null && src.go_y && src.go_z ==null) m.loc=locate(m.x,src.go_y,m.z)
						if(src.go_x && src.go_y && src.go_z) m.loc = locate(src.go_x,src.go_y,src.go_z)
						if(m.z == 2)
							m.apply_afterlife_glow(1)
							m.apply_hell_glow(0)
							m.apply_demonrealm_glow(0)
						if(m.z == 6)
							m.apply_afterlife_glow(0)
							m.apply_hell_glow(1)
							m.apply_demonrealm_glow(0)
						if(m.z == 11)
							m.apply_afterlife_glow(1)
							m.apply_hell_glow(0)
							m.apply_demonrealm_glow(0)
						if(m.z == 12)

							m.apply_afterlife_glow(0)
							m.apply_hell_glow(0)
							m.apply_demonrealm_glow(1)
						if(m.z == 14)
							m.apply_korintower_glow(1)
						if(m.z == 23)
							m.apply_korintower_glow(0)
							sleep(1)
							m.apply_korintower_glow(1)
						if(m.z == 1)
							m.apply_korintower_glow(0)
						spawn(10)
							if(m) m.map_overlays()


		//Player moves over/through bush or long grass
		if(src.shudders) if(o.density_factor)
			src.shudders = 0;
			animate(src,transform = turn(matrix(), 3), time = 1)
			animate(transform = turn(matrix(), -3), time = 1)
			animate(transform = turn(matrix(), 0), time = 1)
			spawn(3)
				if(src) src.shudders = 1;

		//Code for when a beam hits an obj or mob.
		if(istype(o,/obj/ranged/checker))
			if(src.density || src.density_factor > 0)
				var/obj/ranged/checker/b = o
				if(b && b.origin)
					if(ismob(src))
						var/mob/M = src
						//var/Damage=(b.ki_force/2)/(M.resistance)
						var/Damage=((b.ki_force*b.force_usage)*b.ki_power)/(M.resistance*M.psionic_power)
						//world << "DEBUG - Beam dmg = [Damage]"

						//if(M.afk == 0)
						if(Damage > 0)
							if(M.eating) M.cancel_eat()
							M.percent_health -= Damage

						//M.gain_stat("resistance",1,M.mod_resistance,"Attacked by skill",1)
						//M.gain_stat("defence",1,1,"Defending from ranged",1)
						if(b && b.origin)
							if(!M.remembers_force.Find(b.origin.id)) M.remembers_force += b.origin.id
							if(!b.origin.remembers_resistance.Find(M.id)) b.origin.remembers_resistance += M.id
						//	b.origin.gain_stat("force",1,1,"Using skill",1)
						//	b.origin.gain_stat("offence",1,1,"Attacking ranged",1)
						if(!M.client && !M.target)
							if(M.npc)
								M.target = b.origin
								var/mob/NPC/N = M
								N.npc_ai()
							else if(M.boss)
								M.target = b.origin
								var/mob/NPC/WorldBoss/N = M
								N.boss_idle_ai()
						if(M.koed && b.ki_owner.killprompt==0)
							b.ki_owner.killprompt=1
							var/mob/killer = null
							if(b) killer = b.ki_owner
							if(b.ki_owner.srs_mode==0 && b.ki_owner.spar_mode==1 || b.ki_owner.srs_mode == 1 && b.ki_owner.spar_mode==0)
								switch(alert(b.ki_owner,"Are you sure you want to kill [M]?","","No","Yes","Cancel"))
									if("Yes")
										if(M)
											if(M.dead==0)
												M.Death("[killer]",0)
												b.ki_owner.killprompt=0
							else if(b.ki_owner.srs_mode == 1 &&  b.ki_owner.spar_mode == 1)
								if(M)
									if(M.dead==0)
										M.Death("[killer]",0)
										b.ki_owner.killprompt=0
						else if(M.percent_health <= 0)
							M.KO()
						if(b.ki_owner.killprompt == 1) b.ki_owner.killprompt = 0
					else if(src.immune_dmg == 0)
						src.hp -= 10
						if(src.hp <= 0)
							var/turf/t = locate(src.x,src.y+1,src.z)
							if(t)
								//If a cliff part is destroyed and its the lower section of a cliff, make sure to dig/adjust the cliff.
								if(src.type == /obj/map/cliffs/c1 || src.type == /obj/map/cliffs/c2 || src.type == /obj/map/cliffs/c3)
									for(var/obj/map/cliffs/c in t)
										c.destroy()
									t.set_destroyed()
									world.edges_solid_rock(t.x-1,t.y+1,t.x+1,t.y-1,t.z)
								if(src.type == /obj/items/tech/Gravity_Machine)
									var/obj/items/tech/Gravity_Machine/gm = src
									gm.turn_off()
							if(istype(src,/obj/items/tech/))
								for(var/turf/trf in src.locs)
									for(var/obj/items/tech/Power_Line/p in trf)
										spawn(0)
											if(p) p.reconnect_power()
							src.destroy()

				if(o) o.loc = null
		//Code for when a blast or charge hits a obj or mob.
		else if(istype(o,/obj/ranged/))
			var/obj/ranged/b = o
			if(b.fired)// && b.ki_owner.active_attack) // || b.ki_owner.current_attack) //Check if the owner of this attack has an active/current attack set
				if(src.density || src.density_factor > 0)
					if(src.ki_owner != b.ki_owner && src != b.ki_owner)
						//If a blast crosses paths with a mob, apply the damage to them.
						if(ismob(src))
							var/mob/M = src
							if(M.eating) M.cancel_eat()
							var/Block = handle_deflection(b.ki_owner, M.deflection_skill, b.ki_power,M)
							//var/Block=(b.ki_power*(b.ki_offence+(b.ki_agility*0.2)))/(M.psionic_power*(M.defence+(M.mod_agility*0.22)))
							//if(!prob(Block*33))
							var/Damage=((b.ki_force*b.force_usage)*(b.ki_power))/(M.resistance*M.psionic_power)
							if(Block)
								if(M.koed == 0 && M.stunned == 0)
									b.ang = rand(0,360)
									b.travel = 40
									if(b.type == /obj/ranged/blast)
										var/matrix/mat = matrix()
										mat.Turn(b.ang)
										b.transform = mat
									if(M.npc ==0) flick(pick("RPunch","LKick"),M)
									else if(M.npc==1) flick("Attack",M)
									return
							else
								//var/Damage=(b.ki_force)/(M.resistance)
								//var/Damage=((b.ki_force*b.force_usage)*(b.ki_power))/(M.resistance*M.psionic_power)
								//world << "DEBUG - Beam dmg = [Damage]"
								//var/Damage=(b.ki_force)/(M.resistance)*rand(1,2)
								M.anger(Damage)
								var/obj/body_related/bodyparts/randomlimb = null
								for(var/obj/body_related/bodyparts/t in M.body)
									randomlimb = pick(t)
								if(b.ki_owner.srs_mode || b.ki_owner.lethal_mode) M.damage_limb(b.ki_owner,1, 1, Damage, randomlimb)
								if(Damage > 0) M.percent_health -= Damage
								if(prob(50))M.gain_stat("resistance",1,(M.mod_resistance*0.25),"Attacked by skill",1)
							//	M.gain_stat("defence",1,10,"Defending from ranged",1)
								//M.gain_stat("power",1,1,"Attacked by skill",1)
								if(b.ki_owner)
									if(!M.remembers_force.Find(b.ki_owner.id)) M.remembers_force += b.ki_owner.id
									if(!b.ki_owner.remembers_resistance.Find(M.id)) b.ki_owner.remembers_resistance += M.id
								//	b.ki_owner.gain_stat("force",1,10,"Using skill",1)
								//	b.ki_owner.gain_stat("offence",1,10,"Attacking ranged",1)
									if(!M.client && !M.target)
										if(M.npc)
											M.target = b.ki_owner
											var/mob/NPC/N = M
											N.npc_ai()
										else if(M.boss)
											M.target = b.ki_owner
											var/mob/NPC/WorldBoss/N = M
											N.boss_idle_ai()

								if(M.koed && b.ki_owner.killprompt==0)
									b.ki_owner.killprompt=1
									if(b.ki_owner.npc)
										if(M.dead==0)
											if(prob(25))
												var/killer = null
												if(b) killer = b.ki_owner
												if(M)
													M.Death("[killer]",0)
													b.ki_owner.killprompt=0
									else if(b.ki_owner.srs_mode==0 && b.ki_owner.spar_mode==1 || b.ki_owner.srs_mode == 1 && b.ki_owner.spar_mode==0)
										switch(alert(b.ki_owner,"Are you sure you want to kill [M]?","","No","Yes","Cancel"))
											if("Yes")
												if(M.dead==0)
													var/killer = null
													if(b) killer = b.ki_owner
													if(M)
														M.Death("[killer]",0)
														b.ki_owner.killprompt=0
									else if(b.ki_owner.srs_mode == 1 &&  b.ki_owner.spar_mode == 1)
										if(M.dead==0)
											var/killer = null
											if(b) killer = b.ki_owner
											if(M)
												M.Death("[killer]",0)
												b.ki_owner.killprompt=0
								else if(M.percent_health <= 0)
									if(b.ki_owner.boss)
										var/turf/safe = FindSafeBossRespawn(b.ki_owner)
										if(safe)
											M<<output("You managed to make it to safety before being killed.","actionoutput")
											M.loc = safe
									M.KO()

							if(b.ki_owner.killprompt == 1) b.ki_owner.killprompt = 0
						if(istype(src,/obj/ranged/)) //b hits src, which is another blast.
							var/obj/ranged/r = src;
							var/obj/ranged/enemy_ball = r.ki_owner.active_attack
							if(enemy_ball)
								r.ki_force = (r.ki_owner.force/10)
								r.force_usage = r.ki_owner.mod_force_usage
							if(b.ki_force > r.ki_force) //Check which is stronger.
								r.loc = null
							else
								b.loc = null
						if(b.explode_impact == 1)
							b.explode_impact = 2
							var/turf/t = src.loc
							var/c_l = b.charge_lvl-1
							for(var/mob/M in view(c_l,src.loc))

								var/Damage=((b.ki_force*b.force_usage)*(b.ki_power))/(M.resistance*M.psionic_power)
								var/mob/attacker = b.ki_owner
								var/dd = get_dir(src.loc,M)
								spawn(1)
									if(M && M != src && M != attacker)
										//Make anyone near the explosion take half the damage of the attack, and knock them back.
										if(Damage > 0)
											Damage/=2
											if(M.eating) M.cancel_eat()
											M.percent_health -= Damage
										if(prob(50))M.gain_stat("resistance",1,(M.mod_resistance*0.5),"Attacked by skill",1)
									//	M.gain_stat("defence",1,10,"Defending from ranged",1)
										//M.gain_stat("power",1,1,"Attacked by skill",1)
										if(attacker)
											//attacker.gain_stat("force",1,10,"Using skill",1)
											//attacker.gain_stat("offence",1,10,"Attacking ranged",1)
											if(!M.client && !M.target)
												if(M.npc)
													M.target = attacker
													var/mob/NPC/N = M
													N.npc_ai()
												else
													if(M.boss)
														M.target = attacker
														var/mob/NPC/WorldBoss/N = M
														N.boss_idle_ai()

										M.KB_furrow = 1
										M.KB = 50
										M.KnockBack(dd)
							//if(istype(b,/obj/ranged/blast)) b.loc = null
							//else del(b)
							if(src && !ismob(src))
								if(src.immune_dmg == 0)
									//var/Damage=b.ki_force
									var/Damage = (b.ki_force*b.force_usage)*b.ki_power
									src.hp -= Damage
									if(src.hp <= 0)
										if(istype(src,/obj/items/tech/))
											for(var/turf/trf in src.locs)
												for(var/obj/items/tech/Power_Line/p in trf)
													spawn(0)
														if(p) p.reconnect_power()
										src.loc = null//src.destroy()
							b.expired = 1
							b.loc = null
							//b.destroy()

							if(t)
								//if(b.ki_owner.force >= 250000 && b.ki_owner.psionic_power >= (b.ki_owner.force*0.25)) t.explosion(round(c_l))
								if(c_l>=9 && b.ki_owner.psionic_power >= 1000)
									t.explosion(1)
									b.Boom(b.ki_owner.psionic_power)
								else if(b.ki_owner.force >= 250000 && b.ki_owner.psionic_power >= (b.ki_owner.force*0.25))
									t.explosion(round(c_l))
									b.Boom(b.ki_owner.psionic_power)
								else if(b.ki_owner.force >= 100000 && b.ki_owner.psionic_power >= (b.ki_owner.force*0.25))
									t.explosion(round(c_l)-3)
									b.Boom(b.ki_owner.psionic_power)
								else if(b.ki_owner.force >= 50000 && b.ki_owner.psionic_power >= (b.ki_owner.force*0.25))
									t.explosion(round(c_l)-4)
									b.Boom(b.ki_owner.psionic_power)
								else if(b.ki_owner.force >= 50000 && b.ki_owner.psionic_power >= (b.ki_owner.force*0.125))
									t.explosion(round(c_l)-5)
									b.Boom(b.ki_owner.psionic_power)
						//world << output("[b] tried to cross [src] but was prohibited. (cross ranged)", "chat.system")
						else b.loc = null

						return
		else if(src.density_factor >= 1 && o.density_factor >= 1) if(o.lobber != src) if(!istype(src,/obj/ranged/)) //if(src.ki_owner != o)
			if(o.KB)
				o.KB = 0
				if(o.thrown_str) if(ismob(src))
					var/Damage=o.thrown_str/src.endurance*rand(2,4)
					src.percent_health -= Damage
					src.throw_damage(src,Damage,o.lobber)

				//if(create_dust) src.dust_explosion(33,1)
				if(src.loc)
					var/turf/x = src.loc
					if(x.liquid == null)
						var/obj/effects/craters/crater_small/c = new
						c.loc = src.loc
						c.step_x = src.step_x
						c.step_y = src.step_y

				//if(o.explode_impact) o.explode_impact = 2
				if(isobj(src)) if(src.hp)
					if(src.immune_dmg == 0)
						src.hp -= 34
						if(src.hp <= 0)
							if(istype(src,/obj/items/tech/))
								for(var/turf/trf in src.locs)
									for(var/obj/items/tech/Power_Line/p in trf)
										spawn(0)
											if(p) p.reconnect_power()
							src.loc=null//src.destroy() //del(src)
			//if(o.explode_impact) del(o)
			//del(o)
			if(ismob(o))
				var/mob/m = o
				//if(!m.client) m.dir = rand(1,8)
				if(m.skill_quicksilver && m.skill_quicksilver.active)
					if(m.skill_quicksilver.speed) m.skill_quicksilver.speed.loc = null
					if(m.skill_quicksilver.speed_ramp >= 6)
						m.skill_quicksilver.speed_ramp = 0 // We have this twice, once here and once below, due to the delay sleep() with explosion.
						m.loc.explosion(6)
					m.skill_quicksilver.speed_ramp = 0
			return
		return 1
turf
	Enter(atom/movable/o, atom/oldloc)
		..()
		if(ismob(o))
			var/mob/m = o
			if(m.started)
				if(m.in_space_pod) return
				m.tmp_dmg = src.tmp_dmg
				if(m.skill_quicksilver && m.skill_quicksilver.active && m.tmp_dmg >= 0 && m.skill_quicksilver.speed_ramp >= 3) m.tmp_dmg = 1
				m.grav = src.grav
				m.microwaves = src.microwaves
				//Underwater
				if(m.submerged && src.liquid == null || m.submerged && m.in_space_pod && src.liquid == null)
					m.submerge(0,1,src)
					if(m.client && m.bar_o2) m.client.images -= m.bar_o2
				//If turf is a kind of liquid or has no air, and mob isn't already submerged, then continue.
				if(src.liquid && m.submerged == 0 && m.in_space_pod == 0)
					var/flying = 0
					if(m.skill_flight && m.skill_flight.active) flying = 1
					if(m.skill_levitation && m.skill_levitation.active) flying = 1
					if(flying == 0 || src.liquid == "psionic")
						m.submerge(1,1,src)
						if(m.client && m.bar_o2) m.client.images += m.bar_o2
					/*if(flying == 0)
						//if(m.z!=2)
						m.submerge(1,1,src)
						if(m.client && m.bar_o2) m.client.images += m.bar_o2*/
					/*	else if(m.z==2)
							if(prob(25) && !src.liquid)
								m<<output("You fall into the depths of hell.","actionoutput")
								m.loc=locate(m.x,m.y,6)
								m.check_glow_planes()
								m.KO()*/

		if(src.density_factor >= 1)
			//If a charge or blast hits a solid turf, check if it should explode.
			if(istype(o,/obj/ranged/))
				if(src.immune_dmg == 0)
					var/obj/ranged/b = o
					src.hp -= 0.1
					/*
					if(src.glow == null)
						var/obj/g = new
						g.icon = 'fx_glow.dmi'
						g.layer = 5
						g.loc = src
						g.alpha = 35
						g.icon += rgb(35,0,0)
						g.name = "glow"
						g.immune_dmg = 1
						g.mouse_opacity = 0
						g.bolted = 2
						src.glow = g
					if(src.red < 255)
						src.red += 1
						src.glow.icon += rgb(1,0,0)
						if(src.glow.alpha < 100) src.glow.alpha += 1
					src.set_damage_glow()
					*/
					if(src.damage == null)
						var/obj/effects/damage_roof/d = new
						src.vis_contents += d
						src.damage = d
					else
						var/obj/d = src.damage
						if(src.hp <= src.hp_max/6) d.icon_state = "6"
						else if(src.hp <= src.hp_max/5) d.icon_state = "5"
						else if(src.hp <= src.hp_max/4) d.icon_state = "4"
						else if(src.hp <= src.hp_max/3) d.icon_state = "3"
						else if(src.hp <= src.hp_max/2) d.icon_state = "2"
						else if(src.hp <= src.hp_max/1.1) d.icon_state = "1"
						else d.icon_state = "0"
					if(src.hp <= 0)
						src.filters = null
						if(src.red > 0)
							src.icon -= rgb(src.red,0,0)
							src.red = 0
						var/obj/effects/hit/h = new
						h.loc = o.loc
						h.dir = o.dir
						if(o.dir == SOUTH || o.dir == NORTH) h.pixel_x += 16
						h.step_x = o.step_x
						h.step_y = o.step_y
						view(10,src)<<sound('wallhit.ogg',volume=10)
						spawn(10)
							if(h) h.destroy()
						src.remove_worldmap_building()
						src.set_destroyed()
						for(var/obj/map/cliffs/c in src)
							c.destroy()
						for(var/obj/map/cliffs/c in locate(src.x,src.y-1,src.z))
							c.destroy()
						world.edges_solid_rock(src.x-1,src.y+1,src.x+1,src.y-1,src.z)
						src.og_type = null
					if(b.explode_impact == 1)
						b.explode_impact = 2
						var/c_l = b.charge_lvl-1
						if(istype(b,/obj/ranged/blast)) b.loc = null
						else b.loc = null //del(b)
						if(c_l>=9 && b.ki_owner.psionic_power >= 1000)
							src.explosion(1)
							b.Boom(b.ki_owner.psionic_power)

						else if(b.ki_owner.force >= 250000 && b.ki_owner.psionic_power >= (b.ki_owner.force*0.25))
							src.explosion(round(c_l))
							b.Boom(b.ki_owner.psionic_power)
						else if(b.ki_owner.force >= 100000 && b.ki_owner.psionic_power >= (b.ki_owner.force*0.25))
							src.explosion(round(c_l)-3)
							b.Boom(b.ki_owner.psionic_power)
						else if(b.ki_owner.force >= 50000 && b.ki_owner.psionic_power >= (b.ki_owner.force*0.25))
							src.explosion(round(c_l)-4)
							b.Boom(b.ki_owner.psionic_power)
						else if(b.ki_owner.force >= 40000 && b.ki_owner.psionic_power >= (b.ki_owner.force*0.125))
							src.explosion(round(c_l)-5)
							b.Boom(b.ki_owner.psionic_power)
						return
					if(o.name == "beam checker")
						o.loc = null
						return 1
			else if(o.density_factor >= 1)
				if(o.KB)
					if(src.immune_dmg == 0)
						src.hp -= o.KB
						if(src.damage == null)
							var/obj/effects/damage_roof/d = new
							src.vis_contents += d
							src.damage = d
						else
							var/obj/d = src.damage
							if(src.hp <= src.hp_max/6) d.icon_state = "6"
							else if(src.hp <= src.hp_max/5) d.icon_state = "5"
							else if(src.hp <= src.hp_max/4) d.icon_state = "4"
							else if(src.hp <= src.hp_max/3) d.icon_state = "3"
							else if(src.hp <= src.hp_max/2) d.icon_state = "2"
							else if(src.hp <= src.hp_max/1.1) d.icon_state = "1"
							else d.icon_state = "0"
						if(src.hp <= 0)
							src.filters = null
							if(src.red > 0)
								src.icon -= rgb(src.red,0,0)
								src.red = 0
							var/obj/effects/hit/h = new
							h.loc = o.loc
							h.dir = o.dir
							if(o.dir == SOUTH ||o.dir == NORTH) h.pixel_x += 16
							h.step_x = o.step_x
							h.step_y = o.step_y
							view(10, src) << sound('wallhit.ogg', volume = 15)
							spawn(10)
								if(h) h.destroy()
							src.set_destroyed()
							src.og_type = null

				else if(ismob(o))
					var/mob/m = o
					if(m.skill_quicksilver && m.skill_quicksilver.active)
						if(m.skill_quicksilver.speed) m.skill_quicksilver.speed.loc = null
						if(m.skill_quicksilver.speed_ramp >= 6)
							m.skill_quicksilver.speed_ramp = 0 // We have this twice, once here and once below, due to the delay sleep() with explosion.
							if(m.force >= 50000 && m.psionic_power >= (m.force*0.25)) m.loc.explosion(7)
						m.skill_quicksilver.speed_ramp = 0
				return
			/*
			if(o.density_factor >= 1)
				if(o.ki_owner == null) //If someone tries to walk through or into a ki attack, let them, otherwise all other movement shold be prohibited.
					//world << output("[o] tried to enter [src] but was prohibited. (enter)", "chat.system")
					return
			*/
		if(src.density_factor == 2 && o.density_factor != -1)
			if(ismob(o))
				var/mob/m = o
				if(m.skill_quicksilver && m.skill_quicksilver.active)
					if(m.skill_quicksilver.speed) m.skill_quicksilver.speed.loc = null
					if(m.skill_quicksilver.speed_ramp >= 6)
						m.skill_quicksilver.speed_ramp = 0 // We have this twice, once here and once below, due to the delay sleep() with explosion.
						m.loc.explosion(6)
					m.skill_quicksilver.speed_ramp = 0
			return
		return 1

//	This library is a set of procs for finding, setting,
//	and shifting the absolute pixel positions of atoms.

//	(1, 1) is the bottom-left pixel of the map.

#ifndef TILE_WIDTH
#define TILE_WIDTH 32
#endif

#ifndef TILE_HEIGHT
#define TILE_HEIGHT 32
#endif

atom
	proc
		/* Get the pixel width of this atom's bounding box.
		*/
		Width_lib()  . = TILE_WIDTH

		/* Get the pixel height of this atom's bounding box.
		*/
		Height_lib() . = TILE_HEIGHT

		/* Get the absolute pixel-x-coordinate of the bounding box's left edge.
		*/
		Px(P) . = 1 + (x - 1 + P) * TILE_WIDTH

		/* Get the absolute pixel-y-coordinate of the bounding box's bottom edge.
		*/
		Py(P) . = 1 + (y - 1 + P) * TILE_HEIGHT

		/* Get the absolute pixel-x-coordinate of the bounding box's center.
		*/
		Cx() . = Px(1 / 2)

		/* Get the absolute pixel-y-coordinate of the bounding box's center.
		*/
		Cy() . = Py(1 / 2)

atom/movable
	Width_lib()  . = bound_width
	Height_lib() . = bound_height
	Px(P) . = 1 + bound_x + step_x + (x - 1) * TILE_WIDTH  + P * bound_width
	Py(P) . = 1 + bound_y + step_y + (y - 1) * TILE_HEIGHT + P * bound_height

	var
		/* Accumulates the fractional part of movements in the x-axis.
		*/
		fractional_x

		/* Accumulates the fractional part of movements in the y-axis.
		*/
		fractional_y

	proc
		/* Directly sets the loc and step offsets to the given arguments.

		Best to use a proc for this in case you want to add side effects, which
		you can't have if you're just setting variables directly in code.
		*/
		SetLoc(Loc, StepX = 0, StepY = 0)
			loc = Loc
			step_x = StepX
			step_y = StepY

		/* Directly sets the loc and step offsets in order for the bottom-left
		of the bounding box to be at a given absolute pixel coordinate, or
		to the bottom-left of a given atom.

		Format: SetPosition(atom/Atom)
		Parameters:
		* Atom: The object to align bounding box bottom-left corners with.

		Format: SetPosition(Px, Py, Z)
		Parameters:
		* Px: The desired resulting left x-coordinate.
		* Py: bottom y-coordinate.
		* Z: z-level.
		*/
		SetPosition(Px, Py, Z)
			if(isloc(Px))
				var atom/a = Px
				Px = a.Px()
				Py = a.Py()
				Z = a.z
			SetLoc(
				Loc = locate(
					1 + (Px-1)/TILE_WIDTH,
					1 + (Py-1)/TILE_HEIGHT,
					isnull(Z) ? z : Z),
				StepX = (Px-1) % TILE_WIDTH  - bound_x,
				StepY = (Py-1) % TILE_HEIGHT - bound_y)

		/* Directly sets the loc and step offsets in order for the center of the
		bounding box to be at a given absolute pixel coordinate, or at the
		center of a given atom.

		Behaves kinda screwy (i.e. sends you to the void) at map edges.

		Format: SetCenter(atom/Atom)
		Parameters:
		* Atom: The atom to align bounding box centers with.

		Format: SetCenter(Cx, Cy, Z)
		Parameters:
		* Cx: The desired resulting center x-coordinate.
		* Cy: y-coordinate.
		* Z: z-level.
		*/
		SetCenter(Cx, Cy, Z)
			if(isloc(Cx))
				var atom/a = Cx
				Cx = a.Cx()
				Cy = a.Cy()
				Z = a.z
			SetPosition(Cx - Width_lib()/2, Cy - Height_lib()/2, Z)

		/* Slides this movable atom by a given offset in pixels.

		Fractional movements are preserved in the fractional_x/y variables.
		Preserved, as in successive calls to Translate(0.1, 0) will
		eventually add up to a single-pixel movement to the right.

		Parameters:
		* X: Distance to move along the x-axis in pixels.
		* Y: Distance to move along the y-axis in pixels.

		Returns:
		* null if both arguments are false.
		* TRUE if only the fractional values changed.
		* The result of Move() for a successful whole-pixel movement.
		*/
		Translate(X, Y)
			if(!(X || Y)) return
			var rx, ry
			if(X)
				fractional_x += X
				rx = round(fractional_x, 1)
				fractional_x -= rx
			if(Y)
				fractional_y += Y
				ry = round(fractional_y, 1)
				fractional_y -= ry
			var s = step_size
			step_size = max(abs(rx), abs(ry)) + 1
			. = (rx || ry) ? Move(loc, dir, step_x + rx, step_y + ry) : TRUE
			step_size = s

		/* Slides this movable atom by a given polar vector.

		Uses Translate(), so fractional movements are preserved.

		Parameters:
		* Distance: Distance to move in pixels.
		* Angle: Direction to move in degrees clockwise from NORTH.

		Returns:
		* Whatever Translate() returns.
		*/
		Project(Distance, Angle)
			. = Translate(Distance * sin(Angle), Distance * cos(Angle))
