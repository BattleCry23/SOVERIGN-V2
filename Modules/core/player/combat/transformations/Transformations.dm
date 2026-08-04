mob
	var
		transformed = 0
		transformation_boost1 = 3.00
		transformation_boost2 = 5.00
		transformation_boost3 = 10.00 // Max
		transformation_boost4 = 15.00 // I'm thinking SSJ4 if anything.
		current_transformation_boost = 0
		power_percent_og = 0
		obj/ssjhair
		obj/ssj2hair
		obj/ssj3hair
		icon/changeling_base_icon
		icon/changeling_form2_icon
		icon/changeling_form3_icon
		icon/changeling_form4_icon

		sf_mastery = 1
		sf2_mastery = 1
		sf3_mastery = 1
		sf4_mastery = 1
		tmp/next_sf_mastery_tick = 0
		tmp/transformation_drain_running = 0

		sf_drain = 2.0

		ssj_form = 0

		// Changeling Base Reqs

		ling_sf2_req = 400000 // 50,000 Power Level
		ling_sf3_req = 800000 // 100,000 Power Level
		ling_sf4_req = 2400000 // 300,000 Power Level
		ling_sf5_req = 4000000 // 500,000 Power Level

		// Saiyan Base Reqs

		saiyan_sf1_req = 600000 // 75,000 Power Level
		saiyan_sf2_req = 2400000 // 300,000 Power Level
		saiyan_sf3_req = 6000000 // 750,000 Power Level
		saiyan_sf4_req = 40000000 // 5,000,000 Power Level

		// Namekian Base Reqs

		namekian_sf1_req = 800000 // 100,000 Power Level
		namekian_sf2_req = 4000000 // 500,000 Power Level

		// Human Base Reqs

		human_sf1_req = 800000 // 100,000 Power Level

		// Alien Base Reqs

		alien_sf1_req = 800000 // 100,000 Power Level

		// Kai Base Reqs

		kai_sf1_req = 2400000 // 300,000 Power Level

		// Demon Base Reqs

		demon_sf1_req = 2400000 // 300,000 Power Level

		// Makyo Base Reqs

		makyo_sf1_req = 800000 // 100,000 Power Level

		// Half God Base Reqs

		halfgod_sf1_req = 2400000 // 300,000 Power Level

		// Spirit Doll Base Reqs

		spiritdoll_sf1_req = 600000 // 75,000 Power Level

		// Oni Base Reqs

		oni_sf1_req = 800000 // 100,000 Power Level

		// Tuffle Base Reqs

		tuffle_sf1_req =  600000 // 75,000 Power Level
mob/proc/Transformation(var/firsttime=1,var/force=0)
	if(firsttime)
		switch(src.race)
			if("Saiyan")
				src.transing = 1
				if(force==1)
					if(!has_sf1) has_sf1=1
					/*if(superform3)
						spawn() src.SSJ4Form_Effect()
						return

					if(superform2)
						spawn() src.SSJ3Form_Effect()
						return
					if(superform)
						spawn() src.SSJ2Form_Effect()
						return*/
					if(!superform)
						spawn() src.SSJForm_Effect()
						return
				else
					if(!has_sf1)
						if(psionic_power_base >= saiyan_sf1_req)
							if(!has_sf1) has_sf1=1
						/*	if(superform3)
								spawn() src.SSJ4Form_Effect()
								return

							if(superform2)
								spawn() src.SSJ3Form_Effect()
								return
							if(superform)
								spawn() src.SSJ2Form_Effect()
								return*/
							if(!superform)
								spawn() src.SSJForm_Effect()
								return
					else
						//if(!has_sf1) has_sf1=1
						/*	if(superform3)
								spawn() src.SSJ4Form_Effect()
								return

							if(superform2)
								spawn() src.SSJ3Form_Effect()
								return
							if(superform)
								spawn() src.SSJ2Form_Effect()
								return*/
						if(!superform)
							spawn() src.SSJForm_Effect()
							return
			if("Changeling")
				src.transing = 1
				if(force==1)

					if(!has_sf1) has_sf1=1
					if(src.start_changeling_transformation_effect())
						return
				else
					if(!has_sf1 )
						if(psionic_power_base >= 1)
							if(!has_sf1) has_sf1=1
							if(src.start_changeling_transformation_effect())
								return
					else
						if(src.start_changeling_transformation_effect())
							return

		return

mob/proc/get_changeling_base_icon()
	if(src.race != "Changeling")
		return null

	var/use_kid_form = (src.age < 13 && src.age > 3.9)
	var/variant = max(1, min(src.skin_pos, 5))

	switch(variant)
		if(1)
			return use_kid_form ? 'Frieza_1st_form_kid.dmi' : 'Frieza_1st_form.dmi'
		if(2)
			return use_kid_form ? '1stFriezaKid_Blue.dmi' : '1stFriezaBlue.dmi'
		if(3)
			return use_kid_form ? '1stFriezaKid_Green.dmi' : '1stFriezaGreen.dmi'
		if(4)
			return use_kid_form ? '1stFriezaKid_Orange.dmi' : '1stFriezaOrange.dmi'
		if(5)
			return use_kid_form ? '1stFriezaKid_Red.dmi' : '1stFriezaRed.dmi'

	return null

mob/proc/get_changeling_form_icon(var/form)
	if(src.race != "Changeling")
		return null

	var/use_kid_form = (src.age < 13 && src.age > 3.9)
	var/variant = max(1, min(src.skin_pos, 5))

	switch(form)
		if(1)
			switch(variant)
				if(1)
					return 'Frieza_2nd_form.dmi'
				if(2)
					return use_kid_form ? '2ndFriezaKid_Blue.dmi' : '2ndFriezaBlue.dmi'
				if(3)
					return use_kid_form ? '2ndFriezaKid_Green.dmi' : '2ndFriezaGreen.dmi'
				if(4)
					return use_kid_form ? '2ndFriezaKid_Orange.dmi' : '2ndFriezaOrange.dmi'
				if(5)
					return use_kid_form ? '2ndFriezaKid_Red.dmi' : '2ndFriezaRed.dmi'
		if(2)
			switch(variant)
				if(1)
					return 'Frieza_3rd_form.dmi'
				if(2)
					return use_kid_form ? '3rdFriezaKid_Blue.dmi' : '3rdFriezaBlue.dmi'
				if(3)
					return use_kid_form ? '3rdFriezaKid_Green.dmi' : '3rdFriezaGreen.dmi'
				if(4)
					return use_kid_form ? '3rdFriezaKid_Orange.dmi' : '3rdFriezaOrange.dmi'
				if(5)
					return use_kid_form ? '3rdFriezaKid_Red.dmi' : '3rdFriezaRed.dmi'
		if(3)
			if(src.race_class == "Cooler")
				switch(variant)
					if(1)
						return 'cooler_4.dmi'
					if(2)
						return 'cooler_4Blue.dmi'
					if(3)
						return 'cooler_4Green.dmi'
					if(4)
						return 'cooler_4Orange.dmi'
					if(5)
						return 'cooler_4Red.dmi'
			switch(variant)
				if(1)
					return 'Frieza_4th_form.dmi'
				if(2)
					return use_kid_form ? '4thFriezaKid_Blue.dmi' : '4thFriezaBlue.dmi'
				if(3)
					return use_kid_form ? '4thFriezaKid_Green.dmi' : '4thFriezaGreen.dmi'
				if(4)
					return use_kid_form ? '4thFriezaKid_Orange.dmi' : '4thFriezaOrange.dmi'
				if(5)
					return use_kid_form ? '4thFriezaKid_Red.dmi' : '4thFriezaRed.dmi'
		if(4,5)
			if(src.race_class == "Cooler")
				if(variant == 5)
					return 'cooler_5Red.dmi'
				return 'cooler_5.dmi'

	return null

mob/proc/apply_changeling_form_icon(var/form)
	if(src.race != "Changeling")
		return

	if(form <= 0)
		var/icon/base_icon = src.get_changeling_base_icon()
		if(!base_icon)
			base_icon = src.changeling_base_icon
		if(base_icon)
			src.icon = base_icon
			src.changeling_base_icon = base_icon
			src.icon_state = ""
		return

	if(!src.transformed && !src.changeling_base_icon)
		src.changeling_base_icon = src.get_changeling_base_icon()

	var/icon/form_icon = src.get_changeling_form_icon(form)
	if(form_icon)
		src.icon = form_icon
		src.icon_state = ""

mob/proc/start_changeling_transformation_effect()
	if(src.race != "Changeling")
		return 0

	switch(src.superform)
		if(0)
			spawn() src.Changeling_Superform2ndForm_Effect()
			return 1
		if(1)
			spawn() src.Changeling_Superform3rdForm_Effect()
			return 1
		if(2)
			spawn() src.Changeling_Superform4thForm_Effect()
			return 1
		if(3)
			if(src.race_class == "Cooler")
				spawn() src.Changeling_Superform5thForm_Effect()
				return 1

	return 0

