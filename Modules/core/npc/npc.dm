mob/NPC/Defenders/turret
    npc_ai()
        return

mob
	var
		list/attacked_text
		list/attack_text
		task
		function = null;
		active = 0
		tmp/idle_ticks = 0
	proc
		speech_bubble(var/list/x)
			var/t = pick(x)
			var/obj/effects/txt/s = new
			s.pixel_y = 16
			s.pixel_x = -12
			s.filters += filter(type="outline", size=1, color=rgb(0,0,0))
			s.filters += filter(type="drop_shadow", size=1, offset = 8, color=rgb(255,255,255))
			s.maptext = "[src.name]: [t]"
			var/image/I = new(s,src)
			for(var/mob/m in range(8,src))
				if(m.client)
					m << I
			src.txt_say = I
			I.pixel_z = -100
			I.alpha = 0
			animate(I, pixel_z = 0, alpha = 225, time = 10, easing = ELASTIC_EASING)
			spawn(length(s.maptext)+10)
				if(I) animate(I,alpha = 0,25)
		reset_dialogue(var/mob/m = null)
			if(m) src.talk_to = m
			winset(src,"dialogue.continue","is-visible=false")
			winset(src,"dialogue.option1","is-visible=false")
			winset(src,"dialogue.option2","is-visible=false")
			winset(src,"dialogue.option3","is-visible=false")
			winset(src,"dialogue.option4","is-visible=false")
			winset(src,"dialogue.option5","is-visible=false")
			winset(src,"dialogue.option6","is-visible=false")
			winset(src,"dialogue.option7","is-visible=false")
			winset(src,"dialogue.option8","is-visible=false")
			winset(src,"dialogue.option9","is-visible=false")
			winset(src,"dialogue.option10","is-visible=false")
			winset(src,"dialogue.option11","is-visible=false")
			winset(src,"dialogue.option12","is-visible=false")
			src.topic = null
			src << output(null,"dialogue.dialogue")
		follower_ai(var/n = rand(1111,9999))
			/*
			Some new ideas for the npc ai.
			So give the npc a list of commands
			Then once they finish one command, move onto another.
			For instances like attack others, followed by a grab command. Make it intelligent in that, it waits until the enemy is koed before grabbing them.
			For instances like "search an area", ect. Make a hidden timer for the max time they will spend doing that task before moving onto the next.
			If any of the commands don't make sense, skip it.
			*/

			//world << "DEBUG - running [n]"
			if(src.dismissed) return
			if(src.activated)
				//world << "[src] activated"
				var/T = 10
				if(src.loc == null)
					src.function = null
					src.bar_health = null
					src.bar_energy = null
					src.vis_contents = null
					if(src.owner)
						for(var/mob/m in players)
							if(m.real_name == src.owner)
								src.loc = m.loc
								src.filters = m.filters
								break
				else if(src.koed)
					T = 10
					src.function = null
					//world << "DEBUG - koed"
				else if(src.function == "follow" || src.function == "attack")
					if(src.target_follow)
						//world << "DEBUG - following/attacking"
						T = 0.5
						var/dist = bounds_dist(src, src.target_follow)
						if(dist >= 16 && src.orbiting == 0) if(!src.target_follow.KB && !src.KB) step_towards(src,src.target_follow)
						if(dist >= 640 || src.target_follow.koed) src.target_follow = null
						if(function == "attack" && src.target)
							if(src.divine_weapon == 0) src.Attack()
							else if(src.orbiting == 0)
								if(dist <= 16)
									src.orbiting = 1
									var/d = src.GetAngle(src.target.loc)
									src.orbiting(src,src.target, 0.1,192,d,"attack")
									animate(src,transform = turn(matrix(), 120), time = 6, loop = -1)
									animate(transform = turn(matrix(), 240), time = 6)
									animate(transform = null, time = 6)
									//world << "DEBUG - trying to orbit [src.target]"
								else
									step_towards(src,src.target_follow)
							else if(dist <= 24) src.Attack()
					else src.function = null
				else if(src.function == "go" || src.function == "grab")
					//world << "DEBUG - going/grabbing"
					if(src.target_go)
						T = 0.5
						if(!src.KB)
							step_towards(src,src.target_go)
							var/dist = bounds_dist(src, src.target_go)
							if(dist <= 0)
								if(src.function == "grab" && ismovable(src.target_go))
									src.grab_something(src.target_go)//src.pickup(src.target_go)
									T = 30
								else if(src.function == "go") src.function = null
					else src.function = null
				//src.icon_state = src.state()
				if(src.function == null && src.grab == null)
					src.idle_ticks += 10
					//world << "DEBUG - doing nothing"
					if(src.idle_ticks > 100)
						if(src.divine_weapon == 0)
							if(src.skill_dig)
								if(src.skill_dig.active == 0) src.icon_state = "meditate"
							else src.icon_state = "meditate"
						src.idle_ticks = 0
						src.activated = 0
						//world << "[src] deactivated"
						return
				spawn(T)
					if(src && src.activated)
						if(src.shadow)
							src.set_shadow()
							/*
							src.shadow.loc = src.loc
							src.shadow.step_x = src.step_x+3
							src.shadow.step_y = src.step_y
							*/
						src.follower_ai(n)
			else
				if(src.divine_weapon == 0)
					if(src.skill_dig)
						if(src.skill_dig.active == 0) src.icon_state = "meditate"
					else src.icon_state = "meditate"
				src.idle_ticks = 0
				src.activated = 0
				//world << "[src] deactivated"
				return
	NPC
		/*
		Spawn some NPC in the game that act like players.
		They will decide from a list what to do.
		Make it so if they decide to do something mundane like meditate, they might do it for ages. Put them to sleep so their procs don't bog things, make the sleep/spawn higher.

		.:Actions:.
		Some might start digging
		Explore
		Meditate
		Search for items
		Steal items
		Search for fights
		Fight one another
		Fight player
		Build a house
		Build tech
		Gather/use divine energy
		Gather/use dark matter
		Gift players items
		Practice buffs like Focus, expand, ect.
		Telepath people
		*/
		hashadow = 1
		npc = 1
		var
			tmp/track_ko = null
			tmp/returning = 0
			tmp/list/commands = list()
			prob_ki_atk = 5
			prob_stop_charge = 5
			prob_stop_atk = 5
			test_num = 0
			spot
			Probability = 10

			// === Added for AI ===
			leash_range = 82          // max chase distance from start
			chase_range = 48          // how far NPC detects targets
			//attack_range = 2          // melee distance
			attack_cooldown = 25      // ticks between attacks
			path_retry_delay = 10     // delay before retrying failed move
			follow_speed = 0.4        // step pacing when following
			patrol_speed = 8         // pacing when idle/patrolling
		//	aggressive = 0            // 0 = passive, 1 = aggressive
			follow_delay = 2        // delay between pathing checks
			patrol_delay = 6       // idle pacing
			tmp/fleeing = 0
			tmp/Follow = null
			tmp/pathToFollow = null

			tmp
				last_attack = 0
				path_failed_until = 0
				next_decision = 0


		proc
			/*npc_ai()
				//Make it so npc can make a choice to use different skills
				//Maybe one buff skill chosen?
				//If high energy, use flight?
				//Drops random items, like resources, consumables, and very rarely things like skillbooks, when koed.
				spawn(1)
					if(src)
						if(src.active) return
						else src.active = 1
						while(src.active && src.can_attack)
							var/spd = 10
							var/home_dis = get_dist(src,src.start_loc)
							if(src.koed)
								src.target = null //If koed, reset everything
								src.returning = 0
								src.active_attack = null
								src.active = 0
								src.mouse_down = null
							else if(src.stunned)
								src.active_attack = null
								src.mouse_down = null
							else if(src.returning) //If already returning home, make the steps.
								step_towards(src,src.start_loc)
								spd = 0.5
								if(home_dis < 2)
									src.returning = 0
									src.active = 0
									src.active_attack = null
									src.target = null
									src.mouse_down = null
									src.dir = SOUTH
									if(src.skill_flight.active) call(src.skill_flight.act)(src,src.skill_flight)
							else if(home_dis > 32) //If too far away from start loc, return home.
								src.target = null
								src.mouse_down = null
								src.returning = 1
								if(src.skill_flight && src.skill_flight.active == 0) call(src.skill_flight.act)(src,src.skill_flight)
								spd = 0.5
							else if(src.target) //If they actually have a target, process this code.
								if(src.target.koed)
									src.target = null //If the target is koed, reset target.
									src.returning = 1
									src.active_attack = null
									src.mouse_down = null
									if(src.skill_flight && src.skill_flight.active == 0) call(src.skill_flight.act)(src,src.skill_flight)
								else if(src.grabbed_by && src.target != src.grabbed_by) src.target = src.grabbed_by //Otherwise if  being grabbed by a player, reset target to that player.
								//If npc is not using or charging an attack.
								else if(src.active_attack == null && prob(src.prob_ki_atk) && src.energy >= 11)
									var/s = pick(src.skill_charge,src.skill_beam,src.skill_blast)
									//Choose to use blast
									if(s == src.skill_blast && src.skill_blast)
										spd = 0.5
										spawn(0.1)
											if(src)
												src.mouse_down = src.target.loc
												src.current_attack = src.skill_blast
												//src.skill_blast.active = 1
												call(src.skill_blast,src.skill_blast.act)(src)
									//Choose to use charge
									else if(s == src.skill_charge && src.skill_charge)
										spd = 0.5
										spawn(0.1)
											if(src)
												src.mouse_down = src.target.loc
												src.current_attack = src.skill_charge
												src.skill_charge.active = 1
												call(src.skill_charge,src.skill_charge.act)(src)
									//Choose to use beam
									else if(s == src.skill_beam && src.skill_beam)
										spd = 0.5
										spawn(0.1)
											if(src)
												src.mouse_down = src.target.loc
												src.current_attack = src.skill_beam
												src.skill_beam.active = 1
												call(src.skill_beam,src.skill_beam.act)(src)
								//If charging or using an attack
								else if(src.active_attack)
									spd = 2
									if(src.mouse_down)
										if(prob(src.prob_stop_charge))
											src.mouse_down = null
											if(src.skill_charge && src.current_attack == src.skill_charge) spd = 10 //Small delay when using charge, to stop npc warping into their own attack.
									else if(prob(src.prob_stop_atk))
										src.active_attack = null
										spd = 10
								else if(src.skill_flight && src.skill_flight.active == 0 && src.energy > 1000 && prob(10)) call(src.skill_flight.act)(src,src.skill_flight)
								else if(src.skill_super_speed) //Otherwise should make them super speed to target and attack them
									src.Attack()
									spd = 2
								else if(bounds_dist(src,src.target) > 16) //Otherwise if far away, walk toward them.
									step_towards(src,src.target,4)
									spd = 0.5
									if(src.prob_ki_atk > 0)
										var/p_atk = src.prob_ki_atk
										src.prob_ki_atk = 0
										spawn(20)
											if(src) src.prob_ki_atk = p_atk
								else if(bounds_dist(src,src.target) <= 16)//Otherwise attack them in melee when this close.
									src.Attack()
									spd = 2
								//If charging attack, back away from target.
								if(src.mouse_down || src.active_attack)
									if(src.energy <= 10)
										src.active_attack = null
										src.mouse_down = null
									else if(bounds_dist(src,src.target) <= 64)
										var/d = get_dir(src.target,src)
										step(src,d,8)
										spd = 0.4
							src.get_mouse_pos()
							sleep(spd)
							/*
							else if(src.energy < src.energy_max || src.percent_health < 100)
								src.icon_state = "meditate"
								src.healing()
								spd = 10
							else
								src.icon_state = ""
								src.dir = SOUTH
								spd = 60
							*/
							//sleep(spd)
							*/
		proc
			npc_ai()
				set background = 1
				if(src.active) return
				if(istype(src,/mob/NPC/Animals/T_Rex) || istype(src,/mob/NPC/Animals/Mammoth) || istype(src,/mob/NPC/Animals/Black_Mammoth)) return
				if(istype(src,/mob/NPC/Defenders/) || istype(src,/mob/NPC/People/)) return
				src.active = 1
				if(!src.start_loc) src.start_loc = src.loc

				while(src && !src.koed )
					// KO or stunned disables logic temporarily
					if(src.koed || src.stunned)
						src._reset_npc_combat_state()
						sleep(10)
						continue

					// Too far from home � leash back
					if(get_dist(src, src.start_loc) > src.leash_range)
						src._npc_return_home()
						sleep(src.follow_delay)
						continue

					// Acquire a target if none
					if(!src.target)
						if(src.agressive)
							src.target = src._npc_find_target(src.chase_range)
						if(!src.target && src.track_ko)
							src.target = src.track_ko

					// Handle target logic
					if(src.target)
						if(src.target.koed)
							src.target = null
							sleep(5)
							continue

						var/dist = get_dist(src, src.target)

						//if(dist > src.leash_range)
						//	src._npc_return_home()
						//	sleep(src.follow_delay)
						//	continue

						// Too far? Follow using Eternia�s logic
						if(dist > src.attack_range)
							src.updateFollow(src.target, 0, src.follow_delay)
							sleep(src.follow_delay)
							continue

						// In melee range, attack with cooldown
						if(dist <= src.attack_range)
							if(world.time - src.last_attack >= src.attack_cooldown)
								src.last_attack = world.time
								src.mouse_down = src.target.loc
								if(src.target.koed)

								else if(src.grabbed_by && src.target != src.grabbed_by) src.target = src.grabbed_by //Otherwise if  being grabbed by a player, reset target to that player.
								//If npc is not using or charging an attack.
								else if(src.active_attack == null && prob(src.prob_ki_atk) && src.energy >= 5)
									var/s = pick(src.skill_charge,src.skill_blast)
									//Choose to use blast
									if(s == src.skill_blast && src.skill_blast)
										spawn(0.1)
											if(src)
												src.mouse_down = src.target.loc
												src.current_attack = src.skill_blast
												//src.skill_blast.active = 1
												call(src.skill_blast,src.skill_blast.act)(src)
									if(s == src.skill_charge && src.skill_charge)
										spawn(0.1)
											if(src)
												src.mouse_down = src.target.loc
												src.current_attack = src.skill_charge
												//src.skill_blast.active = 1
												call(src.skill_charge,src.skill_charge.act)(src)
								if(hascall(src, "Attack"))
									call(src, "Attack")()
								else
									src._npc_melee_strike(src.target)
							sleep(4)
							continue

					else
						// Idle patrol if aggressive
						if(src.agressive && prob(35))
							var/tx = src.start_loc.x + rand(-3,3)
							var/ty = src.start_loc.y + rand(-3,3)
							step_towards(src, locate(tx, ty, src.z))
						sleep(src.patrol_delay)
						continue
					sleep(0.2)
				src.active = 0

			// === Eternia-style movement helpers ===
			updateFollow(atom/A, min=0, delay=1)
				if(src.Follow)
					if(get_dist(src,A) <= src.chase_range)
						src.Follow = A
						walk_to(src, src.Follow, 1, delay)
						return 1
					else
						src.Follow = null
						walk_to(src, 0)
						return 0
				else
					if(get_dist(src,A) <= src.chase_range)
						src.Follow = A
						walk_to(src, src.Follow, 1, delay)
						src.FollowLoop(A, min, delay)
						return 1
				return 0

			FollowLoop(atom/A, min=0, delay=1)
				spawn(-1)
					while(src && src.Follow)
						if(src.fleeing) return
						if(!src.Follow || src.loc == A.loc)
							src.Follow = null
							walk_to(src, 0)
							return
						if(get_dist(src, src.Follow) >= src.chase_range)
							src.Follow = null
							walk_to(src, 0)
							return
						sleep(delay)

			_npc_return_home()
				src.Follow = null
				walk_to(src, 0)
				src.returning = 1
				walk_to(src, src.start_loc, 0, 5)
				while(src && get_dist(src, src.start_loc) > 1)
					sleep(2)
				src.returning = 0

			_npc_find_target(var/radius)
				for(var/mob/races/M in view(radius, src))
					if(!M || M == src) continue
					if(M.koed) continue
					if(M.npc) continue
					if(istype(M, /mob/races)) return M
				return null

			_npc_melee_strike(var/mob/T)
				if(!src || !T || T.koed) return
				var/dmg = 5 + src.level
				T.percent_health -= dmg
				if(T.percent_health <= 0)
					T.KO()

			_reset_npc_combat_state()
				src.Follow = null
				walk_to(src, 0)
				src.target = null
				src.mouse_down = null
				src.active_attack = null
				src.returning = 1
		Defenders
			beetle
				icon = 'turret.dmi'
				name = "Giant Beetle"
				gender = "neuter"
				agressive = 1
				race = "Beetle"
				appearance_flags = KEEP_TOGETHER

				attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
				attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"

				proc/beetle_idle_ai()
					if(src.active || src.koed || src.stunned) return
					src.active = 1

					spawn(1)
						while(src && !src.koed)
							// === Scan for players in a 25 tile radius ===
							if(!src.target)
								for(var/mob/M in oview(25, src))
									if(!M.npc && !M.koed && M.client)
										src.target = M
										break

							// === If a target is found, step toward them ===
							if(src.target)
								if(get_dist(src, src.target) > 32)
									step_towards(src, src.target)
								else
									src.Attack()

								if(!src.target || src.target.koed || get_dist(src, src.target) > 320)
									src.target = null

							// === Idle wandering behavior ===
							else
								if(prob(40)) step_rand(src)
								else if(prob(10)) src.dir = pick(NORTH, SOUTH, EAST, WEST)

							sleep(10)
						src.active = 0

				New()
					..()

					src.set_lists()
					sleep(100)
					//src.Android()
					set_stats(33,3333,33,100,33,100,50,50)
					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Human()
					src.name = "Giant Beetle"
					src.real_name = "Giant Beetle"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = rand(1,20)*year
					src.energy = 50
					src.energy_max = 50
					src.strength = 15
					src.endurance = 250
					src.force = 500
					src.resistance = 500
					src.offence = 5
					src.defence = 250

					src.text_color_ic = "purple"
					src.race = "Beetle"
					src.set_icon(src)

				//	src.faction = factions[4]



					if(src.shadow) src.shadow.loc = src.loc
					while(src)
						for(var/turf/g in block(locate(1,1,1),locate(500,500,1)))
							spot = g
						if(src.koed == 0 && src.stunned == 0)
							if(!src.target)
								if(get_dist(src,spot) < 40)
									if(src.task == null)
										if(prob(1)) src.task = "wait"
										else if(prob(99)) step_rand(src)
										else src.dir = rand(1,8)
									else if(prob(0.25))
										src.task = null ; src.icon_state = src.state()
								else step_towards(src,spot)
							if(src.target)
								var/dist = bounds_dist(src, src.target)
								if(dist >= 32) step_towards(src,src.target)
								if(dist >= 320 || src.target.koed) src.target = null
							//else if(prob(0.1)) src.hate_list = list()
						sleep(0.5)
					spawn(20)
						src.beetle_idle_ai()
			turret
				icon = 'turret.dmi'
				name = "Turret"
				gender = "neuter"
				agressive = 1
				race = "Turret"
				appearance_flags = KEEP_TOGETHER

				var
					tmp/turret_ai_running = 0
					tmp/next_fire_time = 0
					tmp/obj/items/tech/Planetary_Hub/hub_connect = null

				// Keep these the way you want
				attack_range = 14        // HARD firing range
				prob_ki_atk = 75

				proc
					turret_cancel_attack()
					// Safety: stop any �stuck� attack state
						src.active_attack = null
						src.current_attack = null
						src.mouse_down = null

					turret_find_target()
						for(var/mob/races/M in oview(25, src))
							if(M && M.client && !M.npc && !M.koed)
								return M
								return null

					turret_idle_ai()
						if(src.turret_ai_running) return
						src.turret_ai_running = 1

						spawn(-1)
							while(src)
								if(src.koed || src.stunned)
									src.target = null
									src.turret_cancel_attack()
									sleep(10)
									continue

									// Acquire/validate target
								if(!src.target || src.target.koed || get_dist(src, src.target) > 25)
									src.target = src.turret_find_target()

								if(src.target)
									var/d = get_dist(src, src.target)

									// Always face target (no movement)
									src.dir = get_dir(src, src.target)

									// Only fire if within 1�10 tiles
									if(d >= 1 && d>= src.attack_range)
										// If your blast system sets active_attack while firing, respect it
										if(!src.active_attack && world.time >= src.next_fire_time)
											if(src.skill_blast && src.energy >= 1)

												src.next_fire_time = world.time + src.attack_cooldown
												src.mouse_down = src.target.loc
												src.current_attack = src.skill_blast
												call(src.skill_blast, src.skill_blast.act)(src)

									else
										// Out of range: stop/cancel any ongoing firing state
										if(src.active_attack || src.current_attack)
											src.turret_cancel_attack()


								else
									// Idle: optionally rotate sometimes
									if(prob(10))
										src.dir = pick(NORTH, SOUTH, EAST, WEST)
								src.get_mouse_pos()
								sleep(15)

				New()
					..()

					src.set_lists()
					sleep(100)

					set_stats(33,3333,33,100,33,100,50,50)
					src.id = global_id
					global_id += 1

					sleep(60)
					src.start_loc = src.loc

					src.name = "Turret"
					src.real_name = "Turret"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = rand(1500,5000)
					src.energy = 999999999
					src.energy_max = 999999999
					src.strength = 15
					src.endurance = 250
					src.force = 250000
					src.resistance = 500
					src.offence = 5
					src.defence = 250
					src.mod_agility = 1.2

					src.text_color_ic = "grey"
					src.race = "Turret"
					src.set_icon(src)
					var/colorz
					switch(rand(1,14))
						if(1)
							colorz=rgb(rand(1,250),rand(1,200),rand(1,250))
						if(2)
							colorz=rgb(rand(20,80),rand(1,200),rand(1,255))
						if(3)
							colorz=rgb(0,rand(80,200),rand(20,255))
						if(4)
							colorz=rgb(rand(1,255),rand(1,20),rand(56,175))
						if(5)
							colorz=rgb(rand(1,60),rand(1,80),rand(1,120))
						if(6)
							colorz=rgb(rand(80,155),0,rand(1,80))
						if(7)
							colorz=rgb(rand(5,253),rand(5,253),rand(5,80))
						if(8)
							colorz=rgb(rand(5,80),rand(5,253),rand(5,253))
						if(9)
							colorz=rgb(rand(5,80),rand(5,80),rand(5,80))
						if(10)
							colorz=rgb(rand(35,153),rand(65,153),rand(95,153))
						if(11)
							colorz=rgb(rand(1,250),rand(1,200),rand(1,250))
						if(12)
							colorz=rgb(rand(0,255),rand(200,255),rand(0,255))
						if(13)
							colorz=rgb(rand(200,255),rand(0,255),rand(0,255))
						if(14)
							colorz=rgb(rand(0,255),rand(0,255),rand(200,255))
					auracolor = colorz

					// Ensure blast exists
					var/obj/skills/Blast/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_blast = f

					// IMPORTANT: do NOT run the old movement/chase loop for turrets.
					// Start turret brain immediately:
					src.turret_idle_ai()
					spawn(5)
						for(var/obj/items/tech/Planetary_Hub/p in PlanetaryHubs)
							if(p.z == src.z)
								src.hub_connect = p
				Del()
					if(src.hub_connect) src.hub_connect.defender_count --
					..()

			/*turret
				icon = 'turret.dmi'
				name = "Turret"
				gender = "neuter"
				agressive = 1
				race = "Turret"
				appearance_flags = KEEP_TOGETHER
				var
					tmp/turret_ai_running = 0
					tmp/next_fire_time = 0
				attack_range = 10
				prob_ki_atk = 100
				attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
				attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"

				proc/turret_idle_ai()
					if(src.active || src.koed || src.stunned) return
					src.active = 1
					world.log << "Turrets Idle Ai Procc'd."
					world<< "Turrets Idle Ai Procc'd."
					spawn()
						while(src && !src.koed)

							// === Scan for players in a 25 tile radius ===
							if(!src.target)
								for(var/mob/races/M in oview(25, src))
									if(!M.npc && !M.koed && M.client)
										src.target = M
										break
								if(prob(20)) step_rand(src)
								else if(prob(10)) src.dir = pick(NORTH, SOUTH, EAST, WEST)
							// === If a target is found, step toward them ===
							else
								var/dist = bounds_dist(src, src.target)
								if(prob(1))
									if(get_dist(src, src.target) > src.attack_range)
										step_towards(src, src.target)

								if(dist <= src.attack_range)
									if(world.time - src.last_attack >= src.attack_cooldown)
										src.last_attack = world.time
										src.mouse_down = src.target.loc
										if(src.target.koed)
											src.target = null //If koed, reset everything
											src.returning = 0
											src.active_attack = null
											src.active = 0
											src.mouse_down = null
										else if(src.grabbed_by && src.target != src.grabbed_by) src.target = src.grabbed_by //Otherwise if  being grabbed by a player, reset target to that player.
										//If npc is not using or charging an attack.
										else if(src.active_attack == null && prob(src.prob_ki_atk) && src.energy >= 1)
											var/s = src.skill_blast
											world<< "Turrets Selecting Blast"
											world.log<< "Turrets Selecting Blast"
											//Choose to use blast
											if(s == src.skill_blast && src.skill_blast)
												spawn(0.1)
													if(src)
														src.mouse_down = src.target.loc
														src.current_attack = src.skill_blast
														//src.skill_blast.active = 1
														world<< "Turrets Blasting"
														world.log<< "Turrets Selecting Blasting"
														call(src.skill_blast,src.skill_blast.act)(src)
														world<< "Turrets Blasted"
														world.log<< "Turrets  Blasted"

										else if(src.active_attack)
											world<< "Turrets Selecting Attack"
											world.log<< "Turrets Selecting Attack"
											if(src.mouse_down)
												if(prob(src.prob_stop_charge))
													src.mouse_down = null
													//if(src.skill_charge && src.current_attack == src.skill_charge) spd = 10 //Small delay when using charge, to stop npc warping into their own attack.
											else if(prob(src.prob_stop_atk))
												src.active_attack = null
											//	spd = 10
										src.get_mouse_pos()

								//else
								//	src.Attack()

								if(!src.target || src.target.koed || get_dist(src, src.target) > 320)
									src.target = null



							sleep(30)
						src.active = 0

				New()
					..()

					src.set_lists()
					sleep(10)
					//src.Android()
					set_stats(33,3333,33,100,33,100,50,50)
					src.id = global_id;
					global_id += 1;
					sleep(20)
					src.start_loc = src.loc
					//src.Human()
					src.name = "Turret"
					src.real_name = "Turret"
				//	src.name_txt()
					//src.create_afterimages()

					src.psionic_power = rand(1,20)*year
					src.energy = 250
					src.energy_max = 250
					src.strength = 1
					src.endurance = 250
					src.force = 500
					src.resistance = 150
					src.offence = 5
					src.defence = 2

					src.text_color_ic = "grey"
					src.race = "Turret"
					src.set_icon(src)

					var/obj/skills/Blast/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_blast = f


				//	src.faction = factions[4]

					if(src.shadow) src.shadow.loc = src.loc
					/*while(src)
						for(var/turf/g in block(locate(1,1,1),locate(500,500,1)))
							spot = g
						if(src.koed == 0 && src.stunned == 0)
							if(!src.target)
								if(get_dist(src,spot) < 40)
									if(src.task == null)
										if(prob(1)) src.task = "wait"
										else if(prob(99)) step_rand(src)
										else src.dir = rand(1,8)
									else if(prob(0.25))
										src.task = null ; src.icon_state = src.state()
								else step_towards(src,spot)
							if(src.target)
								var/dist = bounds_dist(src, src.target)
								if(dist >= 32) step_towards(src,src.target)
								if(dist >= 320 || src.target.koed) src.target = null
							//else if(prob(0.1)) src.hate_list = list()
						sleep(0.5)*/
					spawn(20) src.turret_idle_ai()
					*/
		People
			Auctioneers
				var/house_name = "Earth"
				Earth_AH
					icon = 'EarthDoku.dmi'
					name = "Auctioneer"
					real_name = "Auctioneer"
					fullname = "Auctioneer"
					gender = "neuter"
					agressive = 0
					race = "Earth Auctioneer"
					hp = 999999999999999
					bolted = 2
					appearance_flags = KEEP_TOGETHER
					can_attack = 0
					can_move = 0
					var/icer_delux_value = 50000
					attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
					attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"
					Click(location,control,params)
						..()
						params = params2list(params)
						if(params["right"])
							if(get_dist(usr,src) < 2)
								usr.OpenAuctionHouse(house_name, "buy")
				Namek_AH
					icon = 'NamekDoku.dmi'
					name = "Auctioneer"
					real_name = "Auctioneer"
					fullname = "Auctioneer"
					gender = "neuter"
					agressive = 0
					race = "Namek Auctioneer"
					house_name = "Namek"
					hp = 999999999999999
					bolted = 2
					appearance_flags = KEEP_TOGETHER
					can_attack = 0
					bolted = 2
					can_move = 0
					var/icer_delux_value = 50000
					attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
					attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"
					Click(location,control,params)
						..()
						params = params2list(params)
						if(params["right"])
							if(get_dist(usr,src) < 2)
								usr.OpenAuctionHouse(house_name, "buy")
				Icer_AH
					icon = 'IcerDoku.dmi'
					name = "Auctioneer"
					real_name = "Auctioneer"
					fullname = "Auctioneer"
					gender = "neuter"
					agressive = 0
					race = "Icer Auctioneer"
					house_name = "Icer"
					hp = 999999999999999
					bolted = 2
					appearance_flags = KEEP_TOGETHER
					can_attack = 0
					bolted = 2
					can_move = 0
					var/icer_delux_value = 50000
					attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
					attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"
					Click(location,control,params)
						..()
						params = params2list(params)
						if(params["right"])
							if(get_dist(usr,src) < 2)
								usr.OpenAuctionHouse(house_name, "buy")
				Vegeta_AH
					icon = 'VegetaDoku.dmi'
					name = "Auctioneer"
					real_name = "Auctioneer"
					fullname = "Auctioneer"
					gender = "neuter"
					agressive = 0
					race = "Vegeta Auctioneer"
					house_name = "Vegeta"
					hp = 999999999999999
					bolted = 2
					appearance_flags = KEEP_TOGETHER
					can_attack = 0
					bolted = 2
					can_move = 0
					var/icer_delux_value = 50000
					attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
					attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"
					Click(location,control,params)
						..()
						params = params2list(params)
						if(params["right"])
							if(get_dist(usr,src) < 2)
								usr.OpenAuctionHouse(house_name, "buy")
				CP_AH
					icon = 'EarthDoku.dmi'
					name = "Auctioneer"
					real_name = "Auctioneer"
					fullname = "Auctioneer"
					gender = "neuter"
					agressive = 0
					race = "Checkpoint Auctioneer"
					house_name = "Checkpoint"
					hp = 999999999999999
					bolted = 2
					appearance_flags = KEEP_TOGETHER
					can_attack = 0
					bolted = 2
					can_move = 0
					var/icer_delux_value = 50000
					attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
					attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"
					Click(location,control,params)
						..()
						params = params2list(params)
						if(params["right"])
							if(get_dist(usr,src) < 2)
								usr.OpenAuctionHouse(house_name, "buy")
				Hell_AH
					icon = 'EarthDoku.dmi'
					name = "Auctioneer"
					real_name = "Auctioneer"
					fullname = "Auctioneer"
					gender = "neuter"
					agressive = 0
					race = "Hell Auctioneer"
					house_name = "Hell"
					hp = 999999999999999
					bolted = 2
					appearance_flags = KEEP_TOGETHER
					can_attack = 0
					bolted = 2
					can_move = 0
					var/icer_delux_value = 50000
					attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
					attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"
					Click(location,control,params)
						..()
						params = params2list(params)
						if(params["right"])
							if(get_dist(usr,src) < 2)
								usr.OpenAuctionHouse(house_name, "buy")
				DR_AH
					icon = 'EarthDoku.dmi'
					name = "Auctioneer"
					real_name = "Auctioneer"
					fullname = "Auctioneer"
					gender = "neuter"
					agressive = 0
					race = "Dark Realm Auctioneer"
					house_name = "Dark Realm"
					hp = 999999999999999
					bolted = 2
					appearance_flags = KEEP_TOGETHER
					can_attack = 0
					bolted = 2
					can_move = 0
					var/icer_delux_value = 50000
					attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
					attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"
					Click(location,control,params)
						..()
						params = params2list(params)
						if(params["right"])
							if(get_dist(usr,src) < 2)
								usr.OpenAuctionHouse(house_name, "buy")
				New()
					..()
					src.set_lists()
					sleep(100)
					//src.Android()
					//set_stats(999,3333,99,100,99,9999,590,99)
					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Human()
					src.name = "Auctioneer"
					src.real_name = "Auctioneer"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = 999999999
					src.energy = 100
					src.energy_max = 100
					src.strength = 15
					src.endurance = 25099999999
					src.force = 500
					src.resistance = 500999999
					src.offence = 25
					src.defence = 25099999

					src.text_color_ic = "purple"
					src.set_icon(src)


					if(src.shadow) src.shadow.loc = src.loc
			Shopkeeper
				icon = 'Floating_Cat_Base.dmi'
				name = "Shopkeeper"
				real_name = "Shopkeeper"
				fullname = "Shopkeeper"
				gender = "neuter"
				agressive = 0
				race = "Shopkeeper"
				hp = 999999999999999
				bolted = 2
				appearance_flags = KEEP_TOGETHER
				can_attack = 0
				bolted = 2
				can_move = 0
				var/icer_delux_value = 15000
				attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
				attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"
				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["right"])
						if(get_dist(usr,src) < 2)
							//winshow(src,"inven",1)
							if(src.z == 9)
								switch(input(usr,"Hurry up and buy!") in list ("Cancel","Hair Dye(�50z)","Scissors(�50z)","Sparring Gloves((�100z)","Bedroll(�1,500z)","Deluxe Ship(�15,000z)+"))
									if("Sparring Gloves((�100z)")
										var/value = 100
										var/amount=input(usr,"How much are you buying?:") as num
										if(amount<1) return
										if(usr.resources<(value*amount) )
											usr<<"You cannot afford that."
											return
										switch(input("Which size are you buying?") in list("Kid","Adult/Teen"))
											if("Kid")
												if(usr.resources>=(amount*value))
													var/obj/items/tech/Kid_Sparring_Gloves/sc = new /obj/items/tech/Kid_Sparring_Gloves(src.loc)
													sc.stacks = (amount)
													sc.tech_lvl = 500
													usr.pickup(sc)
													usr<<"You purchased x[amount] Sparring Gloves(s)"
													usr.resources -= (amount*value)
													usr.refresh_inv()
											if("Adult/Teen")
												if(usr.resources>=(amount*value))
													var/obj/items/tech/Sparring_Gloves/sc = new /obj/items/tech/Sparring_Gloves(src.loc)
													sc.stacks = (amount)
													sc.tech_lvl = 500
													usr.pickup(sc)
													usr<<"You purchased x[amount] Sparring Gloves(s)"
													usr.resources -= (amount*value)
													usr.refresh_inv()

									if("Bedroll(�1,500z)")
										var/value = 1500
										var/amount=input(usr,"How much are you buying?:") as num
										if(amount<1) return
										if(usr.resources<(value*amount) )
											usr<<"You cannot afford that."
											return
										if(usr.resources>=(amount*value))
											var/obj/items/Bedroll/sc = new /obj/items/Bedroll(src.loc)
											sc.stacks = (amount)
											sc.tech_lvl = 500
											usr.pickup(sc)
											usr<<"You purchased x[amount] Bedroll(s)"
											usr.resources -= (amount*value)
											usr.refresh_inv()
									if("Hair Dye(�50z)")
										var/value = 50
										var/amount=input(usr,"How much are you buying?:") as num
										if(amount<1) return
										if(usr.resources<(value*amount) )
											usr<<"You cannot afford that."
											return
										if(usr.resources>=(amount*value))
											var/obj/items/Hair_Dye/sc = new /obj/items/Hair_Dye(src.loc)
											sc.stacks = (amount)
											usr.pickup(sc)
											usr<<"You purchased x[amount] Hair Dye(s)"
											usr.resources -= (amount*value)
											usr.refresh_inv()
									if("Scissors(�50z)")
										var/value = 50
										var/amount=input(usr,"How much are you buying?:") as num
										if(amount<1) return
										if(usr.resources<(value*amount) )
											usr<<"You cannot afford that."
											return
										if(usr.resources>=(amount*value))
											var/obj/items/Scissors/sc = new /obj/items/Scissors(src.loc)
											sc.stacks = (amount)
											usr.pickup(sc)
											usr<<"You purchased x[amount] Scissors(s)"
											usr.resources -= (amount*value)
											usr.refresh_inv()
									if("Deluxe Ship(�15,000z)+")
										switch(alert(usr,"The Current Price is: [src.icer_delux_value]","","Purchase","Cancel"))
											if("Purchase")
												if(usr.resources<src.icer_delux_value )
													usr<<"You cannot afford that."
													return
												if(usr.resources>=src.icer_delux_value)
													var/obj/items/tech/Capsule/capsule = new /obj/items/tech/Capsule(usr.loc)
													var/obj/items/tech/ships/Deluxe_Ship/sc = new /obj/items/tech/ships/Deluxe_Ship(capsule,1)
													//var/obj/items/tech/ships/CC_Ship/sc = new /obj/items/tech/ships/CC_Ship(capsule,1)
													sleep(0.1)
													//capsule.contents += sc
													capsule.storeditem = sc
													capsule.suffix = "Capsule - [sc.name]"
													capsule.occupied = 1
													sc.tech_lvl = 500
													usr.pickup(capsule)
													usr<<"You purchased a Deluxe Ship and received a capsule with it inside!"
													usr.resources -= value
													src.icer_delux_value += 25000
													usr.refresh_inv()

							else
								switch(input(usr,"Hurry up and buy!") in list ("Cancel","Hair Dye(�50z)","Scissors(�50z)","Sparring Gloves((�100z)","Bedroll(�1,500z)"))
									if("Sparring Gloves((�100z)")
										var/value = 100
										var/amount=input(usr,"How much are you buying?:") as num
										if(amount<1) return
										if(usr.resources<(value*amount) )
											usr<<"You cannot afford that."
											return
										switch(input("Which size are you buying?") in list("Kid","Adult/Teen"))
											if("Kid")
												if(usr.resources>=(amount*value))
													var/obj/items/tech/Kid_Sparring_Gloves/sc = new /obj/items/tech/Kid_Sparring_Gloves(src.loc)
													sc.stacks = (amount)
													usr.pickup(sc)
													usr<<"You purchased x[amount] Sparring Gloves(s)"
													usr.resources -= (amount*value)
													usr.refresh_inv()
											if("Adult/Teen")
												if(usr.resources>=(amount*value))
													var/obj/items/tech/Sparring_Gloves/sc = new /obj/items/tech/Sparring_Gloves(src.loc)
													sc.stacks = (amount)
													usr.pickup(sc)
													usr<<"You purchased x[amount] Sparring Gloves(s)"
													usr.resources -= (amount*value)
													usr.refresh_inv()

									if("Bedroll(�1,500z)")
										var/value = 1500
										var/amount=input(usr,"How much are you buying?:") as num
										if(amount<1) return
										if(usr.resources<(value*amount) )
											usr<<"You cannot afford that."
											return
										if(usr.resources>=(amount*value))
											var/obj/items/Bedroll/sc = new /obj/items/Bedroll(src.loc)
											sc.stacks = (amount)
											usr.pickup(sc)
											usr<<"You purchased x[amount] Bedroll(s)"
											usr.resources -= (amount*value)
											usr.refresh_inv()
									if("Hair Dye(�50z)")
										var/value = 50
										var/amount=input(usr,"How much are you buying?:") as num
										if(amount<1) return
										if(usr.resources<(value*amount) )
											usr<<"You cannot afford that."
											return
										if(usr.resources>=(amount*value))
											var/obj/items/Hair_Dye/sc = new /obj/items/Hair_Dye(src.loc)
											sc.stacks = (amount)
											usr.pickup(sc)
											usr<<"You purchased x[amount] Hair Dye(s)"
											usr.resources -= (amount*value)
											usr.refresh_inv()
									if("Scissors(�50z)")
										var/value = 50
										var/amount=input(usr,"How much are you buying?:") as num
										if(amount<1) return
										if(usr.resources<(value*amount) )
											usr<<"You cannot afford that."
											return
										if(usr.resources>=(amount*value))
											var/obj/items/Scissors/sc = new /obj/items/Scissors(src.loc)
											sc.stacks = (amount)
											usr.pickup(sc)
											usr<<"You purchased x[amount] Scissors(s)"
											usr.resources -= (amount*value)
											usr.refresh_inv()

						//	usr.open_menus.Add(".open_inven")

						/*	if(usr.shop_opened)
							//winshow(usr,"inven",0)
								usr.client.screen -= src.hud_invshop
								usr.shop_opened = 0
								usr.current_shop = null
								//usr.open_menus.Remove(".open_inven")
							else
								usr.accessing = src
								//winshow(usr,"inven",1)
								usr.client.screen += src.hud_invshop
								src.hud_invshop.shopper = usr
								usr.shop_opened = 1
								usr.current_shop = src.hud_invshop
								//usr.open_menus.Add(".open_inven")
								src.refresh_inv()*/
						winset(usr,"map.map","focus=true")
				New()
					..()
					src.set_lists()
					sleep(100)
					//src.Android()
					//set_stats(999,3333,99,100,99,9999,590,99)
					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Human()
					src.name = "Shopkeeper"
					src.real_name = "Shopkeeper"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = 999999999
					src.energy = 100
					src.energy_max = 100
					src.strength = 15
					src.endurance = 25099999999
					src.force = 500
					src.resistance = 500999999
					src.offence = 25
					src.defence = 25099999

					src.text_color_ic = "purple"
					src.set_icon(src)


					if(src.shadow) src.shadow.loc = src.loc

		Attack_Bot
			icon = 'CBot.dmi'
			name = "Attack Bot"
			gender = "neuter"
			agressive = 1
			race = "Attack Bot"
			appearance_flags = KEEP_TOGETHER
			fullname = "Attack Bot"
			attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
			attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"

			Click(location,control,params)
				..()
				params = params2list(params)
				if(params["right"])
					usr.open_dialogue = 1
					usr.open_menus.Add(".close_dialogue")
					if(get_dist(usr,src) < 3)
						usr.talk_to = src
						winshow(usr, "dialogue", 1)

						winset(usr,"dialogue.label_title","text=\"[src.name]\"")
						winset(usr,"dialogue.age_text","text=\"[src.age]\"")
						winset(usr,"dialogue.gender_text","text=\"[src.gender]\"")


						var/icon/I = icon(src.icon,"",EAST,1,0)
						I.Scale(128,128)

						if(src.hair)
							var/icon/E = icon(src.hair.icon,"",EAST,1,0)
							E.Scale(128,128)

							//var/obj/Z = new
							I.Blend(E,ICON_OVERLAY)
						//Z.icon = E

						var/X = fcopy_rsc(I)
						winset(usr,"dialogue.portrait","image=\ref[X]")
			New()
				..()
				src.set_lists()
				sleep(100)
				//src.Android()
				set_stats(33,3333,33,100,33,100,50,50)
				src.id = global_id;
				global_id += 1;
				sleep(60)
				src.start_loc = src.loc
				//src.Human()
				src.name = "Attack Bot"
				src.real_name = "Attack Bot"
				src.name_txt()
				src.create_afterimages()

				src.psionic_power = rand(1,10)*year
				src.energy = 100
				src.energy_max = 100
				src.strength = 15
				src.endurance = 250
				src.force = 500
				src.resistance = 500
				src.offence = 25
				src.defence = 250

				src.text_color_ic = "purple"
				src.race = "Attack Bot"
				src.set_icon(src)

			//	src.faction = factions[4]

				var/obj/skills/Flight/f = new
				f.loc = src
				f.skill_lvl = 25
				src.skill_flight = f

				if(src.shadow) src.shadow.loc = src.loc
				while(src)
					for(var/turf/g in block(locate(1,1,1),locate(500,500,1)))
						spot = g
					if(src.koed == 0 && src.stunned == 0)
						if(!src.target)
							if(get_dist(src,spot) < 40)
								if(src.task == null)
									if(prob(1)) src.task = "wait"
									else if(prob(99)) step_rand(src)
									else src.dir = rand(1,8)
								else if(prob(0.25))
									src.task = null ; src.icon_state = src.state()
							else step_towards(src,spot)
						if(src.target)
							var/dist = bounds_dist(src, src.target)
							if(dist >= 32) step_towards(src,src.target)
							if(dist >= 320 || src.target.koed) src.target = null
						//else if(prob(0.1)) src.hate_list = list()
					sleep(0.5)

		Animals
			proc/activate()
				src.set_lists()
				//sleep(100)
				//src.Android()
				//set_stats(33,3333,33,100,33,100,50,50)

				src.id = global_id;
				global_id += 1;
				//sleep(60)
				src.start_loc = src.loc
				//src.Human()

				src.name_txt()
				src.create_afterimages()



				src.text_color_ic = "grey"
				src.race = "Animal"
			//	src.set_icon(src)
			//	src.faction = factions[4]

				if(src.shadow) src.shadow.loc = src.loc
				src.respawnloc = src.loc=locate(src.x,src.y,src.z)
				switch(rand(1,5))
					if(1)
						var/obj/items/consumables/food/raw_legmeat/legmeat = new
						legmeat.loc = src
					if(2)
						var/obj/items/consumables/food/raw_legmeat/legmeat = new
						legmeat.loc = src
					if(3)
						var/obj/items/consumables/food/raw_steak/steak = new
						steak.loc = src
					if(4)
						var/obj/items/consumables/food/raw_steak/steak = new
						steak.loc = src
					if(5)
						var/obj/items/consumables/food/raw_steak/steak = new
						var/obj/items/consumables/food/raw_legmeat/legmeat = new
						steak.loc = src
						legmeat.loc = src
				if(istype(src,/mob/NPC/Animals/Sheep))
					var/obj/items/wool/wl = new
					wl.loc = src
				if(istype(src,/mob/NPC/Animals/Mammoth) || istype(src,/mob/NPC/Animals/Black_Mammoth))
					var/obj/items/clothing/fur_skirt/fr = new(src)
					fr.loc = src
				if(istype(src,/mob/NPC/Animals/Dinosaur))
					var/obj/items/clothing/fur/fr = new(src)
					fr.loc = src
				while(src)
					for(var/turf/g in block(locate(1,1,1),locate(500,500,1)))
						spot = g
					if(src.koed == 0 && src.stunned == 0)
						if(!src.target)
							if(get_dist(src,spot) < 40)
								if(src.task == null)
									if(prob(15)) src.task = "wait"
									else if(prob(88)) step_rand(src)
									else src.dir = rand(1,8)
								else if(prob(0.25))
									src.task = null ; src.icon_state = src.state()
							else step_towards(src,spot)
						if(src.target)
							var/dist = bounds_dist(src, src.target)
							if(dist >= 32) step_towards(src,src.target)
							if(dist >= 320 || src.target.koed) src.target = null
						//else if(prob(0.1)) src.hate_list = list()
					sleep(2)
			proc/is_contact_predator()
				if(istype(src,/mob/NPC/Animals/T_Rex) || istype(src,/mob/NPC/Animals/Mammoth) || istype(src,/mob/NPC/Animals/Black_Mammoth))
					return 1
				return 0
			proc/try_contact_attack()
				if(!src || !src.target) return
				if(src.koed || src.stunned) return
				if(src.target.koed || src.target.dead)
					src.target = null
					return
				if(!src.is_contact_predator()) return
				if(src.active_attack || src.current_attack || src.mouse_down) return
				if(bounds_dist(src, src.target) <= 0)
					if(world.time - src.last_attack >= src.attack_cooldown)
						src.last_attack = world.time
						src.dir = get_dir(src, src.target)
						src.spawn_melee_hit_effect(src.target)
						src._npc_melee_strike(src.target)
			Pterodactyl
				icon = 'PterodactylG.dmi'
				name = "Pterodactyl"
				gender = "neuter"
				agressive = 1
				race = "Pterodactyl"
				appearance_flags = KEEP_TOGETHER
				respawn_type = /mob/NPC/Animals/Pterodactyl
				fullname = "Pterodactyl"
				attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
				attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"

				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["right"])
						usr.open_dialogue = 1
						usr.open_menus.Add(".close_dialogue")
						if(get_dist(usr,src) < 3)
							usr.talk_to = src
							winshow(usr, "dialogue", 1)

							winset(usr,"dialogue.label_title","text=\"[src.name]\"")
							winset(usr,"dialogue.age_text","text=\"[src.age]\"")
							winset(usr,"dialogue.gender_text","text=\"[src.gender]\"")


							var/icon/I = icon(src.icon,"",EAST,1,0)
							I.Scale(128,128)

							if(src.hair)
								var/icon/E = icon(src.hair.icon,"",EAST,1,0)
								E.Scale(128,128)

								//var/obj/Z = new
								I.Blend(E,ICON_OVERLAY)
							//Z.icon = E

							var/X = fcopy_rsc(I)
							winset(usr,"dialogue.portrait","image=\ref[X]")
				New()
					..()
					src.set_lists()
					sleep(100)
					//src.Android()
					set_stats(33,3333,33,100,33,100,50,50)
					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Human()
					src.name = "Pterodactyl"
					src.real_name = "Pterodactyl"

					src.name_txt()
					src.create_afterimages()

					src.psionic_power = rand(1,10)*year
					src.energy = 50
					src.energy_max = 50
					src.strength = 9
					src.endurance = 9
					src.force = 25
					src.resistance = 9
					src.offence = 5
					src.defence = 2

					src.text_color_ic = "purple"
					src.race = "Pterodactyl"
					src.set_icon(src)


				//	src.faction = factions[4]

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					if(src.shadow) src.shadow.loc = src.loc
					src.respawnloc = src.loc=locate(src.x,src.y,src.z)
					switch(rand(1,5))
						if(1)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							legmeat.loc = src
						if(2)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new/obj/items/consumables/food/raw_legmeat(src)
							legmeat.loc = src
						if(3)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							steak.loc = src
						if(4)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							steak.loc = src
						if(5)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							steak.loc = src
							legmeat.loc = src

					while(src)
						for(var/turf/g in block(locate(1,1,1),locate(500,500,1)))
							spot = g
						if(src.koed == 0 && src.stunned == 0)
							if(!src.target)
								if(get_dist(src,spot) < 40)
									if(src.task == null)
										if(prob(1)) src.task = "wait"
										else if(prob(99)) step_rand(src)
										else src.dir = rand(1,8)
									else if(prob(0.25))
										src.task = null ; src.icon_state = src.state()
								else step_towards(src,spot)
							if(src.target)
								var/dist = bounds_dist(src, src.target)
								if(dist >= 32) step_towards(src,src.target)
								if(dist >= 320 || src.target.koed) src.target = null
							//else if(prob(0.1)) src.hate_list = list()
						sleep(0.5)
			Dragon
				icon = 'IcarusDragon.dmi'
				name = "Dragon"
				gender = "neuter"
				agressive = 1
				race = "Dragon"
				fullname = "Dragon"
				appearance_flags = KEEP_TOGETHER
				respawn_type = /mob/NPC/Animals/Dragon

				attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
				attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"

				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["right"])
						usr.open_dialogue = 1
						usr.open_menus.Add(".close_dialogue")
						if(get_dist(usr,src) < 3)
							usr.talk_to = src
							winshow(usr, "dialogue", 1)

							winset(usr,"dialogue.label_title","text=\"[src.name]\"")
							winset(usr,"dialogue.age_text","text=\"[src.age]\"")
							winset(usr,"dialogue.gender_text","text=\"[src.gender]\"")


							var/icon/I = icon(src.icon,"",EAST,1,0)
							I.Scale(128,128)

							if(src.hair)
								var/icon/E = icon(src.hair.icon,"",EAST,1,0)
								E.Scale(128,128)

								//var/obj/Z = new
								I.Blend(E,ICON_OVERLAY)
							//Z.icon = E

							var/X = fcopy_rsc(I)
							winset(usr,"dialogue.portrait","image=\ref[X]")
				New()
					..()
					src.set_lists()
					sleep(100)
					//src.Android()
					set_stats(33,3333,33,100,33,100,50,50)
					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Human()
					src.name = "Dragon"
					src.real_name = "Dragon"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = rand(1,10)*year
					src.energy = 50
					src.energy_max = 50
					src.strength = 15
					src.endurance = 5
					src.force = 25
					src.resistance = 2
					src.offence = 5
					src.defence = 2

					src.text_color_ic = "purple"
					src.race = "Dragon"
					src.set_icon(src)

				//	src.faction = factions[4]

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f
					switch(rand(1,5))
						if(1)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							legmeat.loc = src
						if(2)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new/obj/items/consumables/food/raw_legmeat(src)
							legmeat.loc = src
						if(3)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							steak.loc = src
						if(4)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							steak.loc = src
						if(5)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							steak.loc = src
							legmeat.loc = src

					if(src.shadow) src.shadow.loc = src.loc
					src.respawnloc = src.loc=locate(src.x,src.y,src.z)
					while(src)
						for(var/turf/g in block(locate(1,1,1),locate(500,500,1)))
							spot = g
						if(src.koed == 0 && src.stunned == 0)
							if(!src.target)
								if(get_dist(src,spot) < 40)
									if(src.task == null)
										if(prob(1)) src.task = "wait"
										else if(prob(99)) step_rand(src)
										else src.dir = rand(1,8)
									else if(prob(0.25))
										src.task = null ; src.icon_state = src.state()
								else step_towards(src,spot)
							if(src.target)
								var/dist = bounds_dist(src, src.target)
								if(dist >= 32) step_towards(src,src.target)
								if(dist >= 320 || src.target.koed) src.target = null
							//else if(prob(0.1)) src.hate_list = list()
						sleep(0.5)


			Large_Fish
				icon = 'Large_Fish.dmi'
				name = "Large Fish"
				gender = "neuter"
				agressive = 1
				race = "Large Fish"
				fullname = "Fish"
				appearance_flags = KEEP_TOGETHER

				attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
				attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"

				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["right"])
						usr.open_dialogue = 1
						usr.open_menus.Add(".close_dialogue")
						if(get_dist(usr,src) < 3)
							usr.talk_to = src
							winshow(usr, "dialogue", 1)

							winset(usr,"dialogue.label_title","text=\"[src.name]\"")
							winset(usr,"dialogue.age_text","text=\"[src.age]\"")
							winset(usr,"dialogue.gender_text","text=\"[src.gender]\"")


							var/icon/I = icon(src.icon,"",EAST,1,0)
							I.Scale(128,128)

							if(src.hair)
								var/icon/E = icon(src.hair.icon,"",EAST,1,0)
								E.Scale(128,128)

								//var/obj/Z = new
								I.Blend(E,ICON_OVERLAY)
							//Z.icon = E

							var/X = fcopy_rsc(I)
							winset(usr,"dialogue.portrait","image=\ref[X]")
				New()
					..()
					src.set_lists()
					sleep(100)
					//src.Android()
					set_stats(33,3333,33,100,33,100,50,50)
					src.name_txt()

					src.faction = factions[4]


					if(src.shadow) src.shadow.loc = src.loc
					while(src)
						for(var/turf/g in block(locate(1,1,1),locate(500,500,1)))
							spot = g
						if(src.koed == 0 && src.stunned == 0)
							if(!src.target)
								if(get_dist(src,spot) < 40)
									if(src.task == null)
										if(prob(1)) src.task = "wait"
										else if(prob(99)) step_rand(src)
										else src.dir = rand(1,8)
									else if(prob(0.25))
										src.task = null ; src.icon_state = src.state()
								else step_towards(src,spot)
							if(src.target)
								var/dist = bounds_dist(src, src.target)
								if(dist >= 32) step_towards(src,src.target)
								if(dist >= 320 || src.target.koed) src.target = null
							//else if(prob(0.1)) src.hate_list = list()
						sleep(0.5)
			Small_Fish
				icon = 'Small_Fish.dmi'
				name = "Small Fish"
				gender = "neuter"
				agressive = 1
				race = "Small Fish"
				fullname = "Fish"
				appearance_flags = KEEP_TOGETHER

				attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
				attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"

				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["right"])
						usr.open_dialogue = 1
						usr.open_menus.Add(".close_dialogue")
						if(get_dist(usr,src) < 3)
							usr.talk_to = src
							winshow(usr, "dialogue", 1)

							winset(usr,"dialogue.label_title","text=\"[src.name]\"")
							winset(usr,"dialogue.age_text","text=\"[src.age]\"")
							winset(usr,"dialogue.gender_text","text=\"[src.gender]\"")


							var/icon/I = icon(src.icon,"",EAST,1,0)
							I.Scale(128,128)

							if(src.hair)
								var/icon/E = icon(src.hair.icon,"",EAST,1,0)
								E.Scale(128,128)

								//var/obj/Z = new
								I.Blend(E,ICON_OVERLAY)
							//Z.icon = E

							var/X = fcopy_rsc(I)
							winset(usr,"dialogue.portrait","image=\ref[X]")
				New()
					..()
					src.set_lists()
					sleep(100)
					//src.Android()
					set_stats(33,3333,33,100,33,100,50,50)
					src.name_txt()

					src.faction = factions[4]


					if(src.shadow) src.shadow.loc = src.loc
					while(src)
						for(var/turf/g in block(locate(1,1,1),locate(500,500,1)))
							spot = g
						if(src.koed == 0 && src.stunned == 0)
							if(!src.target)
								if(get_dist(src,spot) < 40)
									if(src.task == null)
										if(prob(1)) src.task = "wait"
										else if(prob(99)) step_rand(src)
										else src.dir = rand(1,8)
									else if(prob(0.25))
										src.task = null ; src.icon_state = src.state()
								else step_towards(src,spot)
							if(src.target)
								var/dist = bounds_dist(src, src.target)
								if(dist >= 32) step_towards(src,src.target)
								if(dist >= 320 || src.target.koed) src.target = null
							//else if(prob(0.1)) src.hate_list = list()
						sleep(0.5)
			T_Rex
				icon = 'T-Rex_Colorable.dmi'
				name = "T Rex"
				gender = "neuter"
				agressive = 0
				race = "T Rex"
				fullname = "T Rex"
				appearance_flags = KEEP_TOGETHER
				respawn_type = /mob/NPC/Animals/T_Rex

				attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
				attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"

				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["right"])
						usr.open_dialogue = 1
						usr.open_menus.Add(".close_dialogue")
						if(get_dist(usr,src) < 3)
							usr.talk_to = src
							winshow(usr, "dialogue", 1)

							winset(usr,"dialogue.label_title","text=\"[src.name]\"")
							winset(usr,"dialogue.age_text","text=\"[src.age]\"")
							winset(usr,"dialogue.gender_text","text=\"[src.gender]\"")


							var/icon/I = icon(src.icon,"",EAST,1,0)
							I.Scale(128,128)

							if(src.hair)
								var/icon/E = icon(src.hair.icon,"",EAST,1,0)
								E.Scale(128,128)

								//var/obj/Z = new
								I.Blend(E,ICON_OVERLAY)
							//Z.icon = E

							var/X = fcopy_rsc(I)
							winset(usr,"dialogue.portrait","image=\ref[X]")
				New()
					..()
					src.set_lists()
					sleep(100)
					//src.Android()
					set_stats(33,3333,33,100,33,100,50,50)
					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Human()
					src.name = "T Rex"
					src.real_name = "T Rex"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = rand(2,3)*year
					src.energy = 200
					src.energy_max = 200
					src.strength = 2
					src.endurance = 10
					src.force = 1
					src.resistance = 10
					src.offence = 2
					src.defence = 1

					src.text_color_ic = "red"
					src.race = "T Rex"
					src.set_icon(src)
					src.respawnloc = src.loc=locate(src.x,src.y,src.z)

					//src.faction = factions[4]
					if(prob(50)) src.icon = 'T-Rex_Genesis.dmi'
					else
						var/randomcolor = rgb(rand(1,255),rand(1,255),rand(1,255))
						src.icon *= randomcolor

					switch(rand(1,5))
						if(1)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							var/obj/items/clothing/fur_skirt/fr = new /obj/items/clothing/fur_skirt(src)
							fr.loc = src
							legmeat.loc = src
						if(2)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new/obj/items/consumables/food/raw_legmeat(src)
							var/obj/items/clothing/fur/fr = new /obj/items/clothing/fur(src)
							fr.loc = src
							legmeat.loc = src
						if(3)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							var/obj/items/clothing/fur_skirt/fr = new /obj/items/clothing/fur_skirt(src)
							fr.loc = src
							steak.loc = src
						if(4)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							var/obj/items/clothing/fur/fr = new /obj/items/clothing/fur(src)
							fr.loc = src
							steak.loc = src
						if(5)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							steak.loc = src
							legmeat.loc = src
					var/obj/items/clothing/fur/fr = new
					fr.loc = src
					if(src.shadow) src.shadow.loc = src.loc
					while(src)
						for(var/turf/g in block(locate(1,1,1),locate(500,500,1)))
							spot = g
						if(src.koed == 0 && src.stunned == 0)
							if(!src.target)
								if(get_dist(src,spot) < 40)
									if(src.task == null)
										if(prob(1)) src.task = "wait"
										else if(prob(99)) step_rand(src)
										else src.dir = rand(1,8)
									else if(prob(0.25))
										src.task = null ; src.icon_state = src.state()
								else step_towards(src,spot)
							if(src.target)
								src.try_contact_attack()
								var/dist = bounds_dist(src, src.target)
								if(dist >= 32) step_towards(src,src.target)
								if(dist >= 320 || src.target.koed || src.target.dead) src.target = null
							//else if(prob(0.1)) src.hate_list = list()
						sleep(0.5)

			Dinosaur
				icon = 'Dino.dmi'
				icon_state = "Dino"
				name = "Dinosaur"
				gender = "neuter"
				agressive = 1
				race = "Dinosaur"
				fullname = "Dinosaur"
				appearance_flags = KEEP_TOGETHER
				respawn_type = /mob/NPC/Animals/Dinosaur
				attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
				attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"

				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["right"])
						usr.open_dialogue = 1
						usr.open_menus.Add(".close_dialogue")
						if(get_dist(usr,src) < 3)
							usr.talk_to = src
							winshow(usr, "dialogue", 1)

							winset(usr,"dialogue.label_title","text=\"[src.name]\"")
							winset(usr,"dialogue.age_text","text=\"[src.age]\"")
							winset(usr,"dialogue.gender_text","text=\"[src.gender]\"")


							var/icon/I = icon(src.icon,"",EAST,1,0)
							I.Scale(128,128)

							if(src.hair)
								var/icon/E = icon(src.hair.icon,"",EAST,1,0)
								E.Scale(128,128)

								//var/obj/Z = new
								I.Blend(E,ICON_OVERLAY)
							//Z.icon = E

							var/X = fcopy_rsc(I)
							winset(usr,"dialogue.portrait","image=\ref[X]")
				New()
					..()
					src.set_lists()
					sleep(100)
					//src.Android()
					set_stats(33,3333,33,100,33,100,50,50)
					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Human()
					src.name = "Dinosaur"
					src.real_name = "Dinosaur"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = rand(1,2)*year
					src.energy = 200
					src.energy_max = 200
					src.strength = 1
					src.endurance = 5
					src.force = 1
					src.resistance = 5
					src.offence = 1
					src.defence = 1

					src.text_color_ic = "red"
					src.race = "Dinosaur"
					src.set_icon(src)
					//src.faction = factions[4]
					src.respawnloc = src.loc=locate(src.x,src.y,src.z)
					switch(rand(1,5))
						if(1)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							var/obj/items/clothing/fur/fr = new /obj/items/clothing/fur(src)
							fr.loc = src
							legmeat.loc = src
						if(2)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new/obj/items/consumables/food/raw_legmeat(src)
							var/obj/items/clothing/fur_skirt/fr = new /obj/items/clothing/fur_skirt(src)
							fr.loc = src
							legmeat.loc = src
						if(3)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)

							steak.loc = src
						if(4)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							steak.loc = src
						if(5)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							var/obj/items/clothing/fur/fr = new /obj/items/clothing/fur(src)
							fr.loc = src
							steak.loc = src
							legmeat.loc = src
					var/obj/items/clothing/fur/fr = new
					fr.loc = src
					if(src.shadow) src.shadow.loc = src.loc
					while(src)
						for(var/turf/g in block(locate(1,1,1),locate(500,500,1)))
							spot = g
						if(src.koed == 0 && src.stunned == 0)
							if(!src.target)
								if(get_dist(src,spot) < 40)
									if(src.task == null)
										if(prob(1)) src.task = "wait"
										else if(prob(99)) step_rand(src)
										else src.dir = rand(1,8)
									else if(prob(0.25))
										src.task = null ; src.icon_state = src.state()
								else step_towards(src,spot)
							if(src.target)
								var/dist = bounds_dist(src, src.target)
								if(dist >= 32) step_towards(src,src.target)
								if(dist >= 320 || src.target.koed) src.target = null
							//else if(prob(0.1)) src.hate_list = list()
						sleep(0.5)
			Black_Mammoth
				icon = 'MammothColorable.dmi'
				icon_state = ""
				name = "Mammoth"
				gender = "neuter"
				agressive = 0
				race = "Mammoth"
				fullname = "Mammoth"
				appearance_flags = KEEP_TOGETHER
				respawn_type = /mob/NPC/Animals/Black_Mammoth
				attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
				attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"

				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["right"])
						usr.open_dialogue = 1
						usr.open_menus.Add(".close_dialogue")
						if(get_dist(usr,src) < 3)
							usr.talk_to = src
							winshow(usr, "dialogue", 1)

							winset(usr,"dialogue.label_title","text=\"[src.name]\"")
							winset(usr,"dialogue.age_text","text=\"[src.age]\"")
							winset(usr,"dialogue.gender_text","text=\"[src.gender]\"")


							var/icon/I = icon(src.icon,"",EAST,1,0)
							I.Scale(128,128)

							if(src.hair)
								var/icon/E = icon(src.hair.icon,"",EAST,1,0)
								E.Scale(128,128)

								//var/obj/Z = new
								I.Blend(E,ICON_OVERLAY)
							//Z.icon = E

							var/X = fcopy_rsc(I)
							winset(usr,"dialogue.portrait","image=\ref[X]")
				New()
					..()
					src.set_lists()
					sleep(100)
					//src.Android()
					set_stats(33,3333,33,100,33,100,50,50)
					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Human()
					src.name = "Mammoth"
					src.real_name = "Mammoth"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = rand(2,3)*year
					src.energy = 15
					src.energy_max = 15
					src.strength = 3
					src.endurance = 10
					src.force = 1
					src.resistance = 15
					src.offence = 3
					src.defence = 1

					src.text_color_ic = "brown"
					src.race = "Mammoth"
					src.set_icon(src)

					//src.faction = factions[4]
					src.respawnloc = src.loc=locate(src.x,src.y,src.z)
					switch(rand(1,5))
						if(1)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)

							legmeat.loc = src
						if(2)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new/obj/items/consumables/food/raw_legmeat(src)
							var/obj/items/clothing/fur/fr = new /obj/items/clothing/fur(src)
							fr.loc = src
							legmeat.loc = src
						if(3)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							var/obj/items/clothing/fur_skirt/fr = new /obj/items/clothing/fur_skirt(src)
							fr.loc = src
							steak.loc = src
						if(4)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							steak.loc = src
						if(5)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							var/obj/items/clothing/fur/fr = new /obj/items/clothing/fur(src)
							fr.loc = src
							steak.loc = src
							legmeat.loc = src
					var/obj/items/clothing/fur/fr = new
					fr.loc = src
					if(src.shadow) src.shadow.loc = src.loc
					while(src)
						for(var/turf/g in block(locate(1,1,1),locate(500,500,1)))
							spot = g
						if(src.koed == 0 && src.stunned == 0)
							if(!src.target)
								if(get_dist(src,spot) < 40)
									if(src.task == null)
										if(prob(1)) src.task = "wait"
										else if(prob(99)) step_rand(src)
										else src.dir = rand(1,8)
									else if(prob(0.25))
										src.task = null ; src.icon_state = src.state()
								else step_towards(src,spot)
							if(src.target)
								src.try_contact_attack()
								var/dist = bounds_dist(src, src.target)
								if(dist >= 32) step_towards(src,src.target)
								if(dist >= 320 || src.target.koed || src.target.dead) src.target = null
							//else if(prob(0.1)) src.hate_list = list()
						sleep(0.5)
			Mammoth
				icon = 'Mammoth.dmi'
				icon_state = ""
				name = "Mammoth"
				gender = "neuter"
				agressive = 0
				race = "Mammoth"
				fullname = "Mammoth"
				appearance_flags = KEEP_TOGETHER
				respawn_type = /mob/NPC/Animals/Mammoth
				attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
				attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"

				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["right"])
						usr.open_dialogue = 1
						usr.open_menus.Add(".close_dialogue")
						if(get_dist(usr,src) < 3)
							usr.talk_to = src
							winshow(usr, "dialogue", 1)

							winset(usr,"dialogue.label_title","text=\"[src.name]\"")
							winset(usr,"dialogue.age_text","text=\"[src.age]\"")
							winset(usr,"dialogue.gender_text","text=\"[src.gender]\"")


							var/icon/I = icon(src.icon,"",EAST,1,0)
							I.Scale(128,128)

							if(src.hair)
								var/icon/E = icon(src.hair.icon,"",EAST,1,0)
								E.Scale(128,128)

								//var/obj/Z = new
								I.Blend(E,ICON_OVERLAY)
							//Z.icon = E

							var/X = fcopy_rsc(I)
							winset(usr,"dialogue.portrait","image=\ref[X]")
				New()
					..()
					src.set_lists()
					sleep(100)
					//src.Android()
					set_stats(33,3333,33,100,33,100,50,50)
					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Human()
					src.name = "Mammoth"
					src.real_name = "Mammoth"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = rand(1,2)*year
					src.energy = 15
					src.energy_max = 15
					src.strength = 1
					src.endurance = 10
					src.force = 1
					src.resistance = 10
					src.offence = 1
					src.defence = 1

					src.text_color_ic = "brown"
					src.race = "Mammoth"
					src.set_icon(src)

					//src.faction = factions[4]
					src.respawnloc = src.loc=locate(src.x,src.y,src.z)
					switch(rand(1,5))
						if(1)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							var/obj/items/clothing/fur/fr = new /obj/items/clothing/fur(src)
							fr.loc = src
							legmeat.loc = src
						if(2)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new/obj/items/consumables/food/raw_legmeat(src)
							legmeat.loc = src
						if(3)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							var/obj/items/clothing/fur_skirt/fr = new /obj/items/clothing/fur_skirt(src)
							fr.loc = src
							steak.loc = src
						if(4)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							steak.loc = src
						if(5)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							var/obj/items/clothing/fur/fr = new /obj/items/clothing/fur(src)
							fr.loc = src
							steak.loc = src
							legmeat.loc = src
					var/obj/items/clothing/fur/fr = new
					fr.loc = src
					if(src.shadow) src.shadow.loc = src.loc
					while(src)
						for(var/turf/g in block(locate(1,1,1),locate(500,500,1)))
							spot = g
						if(src.koed == 0 && src.stunned == 0)
							if(!src.target)
								if(get_dist(src,spot) < 40)
									if(src.task == null)
										if(prob(1)) src.task = "wait"
										else if(prob(99)) step_rand(src)
										else src.dir = rand(1,8)
									else if(prob(0.25))
										src.task = null ; src.icon_state = src.state()
								else step_towards(src,spot)
							if(src.target)
								src.try_contact_attack()
								var/dist = bounds_dist(src, src.target)
								if(dist >= 32) step_towards(src,src.target)
								if(dist >= 320 || src.target.koed || src.target.dead) src.target = null
							//else if(prob(0.1)) src.hate_list = list()
						sleep(0.5)





			Monkey
				icon = 'Monkey.dmi'
				icon_state = ""
				name = "Monkey"
				gender = "neuter"
				agressive = 1
				race = "Monkey"
				fullname = "Monkey"
				appearance_flags = KEEP_TOGETHER
				respawn_type = /mob/NPC/Animals/Monkey
				attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
				attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"

				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["right"])
						usr.open_dialogue = 1
						usr.open_menus.Add(".close_dialogue")
						if(get_dist(usr,src) < 3)
							usr.talk_to = src
							winshow(usr, "dialogue", 1)

							winset(usr,"dialogue.label_title","text=\"[src.name]\"")
							winset(usr,"dialogue.age_text","text=\"[src.age]\"")
							winset(usr,"dialogue.gender_text","text=\"[src.gender]\"")


							var/icon/I = icon(src.icon,"",EAST,1,0)
							I.Scale(128,128)

							if(src.hair)
								var/icon/E = icon(src.hair.icon,"",EAST,1,0)
								E.Scale(128,128)

								//var/obj/Z = new
								I.Blend(E,ICON_OVERLAY)
							//Z.icon = E

							var/X = fcopy_rsc(I)
							winset(usr,"dialogue.portrait","image=\ref[X]")
				New()
					..()
					src.set_lists()
					sleep(100)
					//src.Android()
					set_stats(33,3333,33,100,33,100,50,50)
					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Human()
					src.name = "Monkey"
					src.real_name = "Monkey"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = 1
					src.energy = 3
					src.energy_max = 3
					src.strength = 1
					src.endurance = 1
					src.force = 1
					src.resistance = 1
					src.offence = 20
					src.defence = 1

					src.text_color_ic = "yellow"
					src.race = "Monkey"
					src.set_icon(src)

					//src.faction = factions[4]
					src.respawnloc = src.loc=locate(src.x,src.y,src.z)

					switch(rand(1,5))
						if(1)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							legmeat.loc = src
						if(2)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new/obj/items/consumables/food/raw_legmeat(src)
							legmeat.loc = src
						if(3)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							var/obj/items/clothing/fur_skirt/fr = new /obj/items/clothing/fur_skirt(src)
							fr.loc = src
							steak.loc = src
						if(4)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							var/obj/items/clothing/fur/fr = new /obj/items/clothing/fur(src)
							fr.loc = src
							steak.loc = src


					if(src.shadow) src.shadow.loc = src.loc
					while(src)
						for(var/turf/g in block(locate(1,1,1),locate(500,500,1)))
							spot = g
						if(src.koed == 0 && src.stunned == 0)
							if(!src.target)
								if(get_dist(src,spot) < 40)
									if(src.task == null)
										if(prob(1)) src.task = "wait"
										else if(prob(99)) step_rand(src)
										else src.dir = rand(1,8)
									else if(prob(0.25))
										src.task = null ; src.icon_state = src.state()
								else step_towards(src,spot)
							if(src.target)
								var/dist = bounds_dist(src, src.target)
								if(dist >= 32) step_towards(src,src.target)
								if(dist >= 320 || src.target.koed) src.target = null
							//else if(prob(0.1)) src.hate_list = list()
						sleep(0.5)
					spawn(500)
						if(src)
							if(src.koed == 0) src.destroy()

			Chicken
				icon = 'Chicken.dmi'
				icon_state = "Chicken"
				name = "Chicken"
				gender = "neuter"
				agressive = 1
				race = "Chicken"
				fullname = "Chicken"
				appearance_flags = KEEP_TOGETHER
				respawn_type = /mob/NPC/Animals/Chicken
				attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
				attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"

				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["right"])
						usr.open_dialogue = 1
						usr.open_menus.Add(".close_dialogue")
						if(get_dist(usr,src) < 3)
							usr.talk_to = src
							winshow(usr, "dialogue", 1)

							winset(usr,"dialogue.label_title","text=\"[src.name]\"")
							winset(usr,"dialogue.age_text","text=\"[src.age]\"")
							winset(usr,"dialogue.gender_text","text=\"[src.gender]\"")


							var/icon/I = icon(src.icon,"",EAST,1,0)
							I.Scale(128,128)

							if(src.hair)
								var/icon/E = icon(src.hair.icon,"",EAST,1,0)
								E.Scale(128,128)

								//var/obj/Z = new
								I.Blend(E,ICON_OVERLAY)
							//Z.icon = E

							var/X = fcopy_rsc(I)
							winset(usr,"dialogue.portrait","image=\ref[X]")
				New()
					..()
					src.set_lists()
					sleep(100)
					//src.Android()
					set_stats(33,3333,33,100,33,100,50,50)
					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Human()
					src.name = "Chicken"
					src.real_name = "Chicken"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = 1
					src.energy = 3
					src.energy_max = 3
					src.strength = 1
					src.endurance = 1
					src.force = 1
					src.resistance = 1
					src.offence = 20
					src.defence = 1

					src.text_color_ic = "yellow"
					src.race = "Chicken"
					src.set_icon(src)

					//src.faction = factions[4]
					src.respawnloc = src.loc=locate(src.x,src.y,src.z)

					switch(rand(1,5))
						if(1)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							legmeat.loc = src
						if(2)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new/obj/items/consumables/food/raw_legmeat(src)
							legmeat.loc = src
						if(3)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							steak.loc = src
						if(4)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							steak.loc = src
						if(5)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							steak.loc = src
							legmeat.loc = src

					if(src.shadow) src.shadow.loc = src.loc
					while(src)
						for(var/turf/g in block(locate(1,1,1),locate(500,500,1)))
							spot = g
						if(src.koed == 0 && src.stunned == 0)
							if(!src.target)
								if(get_dist(src,spot) < 40)
									if(src.task == null)
										if(prob(1)) src.task = "wait"
										else if(prob(99)) step_rand(src)
										else src.dir = rand(1,8)
									else if(prob(0.25))
										src.task = null ; src.icon_state = src.state()
								else step_towards(src,spot)
							if(src.target)
								var/dist = bounds_dist(src, src.target)
								if(dist >= 32) step_towards(src,src.target)
								if(dist >= 320 || src.target.koed) src.target = null
							//else if(prob(0.1)) src.hate_list = list()
						sleep(0.5)
					spawn(500)
						if(src)
							if(src.koed == 0) src.destroy()


			Pig
				icon = 'Pig.dmi'
				name = "Pig"
				gender = "neuter"
				agressive = 1
				race = "Pig"
				fullname = "Pig"
				appearance_flags = KEEP_TOGETHER
				respawn_type = /mob/NPC/Animals/Pig
				attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
				attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"

				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["right"])
						usr.open_dialogue = 1
						usr.open_menus.Add(".close_dialogue")
						if(get_dist(usr,src) < 3)
							usr.talk_to = src
							winshow(usr, "dialogue", 1)

							winset(usr,"dialogue.label_title","text=\"[src.name]\"")
							winset(usr,"dialogue.age_text","text=\"[src.age]\"")
							winset(usr,"dialogue.gender_text","text=\"[src.gender]\"")


							var/icon/I = icon(src.icon,"",EAST,1,0)
							I.Scale(128,128)

							if(src.hair)
								var/icon/E = icon(src.hair.icon,"",EAST,1,0)
								E.Scale(128,128)

								//var/obj/Z = new
								I.Blend(E,ICON_OVERLAY)
							//Z.icon = E

							var/X = fcopy_rsc(I)
							winset(usr,"dialogue.portrait","image=\ref[X]")
				New()
					..()
					src.set_lists()
					sleep(100)
					//src.Android()
					set_stats(33,3333,33,100,33,100,50,50)

					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Human()
					src.name = "Pig"
					src.real_name = "Pig"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = 1
					src.energy = 10
					src.energy_max = 10
					src.strength = 3
					src.endurance = 2
					src.force = 1
					src.resistance = 2
					src.offence = 5
					src.defence = 1

					src.text_color_ic = "pink"
					src.race = "Pig"
					src.set_icon(src)

					//src.faction = factions[4]
					src.respawnloc = src.loc=locate(src.x,src.y,src.z)
					switch(rand(1,5))
						if(1)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							legmeat.loc = src
						if(2)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new/obj/items/consumables/food/raw_legmeat(src)
							legmeat.loc = src
						if(3)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							steak.loc = src
						if(4)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							steak.loc = src
						if(5)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							steak.loc = src
							legmeat.loc = src

					if(src.shadow) src.shadow.loc = src.loc
					while(src)
						for(var/turf/g in block(locate(1,1,1),locate(500,500,1)))
							spot = g
						if(src.koed == 0 && src.stunned == 0)
							if(!src.target)
								if(get_dist(src,spot) < 40)
									if(src.task == null)
										if(prob(1)) src.task = "wait"
										else if(prob(99)) step_rand(src)
										else src.dir = rand(1,8)
									else if(prob(0.25))
										src.task = null ; src.icon_state = src.state()
								else step_towards(src,spot)
							if(src.target)
								var/dist = bounds_dist(src, src.target)
								if(dist >= 32) step_towards(src,src.target)
								if(dist >= 320 || src.target.koed) src.target = null
							//else if(prob(0.1)) src.hate_list = list()
						sleep(0.5)

			Sheep
				icon = 'sheep.dmi'
				name = "Sheep"
				gender = "neuter"
				agressive = 1
				race = "Sheep"
				fullname = "Sheep"
				appearance_flags = KEEP_TOGETHER
				respawn_type = /mob/NPC/Animals/Sheep
				attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
				attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"

				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["right"])
						usr.open_dialogue = 1
						usr.open_menus.Add(".close_dialogue")
						if(get_dist(usr,src) < 3)
							usr.talk_to = src
							winshow(usr, "dialogue", 1)

							winset(usr,"dialogue.label_title","text=\"[src.name]\"")
							winset(usr,"dialogue.age_text","text=\"[src.age]\"")
							winset(usr,"dialogue.gender_text","text=\"[src.gender]\"")


							var/icon/I = icon(src.icon,"",EAST,1,0)
							I.Scale(128,128)

							if(src.hair)
								var/icon/E = icon(src.hair.icon,"",EAST,1,0)
								E.Scale(128,128)

								//var/obj/Z = new
								I.Blend(E,ICON_OVERLAY)
							//Z.icon = E

							var/X = fcopy_rsc(I)
							winset(usr,"dialogue.portrait","image=\ref[X]")
				New()
					..()
					src.set_lists()
					sleep(100)
					//src.Android()
					set_stats(33,3333,33,100,33,100,50,50)

					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Human()
					src.name = "Sheep"
					src.real_name = "Sheep"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = 2
					src.energy = 10
					src.energy_max = 10
					src.strength = 1
					src.endurance = 5
					src.force = 1
					src.resistance = 5
					src.offence = 1
					src.defence = 1

					src.text_color_ic = "grey"
					src.race = "Sheep"
					src.set_icon(src)
				//	src.faction = factions[4]
					src.respawnloc = src.loc=locate(src.x,src.y,src.z)
					switch(rand(1,5))
						if(1)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							legmeat.loc = src
						if(2)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new/obj/items/consumables/food/raw_legmeat(src)
							legmeat.loc = src
						if(3)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							steak.loc = src
						if(4)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							steak.loc = src
						if(5)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							steak.loc = src
							legmeat.loc = src
					var/obj/items/wool/wl = new
					wl.loc = src
					if(src.shadow) src.shadow.loc = src.loc
					while(src)
						for(var/turf/g in block(locate(1,1,1),locate(500,500,1)))
							spot = g
						if(src.koed == 0 && src.stunned == 0)
							if(!src.target)
								if(get_dist(src,spot) < 40)
									if(src.task == null)
										if(prob(1)) src.task = "wait"
										else if(prob(99)) step_rand(src)
										else src.dir = rand(1,8)
									else if(prob(0.25))
										src.task = null ; src.icon_state = src.state()
								else step_towards(src,spot)
							if(src.target)
								var/dist = bounds_dist(src, src.target)
								if(dist >= 32) step_towards(src,src.target)
								if(dist >= 320 || src.target.koed) src.target = null
							//else if(prob(0.1)) src.hate_list = list()
						sleep(0.5)
					spawn(500)
						if(src)
							if(src.koed == 0) src.destroy()
			Cow
				icon = 'Cow.dmi'
				name = "Cow"
				gender = "neuter"
				agressive = 1
				race = "Cow"
				fullname = "Cow"
				appearance_flags = KEEP_TOGETHER
				respawn_type = /mob/NPC/Animals/Cow
				attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
				attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"

				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["right"])
						usr.open_dialogue = 1
						usr.open_menus.Add(".close_dialogue")
						if(get_dist(usr,src) < 3)
							usr.talk_to = src
							winshow(usr, "dialogue", 1)

							winset(usr,"dialogue.label_title","text=\"[src.name]\"")
							winset(usr,"dialogue.age_text","text=\"[src.age]\"")
							winset(usr,"dialogue.gender_text","text=\"[src.gender]\"")


							var/icon/I = icon(src.icon,"",EAST,1,0)
							I.Scale(128,128)

							if(src.hair)
								var/icon/E = icon(src.hair.icon,"",EAST,1,0)
								E.Scale(128,128)

								//var/obj/Z = new
								I.Blend(E,ICON_OVERLAY)
							//Z.icon = E

							var/X = fcopy_rsc(I)
							winset(usr,"dialogue.portrait","image=\ref[X]")
				New()
					..()
					src.set_lists()
					sleep(100)
					//src.Android()
					set_stats(33,3333,33,100,33,100,50,50)

					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Human()
					src.name = "Cow"
					src.real_name = "Cow"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = 2
					src.energy = 10
					src.energy_max = 10
					src.strength = 2
					src.endurance = 5
					src.force = 1
					src.resistance = 5
					src.offence = 3
					src.defence = 1

					src.text_color_ic = "grey"
					src.race = "Cow"
					src.set_icon(src)
				//	src.faction = factions[4]
					src.respawnloc = src.loc=locate(src.x,src.y,src.z)
					switch(rand(1,5))
						if(1)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							legmeat.loc = src
						if(2)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new/obj/items/consumables/food/raw_legmeat(src)
							legmeat.loc = src
						if(3)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							steak.loc = src
						if(4)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							steak.loc = src
						if(5)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							steak.loc = src
							legmeat.loc = src
					var/obj/items/consumables/milk/wl = new
					wl.loc = src
					if(src.shadow) src.shadow.loc = src.loc
					while(src)
						for(var/turf/g in block(locate(1,1,1),locate(500,500,1)))
							spot = g
						if(src.koed == 0 && src.stunned == 0)
							if(!src.target)
								if(get_dist(src,spot) < 40)
									if(src.task == null)
										if(prob(1)) src.task = "wait"
										else if(prob(99)) step_rand(src)
										else src.dir = rand(1,8)
									else if(prob(0.25))
										src.task = null ; src.icon_state = src.state()
								else step_towards(src,spot)
							if(src.target)
								var/dist = bounds_dist(src, src.target)
								if(dist >= 32) step_towards(src,src.target)
								if(dist >= 320 || src.target.koed) src.target = null
							//else if(prob(0.1)) src.hate_list = list()
						sleep(0.5)
					spawn(500)
						if(src)
							if(src.koed == 0) src.destroy()

			Bat
				icon = 'sheep.dmi'
				name = "Bat"
				gender = "neuter"
				agressive = 1
				race = "Bat"
				bolted = 0
				fullname = "Bat"
				appearance_flags = KEEP_TOGETHER
				respawn_type = /mob/NPC/Animals/Bat
				attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
				attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"

				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["right"])
						usr.open_dialogue = 1
						usr.open_menus.Add(".close_dialogue")
						if(get_dist(usr,src) < 3)
							usr.talk_to = src
							winshow(usr, "dialogue", 1)

							winset(usr,"dialogue.label_title","text=\"[src.name]\"")
							winset(usr,"dialogue.age_text","text=\"[src.age]\"")
							winset(usr,"dialogue.gender_text","text=\"[src.gender]\"")


							var/icon/I = icon(src.icon,"",EAST,1,0)
							I.Scale(128,128)

							if(src.hair)
								var/icon/E = icon(src.hair.icon,"",EAST,1,0)
								E.Scale(128,128)

								//var/obj/Z = new
								I.Blend(E,ICON_OVERLAY)
							//Z.icon = E

							var/X = fcopy_rsc(I)
							winset(usr,"dialogue.portrait","image=\ref[X]")
				New()
					..()
					src.set_lists()
					sleep(100)
					//src.Android()
					set_stats(33,3333,33,100,33,100,50,50)


					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Human()
					src.name = "Bat"
					src.real_name = "Bat"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = 1
					src.energy = 10
					src.energy_max = 10
					src.strength = 1
					src.endurance = 2
					src.force = 1
					src.resistance = 2
					src.offence = 1
					src.defence = 1

					src.text_color_ic = "grey"
					src.race = "Bat"
					src.set_icon(src)
					//src.faction = factions[4]
					src.respawnloc = src.loc=locate(src.x,src.y,src.z)
					if(src.shadow) src.shadow.loc = src.loc
					switch(rand(1,5))
						if(1)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							legmeat.loc = src
						if(2)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new/obj/items/consumables/food/raw_legmeat(src)
							legmeat.loc = src
						if(3)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							steak.loc = src
						if(4)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							steak.loc = src
						if(5)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(src)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(src)
							steak.loc = src
							legmeat.loc = src
					while(src)
						for(var/turf/g in block(locate(1,1,1),locate(500,500,1)))
							spot = g
						if(src.koed == 0 && src.stunned == 0)
							if(!src.target)
								if(get_dist(src,spot) < 40)
									if(src.task == null)
										if(prob(1)) src.task = "wait"
										else if(prob(99)) step_rand(src)
										else src.dir = rand(1,8)
									else if(prob(0.25))
										src.task = null ; src.icon_state = src.state()
								else step_towards(src,spot)
							if(src.target)
								var/dist = bounds_dist(src, src.target)
								if(dist >= 32) step_towards(src,src.target)
								if(dist >= 320 || src.target.koed) src.target = null
							//else if(prob(0.1)) src.hate_list = list()
						sleep(0.5)
					spawn(500)
						if(src)
							if(src.koed == 0) src.destroy()



		Robots
			Android
				icon = 'android.dmi'
				name = "{NPC} Android"
				gender = "neuter"
				agressive = 1
				race = "Android"
				appearance_flags = KEEP_TOGETHER

				attacked_text = "-.. . ..-. . -. -.-. .     .- .-.. --. --- .-. .. - .... -- ...         .- -.-. - .. ...- .- - . -.. �-�-�-"
				attack_text = ".--. .-. . .--. .- .-. .     - ---     -... .     .--. .-. --- -.-. . ... ... . -..     .- -. -..     .--. ..- .-. --. . -.. �-�-�-"
				Click(location,control,params)
					..()
					params = params2list(params)
					if(params["right"])
						usr.open_dialogue = 1
						usr.open_menus.Add(".close_dialogue")
						if(get_dist(usr,src) < 3)
							usr.talk_to = src
							winshow(usr, "dialogue", 1)

							winset(usr,"dialogue.label_title","text=\"[src.name]\"")
							winset(usr,"dialogue.age_text","text=\"[src.age]\"")
							winset(usr,"dialogue.gender_text","text=\"[src.gender]\"")


							var/icon/I = icon(src.icon,"",EAST,1,0)
							I.Scale(128,128)

							if(src.hair)
								var/icon/E = icon(src.hair.icon,"",EAST,1,0)
								E.Scale(128,128)

								//var/obj/Z = new
								I.Blend(E,ICON_OVERLAY)
							//Z.icon = E

							var/X = fcopy_rsc(I)
							winset(usr,"dialogue.portrait","image=\ref[X]")
				New()
					..()
					src.set_lists()
					sleep(100)
					//src.Android()
					set_stats(33,3333,33,100,33,100,50,50)
					src.name_txt()

					src.faction = factions[4]

					if(src.shadow) src.shadow.loc = src.loc
					while(src)
						if(src.koed == 0 && src.stunned == 0)
							if(src.village) if(!src.target)
								if(get_dist(src,src.village) < 40)
									if(src.task == null)
										if(prob(1)) src.task = "wait"
										else if(prob(99)) step_rand(src)
										else src.dir = rand(1,8)
									else if(prob(0.25))
										src.task = null ; src.icon_state = src.state()
								else step_towards(src,src.village)
							if(src.target)
								var/dist = bounds_dist(src, src.target)
								if(dist >= 32) step_towards(src,src.target)
								if(dist >= 320 || src.target.koed) src.target = null
							//else if(prob(0.1)) src.hate_list = list()
						sleep(0.5)
		Bosses
			Elder_One
				//Ancient being, like a C'tan shard or Chutchulu creature
				icon = 'Human_Base_Male.dmi'
				agressive = 1
				bolted = 0
				name = "{NPC} Elder One"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				New()
					..()
					src.set_lists()
					sleep(100)
					src.start_loc = src.loc
					//src.Demon()
					src.name_txt()

					src.energy = 1000
					src.energy_max = 1000
					src.strength = 1
					src.endurance = 1
					src.force = 1
					src.resistance = 1
					src.offence = 1
					src.defence = 1

					var/obj/skills/Zanzoken/s = new
					s.loc = src
					src.skill_super_speed = s
					s.active = 1

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					var/obj/skills/Charge/c = new
					src.skill_charge = c
					c.skill_lvl = 25
					c.loc = src
			Celestial_Bull
				//Gives you the Heart of the Bull (Fire/Ice resistance)
				icon = 'imp_brown_ears_curled.dmi'
				agressive = 1
				bolted = 0
				name = "{NPC} Celestial Dragon"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				New()
					..()
					src.set_lists()
					sleep(100)
					src.start_loc = src.loc
					//src.Demon()
					src.name_txt()

					src.energy = 1000
					src.energy_max = 1000
					src.strength = 1
					src.endurance = 1
					src.force = 1
					src.resistance = 1
					src.offence = 1
					src.defence = 1

					var/obj/skills/Zanzoken/s = new
					s.loc = src
					src.skill_super_speed = s
					s.active = 1

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					var/obj/skills/Charge/c = new
					src.skill_charge = c
					c.skill_lvl = 25
					c.loc = src
			Celestial_Dragon
				//Great, giant mythical chinese dragon that flies around the psionic realms
				icon = 'imp_brown_ears_curled.dmi'
				agressive = 1
				bolted = 0
				name = "{NPC} Celestial Dragon"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				New()
					..()
					src.set_lists()
					sleep(100)
					src.start_loc = src.loc
					//src.Demon()
					src.name_txt()

					src.energy = 1000
					src.energy_max = 1000
					src.strength = 1
					src.endurance = 1
					src.force = 1
					src.resistance = 1
					src.offence = 1
					src.defence = 1

					var/obj/skills/Zanzoken/s = new
					s.loc = src
					src.skill_super_speed = s
					s.active = 1

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					var/obj/skills/Charge/c = new
					src.skill_charge = c
					c.skill_lvl = 25
					c.loc = src
			The_Spinx
				//Desert boss idea. Ancient monk who is dead and mumified. Uses his powers to influence and attack others. Worshipped as a living god long ago. Like a Pharoah.
				/*
				Bloated not by simple-satisfied excess, but temporal chronicle obbession also.
				Multitudinous the times self-denied ascension, contently lavished of the material.
				Lore master and watcher, keeper of the balance, paragon of opulence; the rotund one.
				The always coveted, even-handed judge with patience unto heat-death eternal.
				*/
				icon = 'imp_brown_ears_curled.dmi'
				agressive = 1
				bolted = 0
				name = "{NPC} The Chronicler"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				//poooooooooopyhonk
				New()
					..()
					src.set_lists()
					sleep(100)
					src.start_loc = src.loc
					//src.Demon()
					src.name_txt()

					src.energy = 1000
					src.energy_max = 1000
					src.strength = 1
					src.endurance = 1
					src.force = 1
					src.resistance = 1
					src.offence = 1
					src.defence = 1

					var/obj/skills/Zanzoken/s = new
					s.loc = src
					src.skill_super_speed = s
					s.active = 1

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					var/obj/skills/Charge/c = new
					src.skill_charge = c
					c.skill_lvl = 25
					c.loc = src
			Chronicler
				//Giant Imp, hordes, collects and catalogues things.
				//Judge of the psi realms, bigly, and sarcastic.
				/*
				Bloated not by simple-satisfied excess, but temporal chronicle obbession also.
				Multitudinous the times self-denied ascension, contently lavished of the material.
				Lore master and watcher, keeper of the balance, paragon of opulence; the rotund one.
				The always coveted, even-handed judge with patience unto heat-death eternal.
				*/
				icon = 'imp_brown_ears_curled.dmi'
				agressive = 1
				bolted = 0
				name = "{NPC} The Chronicler"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				//poooooooooopyhonk
				New()
					..()
					src.set_lists()
					sleep(100)
					src.start_loc = src.loc
					//src.Demon()
					src.name_txt()

					src.energy = 1000
					src.energy_max = 1000
					src.strength = 1
					src.endurance = 1
					src.force = 1
					src.resistance = 1
					src.offence = 1
					src.defence = 1

					var/obj/skills/Zanzoken/s = new
					s.loc = src
					src.skill_super_speed = s
					s.active = 1

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					var/obj/skills/Charge/c = new
					src.skill_charge = c
					c.skill_lvl = 25
					c.loc = src
			Djinn
				//Psionic being, like majin buu.
				/*
				Numberless in age, fantastical cosmic apparition, force of nature unfettered given form.
				Reality wails asunder, god-shard incarnate, with power to unmake the world.
				Impervious, unwithering to the ruin of all. Neither tempestuous star-heat or star-death can undo its fatecast design.
				Physically resilient unto inconsequential, practically undefeatable, sempiternal, par fragility of the preternatural.
				Horror made manifest, older than old, defined in its insatiable hunger and unquenchable malice.
				*/
				icon = 'Human_Base_Male.dmi'
				agressive = 1
				bolted = 0
				name = "{NPC} Djinn"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				New()
					..()
					src.set_lists()
					sleep(100)
					src.start_loc = src.loc
					//src.Demon()
					src.name_txt()

					src.energy = 1000
					src.energy_max = 1000
					src.strength = 1
					src.endurance = 1
					src.force = 1
					src.resistance = 1
					src.offence = 1
					src.defence = 1

					var/obj/skills/Zanzoken/s = new
					s.loc = src
					src.skill_super_speed = s
					s.active = 1

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					var/obj/skills/Charge/c = new
					src.skill_charge = c
					c.skill_lvl = 25
					c.loc = src
			Tyuran_Titan_Tyrant
				//Like Thanos and Freiza
				icon = 'Human_Base_Male.dmi'
				agressive = 1
				bolted = 0
				name = "{NPC} Tyuran Titan Tyrant"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				New()
					..()
					src.set_lists()
					sleep(100)
					src.start_loc = src.loc
					//src.Demon()
					src.name_txt()

					src.energy = 1000
					src.energy_max = 1000
					src.strength = 1
					src.endurance = 1
					src.force = 1
					src.resistance = 1
					src.offence = 1
					src.defence = 1

					var/obj/skills/Zanzoken/s = new
					s.loc = src
					src.skill_super_speed = s
					s.active = 1

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					var/obj/skills/Charge/c = new
					src.skill_charge = c
					c.skill_lvl = 25
					c.loc = src
			The_Monk
				icon = 'Human_Base_Male.dmi'
				agressive = 1
				bolted = 0
				name = "{NPC} The Monk"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				New()
					..()
					src.set_lists()
					sleep(100)
					src.start_loc = src.loc
					//src.Demon()
					src.name_txt()

					src.energy = 1000
					src.energy_max = 1000
					src.strength = 1
					src.endurance = 1
					src.force = 1
					src.resistance = 1
					src.offence = 1
					src.defence = 1

					var/obj/skills/Zanzoken/s = new
					s.loc = src
					src.skill_super_speed = s
					s.active = 1

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					var/obj/skills/Charge/c = new
					src.skill_charge = c
					c.skill_lvl = 25
					c.loc = src
			Legion
				//Android rogue A.I
				icon = 'android_metal.dmi'
				agressive = 1
				bolted = 0
				name = "{NPC} Legion"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				New()
					..()
					src.set_lists()
					sleep(100)
					src.start_loc = src.loc
					//src.Demon()
					src.name_txt()

					src.energy = 1000
					src.energy_max = 1000
					src.strength = 1
					src.endurance = 1
					src.force = 1
					src.resistance = 1
					src.offence = 1
					src.defence = 1

					var/obj/skills/Zanzoken/s = new
					s.loc = src
					src.skill_super_speed = s
					s.active = 1

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					var/obj/skills/Charge/c = new
					src.skill_charge = c
					c.skill_lvl = 25
					c.loc = src
			The_Last_Cerebroid
				/*
				Doom-laden hubris humbled like the death-wail destruction wrought by a dying star.
				Decadence-saturated complacency perpetuated in hedonism.
				Deafening was the silent thrum of their obliteration, only genecraft their salvation.
				Those few who remained, fused-forged into singular form.
				*/
				//icon = 'goog.dmi'
				agressive = 1
				bolted = 0
				name = "{NPC} The Last Cerebroid"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				New()
					..()
					src.set_lists()
					src.id = global_id;
					global_id += 1;
					sleep(100)
					src.start_loc = src.loc
					//src.Demon()
					//src.icon = 'goog.dmi'
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = 1
					src.energy = 10000
					src.energy_max = 10000
					src.strength = 1
					src.endurance = 1
					src.force = 10
					src.resistance = 1
					src.offence = 1
					src.defence = 1

					src.prob_ki_atk = 50
					src.prob_stop_charge = 4
					src.prob_stop_atk = 4

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					var/obj/skills/Charge/c = new
					src.skill_charge = c
					c.skill_lvl = 25
					c.loc = src

					var/obj/skills/Blast/blt = new
					src.skill_blast = blt
					blt.skill_lvl = 33
					blt.loc = src

					var/obj/skills/Beam/b = new
					src.skill_beam = b
					b.skill_lvl = 25
					b.loc = src
			The_Hermit
				icon = 'Human_Base_Male.dmi'
				agressive = 1
				bolted = 0
				name = "{NPC} The Hermit"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				New()
					..()
					src.set_lists()
					sleep(100)
					src.start_loc = src.loc
					//src.Demon()
					src.name_txt()

					src.energy = 1000
					src.energy_max = 1000
					src.strength = 1
					src.endurance = 1
					src.force = 1
					src.resistance = 1
					src.offence = 1
					src.defence = 1

					var/obj/skills/Zanzoken/s = new
					s.loc = src
					src.skill_super_speed = s
					s.active = 1

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					var/obj/skills/Charge/c = new
					src.skill_charge = c
					c.skill_lvl = 25
					c.loc = src
			The_Celestial_Ascendant
				/*
				*Rumour*
				Rumour has it...Through a feeling that transcends time, space and all reasoning, you feel a serene influence playing about your senses.
				Concentrating on this disturbance brings your attention to a vast, realm spanning sea of energy only visible barely within your mindseye; and only because of your psionic skill.
				It is a pure energy, like that of a radiant star, bathed in brilliance and cascading with great chromatic beams of light.
				Perhaps there is a way you know to find this being, within a realm of pure psionic power...

				*Goals*
				- Find the realm of pure psionic energy
				- Search for the origins of this greater good
				- Defeat the Celestial Ascendant or join her

				*Lore desc*
				Whitehot flame, radiant light, burning passion wrought through might.
				Purest one, soul-drench-bathed in blinding brilliance, antithesis and anathema to six times six times six.
				Zealous, uncompromising spirit, tempered in time and quenched through ceaseless crusade.
				Star-like light cascading in perpetuality, washing over all unto ashen remnant.

				*/
				icon = 'Celestial_Base_Female2.dmi'
				agressive = 1
				bolted = 0
				name = "{NPC} The Celestial Ascendant"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				New()
					..()
					src.set_lists()
					sleep(100)
					src.start_loc = src.loc
					//src.Demon()
					src.name_txt()

					src.energy = 1000
					src.energy_max = 1000
					src.strength = 1
					src.endurance = 1
					src.force = 1
					src.resistance = 1
					src.offence = 1
					src.defence = 1

					var/obj/skills/Zanzoken/s = new
					s.loc = src
					src.skill_super_speed = s
					s.active = 1

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					var/obj/skills/Charge/c = new
					src.skill_charge = c
					c.skill_lvl = 25
					c.loc = src
			Demon_Lord
				/*
				*Rumour*
				Rumour has it...Through a feeling that transcends time, space and all reasoning, you feel in your very bones a terrible evil festering in some far off place or realm.
				Like a baleful beacon that beckons as a challenge to all the universe, it thums with psionic power the likes you have never sensed.
				Purest malice and negative energy, emotion ingited into a furious and condensed form. Whatever it is, it is old and it is powerful.
				Perhaps there is a way you know to find this being, within a realm of pure psionic power...

				*Goals*
				- Find the realm of pure psionic energy
				- Search for the origins of this great evil
				- Defeat the Demon Lord or join him

				* Demon Lord lore desc*
				Doom come calling, tempered in fires of rage, quenched in shadow-black emotion.
				Mark of the beast, entwined within psiforged-flesh, coiling tendril that strangles the soul.
				Master of the dammed, puppeteer string-manipulator of the strands of fate.
				Quicksilver swirl of sudden death within the thrice-cursed storm of creation unending.
				*/
				icon = 'Demon_Base_Male.dmi'
				agressive = 1
				bolted = 0
				name = "{NPC} Zarthorlaraus"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				New()
					..()
					src.set_lists()
					sleep(100)
					src.start_loc = src.loc
					//src.Demon()
					src.name_txt()

					src.energy = 1000
					src.energy_max = 1000
					src.strength = 1
					src.endurance = 1
					src.force = 1
					src.resistance = 1
					src.offence = 1
					src.defence = 1

					var/obj/skills/Zanzoken/s = new
					s.loc = src
					src.skill_super_speed = s
					s.active = 1

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					var/obj/skills/Charge/c = new
					src.skill_charge = c
					c.skill_lvl = 25
					c.loc = src
			Lich
				/*
				Ancient Lich sleeping in a tomb up North, in a region of ever-winter where you need good endurance/weather to travel.
				Gives an item that lets you travel between psi realms and mortal realms.
				Lich might decide to stop the fight half-way through and tell player to come back as part of a bargain where he teaches you to transverse realms?

				*Rumour*
				Rumour has it...That a cold and most unatural wind blows in the North, perpetuated by some, as of yet, unforseen hand.
				Tales speak of an ancient temple, perhaps a tomb, half-buried in the snow.
				None can easily survive long in this dreaded land, an everwinter hellscape protected by razor-wind storms of a omnious nature.

				*Goals*
				- Find a way to survive the frozen wastes
				- Search the frozen wastes for the ancient tomb
				- Explore the ancient tomb
				- Defeat the Lich

				*Lich lore desc*
				A cold wind on Earth flows like frostborne death incarnate, permafrost made manifest unto unlife upon the foundations of that lightless tomb.
				Psionic razor-wind flows, flecks like blades, giving way to an ethereal coalescing of a spirit most unfathomable.
				Bathed in time immemorial, the ancient one slumbers, skeletal-horror of ages; incarnation of entropy-defiant.
				*/
				//icon = 'lich.dmi'
				agressive = 0
				name = "{NPC} Mortis-Marrow the Morbid"
				bolted = 2
				can_harm = 0
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				proc
					reset_convo(var/mob/m)
						if(!m.topics_done.Find("lich intro"))
							m << output("<font color = #15BB36>*Before you stands what can only be described as Death itself. The beings skin is flaking from its bones, flesh sloughing off a decrepit frame and the putrid stench of decay hangs heavy about its aura. Pitch black darkness fills that which were once eyes, staring forth from empty sockets with but the merest flicker of psionic energy swirling within.*<p>","dialogue.dialogue")
							m << output("<font color = #15BB36>*He gives you a massive grin as you approach.*<p>","dialogue.dialogue")
							m << output("Birger:<font color = #1ADBDE> Why hello! Oh I do like visitors! You have come for a reason, no?<p>","dialogue.dialogue")
							m.topics_done += "birger intro"
						else
							if(m.topic == null) m << output("Birger:<font color = #1ADBDE> Welcome back friend! Please, come sit with me and talk, yes?<p>","dialogue.dialogue")
							if(m.topic == "birger who are you") m << output("Birger:<font color = #1ADBDE> Sure thing friend. What else would you like to talk about?<p>","dialogue.dialogue")
						if(!m.topics_done.Find("lich name"))
							winset(m,"dialogue.option1","text=\"Who are you?\"")
						else
							winset(m,"dialogue.option1","text=\"Who are you again?\"")
							winset(m,"dialogue.option6","text=\"Can you make anything for me?\"")
							src.buttons(m,list("option6"),"true")
						winset(m,"dialogue.option2","text=\"You seem rather jolly.\"")
						winset(m,"dialogue.option3","text=\"Why are you just sitting in the cold snow like that?\"")
						winset(m,"dialogue.option4","text=\"What's with that rune on your armour?\"")
						winset(m,"dialogue.option5","text=\"Goodbye.\"")
						src.buttons(m,list("option1","option2","option3","option4","option5"),"true")
						winset(m,"dialogue.name","text=\"[src.name]\"")
						m.topic = null
						m.talk_to = src
					buttons(var/mob/m,var/list/buttons,var/show = "false")
						for(var/b in buttons)
							winset(m,"dialogue.[b]","is-visible=[show]")
				New()
					..()
					src.set_lists()
					sleep(100)
					src.name_txt()
				Click()
					return
					..()
					if(src in range(5,usr))
						var/icon/I = icon(src.icon,"",EAST,1,0)
						I.Scale(128,128)

						var/X = fcopy_rsc(I)
						winset(usr,"dialogue.portrait","image=\ref[X]")
						winshow(usr, "dialogue", 1)
						usr.reset_dialogue(src)

						src.reset_convo(usr)
		Psionics
		Undead
			Lich
				icon = 'Lich_Base.dmi'
				agressive = 1
				bolted = 0
				name = "{NPC} Lich"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				New()
					..()
					src.set_lists()
					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Human()
					src.name = "Zarthorlaraus"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = 10
					src.energy = 1000
					src.energy_max = 1000
					src.strength = 10
					src.endurance = 10
					src.force = 10
					src.resistance = 10
					src.offence = 10
					src.defence = 10

					src.text_color_ic = "grey"
					src.icon = 'Lich_Base.dmi'
					src.gender = "male"

					src.icon_state = "meditate"

					var/obj/skills/Zanzoken/s = new
					s.loc = src
					src.skill_super_speed = s
					s.active = 1

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					var/obj/skills/Charge/c = new
					src.skill_charge = c
					c.skill_lvl = 25
					c.loc = src

					var/obj/skills/Blast/blt = new
					src.skill_blast = blt
					blt.skill_lvl = 33
					blt.loc = src

					var/obj/skills/Beam/b = new
					src.skill_beam = b
					b.skill_lvl = 25
					b.loc = src
		Humans
			Human
				icon = 'Human_Base_Female.dmi'
				agressive = 1
				bolted = 0
				name = "{NPC} Human"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				New()
					..()
					src.set_lists()
					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Human()
					src.name = "Yellow"
					src.real_name = "Yellow"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = 10
					src.energy = 1000
					src.energy_max = 1000
					src.strength = 10
					src.endurance = 10
					src.force = 10
					src.resistance = 10
					src.offence = 10
					src.defence = 10

					src.text_color_ic = "yellow"
					src.icon = 'Human_Base_Female.dmi'
					src.gender = "female"
					src.gen = "Female"
					src.race = "Human"
					src.set_icon(src)

					src.icon_state = "meditate"

					var/obj/skills/Zanzoken/s = new
					s.loc = src
					src.skill_super_speed = s
					s.active = 1

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					var/obj/skills/Charge/c = new
					src.skill_charge = c
					c.skill_lvl = 25
					c.loc = src

					var/obj/skills/Blast/blt = new
					src.skill_blast = blt
					blt.skill_lvl = 33
					blt.loc = src

					var/obj/skills/Beam/b = new
					src.skill_beam = b
					b.skill_lvl = 25
					b.loc = src
		Celestials
			Psionic_Celestial_Lesser
				icon = 'humanoid_no_colour2.dmi'
				agressive = 1
				bolted = 0
				name = "{NPC} Lesser Psionic Celestial"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				New()
					..()
					src.set_lists()
					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Celestial()
					src.name = "Blue"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = 10
					src.energy = 1000
					src.energy_max = 1000
					src.strength = 10
					src.endurance = 10
					src.force = 10
					src.resistance = 10
					src.offence = 10
					src.defence = 10

					src.text_color_ic = "cyan"
					src.gender = "male"
					src.gen = "Male"
					src.race = "Kai"
					src.set_icon(src)

					src.icon_state = "meditate"

					src.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(102,204,255))
					//spawn(20)
					//	if(src) src.Celestial_Wings()

					var/obj/skills/Zanzoken/s = new
					s.loc = src
					src.skill_super_speed = s
					s.active = 1

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					var/obj/skills/Charge/c = new
					src.skill_charge = c
					c.skill_lvl = 25
					c.loc = src

					var/obj/skills/Blast/blt = new
					src.skill_blast = blt
					blt.skill_lvl = 33
					blt.loc = src

					var/obj/skills/Beam/b = new
					src.skill_beam = b
					b.skill_lvl = 25
					b.loc = src
		Imps
			Imp
				icon = 'imp_grey_ears_down.dmi'
				agressive = 1
				bolted = 0
				name = "{NPC} Imp"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				New()
					..()
					src.set_lists()
					src.id = global_id;
					global_id += 1;
					sleep(60)
					src.start_loc = src.loc
					//src.Imp()
					src.name = "Green"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = 10
					src.energy = 1000
					src.energy_max = 1000
					src.strength = 10
					src.endurance = 10
					src.force = 10
					src.resistance = 10
					src.offence = 10
					src.defence = 10
					src.text_color_ic = "green"

					src.icon_state = "meditate"
					src.gender = "male"
					src.gen = "Male"
					src.race = "Oni"
					src.set_icon(src)

					var/obj/skills/Zanzoken/s = new
					s.loc = src
					src.skill_super_speed = s
					s.active = 1

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					var/obj/skills/Charge/c = new
					src.skill_charge = c
					c.skill_lvl = 25
					c.loc = src

					var/obj/skills/Blast/blt = new
					src.skill_blast = blt
					blt.skill_lvl = 33
					blt.loc = src

					var/obj/skills/Beam/b = new
					src.skill_beam = b
					b.skill_lvl = 25
					b.loc = src
		Demons
			Psionic_Demon_Lesser
				icon = 'Demon_Base_Male.dmi'
				agressive = 1
				bolted = 0
				name = "{NPC} Lesser Psionic Demon"
				mouse_over_pointer = MOUSE_ACTIVE_POINTER
				New()
					..()
					src.set_lists()
					src.id = global_id;
					global_id += 1;

					var/list/msg1[0]
					msg1["text"] = "You are a Demon warrior named Red from the Other Realms, created at the dawn of time."
					msg1["index"] = 1
					msg1["recency"] = 1
					msg1["importance"] = 1

					var/list/msg2[0]
					msg2["text"] = "Your master is Lord Zarthorlaraus."
					msg2["index"] = 2
					msg2["recency"] = 0.99
					msg2["importance"] = 0.8

					var/list/msg3[0]
					msg3["text"] = "You are devious, cunning, quick to anger and enjoy violence."
					msg3["index"] = 3
					msg3["recency"] = 1
					msg3["importance"] = 0.9

					var/list/msg4[0]
					msg4["text"] = "You are bored and want a battle. You think souls taste the best. You think Humans are weak compared to Demons."
					msg4["index"] = 4
					msg4["recency"] = 1
					msg4["importance"] = 0.7

					//src.npc_chat_log = list(msg1,msg2,msg3,msg4)

					sleep(60)
					src.start_loc = src.loc
					//src.Demon()
					src.name = "Red"
					src.real_name = "Red"
					src.name_txt()
					src.create_afterimages()

					src.psionic_power = 10
					src.energy = 1000
					src.energy_max = 1000
					src.strength = 10
					src.endurance = 10
					src.force = 10
					src.resistance = 10
					src.offence = 10
					src.defence = 10

					src.gender = "male"
					src.gen = "Male"
					src.race = "Demon"
					src.set_icon(src)

					/*
					spawn(20)
						if(src)
							var/F = "What are you both doing here in the domain of demons?!"
							for(var/mob/M in range(10,src))
								if(M.client) M << output("<BIG>\icon[src.icon]</BIG><font size=[M.text_size] color=[src.text_color_ic]>[src.name] says: [F]<p>","chat.local")
								else
									spawn(60)
										if(src && M && M.ai_enabled)
											if(M.ai_conversation_members.Find(src) == 0)
												M.ai_conversation_members += src
											if(src.ai_conversation_members.Find(M) == 0)
												src.ai_conversation_members += M
											M.ai_chat("[F]")
					*/

					src.icon_state = "meditate"

					var/obj/skills/Zanzoken/s = new
					s.loc = src
					src.skill_super_speed = s
					s.active = 1

					var/obj/skills/Flight/f = new
					f.loc = src
					f.skill_lvl = 25
					src.skill_flight = f

					var/obj/skills/Charge/c = new
					src.skill_charge = c
					c.skill_lvl = 25
					c.loc = src

					var/obj/skills/Blast/blt = new
					src.skill_blast = blt
					blt.skill_lvl = 33
					blt.loc = src

					var/obj/skills/Beam/b = new
					src.skill_beam = b
					b.skill_lvl = 25
					b.loc = src
		Birger
			//icon = 'human_male_white.dmi'
			icon_state = "meditate"
			name = "{NPC} Birger"
			gender = "male"
			agressive = 0
			bolted = 2
			can_harm = 0
			appearance_flags = KEEP_TOGETHER
			mouse_over_pointer = MOUSE_ACTIVE_POINTER
			New()
				..()
				var/obj/items/clothing/armour/armour1/a = new
				a.loc = src
				src.overlays += a
				src.set_lists()
				sleep(100)
				//src.Human()
				var/obj/overlay/hairs/normal/male/Hair7/h = new
				src.hair = h
				src.overlays += h
				src.name_txt()
				var/obj/traits/Unyielding_Fortitude/uf = new
				uf.loc = src
				call(uf.act)(src,uf)
				uf.active = 1
			proc
				set_colors(var/mob/m,var/list/buttons = list())
					for(var/b in buttons)
						winset(m,"dialogue.option[b]","text-color=#4c4747")
				reset_colors(var/mob/m)
					var/list/buttons = list(1,2,3,4,5,6,7,8,9,10,11,12)
					for(var/b in buttons)
						winset(m,"dialogue.option[b]","text-color=#0080C0")
				reset_convo(var/mob/m)
					src.reset_colors(usr)
					if(!m.topics_done.Find("birger intro"))
						m << output("<font color = #15BB36>*A burly man sits cross legged within the snow. He appears to be wearing a suit of custom made armour with a rune etched into the left breast plate. His attire is covered in oil stains and finger prints and you see a dirty cloth hanging from his belt which seems to have seen much use, along with a set of tools.*<p>","dialogue.dialogue")
						m << output("<font color = #15BB36>*He gives you a massive grin as you approach.*<p>","dialogue.dialogue")
						m << output("Birger:<font color = #1ADBDE> Why hello! Oh I do like visitors! You have come for a reason, no?<p>","dialogue.dialogue")
						m.topics_done += "birger intro"
					else
						if(m.topic == null) m << output("Birger:<font color = #1ADBDE> Welcome back friend! Please, come sit with me and talk, yes?<p>","dialogue.dialogue")
						if(m.topic == "birger who are you") m << output("Birger:<font color = #1ADBDE> Sure thing friend. What else would you like to talk about?<p>","dialogue.dialogue")
					if(!m.topics_done.Find("birger name"))
						winset(m,"dialogue.option1","text=\"Who are you?\"")
					else
						winset(m,"dialogue.option1","text=\"Who are you again?\"")
						winset(m,"dialogue.option6","text=\"Can you make anything for me?\"")
						src.buttons(m,list("option6"),"true")
					if(m.topics_done.Find("birger name finished")) winset(m,"dialogue.option1","text-color=#4c4747")
					if(m.topics_done.Find("birger jolly finished")) winset(m,"dialogue.option2","text-color=#4c4747")
					winset(m,"dialogue.option2","text=\"You seem rather jolly.\"")
					winset(m,"dialogue.option3","text=\"Why are you just sitting in the cold snow like that?\"")
					winset(m,"dialogue.option4","text=\"What's with that rune on your armour?\"")
					winset(m,"dialogue.option5","text=\"Goodbye.\"")
					src.buttons(m,list("option1","option2","option3","option4","option5"),"true")
					winset(m,"dialogue.name","text=\"[src.name]\"")
					m.topic = null
					m.talk_to = src
				buttons(var/mob/m,var/list/buttons,var/show = "false")
					for(var/b in buttons)
						winset(m,"dialogue.[b]","is-visible=[show]")
			verb
				option1()
					set src in view(3,usr)
					set name = ".option1"
					set hidden = 1
					if(usr.topic == null)
						var/t = "Who are you?"
						if(usr.topics_done.Find("birger name"))
							t = "Who are you again?"
							if(!usr.topics_done.Find("birger name finished")) usr.topics_done += "birger name finished"
						else usr.topics_done += "birger name"
						usr << output("[usr]: [t]<p>","dialogue.dialogue")
						usr << output("Birger:<font color = #1ADBDE> Who, me? Oh, I am nobody interesting. It is as you might say, not important. Buuuuuut if you must know. I am Birger. Nice to meet you!<p>","dialogue.dialogue")
						usr << output("Birger:<font color = #1ADBDE> I like to tinker. My people were very good mechanics. I don't have much these days, but for small price, I can make you something, yes?<p>","dialogue.dialogue")
						usr.topic = "birger who are you"
						src.reset_colors(usr)
						winset(usr,"dialogue.option1","text=\"Can you make anything for me?\"")
						winset(usr,"dialogue.option2","text=\"Lets talk about something else.\"")
						winset(usr,"dialogue.option3","text=\"Goodbye.\"")
						src.buttons(usr,list("option4","option5","option6"),"false")
						return
				option2()
					set src in view(3,usr)
					set name = ".option2"
					set hidden = 1
					if(usr.topic == "birger who are you")
						usr << output("[usr]: Lets talk about something else.<p>","dialogue.dialogue")
						src.reset_convo(usr)
						usr.topic = null
						return
					if(usr.topic == null)
						if(!usr.topics_done.Find("birger jolly finished")) usr.topics_done += "birger jolly finished"
						usr << output("[usr]: You seem rather jolly.<p>","dialogue.dialogue")
						usr << output("Birger:<font color = #1ADBDE> Yes. When there is not much to be glad about, and much to be glum, you start to find good in the little things, no?<p>","dialogue.dialogue")
						if(usr.topics_done.Find("birger jolly finished")) winset(usr,"dialogue.option2","text-color=#4c4747")
						return
				option3()
					set src in view(3,usr)
					set name = ".option3"
					set hidden = 1
					if(usr.topic == "birger who are you")
						winshow(usr, "dialogue", 0)
						usr.talk_to = null
						usr.topic = null
						return
				option5()
					set src in view(3,usr)
					set name = ".option5"
					set hidden = 1
					if(usr.topic == null)
						winshow(usr, "dialogue", 0)
						usr.talk_to = null
						usr.topic = null
						return
			Click()
				..()
				if(src in range(5,usr))
					var/icon/I = icon(src.icon,"",EAST,1,0)
					I.Scale(128,128)
					if(src.hair)
						var/icon/E = icon(src.hair.icon,"",EAST,1,0)
						E.Scale(128,128)
						I.Blend(E,ICON_OVERLAY)
					for(var/obj/items/clothing/armour/armour1/a in src)
						var/icon/X = icon(a.icon,"",EAST,1,0)
						X.Scale(128,128)
						I.Blend(X,ICON_OVERLAY)

					var/X = fcopy_rsc(I)
					winset(usr,"dialogue.portrait","image=\ref[X]")
					winshow(usr, "dialogue", 1)
					usr.reset_dialogue(src)

					src.reset_convo(usr)
		Oumuamua
			//icon = 'goog.dmi'
			icon_state = "meditate"
			name = "{NPC} Oumuamua"
			gender = "neuter"
			agressive = 0
			can_harm = 0
			bolted = 2
			mouse_over_pointer = MOUSE_ACTIVE_POINTER
			Click()
				..()
				if(src in range(5,usr))
					var/icon/I = icon(src.icon,"",EAST,1,0)
					I.Scale(128,128)
					var/X = fcopy_rsc(I)
					winset(usr,"dialogue.portrait","image=\ref[X]")
					winshow(usr, "dialogue", 1)
					usr.reset_dialogue(src)
					usr.talk_to = src
			New()
				..()
				src.overlays += /obj/effects/elec
				src.set_lists()
				sleep(100)
				//src.Cerebroid()
				src.name_txt()
			proc
				set_colors(var/mob/m,var/list/buttons = list())
					for(var/b in buttons)
						winset(m,"dialogue.option[b]","text-color=#4c4747")
				reset_colors(var/mob/m)
					var/list/buttons = list(1,2,3,4,5,6,7,8,9,10,11,12)
					for(var/b in buttons)
						winset(m,"dialogue.option[b]","text-color=#0080C0")
		Goog_Enforcer
			//icon = 'goog.dmi'
			name = "{NPC} Enforcer"
			gender = "male"
			agressive = 1
			race = "Goog"
			appearance_flags = KEEP_TOGETHER

			attacked_text = "Feh'ak! Uh'tok Ba'rom!"
			attack_text = "Gro pak tor!"
			Click(location,control,params)
				..()
				params = params2list(params)
				if(params["right"])
					usr.open_dialogue = 1
					usr.open_menus.Add(".close_dialogue")
					if(get_dist(usr,src) < 3)
						usr.talk_to = src
						winshow(usr, "dialogue", 1)

						winset(usr,"dialogue.label_title","text=\"[src.name]\"")
						winset(usr,"dialogue.age_text","text=\"[src.age]\"")
						winset(usr,"dialogue.gender_text","text=\"[src.gender]\"")


						var/icon/I = icon(src.icon,"",EAST,1,0)
						I.Scale(128,128)

						if(src.hair)
							var/icon/E = icon(src.hair.icon,"",EAST,1,0)
							E.Scale(128,128)

							//var/obj/Z = new
							I.Blend(E,ICON_OVERLAY)
						//Z.icon = E

						var/X = fcopy_rsc(I)
						winset(usr,"dialogue.portrait","image=\ref[X]")
			New()
				..()
				src.set_lists()
				sleep(100)
				//src.Cerebroid()
				set_stats(33,3333,3,33,100,33,33,33)
				src.name_txt()

				src.faction = factions[4]

				if(src.shadow) src.shadow.loc = src.loc
				src.eng_attack = 1
				//src.ki_attacks()
				while(src)
					if(src.koed == 0 && src.stunned == 0)
						if(src.village) if(!src.target)
							src.mouse_down = null
							if(get_dist(src,src.village) < 40)
								if(src.task == null)
									if(prob(1)) src.task = pick("wait","fly")
									else if(prob(99)) step_rand(src)
									else src.dir = rand(1,8)
									if(prob(1))
										src.icon_state = "Flight"
								else if(prob(0.25))
									src.task = null
									src.icon_state = src.state()
							else step_towards(src,src.village)
						if(src.target)
							var/dist = bounds_dist(src, src.target)
							if(dist >= 32)
								src.mouse_down = src.target.loc
							else src.mouse_down = null
							if(dist >= 320 || src.target.koed)
								src.target = null
								src.mouse_down = null
					sleep(0.5)
		Mercenary
			//icon = 'human_male_white.dmi'
			name = "{NPC} Mercenary"
			gender = "male"
			agressive = 0
			race = "Human"
			appearance_flags = KEEP_TOGETHER

			attacked_text = list("Ha! So you wanna go a few rounds with me, huh?!", "Big mistake, pal!","You fool!","Come on then, bring it!","You'll regret that!","I don't have to take that from you!","Scum!")
			attack_text = list("I'm taking you down!","Prepare yourself!","Make this easy on yourself and just keel over!","You're mine!","Say bye bye!", "I'd kill you for free!","Let's dance!")
			Click(location,control,params)
				..()
				params = params2list(params)
				if(params["right"])
					usr.open_dialogue = 1
					usr.open_menus.Add(".close_dialogue")
					if(get_dist(usr,src) < 3)
						usr.talk_to = src
						winshow(usr, "dialogue", 1)

						winset(usr,"dialogue.label_title","text=\"[src.name]\"")
						winset(usr,"dialogue.age_text","text=\"[src.age]\"")
						winset(usr,"dialogue.gender_text","text=\"[src.gender]\"")


						var/icon/I = icon(src.icon,"",EAST,1,0)
						I.Scale(128,128)

						if(src.hair)
							var/icon/E = icon(src.hair.icon,"",EAST,1,0)
							E.Scale(128,128)

							//var/obj/Z = new
							I.Blend(E,ICON_OVERLAY)
						//Z.icon = E

						var/X = fcopy_rsc(I)
						winset(usr,"dialogue.portrait","image=\ref[X]")
			New()
				..()
				src.set_lists()
				sleep(100)
				//src.layer = 100 - src.y
				var/obj/items/tech/armors/a = new
				a.loc = src
				src.overlays += a
				//src.Human()
				set_stats(100,1000,100,100,100,100,100,100)
				src.faction = factions[3]
				var/g = pick(1,2)
				if(g == 1)
					src.icon = pick(skins_human_male)
					src.hair = pick(hairs_male)
					src.gender = "male"
				else
					src.icon = pick(skins_human_female)
					src.hair = pick(hairs_female)
					src.gender = "female"
				//src.state = "fly"
				//src.icon_state = "fly"
				//src.density_factor = 0
				var/obj/skills/Zanzoken/spd = new
				spd.loc = src
				src.skill_super_speed = spd
				spd.active = 1
				src.overlays += src.hair
				src.name_txt()

				//src.strength = 10
				if(src.shadow) src.shadow.loc = src.loc
				while(src)
					if(src.koed == 0 && src.stunned == 0)
						if(src.village) if(!src.target)
							if(get_dist(src,src.village) < 40)
								if(src.task == null)
									if(prob(1)) src.task = pick("wait","meditate")
									else if(prob(99)) step_rand(src)
									else src.dir = rand(1,8)
								else if(prob(0.25))
									src.task = null
									src.icon_state = src.state()
								else if(src.task == "meditate") src.icon_state = "meditate"
							else step_towards(src,src.village)
						if(src.target)
							var/dist = bounds_dist(src, src.target)
							if(dist >= 32) if(!src.target.KB) step_towards(src,src.target)
							if(dist >= 320 || src.target.koed) src.target = null
						//else if(prob(0.1)) src.hate_list = list()
					sleep(0.5)

		dummy
			//icon = 'human_male_white.dmi'
			name = "{NPC} Fighter"
			gender = "male"
			appearance_flags = KEEP_TOGETHER
			DblClick()
				var/combat = 1
				var/list/combatants = list(usr,src)
				var/mob/attacker = usr
				var/mob/defender = src
				while(combat)
					if(bounds_dist(usr, src) < 32)
						usr.dir = get_dir(usr,src)
						src.dir = get_dir(src,usr)
						//var/attacker = pick(
						if(prob(90)) usr.icon_state = usr.state(1)
						if(prob(90)) src.icon_state = src.state(1)
						sleep(1)
						src.icon_state = src.state()
						usr.icon_state = usr.state()
						if(prob(25)) new /obj/effects/shockwave_small (pick(usr.loc,src.loc))
						if(prob(10))
							var/mob/kbed = pick(combatants) //The knocked back
							if(kbed.KB == 0)
								var/mob/kber //The knock backer
								if(kbed == attacker) kber = defender
								if(kbed == defender && kber == null) kber = attacker
								kbed.KB=50
								if(kbed.KB>100) kbed.KB=100
								if(kbed.KB > 0)
									new /obj/effects/shockwave_small (kbed.loc)
									var/obj/effects/hit/h = new
									h.loc = kber.loc
									h.dir = kber.dir
									if(kber.dir == SOUTH ||kber.dir == NORTH) h.pixel_x += 16
									h.step_x = kber.step_x
									h.step_y = kber.step_y
								var/KB_dir = get_dir(kber.loc,kbed.loc)
								KB_dir = kber.dir
								if(kbed.KB > 1) kbed.dir = KB_dir
								if(kber.strength >= 100) kbed.KB_furrow = 1
								kbed.KnockBack(KB_dir)
					else if (defender.KB || attacker.KB)
						//world << "check1"
						var/mob/kbed
						var/mob/kber
						if(attacker.KB)
							kbed = attacker
							kber = defender
						if(defender.KB)
							kbed = defender
							kber = attacker
						if(kber) step_towards(kber,kbed.loc,8)
					sleep(1)
			New()
				..()
				src.set_lists()
				sleep(100)
				//src.layer = 100 - src.y
				//src.Human()
				src.icon = pick(skins_human_male)
				src.endurance = 100
				//src.state = "fly"
				//src.icon_state = "fly"
				//src.density_factor = 0
				src.hair = pick(hairs_male)
				src.overlays += src.hair
				src.name_txt()

				//src.strength = 10
				if(src.shadow)
					src.shadow.loc = src.loc
		split
			//icon = 'human_male_white.dmi'

			New()
				..()
				src.set_lists()
				src.tmp_lists()
				spawn(10)
					if(src)
						//src.started = 1
						src.process_stats()

						/*
						while(src)
							var/T = 10
							if(src.koed) T = 10
							else if(src.function == "follow" || src.function == "attack")
								if(src.target_follow)
									T = 0.5
									var/dist = bounds_dist(src, src.target_follow)
									if(dist >= 16) if(!src.target_follow.KB && !src.KB) step_towards(src,src.target_follow)
									if(dist >= 320 || src.target_follow.koed) src.target_follow = null
									if(function == "attack" && target) src.Attack()
							else if(src.function == "go" || src.function == "grab")
								if(src.target_go)
									T = 0.5
									if(!src.KB)
										step_towards(src,src.target_go)
										var/dist = bounds_dist(src, src.target_go)
										if(dist <= 0)
											if(src.function == "grab" && ismovable(src.target_go)) src.grab_something(src.target_go)//src.pickup(src.target_go)
							else if(src.percent_health < 100 && src.percent_health > 0) src.icon_state = "meditate"
							else src.state()
							sleep(T)
						*/
