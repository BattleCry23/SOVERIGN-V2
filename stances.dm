obj
	stances
		icon = 'skills.dmi'
		icon_state = "origin"
		stance = 1
		info_point_cost = 1
		info_point_cost_type = "combat"
		info_duration = "Toggleable"
		plane = 33
		layer = 34
		blend_mode = BLEND_INSET_OVERLAY
		appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
		var
			list/category = null //The category this skill is in.
		MouseMove(location,control,params)
			usr.info_box(src,"[src.name]",params)
		MouseEntered(object,location,control,params)
			usr.mouse_saved_loc = src
			usr.client.images += src.img_over
			//winset(usr,"traits.traits_info","text=\"[src.name] - [src.info]\"")
			if(usr.info_box1)
				usr.client.screen += usr.info_box1
				usr.client.screen += usr.info_box2
				usr.client.screen += usr.info_box3
		MouseExited(location,control,params)
			usr.client.images -= src.img_over
			if(usr.info_box1)
				usr.client.screen -= usr.info_box1
				usr.client.screen -= usr.info_box2
				usr.client.screen -= usr.info_box3
				usr.info_box3.maptext = null
		New()
			..()
			var/image/over = image('unlocks_over.dmi',src,"over",100)
			over.pixel_x = -1
			over.pixel_y = -1
			src.img_over = over
			category = list("Stance","Buff")
		Click()
			if(src.loc == null && usr.hud_unlocks)
				usr.skill_selected = src
				var/obj/hud/menus/unlocks_background/bg = usr.hud_unlocks
				var/cats = ""
				var/stats = ""
				if(src.info_stats) stats = "\n\n[src.info_stats]"
				for(var/c in src.category)
					if(cats == "") cats = "[c]"
					else cats = "[cats], [c]"
				bg.info_txt.maptext = "[css_outline]<font size = 1><text align=left valign=top>Point Cost: [src.info_point_cost]\n\nCategories: [cats]\n\n[src.info_buffs][stats]\n\n[src.info]"

				var/icon/I = icon(src.icon,src.icon_state,SOUTH,1,0)
				I.Scale(64,64)
				bg.unlock_icon.icon = I
				var/matrix/m = matrix()
				m.Translate(464,280)
				bg.unlock_icon.hud_x = 464
				bg.unlock_icon.hud_y = 280
				bg.unlock_icon.transform = m

				if(isnum(src.info_dmg)) bg.bar_power.icon_state = "[src.info_dmg]"
				if(isnum(src.info_spd)) bg.bar_speed.icon_state = "[src.info_spd]"
				if(isnum(src.info_energy_cost)) bg.bar_energy.icon_state = "[src.info_energy_cost]"
				if(isnum(src.info_mastery)) bg.bar_mastery.icon_state = "[src.info_mastery]"
				if(isnum(src.info_cd)) bg.bar_cooldown.icon_state = "[src.info_cd]"

				bg.name_txt.maptext = "[css_outline]<font size = 1><center>[src.name]"
		MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
			var/icon/i = new(src.icon,src.icon_state)
			usr.client.mouse_pointer_icon = i
		MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
			usr.client.mouse_pointer_icon = null
			//usr << output("Test drag and drop skill - [over_control],[over_object]", "chat.system")
			if(findtext(over_control,"main"))
				usr << output(null,"[over_control]")
				usr << output(src,"[over_control]:1")
				winset(usr, "[over_control]", "cells=\"1\"")
				if(findtext(over_control,"one"))
					usr.one = list(src)
					if(src.repeat == 1)
						if(usr.one_rep == 0)
							winset(usr,"macro.1","name= 1+REP")
							usr.one_rep = 1;
					else if(usr.one_rep == 1)
						winset(usr,"macro.1+REP","name= 1")
						usr.one_rep = 0;

				if(findtext(over_control,"two"))
					usr.two = list(src)
					if(src.repeat == 1)
						if(usr.two_rep == 0)
							winset(usr,"macro.2","name= 2+REP")
							usr.two_rep = 1;
					else if(usr.two_rep == 1)
						winset(usr,"macro.2+REP","name= 2")
						usr.two_rep = 0;

				if(findtext(over_control,"three"))
					usr.three = list(src)
					if(src.repeat == 1)
						if(usr.three_rep == 0)
							winset(usr,"macro.3","name= 3+REP")
							usr.three_rep = 1;
					else if(usr.three_rep == 1)
						winset(usr,"macro.3+REP","name= 3")
						usr.three_rep = 0;

				if(findtext(over_control,"four"))
					usr.four = list(src)
					if(src.repeat == 1)
						if(usr.four_rep == 0)
							winset(usr,"macro.4","name= 4+REP")
							usr.four_rep = 1;
					else if(usr.four_rep == 1)
						winset(usr,"macro.4+REP","name= 4")
						usr.four_rep = 0;

				if(findtext(over_control,"five"))
					usr.five = list(src)
					if(src.repeat == 1)
						if(usr.five_rep == 0)
							winset(usr,"macro.5","name= 5+REP")
							usr.five_rep = 1;
					else if(usr.five_rep == 1)
						winset(usr,"macro.5+REP","name= 5")
						usr.five_rep = 0;

				if(findtext(over_control,"six"))
					usr.six = list(src)
					if(src.repeat == 1)
						if(usr.six_rep == 0)
							winset(usr,"macro.6","name= 6+REP")
							usr.six_rep = 1;
					else if(usr.six_rep == 1)
						winset(usr,"macro.6+REP","name= 6")
						usr.six_rep = 0;

				if(findtext(over_control,"seven"))
					usr.seven = list(src)
					if(src.repeat == 1)
						if(usr.seven_rep == 0)
							winset(usr,"macro.7","name= 7+REP")
							usr.seven_rep = 1;
					else if(usr.seven_rep == 1)
						winset(usr,"macro.7+REP","name= 7")
						usr.seven_rep = 0;

				if(findtext(over_control,"eight"))
					usr.eight = list(src)
					if(src.repeat == 1)
						if(usr.eight_rep == 0)
							winset(usr,"macro.8","name= 8+REP")
							usr.eight_rep = 1;
					else if(usr.eight_rep == 1)
						winset(usr,"macro.8+REP","name= 8")
						usr.eight_rep = 0;

				if(findtext(over_control,"nine"))
					usr.nine = list(src)
					if(src.repeat == 1)
						if(usr.nine_rep == 0)
							winset(usr,"macro.9","name= 9+REP")
							usr.nine_rep = 1;
					else if(usr.nine_rep == 1)
						winset(usr,"macro.9+REP","name= 9")
						usr.nine_rep = 0;

				if(findtext(over_control,"zero"))
					usr.zero = list(src)
					if(src.repeat == 1)
						if(usr.zero_rep == 0)
							winset(usr,"macro.0","name= 0+REP")
							usr.zero_rep = 1;
					else if(usr.zero_rep == 1)
						winset(usr,"macro.0+REP","name= 0")
						usr.zero_rep = 0;

				if(findtext(over_control,"minus"))
					usr.minus = list(src)
					if(src.repeat == 1)
						if(usr.minus_rep == 0)
							winset(usr,"macro.-","name= -+REP")
							usr.minus_rep = 1;
					else if(usr.minus_rep == 1)
						winset(usr,"macro.-+REP","name= -")
						usr.minus_rep = 0;

				if(findtext(over_control,"equal"))
					usr.equal = list(src)
					if(src.repeat == 1)
						if(usr.equal_rep == 0)
							winset(usr,"macro.=","name= =+REP")
							usr.equal_rep = 1;
					else if(usr.equal_rep == 1)
						winset(usr,"macro.=+REP","name= =")
						usr.equal_rep = 0;
				//usr.skills_bar()
				return
			if(findtext(src_control,"main")) if(!findtext(over_control,"main"))
				usr << output(null,"[src_control]")
				if(findtext(src_control,"one")) usr.one = null
				if(findtext(src_control,"two")) usr.two = null
				if(findtext(src_control,"three")) usr.three = null
				if(findtext(src_control,"four")) usr.four = null
				if(findtext(src_control,"five")) usr.five = null
				if(findtext(src_control,"six")) usr.six = null
				if(findtext(src_control,"seven")) usr.seven = null
				if(findtext(src_control,"eight")) usr.eight = null
				if(findtext(src_control,"nine")) usr.nine = null
				if(findtext(src_control,"zero")) usr.zero = null
				if(findtext(src_control,"minus")) usr.minus = null
				if(findtext(src_control,"equal")) usr.equal = null
				return
		Flow_like_Water
			//Increases all stats based on your max energy. Basically converts energy into stats.
			//Tier 4
			name = "Flow like Water"
			info = ""
			info_name = "Flow_like_Water"
			info_point_cost = 1
			info_buffs = "+10% of energy mod toward all stats except Recovery & Regen. -50% max energy."
			info_energy_cost = "None"
			info_mastery = "Very Slow"
			var/energy_saved = 0;
			act = /obj/stances/Flow_like_Water/proc/activate
			proc
				activate(var/mob/m,var/obj/stances/Flow_like_Water/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.icon_state = initial(s.icon_state)
						s.active = 0
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.1
						m.mod_energy *= 2
						var/n = 1 + (s.energy_saved / 10)

						m.mod_strength /= n
						m.mod_endurance /= n
						m.mod_force /= n
						m.mod_resistance /= n
						m.mod_offence /= n
						m.mod_defence /= n

						m.strength /= n
						m.endurance /= n
						m.force /= n
						m.resistance /= n
						m.offence /= n
						m.defence /= n
					else
						s.active = 1
						s.icon_state = "selected"
						s.energy_saved = m.mod_energy
						var/n = 1 + (m.mod_energy / 10)
						m.stance = s
						m.mod_recovery /= 1.1
						m.mod_energy /= 2

						m.mod_strength *= n
						m.mod_endurance *= n
						m.mod_force *= n
						m.mod_resistance *= n
						m.mod_offence *= n
						m.mod_defence *= n

						m.strength *= n
						m.endurance *= n
						m.force *= n
						m.resistance *= n
						m.offence *= n
						m.defence *= n
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Will_of_Steel
			//Lets you fight on until -100% health, and -100% energy.
			//Tier 4
			name = "Will of Steel"
			info = ""
			info_name = "Will_of_Steel"
			info_point_cost = 1
			info_buffs = "Health, Energy"
			info_energy_cost = "Very High"
			info_mastery = "Very Slow"
			act = /obj/stances/Will_of_Steel/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.2
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.2
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Preternatural_Instinct
			//Basically ultra instinct, gives massive stats to defence, agility and power.
			//Tier 4
			name = "Preternatural Instinct"
			info = ""
			info_name = "Preternatural_Instinct"
			info_point_cost = 1
			info_buffs = "Defence, Agility, Power"
			info_energy_cost = "Very High"
			info_mastery = "Very Slow"
			act = /obj/stances/Preternatural_Instinct/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.2
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.2
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Precognitive_Intuition
			//Lets you dodge most energy attacks
			//Tier 4
			name = "Precognitive Intuition"
			info = ""
			info_name = "Precognitive_Intuition"
			info_point_cost = 1
			info_buffs = "Other"
			info_energy_cost = "Very High"
			info_mastery = "Very Slow"
			act = /obj/stances/Precognitive_Intuition/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.2
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.2
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Defensive_Curl
			//Increases all defensive stats massively, but reduces all offensive stats massively.
			//Tier 3
			name = "Defensive Curl"
			info = ""
			info_name = "Defensive_Curl"
			info_point_cost = 1
			info_buffs = "+100% Defence, Endurance, resistance. -50% Offence, Strength, Force, Recovery"
			info_energy_cost = "High"
			info_mastery = "slow"
			act = /obj/stances/Defensive_Curl/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_defence /= 2
						m.defence /= 2
						m.mod_endurance /= 2
						m.endurance /= 2
						m.mod_resistance /= 2
						m.resistance /= 2
						m.mod_offence *= 2
						m.offence *= 2
						m.mod_strength *= 2
						m.strength *= 2
						m.mod_force *= 2
						m.force *= 2
						m.mod_recovery *= 2
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_defence *= 2
						m.defence *= 2
						m.mod_endurance *= 2
						m.endurance *= 2
						m.mod_resistance *= 2
						m.resistance *= 2
						m.mod_offence /= 2
						m.offence /= 2
						m.mod_strength /= 2
						m.strength /= 2
						m.mod_force /= 2
						m.force /= 2
						m.mod_recovery /= 2
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Unassailable_Posture
			//Enhances endurance and resistance, halves movement. Makes you impossible to move via tk or grabbing.
			//Tier 3
			name = "Unassailable Posture"
			info = ""
			info_name = "Unassailable_Posture"
			info_point_cost = 1
			info_buffs = "+20% Endurance, +20% resistance, -10% Recovery"
			info_energy_cost = "Medium"
			info_mastery = "Slow"
			act = /obj/stances/Unassailable_Posture/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.1
						m.mod_endurance /= 1.2
						m.endurance /= 1.2
						m.mod_resistance /= 1.2
						m.resistance /= 1.2
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.1
						m.mod_endurance *= 1.2
						m.endurance *= 1.2
						m.mod_resistance *= 1.2
						m.resistance *= 1.2
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Way_of_Shadows
			//Enhances offence, agility and creates a shadow as you move. Shadows have a chance to split off and attack your target like a split form does with super speed.
			//Tier 3
			name = "The Way of Shadows"
			info = ""
			info_name = "Way_of_Shadows"
			info_point_cost = 1
			info_buffs = "+20% Offence, +20% Agility, -10% Recovery"
			info_energy_cost = "Medium"
			info_mastery = "Slow"
			act = /obj/stances/Way_of_Shadows/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.1
						m.mod_agility /= 1.2
						m.mod_offence /= 1.2
						m.offence /= 1.2
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.1
						m.mod_agility *= 1.2
						m.mod_offence *= 1.2
						m.offence *= 1.2
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Energized_Tranquility
			//Doubles energy
			//Tier 3
			name = "Energized Tranquility"
			info = ""
			info_name = "Energized_Tranquility"
			info_point_cost = 1
			info_buffs = "+100% Max Energy"
			info_energy_cost = "None"
			info_mastery = "Slow"
			act = /obj/stances/Energized_Tranquility/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_energy /= 2
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_energy *= 2
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Null_and_Void
			//Large boost to resistance, absorb some of the energy used in psi attacks against you.
			//Tier 2
			name = "Null and Void"
			info = ""
			info_name = "Null_and_Void"
			info_point_cost = 1
			info_buffs = "resistance"
			info_buffs = "+20% resistance, -10% Recovery"
			info_energy_cost = "Medium"
			info_mastery = "Medium"
			act = /obj/stances/Null_and_Void/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.1
						m.mod_resistance /= 1.2
						m.resistance /= 1.2
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.1
						m.mod_resistance *= 1.2
						m.resistance *= 1.2
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Defence_Stance
			//Large boost to defence, counter attack any hits that do make it through.
			//Tier 2
			name = "Defence Stance"
			info = ""
			info_name = "Defence_Stance"
			info_point_cost = 1
			info_buffs = "Defence"
			info_energy_cost = "Medium"
			info_buffs = "+20% Defence, -10% Recovery"
			info_mastery = "Medium"
			act = /obj/stances/Defence_Stance/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.1
						m.mod_defence /= 1.2
						m.defence /= 1.2
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.1
						m.mod_defence *= 1.2
						m.defence *= 1.2
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)

		Attack_Stance
			//Large boost to offence, chance to hit twice.
			//Tier 2
			name = "Attack Stance"
			info = ""
			info_name = "Attack_Stance"
			info_point_cost = 1
			info_buffs = "Offence"
			info_energy_cost = "Medium"
			info_buffs = "+20% Offence, -10% Recovery"
			info_mastery = "Medium"
			act = /obj/stances/Attack_Stance/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.1
						m.mod_offence /= 1.2
						m.offence /= 1.2
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.1
						m.mod_offence *= 1.2
						m.offence *= 1.2
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Swift_like_Wind
			//Large boost to agility, increase movement speed.
			//Tier 2
			name = "Swift like the Wind"
			info = ""
			info_name = "Swift_like_Wind"
			info_point_cost = 1
			info_buffs = "Agility"
			info_energy_cost = "Medium"
			info_buffs = "+20% Agility, -10% Recovery"
			info_mastery = "Medium"
			act = /obj/stances/Swift_like_Wind/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.1
						m.mod_agility /= 1.2
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.1
						m.mod_agility *= 1.2
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Mind_over_Matter
			//Large boost to force, boost to skill gain exp, lower energy cost for skills (not stances)
			//Tier 2
			name = "Mind over Matter"
			info = ""
			info_name = "Mind_over_Matter"
			info_point_cost = 1
			info_buffs = "Force"
			info_energy_cost = "Medium"
			info_buffs = "+20% Force, -10% Recovery"
			info_mastery = "Medium"
			act = /obj/stances/Mind_over_Matter/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.1
						m.mod_force /= 1.2
						m.force /= 1.2
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.1
						m.mod_force *= 1.2
						m.force *= 1.2
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Body_like_Rock
			//Large boost to endurance, reduce enviromental damage, increase grav mastery
			//Tier 2
			name = "Body like Rock"
			info = ""
			info_name = "Body_like_rock"
			info_point_cost = 1
			info_buffs = "Endurance"
			info_energy_cost = "Medium"
			info_buffs = "+20% Endurance, -10% Recovery"
			info_mastery = "Medium"
			act = /obj/stances/Body_like_Rock/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.1
						m.mod_endurance /= 1.2
						m.endurance /= 1.2
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.1
						m.mod_endurance *= 1.2
						m.endurance *= 1.2
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Aspect_of_Lotus
			//Large boost to regen
			//Tier 2
			name = "Aspect of the Lotus"
			desc = "Adopt the aspect of the lotus and allow the body to heal and regenerate, like the natural flow of liquid and gentle rhythm of the lotus flower upon its water lily."
			info = "+20% Regeneration \n -10% Recovery"
			info_stats = "+20% Regeneration \n\n -10% Recovery"
			info_name = "Aspect_of_Lotus"
			info_buffs = "+20% Regeneration, -10% Recovery"
			info_point_cost = 1
			info_buffs = "Regeneration"
			info_energy_cost = "Medium"
			info_mastery = "Medium"
			act = /obj/stances/Aspect_of_Lotus/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.1
						m.mod_regeneration /= 1.2
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.1
						m.mod_regeneration *= 1.2
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Fist_of_Mastodon
			//Large strength boost, enhanced grip strength, more strength exp while active
			//Tier 2
			name = "Fist of the Mastodon"
			info = ""
			info_name = "Fist_of_Mastodon"
			info_point_cost = 1
			info_buffs = "Strength"
			info_energy_cost = "Medium"
			info_buffs = "+20% Strength, -10% Recovery"
			info_mastery = "Medium"
			act = /obj/stances/Fist_of_Mastodon/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.1
						m.mod_strength /= 1.2
						m.strength /= 1.2
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.1
						m.mod_strength *= 1.2
						m.strength *= 1.2
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Way_of_Ox
			//Enhances strength
			//Tier 1
			name = "Way of the Ox"
			info = ""
			info_name = "Way_of_Ox"
			info_point_cost = 1
			info_buffs = "+10% Strength, -5% Recovery"
			info_energy_cost = "Low"
			info_mastery = "Medium"
			act = /obj/stances/Way_of_Ox/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.05
						m.mod_strength /= 1.1
						m.strength /= 1.1
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.05
						m.mod_strength *= 1.1
						m.strength *= 1.1
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Way_of_Mountain
			//Enhances endurance
			//Tier 1
			name = "Way of the Mountain"
			info = ""
			info_name = "Way_of_Mountain"
			info_buffs = "+10% Endurance, -5% Recovery"
			info_point_cost = 1
			info_buffs = "Endurance"
			info_energy_cost = "Low"
			info_mastery = "Medium"
			act = /obj/stances/Way_of_Mountain/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.05
						m.mod_endurance /= 1.1
						m.endurance /= 1.1
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.05
						m.mod_endurance *= 1.1
						m.endurance *= 1.1
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Way_of_Resilience
			//Enhances resistance
			//Tier 1
			name = "The Way of Resilience"
			info = ""
			info_name = "Way_of_Resilience"
			info_buffs = "+10% resistance, -5% Recovery"
			info_point_cost = 1
			info_buffs = "resistance"
			info_energy_cost = "Low"
			info_mastery = "Medium"
			act = /obj/stances/Way_of_Resilience/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.05
						m.mod_resistance /= 1.1
						m.resistance /= 1.1
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.05
						m.mod_resistance *= 1.1
						m.resistance *= 1.1
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Way_of_Mind
			//Enhances force
			//Tier 1
			name = "Way of the Mind"
			info = ""
			info_name = "Way_of_Mind"
			info_buffs = "+10% Force, -5% Recovery"
			info_point_cost = 1
			info_buffs = "Force"
			info_energy_cost = "Low"
			info_mastery = "Medium"
			act = /obj/stances/Way_of_Mind/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.05
						m.mod_force /= 1.1
						m.force /= 1.1
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.05
						m.mod_force *= 1.1
						m.force *= 1.1
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Way_of_Tortoise
			//Enhances defence
			//Tier 1
			name = "The Way of Tortoise"
			info = ""
			info_name = "Way_of_Tortoise"
			info_buffs = "+10% Defence, -5% Recovery"
			info_point_cost = 1
			info_buffs = "Defence"
			info_energy_cost = "Low"
			info_mastery = "Medium"
			act = /obj/stances/Way_of_Tortoise/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.05
						m.mod_defence /= 1.1
						m.defence /= 1.1
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.05
						m.mod_defence *= 1.1
						m.defence *= 1.1
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Way_of_Palm
			//Enhances offence
			//Tier 1
			name = "Way of the Palm"
			info = ""
			info_name = "Way_of_Palm"
			info_buffs = "+10% Offence, -5% Recovery"
			info_point_cost = 1
			info_buffs = "Offence"
			info_energy_cost = "Low"
			info_mastery = "Medium"
			act = /obj/stances/Way_of_Palm/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.05
						m.mod_offence /= 1.1
						m.offence /= 1.1
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.05
						m.mod_offence *= 1.1
						m.offence *= 1.1
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Way_of_Agility
			//Enhances agility
			//Tier 1
			name = "The Way of Agility"
			info = ""
			info_name = "Way_of_Agility"
			info_buffs = "+10% Agility, -5% Recovery"
			info_point_cost = 1
			info_buffs = "Agility"
			info_energy_cost = "Low"
			info_mastery = "Medium"
			act = /obj/stances/Way_of_Agility/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.05
						m.mod_agility /= 1.1
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.05
						m.mod_agility *= 1.1
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
		Way_of_Constitution
			//Enhances regen
			//Tier 1
			name = "The Way of Constitution"
			info = ""
			info_name = "Way_of_Constitution"
			info_buffs = "+10% Regeneration, -5% Recovery"
			info_point_cost = 1
			info_buffs = "Regeneration"
			info_energy_cost = "Low"
			info_mastery = "Medium"
			act = /obj/stances/Way_of_Constitution/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(m.stance && s != m.stance) //Switch off all other stances first
						m.disable_stances(s,0)
					if(s.active)
						s.active = 0
						s.icon_state = initial(s.icon_state)
						if(m.stance == s) m.stance = null
						m.mod_recovery *= 1.05
						m.mod_regeneration /= 1.1
					else
						s.active = 1
						s.icon_state = "selected"
						m.stance = s
						m.mod_recovery /= 1.05
						m.mod_regeneration *= 1.1
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					if(m.buff_stance)
						m.buff_stance.active = s.active
						var/image/txt = m.buff_stance.info_txt
						txt.maptext = "<font size = 1><center>Stance: [s.name]"
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed || m.meditating) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)