mob/proc/gain_superform_mastery()
	if(!src.transformed || src.superform <= 0 || src.energy_max <= 0)
		return
	if(world.time < src.next_sf_mastery_tick)
		return

	var/energy_ratio = max(0.05, min(src.energy / max(src.energy_max, 1), 1))
	var/strain_multi = 1 + ((1 - energy_ratio) * 0.75)
	var/base_gain = 0.02
	var/gain_multi = 1
	var/next_tick_delay = 10
	var/gain_amount = 0

	switch(src.superform)
		if(1)
			if(src.sf_mastery >= 100)
				return
			gain_multi = 1
			next_tick_delay = 10
			gain_amount = base_gain * gain_multi * strain_multi
			src.sf_mastery = min(100, src.sf_mastery + gain_amount)
		if(2)
			if(src.sf2_mastery >= 100)
				return
			gain_multi = 0.75
			next_tick_delay = 12
			gain_amount = base_gain * gain_multi * strain_multi
			src.sf2_mastery = min(100, src.sf2_mastery + gain_amount)
		if(3)
			if(src.sf3_mastery >= 100)
				return
			gain_multi = 0.55
			next_tick_delay = 15
			gain_amount = base_gain * gain_multi * strain_multi
			src.sf3_mastery = min(100, src.sf3_mastery + gain_amount)
		if(4,5)
			if(src.sf3_mastery >= 100)
				return
			gain_multi = 0.45
			next_tick_delay = 18
			gain_amount = base_gain * gain_multi * strain_multi
			src.sf4_mastery = min(100, src.sf4_mastery + gain_amount)
		else
			return

	src.next_sf_mastery_tick = world.time + next_tick_delay

mob/proc/start_transformation_upkeep()
	if(!src.transformed || src.superform <= 0 || src.transformation_drain_running)
		return
	spawn(2)
		if(src && src.transformed && src.superform > 0 && !src.transformation_drain_running)
			src.transformation_drain(src)

mob/proc/Apply_Transformation_Boost(var/race)
	var/energy_ratio = max(0.1, min(src.energy / max(src.energy_max, 1), 1))
	var/pressure_multi = 1 + ((1 - energy_ratio) * 0.25)
	var/form_multi = 1
	var/mastery_multi = 1
	power_percent_og = power_percent
	switch(race)
		if("Saiyan")
			if(saiyan_dna)
				if(transformed)
					if(has_sf1 && !superform)
						//mastery_multi = 1 + ((max(0, min(sf_mastery, 100)) / 100) * 0.15)
						form_multi = transformation_boost1 + 7
						var/boost = round(psionic_power * form_multi * mastery_multi * pressure_multi)
						current_transformation_boost = boost
						power_percent = round(100 * form_multi * pressure_multi)
						ssj_form = 1
						superform = ssj_form
						/*if(!has_sf1) 
							has_sf1=1*/
						mod_strength *= 1.1
						mod_endurance *= 1.1
						mod_force *= 1.1
						mod_resistance *= 1.1
						mod_offence *= 1.1
						mod_defence *= 1.1
						mod_agility *= 1.1
						src.start_transformation_upkeep()
						view(15,src)<<output("<b><font color=yellow>[src] has transformed into a Super Saiyan!</b></font>","actionoutput")
						return

					if((has_sf2 || psionic_power_base >= saiyan_sf2_req) && superform == 1)
						//mastery_multi = 1 + ((max(0, min(sf2_mastery, 100)) / 100) * 0.2)
						form_multi = transformation_boost2 + 14
						var/boost = round(psionic_power * form_multi * pressure_multi)
						current_transformation_boost = boost
						power_percent = round(100 * form_multi * pressure_multi)
						ssj_form = 2
						mod_agility = mod_agility_og * 2
						mod_recovery *= 0.5
						superform = ssj_form
						if(!has_sf2) 
							has_sf2=1
						src.start_transformation_upkeep()
						view(15,src)<<output("<b><font color=yellow>[src] has transformed into Super Saiyan 2!</b></font>","actionoutput")
						return

					if((has_sf3 || psionic_power_base >= saiyan_sf3_req) && superform == 2)
						//mastery_multi = 1 + ((max(0, min(sf3_mastery, 100)) / 100) * 0.25)
						form_multi = transformation_boost3 + 21
						var/boost = round(psionic_power * form_multi * mastery_multi * pressure_multi)
						current_transformation_boost = boost
						power_percent = round(100 * form_multi * pressure_multi)
						ssj_form = 3
						mod_recovery *= 0.75
						superform = ssj_form
						if(!has_sf3) 
							has_sf3=1
						src.start_transformation_upkeep()
						view(15,src)<<output("<b><font color=yellow>[src] has transformed into Super Saiyan 3!</b></font>","actionoutput")
						return

				/*if(has_sf4 && superform3 || psionic_power_base >= saiyan_sf4_req && superform3)
					var/boost = (psionic_power * transformation_boost4)
					current_transformation_boost = boost
					power_percent = (100 * transformation_boost4)
					superform=0
					superform2=0
					superform3=0
					superform4=1
					if(!has_sf4) has_sf4=1
					view(15,src)<<output("<b><font color=yellow>[src] has transformed into Super Saiyan 4!</b></font>","actionoutput")
					return*/

		if("Changeling")
			if(transformed)
				if(has_sf1 && !superform)
					mastery_multi = 1 + ((max(0, min(sf_mastery, 100)) / 100) * 0.15)
					form_multi = transformation_boost1 + 5
					var/boost = round(psionic_power * form_multi * mastery_multi * pressure_multi)
					current_transformation_boost = boost
					power_percent = round(100 * form_multi * mastery_multi * pressure_multi)
					superform = 1
					src.apply_changeling_form_icon(superform)
					mod_regeneration *= 0.25
					mod_recovery *= 0.25
					src.start_transformation_upkeep()
					view(15,src)<<output("<b><font color=yellow>[src] has transformed into their second form!</b></font>","actionoutput")
					return

				if(has_sf2 && superform == 1 || psionic_power_base >= ling_sf2_req && superform == 1)
					mastery_multi = 1 + ((max(0, min(sf2_mastery, 100)) / 100) * 0.2)
					form_multi = transformation_boost2 + 8
					var/boost = round(psionic_power * form_multi * mastery_multi * pressure_multi)
					current_transformation_boost = boost
					power_percent = round(100 * form_multi * mastery_multi * pressure_multi)
					superform = 2
					src.apply_changeling_form_icon(superform)
					mod_regeneration *= 0.50
					mod_recovery *= 0.50
					if(!has_sf2) 
						has_sf2=1
					src.start_transformation_upkeep()
					view(15,src)<<output("<b><font color=yellow>[src] has transformed into their third form!</b></font>","actionoutput")
					return

				if(has_sf3 && superform == 2 || psionic_power_base >= ling_sf3_req && superform == 2)
					mastery_multi = 1 + ((max(0, min(sf3_mastery, 100)) / 100) * 0.25)
					form_multi = transformation_boost3 + 10
					var/boost = round(psionic_power * form_multi * mastery_multi * pressure_multi)
					current_transformation_boost = boost
					power_percent = round(100 * form_multi * mastery_multi * pressure_multi)
					superform = 3
					src.apply_changeling_form_icon(superform)
					mod_regeneration *= 0.75
					mod_recovery *= 0.75
					if(!has_sf3) 
						has_sf3=1
					src.start_transformation_upkeep()
					view(15,src)<<output("<b><font color=yellow>[src] has transformed into their final form!</b></font>","actionoutput")
					return

				if(race_class == "Cooler")

					if(has_sf4 && superform == 3 || psionic_power_base >= ling_sf4_req && superform == 3)
						form_multi = transformation_boost4 + 12
						var/boost = round(psionic_power * form_multi * pressure_multi)
						current_transformation_boost = boost
						power_percent = round(100 * form_multi * pressure_multi)
						superform = 4
						src.apply_changeling_form_icon(superform)
						if(!has_sf4) 
							has_sf4=1
						src.start_transformation_upkeep()
						view(15,src)<<output("<b><font color=yellow>[src] has transformed into their ultimate form!</b></font>","actionoutput")
						return

					if(has_sf5 && superform == 4 || psionic_power_base >= ling_sf5_req && superform == 4)
						form_multi = transformation_boost4 + 14
						var/boost = round(psionic_power * form_multi * pressure_multi)
						current_transformation_boost = boost
						power_percent = round(100 * form_multi * pressure_multi)
						superform = 5
						src.apply_changeling_form_icon(superform)
						if(!has_sf5) 
							has_sf5=1
						src.start_transformation_upkeep()
						return

mob/proc/revert_transformation()
	if(!src.transformed || src.superform <= 0)
		return

	var/previous_superform = src.superform

	// Reset stat modifiers
	mod_strength = mod_strength_og
	mod_endurance = mod_endurance_og
	mod_force = mod_force_og
	mod_resistance = mod_resistance_og
	mod_offence = mod_offence_og
	mod_defence = mod_defence_og
	mod_agility = mod_agility_og
	mod_regeneration = mod_regeneration_og
	mod_recovery = mod_recovery_og

	// Reset transformation variables
	transformed = 0
	superform = 0
	ssj_form = 0
	current_transformation_boost = 0
	power_percent = power_percent_og

	// Remove aura and effects
	if(src.race == "Changeling")
		src.apply_changeling_form_icon(0)
	if(saiyan_dna)
		switch(previous_superform)
			if(1)
				remove_overlay(src, src.ssjhair)
			if(2)
				remove_overlay(src, src.ssj2hair)
			if(3)
				remove_overlay(src, src.ssj3hair)
		add_overlay(src, src.hair)
		update_looks("hair color")
		update_looks("eye color")
	
	view(15,src) << output("<b><font color=yellow>[src] has reverted to their base form!</b></font>","actionoutput")

