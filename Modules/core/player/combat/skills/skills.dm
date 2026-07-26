datum/ki_blade
    var
        name
        power
        color
        side
datum/ki_fist
	var
		name
		power
		color
		side

datum/custom_beam
	var
		name
		power
		color
		side
		chant
		chantEnabled

datum/custom_stance
	var
		name
		power
		color
		side
		chant
		chantEnabled
		stance_type

datum/custom_blast
	var
		name
		power
		color
		side
		chant
		chantEnbaled

datum/custom_piercing_beam
	var
		name
		power
		color
		side
		chant
		chantEnabled

obj
	skills
		icon = 'skills.dmi'
		icon_state = "origin"
		skill_lvl = 1
		layer = 34//27
		plane = 33
		box_x_scale = 64
		box_y_scale = 16
		box_x_shift = 16
		box_y_shift = 4
		var
			list/category = null //The category this skill is in.
			obj/lvl_overlay
			overlay_pos
			displayed = 0
			disable_sleep = 0 //Makes sure this skills sleep procs, if any, are not ticking when part of a world.list
			attack_state = null
			last_used = null
			teach_energy = 0
			teach_cd = 0
			cd_current = 0
			cd_max = 0
			cd_text = null
			cd_state = 32
			image/cd_bar = null
			obj/cd_box = null
			cloned = null //When set to non-null, means this skill had its looks and act var copied to a AA_Skill_Copy, ready to be displayed in the skills menu.
			tmp/obj/clone_of = null //A ref pointer to the actual orginal skill. Set by AA_Skill_Copy objs only
			tmp/obj/clone = null //A ref pointer, from the orginal skill to its clone. Set by /obj/skills only
			/*
			.:For skill bar info:.
			0 = None
			1 = Low
			2 = Medium
			3 = High
			4 = Very High
			5 = Extreme
			*/

		New()
			..()
			var/image/over = image('unlocks_over.dmi',src,"over",100)
			over.pixel_x = -1
			over.pixel_y = -1
			src.img_over = over

		Click()
			//usr.check_quest("tutorial_use_skill",1)
			if(src.loc == null && usr.hud_unlocks || usr.hud_unlocks && src.passive_skill == 1)
				usr.skill_selected = src
				var/obj/hud/menus/unlocks_background/bg = usr.hud_unlocks
				var/cats = ""
				var/stats = ""
				if(src.info_stats) stats = "\n\n[src.info_stats]"
				for(var/c in src.category)
					if(cats == "") cats = "[c]"
					else cats = "[cats], [c]"
				bg.info_txt.maptext = "[css_outline]<font size = 1><text align=left valign=top>Level: [src.level]\n\nCategories: [cats]\n\n[src.info_buffs][stats]\n\n[src.info]"

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
		MouseMove(location,control,params)
			usr.info_box(src,"[src.name]",params)

		MouseWheel(delta_x,delta_y,location,control,params)
			var/obj/hud/menus/skills_background/s = usr.hud_skills
			var/obj/sc = s.skills_scroller

			usr.check_mouse_loc(params)
			var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
			usr.mouse_y_true = true_y
			var/wheel_move = 0
			if(delta_y > 0) wheel_move = 16
			else if(delta_y < 0) wheel_move = -16
			var/result = sc.translated_y+wheel_move
			result = clamp(result,0,-218)

			var/matrix/m = matrix()
			m.Translate(0,result)
			sc.transform = m
			sc.translated_y = result
			var/ratio = -1 + ((-218 + result) / -218)
			ratio = clamp(ratio,0,1)
			var/scroll_y = round(200*ratio)

			for(var/obj/txt in s.skills_holder.vis_contents)
				var/matrix/m2 = matrix()
				m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
				txt.transform = m2
		MouseEntered(object,location,control,params)
			usr.client.images += src.img_over
			//src.filters -= filter(type="outline",size=1,color = rgb(255,255,255))
			//src.filters += filter(type="outline",size=1,color = rgb(255,255,255))
			//if(src.img_select) usr.client.images += src.img_select

				//port.icon_state = src.icon_state
			usr.mouse_skill = src
			/*
			var/obj/s = usr.hud_skills
			s.txt.maptext = "<td valign = top><font size = 1>[css_outline]<b>[src.name]</b> - [src.help_text]</SPAN>"
			while(usr.mouse_skill == src)
				for(var/obj/bar in s)
					if(bar.icon == 'HUD_skill_exp.dmi') bar.icon_state = "[round(usr.mouse_skill.skill_exp,10)]"
					if(bar.name == "lvl") bar.maptext = "<font size = 1>[css_outline][src.skill_lvl]"
				sleep(1)
			*/
			if(usr.info_box1)
				var/L = usr.client.MeasureText("<font size = 1>[src.name]")
				var/x_pos = findtext(L, "x")
				L = text2num(copytext(L, 1, x_pos))
				src.box_x_scale = L + 6
				src.box_x_shift = 2 + round(src.box_x_scale/2)
				usr.client.screen += usr.info_box1
				usr.client.screen += usr.info_box2
				usr.client.screen += usr.info_box3
		MouseExited(location,control,params)
			usr.client.images -= src.img_over
			//src.filters -= filter(type="outline",size=1,color = rgb(255,255,255))
			//if(src.img_select) usr.client.images -= src.img_select
			usr.mouse_skill = null
			/*
			var/obj/s = usr.hud_skills
			s.txt.maptext = null
			for(var/obj/bar in s)
				if(bar.icon == 'HUD_skill_exp.dmi') bar.icon_state = "0"
				if(bar.name == "lvl") bar.maptext = "<font size = 1>0"
			*/
			if(usr.info_box1)
				usr.client.screen -= usr.info_box1
				usr.client.screen -= usr.info_box2
				usr.client.screen -= usr.info_box3
				usr.info_box3.maptext = null
		MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
			if(src.loc != null)
				var/icon/i = new(src.icon,src.icon_state)
				usr.client.mouse_pointer_icon = i
		MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
			if(src.loc != null)
				usr.client.mouse_pointer_icon = null

			var/obj/skills/skill = src
			var/dismiss = 0

			if(over_object && isobj(over_object))
				var/obj/h = over_object
				if(istype(h,/obj/hud/buttons/skillbar/) || istype(h,/obj/skills/))
					usr.add_to_skillbar(skill,h)
				else
					dismiss = 1
			else
				dismiss = 1

			if(dismiss)
				usr.check_skillbar(skill)

				// clear overlays
				for(var/obj/hud/buttons/skillbar/h in usr.hud_skillbar)
					h.overlays = null

		/*MouseDrop(over_object,src_location,over_location,src_control,over_control,params)
			if(src.loc != null)
				usr.client.mouse_pointer_icon = null
				//usr << output("Test drag and drop skill - [over_control],[over_object]", "chat.system")
				//if(findtext(over_control,"main"))
				var/obj/skills/skill = src
				var/dismiss = 0
				if(over_object && isobj(over_object))
					var/obj/h = over_object
					if(istype(h,/obj/hud/buttons/skillbar/) || istype(h,/obj/skills/)) usr.add_to_skillbar(skill,h)
					else dismiss = 1
				else dismiss = 1

				if(dismiss)
					if(src.type == /obj/skills/AA_Skill_Copy)
						for(var/obj/skills/s in usr)
							if(src.cloned == "[s.name] aa_clone_aa")
								skill = s
								break
					if(usr.one && length(usr.one) > 0 && usr.one[1] == skill)
						for(var/obj/hud/buttons/skillbar/skillbar_one/h in usr.hud_skillbar)
							h.overlays = null
						usr.one = null
						usr.client.screen -= skill
					if(usr.two && length(usr.two) > 0 && usr.two[1] == skill)
						for(var/obj/hud/buttons/skillbar/skillbar_two/h in usr.hud_skillbar)
							h.overlays = null
						usr.two = null
						usr.client.screen -= skill
					if(usr.three && length(usr.three) > 0 && usr.three[1] == skill)
						for(var/obj/hud/buttons/skillbar/skillbar_three/h in usr.hud_skillbar)
							h.overlays = null
						usr.three = null
						usr.client.screen -= skill
					if(usr.four && length(usr.four) > 0 && usr.four[1] == skill)
						for(var/obj/hud/buttons/skillbar/skillbar_four/h in usr.hud_skillbar)
							h.overlays = null
						usr.four = null
						usr.client.screen -= skill
					if(usr.five && length(usr.five) > 0 && usr.five[1] == skill)
						for(var/obj/hud/buttons/skillbar/skillbar_five/h in usr.hud_skillbar)
							h.overlays = null
						usr.five = null
						usr.client.screen -= skill
					if(usr.six && length(usr.six) > 0 && usr.six[1] == skill)
						for(var/obj/hud/buttons/skillbar/skillbar_six/h in usr.hud_skillbar)
							h.overlays = null
						usr.six = null
						usr.client.screen -= skill
					if(usr.seven && length(usr.seven) > 0 && usr.seven[1] == skill)
						for(var/obj/hud/buttons/skillbar/skillbar_seven/h in usr.hud_skillbar)
							h.overlays = null
						usr.seven = null
						usr.client.screen -= skill
					if(usr.eight && length(usr.eight) > 0 && usr.eight[1] == skill)
						for(var/obj/hud/buttons/skillbar/skillbar_eight/h in usr.hud_skillbar)
							h.overlays = null
						usr.eight = null
						usr.client.screen -= skill
					if(usr.nine && length(usr.nine) > 0 && usr.nine[1] == skill)
						for(var/obj/hud/buttons/skillbar/skillbar_nine/h in usr.hud_skillbar)
							h.overlays = null
						usr.nine = null
						usr.client.screen -= skill
					if(usr.zero && length(usr.zero) > 0 && usr.zero[1] == skill)
						for(var/obj/hud/buttons/skillbar/skillbar_zero/h in usr.hud_skillbar)
							h.overlays = null
						usr.zero = null
						usr.client.screen -= skill
						*/

		skill_overlay
			icon_state = "over"
		//Maybe make it display the skills dmg/buff calculations in the description of the skill.

		/*
		Wrestle system ideas

		Start by using grab on someone

		Make a skill that lets you lock body parts. Maybe not the head and possibly torso?

		Locking bodypart
		- Lock bodypart (Chooses a random one?)
		- Does a strength check to see if the opponent can resist
		- If successful, half usefullness from that part? Or at least disabled until let go? Think Freiza getting his hand grabed by ssj goku.

		Breaking/disabling bodypart
		- Second part of the wrestle skill, like in dwarf fortress
		- Does another strength check to see if the opponent can resist
		- If sucessful, completely disables that part.

		Maybe if really strong, or through a trait, have a third part.
		- Third part, limb is torn off.
		- Does another strength check to see if the opponent can resist
		- If sucessful, completely destroys that part.

		Once you finish doing the above once, player is automatically let go, for balance reasons?

		Destroyed bodyparts can only be replaced via special ways.
		*/



		AA_Skill_Copy
			Click()
				if(usr.skill_selected)
					var/obj/skills/s = usr.skill_selected
					if(s.img_select) usr.client.images -= s.img_select
				usr.skill_selected = src
				if(src.img_select) usr.client.images += src.img_select

				var/obj/hud/menus/skills_background/sk = usr.hud_skills
				sk.txt_raw.maptext = "[css_outline]<font size = 1><text align=left valign=top>[src.info]\n[src.info_stats]\n"
				var/icon/I = icon(src.icon,src.icon_state,SOUTH,1,0)
				I.Scale(64,64)
				sk.skills_portrait.icon = I
				var/matrix/m = matrix()
				m.Translate(317,204)
				sk.skills_portrait.hud_x = 317
				sk.skills_portrait.hud_y = 204
				sk.skills_portrait.transform = m

				usr.skill_exp()

				sk.skills_name.maptext = "[css_outline]<font size = 1><center>[src.name]"
				if(isnum(src.info_dmg)) sk.bar_power.icon_state = "[src.info_dmg]"
				if(isnum(src.info_spd)) sk.bar_speed.icon_state = "[src.info_spd]"
				if(isnum(src.info_energy_cost)) sk.bar_energy.icon_state = "[src.info_energy_cost]"
				if(isnum(src.info_mastery)) sk.bar_mastery.icon_state = "[src.info_mastery]"
				if(isnum(src.info_cd)) sk.bar_cooldown.icon_state = "[src.info_cd]"
		Embryonic_Breathing
			/*
			also known as Taixi or Fetal Breathing. A form of breathing without using one’s nose and mouth. Instead, the practitioner might breathe through their pores or
			dantian (for example). This is generally considered to be a highly-advanced Breathing Exercise which grants mystical benefits and brings the practitioner closer to nature.
			Often compared to how babies breathe in the womb (through the umbilical cord).
			*/

	/*	Cyborg
			icon_state = "Cyborg"
		//	info_energy_cost = 1
			info_mastery = 200
			info_point_cost = 1
			max_level = 200
			info_buffs = "Infuse a bodypart with dark matter energy"
			info_duration = "Channeled"
			info_name = "cyborg"
			//teach_energy = 1000
			hud_x = 68
			hud_y = 636
			passive_skill = 1
			info_point_cost_type = "technology"
			act = /obj/skills/Dark_Infusion/proc/activate
			info = "Using Dark Matter Energy and your skills at toning bodyparts, weave the fabric of the universe into your very physical essence. When using this ability, you can select a bodypart to saturate in Dark Matter Energy, permeating it with power and bringing you closer to ascension. In doing so, this ability will automatically grant 10 levels in the chosen bodypart and bring the Divine Body ascension requirement closer to completion."
			var/progress = 0;
			proc/activate(var/mob/m,var/amount)
				if(!ismob(m)) return // Prevent multiple activations
				active = 1
				var/buff_amount = (amount* 0.25) // The amount to add
				m.cyborg_skill += ((m.cyborg_skill*0.01)+buff_amount)
				m << "[src.skill_lvl] skill lvl - Cyborg Boost Applied: x[m.cyborg_skill]+([buff_amount])"
				if(!locate(/obj/skills/Cyberize) in m)
					var/obj/skills/Cyberize/s = new /obj/skills/Cyberize(m)
					s.skill_lvl = m.cyborg_skill
				if(!locate(/obj/items/tech/Cybertech/) in m)
					m.contents += list(/obj/items/tech/Cybertech/)


			New()
				..()
				category = list("Passive")
		Self_Borgification
			icon_state = "Self Borgification"
		//	info_energy_cost = 1
			info_mastery = 200
			info_point_cost = 1
			max_level = 200
			info_buffs = "Infuse a bodypart with dark matter energy"
			info_duration = "Channeled"
			info_name = "self_borgification"
			//teach_energy = 1000
			hud_x = 362
			hud_y = 636
			passive_skill = 1
			info_point_cost_type = "technology"
			act = /obj/skills/Dark_Infusion/proc/activate
			info = "Using Dark Matter Energy and your skills at toning bodyparts, weave the fabric of the universe into your very physical essence. When using this ability, you can select a bodypart to saturate in Dark Matter Energy, permeating it with power and bringing you closer to ascension. In doing so, this ability will automatically grant 10 levels in the chosen bodypart and bring the Divine Body ascension requirement closer to completion."
			var/progress = 0;
			proc/activate(var/mob/m,var/amount)
				if(!ismob(m)) return // Prevent multiple activations
				active = 1
				var/buff_amount = (amount* 0.25) // The amount to add
				m.selfborg_skill += ((m.selfborg_skill*0.01)+buff_amount)
				m << "[src.skill_lvl] skill lvl - Self Cyborg Boost Applied: x[m.selfborg_skill]+([buff_amount])"
				if(!locate(/obj/skills/Cyborg_Self) in m)
					var/obj/skills/Cyborg_Self/s = new /obj/skills/Cyborg_Self(m)
					s.skill_lvl = m.selfborg_skill
				if(!locate(/obj/items/tech/Cybertech/) in m)
					m.contents += list(/obj/items/tech/Cybertech/)


			New()
				..()
				category = list("Passive")

				*/
		Bare_Handed_Stances
			icon_state = "Bare Hand Stance"
		//	info_energy_cost = 1
			info_mastery = 200
			info_point_cost = 1
			max_level = 10000
			info_buffs = "MAX LEVEL: ∞"
			info_duration = "Channeled"
			info_name = "bare_handed_stances"
			//teach_energy = 1000
			hud_x = 20
			hud_y = 636
			stance_skill = 1
			info_point_cost_type = "combat"
			act = /obj/skills/Bare_Handed_Stances/proc/activate
			info = "Refine your unarmed combat through disciplined body conditioning. Channeling your power directly into your limbs enhances striking precision and impact force, allowing your bare-handed techniques to scale more efficiently in battle."
			var/progress = 0
			proc/activate(var/mob/m,var/amount)
				if(!ismob(m)) return // Prevent multiple activations
				if(!locate(/obj/skills/Stance) in m)
					var/obj/skills/Stance/cs = new
					cs.loc = m
				active = 1
				var/buff_amount = (amount* 0.25) // The amount to add
				//m.bare_handed_skill += ((m.bare_handed_skill*0.01)+buff_amount)
				m << "[src.skill_lvl] skill lvl - Bare handed stances Boost Applied: x[m.bare_handed_skill]+([buff_amount])"



			New()
				..()
				category = list("Passive")

		Weapon_Stance
			icon_state = "Weapon Stance"
		//	info_energy_cost = 1
			info_mastery = 200
			info_point_cost = 1
			max_level = 10000
			info_buffs = "MAX LEVEL: ∞"
			info_duration = "Channeled"
			info_name = "weapon stance"
			//teach_energy = 1000
			hud_x = 68
			hud_y = 636
			stance_skill = 1
			info_point_cost_type = "combat"
			act = /obj/skills/Weapon_Stance/proc/activate
			info = "Adopt a disciplined weapon stance that improves control and lethality. By synchronizing your energy flow with your weapon, each strike becomes more calculated, precise, and devastating."
			var/progress = 0;
			proc/activate(var/mob/m,var/amount)
				if(!ismob(m)) return // Prevent multiple activations
				active = 1

				//var/buff_amount = (amount* 0.2) // The amount to add
				m.weapon_stance += amount
				//m << "[src.skill_lvl] skill lvl - Efficient Boost Applied: x[m.efficiency_skill]+([buff_amount])"



			New()
				..()
				category = list("Passive")

		Androids
			icon_state = "Androids"
	//		info_energy_cost = 1
			info_mastery = 200
			info_point_cost = 1
			max_level = 200
			info_buffs = "MAX LEVEL: 200"
			info_duration = "Channeled"
			info_name = "androids"
			//teach_energy = 1000
			hud_x = 20
			hud_y = 636
			passive_skill = 1
			info_point_cost_type = "technology"
			act = /obj/skills/Androids/proc/activate
			info = "Master advanced synthetic engineering and energy-core manipulation. Increasing this skill enhances your ability to design, construct, and empower Android units, unlocking deeper technological potential."
			var/progress = 0;
			proc/activate(var/mob/m,var/amount)
				if(!ismob(m)) return // Prevent multiple activations
				if(m.AD>=100) return
				if(!locate(/obj/skills/Create_Android) in m)
					var/obj/skills/Create_Android/ca = new
					ca.loc = m
				active = 1
				var/buff_amount = (amount* 0.25) // The amount to add
				m.android_skill += ((m.android_skill*0.01)+buff_amount)
				m.AD += amount
			//	m << "[src.skill_lvl] skill lvl - Android Boost Applied: x[m.android_skill]+([buff_amount])"





			New()
				..()
				category = list("Passive")
		Study_Perk
			name = "Study Passive"
			icon_state = "Study Perk"
		//	info_energy_cost = 1
			info_mastery = 200
			info_point_cost = 1
			max_level = 10000
			info_buffs = "MAX LEVEL: ∞"
			info_duration = "Channeled"
			info_name = "efficient"
			//teach_energy = 1000
			hud_x = 166
			hud_y = 636
			passive_skill = 1
			info_point_cost_type = "technology"
			act = /obj/skills/Study_Perk/proc/activate
			info = "Sharpen your mind through disciplined study and focused thought. This passive greatly increases your intellectual growth, accelerating technological understanding and mental development."
			var/progress = 0;
			proc/activate(var/mob/m,var/amount)
				if(!ismob(m)) return // Prevent multiple activations
				active = 1
			//	var/buff_amount = (amount* 0.25) // The amount to add
				m.intxp += (10*amount)
				//m << "[src.skill_lvl] skill lvl - Study Boost Applied: x[m.intxp]+([buff_amount])"



			New()
				..()
				category = list("Passive")
		Efficient
			icon_state = "Efficient"
		//	info_energy_cost = 1
			info_mastery = 200
			info_point_cost = 1
			max_level = 10000
			info_buffs = "MAX LEVEL: ∞"
			info_duration = "Channeled"
			info_name = "efficient"
			//teach_energy = 1000
			hud_x = 117
			hud_y = 636
			passive_skill = 1
			info_point_cost_type = "technology"
			act = /obj/skills/Efficient/proc/activate
			info = "Through advanced fabrication efficiency and resource optimization, you reduce material waste during construction. This skill lowers the mineral costs required to create technology."
			var/progress = 0;
			proc/activate(var/mob/m,var/amount)
				if(!ismob(m)) return // Prevent multiple activations
				active = 1
				var/buff_amount = (amount*0.5) // The amount to add
				m.efficiency_skill += buff_amount
				m.EffS += amount
			//	m << "[src.skill_lvl] skill lvl - Efficient Boost Applied: x[m.efficiency_skill]+([buff_amount])"



			New()
				..()
				category = list("Passive")



		Regeneration_Bonus
			icon_state = "Regeneration"
	//		info_energy_cost = 1
			info_mastery = 200
			info_point_cost = 1
			max_level = 100
			info_buffs = "MAX LEVEL: 100"
			info_duration = "Channeled"
			info_name = "regeneration"
			//teach_energy = 1000
			hud_x = 313//362
			hud_y = 636
			passive_skill = 1
			info_point_cost_type = "physical"
			act = /obj/skills/Regeneration_Bonus/proc/activate
			info = "Strengthen your body's natural healing processes. By reinforcing cellular regeneration, you recover more health and more rapidly over time."
			var/progress = 0;
			proc/activate(var/mob/m,var/amount)
				if(!ismob(m)) return // Prevent multiple activations
				if(m.RG>=100) return
				active = 1
				var/buff_amount = (amount* 0.05) // The amount to add
				m.mod_regeneration += buff_amount
				m.RG += amount
		//		m << "[src.skill_lvl] skill lvl - Regeneration Boost Applied: x[m.mod_regeneration]+([buff_amount])"
			New()
				..()
				category = list("Passive")
		Recovery_Bonus
			icon_state = "Recovery"
	//		info_energy_cost = 1
			info_mastery = 200
			info_point_cost = 1
			max_level = 100
			info_buffs = "MAX LEVEL: 100"
			info_duration = "Channeled"
			info_name = "recovery"
			//teach_energy = 1000
			hud_x = 264//313
			hud_y = 636
			passive_skill = 1
			info_point_cost_type = "physical"
			act = /obj/skills/Recovery_Bonus/proc/activate
			info = "Enhance energy restoration. This passive improves how quickly your body recovers ki."
			var/progress = 0;
			proc/activate(var/mob/m,var/amount)
				if(!ismob(m)) return // Prevent multiple activations
				if(m.RC >= 100) return
				active = 1
				var/buff_amount = (amount* 0.05) // The amount to add
				m.mod_recovery += buff_amount
				m.RC += amount
		//		m << "[src.skill_lvl] skill lvl - Recovery Boost Applied: x[m.mod_recovery]+([buff_amount])"
			New()
				..()
				category = list("Passive")
		Energy_Master
			icon_state = "Energy Master"
	//		info_energy_cost = 1
			info_mastery = 200
			info_point_cost = 1
			max_level = 10000
			info_buffs = "MAX LEVEL: ∞"
			info_duration = "Channeled"
			info_name = "energy_master"
			//teach_energy = 1000
			hud_x = 215//264
			hud_y = 636
			passive_skill = 1
			info_point_cost_type = "physical"
			act = /obj/skills/Energy_Master/proc/activate
			info = "Expand and fortify your energy reserves. Through advanced internal control, you significantly increase your maximum ki capacity, allowing for greater sustained combat output."
			var/progress = 0;
			proc/activate(var/mob/m,var/amount)
				if(!ismob(m)) return // Prevent multiple activations
				active = 1
				var/buff_amount = (150 * amount)
				//m<<"Starting Buff amount: [buff_amount]" // The amount to add
				buff_amount += (m.energy_max*0.1)
				//m<<"Next Buff amount + Energy max: [buff_amount]"
				m.gains_trained_energy += buff_amount
		//		m << "[src.skill_lvl] skill lvl - Energy Master Boost Applied: [m.energy_max]+([buff_amount])"
			New()
				..()
				category = list("Passive")

		/*Energy_Control
			icon_state = "Energy Control"
	//		info_energy_cost = 1
			info_mastery = 200
			info_point_cost = 1
			max_level = 100
			info_buffs = "MAX LEVEL: 100"
			info_duration = "Channeled"
			info_name = "energy_control"
			//teach_energy = 1000
			hud_x = 280//264
			hud_y = 636
			passive_skill = 1
			info_point_cost_type = "physical"
			act = /obj/skills/Energy_Control/proc/activate
			info = "Enhance your ability to control and manipulate energy. This passive improves your precision and efficiency in using energy-based abilities."
			var/progress = 0;
			proc/activate(var/mob/m,var/amount)
				if(!ismob(m)) return // Prevent multiple activations
				if(m.EC >= 100) return
				active = 1
				var/buff_amount = (amount* 0.05) // The amount to add
				m.mod_energy_control += buff_amount
				m.EC += amount
		//		m << "[src.skill_lvl] skill lvl - Energy Control Boost Applied: x[m.mod_energy_control]+([buff_amount])"
			New()
				..()
				category = list("Passive")*/
		/*Energy_Manipulation
			icon_state = "Energy Manipulation"
	//		info_energy_cost = 1
			info_mastery = 200
			info_point_cost = 1
			max_level = 1000
			info_buffs = "Infuse a bodypart with dark matter energy"
			info_duration = "Channeled"
			info_name = "energy_manipulation"
			//teach_energy = 1000
			hud_x = 215
			hud_y = 636
			passive_skill = 1
			info_point_cost_type = "physical"
			act = /obj/skills/Energy_Manipulation/proc/activate
			info = "Using Dark Matter Energy and your skills at toning bodyparts, weave the fabric of the universe into your very physical essence. When using this ability, you can select a bodypart to saturate in Dark Matter Energy, permeating it with power and bringing you closer to ascension. In doing so, this ability will automatically grant 10 levels in the chosen bodypart and bring the Divine Body ascension requirement closer to completion."
			var/progress = 0;
			proc/activate(var/mob/m,var/amount)
				if(!ismob(m)) return // Prevent multiple activations
				active = 1
				//var/buff_amount = (amount* 0.25) // The amount to add
				//m.energy_max += (100*amount)+(m.energy_max*0.1)
			//	m.energy_manipulation +=  (amount*0.1)
		//		m << "[src.skill_lvl] skill lvl - Energy Manipulation Boost Applied: [m.energy_max]+([buff_amount])"
			New()
				..()
				category = list("Passive")*/

		Energy_Deflection
			icon_state = "Energy Deflection"
	//		info_energy_cost = 1
			info_mastery = 200
			info_point_cost = 1
			max_level = 100
			info_buffs = "MAX LEVEL: 100"
			info_duration = "Channeled"
			info_name = "energy_deflection"
			//teach_energy = 1000
			hud_x = 166
			hud_y = 636
			passive_skill = 1
			info_point_cost_type = "physical"
			act = /obj/skills/Energy_Deflection/proc/activate
			info = "Develop precise control over external energy forces. This skill improves your ability to redirect or mitigate incoming energy-based attacks."
			var/progress = 0;
			proc/activate(var/mob/m,var/amount)
				if(!ismob(m)) return // Prevent multiple activations
				if(m.ED >=100) return
				active = 1
				var/buff_amount = (amount* 0.5) // The amount to add
				m.Edeflection_skill += buff_amount
				m.Edeflection_skill = clamp(m.Edeflection_skill, 0.1, 75)
				m.ED += amount
		//		m << "[src.skill_lvl] skill lvl - Energy Deflection Boost Applied: [m.Edeflection_skill]+([buff_amount])"
			New()
				..()
				category = list("Passive")

		Deflection
			icon_state = "Deflection"
	//		info_energy_cost = 1
			info_mastery = 200
			info_point_cost = 1
			max_level = 100
			info_buffs = "MAX LEVEL: 100"
			info_duration = "Channeled"
			info_name = "deflection"
			//teach_energy = 1000
			hud_x = 117
			hud_y = 636
			passive_skill = 1
			info_point_cost_type = "physical"
			act = /obj/skills/Deflection/proc/activate
			info = "Train your defensive instincts and reactive timing. This passive improves your capability to deflect or avoid incoming physical attacks."
			var/progress = 0;
			proc/activate(var/mob/m,var/amount)
				if(!ismob(m)) return // Prevent multiple activations
				if(m.DS>=100) return
				active = 1
			//	var/buff_amount = (amount* 0.1) // The amount to add
				m.deflection_skill += (10*amount)
				m.DS += amount
		//		m << "[src.skill_lvl] skill lvl - Deflection Boost Applied: [m.deflection_skill]+([buff_amount])"
			New()
				..()
				category = list("Passive")

		Laceration
			icon_state = "Laceration"
	//		info_energy_cost = 1
			info_mastery = 200
			info_point_cost = 1
			max_level = 200
			info_buffs = "MAX LEVEL: 200"
			info_duration = "Channeled"
			info_name = "laceration"
			//teach_energy = 1000
			hud_x = 68
			hud_y = 636
			info_point_cost_type = "physical"
			act = /obj/skills/Laceration/proc/activate
			info = "Refine techniques that cause deep, lasting wounds. Your strikes become more likely to inflict bleeding damage, increasing sustained offensive pressure."
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			passive_skill = 1
			proc/activate(var/mob/m,var/amount)
				if(!ismob(m)) return // Prevent multiple activations
				if(m.LC>=100) return
				active = 1
				var/buff_amount = (amount* 0.50) // The amount to add
				m.laceration_skill += buff_amount
				m.LC += amount
				//m << "[src.skill_lvl] skill lvl - Laceration Boost Applied: [m.laceration_skill]+([buff_amount])"
			New()
				..()
				category = list("Passive")



		Bone_Breaker
			icon_state = "Bone Breaker"
	//		info_energy_cost = 1
			info_mastery = 200
			max_level = 200
			info_point_cost = 1
			info_buffs = "MAX LEVEL: 200"
			info_duration = "Channeled"
			info_name = "bone_breaker"
			//teach_energy = 1000
			hud_x = 20
			hud_y = 636
			info_point_cost_type = "physical"
			act = /obj/skills/Bone_Breaker/proc/activate
			info = "Channel overwhelming force into crushing physical blows. This passive enhances raw strength output, allowing your attacks to shatter defenses and break bones."
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/bonebreakingboost =0
			passive_skill = 1
			skill_lvl = 1
			var/original_strength
			proc/activate(var/mob/m,var/amount)
				if(!ismob(m)) return // Prevent multiple activations
				if(m.BB>=100) return

				original_strength = m.strength // Store original strength
				active = 1
				//var/buff_amount = (1*amount) // The amount to add
				//m.strength += (10*amount)+(m.strength*0.1)
				m.BB += amount
			//	m << "[src.skill_lvl] skill lvl - Strength Boost Applied: [m.strength]+([buff_amount])"
			New()
				..()
				category = list("Passive")

				/*spawn(10)
					if(src)
						var/t = 10
						while(src)
							var/mob/m = null
							if(ismob(src.loc))
								m = src.loc

								m.strength = m.strength+(1+src.skill_lvl*0)
								m<<"[src.skill_lvl] skill lvl - [m.strength+(1+src.skill_lvl*0.03)] BB Boost"
							sleep(t)
							*/
			/*Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(m.skill_dark_infusion == null) m.skill_dark_infusion = src
							call(src.act)(m,src)*/
		Create_Stance
			icon_state = "android off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 3
			info_name = "create stance"
			teach_energy = 1500
			info_buffs = "+50% of force into strength."
			info_duration = "Toggleable"
			info_point_cost_type = "force"
			act = /obj/skills/Create_Stance/proc/activate
			info = "By sending excess Energy throughout your body, you're able to increase your strength significantly. Using this ability expands your muscles, draining your Energy slowly, but increasing your strength by 20%."
			hud_x = 20
			hud_y = 636

			proc

				activate(var/mob/m,var/obj/skills/Create_Stance/s)
					//if(m.part_focus) m.part_focus.part_stats(m) //Update the reward for completing training on this body part.
					m.create_stance(s)
			New()
				..()
				category = list("Strength","Buff")
				//while(src)
				//	if(ismob(src.loc))
				//		var/mob/m = src.loc
					//	src.skill_lvl = m.android_skill
				//	sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"] || m.mouse_dir == "right")
						dir = "right"
					//if(params["right"])
					//	dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)

					if(dir == "right")
						if(src in m)
							call(src.act)(m,src)
		Create_Android
			icon_state = "android off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 3
			info_name = "create android"
			teach_energy = 1500
			info_buffs = "+50% of force into strength."
			info_duration = "Toggleable"
			info_point_cost_type = "force"
			act = /obj/skills/Create_Android/proc/activate
			info = "By sending excess Energy throughout your body, you're able to increase your strength significantly. Using this ability expands your muscles, draining your Energy slowly, but increasing your strength by 20%."
			hud_x = 20
			hud_y = 636

			proc

				activate(var/mob/m,var/obj/skills/Create_Android/s)
					//if(m.part_focus) m.part_focus.part_stats(m) //Update the reward for completing training on this body part.
					m.create_android(s)
			New()
				..()
				category = list("Strength","Force","Buff")
				//while(src)
				//	if(ismob(src.loc))
				//		var/mob/m = src.loc
					//	src.skill_lvl = m.android_skill
				//	sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"] || m.mouse_dir == "right")
						dir = "right"
					//if(params["right"])
					//	dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)

					if(dir == "right")
						if(src in m)
							call(src.act)(m,src)

		/*Cyborgification
			name = "Cyborgification"
			icon_state="selfborg off"
			var/tech_give = list(/obj/items/tech/Cybertech)
			info_mastery = 200
			info_point_cost = 1
			max_level = 200
			info_buffs = "MAX LEVEL: 200"
			info_duration = "Channeled"
			info_name = "cyborgification"
			//teach_energy = 1000
			hud_x = 68
			hud_y = 636
			info_point_cost_type = "technology"
			act = /obj/skills/Cyborgification/proc/activate
			info = "Infuse cybernetic systems into a target, enhancing physical capabilities through technological augmentation. This process fuses machinery with living tissue."
			var/progress = 0;
			passive_skill = 1
			skill_lvl = 1
			proc

				activate(var/mob/m,var/amount)
					if(!ismob(m)) return // Prevent multiple activations
					if(m.CYB>=100) return
					active = 1
					var/buff_amount = (amount* 0.50) // The amount to add
					m.cyborg_skill += buff_amount
					m.CYB += amount
					if(m.CYB >= 10 && !m.has_cyborgself)
						for(var/obj/items/tech/o in global.tech) //m.technology)
							for(var/x in src.tech_give)
								if(o.type == x)
									if(m.tech_unlocked.Find(o.type) == 0)
										//m.technology -= o
										//m.technology_researched += o
										m.tech_unlocked[o.list_pos] = o.type
										m.output_msg("[o] technology unlocked!")
										m.has_cyborgself = 1




			New()
				..()
				category = list("Passive")
				//tech_give = list(/obj/items/tech/Cybertech)
				//while(src)
				//	if(ismob(src.loc))
					//	var/mob/m = src.loc
					//	if(!locate(/obj/items/tech/Cybertech/) in m)
							//m.contents += src.tech_give
					//	src.skill_lvl = m.selfborg_skill
				//	sleep(10)
		Cyberize
			name = "Cyberize"
			icon_state="Cyberize off"
			var/tech_give = list(/obj/items/tech/Cybertech)
			info_mastery = 200
			info_point_cost = 1
			max_level = 200

			info_buffs = "MAX LEVEL: 200"
			info_duration = "Channeled"
			info_name = "cyberize"
			//teach_energy = 1000
			hud_x = 68
			hud_y = 636
			info_point_cost_type = "force"
			act = /obj/skills/Dark_Infusion/proc/activate
			info = "Infuse cybernetic systems into a target, enhancing physical capabilities through technological augmentation. This process fuses machinery with living tissue."
			var/progress = 0;



			New()
				..()
				category = list("Buff")
				tech_give = list(/obj/items/tech/Cybertech)
				*/

		Crane_Breathing
			//Make this increase divine energy recovery and gains. And make it so the lvl of the lungs help contribute toward energy recovery while in use.
			name = "Crane Breathing"
			icon_state = "Meditate off"
			info_energy_cost = 0
			info_mastery = 1
			info_point_cost = 1
			teach_energy = 1000
			info_buffs = "Rapid energy recovery"
			info_duration = "Toggleable"
			info_name = "crane_breathing"
			info_point_cost_type = "recovery"
			info = "Using very specific breathing techniques, you are able to regulate your own internal Energy and Power. In doing so, you recover your Divine Energy quicker than normal. The rate you regain your Divine Energy is based on the level of this skill, and the level of your lungs. Using this skill will enter you into a minigame, where you must press E at the correct time, otherwise you must begin again."
			act = /obj/skills/Crane_Breathing/proc/activate
			var/obj/bar = null
			var/obj/bar_inner = null
			var/obj/e_but = null
			var/fullness = 0
			var/up = 1
			var/showing_e = 0
			hud_x = 20
			hud_y = 636
			proc
				activate(var/mob/m,var/obj/skills/Crane_Breathing/s)
					if(s.active == 0)
						return
						if(m.skill_flight && m.skill_flight.active)
							call(m.skill_flight.act)(m,m.skill_flight)
						if(m.skill_levitation && m.skill_levitation.active)
							call(m.skill_levitation.act)(m,m.skill_levitation)
						if(m.submerged)
							m << output("<font color = teal>You can't to do this when unable to breathe.","chat.system")
							return
						for(var/obj/skills/Meditate/med in m)
							if(med.active == 0) call(med.act)(m,med)
						s.active = 1
						m.client.screen += s.bar
						m.client.screen += s.bar_inner
						m.client.screen += s.e_but
						m.stunned += 1
						m.stunned_pending += 1
						m.minigame = "breathing"
						s.icon_state = "Meditate"
					else
						s.active = 0
						if(m.client)
							m.client.screen -= s.bar_inner
							m.client.screen -= s.bar
							m.client.screen -= s.e_but
						s.bar_inner.screen_loc  = "17:-8,11:-6"
						s.fullness = 0
						m.stunned -= 1
						m.stunned_pending -= 1
						m.minigame = null
						var/matrix/M = matrix()
						M.Scale(1,1)
						s.bar_inner.transform = M
						s.icon_state = "Meditate off"
						if(m.client && m.started)
							m.energy_sources -= "Crane Breathing"
							m.divine_sources -= "Crane Breathing"
			New()
				..()
				e_but = new /:e_button
				bar = new /:breathing_bar
				bar_inner = new /:breathing_bar_inner
				bar_inner.color = rgb(200,0,0)
				category = list("Recovery","Buff")
				spawn(10)


					if(src.disable_sleep) return
					spawn(10)
					if(src)
						while(src)
							var/t = 10
							if(src.active)
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									if(src.fullness < 25)
										bar_inner.color = rgb(200,0,0)
									if(src.fullness >= 25)
										bar_inner.color = rgb(232,232,43)
									if(src.fullness >= 45)
										bar_inner.color = rgb(0,153,0)
									if(src.up)
										t = 0.5
										src.fullness += 1
										if(src.fullness >= 51)
											src.fullness = 51
											src.up = 0
									else
										t = 0.5
										src.fullness -= 1
										src.e_but.icon_state = "normal"
										if(src.fullness <= 0)
											src.fullness = 0
											src.up = 1
									if(m.client)
										//m.client.screen -= src.bar_inner
										//src.bar_inner.screen_loc  = "17:-8,10:[round(src.fullness/2)+1]"
										var/matrix/M = matrix()
										M.Scale(1,round(src.fullness))
										src.bar_inner.transform = M
										//m.client.screen += src.bar_inner
							sleep(t)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(m.skill_breathing == null) m.skill_breathing = src
							call(src.act)(m,src)
		Organogenesis
			icon_state = "Revivification off"
			info_energy_cost = 4
			info_mastery = 1
			info_point_cost = 3
			info_name = "organogenesis"
			teach_energy = 1500
			info_buffs = "+20% Strength"
			info_duration = "Toggleable"
			info_point_cost_type = "strength"
			act = /obj/skills/Organogenesis/proc/activate
			info = "Via the complex manipulation of psionic power and divine energy, mould, form and shape a new organ or bodypart into existence."
			/*
			Opens up a special menu that lets players fully design and create a new organ, muscle or bone. They decide where to place it, and put points into each stat.
			*/
			proc
				activate(var/mob/m,var/obj/s)
					if(m.part_focus) m.part_focus.part_stats(m) //Update the reward for completing training on this body part.
					var/needed = (10/m.mod_recovery) + (10/s.skill_lvl)
					if(s.active)
						s.active = 0
						s.icon_state = "Expand off"
						m.mod_strength/=1.2
						m.expand = 1
						//m.buffs -= "expand"
					else if(m.energy >= needed)
						//m.buffs += "expand"
						s.icon_state = "Expand"
						s.active = 1
						m.mod_strength*=1.2
						m.expand = 1.2
						m.shockwave()
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
			New()
				..()
				category = list("Strength","Endurance","Buff")
				spawn(10)


					if(src.disable_sleep) return
					spawn(10)
						while(src)
							if(ismob(src.loc))
								var/mob/m = src.loc
								if(src.active)
									var/removes = (10/m.mod_recovery) + (10/src.skill_lvl)
									if(m.energy >= removes)
										//m.energy-=((m.energy_max/10)/src.skill_lvl)/m.mod_recovery/m.mod_energy
										m.energy-=removes
										//world << "[removes] energy removed by [src]"
										//m << output("<font color = teal>[removes] energy removed by [src]","chat.system")
										src.skill_exp += (10-(src.skill_lvl/10))*m.mod_skill
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)
									else
										m.mouse_dir = "left"
										call(src.act)(m,src)
							//CHECK_TICK
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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


		Ki_Fist
			icon_state = "ki fist off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 3
			info_name = "ki fist"
			teach_energy = 1500
			info_buffs = "+50% of force into strength."
			info_duration = "Toggleable"
			info_point_cost_type = "force"
			act = /obj/skills/Ki_Fist/proc/activate
			act_create = /obj/skills/Ki_Fist/proc/create
			info = "By sending excess Energy throughout your body, you're able to increase your strength significantly. Using this ability expands your muscles, draining your Energy slowly, but increasing your strength by 20%."
			hud_x = 20
			hud_y = 636
			cd_max = 300
			var/tmp/hits = 0
			var/tmp/max_hits = 5
			var/kiicon
			var/kiicon2

			var/active_fist_index = 1  // Tracks currently selected custom blade
			var/cycle_custom_fist = /obj/skills/Ki_Fist/proc/cycle_custom_fist
			var/selected_custom_fist
			var/power_boost


			proc
				cycle_custom_fist(var/mob/m,obj/skills/Ki_Fist/s)
					if(s.customs.len == 0)
					//	m.create_chat_entry("alerts","You do not have any custom Ki Fist techniques.")
						m.set_alert("You do not have any made Ki Fist techniques.",s.icon,s.icon_state)
						return
					s.active_fist_index += 1
					if(s.active_fist_index > s.customs.len)
						s.active_fist_index = 1
					var/datum/ki_fist/next_fist = s.customs[s.active_fist_index]

					//m.create_chat_entry("alerts","You switched to a new Ki Fist syle.")
					m.set_alert("You switched to a new Ki Fist style",s.icon,s.icon_state)
					s.selected_custom_fist = next_fist
					//s.active=0
				create(var/mob/m,var/obj/skills/Ki_Fist/s)
					var/power
					var/name = input(m, "Name your Ki Fist technique.") as text
					if(m.rank>=4) power = input(m, "Choose a power percentage (1-400%).") as num
					else power = input(m, "Choose a power percentage (1-200%).") as num
					var/color = input(m, "Choose the color for your Ki Fist icon.") as color
					var/side = input(m, "Choose left or right fist for your Ki Fist.") in list ("Left","Right","Both")

					if(!name || !power || !color)
						//m.create_chat_entry("alerts", "You could not create the Ki Fist technique!")
						m.set_alert("You could not create the Ki Fist technique(Missing inputs)!",s.icon,s.icon_state)
						return  // If any input is missing, exit
					if(m.rank<4 && power >200)
						m.set_alert("You could not create the Ki Fist technique(Power too high)!",s.icon,s.icon_state)
						return
					var/datum/ki_fist/custom_fist = new
					custom_fist.name = name
					custom_fist.power = power / 100
					custom_fist.color = color
					custom_fist.side = side

					s.customs += custom_fist  // Add custom blade to the list
				//	m.create_chat_entry("alerts", "You have successfully created the [name] Ki Fist(s) technique!")
					m.set_alert("You have successfully created the [name] Ki Fist(s) technique!",s.icon,s.icon_state)

				activate(var/mob/m,var/obj/skills/Ki_Fist/s)
					//if(m.part_focus) m.part_focus.part_stats(m) //Update the reward for completing training on this body part.
					var/needed = (10/m.mod_recovery) + (10/s.skill_lvl)
					if(m.skill_ki_fist == null) m.skill_ki_fist = s
					if(s.active)
						s.active = 0

						s.icon_state = "ki fist off"
						//m.strength-=s.power_boost
						m.ki_fist = 0
						//m.ki_blade_display(0)
						//m.buffs -= "expand"
						m.overlays -= s.kiicon
						if(s.kiicon2) m.overlays -= s.kiicon2
					else
						if(s.customs.len > 0)
							if(s.active_fist_index < 1 || s.active_fist_index > s.customs.len)
								s.active_fist_index = 1
							var/datum/ki_fist/custom_fist = s.customs[s.active_fist_index] // Activate selected ki blade tech
							var/power_multiplier = custom_fist.power
							var/custom_color = custom_fist.color
							var/fistside = custom_fist.side
							s.power_boost = ((m.force*0.50)*(power_multiplier*0.10))
							if(m.energy >= needed)
								s.icon_state = "ki fist"
								s.active = 1
								//m.strength+= s.power_boost
								m.ki_fist = 1
								m.shockwave()
								if(fistside == "Left")
								//m.ki_blade_display(1)
									var/obj/effects/bluntenergy_fistL/fist = new
									fist.icon *= custom_color
									s.kiicon = fist
									m.overlays += s.kiicon

								if(fistside == "Right")
									var/obj/effects/bluntenergy_fistR/blade = new
									blade.icon *= custom_color
									s.kiicon = blade
									m.overlays -= s.kiicon
									m.overlays += s.kiicon
								if(fistside == "Both")
								//m.ki_blade_display(1)
									var/obj/effects/bluntenergy_fistL/fist = new
									var/obj/effects/bluntenergy_fistR/fist2 = new
									fist.icon *= custom_color
									fist2.icon *= custom_color
									s.kiicon = fist
									s.kiicon2 = fist2
									m.overlays += s.kiicon
									m.overlays += s.kiicon2
				//	if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
			New()
				..()
				category = list("Strength","Force","Buff")
				spawn(10)


					if(src.disable_sleep) return
					spawn(10)
						while(src)
							if(ismob(src.loc))
								var/mob/m = src.loc
								if(src.active)
									var/removes = (100/m.mod_recovery) + (10/src.skill_lvl)
									if(m.energy >= removes)
										//m.energy-=((m.energy_max/10)/src.skill_lvl)/m.mod_recovery/m.mod_energy
										m.energy-=removes
										//world << "[removes] energy removed by [src]"
										//m << output("<font color = teal>[removes] energy removed by [src]","chat.system")
										//world << "DEBUG - [(10-(src.skill_lvl/10))*m.mod_skill]"
										src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
										//world << "DEBUG - exp for expand = [(2.5-(src.skill_lvl/40)*m.mod_skill)+0.025]"
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)
									else
										m.mouse_dir = "left"
										call(src.act)(m,src)
							//CHECK_TICK
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"] || m.mouse_dir == "right")
						dir = "right"
					//if(params["right"])
					//	dir = "right"
					if(dir == "left")
						if(src in m)
							if(!src.selected_custom_fist)
								call(src.cycle_custom_fist)(m,src)
							else
								call(src.act)(m,src)

					if(dir == "right")
						if(src in m)
							if(src.customs.len <0)
								call(src.act_create)(m,src)
							else
								switch(input(m,"Change Ki fist or Create New?") in list ("Change","Create"))
									if("Change")
										call(src.cycle_custom_fist)(m,src)
									if("Create")
										call(src.act_create)(m,src)
		Ki_Blade
			icon_state = "ki blade off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 3
			info_name = "ki blade"
			teach_energy = 1500
			info_buffs = "+50% of force into strength."
			info_duration = "Toggleable"
			info_point_cost_type = "force"
			act = /obj/skills/Ki_Blade/proc/activate
			act_create = /obj/skills/Ki_Blade/proc/create
			info = "By sending excess Energy throughout your body, you're able to increase your strength significantly. Using this ability expands your muscles, draining your Energy slowly, but increasing your strength by 20%."
			hud_x = 20
			hud_y = 636
			cd_max = 300
			var/kiicon
			var/kiicon2
			var/tmp/hits = 0
			var/tmp/max_hits = 5

			var/active_blade_index = 1  // Tracks currently selected custom blade
			var/cycle_custom_blades = /obj/skills/Ki_Blade/proc/cycle_custom_blades
			var/selected_custom_blade
			var/power_boost


			proc
				cycle_custom_blades(var/mob/m,obj/skills/Ki_Blade/s)
					if(s.customs.len == 0)
					//	m.create_chat_entry("alerts","You do not have any custom Ki Blade techniques.")
						m.set_alert("You do not have any made Ki Blade techniques.",s.icon,s.icon_state)
						return
					s.active_blade_index += 1
					if(s.active_blade_index > s.customs.len)
						s.active_blade_index = 1
					var/datum/ki_blade/next_blade = s.customs[s.active_blade_index]

				//	m.create_chat_entry("alerts","You switched to a new Ki Blade syle.")
					m.set_alert("You switched to a new Ki Blade style",s.icon,s.icon_state)
					s.selected_custom_blade = next_blade
					//s.active=0
				create(var/mob/m,var/obj/skills/Ki_Blade/s)
					var/power
					var/name = input(m, "Name your Ki Blade technique.") as text
					if(m.rank>=4) power = input(m, "Choose a power percentage (1-400%).") as num
					else power = input(m, "Choose a power percentage (1-200%).") as num
					var/color = input(m, "Choose the color for your Ki Blade icon.") as color
					var/side = input(m, "Choose left or right fist for your Ki Blade.") in list ("Left","Right","Both")

					if(!name || !power || !color)

						m.set_alert("You could not create the Ki Blade technique(Missing inputs)!",s.icon,s.icon_state)
						return  // If any input is missing, exit
					if(m.rank<4 && power>200)
						m.set_alert("You could not create the Ki Blade technique(Power too high)!",s.icon,s.icon_state)
						return
					var/datum/ki_blade/custom_blade = new
					custom_blade.name = name
					custom_blade.power = power / 100
					custom_blade.color = color
					custom_blade.side = side

					s.customs += custom_blade  // Add custom blade to the list
				//	m.create_chat_entry("alerts", "You have successfully created the [name] Ki Blade technique!")
					m.set_alert("You have successfully created the [name] Ki Blade technique!",s.icon,s.icon_state)

				activate(var/mob/m,var/obj/skills/Ki_Blade/s)
					//if(m.part_focus) m.part_focus.part_stats(m) //Update the reward for completing training on this body part.
					var/needed = (10/m.mod_recovery) + (10/s.skill_lvl)
					if(m.skill_ki_blade == null) m.skill_ki_blade = s
					if(s.active)
						s.active = 0

						s.icon_state = "ki blade off"
						//m.strength-=s.power_boost
						m.ki_blade = 0
						//m.ki_blade_display(0)
						//m.buffs -= "expand"
						m.overlays -= s.kiicon
						if(s.kiicon2) m.overlays -= s.kiicon2
					else
						if(s.customs.len > 0)
							if(s.active_blade_index < 1 || s.active_blade_index > s.customs.len)
								s.active_blade_index = 1
							var/datum/ki_blade/custom_blade = s.customs[s.active_blade_index] // Activate selected ki blade tech
							var/power_multiplier = custom_blade.power
							var/custom_color = custom_blade.color
							var/fistside = custom_blade.side
							s.power_boost = ((m.force*0.50)*(power_multiplier*0.10))
							if(m.energy >= needed)
								s.icon_state = "ki blade"
								s.active = 1
								//m.strength+= s.power_boost
								m.ki_blade = 1
								m.shockwave()
								if(fistside == "Left")
								//m.ki_blade_display(1)
									var/obj/effects/sharpenergy_fistL/blade = new
									blade.icon *= custom_color
									s.kiicon = blade
									m.overlays += s.kiicon

								if(fistside == "Right")
									var/obj/effects/sharpenergy_fistR/blade = new
									blade.icon *= custom_color
									s.kiicon = blade
									m.overlays -= s.kiicon
									m.overlays += s.kiicon
								if(fistside == "Both")
								//m.ki_blade_display(1)
									var/obj/effects/sharpenergy_fistL/blade = new
									var/obj/effects/sharpenergy_fistR/blade2 = new
									blade.icon *= custom_color
									blade2.icon *= custom_color
									s.kiicon = blade
									s.kiicon2 = blade2
									m.overlays += s.kiicon
									m.overlays += s.kiicon2
				//	if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
			New()
				..()
				category = list("Strength","Force","Buff")
				spawn(10)


					if(src.disable_sleep) return
					spawn(10)
						while(src)
							if(ismob(src.loc))
								var/mob/m = src.loc
								if(src.active)
									var/removes = (100/m.mod_recovery) + (10/src.skill_lvl)
									if(m.energy >= removes)
										//m.energy-=((m.energy_max/10)/src.skill_lvl)/m.mod_recovery/m.mod_energy
										m.energy-=removes
										//world << "[removes] energy removed by [src]"
										//m << output("<font color = teal>[removes] energy removed by [src]","chat.system")
										//world << "DEBUG - [(10-(src.skill_lvl/10))*m.mod_skill]"
										src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
										//world << "DEBUG - exp for expand = [(2.5-(src.skill_lvl/40)*m.mod_skill)+0.025]"
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)
									else
										m.mouse_dir = "left"
										call(src.act)(m,src)
							//CHECK_TICK
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"] || m.mouse_dir == "right")
						dir = "right"
					//if(params["right"])
					//	dir = "right"
					if(dir == "left")
						if(src in m)
							if(!src.selected_custom_blade)
								call(src.cycle_custom_blades)(m,src)
							else
								call(src.act)(m,src)

					if(dir == "right")
						if(src in m)
							if(src.customs.len <0)
								call(src.act_create)(m,src)
							else
								switch(input(m,"Change Ki Blade or Create New?") in list ("Change","Create"))
									if("Change")
										call(src.cycle_custom_blades)(m,src)
									if("Create")
										call(src.act_create)(m,src)


		Expand
			icon_state = "Expand off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 3
			info_name = "expand"
			teach_energy = 1500
			info_buffs = "+20% Strength"
			info_duration = "Toggleable"
			info_point_cost_type = "strength"
			act = /obj/skills/Expand/proc/activate
			info = "By sending excess Energy throughout your body, you're able to increase your strength significantly. Using this ability expands your muscles, draining your Energy slowly, but increasing your strength by 20%."
			hud_x = 20
			hud_y = 636
			proc
				activate(var/mob/m,var/obj/s)
					if(m.part_focus) m.part_focus.part_stats(m) //Update the reward for completing training on this body part.
					var/needed = (10/m.mod_recovery) + (10/s.skill_lvl)
					if(s.active)
						s.active = 0
						s.icon_state = "Expand off"
						m.mod_strength/=1.2
						m.strength/=1.2
						m.expand = 1
						//m.buffs -= "expand"
					else if(m.energy >= needed)
						//m.buffs += "expand"
						s.icon_state = "Expand"
						s.active = 1
						m.mod_strength*=1.2
						m.strength*=1.2
						m.expand = 1.2
						m.shockwave()
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
			New()
				..()
				category = list("Strength","Endurance","Buff")
				spawn(10)


					if(src.disable_sleep) return
					spawn(10)
						while(src)
							if(ismob(src.loc))
								var/mob/m = src.loc
								if(src.active)
									var/removes = (10/m.mod_recovery) + (10/src.skill_lvl)
									if(m.energy >= removes)
										//m.energy-=((m.energy_max/10)/src.skill_lvl)/m.mod_recovery/m.mod_energy
										m.energy-=removes
										//world << "[removes] energy removed by [src]"
										//m << output("<font color = teal>[removes] energy removed by [src]","chat.system")
										//world << "DEBUG - [(10-(src.skill_lvl/10))*m.mod_skill]"
										src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
										//world << "DEBUG - exp for expand = [(2.5-(src.skill_lvl/40)*m.mod_skill)+0.025]"
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)
									else
										m.mouse_dir = "left"
										call(src.act)(m,src)
							//CHECK_TICK
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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


		Ressurect
			icon_state = "Revivification off"
			info_energy_cost = 4
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 3000
			info_name = "ressurect"
			info_buffs = "Revive soul"
			info_duration = "Channeled"
			info_point_cost_type = "regen"
			act = /obj/skills/Ressurect/proc/activate
			info = "Whilst already dead, but possessing a body, channel ambient Power and Divine Energy to reknit your deceased soul. The revivification process takes quite some time and needs at least 25 Divine Energy to complete."
			hud_x = 20
			hud_y = 588
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/tmp/mob/skill_target = null
			proc
				activate(var/mob/m,var/obj/skills/Ressurect/s)
					if(s in m)
						if(m.skill_revive == null) m.skill_revive = s
					if(s.active == 0)
						if(m.stance) //Switch off all stances
							m.disable_stances(null,1)
						if(m.grab) m.letgo()
					/*	if(round(m.divine_energy) < 25)
							m << output("<font color = teal>You need at least 25 Divine Energy to attempt the revivification process.","chat.system")
							m.set_alert("25 Divine Energy needed",s.icon,s.icon_state)
							m.create_chat_entry("alerts","You need at least 25 Divine Energy to attempt the revivification process.")
							return */
						if(m.energy < m.energy_max/1.05)
						//	m << output("<font color = teal>You need to be at max energy to attempt the revival process.","actionoutput"")
							m.set_alert("Need max energy",s.icon,s.icon_state)
							m<<"You need to be at max energy to attempt the revival process."
							return
						m.open_skills = 0
						m.open_menus.Remove(".open_skills")
						winshow(m,"skills",0)
						//m.left_click_function = "revive"
						//m.set_alert("Select target to revive",s.icon,s.icon_state)
						s.icon_state = "Revivification"
						var/mob/trg = m
						if(m.target) trg = m.target
						if(trg.client)

							m.left_click_function = null
							if(get_dist(m,trg) > 2)
								m.set_alert("Too far away",'alert.dmi',"alert")
								m.skill_revive.icon_state = "Revivification off"
								return
							//if(trg.has_body == 0)
							//	m << output("<font color = teal>They need to have a body to attempt the revivification process.","chat.system")
							//	m.set_alert("Need body",m.skill_revive.icon,m.skill_revive.icon_state)
							//	m.create_chat_entry("alerts","They need to have a body to attempt the revivification process.")
							//	m.skill_revive.icon_state = "Revivification off"
							//	return

							if(trg.dead == 0)
								m << output("<font color = teal>They are already alive.","actionoutput")
								m.set_alert("Already alive",m.skill_revive.icon,m.skill_revive.icon_state)
								m.skill_revive.icon_state = "Revivification off"
								return
							if(m.race == "Kai" && trg.race == "Kai" || m.kai_dna >= 10 && trg.kai_dna >=10)
								m << output("You cannot revive someone with Kai blood in them.","actionoutput")
								return
							if(m.race == "Demon" && trg.race == "Demon" || m.demon_dna >= 10 && trg.demon_dna >= 10)
								m << output("You cannot revive someone with Demon blood in them.","actionoutput")
								return
							if(trg.dead)
								for(var/obj/skills/Meditate/med in m)
									if(med.active) call(med.act)(m,med)
								m.skill_revive.active = 1
								m.skill_revive.skill_target = trg
								m.icon_state = "Meditate"
								m.stunned += 1
								m.stunned_pending += 1
								m.client.screen += m.skill_revive.bar
								if(trg != m) trg.client.screen += m.skill_revive.bar
								for(var/mob/MM in view(15,m))
									MM<<output("[MM.get_strangername(m)] begins to revive [MM.get_strangername(trg)]'s soul.","actionoutput")
							else

								m.set_alert("They are not dead.",'alert.dmi',"alert")

								m.skill_revive.icon_state = "Revivification off"
								return
						else
							s.icon_state = "Revivification off"
						//	m.set_alert("Only used on players",'alert.dmi',"alert")
						//	m.create_chat_entry("alerts","Only used on players.")
							return
					else
						s.active = 0
						m.stunned -= 1
						m.stunned_pending -= 1
						m.icon_state = ""
						m.client.screen -= s.bar_inner
						m.client.screen -= s.bar
						s.bar_inner.screen_loc = "16:-2,10:-3"
						s.progress = 0
						s.icon_state = "Revivification off"
						if(s.skill_target && s.skill_target.client)
							s.skill_target.client.screen -= s.bar_inner
							s.skill_target.client.screen -= s.bar
						s.skill_target = null
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:revive_bar_inner
				category = list("Regeneration","Utility")


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active)
								var/mob/m = null
								if(ismob(src.loc))
									if(src.skill_target)
										var/mob/tar = src.skill_target
										m = src.loc
										if(get_dist(m,tar) <= 2)
											if(tar.dead)
												if(m.energy >= src.skill_lvl+10)
													m.energy -= src.skill_lvl+10;
													src.progress += 1+round(src.skill_lvl/10)
													//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
													src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
													if(src.skill_exp >= 100 && src.skill_lvl < 100)
														src.skill_exp = 1
														src.skill_lvl += 1
														src.skill_up(m)

												if(m.client)
													m.client.screen -= src.bar_inner
													src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
													var/matrix/M = matrix()
													M.Scale(round(src.progress),1)
													src.bar_inner.transform = M
													m.client.screen += src.bar_inner
													if(tar.client && tar != m)
														tar.client.screen -= src.bar_inner
														src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
														var/matrix/M2 = matrix()
														M2.Scale(round(src.progress),1)
														src.bar_inner.transform = M2
														tar.client.screen += src.bar_inner

												var/obj/effects/orb/o = new
												o.loc = tar.loc
												o.step_x = tar.step_x
												o.step_y = tar.step_y
												o.pixel_x = rand(-64,64)
												o.pixel_y = rand(-64,64)
												animate(o,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
												spawn(10)
													if(o) qdel(o)

												if(m.koed || m.meditating)
													call(src.act)(m,src)
												if(src.progress >= 100)
													if(m.divine_energy>=prob(100))
														tar.Revive()

														m.icon_state = ""
														m.divine_energy -= 25
														if(m.race == "Demon")
															m.lifespan -= (m.lifespan*0.1)
															m<<output("You sacrificed [(m.lifespan*0.1)] worth of your lifespan to revive [tar]","actionoutput")
														else
															m.energy_max -= (m.energy_max *0.125)
															m<<output("You sacrificed [(m.energy_max *0.125)] worth of your ki to revive [tar]","actionoutput")
														m.set_alert("Revivification successful!",src.icon,src.icon_state)
														view(8,m) << output("<font color = purple> [m] finishes reknitting [tar]'s soul and fuses it back to their body.", "chat.local")
														if(src.active) call(src.act)(m,src)
													else
														m.icon_state = ""
														m.divine_energy -= 25
														if(m.race == "Demon")
															m.lifespan -= (m.lifespan*0.1)
															m<<output("You sacrificed [(m.lifespan*0.1)] worth of your lifespan to revive [tar]","actionoutput")
														else
															m.energy_max -= (m.energy_max *0.125)
															m<<output("You sacrificed [(m.energy_max *0.125)] worth of your ki to revive [tar]","actionoutput")
														m.set_alert("Revival failed!",src.icon,src.icon_state)
														if(prob(m.divine_energy)) m.KO()
														view(8,m) << output("<font color = purple> [m] finishes reknitting [tar]'s soul and fuses it back to their body.", "chat.local")
														if(src.active) call(src.act)(m,src)
										else if(src.active)
											m.set_alert("Revive target too far",'alert.dmi',"alert")
										//	m.create_chat_entry("alerts","Revive target too far.")
											if(src.skill_target && src.skill_target != m)
												src.skill_target.set_alert("Revive target too far",'alert.dmi',"alert")
											//	src.skill_target.create_chat_entry("alerts","Revive target too far.")
											call(src.act)(m,src)
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Restoration
			icon_state = "Revivification off"
			info_energy_cost = 4
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 3000
			info_name = "restoration"
			info_buffs = "Restore youth, vigour and vitality"
			info_duration = "Channeled"
			info_point_cost_type = "regen"
			act = /obj/skills/Restoration/proc/activate
			info = "Summon forth Divine Energy and confer a powerful restorative effect upon somebody. Bestowing an individual with this accumulation of energy will cast their body in the image of youth, allowing you to sculpt them to a time before the ravages of time."
			hud_x = 20
			hud_y = 492
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/tmp/mob/skill_target = null
			proc
				activate(var/mob/m,var/obj/skills/Restoration/s)
					if(s in m)
						if(m.skill_restoration == null) m.skill_restoration = s
					if(s.active == 0)
						if(m.stance) //Switch off all stances
							m.disable_stances(null,1)
						if(m.grab) m.letgo()
						if(m.energy < m.energy_max/1.05)
							m << output("<font color = teal>You need to be at max energy to attempt the restoration process.","chat.system")
							m.set_alert("Need max energy",'alert.dmi',"alert")
							//m.create_chat_entry("alerts","You need to be at max energy to attempt the restoration process.")
							return
						if(round(m.divine_energy) < 25)
							m << output("<font color = teal>You need at least 25 Divine Energy to attempt the restoration process.","chat.system")
							m.set_alert("25 Divine Energy needed",s.icon,s.icon_state)
						//	m.create_chat_entry("alerts","25 Divine Energy needed.")
							return
						m.open_skills = 0
						m.open_menus.Remove(".open_skills")
						winshow(m,"skills",0)
						//m.left_click_function = "restoration"
						//m.set_alert("Select target to restore",s.icon,s.icon_state)
						s.icon_state = "Revivification"

						var/mob/trg = m
						if(m.target) trg = m.target
						if(trg.client)
							m.left_click_function = null
							if(get_dist(m,trg) > 2)
								m << output("<font color = teal>They are too far away to interact with.","chat.system")
								m.set_alert("Too far away",'alert.dmi',"alert")
							//	m.create_chat_entry("alerts","They are too far away to interact with.")
								m.skill_reformation.icon_state = "Revivification off"
								return
							for(var/obj/skills/Meditate/med in m)
								if(med.active) call(med.act)(m,med)
							m.skill_restoration.active = 1
							m.skill_restoration.skill_target = trg
							m.icon_state = "Meditate"
							m.stunned += 1
							m.stunned_pending += 1
							animate(trg, color = list("#000", "#000", "#000", "#fff"),time = 20, loop = -1)
							animate(color = initial(trg.color),time = 20)
							m.client.screen += m.skill_restoration.bar
							if(trg != m) trg.client.screen += m.skill_restoration.bar
							view(8,m) << output("<font color = purple> [m] begins to restore [trg]'s youth.", "chat.local")
						else
							s.icon_state = "Revivification off"
							m.set_alert("Only used on players",'alert.dmi',"alert")
						//	m.create_chat_entry("alerts","Only used on players.")
							return
					else
						s.active = 0
						animate(m)
						m.stunned -= 1
						m.stunned_pending -= 1
						m.icon_state = ""
						m.client.screen -= s.bar_inner
						m.client.screen -= s.bar
						s.bar_inner.screen_loc = "16:-2,10:-3"
						s.progress = 0
						s.icon_state = "Revivification off"
						if(s.skill_target && s.skill_target.client)
							s.skill_target.client.screen -= s.bar_inner
							s.skill_target.client.screen -= s.bar
						s.skill_target = null
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:revive_bar_inner
				category = list("Regeneration","Utility")


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active)
								var/mob/m = null
								if(ismob(src.loc))
									if(src.skill_target)
										var/mob/tar = src.skill_target
										m = src.loc
										if(get_dist(m,tar) <= 2)
											if(m.energy >= src.skill_lvl+10)
												m.energy -= src.skill_lvl+10;
												src.progress += 1+round(src.skill_lvl/10)
												//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
												src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
												if(src.skill_exp >= 100 && src.skill_lvl < 100)
													src.skill_exp = 1
													src.skill_lvl += 1
													src.skill_up(m)

											if(m.client)
												m.client.screen -= src.bar_inner
												src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
												var/matrix/M = matrix()
												M.Scale(round(src.progress),1)
												src.bar_inner.transform = M
												m.client.screen += src.bar_inner
												if(tar.client && tar != m)
													tar.client.screen -= src.bar_inner
													src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
													var/matrix/M2 = matrix()
													M2.Scale(round(src.progress),1)
													src.bar_inner.transform = M2
													tar.client.screen += src.bar_inner

											if(m.koed || m.meditating)
												call(src.act)(m,src)
											if(src.progress >= 100)
												animate(tar,alpha = 255, time = 30)
												tar.icon_state = ""
												tar.screen_text.maptext = "<font size = 6><center>Youth restored"
												if(tar.lifespan <= tar.prime) tar.lifespan = tar.prime
												tar.age = tar.prime
												tar.vigour = 100
												m.divine_energy -= 25
												m.set_alert("Restoration successful!",src.icon,src.icon_state)
												//m.create_chat_entry("alerts","Restoration successful!")
												animate(tar.screen_text,alpha = 255,time = 60)
												animate(alpha = 0,time = 60)
												view(8,m) << output("<font color = purple> [m] finishes restoring [tar]'s youth.", "chat.local")
												if(src.active) call(src.act)(m,src)
										else if(src.active)
											m.set_alert("Restoration target too far",'alert.dmi',"alert")
										//	m.create_chat_entry("alerts","Restoration target too far.")
											if(src.skill_target && src.skill_target != m)
												src.skill_target.set_alert("Restoration target too far",'alert.dmi',"alert")
												//src.skill_target.create_chat_entry("alerts","Restoration target too far.")
											call(src.act)(m,src)
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Cleanse
			icon_state = "Cleanse off"
			info_energy_cost = 4
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 1000
			hud_x = 260
			hud_y = 636
			info_name = "divine_infusion"
			info_buffs = "Cleanse a bodypart of infusions"
			info_duration = "Channeled"
			info_point_cost_type = "energy"
			act = /obj/skills/Cleanse/proc/activate
			info = "This skill, despite its name, is not a gentle process. In order to remove divinity from a bodypart, great effort must be exerted upon that part. Ironically, Divine Energy is used to wash away and shed any traces of infusion upon the selected part, be it Dark Matter, Petrifaction, or even Divine Energy itself. Once the bodypart has been wreathed in the saturation of the divine, and the infusion of that part collected, the excess is disgarded violently, cast off like a band-aid, leaving the bodypart sundered."
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/obj/wave = null
			proc
				activate(var/mob/m,var/obj/skills/Cleanse/s)
					s.progress = 0
					if(s.active)
						if(m.stance) //Switch off all stances
							m.disable_stances(null,1)
						if(m.grab) m.letgo()
						s.icon_state = "Cleanse off"
						if(s.active == 2)
							m.stunned -= 1
							m.stunned_pending -= 1
						s.active = 0
						m.icon_state = ""
						if(m.client) m.client.screen -= s.bar_inner
						if(m.client) m.client.screen -= s.bar
						s.bar_inner.screen_loc = "16:-2,10:-3"
						s.progress = 0
						m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,255))
						if(s.wave)
							s.wave.loc = null
							animate(s.wave)
							s.wave = null
					else
						for(var/obj/skills/Dark_Infusion/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Incubation/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Dark_Petrifaction/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						if(m.has_body == 0)
							m << output("<font color = teal>You can only cleanse your body of divine power when you have a body.","chat.system")
							m.set_alert("Unable without body",s.icon,s.icon_state)
							//m.create_chat_entry("alerts","Unable without body.")
							return
						if(round(m.divine_energy) < 10)
							m << output("<font color = teal>You need at least 10 Divine Energy to wash away divine power from a bodypart.","chat.system")
							m.set_alert("10 Divine Energy needed",s.icon,s.icon_state)
						//	m.create_chat_entry("alerts","10 Divine Energy needed.")
							return
						s.icon_state = "Cleanse"
						s.active = 1
						winshow(m,"skills",0)
						m.open_skills = 0
						m.open_menus.Remove(".open_skills")
						if(m.open_body == 0)
							m.open_body = 1
							m.open_menus.Add(".open_body")
							if(m.hud_body) m.client.screen += m.hud_body
						m.set_alert("Select bodypart to cleanse",s.icon,s.icon_state)
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:divine_bar_inner
				category = list("Energy","Buff")


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active == 2)
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									src.progress += 2+round(src.skill_lvl/10)
									//src.skill_exp += (33/src.skill_lvl)*m.mod_skill
									src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

									if(m.client)
										m.client.screen -= src.bar_inner
										src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
										var/matrix/M = matrix()
										M.Scale(round(src.progress),1)
										src.bar_inner.transform = M
										m.client.screen += src.bar_inner
									if(round(m.divine_energy) < 10)
										call(src.act)(m,src)
										m << output("<font color = teal>You must have at least 10 divine energy to continue using Cleanse.","chat.system")
										m.set_alert("10 Divine Energy needed",src.icon,src.icon_state)
									//	m.create_chat_entry("alerts","10 Divine Energy needed.")
									/*
									if(m.cleansing && m.cleansing.disabled || m.cleansing.damaged)
										call(src.act)(m,src)
										m << output("<font color = teal>Can only cleanse heathly bodyparts.","chat.system")
										m.set_alert("Bodypart damaged during cleansing",src.icon,src.icon_state)
									*/

									var/obj/effects/orb_divine/o = new
									o.loc = m.loc
									o.step_x = m.step_x
									o.step_y = m.step_y
									o.pixel_x = 0//rand(-64,64)
									o.pixel_y = 0//rand(-64,64)
									o.alpha = 0
									animate(o,pixel_x = rand(-64,64), pixel_y = rand(-64,64), alpha = 255, time = 10)
									spawn(10)
										if(o) o.loc = null//del(o)

									if(m.koed || m.meditating)
										call(src.act)(m,src)
									if(src.progress >= 100)
										m.divine_energy -= 10
										animate(m,alpha = 255, time = 30)
										m.icon_state = ""
										m.screen_text.maptext = "<font size = 6><center>[m.cleansing] cleansed"
										m.cleansing.i_state = "[initial(m.cleansing.icon_state)]"
										m.cleansing.icon_state = m.cleansing.i_state
										m.cleansing.infused_divine = 0
										m.cleansing.infused_dark = 0
										m.cleansing.infused_petrified = 0
										m.cleansing.disabled_perma = 0
										if(m.cleansing.disabled == 0 && m.cleansing.damaged == 0) m.damage_limb(m,0,1,100,m.cleansing)
										m.cleansing = null
										animate(m.screen_text,alpha = 255,time = 60)
										animate(alpha = 0,time = 60)
										m.shockwave()
										if(m.dead)
											m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
											m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
										if(src.active) call(src.act)(m,src)
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(m.skill_cleanse == null) m.skill_cleanse = src
							call(src.act)(m,src)
		Reconstruction
			// Sets a bodypart to 0 hp, but gives a large boost to psiforging while healing it immedtately.
			icon_state = "Revivification off"
			info_energy_cost = 4
			info_mastery = 1
			info_point_cost = 3
			info_name = "reconstruction"
			info_buffs = "Reform a body"
			info_duration = "Channeled"
			teach_energy = 3000
			info_point_cost_type = "regen"
			act = /obj/skills/Reconstruction/proc/activate
			info = "Whilst already dead, channel ambient Power and Divine Energy to form a new body to inhabit. However, this will not revive you from the dead, since your soul would still be deceased. The reformation process takes quite some time and needs at least 25 Divine Energy to complete."
			proc
				activate(var/mob/m,var/obj/skills/Reformation/s)
		Reincarnation
			icon_state = "Reformation off"
			info_energy_cost = 4
			info_mastery = 1
			info_point_cost = 3
			info_name = "reincarnation"
			info_buffs = "Reform a new life"
			info_duration = "Channeled"
			teach_energy = 3000
			hud_x = 20
			hud_y = 636
			info_point_cost_type = "regen"
			act = /obj/skills/Reincarnation/proc/activate
			info = "Whilst already dead, channel ambient Power and Divine Energy to form a new body to inhabit.The reincarnation process takes quite some time and needs Divine Energy to complete."
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/tmp/mob/skill_target = null
			proc
				activate(var/mob/m,var/obj/skills/Reincarnation/s)
					if(s in m)
						if(m.skill_reformation == null) m.skill_reformation = s
					if(s.active == 0)
						if(m.stance) //Switch off all stances
							m.disable_stances(null,1)
						if(m.grab) m.letgo()
						if(m.energy < m.energy_max/1.05)
							m << output("<font color = teal>You need to be at max energy to attempt the reincarnation process.","chat.system")
							m.set_alert("Need max energy",'alert.dmi',"alert")
							//m.create_chat_entry("alerts","Need max energy.")
							return
						if(round(m.divine_energy) < 25)
							m << output("<font color = teal>You need at least 25 Divine Energy to attempt the reincarnation process.","chat.system")
							m.set_alert("25 Divine Energy needed",s.icon,s.icon_state)
							//m.create_chat_entry("alerts","25 Divine Energy needed.")
							return
						m.open_skills = 0
						m.open_menus.Remove(".open_skills")
						winshow(m,"skills",0)
						/*
						m.left_click_function = "reformation"
						m.set_alert("Select target to reform",s.icon,s.icon_state)
						*/
						s.icon_state = "Reformation"
						if(m.client)
							if(m.dead == 0)
								m.set_alert("Not dead!","alert.dmi", "alert")
							//	m.create_chat_entry("alert","Cannot reincarnate while alive!")
								m.skill_reformation = null
								src.destroy()
								return
							if(m.dead)
								for(var/obj/skills/Meditate/med in m)
									if(med.active) call(med.act)(m,med)
								m.skill_reformation.active = 1
								//m.skill_reformation.skill_target = trg
								m.icon_state = "Meditate"
								m.stunned += 1
								m.stunned_pending += 1
								m.client.screen += m.skill_reformation.bar
								//if(trg != m) trg.client.screen += m.skill_reformation.bar


						/*var/mob/trg = m

						if(m.target) trg = m.target
						if(trg.client)
							if(get_dist(m,trg) > 2)
								m << output("<font color = teal>They are too far away to interact with.","chat.system")
								m.set_alert("Too far away",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Too far away.")
								m.skill_reformation.icon_state = "Reformation off"
								return
							if(trg.dead == 0)
								m << output("<font color = teal>You have no need to reincarnate their body, since they already have one.","chat.system")
								m.set_alert("Already have body",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Already have body.")
								m.skill_reformation.icon_state = "Reformation off"
								return
							if(trg.dead && trg.z == 2)
								for(var/obj/skills/Meditate/med in m)
									if(med.active) call(med.act)(m,med)
								m.skill_reformation.active = 1
								m.skill_reformation.skill_target = trg
								m.icon_state = "Meditate"
								m.stunned += 1
								m.stunned_pending += 1
								m.client.screen += m.skill_reformation.bar
								if(trg != m) trg.client.screen += m.skill_reformation.bar
								view(8,m) << output("<font color = purple> [m] begins to reform a new body for [trg].", "chat.local")
							else
								m << output("<font color = teal>They need to be dead and in the Psionic Realm for you to attempt the reformation process.","chat.system")
								m.set_alert("Target must be dead and in Psi Realms",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Target must be dead and in Psi Realms.")
								m.skill_reformation.icon_state = "Reformation off"
								return */
					else
						s.active = 0
						m.stunned -= 1
						m.stunned_pending -= 1
						m.icon_state = ""
						m.client.screen -= s.bar_inner
						m.client.screen -= s.bar
						s.bar_inner.screen_loc = "16:-2,10:-3"
						s.progress = 0
						s.icon_state = "Reformation off"
						if(s.skill_target && s.skill_target.client)
							s.skill_target.client.screen -= s.bar_inner
							s.skill_target.client.screen -= s.bar
						s.skill_target = null
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:revive_bar_inner
				category = list("Regeneration","Utility")


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active)
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									if(m)
										if(m.energy >= src.skill_lvl+10)
											m.energy -= src.skill_lvl+10;
											src.progress += 1+round(src.skill_lvl/10)
											//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
											src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
											if(src.skill_exp >= 100 && src.skill_lvl < 100)
												src.skill_exp = 1
												src.skill_lvl += 1
												src.skill_up(m)

										if(m.client)
											m.client.screen -= src.bar_inner
											src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
											var/matrix/M = matrix()
											M.Scale(round(src.progress),1)
											src.bar_inner.transform = M
											m.client.screen += src.bar_inner


										var/obj/effects/orb/o = new
										o.loc = m.loc
										o.step_x = m.step_x
										o.step_y = m.step_y
										o.pixel_x = rand(-64,64)
										o.pixel_y = rand(-64,64)
										animate(o,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
										spawn(10)
											if(o) del(o)

										if(m.koed || m.meditating)
											call(src.act)(m,src)
										if(src.progress >= 100)
											if(m.dead == 1)

												//m.Body()
												m.divine_energy -= 25
												m.reincarnate()
												m.set_alert("Reincarnation successful!",src.icon,src.icon_state)
												//m.create_chat_entry("alerts","Reincarnation successful!")

												if(src.active) call(src.act)(m,src)
									/*else if(src.active)
										m.set_alert("Target too far",'alert.dmi',"alert")
										m.create_chat_entry("alerts","Reformation target too far.")
										if(src.skill_target && src.skill_target != m)
											src.skill_target.set_alert("Reformation target too far",'alert.dmi',"alert")
											src.skill_target.create_chat_entry("alerts","Reformation target too far.")
										call(src.act)(m,src)*/
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Toggle_Run
			icon_state = "run off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 1
			info_name = "toggle_run"
			info_buffs = "Pick your pace in running"
			info_duration = "Channeled"
			info_point_cost_type = "strength"
			act = /obj/skills/Toggle_Run/proc/activate
			info = "Toggling Run allows you to pick your pace increasing your movement speed."
			var/tmp/shov = null
			var/tmp/dig_mod = 1
			proc
				activate(var/mob/m, var/obj/skills/Toggle_Run/s)
					if (s in m)
						if (m.skill_run == null) m.skill_run = s
					if (s.active == 0)
						if (m.loc)
							s.active = 1
							s.icon_state = "run"
					else
						if(m.loc)
							s.active = 0
							s.icon_state = "run off"
			New()
				..()
				category = list("Excercise")

			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		/*Dig
			name = "Mine"
			icon_state = "Explosion off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 1
			info_name = "dig"
			info_buffs = "Dig for minerals"
			info_duration = "Channeled"
			info_point_cost_type = "strength"
			act = /obj/skills/Dig/proc/activate
			info = "Digging allows you to collect minerals from the ground. Resource veins are unique per tile and replenish over time."
			var/tmp/shov = null
			var/tmp/dig_mod = 1

			proc/activate(var/mob/m, var/obj/skills/Dig/s)
				s.shov = null
				s.dig_mod = 1
				if(m.skill_selftrain && m.skill_selftrain.active == 1 ) return
				if (m.meditating || m.selftraining || m.stunned) return

				if (s in m)
					if (m.skill_dig == null) m.skill_dig = s

				if (s.active == 0 && m.loc)
					var/turf/t = m.loc//get_step(m,SOUTH)
					var/findChance = 55
					var/obj/dirt_overlay = new
					dirt_overlay.icon = 'mining_dirt.dmi'

					if (t.liquid) // No digging in liquid
						m << output("<font color = teal>Can't do this in any sort of liquid.", "chat.system")
						m.set_alert("Need solid ground", 'alert.dmi', "alert")
						return

				// Lazy generation of vein
					if (!t.vein)
						var/planet_name = m.check_planet() // <-- Make sure you track player's planet
						if (!planet_name || !planet_resources[planet_name]) planet_name = "Earth"
						var/list/mineral_table = planet_resources[planet_name]
						var/mineral = pick(mineral_table)
						var/qty = mineral_table[mineral] + rand(5, 15)
						t.vein = new /datum/resource_vein(mineral, qty)


					if (t.liquid == null)
						var/obj/effects/craters/crater_small/c = new
						c.SetCenter(m)
						m.icon_state = "dig"
						var/list/dig_targets = list(t)
						for (var/obj/items/tech/digging/sh in m)
							if (sh.suffix)
								s.shov = sh
								if (sh.type == /obj/items/tech/digging/Shovel)
									m.overlays += /obj/effects/Shovel_Dig
									s.dig_mod = 4 + clamp((sh.level*0.005), 1,120)
								//	rand(round(2 + clamp((sh.level*0.00125), 1,5)),round(1 + clamp((sh.level*0.005), 1,15)))

									//s.dig_mod = 2 + s.tech_lvl
									findChance = (s.dig_mod + 40)

								else if(sh.type == /obj/items/tech/digging/Hand_Drill)
									m.overlays +=/obj/effects/HandDrill_Dig
									s.dig_mod = 4 + clamp((sh.level*0.005), 1,120)
								//	rand(round(4 + clamp((sh.level*0.00125), 1,5)),round(1 + clamp((sh.level*0.005), 1,15)))
									findChance = (s.dig_mod + 40)
									dig_targets += list(get_step(t, EAST), get_step(t, WEST))
								else if(sh.type == /obj/items/tech/digging/Super_Drill)
									dig_targets -= t
									t = get_step(m, SOUTH)
									dig_targets += t
									m.overlays +=/obj/effects/SuperDrill_Dig
									s.dig_mod = 6 + clamp((sh.level*0.005), 1, 200)
									//rand(round(8 + clamp((sh.level*0.00125), 1,5)),round(1 + clamp((sh.level*0.005), 1,15)))
									findChance = (s.dig_mod + 60)
									//dig_targets += list(get_step(t, EAST), get_step(t, WEST), get_step(t, NORTH), get_step(t, SOUTHWEST), get_step(t, NORTHWEST), get_step(t, SOUTHEAST), get_step(t, NORTHEAST))
									for (var/dx = -1 to 1)
										for (var/dy = -1 to 1)
											var/turf/target = locate(t.x + dx, t.y+1 + dy, t.z)
											if (target && target != t) dig_targets += target

								break

						if (m.stance)
							m.disable_stances(null, 1)
						if (m.grab) m.letgo()
						if (m.energy < 1)
							m.set_alert("Need more energy", 'alert.dmi', "alert")
							return
						m.stunned += 1
						m.stunned_pending += 1
						m.dir = SOUTH
						m.wings()
						if (m.digging_dust) m.vis_contents -= m.digging_dust
						var/turf/tt = locate(m.x, m.y - 1, m.z)
						if (tt.tmp_dmg < 0)
							m.digging_dust = new/obj/effects/digging_snow
						else if (istype(tt, /turf/lava_cooled) || istype(tt, /turf/lava_cooling))
							m.digging_dust = new/obj/effects/digging_ash
						else
							m.digging_dust = new/obj/effects/digging
						m.vis_contents += m.digging_dust
						s.active = 1
						s.icon_state = "Explosion"
						if (m.shadow) m.shadow.alpha = 0

						spawn(25)
							/*if (t.vein.quantity <= 0)
								m << "There is nothing to mine."
								m.set_alert("There is nothing to mine", 'alert.dmi', "fail")
								s.active = 0
								m.stunned -= 1
								m.stunned_pending -= 1
								m.icon_state = ""
								s.icon_state = "Explosion off"
								m.overlays -= list(/obj/effects/Shovel_Dig, /obj/effects/HandDrill_Dig, /obj/effects/SuperDrill_Dig)
								if (m.digging_dust) m.vis_contents -= m.digging_dust
								if (m.shadow && (!m.skill_invis || m.skill_invis.active == 0)) m.shadow.alpha = 255
								return*/

							for(var/turf/D in dig_targets)
								//dirt_overlay.SetCenter(m)
								D.overlays+=dirt_overlay
								//D.icon='mining_dirt.dmi'
								if(prob(!findChance))
									m << "<font color = white>You failed to find anything."
									//m.set_alert("You failed to find anything", 'alert.dmi', "fail")
								else
									if (!D.vein)
										var/planet_name = m.check_planet() // <-- Make sure you track player's planet
										if (!planet_name || !planet_resources[planet_name]) planet_name = "Earth"
										var/list/mineral_table = planet_resources[planet_name]
										var/mineral = pick(mineral_table)
										var/qty = mineral_table[mineral] + rand(5, 15)
										D.vein = new /datum/resource_vein(mineral, qty)
									if (D.vein.quantity <= 0 )
										m << "There is nothing to mine."
									else
										var/amount = round(s.dig_mod * rand(1,8),1)
										D.vein.quantity -= amount
										D.vein.replenish() // If depleted, start regen timer
										//m<<"[t.vein.mineral] - Vein, [t.vein]([t.vein.quantity]) Quant."
										var/mineral_path = mineral_paths[D.vein.mineral]
										if(mineral_path)
											var/obj/items/minerals/min = new mineral_path
											min.stacks = amount
											m.digging_mins(min, 1)
											m.refresh_inv()
											m << "<font color = white>You found x[amount] [min.name]."
										//	m.set_alert("You found x[amount] [min.name]", 'alert.dmi', "[min.name]")

										    // Attempt treasure chest spawn
										attempt_spawn_chest(m, D)
									//	m<<"11."
								/*for(var/turf/D in dig_targets)
									var/amount = round(s.dig_mod * rand(1,4),1)
									D.vein.quantity -= amount
									D.vein.replenish() // If depleted, start regen timer
									//m<<"[t.vein.mineral] - Vein, [t.vein]([t.vein.quantity]) Quant."
									var/mineral_path = mineral_paths[D.vein.mineral]
									if(mineral_path)
										var/obj/items/minerals/min = new mineral_path(m.loc)
										min.stacks = amount
										m.digging_mins(min, 1)
										m.refresh_inv()
										m.gain_stat("strength", 1, (m.mod_strength * 0.75), "Digging", 1)
										m << "<font color = white>You found x[amount] [min.name]."
										m.set_alert("You found x[amount] [min.name]", 'alert.dmi', "[min.name]")
										    // Attempt treasure chest spawn
										spawn() attempt_spawn_chest(m, t)*/

								/*var/obj/items/minerals/min = new /obj/items/minerals(m.loc)
								min.name = t.vein.mineral
								min.stacks = amount
								m.digging_mins(min, 1)
								m.refresh_inv()
								m.gain_stat("strength", 1, (m.mod_strength * 0.75), "Digging", 1)
								m << "<font color = white>You found x[amount] [min.name]."
								m.set_alert("You found x[amount] [min.name]", 'alert.dmi', "[min.name]")*/

							// Reset State
							m.refresh_inv()
							s.active = 0
							m.stunned -= 1
							m.stunned_pending -= 1
							m.icon_state = ""
							s.icon_state = "Explosion off"
							m.overlays -= list(/obj/effects/Shovel_Dig, /obj/effects/HandDrill_Dig, /obj/effects/SuperDrill_Dig)
							if (m.digging_dust) m.vis_contents -= m.digging_dust
							if (m.shadow && (!m.skill_invis || m.skill_invis.active == 0)) m.shadow.alpha = 255
					else
						m << output("<font color = teal>Can't do this in any sort of liquid.", "chat.system")
						m.set_alert("Need solid ground", 'alert.dmi', "alert")
						return
								//m.create_chat_entry("alerts", "Need solid ground.")

						//	m.create_chat_entry("alerts", "Need solid ground.")

			New()
				..()
				category = list("Strength", "Utility")

			Click(location, control, params)
				..()
				if (ismob(src.loc))
					var/mob/m = src.loc
					if (m.koed) return
					params = params2list(params)
					winset(m, "map.map", "focus=true")
					var/dir = null
					if (params["left"] || m.mouse_dir == "left")
						dir = "left"
					if (params["right"])
						dir = "right"
					if (dir == "left")
						if (src in m)
							call(src.act)(m, src)*/
		/*Dig
			icon_state = "Explosion off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 1
			info_name = "dig"
			info_buffs = "Dig for minerals"
			info_duration = "Channeled"
			info_point_cost_type = "strength"
			act = /obj/skills/Dig/proc/activate
			info = "Digging allows you to collect minerals from the ground. The amount you find is based off your level in digging, and the tool you're using, such as a shovel or drill. While rudimentary, this does allow you to gather some minerals starting out before moving onto heavier machinery. Digging also raises your Strength, but slowly drains your Energy."
			var/tmp/shov = null
			var/tmp/dig_mod = 1
			proc
				activate(var/mob/m, var/obj/skills/Dig/s)
					s.shov = null
					s.dig_mod = 1
					if(m.meditating || m.selftraining || m.stunned ) return
					if (s in m)
						if (m.skill_dig == null) m.skill_dig = s
					if (s.active == 0)
						if (m.loc)
							var/turf/x = m.loc
							var/findChance = 10
							if (x.liquid == null)
								var/obj/effects/craters/crater_small/c = new
								c.SetCenter(m)
								m.icon_state = "dig"
								if (m.race == "Alien")
									c.step_x -= 4
									s.dig_mod = 3
								else
									for (var/obj/items/tech/digging/sh in m)
										if (sh.suffix)
											s.shov = sh
											if (sh.type == /obj/items/tech/digging/Shovel)
												m.overlays += /obj/effects/Shovel_Dig
												s.dig_mod = 2 + s.tech_lvl
												findChance = (s.dig_mod * 10)
											else if(sh.type == /obj/items/tech/digging/Hand_Drill)
												m.overlays +=/obj/effects/HandDrill_Dig
												s.dig_mod = 3 + s.tech_lvl
												findChance = (s.dig_mod *10)
											else if(sh.type == /obj/items/tech/digging/Super_Drill)
												m.overlays +=/obj/effects/SuperDrill_Dig
												s.dig_mod = 5 + s.tech_lvl
												findChance = (s.dig_mod *10)
											else
												m.overlays += 'drill_dig.dmi'
												//m.icon_state = "drill"
												s.dig_mod = 1
												findChance = (s.dig_mod * 10)
											break
								if (m.stance)
									m.disable_stances(null, 1)
								if (m.grab) m.letgo()
								if (m.energy < 1)
									m.set_alert("Need more energy", 'alert.dmi', "alert")
									return
								m.stunned += 1
								m.stunned_pending += 1
								m.dir = SOUTH
								m.wings()
								if (m.digging_dust) m.vis_contents -= m.digging_dust
								var/turf/t = locate(m.x, m.y - 1, m.z)
								if (t.tmp_dmg < 0)
									m.digging_dust = new/obj/effects/digging_snow
								else if (istype(t, /turf/lava_cooled) || istype(t, /turf/lava_cooling))
									m.digging_dust = new/obj/effects/digging_ash
								else
									m.digging_dust = new/obj/effects/digging
								m.vis_contents += m.digging_dust
								s.active = 1
								s.icon_state = "Explosion"
								if (m.shadow) m.shadow.alpha = 0

								// Start the digging process with a delay
								spawn(25) // Approximately 4 seconds delay
									if(prob(findChance))
										//src<<"You failed to find anything."

										m <<"<font color = white>You failed to find anything."
										m.set_alert("You failed to find anything!",'alert.dmi',"fail")
									//	m.create_chat_entry("alerts","You failed to find anything.(Mining)")
										s.active = 0
										m.stunned -= 1
										m.stunned_pending -= 1
										m.icon_state = ""
										s.icon_state = "Explosion off"

										m.overlays -= 'spade_dig.dmi'
										m.overlays -= list(/obj/effects/Shovel_Dig,/obj/effects/HandDrill_Dig,/obj/effects/SuperDrill_Dig)
										m.overlays -= 'drill_dig.dmi'
										if (m.digging_dust) m.vis_contents -= m.digging_dust
										if (m.shadow && m.skill_invis == null || m.skill_invis && m.skill_invis.active == 0)
											m.shadow.alpha = 255
										m.gain_stat("strength", 1, (m.mod_strength*0.75), "Digging", 1)
										return
									else
										var/list/mineral_types = list()
										for (var/type in typesof(/obj/items/minerals))
											if (type != /obj/items/minerals) mineral_types += type
										var/random_mineral_type = pick(mineral_types)
										var/obj/items/minerals/random_mineral = new random_mineral_type
										var/mineral_stack = round(s.dig_mod * s.skill_lvl)
										random_mineral.stacks = mineral_stack
										m.digging_mins(random_mineral, 1)
										m.refresh_inv()
										m.gain_stat("strength", 1, (m.mod_strength*0.75), "Digging", 1)
										// Reset player state

										//src<<"You found x[round(A.Amount,1)] [B.Vein]"

										m <<"<font color = white>You found x[round(random_mineral.stacks,1)] [random_mineral]"
										m.set_alert("You found x[round(random_mineral.stacks,1)] [random_mineral.name]",'alert.dmi',"[random_mineral.name]")
										//m.create_chat_entry("alerts","You found x[round(random_mineral.stacks,1)] [random_mineral]")
										s.active = 0
										m.stunned -= 1
										m.stunned_pending -= 1
										m.icon_state = ""
										s.icon_state = "Explosion off"
										m.overlays -= list(/obj/effects/Shovel_Dig,/obj/effects/HandDrill_Dig,/obj/effects/SuperDrill_Dig)
										m.overlays -= 'drill_dig.dmi'
										if (m.digging_dust) m.vis_contents -= m.digging_dust
										if (m.shadow && m.skill_invis == null || m.skill_invis && m.skill_invis.active == 0)
											m.shadow.alpha = 255
							else
								m << output("<font color = teal>Can't do this in any sort of liquid.", "chat.system")
								m.set_alert("Need solid ground", 'alert.dmi', "alert")
								//m.create_chat_entry("alerts", "Need solid ground.")
						else
							m << output("<font color = teal>Need to be on the map to dig.", "chat.system")
							m.set_alert("Need solid ground", 'alert.dmi', "alert")
						//	m.create_chat_entry("alerts", "Need solid ground.")

			New()
				..()
				category = list("Strength","Utility")
				if(src.disable_sleep) return


			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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

*/
		/*Dig
			icon_state = "Explosion off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 1
			info_name = "dig"
			info_buffs = "Dig for minerals"
			info_duration = "Channeled"
			info_point_cost_type = "strength"
			act = /obj/skills/Dig/proc/activate
			info = "Digging allows you to collect minerals from the ground. The amount you find is based off your level in digging, and the tool you're using, such as a shovel or drill. While rudimentary, this does allow you to gather some minerals starting out before moving onto heavier machinery. Digging also raises your Strength, but slowly drains your Energy."
			var/tmp/shov = null
			var/tmp/dig_mod = 1
			proc
				activate(var/mob/m,var/obj/skills/Dig/s)
					s.shov = null
					s.dig_mod = 1
					if(s in m)
						if(m.skill_dig == null) m.skill_dig = s
					if(s.active == 0)
						if(m.loc)
							var/turf/x = m.loc
							if(x.liquid == null)
								var/obj/effects/craters/crater_small/c = new
								c.SetCenter(m)
								m.icon_state = "dig"
								if(m.race == "Cerebroid")
									c.step_x -= 4
									s.dig_mod = 3
								else
									for(var/obj/items/tech/digging/sh in m)
										if(sh.suffix)
											s.shov = sh
											if(sh.type == /obj/items/tech/digging/Shovel)
												m.overlays += 'spade_dig.dmi'
												s.dig_mod = 2
											else
												m.overlays += 'drill_dig.dmi'
												//m.icon_state = "blast"
												m.icon_state = "drill"
												s.dig_mod = 3
											break
								if(m.stance) //Switch off all stances
									m.disable_stances(null,1)
								if(m.grab) m.letgo()
								if(m.energy < 1)
									m << output("<font color = teal>You need more energy to dig.","chat.system")
									m.set_alert("Need more energy",'alert.dmi',"alert")
									m.create_chat_entry("alerts","Need more energy.")
									return
								m.stunned += 1
								m.stunned_pending += 1
								m.dir = SOUTH
								m.wings()
								//m.particles = new/particles/dust
								if(m.digging_dust) m.vis_contents -= m.digging_dust
								var/turf/t = locate(m.x,m.y-1,m.z)
								if(t.tmp_dmg < 0) m.digging_dust = new/obj/effects/digging_snow
								else if(istype(t,/turf/lava_cooled) || istype(t,/turf/lava_cooling)) m.digging_dust = new/obj/effects/digging_ash
								else m.digging_dust = new/obj/effects/digging
								m.vis_contents += m.digging_dust
								s.active = 1
								s.icon_state = "Explosion"
								if(m.shadow) m.shadow.alpha = 0
							else
								m << output("<font color = teal>Can't do this in any sort of liquid.","chat.system")
								m.set_alert("Need solid ground",'alert.dmi',"alert")
								m.create_chat_entry("alerts","Need solid ground.")
						else
							m << output("<font color = teal>Need to be on the map to dig.","chat.system")
							m.set_alert("Need solid ground",'alert.dmi',"alert")
							m.create_chat_entry("alerts","Need solid ground.")
						return
					else
						s.active = 0
						m.stunned -= 1
						m.stunned_pending -= 1
						//m.particles = null
						if(!m.client) m.icon_state = "Meditate"
						else m.icon_state = ""
						s.icon_state = "Explosion off"
						m.overlays -= 'spade_dig.dmi'
						m.overlays -= 'drill_dig.dmi'
						if(m.digging_dust) m.vis_contents -= m.digging_dust
						if(m.shadow && m.skill_invis == null || m.skill_invis && m.skill_invis.active == 0) m.shadow.alpha = 255
			New()
				..()
				category = list("Strength","Utility")


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							//var/T = 60
							if(src.active)
								//T = 10
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									if(m.energy >= 1)
										m.energy -= 1
										//src.skill_exp += (3/src.skill_lvl)*m.mod_skill
										//src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
										src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)

										if(m.koed || m.meditating || m.stunned > 1)
											call(src.act)(m,src)

										else
											var/list/mineral_types = list()
											for (var/type in typesof(/obj/items/minerals))
												if (type != /obj/items/minerals) // Exclude the base type
													mineral_types += type
											var/random_mineral_type = pick(mineral_types)// Randomly pick a mineral
											var/obj/items/minerals/random_mineral = new random_mineral_type

											var/mineral_stack = round(src.dig_mod*src.skill_lvl) // Calculate stack amount
											random_mineral.stacks = mineral_stack // Assign stacks to the mineral
											m.digging_mins(random_mineral,1) // Add mineral to inventory
											//m.resources += round(src.dig_mod*src.skill_lvl)
										//	m.rsc()
											m.gain_stat("strength",1,1,"Digging",1)
											var/X = rand(-96,96)
											var/Y = rand(-96,96)
											var/turf/t = locate(m.x,m.y-1,m.z)
											var/I = 'fx_dust_plume.dmi'
											if(t)
												if(t.tmp_dmg < 0) I = 'fx_dust_plume_snow.dmi'
												else if(istype(t,/turf/lava_cooled) || istype(t,/turf/lava_cooling)) I = 'fx_ash_plume.dmi'
											for(var/obj/d in dusts)
												if(d.loc == null)
													d.loc = t
													d.icon = I
													d.step_x = m.step_x-9
													d.step_y = m.step_y
													d.alpha = 200
													animate(d, pixel_y = Y,pixel_x = X,alpha = 0, time = 30)
													spawn(30)
														if(d)
															d.pixel_y = 0
															d.pixel_x = 0
															d.alpha = 255
															d.loc = null
															d.layer = 3
															d.icon = initial(d.icon)
													break
									else call(src.act)(m,src)
							sleep(60)
							src.active = 0
							m.stunned -= 1
							m.stunned_pending -= 1
							//m.particles = null
							if(!m.client) m.icon_state = "Meditate"
							else m.icon_state = ""
							src.icon_state = "Explosion off"
							m.overlays -= 'spade_dig.dmi'
							m.overlays -= 'drill_dig.dmi'
							if(m.digging_dust) m.vis_contents -= m.digging_dust
							if(m.shadow && m.skill_invis == null || m.skill_invis && m.skill_invis.active == 0) m.shadow.alpha = 255

			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
							*/
		Focus
			icon_state = "Focus off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 1500
			info_buffs = "+20% Force"
			info_duration = "Toggleable"
			info_point_cost_type = "force"
			info_name = "focus"
			act = /obj/skills/Focus/proc/activate
			info_stats = "+20% Force\n\nConstant energy drain\n\nToggleable"
			hud_x = 20
			hud_y = 636
			proc
				activate(var/mob/m,var/obj/s)

					var/needed = (10/m.mod_recovery) + (10/s.skill_lvl)
					if(s.active)
						//m.buffs -= "focus"
						s.active = 0
						if(m.client) m.force_sources -= "From Focus skill"

						//m.overlays -= 'focus_eyes.dmi'
						//m.overlays -= /obj/effects/eyes_focus
						s.icon_state = "Focus off"
						if(m.race == "Alien") m.overlays -= /obj/effects/elec_cerebroid
						else m.overlays -= /obj/effects/elec
						m.med_pixel = 1
						m.shock_chance = 0
						//m.mod_force/=1.2
						//m.multi_force -= 0.2
						m.vis_contents -= m.eyes_white
						m.vis_contents -= m.eyes
						if(m.eyes)
							m.eyes = m.eyes_copy
							var/proceed = 1
							if(m.skill_active_meditation && m.skill_active_meditation.active) proceed = 0
							if(proceed)
								m.vis_contents += m.eyes_white
								m.vis_contents += m.eyes
						//animate(m)
						var/turf/t = m.loc
						if(t && t.liquid == null) animate(m)
						//m.mods(list("Strength","Endurance","resistance","offence","defence","Regeneration","Agility","force"))
						//if(m.meditating)
							//animate(m,pixel_y = initial(m.pixel_y), time = 10)
					else if(m.energy >= needed)
						//m.buffs += "focus"
						s.active = 1
						s.icon_state = "Focus"
						var/turf/t = m.loc
						if(!t.liquid)
							var/obj/effects/dust_medium/d = new
							d.SetCenter(m)
						if(m.race == "Alien")
							m.overlays -= /obj/effects/elec_cerebroid
							m.overlays += /obj/effects/elec_cerebroid
						else
							m.overlays -= /obj/effects/elec
							m.overlays += /obj/effects/elec
						//for(var/mob/h in view(8,m))
							//h << sound('focus1.mp3',0,1,10,100)
						m.shock_chance = 10
						//m.mod_force*=1.2
						//m.multi_force += 0.2
						m.vis_contents -= m.eyes_white
						m.vis_contents -= m.eyes
						if(m.eyes)
							if(m.race == "Kai") m.eyes = global.eyes_focus_celestial
							else m.eyes = global.eyes_focus
							var/proceed = 1
							if(m.skill_active_meditation && m.skill_active_meditation.active) proceed = 0
							if(proceed)
								m.vis_contents += m.eyes_white
								m.vis_contents += m.eyes
						//hearers(8,m) << 'shockwave.wav'
						m.shockwave()
						if(m.meditating)
							var/pix_y = 0
							//if(m.race == "Alien") pix_y = -16
							animate(m,pixel_y = 10, time = 20,loop = -1,flags = ANIMATION_PARALLEL)
							animate(pixel_y = pix_y, time = 20)
						//hearers(8,m) << 'focus_activate.wav'
						//hearers(8,m) << 'electric.wav'
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
			New()
				..()
				category = list("Force","Agility","Buff")
				spawn(10)
					src.info = text_focus


					if(src.disable_sleep) return
					spawn(10)
						while(src)
							var/mob/m = null
							if(ismob(src.loc))
								m = src.loc
								if(src.active)
									var/removes = (10/m.mod_recovery) + (10/src.skill_lvl)
									if(m.energy >= removes)
										//m.energy-=5+((m.energy_max/5)/src.skill_lvl)/m.mod_recovery/m.mod_energy
										//var/removes = 1 + 10 - (m.mod_recovery+m.mod_energy) - (src.skill_lvl/10)
										m.energy -= removes
										//world << "[removes] energy removed by [src]"
										//m << output("<font color = teal>[removes] energy removed by [src]","chat.system")
										if(m.meditating)
											var/proceed = 1
											for(var/obj/items/tech/Bio_Rejuvination_Tank/t in range(2,m))
												if(bounds_dist(t, m) < 3)
													proceed = 0
											if(proceed)
												//animate(m,pixel_y = 2, time = 10)
												//animate(m,pixel_y = 10, time = 11)
												if(m.reflection) animate(m.reflection,pixel_y = 10, time = 11)
										//src.skill_exp += (5-(src.skill_lvl/20))*m.mod_skill
										m.gain_stat("force",1,1,"From Focus skill")
										//src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
										src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)
										if(m.energy < 1)
											m.mouse_dir = "left"
											call(src.act)(m,src)
									else
										m.mouse_dir = "left"
										call(src.act)(m,src)
							sleep(5)
							if(m) if(src.active) if(m.meditating)
								var/proceed = 1
								for(var/obj/items/tech/Bio_Rejuvination_Tank/t in range(2,m))
									if(bounds_dist(t, m) < 3)
										proceed = 0
								if(proceed)
									//animate(m,pixel_y = 0, time = 11)
									if(m.reflection) animate(m.reflection,pixel_y = 0, time = 11)
							sleep(5)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(m.skill_focus == null) m.skill_focus = src
							call(src.act)(m,src)

		Planetary_Genesis
			//Realms could also just be new planets the player creates, with more limited rules. But cost much less investment.
			icon_state = "Planetary Genesis off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 1500
			info_buffs = "+20% Force"
			info_duration = "Toggleable"
			info_point_cost_type = "force"
			info_name = "planetary genesis"
			act = /obj/skills/Planetary_Genesis/proc/activate
			info_stats = "+20% Force\n\nConstant energy drain\n\nToggleable"
			//hud_x = 20
			//hud_y = 636
			proc
				activate(var/mob/m,var/obj/s)
			New()
				..()
				category = list("Force","Agility","Buff")
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(m.skill_focus == null) m.skill_focus = src
							call(src.act)(m,src)
		Psi_Storm
			name = "Psi Storm"
			icon_state = "Psi Storm off"
			disabled_switch = 1;
			info_energy_cost = 4
			info_dmg = 3
			info_spd = 1
			info_mastery = 1
			info_point_cost = 3
			info_point_cost_type = "force"
			info_name = "psi_storm"
			info_prerequisite = list("Psi Lightning")
			info_stats = "Energy Cost: Very High\n\nDamage: High\n\nSpeed: Slow\n\nMastery: Very Slow\n\nToggleable"
			energy_skill = 1
			teach_energy = 1000
			cd_max = 6000
			hud_x = 68
			hud_y = 492
			New()
				..()
				category = list("Energy","Utility","Offence","Agility")
				spawn(10)
					src.info = text_super_speed


			Click(location,control,params)
				..()
				if(ismob(src.loc))
					return
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(m.loc)
								if(src.cd_state < 32)
									m << output("<font color = teal>Skill is on cooldown, please wait.","chat.system")
									src.icon_state = "cd"
									spawn(3)
										if(src) src.icon_state = "Psi Storm off"
									return
								if(m.skill_lightning_storm == null) m.skill_lightning_storm = src
								m.skill_cooldown(src)
								var/turf/t = m.loc
								m.cloud_circle()
								t.storm_psionic()
		Explosion
			icon_state = "Explosion off"
			disabled_ko = 0
			info_energy_cost = 2
			info_dmg = 2
			info_spd = 5
			info_mastery = 2
			info_point_cost = 3
			teach_energy = 1500
			info_point_cost_type = "force"
			info_name = "explosion"
			info_prerequisite = list("Telekinesis")
			info_stats = "Energy Cost: Medium\n\nDamage: Medium\n\nSpeed: Instant\n\nMastery: Medium\n\nToggleable"
			info = ""
			act = /obj/skills/Explosion/proc/activate
			energy_skill = 1
			disabled_switch = 1
			cd_max = 200
			hud_x = 164
			hud_y = 492
			proc
				activate(var/mob/m,var/obj/s)
					if(m.skill_explosion == null) m.skill_explosion = s
					if(s.active)
						s.active = 0
						s.icon_state = "Explosion off"
					else
						s.icon_state = "Explosion"
						s.active = 1
			New()
				..()
				category = list("Force","Offence")
				spawn(10)
					src.info = text_super_speed


			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Beam
			icon_state = "Beam off"
			disabled_ko = 1
			act = /obj/skills/Beam/proc/activate
			info_energy_cost = 4
			info_dmg = 3
			info_spd = 1
			info_mastery = 2
			info_point_cost = 5
			info_point_cost_type = "force"
			info_cd = 0
			info_name = "beam"
			info_prerequisite = list("Blast")
			info_stats = "Energy Cost: High\n\nDamage: High\n\nSpeed: Slow\n\nMastery: Medium\n\nToggleable\n\nChargeable"
			info = "Gather, condense and form psionic power into a deadly ball before unleashing the pent up force as a beam of energy. It does 50% of the users Force stat in damage to anything it hits every 0.1 seconds. You can charge this skill by holding the left mouse button. Releasing the button will fire the skill. Charge time is quicker the higher your Recovery stat is."
			energy_skill = 1
			teach_energy = 1000
			disabled_switch = 1
			attack_state = "beam"
			var/tmp/list/parts = list()
			hud_x = 212
			hud_y = 540
			act_create = /obj/skills/Beam/proc/create

			var/active_beam_index = 1  // Tracks currently selected custom blade
			var/cycle_custom_beam = /obj/skills/Beam/proc/cycle_custom_beams
			var/selected_custom_beam
			var/power_boost
			var/tmp/safe_cancel = FALSE
			var/tmp/last_gain_time = 0
			var/gain_cd = 25  // cooldown in ticks (2.5 seconds)
			proc
				cycle_custom_beams(var/mob/m,obj/skills/Beam/s)
					if(s.customs.len == 0)
						m<<output("You do not have any custom Beam techniques.","actionoutput")
						m.set_alert("You do not have any made Beam techniques.",s.icon,s.icon_state)
						return
					s.active_beam_index += 1
					if(s.active_beam_index > s.customs.len)
						s.active_beam_index = 1
					var/datum/custom_beam/next_beam = s.customs[s.active_beam_index]

					//m.create_chat_entry("alerts","You switched to a new Beam.")
					m.set_alert("You switched to a new Beam",s.icon,s.icon_state)
					s.selected_custom_beam = next_beam
					//s.active=0
				create(var/mob/m,var/obj/skills/Beam/s)
					var/power
					var/name = input(m, "Name your Beam technique.") as text
					if(m.rank>=4) power = input(m, "Choose a power percentage (1-400%).") as num
					else power = input(m, "Choose a power percentage (1-200%).") as num
					var/color = input(m, "Choose the color for your Beam icon.") as color
					var/side = input(m, "Choose left or right fist for your Beam.") in list ("Left","Right","Both")
					var/chantEnabled = input(m, "Will this involve a chant?") in list ("Yes","No")
					var/chant
					if(chantEnabled == "Yes")
						chant = input(m,"What will the chant be?") as text

					if(!name || !power || !color || !side)
						//m.create_chat_entry("alerts", "You could not create the Beam technique!")
						m.set_alert("You could not create the Beam technique(Missing inputs)!",s.icon,s.icon_state)
						return  // If any input is missing, exit
					if(m.rank<4 && power>200)
						m.set_alert("You could not create the Beam technique(Power too high)!",s.icon,s.icon_state)
						return  // If any input is missing, exit
					var/datum/custom_beam/custombeam = new
					custombeam.name = name
					custombeam.power = power / 100
					custombeam.color = color
					custombeam.side = side
					custombeam.chant = chant
					custombeam.chantEnabled = chantEnabled

					s.customs += custombeam  // Add custom blade to the list
					//m.create_chat_entry("alerts", "You have successfully created the [name] Beam technique!")
					m.set_alert("You have successfully created the [name] Beam technique!",s.icon,s.icon_state)
				activate(var/mob/m)
					if(src in m)
						if(m.active_attack) return
						if(m.koed || m.stunned || m.meditating || m.selftraining) return
						if(m.energy <= 10) return
						if(world.time < src.last_activate_time + 30)
							return
						src.last_activate_time = world.time
						if(m.skill_beam == null) m.skill_beam = src
						if(m.locked_mouse_degree) m.locked_mouse_degree = null

						var/power_multiplier
						var/custom_color
						var/fistside
						var/chant
						var/datum/custom_beam/custombeam
						var/beamname
						//Beam stages
						//How it looks when it starts
						//How it looks as it expands
						//How it looks when finished.
						if(src.customs.len > 0)
							if(src.active_beam_index < 1 || src.active_beam_index > src.customs.len)
								src.active_beam_index = 1
							custombeam  = src.customs[src.active_beam_index] // Activate selected ki blade tech
							power_multiplier = custombeam.power
							custom_color = custombeam.color
							fistside = custombeam.side
							chant = custombeam.chant
							beamname = custombeam.name

							src.power_boost = ((m.force*0.75)*(power_multiplier*0.10))
						else
							//m.create_chat_entry("alerts","You do not have any custom Beam techniques.")
							m.set_alert("You do not have any made Beam techniques.",src.icon,src.icon_state)
							return
						if(!src.last_gain_time || world.time >= src.last_gain_time + src.gain_cd)
							var/sound/SS = sound('Modules/core/sound/sound files/Xia SFX v0.1/basicbeam_chargeoriginal.wav')
							SS.channel = 1
							SS.volume = 30
							SS.repeat = 0


							if(fistside == "Left" || fistside == "Right") m.icon_state = "1HCharge"
							if(fistside == "Both") m.icon_state = "2HCharge"
							m.beaming = 1

							m.active_attack = src
							src.last_activate_time = world.time

							var/obj/chargeball = new
							chargeball.icon = 'beam_charge.dmi'
							chargeball.icon *= custom_color
							for(var/obj/body_related/ascension_milestones/a in m.ascensions)
								if(a.major_ascension && a.icon_state == "ascension" && a.level > 0)
									chargeball.icon_state = "divine"
									chargeball.plane = 2
									break
								else
									chargeball.icon_state = "psionic"
									chargeball.plane = 1
							if(chargeball.icon_state==null||chargeball.icon_state=="") chargeball.icon_state = "psionic"
							chargeball.pixel_x = -48
							chargeball.pixel_y = -48
							chargeball.transform*=0.1
							chargeball.bolted = 2
							chargeball.density_factor = -1

							var/obj/ball = new
							ball.icon = 'beam_head.dmi'
							ball.icon *= custom_color
							for(var/obj/body_related/ascension_milestones/a in m.ascensions)
								if(a.major_ascension && a.icon_state == "ascension" && a.level > 0)
									ball.icon_state = "divine"
									ball.plane = 2
									break
								else
									ball.icon_state = "psionic"
									ball.plane = 1
							if(ball.icon_state==null||ball.icon_state=="") ball.icon_state = "psionic"
							ball.pixel_x = -48
							ball.pixel_y = -48
							ball.transform*=0.1
							ball.bolted = 2
							ball.density_factor = -1

							//m.active_attack = src
							//m.icon_state = m.state()


							var/obj/ball_hit = new
							ball_hit.icon = 'beam_hit.dmi'
							ball_hit.icon *= custom_color
							for(var/obj/body_related/ascension_milestones/a in m.ascensions)
								if(a.major_ascension && a.icon_state == "ascension" && a.level > 0)
									ball_hit.icon_state = "divine"
									ball_hit.plane = 2
									break
								else
									ball_hit.icon_state = "psionic"
									ball_hit.plane = 1
							if(ball_hit.icon_state==null||ball_hit.icon_state=="") ball_hit.icon_state = "psionic"
							ball_hit.pixel_x = -48
							ball_hit.pixel_y = -48
							ball_hit.transform*=0.1
							ball_hit.density_factor = -1
							ball_hit.bolted = 2

							var/obj/beam = new
							beam.icon = 'beam_body_new.dmi'
							beam.icon *= custom_color
							for(var/obj/body_related/ascension_milestones/a in m.ascensions)
								if(a.major_ascension && a.icon_state == "ascension" && a.level > 0)
									beam.icon_state = "divine"
									beam.plane = 2
									break
								else
									beam.icon_state = "psionic"
									beam.plane = 1
							if(beam.icon_state==null||beam.icon_state=="") beam.icon_state="psionic"
							beam.pixel_y = -48
							beam.bolted = 2
							beam.density_factor = -1
							beam.transform*=0.1

							var/obj/ranged/checker/checker = new
							checker.origin = m
							checker.KB_furrow = 1
							//checker.density_factor = -1
							var/steps = 0

							//var/list/visited_x = list()
							//var/list/visited_y = list()

							var/obj/ray = new
							ray.loc = m.loc
							ray.bolted = 2
							ray.icon = 'fx_ray.dmi'
							ray.icon *= custom_color
							ray.pixel_x = -144
							ray.pixel_y = -144
							ray.filters += filter(type="rays",x=0,y=0,size=96,color=rgb(255,255,255),offset=0,density=10,threshold=0.7,factor=0,flags=FILTER_OVERLAY)
							animate(ray.filters[1],offset = 100,time = 1000, loop = -1)
							animate(offset = 0,time = 0)

							src.parts = list(chargeball,ball,ball_hit,beam,checker,ray)

							var/pix_max = 0.1;
							var/trans_max = 1;
							var/trans_extra = 0;
							var/pix = 0.1
							var/trans = 0.1

							//Controls beam sizes and pulsations
							var/size = 0.1
							var/size_upper = 0.1
							//var/size_dir = 0

							var/hov_dis = 16
							//var/hov_dis_extra = 0;

							//var/charging = 0; //If the attack is charging, increase its size and offset the assets correctly.
							var/fired = 0;
							var/stopping = 0;
							var/charge_check = 1;
							var/too_close = 0
							var/turf/t = null

							var/go = 1
							//m.beaming
							  // Store the direction to lock later


							switch(m.mouse_degree-180)
								if(0 to 44) m.dir = WEST
								if(45 to 135) m.dir = NORTH
								if(136 to 225) m.dir = EAST
								if(226 to 315) m.dir = SOUTH
								if(316 to 360) m.dir = WEST

							m.locked_mouse_degree = m.GetAngleStep(m.mouse_saved_loc)//m.mouse_degree
							view(12, m) << SS
							var/sound/S = sound('Modules/core/sound/sound files/Xia SFX v0.1/basicbeam_fire.wav')
							S.channel = 2 // Any number from 1-99
							S.volume = 50
							S.repeat = 0 // Make sure it's not loopin
							var/chanted=0
							if(chant)
								var/speaker_avatar = get_chatbox_render(m, m.client)
								for(var/mob/mm in view(25,m))
									mm<<output("<IMG CLASS=image SRC=\ref[speaker_avatar] STYLE='width:32px; height:32px;'><font color = [m.text_color_ic]>[m.real_name] says, '</font><font color = [custom_color]>[chant]'</font>","actionoutput")
								chanted=1

							while(go == 1)

								var/e = (5/m.mod_recovery)+(5/src.skill_lvl)*power_multiplier
								if(e<0) e = 1
								//While this skill is active, give some exp.
								src.skill_exp += ((0.1-(src.skill_lvl/100))*m.mod_skill)+0.1

								if(src.skill_exp >= 100 && src.skill_lvl < 100)
									src.skill_exp = 1
									src.skill_lvl += 1
									src.skill_up(m)
								//Once we reach 0 size, the attack is finished and considered ended.
								if(size <= 0)
									size = 0;
									if(ray) ray.loc = null
									qdel(beam)
									qdel(ball)
									qdel(ball_hit)
									checker.origin = null
									checker.loc = null
									//del(checker)
									m.icon_state = m.state()
									m.beaming = 0
									return

								//If the player doesn't have enough energy while firing or charging, or they become stunned, ect, then force the ball and beams to shrink and vanish.
								if(m.energy <= e) m.active_attack = null
								if(m.koed || m.stunned || m.meditating) m.active_attack = null
								if(!ball)
									m.active_attack = null
									go = 0;
									m.beaming=1
									return;

								//Otherwise continue
								else
									//m.dir = get_dir(m,m.mouse_saved_loc)
									/*switch(m.mouse_degree-180)
										if(0 to 44) m.dir = WEST
										if(45 to 135) m.dir = NORTH
										if(136 to 225) m.dir = EAST
										if(226 to 315) m.dir = SOUTH
										if(316 to 360) m.dir = WEST*/
									m.wings()

									//Check if the attack is active. If its not, it means player canceled the attack or something else happened.
									if(m.active_attack == null)
										if(stopping == 0)
											stopping = 1
											for(var/mob/h in view(8,m))
												if(!h.npc && h.client)
													h << sound(null, channel=3)

									var/move_x = 16 * cos(m.locked_mouse_degree)
									var/move_y = 16 * sin(m.locked_mouse_degree)

									//world << "Beam charge size removes [removes_charging]"

									chargeball.Move(m.loc, 0, m.step_x + move_x, m.step_y - move_y)
									if(ray && ray.loc)
										ray.loc = chargeball.loc
										ray.step_x = chargeball.step_x
										ray.step_y = chargeball.step_y

									//If the beam is canceled for any reason, force the ball and ball_hit to shrink and make the size reduce for the beam and balls.
									if(stopping >= 1)
										hov_dis -= 0.075
										size = 0
										//size -= size_upper/20
										trans_extra -= 0.034 //240/88 = 2.727. Then divided by 8, which is the steps. Equals 0.34

										if(hov_dis <= 16) hov_dis = 16

										var/matrix/B_C = matrix()
										B_C.Scale(size,size)
										chargeball.transform = B_C

										var/matrix/B = matrix()
										B.Scale(size,size)
										ball.transform = B

										var/matrix/B_H = matrix()
										B_H.Scale(size,size)
										ball_hit.transform = B_H
										view(12,m) << sound(null, channel = 1)
										//m<<"Stopped Beam. (Hov_Dis:[hov_dis] - Size[size] - Trans_exta[trans_extra] "
										for(var/obj/O in src.parts) O.qdel_obj_safe(O)
										src.parts.Cut(1,0)
										m.icon_state = m.state()
										m.beaming = 0
										m.active_attack = null
										view(12,m) << sound(null, channel = 1)
										break
										return

									//If the attack is on-going and the player has their mouse held down, charge the attack and make it bigger.
									else if(m.mouse_down)
										//if(size == 0.1)
											//for(var/mob/h in view(8,m))
												//h << sound('activate.mp3',1,0,3,100)
										var/matrix/B_C = matrix()
										B_C.Scale(size,size)
										chargeball.transform = B_C

										var/matrix/B = matrix()
										B.Scale(size,size)
										ball.transform = B

										var/matrix/B_H = matrix()
										B_H.Scale(size,size)
										ball_hit.transform = B_H

										hov_dis += 0.075*m.mod_recovery
										size += 0.001*m.mod_recovery
										//Increase the charge lvl of the attack, and its dmg, then check if the rounded charge lvl of the attack is higher than when we looked last. Only looking for whole increases.
										checker.charge_lvl += 0.01*m.mod_recovery
										checker.ki_force = (m.force/100)*(power_multiplier*0.1)*checker.charge_lvl
										checker.force_usage = m.mod_force_usage
										checker.ki_power = m.psionic_power
										if(checker.charge_lvl>= (25/m.mod_recovery)+(25/src.skill_lvl)*power_multiplier)
											checker.charge_lvl = (25/m.mod_recovery)+(25/src.skill_lvl)*power_multiplier
										var/charge_rounded = round(checker.charge_lvl)
										if(charge_rounded > charge_check)
											charge_check = charge_rounded
											//m.charge_nums("<font color = green>x[charge_check]")

											//world << "Beam charge lvl is [checker.charge_lvl] and rounded it is [round(checker.charge_lvl)]"
										m.energy -= e*checker.charge_lvl
										size_upper += 0.001*m.mod_recovery
										if(size >= 1) size = 1;
										//issue is trans_extra
										//if(size > 0.2) m.mouse_down = null
										if(size < 1) trans_extra += 0.034*m.mod_recovery //240/88 = 2.727. Then divided by 8, which is the steps. Equals 0.34

										if(hov_dis >= 80) hov_dis = 80 //Max 80 seems good

										//Create cool gathering energy effect around the main charging orb.
										if(prob(10))
											if(chargeball && isturf(chargeball.loc))
												var/obj/orb = null
												if(chargeball.icon_state == "psionic") orb = new /obj/effects/orb
												else if(chargeball.icon_state == "divine") orb = new /obj/effects/orb_divine
												orb.icon *= custom_color
												orb.loc = chargeball.loc
												orb.step_x = chargeball.step_x
												orb.step_y = chargeball.step_y
												orb.pixel_x = rand(-64,64)
												orb.pixel_y = rand(-64,64)
												animate(orb,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
												spawn(10)
													if(orb) orb.loc = null//del(o)
									//If the beam isn't canceled and the mouse isn't held, then fire the attack.
									else if(fired <= 0)
										//for(var/mob/h in view(8,m))
											//h << sound('beam1.mp3',1,0,3,100)
										if(fistside == "Left")
											m.icon_state = "1HBlastL"
										if(fistside == "Right")
											m.icon_state = "1HBlastR"
										if(fistside == "Both")
											m.icon_state= "2HBlast"
										m.beaming = 1
									//	m.can_move =0
										if(chant && chanted==1 || !chant)
											view(12,m) << sound(null, channel = 1)
											var/speaker_avatar = get_chatbox_render(m, m.client)
											for(var/mob/mx in view(25,m))
												mx<<output("<BIG><IMG CLASS=image SRC=\ref[speaker_avatar] STYLE='width:32px; height:32px;' ICONSTATE='' ICONDIR=SOUTH ICONFRAME=2></BIG><font color = [m.text_color_ic]><b>[m.real_name] shouts, '</font><b><font color = [custom_color]>[beamname]!'</b></font>","actionoutput")
											chanted=0
										view(12,m)<<S
										fired = 1
										if(ray && ray.loc) ray.loc = null
										var/obj/effects/hit/h = new
										h.loc = m.loc
										h.dir = m.dir
										if(m.dir == SOUTH ||m.dir == NORTH) h.pixel_x += 16
										h.step_x = m.step_x
										h.step_y = m.step_y
										spawn(10)
											if(h) h.destroy()

									//This is still executed, even if the player stops or starts charging again.
									if(fired >= 1)
										pix_max = 0.1;
										trans_max = 1-trans_extra
										//if(trans_max >= 240) trans_max = 1
										//else trans_max = 1-trans_extra;
										t = get_step(m,m.dir)
										too_close = 0
										if(t && t.density || t.density_factor == 2)
											checker.loc = null
											too_close = 1
										else
											//The checker's position is reset every loop, ready to travel out and plot a course.
											checker.loc = m.loc
											checker.step_x = m.step_x
											checker.step_y = m.step_y

										m.energy -= e*checker.charge_lvl
										//world << "Beam firing removes [removes]"

										//Sends an obj out to seek obstacles. Tracks how long the beam will be.
										while(checker.loc)
											pix_max += 21/88 //This is derived from 20*24, which is 480, +5% for adjustments
											if(pix_max >= 15) pix_max = 15
											trans_max += 336/88 //This is derived from 480/1.5, then + 5% for adjustments.
											//if(trans_max >= 245) trans_max = 245; //Half of the beam length in pixels
											if(trans_max >= 240) trans_max = 240; //Half of the beam length in pixels - This is the og setting
											steps += 8
											var/m_x = steps * cos(m.locked_mouse_degree)
											var/m_y = steps * sin(m.locked_mouse_degree)
											checker.Move(m.loc, 0, m.step_x + m_x, m.step_y - m_y)
											if(prob(1)) checker.dust_and_furrows(pick(1,2,3,4,5,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0),1)
													/*
											if(visited_x.Find(checker.step_x) == 0 && visited_y.Find(checker.step_y) == 0)
												checker.dust_and_furrows(0)
												visited_x += checker.step_x
												visited_y += checker.step_y
											*/
											if(steps >= 705) checker.loc = null //88 steps to reach 704, 8*88 = 704+1

										//Make sure we're not too close to a solid turf.
										if(too_close == 0)
											//Once we know how far and long the beam can travel, cap it off with an end graphically
											//var/b_x = ((pix*32)+(trans_max/10)) * cos(m.mouse_degree)
											//var/b_y = ((pix*32)+(trans_max/10)) * sin(m.mouse_degree)
											var/b_x = ((pix*32)+16) * cos(m.locked_mouse_degree)// - og setting
											var/b_y = ((pix*32)+16) * sin(m.locked_mouse_degree)// - og setting
											ball_hit.Move(m.loc, 0, m.step_x + b_x, m.step_y - b_y)
											ball_hit.layer = 6
										else ball_hit.loc = null

										steps = 0

										//Stretch out the beam graphically to the length of the plotted course, then set its location a tiny bit away from the caster.

										size = clamp(size,0,1) //Make sure beam has a max size

										var/matrix/M = matrix()
										M.Scale(pix,size)
										M.Translate(trans,0)
										M.Turn(m.locked_mouse_degree)
										beam.transform = M

										//beam.filters = list(filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,170)))
										//beam.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)

										beam.Move(m.loc, 0, m.step_x + move_x, m.step_y - move_y)

										pix += 1
										pix = clamp(pix,0,pix_max)
										//world << "pix = [pix], trans = [trans], size = [size]"
										trans += 16
										trans = clamp(trans,0,trans_max)
								sleep(0.1)

							for(var/obj/O in src.parts) O.qdel_obj_safe(O)
							src.parts.Cut(1,0)
							m.icon_state = m.state()
							m.beaming = 0
							m.active_attack = null
							view(25,m) << sound(null, channel = 1)
							src.last_activate_time = world.time
							return



			New()
				..()
				category = list("Force","Offence")
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null

					if(dir == "left")
						if(src in m)
							if(!src.selected_custom_beam)
								call(src.cycle_custom_beam)(m,src)
							else
								call(src.act)(m,src)






					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"] || m.mouse_dir == "right")
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(src.active)
								src.active = 0
								if(src == m.current_attack) m.current_attack = null
								if(src == m.active_attack) m.active_attack = null
								src.icon_state = "Beam off"
								m.beaming=0

							else
								if(!src.selected_custom_beam)
									call(src.cycle_custom_beam)(m,src)
								else

									src.icon_state = "Beam"
									m.current_attack = src
									src.active = 1
									m.toggle_skill(src)
									//call(src.act)(m,src)

					if(dir == "right")
						if(src in m)
							if(src.customs.len <0)
								call(src.act_create)(m,src)
							else
								switch(input(m,"Change Beam or Create New?") in list ("Change","Create"))
									if("Change")
										call(src.cycle_custom_beam)(m,src)
									if("Create")
										call(src.act_create)(m,src)
		Stance
			icon_state = "stance off"
			disabled_ko = 1
			act = /obj/skills/Stance/proc/activate
			//info_point_cost = 5
			//info_point_cost_type = "combat"
			info_cd = 0
			info_name = "stance"
			info_stats = ""
			info = "Gather, condense and form psionic power into a deadly ball before unleashing the pent up force as a beam of energy. It does 50% of the users Force stat in damage to anything it hits every 0.1 seconds. You can charge this skill by holding the left mouse button. Releasing the button will fire the skill. Charge time is quicker the higher your Recovery stat is."
			energy_skill = 1
			teach_energy = 1000
			disabled_switch = 1
			//attack_state = "beam"
			//var/tmp/list/parts = list()
			hud_x = 212
			hud_y = 540
			act_create = /obj/skills/Stance/proc/create
			  // Store custom Ki Blade techniques
			var/active_stance_index = 1  // Tracks currently selected custom blade
			var/cycle_custom_stance = /obj/skills/Stance/proc/cycle_custom_stances
			var/selected_custom_stance
			var/power_boost
			var/tmp/safe_cancel = FALSE
			proc
				cycle_custom_stances(var/mob/m,obj/skills/Stance/s)
					if(s.customs.len == 0)
						m<<output("You do not know any Stances.","actionoutput")
						m.set_alert("You do not know any Stances.",s.icon,s.icon_state)
						return
					s.active_stance_index += 1
					if(s.active_stance_index > s.customs.len)
						s.active_stance_index = 1
					var/datum/custom_stance/next_stance = s.customs[s.active_stance_index]

					//m.create_chat_entry("alerts","You switched to a new Beam.")
					m.set_alert("You switched to a new Stance",s.icon,s.icon_state)
					s.selected_custom_stance = next_stance
					//s.active=0
				create(var/mob/m,var/obj/skills/Stance/s)
					var/name = input(m, "Name your Stance technique.") as text
					var/power = input(m, "Choose a power percentage (1-200%).") as num
					var/color = input(m, "Choose the color for your Stance icon.") as color
					var/side = input(m, "Choose left or right fist for your Beam.") in list ("Left","Right","Both")
					var/chantEnabled = input(m, "Will this involve a chant?") in list ("Yes","No")
					var/chant
					if(chantEnabled == "Yes")
						chant = input(m,"What will the chant be?") as text

					if(!name || !power || !color || !side)
						//m.create_chat_entry("alerts", "You could not create the Beam technique!")
						m.set_alert("You could not create the Stance technique(Missing inputs)!",s.icon,s.icon_state)
						return  // If any input is missing, exit
					var/datum/custom_beam/custombeam = new
					custombeam.name = name
					custombeam.power = power / 100
					custombeam.color = color
					custombeam.side = side
					custombeam.chant = chant
					custombeam.chantEnabled = chantEnabled

					s.customs += custombeam  // Add custom blade to the list
					//m.create_chat_entry("alerts", "You have successfully created the [name] Beam technique!")
					m.set_alert("You have successfully created the [name] Stance technique!",s.icon,s.icon_state)
				activate(var/mob/m)
					if(src in m)
						//if(m.active_attack) return
						if(m.koed || m.stunned || m.meditating) return
						//if(m.energy <= 10) return
						if(!m.inStance)
							if(m.skill_stance == null) m.skill_stance = src
							//if(m.locked_mouse_degree) m.locked_mouse_degree = null
							var/power_multiplier
							var/custom_color
						//	var/fistside
							var/datum/custom_stance/customstance
							var/stancename
							//Beam stages
							//How it looks when it starts
							//How it looks as it expands
							//How it looks when finished.
							if(src.customs.len > 0)
								if(src.active_stance_index < 1 || src.active_stance_index > src.customs.len)
									src.active_stance_index = 1
								customstance  = src.customs[src.active_stance_index] // Activate selected ki blade tech
								power_multiplier = customstance.power
								//custom_color = customstance.color
								//fistside = custombeam.side
								stancename = customstance.name

								src.power_boost = power_multiplier
							else
								//m.create_chat_entry("alerts","You do not have any custom Beam techniques.")
								m.set_alert("You do not have any made Stance techniques.",src.icon,src.icon_state)
								return
							m.inStance = 1
							view(12,m) << sound(null, channel = 1)
							var/speaker_avatar = get_chatbox_render(m, m.client)
							for(var/mob/mx in view(25,m))
								mx<<output("<BIG><IMG CLASS=image SRC=\ref[speaker_avatar] STYLE='width:32px; height:32px;' ICONSTATE='' ICONDIR=SOUTH ICONFRAME=2></BIG><font color = [m.text_color_ic]><b>[m.real_name] shouts, '</font><b><font color = [custom_color]>[stancename]!'</b></font>","actionoutput")
							return
						else
							m.inStance = 0
							return





			New()
				..()
				category = list("Force","Offence")
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null

					if(dir == "left")
						if(src in m)
							if(!src.selected_custom_stance)
								call(src.cycle_custom_stance)(m,src)
							else
								call(src.act)(m,src)






					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"] || m.mouse_dir == "right")
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(src.active)
								src.active = 0
								if(src == m.current_attack) m.current_attack = null
								if(src == m.active_attack) m.active_attack = null
								src.icon_state = "stance off"
								m.beaming=0

							else
								if(!src.selected_custom_stance)
									call(src.cycle_custom_stance)(m,src)
								else

									src.icon_state = "stance"
								//	m.current_attack = src
									src.active = 1
									m.toggle_skill(src)
									//call(src.act)(m,src)

					if(dir == "right")
						if(src in m)
							if(src.customs.len <0)
								m.create_stance(src)
							else
								switch(input(m,"Change, Create, or Upgrade?") in list ("Change","Create","Upgrade"))
									if("Upgrade")
										var/datum/custom_stance/next_stance = src.customs[src.active_stance_index]

										if(next_stance == "All Around")
											var/offbonus = input ("How much points will you put into [next_stance]'s offense?\n Max Points: [m.stance_points]") as num
											if(offbonus>m.stance_points)
												offbonus = m.stance_points
											if(offbonus<=-0) offbonus=0
											var/remainder = (m.stance_points-offbonus)
											var/defbonus = input ("How much points will you put into [next_stance]'s defense?\n Max Points: [remainder]") as num
											if(defbonus>(usr.stance_points-offbonus))
												defbonus = usr.stance_points-offbonus
											if(defbonus<=-0) defbonus=0
											m.stance_points-=(offbonus+defbonus)
											next_stance.power += (offbonus+defbonus)*0.50
											m<<"You have added [offbonus] Offence and [defbonus] Defence points to your new stance!"
											return
										if(next_stance == "Offence")
											var/offbonus = input ("How much points will you put into [next_stance]'s offense?\n Max Points: [m.stance_points]") as num
											if(offbonus>m.stance_points)
												offbonus = m.stance_points
											if(offbonus<=-0) offbonus=0
											m.stance_points-=(offbonus)
											next_stance.power += (offbonus)
											m<<"You have added [offbonus] Offence points to your new stance!"
											return
										if(next_stance == "Defence")
											var/defbonus = input ("How much points will you put into [next_stance]'s defense?\n Max Points: [m.stance_points]") as num
											if(defbonus>m.stance_points)
												defbonus = m.stance_points
											if(defbonus<=-0) defbonus=0
											m.stance_points-=(defbonus)
											next_stance.power += (defbonus)
											m<<"You have added [defbonus] Defence points to your new stance!"
											return




									if("Change")
										call(src.cycle_custom_stance)(m,src)
									if("Create")
										m.create_stance(src)
		/*Beam
			icon_state = "Beam off"
			disabled_ko = 1
			act = /obj/skills/Beam/proc/activate
			info_energy_cost = 4
			info_dmg = 3
			info_spd = 1
			info_mastery = 2
			info_point_cost = 5
			info_point_cost_type = "force"
			info_cd = 0
			info_name = "beam"
			info_prerequisite = list("Blast")
			info_stats = "Energy Cost: High\n\nDamage: High\n\nSpeed: Slow\n\nMastery: Medium\n\nToggleable\n\nChargeable"
			info = "Hold to channel energy and fire continuously until depleted or canceled."
			energy_skill = 1
			teach_energy = 1000
			disabled_switch = 1
			attack_state = "beam"
			var/tmp/list/parts = list()
			hud_x = 212
			hud_y = 540
			act_create = /obj/skills/Beam/proc/create
			var/list/customs = list()
			var/active_beam_index = 1
			var/cycle_custom_beam = /obj/skills/Beam/proc/cycle_custom_beams
			var/selected_custom_beam
			var/power_boost
			var/tmp/safe_cancel = FALSE

			proc
				cycle_custom_beams(var/mob/m, obj/skills/Beam/s)
					if(!s.customs.len)
						m.create_chat_entry("alerts", "You do not have any custom Beam techniques.")
						m.set_alert("You do not have any made Beam techniques.", s.icon, s.icon_state)
						return
					s.active_beam_index++
					if(s.active_beam_index > s.customs.len) s.active_beam_index = 1
					var/datum/custom_beam/next_beam = s.customs[s.active_beam_index]
					s.selected_custom_beam = next_beam
					m.create_chat_entry("alerts", "Switched to new Beam: [next_beam.name].")
					m.set_alert("Switched Beam style.", s.icon, s.icon_state)

				create(var/mob/m, var/obj/skills/Beam/s)
					var/name = input(m, "Name your Beam technique.") as text
					var/power = input(m, "Choose a power percentage (1–200%).") as num
					var/color = input(m, "Choose the color for your Beam icon.") as color
					var/side = input(m, "Choose left or right fist for your Beam.") in list("Left","Right","Both")
					var/chantEnabled = input(m, "Will this involve a chant?") in list("Yes","No")
					var/chant
					if(chantEnabled == "Yes") chant = input(m,"Enter the chant:") as text
					if(!name || !power || !color || !side)
						m.create_chat_entry("alerts", "Beam creation failed (missing inputs).")
						m.set_alert("Beam creation failed!", s.icon, s.icon_state)
						return

					var/datum/custom_beam/newbeam = new
					newbeam.name = name
					newbeam.power = power / 100
					newbeam.color = color
					newbeam.side = side
					newbeam.chant = chant
					newbeam.chantEnabled = chantEnabled

					s.customs += newbeam
					m.create_chat_entry("alerts", "Created custom Beam: [name].")
					m.set_alert("Beam created!", s.icon, s.icon_state)

				activate(var/mob/m)
					if(!(src in m)) return
					if(m.active_attack || m.koed || m.stunned || m.meditating || m.energy <= 10) return

					m.skill_beam = src
					m.locked_mouse_degree = null

					// Safety + local vars
					src.safe_cancel = FALSE
					var/tmp/list/beam_parts = list()
					var/power_multiplier = 1
					var/custom_color
					var/fistside
					var/chant
					var/beamname

					if(src.customs.len)
						if(src.active_beam_index < 1 || src.active_beam_index > src.customs.len)
							src.active_beam_index = 1
						var/datum/custom_beam/cb = src.customs[src.active_beam_index]
						power_multiplier = cb.power
						custom_color = cb.color
						fistside = cb.side
						chant = cb.chant
						beamname = cb.name
						src.power_boost = ((m.force * 0.75) * (power_multiplier * 0.10))
					else
						m.create_chat_entry("alerts", "You do not have any custom Beam techniques.")
						m.set_alert("No Beam techniques found.", src.icon, src.icon_state)
						return

					var/sound/SS = sound('Modules/core/sound/sound files/Xia SFX v0.1/basicbeam_chargeoriginal.wav')
					SS.channel = 5; SS.volume = 100; SS.repeat = 0
					view(8, m) << SS

					if(fistside == "Left" || fistside == "Right") m.icon_state = "1HCharge"
					if(fistside == "Both") m.icon_state = "2HCharge"
					m.beaming = 1
					m.active_attack = src

					//================ Beam object setup ================//
					var/obj/ball = new; beam_parts += ball
					ball.icon = 'beam_charge.dmi'; ball.icon *= custom_color
					ball.icon_state = "psionic"; ball.plane = 29
					ball.pixel_x = -48; ball.pixel_y = -48
					ball.transform *= 0.1; ball.bolted = 2; ball.density_factor = -1

					var/obj/beam = new; beam_parts += beam
					beam.icon = 'beam_body_new.dmi'; beam.icon *= custom_color
					beam.icon_state = "psionic"; beam.plane = 29
					beam.pixel_y = -48; beam.bolted = 2; beam.density_factor = -1
					beam.transform *= 0.1

					var/obj/ball_hit = new; beam_parts += ball_hit
					ball_hit.icon = 'beam_charge.dmi'; ball_hit.icon *= custom_color
					ball_hit.icon_state = "psionic"; ball_hit.plane = 29
					ball_hit.pixel_x = -48; ball_hit.pixel_y = -48
					ball_hit.transform *= 0.1; ball_hit.bolted = 2; ball_hit.density_factor = -1

					var/obj/ranged/checker/checker = new; beam_parts += checker
					checker.origin = m; checker.KB_furrow = 1

					var/obj/ray = new; beam_parts += ray
					ray.loc = m.loc; ray.bolted = 2; ray.icon = 'fx_ray.dmi'; ray.icon *= custom_color
					ray.pixel_x = -144; ray.pixel_y = -144
					ray.filters += filter(type="rays", x=0, y=0, size=96, color=rgb(255,255,255), offset=0, density=10, threshold=0.7, factor=0, flags=FILTER_OVERLAY)
					animate(ray.filters[1], offset=100, time=1000, loop=-1)

					src.parts = beam_parts

					// Cached trig
					var/mx = cos(m.mouse_degree)
					var/my = sin(m.mouse_degree)

					m.locked_mouse_degree = m.mouse_degree
					var/size = 0.1, size_upper = 0.1, trans_extra = 0, hov_dis = 16
					var/fired = 0, stopping = 0, too_close = 0
					var/turf/t
					var/steps = 0
					var/pix = 0.1, trans = 0.1, pix_max = 0.1, trans_max = 1

					var/sound/S = sound('Modules/core/sound/sound files/Xia SFX v0.1/basicbeam_fire.wav'); S.channel = 5; S.volume = 25; S.repeat = 0


					while(!src.safe_cancel && m && m.energy > 0)
						if(m.koed || m.stunned || m.meditating)
							m.active_attack = null
							src.safe_cancel = TRUE
							break

						// Handle cancel safely
						if(src.safe_cancel)
							stopping = 1
							m.active_attack = null

						// Update beam visuals
						ball.Move(m.loc, 0, m.step_x + (16 * mx), m.step_y - (16 * my))
						if(ray && ray.loc)
							ray.loc = ball.loc
							ray.step_x = ball.step_x
							ray.step_y = ball.step_y

						if(stopping)
							hov_dis -= 0.075


							if(hov_dis <= 16) hov_dis = 16


							size -= size_upper / 20
							trans_extra -= 0.034
							animate(ball, transform = matrix()*size, time = 1)
							animate(ball_hit, transform = matrix()*size, time = 1)
							if(size <= 0.05) break

						else if(m.mouse_down)
							size += 0.001*m.mod_recovery
							if(size > 1) size = 1
							m.energy -= (5/m.mod_recovery)
							animate(ball, transform = matrix()*size, time = 1)
							animate(ball_hit, transform = matrix()*size, time = 1)

						else if(!fired)
							fired = 1
							qdel_safe(ray)
							var/obj/effects/hit/h = new
							h.loc = m.loc
							h.dir = m.dir
							spawn(10) if(h) h.destroy()

						else if(fired)
							t = get_step(m, m.dir)
							too_close = (t && t.density)
							if(!too_close)
								checker.loc = m.loc
								checker.step_x = m.step_x
								checker.step_y = m.step_y
							m.energy -= 0.5
							pix += 1; trans += 16
							var/matrix/M = matrix()
							M.Scale(pix, size)
							M.Translate(trans, 0)
							M.Turn(m.locked_mouse_degree)
							beam.transform = M
							beam.Move(m.loc, 0, m.step_x + (16*mx), m.step_y - (16*my))

						sleep(0.1)

					// Cleanup
					for(var/obj/O in beam_parts) qdel_safe(O)
					beam_parts.Cut()
					m.icon_state = m.state()
					m.beaming = 0
					m.active_attack = null
					return
					*/
		Eye_Laser_Test
			icon_state = "Beam off"
			disabled_ko = 1
			act = /obj/skills/Eye_Laser_Test/proc/activate
			info_energy_cost = 4
			info_dmg = 3
			info_spd = 1
			info_mastery = 2
			info_point_cost = 5
			info_point_cost_type = "force"
			info_cd = 0
			info_name = "beam"
			info_prerequisite = list("Blast")
			info_stats = "Energy Cost: High\n\nDamage: High\n\nSpeed: Slow\n\nMastery: Medium\n\nToggleable\n\nChargeable"
			info = "Gather, condense and form psionic power into a deadly ball before unleashing the pent up force as a beam of energy. It does 50% of the users Force stat in damage to anything it hits every 0.1 seconds. You can charge this skill by holding the left mouse button. Releasing the button will fire the skill. Charge time is quicker the higher your Recovery stat is."
			energy_skill = 1
			teach_energy = 1000
			disabled_switch = 1
			attack_state = ""
			var/tmp/list/parts = list()
			//hud_x = 212
			//hud_y = 540
			proc
				activate(var/mob/m)
					if(src in m)
						if(m.active_attack) return
						if(m.energy <= 10) return
						if(m.koed || m.stunned || m.meditating) return

						//Beam stages
						//How it looks when it starts
						//How it looks as it expands
						//How it looks when finished.

						m.active_attack = src
						m.icon_state = m.state()
						m << output("Current attack is [src], [m.active_attack]", "chat.system")

						var/obj/beam = new
						beam.icon = 'eye_lasers.dmi'
						//beam.blend_mode = BLEND_INSET_OVERLAY
						//beam.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
						//beam.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
						for(var/obj/body_related/ascension_milestones/a in m.ascensions)
							if(a.major_ascension && a.icon_state == "ascension" && a.level > 0)
								beam.icon_state = "divine"
								beam.plane = 2
								break
							else
								beam.icon_state = "all dir"
								beam.plane = 1
						beam.pixel_y = 4
						beam.bolted = 2
						beam.density_factor = -1

						var/obj/ranged/checker/checker = new
						checker.origin = m
						checker.KB_furrow = 1
						var/steps = 0
						checker.charge_lvl += 0.01*m.mod_recovery
						checker.ki_force = (m.force/100)*checker.charge_lvl
						checker.force_usage = m.mod_force_usage
						checker.ki_power = m.psionic_power

						src.parts = list(beam,checker)

						var/pix_max = 0.1;
						var/trans_max = 1;
						var/trans_extra = 0;
						var/pix = 0.1
						var/trans = 0.1


						var/hov_dis = 1
						var/fired = 1;
						var/turf/t = null
						var/stop = 0

						var/go = 1

						while(go == 1)
							var/e = (0.5/m.mod_recovery)+(0.5/src.skill_lvl)

							//While this skill is active, give some exp.
							src.skill_exp += ((0.1-(src.skill_lvl/100))*m.mod_skill)+0.1

							if(src.skill_exp >= 100 && src.skill_lvl < 100)
								src.skill_exp = 1
								src.skill_lvl += 1
								src.skill_up(m)

							//If the player doesn't have enough energy while firing or charging, or they become stunned, ect, then force the attack to stop.

							if(m.energy <= e) stop = 1
							if(m.koed || m.stunned || m.meditating) stop = 1
							if(m.active_attack == null) stop = 1
							if(stop)
								qdel(beam)
								checker.origin = null
								checker.loc = null
								m.icon_state = m.state()
								return

							m.dir = Directions.FromDegreesToCardinal(m.GetAngleStep(m.mouse_saved_loc))//get_dir(m,m.mouse_saved_loc)
							m.wings()

							var/move_x = hov_dis * cos(m.mouse_degree)
							var/move_y = hov_dis * sin(m.mouse_degree)

							//This is still executed, even if the player stops or starts charging again.
							if(fired >= 1)
								m.stunned = 1
								pix_max = 0.1;
								trans_max = 1-trans_extra
								t = get_step(m,m.dir)
								if(t && t.density || t.density_factor == 2)
									checker.loc = null
								else
									//The checker's position is reset every loop, ready to travel out and plot a course.
									checker.loc = m.loc
									checker.step_x = m.step_x
									checker.step_y = m.step_y

								m.energy -= e*checker.charge_lvl

								//Sends an obj out to seek obstacles. Tracks how long the beam will be.
								while(checker.loc)
									pix_max += 21/88 //This is derived from 20*24, which is 480, +5% for adjustments
									if(pix_max >= 15) pix_max = 15
									trans_max += 336/88 //This is derived from 480/1.5, then + 5% for adjustments.
									//if(trans_max >= 245) trans_max = 245; //Half of the beam length in pixels
									if(trans_max >= 240) trans_max = 240; //Half of the beam length in pixels - This is the og setting
									steps += 8
									var/m_x = steps * cos(m.mouse_degree)
									var/m_y = steps * sin(m.mouse_degree)
									checker.Move(m.loc, 0, m.step_x + m_x, m.step_y - m_y)
									if(prob(1)) checker.dust_and_furrows(pick(1,2,3,4,5,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0),1)
									//if(prob(1)) checker.dust_and_furrows(pick(1,2,3,4,5,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
									if(steps >= 705) checker.loc = null //88 steps to reach 704, 8*88 = 704+1

								steps = 0

								//Stretch out the beam graphically to the length of the plotted course, then set its location a tiny bit away from the caster.

								//beam.filters = null

								var/d = m.get_mouse_degree_from_player(m.mouse_x,m.mouse_y,m.mouse_pix_x,m.mouse_pix_y)

								var/matrix/M = matrix()
								M.Scale(pix,1)
								M.Translate(trans,0)
								M.Turn(d)//m.mouse_degree)
								beam.transform = M


								//beam.filters = list(filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204)),filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175))
								if(beam.dir == NORTH) beam.Move(m.loc, 0, m.step_x + move_x, m.step_y - move_y + 5)
								else beam.Move(m.loc, 0, m.step_x + move_x, m.step_y - move_y)

								switch(d)
									if(0 to 44) m.dir = EAST
									if(45 to 135) m.dir = SOUTH
									if(136 to 225) m.dir = WEST
									if(226 to 315) m.dir = NORTH
									if(316 to 360) m.dir = EAST

								pix += 1
								pix = clamp(pix,0,pix_max)
								trans += 16
								trans = clamp(trans,0,trans_max)
							sleep(0.1)
			New()
				..()
				category = list("Force","Offence")
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(src.active)
								src.active = 0
								if(src == m.current_attack) m.current_attack = null
								if(src == m.active_attack) m.active_attack = null
								src.icon_state = "Beam off"
							else
								src.icon_state = "Beam"
								m.current_attack = src
								src.active = 1
								m.toggle_skill(src)
		Eye_Laser
			icon_state = "Explosion off"
			disabled_ko = 1
			act = /obj/skills/Eye_Laser/proc/activate
			info_energy_cost = 4
			info_dmg = 3
			info_spd = 3
			info_mastery = 1
			info_point_cost = 5
			info_point_cost_type = "force"
			info_name = "laser"
			info_prerequisite = list("Beam")
			energy_skill = 1
			disabled_switch = 1
			var/list/segments
			proc
				activate(var/mob/m)
					if(src in m)
						if(m.active_attack) return
						if(m.koed || m.stunned || m.meditating) return
						m.active_attack = src
						var/obj/eyes = new
						//if(m.race == "Cerebroid") eyes.icon = 'goog_eye_glow.dmi'
						eyes.icon = 'humanoid_eyes_glow.dmi'
						eyes.filters += filter(type="outline", size=1, color=rgb(118,66,138))
						eyes.plane = 1;
						m.overlays += eyes
						var/pix_y = 3
						var/pix_x = 0;
					//	if(m.race == "Alien")
					//		pix_y = 17;
					//		pix_x = 6;
						var/go = 1
						while(go == 1)
							var/di = 0
							di = m.mouse_degree
							m.dir = get_dir(m,m.mouse_saved_loc)
							if(src)
								src.skill_exp += (1/src.skill_lvl)*m.mod_skill
								if(src.skill_exp >= 100 && src.skill_lvl < 100)
									src.skill_exp = 1
									src.skill_lvl += 1
								var/e = (1/m.mod_recovery)+(1/src.skill_lvl)
								if(m.mouse_saved_loc)
									m.energy -= e
									//Grab any beams that got removed from play for any reason and put them back into play, unless the player canceled use of the skill.
									var/fly = 0;
									if(m.skill_flight && m.skill_flight.active) fly = 1;
									//if(m.race == "Alien")
										//if(m.dir == WEST || m.dir == NORTHWEST || m.dir == SOUTHWEST) pix_x = 0
										//else pix_x = 6
									for(var/obj/ranged/eye_laser/o in src.segments)
										if(o.loc == null && m.active_attack)
											o.loc = m.loc
											o.ki_owner = m
											o.pix_away = 18
											o.finishing = 0
											o.fired = 1;
											o.alpha = 255;
											if(fly) o.pixel_y = pix_y+5
											else o.pixel_y = pix_y
											o.pixel_x = pix_x
											//Because eye lasers don't have a charge phase, we can apply the damage here. Other beams must have their damage updated on impact instead.
											o.charge_lvl += 1*m.mod_recovery
											o.ki_power = m.psionic_power
											o.ki_force = (m.force/10)*o.charge_lvl
											o.force_usage = m.mod_force_usage
											o.ki_offence = m.offence
											o.ki_agility = m.mod_agility
											//o.MoveAngInstant(di,o.pix_away,0,0,null)
											break
								var/matrix/M = matrix()
								M.Turn(di)
								for(var/obj/ranged/eye_laser/o in src.segments)
									if(o.loc)
										//If the player has enough energy, move all the beams in a straight line and adjust the location if the player rotates the origin point.
										o.loc = m.loc
										o.step_x = m.step_x
										o.step_y = m.step_y
										o.MoveAngInstant(di,o.pix_away,0,0,null)
										o.dir = m.dir
										//var/matrix/M = matrix()
										//var/t = 0
										//M.Turn(di)
										if(o.finishing == 0)
											o.pix_away += 12
											if(o.pix_away >= 500)
												o.loc = null
											if(m.active_attack == null) //If the attack is canceled for any reason, force all the beam segments to shrink and vanish. (Beams no longer move further than where they are, because pix_away is no longer increasing.)
												o.finishing = 1
												go = 0
												animate(o,alpha = 0,time = 5)
												spawn(5)
													if(o) o.loc = null
										o.transform = M
								//If the player doesn't have enough energy while firing or charging, force the ball and beams to shrink and vanish.
								if(m.energy <= 1) m.active_attack = null
								if(m.koed || m.stunned || m.meditating) m.active_attack = null
							else
								m.active_attack = null
								go = 0;
								return
							sleep(0.1)
						m.overlays -= eyes
						qdel(eyes)
			New()
				..()
				category = list("Force","Offence")
				spawn(10)
					src.info = text_super_speed


					src.segments = list()
					var/n = 42
					while(n)
						n -= 1
						var/obj/ranged/eye_laser/l = new
						src.segments += l
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(src.active)
								src.active = 0
								if(src == m.current_attack) m.current_attack = null
								src.icon_state = "Explosion off"
							else
								src.icon_state = "Explosion"
								m.current_attack = src
								src.active = 1
								m.toggle_skill(src)
		Kaioenjin
			icon_state = "Kaioenjin off"
			disabled_ko = 1
			act = /obj/skills/Kaioenjin/proc/activate
			info_energy_cost = 4
			info_dmg = 4
			info_spd = 3
			info_mastery = 1
			info_point_cost = 5
			disabled_ko = 1
			info_dmg = 5
			info_spd = 5
			info_mastery = 2
			info_cd = 0
			info_name = "kaioenjin"
			info_prerequisite = list("Blast")
			info_stats = "Energy Cost:Very High\n\nDamage: Very High\n\nSpeed: Very Fast\n\nMastery: Medium\n\nToggleable"
			info = "Gather, condense and form power into a deadly ball before unleashing the pent up force as a beam of energy. It does 50% of the users Force stat in damage to anything it hits every 0.1 seconds. You can charge this skill by holding the left mouse button. Releasing the button will fire the skill. Charge time is quicker the higher your Recovery stat is."
			energy_skill = 1
			teach_energy = 10000
			disabled_switch = 1
			attack_state = "beam"
			hud_x = 212
			hud_y = 540
			info_point_cost_type = "force"
			var/tmp/list/parts = list()
			proc/activate(var/mob/m)
				if(m.active_attack) return
				if(m.koed || m.stunned || m.meditating) return
				if(m.energy <= 10) return
				if(m.skill_kaioenjin == null) m.skill_kaioenjin = src
				if(m.locked_mouse_degree) m.locked_mouse_degree = null
				var/custom_color = rgb(230,109,0)
				m.icon_state ="2HCharge"
				m.beaming=1
				var/obj/ball = new
				ball.icon = 'beam2_charge.dmi'
			//	ball.icon *= custom_color
				ball.plane=2
				if(ball.icon_state==null||ball.icon_state=="") ball.icon_state = "psionic"
				ball.pixel_x = -48
				ball.pixel_y = -48
				ball.transform*=0.1
				ball.bolted = 2
				ball.density_factor = -1

				m.active_attack = src
				m.icon_state = m.state()


				var/obj/ball_hit = new
				ball_hit.icon = 'beam2_charge.dmi'
			//	ball_hit.icon *= custom_color
				ball_hit.plane = 2
				if(ball_hit.icon_state==null||ball_hit.icon_state=="") ball_hit.icon_state = "psionic"
				ball_hit.pixel_x = -48
				ball_hit.pixel_y = -48
				ball_hit.transform*=0.1
				ball_hit.density_factor = -1
				ball_hit.bolted = 2

				var/obj/beam = new
				beam.icon = 'beam2_body.dmi'
			//	beam.icon *= custom_color
				beam.plane=2
			//	if(beam.icon_state==null||beam.icon_state=="") beam.icon_state="psionic"
				beam.pixel_y = -48
				beam.bolted = 2
				beam.density_factor = -1
				var/matrix/bm = matrix()
				bm.Scale(328,328)
				beam.transform = bm
				//beam.transform*=0.1


				var/obj/ranged/checker/checker = new
				checker.origin = m
				checker.KB_furrow = 1
				//checker.density_factor = -1
				var/steps = 0

				//var/list/visited_x = list()
				//var/list/visited_y = list()

				var/obj/ray = new
				ray.loc = m.loc
				ray.bolted = 2
				ray.icon = 'fx_ray.dmi'
				ray.icon *= custom_color
				ray.pixel_x = -144
				ray.pixel_y = -144
				ray.filters += filter(type="rays",x=0,y=0,size=96,color=rgb(255,255,255),offset=0,density=10,threshold=0.7,factor=0,flags=FILTER_OVERLAY)
				animate(ray.filters[1],offset = 100,time = 1000, loop = -1)
				animate(offset = 0,time = 0)

				src.parts = list(ball,ball_hit,beam,checker,ray)

				var/pix_max = 0.1;
				var/trans_max = 1;
				var/trans_extra = 0;
				var/pix = 0.1
				var/trans = 0.1

				//Controls beam sizes and pulsations
				var/size = 0.1
				var/size_upper = 0.1
				//var/size_dir = 0

				var/hov_dis = 16
				//var/hov_dis_extra = 0;

				//var/charging = 0; //If the attack is charging, increase its size and offset the assets correctly.
				var/fired = 0;
				var/stopping = 0;
				var/charge_check = 1;
				var/too_close = 0
				var/turf/t = null

				var/go = 1
				//m.beaming
				  // Store the direction to lock later


				switch(m.GetAngleStep(m.mouse_saved_loc))
					if(0 to 44) m.dir = WEST
					if(45 to 135) m.dir = NORTH
					if(136 to 225) m.dir = EAST
					if(226 to 315) m.dir = SOUTH
					if(316 to 360) m.dir = WEST

				m.locked_mouse_degree = m.GetAngleStep(m.mouse_saved_loc)//m.mouse_degree

				while(go == 1)

					var/e = (5/m.mod_recovery)+(5/src.skill_lvl)*5
					if(e<0) e = 1
					//While this skill is active, give some exp.
					src.skill_exp += ((0.1-(src.skill_lvl/100))*m.mod_skill)+0.1

					if(src.skill_exp >= 100 && src.skill_lvl < 100)
						src.skill_exp = 1
						src.skill_lvl += 1
						src.skill_up(m)
					//Once we reach 0 size, the attack is finished and considered ended.
					if(size <= 0)
						size = 0;
						if(ray) ray.loc = null
						qdel(beam)
						qdel(ball)
						qdel(ball_hit)
						checker.origin = null
						checker.loc = null
						//del(checker)
						m.icon_state = m.state()
						m.beaming = 0
						return

					//If the player doesn't have enough energy while firing or charging, or they become stunned, ect, then force the ball and beams to shrink and vanish.
					if(m.energy <= e) m.active_attack = null
					if(m.koed || m.stunned || m.meditating) m.active_attack = null
					if(!ball)
						m.active_attack = null
						go = 0;
						m.beaming=1
						return;

					//Otherwise continue
					else
						//m.dir = get_dir(m,m.mouse_saved_loc)
						/*switch(m.mouse_degree-180)
							if(0 to 44) m.dir = WEST
							if(45 to 135) m.dir = NORTH
							if(136 to 225) m.dir = EAST
							if(226 to 315) m.dir = SOUTH
							if(316 to 360) m.dir = WEST*/
						m.wings()

						//Check if the attack is active. If its not, it means player canceled the attack or something else happened.
						if(m.active_attack == null)
							if(stopping == 0)
								stopping = 1
								for(var/mob/h in view(8,m))
									h << sound(null, channel=3)

						var/move_x = 16 * cos(m.locked_mouse_degree)
						var/move_y = 16 * sin(m.locked_mouse_degree)

						//world << "Beam charge size removes [removes_charging]"

						ball.Move(m.loc, 0, m.step_x + move_x, m.step_y - move_y)
						if(ray && ray.loc)
							ray.loc = ball.loc
							ray.step_x = ball.step_x
							ray.step_y = ball.step_y

						//If the beam is canceled for any reason, force the ball and ball_hit to shrink and make the size reduce for the beam and balls.
						if(stopping >= 1)
							hov_dis -= 0.075
							size -= size_upper/20
							trans_extra -= 0.034 //240/88 = 2.727. Then divided by 8, which is the steps. Equals 0.34

							if(hov_dis <= 16) hov_dis = 16

							var/matrix/B = matrix()
							B.Scale(size,size)
							ball.transform = B

							var/matrix/B_H = matrix()
							B_H.Scale(size,size)
							ball_hit.transform = B_H

						//If the attack is on-going and the player has their mouse held down, charge the attack and make it bigger.
						else if(m.mouse_down)
							//if(size == 0.1)
								//for(var/mob/h in view(8,m))
									//h << sound('activate.mp3',1,0,3,100)
							var/matrix/B = matrix()
							B.Scale(size,size)
							ball.transform = B

							var/matrix/B_H = matrix()
							B_H.Scale(size,size)
							ball_hit.transform = B_H

							hov_dis += 0.075*m.mod_recovery
							size += 0.001*m.mod_recovery
							//Increase the charge lvl of the attack, and its dmg, then check if the rounded charge lvl of the attack is higher than when we looked last. Only looking for whole increases.
							checker.charge_lvl += 0.01*m.mod_recovery
							checker.ki_force = (m.force/100)*checker.charge_lvl*5
							checker.force_usage = m.mod_force_usage
							checker.ki_power = m.psionic_power
							if(checker.charge_lvl>= (25/m.mod_recovery)+(25/src.skill_lvl)*5)
								checker.charge_lvl = (25/m.mod_recovery)+(25/src.skill_lvl)*5
							var/charge_rounded = round(checker.charge_lvl)
							if(charge_rounded > charge_check)
								charge_check = charge_rounded
								m.charge_nums("<font color = green>x[charge_check]")
								//world << "Beam charge lvl is [checker.charge_lvl] and rounded it is [round(checker.charge_lvl)]"
							m.energy -= e*checker.charge_lvl
							size_upper += 0.001*m.mod_recovery
							if(size >= 1) size = 1;
							//issue is trans_extra
							//if(size > 0.2) m.mouse_down = null
							if(size < 1) trans_extra += 0.034*m.mod_recovery //240/88 = 2.727. Then divided by 8, which is the steps. Equals 0.34

							if(hov_dis >= 80) hov_dis = 80 //Max 80 seems good

							//Create cool gathering energy effect around the main charging orb.
							if(prob(10))
								if(ball && isturf(ball.loc))
									var/obj/orb = null
									if(ball.icon_state == "psionic") orb = new /obj/effects/orb
									else if(ball.icon_state == "divine") orb = new /obj/effects/orb_divine
									orb.icon *= custom_color
									orb.loc = ball.loc
									orb.step_x = ball.step_x
									orb.step_y = ball.step_y
									orb.pixel_x = rand(-64,64)
									orb.pixel_y = rand(-64,64)
									animate(orb,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
									spawn(10)
										if(orb) orb.loc = null//del(o)
						//If the beam isn't canceled and the mouse isn't held, then fire the attack.
						else if(fired <= 0)
							//for(var/mob/h in view(8,m))
								//h << sound('beam1.mp3',1,0,3,100)
							m.icon_state= "2HBlast"
							m.beaming = 1
						//	m.can_move =0
							//for(var/mob/mx in view(25,m))
							//	mx.create_chat_entry("local","<font color = [m.text_color_ic]>[m.real_name]</font> shouts, '<b><font color = [custom_color]>Kaioenjin!<b></font>'",0,1)

							fired = 1
							if(ray && ray.loc) ray.loc = null
							var/obj/effects/hit/h = new
							h.loc = m.loc
							h.dir = m.dir
							if(m.dir == SOUTH ||m.dir == NORTH) h.pixel_x += 16
							h.step_x = m.step_x
							h.step_y = m.step_y
							spawn(10)
								if(h) h.destroy()

						//This is still executed, even if the player stops or starts charging again.
						if(fired >= 1)
							pix_max = 0.1;
							trans_max = 1-trans_extra
							//if(trans_max >= 240) trans_max = 1
							//else trans_max = 1-trans_extra;
							t = get_step(m,m.dir)
							too_close = 0
							if(t && t.density || t.density_factor == 2)
								checker.loc = null
								too_close = 1
							else
								//The checker's position is reset every loop, ready to travel out and plot a course.
								checker.loc = m.loc
								checker.step_x = m.step_x
								checker.step_y = m.step_y

							m.energy -= e*checker.charge_lvl
							//world << "Beam firing removes [removes]"

							//Sends an obj out to seek obstacles. Tracks how long the beam will be.
							while(checker.loc)
								pix_max += 21/88 //This is derived from 20*24, which is 480, +5% for adjustments
								if(pix_max >= 15) pix_max = 15
								trans_max += 336/88 //This is derived from 480/1.5, then + 5% for adjustments.
								//if(trans_max >= 245) trans_max = 245; //Half of the beam length in pixels
								if(trans_max >= 240) trans_max = 240; //Half of the beam length in pixels - This is the og setting
								steps += 8
								var/m_x = steps * cos(m.locked_mouse_degree)
								var/m_y = steps * sin(m.locked_mouse_degree)
								checker.Move(m.loc, 0, m.step_x + m_x, m.step_y - m_y)
								if(prob(1)) checker.dust_and_furrows(pick(1,2,3,4,5,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0),1)
								/*
								if(visited_x.Find(checker.step_x) == 0 && visited_y.Find(checker.step_y) == 0)
									checker.dust_and_furrows(0)
									visited_x += checker.step_x
									visited_y += checker.step_y
								*/
								if(steps >= 705) checker.loc = null //88 steps to reach 704, 8*88 = 704+1

							//Make sure we're not too close to a solid turf.
							if(too_close == 0)
								//Once we know how far and long the beam can travel, cap it off with an end graphically
								//var/b_x = ((pix*32)+(trans_max/10)) * cos(m.mouse_degree)
								//var/b_y = ((pix*32)+(trans_max/10)) * sin(m.mouse_degree)
								var/b_x = ((pix*32)+16) * cos(m.locked_mouse_degree)// - og setting
								var/b_y = ((pix*32)+16) * sin(m.locked_mouse_degree)// - og setting
								ball_hit.Move(m.loc, 0, m.step_x + b_x, m.step_y - b_y)
								ball_hit.layer = 6
							else ball_hit.loc = null

							steps = 0

							//Stretch out the beam graphically to the length of the plotted course, then set its location a tiny bit away from the caster.

							size = clamp(size,0,1) //Make sure beam has a max size

							var/matrix/M = matrix()
							M.Scale(pix,size)
							M.Translate(trans,0)
							M.Turn(m.locked_mouse_degree)
							beam.transform = M

							//beam.filters = list(filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,170)))
							//beam.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)

							beam.Move(m.loc, 0, m.step_x + move_x, m.step_y - move_y)

							pix += 1
							pix = clamp(pix,0,pix_max)
							//world << "pix = [pix], trans = [trans], size = [size]"
							trans += 16
							trans = clamp(trans,0,trans_max)
					sleep(0.1)
			New()
				..()
				category = list("Force","Offence")
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null

					if(dir == "left")
						if(src in m)
							call(src.act)(m)





					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"] || m.mouse_dir == "right")
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(src.active)
								src.active = 0
								if(src == m.current_attack) m.current_attack = null
								if(src == m.active_attack) m.active_attack = null
								src.icon_state = "Kaioenjin off"
								m.beaming=0

							else

								src.icon_state = "Kaioenjin"
								m.current_attack = src
								src.active = 1
								m.toggle_skill(src)
									//call(src.act)(m,src)





		Piercing_Beam
			icon_state = "Explosion off"
			disabled_ko = 1
			act = /obj/skills/Piercing_Beam/proc/activate
			info_energy_cost = 4
			info_dmg = 4
			info_spd = 3
			info_mastery = 1
			info_point_cost = 5
			info_point_cost_type = "force"
			info_name = "piercing_beam"
			info_prerequisite = list("Beam")
			energy_skill = 1
			disabled_switch = 1
			proc
				activate(var/mob/m)
					return
					if(src in m)
						if(m.active_attack) return
						if(m.koed || m.stunned || m.meditating) return
						var/obj/ranged/beam_charge/b = new
						b.ki_owner = m
						if(m.skill_flight && m.skill_flight.active) m.icon_state = "fly blast"
						else m.icon_state = "blast"
						m.active_attack = b
						var/matrix/trix = matrix()
						trix.Scale(0,0)
						b.transform = trix
						var/list/beam_list = list()
						b.pix_away = 18
						var/go = 1;
						while(go == 1)
							var/di = 0
							var/b_num = 0
							//If the charge ball exists, move it relative to player mouse position and continue with the rest of the code.
							if(b)
								src.skill_exp += (1/src.skill_lvl)*m.mod_skill
								if(src.skill_exp >= 100 && src.skill_lvl < 100)
									src.skill_exp = 1
									src.skill_lvl += 1
								b.loc = m.loc
								m.dir = get_dir(m,m.mouse_saved_loc)
								di = m.GetAngleStep(m.mouse_saved_loc)//m.mouse_degree//m.GetAngleStep(m.mouse_saved_loc)
								b.step_x = m.step_x
								b.step_y = m.step_y
								b.MoveAng(di,b.pix_away,0,0,null)
								if(b.fired == 0)
									b.shockwave()
									var/matrix/M = matrix()
									M.Scale(0.1,0.1)
									animate(b,transform = M,time = 5)
									b.size = 0.2
									b.charge_lvl = 5
									b.fired = 1
									spawn(5)
										if(b) b.fired = 2
								src.skill_exp += (1/src.skill_lvl)*m.mod_skill
								if(src.skill_exp >= 100 && src.skill_lvl < 100)
									src.skill_exp = 1
									src.skill_lvl += 1
								b.loc = m.loc
								m.dir = get_dir(m,m.mouse_saved_loc)
								di = m.GetAngleStep(m.mouse_saved_loc)//m.mouse_degree//m.GetAngleStep(m.mouse_saved_loc)
								b.step_x = m.step_x
								b.step_y = m.step_y
								b.MoveAng(di,b.pix_away,0,0,null)
								if(b.fired == 2)
									for(var/obj/ranged/beam/o in beam_list)
										//If the player has enough energy, move all the beams in a straight line and adjust the location if the player rotates the origin point.
										var/t = 0
										b_num += 1
										o.icon = 'beam_body_sharp.dmi'
										var/icon/I_start = new(o.icon)
										I_start.Turn(di)
										o.icon = I_start
										if(o.finishing == 0)
											if(m.active_attack == null) //If the attack is canceled for any reason, force all the beam segments to shrink and vanish.
												o.finishing = 1
												var/matrix/M2 = matrix()
												M2.Scale(0,0)
												animate(o,transform = M2,time = 10)
												t = 10
												o.hit_solid = 1
										o.loc = b.loc
										o.step_x = b.step_x
										o.step_y = b.step_y
										o.ki_power = m.psionic_power
										o.ki_force = (m.force/10)*b.charge_lvl
										o.force_usage = m.mod_force_usage
										o.ki_offence = m.offence
										o.ki_agility = m.mod_agility
										o.MoveAngInstant(di,o.pix_away,0,0,null)
										if(o.finishing == 0)
											o.pix_away += 32
											if(o.pix_away >= 500)
												o.hit_solid = 1
										if(o.hit_solid == 1)
											o.hit_solid = 2
											spawn(t)
												if(o)
													o.loc = null
													o.suffix = null
													o.fired = 0;
													b_num -= 1
													beam_list -= o
									//If the attack was canceled, or the player ran out of energy during charging or firing, force the attack segements to shrink and vanish.
									if(m.active_attack == null)
										if(b.finishing == 0)
											m.icon_state = m.state()
											var/matrix/M = matrix()
											M.Scale(0,0)
											animate(b,transform = M,time = 10)
											b.finishing = 1
											spawn(10)
												if(b)
													go = 0
													qdel(b)
									var/e = ((1/m.mod_recovery)+(1/src.skill_lvl)*b.charge_lvl)
									if(m.mouse_saved_loc)
										if(b.fired)
											m.energy -= e
											if(b_num < 30 && b.finishing == 0)
												//Make sure we have no more than 40 beam segements and create them as needed.
												for(var/obj/ranged/beam/o in beams)
													if(o.loc == null && o.suffix == null)
														o.icon = 'beam_body_sharp.dmi'
														o.pixel_x = -16
														o.pixel_y = -16
														o.suffix = "in use"
														var/matrix/M = matrix()
														M.Scale(1,1)
														o.transform = M
														beam_list += o
														b_num += 1
														o.ki_owner = m
														o.pix_away = 32
														o.finishing = 0
														o.hit_solid = 0
														break
								//If the player doesn't have enough energy while firing or charging, force the ball and beams to shrink and vanish.
								if(m.energy <= 1) m.active_attack = null
								if(m.koed || m.stunned || m.meditating) m.active_attack = null
							else
								go = 0
								m.active_attack = null
								return
							sleep(0.1)
			New()
				..()
				category = list("Force","Offence")
				spawn(10)
					src.info = text_super_speed


			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(src.active)
								src.active = 0
								if(src == m.current_attack) m.current_attack = null
								src.icon_state = "Explosion off"
							else
								src.icon_state = "Explosion"
								m.current_attack = src
								src.active = 1
								m.toggle_skill(src)
		Psychokinetic_Lash
			icon_state = "Telekinesis off"
			info_energy_cost = 1
			info_dmg = 1
			info_spd = 5
			info_mastery = 2
			teach_energy = 2000
			info_point_cost = 1
			info_point_cost_type = "force"
			info_name = "telekinesis"
			act = /obj/skills/Telekinesis/proc/activate
			hud_x = 164
			hud_y = 636
			/*
			Special form of Telekinesis that acts like the attack skill, but doesn't ever require the user to be near, or teleport near, the target. It also uses the force stat instead.
			     - Ranged
			     - Uses Force
			     - Doesn't warp player near target, unless they get knocked out of range, in which case, brings the user slightly closer instead
			     - Half-knock back
			     - Appears as a kind of purple slash/lash
			     - Uses a lot more energy than normal Attack skill
			     - Has a cooldown like super speed, which is based on Recovery stat
			*/
		Telekinesis
			icon_state = "Telekinesis off"
			info_energy_cost = 1
			info_dmg = 1
			info_spd = 5
			info_mastery = 2
			teach_energy = 2000
			info_point_cost = 1
			info_point_cost_type = "force"
			info_name = "telekinesis"
			act = /obj/skills/Telekinesis/proc/activate
			hud_x = 164
			hud_y = 636
			/*
			Redesign this, so you click something to activate it.
			Then you can do the normal stuff, like moving that item about with the mouse.
			However, double-clicking another turf or movable forces the item in your control to slam into it
			Right clicking the item you are controlling starts to dmg it
			Right clicking a mob will start to squeeze it like the wrestle system, and break limbs.
			Bonus, maybe at high lvls and stupid high force, can just pluck out eyes, ect.
			*/
			proc
				/*activate(var/mob/m,var/obj/s)
				//	return
					if(s in m)
						if(m.skill_tk == null) m.skill_tk = s
						if(s.active)
							s.active = 0
							s.icon_state = "Telekinesis off"
							m.drop_tk()
							//clear = 1
						else
							s.icon_state = "Telekinesis"
							s.active = 1
							m.left_click_function = "tk"
							m.set_alert("Select target",s.icon,s.icon_state)
							winshow(m,"skills",0)
							m.open_skills = 0
							m.open_menus.Remove(".open_skills")*/
				activate(mob/m,obj/s)

					if(!(s in m)) return

					if(!m.skill_tk)
						m.skill_tk = s

					if(s.active)

						s.active = 0
						s.icon_state = "Telekinesis off"

						m.left_click_function = null
						m.drop_tk()

						m << "Telekinesis disabled."

					else

						s.active = 1
						s.icon_state = "Telekinesis"

						m.left_click_function = "tk"

						m.set_alert("Select object to move",s.icon,s.icon_state)

						m << "Telekinesis enabled."
			var
				tmp/mob/tether
				tk_mini = 0
				obj/tk_ring
			New()
				..()
				category = list("Energy","Force","Utility")
				spawn(10)
					if(src.spawned == 0)
						src.spawned = 1
						src.info = text_telekinesis


						/*
						var/obj/hud/minigames/tk/tk_pointer/H = new
						H.loc = src
						src.tk_pointer = H
						var/obj/hud/minigames/tk/tk_bar/H2 = new
						H2.loc = src
						var/obj/hud/minigames/tk/tk_range/H3 = new
						H3.loc = src
						src.tk_range = H3
						var/obj/hud/minigames/tk/tk_multi/H4 = new
						H4.loc = src
						*/
					var/obj/effects/minigames/tk_ring/ring = new
					src.tk_ring = ring
					if(ismob(src.loc)) src.tether = src.loc
					/*
					while(src)
						var/spd = 10
						if(src.active)
							spd = 0.1
							if(ismob(src.loc))
								var/mob/m = src.loc
								src.tk_ring.loc = m.loc
								src.step_x = m.step_x
								src.step_y = m.step_y
								var/list/items = list()
								for(var/obj/items/x in orange(4,m))
									if(x.bolted == 0) if(x.bolted != 5)
										if(get_dist(x,m) == 3)
											//x.tk_pos = pick(m.tk_spaces)
											//m.tk_spaces -= x.tk_pos
											//x.tk_pos = text2num(x.tk_pos)
											m.tk_minigame += x
											x.tk = 1
											x.bolted = 5
											x.density_factor = 0
											animate(x, pixel_z = 16, time = 1)
											var/obj/effects/dust_medium/d = new
											d.pixel_x -= 10
											d.loc = x.loc
											d.step_x = x.step_x
											d.step_y = x.step_y
											items += x
											sleep(2)
								sleep(1)
								for(var/obj/i in items)
									var/d = m.GetAngle(i.loc)
									var/turf/t = orbit_pos(m,i,96,d)
									while(i.loc != t)
										i.MoveAngInstant(d,6,1,0,t)
										sleep(1)
									//world << "angle is [d]"
									orbiting(i,m, 6,96,d)
									//orbiting(i,m,6,96,i.tk_pos)
						sleep(spd)
					*/
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					//var/clear = 0
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"] || m.mouse_dir == "right")
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)

					if(dir == "right")
					//	m << "This minigame is being re-designed."
						src.tk_mini = 1
						m.tk_spaces = list("45","90","135","180","225","270","315","360")
						m.tk_minigame = list()
						return




						/*
						if(src.active) if(usr.minigame == null)
							m.minigame = "tk"
							var/turf/right = locate(m.x+src.spin_size,m.y,m.z)
							var/turf/left = locate(m.x-src.spin_size,m.y,m.z)
							var/turf/up = locate(m.x,m.y+src.spin_size,m.z)
							var/turf/down = locate(m.x,m.y-src.spin_size,m.z)
							src.positions = list(right,left,up,down)
							var/L = length(m.tk_minigame)
							for(var/obj/hud/minigames/H in src)
								m.client.screen += H
							if(L != 4)
								for(var/obj/items/I in orange(6,m))
									if(!m.tk_minigame.Find(I)) if(L != 4) if(I.bolted == 0) if(I.pos == null)
										m.tk_minigame.Add(I)
										L = length(m.tk_minigame)
										I.density_factor = 0
										I.tk = 1
										I.SetOrbitRadius(src.spin_size)
										var/turf/T = pick(src.positions)
										I.pos = T
										src.positions -= T
										I.dir = EAST
										if(I.pixel_z < 8)
											animate(I, pixel_z = 8, time = 2)
							else
								clear = 1
						else
							clear = 1
					if(clear)
						src.spin_speed = 4
						m.clear_minigame_tk()*/

		Conceive_Offspring
			icon_state = "Conceive"
			info_energy_cost = 0
			info_mastery = 0
			info_point_cost = 1
			can_teach = 0
			info_point_cost_type = "energy"
			info_buffs = "Conceive and genetically merge offspring"
			info_duration = "Instant"
			info_name = "Conceive Offspring"
			info_stats = "Combines traits, mods, and power of two consenting parents to create offspring data.\nRequires target in front."
			teach_energy = 2000
			hud_x = 560
			hud_y = 520
			category = list("Genetic","Utility")
			act = /obj/skills/Conceive_Offspring/proc/activate

			proc/activate(var/mob/races/m, var/obj/s)
				if(!(s in m)) return
				if(m.koed || m.dead) return
				if(m.gen == "Neuter")

					if(m.child_slots <= 0)
						m << "You do not have any more child slots!"
						return

					if(m.age < 18)
						m << "You are too young to conceive offspring."
						return

					m << "You begin asexual reproduction..."

					var/password_choice = input(m, "Would you like this offspring to have a password?") in list("Yes","No")
					var/child_password = null

					if(password_choice == "Yes")
						child_password = input(m, "Enter offspring password:") as text

					var/child_name = input(m, "Enter a name for your offspring:") as text
					if(!child_name || child_name == "")
						m << "Invalid name."
						return

					if(alert(m, "Confirm creation of offspring named [child_name]?", "Confirm", "Yes","No") == "No")
						m << "Conception canceled."
						return
					// === Create Profile ===
					var/datum/offspring_profile/O = new
					O.name = child_name
					O.real_name = child_name
					O.password = child_password

					O.gen = pick("Male", "Female","Neuter")
					O.Father = "[m.name]"
					O.Mother = "[m.name]"
					O.conceived_by = list("[m.key]")
					O.spawn_point = get_turf(m)

					// --- Core inheritance ---
					var/mob/stronger = m
					var/mob/weaker   = m
					O.PG = (stronger.PG * 0.125) + (weaker.PG * 0.3)
					O.generation_lvl = (stronger.generation_lvl + 1)
					O.race = stronger.race
					if(stronger.recessive_race) O.recessive_race = stronger.recessive_race
					if(stronger.recessive_race)
						switch(stronger.recessive_race)
							if("Alien")
								O.alien_dna += (100/O.generation_lvl)
							if("Makyo")
								O.makyo_dna += (100/O.generation_lvl)
							if("Tuffle")
								O.tuffle_dna += (100/O.generation_lvl)
							if("Demon")
								O.demon_dna += (100/O.generation_lvl)
							if("Kai")
								O.kai_dna += (100/O.generation_lvl)
							if("Spirit Doll")
								O.spirit_doll_dna += (100/O.generation_lvl)
							if("Oni")
								O.oni_dna += (100/O.generation_lvl)
							if("Changeling")
								O.changeling_dna += (100/O.generation_lvl)
							if("Saiyan")
								O.saiyan_dna += (100/O.generation_lvl)
							if("Namekian")
								O.namekian_dna += (100/O.generation_lvl)

					switch(stronger.race)
						if("Alien")
							O.alien_dna += (100/O.generation_lvl)
						if("Makyo")
							O.makyo_dna += (100/O.generation_lvl)
						if("Tuffle")
							O.tuffle_dna += (100/O.generation_lvl)
						if("Demon")
							O.demon_dna += (100/O.generation_lvl)
						if("Kai")
							O.kai_dna += (100/O.generation_lvl)
						if("Spirit Doll")
							O.spirit_doll_dna += (100/O.generation_lvl)
						if("Oni")
							O.oni_dna += (100/O.generation_lvl)
						if("Changeling")
							O.changeling_dna += (100/O.generation_lvl)
						if("Saiyan")
							O.saiyan_dna += (100/O.generation_lvl)
						if("Namekian")
							O.namekian_dna += (100/O.generation_lvl)
					// --- Specific stat inheritance ---
					// Only take the genetic core modifiers
					O.mod_strength     = (stronger.mod_strength     * 0.75) + (weaker.mod_strength     * 0.1)
					O.mod_energy       = (stronger.mod_energy       * 0.75) + (weaker.mod_energy       * 0.1)
					O.mod_agility      = (stronger.mod_agility      * 0.75) + (weaker.mod_agility      * 0.1)
					O.mod_endurance    = (stronger.mod_endurance    * 0.75) + (weaker.mod_endurance    * 0.1)
					O.mod_defence      = (stronger.mod_defence      * 0.75) + (weaker.mod_defence      * 0.1)
					O.mod_force        = (stronger.mod_force        * 0.75) + (weaker.mod_force        * 0.1)
					O.mod_recovery     = (stronger.mod_recovery     * 0.75) + (weaker.mod_recovery     * 0.1)
					O.mod_regeneration = (stronger.mod_regeneration * 0.75) + (weaker.mod_regeneration * 0.1)
					O.mod_resistance   = (stronger.mod_resistance   * 0.75) + (weaker.mod_resistance   * 0.1)
					if(m.race == "Changeling")
						O.mod_psionic_power = (stronger.mod_psionic_power   * 0.15) + (weaker.mod_psionic_power   * 0.15)
						O.mod_psionic_power_base = (stronger.mod_psionic_power_base   * 0.1) + (weaker.mod_psionic_power_base   * 0.15)
					else
						O.mod_psionic_power = (stronger.mod_psionic_power   * 0.5) + (weaker.mod_psionic_power   * 0.3)
						O.mod_psionic_power_base = (stronger.mod_psionic_power_base   * 0.5) + (weaker.mod_psionic_power_base   * 0.3)


					// == CORE STATS

					O.resistance    = max(stronger.resistance    * 0.10, 1)
					O.force         = max(stronger.force    * 0.10, 1)
					O.offence       = max(stronger.offence       * 0.10, 1)
					O.defence       = max(stronger.defence       * 0.10, 1)
					O.mod_agility   = max(stronger.mod_agility   * 0.50 + (weaker.mod_agility * 0.3),  1)
					O.psionic_power = max(stronger.psionic_power * 0.75,  1)
					O.energy_max    = max(stronger.energy_max    * 0.25 + (weaker.energy_max * 0.3), 1)
					O.gains_trained_energy = max(stronger.gains_trained_energy    * 0.25, 1)

					// --- Appearance ---

					if(O.race!="Changeling") O.hair_c   = m.hair_c
					O.eye_c    = m.eye_c

					if(O.race!="Changeling") O.hair_pos = pick(1, 2, 3)
					O.mouth_pos = m.mouth_pos
					O.nose_pos = m.nose_pos
					O.eye_pos = m.eye_pos
					O.body_pos = m.body_pos
					O.bodysize = m.bodysize

					if(O.gen == "Male")
						if(m.gen == "Male")
							O.skin_pos = m.skin_pos
					else if(O.gen == "Female")
						if(m.gen == "Female")
							O.skin_pos = m.skin_pos
					if(!O.skin_pos)
						O.skin_pos = 1
						//O.skin_pos = pick(m.skin_pos, target.skin_pos)
					O.planet_spawn = m.z  // optional tracking of parent world

					// --- Mutations ---
					O.mutation_types = list()
					new /mutations()
					var/list/MutationList = list()
					// Build the mutation list once to avoid redundancy
					switch(rand(1,5))
						if(1)
							for(var/mutation in stronger.mutations)
								O.mutation_types += mutation
						if(2)

							for(var/mutation in weaker.mutations)
								O.mutation_types += mutation
						if(3)
							for(var/mutation in weaker.mutations)
								O.mutation_types += mutation
							for (var/A in typesof(/mutations/))
								if (A != /mutations)  // Only add valid mutations, exclude the base type
									MutationList += A
							var/mutations/MutationType2 = pick(MutationList)
							if (MutationType2)
								var/mutations/MutationInstance2 = new MutationType2(O) // Create second mutation
								O.mutation_types += MutationInstance2 // Add second mutation to target's mutations list

						if(4)
							for(var/mutation in stronger.mutations)
								O.mutation_types += mutation
							for (var/A in typesof(/mutations/))
								if (A != /mutations)  // Only add valid mutations, exclude the base type
									MutationList += A
							var/mutations/MutationType2 = pick(MutationList)
							if (MutationType2)
								var/mutations/MutationInstance2 = new MutationType2(O) // Create second mutation
								O.mutation_types += MutationInstance2 // Add second mutation to target's mutations list
						if(5)
							for(var/mutation in stronger.mutations)
								O.mutation_types += mutation

						if(6)
							for(var/mutation in stronger.mutations)
								O.mutation_types += mutation
						if(7)
							for(var/mutation in weaker.mutations)
								O.mutation_types += mutation
					// Save in global offspring list
					ActiveChildren += O
					m.child_slots -=1
					if(!child_password) m << "You have conceived [child_name]."
					else if(child_password) m << "You have conceived [child_name]. <b>Password: [child_password]</b>\nSave your password safe!"

				else

					if(m.child_slots <=0)
						m << "You do not have any more child slots!"
						return
					if(m.age < 18)
						m << "You are too young to conceive offspring."
						return
					var/list/playerstomate = list()
					for(var/mob/races/M in oview(1, m))
						if(M.client) // only real players
							playerstomate += M

					var/mob/races/target = input("Select someone to mate with:") \
					    as null|anything in playerstomate
					//var/mob/target = input("Select a player to mate with:") as null|mob in oview(1,m)
					//var/mob/target = get_step(m, m.dir)
					if(!istype(target, /mob/))
						if(!target.client)
							m << "No valid partner detected in front of you."
							return
					if(!target.client)
						return
					if(target.age < 18)
						m << "[target] is too young."
						return

					if(target == m)
						m << "You cannot mate with yourself."
						return

					// Hardcoded exclusions
					if((m.race == "Changeling" && target.race != "Alien") || (target.race == "Changeling" && m.race != "Alien"))
						m << "You cannot mate with their kind."
						return

					if((m.race == "Demon" && target.race == "Kai") || (m.race == "Kai" && target.race == "Demon"))
						m << "You cannot mate with their kind."
						return

					// General natural compatibility rules
					var/list/disallowed_race_pairs = list(
						"Saiyan" = list("Namekian","Alien","Makyo","Spirit Doll","Demon","Oni","Kai"),
						"Namekian" = list("Saiyan","Spirit Doll","Human","Tuffle"),
						"Alien" = list("Demon","Kai","Saiyan","Makyo","Oni","Human","Tuffle"),
						"Oni" = list("Saiyan","Human","Spirit Doll","Makyo","Tuffle","Alien"),
						"Demon" = list("Human","Saiyan","Spirit Doll","Tuffle","Alien"),
						"Kai" = list("Saiyan","Human","Spirit Doll","Tuffle","Makyo","Alien"),
						"Makyo" = list("Spirit Doll","Human","Saiyan","Namekian","Tuffle","Alien"),
						"Human" = list("Alien","Makyo","Demon","Kai","Namekian","Oni")
					)

					var/list/disallowed_for_m = disallowed_race_pairs[m.race]
					if(disallowed_for_m && target.race in disallowed_for_m)
						m << "You cannot naturally mate with their kind."
						return

					if(target.koed || target.dead)
						m << "They are unconscious or dead."
						return

					// Request consent
					switch(input(target, "[m] wishes to conceive an offspring with you. Do you accept?") in list("Yes","No"))
						if("No")
							m << "[target] has declined."
							return
						if("Yes")
							m << "[target] accepted. Preparing conception sequence..."

					// Password and name setup
					var/password_choice = input(m, "Would you like this offspring to have a password?") in list("Yes", "No")
					var/child_password = null
					if(password_choice == "Yes")
						child_password = input(m, "Enter offspring password:") as text

					var/child_name = input(m, "Enter a name for your offspring:") as text
					if(!child_name || child_name == "")
						m << "Invalid name."
						return

					// Confirmation
					if(alert(m, "Confirm conception of offspring named [child_name]?", "Confirm", "Yes", "No") == "No")
						m << "Conception canceled."
						return

					// === Create Profile ===
					var/datum/offspring_profile/O = new
					O.name = child_name
					O.real_name = child_name
					O.password = child_password

					O.gen = pick("Male", "Female")
					O.Father = (m.gen == "Male" ? "[m.name]" : "[target.name]")
					O.Mother = (m.gen == "Female" ? "[m.name]" : "[target.name]")
					O.conceived_by = list("[m.key]", "[target.key]")
					O.spawn_point = get_turf(m)

					// --- Core inheritance ---
					var/mob/stronger = (m.PG >= target.PG) ? m : target
					var/mob/weaker   = (m.PG >= target.PG) ? target : m
					O.PG = (stronger.PG * 0.3) + (weaker.PG * 0.3)
					O.generation_lvl = (stronger.generation_lvl + 1)
					O.race = stronger.race
					if(weaker.race != stronger.race ) O.recessive_race = weaker.race
					switch(weaker.race)
						if("Alien")
							O.alien_dna += (100/O.generation_lvl)
						if("Makyo")
							O.makyo_dna += (100/O.generation_lvl)
						if("Tuffle")
							O.tuffle_dna += (100/O.generation_lvl)
						if("Demon")
							O.demon_dna += (100/O.generation_lvl)
						if("Kai")
							O.kai_dna += (100/O.generation_lvl)
						if("Spirit Doll")
							O.spirit_doll_dna += (100/O.generation_lvl)
						if("Oni")
							O.oni_dna += (100/O.generation_lvl)
						if("Changeling")
							O.changeling_dna += (100/O.generation_lvl)
						if("Saiyan")
							O.saiyan_dna += (100/O.generation_lvl)
						if("Namekian")
							O.namekian_dna += (100/O.generation_lvl)

					switch(stronger.race)
						if("Alien")
							O.alien_dna += (100/O.generation_lvl)
						if("Makyo")
							O.makyo_dna += (100/O.generation_lvl)
						if("Tuffle")
							O.tuffle_dna += (100/O.generation_lvl)
						if("Demon")
							O.demon_dna += (100/O.generation_lvl)
						if("Kai")
							O.kai_dna += (100/O.generation_lvl)
						if("Spirit Doll")
							O.spirit_doll_dna += (100/O.generation_lvl)
						if("Oni")
							O.oni_dna += (100/O.generation_lvl)
						if("Changeling")
							O.changeling_dna += (100/O.generation_lvl)
						if("Saiyan")
							O.saiyan_dna += (100/O.generation_lvl)
						if("Namekian")
							O.namekian_dna += (100/O.generation_lvl)

					// --- Specific stat inheritance ---
					// Only take the genetic core modifiers
					O.mod_strength     = (stronger.mod_strength     * 0.75) + (weaker.mod_strength     * 0.3)
					O.mod_energy       = (stronger.mod_energy       * 0.75) + (weaker.mod_energy       * 0.3)
					O.mod_agility      = (stronger.mod_agility      * 0.75) + (weaker.mod_agility      * 0.3)
					O.mod_endurance    = (stronger.mod_endurance    * 0.75) + (weaker.mod_endurance    * 0.3)
					O.mod_defence      = (stronger.mod_defence      * 0.75) + (weaker.mod_defence      * 0.3)
					O.mod_force        = (stronger.mod_force        * 0.75) + (weaker.mod_force        * 0.3)
					O.mod_recovery     = (stronger.mod_recovery     * 0.75) + (weaker.mod_recovery     * 0.3)
					O.mod_regeneration = (stronger.mod_regeneration * 0.75) + (weaker.mod_regeneration * 0.3)
					O.mod_resistance   = (stronger.mod_resistance   * 0.75) + (weaker.mod_resistance   * 0.3)
					if(target.race == "Changeling" || m.race == "Changeling")
						O.mod_psionic_power = (stronger.mod_psionic_power   * 0.25) + (weaker.mod_psionic_power   * 0.15)
						O.mod_psionic_power_base = (stronger.mod_psionic_power_base   * 0.25) + (weaker.mod_psionic_power_base   * 0.15)
					else
						O.mod_psionic_power = (stronger.mod_psionic_power   * 0.75) + (weaker.mod_psionic_power   * 0.3)
						O.mod_psionic_power_base = (stronger.mod_psionic_power_base   * 0.75) + (weaker.mod_psionic_power_base   * 0.3)


					// == CORE STATS

					O.resistance    = max(stronger.resistance    * 0.10, 1)
					O.force         = max(stronger.force    * 0.10, 1)
					O.offence       = max(stronger.offence       * 0.10, 1)
					O.defence       = max(stronger.defence       * 0.10, 1)
					O.mod_agility   = max(stronger.mod_agility   * 0.50 + (weaker.mod_agility * 0.3),  1)
					O.psionic_power = max(stronger.psionic_power * 0.75,  1)
					O.energy_max    = max(stronger.energy_max    * 0.25 + (weaker.energy_max * 0.3), 1)
					O.gains_trained_energy = max(stronger.gains_trained_energy    * 0.25, 1)

					// --- Appearance ---

					if(O.race!="Changeling") O.hair_c   = pick(m.hair_c, target.hair_c)
					O.eye_c    = pick(m.eye_c, target.eye_c)

					if(O.race!="Changeling") O.hair_pos = pick(1, 2, 3)
					O.mouth_pos = pick(m.mouth_pos,target.mouth_pos)
					O.nose_pos = pick(m.nose_pos,target.nose_pos)
					O.eye_pos = pick(m.eye_pos,target.eye_pos)
					O.body_pos = pick(m.body_pos,target.body_pos)
					O.bodysize = pick(m.bodysize,target.bodysize)

					if(O.gen == "Male")
						if(target.gen == "Male")
							O.skin_pos = target.skin_pos
						else if(m.gen == "Male")
							O.skin_pos = m.skin_pos
					else if(O.gen == "Female")
						if(target.gen == "Female")
							O.skin_pos = target.skin_pos
						else if(m.gen == "Female")
							O.skin_pos = m.skin_pos
					if(!O.skin_pos)
						O.skin_pos = 1
						//O.skin_pos = pick(m.skin_pos, target.skin_pos)
					O.planet_spawn = m.z  // optional tracking of parent world

					// --- Mutations ---
					O.mutation_types = list()
					new /mutations()
					var/list/MutationList = list()
					// Build the mutation list once to avoid redundancy
					switch(rand(1,5))
						if(1)
							for(var/mutation in stronger.mutations)
								O.mutation_types += mutation
						if(2)

							for(var/mutation in weaker.mutations)
								O.mutation_types += mutation
						if(3)
							for(var/mutation in weaker.mutations)
								O.mutation_types += mutation
							for (var/A in typesof(/mutations/))
								if (A != /mutations)  // Only add valid mutations, exclude the base type
									MutationList += A
							var/mutations/MutationType2 = pick(MutationList)
							if (MutationType2)
								var/mutations/MutationInstance2 = new MutationType2(O) // Create second mutation
								O.mutation_types += MutationInstance2 // Add second mutation to target's mutations list

						if(4)
							for(var/mutation in stronger.mutations)
								O.mutation_types += mutation
							for (var/A in typesof(/mutations/))
								if (A != /mutations)  // Only add valid mutations, exclude the base type
									MutationList += A
							var/mutations/MutationType2 = pick(MutationList)
							if (MutationType2)
								var/mutations/MutationInstance2 = new MutationType2(O) // Create second mutation
								O.mutation_types += MutationInstance2 // Add second mutation to target's mutations list
						if(5)
							for(var/mutation in stronger.mutations)
								O.mutation_types += mutation
							for(var/mutation in weaker.mutations)
								O.mutation_types += mutation
						if(6)
							for(var/mutation in stronger.mutations)
								O.mutation_types += mutation
						if(7)
							for(var/mutation in weaker.mutations)
								O.mutation_types += mutation

					// Save in global offspring list
					ActiveChildren += O
					m.child_slots -=1
					if(!child_password) m << "You and [target] have conceived [child_name]."
					else if(child_password) m << "You and [target] have conceived [child_name]. <b>Password: [child_password]</b>\nSave your password safe!"


				var/savefile/F = new("saves/ChildrenandAndroids/ActiveChildren.sav")
				F["ActiveChildren"] << ActiveChildren
				return

			New()
				..()
				spawn(10)
					if(src)
						src.info = "Allows the merging of two beings' genetic data to create a new offspring template.\nRequires both parties to consent."
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"] || m.mouse_dir == "right")
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
					if(dir == "left")
						return

		Telepathy
			icon_state = "Sense off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 1
			info_buffs = "Instant communication"
			info_duration = "Toggleable"
			info_point_cost_type = "energy"
			info_name = "telepathy"
			teach_energy = 1000
			act = /obj/skills/Telepathy/proc/activate
			info_prerequisite = list("Sense")
			info_stats = "Instant communication\n\nNot usable on dead or sleeping"
			hud_x = 341
			hud_y = 588

			proc
				activate(var/mob/m,var/obj/s)
					if(s in m)
						if(m.skill_telepathy == null) m.skill_telepathy = s
						m.left_click_function = "telepath"
						winshow(m,"skills",0)
						m.open_skills = 0
						m.open_menus.Remove(".open_skills")
						m << output("Select someone to telepath by either clicking them directly, or their name in your contacts list.", "chat.system")
						m.set_alert("Select contact to telepath",s.icon,s.icon_state)
						//m.skill_ref = s
			New()
				..()
				category = list("Energy","Utility")
				spawn(10)
					if(src)
						src.info = text_telekinesis


						if(ismob(src.loc))
							var/mob/m = src.loc
							m.skill_telepathy = src
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"] || m.mouse_dir == "right")
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
					if(dir == "left")
						return
		Pyrokinesis
			icon_state = "Pyrokinesis off"
			act = /obj/skills/Pyrokinesis/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						s.active = 0
					else
						s.icon_state = "Pyrokinesis"
						s.active = 1
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		/*Destructo_Disk
			name = "Destructo Disk"
			icon_state = "destructo disk off"
			disabled_switch = 1;
			act = /obj/skills/Destructo_Disk/proc/activate
			info_energy_cost = 2
			info_dmg = 2
			info_spd = 5
			info_mastery = 2
			info_point_cost = 3
			info_point_cost_type = "force"
			info_name = "destructo_disk"
			info_prerequisite = list("Blast")
			info_stats = "Energy Cost: Medium\n\nDamage: Medium\n\nSpeed: Medium\n\nMastery: Medium\n\nToggleable\n\nChargeable"
			info = "Gather, condense and form psionic power into a deadly ball before unleashing the pent up force. You can charge this skill by holding the left mouse button. Releasing the button will fire the skill. Charge time is quicker the higher your Recovery stat is."
			energy_skill = 1
			teach_energy = 600
			attack_state = "beam"
			cd_max = 200
			act = /obj/skills/Destructo_Disk/proc/activate
			var/tmp/shotforsound = 0
			hud_x = 212
			hud_y = 588
			New()
				..()
				category = list("Force","Offence")
				src.info = text_destructo_disk
			proc
				activate(var/mob/m)
					if(src in m)
						if(m.active_attack) return
						if(m.koed || m.stunned || m.meditating) return
						if(m.can_ki == 0) return
						if(m.energy <= 10) return
						if(src.cd_state < 32)
							m << output("<font color = teal>Skill is on cooldown, please wait.","chat.system")
							//var/is = src.icon_state
							src.icon_state = "cd"
							spawn(3)
								if(src) src.icon_state = "destructo disk"
							return
						var/obj/ranged/disk_charge/b = new /obj/ranged/disk_charge
						b.plane=1
						b.icon = 'DestructoDisk.dmi'
						b.icon_state="disk"
						b.icon *= m.auracolor
						b.ki_owner = m
						var/obj/ray = new
						ray.bolted = 2
						ray.icon = 'fx_ray.dmi'
						ray.icon *= m.auracolor
						ray.pixel_x = -144
						ray.pixel_y = -144
						ray.filters += filter(type="rays",x=0,y=0,size=96,color=rgb(255,255,255),offset=0,density=10,threshold=0.7,factor=0,flags=FILTER_OVERLAY)
						//animate(ray.filters[1],offset = 100,time = 1000, loop = -1)
						animate(ray.filters[1],offset = 100,time = 200, loop = -1)
						animate(offset = 0,time = 0)

						m.active_attack = b
						m.icon_state = m.state()
						m.can_ki = 0
						var/charge_check = 1;
						var/too_close = 0
						var/turf/t = null
						src.cd_max = (initial(src.cd_max)/m.mod_agility)/(1+src.skill_lvl/100)
						m.skill_cooldown(src)
						var/sound/S = sound('disc_fire.ogg')
						S.channel = 5 // Any number from 1-99
						S.volume = 100
						S.repeat = 0 // Make sure it's not loopin
						while(m)
							set background = 1
							var/di = 0
							//If the charge ball exists, move it relative to player mouse position and continue with the rest of the code.
							if(b && b.expired == 0)
								var/e = ((1/m.mod_recovery)+(1/src.skill_lvl)*b.charge_lvl)

								if(b.fired == 0)
									//src.skill_exp += (1/src.skill_lvl)*m.mod_skill
									if(!isturf(m.mouse_saved_loc) || m.mouse_saved_loc.z != m.z)
										m.active_attack = null
										return
									src.skill_exp += ((0.1-(src.skill_lvl/1000))*m.mod_skill)+0.1
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)
									b.loc = m.loc
									m.dir = get_dir(m,m.mouse_saved_loc)
									m.wings()
									di = b.GetAngleStep(m.mouse_saved_loc)//m.mouse_degree//m.GetAngleStep(m.mouse_saved_loc)
									b.step_x = m.step_x
									b.step_y = m.step_y
									t = get_step(m,m.dir)
									too_close = 0
									if(t)
										if(t.density || t.density_factor == 2) too_close = 1
									if(too_close == 0) b.MoveAng(di,b.pix_away,0,0,null)
									b.ki_power = (m.psionic_power*0.75)
									b.ki_force = ((m.force*0.5)*b.charge_lvl)
									b.force_usage = m.mod_force_usage
									b.ki_offence = m.offence
									b.ki_agility = m.mod_agility

									ray.loc = m.loc
									ray.step_x = m.step_x
									ray.step_y = m.step_y
									ray.MoveAng(di,b.pix_away,0,0,null)

									//If the attack was canceled, or the player ran out of energy during charging or firing, force the attack to shrink and vanish.
									if(m.active_attack == null)
										if(b.finishing == 0)
											m.icon_state = m.state()
											//m.can_ki = 1
											var/matrix/M = matrix()
											M.Scale(0,0)
											animate(b,transform = M,time = 10)
											b.finishing = 1
											spawn(10)
												if(b)
													b.expired = 1
													b.destroy() //del(b)
												if(ray) ray.loc = null
												if(m) m.can_ki = 1
									//Continue to fire or charge the attack.
								if(m.mouse_down)
									if(b.just_started)
										b.shockwave()
										b.just_started = 0
									//Make the ball bigger and the charge lvl higher if players charged ball wasn't canceled for any reason.
									if(b.finishing == 0)
										if(b.size < 1)
											//Charge increase and displays charge lvl
											b.charge_lvl += 0.01*m.mod_recovery
											var/charge_rounded = round(b.charge_lvl)
											if(charge_rounded > charge_check)
												charge_check = charge_rounded
											//	m.charge_nums("<font color = green>x[charge_check]")
											//m << output("Charge lvl is [b.charge_lvl]", "chat.system")
											m.energy-=e
											b.size += 0.001*m.mod_recovery
											if(b.size > 1) b.size = 1
											var/matrix/M = matrix()
											M.Scale(b.size,b.size)
											b.transform = M
											b.pix_away += 0.07*m.mod_recovery
											if(b.pix_away >= 80) b.pix_away = 80
											//Create cool gathering energy effect
											if(prob(1))
												var/obj/orb = null
												//if(b.icon_state == "psionic") orb = new /obj/effects/orb
												//else if(b.icon_state == "divine") orb = new /obj/effects/orb_divine
												orb = new /obj/effects/orb
												orb.icon *= m.auracolor
												orb.loc = b.loc
												orb.step_x = b.step_x
												orb.step_y = b.step_y
												orb.pixel_x = rand(-64,64)
												orb.pixel_y = rand(-64,64)
												animate(orb,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
												spawn(10)
													if(orb) orb.loc = null//del(o)
												/*
												for(var/obj/o in orbs)
													if(o.loc == null)
														o.alpha = 255;
														o.loc = b.loc
														o.step_x = b.step_x
														o.step_y = b.step_y
														o.pixel_x = rand(-32-b.pix_away,32+b.pix_away)
														o.pixel_y = rand(-32-b.pix_away,32+b.pix_away)
														animate(o,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
														spawn(10)
															if(o) o.loc = null
														break
												*/
								else if(b.fired == 0 && m.active_attack)
									di = m.GetAngleStep(m.mouse_saved_loc)//b.GetAngleStep(m.mouse_saved_loc)
									b.ang = di
									b.fired = 1
									b.travel = 40
									b.explode_impact = 1
									b.go()
									m.gain_stat("force",1,(m.mod_force*0.095),"From Destructo Disk skill")
									m.active_attack = null
									m.icon_state = m.state()
									var/time = 7/m.mod_agility
									if(time < 1) time = 1
									spawn(time)
										if(m) m.can_ki = 1
									ray.loc = null
									//view(8,src)<<S
									if(src.shotforsound==0) src.shotforsound = 1
									return
								//If the player doesn't have enough energy while firing or charging, force the ball and beams to shrink and vanish.
								if(m.energy <= 1) m.active_attack = null
								if(m.koed || m.stunned || m.meditating) m.active_attack = null
							else
								m.active_attack = null
								return
							if(src.shotforsound)
								view(8,src)<<S
								src.shotforsound = 0
							sleep(0.1)

			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(src.active)
								src.active = 0
								src.icon_state = "destructo disk off"
								if(src == m.current_attack) m.current_attack = null
								m.stop_charging()
								if(src.shotforsound == 1) src.shotforsound = 0
							else
								src.icon_state = "destructo disk"
								src.active = 1
								m.current_attack = src;
								m.toggle_skill(src)*/
		Razor_Disk
			name = "Razor Disk"
			icon_state = "Charge off"
			repeat = 1;
			disabled_switch = 1;
			//act = /obj/skills/Razor_Disk/proc/activate
			info_energy_cost = 4
			info_dmg = 4
			info_spd = 1
			info_mastery = 1
			info_point_cost = 6
			info_point_cost_type = "force"
			info_name = "razor_disk"
			info_prerequisite = list("Charged Blast")
			disabled_switch = 1
			energy_skill = 1
			var
				tmp/obj/fly = null
			New()
				..()
				category = list("Force","Offence")
			Click(location,control,params)
				..()
				return
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(src.active)
								src.active = 0
								src.icon_state = "Charge off"
								if(src == m.current_attack) m.current_attack = null
								m.stop_charging()
							else
								src.icon_state = "Charge"
								src.active = 1
								m.current_attack = src;
								m.toggle_skill(src)
		Charge
			name = "Charged Blast"
			icon_state = "charge blast off"
			disabled_switch = 1;
			act = /obj/skills/Charge/proc/activate
			info_energy_cost = 2
			info_dmg = 2
			info_spd = 2
			info_mastery = 2
			info_point_cost = 3
			info_point_cost_type = "force"
			info_name = "charged_blast"
			info_prerequisite = list("Blast")
			info_stats = "Energy Cost: Medium\n\nDamage: Medium\n\nSpeed: Medium\n\nMastery: Medium\n\nToggleable\n\nChargeable"
			info = "Gather, condense and form psionic power into a deadly ball before unleashing the pent up force. You can charge this skill by holding the left mouse button. Releasing the button will fire the skill. Charge time is quicker the higher your Recovery stat is."
			energy_skill = 1
			teach_energy = 600
			attack_state = "beam"
			cd_max = 200
			act = /obj/skills/Charge/proc/activate
			hud_x = 212
			hud_y = 588
			var/tmp/last_gain_time = 0
			var/tmp/shotforsound = 0
			var/gain_cd = 25  // cooldown in ticks (2.5 seconds)

			New()
				..()
				category = list("Force","Offence")
			proc
				activate(var/mob/m)
					if(src in m)
						if(m.active_attack) return
						if(m.koed || m.stunned || m.meditating || m.selftraining) return
						if(m.can_ki == 0) return
						if(m.energy <= 10) return
						if(src.cd_state < 32)
							m << output("<font color = teal>Skill is on cooldown, please wait.","chat.system")
							//var/is = src.icon_state
							src.icon_state = "cd"
							spawn(3)
								if(src) src.icon_state = "charge blast"
							return
						var/obj/ranged/beam_charge/b = new
						for(var/obj/body_related/ascension_milestones/a in m.ascensions)
							if(a.major_ascension && a.icon_state == "ascension" && a.level > 0)
								b.icon_state = "divine"
								b.plane = 2
								break
							else
								b.icon_state = "psionic"
								b.plane = 1
						b.ki_owner = m
						b.icon *= m.auracolor
						var/obj/ray = new
						ray.bolted = 2
						ray.icon = 'fx_ray.dmi'
						ray.icon *= m.auracolor
						ray.pixel_x = -144
						ray.pixel_y = -144
						ray.filters += filter(type="rays",x=0,y=0,size=96,color=rgb(255,255,255),offset=0,density=10,threshold=0.7,factor=0,flags=FILTER_OVERLAY)
						animate(ray.filters[1],offset = 100,time = 1000, loop = -1)
						animate(offset = 0,time = 0)

						m.active_attack = b
						m.icon_state = m.state()
						m.can_ki = 0
						var/charge_check = 1;
						var/too_close = 0
						var/turf/t = null
						src.cd_max = (initial(src.cd_max)/m.mod_agility)/(1+src.skill_lvl/100)
						m.skill_cooldown(src)
						var/sound/S = sound('Modules/core/sound/sound files/Xia SFX v0.1/Charge_Fire.wav')
						S.channel = 5 // Any number from 1-99
						S.volume = 100
						S.repeat = 0 // Make sure it's not loopin
						while(m)
							set background = 1
							var/di = 0
							//If the charge ball exists, move it relative to player mouse position and continue with the rest of the code.
							if(b && b.expired == 0)
								var/e = ((1/m.mod_recovery)+(1/src.skill_lvl)*b.charge_lvl)
								if(b.fired == 0)
									if(!isturf(m.mouse_saved_loc) || m.mouse_saved_loc.z != m.z)
										m.active_attack = null
										continue
									//src.skill_exp += (1/src.skill_lvl)*m.mod_skill
									src.skill_exp += ((0.1-(src.skill_lvl/1000))*m.mod_skill)+0.1
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)
									b.loc = m.loc
									m.dir = get_dir(m,m.mouse_saved_loc)
									m.wings()
									di = m.GetAngleStep(m.mouse_saved_loc)//m.mouse_degree//m.GetAngleStep(m.mouse_saved_loc)
									b.step_x = m.step_x
									b.step_y = m.step_y
									t = get_step(m,m.dir)
									too_close = 0
									if(t)
										if(t.density || t.density_factor == 2) too_close = 1
									if(too_close == 0) b.MoveAng(di,b.pix_away,0,0,null)
									b.ki_power = m.psionic_power
									b.ki_force = ((m.force*0.75)*b.charge_lvl)
									b.force_usage = m.mod_force_usage
									b.ki_offence = m.offence
									b.ki_agility = m.mod_agility

									ray.loc = m.loc
									ray.step_x = m.step_x
									ray.step_y = m.step_y
									ray.MoveAng(di,b.pix_away,0,0,null)

									//If the attack was canceled, or the player ran out of energy during charging or firing, force the attack to shrink and vanish.
									if(m.active_attack == null)
										if(b.finishing == 0)
											m.icon_state = m.state()
											//m.can_ki = 1
											var/matrix/M = matrix()
											M.Scale(0,0)
											animate(b,transform = M,time = 10)
											b.finishing = 1
											spawn(10)
												if(b)
													b.expired = 1
													b.destroy() //del(b)
												if(ray) ray.loc = null
												if(m) m.can_ki = 1
									//Continue to fire or charge the attack.
								if(m.mouse_down)
									if(b.just_started)
										b.shockwave()
										b.just_started = 0
									//Make the ball bigger and the charge lvl higher if players charged ball wasn't canceled for any reason.
									if(b.finishing == 0)
										if(b.size < 1)
											//Charge increase and displays charge lvl
											b.charge_lvl += 0.01*m.mod_recovery
											var/charge_rounded = round(b.charge_lvl)
											if(charge_rounded > charge_check)
												charge_check = charge_rounded
												//m.charge_nums("<font color = green>x[charge_check]")
											//m << output("Charge lvl is [b.charge_lvl]", "chat.system")
											m.energy-=e
											b.size += 0.001*m.mod_recovery
											if(b.size > 1) b.size = 1
											var/matrix/M = matrix()
											M.Scale(b.size,b.size)
											b.transform = M
											b.pix_away += 0.07*m.mod_recovery
											if(b.pix_away >= 80) b.pix_away = 80
											//Create cool gathering energy effect
											if(prob(1))
												var/obj/orb = null
												if(b.icon_state == "psionic") orb = new /obj/effects/orb
												else if(b.icon_state == "divine") orb = new /obj/effects/orb_divine
												orb.loc = b.loc
												orb.step_x = b.step_x
												orb.step_y = b.step_y
												orb.pixel_x = rand(-64,64)
												orb.pixel_y = rand(-64,64)
												animate(orb,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
												spawn(10)
													if(orb) orb.loc = null//del(o)
												/*
												for(var/obj/o in orbs)
													if(o.loc == null)
														o.alpha = 255;
														o.loc = b.loc
														o.step_x = b.step_x
														o.step_y = b.step_y
														o.pixel_x = rand(-32-b.pix_away,32+b.pix_away)
														o.pixel_y = rand(-32-b.pix_away,32+b.pix_away)
														animate(o,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
														spawn(10)
															if(o) o.loc = null
														break
												*/
								else if(b.fired == 0 && m.active_attack)
									di = b.GetAngleStep(m.mouse_saved_loc)//m.mouse_degree//b.GetAngleStep(m.mouse_saved_loc)
									b.ang = di
									b.fired = 1
									b.travel = 40
									b.explode_impact = 1
									b.go()
									if(!src.last_gain_time || world.time >= src.last_gain_time + src.gain_cd)
										var/growth_mult = clamp(0.25 + (m.PG), 0.25, 5) // PG gives modest scaling
										m.gain_stat("rating",1,growth_mult,"From Charge Blast skill")
										m.gain_stat("force",1,m.mod_force,"From Charge Blast skill")
										if(prob(50))m.gain_stat("energy",1,(m.mod_energy/1*0.125),"From Charge Blast skill")
										if(prob(2))m.gain_stat("resistance",1,(m.mod_resistance*0.08),"From Charge Blast skill")
										src.last_gain_time = world.time
									m.active_attack = null
									m.icon_state = m.state()
									var/time = 10/m.mod_agility
									if(time < 1) time = 1
									spawn(time)
										if(m) m.can_ki = 1
									ray.loc = null
									//view(8,m)<<S
									if(src.shotforsound==0) src.shotforsound = 1
									return
								//If the player doesn't have enough energy while firing or charging, force the ball and beams to shrink and vanish.
								if(m.energy <= 1) m.active_attack = null
								if(m.koed || m.stunned || m.meditating) m.active_attack = null
							else
								m.active_attack = null
								return
							if(src.shotforsound)
								view(8,m)<<S
								src.shotforsound = 0
							sleep(0.1)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(src.active)
								src.active = 0
								src.icon_state = "charge blast off"
								if(src == m.current_attack) m.current_attack = null
								m.stop_charging()
								if(src.shotforsound==1) src.shotforsound = 0
							else
								src.icon_state = "charge blast"
								src.active = 1
								m.current_attack = src;
								m.toggle_skill(src)
		Psionic_Lance
			name = "Psionic Lance"
			icon_state = "origin"
			disabled_switch = 1;
			act = /obj/skills/Psionic_Lance/proc/activate
			info_energy_cost = "Extreme"
			info_dmg = 3
			info_spd = 3
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 1500
			info_point_cost_type = "force"
			info_name = "psionic_lance"
			info_prerequisite = list("Beam")
			info_stats = "Energy Cost: Extreme\n\nDamage: High\n\nSpeed: Fast\n\nMastery: Slow\n\nToggleable\n\nChargeable"
			energy_skill = 1
			cd_max = 300
			attack_state = "blast"
			hud_x = 260
			hud_y = 588
			var
				tmp/obj/fly = null
			New()
				..()
				category = list("Force","Offence")
			proc
				activate(var/mob/m)
					if(src in m)
						if(m.active_attack) return
						if(m.energy <= 10) return
						if(m.koed || m.stunned || m.meditating) return
						if(m.can_ki == 0) return
						if(src.cd_state < 32)
							m << output("<font color = teal>Skill is on cooldown, please wait.","chat.system")
							//var/is = src.icon_state
							src.icon_state = "cd"
							spawn(3)
								if(src) src.icon_state = "Charge"
							return
						src.cd_max = (initial(src.cd_max)/m.mod_agility)/(1+src.skill_lvl/100)
						m.skill_cooldown(src)
						var/ascended = "psionic"
						var/obj/ranged/beam_charge/b = new
						b.size = 0.3
						b.pix_away = 32
						b.icon = 'attack_spike.dmi'
						for(var/obj/body_related/ascension_milestones/a in m.ascensions)
							if(a.major_ascension && a.icon_state == "ascension" && a.level > 0)
								b.plane = 2
								ascended = "divine"
								break
							else
								b.plane = 1
						b.ki_owner = m

						m.active_attack = b
						m.icon_state = m.state()
						m.can_ki = 0
						var/charge_check = 1;
						var/too_close = 0
						var/turf/t = null
						while(m)
							var/di = 0
							//If the charge ball exists, move it relative to player mouse position and continue with the rest of the code.
							if(b && b.expired == 0)
								var/e = ((4/m.mod_recovery)+(4/src.skill_lvl)*b.charge_lvl)
								if(b.fired == 0)
									//src.skill_exp += (1/src.skill_lvl)*m.mod_skill
									src.skill_exp += ((0.1-(src.skill_lvl/1000))*m.mod_skill)+0.1
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)
									b.loc = m.loc
									m.dir = get_dir(m,m.mouse_saved_loc)
									m.wings()
									di = m.GetAngleStep(m.mouse_saved_loc)//m.mouse_degree//m.GetAngleStep(m.mouse_saved_loc)
									b.step_x = m.step_x
									b.step_y = m.step_y
									t = get_step(m,m.dir)
									too_close = 0
									if(t)
										if(t.density || t.density_factor == 2) too_close = 1
									if(too_close == 0) b.MoveAng(di,b.pix_away,0,0,null)
									b.ki_power = m.psionic_power
									b.ki_force = m.force*b.charge_lvl
									b.force_usage = m.mod_force_usage
									b.ki_offence = m.offence
									b.ki_agility = m.mod_agility

									//If the attack was canceled, or the player ran out of energy during charging or firing, force the attack to shrink and vanish.
									if(m.active_attack == null)
										if(b.finishing == 0)
											m.icon_state = m.state()
											//m.can_ki = 1
											var/matrix/M = matrix()
											M.Scale(0,0)
											animate(b,transform = M,time = 10)
											b.finishing = 1
											spawn(10)
												if(b)
													b.expired = 1
													b.destroy() //del(b)
												//if(ray) ray.loc = null
												if(m) m.can_ki = 1
												//if(ray) ray.loc = null
									//Continue to fire or charge the attack.
								if(m.mouse_down)
									if(b.just_started)
										b.shockwave()
										b.just_started = 0
									//Make the ball bigger and the charge lvl higher if players charged ball wasn't canceled for any reason.
									if(b.finishing == 0)
										if(b.size < 1)
											//Charge increase and displays charge lvl
											b.charge_lvl += 0.02*m.mod_recovery
											var/charge_rounded = round(b.charge_lvl)
											if(charge_rounded > charge_check)
												charge_check = charge_rounded
												//m.charge_nums("<font color = green>x[charge_check]")
											//m << output("Charge lvl is [b.charge_lvl]", "chat.system")
											m.energy-=e
											b.size += 0.002*m.mod_recovery
											if(b.size > 1) b.size = 1
											b.pix_away += 0.14*m.mod_recovery
											if(b.pix_away >= 80) b.pix_away = 80
											//Create cool gathering energy effect
											if(prob(10))
												var/obj/orb = null
												if(ascended == "psionic") orb = new /obj/effects/orb
												else if(ascended == "divine") orb = new /obj/effects/orb_divine
												orb.loc = b.loc
												orb.step_x = b.step_x
												orb.step_y = b.step_y
												orb.pixel_x = rand(-64,64)
												orb.pixel_y = rand(-64,64)
												animate(orb,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
												spawn(10)
													if(orb) orb.loc = null//del(o)
												/*
												for(var/obj/o in orbs)
													if(o.loc == null)
														o.alpha = 255;
														o.loc = b.loc
														o.step_x = b.step_x
														o.step_y = b.step_y
														o.pixel_x = rand(-32-b.pix_away,32+b.pix_away)
														o.pixel_y = rand(-32-b.pix_away,32+b.pix_away)
														animate(o,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
														spawn(10)
															if(o) o.loc = null
														break
												*/
									var/matrix/M = matrix()
									M.Scale(b.size,b.size)
									M.Turn(m.GetAngleStep(m.mouse_saved_loc))
									b.transform = M
								else if(b.fired == 0 && m.active_attack)
									di = b.GetAngleStep(m.mouse_saved_loc)//m.mouse_degree//b.GetAngleStep(m.mouse_saved_loc)
									b.ang = di
									b.travel = 40
									b.fired = 1
									b.explode_impact = 1
									b.go()
									m.active_attack = null
									m.icon_state = m.state()
									var/time = 10/m.mod_agility
									if(time < 1) time = 1
									spawn(time)
										if(m) m.can_ki = 1
									//ray.loc = null
									return
								//If the player doesn't have enough energy while firing or charging, force the ball and beams to shrink and vanish.
								if(m.energy <= 1) m.active_attack = null
								if(m.koed || m.stunned || m.meditating) m.active_attack = null
							else
								m.active_attack = null
								return
							sleep(0.1)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(src.active)
								src.active = 0
								src.icon_state = "Charge off"
								if(src == m.current_attack) m.current_attack = null
								m.stop_charging()
							else
								src.icon_state = "Charge"
								src.active = 1
								m.current_attack = src;
								m.toggle_skill(src)
		Homing_Charge
			name = "Homing Charged Blast"
			icon_state = "Charge off"
			disabled_switch = 1;
			act = /obj/skills/Charge/proc/activate
			info_energy_cost = 3
			info_dmg = 2
			info_spd = 3
			info_mastery = 1
			info_point_cost = 6
			info_point_cost_type = "force"
			info_name = "homing_charged_blast"
			info_prerequisite = list("Charged Blast")
			energy_skill = 1
			var
				tmp/obj/fly = null
			act = /obj/skills/Homing_Charge/proc/activate
			New()
				..()
				category = list("Force","Offence")
			proc
				activate(var/mob/m)
					return
					if(src in m)
						if(m.active_attack) return
						if(m.koed || m.stunned || m.meditating) return
						if(m.can_ki == 0) return
						var/obj/ranged/beam_charge/b = new
						b.spd = 6
						b.ki_owner = m
						b.homing = 1
						if(m.skill_flight && m.skill_flight.active) m.icon_state = "fly beam"
						else m.icon_state = "beam"
						m.active_attack = b
						m.can_ki = 0
						b.explode_impact = 1
						var/di = 0
						var/LOC = m.mouse_saved_loc
						//var/e = ((10/m.mod_recovery)+(1/src.skill_lvl)*b.charge_lvl)
						b.fired = 1
						b.shockwave()
						var/matrix/M = matrix()
						M.Scale(0.5,0.5)
						animate(b,transform = M,time = 5)
						b.size = 0.5
						b.pix_away = 40
						b.charge_lvl = 3.5
						b.ki_power = m.psionic_power
						b.ki_force = m.force*b.charge_lvl
						b.force_usage = m.mod_force_usage
						b.ki_offence = m.offence
						b.ki_agility = m.mod_agility
						src.skill_exp += (1/src.skill_lvl)*m.mod_skill
						if(src.skill_exp >= 100 && src.skill_lvl < 100)
							src.skill_exp = 1
							src.skill_lvl += 1
						b.loc = m.loc
						m.dir = get_dir(m,LOC)
						di = m.GetAngleStep(LOC)
						b.step_x = m.step_x
						b.step_y = m.step_y
						b.MoveAng(di,b.pix_away,0,0,null)
						m.stunned += 1
						m.stunned_pending += 1
						sleep(5)
						if(m)
							m.stunned -= 1
							m.stunned_pending -= 1
							m.active_attack = null
							m.icon_state = m.state()
							var/time = 10/m.mod_agility
							if(time < 1) time = 1
							spawn(time)
								if(m) m.can_ki = 1
						if(b)
							b.explode_impact = 1
							b.fired = 1
							b.go(80,di)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(src.active)
								src.active = 0
								src.icon_state = "Charge off"
								if(src == m.current_attack) m.current_attack = null
								m.stop_charging()
							else
								src.icon_state = "Charge"
								src.active = 1
								m.current_attack = src;
								m.toggle_skill(src)
		Block
			icon_state = "Block off"
			info_energy_cost = "Low"
			info_dmg = 1
			disabled_switch = 1;
			info_spd = 2
			cd_max = 40
			info_cd = "4 seconds"
			info_name = "block"
			info_mastery = 3
			info_point_cost = 0
			info_point_cost_type = "defence"
			info_stats = "Energy Cost: Low \n\n Damage: Low \n\n Speed: Medium \n\n Mastery: Fast"
			act = /obj/skills/Block/proc/activate
			info = "A basic blocking technique to cull incoming damage."
			New()
				..()
				category = list("Strength","Offence")


			proc
				activate(var/mob/m,var/obj/s)
					if(s in m)
						if(m.skill_attack == null) m.skill_block = s
					//if(m.started == 0) return
					if(s.active == 1&&m.can_block==1)
						s.icon_state="Block off"
						m.icon_state = ""
						m.can_block = 0
						s.active=0
						return

					if(s.active == 0 )



						spawn(1)
							var/speed_cd = m.movement_speed
							//if(m.skill_run.active) speed_cd = (m.movement_speed + 0.5)

							if(m && s)
								if(m.guard >0 )

									if(s && s.active)
										s.active = 1
										s.icon_state = "Block"
										if(m.icon_state !="Block") m.icon_state = "Block"
										if(!m.can_block) m.can_block = 1
								else
									if(m.guard<=0)
										if(s)
											if(s.active) s.active = 0
											s.icon_state = "Block off"
											if(m.icon_state =="Block") m.icon_state = "Block off"


											if(m.can_block) m.can_block = 0
											return


							/*if(m.target)
								if(ismob(m.target))
									var/mob/t = m.target
									if(t && m)

										//var/obj/effects/dust_medium/d = new
									//	d.SetCenter(t)
									//	t.shockwave()
										sleep(1)*/


							//s:cd_max = (initial(s:cd_max)/m.mod_agility)/(1+s.skill_lvl/100)
							//sleep(m.attack_rate)

							sleep(speed_cd)
							s.icon_state="Block off"
							s.active=0


			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
							if(src.active) m.toggle_skill(src)
		Attack
			icon_state = "Attack off"
			info_energy_cost = "Low"
			info_dmg = 1
			disabled_switch = 1;
			info_spd = 2
			cd_max = 40
			info_cd = "4 seconds"
			info_name = "attack"
			info_mastery = 3
			info_point_cost = 0
			arsenal = 1
			info_point_cost_type = "offence"
			info_stats = "Energy Cost: Low \n\n Damage: Low \n\n Speed: Medium \n\n Mastery: Fast"
			act = /obj/skills/Attack/proc/activate
			info = "A basic melee attack for immediate damage. The rate at which you attack is based on your speed. Using this with Zanzoken will allow you to auto-combo-attack your target."
			New()
				..()
				category = list("Strength","Offence")


			proc
				activate(var/mob/m,var/obj/s)
					if(s in m)
						if(m.skill_attack == null) m.skill_attack = s
					//if(m.started == 0) return
					if(s.active == 1&&m.can_attack==1)
						s.icon_state="Attack off"
						s.active=0
						return

					if(s.active == 0)

						s.active = 1
						s.icon_state = "Attack"

						var/atom/A = get_step(m, m.dir)

						if(ismob(A))
							// Flick against mob
							switch(rand(1, 2))
								if(1) flick(pick("RPunch", "LPunch"), m)
								if(2) flick(pick("RKick", "LKick"), m)

						else if(isobj(A))
							var/obj/o = A
							if(o.density || (o.density_factor))
								// Flick against dense object or one with density_factor
								switch(rand(1, 2))
									if(1) flick(pick("RPunch", "LPunch"), m)
									if(2) flick(pick("RKick", "LKick"), m)
						spawn(1)
							var/speed_cd = m.movement_speed
							//if(m.skill_run.active) speed_cd = (m.movement_speed + 0.5)
							if(m && s)


								if(s && s.active)
									m.Attack()


							/*if(m.target)
								if(ismob(m.target))
									var/mob/t = m.target
									if(t && m)

										//var/obj/effects/dust_medium/d = new
									//	d.SetCenter(t)
									//	t.shockwave()
										sleep(1)*/


							//s:cd_max = (initial(s:cd_max)/m.mod_agility)/(1+s.skill_lvl/100)
							//sleep(m.attack_rate)

							sleep(speed_cd)
							s.icon_state="Attack off"
							s.active=0


			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
							if(src.active) m.toggle_skill(src)
		Precision
			icon_state = "Expand off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 3
			info_name = "expand"
			teach_energy = 1500
			cd_max = 1000
			info_duration = "Toggleable"
			info_point_cost_type = "offence"
			act = /obj/skills/Precision/proc/activate
			info = "Using this ability expands your accuracy for up to a possibility of five hits, but decreases your strength by 10%."
			var/tmp/hits = 0
			var/tmp/max_hits = 3
			hud_x = 20
			hud_y = 636
			arsenal = 1
			proc
				activate(var/mob/m,var/obj/skills/Precision/s)
					if(m.skill_touch_of_death == null) m.skill_touch_of_death = s
					if(s.cd_state < 32)
						//m << output("<font color = teal>Skill is on cooldown, please wait.","chat.system")
						s.icon_state = "cd"
						spawn(3)
							if(s) s.icon_state = "Expand off"
						return
					if(s.active)
						s.active = 0
						s.icon_state = "Expand off"
					else
						s.icon_state = "Expand"
						s.active = 1
						s.hits = 0
						s.max_hits = rand(3,5)
			New()
				..()
				category = list("Strength","Offence")
				spawn(10)


					if(src.disable_sleep) return
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Stunning_Blow
			icon_state = "Attack off"
			info_energy_cost = 1
			info_dmg = 1
			disabled_switch = 1;
			info_spd = 2
			info_name = "attack"
			info_mastery = 2
			info_point_cost = 0
			cd_max = 200
			info_point_cost_type = "strength"
			info_stats = "Energy Cost: Low \n\n Damage: Low \n\n Speed: Medium \n\n Mastery: Medium"
			act = /obj/skills/Stunning_Blow/proc/activate
			info = "A basic melee attack that can be toggled on and off. Keeping this on will make you automatically attack your target when they are close. The rate at which you attack is based on your Agility mod. Using this with Super Speed will allow you to auto-combo-attack your target. Using this without a target will cause you to attack objects instead."
			hud_x = 68
			hud_y = 636
			arsenal = 1
			New()
				..()
				category = list("Strength","Offence")
			proc
				activate(var/mob/m,var/obj/skills/Stunning_Blow/s)
					if(s in m)
						if(s.cd_state < 32)
							m << output("<font color = teal>Skill is on cooldown, please wait.","chat.system")
							s.icon_state = "cd"
							spawn(3)
								if(s) s.icon_state = "Blast off"
							return
						if(m.koed || m.stunned || m.recovering)
							m.set_alert("Unable while stunned or unconscious",'alert.dmi',"alert")
						//	m.create_chat_entry("alerts","Unable while stunned or unconscious.")
							return
						var/removes = (25/m.mod_recovery) + (25/s.skill_lvl)
						if(m.energy < removes)
							m << output("<font color = teal>Need [removes] energy","chat.system")
							m.set_alert("Need [removes] energy",s.icon,s.icon_state)
					//		m.create_chat_entry("alerts","Need [removes] energy.")
							return
						if(m.target)
							var/mob/tgt = m.target
							if(tgt.KB > 0 || tgt.in_knockback)
								m << output("<font color = teal>Target stunned already.","chat.system")
								m.set_alert("Target stunned already",s.icon,s.icon_state)
							//	m.create_chat_entry("alerts","Target stunned already.")
								return
							if(bounds_dist(m, tgt) <= m.attack_range)
								m.skill_cooldown(s)
								m.energy -= removes
								s.skill_exp += (2.5-(s.skill_lvl/40)*m.mod_skill)+0.025
								if(s.skill_exp >= 100 && s.skill_lvl < 100)
									s.skill_exp = 1
									s.skill_lvl += 1
									s.skill_up(m)
								flick(pick("punch","kick"),m)
								var/Evasion=m.evasion(m,tgt)
								if(Evasion)
									return
								new /obj/effects/shockwave_small (tgt.loc)
								var/obj/effects/hit/h = new
								h.loc = m.loc
								h.dir = m.dir
								if(m.dir == SOUTH ||m.dir == NORTH) h.pixel_x += 16
								h.step_x = m.step_x
								h.step_y = m.step_y
								var/KB_dir = m.dir
								tgt.KB = 30
								tgt.KB_furrow = 1
								tgt.dir = KB_dir

								if(!(/obj/effects/stunned in tgt.overlays))
									tgt.overlays += /obj/effects/stunned

								tgt.stunned += 1
								tgt.stunned_pending += 1

								tgt.KnockBack(KB_dir)

								// cleanup without blocking this proc
								spawn(6)
									if(tgt)
										tgt.stunned = max(0, tgt.stunned - 1)
										tgt.stunned_pending = max(0, tgt.stunned_pending - 1)
										tgt.overlays -= /obj/effects/stunned

								/*tgt.KB = 30
								tgt.KB_furrow = 1
								tgt.dir = KB_dir
								tgt.overlays += /obj/effects/stunned
								tgt.stunned += 1
								tgt.stunned_pending += 1
								tgt.KnockBack(KB_dir)
								sleep(6)
								if(tgt)
									tgt.stunned -= 1
									tgt.stunned_pending -= 1
									tgt.overlays -= /obj/effects/stunned
								return*/
					if(m.started == 0) return
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
							if(src.active) m.toggle_skill(src)
		Wrestle
			icon_state = "Blast off"
			info_energy_cost = 1
			info_dmg = 4
			info_spd = 5
			info_name = "wrestle"
			info_mastery = 1
			info_point_cost = 0
			info_point_cost_type = "strength"
			info_stats = "Energy Cost: Low \n\n Damage: Very High \n\n Speed: Instant \n\n Mastery: Very Slow"
			info = ""
			cd_max = 200
			level = 1
			act = /obj/skills/Wrestle/proc/activate
			New()
				..()
				category = list("Strength","Offence")
			proc
				activate(var/mob/m,var/obj/skills/s)
					if(s in m)
						if(m.skill_wrestle == null) m.skill_wrestle = s
					if(m.started == 0) return
					if(s.cd_state < 32)
						m << output("<font color = teal>Skill is on cooldown, please wait.","chat.system")
						//var/is = s.icon_state
						s.icon_state = "cd"
						spawn(3)
							if(s) s.icon_state = "Blast off"
						return
					if(m.grab && m.grab_part)
						if(ismob(m.grab))
							var/mob/t = m.grab
							if(m.wrestle_stage == null)
								var/strength_contest = (m.strength*m.psionic_power)/(t.strength*t.psionic_power)
								//world << "DEBUG - Chance is [strength_contest*33]%"
								if(prob(strength_contest*33))
									m.wrestle_stage = "locking joint"
									view(8,m) << output("<font color = magenta> [m] manages to tighten their grip on [t]'s [m.grab_part]!", "chat.local")
									t.flash_red()
									t.shake()
									return
								else
									view(8,m) << output("<font color = green> [m] fails to tighten their grip on [t]'s [m.grab_part]!", "chat.local")
									return
							else if(m.wrestle_stage == "locking joint")
								s.cd_max = (initial(s.cd_max)/m.mod_agility)/(1+s.skill_lvl/100)
								m.skill_cooldown(s)
								s.skill_exp += ((5-(s.skill_lvl/20))*m.mod_skill)+0.5
								if(s.skill_exp >= 100 && s.skill_lvl < 100)
									s.skill_exp = 1
									s.skill_lvl += 1
									s.skill_up(m)
								var/strength_contest = (m.strength*m.psionic_power)/(t.strength*t.psionic_power)
								//world << "DEBUG - Chance is [strength_contest*33]%"
								if(prob(strength_contest*33))
									var/obj/body_related/limb = pick(m.grab_part)
									if(length(limb.contents) > 0)
										var/obj/body_related/p = pick(limb.contents)
										var/msgs = pick("mangling their [p] badly!","crushing their [p] badly!","damaging their [p] terribly!","horrifically injuring their [p]!","mutilating their [p]!")
										view(8,m) << output("<font color = red> [m] puts immense pressure on [t]'s [m.grab_part], [msgs]", "chat.local")
										t.damage_limb(m,0, 0, 100,p)
									else
										view(8,m) << output("<font color = magenta> [m] manages to crush [t]'s [m.grab_part]!", "chat.local")
										var/Damage = ((m.strength*m.mod_str_usage)*(m.psionic_power))/(t.endurance*t.psionic_power)
										if(Damage < 0) Damage = 0.1
										t.percent_health -= Damage
										if(t.percent_health < 0) t.KO()
									m.wrestle_stage = null
									m.letgo()
									t.flash_red()
									t.shake()
									return
								else
									view(8,m) << output("<font color = green> [m] fails to tighten their grip on [t]'s [m.grab_part]!", "chat.local")
									return
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Finish
			icon_state = "Attack off"
			info_energy_cost = 1
			info_dmg = 5
			info_spd = 5
			info_name = "finish"
			info_mastery = 5
			info_point_cost = 0
			info_point_cost_type = "offence"
			info_stats = "Energy Cost: Low \n\n Damage: Very High \n\n Speed: Instant \n\n Mastery: Instant"
			info = "Finishes off an unconscious enemy. Can only be used on the target you have selected and they must be knocked out. Enemies can also be finished using psionic attacks instead of this skill."
			level = 100
			act = /obj/skills/Finish/proc/activate
			New()
				..()
				category = list("Strength","Offence")
			proc
				activate(var/mob/m,var/obj/s)
					if(s in m)
						if(m.skill_attack == null) m.skill_attack = s
					if(m.started == 0) return
					if(m.target)
						if(ismob(m.target))
							var/mob/t = m.target
							if(t.koed)
								flick(pick("punch","kick"),m)
								var/obj/effects/dust_medium/d = new
								d.SetCenter(t)
								sleep(1)
								if(t) t.shockwave()
								sleep(1)
								if(t && m)
									t.Death("[m]")
									m.target = null
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Kaioryu
			icon_state = "kaioryu off"
			//repeat = 1;
			disabled_switch = 1;
			act = /obj/skills/Kaioryu/proc/activate
			var/tmp/obj/fly = null
			info_energy_cost = 1
			info_dmg = 1
			info_spd = 4
			info_name = "Kaioryu"
			cd_max = 50
			info_cd = "5 seconds"
			info_mastery = 4
			info_point_cost = 1
			info_point_cost_type = "force"
			energy_skill = 1
			teach_energy = 400
			disabled_switch = 1
			attack_state = "blast"
			info_stats = "Energy Cost: High \n\n Damage: Very High \n\n Speed: Very Fast \n\n Mastery: Fast \n\n Toggleable"
			act = /obj/skills/Kaioryu/proc/activate
			info = "With this skill selected, you can click, or click and drag, to manifest a portion of your Energy, creating psionic blasts. Like most psionic attacks, the damage scales with your Force stat. And the energy cost scales with the level of this skill and your Recovery stat."
			hud_x = 212
			hud_y = 636
			New()
				..()
				category = list("Force","Offence")
			proc
				decide_blast_lvl()
					if(src.skill_lvl <50)
						var/obj/ranged/kaioryu_blast/lvl2/one = new
						return one
					if(src.skill_lvl >=100 && src.skill_lvl <= 199)
						var/obj/ranged/kaioryu_blast/lvl3/two = new
						return two


				activate(var/mob/m)
					if(src == null) return
					if(src.active) return
					else src.active = 1
					m.current_attack = src
					m.active_attack = src
					while(m.mouse_down)
						if(src in m)
							if(m.build_mouse == null) if(m.meditating == 0) if(m.koed == 0) if(m.stunned == 0) if(m.selftraining==0)
								if(src.fly == null)
									for(var/obj/skills/Flight/f in m)
										src.fly = f
								var/e = 1
								e = (100/m.mod_recovery) + (10/src.skill_lvl) * 5
								m.icon_state = m.state()
								//if(src.fly && src.fly.active || m.submerged) m.icon_state = "fly blast"//flick("fly blast",m)
								//else m.icon_state = "blast"//flick("blast",m)
								if(m.energy >= e)
									m.energy-=(e)
									//m << output("<font color = teal>[e] energy removed by [src]","chat.system")
									//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
									//src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
									src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)
									m.can_ki = 0
									src.icon_state = "kaioryu"
									//for(var/mob/h in view(8,m))
										//h << sound('blast.mp3',0,0,3,100)
									var/d = m.GetAngleStep(m.mouse_saved_loc)//m.mouse_degree//m.GetAngleStep(m.mouse_saved_loc)
									var/obj/ranged/kaioryu_blast/b = src.decide_blast_lvl()

									var/matrix/M = matrix()
									M.Turn(d)
									b.transform = M

									/*
									if(b && b.icon)
										var/icon/I = new(b.icon)
										I.Turn(d)
										b.icon = I
									*/
									//b.icon *= m.auracolor
									b.KB = 60
									b.loc = m.loc
									b.step_x = m.step_x
									b.step_y = m.step_y
									b.step_y -= 16;
									b.step_x -= 16;
									b.ki_power = m.psionic_power
									b.ki_force = m.force * 5
									b.force_usage = m.mod_force_usage
									b.ki_offence = m.offence * 5
									b.ki_agility = m.mod_agility * 5
									b.ki_owner = m
									b.alpha = 0
									animate(b, alpha = 255,1)
									m.dir = get_dir(m,m.mouse_saved_loc)
									b.travel = 75
									b.ang = d
									b.go()
								//	m.gain_stat("force",1,(m.mod_strength*0.125),"From Blast skill")
						src:cd_max = (initial(src:cd_max)/m.mod_agility)/(1+src.skill_lvl/100)
							//sleep(m.attack_rate)
						sleep((m.movement_speed-1.5))//sleep(src:cd_max)
				//	for(var/mob/mx in view(25,m))
					//	mx.create_chat_entry("local","<font color = [m.text_color_ic]>[m.real_name]</font> shouts, '<b><font color = #BCC5D8>Kaioryu!<b></font>'",0,1)
					m.can_ki = 1
					src.active = 0
					if(m.active_attack == src) m.active_attack = null
					m.icon_state = m.state()
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(src == m.current_attack)
								//src.active = 0
								src.icon_state = "kaioryu off"
								m.current_attack = null
							//	if(m.client) m.force_sources -= "From Blast skill"
							else
								src.icon_state = "kaioryu"
								//src.active = 1
								m.current_attack = src;
								m.toggle_skill(src)

		Blast
			icon_state = "blast off"
			//repeat = 1;
			disabled_switch = 1;
			act = /obj/skills/Blast/proc/activate
			var/tmp/obj/fly = null
			info_energy_cost = 1
			info_dmg = 1
			info_spd = 4
			info_name = "blast"
			cd_max = 30
			info_cd = "Agility and skill based"
			info_mastery = 4
			info_point_cost = 1
			info_point_cost_type = "force"
			energy_skill = 1
			teach_energy = 400
			disabled_switch = 1
			attack_state = "blast"
			info_stats = "Energy Cost: Low \n\n Damage: Low \n\n Speed: Fast \n\n Mastery: Fast \n\n Toggleable"
			act = /obj/skills/Blast/proc/activate
			info = "With this skill selected, you can click, or click and drag, to manifest a portion of your Energy, creating psionic blasts. Like most psionic attacks, the damage scales with your Force stat. And the energy cost scales with the level of this skill and your Recovery stat."
			hud_x = 212
			hud_y = 636
			var/tmp/last_gain_time = 0
			var/tmp/shotforsound = 0
			var/gain_cd = 25  // cooldown in ticks (2.5 seconds)
			New()
				..()
				category = list("Force","Offence")
			proc
				decide_blast_lvl()
					if(src.skill_lvl <50)
						var/obj/ranged/blast/lvl1/one = new
						return one
					if(src.skill_lvl >=50 && src.skill_lvl <= 199)
						var/obj/ranged/blast/lvl2/two = new
						return two
					if(src.skill_lvl >=200)
						var/obj/ranged/blast/lvl3/three = new
						return three

				activate(var/mob/m)
					if(src == null) return
					if(src.active) return
					if(m.koed || m.stunned || m.meditating || m.selftraining) return
					else src.active = 1
					m.current_attack = src
					m.active_attack = src
					var/sound/S = sound('Modules/core/sound/sound files/Xia SFX v0.1/Blast1.wav')
					S.channel = 1 // Any number from 1-99
					S.volume = 40
					S.repeat = 0 // Make sure it's not loopin

					while(m.mouse_down)
						set background = 1
						if(src in m)
							if(m.build_mouse == null) if(m.meditating == 0) if(m.koed == 0) if(m.stunned == 0) if(m.selftraining==0)
								if(src.fly == null)
									for(var/obj/skills/Flight/f in m)
										src.fly = f

								var/e = 1
								e = (10/m.mod_recovery) + (10/src.skill_lvl)
								m.icon_state = m.state()
								//if(src.fly && src.fly.active || m.submerged) m.icon_state = "fly blast"//flick("fly blast",m)
								//else m.icon_state = "blast"//flick("blast",m)
								if(m.energy >= e)
									S.volume = rand(15,40)

									m.energy-=e
									//m << output("<font color = teal>[e] energy removed by [src]","chat.system")
									//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
									//src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
									src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)
									m.can_ki = 0
									src.icon_state = "blast"
									//for(var/mob/h in view(8,m))
										//h << sound('blast.mp3',0,0,3,100)
									var/d = m.GetAngleStep(m.mouse_saved_loc)//m.mouse_degree
									var/obj/ranged/blast/b = src.decide_blast_lvl()

									var/matrix/M = matrix()
									M.Turn(d)
									b.transform = M

									/*
									if(b && b.icon)
										var/icon/I = new(b.icon)
										I.Turn(d)
										b.icon = I
									*/
									b.icon *= m.auracolor
									b.KB = 40
									b.loc = m.loc
									b.step_x = m.step_x
									b.step_y = m.step_y
									b.step_y -= 16;
									b.step_x -= 16;
									b.ki_power = (m.psionic_power*0.15)
									b.ki_force = (m.force*0.35)
									b.force_usage = m.mod_force_usage
									b.ki_offence = m.offence
									b.ki_agility = m.mod_agility
									b.ki_owner = m
									b.alpha = 0
									animate(b, alpha = 255,1)
									m.dir = get_dir(m,m.mouse_saved_loc)
									b.travel = 40
									b.ang = d
									b.go()
									if(!src.last_gain_time || world.time >= src.last_gain_time + src.gain_cd)
										var/growth_mult = clamp(0.25 + (m.PG), 0.25, 5) // PG gives modest scaling
										m.gain_stat("rating",1,growth_mult,"From Blast skill")
										m.gain_stat("force",1,(m.mod_force*0.0125),"From Blast skill")
										if(prob(25))m.gain_stat("power",1,(m.mod_psionic_power*0.0125),"From Blast skill")
										if(prob(50))m.gain_stat("energy",1,(m.mod_energy/1*0.125),"From Blast skill")
										//if(prob(2))m.gain_stat("resistance",1,(m.mod_resistance*0.08),"From Blast skill")
										src.last_gain_time = world.time
										//view(9,m)<<S
										if(src.shotforsound==0) src.shotforsound = 1



							if(src.shotforsound)
								view(8,src)<<S
								src.shotforsound = 0
						src:cd_max = (initial(src:cd_max)/m.mod_agility)/(1+src.skill_lvl/100)
						//b.stacks = round(max(1, (skill_lvl * 0.1)),1)
							//sleep(m.attack_rate)
						//m<<"[round(max(2, (src:cd_max)))] CD (Org. [src:cd_max])"
						sleep(round(max(2, (src:cd_max))))

					m.can_ki = 1
					src.active = 0
					if(m.active_attack == src) m.active_attack = null
					m.icon_state = m.state()

			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(src == m.current_attack)
								//src.active = 0
								src.icon_state = "blast off"
								m.current_attack = null
								if(m.client) m.force_sources -= "From Blast skill"
							else
								src.icon_state = "blast"
								//src.active = 1
								m.current_attack = src;
								m.toggle_skill(src)


			// The powering down part of power control
			// Make someone undetactable from long distance via sense
		Obfuscation
			icon_state = "Invisibility off"
			info_name = "invisibility"
			act = /obj/skills/Obfuscation/proc/activate
			teach_energy = 2000
			proc
				activate(var/mob/m,var/obj/s)
					if(s in m)
						if(m.skill_obfuscation == null) m.skill_obfuscation = s
						var/needed = (10/m.mod_recovery) + (10/s.skill_lvl)
						if(s.active)
							s.active = 0
							s.icon_state = "Invisibility off"
							if(m.map_blip)
								for(var/mob/p in players)
									if(p.open_map)
										if(p != m && p.z == m.z) p.client.images += m.map_blip
						else if(m.energy >= needed)
							s.active = 1
							s.icon_state = "Invisibility"
							if(m.map_blip)
								for(var/mob/p in players)
									if(p != m) p.client.images -= m.map_blip
			New()
				..()
				category = list("Energy","Utility")
				spawn(10)
					src.info = text_invisibility


					if(src.disable_sleep) return
					spawn(10)
						while(src)
							var/mob/m = null
							if(ismob(src.loc))
								m = src.loc
								if(src.active)
									var/removes = (10/m.mod_recovery) + (10/src.skill_lvl)
									if(m.energy >= removes)
										m.energy -= removes
										src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)
									else
										m.mouse_dir = "left"
										call(src.act)(m,src)
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Limit_Breaker
			// The powering up part of power control
			// Burns lifespan, energy and limb hp
			// Gives +200% psionic energy output while active
			// Energy burns slower if your recovery is higher - makes power up builds a bit better


		Power_Control
			icon_state = "Profusion off"
			info_name = "power_control"
			info_energy_cost = 3
			info_mastery = 2 //"Medium"
			info_point_cost = 3
			teach_energy = 2000
			info_buffs = "Power boost"
			info_duration = "Toggleable"
			info_point_cost_type = "force"
			var/obj/aura = null
			info_stats = "Energy Cost: High\n\nMastery: Medium\n\nToggleable"
			var/sound/sfx = sound('Modules/core/sound/sound files/Flying Sound FX.ogg')
			var/sound/sfx_start = sound('Modules/core/sound/sound files/Xia SFX v0.1/Power_Control_Stop.wav')
			var/icon/trans2_icon
			var/icon/trans3_icon
			var/icon/trans4_icon
			var/icon/trans5_icon
			var/icon/og_form_icon
			var/stage=0
			hud_x = 260
			hud_y = 636
			arsenal = 1
			// Used to lower power to spar others on equal terms
			// Used to hide power from others
			// Used to power up for extra damage
			// Used to return power to normal
			New()
				..()
				category = list("Energy","Power","Buff")

				sfx_start.channel = 9
				sfx_start.volume = 35
				sfx_start.repeat = 0
				spawn(10)
					src.info = text_power_control
					if(src.disable_sleep) return
					if(ismob(src.loc))
						var/mob/m = src.loc
						var/obj/overlay/auras/regular_aura/a = new
						a.icon *= m.auracolor
						if(src.skill_lvl < 25)
							a.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
							a.filters += filter(type="motion_blur", x=1, y=0)
						if(src.skill_lvl >=25 && src.skill_lvl <=50)
							a.filters += filter(type="drop_shadow", x=0, y=0, size=9, offset=1, color=m.auracolor)
							a.filters += filter(type="motion_blur", x=1, y=0)
						if(src.skill_lvl > 50 && src.skill_lvl >=100)
							a.filters += filter(type="drop_shadow", x=0, y=0, size=15, offset=1, color=m.auracolor)
							a.filters += filter(type="motion_blur", x=1, y=0)
						src.aura = a;

						spawn(10)
							while(src)

								if(ismob(src.loc))
									//var/mob/m = src.loc
									if(src.active >= 1 && m.icon_state != "meditate" && !stage) m.power_percent += 1*m.mod_recovery
									if(src.active >= 1 && m.icon_state != "meditate" && stage == 1) m.power_percent += 2*m.mod_recovery
									if(src.active >= 1 && m.icon_state != "meditate" && stage == 2) m.power_percent += 3*m.mod_recovery
									if(src.active >= 1 && m.icon_state != "meditate" && stage == 3) m.power_percent += 4*m.mod_recovery
									if(src.active >= 1 && m.icon_state != "meditate" && stage == 4) m.power_percent += 5*m.mod_recovery
									if(src.active >= 1 && m.icon_state != "meditate" && stage == 5) m.power_percent += 6*m.mod_recovery
									if(src.active == -1 ) m.power_percent -= 1*m.mod_recovery
									if(m.power_percent <= 0) m.power_percent = 0;
									if(m.power_percent > 100 && stage == 1)
										var/drain=10*(m.power_percent-100)/pick(1,m.mod_recovery)
										if(m.energy >= drain)
											m.energy -= drain
											//m << output("Now at [m.power_percent]% power","chat.local")
											//m << output("Psionic power now at [m.psionic_power]","chat.local")
											//m.gain_stat("recovery",1,100,"From Power Control skill")
											src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
											if(src.skill_exp >= 100 && src.skill_lvl < 100)
												src.skill_exp = 1
												src.skill_lvl += 1
												src.skill_up(m)

										else
											m.power_percent = 100;
											m.powering_up = 0
											src.icon_state = "Profusion off"
											src.active = 0;
											remove_overlay(m, src.aura)
											stage=0
											m<<output("You ran out of energy.","actionoutput")

									if(m.power_percent > 100 && stage==5 && m.has_sf1)
										var/drain=10.8*(m.power_percent-100)/pick(1,m.mod_recovery)
										if(m.energy >= drain)
											m.energy -= drain
											//m << output("Now at [m.power_percent]% power","chat.local")
											//m << output("Psionic power now at [m.psionic_power]","chat.local")
											//m.gain_stat("recovery",1,100,"From Power Control skill")
											src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
											if(src.skill_exp >= 100 && src.skill_lvl < 100)
												src.skill_exp = 1
												src.skill_lvl += 1
												src.skill_up(m)
										else
											m.power_percent = 100;
											m.powering_up = 0
											src.icon_state = "Profusion off"
											src.active = 0;
											remove_overlay(m, src.aura)
											stage=0
											m<<output("You ran out of energy.","actionoutput")

									if(m.power_percent > 100 && stage==4 && m.has_sf1)
										var/drain=10.6*(m.power_percent-100)/pick(1,m.mod_recovery)
										if(m.energy >= drain)
											m.energy -= drain
											//m << output("Now at [m.power_percent]% power","chat.local")
											//m << output("Psionic power now at [m.psionic_power]","chat.local")
											//m.gain_stat("recovery",1,100,"From Power Control skill")
											src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
											if(src.skill_exp >= 100 && src.skill_lvl < 100)
												src.skill_exp = 1
												src.skill_lvl += 1
												src.skill_up(m)
										else
											m.power_percent = 100;
											m.powering_up = 0
											src.icon_state = "Profusion off"
											src.active = 0;
											remove_overlay(m, src.aura)
											stage=0
											m<<output("You ran out of energy.","actionoutput")

									if(m.power_percent > 100 && stage==3 && m.has_sf1)
										var/drain=10.4*(m.power_percent-100)/pick(1,m.mod_recovery)
										if(m.energy >= drain)
											m.energy -= drain
											//m << output("Now at [m.power_percent]% power","chat.local")
											//m << output("Psionic power now at [m.psionic_power]","chat.local")
											//m.gain_stat("recovery",1,100,"From Power Control skill")
											src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
											if(src.skill_exp >= 100 && src.skill_lvl < 100)
												src.skill_exp = 1
												src.skill_lvl += 1
												src.skill_up(m)
										else
											m.power_percent = 100;
											m.powering_up = 0
											src.icon_state = "Profusion off"
											src.active = 0;
											remove_overlay(m, src.aura)
											stage=0
											m<<output("You ran out of energy.","actionoutput")

									if(m.power_percent > 100 && stage==2 && m.has_sf1)
										var/drain=10.2*(m.power_percent-100)/pick(1,m.mod_recovery)
										if(m.energy >= drain)
											m.energy -= drain
											//m << output("Now at [m.power_percent]% power","chat.local")
											//m << output("Psionic power now at [m.psionic_power]","chat.local")
											//m.gain_stat("recovery",1,100,"From Power Control skill")
											src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
											if(src.skill_exp >= 100 && src.skill_lvl < 100)
												src.skill_exp = 1
												src.skill_lvl += 1
												src.skill_up(m)
										else
											m.power_percent = 100;
											m.powering_up = 0
											src.icon_state = "Profusion off"
											src.active = 0;
											remove_overlay(m, src.aura)
											stage=0
											m<<output("You ran out of energy.","actionoutput")



									//if(m.power_percent >= 400 && !m.transformed)
									//	return
								//CHECK_TICK
								sleep(10)
			Click(location,control,params)
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"] || m.mouse_dir == "right")
						dir = "right"
					if(dir == "right")
						if(src in m)
							 //Power down
							if(m.transformed)
								if(m.race == "Saiyan")
									if(m.superform)
										m.overlays.Remove(m.ssjhair)
										m.overlays.Add(m.hair)
									if(m.superform2)
										m.overlays.Remove(m.ssjhair)
										m.overlays.Add(m.hair)
									if(m.superform3)
										m.overlays.Remove(m.ssjhair)
										m.overlays.Add(m.hair)
									if(m.superform4)
										m.overlays.Remove(m.ssjhair)
										m.overlays.Add(m.hair)

								if(m.race == "Changeling")
									if(m.superform)
										m.icon = og_form_icon
									if(m.superform2)
										m.icon = trans2_icon
									if(m.superform3)
										m.icon = trans3_icon
									if(m.superform4)
										m.icon = trans4_icon
									if(m.superform5)
										m.icon = trans5_icon
								m.transformed = 0
								if(m.superform)
									m.superform = 0

								if(m.superform2)
									m.superform=0
									m.superform2 = 0
									m.Apply_Transformation_Boost(m.race)
								if(m.superform3)
									m.superform = 1
									m.superform2 = 0
									m.superform3 = 0
									m.Apply_Transformation_Boost(m.race)
								if(m.superform4)
									m.superform = 0
									m.superform2 = 1
									m.superform3 = 0
									m.superform4 = 0
									m.Apply_Transformation_Boost(m.race)
								if(m.superform5)
									m.superform = 0
									m.superform2 = 0
									m.superform3 = 1
									m.superform4 = 0
									m.superform5 = 0
								if(m.current_transformation_boost) m.current_transformation_boost = 0
							// FIRST: stop powering up if currently powering up
							if(src.active == 1)
								src.active = 0
								m.powering_up = 0
								m << output("You stop powering up.","actionoutput")
								src.icon_state = "Profusion off"
								remove_overlay(m, src.aura)
								return

							// SECOND: return power to normal if above/below 100
							if(m.power_percent != 100)
								m.power_percent = 100
								m.shockwave()
								m << output("You return your power to normal.","actionoutput")
								src.icon_state = "Profusion off"
								remove_overlay(m, src.aura)
								m.powering_up = 0
								src.active = 0
								stage = 0
								if(m.client) m.recov_sources -= "From Power Control skill"
								return

							// THIRD: start powering down
							if(src.active == 0)
								src.active = -1
								m.powering_up = -1
								m.current_attack = src
								m << output("You begin powering down.","actionoutput")
								src.icon_state = "Profusion"
								stage = 0
								return
							/*if(m.power_percent != 100)
								m.power_percent = 100
								m.shockwave()
								m << output("You return your power to normal.","actionoutput")
								src.icon_state = "Profusion off"
								remove_overlay(m, src.aura)
								m.powering_up = 0
								src.active = 0
								stage=0
								if(m.client) m.recov_sources -= "From Power Control skill"


								return
							if(src.active == 0)
								src.active = -1;
								m.powering_up = -1;
								m.current_attack = src
								m << output("You begin powering down.","actionoutput")
								src.icon_state = "Profusion"
								stage=0

								return
							if(src.active == 1) //If we were powering up, take it down a level
								src.active = 0;
								m.powering_up = 0
								m << output("You stop powering up.","actionoutput")
								src.icon_state = "Profusion off"
								m.overlays -= src.aura


								return*/

								/*if( src == m.current_attack)
									src.icon_state = "Profusion off"
									m.current_attack = null
									if(m.client) m.force_sources -= "From Power Control skill"
								else
									src.icon_state="Profusion"
									m.current_attack = src;
									m.toggle_skill(src)
								if(m.power_percent > 100) // EDIT THIS BPCNT - PL
									m.power_percent = 100
									m << output("You return your power to normal.","chat.local")
									m.current_attack = null
									src.icon_state="Profusion off"
									if(m.client) m.recov_sources -= "From Power Control skill"

									return
								src.active = -1;
								m.powering_up = -1;
								m << output("You begin powering down.","chat.local")
								src.icon_state = "Profusion"
								return
							if(src.active == 1) //If we were powering up, take it down a level
								src.active = 0;
								m.powering_up = 0
								m << output("You stop powering up.","chat.local")
								src.icon_state = "Profusion off"
								//m.overlays -= src.aura
								return*/
					if(dir == "left")
						if(src in m)
							if(m.meditating || m.selftraining || m.koed) return
							if(src.active == 0) //Power up
								src.active = 1;

								m.powering_up = 1
								//m.power_percent = 100;
								m << output("You begin powering up","actionoutput")
								src.icon_state = "Profusion"
								add_overlay(m, src.aura)

								m.shockwave()
								sleep(2)
								if(src.skill_lvl >= 25 && m.energy_max >=10000) m.shockwave_huge()

								view(15,m)<<sfx_start
								stage=1
							//	spawn(3) view(15,m)<<sfx
								return
							if(src.active == 1)
								if(m.race == "Makyo" && m.psionic_power_base >= m.makyo_sf1_req|| m.race == "Changeling" && m.psionic_power_base >= m.ling_sf2_req ||m.race == "Saiyan" && m.psionic_power_base >= m.saiyan_sf1_req || m.race == "Namekian" && m.psionic_power_base >= m.namekian_sf1_req || m.race == "Human" && m.psionic_power_base >= m.human_sf1_req || m.race == "Kai" && m.psionic_power_base >= m.kai_sf1_req || m.race == "Demon" && m.psionic_power_base >= m.demon_sf1_req || m.race == "Spirit Doll" && m.psionic_power_base >= m.spiritdoll_sf1_req || m.race == "Tuffle" && m.psionic_power_base >= m.tuffle_sf1_req ||m.race == "Oni" && m.psionic_power_base >= m.oni_sf1_req ||m.race == "Alien" && m.psionic_power_base >= m.alien_sf1_req || m.race == "Half God" && m.psionic_power_base >= m.halfgod_sf1_req)
									if(!m.has_sf1)
										if(!m.transformed)
											if(!m.transing)
												switch(alert(m,"Do you wish to transform?","","Transform","Cancel"))
													if("Transform")
														if(!m.transing)
															if(!m.transformed) m.Transformation(1,0)

										/*if(stage==4)
											if(stage!=5)
												m<<output("You begin powering up faster!","actionoutput")
											stage=5
											return
										if(stage==3)
											if(stage!=4)
												m<<output("You begin powering up faster!","actionoutput")
											stage=4
											return
										if(stage==2)
											if(stage!=3)
												m<<output("You begin powering up faster!","actionoutput")
											stage=3
											return

										if(stage==1)
											if(stage!=2)
												m<<output("You begin powering up faster!","actionoutput")
											stage=2
											return*/
									return
								if(m.has_sf1 || m.has_sf2 || m.has_sf3 || m.has_sf4 || m.has_sf5)
									if(!m.transformed)
										if(!m.transing)
											switch(alert(m,"Do you wish to transform?","","Transform","Cancel"))
												if("Transform")
													if(!m.transing)
														if(!m.transformed) m.Transformation(1,0)

								return


							if(src.active == -1) //If we were powering up, take it down a level
								if( src == m.current_attack)
									src.active = 0;
									m.powering_up = 0
									m << output("You stop powering down.","actionoutput")
									src.icon_state = "Profusion off"
									remove_overlay(m, src.aura)
									src.stage=0
									m << sound(null, channel = 9)
								//	m << sound(null, channel = 10)
									return

		Profusion
			icon_state = "Profusion off"
			info_name = "profusion"
			act = /obj/skills/Profusion/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						s.active = 0
						s.icon_state = "Profusion off"
						m.filters -= filter(type="drop_shadow", x=0, y=0,size=5, offset=2, color=rgb(150,150,225))

						m.mod_strength*=1.2
						m.mod_resistance/=1.2
						m.mod_agility/=1.2
						m.mod_force/=1.3
						m.mod_regeneration/=1.2
						m.mod_recovery*=1.2
					else
						s.icon_state = "Profusion"
						m.filters += filter(type="drop_shadow", x=0, y=0,size=5, offset=2, color=rgb(150,150,225))

						s.active = 1

						m.mod_strength/=1.2
						m.mod_resistance*=1.2
						m.mod_agility*=1.2
						m.mod_force*=1.3
						m.mod_regeneration*=1.2
						m.mod_recovery/=1.2

						m.shockwave()
					if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.

			New()
				..()
				spawn(10)
					src.info = text_profusion


					if(src.disable_sleep) return
					spawn(10)
						while(src)
							if(ismob(src.loc))
								var/mob/m = src.loc
								if(src.active)
									if(m.energy>=1)
										//m.energy-=5+((m.energy_max/10)/src.skill_lvl)/m.mod_recovery/m.mod_energy
										var/removes = (10/m.mod_recovery) + (10/src.skill_lvl)
										m.energy-=removes
										//world << "[removes] energy removed by [src]"
										//m << output("<font color = teal>[removes] energy removed by [src]","chat.system")
										//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
										src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)
									else
										m.mouse_dir = "left"
										call(src.act)(m,src)
							//CHECK_TICK
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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



		//healing waves
		Astral_Projection
			icon_state = "Astral Projection off"
			name = "Astral Projection"
			info_energy_cost = 2
			info_mastery = 1
			info_point_cost = 2
			info_name = "astral_projection"
			info_buffs = "Remotely project your spirit to other places."
			info_duration = "Instant"
			info_point_cost_type = "energy"
			info_stats = "Energy Cost: Medium\n\nSpeed: Instant\n\nMastery: Slow\n\nToggleable"
			teach_energy = 1000
			hud_x = 308
			hud_y = 540
			info_prerequisite = list("Remote Viewing","Telepathy")
			info = "Reach out with your mind and project a copy of your physical body. Doing so will leave you in a meditative state while your soul-projection travels out to your desired location. When activated, you will be prompted to click a physical location on the map for your astral projection to appear. The manifestation that you create has quite vague features, roughly resembling someone of your species. You can move it about, talk, hear and see through it, but you can't interact in any other way."
			act = /obj/skills/Astral_Projection/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						s.active = 0
						s.icon_state = "Astral Projection off"
						if(m.client)
							m.client.perspective = MOB_PERSPECTIVE | EDGE_PERSPECTIVE//initial(m.client.perspective)
							m.client.eye = m
						if(m.projection)
							m.projection.shockwave()
							animate(m.projection,alpha = 0, time = 7)
							spawn(8)
								if(m)
									m.projection.loc = null
									m.projection.destroy()
									m.projection = null
					else
						s.active = 1
						s.icon_state = "Astral Projection"
						m.map_proc(0)
						winshow(m,"skills",0)
						m.open_skills = 0
						m.open_menus.Remove(".open_skills")
						for(var/obj/skills/Remote_Viewing/rm in m)
							if(rm.active) call(rm.act)(m,rm)
						/*
						if(m.projection == null)
							for(var/obj/skills/Meditate/med in m)
								if(med.active == 0) call(med.act)(m,med)
							var/mob/p = new
							p.appearance = m.appearance
							p.loc = locate(m.x,m.y-1,m.z)
							p.step_x = m.step_x
							p.step_y = m.step_y
							p.icon_state = ""
							m.projection = p
							m.client.perspective = EYE_PERSPECTIVE
							m.client.eye = p
							s.icon_state = "Meditate"
						*/
			New()
				..()
				category = list("Energy","Utility")
				spawn(10)


					if(src.disable_sleep) return
					spawn(10)
						while(src)
							if(ismob(src.loc))
								var/mob/m = src.loc
								if(src.active)
									var/removes = (1/m.mod_recovery) + (1/src.skill_lvl)
									if(m.energy >= removes)
										m.energy -= removes
										//world << "[removes] energy removed by [src]"
										//m << output("<font color = teal>[removes] energy removed by [src]","chat.system")
										//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
										//src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
										src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)
									else
										m.mouse_dir = "left"
										call(src.act)(m,src)
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)

					winset(m,"map.map","focus=true")
		Hide_Wings
			icon_state = "Hide Wings off"
			name = "Hide Wings"
			info_energy_cost = 0
			info_mastery = 0
			info_point_cost = 2
			info_name = "hide_wings"
			info_buffs = "Hide your divine heritage."
			info_duration = "Instant"
			info_point_cost_type = "energy"
			info_stats = "Hides Wings"
			teach_energy = 1000
			info = "Hide your divine heritage."
			skill_lvl = 1
			act = /obj/skills/Hide_Wings/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s.active)
						s.active = 0
						s.icon_state = "Hide Wings off"
						m.wings_hidden = 0
						m.wings()
					else
						s.active = 1
						s.icon_state = "Hide Wings"
						m.wings_hidden = 1
						if(m.wings) m.vis_contents -= m.wings
						m.wings = null
			New()
				..()
				category = list("Utility")
				spawn(10)


					if(src.disable_sleep) return
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)

					winset(m,"map.map","focus=true")
		Remote_Viewing
			name = "Remote Viewing"
			icon_state = "Remote Viewing off"
			info_energy_cost = 1
			info_mastery = 1
			teach_energy = 1000
			info_point_cost = 3
			hud_x = 275
			hud_y = 588
			info_name = "remote_viewing"
			info_buffs = "Remotely view others"
			info_duration = "Instant"
			info_point_cost_type = "energy"
			info_prerequisite = list("Sense")
			info_stats = "Energy Cost: Low\n\nMastery: Slow\n\nConstant energy drain\n\nToggleable"
			act = /obj/skills/Remote_Viewing/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					if(s in m)
						if(m.skill_remote_viewing == null) m.skill_remote_viewing = s
						if(s.active)
							s.active = 0
							//m.buffs -= "remote view"
							s.icon_state = "Remote Viewing off"
							if(m.client)
								m.client.eye = m
								m.client.perspective = EYE_PERSPECTIVE | EDGE_PERSPECTIVE
						else
							s.icon_state = "Remote Viewing"
							s.active = 1
							//m.buffs += "remote view"
							m.map_proc(0)
							winshow(m,"skills",0)
							m.open_skills = 0
							m.open_menus.Remove(".open_skills")
							for(var/obj/skills/Astral_Projection/ap in m)
								if(ap.active) call(ap.act)(m,ap)
			New()
				..()
				category = list("Energy","Utility")
				spawn(10)
					src.info = text_sense


					if(src.disable_sleep) return
					spawn(10)
						while(src)
							if(ismob(src.loc))
								var/mob/m = src.loc
								if(src.active)
									if(m.energy>=2)
										var/removes = (1/m.mod_recovery) + (1/src.skill_lvl)
										m.energy -= removes
										//world << "[removes] energy removed by [src]"
										//m << output("<font color = teal>[removes] energy removed by [src]","chat.system")
										//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
										//src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
										src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)
									else
										m.mouse_dir = "left"
										call(src.act)(m,src)
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							call(src.act)(m,src)
							m.toggle_skill(src)

					winset(m,"map.map","focus=true")
		Dark_Petrifaction
			icon_state = "Dark Petrifaction off"
			info_energy_cost = 5
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 1000
			info = "Use Dark Matter energy to petrify organs, muscles and bone in preperation for the transformation into an ever living Lich. When using this ability, you can select a bodypart to saturate in Dark Matter Energy, withering it to the point of no return. In doing so, the body part will be disabled until either the Lichdom ritual is complete, or the body part is cleansed. However, this dark transfiguration will bring you one step closer to the Petrified Body ascension needed in the Lichdom ritual."
			info_duration = "Channeled"
			info_name = "divine_petrifaction"
			info_point_cost_type = "energy"
			act = /obj/skills/Dark_Petrifaction/proc/activate
			info_buffs = "Wither a bodypart with dark matter energy"
			hud_x = 20
			hud_y = 636
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/tmp/mob_filter_pos = 0
			var/rotate = 0
			proc
				activate(var/mob/m,var/obj/skills/Dark_Petrifaction/s)
					s.progress = 0
					if(s.active)
						if(m.stance) //Switch off all stances
							m.disable_stances(null,1)
						if(m.grab) m.letgo()
						s.icon_state = "Dark Petrifaction off"
						if(s.active == 2)
							m.stunned -= 1
							m.stunned_pending -= 1
						s.active = 0
						m.icon_state = ""
						if(m.client)
							m.client.screen -= s.bar_inner
							m.client.screen -= s.bar
						s.bar_inner.screen_loc = "16:-2,10:-3"
						s.progress = 0
						if(s.mob_filter_pos) m.filters -= m.filters[s.mob_filter_pos]
					else
						for(var/obj/skills/Incubation/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Divine_Infusion/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Dark_Infusion/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						if(m.dead)
							m << output("<font color = teal>You can only petrify your body with dark power when you are alive.","chat.system")
							m.set_alert("Unable while dead",s.icon,s.icon_state)
							//m.create_chat_entry("alerts","Unable while dead.")
							return
						if(m.dark_matter < 10)
							m << output("<font color = teal>You need at least 10 Dark Matter Energy to wreath a bodypart in cosmic power.","chat.system")
							m.set_alert("10 Dark Matter Energy needed",s.icon,s.icon_state)
						//	m.create_chat_entry("alerts","10 Dark Matter Energy needed.")
							return
						s.icon_state = "Dark Petrifaction"
						s.active = 1
						winshow(m,"skills",0)
						m.open_skills = 0
						m.open_menus.Remove(".open_skills")
						if(m.open_body == 0)
							m.open_body = 1
							m.open_menus.Add(".open_body")
							if(m.hud_body) m.client.screen += m.hud_body
						m.set_alert("Select bodypart to petrify",s.icon,s.icon_state)
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:divine_bar_inner
				category = list("Energy","Buff")


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active == 2)
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									src.progress += 3+round(src.skill_lvl/10)
									//src.skill_exp += (33/src.skill_lvl)*m.mod_skill
									src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
									if(src.rotate == 0)
										m.shockwave_inverse()
										src.rotate = 1
									else src.rotate = 0
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

									if(m.client)
										m.client.screen -= src.bar_inner
										src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
										var/matrix/M = matrix()
										M.Scale(round(src.progress),1)
										src.bar_inner.transform = M
										m.client.screen += src.bar_inner
									if(m.dark_matter < 10)
										call(src.act)(m,src)
										m << output("<font color = teal>You must have at least 10 dark matter energy to continue using Dark Petrifaction.","chat.system")
										m.set_alert("10 Dark Matter Energy needed",src.icon,src.icon_state)
									//	m.create_chat_entry("alerts","10 Dark Matter Energy needed.")
									/*
									if(m.infusing && m.infusing.disabled || m.infusing.damaged)
										call(src.act)(m,src)
										m << output("<font color = teal>Can only wither heathly bodyparts.","chat.system")
										m.set_alert("Bodypart damaged during infusion",src.icon,src.icon_state)
									*/
									var/obj/effects/orb_dark/o = new
									o.loc = m.loc
									o.step_x = m.step_x
									o.step_y = m.step_y
									o.pixel_x = rand(-64,64)
									o.pixel_y = rand(-64,64)
									animate(o,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
									spawn(10)
										if(o) qdel(o)

									if(m.koed || m.meditating)
										call(src.act)(m,src)
									if(src.progress >= 100)
										m.dark_matter -= 10
										animate(m,alpha = 255, time = 30)
										//m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
										m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
										m.icon_state = ""
										//m.stunned -= 1;
										//m.stunned_pending -= 1
										m.screen_text.maptext = "<font size = 6><center>[m.infusing] petrified"
										m.infusing.i_state = "[initial(m.infusing.icon_state)] petrified"
										m.infusing.icon_state = m.infusing.i_state
										m.infusing.infused_petrified = 1
										if(m.infusing.damaged  == 0 && m.infusing.disabled == 0) m.damage_limb(m,0,1,100,m.infusing)
										m.infusing.disabled_perma = 1
										m.infusing = null
										//m.check_quest("tutorial_infuse",1)
										animate(m.screen_text,alpha = 255,time = 60)
										animate(alpha = 0,time = 60)
										m.shockwave()
										if(m.dead)
											m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
											m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
										if(src.active) call(src.act)(m,src)
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(m.skill_dark_petrifaction == null) m.skill_dark_petrifaction = src
							call(src.act)(m,src)
		Dark_Infusion
			icon_state = "Dark Infusion off"
			info_energy_cost = 5
			info_mastery = 1
			info_point_cost = 3
			info_buffs = "Infuse a bodypart with dark matter energy"
			info_duration = "Channeled"
			info_name = "dark_infusion"
			teach_energy = 1000
			hud_x = 68
			hud_y = 636
			info_point_cost_type = "energy"
			act = /obj/skills/Dark_Infusion/proc/activate
			info = "Using Dark Matter Energy and your skills at toning bodyparts, weave the fabric of the universe into your very physical essence. When using this ability, you can select a bodypart to saturate in Dark Matter Energy, permeating it with power and bringing you closer to ascension. In doing so, this ability will automatically grant 10 levels in the chosen bodypart and bring the Divine Body ascension requirement closer to completion."
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			proc
				activate(var/mob/m,var/obj/skills/Dark_Infusion/s)
					s.progress = 0
					if(s.active)
						if(m.stance) //Switch off all stances
							m.disable_stances(null,1)
						if(m.grab) m.letgo()
						s.icon_state = "Dark Infusion off"
						if(s.active == 2)
							m.stunned -= 1
							m.stunned_pending -= 1
						s.active = 0
						m.icon_state = ""
						if(m.client)
							m.client.screen -= s.bar_inner
							m.client.screen -= s.bar
						s.bar_inner.screen_loc = "16:-2,10:-3"
						s.progress = 0
						m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
					else
						for(var/obj/skills/Incubation/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Divine_Infusion/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Dark_Petrifaction/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						if(m.dead)
							m << output("<font color = teal>You can only infuse your body with dark power when you are alive.","chat.system")
							m.set_alert("Unable while dead",s.icon,s.icon_state)
						//	m.create_chat_entry("alerts","Unable while dead.")
							return
						if(m.dark_matter < 10)
							m << output("<font color = teal>You need at least 10 Dark Matter Energy to wreath a bodypart in cosmic power.","chat.system")
							m.set_alert("10 Dark Matter Energy needed",s.icon,s.icon_state)
						//	m.create_chat_entry("alerts","10 Dark Matter Energy needed.")
							return
						s.icon_state = "Dark Infusion"
						s.active = 1
						winshow(m,"skills",0)
						m.open_skills = 0
						m.open_menus.Remove(".open_skills")
						if(m.open_body == 0)
							m.open_body = 1
							m.open_menus.Add(".open_body")
							if(m.hud_body) m.client.screen += m.hud_body
						m.set_alert("Select bodypart to infuse",s.icon,s.icon_state)
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:divine_bar_inner
				category = list("Energy","Buff")


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active == 2)
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									src.progress += 3+round(src.skill_lvl/10)
									//src.skill_exp += (33/src.skill_lvl)*m.mod_skill
									src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

									if(m.client)
										m.client.screen -= src.bar_inner
										src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
										var/matrix/M = matrix()
										M.Scale(round(src.progress),1)
										src.bar_inner.transform = M
										m.client.screen += src.bar_inner
									if(m.dark_matter < 10)
										call(src.act)(m,src)
										m << output("<font color = teal>You must have at least 10 dark matter energy to continue using Dark Infusion.","chat.system")
										m.set_alert("10 Dark Matter Energy needed",src.icon,src.icon_state)
									//	m.create_chat_entry("alerts","10 Dark Matter Energy needed.")
									if(m.infusing && m.infusing.disabled || m.infusing.damaged)
										call(src.act)(m,src)
										m << output("<font color = teal>Can only infuse heathly bodyparts.","chat.system")
										m.set_alert("Bodypart damaged during infusion",src.icon,src.icon_state)
									//	m.create_chat_entry("alerts","Bodypart damaged during infusion.")
									var/obj/effects/orb_dark/o = new
									o.loc = m.loc
									o.step_x = m.step_x
									o.step_y = m.step_y
									o.pixel_x = rand(-64,64)
									o.pixel_y = rand(-64,64)
									animate(o,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
									spawn(10)
										if(o) del(o)

									if(m.koed || m.meditating)
										call(src.act)(m,src)
									if(src.progress >= 100)
										m.dark_matter -= 10
										animate(m,alpha = 255, time = 30)
										//m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
										m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
										m.icon_state = ""
										//m.stunned -= 1;
										//m.stunned_pending -= 1
										m.screen_text.maptext = "<font size = 6><center>[m.infusing] infused"
										m.infusing.i_state = "[initial(m.infusing.icon_state)] dark"
										m.infusing.icon_state = m.infusing.i_state
										m.infusing.infused_dark = 1
										m.infusing.part_exp = 1000
										m.infusing.part_reward(m,1)
										//m.check_quest("tutorial_infuse",1)
										m.infusing = null
										animate(m.screen_text,alpha = 255,time = 60)
										animate(alpha = 0,time = 60)
										m.shockwave()
										if(m.dead)
											m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
											m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
										if(src.active) call(src.act)(m,src)
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(m.skill_dark_infusion == null) m.skill_dark_infusion = src
							call(src.act)(m,src)
		Divine_Infusion
			icon_state = "Divine Infusion off"
			info_energy_cost = 5
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 1000
			info_name = "divine_infusion"
			info_buffs = "Infuse a bodypart with divine energy"
			info_duration = "Channeled"
			info_point_cost_type = "energy"
			hud_x = 116
			hud_y = 636
			act = /obj/skills/Divine_Infusion/proc/activate
			info = "Using Divine Energy and your skills at toning bodyparts, meld divinity into your very physical essence. When using this ability, you can select a bodypart to saturate in Divine Energy, permeating it with power and bringing you closer to divinity. In doing so, this ability will automatically grant 10 levels in the chosen bodypart and bring the Divine Body ascension requirement closer to completion."
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			proc
				activate(var/mob/m,var/obj/skills/Divine_Infusion/s)
					s.progress = 0
					if(s.active)
						if(m.stance) //Switch off all stances
							m.disable_stances(null,1)
						if(m.grab) m.letgo()
						s.icon_state = "Divine Infusion off"
						if(s.active == 2)
							m.stunned -= 1
							m.stunned_pending -= 1
						s.active = 0
						m.icon_state = ""
						if(m.client) m.client.screen -= s.bar_inner
						if(m.client) m.client.screen -= s.bar
						s.bar_inner.screen_loc = "16:-2,10:-3"
						s.progress = 0
						m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,170))
					else
						for(var/obj/skills/Dark_Infusion/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Incubation/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Dark_Petrifaction/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						if(m.has_body == 0)
							m << output("<font color = teal>You can only infuse your body with divine power when you have a body.","chat.system")
							m.set_alert("Unable without body",s.icon,s.icon_state)
						//	m.create_chat_entry("alerts","Unable without body.")
							return
						if(round(m.divine_energy) < 10)
							m << output("<font color = teal>You need at least 10 Divine Energy to wreath a bodypart in godly power.","chat.system")
							m.set_alert("10 Divine Energy needed",s.icon,s.icon_state)
						//	m.create_chat_entry("alerts","10 Divine Energy needed.")
							return
						s.icon_state = "Divine Infusion"
						s.active = 1
						winshow(m,"skills",0)
						m.open_skills = 0
						m.open_menus.Remove(".open_skills")
						if(m.open_body == 0)
							m.open_body = 1
							m.open_menus.Add(".open_body")
							if(m.hud_body) m.client.screen += m.hud_body
						m.set_alert("Select bodypart to infuse",s.icon,s.icon_state)
				/*
				activate(var/mob/m,var/obj/skills/Divine_Infusion/s)
					if(s.active == 0)
						if(m.divine_energy < 25)
							m << output("<font color = teal>You need at least 25 Divine Energy to attempt the revivification process.","chat.system")
							return
						if(m.dead && m.z == 2)
							if(m.energy < m.energy_max)
								m << output("<font color = teal>You need to be at max energy to attempt the revivification process.","chat.system")
								return
							s.active = 1
							m.icon_state = "meditate"
							m.stunned += 1
							m.stunned_pending += 1
							m.client.screen += s.bar
						else m << output("<font color = teal>You need to be dead and in the Psionic Realm to attempt the revivification process.","chat.system")
					else
						s.active = 0
						m.stunned -= 1
						m.icon_state = ""
						m.client.screen -= s.bar_inner
						m.client.screen -= s.bar
						s.bar_inner.screen_loc = "18:-2,11:-6"
						s.progress = 0
				*/
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:divine_bar_inner
				category = list("Energy","Buff")


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active == 2)
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									src.progress += 3+round(src.skill_lvl/10)
									//src.skill_exp += (33/src.skill_lvl)*m.mod_skill
									src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

									if(m.client)
										m.client.screen -= src.bar_inner
										src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
										var/matrix/M = matrix()
										M.Scale(round(src.progress),1)
										src.bar_inner.transform = M
										m.client.screen += src.bar_inner
									if(round(m.divine_energy) < 10)
										call(src.act)(m,src)
										m << output("<font color = teal>You must have at least 10 divine energy to continue using Divine Infusion.","chat.system")
										m.set_alert("10 Divine Energy needed",src.icon,src.icon_state)
										//m.create_chat_entry("alerts","10 Divine Energy needed.")
									if(m.infusing && m.infusing.disabled || m.infusing.damaged)
										call(src.act)(m,src)
										m << output("<font color = teal>Can only infuse heathly bodyparts.","chat.system")
										m.set_alert("Bodypart damaged during infusion",src.icon,src.icon_state)
										//m.create_chat_entry("alerts","Bodypart damaged during infusion.")
									var/obj/effects/orb_divine/o = new
									o.loc = m.loc
									o.step_x = m.step_x
									o.step_y = m.step_y
									o.pixel_x = rand(-64,64)
									o.pixel_y = rand(-64,64)
									animate(o,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
									spawn(10)
										if(o) o.loc = null//del(o)

									if(m.koed || m.meditating)
										call(src.act)(m,src)
									if(src.progress >= 100)
										m.divine_energy -= 10
										animate(m,alpha = 255, time = 30)
										//m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
										m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,170))
										m.icon_state = ""
										//m.stunned -= 1;
										//m.stunned_pending -= 1

										m.screen_text.maptext = "<font size = 6><center>[m.infusing] infused"
										m.infusing.i_state = "[initial(m.infusing.icon_state)] divine"
										m.infusing.icon_state = m.infusing.i_state
										m.infusing.infused_divine = 1
										m.infusing.part_exp = 1000
										m.infusing.part_reward(m,1)
										m.infusing = null
									//	m.check_quest("tutorial_infuse",1)
										animate(m.screen_text,alpha = 255,time = 60)
										animate(alpha = 0,time = 60)
										m.shockwave()
										if(m.dead)
											m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
											m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
										if(src.active) call(src.act)(m,src)
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(m.skill_divine_infusion == null) m.skill_divine_infusion = src
							call(src.act)(m,src)
		Germination
			icon_state = "Germination off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 3000
			hud_x = 164
			hud_y = 636
			info_name = "germination"
			info_buffs = "Use Divine Energy to manifest a godly fruit"
			info_duration = "Channeled"
			info_point_cost_type = "energy"
			info = "Send forth bounteous Divine Energy and force it to collapse into a singular and powerful manifestation of divine will. Pure concentrated, prodigious power is poured into a special godly fruit. The process is very taxing and requires a massive sacrifice of 100 Divine Energy. Eating this physical expression of immortal power will grant the consumer many levels in any and all bodyparts they possess and increase their lifespan by 100 years. Can only be used every few years."
			act = /obj/skills/Germination/proc/activate
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/tmp/obj/g_ball = null
			var/tmp/obj/g_rays = null
			var/tmp/list/pixs
			proc
				activate(var/mob/m,var/obj/skills/Germination/s)
					if(s.active == 0)
						s.pixs = list()
						if(m.stance) //Switch off all stances
							m.disable_stances(null,1)
						if(m.grab) m.letgo()
						if(s.last_used != null)
							if(year-s.last_used < 2)
								m << output("<font color = teal>This can only be used every 2 years. Next use will be available in [round(2-(year-s.last_used),0.1)] years.","chat.system")
								m.set_alert("Available in [round(2-(year-s.last_used),0.1)] years",s.icon,s.icon_state)
							//	m.create_chat_entry("alerts","Available in [round(2-(year-s.last_used),0.1)] years.")
								return
						if(round(m.divine_energy) < 100)
							m << output("<font color = teal>You need at least 100 Divine Energy to attempt the germination process.","chat.system")
							m.set_alert("100 Divine Energy needed",s.icon,s.icon_state)
							//m.create_chat_entry("alerts","100 Divine Energy needed.")
							return
						if(m.has_body == 0)
							m << output("<font color = teal>You need to have a body to attempt the germination process.","chat.system")
							m.set_alert("Need body",s.icon,s.icon_state)
							//m.create_chat_entry("alerts","Need body.")
							return
						if(m.energy < m.energy_max/1.05)
							m << output("<font color = teal>You need to be at max energy to attempt the germination process.","chat.system")
							m.set_alert("Need max energy",s.icon,s.icon_state)
							//m.create_chat_entry("alerts","Need max energy.")
							return
						for(var/obj/skills/Meditate/med in m)
							if(med.active) call(med.act)(m,med)
						for(var/obj/skills/Dark_Transmutation/dt in m)
							if(dt.active) call(dt.act)(m,dt)
						for(var/obj/skills/Dark_Infusion/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Divine_Infusion/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Dark_Petrifaction/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Incubation/inc in m)
							if(inc.active) call(inc.act)(m,inc)
						//m.energy = 1
						s.active = 1
						s.icon_state = "Germination"
						m.icon_state = "beam"
						m.stunned += 1
						m.stunned_pending += 1
						m.client.screen += s.bar

						var/obj/ball = new
						ball.loc = locate(m.x,m.y-2,m.z)
						ball.layer = 10
						ball.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,170))
						ball.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
						ball.step_x = m.step_x
						ball.step_y = m.step_y+12
						ball.icon = 'consumables.dmi'
						ball.icon_state = "divine fruit"
						ball.bolted = 2
						var/turf/t = ball.loc
						if(!t.liquid)
							var/obj/effects/dust_medium/d = new
							d.SetCenter(ball)
						ball.shockwave()
						ball.shockwave_huge()
						animate(ball,pixel_y = 4, color = list("#000", "#000", "#000", "#fff"),time = 12, loop = -1)
						animate(pixel_y = 0, color = initial(m.color),time = 12)
						animate(transform = turn(matrix(), 120), time = 6, loop = -1,flags = ANIMATION_PARALLEL)
						animate(transform = turn(matrix(), 240), time = 6)
						animate(transform = null, time = 6)
						s.g_ball = ball

						var/obj/rays = new
						rays.icon = 'fx_ray_small.dmi'
						rays.pixel_x = -16
						rays.pixel_y = -16
						rays.loc = locate(m.x,m.y-2,m.z)
						rays.bolted = 2
						rays.step_x = m.step_x
						rays.step_y = m.step_y+12
						rays.layer = 9
						rays.filters += filter(type="rays",x=0,y=0,size=64,color=rgb(255,255,170),offset=0,density=10,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
						animate(rays.filters[1],offset = 100,time = 1500, loop = -1)
						animate(offset = 0,time = 0)
						animate(rays.filters[1],y = 4,time = 12, loop = -1, flags = ANIMATION_PARALLEL)
						animate(y = 0, time = 12)
						s.g_rays = rays

						var/p = 33
						while(p)
							if(prob(25))
								sleep(1)
							p -= 1;
							var/obj/pix = new
							pix.icon = 'fx.dmi'
							pix.icon_state = "pixel"
							pix.loc = locate(m.x,m.y-2,m.z)
							pix.step_x = m.step_x
							pix.step_y = m.step_y+12
							pix.pixel_x = rand(-200,200)
							pix.pixel_y = rand(-200,200)
							pix.bolted = 2
							animate(pix,pixel_x = 0, pixel_y = 0, time = rand(5,10), alpha = 0,loop = -1)
							animate(pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = 0, alpha = 255)
							if(s.pixs && islist(s.pixs)) s.pixs += pix
							else s.pixs = list()

					else
						s.active = 0
						m.stunned -= 1
						m.stunned_pending -= 1
						m.icon_state = ""
						m.client.screen -= s.bar_inner
						m.client.screen -= s.bar
						s.bar_inner.screen_loc = "16:-2,10:-3"
						s.progress = 0
						s.icon_state = "Germination off"
						animate(m)
						if(s.pixs && islist(s.pixs))
							for(var/obj/o in s.pixs)
								o.destroy()
						s.pixs = list()
						if(s.g_rays) s.g_rays.destroy()
						s.g_rays = null
						if(s.g_ball) s.g_ball.destroy()
						s.g_ball = null
						//m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:divine_bar_inner
				category = list("Utility","Buff")


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active)
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									src.progress += 3+round(src.skill_lvl/10)
									//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
									src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

									if(m.client)
										m.client.screen -= src.bar_inner
										src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
										var/matrix/M = matrix()
										M.Scale(round(src.progress),1)
										src.bar_inner.transform = M
										m.client.screen += src.bar_inner

									if(round(m.divine_energy) < 100)
										call(src.act)(m,src)
										m << output("<font color = teal>You must have at least 100 divine energy to continue using Germination.","chat.system")
										m.set_alert("100 Divine Energy needed",src.icon,src.icon_state)
									//	m.create_chat_entry("alerts","100 Divine Energy needed.")
									if(m.koed || m.meditating)
										call(src.act)(m,src)
									if(src.progress >= 100)
										if(src.g_ball)
											animate(src.g_ball)
											src.g_ball.shockwave()
										if(src.g_rays)
											src.g_rays.destroy()
											src.g_rays = null
										sleep(10)
										if(src && m)
											if(src.pixs && islist(src.pixs))
												for(var/obj/o in src.pixs)
													animate(o)
													o.destroy()
													sleep(1)
												src.pixs = null
											if(src.g_ball)
												src.g_ball.icon_state = "divine fruit grown"
												sleep(10)
												if(src && m)
													var/obj/items/consumables/divine_fruit/f = new
													f.loc = src.g_ball.loc
													f.step_x = src.g_ball.step_x
													f.step_y = src.g_ball.step_y
													f.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(255,255,170))
													var/fil = f.filters[1]
													animate(fil,size = 0,offset = 0, time = 10)
													spawn(10)
														if(f) f.filters = null
													src.g_ball.destroy()
													src.g_ball = null
													src.last_used = year
													m.divine_energy -= 100
											if(src && src.active && m) call(src.act)(m,src)
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Dark_Formation
			icon_state = "Dark Formation off"
			info_energy_cost = 5
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 3000
			hud_x = 212
			hud_y = 492
			info_name = "dark_formation"
			info_buffs = "Use Dark Matter to create a black hole"
			info_duration = "Channeled"
			info_prerequisite = list("Dark Transmutation")
			info_point_cost_type = "energy"
			info = "Summon forth a huge collection of Dark Matter confined within yourself to initiate the creation of a micro-black hole. With sufficient concentration and extreme supervision, Dark Matter can be manipulated and twisted into higher dimensional spaces, curling and circling into unknowable depths and places to coalesce, forming a mighty singularity. These are astronomically dangerous, if not useful tools, allowing those near to experience gravitational effects that harden the body - or completely destroy it."
			act = /obj/skills/Dark_Formation/proc/activate
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/tmp/list/things = list()
			var/tmp/list/dusts = list()
			var/tmp/list/disk_dust1 = list()
			var/tmp/list/disk_dust2 = list()
			var/tmp/obj/items/environmental/blackhole/blackhole = null
			var/rotation = 0
			//var/tmp/list/pixs
			//var/tmp/list/dusts
			proc
				activate(var/mob/m,var/obj/skills/Dark_Formation/s)
					if(s.active == 0)
						s.things = list()
						if(m.stance) //Switch off all stances
							m.disable_stances(null,1)
						if(m.grab) m.letgo()
						if(s.last_used != null)
							if(year-s.last_used < 5)
								m << output("<font color = teal>This can only be used every 5 years. Next use will be available in [5-(year-s.last_used)] years.","chat.system")
								m.set_alert("Available in [5-(year-s.last_used)] years",s.icon,s.icon_state)
								//m.create_chat_entry("alerts","Available in [5-(year-s.last_used)] years.")
								return
						if(round(m.dark_matter) < 200)
							m << output("<font color = teal>You need at least 200 Dark Matter to create a black hole.","chat.system")
							m.set_alert("200 Dark Matter needed",s.icon,s.icon_state)
						//	m.create_chat_entry("alerts","200 Dark Matter needed.")
							return
						if(m.energy < m.energy_max/1.05)
							m << output("<font color = teal>You need to be at max energy to create a black hole.","chat.system")
							m.set_alert("Need max energy",s.icon,s.icon_state)
						//	m.create_chat_entry("alerts","Need max energy.")
							return
						for(var/obj/skills/Meditate/med in m)
							if(med.active) call(med.act)(m,med)
						for(var/obj/skills/Dark_Transmutation/dt in m)
							if(dt.active) call(dt.act)(m,dt)
						for(var/obj/skills/Dark_Infusion/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Divine_Infusion/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Dark_Petrifaction/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Incubation/inc in m)
							if(inc.active) call(inc.act)(m,inc)
						//m.energy = 1
						s.active = 1
						s.icon_state = "Dark Formation"
						m.icon_state = "beam"
						m.stunned += 1
						m.stunned_pending += 1
						m.client.screen += s.bar
						m.step_x = 0
						m.step_y = 0
						m.set_shadow()

						var/create_dusts = 66
						var/xx = 0
						var/yy = 6
						var/deg = 0
						var/t = 0
						var/obj/h = new
						var/turf/trf = locate(m.x,m.y-2,m.z)
						h.loc = trf
						h.alpha = 0
						s.things += h
						locate(m.x,m.y-3,m.z).explosion(7)
						var/obj/effects/shockwave_medium/b = new
						b.pixel_x = -96
						b.pixel_y = -96
						b.loc = h.loc
						b.transform *= 0.1
						animate(b, transform = matrix()*1, alpha = 0, time = 3)
						spawn(3)
							if(b) b.destroy()
						var/terrain = null
						var/turf/t_usr = m.loc
						if(t_usr.liquid == "water")
							terrain = "water"
							h.plane = -1
						else if(t_usr.liquid == "psionic") terrain = "psionic"
						else if(istype(t_usr,/turf/snows/)) terrain = "snow"
						else if(istype(t_usr,/turf/lava_static)) terrain = "lava"
						while(create_dusts)
							create_dusts -= 1
							for(var/obj/effects/dust/d in global.dusts)
								if(d.loc == null)
									var/matrix/mat = matrix()
									mat.Translate(xx,yy)
									mat.Turn(deg)
									d.transform = mat
									d.plane = 0
									d.alpha = 255
									if(terrain == "snow" && prob(50)) d.icon = 'fx_dust.dmi'
									else if(terrain == "psionic") d.icon = 'fx_dust_cosmic.dmi'
									else if(terrain == "water")
										d.icon = 'fx_water.dmi'
										d.filters += filter(type="outline",size=1, color=rgb(204,236,255))
										d.plane = -1
									else if(terrain == "lava")
										if(prob(33))
											d.icon = 'fx_lava.dmi'
											d.filters += filter(type="drop_shadow", x=0, y=0, size=2, offset=2, color=rgb(224,128,0))
										else d.icon = 'fx_ash.dmi'
									d.loc = h
									yy += 6
									deg += 10
									t += 1
									d.trans_x = xx
									d.trans_y = yy
									d.deg = deg
									h.overlays += d
									s.dusts += d
									break
						create_dusts = 66
						xx = 0
						yy = 6
						deg = 0
						t = 0
						while(create_dusts)
							create_dusts -= 1
							for(var/obj/effects/dust/d in global.dusts)
								if(d.loc == null)
									var/matrix/mat = matrix()
									mat.Translate(xx,yy)
									mat.Turn(deg)
									d.transform = mat
									d.loc = h
									d.plane = 0
									d.alpha = 255
									if(terrain == "snow" && prob(50)) d.icon = 'fx_dust.dmi'
									else if(terrain == "psionic") d.icon = 'fx_dust_cosmic.dmi'
									else if(terrain == "water")
										d.icon = 'fx_water.dmi'
										d.filters += filter(type="outline",size=1, color=rgb(204,236,255))
										d.plane = -1
									else if(terrain == "lava")
										if(prob(33))
											d.icon = 'fx_lava.dmi'
											d.filters += filter(type="drop_shadow", x=0, y=0, size=2, offset=2, color=rgb(224,128,0))
										else d.icon = 'fx_ash.dmi'
									yy -= 6
									deg += 10
									t += 1
									d.trans_x = xx
									d.trans_y = yy
									d.deg = deg
									h.overlays += d
									s.dusts += d
									break
						create_dusts = 120
						deg = 360
						while(create_dusts)
							create_dusts -= 1
							for(var/obj/effects/dust/d in global.dusts)
								if(d.loc == null)
									d.plane = 0
									d.loc = h.loc
									d.step_x = -16
									if(terrain == "snow" && prob(50)) d.icon = 'fx_dust.dmi'
									else if(terrain == "psionic") d.icon = 'fx_dust_cosmic.dmi'
									else if(terrain == "water")
										d.icon = 'fx_water.dmi'
										d.filters += filter(type="outline",size=1, color=rgb(204,236,255))
										d.plane = -1
									else if(terrain == "lava")
										if(prob(33))
											d.icon = 'fx_lava.dmi'
											d.filters += filter(type="drop_shadow", x=0, y=0, size=2, offset=2, color=rgb(224,128,0))
										else d.icon = 'fx_ash.dmi'
									var/px = cos(deg)
									var/py = sin(deg)
									animate(d, pixel_x = px*200, pixel_y = py*200, time = 10)
									d.trans_x = px*200
									d.trans_y = py*200
									d.og_layer = d.layer
									d.deg = deg
									s.disk_dust1 += d
									s.dusts += d
									break
							deg -= 3
						create_dusts = 120
						deg = 360
						while(create_dusts)
							create_dusts -= 1
							for(var/obj/effects/dust/d in global.dusts)
								if(d.loc == null)
									d.loc = h.loc
									d.plane = 0
									if(terrain == "snow" && prob(50)) d.icon = 'fx_dust.dmi'
									else if(terrain == "psionic") d.icon = 'fx_dust_cosmic.dmi'
									else if(terrain == "water")
										d.icon = 'fx_water.dmi'
										d.filters += filter(type="outline",size=1, color=rgb(204,236,255))
										d.plane = -1
									else if(terrain == "lava")
										if(prob(33))
											d.icon = 'fx_lava.dmi'
											d.filters += filter(type="drop_shadow", x=0, y=0, size=2, offset=2, color=rgb(224,128,0))
										else d.icon = 'fx_ash.dmi'
									d.step_x = -16
									d.deg = deg
									var/px = cos(deg)
									var/py = sin(deg)
									animate(d, pixel_x = px*170, pixel_y = py*170, time = 10)
									d.trans_x = px*170
									d.trans_y = py*170
									d.og_layer = d.layer
									s.disk_dust2 += d
									s.dusts += d
									break
							deg -= 3
						//sleep(10)
						create_dusts = 66
						while(create_dusts)
							create_dusts -= 1
							for(var/obj/effects/dust/d in global.dusts)
								if(d.loc == null)
									d.loc = h.loc
									if(terrain == "snow" && prob(50)) d.icon = 'fx_dust.dmi'
									else if(terrain == "psionic") d.icon = 'fx_dust_cosmic.dmi'
									else if(terrain == "water")
										d.icon = 'fx_water.dmi'
										d.filters += filter(type="outline",size=1, color=rgb(204,236,255))
										d.plane = -1
									else if(terrain == "lava") d.icon = 'fx_ash.dmi'
									var/px = rand(-320,320)
									var/py = rand(-320,320)
									if(px < 64 && px > 0) px = 64
									if(px > -64 && px < 0) px = -64
									if(py < 64 && py > 0) py = 64
									if(py > -64 && py < 0) py = -64
									d.pixel_x = px
									d.pixel_y = py
									animate(d,pixel_x = -20,pixel_y = -12, alpha = 55,time = rand(5,15), loop = -1)
									animate(pixel_x = px,pixel_y = py,alpha = 255, time = 0)
									s.dusts += d
									break
						animate(h, transform = turn(matrix(), -120), time = 15, loop = -1)
						animate(transform = turn(matrix(), -240), time = 15)
						animate(transform = null, time = 15)
						animate(h,alpha = 255,time = 10, flags = ANIMATION_PARALLEL)


						var/obj/items/environmental/blackhole/bh = new
						bh.loc = h.loc
						bh.transform = matrix()*0.1
						bh.grown = 0
						bh.layer = m.layer+0.1
						animate(bh)
						animate(bh,transform = matrix()*1, time = 1000)
						bh.spin()
						s.blackhole = bh


						for(var/obj/effects/dust/d in s.disk_dust1)
							animate(d,transform = turn(matrix(),120), time = 5,loop = -1)
							animate(transform = turn(matrix(),240), time = 5)
							animate(transform = null, time = 5)
						for(var/obj/effects/dust/d in s.disk_dust2)
							animate(d,transform = turn(matrix(),120), time = 5,loop = -1)
							animate(transform = turn(matrix(),240), time = 5)
							animate(transform = null, time = 5)


					else
						s.active = 0
						m.stunned -= 1
						m.stunned_pending -= 1
						m.icon_state = ""
						m.client.screen -= s.bar_inner
						m.client.screen -= s.bar
						s.bar_inner.screen_loc = "18:-2,11:-6"
						s.progress = 0
						s.icon_state = "Dark Formation off"
						s.rotation = 1
						animate(m)
						if(s.blackhole && s.blackhole.grown == 0)
							s.blackhole.destroy()
							s.blackhole = null
						if(s.things && islist(s.things))
							for(var/obj/o in s.things)
								o.destroy()
						if(s.dusts && islist(s.dusts))
							for(var/obj/o in s.dusts)
								animate(o)
								animate(o,alpha = 0, pixel_x = -10,pixel_y = -10,time = 10)
								spawn(10)
									if(o)
										o.loc = null
										o.alpha = 255
										o.pixel_y = 0
										o.pixel_x = -20
										o.layer = 3
										o.color = null
										o.icon = initial(o.icon)
										o.plane = initial(o.plane)
										animate(o)
						s.things = list()
						s.dusts = list()
						s.disk_dust1 = list()
						s.disk_dust2 = list()
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:revive_bar_inner
				category = list("Utility")


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active)
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									src.progress += 2+round(src.skill_lvl/10)
									src.skill_exp += (10/src.skill_lvl)*m.mod_skill
									if(prob(50))
										var/obj/effects/lightning_bolt_psi_temp/bolt = new
										bolt.loc = locate(m.x+rand(-3,3),m.y+rand(-3,3),m.z)
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

									if(m.client)
										m.client.screen -= src.bar_inner
										src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
										var/matrix/M = matrix()
										M.Scale(round(src.progress),1)
										src.bar_inner.transform = M
										m.client.screen += src.bar_inner

									if(round(m.dark_matter) < 200)
										call(src.act)(m,src)
										m << output("<font color = teal>You must have at least 200 dark matter to continue using Dark Formation.","chat.system")
										m.set_alert("200 Dark Matter needed",src.icon,src.icon_state)
									//	m.create_chat_entry("alerts","200 Dark Matter needed.")
									if(m.koed || m.meditating)
										call(src.act)(m,src)
									for(var/obj/effects/dust/d in src.disk_dust1)
										var/col = null
										if(src.rotation == 1)
											if(d.deg >= 180 && d.deg <= 360)
												d.layer = src.blackhole.layer-0.1 //2.3
												col = rgb(200,200,200)
												//d.icon = 'fx_dust_cosmic.dmi'
											else
												d.layer = 11
											animate(d,pixel_y = round(d.trans_y-(d.trans_y*2)), easing = SINE_EASING,time = 15,flags = ANIMATION_PARALLEL)
											animate(d, color = col, time = 7.5,easing = SINE_EASING, flags = ANIMATION_PARALLEL)
											animate(color = null, time = 7.5)
											//src.rotation1 = 2
										else
											if(d.deg >= 180 && d.deg <= 360)
												d.layer = 11
												//d.icon = 'fx_dust_cosmic.dmi'
											else
												d.layer = src.blackhole.layer-0.1 //2.3
												col = rgb(200,200,200)
											animate(d,pixel_y = round(d.trans_y-(d.trans_y*2)), easing = SINE_EASING,time = 15,flags = ANIMATION_PARALLEL)
											animate(d, color = col, time = 7.5, easing = SINE_EASING,flags = ANIMATION_PARALLEL)
											animate(color = null, time = 7.5)
											//src.rotation1 = 1
										d.trans_y = d.pixel_y

									for(var/obj/effects/dust/d in src.disk_dust2)
										var/col = null
										if(src.rotation == 1)
											if(d.deg >= 90 && d.deg <= 270)
												d.layer = src.blackhole.layer-0.2 //2.2
												col = rgb(200,200,200)
											else
												d.layer = 10
											animate(d,pixel_x = round(d.trans_x-(d.trans_x*2)), time = 15,easing = SINE_EASING,flags = ANIMATION_PARALLEL)
											animate(d, color = col, time = 7.5, easing = SINE_EASING,flags = ANIMATION_PARALLEL)
											animate(color = null, time = 7.5)
											//src.rotation2 = 2
										else
											if(d.deg >= 90 && d.deg <= 270)
												d.layer = 10
											else
												d.layer = src.blackhole.layer-0.2 //2.2
												col = rgb(200,200,200)
											animate(d,pixel_x = round(d.trans_x-(d.trans_x*2)), time = 15,easing = SINE_EASING,flags = ANIMATION_PARALLEL)
											animate(d, color = col, time = 7.5, loop = 0, easing = SINE_EASING,flags = ANIMATION_PARALLEL)
											animate(color = null, time = 7.5)
											//src.rotation2 = 1
										d.trans_x = d.pixel_x

									if(src.rotation == 1) src.rotation = 2
									else src.rotation = 1
									if(src.progress >= 100)
										if(src.blackhole)
											src.blackhole.grown = 1
											src.blackhole = null
										m.dark_matter -= 200
										call(src.act)(m,src)
							sleep(15)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Dark_Transmutation
			icon_state = "Dark Transmutation off"
			info_energy_cost = 5
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 3000
			hud_x = 212
			hud_y = 636
			info_name = "dark transmutation"
			info_stats = "Convert 2 Divine Energy into 1 Dark Matter"
			info_stats = "Energy Cost: Very High\n\nSpeed: Slow\n\nMastery: Slow\n\nChanneled\n\nConvert 2 Divine Energy into 1 Dark Matter"
			info_duration = "Channeled"
			info_point_cost_type = "energy"
			info = "With directed focus and careful application of skill, twist Divine Energy into a new form. With Dark Transmutation, you take the entirety of your Divine Energy reserves and compress them into a micro singularity, squeezing out and collecting droplets of Dark Matter energy. The process in which Dark Matter is created this way isn't very effective, but it is safe. The conversion rate is 1 Dark Matter for every 2 Divine Energy you possess, a 2 to 1 ratio."
			act = /obj/skills/Dark_Transmutation/proc/activate
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/tmp/obj/g_ball = null
			var/tmp/obj/g_rays = null
			var/tmp/list/pixs
			var/tmp/mob_filter_pos = 0
			proc
				activate(var/mob/m,var/obj/skills/Dark_Transmutation/s)
					if(s.pixs && islist(s.pixs))
						for(var/obj/o in s.pixs)
							o.destroy()
					if(s.active == 0)
						s.pixs = list()
						if(m.stance) //Switch off all stances
							m.disable_stances(null,1)
						if(m.grab) m.letgo()
						if(m.energy < m.energy_max/1.05)
							m << output("<font color = teal>You need to be at max energy to attempt Dark Transmutation.","chat.system")
							m.set_alert("Need max energy",s.icon,s.icon_state)
						//	m.create_chat_entry("alerts","Need max energy.")
							return
						for(var/obj/skills/Meditate/med in m)
							if(med.active) call(med.act)(m,med)
						for(var/obj/skills/Dark_Infusion/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Divine_Infusion/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Dark_Petrifaction/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Incubation/inc in m)
							if(inc.active) call(inc.act)(m,inc)
						m.energy = 1
						s.active = 1
						s.icon_state = "Dark Transmutation"
						m.stunned += 1
						m.stunned_pending += 1
						m.client.screen += s.bar
						m.icon_state = "Meditate"
						m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
						s.mob_filter_pos = m.filters.len
						animate(m.filters[m.filters.len], size = 3,offset = 1, time = 15, loop = -1)
						animate(size = -3,offset = -3, time = 15, loop = -1)

						var/p = 33
						while(p)
							p -= 1;
							var/obj/pix = new
							pix.icon = 'fx.dmi'
							pix.icon_state = "pixel"
							pix.loc = m.loc
							pix.step_x = m.step_x
							pix.step_y = m.step_y
							pix.pixel_x = rand(-200,200)
							pix.pixel_y = rand(-200,200)
							pix.bolted = 2
							pix.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(255,255,170))
							pix.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
							animate(pix,pixel_x = 0, pixel_y = 0, time = rand(10,20), alpha = 255,loop = -1)
							animate(pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = 0, alpha = 0)
							if(s.pixs && islist(s.pixs)) s.pixs += pix
							else s.pixs = list()
						p = 33
						while(p)
							p -= 1;
							var/obj/pix = new
							pix.icon = 'fx.dmi'
							pix.icon_state = "pixel"
							pix.loc = m.loc
							pix.step_x = m.step_x
							pix.step_y = m.step_y
							pix.pixel_x = 0
							pix.pixel_y = 0
							pix.bolted = 2
							pix.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(102,0,204))
							pix.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
							animate(pix,pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = rand(10,20), alpha = 0,loop = -1)
							animate(pixel_x = 0, pixel_y = 0, time = 0, alpha = 255)
							if(s.pixs && islist(s.pixs)) s.pixs += pix
							else s.pixs = list()

					else
						s.active = 0
						m.stunned -= 1
						m.stunned_pending -= 1
						m.icon_state = ""
						m.client.screen -= s.bar_inner
						m.client.screen -= s.bar
						s.bar_inner.screen_loc = "16:-2,10:-3"
						s.progress = 0
						s.icon_state = "Dark Transmutation off"
						//animate(m)
						if(s.mob_filter_pos) m.filters -= m.filters[s.mob_filter_pos]
						//m.filters = null
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:revive_bar_inner
				category = list("Utility")


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active)
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									src.progress += 2+round(src.skill_lvl/10)
									//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
									src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

									if(m.client)
										m.client.screen -= src.bar_inner
										src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
										var/matrix/M = matrix()
										M.Scale(round(src.progress),1)
										src.bar_inner.transform = M
										m.client.screen += src.bar_inner

									if(m.koed || m.meditating)
										call(src.act)(m,src)
									if(src.progress >= 100)
										if(src && m)
											if(src.pixs && islist(src.pixs))
												for(var/obj/o in src.pixs)
													animate(o)
													o.destroy()
													sleep(0.1)
												src.pixs = null
											if(m.divine_energy > 0) m.dark_matter += (m.divine_energy/2)*m.dark_matter_mod
											m.divine_energy = 0
											if(src && src.active && m) call(src.act)(m,src)
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Hunt
			icon_state = "hunt off"
			info_name = "hunt"
			info_stats = "Allows hunting animals and creatures from terrains."
			info = "You'll need to know how to hunt for food if you're going to want to survive."
			act = /obj/skills/Hunt/proc/activate
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null

			proc
				activate(var/mob/m,var/obj/skills/Hunt/s)

					if(m.hunting_enabled)
						m.hunting_enabled=0
						m.set_alert("Hunting Toggled: OFF",s.icon,s.icon_state)
					//	m.create_chat_entry("alerts","Hunting toggled: <font color=red>OFF</font>")
						s.icon_state = "hunt off"
						return

					else if(m.hunting_enabled == 0)
						m.hunting_enabled=1
						s.icon_state = "hunt"
						m.set_alert("Hunting Toggled: ON",s.icon,s.icon_state)
					//	m.create_chat_entry("alerts","Hunting toggled: <font color=green>ON</font>")
						return
					//	animate(m)
						//m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:gather_bar_inner
				category = list("Hunting")


				if(src.disable_sleep) return

			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Kaioken
			icon_state = "kaioken off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 1500
			info_buffs = "Power multiplier (x1-20)"
			info_duration = "Toggleable"
			info_point_cost_type = "force"
			info_name = "kaioken"
			act = /obj/skills/Kaioken/proc/activate
			info_stats = "Power multiplier (x1-20)\n\nConstant energy drain\n\nToggleable"
			hud_x = 20
			hud_y = 636
			var/mob/granter
			var/times_multi = 1
			proc
				activate(var/mob/m,var/obj/skills/Kaioken/s)

					var/needed = (10/m.mod_recovery) + (10/s.skill_lvl)
					if(s.active)
						//m.buffs -= "focus"
						s.active = 0
					//	if(m.client) m.power_sources -= m.buff_mystic

						//m.overlays -= 'focus_eyes.dmi'
						//m.overlays -= /obj/effects/eyes_focus
						s.icon_state = "kaioken off"
					//	if(m.race == "Alien") m.overlays -= /obj/effects/elec_cerebroid
						remove_overlay(m, /obj/overlay/auras/kaioken)
						m.med_pixel = 1
						m.shock_chance = 0
						m.mod_strength = m.mod_strength_og
						m.mod_offence = m.mod_offence_og
						m.mod_agility = m.mod_agility_og
						s.times_multi = 1
					//	src.controller = null
						//m.mod_force/=1.2
						//m.multi_force -= 0.2
					//	m.vis_contents -= m.eyes_white
					//	m.vis_contents -= m.eyes
						if(m.eyes)
							m.eyes = m.eyes_copy
						//	if(proceed)
						//		m.vis_contents += m.eyes_white
							//	m.vis_contents += m.eyes
						//animate(m)
						var/turf/t = m.loc
						if(t && t.liquid == null) animate(m)
						//m.mods(list("Strength","Endurance","resistance","offence","defence","Regeneration","Agility","force"))
						//if(m.meditating)
							//animate(m,pixel_y = initial(m.pixel_y), time = 10)

					else
						var/multi = input ("Kaioken x:") as num
						if(multi>=20) multi = 20
						if(multi<=0.1||multi<=1)
							multi = 0
							return
						s.times_multi = multi
						needed*=multi
						if(m.energy >= needed)
						//m.buffs += "focus"
							s.active = 1
							s.icon_state = "kaioken"
							m.mod_strength *= (round(s.times_multi * 0.55))
							m.mod_offence *= (round(s.times_multi * 0.55))
							m.mod_agility *= (round(s.times_multi * 0.55))
							var/turf/t = m.loc
							if(!t.liquid)
								var/obj/effects/dust_medium/d = new
								d.SetCenter(m)
							remove_overlay(m, /obj/overlay/auras/kaioken)
							add_overlay(m, /obj/overlay/auras/kaioken)
							//for(var/mob/h in view(8,m))
								//h << sound('focus1.mp3',0,1,10,100)
							m.shock_chance = 25
							//m.mod_force*=1.2
							//m.multi_force += 0.2
						//	m.vis_contents -= m.eyes_white
						//	m.vis_contents -= m.eyes

							//	if(proceed)
								//	m.vis_contents += m.eyes_white
							//		m.vis_contents += m.eyes
							//hearers(8,m) << 'shockwave.wav'
							m.shockwave()
							if(m.meditating)
								var/pix_y = 0
								//if(m.race == "Alien") pix_y = -16
								animate(m,pixel_y = 10, time = 20,loop = -1,flags = ANIMATION_PARALLEL)
								animate(pixel_y = pix_y, time = 20)
							// do if majin_level == 1, and set buff_majin1 and so forth
							m.kaioken_pl = s.times_multi
							var/obj/buffs_and_debuffs/b = m.buff_kaioken

							var/txt = "<br><u>Sources</u>"
							for(var/x in m.power_sources)
								txt = "[txt]<br>[x]x[s.times_multi]"
							b.info_txt.maptext = "<font size = 1><text align=center valign=top>[b.desc][txt]"
							b:activate(m,b)
						//	for(var/mob/mx in view(25,m))
						//		mx.create_chat_entry("local","<font color = [m.text_color_ic]>[m.real_name]</font> shouts, '<b><font color = #FF2659>Kaioken times [s.times_multi]!<b></font>'",0,1)
						//	b.active = 1;

						//	if(m.power_sources && islist(m.power_sources) && m.power_sources.Find("From Mystic Skill") == 0) m.power_sources += "From Mystic Skill"
							//hearers(8,m) << 'focus_activate.wav'
							//hearers(8,m) << 'electric.wav'
						//if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.

			New()
				..()
				category = list("Force","Agility","Buff")
				spawn(10)
					src.info = text_kaioken


					if(src.disable_sleep) return
					spawn(10)
						while(src)
							var/mob/m = null
							if(ismob(src.loc))
								m = src.loc
								if(src.active)
									var/removes = (10/m.mod_recovery) + (10/src.skill_lvl) * src.times_multi
									var/kaiodmg = 1 + (m.skill_kaioken.skill_lvl/100) * 2

									if(m.energy >= removes)
										//m.energy-=5+((m.energy_max/5)/src.skill_lvl)/m.mod_recovery/m.mod_energy
										//var/removes = 1 + 10 - (m.mod_recovery+m.mod_energy) - (src.skill_lvl/10)
										m.energy -= removes
										if(prob(25) && m.body && m.body.len)
											var/obj/body_related/bodyparts/limb_random = pick(m.body)
											m.damage_limb(m,1, 1, kaiodmg, limb_random)
										//world << "[removes] energy removed by [src]"
										//m << output("<font color = teal>[removes] energy removed by [src]","chat.system")
										if(m.meditating)
											var/proceed = 1
											for(var/obj/items/tech/Bio_Rejuvination_Tank/t in range(2,m))
												if(bounds_dist(t, m) < 3)
													proceed = 0
											if(proceed)
												//animate(m,pixel_y = 2, time = 10)
												//animate(m,pixel_y = 10, time = 11)
												if(m.reflection) animate(m.reflection,pixel_y = 10, time = 11)
										//src.skill_exp += (5-(src.skill_lvl/20))*m.mod_skill
										//m.gain_stat("force",1,1,"From Focus skill")
										//src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
										src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)
										if(m.energy < 1)
											m.mouse_dir = "left"
											call(src.act)(m,src)
									//else
									//	m.mouse_dir = "left"
										//call(src.act)(m,src)
							sleep(5)
							if(m) if(src.active) if(m.meditating)
								var/proceed = 1
								for(var/obj/items/tech/Bio_Rejuvination_Tank/t in range(2,m))
									if(bounds_dist(t, m) < 3)
										proceed = 0
								if(proceed)
									//animate(m,pixel_y = 0, time = 11)
									if(m.reflection) animate(m.reflection,pixel_y = 0, time = 11)
							sleep(5)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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


		Spirit_Reprieve // Temporary Revival skill for Witches 50% Energy cast while they are alive.
			icon_state = "spirit rep off"
			info_energy_cost = 4
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 3000
			info_name = "spirit_reprieve"
			info_buffs = "Temporarily Revive soul"
			info_duration = "Channeled"
			info_point_cost_type = "regen"
			act = /obj/skills/Spirit_Reprieve/proc/activate
			hud_x = 20
			hud_y = 588
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/tmp/mob/skill_target = null
			proc
				activate(var/mob/m,var/obj/skills/Spirit_Reprieve/s)
					if(s in m)
						if(m.skill_reprieve == null) m.skill_reprieve = s
					if(s.active == 0)
						if(m.stance) //Switch off all stances
							m.disable_stances(null,1)
						if(m.grab) m.letgo()

						if(m.energy < m.energy_max/1.05)
							m << output("<font color = teal>You need to be at max energy to attempt the spirit reprieval process.","chat.system")
							m.set_alert("Need max energy",s.icon,s.icon_state)
						//	m.create_chat_entry("alerts","You need to be at max energy to attempt the spirit reprieval process.")
							return

						m.open_skills = 0
						m.open_menus.Remove(".open_skills")
						winshow(m,"skills",0)
						//m.left_click_function = "revive"
						//m.set_alert("Select target to revive",s.icon,s.icon_state)
						s.icon_state = "spirit rep"
						var/mob/trg = m
						if(m.target) trg = m.target
						if(trg.client)
							m.left_click_function = null
							if(get_dist(m,trg) > 2)
								m << output("<font color = teal>They are too far away to interact with.","chat.system")
								m.set_alert("Too far away",'alert.dmi',"alert")
							//	m.create_chat_entry("alerts","They are too far away to interact with.")
								m.skill_reprieve.icon_state = "spirit rep off"
								return
							//if(trg.has_body == 0)
							//	m << output("<font color = teal>They need to have a body to attempt the revivification process.","chat.system")
							//	m.set_alert("Need body",m.skill_revive.icon,m.skill_revive.icon_state)
							//	m.create_chat_entry("alerts","They need to have a body to attempt the revivification process.")
							//	m.skill_revive.icon_state = "Revivification off"
							//	return
							if(trg.dead == 0)
								m << output("<font color = teal>They are already alive.","chat.system")
								m.set_alert("Already alive",s.icon,s.icon_state)
								m.skill_reprieve.icon_state = "spirit rep off"
							//	m.create_chat_entry("alerts","They are already alive.")
								return
							if(trg.dead)
								for(var/obj/skills/Meditate/med in m)
									if(med.active) call(med.act)(m,med)
								m.skill_reprieve.active = 1
								m.skill_reprieve.skill_target = trg
								m.icon_state = "Meditate"
								m.stunned += 1
								m.stunned_pending += 1
								m.client.screen += m.skill_reprieve.bar
								if(trg != m) trg.client.screen += m.skill_reprieve.bar
							//	m.create_chat_entry("local","<font color = purple> [m] begins to revive [trg]'s soul.</font>",0,1)
							else

								m.set_alert("They are not dead.",'alert.dmi',"alert")
							//	m.create_chat_entry("alerts","Target must be dead.")
								m.skill_reprieve.icon_state = "spirit rep off"
								return
						else
							s.icon_state = "spirit rep off"
						//	m.set_alert("Only used on players",'alert.dmi',"alert")
						//	m.create_chat_entry("alerts","Only used on players.")
							return
					else
						s.active = 0
						m.stunned -= 1
						m.stunned_pending -= 1
						m.icon_state = ""
						m.client.screen -= s.bar_inner
						m.client.screen -= s.bar
						s.bar_inner.screen_loc = "16:-2,10:-3"
						s.progress = 0
						s.icon_state = "spirit rep off"
						if(s.skill_target && s.skill_target.client)
							s.skill_target.client.screen -= s.bar_inner
							s.skill_target.client.screen -= s.bar
						s.skill_target = null
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:revive_bar_inner
				category = list("Regeneration","Utility")
				src.info = text_spirit_reprieve


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active)
								var/mob/m = null
								if(ismob(src.loc))
									if(src.skill_target)
										var/mob/tar = src.skill_target
										m = src.loc
										if(get_dist(m,tar) <= 2)
											if(tar.dead)
												if(m.energy >= src.skill_lvl+10)
													m.energy -= src.skill_lvl+10;
													src.progress += 1+round(src.skill_lvl/10)
													//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
													src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
													if(src.skill_exp >= 100 && src.skill_lvl < 100)
														src.skill_exp = 1
														src.skill_lvl += 1
														src.skill_up(m)

												if(m.client)
													m.client.screen -= src.bar_inner
													src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
													var/matrix/M = matrix()
													M.Scale(round(src.progress),1)
													src.bar_inner.transform = M
													m.client.screen += src.bar_inner
													if(tar.client && tar != m)
														tar.client.screen -= src.bar_inner
														src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
														var/matrix/M2 = matrix()
														M2.Scale(round(src.progress),1)
														src.bar_inner.transform = M2
														tar.client.screen += src.bar_inner

												var/obj/effects/orb/o = new
												o.loc = tar.loc
												o.step_x = tar.step_x
												o.step_y = tar.step_y
												o.pixel_x = rand(-64,64)
												o.pixel_y = rand(-64,64)
												animate(o,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
												spawn(10)
													if(o) qdel(o)

												if(m.koed || m.meditating)
													call(src.act)(m,src)
												var/neededenergy = (tar.energy_max/tar.psionic_power)
												if(src.progress >= 100)
													if(m.energy_max >= neededenergy)
														tar.TempRevive(neededenergy,m)
														m.icon_state = ""
														m.divine_energy -= 25
														m.set_alert("You have temporarily revived [tar.real_name]!",src.icon,src.icon_state)
													//	m.create_chat_entry("alerts","You have temporarily revived [tar.real_name]!")
														//view(8,m) << output("<font color = purple> [m] finishes reknitting [tar]'s soul and fuses it back to their body.", "chat.local")
														if(src.active) call(src.act)(m,src)
													else
														if(prob(50))
															tar.TempRevive(neededenergy,m)
															m.icon_state = ""
															m.divine_energy -= 25
															m.set_alert("You have temporarily revived [tar.real_name]!",src.icon,src.icon_state)
														//	m.create_chat_entry("alerts","You have temporarily revived [tar.real_name]!")
														//	view(8,m) << output("<font color = purple> [m] finishes reknitting [tar]'s soul and fuses it back to their body.", "chat.local")
															if(src.active) call(src.act)(m,src)
														else
															m.icon_state = ""
															m.divine_energy -= 25
															m.set_alert("You have failed to temporarily revived [tar.real_name]!",src.icon,src.icon_state)
														//	m.create_chat_entry("alerts","You have failed to temporarily revived [tar.real_name]!")
														//	view(8,m) << output("<font color = purple> [m] finishes reknitting [tar]'s soul and fuses it back to their body.", "chat.local")
															if(src.active) call(src.act)(m,src)

										else if(src.active)
											m.set_alert("Target too far",'alert.dmi',"alert")
										//	m.create_chat_entry("alerts","Target too far.")
											if(src.skill_target && src.skill_target != m)
												src.skill_target.set_alert("Target too far",'alert.dmi',"alert")
											//	src.skill_target.create_chat_entry("alerts","Target too far.")
											call(src.act)(m,src)
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Majin
			icon_state = "majin off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 1500
			info_buffs = "+20% Force"
			info_duration = "Toggleable"
			info_point_cost_type = "force"
			info_name = "majin"
			act = /obj/skills/Majin/proc/activate
			info_stats = "+20% Force\n\nConstant energy drain\n\nToggleable"
			hud_x = 20
			hud_y = 636
			var/majin_level = 1
			var/mob/controller
			proc
				activate(var/mob/m,var/obj/skills/Majin/s)

					var/needed = (10/m.mod_recovery) + (10/s.skill_lvl)
					if(s.active && s.controller.dead || s.active && m.has_majin == 0)
						//m.buffs -= "focus"
						s.active = 0
					//	if(m.client) m.power_sources -= m.buff_majin
						//m.overlays -= 'focus_eyes.dmi'
						//m.overlays -= /obj/effects/eyes_focus
						s.icon_state = "majin off"
					//	if(m.race == "Alien") m.overlays -= /obj/effects/elec_cerebroid
						m.overlays -= /obj/effects/elec_majin
						m.med_pixel = 1
						m.shock_chance = 0
						src.controller = null
						//m.mod_force/=1.2
						//m.multi_force -= 0.2
					//	m.vis_contents -= m.eyes_white
					//	m.vis_contents -= m.eyes
						if(m.eyes)
							m.eyes = m.eyes_copy
						//	if(proceed)
						//		m.vis_contents += m.eyes_white
							//	m.vis_contents += m.eyes
						//animate(m)
						var/turf/t = m.loc
						if(t && t.liquid == null) animate(m)
						//m.mods(list("Strength","Endurance","resistance","offence","defence","Regeneration","Agility","force"))
						//if(m.meditating)
							//animate(m,pixel_y = initial(m.pixel_y), time = 10)

					else if(m.energy >= needed)
						//m.buffs += "focus"
						s.active = 1
						s.icon_state = "majin"
						var/turf/t = m.loc
						if(!t.liquid)
							var/obj/effects/dust_medium/d = new
							d.SetCenter(m)
						if(m.race == "Alien")
							m.overlays -= /obj/effects/elec_majin
							m.overlays += /obj/effects/elec_majin
						else
							m.overlays -= /obj/effects/elec_majin
							m.overlays += /obj/effects/elec_majin
						//for(var/mob/h in view(8,m))
							//h << sound('focus1.mp3',0,1,10,100)
						m.shock_chance = 10

						//hearers(8,m) << 'shockwave.wav'
						m.shockwave()
						if(m.meditating)
							var/pix_y = 0
							//if(m.race == "Alien") pix_y = -16
							animate(m,pixel_y = 10, time = 20,loop = -1,flags = ANIMATION_PARALLEL)
							animate(pixel_y = pix_y, time = 20)

						var/obj/buffs_and_debuffs/b = m.buff_majin

						var/txt = "<br><u>Sources</u>"
						for(var/x in m.power_sources)
							txt = "[txt]<br>[x]."
						b.info_txt.maptext = "<font size = 1><text align=center valign=top>[b.desc][txt]"
						b:activate(m,b)

					//	b.active = 1;

						//if(m.power_sources && islist(m.power_sources) && m.power_sources.Find("From Majin Skill") == 0) m.power_sources += "From Majin Skill"
						//hearers(8,m) << 'focus_activate.wav'
						//hearers(8,m) << 'electric.wav'
					//if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.
					else if (s.active && s.controller.dead == 0)
						m.set_alert("Only the person that Majinized you can cancel your Majin!",'alert.dmi',"alert")
						//m.create_chat_entry("alerts","Only the person that Majinized you can canel your Majin!")
						return
			New()
				..()
				category = list("Force","Agility","Buff")
				spawn(10)
					src.info = text_focus


					//if(src.disable_sleep) return
					spawn(10)
						while(src)
							var/mob/m = null
							if(ismob(src.loc))
								m = src.loc
								if(src.active)
									var/removes = (10/m.mod_recovery) + (10/src.skill_lvl)

									if(m.energy >= removes)
										//m.energy-=5+((m.energy_max/5)/src.skill_lvl)/m.mod_recovery/m.mod_energy
										//var/removes = 1 + 10 - (m.mod_recovery+m.mod_energy) - (src.skill_lvl/10)
									//	m.energy -= removes
										//world << "[removes] energy removed by [src]"
										//m << output("<font color = teal>[removes] energy removed by [src]","chat.system")
										if(m.meditating)
											var/proceed = 1
											for(var/obj/items/tech/Bio_Rejuvination_Tank/t in range(2,m))
												if(bounds_dist(t, m) < 3)
													proceed = 0
											if(proceed)
												//animate(m,pixel_y = 2, time = 10)
												//animate(m,pixel_y = 10, time = 11)
												if(m.reflection) animate(m.reflection,pixel_y = 10, time = 11)
										//src.skill_exp += (5-(src.skill_lvl/20))*m.mod_skill
										//m.gain_stat("force",1,1,"From Focus skill")
										//src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
										src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)
										if(m.energy < 1)
											m.mouse_dir = "left"
											call(src.act)(m,src)
									//else
									//	m.mouse_dir = "left"
										//call(src.act)(m,src)
							sleep(5)
							if(m) if(src.active) if(m.meditating)
								var/proceed = 1
								for(var/obj/items/tech/Bio_Rejuvination_Tank/t in range(2,m))
									if(bounds_dist(t, m) < 3)
										proceed = 0
								if(proceed)
									//animate(m,pixel_y = 0, time = 11)
									if(m.reflection) animate(m.reflection,pixel_y = 0, time = 11)
							sleep(5)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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

		Majinize // Level 1, 2, 3, (1: no control, 250% Boost, 2: stun control, 500% boost, 3: physical,stun,explosion control 1000% boost)
			icon_state = "majinize off"
			info_energy_cost = 4
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 3000
			info_name = "majinize"
			info_buffs = ""
			info_duration = "Channeled"
			info_point_cost_type = "regen"
			act = /obj/skills/Majinize/proc/activate
			hud_x = 20
			hud_y = 588
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/tmp/mob/skill_target = null
			var/intended_level = 1
			proc
				activate(var/mob/m,var/obj/skills/Majinize/s)
					if(m.koed || m.meditating || m.selftraining || m.KB) return
					if(s in m)
						if(m.skill_majinize == null) m.skill_majinize = s
					if(s.active == 0)
						if(m.stance) //Switch off all stances
							m.disable_stances(null,1)
						if(m.grab) m.letgo()

						if(m.energy < m.energy_max/1.05)
							m << output("<font color = teal>You need to be at max energy to attempt the majinization process.","chat.system")
							m.set_alert("Need max energy",s.icon,s.icon_state)
						//	m.create_chat_entry("alerts","You need to be at max energy to attempt the majinization process.")
							return

						m.open_skills = 0
						m.open_menus.Remove(".open_skills")
						winshow(m,"skills",0)
						//m.left_click_function = "revive"
						//m.set_alert("Select target to revive",s.icon,s.icon_state)
						s.icon_state = "majinize"
						var/mob/trg = m
						if(m.target) trg = m.target
						if(trg.client)
							m.left_click_function = null
							if(get_dist(m,trg) > 2)
								m << output("<font color = teal>They are too far away to interact with.","chat.system")
								m.set_alert("Too far away",'alert.dmi',"alert")
							//	m.create_chat_entry("alerts","They are too far away to interact with.")
								m.skill_majinize.icon_state = "majinize off"
								return
							//if(trg.has_body == 0)
							//	m << output("<font color = teal>They need to have a body to attempt the revivification process.","chat.system")
							//	m.set_alert("Need body",m.skill_revive.icon,m.skill_revive.icon_state)
							//	m.create_chat_entry("alerts","They need to have a body to attempt the revivification process.")
							//	m.skill_revive.icon_state = "Revivification off"
							//	return
							if(trg.has_majin >= 1)
								m << output("<font color = teal>They are already Majin.","chat.system")
								m.set_alert("They are already Majin.",s.icon,s.icon_state)
								m.skill_majinize.icon_state = "majinize off"
							//	m.create_chat_entry("alerts","They are already Majin.")
								return
							else if(trg.has_majin == 0)
								for(var/obj/skills/Meditate/med in m)
									if(med.active) call(med.act)(m,med)
								switch(alert(m,"What Level of Majin will you be making them?\n1: 250% Boost, little control.\n2:500% Boost, stun control.\n3:1000% Boost, stun control, movement control, self-destruct control.\n\nEach level's energy cost varies, and upon success, they will learn a skill that will help them to Break Out of the majin control. It is your duty to continue to investing energy into them to further the hold.","","Level 1","Level 2","Level 3"))
									if("Level 1") s.intended_level = 1
									if("Level 2") s.intended_level = 2
									if("Level 3") s.intended_level = 3
									//	s.active = 1
								s.active=1
								m.skill_majinize.active = 1
								m.skill_majinize.skill_target = trg
								m.icon_state = "2HBlast"
								m.stunned += 1
								m.stunned_pending += 1
								m.client.screen += m.skill_majinize.bar
								if(trg != m) trg.client.screen += m.skill_majinize.bar
								m.create_chat_entry("local","[m] begins the process of granting [trg] power.</font>",0,1)

						else
							s.icon_state = "majinize off"
							m.set_alert("Only used on players",'alert.dmi',"alert")
						//	m.create_chat_entry("alerts","Only used on players.")
							return
					else
						s.active = 0
						m.stunned -= 1
						m.stunned_pending -= 1
						m.icon_state = ""
						m.client.screen -= s.bar_inner
						m.client.screen -= s.bar
						s.bar_inner.screen_loc = "16:-2,10:-3"
						s.progress = 0
						s.icon_state = "majinize off"
						if(s.skill_target && s.skill_target.client)
							s.skill_target.client.screen -= s.bar_inner
							s.skill_target.client.screen -= s.bar
						s.skill_target = null
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:revive_bar_inner
				category = list("Regeneration","Utility")
				src.info = text_majinize


				//if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active)
								var/mob/m = null
								if(ismob(src.loc))
									if(src.skill_target)
										var/mob/tar = src.skill_target
										m = src.loc
										if(get_dist(m,tar) <= 2)
											if(tar.has_majin <=0)
												if(m.energy >= src.skill_lvl+10)
													m.energy -= src.skill_lvl+10;
													src.progress += 1+round(src.skill_lvl/10)
													//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
													src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
													if(src.skill_exp >= 100 && src.skill_lvl < 100)
														src.skill_exp = 1
														src.skill_lvl += 1
														src.skill_up(m)

												if(m.client)
													m.client.screen -= src.bar_inner
													src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
													var/matrix/M = matrix()
													M.Scale(round(src.progress),1)
													src.bar_inner.transform = M
													m.client.screen += src.bar_inner
													if(tar.client && tar != m)
														tar.client.screen -= src.bar_inner
														src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
														var/matrix/M2 = matrix()
														M2.Scale(round(src.progress),1)
														src.bar_inner.transform = M2
														tar.client.screen += src.bar_inner

												var/obj/effects/orb/o = new
												o.loc = tar.loc
												o.icon *= tar.auracolor
												o.step_x = tar.step_x
												o.step_y = tar.step_y
												o.pixel_x = rand(-64,64)
												o.pixel_y = rand(-64,64)
												animate(o,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
												spawn(10)
													if(o) qdel(o)

												if(m.koed || m.meditating)
													call(src.act)(m,src)
												var/neededenergy = (tar.energy_max/tar.psionic_power)
												if(src.progress >= 100)
													if(m.energy_max >= neededenergy)
														tar.majinize(src.intended_level,m)
														m.icon_state = ""

														m.set_alert("You have Majinized [tar.real_name] to Level [src.intended_level]!",src.icon,src.icon_state)
														m.create_chat_entry("alerts","You have Majinized [tar.real_name] to Level [src.intended_level]!")
														//view(8,m) << output("<font color = purple> [m] finishes reknitting [tar]'s soul and fuses it back to their body.", "chat.local")
														if(src.active) call(src.act)(m,src)
														for(var/obj/skills/Majin/mjn in tar)
															if(mjn.active == 0)
																mjn.activate(tar,mjn)
																mjn.controller = m
													else
														if(prob(50))
															tar.majinize(src.intended_level,m)
															m.icon_state = ""
															m.set_alert("You have Majinized [tar.real_name] to Level [src.intended_level]!",src.icon,src.icon_state)
															m.create_chat_entry("alerts","You have Majinized [tar.real_name] to Level [src.intended_level]!")
														//	view(8,m) << output("<font color = purple> [m] finishes reknitting [tar]'s soul and fuses it back to their body.", "chat.local")
															if(src.active) call(src.act)(m,src)
															for(var/obj/skills/Majin/mjn in tar)
																if(mjn.active == 0)
																	mjn.activate(tar,mjn)
																	mjn.controller = m

														else
															m.icon_state = ""

															m.set_alert("You failed to Majinize [tar.real_name]!",tar.icon,tar.icon_state)
															m.create_chat_entry("alerts","You failed to Majinize [tar.real_name]!")
														//	view(8,m) << output("<font color = purple> [m] finishes reknitting [tar]'s soul and fuses it back to their body.", "chat.local")
															if(src.active) call(src.act)(m,src)
										else if(src.active)
											m.set_alert("Target too far",'alert.dmi',"alert")
											m.create_chat_entry("alerts","Target too far.")
											if(src.skill_target && src.skill_target != m)
												src.skill_target.set_alert("Target too far",'alert.dmi',"alert")
												src.skill_target.create_chat_entry("alerts","Target too far.")
											call(src.act)(m,src)
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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


		Mystic
			icon_state = "mystic off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 1500
			info_buffs = "+20% Force"
			info_duration = "Toggleable"
			info_point_cost_type = "force"
			info_name = "mystic"
			act = /obj/skills/Mystic/proc/activate
			info_stats = "+20% Force\n\nConstant energy drain\n\nToggleable"
			hud_x = 20
			hud_y = 636
			var/mob/granter
			proc
				activate(var/mob/m,var/obj/skills/Mystic/s)

					var/needed = (10/m.mod_recovery) + (10/s.skill_lvl)
					if(s.active)
						//m.buffs -= "focus"
						s.active = 0
					//	if(m.client) m.power_sources -= m.buff_mystic

						//m.overlays -= 'focus_eyes.dmi'
						//m.overlays -= /obj/effects/eyes_focus
						s.icon_state = "mystic off"
					//	if(m.race == "Alien") m.overlays -= /obj/effects/elec_cerebroid
						m.overlays -= /obj/effects/elec_mystic
						m.med_pixel = 1
						m.shock_chance = 0
					//	src.controller = null
						//m.mod_force/=1.2
						//m.multi_force -= 0.2
					//	m.vis_contents -= m.eyes_white
					//	m.vis_contents -= m.eyes
						if(m.eyes)
							m.eyes = m.eyes_copy
						//	if(proceed)
						//		m.vis_contents += m.eyes_white
							//	m.vis_contents += m.eyes
						//animate(m)
						var/turf/t = m.loc
						if(t && t.liquid == null) animate(m)
						//m.mods(list("Strength","Endurance","resistance","offence","defence","Regeneration","Agility","force"))
						//if(m.meditating)
							//animate(m,pixel_y = initial(m.pixel_y), time = 10)

					else if(m.energy >= needed)
						//m.buffs += "focus"
						s.active = 1
						s.icon_state = "mystic"
						var/turf/t = m.loc
						if(!t.liquid)
							var/obj/effects/dust_medium/d = new
							d.SetCenter(m)
						if(m.race == "Alien")
							m.overlays -= /obj/effects/elec_mystic
							m.overlays += /obj/effects/elec_mystic
						else
							m.overlays -= /obj/effects/elec_mystic
							m.overlays += /obj/effects/elec_mystic
						//for(var/mob/h in view(8,m))
							//h << sound('focus1.mp3',0,1,10,100)
						m.shock_chance = 10
						//m.mod_force*=1.2
						//m.multi_force += 0.2
					//	m.vis_contents -= m.eyes_white
					//	m.vis_contents -= m.eyes
						if(m.eyes)
							if(m.race == "Kai") m.eyes = global.eyes_focus_celestial
							else m.eyes = global.eyes_focus
						//	if(proceed)
							//	m.vis_contents += m.eyes_white
						//		m.vis_contents += m.eyes
						//hearers(8,m) << 'shockwave.wav'
						m.shockwave()
						if(m.meditating)
							var/pix_y = 0
							//if(m.race == "Alien") pix_y = -16
							animate(m,pixel_y = 10, time = 20,loop = -1,flags = ANIMATION_PARALLEL)
							animate(pixel_y = pix_y, time = 20)
						// do if majin_level == 1, and set buff_majin1 and so forth
						var/obj/buffs_and_debuffs/b = m.buff_mystic

						var/txt = "<br><u>Sources</u>"
						for(var/x in m.power_sources)
							txt = "[txt]<br>[x]."
						b.info_txt.maptext = "<font size = 1><text align=center valign=top>[b.desc][txt]"
						b:activate(m,b)
					//	b.active = 1;

					//	if(m.power_sources && islist(m.power_sources) && m.power_sources.Find("From Mystic Skill") == 0) m.power_sources += "From Mystic Skill"
						//hearers(8,m) << 'focus_activate.wav'
						//hearers(8,m) << 'electric.wav'
					//if(m.part_selected) m.part_selected.part_stats(m) //Update the reward for completing training on this body part.

			New()
				..()
				category = list("Force","Agility","Buff")
				spawn(10)
					src.info = text_focus


					if(src.disable_sleep) return
					spawn(10)
						while(src)
							var/mob/m = null
							if(ismob(src.loc))
								m = src.loc
								if(src.active)
									var/removes = (10/m.mod_recovery) + (10/src.skill_lvl)

									if(m.energy >= removes)
										//m.energy-=5+((m.energy_max/5)/src.skill_lvl)/m.mod_recovery/m.mod_energy
										//var/removes = 1 + 10 - (m.mod_recovery+m.mod_energy) - (src.skill_lvl/10)
									//	m.energy -= removes
										//world << "[removes] energy removed by [src]"
										//m << output("<font color = teal>[removes] energy removed by [src]","chat.system")
										if(m.meditating)
											var/proceed = 1
											for(var/obj/items/tech/Bio_Rejuvination_Tank/t in range(2,m))
												if(bounds_dist(t, m) < 3)
													proceed = 0
											if(proceed)
												//animate(m,pixel_y = 2, time = 10)
												//animate(m,pixel_y = 10, time = 11)
												if(m.reflection) animate(m.reflection,pixel_y = 10, time = 11)
										//src.skill_exp += (5-(src.skill_lvl/20))*m.mod_skill
										//m.gain_stat("force",1,1,"From Focus skill")
										//src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
										src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)
										if(m.energy < 1)
											m.mouse_dir = "left"
											call(src.act)(m,src)
									//else
									//	m.mouse_dir = "left"
										//call(src.act)(m,src)
							sleep(5)
							if(m) if(src.active) if(m.meditating)
								var/proceed = 1
								for(var/obj/items/tech/Bio_Rejuvination_Tank/t in range(2,m))
									if(bounds_dist(t, m) < 3)
										proceed = 0
								if(proceed)
									//animate(m,pixel_y = 0, time = 11)
									if(m.reflection) animate(m.reflection,pixel_y = 0, time = 11)
							sleep(5)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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


		Mysticize // 15x Boost, very high energy cost,
			icon_state = "mysticize off"
			info_energy_cost = 4
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 3000
			info_name = "mysticize"
			info_buffs = ""
			info_duration = "Channeled"
			info_point_cost_type = "regen"
			act = /obj/skills/Mysticize/proc/activate
			hud_x = 20
			hud_y = 588
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/tmp/mob/skill_target = null
			var/intension = 0
			proc
				activate(var/mob/m,var/obj/skills/Mysticize/s)
					if(m.koed || m.meditating || m.selftraining || m.KB) return
					if(s in m)
						if(m.skill_mysticize == null) m.skill_mysticize = s
					if(s.active == 0)
						if(m.stance) //Switch off all stances
							m.disable_stances(null,1)
						if(m.grab) m.letgo()

						if(m.energy < m.energy_max/1.05)
							m << output("<font color = teal>You need to be at max energy to attempt the Mystic process.","chat.system")
							m.set_alert("Need max energy",s.icon,s.icon_state)
							m.create_chat_entry("alerts","You need to be at max energy to attempt the Mystic process.")
							return

						m.open_skills = 0
						m.open_menus.Remove(".open_skills")
						winshow(m,"skills",0)
						//m.left_click_function = "revive"
						//m.set_alert("Select target to revive",s.icon,s.icon_state)
						s.icon_state = "mysticize"
						var/mob/trg = m
						if(m.target) trg = m.target
						if(trg.client)
							m.left_click_function = null
							if(get_dist(m,trg) > 2)
								m << output("<font color = teal>They are too far away to interact with.","chat.system")
								m.set_alert("Too far away",'alert.dmi',"alert")
								m.create_chat_entry("alerts","They are too far away to interact with.")
								m.skill_majinize.icon_state = "mysticize off"
								return
							//if(trg.has_body == 0)
							//	m << output("<font color = teal>They need to have a body to attempt the revivification process.","chat.system")
							//	m.set_alert("Need body",m.skill_revive.icon,m.skill_revive.icon_state)
							//	m.create_chat_entry("alerts","They need to have a body to attempt the revivification process.")
							//	m.skill_revive.icon_state = "Revivification off"
							//	return
							if(trg.has_mystic >= 1)
								m << output("<font color = teal>They are already possess Mystic.","chat.system")
								m.set_alert("They are already possess Mystic.",s.icon,s.icon_state)
								m.skill_mysticize.icon_state = "mysticize off"
								m.create_chat_entry("alerts","They are already possess Mystic.")
								return
							else if(trg.has_mystic == 0)
								for(var/obj/skills/Meditate/med in m)
									if(med.active) call(med.act)(m,med)
								switch(alert(m,"Granting another being Mystic is considered a very bold responsibility to have, considering you'll be giving someone access to tap into a power that grants them a huge power increase.\nAre you sure you wish to grant them Mystic?","","Yes","No","Cancel"))
									if("Yes") s.intension = 1
									if("No")
										m.skill_mysticize = null
										m.skill_mysticize.icon_state = "mysticize off"
										return
									if("Cancel")
										m.skill_mysticize = null
										m.skill_mysticize.icon_state = "mysticize off"
										return
									//	s.active = 1
								s.active=1
								m.skill_mysticize.active = 1
								m.skill_mysticize.skill_target = trg
								m.icon_state = "2HBlast"
								m.stunned += 1
								m.stunned_pending += 1
								m.client.screen += m.skill_mysticize.bar
								if(trg != m) trg.client.screen += m.skill_mysticize.bar
								m.create_chat_entry("local","[m] begins the process of granting [trg] power.</font>",0,1)

						else
							s.icon_state = "mysticize off"
							m.set_alert("Only used on players",'alert.dmi',"alert")
						//	m.create_chat_entry("alerts","Only used on players.")
							return
					else
						s.active = 0
						m.stunned -= 1
						m.stunned_pending -= 1
						m.icon_state = ""
						m.client.screen -= s.bar_inner
						m.client.screen -= s.bar
						s.bar_inner.screen_loc = "16:-2,10:-3"
						s.progress = 0
						s.icon_state = "mysticize off"
						if(s.skill_target && s.skill_target.client)
							s.skill_target.client.screen -= s.bar_inner
							s.skill_target.client.screen -= s.bar
						s.skill_target = null
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:revive_bar_inner
				category = list("Regeneration","Utility")
				src.info = text_mysticize


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active)
								var/mob/m = null
								if(ismob(src.loc))
									if(src.skill_target)
										var/mob/tar = src.skill_target
										m = src.loc
										if(get_dist(m,tar) <= 2)
											if(tar.has_mystic <=0)
												if(m.energy >= src.skill_lvl+10)
													m.energy -= src.skill_lvl+10;
													src.progress += 1+round(src.skill_lvl/10)
													//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
													src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
													if(src.skill_exp >= 100 && src.skill_lvl < 100)
														src.skill_exp = 1
														src.skill_lvl += 1
														src.skill_up(m)

												if(m.client)
													m.client.screen -= src.bar_inner
													src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
													var/matrix/M = matrix()
													M.Scale(round(src.progress),1)
													src.bar_inner.transform = M
													m.client.screen += src.bar_inner
													if(tar.client && tar != m)
														tar.client.screen -= src.bar_inner
														src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
														var/matrix/M2 = matrix()
														M2.Scale(round(src.progress),1)
														src.bar_inner.transform = M2
														tar.client.screen += src.bar_inner

												var/obj/effects/orb/o = new
												o.loc = tar.loc
												o.icon *= tar.auracolor
												o.step_x = tar.step_x
												o.step_y = tar.step_y
												o.pixel_x = rand(-64,64)
												o.pixel_y = rand(-64,64)
												animate(o,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
												spawn(10)
													if(o) qdel(o)

												if(m.koed || m.meditating)
													call(src.act)(m,src)
												var/neededenergy = (tar.energy_max/tar.psionic_power)
												if(src.progress >= 100)
													if(m.energy_max >= neededenergy)
														tar.mysticize(m)
														m.icon_state = ""

														m.set_alert("You have granted [tar.real_name] Mystic!",src.icon,src.icon_state)
														m.create_chat_entry("alerts","You have granted [tar.real_name] Mystic!")
														//view(8,m) << output("<font color = purple> [m] finishes reknitting [tar]'s soul and fuses it back to their body.", "chat.local")
														if(src.active) call(src.act)(m,src)
														for(var/obj/skills/Mystic/myst in tar)
															myst.granter = m
													else
														if(prob(50))
															tar.mysticize(m)
															m.icon_state = ""
															m.set_alert("You have granted [tar.real_name] Mystic!",src.icon,src.icon_state)
															m.create_chat_entry("alerts","You have granted [tar.real_name] Mystic!")
														//	view(8,m) << output("<font color = purple> [m] finishes reknitting [tar]'s soul and fuses it back to their body.", "chat.local")
															if(src.active) call(src.act)(m,src)
															for(var/obj/skills/Mystic/myst in tar)
																myst.granter = m

														else
															m.icon_state = ""

															m.set_alert("You failed to grant [tar.real_name] Mystic!",tar.icon,tar.icon_state)
															m.create_chat_entry("alerts","You failed to grant [tar.real_name] Mystic!")
														//	view(8,m) << output("<font color = purple> [m] finishes reknitting [tar]'s soul and fuses it back to their body.", "chat.local")
															if(src.active) call(src.act)(m,src)
										else if(src.active)
											m.set_alert("Target too far",'alert.dmi',"alert")
											m.create_chat_entry("alerts","Target too far.")
											if(src.skill_target && src.skill_target != m)
												src.skill_target.set_alert("Target too far",'alert.dmi',"alert")
												src.skill_target.create_chat_entry("alerts","Target too far.")
											call(src.act)(m,src)
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Create_Witch_Pot // WITCHES - Creates carryable witch pot that can store energy from people up to 15% Maximmum storage up to 10,000,000 ME%
			icon_state = "create pot off"
			info_name = "create_witch_pot"
			info_stats = "Allows the collection of information from artifacts."
			info = "You'll need to know how to gather some resources if you're going to want to survive."
			act = /obj/skills/Create_Witch_Pot/proc/activate
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null

			var/creating = 0
			proc
				activate(var/mob/m,var/obj/skills/Create_Witch_Pot/s)

					if(m.meditating || m.selftraining || m.beaming || m.KB) return
					if(s.active == 0)


						if(s.creating==1)
							m.set_alert("You are already creating something!",s.icon,s.icon_state)
							m.create_chat_entry("alerts","You are already creating something!")
							return
						if(s.creating==0)
							if(m.stance) //Switch off all stances
								m.disable_stances(null,1)
							//if(m.grab) m.letgo()
							if(m.energy_max <= 2500)
								m.set_alert("Not enough energy!",s.icon,s.icon_state)
								m.create_chat_entry("alerts","Not enough energy!")
								return
							for(var/obj/skills/Meditate/med in m)
								if(med.active) call(med.act)(m,med)
						/*	for(var/obj/skills/Dark_Transmutation/dt in m)
								if(dt.active) call(dt.act)(m,dt)
							for(var/obj/skills/Dark_Infusion/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Divine_Infusion/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Dark_Petrifaction/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Germination/gm in m)
								if(gm.active) call(gm.act)(m,gm) */
							//m.energy = 1
							s.active = 1
							s.icon_state = "create pot"
							s.creating = 1
							//m.icon_state = "Meditate"
							m.stunned += 1
							m.stunned_pending += 1
							m.client.screen += s.bar
							//m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
							animate(m, color = list("#000", "#000", "#000", "#fff"),time = 20, loop = -1)
							animate(color = initial(m.color),time = 20)
					else
						s.active = 0
						m.stunned -= 1
						m.stunned_pending -= 1
						m.icon_state = ""
						if(m.client)
							m.client.screen -= s.bar_inner
							m.client.screen -= s.bar
						s.bar_inner.screen_loc = "16:-2,10:-3"
						s.progress = 0
						s.creating = 0
						s.icon_state = "create pot off"
						animate(m)
						//m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:gather_bar_inner
				category = list("Utility","Intelligence")


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active)
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									src.progress += 10+round(src.skill_lvl/10)
									//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
									src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

									if(m.client)
										m.client.screen -= src.bar_inner
										src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
										var/matrix/M = matrix()
										M.Scale(round(src.progress),1)
										src.bar_inner.transform = M
										m.client.screen += src.bar_inner


									if(m.koed || m.meditating)
										call(src.act)(m,src)
										animate(m)
									if(src.progress >= 100)
										src.progress = 0
									//	var/exp = m.mod_arcane_potential
										//var/obj/items/consumables/water/water_bottle_dirty/b = new/obj/items/consumables/water/water_bottle_dirty
										//Player should have a list of lists. Inside each sub-list should be all the organs missings for that limb.


									//	m.tiredness_rate -= (m.energy_max/rand(45,55))*(m.mod_recovery)*((m.weight*0.05)**0.1)
										m.lvlupwave(0,m)
										var/obj/items/tech/drainers/Witch_Pot/ED = new /obj/items/tech/drainers/Witch_Pot
										ED.loc = get_step(m, m)
										ED.step_x = m.step_x
										ED.step_y = m.step_y
										animate(ED,alpha = 255, time = 7)
										m.energy_max -= (m.energy_max*0.15)
										m.set_alert("You sacrificed 15% of your energy to create a Witch Pot.",src.icon,src.icon_state)

										if(src.active) call(src.act)(m,src)


							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Create_Energy_Drainer // WIZARDS- creates carryable drainer that can steal energy from people 10%, maximum storage up to 10,000,000 ME%
			icon_state = "create drainer off"
			info_name = "create_energy_drainer"
			info_stats = "Allows the collection of information from artifacts."
			act = /obj/skills/Create_Energy_Drainer/proc/activate
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/nearby_artifact=0
			var/creating = 0
			proc
				activate(var/mob/m,var/obj/skills/Create_Energy_Drainer/s)

					if(m.meditating || m.selftraining || m.beaming || m.KB) return
					if(s.active == 0)


						if(s.creating==1)
							m.set_alert("You are already creating something!",s.icon,s.icon_state)
							m.create_chat_entry("alerts","You are already creating something!")
							return
						if(s.creating==0)
							if(m.stance) //Switch off all stances
								m.disable_stances(null,1)
							//if(m.grab) m.letgo()
							if(m.energy_max <= 2500)
								m.set_alert("Not enough energy!",s.icon,s.icon_state)
								m.create_chat_entry("alerts","Not enough energy!")
								return
							for(var/obj/skills/Meditate/med in m)
								if(med.active) call(med.act)(m,med)
						/*	for(var/obj/skills/Dark_Transmutation/dt in m)
								if(dt.active) call(dt.act)(m,dt)
							for(var/obj/skills/Dark_Infusion/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Divine_Infusion/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Dark_Petrifaction/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Germination/gm in m)
								if(gm.active) call(gm.act)(m,gm) */
							//m.energy = 1
							s.active = 1
							s.icon_state = "create drainer"
							s.creating = 1
							//m.icon_state = "Meditate"
							m.stunned += 1
							m.stunned_pending += 1
							m.client.screen += s.bar
							//m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
							animate(m, color = list("#000", "#000", "#000", "#fff"),time = 20, loop = -1)
							animate(color = initial(m.color),time = 20)
					else
						s.active = 0
						m.stunned -= 1
						m.stunned_pending -= 1
						m.icon_state = ""
						if(m.client)
							m.client.screen -= s.bar_inner
							m.client.screen -= s.bar
						s.bar_inner.screen_loc = "16:-2,10:-3"
						s.progress = 0
						s.creating = 0
						s.icon_state = "create drainer off"
						animate(m)
						//m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:gather_bar_inner
				category = list("Utility","Intelligence")
				src.info = text_create_energy_drainer


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active)
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									src.progress += 10+round(src.skill_lvl/10)
									//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
									src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

									if(m.client)
										m.client.screen -= src.bar_inner
										src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
										var/matrix/M = matrix()
										M.Scale(round(src.progress),1)
										src.bar_inner.transform = M
										m.client.screen += src.bar_inner


									if(m.koed || m.meditating)
										call(src.act)(m,src)
										animate(m)
									if(src.progress >= 100)
										src.progress = 0
									//	var/exp = m.mod_tech_potential
										//var/obj/items/consumables/water/water_bottle_dirty/b = new/obj/items/consumables/water/water_bottle_dirty
										//Player should have a list of lists. Inside each sub-list should be all the organs missings for that limb.


									//	m.tiredness_rate -= (m.energy_max/rand(45,55))*(m.mod_recovery)*((m.weight*0.05)**0.1)
										m.lvlupwave(0,m)
										var/obj/items/tech/drainers/Energy_Drainer/ED = new /obj/items/tech/drainers/Energy_Drainer
										ED.loc = get_step(m, m)
										ED.step_x = m.step_x
										ED.step_y = m.step_y
										animate(ED,alpha = 255, time = 7)
										m.energy_max -= (m.energy_max*0.25)
										m.set_alert("You sacrificed 25% of your energy to create an Energy Drainer.",src.icon,src.icon_state)

										if(src.active) call(src.act)(m,src)


							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Materialization // 4% Energy per Kilogram for making weights

		Majin_Break_Out // Skill to help break out of Majin level. Yearly Cooldown.

		Majin_Infusion // Skill for Wizards to help invest energy into their Majins for better control

		Underworld_Portal // Portal to Underworld where Buu Eggs(Incubator Eggs) are housed and can be summoned.
			icon_state = "uw portal off"
			info_name = "underworld_portal"
			info_stats = "Allows the summoning of a portal that leads to a forbidden underworld."
			info = "Allows the summoning of a portal that leads to a forbidden underworld."
			act = /obj/skills/Underworld_Portal/proc/activate
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/nearby_artifact=0
			var/summoning = 0
			var/portal_opened = 0
			var/obj/items/environmental/blackhole2/portal
			var/act_jump =/obj/skills/Underworld_Portal/proc/send_back

			proc
				send_back(var/mob/m,var/obj/skills/Underworld_Portal/s)
					if(m.z == 18 )
						if(s.portal.loc)
							m.loc = get_step(s.portal, s.portal)
						else if(s.portal.loc == null || !s.portal)
							switch(alert(m,"The portal back to the main world has dispersed, jumping back will send you to a random planet, do you wish to jump or wait?","","Go","Wait"))
								if("Go")
									switch(rand(1,4))
										if(1)
											m.loc=locate(rand(10,450),rand(10,450),1)
										if(2)
											m.loc=locate(rand(10,450),rand(10,450),3)
										if(3)
											m.loc=locate(rand(10,450),rand(10,450),9)
										if(4)
											m.loc=locate(rand(10,450),rand(10,450),11)


				activate(var/mob/m,var/obj/skills/Underworld_Portal/s)

					if(m.meditating || m.selftraining || m.beaming || m.KB) return


					if(s.active == 0)
						if(s.last_used != null)
							if(year-s.last_used < 1)
								m << output("<font color = teal>This can only be used once every year. Next use will be available in [1-(year-s.last_used)] years.","chat.system")
								m.set_alert("Available in [1-(year-s.last_used)] year",s.icon,s.icon_state)
								m.create_chat_entry("alerts","Available in [1-(year-s.last_used)] year.")
								return

						if(s.summoning==1)
							m.set_alert("You are already summoning a portal!",s.icon,s.icon_state)
							m.create_chat_entry("alerts","You are already summoning a portal!")
							return
						if(s.summoning==0)
							if(m.stance) //Switch off all stances
								m.disable_stances(null,1)
							//if(m.grab) m.letgo()
							if(m.energy <= (m.energy_max*0.50))
								m << output("<font color = teal>You are too tired to research anything!","chat.system")
								m.set_alert("Not enough energy!",s.icon,s.icon_state)
								m.create_chat_entry("alerts","Not enough energy!")
								return
							for(var/obj/skills/Meditate/med in m)
								if(med.active) call(med.act)(m,med)
						/*	for(var/obj/skills/Dark_Transmutation/dt in m)
								if(dt.active) call(dt.act)(m,dt)
							for(var/obj/skills/Dark_Infusion/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Divine_Infusion/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Dark_Petrifaction/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Germination/gm in m)
								if(gm.active) call(gm.act)(m,gm) */
							//m.energy = 1
							s.active = 1
							s.icon_state = "uw portal"
							s.summoning = 1
							//m.icon_state = "Meditate"
							m.stunned += 1
							m.stunned_pending += 1
							m.client.screen += s.bar
							//m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
							animate(m, color = list("#000", "#000", "#000", "#fff"),time = 20, loop = -1)
							animate(color = initial(m.color),time = 20)




					else
						if(s.portal_opened == 1)
							s.active = 0
							m.stunned -= 1
							m.stunned_pending -= 1
							m.icon_state = ""
							if(m.client)
								m.client.screen -= s.bar_inner
								m.client.screen -= s.bar
							s.bar_inner.screen_loc = "16:-2,10:-3"
							s.progress = 0
							s.summoning = 0
							s.icon_state = "uw portal off"
							animate(m)
							m.energy -= (m.energy_max*0.25)


							var/obj/items/environmental/blackhole2/bh = new
							bh.loc = get_step(m,m)
							s.portal = bh
							bh.transform = matrix()*0.1
							bh.grown = 0
							bh.layer = m.layer+0.1

							animate(bh)
							animate(bh,transform = matrix()*1, time = 90)
							bh.spin()
							m.set_alert("You've summoned a portal to the underworld.",s,s.icon_state)
							//if(s.portal && s.portal.grown == 0)
							//	s.portal.destroy()
							//	s.portal = null

							//m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:gather_bar_inner
				category = list("Utility","Intelligence")



				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active)
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									src.progress += 10+round(src.skill_lvl/10)
									//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
									src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

									if(m.client)
										m.client.screen -= src.bar_inner
										src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
										var/matrix/M = matrix()
										M.Scale(round(src.progress),1)
										src.bar_inner.transform = M
										m.client.screen += src.bar_inner


									if(m.koed || m.meditating)
										call(src.act)(m,src)
										animate(m)
									if(src.progress >= 100)
										src.progress = 0
									//	var/exp = m.mod_tech_potential
										//var/obj/items/consumables/water/water_bottle_dirty/b = new/obj/items/consumables/water/water_bottle_dirty
										//Player should have a list of lists. Inside each sub-list should be all the organs missings for that limb.


									//	m.tiredness_rate -= (m.energy_max/rand(45,55))*(m.mod_recovery)*((m.weight*0.05)**0.1)
										m.lvlupwave(0,m)
										//var/obj/effects/portal/Underworld_Portal/UWP = new /obj/effects/portal/Underworld_Portal
									//	UWP.loc = get_step(m, m)
									//	UWP.step_x = m.step_x
										////UWP.step_y = m.step_y
										//animate(UWP,alpha = 255, time = 7)
										//m.energy_max -= (m.energy_max*0.25)
										//m.set_alert("You've summoned a portal to the underworld.",src.icon,src.icon_state)
										src.portal_opened = 1
										if(src.active) call(src.act)(m,src)


							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
					if(dir == "right")
						if(src in m)
							call(src.act_jump)(m,src)

		Create_Namekian_Dragonballs
			name = "Create Namekian Dragonballs"
			icon_state = "unlockpotential off"
			info_name = "create namekian dragonballs"
			info = "Forge a set of 7 magical orbs. When gathered, they can summon a powerful dragon capable of granting three wishes."
			info_energy_cost = 3
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 2500
			info_buffs = ""
			info_duration = "Instant"
			hud_x = 22
			hud_y = 620

			category = list("Utility")
			act = /obj/skills/Create_Namekian_Dragonballs/proc/activate
			var/list/ball_names = list("One", "Two", "Three", "Four", "Five", "Six", "Seven")
			//var/planet_z
			New()
				..()
				category = list("Utility")
				spawn(10)
					if(ismob(src.loc))
						var/mob/m = src.loc
						if(m.skill_createdbs == null) m.skill_createdbs = src
			proc
				activate(var/mob/m, var/obj/skills/Create_Namekian_Dragonballs/s)
					if(m.koed || m.KB || m.stunned || s.active) return
					if(m.energy < 2500)
						m << output("You lack the energy to create Dragonballs right now.", "actionoutput")
						return
					s.active = 1
					m << output("You begin creating Dragonballs...", "actionoutput")
					//m.set_alert("Creating Dragonballs...", s.icon, s.icon_state)
					m.stunned += 1
					//planet_z = (m.z)
					spawn(1)
						for(var/name in s.ball_names)
							m<<"[name] Star Dragonball found."
							var/obj/items/Namekian_Dragonball/DB = new(locate(m.x + rand(-1, 1), m.y + rand(-1, 1), m.z))
							DB.name = "[name] Star Dragonball"
							DB.owner = m
							DB.Home = m.z
							DB.WishPower = m.energy_max
							DB.Active()
						m << output("You have created the Dragonballs and scattered them across the planet!", "actionoutput")
					//	m.create_chat_entry("local", "[m] creates a set of magical orbs and casts them across the planet.", 0, 1)

						for(var/obj/items/Namekian_Dragonball/A in world)
							if(A.owner == m)
								spawn A.Scatter()

						//log_game("[key_name(m)] has created and scattered Dragonballs on Z[m.z].")
						//logAndAlertAdmins("[key_name(m)] has created Dragonballs.")

						m.stunned -= 1
						s.active = 0

			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Create_Dragonballs
			name = "Create Dragonballs"
			icon_state = "unlockpotential off"
			info_name = "create dragonballs"
			info = "Forge a set of 7 magical orbs. When gathered, they can summon a powerful dragon capable of granting wishes."
			info_energy_cost = 3
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 2500
			info_buffs = ""
			info_duration = "Instant"
			hud_x = 22
			hud_y = 620

			category = list("Utility")
			act = /obj/skills/Create_Dragonballs/proc/activate
			var/list/ball_names = list("One", "Two", "Three", "Four", "Five", "Six", "Seven")
			//var/planet_z
			New()
				..()
				category = list("Utility")
				spawn(10)
					if(ismob(src.loc))
						var/mob/m = src.loc
						if(m.skill_createdbs == null) m.skill_createdbs = src
			proc
				activate(var/mob/m, var/obj/skills/Create_Dragonballs/s)
					if(m.koed || m.KB || m.stunned || s.active) return
					if(m.energy < 2500)
						m << output("You lack the energy to create Dragonballs right now.", "actionoutput")
						return
					s.active = 1
					m << output("You begin creating Dragonballs...", "actionoutput")
					//m.set_alert("Creating Dragonballs...", s.icon, s.icon_state)
					m.stunned += 1
					//planet_z = (m.z)
					spawn(1)
						for(var/name in s.ball_names)
							m<<"[name] Star Dragonball found."
							var/obj/items/Earth_Dragonball/DB = new(locate(m.x + rand(-1, 1), m.y + rand(-1, 1), m.z))
							DB.name = "[name] Star Dragonball"
							DB.owner = m
							DB.Home = m.z
							DB.WishPower = m.energy_max
							DB.Active()
						m << output("You have created the Dragonballs and scattered them across the planet!", "actionoutput")
					//	m.create_chat_entry("local", "[m] creates a set of magical orbs and casts them across the planet.", 0, 1)

						for(var/obj/items/Earth_Dragonball/A in world)
							if(A.owner == m)
								spawn A.Scatter()

						//log_game("[key_name(m)] has created and scattered Dragonballs on Z[m.z].")
						//logAndAlertAdmins("[key_name(m)] has created Dragonballs.")

						m.stunned -= 1
						s.active = 0

			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Judgement
			icon_state = "judgement off"
			info_energy_cost = 2
			info_mastery = 1
			info_point_cost = 2
			teach_energy = 1500
			info_name = "Judgement"
			info_buffs = ""
			info_duration = "Instant"
			info_point_cost_type = "regen"
			hud_x = 22
			hud_y = 588
			act = /obj/skills/Judgement/proc/activate
			var/tmp/progress = 0
			var/tmp/obj/bar = null
			var/tmp/obj/bar_inner = null
			var/tmp/mob/skill_target = null
			var/tmp/list/used_on = list()
			var/tmp/sendlocation = 2

			proc/activate(var/mob/m, var/obj/skills/Judgement/s)
				if(m.koed || m.meditating || m.selftraining || m.KB) return
				if(s in m && m.energy >= m.energy_max/1.05)
					if(m.stance) m.disable_stances(null,1)
					if(m.grab) m.letgo()

					m.open_skills = 0
					m.open_menus.Remove(".open_skills")
					winshow(m,"skills",0)
					s.icon_state = "judgement"
					var/mob/trg = m
					if(m.target) trg = m.target

					if(trg.client)
						if(get_dist(m,trg) > 2)
							m.set_alert("Too far away",'alert.dmi',"alert")
						//	m.create_chat_entry("alerts","They are too far away to interact with.")
							s.icon_state = "judgement off"
							return

						if(trg.judgement_bid)
							m.set_alert("[trg] has already been judged!.",s.icon,s.icon_state)
						//	m.create_chat_entry("alerts","[trg] already judged!.")
							s.icon_state = "judgement off"
							return
						switch(alert(m,"[trg] has an alignment of [auraalignment(trg)], where will you send them?","","Heaven","Hell"))
							if("Heaven")
								var/bid = input ("For how long will you be sending them?") as num
								if(bid<5)
									m.set_alert("Bid cannot be less than 5 years!",'alert.dmi',"alert")
									return
								trg.judgement_bid = bid
								s.sendlocation = 12
							if("Hell")
								var/bid = input ("For how long will you be sending them?") as num
								if(bid<5)
									m.set_alert("Bid cannot be less than 5 years!",'alert.dmi',"alert")
									return
								trg.judgement_bid = bid
								s.sendlocation = 6

						s.skill_target = trg
						s.active = 1
						m.icon_state = "2HBlast"
						m.stunned++
						m.stunned_pending++
						m.client.screen += s.bar
						if(trg != m) trg.client.screen += s.bar
						//m.create_chat_entry("local","[m] begins unlocking [trg]'s potential.",0,1)
					else
						s.icon_state = "unlockpotential off"
						m.set_alert("Only used on players",'alert.dmi',"alert")
						return
				else
					m.set_alert("You need max energy",s.icon,s.icon_state)
				//	m.create_chat_entry("alerts","Need max energy to unlock potential.")
					return

			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:revive_bar_inner
				category = list("Regeneration","Utility")
				if(src.disable_sleep) return

				spawn(10)
					while(src)
						if(src.active)
							var/mob/m = null
							if(ismob(src.loc))
								if(src.skill_target)
									var/mob/tar = src.skill_target
									m = src.loc

									if(get_dist(m, tar) <= 2 && m.energy >= src.skill_lvl+5)
										m.energy -= src.skill_lvl+5
										src.progress += 10 + round(src.skill_lvl / 10)
										src.skill_exp += ((5 - (src.skill_lvl/20)) * m.mod_skill) + 0.5

										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl++
											src.skill_up(m)

										m.client.screen -= src.bar_inner
										src.bar_inner.screen_loc = "16:[round(src.progress/2)-2],10:-3"
										var/matrix/M = matrix()
										M.Scale(round(src.progress),1)
										src.bar_inner.transform = M
										m.client.screen += src.bar_inner

										if(tar.client && tar != m)
											tar.client.screen -= src.bar_inner
											src.bar_inner.screen_loc = "16:[round(src.progress/2)-2],10:-3"
											var/matrix/M2 = matrix()
											M2.Scale(round(src.progress),1)
											src.bar_inner.transform = M2
											tar.client.screen += src.bar_inner

										var/obj/effects/orb/o = new
										o.loc = tar.loc
										o.icon *= tar.auracolor
										o.step_x = tar.step_x
										o.step_y = tar.step_y
										o.pixel_x = rand(-64,64)
										o.pixel_y = rand(-64,64)
										animate(o,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
										spawn(10) if(o) del(o)

										if(m.koed || m.meditating) call(src.act)(m,src)

										if(src.progress >= 100)
											if(src.sendlocation == 6) view(tar,15)<<output("<b>[tar] was sent to Hell!</b>","actionoutput")
											if(src.sendlocation == 12) view(tar,15)<<output("<b>[tar] was accepted into Heaven!</b>","actionoutput")
											tar.loc=locate(rand(30,420),rand(20,450),src.sendlocation)
											//tar.judgement_bid = 1
											call(src.act)(m,src)
											src.active = 0
											src.progress = 0
											m.icon_state = ""
											m.client.screen -= src.bar_inner
											m.client.screen -= src.bar
											tar.client.screen -= src.bar_inner
											tar.client.screen -= src.bar
									else if(src.active)
										m.set_alert("Target too far",'alert.dmi',"alert")
										call(src.act)(m,src)
										src.active = 0
						sleep(10)
		/// Unlocks another player's hidden potential. One-time boost to potential-related modifiers.
		UnlockPotential
			name = "Unlock Potential"
			icon_state = "unlockpotential off"
			info_energy_cost = 2
			info_mastery = 1
			info_point_cost = 2
			teach_energy = 1500
			info_name = "Unlock Potential"
			info_buffs = ""
			info_duration = "Instant"
			info_point_cost_type = "regen"
			hud_x = 22
			hud_y = 588
			act = /obj/skills/UnlockPotential/proc/activate
			var/tmp/progress = 0
			var/tmp/obj/bar = null
			var/tmp/obj/bar_inner = null
			var/tmp/mob/skill_target = null
			var/tmp/list/used_on = list()

			proc/activate(var/mob/m, var/obj/skills/UnlockPotential/s)
				if(m.koed || m.meditating || m.selftraining || m.KB) return
				if(s in m && m.energy >= m.energy_max/1.05)
					if(m.stance) m.disable_stances(null,1)
					if(m.grab) m.letgo()

					m.open_skills = 0
					m.open_menus.Remove(".open_skills")
					winshow(m,"skills",0)
					s.icon_state = "unlockpotential"
					var/mob/trg = m
					if(m.target) trg = m.target

					if(trg.client)
						if(get_dist(m,trg) > 2)
							m.set_alert("Too far away",'alert.dmi',"alert")
							m.create_chat_entry("alerts","They are too far away to interact with.")
							s.icon_state = "unlockpotential off"
							return

						if(trg.potential_unlocked)
							m.set_alert("[trg] has already had their potential unlocked.",s.icon,s.icon_state)
							//m.create_chat_entry("alerts","[trg] already unlocked.")
							s.icon_state = "unlockpotential off"
							return

						s.skill_target = trg
						s.active = 1
						m.icon_state = "2HBlast"
						m.stunned++
						m.stunned_pending++
						m.client.screen += s.bar
						if(trg != m) trg.client.screen += s.bar
						//m.create_chat_entry("local","[m] begins unlocking [trg]'s potential.",0,1)
					else
						s.icon_state = "unlockpotential off"
						m.set_alert("Only used on players",'alert.dmi',"alert")
						return
				else
					m.set_alert("You need max energy",s.icon,s.icon_state)
				//	m.create_chat_entry("alerts","Need max energy to unlock potential.")
					return

			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:revive_bar_inner
				category = list("Regeneration","Utility")
				if(src.disable_sleep) return
				src.info = text_unlock_potential

				spawn(10)
					while(src)
						if(src.active)
							var/mob/m = null
							if(ismob(src.loc))
								if(src.skill_target)
									var/mob/tar = src.skill_target
									m = src.loc

									if(get_dist(m, tar) <= 2 && m.energy >= src.skill_lvl+5)
										m.energy -= src.skill_lvl+5
										src.progress += 1 + round(src.skill_lvl / 10)
										src.skill_exp += ((5 - (src.skill_lvl/20)) * m.mod_skill) + 0.5

										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl++
											src.skill_up(m)

										m.client.screen -= src.bar_inner
										src.bar_inner.screen_loc = "16:[round(src.progress/2)-2],10:-3"
										var/matrix/M = matrix()
										M.Scale(round(src.progress),1)
										src.bar_inner.transform = M
										m.client.screen += src.bar_inner

										if(tar.client && tar != m)
											tar.client.screen -= src.bar_inner
											src.bar_inner.screen_loc = "16:[round(src.progress/2)-2],10:-3"
											var/matrix/M2 = matrix()
											M2.Scale(round(src.progress),1)
											src.bar_inner.transform = M2
											tar.client.screen += src.bar_inner

										var/obj/effects/orb/o = new
										o.loc = tar.loc
										o.icon *= tar.auracolor
										o.step_x = tar.step_x
										o.step_y = tar.step_y
										o.pixel_x = rand(-64,64)
										o.pixel_y = rand(-64,64)
										animate(o,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
										spawn(10) if(o) del(o)

										if(m.koed || m.meditating) call(src.act)(m,src)

										if(src.progress >= 100)
											tar.mod_psionic_power = (tar.mod_psionic_power * 1.5)
											tar.mod_strength = (tar.mod_strength * 1.5)
											tar.mod_endurance = (tar.mod_endurance * 1.5)
											tar.mod_offence = (tar.mod_offence * 1.5)
											tar.mod_defence = (tar.mod_defence * 1.5)
											tar.mod_energy = (tar.mod_energy * 1.5)
											tar.PG = (tar.PG + 0.5)
											tar.potential_unlocked = 1
											tar.set_alert("Your potential has been unlocked!",'alert.dmi',"alert")
											//tar.create_chat_entry("alerts","[m] has unlocked your potential!")
											//s.used_on += trg.key

											m.set_alert("You have unlocked [tar]'s potential!",src.icon,src.icon_state)
											//m.create_chat_entry("alerts","You unlocked [tar]'s potential!")
											call(src.act)(m,src)
											src.active = 0
											src.progress = 0
											m.icon_state = ""
											m.client.screen -= src.bar_inner
											m.client.screen -= src.bar
											tar.client.screen -= src.bar_inner
											tar.client.screen -= src.bar
									else if(src.active)
										m.set_alert("Target too far",'alert.dmi',"alert")
										call(src.act)(m,src)
										src.active = 0
						sleep(10)

		Harness
			icon_state = "harness off"
			info_name = "harness"
			info_stats = "Allows the collection of information from artifacts."
			info = "You'll need to know how to gather some resources if you're going to want to survive."
			act = /obj/skills/Harness/proc/activate
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/nearby_artifact=0
			cd_max = 8500
			var/obj/items/misc/current_artifact = null
			proc
				activate(var/mob/m,var/obj/skills/Harness/s)

					if(m.meditating || m.selftraining || m.beaming || m.KB) return
					if(s.cd_state < 32)
						m << output("<font color = teal>Skill is on cooldown, please wait.","actionoutput")
						//var/is = src.icon_state
						//src.icon_state = "cd"
						//spawn(3)
						//	if(src) src.icon_state = "charge blast"
						return
					if(s.active == 0)

						for(var/obj/items/misc/i in get_step(m,m.dir))
							if(i && istype(i,/obj/items/misc/rad_rock_1))
								s.nearby_artifact = 1
								s.current_artifact = i
							if(i && istype(i,/obj/items/misc/rad_rock_2))
								s.nearby_artifact = 1
								s.current_artifact = i
							if(i && istype(i,/obj/items/misc/rad_rock_3))
								s.nearby_artifact = 1
								s.current_artifact = i
							if(i && istype(i,/obj/items/misc/sword_in_stone))
								s.nearby_artifact = 1
								s.current_artifact = i



						if(s.nearby_artifact==0)
							m.set_alert("You need to be near an artifact!",s.icon,s.icon_state)
							return
						if(s.nearby_artifact==1)
							if(m.stance) //Switch off all stances
								m.disable_stances(null,1)
							//if(m.grab) m.letgo()
							if(m.restedness <=10)
								m << output("<font color = teal>You are too tired to harness anything!","chat.system")
								m.set_alert("You are too tired to harness anything!",s.icon,s.icon_state)

								return
							for(var/obj/skills/Meditate/med in m)
								if(med.active) call(med.act)(m,med)
						/*	for(var/obj/skills/Dark_Transmutation/dt in m)
								if(dt.active) call(dt.act)(m,dt)
							for(var/obj/skills/Dark_Infusion/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Divine_Infusion/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Dark_Petrifaction/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Germination/gm in m)
								if(gm.active) call(gm.act)(m,gm) */
							//m.energy = 1
							s.active = 1
							s.icon_state = "harness"
							//m.icon_state = "Meditate"
							m.stunned += 1
							m.stunned_pending += 1
							m.client.screen += s.bar
							//m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
							animate(m, color = list("#000", "#000", "#000", "#fff"),time = 20, loop = -1)
							animate(color = initial(m.color),time = 20)
					else
						s.active = 0
						m.stunned -= 1
						m.stunned_pending -= 1
						s.nearby_artifact = 0
						s.current_artifact = null
						m.icon_state = ""
						if(m.client)
							m.client.screen -= s.bar_inner
							m.client.screen -= s.bar
						s.bar_inner.screen_loc = "20:-7,13:-3"
						s.progress = 0
						s.icon_state = "harness off"
						animate(m)
						//m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:gather_bar_inner
				category = list("Utility","Intelligence")


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(pre_cooldown>=5 && prob(1))
								switch(rand(1,3))
									if(1)
										pre_cooldown --

							if(src.active)
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									src.progress += 10
									//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
									src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

									if(m.client)
										m.client.screen -= src.bar_inner
										src.bar_inner.screen_loc  = "20:[round(src.progress/2)-2],13:-3"
										var/matrix/M = matrix()
										M.Scale(round(src.progress),1)
										src.bar_inner.transform = M
										m.client.screen += src.bar_inner


									if(m.koed || m.meditating)
										call(src.act)(m,src)
										animate(m)
									if(src.progress >= 100)
										src.progress = 0
										var/exp = m.mod_arcane_potential
										//var/obj/items/consumables/water/water_bottle_dirty/b = new/obj/items/consumables/water/water_bottle_dirty
										//Player should have a list of lists. Inside each sub-list should be all the organs missings for that limb.

									//	m.tiredness_rate -= (m.energy_max/rand(45,55))*(m.mod_recovery)*((m.weight*0.05)**0.1)
										m.lvlupwave(0,m)
										var/htt_multiplier = min(max(0, (m.HTT - 1) / 10), 50) + 1
										//src.create_chat_entry("local","Pre: [htt_multiplier] - HTT (Current HTT: [src.HTT])",0,1)
										//if(m.HTT < 1)
										//	htt_multiplier = 0 // Below 100 HTT? No gains at all.
										if(htt_multiplier !=0) exp =  exp * (htt_multiplier)
										m.magicxp += (exp*0.015) + (exp*0.015)
										src.current_artifact.shake()
										src.current_artifact.hp -= 50
										src.pre_cooldown ++
										if(src.current_artifact.hp <= 0)
											src.current_artifact.destroy()
										if(src.pre_cooldown >=5 )
											m.skill_cooldown(src)
											src.pre_cooldown = 0
										src.nearby_artifact = 0
										src.current_artifact = null

										if(src.active) call(src.act)(m,src)

										//m.rng_intelpts(m,src)
										//break

							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Research
			icon_state = "research off"
			info_name = "research"
			info_stats = "Allows the collection of information from artifacts."
			info = "You'll need to know how to gather some resources if you're going to want to survive."
			act = /obj/skills/Research/proc/activate
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/nearby_artifact=0
			var/obj/items/misc/current_artifact = null
			cd_max = 8500
			proc
				activate(var/mob/m,var/obj/skills/Research/s)

					if(m.meditating || m.selftraining || m.beaming || m.KB) return
					if(s.cd_state < 32)
						m << output("<font color = teal>Skill is on cooldown, please wait.","actionoutput")
						//var/is = src.icon_state
						//src.icon_state = "cd"
						//spawn(3)
						//	if(src) src.icon_state = "charge blast"
						return
					if(s.active == 0)
						for(var/obj/items/misc/i in get_step(m,m.dir))
							if(i && istype(i,/obj/items/misc/meteorite))
								s.nearby_artifact = 1
								s.current_artifact = i
							if(i && istype(i,/obj/items/misc/crashed_satellite))
								s.nearby_artifact = 1
								s.current_artifact = i
							if(i && istype(i,/obj/items/misc/crashed_space_pod))
								s.nearby_artifact = 1
								s.current_artifact = i
							if(i && istype(i,/obj/items/misc/crashed_storage))
								s.nearby_artifact = 1
								s.current_artifact = i

						if(s.nearby_artifact==0)
							m.set_alert("You need to be near an artifact!",s.icon,s.icon_state)
							return
						if(s.nearby_artifact==1)
							if(m.stance) //Switch off all stances
								m.disable_stances(null,1)
							//if(m.grab) m.letgo()
							if(m.restedness <=10)
								m << output("<font color = teal>You are too tired to research anything!","chat.system")
								m.set_alert("You are too tired to research anything!",s.icon,s.icon_state)
								//m.create_chat_entry("alerts","Need sleep!")
								return
							for(var/obj/skills/Meditate/med in m)
								if(med.active) call(med.act)(m,med)
						/*	for(var/obj/skills/Dark_Transmutation/dt in m)
								if(dt.active) call(dt.act)(m,dt)
							for(var/obj/skills/Dark_Infusion/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Divine_Infusion/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Dark_Petrifaction/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Germination/gm in m)
								if(gm.active) call(gm.act)(m,gm) */
							//m.energy = 1
							s.active = 1
							s.icon_state = "research"
							//m.icon_state = "Meditate"
							m.stunned += 1
							m.stunned_pending += 1
							m.client.screen += s.bar

							//m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
							animate(m, color = list("#000", "#000", "#000", "#fff"),time = 20, loop = -1)
							animate(color = initial(m.color),time = 20)
					else
						s.active = 0
						m.stunned -= 1
						m.stunned_pending -= 1
						m.icon_state = ""
						if(m.client)
							m.client.screen -= s.bar_inner
							m.client.screen -= s.bar
						s.bar_inner.screen_loc = "20:-7,13:-3"
						s.progress = 0
						s.current_artifact = null
						s.nearby_artifact=0
						s.icon_state = "research off"
						animate(m)
						//m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:gather_bar_inner
				category = list("Utility","Intelligence")


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(pre_cooldown>=5 && prob(1))
								switch(rand(1,3))
									if(1)
										pre_cooldown --
							if(src.active)
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									src.progress += 10//m.mod_tech_potential+round(src.skill_lvl/10)
									//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
									src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

									if(m.client)
										m.client.screen -= src.bar_inner
										src.bar_inner.screen_loc  = "20:[round(src.progress/2)-2],13:-3"
										var/matrix/M = matrix()
										M.Scale(round(src.progress),1)
										src.bar_inner.transform = M
										m.client.screen += src.bar_inner


									if(m.koed || m.meditating)
										call(src.act)(m,src)
										animate(m)
									if(src.progress >= 100)
										src.progress = 0
										var/exp = m.mod_tech_potential
										//var/obj/items/consumables/water/water_bottle_dirty/b = new/obj/items/consumables/water/water_bottle_dirty
										//Player should have a list of lists. Inside each sub-list should be all the organs missings for that limb.


									//	m.tiredness_rate -= (m.energy_max/rand(45,55))*(m.mod_recovery)*((m.weight*0.05)**0.1)
										m.lvlupwave(0,m)
										var/htt_multiplier = min(max(0, (m.HTT - 1) / 10), 50) + 1
										//src.create_chat_entry("local","Pre: [htt_multiplier] - HTT (Current HTT: [src.HTT])",0,1)
										//f(m.HTT < 1)
										//	htt_multiplier = 0 // Below 100 HTT? No gains at all.
										if(htt_multiplier !=0) exp =  exp * (htt_multiplier)
										m.intxp += (exp*0.01)+(exp*0.01)
										src.current_artifact.shake()
										src.current_artifact.hp -= 50
										src.pre_cooldown ++
										src.nearby_artifact = 0
										if(src.current_artifact.hp <= 0)
											src.current_artifact.destroy()
										if(src.pre_cooldown>=5)
											m.skill_cooldown(src)
											src.pre_cooldown = 0
										src.current_artifact = null
										if(src.active) call(src.act)(m,src)

										//m.rng_intelpts(m,src)
										//break

							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Decline_Absorb
			icon_state = "da off"
			info_name = "decline absorb"
			info_stats = "Allows the opportunity to absorb one's lifespan once they are knocked down."
			info = "A perk for Demons."
			act = /obj/skills/Decline_Absorb/proc/activate
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/mob/nearby_person= null
			proc
				activate(var/mob/m,var/obj/skills/Decline_Absorb/s)


					if(s.active == 0)
						var/mob/t = get_step(m,m.dir)
						if (t && t.client && t.koed == 1)
							s.nearby_person = t
						if(!s.nearby_person|| s.nearby_person == null)
							m.set_alert("You need to be near someone knocked down!",s.icon,s.icon_state)
							s.nearby_person=0
							return
						if(s.nearby_person)
							if(m.stance) //Switch off all stances
								m.disable_stances(null,1)
							//if(m.grab) m.letgo()
							if(m.energy <=0)
								m << output("You are too tired to absorb anything!","actionoutput")
								m.set_alert("You are too tired to absorb anything!",s.icon,s.icon_state)
								s.nearby_person = null
								return
							for(var/obj/skills/Meditate/med in m)
								if(med.active) call(med.act)(m,med)
						/*	for(var/obj/skills/Dark_Transmutation/dt in m)
								if(dt.active) call(dt.act)(m,dt)
							for(var/obj/skills/Dark_Infusion/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Divine_Infusion/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Dark_Petrifaction/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Germination/gm in m)
								if(gm.active) call(gm.act)(m,gm) */
							m.energy = 1
							s.active = 1
							s.icon_state = "da"
							//m.icon_state = "Meditate"
							m.stunned += 1
							m.stunned_pending += 1
							m.client.screen += s.bar
							//m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
							animate(m, color = list("#000", "#000", "#000", "#fff"),time = 20, loop = -1)
							animate(color = initial(m.color),time = 20)
					else
						s.nearby_person = null
						s.active = 0
						m.stunned -= 1
						m.stunned_pending -= 1
						m.icon_state = ""
						if(m.client)
							m.client.screen -= s.bar_inner
							m.client.screen -= s.bar
						s.bar_inner.screen_loc = "16:-2,10:-3"
						s.progress = 0
						s.icon_state = "da off"

						animate(m)
						//m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:gather_bar_inner
				category = list("Utility","Buff")


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active && src.nearby_person)
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									src.progress += 50+round(src.skill_lvl/10)
									//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
									src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

									if(m.client)
										m.client.screen -= src.bar_inner
										src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
										var/matrix/M = matrix()
										M.Scale(round(src.progress),1)
										src.bar_inner.transform = M
										m.client.screen += src.bar_inner


									if(m.koed || m.meditating)
										call(src.act)(m,src)
										animate(m)
									if(src.progress >= 100)
										src.progress = 0
										if(src.nearby_person.koed)
											m.decline_absorb(src.nearby_person)
											m.set_alert("You absorbed some of [src.nearby_person]'s lifespan",src.icon,src.icon_state)
											for(var/mob/MM in view(15,m))
												MM<<output("<font color=red>[MM.get_strangername(m)] absorbed some of [MM.get_strangername(src.nearby_person)]'s lifespan!</font>","actionoutput")
										else
											m.set_alert("You failed to absorb some of [src.nearby_person]'s lifespan",src.icon,src.icon_state)
										if(src.active) call(src.act)(m,src)

							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Soul_Absorb
			icon_state = "sa off"
			info_name = "soul absorb"
			info_stats = "Allows the opportunity to absorb one's soul once they are knocked down."
			info = "A perk for Demons."
			act = /obj/skills/Soul_Absorb/proc/activate
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/mob/nearby_person= null
			proc
				activate(var/mob/m,var/obj/skills/Soul_Absorb/s)


					if(s.active == 0)
						var/mob/t = get_step(m,m.dir)
						if (t && t.client && t.koed == 1)
							s.nearby_person = t
						if(!s.nearby_person|| s.nearby_person == null)
							m.set_alert("You need to be near someone knocked down!",s.icon,s.icon_state)
							s.nearby_person=0
							return
						if(s.nearby_person)
							if(m.stance) //Switch off all stances
								m.disable_stances(null,1)
							//if(m.grab) m.letgo()
							if(m.energy <=0)
								m << output("You are too tired to absorb anything!","actionoutput")
								m.set_alert("You are too tired to absorb anything!",s.icon,s.icon_state)
								s.nearby_person = null
								return
							for(var/obj/skills/Meditate/med in m)
								if(med.active) call(med.act)(m,med)
						/*	for(var/obj/skills/Dark_Transmutation/dt in m)
								if(dt.active) call(dt.act)(m,dt)
							for(var/obj/skills/Dark_Infusion/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Divine_Infusion/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Dark_Petrifaction/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Germination/gm in m)
								if(gm.active) call(gm.act)(m,gm) */
							m.energy = 1
							s.active = 1
							s.icon_state = "sa"
							//m.icon_state = "Meditate"
							m.stunned += 1
							m.stunned_pending += 1
							m.client.screen += s.bar
							//m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
							animate(m, color = list("#000", "#000", "#000", "#fff"),time = 20, loop = -1)
							animate(color = initial(m.color),time = 20)
					else
						s.nearby_person = null
						s.active = 0
						m.stunned -= 1
						m.stunned_pending -= 1
						m.icon_state = ""
						if(m.client)
							m.client.screen -= s.bar_inner
							m.client.screen -= s.bar
						s.bar_inner.screen_loc = "16:-2,10:-3"
						s.progress = 0
						s.icon_state = "sa off"

						animate(m)
						//m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:gather_bar_inner
				category = list("Utility","Buff")


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active && src.nearby_person)
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									src.progress += 50+round(src.skill_lvl/10)
									//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
									src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

									if(m.client)
										m.client.screen -= src.bar_inner
										src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
										var/matrix/M = matrix()
										M.Scale(round(src.progress),1)
										src.bar_inner.transform = M
										m.client.screen += src.bar_inner


									if(m.koed || m.meditating)
										call(src.act)(m,src)
										animate(m)
									if(src.progress >= 100)
										src.progress = 0
										if(src.nearby_person.koed)
											m.soul_absorb(src.nearby_person)
											m.set_alert("You absorbed [src.nearby_person]'s soul!",src.icon,src.icon_state)
											for(var/mob/MM in view(15,m))
												MM<<output("<font color=red>[MM.get_strangername(m)] absorbed [MM.get_strangername(src.nearby_person)]'s soul!</font>","actionoutput")
										else
											m.set_alert("You failed to absorb some of [src.nearby_person]'s soul",src.icon,src.icon_state)
										if(src.active) call(src.act)(m,src)

							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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

		Gather
			icon_state = "gather off"
			info_name = "gather"
			info_stats = "Allows gathering from water and bushes."
			info = "You'll need to know how to gather some resources if you're going to want to survive."
			act = /obj/skills/Gather/proc/activate
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			var/nearby_water=0
			proc
				activate(var/mob/m,var/obj/skills/Gather/s)


					if(s.active == 0)
						var/turf/t = get_step(m,m.dir)
						if (t && istype(t, /turf/water/) || locate(/obj/GDBGSet/FountainofDespair) in t || locate(/obj/GDBGSet/FountainofDespair) in oview(6))
							s.nearby_water = 1
						if(s.nearby_water==0)
							m.set_alert("You need to be near water!",s.icon,s.icon_state)
							m<<"You need to be near water!"
							s.nearby_water=0
							return
						if(s.nearby_water==1)
							if(m.stance) //Switch off all stances
								m.disable_stances(null,1)
							//if(m.grab) m.letgo()

							//for(var/obj/skills/Meditate/med in m)
							//	if(med.active) call(med.act)(m,med)


						/*	for(var/obj/skills/Dark_Transmutation/dt in m)
								if(dt.active) call(dt.act)(m,dt)
							for(var/obj/skills/Dark_Infusion/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Divine_Infusion/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Dark_Petrifaction/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Germination/gm in m)
								if(gm.active) call(gm.act)(m,gm) */
							//m.energy = 1
							s.active = 1
							s.icon_state = "gather"
							//m.icon_state = "Meditate"
							m.stunned += 1
							m.stunned_pending += 1
							m.client.screen += s.bar
							//m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
							animate(m, color = list("#000", "#000", "#000", "#fff"),time = 20, loop = -1)
							animate(color = initial(m.color),time = 20)
					/*else
						s.nearby_water = 0
						s.active = 0
						m.stunned -= 1
						m.stunned_pending -= 1
						m.icon_state = ""
						if(m.client)
							m.client.screen -= s.bar_inner
							m.client.screen -= s.bar
						s.bar_inner.screen_loc = "16:-2,10:-3"
						s.progress = 0
						s.icon_state = "gather off"

						animate(m)  */
						//m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:gather_bar_inner
				category = list("Utility","Buff")


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active && src.nearby_water)
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									src.progress += 35+round(src.skill_lvl/10)
									//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
									src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

									if(m.client)
										m.client.screen -= src.bar_inner
										src.bar_inner.screen_loc  = "20:[round(src.progress/2)-2],13:-3"
										var/matrix/M = matrix()
										M.Scale(round(src.progress),1)
										src.bar_inner.transform = M
										m.client.screen += src.bar_inner


									if(m.koed || m.meditating)
										call(src.act)(m,src)
										animate(m)
									if(src.progress >= 100)
										src.progress = 0
										src.nearby_water = 0
										var/obj/items/consumables/water/water_bottle_dirty/b = new/obj/items/consumables/water/water_bottle_dirty
										b.stacks = round(max(1, (skill_lvl * 0.1)),1)
										//Player should have a list of lists. Inside each sub-list should be all the organs missings for that limb.
										m.give_water(b, 1)
										m.set_alert("You gathered x[b.stacks] Bottle of Sea Water!",'consumables.dmi',"water bottle dirty")
										m<<"You gathered x[b.stacks] Bottle of Sea Water!"
										//if(src.active) call(src.act)(m,src)
										src.nearby_water = 0
										src.active = 0
										m.stunned -= 1
										m.stunned_pending -= 1
										m.icon_state = ""
										if(m.client)
											m.client.screen -= src.bar_inner
											m.client.screen -= src.bar
										src.bar_inner.screen_loc = "16:-2,10:-3"
										src.progress = 0
										src.icon_state = "gather off"

										animate(m)
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Incubation
			icon_state = "Incubation off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 1000
			info_name = "incubation"
			info_buffs = "Use psionic power to grow a bodypart"
			info_duration = "Channeled"
			info_point_cost_type = "energy"
			info_stats = "Grow a new bodypart\n\nOr duplicate a bodypart\n\nOr Split a bodypart\n\nOr strengthen a bodypart"
			info = "A Demon or Kais physical form is manifested from psionic energy, made whole and solid by thought and sheer will. Usually, a newly awakened Demon or Kai is made from pure ectoplasm. Using this ability, you can grow new organs for your body. Each time this is used, a bodypart you don't already have is grown. Each bodypart that you grow extends the time you can exist outside the Psionic Realm as a supernatural being."
			act = /obj/skills/Incubation/proc/activate
			var/progress = 0;
			var/obj/bar = null
			var/obj/bar_inner = null
			proc
				activate(var/mob/m,var/obj/skills/Incubation/s)
					if(s.active == 0)
						if(m.stance) //Switch off all stances
							m.disable_stances(null,1)
						if(m.grab) m.letgo()
						if(m.organ_grow >= m.total_organs+1)
							m << "All bodyparts grown."
							m.set_alert("All bodyparts grown",s.icon,s.icon_state)
							m.create_chat_entry("alerts","All bodyparts grown.")
							return
						if(m.has_body == 0)
							m << output("<font color = teal>You need to have a body to attempt the incubation process.","chat.system")
							m.set_alert("Need body",s.icon,s.icon_state)
							m.create_chat_entry("alerts","Need body.")
							return
						if(m.energy < m.energy_max/1.05)
							m << output("<font color = teal>You need to be at max energy to attempt the incubation process.","chat.system")
							m.set_alert("Need max energy",s.icon,s.icon_state)
							m.create_chat_entry("alerts","Need body.")
							return
						for(var/obj/skills/Meditate/med in m)
							if(med.active) call(med.act)(m,med)
						for(var/obj/skills/Dark_Transmutation/dt in m)
							if(dt.active) call(dt.act)(m,dt)
						for(var/obj/skills/Dark_Infusion/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Divine_Infusion/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Dark_Petrifaction/sk in m)
							if(sk.active) call(sk.act)(m,sk)
						for(var/obj/skills/Germination/gm in m)
							if(gm.active) call(gm.act)(m,gm)
						m.energy = 1
						s.active = 1
						s.icon_state = "Incubation"
						m.icon_state = "Meditate"
						m.stunned += 1
						m.stunned_pending += 1
						m.client.screen += s.bar
						//m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
						animate(m, color = list("#000", "#000", "#000", "#fff"),time = 20, loop = -1)
						animate(color = initial(m.color),time = 20)
					else
						s.active = 0
						m.stunned -= 1
						m.stunned_pending -= 1
						m.icon_state = ""
						if(m.client)
							m.client.screen -= s.bar_inner
							m.client.screen -= s.bar
						s.bar_inner.screen_loc = "16:-2,10:-3"
						s.progress = 0
						s.icon_state = "Incubation off"
						animate(m)
						//m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
			New()
				..()
				bar = new /:revive_bar
				bar_inner = new /:revive_bar_inner
				category = list("Utility","Buff")


				if(src.disable_sleep) return
				spawn(10)
					if(src)
						while(src)
							if(src.active)
								var/mob/m = null
								if(ismob(src.loc))
									m = src.loc
									src.progress += 3+round(src.skill_lvl/10)
									//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
									src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

									if(m.client)
										m.client.screen -= src.bar_inner
										src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
										var/matrix/M = matrix()
										M.Scale(round(src.progress),1)
										src.bar_inner.transform = M
										m.client.screen += src.bar_inner
									var/obj/effects/orb/o = new
									o.loc = m.loc
									o.step_x = m.step_x
									o.step_y = m.step_y
									o.pixel_x = rand(-64,64)
									o.pixel_y = rand(-64,64)
									animate(o,pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
									spawn(10)
										if(o) del(o)

									if(m.koed || m.meditating)
										call(src.act)(m,src)
										animate(m)
									if(src.progress >= 100)
										src.progress = 0
										//Player should have a list of lists. Inside each sub-list should be all the organs missings for that limb.
										if(m.race == "Demon" || m.race == "Kai")
											LOOP
											if(m.organ_grow >= m.total_organs+1)
												m << "All bodyparts grown."
												m.set_alert("All bodyparts grown",src.icon,src.icon_state)
												m.create_chat_entry("alerts","All bodyparts grown.")
												return
											var/obj/body_related/bodyparts/part = global.grow_order[m.organ_grow]

											if(istype(part,/obj/body_related/bodyparts/head/))
												var/obj/body_related/bodyparts/head/h = m.bodyparts[1]
												var/dupe = 0
												for(var/obj/body_related/bodyparts/b in h)
													if(b.type == part.type)
														dupe = 1
														break
												if(dupe == 0) part = new part.type (h)
												else
													m.organ_grow += 1
													goto LOOP

											if(istype(part,/obj/body_related/bodyparts/torso/))
												var/obj/body_related/bodyparts/torso/t = m.bodyparts[2]
												var/dupe = 0
												for(var/obj/body_related/bodyparts/b in t)
													if(b.type == part.type)
														dupe = 1
														break
												if(dupe == 0) part = new part.type (t)
												else
													m.organ_grow += 1
													goto LOOP

											if(istype(part,/obj/body_related/bodyparts/left_arm/))
												var/obj/body_related/bodyparts/left_arm/la = m.bodyparts[3]
												var/dupe = 0
												for(var/obj/body_related/bodyparts/b in la)
													if(b.type == part.type)
														dupe = 1
														break
												if(dupe == 0) part = new part.type (la)
												else
													m.organ_grow += 1
													goto LOOP

											if(istype(part,/obj/body_related/bodyparts/right_arm/))
												var/obj/body_related/bodyparts/right_arm/ra = m.bodyparts[4]
												var/dupe = 0
												for(var/obj/body_related/bodyparts/b in ra)
													if(b.type == part.type)
														dupe = 1
														break
												if(dupe == 0) part = new part.type (ra)
												else
													m.organ_grow += 1
													goto LOOP

											if(istype(part,/obj/body_related/bodyparts/right_leg/))
												var/obj/body_related/bodyparts/right_leg/rl = m.bodyparts[5]
												part = new part.type (rl)
												var/dupe = 0
												for(var/obj/body_related/bodyparts/b in rl)
													if(b.type == part.type)
														dupe = 1
														break
												if(dupe == 0) part = new part.type (rl)
												else
													m.organ_grow += 1
													goto LOOP
											if(istype(part,/obj/body_related/bodyparts/left_leg/))
												var/obj/body_related/bodyparts/left_leg/ll = m.bodyparts[6]
												part = new part.type (ll)
												var/dupe = 0
												for(var/obj/body_related/bodyparts/b in ll)
													if(b.type == part.type)
														dupe = 1
														break
												if(dupe == 0) part = new part.type (ll)
												else
													m.organ_grow += 1
													goto LOOP
											part.name = part.info_name
											part.i_state = part.icon_state
											part.part_exp = 500//1000
											part.part_reward(m,1)
											if(part.type == /obj/body_related/bodyparts/torso/stomach) m.has_stomach = 1
											m.organ_grow += 1
											m.shockwave()
											m.screen_text.maptext = "<font size = 6><center>[part] grown"
											animate(m.screen_text,alpha = 255,time = 60)
											animate(alpha = 0,time = 60)
											if(src.active) call(src.act)(m,src)
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Hone
			icon_state = "hone off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 1000
			hud_x = 308
			hud_y = 636
			info_name = "hone"
			info_buffs = "Hone your magic to yourself as you meditate."
			info_duration = "Toggleable"
			info_point_cost_type = "energy"
			act = /obj/skills/Hone/proc/activate
			proc
				activate(var/mob/m,var/obj/skills/Hone/s)
					if(m.skill_hone == null) m.skill_hone = s
					if(s.active)
						s.active = 0

						//m.buffs -= "sense"
						s.icon_state = "hone off"
						//winshow(m,"sense",0)

					else
						s.icon_state = "hone"
						s.active = 1
						if(m.skill_study.active==1) call(m.skill_study.act)(m,m.skill_study)

			New()
				..()
				category = list("Intelligence","Utility")
				spawn(10)
					src.info = text_study


					if(src.disable_sleep) return
					spawn(10)
						if(ismob(src.loc))
							var/mob/m = src.loc
							if(m.skill_hone == null) m.skill_hone = src
						/*while(src)
							if(ismob(src.loc))
								var/mob/m = src.loc
								if(src.active)
									src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

							sleep(10)
							*/
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					//var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
						m.mouse_dir = "left"
					if(params["right"])
						dir = "right"
						m.mouse_dir = "right"
					if(src in m)
						call(src.act)(m,src)

					winset(m,"map.map","focus=true")
		Study
			icon_state = "studying off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 1000
			hud_x = 308
			hud_y = 636
			info_name = "study"
			info_buffs = "Study to your self for an increase in intelligence."
			info_duration = "Toggleable"
			info_point_cost_type = "energy"
			act = /obj/skills/Study/proc/activate
			proc
				activate(var/mob/m,var/obj/skills/Study/s)


					if(m.skill_study == null) m.skill_study = s
					if(s.active)
						s.active = 0

						//m.buffs -= "sense"
						s.icon_state = "studying off"
						//winshow(m,"sense",0)

					else
						//if(m.skill_sleep.active) return


						s.icon_state = "studying"
						s.active = 1
						if(m.skill_hone && m.skill_hone.active==1) call(m.skill_hone.act)(m,m.skill_hone)

			New()
				..()
				category = list("Intelligence","Utility")
				spawn(10)
					src.info = text_study


					if(src.disable_sleep) return
					spawn(10)
						if(ismob(src.loc))
							var/mob/m = src.loc
							if(m.skill_study == null) m.skill_study = src
						/*while(src)
							if(ismob(src.loc))
								var/mob/m = src.loc
								if(src.active)
									src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

							sleep(10)*/
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					//var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
						m.mouse_dir = "left"
					if(params["right"])
						dir = "right"
						m.mouse_dir = "right"
					if(src in m)
						call(src.act)(m,src)

					winset(m,"map.map","focus=true")

		Sense
			icon_state = "Sense off"
			info_energy_cost = 1
			info_mastery = 1
			info_point_cost = 3
			teach_energy = 1000
			hud_x = 308
			hud_y = 636
			info_name = "sense"
			info_buffs = "Sense power/location of others"
			info_duration = "Toggleable"
			info_point_cost_type = "energy"
			act = /obj/skills/Sense/proc/activate
			var/power_factor, sense_range, distance_scaling
			var/min_range = 10, base_range = 50, max_range = 300
			proc
				activate(var/mob/m,var/obj/s)
					if(m.skill_sense == null || !istype(m.skill_sense,/obj/skills/Sense)) m.skill_sense = src
					if(s.active)
						s.active = 0
						if(m.target) m.hide_sense(1,1)
						//m.buffs -= "sense"
						s.icon_state = "Sense off"
						//winshow(m,"sense",0)
						m.open_sense = 0
						if(m.open_map)
							for(var/mob/p in players)
								if(p.loc && p != m && p.map_blip && m.client) m.client.images -= p.map_blip
					else
						s.icon_state = "Sense"
						s.active = 1

						 //set up our range values
						if(m.target) m.hide_sense(0)
						//m.buffs += "sense"
						if(m.open_map)
							m.map_blip("add")
						for(var/mob/races/p in players)
							var/powersense = round((p.psionic_power/m.psionic_power)*100)
							if(p.z == m.z)
								power_factor = p.psionic_power / src.psionic_power //calculate our power factor
								if (power_factor >= 10)
									sense_range = max_range //use power factor to calculate sense range
								else if (power_factor > 1)
									sense_range = base_range + (max_range - base_range) * (power_factor - 1) / 9
								else
									sense_range = min_range + (base_range - min_range) * power_factor
								var/distance = get_dist(m, p) //calculate distance between center and target
								distance_scaling = (1 - distance / sense_range) * (p.psionic_power / 100) //distance scaling factor

								if (distance_scaling > 0 && distance_scaling <= 1) //ensure distance scaling is within range
									p<<output("[dir2text_sense(get_dir(m.loc,p.loc))] - ([powersense]%)","actionoutput")
									//p.create_chat_entry("local","[dir2text_sense(get_dir(m.loc,p.loc))] - ([powersense]%)",0,1)
								p<<output("[dir2text_sense(get_dir(m.loc,p.loc))] - ([powersense]%)","actionoutput")
							//p.create_chat_entry("local","[dir2text_sense(get_dir(m.loc,p.loc))] - ([powersense]%)",0,1)
							/*		m.cre
							for(var/mob/p in players)
								if(p.loc && p != m && p.z == m.z && p.map_blip)
									if(maps[m.z] in m.client.screen)
									//if(m.z != 3 && maps[m.z] in m.client.screen)
										m.client.images += p.map_blip
							*/
			New()
				..()
				category = list("Energy","Utility")
				spawn(10)
					src.info = text_sense


					if(src.disable_sleep) return
					spawn(10)
						if(ismob(src.loc))
							var/mob/m = src.loc
							if(m.skill_sense == null || !istype(m.skill_sense,/obj/skills/Sense)) m.skill_sense = src

						while(src)
							if(ismob(src.loc))
								var/mob/m = src.loc
								if(src.active)
									var/removes = (1/m.mod_recovery) + (1/src.skill_lvl)
									if(m.energy >= removes)
										m.energy -= removes
										//world << "[removes] energy removed by [src]"
										//m << output("<font color = teal>[removes] energy removed by [src]","chat.system")
										//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
										//src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
										src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)
									else
										m.mouse_dir = "left"
										call(src.act)(m,src)
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					//var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
						m.mouse_dir = "left"
						if(src in m)
							call(src.act)(m,src)
					if(params["right"])
						dir = "right"
						m.mouse_dir = "right"
						if(src.super_sense)
							for(var/mob/races/P)
								if(P.z == m.z && !P.npc && P.psionic_power >0)
									if(!P.koed||P.icon_state!="KO")
										P.RecentScan = round((P.psionic_power/m.psionic_power)*100)
										/*if(P.psionic_power >= 100000000)
											P.RecentScan = round(P.psionic_power / m.psionic_power / 1000000) * 1000000

										else
											if(P.psionic_power >= 10000000)
												P.RecentScan = round(P.psionic_power / m.psionic_power / 100000) * 100000

											else
												if(P.psionic_power >= 1000000)
													P.RecentScan = round(P.psionic_power / m.psionic_power / 10000) * 10000
												else
													if(P.psionic_power >= 100000)
														P.RecentScan = round(P.psionic_power / m.psionic_power / 1000) * 1000
													else
														if(P.psionic_power >=1000)
															P.RecentScan = round(P.psionic_power / m.psionic_power / 100) * 100
														else
															if(P.psionic_power >=100)
																P.RecentScan = round(P.psionic_power / m.psionic_power / 10) * 10
															else
																P.RecentScan = round(P.psionic_power / m.psionic_power )*/

								if(P.psionic_power>0)
									if(P.z==m.z)
										var/list/Powers=new
										Powers += P.RecentScan
										var/Power_Window=""
										for(var/E in Powers)
											var/Lowest_Power=min(Powers)
											if(Lowest_Power==P.RecentScan)
												if(P in Power_Window) continue
												var/directional = "[dir2text(get_dir(m.loc,P.loc))]"
												if(directional == "" || directional == null)
													directional = "CENTER"
												var/text = add_tspace("([directional]) - [m.get_strangername(P)]",10)
												text += " [Commas(min(Powers))]%<br>"
												Power_Window += text
											Powers-=min(Powers)
										m << output("[Power_Window]","actionoutput")
						else
							m<<"You lack the ability to sense planets."
							return


					winset(m,"map.map","focus=true")

		Teleportation
			icon_state = "Teleportation off"
			disabled_ko = 1
			info_name = "teleportation"
			teach_energy = 3000
			cd_max = 3000
			hud_x = 308
			hud_y = 492
			info_point_cost_type = "energy"
			act = /obj/skills/Teleportation/proc/activate
			//info_prerequisite = list("Astral Projection")
			proc
				activate(var/mob/m,var/obj/skills/s)
					if(s in m)
						if(m.skill_teleport == null) m.skill_teleport = s
						if(s.active)
							s.active = 0
							s.icon_state = "Teleportation off"
						else
							if(s.cd_state < 32)
								m << output("<font color = teal>Skill is on cooldown, please wait.","chat.system")
								//var/is = s.icon_state
								s.icon_state = "cd"
								spawn(3)
									if(s) s.icon_state = "Teleportation off"
								return
							s.icon_state = "Teleportation"
							s.active = 1
							m.map_proc(0)
							winshow(m,"skills",0)
							m.open_skills = 0
							m.open_menus.Remove(".open_skills")
			New()
				..()
				spawn(10)
					src.info = text_super_speed


			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
							m.toggle_skill(src)


		Concussive_Blow
			icon_state = "Concussive Blow off"
			disabled_ko = 0
			New()
				..()
				spawn(10)
					src.info = text_super_speed


			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(m.target && bounds_dist(m, m.target) <= 32)
								var/mob/trg = m.target
								if(m.skill_flight && m.skill_flight.active)
									flick("punch right fly",m)
								else if(m.skill_levitation && m.skill_levitation.active)
									flick("punch right fly",m)
								else
									flick("punch right",m)
								//trg.dmg_nums("<font color = yellow>Stun")
								if(trg.stunned == 0)
									trg.overlays -= 'fx_stun.dmi'
									trg.overlays += 'fx_stun.dmi'
									trg.stun_cd(20)
		Self_Destruct
			icon_state = "Self Destruct off"
			disabled_ko = 1
			info_energy_cost = 5
			info_mastery = 4
			info_point_cost = 3
			teach_energy = 1500
			info_name = "self_destruct"
			info_buffs = "Explode in one last blaze of glory"
			info_duration = "Channeled"
			info_point_cost_type = "force"
			info_prerequisite = list("Explosion")
			cd_max = 6000
			level = 100
			act = /obj/skills/Self_Destruct/proc/activate
			hud_x = 116
			hud_y = 492

			proc
				activate(var/mob/m,var/obj/skills/s)
					if(s.active)
						s.active = 0
						s.icon_state = "Self Destruct off"
					else
						if(s.cd_state < 32)
							m << output("<font color = teal>Skill is on cooldown, please wait.","chat.system")
							//var/is = s.icon_state
							s.icon_state = "cd"
							spawn(3)
								if(s) s.icon_state = "Self Destruct off"
							return
						m.skill_cooldown(s)
						s.icon_state = "Self Destruct"
						s.active = 1
						m.stunned += 1
						m.stunned_pending += 1
						m.shockwave_huge()

						var/obj/rays = new
						rays.icon = 'fx_ray_large.dmi'
						rays.pixel_x = -284
						rays.pixel_y = -284
						rays.loc = m.loc
						rays.step_x = m.step_x
						rays.step_y = m.step_y
						rays.bolted = 2
						rays.layer = m.layer+100
						m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
						m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
						rays.filters += filter(type="rays",x=0,y=0,size=300,color=rgb(255,255,255),offset=0,density=15,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
						animate(rays.filters[1],offset = 100,time = 1000, loop = -1)
						animate(offset = 0,time = 0)

						var/obj/o = new
						o.icon = m.icon
						o.icon_state = m.icon_state
						o.overlays = m.overlays
						o.loc = m.loc
						o.step_x = m.step_x
						o.step_y = m.step_y
						o.bolted = 2
						o.layer = m.layer+1
						animate(o, color = list("#000", "#000", "#000", "#fff"),time=20)
						//animate(alpha = 155, time = 20, flags = ANIMATION_PARALLEL)
						spawn(33)
							if(m && s)
								m.loc.explosion(7)
								rays.loc = null
								o.loc = null
								m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
								m.Death("Self-Destruction",0)
								if(m)
									m.stunned -= 1
									m.stunned_pending -= 1
						//animate(o, transform = matrix()*2,alpha = 0, time = 10, loop = -1)
						//animate(transform = matrix()*1,alpha = 155,time = 0)
			New()
				..()
				category = list("Energy","Buff","resistance")
				spawn(10)
					src.info = text_super_speed


			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Solar_Flare
			icon_state = "solar flare off"
			disabled_ko = 1
			info_energy_cost = 5
			info_mastery = 4
			info_point_cost = 3
			teach_energy = 1500
			info_name = "solar_flare"
			info_buffs = "Explode in one last blaze of glory"
			info_duration = "Channeled"
			info_point_cost_type = "force"
			info_prerequisite = list("Explosion")
			cd_max = 350
			level = 100
			act = /obj/skills/Solar_Flare/proc/activate
			hud_x = 116
			hud_y = 492
			proc
				activate(var/mob/m,var/obj/skills/s)
					if(s.active)
						s.active = 0
						s.icon_state = "solar flare off"
					else
						if(s.cd_state < 32)
							//m << output("<font color = teal>Skill is on cooldown, please wait.","chat.system")
							//var/is = s.icon_state
							s.icon_state = "cd"
							spawn(3)
								if(s) s.icon_state = "solar flare off"
							return
						m.skill_cooldown(s)
						s.icon_state = "solar flare"
						s.active = 1
						m.stunned += 1
						m.stunned_pending += 1
						m.icon_state = "Block"

						var/obj/o = new
						o.icon = m.icon
						o.icon_state = m.icon_state
						o.overlays = m.overlays
						o.loc = m.loc
						o.step_x = m.step_x
						o.step_y = m.step_y
						o.bolted = 2
						o.layer = m.layer+1
						animate(o, color = list("#000", "#000", "#000", "#fff"),time=10)
						m.shockwave_huge()
						animate(alpha = 155, time = 20, flags = ANIMATION_PARALLEL)
						spawn(5)
							if(m.koed==0)
								for(var/mob/n in oview(25,m))
									if(n)
										if(n.skill_shieldeyes.active==0)
											Apply_Solar_Flare_Blind(n)

								view(20,m)<<output("[m.get_strangername(m)] says, Solar Flare!","actionoutput")
								m.stunned -= 1
								m.stunned_pending -= 1
								m.icon_state = initial(m.icon_state)
								//rays.loc = null
								o.loc = null
								//m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
								//m.Death("Self-Destruction",0)

						//animate(o, transform = matrix()*2,alpha = 0, time = 10, loop = -1)
						//animate(transform = matrix()*1,alpha = 155,time = 0)
			New()
				..()
				category = list("Energy","Buff","resistance")
				spawn(10)
					src.info = text_super_speed


			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Energy_Shield
			icon_state = "shield off"
			disabled_ko = 0
			info_energy_cost = 2
			info_mastery = 1
			info_name = "shield"
			info_point_cost = 3
			info_buffs = "Protection against Force based attacks"
			info_duration = "Toggleable"
			info_point_cost_type = "resistance"
			act = /obj/skills/Energy_Shield/proc/activate
			var/obj/effects/energy_shield/shield = null
			proc
				activate(var/mob/m,var/obj/skills/Energy_Shield/s)

					//if(m.skill_super_speed == null) m.skill_super_speed = s
					if(s.active)
						s.active = 0
						s.icon_state = "shield off"
						m.overlays -= s.shield
					else
						s.icon_state = "shield"
						s.active = 1
						m.overlays += s.shield
						shield.icon *= m.auracolor


			New()
				..()
				var/obj/effects/energy_shield/sh = new /obj/effects/energy_shield(src)
				sh.icon = 'energy_shield.dmi'
				src.shield = sh
				src.info = text_energy_shield
				category = list("Energy","Buff","resistance")



			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Give_Power
			icon_state = "Super Speed off"
			disabled_ko = 0
			info_energy_cost = 5
			info_mastery = 2
			info_point_cost = 5
			info_buffs = "Transfer all power to target"
			info_duration = "Instant"
			info_name = "give_power"
			info_point_cost_type = "power"
			act = /obj/skills/Give_Power/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					//if(m.skill_super_speed == null) m.skill_super_speed = s
					if(s.active)
						s.active = 0
						s.icon_state = "Super Speed off"
					else
						s.icon_state = "Super Speed"
						s.active = 1
			New()
				..()
				category = list("Power","Utility")
				spawn(10)
					src.info = text_super_speed


			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Give_Energy
			icon_state = "Super Speed off"
			disabled_ko = 0
			info_energy_cost = 5
			info_mastery = 2
			info_point_cost = 5
			info_name = "give_energy"
			info_buffs = "Transfer all energy to target"
			info_duration = "Instant"
			info_point_cost_type = "energy"
			act = /obj/skills/Give_Energy/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					//if(m.skill_super_speed == null) m.skill_super_speed = s
					if(s.active)
						s.active = 0
						s.icon_state = "Super Speed off"
					else
						s.icon_state = "Super Speed"
						s.active = 1
			New()
				..()
				category = list("Energy","Utility")
				spawn(10)
					src.info = text_super_speed


			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Mental_Battle //Used when mediating, creates an arena in the players head where he can choose to fight an npc or player.
			icon_state = "Super Speed off"
			disabled_ko = 0
			info_energy_cost = 3
			info_mastery = 1
			info_name = "mental_battle"
			info_point_cost = 5
			info_buffs = "Fight a mental battle against an opponent"
			info_duration = "Toggleable"
			info_point_cost_type = "Energy"
			act = /obj/skills/Mental_Battle/proc/activate
			proc
				activate(var/mob/m,var/obj/s)
					//if(m.skill_super_speed == null) m.skill_super_speed = s
					if(s.active)
						s.active = 0
						s.icon_state = "Super Speed off"
					else
						s.icon_state = "Super Speed"
						s.active = 1
			New()
				..()
				category = list("Energy","Utility")
				spawn(10)
					src.info = text_super_speed


			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Dash_Attack
		Psi_Lightning
			name = "Psi Lightning"
			icon_state = "Psi Lightning off"
			disabled_switch = 1;
			info_energy_cost = 4
			info_dmg = 3
			info_spd = 1
			info_mastery = 1
			info_point_cost = 3
			info_point_cost_type = "force"
			info_name = "psi_lightning"
			info_stats = "Energy Cost: Very High\n\nDamage: High\n\nSpeed: Slow\n\nMastery: Very Slow\n\nToggleable"
			energy_skill = 1
			teach_energy = 1000
			cd_max = 100
			info_cd = "10 seconds"
			hud_x = 68
			hud_y = 636
			New()
				..()
				category = list("Energy","Utility","Offence","Agility")
				spawn(10)
					src.info = text_super_speed


			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(m.skill_lightning == null) m.skill_lightning = src
							if(src.active)
								src.active = 0
								src.icon_state = "Psi Lightning off"
								if(src == m.current_attack) m.current_attack = null
								m.stop_charging()
							else
								src.icon_state = "Psi Lightning"
								src.active = 1
								m.current_attack = src;
								m.toggle_skill(src)

								src.cd_current = src.cd_max
		Kaiosoku
			icon_state = "kaiosoku off"
			disabled_ko = 0
			info_energy_cost = 2
			info_mastery = 2
			info_point_cost = 3
			teach_energy = 1000
			info_name = "Kaiosoku"
			info_buffs = "Quicksilver speed"
			info_duration = "Toggleable"
			info_point_cost_type = "agility"
			act = /obj/skills/Kaiosoku/proc/activate
			var/speed_ramp = 0
			var/speed_skip = 0
			var/obj/speed = null
			proc
				activate(var/mob/m,var/obj/skills/Kaiosoku/s)
					if(m.skill_quicksilver == null) m.skill_quicksilver = s
					if(s.active)
						s.active = 0
						s.icon_state = "kaiosoku off"
						s.speed_ramp = 0
						m.density_factor = 1
						if(m.skill_focus == null || m.skill_focus && m.skill_focus.active == 0) m.overlays -= /obj/effects/elec
						if(s.speed) s.speed.loc = null
						m.icon_state = m.state()
						m.kaiosoku_boost = 1
						var/obj/buffs_and_debuffs/b = m.buff_kaiosoku

						var/txt = "<br><u>Sources</u>"
						for(var/x in m.power_sources)
							txt = "[txt]<br>[x]."
						b.info_txt.maptext = "<font size = 1><text align=center valign=top>[b.desc][txt]"
						b:activate(m,b)
					else
						s.icon_state = "kaiosoku"
						s.active = 1
						m.KB_furrow = 1
						m.density_factor = 0
			New()
				..()
				category = list("Energy","Utility","Offence","Agility")
				spawn(10)
					src.info = text_super_speed


					var/obj/effects/speed_shockwave/h = new
					src.speed = h
					spawn(10)
						if(src)
							var/mob/m = null
							if(ismob(src.loc)) m = src.loc
							else return
							while(src)
								var/spd = 10
								if(src.active)
									if(!m.skill_flight || m.skill_flight && !m.skill_flight.active)
										if(!m.skill_levitation || m.skill_levitation && !m.skill_levitation.active)
											if(m.energy <= 1) call(src.act)(m,src)
											else if(m.tmp_dmg < 0) call(src.act)(m,src)
											if(m.skill_meditation && m.skill_meditation.active) call(m.skill_meditation.act)(m,m.skill_meditation)
											src.skill_exp += ((0.1-(src.skill_lvl/100))*m.mod_skill)+0.1
											if(src.skill_exp >= 100 && src.skill_lvl < 100)
												src.skill_exp = 1
												src.skill_lvl += 1
												src.skill_up(m)
											src.speed_ramp -= 0.4
											if(src.speed_ramp <= 0)
												src.speed_ramp = 0
												m.icon_state = m.state()
												if(m.skill_focus == null || m.skill_focus && m.skill_focus.active == 0) m.overlays -= /obj/effects/elec
											else if(src.speed_ramp < 6 && src.speed)
												src.speed.loc = null
												m.icon_state = ""
											else
												m.icon_state = "Block"
												m.overlays -= /obj/effects/elec
												m.overlays += /obj/effects/elec
											spd = 1
										else call(src.act)(m,src)
									else call(src.act)(m,src)
								sleep(spd)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Zanzoken
			icon_state = "Super Speed off"
			disabled_ko = 0
			info_energy_cost = 1
			info_mastery = 2
			info_point_cost = 3
			teach_energy = 1000
			info_name = "zanzoken"
			info_buffs = "Attack combos"
			info_duration = "Toggleable"
			info_point_cost_type = "agility"
			cd_max = 10
			act = /obj/skills/Zanzoken/proc/activate
			hud_x = 20
			hud_y = 636
			proc
				activate(var/mob/m,var/obj/s)
					if(m.skill_super_speed == null) m.skill_super_speed = s
					if(s.active)
						s.active = 0
						s.icon_state = "Super Speed off"
						m.mod_agility /= 1.1
					else
						s.icon_state = "Super Speed"
						s.active = 1
						m.mod_agility *= 1.1
			New()
				..()
				category = list("Energy","Utility","Offence","Agility")
				spawn(10)
					src.info = text_super_speed


			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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


		/*
		Psi_Wave
			icon = 'skills.dmi'
			icon_state = "Psi Wave off"
			var/obj/wave = null
			Click(location,control,params)
				if(ismob(src.loc))
					var/mob/m = src.loc
					if("ko" in m.debuffs) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(m.charging == 0)
								m.charging = 1
								m.icon_state = "charge"
								var/obj/ranged/wave_start/s = new
								s.loc = locate(m.x+1,m.y,m.z)
								src.wave = s
			New()
				spawn(10)
					src.info = text_train


					spawn(10)
						while(src)
							if(ismob(src.loc))
								var/mob/m = src.loc
								if(src.wave && m.charging && m.charge_size <= 15)
									var/size_new = src.wave.transform*1.1
									animate(src.wave, transform = matrix()*size_new,pixel_x = src.wave.pixel_x + 1, time = 7)
									m.charge_size += 1
							sleep(7)

		*/

		//Advanced form of meditation that links user to psionic realms, so they can attune to the divine power there as if they were present.
		Self_Train
			icon_state = "Self Train off"
			act = /obj/skills/Self_Train/proc/activate
			info_stats = "Small xp gain in physical stats\n\nUnable to move while active\n"
			var/tmp/last_gain_time = 0

			var/gain_cd = 25  // cooldown in ticks (2.5 seconds)
			proc
				activate(var/mob/m,var/obj/s)
					if(world.time < s.last_activate_time + 30)
						return
					s.last_activate_time = world.time
					if(m.skill_sleep && m.skill_sleep.active || m.meditating ) return
					if(m && s && m.skill_selftrain == null) m.skill_selftrain = s
					if(s.active)
						s.active = 0
						m.selftraining = 0
						//m.pixel_y = -8
						m.icon_state = m.state()
						s.icon_state = "Self Train off"
						var/turf/t = m.loc
						if(m.skill_focus && m.skill_focus.active || t && t.liquid) animate(m)
						/*
						if(m.pixel_y)
							animate(m,pixel_y = initial(m.pixel_y), time = 10)
							if(m.reflection) animate(m.reflection,pixel_y = initial(m.pixel_y), time = 10)
						*/
						if(m && m.client && m.started)
							//m.power_sources -= "Meditation"
							//m.energy_sources -= "Meditation"
							m.strength_sources -= "Self Train"
							m.endurance_sources -= "Self Train"
							m.agility_sources -= "Self Train"
							m.offence_sources -= "Self Train"
							m.defence_sources -= "Self Train"
							//m.regen_sources -= "Meditation"
							//m.recov_sources -= "Meditation"
						if(m.shadow)
							m.shadow.step_y -= 4
						//m.metabolic_rate *= 2
						//m.dehydration_rate *= 2
						//m.tiredness_rate *= 2
						m.open_close_eyes(0)
						m<<output("You stop training.","actionoutput")
					else
						if(m.energy<=2) return
						if(m.skill_flight && m.skill_flight.active) call(m.skill_flight.act)(m,m.skill_flight)
						if(m.skill_levitation && m.skill_levitation.active) call(m.skill_levitation.act)(m,m.skill_levitation)
						if(m.skill_quicksilver && m.skill_quicksilver.active) call(m.skill_quicksilver.act)(m,m.skill_quicksilver)
						//if(m.skill_active_selftrain&& m.skill_active_meditation.active) call(m.skill_active_meditation.act)(m,m.skill_active_meditation)
						for(var/obj/skills/Incubation/inc in m)
							if(inc.active) animate(m)
						m.Move(m.loc,SOUTH,m.step_x,m.step_y)
						m.selftraining = 1
						m.icon_state = "Train"
						s.icon_state = "Self Train"
						s.active = 1
						if(m.stance) //Switch off all stances
							m.disable_stances(null,1)
						if(m.grab) m.letgo()
						var/turf/t = m.loc
						if(m.skill_focus && m.skill_focus.active || t && t.liquid)
							var/pix_y = 0
						//	if(m.race == "Alien") pix_y = -16
							animate(m,pixel_y = 10, time = 20,loop = -1,flags = ANIMATION_PARALLEL + ANIMATION_END_NOW)
							animate(pixel_y = pix_y, time = 20)
						if(m.shadow)
							m.shadow.step_y += 4
						//m.metabolic_rate /= 2
						//m.dehydration_rate /= 2
						//m.tiredness_rate /= 2
						m.open_close_eyes(1)
						m<<output("You start training.","actionoutput")
			New()
				..()
				category = list("Strength","Endurance")
				spawn(10)
					src.info = text_self_train
					if(src.disable_sleep) return
					spawn(10)
						while(src)
							if(ismob(src.loc))
								var/mob/m = src.loc
								if(src.active)
									m.icon_state = "Train"
									//m.check_quest("gen_meditate",1,1,1)

									//Normal gains

									var/N = 1
									//if(m.race == "Celestial") N = 20
									if(!src.last_gain_time || world.time >= src.last_gain_time + src.gain_cd)
										var/growth_mult = clamp(0.25 + (m.PG), 0.25, 5) // PG gives modest scaling
										m.gain_stat("rating",1,growth_mult,"Self Train")
										m.gain_stat("power",1,m.mod_psionic_power*0.125,"Self Train")
										m.gain_stat("energy",1,m.mod_energy*0.125,"Self Train")
										if(prob(75))m.gain_stat("strength",1,(m.mod_strength*0.00125)/1,"Self Train")
										m.gain_stat("endurance",1,m.mod_endurance,"Self Train")

										if(prob(25))m.gain_stat("agility",1,m.mod_agility*0.025,"Self Train")
									//	if(prob(1)) m.gain_stat("offence",1,N,"Self Train")
										//if(prob(1)) m.gain_stat("defence",1,N,"Self Train")
										//src.skill_exp += (N/src.skill_lvl)*m.mod_skill
										src.skill_exp += (((N/4)-(src.skill_lvl/40))*m.mod_skill)+0.025
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)
										src.last_gain_time = world.time
									//if(prob(0.01*(m.mod_energy+m.mod_recovery))) m.decline+=0.2

									//var/L = length(m.buffs)
									//if(L == 0)

									//if(m.energy !=0 || m.energy >=1 ) // energy recovery while meditating
									//	m.energy -= (0.01*m.energy_max*m.mod_recovery)+(src.skill_lvl/100)
										//else m.energy += 0.001*m.energy_max*m.mod_recovery+(src.skill_lvl/100)
										if(m.energy <= (m.energy_max*0.05))
											m.energy = 0
											src.active=0
											m.selftraining=0
											m<<output("You ran out of energy","actionoutput")
											m.icon_state = m.state()
											src.icon_state = "Self Train off"
											var/turf/t = m.loc
											if(m.skill_focus && m.skill_focus.active || t && t.liquid) animate(m)
											/*
											if(m.pixel_y)
												animate(m,pixel_y = initial(m.pixel_y), time = 10)
												if(m.reflection) animate(m.reflection,pixel_y = initial(m.pixel_y), time = 10)
											*/
											if(m && m.client && m.started)
												m.strength_sources -= "Self Train"
												m.endurance_sources -= "Self Train"
												m.agility_sources -= "Self Train"
												m.offence_sources -= "Self Train"
												m.defence_sources -= "Self Train"
											if(m.shadow)
												m.shadow.step_y -= 4
										//	m.gains_temp_off_mod += m.mod_offence
										//	m.gains_temp_def_mod += m.mod_defence
											//m.gains_temp_off += m.offence
											//m.gains_temp_def += m.defence
											//..m.offence *= 2
											//..m.defence *= 2
											//m.mod_offence *= 2
											//m.mod_defence *= 2
											m.metabolic_rate *= 2
											m.dehydration_rate *= 2
											m.tiredness_rate *= 2
											m.open_close_eyes(0)
										else
										//	m.energy -= (1000/rand(10,20))*(m.mod_recovery)*((m.weight*0.125)**0.1)
											m.energy -= (300/m.mod_recovery)*((m.weight*0.125)**0.1)
							sleep(1)

			Click(location,control,params)
				//world << "[src]'s loc is [src.loc]"
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					//if(m.buffs.Find("flying")) return
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
		Meditate
			icon_state = "Meditate off"
			act = /obj/skills/Meditate/proc/activate
			info_stats = "Unable to move while active"
			var/tmp/last_gain_time = 0
			var/gain_cd = 25  // cooldown in ticks (2.5 seconds)
			proc
				activate(var/mob/m,var/obj/s)
					if(m.skill_sleep && m.skill_sleep.active) return
					if(m.selftraining) return
					if(m.stunned) return
					if(world.time < s.last_activate_time + 30)
					//	world.log << "[m] Meditate skill cooldown: [s.last_activate_time]/[world.time]"
						return
					s.last_activate_time = world.time
					if(m && s && m.skill_meditation == null) m.skill_meditation = s
					if(s.active)
						s.active = 0
						m.meditating = 0
						//m.pixel_y = -8
						m.icon_state = m.state()
						s.icon_state = "Meditate off"
						var/turf/t = m.loc
						if(m.skill_focus && m.skill_focus.active || t && t.liquid) animate(m)
						/*
						if(m.pixel_y)
							animate(m,pixel_y = initial(m.pixel_y), time = 10)
							if(m.reflection) animate(m.reflection,pixel_y = initial(m.pixel_y), time = 10)
						*/
						if(m && m.client && m.started)
							//m.power_sources -= "Meditation"
							m.energy_sources -= "Meditation"
						//	m.strength_sources -= "Meditation"
						//	m.endurance_sources -= "Meditation"
						//	m.force_sources -= "Meditation"
							m.resistance_sources -= "Meditation"
							m.agility_sources -= "Meditation"
						//	m.offence_sources -= "Meditation"
						//	m.defence_sources -= "Meditation"
							//m.regen_sources -= "Meditation"
							//m.recov_sources -= "Meditation"
						if(m.shadow)
							m.shadow.step_y -= 4
						//m.metabolic_rate *= 2
						//m.dehydration_rate *= 2
						//m.tiredness_rate *= 2
						m.open_close_eyes(0)
						m<<output("You stop meditating.","actionoutput")
					else
						if(m.skill_flight && m.skill_flight.active) call(m.skill_flight.act)(m,m.skill_flight)
						if(m.skill_levitation && m.skill_levitation.active) call(m.skill_levitation.act)(m,m.skill_levitation)
						if(m.skill_quicksilver && m.skill_quicksilver.active) call(m.skill_quicksilver.act)(m,m.skill_quicksilver)
						if(m.skill_active_meditation && m.skill_active_meditation.active) call(m.skill_active_meditation.act)(m,m.skill_active_meditation)
						if(m.skill_selftrain && m.skill_selftrain.active) call(m.skill_selftrain.act)(m,m.skill_selftrain)
						for(var/obj/skills/Incubation/inc in m)
							if(inc.active) animate(m)
						m.Move(m.loc,SOUTH,m.step_x,m.step_y)
						m.meditating = 1
						m.icon_state = "Meditate"
						s.icon_state = "Meditate"
						s.active = 1
						if(m.stance) //Switch off all stances
							m.disable_stances(null,1)
						if(m.grab) m.letgo()
						var/turf/t = m.loc
						if(m.skill_focus && m.skill_focus.active || t && t.liquid)
							var/pix_y = 0
						//	if(m.race == "Alien") pix_y = -16
							animate(m,pixel_y = 10, time = 20,loop = -1,flags = ANIMATION_PARALLEL + ANIMATION_END_NOW)
							animate(pixel_y = pix_y, time = 20)
						if(m.shadow)
							m.shadow.step_y += 4

						//m.metabolic_rate /= 2
						//m.dehydration_rate /= 2
						//m.tiredness_rate /= 2
						m.open_close_eyes(1)
						if(m.anger >100 && m.oozaru_form == 0 && m.lssj_form == 0) m.reset_anger()
						m<<output("You start to meditate.","actionoutput")
			New()
				..()
				category = list("Energy","Regeneration","Recovery","Utility")
				spawn(10)
					src.info = text_meditation


					if(src.disable_sleep) return
					spawn(10)
						while(src)
							if(ismob(src.loc))
								var/mob/m = src.loc
								var/exp = m.mod_tech_potential
								if(src.active)
									m.icon_state = "Meditate"
									//m.check_quest("gen_meditate",1,1,1)
									if(ismob(src.loc))
										/*for(var/obj/items/Bedroll/B in range(0, m))
											bed = B
											break*/
										var/bed_bonus = 1
										for(var/obj/items/Bedroll/B in range(1, m))
											if(isturf(B.loc))
												bed_bonus = 2
												break

										if(bed_bonus == 1)
											for(var/obj/Beds/B2 in range(1, m))
												if(isturf(B2.loc))
													bed_bonus = 2
													break
										if(bed_bonus == 2)
											m.restedness += 0.25 * bed_bonus
											if(m.restedness>100) m.restedness = 100

									//Intelligence gain
									if(!src.last_gain_time || world.time >= src.last_gain_time + src.gain_cd)
										//Intelligence gain start
										if(m.skill_study && m.skill_study.active)
											exp = m.mod_tech_potential
											if(m.cycle_free_time)
												if(!cftglobal) m.cycle_free_time -= 0.015
												if(m.cycle_free_time <= -0.1 || m.cycle_free_time <= -0.1 )
													m.remove_cft()
												else
													exp *=1
											else if(m.offline_gains && !m.standing_gains_timer)
												m.offline_gains -= 0.03
												if(m.offline_gains <= -0.1)
													m.offline_gains = 0
												else
													exp *= 3
											if(m.standing_gains_timer)
												m.standing_gains_timer --
												exp *= 1.5

											if(m.inside_hbtc)
												exp *= 5
												//multi *= 5

											//var/htt_multiplier = min(max(0, (m.HTT - 1) / 10), 50) + 1
											//src.create_chat_entry("local","Pre: [htt_multiplier] - HTT (Current HTT: [src.HTT])",0,1)
										//	if(m.HTT < 1)
											//	htt_multiplier = 0 // Below 100 HTT? No gains at all.
											//if(htt_multiplier !=0) exp =  exp * (htt_multiplier)
											var/growth_mult = clamp(0.25 + (m.PG), 0.25, 10) // PG gives modest scaling
											var/rating_mult = clamp(log(1 + m.rating / 50000), 1, 10) // no +1 in base to allow smoother scaling
											//var/rating_mult = clamp(1 + log(1 + m.rating / 50000), 1, 10) // slows over time
											m.intxp += (exp * 0.001 * growth_mult) * rating_mult
											//m<<"Growth mult: [growth_mult] - rating mult: [rating_mult] - exp: [exp] * 0.001 [exp *0.001 * growth_mult] - growthmult"
											m.gain_stat("rating",1,growth_mult)
											m.gain_stat("energy",1,(m.mod_energy/1*0.75))
											if(prob(50))m.gain_stat("resistance",1,m.mod_resistance/1*0.25)
											if(prob(98))m.gain_stat("agility",1,(m.mod_agility/1*0.000125))
											if(prob(10))m.gain_stat("power",1,m.mod_psionic_power*0.125,"",1)
											src.last_gain_time = world.time
											goto end

										//Magical gain

										if(m.skill_hone && m.skill_hone.active)
											exp = m.mod_arcane_potential
											if(m.cycle_free_time)
												if(!cftglobal)m.cycle_free_time -= 0.015
												if(m.cycle_free_time <= -0.1 || m.cycle_free_time <= -0.1 )
													m.remove_cft()
												else
													exp *=1
											else if(m.offline_gains && !m.standing_gains_timer)
												m.offline_gains -= 0.03
												if(m.offline_gains <= -0.1)
													m.offline_gains = 0
												else
													exp *= 3
											if(m.standing_gains_timer)
												m.standing_gains_timer --
												exp *= 1.5

											if(m.inside_hbtc)
												exp *= 5
											//src.create_chat_entry("local","Pre: [htt_multiplier] - HTT (Current HTT: [src.HTT])",0,1)
											//if(m.HTT < 1)
												//htt_multiplier = 0 // Below 100 HTT? No gains at all.
											//if(htt_multiplier !=0) exp =  exp * (htt_multiplier)
											var/growth_mult = clamp(0.25 + (m.PG), 0.25, 8) // PG gives modest scaling
											var/rating_mult = clamp(1 + log(1 + m.rating / 50000), 1, 10) // slows over time
											m.magicxp +=(exp * 0.001 * growth_mult) / rating_mult
											m.gain_stat("rating",1,growth_mult)
											m.gain_stat("energy",1,(m.mod_energy/1*0.75))
											if(prob(50))m.gain_stat("resistance",1,m.mod_resistance/1*0.25)
											if(prob(98))m.gain_stat("agility",1,(m.mod_agility/1*0.000125))
											if(prob(10))m.gain_stat("power",1,m.mod_psionic_power*0.125,"",1)
											src.last_gain_time = world.time
											goto end
											//m.rng_intelpts(b, 1)






									//Tech research
									/*else if(m.tech_focus)
										var/obj/items/tech/sub_tech/t = m.tech_focus
										m.tech_xp[t.list_pos] += t.tech_exp_gain*m.mod_tech_potential
										m.intxp += m.mod_tech_potential
										if(m.tech_xp[t.list_pos] >= 100)
											t.lvl_up_tech(m)
											m.check_quest("gen_lvl_research",1,0,1)

										m.tech_xp_update()*/

										/*
										if(m.tech_display == t)
											if(tech_xp_bar)//if(t.xp_bar)
												var/matrix/m1 = matrix()
												m1.Translate(t.hud_x,t.hud_y)
												tech_xp_bar.transform = m1
												var/result =  round((m.tech_xp[t.list_pos]/100)*100,10)
												tech_xp_bar.icon_state = "[result]"
												if(m.hud_tech)
													var/obj/hud/menus/tech_background/b = m.hud_tech
													b.tech_holder_special.overlays = null
													b.tech_holder_special.overlays += tech_xp_bar
												//t.xp_bar.pixel_x = -22+result
										*/
										//Normal gains
										else
											if(!m.skill_study || m.skill_study.active == 0)

												var/N = 1
												var/growth_mult = clamp(0.25 + (m.PG), 0.25, 5) // PG gives modest scaling
												//if(m.race == "Celestial") N = 20
												m.gain_stat("rating",1,growth_mult,"Meditation")
												//m.gain_stat("power",1,N,"Meditation")
												m.gain_stat("energy",1,m.mod_energy/N,"Meditation")
											//	m.gain_stat("strength",1,N,"Meditation")
											//	m.gain_stat("endurance",1,N,"Meditation")
												if(prob(5))m.gain_stat("agility",1,m.mod_agility/N*0.0125,"Meditation")
												if(prob(50))m.gain_stat("power",1,m.mod_psionic_power*0.125,"Meditation",1)
												//m.gain_stat("force",1,m.mod_force/1*0.00125,"Meditation",1)
											//	m<<"Stat Gain Force: [m.mod_force/1*0.0125] < -"
											//	m.gain_stat("offence",1,N,"Meditation")
											//	m.gain_stat("defence",1,N,"Meditation")
												m.gain_stat("resistance",1,m.mod_resistance/N,"Meditation")
											//	m.gain_stat("force",1,N,"Meditation")
											//	m.gain_stat("regen",1,N,"Meditation")
											//	m.gain_stat("recovery",1,N,"Meditation")
												//src.skill_exp += (N/src.skill_lvl)*m.mod_skill
												/*src.skill_exp += (((N/4)-(src.skill_lvl/40))*m.mod_skill)+0.025
												if(src.skill_exp >= 100 && src.skill_lvl < 100)
													src.skill_exp = 1
													src.skill_lvl += 1
													src.skill_up(m) */
												//if(prob(0.01*(m.mod_energy+m.mod_recovery))) m.decline+=0.2

												//var/L = length(m.buffs)
												//if(L == 0)
												if(m.energy < m.energy_max) // energy recovery while meditating
													var/gain_eng = 0
													if(m.mortal) gain_eng = 1
													else if(m.z == 2 || m.z == 6) gain_eng = 1
													if(gain_eng) m.energy += 0.01*m.energy_max*m.mod_recovery+(src.skill_lvl/100)
													else m.energy += 0.001*m.energy_max*m.mod_recovery+(src.skill_lvl/100)
													if(m.energy > m.energy_max) m.energy = m.energy_max
												src.last_gain_time = world.time
							end
							sleep(1)
			Click(location,control,params)
				//world << "[src]'s loc is [src.loc]"
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					//if(m.buffs.Find("flying")) return
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

		Sleep
			info_name ="sleep"

			icon_state = "Meditate off"
			act = /obj/skills/Sleep/proc/activate
			info_stats = "Unable to move while active\n\nFall asleep anywhere, but on a bed is better."
			var/tired_gain = 0.25
			proc
				activate(var/mob/m,var/obj/s)
					if(m && s && m.skill_sleep == null) m.skill_sleep = s
					if(s.active)
						s.active = 0
						m.stunned = 0
						m.stunned_pending = 0
						m.icon_state = m.state()
						s.icon_state = "Meditate off"
						if(m.shadow)
							m.shadow.step_y -= 4
						m.open_close_eyes(0)
					else
					//	m.check_quest("tutorial_sleep",1)

						if(m.restedness >= 100)
							m<<output("You are already fully rested.","actionoutput")
							return

						if(m.skill_flight && m.skill_flight.active) call(m.skill_flight.act)(m,m.skill_flight)
						if(m.skill_levitation && m.skill_levitation.active) call(m.skill_levitation.act)(m,m.skill_levitation)
						if(m.skill_quicksilver && m.skill_quicksilver.active) call(m.skill_quicksilver.act)(m,m.skill_quicksilver)
						if(m.skill_active_meditation && m.skill_active_meditation.active) call(m.skill_active_meditation.act)(m,m.skill_active_meditation)
						if(m.skill_meditation && m.skill_meditation.active) call(m.skill_meditation.act)(m,m.skill_meditation)
						/*for(var/obj/skills/Incubation/inc in m)
							if(inc.active) animate(m)*/
						m.Move(m.loc,SOUTH,m.step_x,m.step_y)
						m.icon_state = "Meditate"
						s.icon_state = "Meditate"
						s.active = 1
						m.stunned += 1
						m.stunned_pending += 1
						if(m.stance) //Switch off all stances
							m.disable_stances(null,1)
						if(m.grab) m.letgo()
						if(m.shadow)
							m.shadow.step_y += 4
						m.open_close_eyes(1)
			New()
				..()
				category = list("Recovery","Utility")
				spawn(10)
					src.info = text_sleep


					//if(src.disable_sleep) return
					spawn(10)
						while(src)
							var/spd = 40
							if(ismob(src.loc))
								var/mob/m = src.loc
								if(src.active)
									m.icon_state = "Meditate"
									if(m.restedness >= 100)
										m.restedness = 100
										sleep(spd)
										return

									if(ismob(src.loc))
										/*for(var/obj/items/Bedroll/B in range(0, m))
											bed = B
											break*/
										var/bed_bonus = 1

										// Bed detection (cheap)
										for(var/obj/items/Bedroll/B in range(1, m))
											if(isturf(B.loc))
												bed_bonus = 2
												break

										if(bed_bonus == 1)
											for(var/obj/Beds/B2 in range(1, m))
												if(isturf(B2.loc))
													bed_bonus = 2
													break
										m.restedness += 0.25 * bed_bonus
										if(m.restedness > 100)
											m.restedness = 100

									/*var/obj/items/Bedroll/bed = locate(/obj/items/Bedroll) in range(1, m)
									var/obj/Beds/beds = locate(/obj/Beds) in range(1, m)
									if(bed || beds)
										tired_gain = 0.5

									m.restedness += tired_gain
									if(m.restedness >= 100)
										m.restedness = 100*/

									//	call(src.act)(m,src)
							sleep(spd)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					//if(m.buffs.Find("flying")) return
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
		Active_Meditation
			icon_state = "Active Meditation off"
			act = /obj/skills/Active_Meditation/proc/activate
			info_stats = "+100% Divine Energy gathering\n\nSmall xp gain in all stats\n\nCan move while active\n\nProtects against eye damage"
			info = "This is a special form of meditation that allows the user to perform a wide range of movements and actions without being constrained to a meditative position. Just like in normal meditation, this form will give a small amount of xp in all stats and even allow research to be done, but at half the normal rate compared to seated meditation. Also, this form does not boost the rate at which someone heals or recovers energy, and also halves Offence and Defence. In using this, the users eyes have a measure of protection from some skills that might harm vision."
			info_point_cost_type = "energy"
			hud_x = 356
			hud_y = 636
			proc
				activate(var/mob/m,var/obj/s)
					if(m && s && m.skill_active_meditation == null) m.skill_active_meditation = s

					if(s.active)
						s.active = 0

						m.icon_state = m.state()
						s.icon_state = "Active Meditation off"
						/*
						if(m.pixel_y)
							animate(m,pixel_y = initial(m.pixel_y), time = 10)
							if(m.reflection) animate(m.reflection,pixel_y = initial(m.pixel_y), time = 10)
						*/
						if(m && m.client && m.started)
							m.power_sources -= "Active Meditation"
							m.energy_sources -= "Active Meditation"
							m.strength_sources -= "Active Meditation"
							m.endurance_sources -= "Active Meditation"
							m.force_sources -= "Active Meditation"
							m.resistance_sources -= "Active Meditation"
							m.agility_sources -= "Active Meditation"
							m.offence_sources -= "Active Meditation"
							m.defence_sources -= "Active Meditation"
							m.regen_sources -= "Active Meditation"
							m.recov_sources -= "Active Meditation"
						m.open_close_eyes(0)
					else
						if(m.skill_meditation && m.skill_meditation.active) call(m.skill_meditation.act)(m,m.skill_meditation)
						s.icon_state = "Active Meditation"
						s.active = 1
						m.open_close_eyes(1)
			New()
				..()
				category = list("Energy","Regeneration","Recovery","Utility")
				spawn(10)


					if(src.disable_sleep) return
					spawn(10)
						while(src)
							var/spd = 10
							if(ismob(src.loc))
								var/mob/m = src.loc
								if(src.active)
								//	m.check_quest("gen_meditate",1,1,1)
									//Tech research
									if(m.tech_focus)
										var/obj/items/tech/sub_tech/t = m.tech_focus
										m.tech_xp[t.list_pos] += t.tech_exp_gain*m.mod_tech_potential
										if(m.tech_xp[t.list_pos] >= 100) t.lvl_up_tech(m)
										if(m.tech_display == t)
											if(t.xp_bar)
												var/result =  round((m.tech_xp[t.list_pos]/100)*22)
												t.xp_bar.pixel_x = -22+result
									//Normal gains
									else
										var/N = 5
										//if(m.race == "Celestial") N = 20
										m.gain_stat("rating",1,N,"Meditation")
										m.gain_stat("power",1,N,"Active Meditation")
										m.gain_stat("energy",1,N,"Active Meditation")
										m.gain_stat("strength",1,N,"Active Meditation")
										m.gain_stat("endurance",1,N,"Active Meditation")
										m.gain_stat("agility",1,N,"Active Meditation")
										m.gain_stat("offence",1,N,"Active Meditation")
										m.gain_stat("defence",1,N,"Active Meditation")
										m.gain_stat("resistance",1,N,"Active Meditation")
										m.gain_stat("force",1,N,"Active Meditation")
										m.gain_stat("regen",1,N,"Active Meditation")
										m.gain_stat("recovery",1,N,"Active Meditation")
										//src.skill_exp += (N/src.skill_lvl)*m.mod_skill
										src.skill_exp += (((N/4)-(src.skill_lvl/40))*m.mod_skill)+0.025
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)
										//if(prob(0.01*(m.mod_energy+m.mod_recovery))) m.decline+=0.2

										//var/L = length(m.buffs)
										//if(L == 0)
							sleep(spd)
			Click(location,control,params)
				//world << "[src]'s loc is [src.loc]"
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					//if(m.buffs.Find("flying")) return
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
		Plant_Cultivation //Call this something else
				//Use this to imbue plants and herbs with energy so they grow quicker and become more potent?
				//Also make it so when you eat foods, you get seeds which you can click and replant.
		Divine_Weapon
			name = "Divine Weapon"
			info_name = "divine_weapon"
			icon_state = "divine weapon sword off"
			info_energy_cost = 4
			info_mastery = 1
			teach_energy = 3000
			info_point_cost = 5
			info = "Through the application of Divine Energy, forcefully manifest a weapon for you to command. The weapons are linked to you in some manner, either spirituality or telepathically and obey only your commands. The weapon shape can be changed by right clicking this skill. The number you can summon is based on this skills level. They have little to no regenerative capabilities and cost 25 Divine Energy to conjure. They are also destroyed when defeated."
			info_duration = "Instant"
			info_point_cost_type = "force"
			info_stats = "Energy Cost: Very High\n\nMastery: Slow"
			act = /obj/skills/Divine_Weapon/proc/activate
			hud_x = 116
			hud_y = 636
			var
				list/active_splits = list()
				max_splits = 10
				icon_og = "divine weapon sword"
				list/icons = list('divine weapon sword.dmi','divine weapon cross.dmi','divine weapon spear.dmi','divine weapon sword 1.dmi','divine weapon hammer.dmi','divine weapon axe.dmi')
				list/icon_states = list("divine weapon sword","divine weapon cross","divine weapon spear","divine weapon sword 1","divine weapon hammer","divine weapon axe")
				progress = 0;
				obj/bar = null
				obj/bar_inner = null
				tmp/mob/dw = null
				tmp/obj/g_rays = null
				tmp/list/pixs
				current_i = 1
			proc
				activate(var/mob/m,var/obj/skills/Divine_Weapon/x)
					//return
					if(m && x)
						if(x.active == 0)
							if(x.dw)
								x.dw.destroy()
								x.dw = null
							if(x.g_rays)
								x.g_rays.destroy()
								x.g_rays = null
							if(x.pixs && islist(x.pixs))
								for(var/obj/o in x.pixs)
									o.destroy()
							x.pixs = list()
							if(m.stance) //Switch off all stances
								m.disable_stances(null,1)
							if(m.grab) m.letgo()

							for(var/obj/skills/Meditate/med in m)
								if(med.active) call(med.act)(m,med)
							for(var/obj/skills/Dark_Transmutation/dt in m)
								if(dt.active) call(dt.act)(m,dt)
							for(var/obj/skills/Dark_Infusion/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Divine_Infusion/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Dark_Petrifaction/sk in m)
								if(sk.active) call(sk.act)(m,sk)
							for(var/obj/skills/Incubation/inc in m)
								if(inc.active) call(inc.act)(m,inc)

							if(length(x.active_splits) >= x.max_splits)
								m << output("<font color = teal>You currently have the max number of Divine Weapons you can create.","chat.system")
								m.set_alert("Max weapons currently",x.icon,x.icon_state)
								m.create_chat_entry("alerts","Max weapons currently.")
								return
							if(m.energy >= m.energy_max/1.05)
								x.icon_state = "[x.icon_og]"
								x.active = 1
								m.stunned += 1
								m.stunned_pending += 1
								m.client.screen += x.bar
								m.dir = SOUTH

								m.energy -= m.energy_max/x.skill_lvl
								x.skill_exp += (100/x.skill_lvl)*m.mod_skill
								if(x.skill_exp >= 100 && x.skill_lvl < 100)
									x.skill_exp = 1
									x.skill_lvl += 1
									x.skill_up(m)
								var/mob/races/Celestial/s = new
								s.icon = x.icons[x.current_i]
								s.density_factor = 0
								s.alpha = 55
								s.dir = SOUTH
								s.tmp_lists()
								var/image/sel = image('select.dmi',s,null,10,pixel_y = 8)
								sel.appearance_flags = KEEP_APART | RESET_TRANSFORM
								s.target_img = sel

								animate(s,alpha = 255, time = 7)
								s.filters += filter(type="outline",size=1, color=rgb(204,236,255))
								s.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(204,236,255))
								s.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
								x.dw = s

								s.loc = locate(m.x,m.y-2,m.z)
								s.layer = 10
								s.step_x = m.step_x
								s.step_y = m.step_y+12
								s.bolted = 2
								s.divine_weapon = 1
								s.floats = 1
								s.hasreflect = 0
								s.attack_range = 64

								var/obj/effects/shadow/shad = new
								var/obj/effects/weapon_energy/we = new
								shad.appearance_flags = KEEP_APART | RESET_TRANSFORM
								shad.pixel_y = -8
								//shad.pixel_x = 5
								shad.loc = s.loc
								shad.step_x = s.step_x+3
								shad.step_y = s.step_y
								shad.vis_contents += we
								s.shadow = shad

								//s.create_afterimages()
								var/turf/t = s.loc
								if(!t.liquid)
									var/obj/effects/dust_medium/d = new
									d.SetCenter(s)
								s.shockwave()
								s.shockwave_huge()
								//animate(s,pixel_y = 4, color = list("#000", "#000", "#000", "#fff"),time = 12, loop = -1)
								//animate(pixel_y = 0, color = initial(m.color),time = 12)
								animate(s,transform = turn(matrix(), 120), time = 6, loop = -1)
								animate(transform = turn(matrix(), 240), time = 6)
								animate(transform = null, time = 6)

								var/obj/rays = new
								rays.icon = 'fx_ray_small.dmi'
								rays.pixel_x = -16
								rays.pixel_y = -16
								rays.loc = locate(m.x,m.y-2,m.z)
								rays.bolted = 2
								rays.step_x = m.step_x
								rays.step_y = m.step_y+10
								rays.layer = 3
								rays.filters += filter(type="rays",x=0,y=0,size=64,color=rgb(204,236,255),offset=0,density=10,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
								animate(rays.filters[1],offset = 100,time = 1500, loop = -1)
								animate(offset = 0,time = 0)
								animate(rays.filters[1],y = 4,time = 12, loop = -1, flags = ANIMATION_PARALLEL)
								animate(y = 0, time = 12)
								x.g_rays = rays

								var/p = 33
								while(p)
									if(prob(25))
										sleep(1)
									p -= 1;
									var/obj/pix = new
									pix.icon = 'fx.dmi'
									pix.icon_state = "pixel"
									pix.loc = locate(m.x,m.y-2,m.z)
									pix.step_x = m.step_x
									pix.step_y = m.step_y+12
									pix.pixel_x = rand(-200,200)
									pix.pixel_y = rand(-200,200)
									pix.bolted = 2
									animate(pix,pixel_x = 0, pixel_y = 0, time = rand(5,10), alpha = 0,loop = -1)
									animate(pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = 0, alpha = 255)
									if(x.pixs && islist(x.pixs)) x.pixs += pix
									else x.pixs = list()

								sleep(3)
								if(s && m)
									//s.Celestial()
									s.vis_contents -= s.wings
									s.wings = null
									s.name = "{NPC} Divine Weapon"
									s.name_txt()
									s.icon = x.icons[x.current_i]
									s.appearance_flags = KEEP_TOGETHER
									s.mod_psionic_power = m.mod_psionic_power
									s.gains_trained_power = m.gains_trained_power
									s.gains_psiforged_power = m.gains_psiforged_power
									s.dead = m.dead
									if(s.dead) s.psionic_power /= 2
									s.strength = m.strength
									s.endurance = m.endurance
									s.force = m.force
									s.mod_agility = 10
									s.mod_str_usage = m.mod_str_usage
									s.mod_force_usage = m.mod_force_usage
									s.resistance = m.resistance
									s.mod_regeneration = 0.1
									s.mod_recovery = 0.1
									s.offence = m.offence
									s.defence = m.defence
									s.vigour = m.vigour
									s.gains_trained_energy = m.gains_trained_energy
									s.gains_psiforged_energy = m.gains_psiforged_energy

									/*
									var/obj/skills/Super_Speed/spd = new
									spd.loc = s
									s.skill_super_speed = spd
									spd.skill_lvl = 100//s.skill_super_speed.skill_lvl
									spd.active = 1
									s.mod_agility *= 1.1
									*/
									return
							else
								m << output("<font color = teal>Need more current energy.","chat.system")
								m.set_alert("Need more energy",x.icon,x.icon_state)
								m.create_chat_entry("alerts","Need more energy.")
								return
						else
							x.active = 0
							m.stunned -= 1
							m.stunned_pending -= 1
							m.icon_state = ""
							m.client.screen -= x.bar_inner
							m.client.screen -= x.bar
							x.bar_inner.screen_loc = "16:-2,10:-3"
							x.progress = 0
							x.icon_state = "[x.icon_og] off"
							if(x.g_rays)
								x.g_rays.destroy()
								x.g_rays = null
							if(x.pixs && islist(x.pixs))
								for(var/obj/o in x.pixs)
									animate(o)
									o.destroy()
									sleep(1)
								x.pixs = null
							if(x.dw)
								x.dw.destroy()
								x.dw = null
			New()
				..()
				category = list("Energy","Utility")
				spawn(10)
					bar = new /:revive_bar
					bar_inner = new /:divine_bar_inner


					if(src.disable_sleep) return
					spawn(10)
						if(src)
							while(src)
								if(src.active)
									var/mob/m = null
									if(ismob(src.loc))
										m = src.loc
										src.progress += 10//3+round(src.skill_lvl/10)
										//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
										src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)

										if(m.client)
											m.client.screen -= src.bar_inner
											src.bar_inner.screen_loc  = "16:[round(src.progress/2)-2],10:-3"
											var/matrix/M = matrix()
											M.Scale(round(src.progress),1)
											src.bar_inner.transform = M
											m.client.screen += src.bar_inner


										if(m.koed || m.meditating)
											call(src.act)(m,src)
										if(src.progress >= 100)
											src.progress = 100
											if(src.dw)
												animate(src.dw)
												src.dw.shockwave()
												var/obj/effects/lightning_bolt/b = new
												b.loc = src.dw.loc
												b.step_x = src.dw.step_x
												b.step_y = src.dw.step_y
												var/obj/o = src.dw
												spawn(7)
													if(o) o.shake()
											if(src.g_rays)
												src.g_rays.destroy()
												src.g_rays = null
											//sleep(10)
											//if(src && m)
											if(src.pixs && islist(src.pixs))
												for(var/obj/o in src.pixs)
													animate(o)
													o.destroy()
													sleep(1)
												src.pixs = null
											if(src.dw)
												if(src && m && src.dw)
													animate(src.dw,pixel_y = 10, time = 20,loop = -1)
													animate(pixel_y = 0, time = 20)
													src.active_splits += src.dw
													src.dw.owner = m.real_name
													//src.dw.buffs.Add("flying")
													//world << "DEBUG - Created [src.dw.skill_super_speed] for [src.dw]. Their super speed skill is now [src.dw.skill_super_speed], which has its active set to [dw.skill_super_speed.active]"
													src.dw = null
													src.icon_state = "[src.icon_og] off"
													m.divine_energy -= 25
											if(src && src.active && m) call(src.act)(m,src)
								sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(m.skill_divine_weapon == null) m.skill_divine_weapon = src
							call(src.act)(m,src)
					else if(dir == "right")
						if(src in m)
							src.current_i += 1
							if(current_i >= 7) src.current_i = 1
							if(src.active)
								src.icon_state = "[src.icon_states[current_i]]"
								src.icon_og = src.icon_states[current_i]
							else
								src.icon_state = "[src.icon_states[current_i]] off"
								src.icon_og = src.icon_states[current_i]
		Summon_Mage_Pot
			name = "Summon Mage Pot"
			info_name = "mage pot"
			icon_state = "mage pot off"
			info_energy_cost = 3
			info_mastery = 1
			teach_energy = 3000
			info_point_cost = 5
			info_buffs = "Summons a Witch Pot for species creation development, requires a base type ingredient and energy to hatch the results. Other ingredients can be added as an increase into making sure you make the correct species.\nA 25% sacrifice of energy is needed to create the pot.\nThe pot can only exist in the Underworld."

			info_duration = "Instant"
			info_point_cost_type = "energy"
			info_stats = "Energy Cost: High\n\nMastery: Slow"
			act = /obj/skills/Summon_Mage_Pot/proc/activate

			proc
				activate(var/mob/m,var/obj/skills/Summon_Mage_Pot/x)
					m = usr
					if(m && x)

						var/needed_energy = m.energy_max * 0.25 // 25% of energy_max
						if(m.energy < needed_energy)
							m.set_alert("You don't have enough energy to summon a Witch Pot.",x.icon,x.icon_state)
							return
						//x.max_splits = round(1+(x.skill_lvl/11),1)
						if(m.z != 18)
							m.set_alert("The pot cannot exist in this realm.",x.icon,x.icon_state)
							return

						x.icon_state = "mage pot"
						//m.energy_max -= needed_energy
						m.energy -= needed_energy
						var/obj/items/Mage_Pot/pot = new /obj/items/Mage_Pot(get_step(m, m.dir))
						pot.user = m // Assign the user to the pot
						for(var/mob/MM in view(10,m))
							MM.create_chat_entry("local","A mage pot was summoned.",0,1)
						m.set_alert("You created a Mage Pot!",x.icon,x.icon_state)
						spawn(10) x.icon_state = "mage pot off"
						m.skill_cooldown(src)

						//spawn(32)
						//	x.icon_state="mage pot off"
						return


			New()
				..()
				category = list("Energy","Utility")
				src.info = text_summon_mage_pot


			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(m.skill_mage_pot == null) m.skill_mage_pot = src
							call(src.act)(m,src)

		Split_Form
			name = "Split Form"
			info_name = "psi_clone"
			icon_state = "Psi Clone off"
			info_energy_cost = 3
			info_mastery = 1
			teach_energy = 3000
			info_point_cost = 5
			info_buffs = "Create a copy to send against your foes"
			info_duration = "Instant"
			info_point_cost_type = "energy"
			info_stats = "Energy Cost: High\n\nMastery: Slow"
			act = /obj/skills/Split_Form/proc/activate

			var
				list/active_splits = list()
				max_splits = 10
			proc
				activate(var/mob/m,var/obj/skills/Split_Form/x)
					if(!m || !x) return

					// Clean invalid/stale splits first
					for(var/mob/s in x.active_splits.Copy())
						if(!s || s.loc == null)
							x.active_splits -= s

					if(length(x.active_splits) >= x.max_splits)
						return

					if(m.energy < m.energy_max / max(x.skill_lvl, 1))
						m << output("<font color = teal>You need more energy to continue.","chat.system")
						m.set_alert("Need more energy",x.icon,x.icon_state)
						m.create_chat_entry("alerts","Need more energy.")
						return

					x.icon_state = "Psi Clone"
					m.energy -= m.energy_max / max(x.skill_lvl, 1)

					x.skill_exp += ((10-(x.skill_lvl/10))*m.mod_skill)+1
					if(x.skill_exp >= 100 && x.skill_lvl < 100)
						x.skill_exp = 1
						x.skill_lvl += 1
						x.skill_up(m)

					m.create_follower(null,"Clone","Clone","Clone",x)

				/*activate(var/mob/m,var/obj/skills/Split_Form/x)
					if(m && x)
						//x.max_splits = round(1+(x.skill_lvl/11),1)
						for(var/mob/s in x.active_splits)
							if(s.loc == null)
								s.loc = get_step(m,m.dir)
								s.dir = get_dir(s,m)
								s.pixel_x = m.pixel_x
								s.pixel_y = m.pixel_y
								s.step_x = m.step_x;
								s.step_y = m.step_y;
								var/image/sel = image('select.dmi',s,null,10,pixel_y = 8)
								sel.appearance_flags = KEEP_APART | RESET_TRANSFORM
								s.target_img = sel
						if(length(x.active_splits) >= x.max_splits) return
						if(m.energy >= m.energy_max/x.skill_lvl)
							x.icon_state = "Psi Clone"

							m.energy -= m.energy_max/x.skill_lvl
							//x.skill_exp += (100/x.skill_lvl)*m.mod_skill
							x.skill_exp += ((10-(x.skill_lvl/10))*m.mod_skill)+1
							if(x.skill_exp >= 100 && x.skill_lvl < 100)
								x.skill_exp = 1
								x.skill_lvl += 1
								x.skill_up(m)
							m.create_follower(null,"Clone","Clone","Clone",x)
							return
						else
							m << output("<font color = teal>You need more energy to continue.","chat.system")
							m.set_alert("Need more energy",x.icon,x.icon_state)
							m.create_chat_entry("alerts","Need more energy.")
							return*/
			New()
				..()
				category = list("Energy","Utility")
				spawn(10)
					src.info = text_split_form


			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(m.skill_psi_clone == null) m.skill_psi_clone = src
							call(src.act)(m,src)
		Simulacrum
		//Demon special ability, creates a clone like Psi Clone, but the player can switch between playing them instantly, and swap places.
		//Also if the player dies, they ressurect and become the Simulacrum.
		//Can have a max of 4 or so at once?
		//Costs dark matter to create
		//Stronger than normal psi clone, uses advanced combat ai when battling
		//Maybe make it cost 100 lifespan to do also?
		//Make it given as an ascension reward.
			name = "Simulacrum"
			info_name = "psi_clone"
			icon_state = "Psi Clone off"
			info_energy_cost = 3
			info_mastery = 1
			teach_energy = 3000
			info_point_cost = 5
			info_buffs = "Create a copy to send against your foes"
			info_duration = "Instant"
			info_point_cost_type = "energy"
			info_stats = "Energy Cost: High\n\nMastery: Slow"
			act = /obj/skills/Split_Form/proc/activate
			var
				list/active_splits = list()
				max_splits = 10
			proc
				activate(var/mob/m,var/obj/skills/Split_Form/x)
					if(m && x)
						//x.max_splits = round(1+(x.skill_lvl/11),1)
						for(var/mob/s in x.active_splits)
							if(s.loc == null)
								s.loc = get_step(m,m.dir)
								s.dir = get_dir(s,m)
								s.pixel_x = m.pixel_x
								s.pixel_y = m.pixel_y
								s.step_x = m.step_x;
								s.step_y = m.step_y;
								var/image/sel = image('select.dmi',s,null,10,pixel_y = 8)
								sel.appearance_flags = KEEP_APART | RESET_TRANSFORM
								s.target_img = sel
						if(length(x.active_splits) >= x.max_splits) return
						if(m.energy >= m.energy_max/x.skill_lvl)
							x.icon_state = "Psi Clone"

							m.energy -= m.energy_max/x.skill_lvl
							//x.skill_exp += (100/x.skill_lvl)*m.mod_skill
							x.skill_exp += ((10-(x.skill_lvl/10))*m.mod_skill)+1
							if(x.skill_exp >= 100 && x.skill_lvl < 100)
								x.skill_exp = 1
								x.skill_lvl += 1
								x.skill_up(m)
							var/mob/s = new m.type
							s.icon = m.icon
							s.loc = get_step(m,m.dir)
							s.dir = get_dir(s,m)
							s.pixel_x = m.pixel_x
							s.pixel_y = m.pixel_y
							s.step_x = m.step_x;
							s.step_y = m.step_y;
							s.density_factor = 0
							s.icon +=rgb(125,125,125)
							s.alpha = 55
							s.bodyparts = list(new /obj/body_related/bodyparts/head, new /obj/body_related/bodyparts/torso, new /obj/body_related/bodyparts/left_arm, new /obj/body_related/bodyparts/right_arm, new /obj/body_related/bodyparts/right_leg, new /obj/body_related/bodyparts/left_leg)
							s.dir = SOUTH
							var/image/sel = image('select.dmi',s,null,10,pixel_y = 8)
							sel.appearance_flags = KEEP_APART | RESET_TRANSFORM
							s.target_img = sel
							s.accessing = s
							animate(s,alpha = 255, time = 7)
							x.active_splits += s
							sleep(5)
							if(s && m) s.shockwave()
							sleep(3)
							if(s && m)
								x.icon_state = "Psi Clone off"
								/*
								if(m.race == "Human") s.Human()
								if(m.race == "Demon") s.Demon()
								if(m.race == "Celestial") s.Celestial()
								if(m.race == "Imp") s.Imp()
								if(m.race == "Cerebroid") s.Cerebroid()
								if(m.race == "Namekian") s.Yukopian()
								if(m.race == "Android") s.Android()
								*/
								s.name = "{NPC} Psi Clone"
								s.name_txt()
								s.icon = m.icon
								s.appearance_flags = KEEP_TOGETHER
								s.overlays = m.overlays
								s.mod_psionic_power = m.mod_psionic_power
								s.gains_trained_power = m.gains_trained_power
								s.gains_psiforged_power = m.gains_psiforged_power
								s.dead = m.dead
								if(s.dead) s.psionic_power /= 2
								if(m.wings_hidden == 0) s.wings = m.wings
								s.halo = m.halo
								s.eyes = m.eyes
								s.eyes_white = m.eyes_white
								s.vis_contents += s.eyes
								s.vis_contents += s.eyes_white
								s.strength = m.strength
								s.endurance = m.endurance
								s.force = m.force
								s.mod_str_usage = m.mod_str_usage
								s.mod_force_usage = m.mod_force_usage
								s.mod_agility = m.mod_agility
								s.resistance = m.resistance
								s.offence = m.offence
								s.defence = m.defence
								s.vigour = m.vigour
								s.owner = m.real_name
								s.gains_trained_energy = m.gains_trained_energy
								s.gains_psiforged_energy = m.gains_psiforged_energy
								s.Move(s.loc,SOUTH,s.step_x,s.step_y)
								s.filters = m.filters
								s.set_shadow()
								var/obj/skills/Dig/d = new
								d.loc = s
								for(var/obj/skills/Flight/f in m)
									var/obj/skills/Flight/fly = new
									fly.loc = s
									fly.skill_lvl = f.skill_lvl
									if(f.active)
										call(fly.act)(s,fly)
								return
						else
							m << output("<font color = teal>You need more energy to continue.","chat.system")
							m.set_alert("Need more energy",x.icon,x.icon_state)
							m.create_chat_entry("alerts","Need more energy.")
							return
			New()
				..()
				category = list("Energy","Utility")
				spawn(10)
					src.info = text_focus


			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
					var/dir = null
					if(params["left"] || m.mouse_dir == "left")
						dir = "left"
					if(params["right"])
						dir = "right"
					if(dir == "left")
						if(src in m)
							if(m.skill_psi_clone == null) m.skill_psi_clone = src
							call(src.act)(m,src)
		Invisibility
			icon_state = "Invisibility off"
			info_name = "invisibility"
			act = /obj/skills/Invisibility/proc/activate
			teach_energy = 2000
			proc
				activate(var/mob/m,var/obj/s)
					if(s in m)
						if(m.skill_invis == null) m.skill_invis = s
						var/needed = (10/m.mod_recovery) + (10/s.skill_lvl)
						if(s.active)
							s.active = 0
							s.icon_state = "Invisibility off"
							if(m.submerged == 0) animate(m,alpha = 255, time = 15)
							else animate(m,alpha = 100, time = 15)
							m.appearance_flags = LONG_GLIDE | KEEP_TOGETHER
							if(m.shadow && m.skill_dig == null || m.skill_dig && m.skill_dig.active == 0) animate(m.shadow,alpha = 255, time = 15)
							//spawn(15)
								//if(m) m.appearance_flags = null
						else if(m.energy >= needed)
							s.active = 1
							s.icon_state = "Invisibility"
							animate(m,alpha = 33, time = 15)
							m.appearance_flags = LONG_GLIDE | KEEP_TOGETHER
							if(m.shadow) animate(m.shadow,alpha = 0, time = 15)
							spawn(15)
								if(m) m.appearance_flags = null
			New()
				..()
				category = list("Energy","Utility")
				spawn(10)
					src.info = text_invisibility


					if(src.disable_sleep) return
					spawn(10)
						while(src)
							var/mob/m = null
							if(ismob(src.loc))
								m = src.loc
								if(src.active)
									var/removes = (10/m.mod_recovery) + (10/src.skill_lvl)
									if(m.energy >= removes)
										//m.energy-=5+((m.energy_max/10)/src.skill_lvl)/m.mod_recovery/m.mod_energy
										m.energy -= removes
										//world << "[removes] energy removed by [src]"
										//m << output("<font color = teal>[removes] energy removed by [src]","chat.system")
										//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
										//src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
										src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)
									else
										m.mouse_dir = "left"
										call(src.act)(m,src)
							sleep(10)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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


		Levitation
			icon_state = "Levitation off"
			info_energy_cost = 1
			info_mastery = 2
			info_point_cost = 1
			teach_energy = 2000
			info_buffs = "Levitation, mobility"
			info_duration = "Toggleable"
			info_point_cost_type = "energy"
			info_name = "levitate"
			hud_x = 404
			hud_y = 636
			act = /obj/skills/Levitation/proc/activate
			info_stats = "Energy Cost: Medium\n\nMastery: Medium\n\nToggleable\n\n+100% movement speed"
			proc
				activate(var/mob/m,var/obj/s)
					if(m.skill_levitation != s) m.skill_levitation = s
					if(s.active)
						m.overlays -= /obj/effects/superfly
						s.active = 0
						m.laymod = 1
						if(m.skill_quicksilver && m.skill_quicksilver.active)
							call(m.skill_quicksilver.act)(m,m.skill_quicksilver)
						m.density_factor = 1
						if(m.shadow) m.shadow.step_size = m.step_size
						if(m.client)
							m.power_sources -= "Levitation"
							m.energy_sources -= "Levitation"
						m.icon_state = m.state()
						s.icon_state = "Levitation off"
						if(m.loc)
							var/turf/t = m.loc
							if(!t.liquid)
								var/obj/effects/dust_medium/d = new
								d.SetCenter(m)
					else if(m.energy>=1)
						if(m.meditating) return
						if(m.skill_flight && m.skill_flight.active) call(m.skill_flight.act)(m,m.skill_flight)
						if(m.submerged)
							m.submerge(0,1,m.loc)
						if(m.client && m.bar_o2) m.client.images -= m.bar_o2
						if(m.loc)
							var/turf/t = m.loc
							if(!t.liquid)
								var/obj/effects/dust_medium/d = new
								d.SetCenter(m)
							else if(t.liquid == "psionic")
								m.submerge(1,1,m.loc)
								if(m.client && m.bar_o2) m.client.images += m.bar_o2
						m.overlays = null
						m.redraw_appearance()
						m.laymod = 1.001
						if(m.skill_quicksilver && m.skill_quicksilver.active)
							call(m.skill_quicksilver.act)(m,m.skill_quicksilver)
						m.density_factor = 0
						s.icon_state = "Levitation"
						s.active = 1
						m.icon_state = m.state()
						//for(var/mob/h in view(8,m))
							//h << sound('fly.mp3',0,0,11,100)
						if(m.shadow) m.shadow.step_size = m.step_size
			New()
				..()
				category = list("Energy","Utility","Buff")
				spawn(10)
					src.info = text_flight
					if(src.disable_sleep) return
					var/mob/m = src.loc
					spawn(10)
						while(src)
							if(ismob(src.loc))
								if(src.active)
									var/e = 5
									if(m.trait_ef) e = 1
									var/removes = (e/m.mod_recovery) + (e/src.skill_lvl)
									if(m.race == "Kai" && m.wings_hidden == 0)
										if(m.z == 2 || m.z == 6) removes = 0
									if(m.energy >= e)
										m.gain_stat("energy",1,10,"Levitation")
										//m.gain_stat("power",1,1,"Levitation")
										m.gain_stat("rating",1,1,"Levitation")
										m.overlays -= /obj/effects/superfly
										m.energy -= removes
										src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)
									else
										m.mouse_dir = "left"
										call(src.act)(m,src)
							sleep(30)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
		Control_Oozaru
			icon_state = "oozaru off"
			info_energy_cost = 1
			info_mastery = 2
			info_point_cost = 1
			teach_energy = 2000
			info_buffs = "Controls the beast within Oozaru."
			info_duration = "Toggleable"
			info_point_cost_type = "energy"
			info_name = "control_oozaru"
			info_prerequisite = list("")
			hud_x = 404
			hud_y = 588
			//arsenal = 1
			//act = /obj/skills/Control_Oozaru/proc/activate
			info_stats = "Energy Cost: Low\n\nMastery: Low\n\nToggleable"

			New()
				..()
				category = list("Energy","Utility","Buff")
				spawn(10)
					src.info = text_flight


					if(src.disable_sleep) return
					var/mob/m = src.loc
					if(m.skill_control_oozaru == null) m.skill_control_oozaru = src
					spawn(30)
						while(src)
							if(ismob(src.loc))
								src.active = 1

								if(m.in_oozaru_rampage)
									src.skill_exp += (10.5-(src.skill_lvl/40)*m.mod_skill)+0.125
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										m.oozaru_mastery = src.skill_lvl
										src.skill_up(m)

							sleep(30)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
		Control_Rampage
			icon_state = "rampage off"
			info_energy_cost = 1
			info_mastery = 2
			info_point_cost = 1
			teach_energy = 2000
			info_buffs = "Controls the beast within your Legendary Super Saiyan rage."
			info_duration = "Toggleable"
			info_point_cost_type = "energy"
			info_name = "control_rampage"
			info_prerequisite = list("")
			hud_x = 404
			hud_y = 588
			//arsenal = 1
			//act = /obj/skills/Control_Oozaru/proc/activate
			info_stats = "Energy Cost: Low\n\nMastery: Low\n\nToggleable"

			New()
				..()
				category = list("Energy","Utility","Buff")
				spawn(10)
					src.info = text_flight


					if(src.disable_sleep) return
					var/mob/m = src.loc
					if(m.skill_control_rampage == null) m.skill_control_rampage = src
					spawn(30)
						while(src)
							if(ismob(src.loc))
								src.active = 1

								if(m.in_lssj_rampage)
									src.skill_exp += (10.5-(src.skill_lvl/40)*m.mod_skill)+0.125
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										m.lssj_mastery = src.skill_lvl
										src.skill_up(m)

							sleep(30)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
					params = params2list(params)
					winset(m,"map.map","focus=true")
		Look_At_Moon
			icon_state = "shieldeyes off"
			info_energy_cost = 1
			info_mastery = 2
			info_point_cost = 1
			teach_energy = 2000
			info_buffs = "Shield Eyes, Stops looking at moon."
			info_duration = "Toggleable"
			info_point_cost_type = "energy"
			info_name = "shield_eyes"
			info_prerequisite = list("")
			hud_x = 404
			hud_y = 588
			//arsenal = 1
			act = /obj/skills/Look_At_Moon/proc/activate
			info_stats = "Energy Cost: Low\n\nMastery: Low\n\nToggleable"
			proc
				activate(var/mob/m,var/obj/s)
					if(m.skill_shieldeyes != s) m.skill_shieldeyes = s
					if(s.active)
						s.active = 0
						m.looking_at_moon = 1
						m.looking_at_flares = 1
						view(10,m)<<output("[m.fullname] un-shields they're eyes.","actionoutput")
						s.icon_state = "shieldeyes off"

					else if(s.active ==0)
						s.active = 1
						m.looking_at_moon = 0
						m.looking_at_flares = 0
						view(10,m)<<output("[m.fullname] shields they're eyes.","actionoutput")
						s.icon_state = "shieldeyes"
			New()
				..()
				category = list("Energy","Utility","Buff")
				spawn(10)
					src.info = text_flight


					if(src.disable_sleep) return
					var/mob/m = src.loc
					spawn(30)
						while(src)
							if(ismob(src.loc))
								if(src.active)
									src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
									if(src.skill_exp >= 100 && src.skill_lvl < 100)
										src.skill_exp = 1
										src.skill_lvl += 1
										src.skill_up(m)

							sleep(30)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
					if(dir == "right")
						if(src in m)
							call(src.act)(m,src)
		Flight
			icon_state = "Flight off"
			info_energy_cost = 1
			info_mastery = 2
			info_point_cost = 1
			teach_energy = 2000
			info_buffs = "Flight, Faster movement"
			info_duration = "Toggleable"
			info_point_cost_type = "energy"
			info_name = "flight"
			info_prerequisite = list("Levitation")
			hud_x = 404
			hud_y = 588

			act = /obj/skills/Flight/proc/activate
			info_stats = "Energy Cost: Medium\n\nMastery: Medium\n\nToggleable"
			proc
				activate(var/mob/m,var/obj/s)
					if(m.skill_flight != s) m.skill_flight = s
					if(s.active)
						m.overlays -= /obj/effects/superfly
						//m.buffs -= "flying"
						s.active = 0
						m.laymod = 1
						if(m.skill_quicksilver && m.skill_quicksilver.active)
							call(m.skill_quicksilver.act)(m,m.skill_quicksilver)
						//m.step_size = 5
						m.density_factor = 1
						if(m.shadow) m.shadow.step_size = m.step_size
						if(m.client)
							m.power_sources -= "Flight"
							m.energy_sources -= "Flight"
						m.icon_state = m.state()
						s.icon_state = "Flight off"
						if(m.loc)
							var/turf/t = m.loc
							if(!t.liquid)
								var/obj/effects/dust_medium/d = new
								d.SetCenter(m)
					else if(m.energy>=1)
						if(m.meditating || m.selftraining) return
						if(m.skill_levitation && m.skill_levitation.active) call(m.skill_levitation.act)(m,m.skill_levitation)
						if(m.submerged)
							m.submerge(0,1,m.loc)
						if(m.client && m.bar_o2) m.client.images -= m.bar_o2
						if(m.loc)
							var/turf/t = m.loc
							if(!t.liquid)
								var/obj/effects/dust_medium/d = new
								d.SetCenter(m)
							else if(t.liquid == "psionic")
								m.submerge(1,1,m.loc)
								if(m.client && m.bar_o2) m.client.images += m.bar_o2
						m.overlays -= /obj/effects/swim
						m.laymod = 1.001
						if(m.skill_quicksilver && m.skill_quicksilver.active)
							call(m.skill_quicksilver.act)(m,m.skill_quicksilver)
						//m.step_size = 10
						//if(m.super_fly) m.step_size = 16
						m.density_factor = 0
						s.icon_state = "Flight"
						s.active = 1
						m.icon_state = m.state()
						//for(var/mob/h in view(8,m))
							//h << sound('fly.mp3',0,0,11,100)
						if(m.shadow) m.shadow.step_size = m.step_size
			New()
				..()
				category = list("Energy","Utility","Buff")
				spawn(10)
					src.info = text_flight


					if(src.disable_sleep) return
					var/mob/m = src.loc
					spawn(30)
						while(src)
							if(ismob(src.loc))
								if(src.active)
									//if(m.submerged)
										//m.mouse_dir = "left"
										//call(src.act)(m,src)
									var/e = 10
									if(m.trait_ef) e = 1
									var/removes = (e/m.mod_recovery) + (e/src.skill_lvl)
									if(m.race == "Kai" && m.wings_hidden == 0)
										if(m.z == 2 || m.z == 6) removes = 0
									if(m.energy >= e)
										//m.gain_stat("energy",1,0.1,"Flight")
										//m.gain_stat("power",1,1,"Flight")
										m.overlays -= /obj/effects/superfly
										//m.overlays += /obj/effects/superfly
										if(m.super_fly)
											m.energy -= (removes*3)
											//world << "[removes] energy removed by [src]"
											//m << output("<font color = teal>[removes] energy removed by [src]","chat.system")
										else
											if(m.trait_ef == null)
												//m.energy -= 1+((m.energy_max*0.25)/src.skill_lvl/m.mod_energy)
												m.energy -= removes*3
												//world << "[removes] energy removed by [src]"
												//m << output("<font color = teal>[removes] energy removed by [src]","chat.system")
										//src.skill_exp += (10/src.skill_lvl)*m.mod_skill
										//src.skill_exp += ((5-(src.skill_lvl/20))*m.mod_skill)+0.5
										src.skill_exp += (2.5-(src.skill_lvl/40)*m.mod_skill)+0.025
										if(src.skill_exp >= 100 && src.skill_lvl < 100)
											src.skill_exp = 1
											src.skill_lvl += 1
											src.skill_up(m)
									else
										m.mouse_dir = "left"
										call(src.act)(m,src)
							sleep(30)
			Click(location,control,params)
				..()
				if(ismob(src.loc))
					var/mob/m = src.loc
					if(m.koed) return
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
					if(dir == "right")
						if(m.super_fly)
							m.super_fly = 0
							m << "Super flight deactivated"
							//if(src.active)
								//m.step_size = 10
								///if(m.shadow) m.shadow.step_size = 10
						else
							m.super_fly = 1
							m << "Super flight active"
							if(src.active)
								//m.step_size = 16
								//if(m.shadow) m.shadow.step_size = 16
								var/obj/effects/hit/h = new
								h.loc = m.loc
								h.dir = m.dir
								if(m.dir == SOUTH ||m.dir == NORTH) h.pixel_x += 16
								h.step_x = m.step_x
								h.step_y = m.step_y
								spawn(10)
									if(h) h.destroy()
	proc
		dismiss_alert(var/mob/c)
			var/obj/effects/over_displays/lvl_up_overlay/o = src
			for(var/obj/effects/over_displays/lvl_up_overlay/L in c.client.screen)
				if(L != o && L.skill_y > o.skill_y)
					animate(L)
					var matrix2 = matrix().Translate(0,L.skill_y-36)
					animate(L,transform = matrix2, time = 1)
					L.skill_y -= 36
					if(L.skill_y <= -464)
						L.skill_shift(c)
			c.client.screen -= o
			o.filters = null
			o.icon = null
			o.can_click = 0
			o.help_text = null
			o.name = initial(o.name)
			o.skill_y = -464
			var/matrix = matrix().Translate(0,0)
			o.transform = matrix
			animate(o)
			o.reset_use()
			/*
			spawn(100)
				if(o) o.in_use = 0
			*/
		skill_shift(var/mob/c)
			var/obj/effects/over_displays/lvl_up_overlay/o = src
			spawn(20)
				if(c && o && o.in_use)
					animate(o,alpha = 0, time = 10)
					spawn(10)
						if(c && o && o.in_use && o.icon && c.client)
							for(var/obj/effects/over_displays/lvl_up_overlay/L in c.client.screen)
								if(L != o)
									var matrix2 = matrix().Translate(0,L.skill_y-36)
									animate(L,transform = matrix2, time = 1)
									L.skill_y -= 36
									if(L.skill_y <= -464)
										L.skill_shift(c)
							c.client.screen -= o
							//o.in_use = 0
							o.icon = null
							o.can_click = 0
							o.filters = null
							o.help_text = null
							o.name = initial(o.name)
							o.skill_y = -464
							var/matrix = matrix().Translate(0,0)
							o.transform = matrix
							animate(o)
							o.reset_use()
		skill_up(var/mob/c)
			if(c && c.client)
				var/obj/effects/over_displays/lvl_up_overlay/o
				for(var/obj/effects/over_displays/lvl_up_overlay/x in lvl_overlays)
					if(x.in_use == 0)
						x.in_use = 1
						o = x
						break
				if(src && o)
					if(src.icon)
						o.icon = src.icon
						o.icon_state = src.icon_state
						o.alpha = 255

					var/lvl
					var/tech = 0
					var/tutorial = 0
					var/alert = 0

					if(istype(src,/obj/skills/)) lvl = src.skill_lvl
					else if(istype(src,/obj/body_related/)) lvl = src.level
					else if(istype(src,/obj/items/tech/sub_tech)) tech = 1
					else if(istype(src,/obj/help_topics/Alert_Misc)) alert = 1
					else if(istype(src,/obj/help_topics/)) tutorial = 1

					if(tutorial)
					//	o.icon = 'question_mark.dmi'
						o.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:right'>[src.name]</span>"
						c.save_alert_history("[src] ")
						//o.help_text = src.help_text//"[src.name] - [src.info]"
					//	o.name = src.name
					//	o.can_click = 1
						//c.create_chat_entry("alerts","[o.name] - [o.help_text]")
					else if(tech)
						o.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:right'>[src] research finished</span>"
						c.save_alert_history("[src] research finished")
					else if(alert)
						o.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:right'>[src]</span>"
						c.save_alert_history("[src]")
					else if(tech == 0)
						o.maptext = "<span style='-dm-text-outline: 1px #000000;text-align:right'>[src] leveled up to [lvl]</span>"
						c.save_alert_history("[src] leveled up to [lvl]")

					var/huds = 0
					//var/times = 10
					var/times = 5
					for(var/obj/effects/over_displays/lvl_up_overlay/L in c.client.screen)
						if(L != o)
							huds += 1
							//times -= 1
							times += 1
					o.skill_y = -464+(huds*36)
					var/matrix = matrix().Translate(0,-464+(huds*36))
					animate(o,transform = matrix, time = times)
					c.client.screen += o
					if(c && c.HUD)
						c.HUD.Rescale_HUD(c)
					if(o.skill_y <= -464) //If its the bottom alert, make it fade over time. Also moves any others above it down a spot.
						spawn(20)
							if(src && c && o) o.skill_shift(c)
		reset_use()
			spawn(100)
				if(src)
					var/obj/effects/over_displays/lvl_up_overlay/o = src
					o.in_use = 0

mob/proc/check_skillbar(obj/o)
    if(!o) return

    // Loop BOTH bars so skills are unique across bars
    for(var/bar_id in skillbar_slots)
        var/list/bar = skillbar_slots[bar_id]
        if(!bar) continue

        for(var/slot_name in bar)
            var/list/L = bar[slot_name]
            if(!L || !L.len) continue

            if(L[1] == o)
                L.Cut()  // clear contents but keep the list reference

                if(client)
                    client.screen -= o


/*mob
	proc
		check_skillbar(var/obj/o)
			//Reset a slot if it already belonged to one
			if(src.one && length(src.one) > 0 && o == src.one[1])
				src.one = null
				if(src.client) src.client.screen -= o
			if(src.two && length(src.two) > 0 && o == src.two[1])
				src.two = null
				src.two.Cut()

				if(src.client) src.client.screen -= o
			if(src.three && length(src.three) > 0 && o == src.three[1])
				src.three = null
				if(src.client) src.client.screen -= o
			if(src.four && length(src.four) > 0 && o == src.four[1])
				src.four = null
				if(src.client) src.client.screen -= o
			if(src.five && length(src.five) > 0 && o == src.five[1])
				src.five = null
				if(src.client) src.client.screen -= o
			if(src.six && length(src.six) > 0 && o == src.six[1])
				src.six = null
				if(src.client) src.client.screen -= o
			if(src.seven && length(src.seven) > 0 && o == src.seven[1])
				src.seven = null
				if(src.client) src.client.screen -= o
			if(src.eight && length(src.eight) > 0 && o == src.eight[1])
				src.eight = null
				if(src.client) src.client.screen -= o
			if(src.nine && length(src.nine) > 0 && o == src.nine[1])
				src.nine = null
				if(src.client) src.client.screen -= o
			if(src.zero && length(src.zero) > 0 && o == src.zero[1])
				src.zero = null
				if(src.client) src.client.screen -= o

				*/
mob
	proc
		skillbar()
			if(!src || !src.client) return

    clear_skillbar_screen()
			clear_skillbar_screen() // Ensures stale icons are removed
			var/list/bar = skillbar_slots[active_skillbar]
			//var/bar = skillbar_slots[active_skillbar]
			if(!bar) return
			for(var/obj/hud/h in src.hud_skillbar)
				var/obj/skill

				if(istype(h,/obj/hud/buttons/skillbar/skillbar_one))
					skill = bar["one"] ? bar["one"][1] : null
					h.overlays = null
					if(skill)
						h.overlays += /obj/hud/buttons/skillbar/skillbar_one_overlay
						client.screen += skill

				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_two))
					skill = bar["two"] ? bar["two"][1] : null
					h.overlays = null
					if(skill)
						h.overlays += /obj/hud/buttons/skillbar/skillbar_two_overlay
						client.screen += skill

				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_three))
					skill = bar["three"] ? bar["three"][1] : null
					h.overlays = null
					if(skill)
						h.overlays += /obj/hud/buttons/skillbar/skillbar_three_overlay
						client.screen += skill

				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_four))
					skill = bar["four"] ? bar["four"][1] : null
					h.overlays = null
					if(skill)
						h.overlays += /obj/hud/buttons/skillbar/skillbar_four_overlay
						client.screen += skill

				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_five))
					skill = bar["five"] ? bar["five"][1] : null
					h.overlays = null
					if(skill)
						h.overlays += /obj/hud/buttons/skillbar/skillbar_five_overlay
						client.screen += skill

				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_six))
					skill = bar["six"] ? bar["six"][1] : null
					h.overlays = null
					if(skill)
						h.overlays += /obj/hud/buttons/skillbar/skillbar_six_overlay
						client.screen += skill

				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_seven))
					skill = bar["seven"] ? bar["seven"][1] : null
					h.overlays = null
					if(skill)
						h.overlays += /obj/hud/buttons/skillbar/skillbar_seven_overlay
						client.screen += skill

				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_eight))
					skill = bar["eight"] ? bar["eight"][1] : null
					h.overlays = null
					if(skill)
						h.overlays += /obj/hud/buttons/skillbar/skillbar_eight_overlay
						client.screen += skill

				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_nine))
					skill = bar["nine"] ? bar["nine"][1] : null
					h.overlays = null
					if(skill)
						h.overlays += /obj/hud/buttons/skillbar/skillbar_nine_overlay
						client.screen += skill

				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_zero))
					skill = bar["zero"] ? bar["zero"][1] : null
					h.overlays = null
					if(skill)
						h.overlays += /obj/hud/buttons/skillbar/skillbar_zero_overlay
						client.screen += skill


		/*skillbar()
			var/bar = skillbar_slots[active_skillbar]

			for(var/obj/hud/h in src.hud_skillbar)
				var/obj/s = null
				var/obj/skill
				if(istype(h,/obj/hud/buttons/skillbar/skillbar_one))
					skill = bar["one"]
					if(skill)
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_one_overlay
						client.screen += skill
					if(src.one && length(src.one) > 0)
						s = src.one[1]
				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_two))
					skill = bar["two"]
					if(skill)
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_two_overlay
						client.screen += skill
					if(src.two && length(src.two) > 0)
						s = src.two[1]
				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_three))
					skill = bar["three"]
					if(skill)
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_three_overlay
						client.screen += skill
					if(src.three && length(src.three) > 0)
						s = src.three[1]
				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_four))
					skill = bar["four"]
					if(skill)
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_four_overlay
						client.screen += skill
					if(src.four && length(src.four) > 0)
						s = src.four[1]
				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_five))
					skill = bar["five"]
					if(skill)
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_five_overlay
						client.screen += skill
					if(src.five && length(src.five) > 0)
						s = src.five[1]
				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_six))
					skill = bar["six"]
					if(skill)
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_six_overlay
						client.screen += skill
					if(src.six && length(src.six) > 0)
						s = src.six[1]
				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_seven))
					skill = bar["seven"]
					if(skill)
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_seven_overlay
						client.screen += skill
					if(src.seven && length(src.seven) > 0)
						s = src.seven[1]
				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_eight))
					skill = bar["eight"]
					if(skill)
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_eight_overlay
						client.screen += skill
					if(src.eight && length(src.eight) > 0)
						s = src.eight[1]
				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_nine))
					skill = bar["nine"]
					if(skill)
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_nine_overlay
						client.screen += skill
					if(src.nine && length(src.nine) > 0)
						s = src.nine[1]
				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_zero))
					skill = bar["zero"]
					if(skill)
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_zero_overlay
						client.screen += skill
					if(src.zero && length(src.zero) > 0)
						s = src.zero[1]


						*/
			/*for(var/obj/hud/h in src.hud_skillbar)
				var/obj/s = null
				if(istype(h,/obj/hud/buttons/skillbar/skillbar_one))
					if(src.one && length(src.one) > 0)
						s = src.one[1]
						//s.screen_loc = "10:-13,1:4"
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_one_overlay
						src.client.screen += s

				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_two))
					if(src.two && length(src.two) > 0)
						s = src.two[1]
						//s.screen_loc = "11:-12,1:4"
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_two_overlay
						src.client.screen += s

				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_three))
					if(src.three && length(src.three) > 0)
						s = src.three[1]
						//s.screen_loc = "12:-11,1:4"
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_three_overlay
						src.client.screen += s

				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_four))
					if(src.four && length(src.four) > 0)
						s = src.four[1]
						//s.screen_loc = "13:-10,1:4"
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_four_overlay
						src.client.screen += s

				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_five))
					if(src.five && length(src.five) > 0)
						s = src.five[1]
						//s.screen_loc = "14:-9,1:4"
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_five_overlay
						src.client.screen += s

				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_six))
					if(src.six && length(src.six) > 0)
						s = src.six[1]
						//s.screen_loc = "15:-8,1:4"
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_six_overlay
						src.client.screen += s

				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_seven))
					if(src.seven && length(src.seven) > 0)
						s = src.seven[1]
						//s.screen_loc = "16:-7,1:4"
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_seven_overlay
						src.client.screen += s

				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_eight))
					if(src.eight && length(src.eight) > 0)
						s = src.eight[1]
						//s.screen_loc = "17:-6,1:4"
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_eight_overlay
						src.client.screen += s

				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_nine))
					if(src.nine && length(src.nine) > 0)
						s = src.nine[1]
						//s.screen_loc = "18:-5,1:4"
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_nine_overlay
						src.client.screen += s

				else if(istype(h,/obj/hud/buttons/skillbar/skillbar_zero))
					if(src.zero && length(src.zero) > 0)
						s = src.zero[1]
						//s.screen_loc = "19:-4,1:4"
						h.overlays = null
						h.overlays += /obj/hud/buttons/skillbar/skillbar_zero_overlay
						src.client.screen += s
					*/
		follower_go_dblclick(var/turf/t)
			if(src.target_follower)
				if(ismob(src.target_follower))
					var/mob/NPC/m = src.target_follower
					if(m.owner == src.real_name)
						m.idle_ticks = 0
						m.disable_skills()
						src.left_click_ref = m
						m.idle_ticks = 0
						m.function = "go"
						m.target_go = t
						m.icon_state = m.state()
						if(m.activated == 0)
							m.activated = 1
							m.follower_ai()
		dimiss_all_alerts()
			if(src.client)
				for(var/obj/effects/over_displays/lvl_up_overlay/o in src.client.screen)
					if(src.client) src.client.screen -= o
					//o.in_use = 0
					o.icon = null
					o.can_click = 0
					o.filters = null
					o.help_text = null
					o.name = initial(o.name)
					o.skill_y = -464
					var/matrix = matrix().Translate(0,0)
					o.transform = matrix
					animate(o)
					o.reset_use()
		increase_passive(var/p)
			if(src.typing) return
			var/obj/x

			if(src.skill_selected && src.skill_selected.stance_skill) x = src.skill_selected

			else if(src.skill_selected && src.skill_selected.passive_skill) x = src.skill_selected
			else
				for(var/obj/skills/s in learnable_skills)
					if(s.info_name == p)
						x = s
						break
				for(var/obj/traits/s in learnable_traits)
					if(s.info_name == p)
						x = s
						break
				for(var/obj/stances/st in learnable_stances)
					if(st.info_name == p)
						x = st
						break
			var/needed = 0
			var/found = 0
			var/howmuch

			if(x.stance_skill)
				howmuch=input("How much stance points are you increasing this by?") as num
			else if(x.passive_skill)
				howmuch=input("How much passive points are you increasing this by?") as num
			if(x.stance_skill && src.stance_points<howmuch)
				src.set_alert("Not enough stance points",'alert.dmi',"alert")

				return
			else if(x.passive_skill && src.passive_points<howmuch)
				src.set_alert("Not enough passive points",'alert.dmi',"alert")

				return
			if(howmuch<=0) return
			if(howmuch<=-0) return
			if(x)
				if(x.stance_skill)
					if(x.skill_lvl>=x.max_level)
						src.set_alert("[p] is at it's max level!",'alert.dmi',"alert")

						return

					if(x.info_prerequisite && x.info_prerequisite.len > 0)
						needed = x.info_prerequisite.len
						for(var/obj/s in src)
							for(var/n in x.info_prerequisite)
								if(s.name == n)
									found += 1
					else
						found = 1
						needed = 1
					if(found >= needed)
						var/point_type = x.info_point_cost_type
						switch(point_type)
							if("combat")
								if(src.stance_points >= x.info_point_cost)
									src.stance_points -= howmuch
								else
									src.set_alert("Not enough stance points",'alert.dmi',"alert")
									return



						//for(x in src)
						//	if(x.name == x.name)
							//	x.skill_lvl+=howmuch
							//	src.set_alert("[x] increased by [howmuch]+",x.icon,x.icon_state)
							//	src<<"First test"
							//	return
						var/obj/z = new x.type
						if(locate(x) in src)
							if(!x.info_name) x.info_name = p
							src.set_alert("[x] increased by [howmuch]+",x.icon,x.icon_state)
							z.skill_lvl +=howmuch
							if(z.act) call(z,z.act)(src,howmuch)
							if(src.hud_unlocks) src.hud_unlocks.switch_tab(1,src)
							return
						else
							z.Move(src)
							if(!x.info_name) x.info_name = p
							src.set_alert("[x] increased by [howmuch]+",x.icon,x.icon_state)
							z.skill_lvl+=howmuch

							if(z.act) call(z,z.act)(src,howmuch)
							if(src.hud_unlocks) src.hud_unlocks.switch_tab(1,src)
							return
				else if(x.passive_skill)
					if(x.skill_lvl>=x.max_level)
						src.set_alert("[p] is at it's max level!",'alert.dmi',"alert")

						return

					if(x.info_prerequisite && x.info_prerequisite.len > 0)
						needed = x.info_prerequisite.len
						for(var/obj/s in src)
							for(var/n in x.info_prerequisite)
								if(s.name == n)
									found += 1
					else
						found = 1
						needed = 1
					if(found >= needed)
						var/point_type = x.info_point_cost_type
						switch(point_type)
							if("physical")
								if(src.passive_points >= x.info_point_cost)
									src.passive_points -= howmuch
								else
									src.set_alert("Not enough passive points",'alert.dmi',"alert")
									return
							if("technology")
								if(src.passive_points >= x.info_point_cost)
									src.passive_points -= howmuch
								else
									src.set_alert("Not enough passive points",'alert.dmi',"alert")
									return
							if("combat")
								if(src.stance_points >= x.info_point_cost)
									src.stance_points -= howmuch
								else
									src.set_alert("Not enough stance points",'alert.dmi',"alert")
									return



						//for(x in src)
						//	if(x.name == x.name)
							//	x.skill_lvl+=howmuch
							//	src.set_alert("[x] increased by [howmuch]+",x.icon,x.icon_state)
							//	src<<"First test"
							//	return
						var/obj/z = locate(x.type) in src

						//if(z)
						//	z.skill_lvl += howmuch
						/*else
							z = new x.type
							z.skill_lvl = howmuch
							z.Move(src)*/

					//	var/obj/z = new x.type
						//if(locate(x.type) in src)
						if(z)
							if(!x.info_name) x.info_name = p
							src.set_alert("[x] increased by [howmuch]+",x.icon,x.icon_state)
							z.skill_lvl +=howmuch
							if(z.act) call(z,z.act)(src,howmuch)
							if(src.hud_unlocks) src.hud_unlocks.switch_tab(1,src)
							return
						else
							z = new x.type
							z.Move(src)
							if(!x.info_name) x.info_name = p
							src.set_alert("[x] increased by [howmuch]+",x.icon,x.icon_state)
							z.skill_lvl=howmuch

							if(z.act) call(z,z.act)(src,howmuch)
							if(src.hud_unlocks) src.hud_unlocks.switch_tab(1,src)
							return

				else
					src.output_msg("Unable to unlock [p], prerequisites not met.")
					src.set_alert("Prerequisites not met",'alert.dmi',"alert")
					return
		give_skill(var/p)
			if(src.typing) return
			var/obj/x
			if(src.skill_selected && src.skill_selected.loc == null) x = src.skill_selected
			else
				for(var/obj/skills/s in learnable_skills)
					if(s.name == p)
						x = s
						break
				for(var/obj/traits/s in learnable_traits)
					if(s.name == p)
						x = s
						break
				for(var/obj/stances/st in learnable_stances)
					if(st.name == p)
						x = st
						break
			var/needed = 0
			var/found = 0
			if(x)
				for(var/obj/s in src)
					if(s.type == x.type)
						src.set_alert("Already have [p]",'alert.dmi',"alert")
						src.create_chat_entry("alerts","Already have [p].")
						return
				if(x.info_prerequisite && x.info_prerequisite.len > 0)
					needed = x.info_prerequisite.len
					for(var/obj/s in src)
						for(var/n in x.info_prerequisite)
							if(s.name == n)
								found += 1
				else
					found = 1
					needed = 1
				if(found >= needed)
					var/point_type = x.info_point_cost_type
					switch(point_type)
						if("energy")
							if(src.skill_points_energy >= x.info_point_cost)
								src.skill_points_energy -= x.info_point_cost
							else
								src.set_alert("Not enough Energy points",'alert.dmi',"alert")
								src.create_chat_entry("alerts","Not enough Energy points.")
								return
						if("agility")
							if(src.skill_points_agility >= x.info_point_cost)
								src.skill_points_agility -= x.info_point_cost
							else
								src.set_alert("Not enough Agility points",'alert.dmi',"alert")
								src.create_chat_entry("alerts","Not enough Agility points.")
								return
						if("power")
							if(src.skill_points_power >= x.info_point_cost)
								src.skill_points_power -= x.info_point_cost
							else
								src.set_alert("Not enough Power points",'alert.dmi',"alert")
								src.create_chat_entry("alerts","Not enough Power points.")
								return
						if("strength")
							if(src.skill_points_strength >= x.info_point_cost)
								src.skill_points_strength -= x.info_point_cost
							else
								src.set_alert("Not enough Strength points",'alert.dmi',"alert")
								src.create_chat_entry("alerts","Not enough Strength points.")
								return
						if("recovery")
							if(src.skill_points_recovery >= x.info_point_cost)
								src.skill_points_recovery -= x.info_point_cost
							else
								src.set_alert("Not enough Recovery points",'alert.dmi',"alert")
								src.create_chat_entry("alerts","Not enough Recovery points.")
								return
						if("regen")
							if(src.skill_points_regen >= x.info_point_cost)
								src.skill_points_regen -= x.info_point_cost
							else
								src.set_alert("Not enough Regeneration points",'alert.dmi',"alert")
								src.create_chat_entry("alerts","Not enough Regeneration points.")
								return
						if("resistance")
							if(src.skill_points_resistance >= x.info_point_cost)
								src.skill_points_resistance -= x.info_point_cost
							else
								src.set_alert("Not enough Resistance points",'alert.dmi',"alert")
								src.create_chat_entry("alerts","Not enough Resistance points.")
								return
						if("force")
							if(src.skill_points_force >= x.info_point_cost)
								src.skill_points_force -= x.info_point_cost
							else
								src.set_alert("Not enough Force points",'alert.dmi',"alert")
								src.create_chat_entry("alerts","Not enough Force points.")
								return
						if("combat")
							if(src.skill_points_combat >= x.info_point_cost)
								src.skill_points_combat -= x.info_point_cost
							else
								src.set_alert("Not enough Combat points",'alert.dmi',"alert")
								src.create_chat_entry("alerts","Not enough Combat points.")
								return
						if("endurance")
							if(src.skill_points_endurance >= x.info_point_cost)
								src.skill_points_endurance -= x.info_point_cost
							else
								src.set_alert("Not enough Endurance points",'alert.dmi',"alert")
								src.create_chat_entry("alerts","Not enough Endurance points.")
								return
						if("offence")
							if(src.skill_points_offence >= x.info_point_cost)
								src.skill_points_offence -= x.info_point_cost
							else
								src.set_alert("Not enough Offence points",'alert.dmi',"alert")
								src.create_chat_entry("alerts","Not enough Offence points.")
								return
						if("defence")
							if(src.skill_points_defence >= x.info_point_cost)
								src.skill_points_defence -= x.info_point_cost
							else
								src.set_alert("Not enough Defence points",'alert.dmi',"alert")
								src.create_chat_entry("alerts","Not enough Defence points.")
								return

					var/obj/n = new x.type(src)
					if(n.trait && n.act) call(n.act)(src,n)
					if(!x.info_name) x.info_name = p
					src.set_alert("[n] unlocked successfully",n.icon,n.icon_state)
					//src.create_chat_entry("alerts","[n] unlocked successfully")
					//src.check_quest("tutorial_unlock_skill",1)
					if(x.img_select) src.client.images += x.img_select
					if(src.origin && src.origin.type == /obj/origins/skilled)
						n.skill_lvl += 24
						src.set_alert("[n] leveled up to [n.skill_lvl]",n.icon,n.icon_state)
					//	src.create_chat_entry("alerts","[n] leveled up to [n.skill_lvl]")
				else
					src.output_msg("Unable to unlock [p], prerequisites not met.")
					src.set_alert("Prerequisites not met",'alert.dmi',"alert")
					return
		taught_skill(var/mob/teacher,var/obj/skills/s)
			//Make a check to confirm if they have skill already
			var/obj/bar = new /:revive_bar
			var/obj/bar_inner = new /:revive_bar_inner
			var/progress = 0
			src.icon_state = "Meditate"
			teacher.icon_state = "Meditate"
			src.client.screen += bar
			teacher.client.screen += bar
			src.stunned += 1
			src.stunned_pending += 1
			teacher.stunned += 1
			teacher.stunned_pending += 1
			while(progress < 100)
				progress += 1
				if(src && teacher)
					if(get_dist(src,teacher) <= 8)
						src.client.screen -= bar_inner
						bar_inner.screen_loc  = "10:[round(progress/2)-2],9:-6"
						var/matrix/M = matrix()
						M.Scale(round(progress),1)
						bar_inner.transform = M
						src.client.screen += bar_inner

						teacher.client.screen -= bar_inner
						teacher.client.screen += bar_inner

						progress += 1
					else progress = 100
				else progress = 100
				sleep(1)
			if(src)
				src.client.screen -= bar
				src.client.screen -= bar_inner
				src.stunned -= 1
				src.stunned_pending -= 1
				src.icon_state = ""
				teacher.icon_state = ""
				if(s)
					var/obj/skills/sk = new s.type(src)
					if(istype(s,/obj/skills/Flight)||istype(s,/obj/skills/Blast)||istype(s,/obj/skills/Charge)||istype(s,/obj/skills/Stunning_Blow))
						sk.teach_cd = 0
					else
						sk.teach_cd = year+1
			if(teacher)
				teacher.client.screen -= bar
				teacher.client.screen -= bar_inner
				teacher.stunned -= 1
				teacher.stunned_pending -= 1
				if(s && !teacher.key == "VOXTECH") s.teach_cd = year+1

		reset_alerts() //For when player logs out, grab all their alerts in their screen and reset them, otherwise the alerts will be in perma-limbo.
			if(src.client)
				var/mob/c = src
				for(var/obj/effects/over_displays/lvl_up_overlay/o in c.client.screen)
					if(c.client) c.client.screen -= o
					o.filters = null
					o.icon = null
					o.can_click = 0
					o.help_text = null
					o.name = initial(o.name)
					o.skill_y = -464
					var matrix = matrix().Translate(0,0)
					o.transform = matrix
					animate(o)
					o.reset_use() //Sent to the obj, rather than player, because the player is about to be deleted. Has a spawn(100) in it.
		dimiss_follower(var/mob/owner)
			src.function = null
			src.disable_skills()
			src.letgo()
			src.shockwave()
			src.icon +=rgb(125,125,125)
			animate(src,alpha = 0, time = 7)
			spawn(7)
				if(owner && src)
					if(owner.skill_psi_clone)
						if(src in owner.skill_psi_clone.active_splits)
							owner.skill_psi_clone.active_splits -= src
					if(owner.skill_divine_weapon)
						if(src in owner.skill_divine_weapon.active_splits)
							owner.skill_divine_weapon.active_splits -= src
					src.dismissed = 1
					src.destroy()
		skill_cooldown(var/obj/skills/s)
			spawn(1)
				if(src && s && s.cd_state <= 32 && s.loc == src && src.client)

					if(s.clone) src.skill_cooldown(s.clone)
					s.vis_contents = null
					if(s.cd_bar == null)
						var/obj/cd_shell = new
						cd_shell.plane = s.plane
						cd_shell.layer = s.layer+1
						cd_shell.icon = 'skills_cd.dmi'
						cd_shell.mouse_opacity = 0
						s.cd_bar = cd_shell

					s.vis_contents += s.cd_bar
					while(s.cd_state > 0)
						s.cd_state -= 1
						s.cd_bar.icon_state = "[s.cd_state]"
						sleep(s.cd_max/32)
					s.cd_state = 32
					animate(s, color = list("#000", "#000", "#000", "#fff"),time = 3)
					animate(color = initial(s.color),time = 3)
					if(src && src.client) s.vis_contents -= s.cd_bar
	proc
		//Follower commands
		follower_give_proc()
			var/mob/NPC/m = src.target_follower
			if(m.owner == src.real_name)
				if(m.divine_weapon == 0)
					if(get_dist(src,m) <= 2)
						return
						winshow(src,"inven",1)
						src.refresh_inv()
						src.open_inven = 1
						src.left_click_function = "clone give"
						src.client.mouse_pointer_icon = 'mouse_left_interact.dmi'
						src.left_click_ref = m
						src.open_menus.Add(".open_inven")
						src << output("Click an item to give [m]","chat.world")
		follower_inv_proc()
			var/mob/NPC/m = src.target_follower
			if(m.owner == src.real_name)
				if(m.divine_weapon == 0)
					if(get_dist(src,m) <= 2)
						//winshow(src,"inven",1)
						src.accessing = m
						src.refresh_inv()
						src.client.screen += src.hud_inv
						src.open_inven = 1
						src.open_menus.Add(".open_inven")
		follower_stop_proc()
			var/mob/NPC/m = src.target_follower
			if(m.owner == src.real_name)
				//if(src.skill_psi_clone)
				m.function = null
				m.target = null
				m.target_follow = null
				m.target_go = null
				m.disable_skills()
				m.letgo()
				if(m.divine_weapon) m.divine_weapon_reset()
		follower_grab_proc(var/atom/tar = null)
			var/mob/NPC/m = src.target_follower
			if(m.owner == src.real_name)
				if(m.divine_weapon == 0)
					m.idle_ticks = 0
					//m.function = "grab"
					m.disable_skills()
					if(tar == null)
						src.left_click_function = "clone grab"
						src.left_click_ref = m
						src << output("Click a target for [m] to grab.","chat.world")
						src << output("Click a target for [m] to grab.","chat.local")
						src.client.mouse_pointer_icon = 'mouse_left_interact.dmi'
						winshow(src,"contacts",0)
						src.open_contacts = 0
						src.open_menus.Remove(".open_contacts")
					else
						m.idle_ticks = 0
						m.function = "grab"
						m.target_go = tar
						m.icon_state = m.state()
					if(m.activated == 0)
						m.activated = 1
						m.follower_ai()
		follower_go_proc()
			var/mob/NPC/m = src.target_follower
			if(m.owner == src.real_name)
				m.idle_ticks = 0
				//m.function = "go"
				m.disable_skills()
				src.left_click_function = "clone go"
				src.left_click_ref = m
				src << output("Click a location for [m] to travel to.","chat.world")
				src << output("Click a location for [m] to travel to.","chat.local")
				src.client.mouse_pointer_icon = 'mouse_left_interact.dmi'
				winshow(src,"contacts",0)
				src.open_contacts = 0
				src.open_menus.Remove(".open_contacts")
				if(m.activated == 0)
					m.activated = 1
					m.follower_ai()
		follower_attack_proc(var/mob/tar = null)
			var/mob/NPC/m = src.target_follower
			if(m.owner == src.real_name)
				m.idle_ticks = 0
				//m.function = "attack"
				m.disable_skills()
				if(m.skill_super_speed) m.skill_super_speed.active = 1
				m.letgo()
				if(tar == null)
					src.left_click_function = "clone attack"
					src.left_click_ref = m
					src << output("Click a target for the attack.","chat.world")
					src << output("Click a target for the attack.","chat.local")
					src.client.mouse_pointer_icon = 'mouse_left_interact.dmi'
					winshow(src,"contacts",0)
					src.open_contacts = 0
					src.open_menus.Remove(".open_contacts")
				else
					m.idle_ticks = 0
					m.function = "attack"
					m.target = tar
					m.target_follow = tar
					m.icon_state = m.state()
				if(m.activated == 0)
					m.activated = 1
					m.follower_ai()
		follower_follow_proc(var/mob/tar = null)
			var/mob/NPC/m = src.target_follower
			if(m.owner == src.real_name)
				//if(src.skill_psi_clone)
				m.idle_ticks = 0
				//m.function = "follow"
				m.disable_skills()
				if(tar == null)
					src.left_click_function = "clone follow"
					src.left_click_ref = m
					src << output("Click a target for [m] to follow.","chat.world")
					src << output("Click a target for [m] to follow.","chat.local")
					src.client.mouse_pointer_icon = 'mouse_left_interact.dmi'
					winshow(src,"contacts",0)
					src.open_contacts = 0
					src.open_menus.Remove(".open_contacts")
				else
					m.idle_ticks = 0
					m.function = "follow"
					m.target = null
					m.target_follow = tar
					m.icon_state = m.state()
				if(m.activated == 0)
					m.activated = 1
					m.follower_ai()
		follower_dismiss_proc()
			var/mob/NPC/m = src.target_follower
			if(m.owner == src.real_name)
				if(m.target_img && src.client) src.client.images -= m.target_img
				for(var/mob/p in players)
					if(m == p.target)
						if(p.client) p.client.screen -= m
						p.add_remove_target(m,1)
				src.target_follower = null
				m.dimiss_follower(src)
		admin_view_proc(var/icon/seticon)
			if(src.client.admin_mode == 0 )
				if(src.projection == null)
				//	for(var/obj/skills/Meditate/med in usr)
					//	if(med.active == 0) call(med.act)(usr,med)
					var/mob/p = new
					switch(src.client.admin_icon_type)
						if("Feline Humanoid")   p.icon = 'Cat_Male_Adult_fix.dmi'
						if("Canine Humanoid")   p.icon = 'Dog_Base.dmi'
						if("Floating Cat")      p.icon = 'Floating_Cat_Base_Gray.dmi'
						if("Default")           p.icon = seticon

					p.icon += rgb(155,155,155)
					p.loc = locate(158,240,13)
					p.density_factor=0
					p.density=0
					p.icon_state = ""
					var/color_name = (src.client.admin_color) ? src.client.admin_color : "Admin"
					p.name = "Admin [color_name]"
					src.client.admin_name = p.name
					p.name_txt()
					p.filters = null
					p.vis_contents = null
					p.particles = null
					p.race = usr.race
					p.psionic_power=99999999999999
					p.endurance = 99999999999999
					p.strength = 9999999999999
					p.offence = 99999999999999
					p.defence = 9999999999999

					//p.wings_hidden = usr.wings_hidden
					//p.halo_hidden = usr.halo_hidden
					//if(usr.halo && usr.halo_hidden == 0) p.overlays += usr.halo
					p.filters += filter(type="outline",size=1, color=rgb(100,136,255))
					p.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(204,236,255))
					p.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
					p.afk = 1
					p.started = 1
					p.ref = src

					p.immune_dmg = 1
					var/obj/effects/weapon_energy/we = new
					p.vis_contents += we
					src.projection = p
					src.client.perspective = EYE_PERSPECTIVE | EDGE_PERSPECTIVE
					src.client.eye = p
					p.Move(p.loc)
					src.client.admin_mode=1
					if(p.z == 2)
						p.apply_hell_glow(0)
						p.apply_afterlife_glow(1)
					else if(p.z == 6)
						p.apply_afterlife_glow(0)
						p.apply_hell_glow(1)
					else if(p.z == 12)
						p.apply_afterlife_glow(0)
						p.apply_hell_glow(0)
						p.apply_demonrealm_glow(1)
					else if(p.z == 16)
						p.apply_hell_glow(0)
						p.apply_afterlife_glow(0)
						p.apply_space_glow(1)
					else
						p.apply_hell_glow(0)
						p.apply_afterlife_glow(0)
						p.apply_space_glow(0)
						p.apply_demonrealm_glow(0)
					//if(p.z == 4) usr.show_worldtree(1,1)
					if(p.z != src.z)
						src.screen_text.maptext = "<font size = 6><center>Welcome [p.name]"
						animate(src.screen_text,alpha = 255,time = 60)
						animate(alpha = 0,time = 60)
					if(src.eyes)
						p.eyes = src.eyes
						p.vis_contents += p.eyes
					if(src.eyes_white)
						p.eyes_white = src.eyes_white
						p.vis_contents += p.eyes_white
					//usr.map_proc(1)
					src.client.admin_mode_set = src.client.admin_mode
					save_admin_profile(src.client)
					return
			else
				if(src.client)
					src.client.perspective = MOB_PERSPECTIVE | EDGE_PERSPECTIVE//initial(m.client.perspective)
					src.client.eye = src
				if(src.projection)
					src.projection.shockwave()
					animate(src.projection,alpha = 0, time = 7)
					spawn(8)
						if(src)
							src.projection.loc = null
							src.projection.destroy()
							src.projection = null
				src.client.admin_mode=0



				//var/mob/NPC/m = src.target_follower
				//if(m.owner == src.real_name)
				//	if(src.client.eye != src)
					//	src.client.perspective = EYE_PERSPECTIVE | EDGE_PERSPECTIVE
					//	src.client.eye = src
					//else
					//	src.client.perspective = EYE_PERSPECTIVE | EDGE_PERSPECTIVE
					//	src.client.eye = m
		follower_view_proc()
			var/mob/NPC/m = src.target_follower
			if(m.owner == src.real_name)
				if(src.client.eye != src)
					src.client.perspective = EYE_PERSPECTIVE | EDGE_PERSPECTIVE
					src.client.eye = src
				else
					src.client.perspective = EYE_PERSPECTIVE | EDGE_PERSPECTIVE
					src.client.eye = m
					//src.client.mob = m

		follower_dig_proc()
			var/mob/NPC/m = src.target_follower
			if(m.owner == src.real_name)
				if(m.divine_weapon == 0)
					m.function = null
					m.target = null
					m.target_follow = null
					m.target_go = null
					m.disable_skills()
					m.letgo()
					for(var/obj/skills/Dig/d in m)
						call(d.act)(m,d)
						return
	verb
		//Follower commands
		follower_give()
			set name = ".follower_give"
			set hidden = 1
			if(usr.target_follower)
				if(ismob(usr.target_follower))
					usr.follower_give_proc()
		follower_inv()
			set name = ".follower_inv"
			set hidden = 1
			if(usr.target_follower)
				if(ismob(usr.target_follower))
					usr.follower_inv_proc()
		follower_stop()
			set name = ".follower_stop"
			set hidden = 1
			if(usr.target_follower)
				if(ismob(usr.target_follower))
					usr.follower_stop_proc()
		follower_grab()
			set name = ".follower_grab"
			set hidden = 1
			if(usr.target_follower)
				if(ismob(usr.target_follower))
					usr.follower_grab_proc()
		follower_go()
			set name = ".follower_go"
			set hidden = 1
			if(usr.target_follower)
				if(ismob(usr.target_follower))
					usr.follower_go_proc()
		follower_attack()
			set name = ".follower_attack"
			set hidden = 1
			if(usr.target_follower)
				if(ismob(usr.target_follower))
					usr.follower_attack_proc()
		follower_follow()
			set name = ".follower_follow"
			set hidden = 1
			if(usr.target_follower)
				if(ismob(usr.target_follower))
					usr.follower_follow_proc()
		follower_dismiss()
			set name = ".follower_dismiss"
			set hidden = 1
			if(usr.target_follower)
				if(ismob(usr.target_follower))
					usr.follower_dismiss_proc()
		admin_mode()
			set name = ".admin_mode"
			set hidden = 1
			if(usr.client.admin_mode_set==1)
				usr.admin_view_proc('NewMaleColorable.dmi')
			else
				usr<<"You have to setup your admin profile first, click the Admin Panel Button on your screen!"
				return

		follower_view()
			set name = ".follower_view"
			set hidden = 1
			if(usr.target_follower)
				if(ismob(usr.target_follower))
					usr.follower_view_proc()

		follower_dig()
			set name = ".follower_dig"
			set hidden = 1
			if(usr.target_follower)
				if(ismob(usr.target_follower))
					usr.follower_dig_proc()


		teach_skill()
			set name = ".teach"
			set hidden = 1
			var/obj/skills/x
		//	var/p=input("Input the skill name:") as text
		//	var/t = winget(usr,"[p].label_name","text")
			var/list/skillstoteach=list()
			for(var/obj/skills/s in usr) skillstoteach+=s
			var/obj/skills/taughtskill = input("Which skill to teach:") as null|obj in skillstoteach
			x = taughtskill
			/*
			for(var/obj/skills/s in usr)
				if(s.name == p)
					x = s
				else
					usr.set_alert("Technique not found",'alert.dmi',"alert")
					usr<<"You cannot teach a teachnique you do not have."
					break
					*/
			if(x) //If we find the skill inside the player that they want to teach, continue.
				if(year >= x.teach_cd) x.teach_cd = 0
				if(x.teach_cd <= 0)
					x.teach_cd = 0
					usr.left_click_function = "teach"
					usr.set_alert("Select target to teach",x.icon,x.icon_state)
					usr.left_click_ref = x
					winshow(usr,"skill_panes",0)
					usr.open_traits = 0
					usr.open_menus.Remove(".open_traits")
				else
					usr << output("<font color = teal>Skills can only be taught every 3 years. Next teaching will be available at year [x.teach_cd].","actionoutput")
					usr.set_alert("Available at year [round(x.teach_cd,0.1)]",x.icon,x.icon_state)
					usr.<<output("Available at year [round(x.teach_cd,0.1)]","actionoutput")