mob/proc/transformation_drain(var/mob/container)
	if(!container || !container.transformed || container.energy <= 0)
		return
	if(container.transformation_drain_running)
		return
	container.transformation_drain_running = 1

	while(container && container.transformed && container.superform && container.energy_max > 0)
		if(prob(30))
			container.gain_superform_mastery()

		if(container.energy <= 0)
			container.transformation_drain_running = 0
			container.revert_transformation()
			return

		var/form_multiplier = 1
		var/mastery = 0
		var/mastery_reduction = 0.75
		var/min_drain = 1
		var/valid_form = 0
		var/apply_backlash = 0

		switch(container.race)
			if("Saiyan")
				switch(container.superform)
					if(1)
						mastery = max(0, min(container.sf_mastery, 100))
						if(mastery >= 100)
							min_drain = 0.12
						valid_form = 1
					if(2)
						mastery = max(0, min(container.sf2_mastery, 100))
						form_multiplier = 2
						valid_form = 1
					if(3)
						mastery = max(0, min(container.sf3_mastery, 100))
						form_multiplier = 4.5
						mastery_reduction = 0.35
						valid_form = 1
					else
						break

			if("Namekian")
				switch(container.superform)
					if(1)
						mastery = max(0, min(container.sf_mastery, 100))
						if(mastery >= 100)
							min_drain = 0
						valid_form = 1
					if(2)
						mastery = max(0, min(container.sf2_mastery, 100))
						form_multiplier = 2
						if(mastery >= 100)
							min_drain = 1.3
						valid_form = 1
					else
						break
			
			if("Changeling")
				switch(container.superform)
					if(1)
						mastery = max(0, min(container.sf_mastery, 100))
						form_multiplier = 1.5
						valid_form = 1
						apply_backlash = 1
					if(2)
						mastery = max(0, min(container.sf2_mastery, 100))
						form_multiplier = 2.5
						valid_form = 1
						apply_backlash = 1
					if(3)
						mastery = max(0, min(container.sf3_mastery, 100))
						form_multiplier = 3.5
						valid_form = 1
						apply_backlash = 1
					if(4)
						mastery = max(0, min(container.sf3_mastery, 100))
						form_multiplier = 4.5
						mastery_reduction = 0.5
						valid_form = 1
						apply_backlash = 1
					if(5)
						mastery = max(0, min(container.sf3_mastery, 100))
						form_multiplier = 5.5
						mastery_reduction = 0.4
						valid_form = 1
						apply_backlash = 1
					else
						break

		if(valid_form)
			var/transdrain = container.energy_max * 0.01
			var/mastery_multi = 1 - ((mastery / 100) * mastery_reduction)
			var/energy_ratio = max(0.05, min(container.energy / max(container.energy_max, 1), 1))
			var/pressure_multi = 1 + ((1 - energy_ratio) * 0.5)
			var/final_drain = max(min_drain, round(transdrain * mastery_multi * container.sf_drain * form_multiplier * pressure_multi))
			if(apply_backlash && mastery >= 100 && container.superform <= 3)
				final_drain = 0
			else if(apply_backlash && mastery >= 100 && container.superform == 4)
				final_drain = max(0.12, final_drain * 0.1)

			if(final_drain > 0 && prob(20))
				container.energy -= final_drain

			var/unmastered_ratio = max(0, (100 - mastery) / 100)
			if(apply_backlash && unmastered_ratio > 0)
				var/form_pressure = max(0.5, form_multiplier - 0.5)
				var/backlash_intensity = unmastered_ratio * form_pressure * pressure_multi
				var/hp_backlash = max(0.05, 0.08 + (backlash_intensity * 0.55))
				var/limb_damage_chance = min(85, 20 + round(backlash_intensity * 30))
				var/obj/body_related/bodyparts/torso/torso_limb = null
				var/obj/body_related/bodyparts/head/head_limb = null
				for(var/obj/body_related/bodyparts/torso/torso_part in container.bodyparts)
					torso_limb = torso_part
					break
				for(var/obj/body_related/bodyparts/head/head_part in container.bodyparts)
					head_limb = head_part
					break

				if(prob(limb_damage_chance) && container.body && container.body.len)
					var/limb_hit_damage = max(0.1, hp_backlash * (0.6 + (backlash_intensity * 0.3)))
					if(torso_limb)
						container.damage_limb(container,0,0,limb_hit_damage,torso_limb)
					if(head_limb)
						container.damage_limb(container,0,0,limb_hit_damage,head_limb)
					if(!torso_limb && !head_limb)
						container.damage_limb(container,1,0,limb_hit_damage)
					container.percent_health -= hp_backlash
					if(container.percent_health <= 0)
						container.KO()
						break
		
		sleep(1)
	container.transformation_drain_running = 0
	
mob/proc/SSJForm_Effect()
//	var/progress = 0;
//	var/obj/bar = null
//	var/obj/bar_inner = null
	var/tmp/list/things = list()
	var/tmp/list/dusts = list()
	var/tmp/list/disk_dust1 = list()
	var/tmp/list/disk_dust2 = list()
//	var/tmp/obj/g_ball = null
//	var/tmp/obj/g_rays = null
	var/tmp/list/pixs
	var/tmp/mob_filter_pos = 0
	var/sound/SF = sound('first ssj.ogg')
	SF.channel = 3
	SF.volume = 25
	SF.repeat = 0

	var/sound/S = sound('Power_Control_Stop.wav')
	S.channel = 9
	S.volume = 40
	S.repeat = 0
	var/sound/ST = sound('SuperFly.wav')
	ST.channel=7
	ST.volume = 45
	ST.repeat = 1
	var/sound/SP = sound('Power_Control_Continuous.wav')
	SP.channel=8
	SP.volume = 45
	SP.repeat = 0
	var/sound/SA = sound('Super_Aura.wav')
	SA.channel = 10
	SA.volume = 30
	SA.repeat = 1

//	var/rotation = 0
	var/mob/m = src
	var/obj/o = new
	var/obj/rays = new
	var/obj/Auras_Special/SSJ1/a = new
	m.ssjhair = m.hair
	m.ssjhair.filters += filter(type="color", color="#FFF27A")
	m.ssjhair.color = list(
	1.6, 1.4, 0.1, 0,
	1.6, 1.4, 0.1, 0,
	0.3, 0.3, 0.1, 0,
	0,   0,   0,   1
	)



	m.stunned += 1
	m.stunned_pending += 1


	// INITIAL PARTICLE GLOW EFFECT

	m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
	mob_filter_pos = m.filters.len
	animate(m.filters[m.filters.len], size = 3,offset = 1, time = 15, loop = -1)
	animate(size = -3,offset = -3, time = 15, loop = -1)
	m.step_x = 0
	m.step_y = 0
	m.set_shadow()
	m.icon_state="Superform"
	view(15,m) << ST
	sleep(10)
	view(15,m) << sound(null, channel = 1)
	view(15,m) << SF

	var/p = 44
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
		pix.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=m.auracolor) //rgb(255,255,170) white-ish?
		pix.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
		animate(pix,pixel_x = 0, pixel_y = 0, time = rand(10,20), alpha = 255,loop = -1)
		animate(pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = 0, alpha = 0)
		if(pixs && islist(pixs)) pixs += pix
		else pixs = list()
	p = 44
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
		pix.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color="#FFF27A") //rgb(102,0,204) purple hue?
		pix.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
		animate(pix,pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = 10, alpha = 0,loop = -1)
		animate(pixel_x = 0, pixel_y = 0, time = 0, alpha = 255)
		if(pixs && islist(pixs)) pixs += pix
		else pixs = list()


	//SHOCKWAVE - INITIAL DUST EXPLOSION EFFECT
	spawn for(var/area/A in view(60,src)) A.Super_Darkness()

	var/create_dusts = 55
//	var/xx = 0
//	var/yy = 6
//	var/deg = 0
//	var/t = 0
	var/obj/h = new
	var/turf/trf = locate(m.x,m.y,m.z)
	h.loc = trf
	h.alpha = 0
	things += h
	var/terrain = null
	var/turf/t_usr = m.loc
	if(t_usr.liquid == "water")
		terrain = "water"
		h.plane = -1
	else if(t_usr.liquid == "psionic") terrain = "psionic"
	else if(istype(t_usr,/turf/snows/)) terrain = "snow"
	else if(istype(t_usr,/turf/lava_static)) terrain = "lava"


	// DUST FURROW EFFECT

	create_dusts = 44
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
				var/px = rand(-180,180)
				var/py = rand(-180,180)
				if(px < 32 && px > 0) px = 32
				if(px > -16 && px < 0) px = -16
				if(py < 32 && py > 0) py = 32
				if(py > -16 && py < 0) py = -16
				d.pixel_x = px
				d.pixel_y = py
				animate(d,pixel_x = -10,pixel_y = -6, alpha = 5,time = rand(5,15), loop = -1)
				animate(pixel_x = px,pixel_y = py,alpha = 255, time = 0)
				dusts += d
				break

	// RAYS GLOW - SHAPESHIFTING EFFECT
	spawn(15)
		var/obj/rev = m.hair


		rays.icon = 'fx_ray_large.dmi'
		rays.pixel_x = -284
		rays.pixel_y = -284
		rays.loc = m.loc
		rays.step_x = m.step_x
		rays.step_y = m.step_y
		rays.bolted = 2
		rays.layer = m.layer+100
		m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor) // possibly purple? rgb(102,0,204)
		m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
		rays.filters += filter(type="rays",x=0,y=0,size=300,color=rgb(255,255,255),offset=0,density=15,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
		animate(rays.filters[1],offset = 100,time = 1000, loop = -1)
		animate(offset = 0,time = 0)

		o.icon = m.icon
		o.icon_state = m.icon_state
		o.overlays = m.overlays
		o.loc = m.loc
		o.step_x = m.step_x
		o.step_y = m.step_y
		o.bolted = 2
		o.layer = m.layer+1
		animate(o, color = list("#000", "#000", "#000", "#fff"),time=20)
		var/amount=6
		//overlays.Remove(m.hair)
		while(amount)
			amount-=1
			remove_overlay(m, rev)
			add_overlay(m, m.ssjhair)
			add_overlay(m, a)
			m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor) // possibly purple? rgb(102,0,204)
			m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
			o.icon = m.icon
			o.icon_state = m.icon_state
			o.overlays = m.overlays
			o.loc = m.loc
			o.step_x = m.step_x
			o.step_y = m.step_y
			o.bolted = 2
			o.layer = m.layer+1
			animate(o, color = list("#000", "#000", "#000", "#fff"),time=20)
			sleep(rand(5,20))
			if(prob(50))
				remove_overlays(m, list(m.ssjhair, a))
				add_overlay(m, rev)
				//remove_overlay(m, a)

			m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor) // possibly purple? rgb(102,0,204)
			m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
			o.icon = null
			o.icon_state = null
			o.overlays = null
			o.loc = null
			o.step_x = m.step_x
			o.step_y = m.step_y
			o.bolted = 2
			o.layer = m.layer+1
			animate(o, color = list("#000", "#000", "#000", "#fff"),time=20)
			sleep(rand(2,4))

		overlays.Remove(a)
		remove_overlay(m, m.ssjhair)
		for(var/turf/A in view(10,src))
			A.Rising_Rocks()
		spawn() Super_Lightning()

	// ANIMATE DUST FURROW EFFECT

	for(var/obj/effects/dust/d in disk_dust1)
		animate(d,transform = turn(matrix(),60), time = 5,loop = -1)
		animate(transform = turn(matrix(),120), time = 5)
		animate(transform = null, time = 5)
	for(var/obj/effects/dust/d in disk_dust2)
		animate(d,transform = turn(matrix(),240), time = 5,loop = -1)
		animate(transform = turn(matrix(),120), time = 5)
		animate(transform = null, time = 5)

	spawn(120)
		if(pixs && islist(pixs))
			for(var/obj/v in pixs)
				animate(v)
				v.destroy()
				sleep(0.1)
			pixs = null
		view(15,m) << sound(null, channel = 7)
		m.shockwave_huge()
		locate(m.x,m.y,m.z).explosion(2,0)
		var/obj/effects/shockwave_medium/b = new
		b.pixel_x = -64
		b.pixel_y = -64
		b.loc = h.loc
		b.transform *= 0.1
		animate(b, transform = matrix()*1, alpha = 0, time = 3)
		spawn(3)
			if(b) b.destroy()
		view(15,src) << S
		rays.loc = null
		o.loc = null
		m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color="#FFF27A")
		m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
		if(mob_filter_pos) m.filters -= m.filters[mob_filter_pos]
		if(things && islist(things))
			for(var/obj/v in things)
				v.destroy()
		if(dusts && islist(dusts))
			for(var/obj/v in dusts)
				animate(v)
				animate(v,alpha = 0, pixel_x = -10,pixel_y = -10,time = 10)
				spawn(10)
					if(v)
						v.loc = null
						v.alpha = 255
						v.pixel_y = 0
						v.pixel_x = -20
						v.layer = 3
						v.color = null
						v.icon = initial(v.icon)
						v.plane = initial(v.plane)
						animate(v)
		things = list()
		dusts = list()
		disk_dust1 = list()
		disk_dust2 = list()
		m.stunned -= 1
		m.stunned_pending -= 1
		//for(var/obj/skills/Power_Control/pc in m)
		//	pc.og_trans_hair = m.hair
		view(15,m) << SA
		view(15,m) << SP
		m.icon_state = initial(m.icon_state)
		flick("Transform",m)
		spawn(5)
			remove_overlay(m, m.hair)
			add_overlay(m, m.ssjhair)
		overlays.Add(a)
		m.transformed = 1
		if(m.has_sf1!=1) m.has_sf1 = 1
		m.Apply_Transformation_Boost(m.race)
		m.transing = 0
		spawn(120)
			SA.repeat = 0
			SP.repeat = 0
			view(15,m) << sound(null, channel = 7)
			view(15,m) << sound(null, channel = 8)
			view(15,m) << sound(null, channel = 9)
			view(15,m) << sound(null, channel = 10)


mob/proc/Changeling_Superform2ndForm_Effect()
//	var/progress = 0;
//	var/obj/bar = null
//	var/obj/bar_inner = null
	var/tmp/list/things = list()
	var/tmp/list/dusts = list()
	var/tmp/list/disk_dust1 = list()
	var/tmp/list/disk_dust2 = list()
//	var/tmp/obj/g_ball = null
//	var/tmp/obj/g_rays = null
	var/tmp/list/pixs
	var/tmp/mob_filter_pos = 0
	var/sound/S = sound('Power_Control_Stop.wav')
	S.channel = 9
	S.volume = 40
	S.repeat = 0
	var/sound/ST = sound('SuperFly.wav')
	ST.channel=7
	ST.volume = 45
	ST.repeat = 1
	var/sound/SP = sound('Power_Control_Continuous.wav')
	SP.channel=8
	SP.volume = 45
	SP.repeat = 0
	var/sound/SA = sound('Super_Aura.wav')
	SA.channel = 10
	SA.volume = 30
	SA.repeat = 1
//	var/rotation = 0
	var/mob/m = src
	var/obj/o = new
	var/obj/rays = new
	var/obj/effects/aura/a = new
	a.icon *= m.auracolor
	m.stunned += 1
	m.stunned_pending += 1
	for(var/obj/skills/Power_Control/pc in m)
		overlays.Remove(pc.aura)
		pc.aura = a
		pc.sfx = S
		pc.og_form_icon = m.icon

	// INITIAL PARTICLE GLOW EFFECT

	m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
	mob_filter_pos = m.filters.len
	animate(m.filters[m.filters.len], size = 3,offset = 1, time = 15, loop = -1)
	animate(size = -3,offset = -3, time = 15, loop = -1)
	m.step_x = 0
	m.step_y = 0
	m.set_shadow()
	m.icon_state="Superform"
	view(15,m) << ST
	sleep(10)
	overlays.Add(a)


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
		pix.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(255,255,170)) //rgb(255,255,170) white-ish?
		pix.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
		animate(pix,pixel_x = 0, pixel_y = 0, time = rand(10,20), alpha = 255,loop = -1)
		animate(pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = 0, alpha = 0)
		if(pixs && islist(pixs)) pixs += pix
		else pixs = list()
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
		pix.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=m.auracolor) //rgb(102,0,204) purple hue?
		pix.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
		animate(pix,pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = 10, alpha = 0,loop = -1)
		animate(pixel_x = 0, pixel_y = 0, time = 0, alpha = 255)
		if(pixs && islist(pixs)) pixs += pix
		else pixs = list()
		sleep(0.1)




	//SHOCKWAVE - INITIAL DUST EXPLOSION EFFECT
	spawn for(var/area/A in view(60,src)) A.Super_Darkness()

	var/create_dusts = 44
//	var/xx = 0
//	var/yy = 6
//	var/deg = 0
//	var/t = 0
	var/obj/h = new
	var/turf/trf = locate(m.x,m.y,m.z)
	h.loc = trf
	h.alpha = 0
	things += h

	var/terrain = null
	var/turf/t_usr = m.loc
	if(t_usr.liquid == "water")
		terrain = "water"
		h.plane = -1
	else if(t_usr.liquid == "psionic") terrain = "psionic"
	else if(istype(t_usr,/turf/snows/)) terrain = "snow"
	else if(istype(t_usr,/turf/lava_static)) terrain = "lava"
	/*while(create_dusts)
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
				yy += 9
				deg += 3
				t += 1
				d.trans_x = xx
				d.trans_y = yy
				d.deg = deg
				h.overlays += d
				dusts += d
				break
	create_dusts = 44
	xx = 0
	yy = 2
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
				yy -= 9
				deg += 5
				t += 1
				d.trans_x = xx
				d.trans_y = yy
				d.deg = deg
				h.overlays += d
				dusts += d
				break
				*/
	/*create_dusts = 66
	deg = 140
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
				animate(d, pixel_x = px*100, pixel_y = py*100, time = 10)
				d.trans_x = px*100
				d.trans_y = py*100
				d.og_layer = d.layer
				d.deg = deg
				disk_dust1 += d
				dusts += d
				break
		deg -= 3*/
	/*create_dusts = 44
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
				animate(d, pixel_x = px*100, pixel_y = py*100, time = 8)
				d.trans_x = px*100
				d.trans_y = py*100
				d.og_layer = d.layer
				disk_dust2 += d
				dusts += d
				break
		deg -= 3*/
	//sleep(20)



	// DUST FURROW EFFECT

	create_dusts = 22
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
				var/px = rand(-180,180)
				var/py = rand(-180,180)
				if(px < 32 && px > 0) px = 32
				if(px > -16 && px < 0) px = -16
				if(py < 32 && py > 0) py = 32
				if(py > -16 && py < 0) py = -16
				d.pixel_x = px
				d.pixel_y = py
				animate(d,pixel_x = -10,pixel_y = -6, alpha = 5,time = rand(5,15), loop = -1)
				animate(pixel_x = px,pixel_y = py,alpha = 255, time = 0)
				dusts += d
				break
		sleep(0.1)

	// RAYS GLOW - SHAPESHIFTING EFFECT
	spawn(15)
		overlays.Remove(a)
		var/icon/rev = m.icon
		var/icon/form_preview = m.get_changeling_form_icon(1)
		if(!form_preview)
			form_preview = 'Frieza_2nd_form.dmi'
		rays.icon = 'fx_ray_large.dmi'
		rays.pixel_x = -284
		rays.pixel_y = -284
		rays.loc = m.loc
		rays.step_x = m.step_x
		rays.step_y = m.step_y
		rays.bolted = 2
		rays.layer = m.layer+100
		m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor) // possibly purple? rgb(102,0,204)
		m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
		rays.filters += filter(type="rays",x=0,y=0,size=300,color=rgb(255,255,255),offset=0,density=15,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
		animate(rays.filters[1],offset = 100,time = 1000, loop = -1)
		animate(offset = 0,time = 0)


		o.icon = m.icon
		o.icon_state = m.icon_state
		o.overlays = m.overlays
		o.loc = m.loc
		o.step_x = m.step_x
		o.step_y = m.step_y
		o.bolted = 2
		o.layer = m.layer+1
		animate(o, color = list("#000", "#000", "#000", "#fff"),time=20)
		var/amount=6
		while(amount)
			amount-=1


			m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor) // possibly purple? rgb(102,0,204)
			m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
			o.icon = form_preview
			o.icon_state = ""
			o.overlays = m.overlays
			o.loc = m.loc
			o.step_x = m.step_x
			o.step_y = m.step_y
			o.bolted = 2
			o.layer = m.layer+1
			animate(o, color = list("#000", "#000", "#000", "#fff"),time=20)
			sleep(rand(5,20))
			o.overlays = m.overlays
			o.icon = rev
			o.icon_state = m.icon_state
			o.loc = m.loc
			o.step_x = m.step_x
			o.step_y = m.step_y
			o.bolted = 2
			o.layer = m.layer+1
			animate(o, color = list("#000", "#000", "#000", "#fff"),time=20)
			m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor) // possibly purple? rgb(102,0,204)
			m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
			sleep(rand(2,4))

		//overlays.Remove(a)

		for(var/turf/A in view(10,src))
			A.Rising_Rocks()
		spawn() Super_Lightning()
	//animate(h, transform = turn(matrix(), -120), time = 15, loop = -1)
	//animate(transform = turn(matrix(), -240), time = 15)
	//animate(transform = null, time = 15)
	//animate(h,alpha = 255,time = 10, flags = ANIMATION_PARALLEL)


	//var/obj/items/environmental/blackhole/bh = new
	//bh.loc = h.loc
	//bh.transform = matrix()*0.1
	//bh.grown = 0
	//bh.layer = m.layer+0.1
	//animate(bh)
	//animate(bh,transform = matrix()*1, time = 1000)
	//bh.spin()
	//blackhole = bh



	// ANIMATE DUST FURROW EFFECT

	for(var/obj/effects/dust/d in disk_dust1)
		animate(d,transform = turn(matrix(),60), time = 5,loop = -1)
		animate(transform = turn(matrix(),120), time = 5)
		animate(transform = null, time = 5)
	for(var/obj/effects/dust/d in disk_dust2)
		animate(d,transform = turn(matrix(),240), time = 5,loop = -1)
		animate(transform = turn(matrix(),120), time = 5)
		animate(transform = null, time = 5)

	spawn(120)
		if(pixs && islist(pixs))
			for(var/obj/v in pixs)
				animate(v)
				v.destroy()
				sleep(0.1)
			pixs = null
		view(15,m) << sound(null, channel = 7)
		m.shockwave_huge()
		locate(m.x,m.y,m.z).explosion(2,0)
		var/obj/effects/shockwave_medium/b = new
		b.pixel_x = -64
		b.pixel_y = -64
		b.loc = h.loc
		b.transform *= 0.1
		animate(b, transform = matrix()*1, alpha = 0, time = 3)
		spawn(3)
			if(b) b.destroy()
		view(15,src) << S

		rays.loc = null
		o.loc = null
		m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
		m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
		if(mob_filter_pos) m.filters -= m.filters[mob_filter_pos]
		if(things && islist(things))
			for(var/obj/v in things)
				v.destroy()
		if(dusts && islist(dusts))
			for(var/obj/v in dusts)
				animate(v)
				animate(v,alpha = 0, pixel_x = -10,pixel_y = -10,time = 10)
				spawn(10)
					if(v)
						v.loc = null
						v.alpha = 255
						v.pixel_y = 0
						v.pixel_x = -20
						v.layer = 3
						v.color = null
						v.icon = initial(v.icon)
						v.plane = initial(v.plane)
						animate(v)
		things = list()
		dusts = list()
		disk_dust1 = list()
		disk_dust2 = list()
		m.stunned -= 1
		m.stunned_pending -= 1
		view(15,m) << SA
		view(15,m) << SP
		m.icon_state = initial(m.icon_state)
		flick("Transform",m)
		spawn(10)
			m.apply_changeling_form_icon(1)
		overlays.Add(a)
		m.transformed = 1
		if(m.has_sf1!=1) m.has_sf1 = 1
		m.Apply_Transformation_Boost(m.race)
		m.transing = 0
		spawn(120)
			SA.repeat = 0
			SP.repeat = 0
			view(15,m) << sound(null, channel = 7)
			view(15,m) << sound(null, channel = 8)
			view(15,m) << sound(null, channel = 9)
			view(15,m) << sound(null, channel = 10)



mob/proc/Changeling_Superform3rdForm_Effect()
//	var/progress = 0;
//	var/obj/bar = null
//	var/obj/bar_inner = null
	var/tmp/list/things = list()
	var/tmp/list/dusts = list()
	var/tmp/list/disk_dust1 = list()
	var/tmp/list/disk_dust2 = list()
//	var/tmp/obj/g_ball = null
	//var/tmp/obj/g_rays = null
	var/tmp/list/pixs
	var/tmp/mob_filter_pos = 0
	var/sound/S = sound('Power_Control_Stop.wav')
	S.channel = 9
	S.volume = 40
	S.repeat = 0
	var/sound/ST = sound('SuperFly.wav')
	ST.channel=7
	ST.volume = 45
	ST.repeat = 1
	var/sound/SP = sound('Power_Control_Continuous.wav')
	SP.channel=8
	SP.volume = 45
	SP.repeat = 0
	var/sound/SA = sound('Super_Aura.wav')
	SA.channel = 10
	SA.volume = 30
	SA.repeat = 1

//	var/rotation = 0
	var/mob/m = src
	var/obj/o = new
	var/obj/rays = new
	var/obj/effects/aura/a = new
	a.icon *= m.auracolor


	m.stunned += 1
	m.stunned_pending += 1
	for(var/obj/skills/Power_Control/pc in m)
		remove_overlay(m, pc.aura)
		pc.aura = a
		pc.sfx = S
		pc.trans2_icon = m.icon

	// INITIAL PARTICLE GLOW EFFECT

	m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
	mob_filter_pos = m.filters.len
	animate(m.filters[m.filters.len], size = 3,offset = 1, time = 15, loop = -1)
	animate(size = -3,offset = -3, time = 15, loop = -1)
	m.step_x = 0
	m.step_y = 0
	m.set_shadow()
	m.icon_state="Superform"
	view(15,m) << ST
	sleep(10)
	add_overlay(m, a)


	var/p = 44
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
		pix.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(255,255,170)) //rgb(255,255,170) white-ish?
		pix.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
		animate(pix,pixel_x = 0, pixel_y = 0, time = rand(10,20), alpha = 255,loop = -1)
		animate(pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = 0, alpha = 0)
		if(pixs && islist(pixs)) pixs += pix
		else pixs = list()
		sleep(0.1)
	p = 44
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
		pix.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=m.auracolor) //rgb(102,0,204) purple hue?
		pix.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
		animate(pix,pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = 10, alpha = 0,loop = -1)
		animate(pixel_x = 0, pixel_y = 0, time = 0, alpha = 255)
		if(pixs && islist(pixs)) pixs += pix
		else pixs = list()
		sleep(0.1)


	//SHOCKWAVE - INITIAL DUST EXPLOSION EFFECT
	spawn for(var/area/A in view(60,src)) A.Super_Darkness()

	var/create_dusts = 55
//	var/xx = 0
//	var/yy = 6
//	var/deg = 0
//	var/t = 0
	var/obj/h = new
	var/turf/trf = locate(m.x,m.y,m.z)
	h.loc = trf
	h.alpha = 0
	things += h
	var/terrain = null
	var/turf/t_usr = m.loc
	if(t_usr.liquid == "water")
		terrain = "water"
		h.plane = -1
	else if(t_usr.liquid == "psionic") terrain = "psionic"
	else if(istype(t_usr,/turf/snows/)) terrain = "snow"
	else if(istype(t_usr,/turf/lava_static)) terrain = "lava"


	// DUST FURROW EFFECT

	create_dusts = 44
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
				var/px = rand(-180,180)
				var/py = rand(-180,180)
				if(px < 32 && px > 0) px = 32
				if(px > -16 && px < 0) px = -16
				if(py < 32 && py > 0) py = 32
				if(py > -16 && py < 0) py = -16
				d.pixel_x = px
				d.pixel_y = py
				animate(d,pixel_x = -10,pixel_y = -6, alpha = 5,time = rand(5,15), loop = -1)
				animate(pixel_x = px,pixel_y = py,alpha = 255, time = 0)
				dusts += d
				break
		sleep(0.1)

	// RAYS GLOW - SHAPESHIFTING EFFECT
	spawn(15)
		overlays.Remove(a)
		var/icon/rev = m.icon
		var/icon/form_preview = m.get_changeling_form_icon(2)
		if(!form_preview)
			form_preview = 'Frieza_3rd_form.dmi'
		rays.icon = 'fx_ray_large.dmi'
		rays.pixel_x = -284
		rays.pixel_y = -284
		rays.loc = m.loc
		rays.step_x = m.step_x
		rays.step_y = m.step_y
		rays.bolted = 2
		rays.layer = m.layer+100
		m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor) // possibly purple? rgb(102,0,204)
		m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
		rays.filters += filter(type="rays",x=0,y=0,size=300,color=rgb(255,255,255),offset=0,density=15,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
		animate(rays.filters[1],offset = 100,time = 1000, loop = -1)
		animate(offset = 0,time = 0)

		o.icon = m.icon
		o.icon_state = m.icon_state
		o.overlays = m.overlays
		o.loc = m.loc
		o.step_x = m.step_x
		o.step_y = m.step_y
		o.bolted = 2
		o.layer = m.layer+1
		animate(o, color = list("#000", "#000", "#000", "#fff"),time=20)
		var/amount=6
		while(amount)
			amount-=1


			m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor) // possibly purple? rgb(102,0,204)
			m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
			o.icon = form_preview
			o.icon_state = ""
			o.overlays = m.overlays
			o.loc = m.loc
			o.step_x = m.step_x
			o.step_y = m.step_y
			o.bolted = 2
			o.layer = m.layer+1
			animate(o, color = list("#000", "#000", "#000", "#fff"),time=20)
			sleep(rand(5,20))
			o.overlays = m.overlays
			o.icon = rev
			o.icon_state = m.icon_state
			o.loc = m.loc
			o.step_x = m.step_x
			o.step_y = m.step_y
			o.bolted = 2
			o.layer = m.layer+1
			animate(o, color = list("#000", "#000", "#000", "#fff"),time=20)
			m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor) // possibly purple? rgb(102,0,204)
			m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
			sleep(rand(2,4))

		//overlays.Remove(a)

		for(var/turf/A in view(10,src))
			A.Rising_Rocks()
		spawn() Super_Lightning()

	// ANIMATE DUST FURROW EFFECT

	for(var/obj/effects/dust/d in disk_dust1)
		animate(d,transform = turn(matrix(),60), time = 5,loop = -1)
		animate(transform = turn(matrix(),120), time = 5)
		animate(transform = null, time = 5)
	for(var/obj/effects/dust/d in disk_dust2)
		animate(d,transform = turn(matrix(),240), time = 5,loop = -1)
		animate(transform = turn(matrix(),120), time = 5)
		animate(transform = null, time = 5)

	spawn(120)
		if(pixs && islist(pixs))
			for(var/obj/v in pixs)
				animate(v)
				v.destroy()
				sleep(0.1)
			pixs = null
		view(15,m) << sound(null, channel = 7)
		m.shockwave_huge()
		locate(m.x,m.y,m.z).explosion(4,0)
		var/obj/effects/shockwave_medium/b = new
		b.pixel_x = -64
		b.pixel_y = -64
		b.loc = h.loc
		b.transform *= 0.1
		animate(b, transform = matrix()*1, alpha = 0, time = 3)
		spawn(3)
			if(b) b.destroy()
		view(15,src) << S
		rays.loc = null
		o.loc = null
		m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
		m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
		if(mob_filter_pos) m.filters -= m.filters[mob_filter_pos]
		if(things && islist(things))
			for(var/obj/v in things)
				v.destroy()
		if(dusts && islist(dusts))
			for(var/obj/v in dusts)
				animate(v)
				animate(v,alpha = 0, pixel_x = -10,pixel_y = -10,time = 10)
				spawn(10)
					if(v)
						v.loc = null
						v.alpha = 255
						v.pixel_y = 0
						v.pixel_x = -20
						v.layer = 3
						v.color = null
						v.icon = initial(v.icon)
						v.plane = initial(v.plane)
						animate(v)
		things = list()
		dusts = list()
		disk_dust1 = list()
		disk_dust2 = list()
		m.stunned -= 1
		m.stunned_pending -= 1
		view(15,m) << SA
		view(15,m) << SP
		m.icon_state = initial(m.icon_state)
		flick("Transform",m)
		spawn(10)
			m.apply_changeling_form_icon(2)
		overlays.Add(a)
		m.transformed = 1
		if(m.has_sf2!=1) m.has_sf2 = 1
		m.Apply_Transformation_Boost(m.race)
		m.transing = 0
		spawn(120)
			SA.repeat = 0
			SP.repeat = 0
			view(15,m) << sound(null, channel = 7)
			view(15,m) << sound(null, channel = 8)
			view(15,m) << sound(null, channel = 9)
			view(15,m) << sound(null, channel = 10)




mob/proc/Changeling_Superform4thForm_Effect()
//	var/progress = 0;
//	var/obj/bar = null
//	var/obj/bar_inner = null
	var/tmp/list/things = list()
	var/tmp/list/dusts = list()
	var/tmp/list/disk_dust1 = list()
	var/tmp/list/disk_dust2 = list()
//	var/tmp/obj/g_ball = null
	//var/tmp/obj/g_rays = null
	var/tmp/list/pixs
	var/tmp/mob_filter_pos = 0
	var/sound/SF = sound('FriezaBegs.ogg')
	SF.channel = 3
	SF.volume = 30
	SF.repeat = 0
	var/sound/S = sound('Power_Control_Stop.wav')
	S.channel = 9
	S.volume = 40
	S.repeat = 0
	var/sound/ST = sound('SuperFly.wav')
	ST.channel=7
	ST.volume = 45
	ST.repeat = 1
	var/sound/SP = sound('Power_Control_Continuous.wav')
	SP.channel=8
	SP.volume = 45
	SP.repeat = 0
	var/sound/SA = sound('Super_Aura.wav')
	SA.channel = 10
	SA.volume = 30
	SA.repeat = 1

	//var/rotation = 0
	var/mob/m = src
	var/obj/o = new
	var/obj/rays = new

	var/obj/effects/aura/a = new
	a.icon *= m.auracolor
	m.stunned += 1
	m.stunned_pending += 1
	for(var/obj/skills/Power_Control/pc in m)
		overlays.Remove(pc.aura)
		pc.aura = a
		pc.sfx = S
		pc.trans3_icon = m.icon


	// INITIAL PARTICLE GLOW EFFECT

	m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
	mob_filter_pos = m.filters.len
	animate(m.filters[m.filters.len], size = 3,offset = 1, time = 15, loop = -1)
	animate(size = -3,offset = -3, time = 15, loop = -1)
	m.step_x = 0
	m.step_y = 0
	m.set_shadow()
	m.icon_state="Superform"
	view(15,m) << ST
	sleep(10)
	overlays.Add(a)
	view(15,m) << sound(null, channel = 1)
	view(15,m) << SF
	var/p = 66
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
		pix.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(255,255,170)) //rgb(255,255,170) white-ish?
		pix.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
		animate(pix,pixel_x = 0, pixel_y = 0, time = rand(10,20), alpha = 255,loop = -1)
		animate(pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = 0, alpha = 0)
		if(pixs && islist(pixs)) pixs += pix
		else pixs = list()
		sleep(0.1)
	p = 66
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
		pix.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=m.auracolor) //rgb(102,0,204) purple hue?
		pix.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
		animate(pix,pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = 10, alpha = 0,loop = -1)
		animate(pixel_x = 0, pixel_y = 0, time = 0, alpha = 255)
		if(pixs && islist(pixs)) pixs += pix
		else pixs = list()
		sleep(0.1)


	//SHOCKWAVE - INITIAL DUST EXPLOSION EFFECT
	spawn for(var/area/A in view(60,src)) A.Super_Darkness()

	var/create_dusts = 66
//	var/xx = 0
//	var/yy = 6
//	var/deg = 0
//	var/t = 0
	var/obj/h = new
	var/turf/trf = locate(m.x,m.y,m.z)
	h.loc = trf
	h.alpha = 0
	things += h
	var/terrain = null
	var/turf/t_usr = m.loc
	if(t_usr.liquid == "water")
		terrain = "water"
		h.plane = -1
	else if(t_usr.liquid == "psionic") terrain = "psionic"
	else if(istype(t_usr,/turf/snows/)) terrain = "snow"
	else if(istype(t_usr,/turf/lava_static)) terrain = "lava"


	// DUST FURROW EFFECT

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
				var/px = rand(-180,180)
				var/py = rand(-180,180)
				if(px < 32 && px > 0) px = 32
				if(px > -16 && px < 0) px = -16
				if(py < 32 && py > 0) py = 32
				if(py > -16 && py < 0) py = -16
				d.pixel_x = px
				d.pixel_y = py
				animate(d,pixel_x = -10,pixel_y = -6, alpha = 5,time = rand(5,15), loop = -1)
				animate(pixel_x = px,pixel_y = py,alpha = 255, time = 0)
				dusts += d
				break
		sleep(0.1)

	// RAYS GLOW - SHAPESHIFTING EFFECT
	spawn(15)
		overlays.Remove(a)
		var/icon/rev = m.icon
		var/icon/form_preview = 'Frieza_4th_form.dmi'
		if(m.race_class == "Cooler")
			switch(m.skin_pos)
				if(2)
					form_preview = 'cooler_4Blue.dmi'
				if(3)
					form_preview = 'cooler_4Green.dmi'
				if(4)
					form_preview = 'cooler_4Orange.dmi'
				if(5)
					form_preview = 'cooler_4Red.dmi'
				else
					form_preview = 'cooler_4.dmi'
		rays.icon = 'fx_ray_large.dmi'
		rays.pixel_x = -284
		rays.pixel_y = -284
		rays.loc = m.loc
		rays.step_x = m.step_x
		rays.step_y = m.step_y
		rays.bolted = 2
		rays.layer = m.layer+100
		m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor) // possibly purple? rgb(102,0,204)
		m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
		rays.filters += filter(type="rays",x=0,y=0,size=300,color=rgb(255,255,255),offset=0,density=15,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
		animate(rays.filters[1],offset = 100,time = 1000, loop = -1)
		animate(offset = 0,time = 0)

		o.icon = m.icon
		o.icon_state = m.icon_state
		o.overlays = m.overlays
		o.loc = m.loc
		o.step_x = m.step_x
		o.step_y = m.step_y
		o.bolted = 2
		o.layer = m.layer+1
		animate(o, color = list("#000", "#000", "#000", "#fff"),time=20)
		var/amount=6
		while(amount)
			amount-=1


			m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor) // possibly purple? rgb(102,0,204)
			m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
			o.icon = form_preview
			o.icon_state = ""
			o.overlays = m.overlays
			o.loc = m.loc
			o.step_x = m.step_x
			o.step_y = m.step_y
			o.bolted = 2
			o.layer = m.layer+1
			animate(o, color = list("#000", "#000", "#000", "#fff"),time=20)
			sleep(rand(5,20))
			o.overlays = m.overlays
			o.icon = rev
			o.icon_state = m.icon_state
			o.loc = m.loc
			o.step_x = m.step_x
			o.step_y = m.step_y
			o.bolted = 2
			o.layer = m.layer+1
			animate(o, color = list("#000", "#000", "#000", "#fff"),time=20)
			m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor) // possibly purple? rgb(102,0,204)
			m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
			sleep(rand(2,4))

		//overlays.Remove(a)

		for(var/turf/A in view(10,src))
			A.Rising_Rocks()
		spawn() Super_Lightning()

	// ANIMATE DUST FURROW EFFECT

	for(var/obj/effects/dust/d in disk_dust1)
		animate(d,transform = turn(matrix(),60), time = 5,loop = -1)
		animate(transform = turn(matrix(),120), time = 5)
		animate(transform = null, time = 5)
	for(var/obj/effects/dust/d in disk_dust2)
		animate(d,transform = turn(matrix(),240), time = 5,loop = -1)
		animate(transform = turn(matrix(),120), time = 5)
		animate(transform = null, time = 5)

	var/icon/form_preview = 'Frieza_4th_form.dmi'
	spawn(120)
		if(pixs && islist(pixs))
			for(var/obj/v in pixs)
				animate(v)
				v.destroy()
				sleep(0.1)
			pixs = null
		view(15,m) << sound(null, channel = 7)
		m.shockwave_huge()
		locate(m.x,m.y,m.z).explosion(6,0)
		var/obj/effects/shockwave_medium/b = new
		b.pixel_x = -64
		b.pixel_y = -64
		b.loc = h.loc
		b.transform *= 0.1
		animate(b, transform = matrix()*1, alpha = 0, time = 3)
		spawn(3)
			if(b) b.destroy()
		view(15,src) << S
		rays.loc = null
		o.loc = null
		m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
		m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
		if(mob_filter_pos) m.filters -= m.filters[mob_filter_pos]
		if(things && islist(things))
			for(var/obj/v in things)
				v.destroy()
		if(dusts && islist(dusts))
			for(var/obj/v in dusts)
				animate(v)
				animate(v,alpha = 0, pixel_x = -10,pixel_y = -10,time = 10)
				spawn(10)
					if(v)
						v.loc = null
						v.alpha = 255
						v.pixel_y = 0
						v.pixel_x = -20
						v.layer = 3
						v.color = null
						v.icon = initial(v.icon)
						v.plane = initial(v.plane)
						animate(v)
		things = list()
		dusts = list()
		disk_dust1 = list()
		disk_dust2 = list()
		m.stunned -= 1
		m.stunned_pending -= 1

		view(15,m) << SA
		view(15,m) << SP
		m.icon_state = initial(m.icon_state)
		flick("Transform",m)
		spawn(10)
			m.apply_changeling_form_icon(3)
		overlays.Add(a)
		m.transformed = 1
		if(m.has_sf3!=1) m.has_sf3 = 1
		m.Apply_Transformation_Boost(m.race)
		m.transing = 0
		spawn(120)
			SA.repeat = 0
			SP.repeat = 0
			//view(15,m) << sound(null, channel = 3)
			view(15,m) << sound(null, channel = 7)
			view(15,m) << sound(null, channel = 8)
			view(15,m) << sound(null, channel = 9)
			view(15,m) << sound(null, channel = 10)



mob/proc/Changeling_Superform5thForm_Effect()
//	var/progress = 0;
//	var/obj/bar = null
//	var/obj/bar_inner = null
	var/tmp/list/things = list()
	var/tmp/list/dusts = list()
	var/tmp/list/disk_dust1 = list()
	var/tmp/list/disk_dust2 = list()
//	var/tmp/obj/g_ball = null
	//var/tmp/obj/g_rays = null
	var/tmp/list/pixs
	var/tmp/mob_filter_pos = 0
	var/sound/SF = sound('KameSad.ogg')
	SF.channel = 3
	SF.volume = 25
	SF.repeat = 0
	var/sound/S = sound('Power_Control_Stop.wav')
	S.channel = 9
	S.volume = 40
	S.repeat = 0
	var/sound/ST = sound('SuperFly.wav')
	ST.channel=7
	ST.volume = 45
	ST.repeat = 1
	var/sound/SP = sound('Power_Control_Continuous.wav')
	SP.channel=8
	SP.volume = 45
	SP.repeat = 0
	var/sound/SA = sound('Super_Aura.wav')
	SA.channel = 10
	SA.volume = 30
	SA.repeat = 1

//	var/rotation = 0
	var/mob/m = src
	var/obj/o = new
	var/obj/rays = new
	for(var/obj/skills/Power_Control/pc in m)
		overlays.Remove(pc.aura)

	var/obj/effects/aura/a = new
	a.icon *= m.auracolor
	m.stunned += 1
	m.stunned_pending += 1
	view(15,m) << SF

	// INITIAL PARTICLE GLOW EFFECT

	m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(0,0,0))
	mob_filter_pos = m.filters.len
	animate(m.filters[m.filters.len], size = 3,offset = 1, time = 15, loop = -1)
	animate(size = -3,offset = -3, time = 15, loop = -1)
	m.step_x = 0
	m.step_y = 0
	m.set_shadow()
	m.icon_state="Superform"
	view(15,m) << ST
	sleep(10)
	overlays.Add(a)


	var/p = 11
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
		pix.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=rgb(255,255,170)) //rgb(255,255,170) white-ish?
		pix.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
		animate(pix,pixel_x = 0, pixel_y = 0, time = rand(10,20), alpha = 255,loop = -1)
		animate(pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = 0, alpha = 0)
		if(pixs && islist(pixs)) pixs += pix
		else pixs = list()
		sleep(0.1)
	p = 66
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
		pix.filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=1, color=m.auracolor) //rgb(102,0,204) purple hue?
		pix.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
		animate(pix,pixel_x = rand(-200,200), pixel_y = rand(-200,200), time = rand(10,20), alpha = 0,loop = -1)
		animate(pixel_x = 0, pixel_y = 0, time = 0, alpha = 255)
		if(pixs && islist(pixs)) pixs += pix
		else pixs = list()
		sleep(0.1)


	//SHOCKWAVE - INITIAL DUST EXPLOSION EFFECT
	spawn for(var/area/A in view(60,src)) A.Super_Darkness()

	var/create_dusts = 66
//	var/xx = 0
//	var/yy = 6
	//var/deg = 0
//	var/t = 0
	var/obj/h = new
	var/turf/trf = locate(m.x,m.y,m.z)
	h.loc = trf
	h.alpha = 0
	things += h
	var/terrain = null
	var/turf/t_usr = m.loc
	if(t_usr.liquid == "water")
		terrain = "water"
		h.plane = -1
	else if(t_usr.liquid == "psionic") terrain = "psionic"
	else if(istype(t_usr,/turf/snows/)) terrain = "snow"
	else if(istype(t_usr,/turf/lava_static)) terrain = "lava"


	// DUST FURROW EFFECT

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
				var/px = rand(-180,180)
				var/py = rand(-180,180)
				if(px < 32 && px > 0) px = 32
				if(px > -16 && px < 0) px = -16
				if(py < 32 && py > 0) py = 32
				if(py > -16 && py < 0) py = -16
				d.pixel_x = px
				d.pixel_y = py
				animate(d,pixel_x = -10,pixel_y = -6, alpha = 5,time = rand(5,15), loop = -1)
				animate(pixel_x = px,pixel_y = py,alpha = 255, time = 0)
				dusts += d
				break
		sleep(0.1)

	// RAYS GLOW - SHAPESHIFTING EFFECT
	spawn(15)
		overlays.Remove(a)
		var/icon/rev = m.icon
		var/icon/form_preview = m.get_changeling_form_icon(4)
		if(!form_preview)
			form_preview = 'cooler_5.dmi'
		rays.icon = 'fx_ray_large.dmi'
		rays.pixel_x = -284
		rays.pixel_y = -284
		rays.loc = m.loc
		rays.step_x = m.step_x
		rays.step_y = m.step_y
		rays.bolted = 2
		rays.layer = m.layer+100
		m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor) // possibly purple? rgb(102,0,204)
		m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
		rays.filters += filter(type="rays",x=0,y=0,size=300,color=rgb(255,255,255),offset=0,density=15,threshold=0.5,factor=0,flags=FILTER_OVERLAY)
		animate(rays.filters[1],offset = 100,time = 1000, loop = -1)
		animate(offset = 0,time = 0)


		o.icon = m.icon
		o.icon_state = m.icon_state
		o.overlays = m.overlays
		o.loc = m.loc
		o.step_x = m.step_x
		o.step_y = m.step_y
		o.bolted = 2
		o.layer = m.layer+1
		animate(o, color = list("#000", "#000", "#000", "#fff"),time=30)
		var/amount=6
		while(amount)
			amount-=1


			m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor) // possibly purple? rgb(102,0,204)
			m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
			o.icon = form_preview
			o.icon_state = ""
			o.overlays = m.overlays
			o.loc = m.loc
			o.step_x = m.step_x
			o.step_y = m.step_y
			o.bolted = 2
			o.layer = m.layer+1
			animate(o, color = list("#000", "#000", "#000", "#fff"),time=20)
			sleep(rand(5,20))
			o.overlays = m.overlays
			o.icon = rev
			o.icon_state = m.icon_state
			o.loc = m.loc
			o.step_x = m.step_x
			o.step_y = m.step_y
			o.bolted = 2
			o.layer = m.layer+1
			animate(o, color = list("#000", "#000", "#000", "#fff"),time=20)
			m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor) // possibly purple? rgb(102,0,204)
			m.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
			sleep(rand(2,4))

		//overlays.Remove(a)

		for(var/turf/A in view(10,src))
			A.Rising_Rocks()
		spawn() Super_Lightning()

	// ANIMATE DUST FURROW EFFECT

	for(var/obj/effects/dust/d in disk_dust1)
		animate(d,transform = turn(matrix(),60), time = 5,loop = -1)
		animate(transform = turn(matrix(),120), time = 5)
		animate(transform = null, time = 5)
	for(var/obj/effects/dust/d in disk_dust2)
		animate(d,transform = turn(matrix(),240), time = 5,loop = -1)
		animate(transform = turn(matrix(),120), time = 5)
		animate(transform = null, time = 5)

	spawn(120)
		if(pixs && islist(pixs))
			for(var/obj/v in pixs)
				animate(v)
				v.destroy()
				sleep(0.1)
			pixs = null
		view(15,m) << sound(null, channel = 7)
		m.shockwave_huge()
		locate(m.x,m.y,m.z).explosion(6,0)
		var/obj/effects/shockwave_medium/b = new
		b.pixel_x = -64
		b.pixel_y = -64
		b.loc = h.loc
		b.transform *= 0.1
		animate(b, transform = matrix()*1, alpha = 0, time = 8)
		spawn(4)
			if(b) b.destroy()
		view(15,src) << S
		rays.loc = null
		o.loc = null
		m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(102,0,204))
		m.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=m.auracolor)
		if(mob_filter_pos) m.filters -= m.filters[mob_filter_pos]
		if(things && islist(things))
			for(var/obj/v in things)
				v.destroy()
		if(dusts && islist(dusts))
			for(var/obj/v in dusts)
				animate(v)
				animate(v,alpha = 0, pixel_x = -10,pixel_y = -10,time = 10)
				spawn(10)
					if(v)
						v.loc = null
						v.alpha = 255
						v.pixel_y = 0
						v.pixel_x = -20
						v.layer = 3
						v.color = null
						v.icon = initial(v.icon)
						v.plane = initial(v.plane)
						animate(v)
		things = list()
		dusts = list()
		disk_dust1 = list()
		disk_dust2 = list()
		m.stunned -= 1
		m.stunned_pending -= 1
		for(var/obj/skills/Power_Control/pc in m)
			pc.aura = a
			pc.sfx = S
			pc.trans4_icon = m.icon
		view(15,m) << SA
		view(15,m) << SP
		m.icon_state = initial(m.icon_state)
		flick("Transform",m)
		spawn(10)
			m.apply_changeling_form_icon(4)
		overlays.Add(a)
		m.transformed = 1
		if(m.has_sf4!=1) m.has_sf4 = 1
		m.Apply_Transformation_Boost(m.race)
		m.transing = 0
		spawn(120)
			SA.repeat = 0
			SP.repeat = 0
			view(15,m) << sound(null, channel = 3)
			view(15,m) << sound(null, channel = 7)
			view(15,m) << sound(null, channel = 8)
			view(15,m) << sound(null, channel = 9)
			view(15,m) << sound(null, channel = 10)
		for(var/obj/skills/Power_Control/pc in m)
			pc.aura = a
			pc.sfx = S
			pc.trans5_icon = m.icon





area/proc/Super_Darkness()
	var/A=icon
	//var/P=plane
	icon='Weather.dmi'
	icon_state="Super Darkness"
	plane=0
	spawn(122)
		if(src)
			icon=A
			icon_state=null

area/proc/Super_LSDarkness()
	var/A=icon
	icon='Weather.dmi'
	icon_state="Super LSDarkness"
	spawn(60) if(src)
		icon=A
		icon_state=null
mob/proc/Super_DBLightning(var/Amount=10)
	var/list/Locs=new
	for(var/turf/B in range(20,src)) Locs+=B
	while(Amount)
		Amount-=1
		var/obj/effects/lightning_bolt/A=new
		A.loc=pick(Locs)
		sleep(rand(1,20))
mob/proc/Super_Lightning(var/Amount=10)
	var/list/Locs=new
	for(var/turf/B in range(20,src)) Locs+=B
	while(Amount)
		Amount-=1
		var/obj/effects/lightning_bolt/A=new
		A.loc=pick(Locs)
		sleep(rand(1,20))
mob/proc/Super_Lightning2(var/Amount=15)
	var/list/Locs=new
	var/list/Locs2=new
	for(var/turf/B in range(20,src)) Locs+=B
	for(var/turf/E in range(4,src)) Locs2=E
	while(Amount)
		Amount-=1
		var/obj/effects/lightning_bolt/A=new
		A.loc=pick(Locs)
		var/obj/effects/lightning_bolt/C=new
		C.loc=pick(Locs2)
		if(prob(50))
			var/obj/crackground/G=new
			G.loc=C.loc
		sleep(rand(1,50))
turf/proc/Rising_Rocks()
	if(usr.psionic_power>10000)
		if(prob(50))
			overlays-='Rising Rocks.dmi'
			overlays+='Rising Rocks.dmi'
		spawn(rand(100,130)) if(src.overlays && src) overlays-='Rising Rocks.dmi'
obj/crackground
	icon='crack_ground.dmi'
	can_pocket = 0
	bolted = 2
	//pixel_y=-30
	layer=9
	New()
		if(src.z==0) src.loc=null
		for(var/obj/crackground/A in view(3,src)) if(A!=src) src.loc=null
		spawn(1200) if(src) src.loc = null

obj/Auras_Special

	SuperAura
		alpha=80
		icon = 'DBG_AuraTaller (1).dmi'
		icon_state = "Different SN Aura"
		layer=10
	SuperNamek
		alpha=175
		icon = 'DBG_AuraTaller (1).dmi'
		icon_state = "Super Namekian Aura"
		layer=10
	SuperDemon
		icon = 'DBG_AuraTaller (1).dmi'
		icon_state = "GoD Flow"
		layer=10
	SuperKai
		icon = 'DBG_AuraTaller (1).dmi'
		icon_state = "Super Kai Aura"
		layer=10

	SuperMakyo
		alpha=175
		icon='DBG_AuraTaller (1).dmi'
		icon_state="Makyo Aura"
		layer=10

	GIJI
		icon = 'GijiAura.dmi'
		icon_state="Giji"
		layer=10
		pixel_x=-16
	SSJ1
		icon = 'SSJ1AuraNew.dmi'
		icon_state = "SSJ"
		layer=10
		pixel_x=-16