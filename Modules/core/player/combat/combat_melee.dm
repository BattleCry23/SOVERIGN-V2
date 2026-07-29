/// Finds a mob in front of the attacker, within attack range.
/// Returns the mob if found, otherwise null.
mob/proc/find_facing_target(range)
    if (!src || src.koed || src.stunned) return null

    var/mob/best_target = null
    var/min_dist = range

    // Loop through nearby mobs within attack range
    for (var/mob/M in oview(src, range))
        if (M == src) continue
        if (!M.can_harm) continue
        if (M.z != src.z) continue

        // Check if mob is in front (directional check)
        var/dir_to_mob = get_dir(src, M)
        if (!(dir_to_mob & src.dir))
            continue

        // Now check actual pixel distance
        var/dist = bounds_dist(src, M)
        if (dist <= range && dist < min_dist)
            best_target = M
            min_dist = dist

    return best_target
mob/proc/find_facing_object(range)
	if (!src || src.koed || src.stunned) return null

	var/obj/best_target = null
	var/min_dist = range

	// Loop through objects in attack range
	for (var/obj/items/O in oview(src, range))
		if (O.invisibility || O.invul_melee) continue
		if (O.z != src.z) continue

		var/dir_to_obj = get_dir(src, O)
		if (!(dir_to_obj & src.dir)) continue

		var/dist = bounds_dist(src, O)
		if (dist <= range && dist < min_dist)
			best_target = O
			min_dist = dist

	return best_target
proc/handle_energy_deflection(mob/M, edeflection, damage, var/mob/opp)
	if (opp.Edeflection_skill && prob(edeflection * 1.2))
		switch(rand(1,4))
			if(1)
				if((M.offence + M.force / 100) * 0.5 >= edeflection)
					return 0
				else
					if(prob(40))
						return 0
					else
						return 1
			if(2)
				return 1
			if(3)
				if((M.offence + M.force / 100) * 0.5 >= edeflection)
					return 0
				else
					if(prob(40))
						return 1
					else
						return 0
			if(4)
				return 1
proc/handle_deflection(mob/M, deflection, damage, var/mob/opp)
	if (opp.deflection_skill && prob(deflection * 1.2))
		switch(rand(1,4))
			if(1)
				if((M.defence + M.resistance / 100) * 0.5 >= deflection)
					return 0
				else
					if(prob(40))
						return 0
					else
						return 1
			if(2)
				return 1
			if(3)
				if((M.defence + M.resistance / 100) * 0.5 >= deflection)
					return 0
				else
					if(prob(40))
						return 1
					else
						return 0
			if(4)
				return 1
proc/handle_blocking(mob/M, damage, var/mob/opp)
	if (opp.icon_state == "Block")
		switch(rand(1,4))
			if(1)
				if((M.defence + M.endurance / 100) * 0.5 >= (damage*10))
					return 0
				else
					if(prob(40))
						return 0
					else
						return 1
			if(2)
				return 1
			if(3)
				if((M.defence + M.endurance / 100) * 0.5 >= (damage*10))
					return 0
				else
					if(prob(40))
						return 1
					else
						return 0
			if(4)
				return 1

mob
	verb
		Button_Attack()
			set popup_menu = 0
			set hidden = 1
			usr.attack_state = "melee"

	proc
		set_dir(var/d)
			//Sets the mobs direction based on another mob, so they face them
			if(d == 0) src.dir = WEST
			if(d == 45) src.dir = NORTHWEST
			if(d == 90) src.dir = NORTH
			if(d == 135) src.dir = NORTHEAST
			if(d == 180) src.dir = EAST
			if(d == 225) src.dir = SOUTHEAST
			if(d == 270) src.dir = SOUTH
			if(d == 315) src.dir = SOUTHWEST
		/*evasion(var/mob/attacker,var/mob/defender)
			var/Evasion=(attacker.psionic_power*(attacker.offence+(attacker.mod_agility*0.2)))/(defender.psionic_power*(defender.defence+(defender.mod_agility*0.22)))
			if(attacker.sword_pl > 0 ) Evasion -= clamp(attacker.sword_pl,0.0001)
			if(attacker.axe_pl > 0 ) Evasion += clamp(attacker.axe_pl,0.0001)
			if(attacker.hammer_pl > 0 ) Evasion += clamp(attacker.hammer_pl,0.001)
			if(defender.koed == 0 && defender.stunned == 0) if(!prob(Evasion*33))
				flick('dodge.dmi',defender)
				//for(var/mob/h in view(8,defender))
					//h << sound(pick(dodges),0,0,2,100)
				if(defender.target == attacker)
					if(!defender.remembers_offence.Find(attacker.id)) defender.remembers_offence += attacker.id
				if(attacker.target == defender)
					if(!attacker.remembers_defence.Find(defender.id)) attacker.remembers_defence += defender.id
				return 1 //1 sucessful dodge
			return 0 */
		calc_weapon_boost(var/weapon_pl, var/stance_level)
			if(weapon_pl <= 0 || stance_level <= 0)
				return 0
			var/percent = min(stance_level, 100) / 100 // 0.01 to 1
			return weapon_pl * percent

		evasion(var/mob/attacker, var/mob/defender)
			var/Evasion = (attacker.psionic_power * (attacker.offence + (attacker.mod_agility * 0.2))) / \
						  (defender.psionic_power * (defender.defence + (defender.mod_agility * 0.2)))

			// Sword stance logic - boosts Evasion *OR* Offence (we'll apply to Offence here)
			if(attacker.sword_pl > 0)
				var/boost = calc_weapon_boost(attacker.sword_pl, attacker.weapon_stance)
				Evasion *= 1 + (boost / 100) // up to 1.25x multiplier

			// Axe penalty - -Offence (which affects Evasion denominator)
			if(attacker.axe_pl > 0)
				var/penalty = calc_weapon_boost(attacker.axe_pl, attacker.weapon_stance)
				Evasion *= 1 - min(penalty / 100, 0.99)

			// Hammer penalty - -Defence for the defender (Evasion denominator increases)
			if(defender.hammer_pl > 0)
				var/penalty = calc_weapon_boost(defender.hammer_pl, defender.weapon_stance)
				Evasion *= 1 + (penalty / 100)

			// Check dodge
			if(defender.koed == 0 && defender.stunned == 0)
				switch(rand(1,8))
					if(1)
						if(!prob(Evasion * 33))
							flick('dodge.dmi', defender)
							if(defender.target == attacker && !defender.remembers_offence.Find(attacker.id))
								defender.remembers_offence += attacker.id
							if(attacker.target == defender && !attacker.remembers_defence.Find(defender.id))
								attacker.remembers_defence += defender.id
							return 1
					if(2)
						if(!prob(Evasion * 44))
							flick('dodge.dmi', defender)
							if(defender.target == attacker && !defender.remembers_offence.Find(attacker.id))
								defender.remembers_offence += attacker.id
							if(attacker.target == defender && !attacker.remembers_defence.Find(defender.id))
								attacker.remembers_defence += defender.id
							return 1
					if(3)
						if(!prob(Evasion * 33))
							flick('dodge.dmi', defender)
							if(defender.target == attacker && !defender.remembers_offence.Find(attacker.id))
								defender.remembers_offence += attacker.id
							if(attacker.target == defender && !attacker.remembers_defence.Find(defender.id))
								attacker.remembers_defence += defender.id
							return 1
					if(4)
						if(!prob(Evasion * 33))
							flick('dodge.dmi', defender)
							if(defender.target == attacker && !defender.remembers_offence.Find(attacker.id))
								defender.remembers_offence += attacker.id
							if(attacker.target == defender && !attacker.remembers_defence.Find(defender.id))
								attacker.remembers_defence += defender.id
							return 1
					if(5)
						if(!prob(Evasion * 11))
							flick('dodge.dmi', defender)
							if(defender.target == attacker && !defender.remembers_offence.Find(attacker.id))
								defender.remembers_offence += attacker.id
							if(attacker.target == defender && !attacker.remembers_defence.Find(defender.id))
								attacker.remembers_defence += defender.id
							return 1
					if(6)
						if(!prob(Evasion))
							flick('dodge.dmi', defender)
							if(defender.target == attacker && !defender.remembers_offence.Find(attacker.id))
								defender.remembers_offence += attacker.id
							if(attacker.target == defender && !attacker.remembers_defence.Find(defender.id))
								attacker.remembers_defence += defender.id
							return 1
					if(7)
						if(!prob(Evasion * 33))
							flick('dodge.dmi', defender)
							if(defender.target == attacker && !defender.remembers_offence.Find(attacker.id))
								defender.remembers_offence += attacker.id
							if(attacker.target == defender && !attacker.remembers_defence.Find(defender.id))
								attacker.remembers_defence += defender.id
							return 1
					if(8)
						if(!prob(Evasion * 33))
							flick('dodge.dmi', defender)
							if(defender.target == attacker && !defender.remembers_offence.Find(attacker.id))
								defender.remembers_offence += attacker.id
							if(attacker.target == defender && !attacker.remembers_defence.Find(defender.id))
								attacker.remembers_defence += defender.id
							return 1
			return 0

		speed_image_reverse(var/turf/start,var/s_step_x,var/s_step_y,var/s_step_z)
			var/obj/img = new
			img.density_factor = 0
			img.density = 0
			img.loc = src.loc
			img.step_x = src.step_x
			img.step_y = src.step_y
			img.pixel_z = s_step_z
			img.dir = src.dir
			var/a = 130
			var/steps = 0
			var/ang = img.GetAngleStep(start)
			var/b_dist = round(bounds_dist(start,src))
			var/steps_total = round(b_dist/8)
			//var/sound/s = sound(pick(speed),0,0,12,100)
			//for(var/mob/h in view(8,src))
				//h << s
			while(b_dist > 0)
				a -= 1
				img.MoveAng(ang,8,0,0,src)
				steps += 1
				b_dist -= 8
				if(steps > 160)
					img.loc = null
					return
				for(var/obj/effects/after_image/af in src.afterimages)
					if(af.in_use == 0)
						af.loc = img.loc
						af.in_use = 1;
						af.icon = src.icon
						af.icon_state = src.icon_state
						af.overlays = src.overlays
						af.alpha = a
						af.step_x = img.step_x
						af.step_y = img.step_y
						af.pixel_z = img.pixel_z
						af.dir = src.dir
						spawn(steps_total/8)
							if(af)
								af.in_use = 0;
								af.loc = null
								af.pixel_z = 0
								af.alpha = 130
						steps_total -= 1
						break;
				sleep(0.1)
			//world << "DEBUG - steps total = [steps_total]"
			img.loc = null
		speed_image(var/atom/target,var/time = 2)
			if(src.skill_super_speed.using == 0)
				src.skill_super_speed.using = 1
				var/ds = src.density_factor
				src.density_factor = 0
				src.appearance_flags = LONG_GLIDE | KEEP_TOGETHER
				var/a = 50
				//if(ismovable(target)) times = 4.5
				var/steps = (get_dist(src,target)*5)
				//steps += 2
				//var/steps = bounds_dist(src,target)
				//src << output("[src] and [target] are [steps] pixels away from one another. This would take [round(steps/8)] steps to reach.","chat.system")
				//steps = round(steps/8)
				var/steps_max = steps
				src.filters += filter(type="motion_blur", x=1, y=0)
				//src.icon_state = "super speed"
				var/ang = src.GetAngleStep(target)
				src.dir = get_dir(src,target) //Was inside the while() statement, maybe move back if looks bad?
				//var/sound/s = sound(pick(speed),0,0,12,100)
				//for(var/mob/h in view(8,src))
					//h << s
				while(steps > 0)
					steps -= 1
					for(var/obj/effects/after_image/af in src.afterimages)
						if(af.in_use == 0)
							af.loc = src.loc
							af.in_use = 1;
							af.icon_state = src.icon_state
							af.overlays = src.overlays
							af.alpha = a
							af.step_x = src.step_x
							af.step_y = src.step_y
							//af.dir = get_dir(src,target)
							af.dir = src.dir
							spawn((steps_max/10) - (steps/10))
								if(af)
									af.in_use = 0;
									af.loc = null
							break;
					a += 1
					var/xx = src.step_x
					var/yy = src.step_y
					src.MoveAng(ang,8,0,0,target)
					if(src.step_x == xx && src.step_y == yy)
						steps = 0
						src << output("Aborted super speed movement for [src], ran into solid.","chat.system")
					if(bounds_dist(src,target) <= -0) steps = 0
					//sleep(0.2)
				src.density_factor = ds
				spawn(time)
					if(src)
						src.filters -= filter(type="motion_blur", x=1, y=0)
						//src.appearance_flags = null
						src.skill_super_speed.using = 0
						src.icon_state = src.state()



		damage_limb(var/mob/attacker,var/random = 1, var/show_msg = 1, var/Damage = 0.1,var/obj/limb)

			if(!src.hurt_limbs)
				src.hurt_limbs = list()

			if(random)
				var/obj/body_related/bodyparts/L = pick(src.body)
				L.hp -= Damage

				if(!src.hurt_limbs.Find(L))
					src.hurt_limbs += L

				if(L.hp <= 0 && !L.broken)
					L.hp = 0
					view(15,src)<<output("[src]'s [L.name] was broken!","actionoutput")
					L.broken=1
					//src.damage_part(L,1,"Broken",show_msg)

			else if(limb)
				limb.hp -= Damage
				if(limb.hp <= 0)
					limb.hp = 0

			src.update_limb_hud()

			if(src.hud_body)
				src.hud_body.color_paperdoll(src)
		/*damage_limb(var/mob/attacker,var/random = 1, var/show_msg = 1, var/Damage = 0.1,var/obj/limb)
			if(!src.hurt_limbs)
				src.hurt_limbs = list()
			for(var/obj/body_related/bodyparts/b in src.body)
				world << "[b] hp_max: [b.hp_max]"
			if(random)
				world<<" Test Random Limb"
				if(length(src.body) > 0)

					if(length(src.body) > 0)
						var/obj/body_related/part = pick(src.body)
						part.hp -= Damage

						if(!src.hurt_limbs.Find(part))
							src.hurt_limbs += part

						if(part.hp <= 0)
							part.hp = 0
							src.damage_part(part,1,"Broken",show_msg)
						if(attacker.srs_mode && attacker.spar_mode && attacker.client || (attacker.strength + attacker.psionic_power) > (src.psionic_power + src.endurance) * 5  ) check_maim_limb(attacker, part, src)

						src.update_limb_hud()

					/*var/obj/body_related/part = pick(src.body)
					if(length(part.contents) > 0)
						var/obj/body_related/hit_part = pick(part.contents)
						hit_part.hp -= Damage
						world<<"Test Limb Check: [hit_part] health: [hit_part.hp]"
						if(src.hurt_limbs == null || islist(src.hurt_limbs) == 0) src.hurt_limbs = list()
						if(!src.hurt_limbs.Find(hit_part)) src.hurt_limbs += hit_part
						//Part is damaged or broken, so now it needs time to heal.
						if(hit_part.hp <= 0 )
							var/msg = "Damaged"
							if(hit_part.bodypart_type == "Bone") msg = "Broken"
							hit_part.hp = 0
							src.damage_part(hit_part,1,msg,show_msg)*/



							//If its a bone, find all the parts connected to it and disable them also.
							//if(hit_part.bodypart_type == "Bone")
							//	var/list/extensions = list()
							//	for(var/obj/body_related/p in part)
							//		if(p.part_hierarchy < hit_part.part_hierarchy)
							//			extensions += p
							//	src.disable_parts(extensions,0,1,show_msg,"[msg]:<font color = red> [hit_part]")
						/*if(src.client)
						//	if(show_msg) src << output("Hit by [attacker] in the [part], hurting your [hit_part] for [round(Damage*2,0.1)]%","actionoutput")
							if(hit_part == src.part_selected)
								var/hud_id = get_limb_hud_id(hit_part) // Write this function
								winset(src, hud_id, "value=[round(hit_part.hp / hit_part.hp_max * 100)]")
								//winset(src,"body.bar_hp","value=[hit_part.hp]")
							src.update_limb_hud() */


					//	if(show_msg && attacker.client) attacker << output("Hit [src] in the [part], hurting their [hit_part] for [round(Damage*2,0.1)]%","chat.system")
			else if(limb)
				limb.hp -= Damage
				world<<" Test Damage Limb - [limb]"
				if(!src.hurt_limbs.Find(limb)) src.hurt_limbs += limb
				//Part is damaged or broken, so now it needs time to heal.
				var/msg = "Damaged"
				if(limb.hp <= 0)
					msg = "Broken"
					src.damage_part(limb,1,msg,show_msg)
				//	var/msg = "Damaged"
				//	if(limb.bodypart_type == "Bone") msg = "Broken"
					limb.hp = 0
				src.update_limb_hud()
				world<<" Test Damage Limb Updated: [limb.hp] Health"


				//	src.damage_part(limb,1,msg,show_msg)
				//	if(limb.bodypart_type == "Bone")
					//	view(15,attacker)<< output("[src]'s [limb] broke","actionoutput")
					//If its a bone, find all the parts connected to it and disable them also.
					//if(limb.bodypart_type == "Bone")
					//	var/list/extensions = list()
						//for(var/obj/body_related/p in limb.loc)
						//	if(p.part_hierarchy < limb.part_hierarchy)
						//		extensions += p
						//src.disable_parts(extensions,0,1,show_msg,"[msg]:<font color = red> [limb]")
				//if(src.client)
					//if(show_msg) src << output("Hit by [attacker] in the [limb.loc], hurting your [limb] for [round(Damage*2,0.1)]%","chat.system")
				//	if(limb == src.part_selected)
						//winset(src,"body.bar_hp","value=[limb.hp]")
					//	var/hud_id = get_limb_hud_id(limb) // Write this function
					//	winset(src, hud_id, "value=[round(limb.hp / limb.hp_max * 100)]")
				//	src.update_limb_hud()
					//winset(src, hud_id, "value=[round(part.hp / part.hp_max * 100)]")
				//if(show_msg && attacker && attacker.client) attacker << output("Hit [src] in the [limb.loc], hurting their [limb] for [round(Damage*2,0.1)]%","chat.system")
			if(src.hud_body) src.hud_body.color_paperdoll(src)



			*/











		ReDie(var/mob/caster)
			if(src.eating) src.cancel_eat()
			src.letgo()
			src.dead = 1;
			src.disable_skills()
			src.clear_drugs()
			src.energy = 1
			src.percent_health = 1
			for(var/mob/m in players)
				if(m.target == src) m.add_remove_target(src,1)
			//src.KB_furrow = 0;
			//src.icon_state = src.state()
			if(src.charging)
				var/obj/ranged/c = src.charging
				c.remove()
				src.charging = null
			var/chance = 100
			if(src.trait_ur) chance = 50

			if(prob(chance))
				view(10,src)<<output("[src.real_name]'s was returned to the dead!","actionoutput")
				if(src.grabbed_by)
					var/mob/X = src.grabbed_by
					X.letgo()
				var/turf/t = src.loc
				//Create the body
				if(src.has_body)
					var/obj/items/misc/body/b = new
					var/obj/i=new
					i.icon='deathblood.dmi'
					b.appearance = src.appearance
					b.loc = src.loc
					b.step_x = src.step_x
					b.step_y = src.step_y
					b.icon_state = "KO"
					b.owner = src
					b.dir = src.dir
					b.name = "[src.real_name]'s corpse"
					i.dir = b.dir
					b.overlays+=i
					items += b
					b.hp = src.psionic_power*src.endurance

				//Drop cybertech
				src.drop_cybertech()
				//Drop items

				//if(src.keep_body == 0) src.has_body = 0;
				src.has_body = 0;
				src.alpha = 130;
				if(src.client)
					if(src.shadow) src.shadow.loc = null
					var/mob/clone = null;
					var/obj/stone = null
					for(var/obj/items/consumables/spirit_stone/i in items)
						if(i.fused_name == src.real_name && i.fused_key == src.key && i.fused_id == src.id)
							stone = i
							break
					for(var/mob/m in world)
						for(var/i in src.clones)
							//world << output("Debug - Found clone id [i].", "chat.system")
						//if(m.id in src.clones)
							if(i == m.id && m.being_grown == 0)
								//world << output("Debug - Found clone.", "chat.system")
								clone = m
								break;
					/*
					if(src.vat)
						var/obj/items/tech/Vat/v = src.vat
						if(v.set_for == src.id) clone = v
					*/
					if(clone)
						src.loc = clone.loc
						src.step_x = clone.step_x
						src.step_y = clone.step_y//+14
						src.dead = 0;
						src.has_body = 1
						src.icon_state = "Meditate"
						src.copy_mob_genetics(clone,0,0,0,0,"copy clone")
						clone.give_extra_organs(null,src)
						clone.vat.set_for = null
						clone.vat.in_use = null;
						clone.vat.growth_percent = 0
						clone.vat = null
						//del(clone)
						//src.layer = clone.layer + 1;
						//src.transform = matrix()*0.1
						//src.stunned += 1
						//src.being_cloned = 1;
					else if(caster.online||caster)
						src.loc = locate(caster.x,caster.y-1,caster.z)
						if(src.map_blip)
							src.map_blip.pixel_x = src.x-3
							src.map_blip.pixel_y = src.y-3
						src.step_x = caster.step_x
						src.step_y = caster.step_y
						src.dead = 0;
						//src.has_body = 1
						if(!src.halo) src.halo = 'newhalo.dmi'
						src.overlays += src.halo
						src.alpha = 130
						for(var/obj/body_related/bodyparts/b in src.body)
							for(var/obj/body_related/bodyparts/o in b)
								src.damage_limb(src,0, 0, 100,o)
						if(src.skill_meditation) call(src.skill_meditation.act)(src,src.skill_meditation)
					else if(stone)
						src.loc = locate(stone.x,stone.y-1,stone.z)
						if(src.map_blip)
							src.map_blip.pixel_x = src.x-3
							src.map_blip.pixel_y = src.y-3
						src.step_x = stone.step_x
						src.step_y = stone.step_y
						src.dead = 0;
						//src.has_body = 1
						if(!src.halo) src.halo = 'newhalo.dmi'
						src.overlays += src.halo
						src.alpha = 130
						for(var/obj/body_related/bodyparts/b in src.body)
							for(var/obj/body_related/bodyparts/o in b)
								src.damage_limb(src,0, 0, 100,o)
						if(src.skill_meditation) call(src.skill_meditation.act)(src,src.skill_meditation)
					else
						if(src.debuff_dead && src.debuff_dead.active == 0) call(src.debuff_dead.act)(src,src.debuff_dead)
						src.loc = locate(418,49,2)
						if(src.map_blip)
							src.map_blip.pixel_x = src.x-3
							src.map_blip.pixel_y = src.y-3
						src.step_x = 0;
						src.step_y = 0;
						src.in_oldage = 0
						src.vigour = 100
						src.apply_afterlife_glow(1)
						if(!src.halo) src.halo = 'newhalo.dmi'
						src.overlays += src.halo
						src.alpha = 130
						//if(already_dead == 0) src.disable_parts(null,1,1,1,"Death")
					src.client.perspective = EYE_PERSPECTIVE | EDGE_PERSPECTIVE
					src.client.eye = t
					src.screen_text.maptext = "<font size = 3><center>You have died. However this is not the end for you. If you feel like you your death was done in foul play, please gather any evidence and collectives you need and send them to an admin! If you plan to dispute your death, please pause your IC until an admin gives a decision."
					animate(src.screen_text,alpha = 255,time = 120)
					src<<"<font color=red>You have died. However this is not the end for you. If you feel like you your death was done in foul play, please gather any evidence and collectives you need and send them to an admin! If you plan to dispute your death, please pause your IC until an admin gives a decision.</font>"

					//winset(src,null,"stats_other.label_dead.text=\"Dead: Yes\"")
					//winset(src,null,"stats_other.label_has_body.text=\"Has Body: No\"")
					sleep(60)
					if(src) animate(src.vision,alpha = 255,time = 30)
					sleep(30)
					if(src)
						src.client.perspective = MOB_PERSPECTIVE | EDGE_PERSPECTIVE //initial(src.client.perspective)
						src.client.eye = src
						src.screen_text.alpha = 0;
						src.dir = SOUTH
						animate(src.vision,alpha = 0,time = 30)
						animate(src,alpha = 200,time = 10)
						if(clone == null && stone == null)
							src.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=src.auracolor)
							src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=src.auracolor)
						else
							src.alpha = 130
							clone.loc=null
							clone.contents=null
						/*
						else
							animate(transform = matrix()*1,time = 600)
							src.cloning()
						*/
				else src.loc = null
		Death(var/reason,var/make_body = 1)
			//src.KB = 0;

			if(!src.koed) return

			if(src.eating) src.cancel_eat()
			src.letgo()
			src.dead = 1;
			src.toxicity = 0
			src.hunger = 99
			src.thirst = 99
			src.restedness = 99
			if(src.has_body)
				src.death_power_mod = 0.5
			else
				src.death_power_mod = 0.2
			src.disable_skills()
			src.clear_drugs()
			src.energy = 1
			src.percent_health = 1
			for(var/mob/m in players)
				if(m.target == src) m.add_remove_target(src,1)
			//src.KB_furrow = 0;
			//src.icon_state = src.state()
			if(src.charging)
				var/obj/ranged/c = src.charging
				c.remove()
				src.charging = null
			var/chance = 100
			if(src.trait_ur) chance = 50

			if(prob(chance))
				view(10,src)<<output("<font color=red>[src] was killed by [reason]!</font>","actionoutput")
				if(src.grabbed_by)
					var/mob/X = src.grabbed_by
					X.letgo()
				var/turf/t = src.loc
				//Create the body
				if(src.has_body && make_body)
					var/obj/items/misc/body/b = new
					var/obj/i=new
					i.icon='deathblood.dmi'
					i.dir = src.dir
					b.appearance = src.appearance
					b.loc = src.loc
					b.step_x = src.step_x
					b.step_y = src.step_y
					b.icon_state = "KO"
					b.owner = src
					b.dir = src.dir
					b.name = "[src]'s corpse"
					i.dir = b.dir
					b.overlays+=i
					items += b
					b.hp = src.psionic_power*src.endurance
					src.death_location = locate(b.x,b.y,b.z)
				if(!src.boss)
				/*	var/obj/items/misc/item_container/ic = new
					ic.name = "[src]'s items"
					ic.loc = src.loc
					ic.step_x = src.step_x
					ic.step_y = src.step_y
					*/
					for(var/obj/items/i in src)
						if(istype(i,/obj/items/consumables/))
							if(i.active==0) i.active=1
						src.drop(i,1)
				/*if(src.client == null && src.byond_key == null)
					var/mob/NPC/n = src
					switch(rand(1,5))
						if(1)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(n.loc)
							legmeat.loc = n.loc
						if(2)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new/obj/items/consumables/food/raw_legmeat(n.loc)
							legmeat.loc =  n.loc
						if(3)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(n.loc)
							steak.loc = n.loc
						if(4)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(n.loc)
							steak.loc = n.loc
						if(5)
							var/obj/items/consumables/food/raw_steak/steak = new /obj/items/consumables/food/raw_steak(n.loc)
							var/obj/items/consumables/food/raw_legmeat/legmeat = new /obj/items/consumables/food/raw_legmeat(n.loc)
							steak.loc = n.loc
							legmeat.loc = n.loc
					if(n.name == "Sheep")
						var/obj/items/wool/wl = new /obj/items/wool(n.loc)
						wl.loc = n.loc
					if(n.name == "Dinosaur")
						var/obj/items/clothing/fur/wl = new /obj/items/clothing/fur(n.loc)
						wl.loc = n.loc
					if(n.name == "Mammoth")
						var/obj/items/clothing/fur/wl = new /obj/items/clothing/fur(n.loc)
						wl.loc = n.loc
					if(n.name == "T Rex")
						var/obj/items/clothing/fur/wl = new /obj/items/clothing/fur(n.loc)
						wl.loc = n.loc
						*/


				//Drop cybertech
				src.drop_cybertech()
				//Drop items


				//if(src.keep_body == 0) src.has_body = 0;
				src.has_body = 0;
				src.alpha = 130;
				if(!src.npc && !src.boss)
					if(src.shadow) src.shadow.loc = null
					var/mob/clone = null;
					var/obj/stone = null
					for(var/obj/items/consumables/spirit_stone/i in items)
						if(i.fused_name == src.real_name && i.fused_key == src.key && i.fused_id == src.id)
							stone = i
							break
					for(var/mob/m in world)
						for(var/i in src.clones)
							//world << output("Debug - Found clone id [i].", "chat.system")
						//if(m.id in src.clones)
							if(i == m.id && m.being_grown == 0)
								//world << output("Debug - Found clone.", "chat.system")
								clone = m
								break;
					/*
					if(src.vat)
						var/obj/items/tech/Vat/v = src.vat
						if(v.set_for == src.id) clone = v
					*/
					/*if(clone)
						src.loc = clone.loc
						src.step_x = clone.step_x
						src.step_y = clone.step_y//+14
						src.dead = 0;
						src.has_body = 1
						src.icon_state = "Meditate"
						src.copy_mob_genetics(clone,0,0,0,0,"copy clone")
						clone.give_extra_organs(null,src)
						clone.vat.set_for = null
						clone.vat.in_use = null;
						clone.vat.growth_percent = 0
						clone.vat = null
						//del(clone)
						//src.layer = clone.layer + 1;
						//src.transform = matrix()*0.1
						//src.stunned += 1
						//src.being_cloned = 1;
					else if(stone)
						src.loc = locate(stone.x,stone.y-1,stone.z)
						if(src.map_blip)
							src.map_blip.pixel_x = src.x-3
							src.map_blip.pixel_y = src.y-3
						src.step_x = stone.step_x
						src.step_y = stone.step_y
						src.dead = 0;
						//src.has_body = 1
						if(!src.halo) src.halo = 'newhalo.dmi'
						src.overlays += src.halo
						src.alpha = 130
						for(var/obj/body_related/bodyparts/b in src.bodyparts)
							for(var/obj/body_related/bodyparts/o in b)
								src.damage_limb(src,0, 0, 100,o)
						if(src.skill_meditation) call(src.skill_meditation.act)(src,src.skill_meditation)*/

					if(src.debuff_dead && src.debuff_dead.active == 0) call(src.debuff_dead.act)(src,src.debuff_dead)
					src.loc = locate(418,49,2)
					if(src.map_blip)
						src.map_blip.pixel_x = src.x-3
						src.map_blip.pixel_y = src.y-3
					src.step_x = 0;
					src.step_y = 0;
					src.in_oldage = 0
					src.vigour = 100
					src.apply_afterlife_glow(1)
					if(!src.halo) src.halo = 'newhalo.dmi'
					src.overlays += src.halo
					src.alpha = 130
						//if(already_dead == 0) src.disable_parts(null,1,1,1,"Death")
					src.client.perspective = EYE_PERSPECTIVE | EDGE_PERSPECTIVE
					src.client.eye = t
					src.screen_text.maptext = "<font size = 3><center>You have died. However this is not the end for you. If you feel like you your death was done in foul play, please gather any evidence and collectives you need and send them to an admin! If you plan to dispute your death, please pause your IC until an admin gives a decision."
					animate(src.screen_text,alpha = 255,time = 75)
					src<<output("<font color=red>You have died. However this is not the end for you. If you feel like you your death was done in foul play, please gather any evidence and collectives you need and send them to an admin! If you plan to dispute your death, please pause your IC until an admin gives a decision.</font>","actionoutput")

					//winset(src,null,"stats_other.label_dead.text=\"Dead: Yes\"")
					//winset(src,null,"stats_other.label_has_body.text=\"Has Body: No\"")
					spawn(30)
						src.client.perspective = MOB_PERSPECTIVE //| EDGE_PERSPECTIVE //initial(src.client.perspective)
						src.client.eye = src
						src.screen_text.alpha = 0;
						src.dir = SOUTH
						animate(src,alpha = 200,time = 10)
						if(clone == null && stone == null)
							src.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=src.auracolor)
							src.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=src.auracolor)
						else
							src.alpha = 130
							clone.loc=null
							clone.contents=null
							/*
						else
							animate(transform = matrix()*1,time = 600)
							src.cloning()
						*/
				else
					if(!istype(src,/mob/NPC/Defenders/) || !istype(src,/mob/NPC/WorldBoss/))
						src.loc = null
						spawn(rand(500,1000))
							var/mob/new_spawn
							new_spawn = new src.respawn_type(src.respawnloc)
							new_spawn.hp = 100
					else
						Del(src)
		/*KnockBack(var/KB_dir)
			if(src.eating) src.cancel_eat()
			if(src.charging && src.KB > 1)
				src.stop_charging()
			var/skip = 0
			var/obj/plume = null
			for(var/obj/p in plumes)
				if(p.loc == null)
					plume = p
					break
			plume.dir = src.dir
			view(10,src)<<sound('strongpunch.ogg', volume = 25,channel=20)
			while(src && src.KB)
				if(!src.skill_flight || src.skill_flight && src.skill_flight.active == 0)
					if(!src.skill_levitation || src.skill_levitation && src.skill_levitation.active == 0)
						if(isturf(src.loc))
							var/turf/t = src.loc
							if(t.tmp_dmg < 0) plume.icon = 'fx_dust_plume_snow.dmi'
							else if(istype(t,/turf/lava_cooled) || istype(t,/turf/lava_cooling)) plume.icon = 'fx_ash_plume.dmi'
							else plume.icon = 'fx_dust_plume.dmi'
							if(t.fragile)
								if(skip == 0)
									skip += 1
									src.dust_and_furrows()
									plume.loc = get_step(src,src.dir)
									plume.step_x = src.step_x
									if(plume.dir == SOUTHWEST) plume.step_y = src.step_y+24
									else if(plume.dir == NORTHEAST) plume.step_y = src.step_y-24
									else if(plume.dir == NORTHWEST) plume.step_y = src.step_y-24
									else if(plume.dir == SOUTHEAST)
										plume.step_y = src.step_y+24
										plume.step_x = src.step_x-6
									else plume.step_y = src.step_y
								else
									skip = 0

				src.icon_state = "kb"
				src.KB -= 1
				step(src,KB_dir,src.step_size)
				src.set_shadow()
				src.layer = MOB_LAYER + src.laymod - (src.y + src.step_y / 32) / world.maxy
				src.wings()

			if(src)
				src.impact_cd = 0
				src.KB_furrow = 0
				src.recovering = 1
				spawn(src.attack_rate)
					if(src) src.recovering = 0

				src.icon_state = src.state()
				src.wings()
			if(plume) plume.remove_obj(0.1)*/

		Body()
			if(src.has_body == 0)
				animate(src,alpha = 255, time = 30)
				src.icon_state = ""
				src.screen_text.maptext = "<font size = 4><center>Your body was restored!"
				src.has_body = 1;
				src.death_power_mod = 0.5
				animate(src.screen_text,alpha = 255,time = 60)
				animate(alpha = 0,time = 60)
				src.disable_parts(null,1,0)
				winset(src,null,"stats_other.label_has_body.text=\"Has Body: Yes\"")

		TempRevive(var/energyconsumption,var/mob/caster)
			if(src)
				src.dead = 0;
				animate(src,alpha = 255, time = 30)
				src.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=src.auracolor)
				src.screen_text.maptext = "<font size = 6><center>Soul temporarily restored"
				animate(src.screen_text,alpha = 255,time = 60)
				animate(alpha = 0,time = 60)
				//winset(src,null,"stats_other.label_dead.text=\"Dead: No\"")

				//src.disable_parts(soul_related,0, 0,1)
				if(!src.halo) src.halo = 'newhalo.dmi'
				src.overlays-=src.halo
				src.has_body = 1
				src<<output("You were temporarily revived for 30 minutes!","actionoutput")
				src.repriever_timer = 18000
				energyconsumption = (energyconsumption/src.psionic_power)
				caster.reprievee_drain = energyconsumption
				src.alive_ticker(caster)
				caster.alive_drainer(energyconsumption,src)
				src.repriever = caster
				caster.reprievee = src
				//if(src.debuff_dead && src.debuff_dead.active) call(src.debuff_dead.act)(src,src.debuff_dead)
		Revive()
			src.dead = 0;
			animate(src,alpha = 255, time = 30)
			src.filters -= filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=src.auracolor)
			src.screen_text.maptext = "<font size = 4><center>You were revived."
			animate(src.screen_text,alpha = 255,time = 60)
			animate(alpha = 0,time = 60)
			//winset(src,null,"stats_other.label_dead.text=\"Dead: No\"")
			/*var/list/soul_related = list()
			for(var/obj/body_related/b in src.ascensions)
				if(b.needs_soul) soul_related += b
			for(var/obj/body_related/b in src.soul)
				soul_related += b*/
			//src.disable_parts(soul_related,1, 0,1)
			if(!src.halo) src.halo = 'newhalo.dmi'
			src.overlays-=src.halo
			if(src.halo) src.halo = null
			src.has_body = 1
			src.death_power_mod = 1
			src.alpha = 255
			if(src.death_location)
				src.loc=src.death_location
				src.check_glow_planes()
				src.death_location = null

			//if(src.debuff_dead && src.debuff_dead.active) call(src.debuff_dead.act)(src,src.debuff_dead)
		KO(var/loggedin = 0,var/un_koed=0)
			if(src.koed && !un_koed) return
			if(src.eating) src.cancel_eat()
			if(src.charging)
				var/obj/ranged/c = src.charging
				c.remove()
				src.charging = null
			if(un_koed==1)
				src.koed = 0
				src.redraw_appearance()
				src.idle_state = null
				src.lifeforce = 100;
				src.stunned = 0;
				src.can_attack = 1;
				src.recovering = 0;
				src.icon_state = src.state()
				if(src.can_move == 0) src.can_move = 1


				src.client.color = null
				src.client.images -= src.bar_ko


				if(src.npc && !src.client)
					var/mob/NPC/N = src
					N.returning = 1
					if(N.skill_flight && N.skill_flight.active == 0) call(N.skill_flight.act)(N,N.skill_flight)
					if(N.skill_super_speed) N.skill_super_speed.active = 1
					N.npc_ai()
				if(src.boss && !src.client)
					var/mob/NPC/WorldBoss/N = src
					N.returning = 1
					if(N.skill_flight && N.skill_flight.active == 0) call(N.skill_flight.act)(N,N.skill_flight)
					if(N.skill_super_speed) N.skill_super_speed.active = 1
					N.boss_idle_ai()

				if(src.percent_health < 0) src.percent_health = 0
				view(10,src)<<output("[src] picks themself off the ground.","actionoutput")
				var/turf/t = src.loc
				src.loc.Enter(src)
				src.Move(t)
				src.grav = t.grav
				return
			else
				flick("Fall",src)
				src.letgo()
				src.disable_skills()

				if(src.client) src.client.color = list(0.30,0.30,0.30,0, 0.60,0.60,0.60,0, 0.10,0.10,0.10,0, 0,0,0,1, 0,0,0,0)
				src.koed = 1
				if(src.client) src.client.images += src.bar_ko
				if(src.power_percent > 100) src.power_percent = 100;
				src.icon_state = "KO"
				src.percent_health = 0
				src.lifeforce = 100
				src.recovering = 0;
				src.stunned = 0
				//if(src.hair) src.overlays -= src.hair
				src.idle_state = "KO"
				view(10,src)<<output("<font color=yellow>[src] body is too badly damaged to support itself!</font>","actionoutput")
			//	view() << output("[src] is knocked out.","chat.local")
				var/time = 840/src.mod_regeneration
				if(src.trait_wos) time = time/2
				src.ko_time = time
				src.ko_time_max = time
				if(src.divine_weapon)
					for(var/mob/m in players)
						if(src.owner == m.real_name)
							src.dimiss_follower(m)
							return
				if(time<=0||time<=-0) time = 5
				spawn(5)
					src.process_zenkai_on_ko()
				spawn(time)
					if(src)
						src.koed = 0
						src.redraw_appearance()
						src.idle_state = null
						src.lifeforce = 100;
						src.stunned = 0;
						src.can_attack = 1;
						src.recovering = 0;
						src.icon_state = src.state()
						if(src.can_move == 0) src.can_move = 1

						if(src.client)
							src.client.color = null
							src.client.images -= src.bar_ko

						if(src.npc && !src.client)
							var/mob/NPC/N = src
							N.returning = 1
							if(N.skill_flight && N.skill_flight.active == 0) call(N.skill_flight.act)(N,N.skill_flight)
							if(N.skill_super_speed) N.skill_super_speed.active = 1
							N.npc_ai()
						if(src.boss && !src.client)
							var/mob/NPC/WorldBoss/N = src
							N.returning = 1
							if(N.skill_flight && N.skill_flight.active == 0) call(N.skill_flight.act)(N,N.skill_flight)
							if(N.skill_super_speed) N.skill_super_speed.active = 1
							N.boss_idle_ai()

						if(src.percent_health <= 0) src.percent_health = 1
						view(10,src) <<output("[src] picks themself off the ground.","actionoutput")
						var/turf/t = src.loc
						src.loc.Enter(src)
						src.Move(t)
						src.grav = t.grav
						//if(prob(15))
							//if(src.willpower>0)
							//	src.willpower -= (src.mod_zenkai)
								//if(src.willpower<=0) src.apply_zenkai(src)
						//view() << output("[src] regains consciousness.","chat.local")
		Attack()
			if(src.koed || src.stunned || src.recovering || src.selftraining || src.meditating) //If the player is ko, stunned, ect, they can't attack.
				//world << output("unable to attack - KO'ed, stunned, ect.","chat.local")
				return
			if(src.target)
				if(src.target == src) 	src.target = null
				if(src.target.loc == null)
					if(src.target.target == src) src.target.target = null

					src.target = null
					return
				//if(src.KB <= 0) src.dir = get_dir(src,src.target)
			if(src.can_attack <= 0)
				//world << output("unable to attack - can_attack = [src.can_attack]","chat.local")
				return
			if(src.mouse_down) return
			//if(src.energy <= 1)
				//world << output("unable to attack - no energy","chat.local")
			//	return
		//	if(src.psionic_power < 0)
				//world << output("unable to attack - psi power = 0","chat.local")
			//	return
			if(src.rp_mode == "Phase" && src.phase_members && src.phase_ready && !src.phased)
				for(var/mob/races/p in oview(25))
					if(findtext(phase_members,"[p.name]"))
						if(p.phased)
							src<<"A member apart of this phase is not ready! ([p.name] needs to RP!)"
							return
			if(src.rp_mode == "Phase" && src.phase_members && src.phase_ready && src.phased)
				src<<"You are not ready! (You need to RP!)"
				return
			if(src.rp_mode == "Phase" && src.phase_members && !src.phase_ready && !src.phased)
				for(var/mob/races/p in oview(25))
					if(findtext(phase_members,"[p.name]"))
						p.start_phase()
						src.start_phase()
				//continue

			src.can_attack = 0
			spawn(src.attack_rate)
				src.can_attack = 1
				src.last_attacked = null
			if(src.eating) src.cancel_eat()
			if (!src.target || src.target.koed || src.target.z != src.z || get_dist(src,src.target) >=2 )
				var/mob/found = src.find_facing_target(src.attack_range)
				if (found)
					src.target = found
			// ATTACKING WALL LOGIC
			var/turf/T = get_step(src, src.dir)
			if(T)
				var/turf/buildables/O = T
				if(O.wall == 1)
					// Play sound
					var/S = pick("1", "2")
					if (S == "1") hearers(6, src) << sound('weakkick.ogg', volume = 24)
					if (S == "2") hearers(6, src) << sound('weakpunch.ogg', volume = 24)

					// Animation
					switch(rand(1,2))
						if(1) flick(pick("RPunch", "LPunch"), src)
						if(2) flick(pick("RKick", "LKick"), src)

					// Stat gain
					if(!src.last_gain_time || world.time >= src.last_gain_time + 25)
						var/multi = 1
						var/growth_mult = clamp(0.25 + (src.PG), 0.25, 5)
						src.gain_stat("offence", 1, src.mod_offence/multi, "Attacking in melee", 1)
						if(prob(97)) src.gain_stat("strength", 1, src.mod_strength/multi, "Attacking in melee", 1)
						if(prob(49)) src.gain_stat("power", 1, src.mod_psionic_power/multi, "Attacking in melee", 1)
					//	if(prob(90)) src.gain_stat("offence", 1, src.mod_defence/multi, "Attacking in melee", 1)
						//if(prob(97)) src.gain_stat("endurance", 1, src.mod_endurance/multi, "Taking melee damage", 1)
						src.gain_stat("rating", 1, growth_mult, "Attacking in melee", 1)
						src.last_gain_time = world.time

					// Damage it
					var/damage = src.strength / 2
					if(src.sparring_gloves) damage = max(damage * 0.001, 0.01)
					O.hp -= damage
					O.flash_red()
					//O.shake()

					// Destroy if broken
					if(O.hp <= 0)
						O.destroy()
					return
			// ATTACK ITEMS/ROCK LOGIC
			var/obj/items/i = src.find_facing_object(src.attack_range)
			if(i)
				//for(var/obj/items/i in get_step(src,src.dir))
				if(bounds_dist(src,i) <= 8 && i.invul_melee == 0)
					var/S = pick("1", "2")
					if (S == "1") hearers(6, src) << sound('weakkick.ogg', volume = 24)
					if (S == "2") hearers(6, src) << sound('weakpunch.ogg', volume = 24)
					//Set the can_attack to 0, and set it on a cd based on speed
					//src.energy -= 1
					switch(rand(1,2))
						if(1)flick(pick("RPunch","LPunch"),src)
						if(2)flick(pick("RKick","LKick"),src)
					//world << "[src] Attacked [i]"
					i.flash_red()
					i.shake()
					var/dmg = src.strength/2
					if(src.sparring_gloves) dmg = max(dmg * 0.001, 0.01)
					i.hp -= dmg
					var/multi = 1
					//if(src.skill_super_speed && src.skill_super_speed.active) multi = src.mod_agility
					if(!src.last_gain_time || world.time >= src.last_gain_time + 25)
						var/growth_mult = clamp(0.25 + (src.PG), 0.25, 5) // PG gives modest scaling

						//world<<"[src] growth mult: [growth_mult] - rating mult: [rating_mult]"
						src.gain_stat("offence",1,src.mod_offence/multi,"Attacking in melee",1)
						if(prob(97))src.gain_stat("strength",1,src.mod_strength/multi,"Attacking in melee",1)
						if(prob(49)) src.gain_stat("power",1,src.mod_psionic_power/multi,"Attacking in melee",1)
						//if(prob(90))src.gain_stat("defence",1,src.mod_defence/multi,"Attacking in melee",1)
						//if(prob(97)) src.gain_stat("endurance",1,src.mod_endurance/multi,"Taking melee damage",1)
						//src.gain_stat("rating",1,(src.rating_mult*0.75),"Attacking in melee",1)
						src.gain_stat("rating",1,growth_mult,"Attacking in melee",1)
						src.last_gain_time = world.time

					if(istype(i,/obj/items/tech/Black_Hole_Generator))
						var/obj/items/tech/Black_Hole_Generator/b = i
						b.Activate()
					if(i.hp <= 0)
						if(i.type == /obj/items/tech/Gravity_Machine)
							var/obj/items/tech/Gravity_Machine/gm = i
							gm.turn_off()
						if(i.type == /obj/items/tech/Power_Line)
							var/obj/items/tech/Power_Line/p = i
							p.check_connections()
						if(istype(i,/obj/items/plants/) || i:tree == 1 )
							if(i:tree==1)
								var/obj/items/Wood/w = new(i.loc)
								switch(rand(1,2))
									if(1)w.stacks = 1
									if(2)w.stacks = rand(2,3)
						i.destroy()

					//break
					return
			/*
			if(src.target == null)
				for(var/mob/M in get_step(src,src.dir))
					if(bounds_dist(src, M) <= 32) if(M.can_harm) if(M != src)
						src.target = M
						if(M.target == null)
							M.dir = get_dir(M,src)
							M.target = src
						break
			*/
			// 🔹 Try to find a facing mob automatically if none targeted
			if (!src.target || src.target.koed || src.target.z != src.z || get_dist(src,src.target) >=2 )
				var/mob/found = src.find_facing_target(src.attack_range)
				if (found)
					src.target = found
			if (!src.target) return
			var/mob/M = src.target
			//if(src.target && src.target.z == src.z && src.target.afk == 0)
			if(src.target.KB > 0)
				//world << output("unable to attack - target knocked back","chat.local")
				return
		//	var/mob/M = src.target
			var/dir_to_target = get_dir(src, M)
			if (!(dir_to_target & src.dir)) return
			if (bounds_dist(src, M) > src.attack_range) return
			if(M.koed == 1)
				//if(bounds_dist(src,src.target) <= src.attack_range && src.target in get_step(src,src.dir))
				if(src.strength>M.endurance*1.5)

					if(prob(75))
						switch(alert(src,"Are you sure you wish to kill [M]?","","No","Yes","Cancel"))
							if("Yes")
								M.Death("[src]")
								src.target = null
								return
					else
						view(10,src) << output("<font color = red>[src.fullname] is trying to kill [M.name]!</font>","actionoutput")
						//	MM.create_chat_entry("alerts","<font color = red>[src.fullname] is trying to kill [M.fullname]!</font>")
						// is trying to KILL - chat output

				else
					if(prob(15))
						switch(alert(src,"Are you sure you wish to kill [M]?","","No","Yes","Cancel"))
							if("Yes")
								M.Death("[src]")
								src.target = null
								return

					else
						view(15,src) << output("<font color = red>[src.fullname] is trying to kill [M.name]!</font>","actionoutput")
							//	MM.create_chat_entry("alerts","<font color = red>[src.real_name] is trying to kill [M.real_name]!</font>")
				return

		/*	if(M.active_attack.active)
				M.active_attack.active=0
			if(M.skill_meditation && M.skill_meditation.active) call(M.skill_meditation.act)(M,M.skill_meditation)
			if(M.skill_sleep && M.skill_sleep.active) call(M.skill_sleep.act)(M,M.skill_sleep)
			if(M.skill_selftrain && M.skill_selftrain.active) call(M.skill_selftrain.act)(M,M.skill_selftrain) */

			if(M.target == null && M.koed == 0)
				M.target = src
				M.dir = get_dir(M, src)
				// Cancel Skills if attacked
				if(M.client == null && M.byond_key == null)
					if(istype(M,/mob/NPC/WorldBoss/))
						var/mob/NPC/WorldBoss/N = M
						if(!N.active) N.boss_idle_ai()
						if(N.boss !=1) N.boss = 1
					if(istype(M,/mob/NPC/Defenders/turret/))
						var/mob/NPC/Defenders/turret/N = M
						if(!N.active) N.turret_idle_ai()
						if(N.npc !=1) N.npc = 1
					else if(M.npc)
						var/mob/NPC/N = M
						if(!N.active) N.npc_ai()
						if(N.npc !=1) N.npc = 1




			//Set the can_attack to 0, and set it on a cd based on speed
			//src.can_attack = 0


			//Warp toward our target with super speed if possible
			if(src.skill_super_speed && src.skill_super_speed.active)
				//world << "DEBUG - Has super speed and is active"
				if(src.icon_state != "KB")
					//world << "DEBUG - Not in KB icon_state"
					if(get_dist(src,M) <= 18) //This is in tiles, not pixels.
						//world << "DEBUG - Not too far away"
						var/turf/s = src.loc
						var/s_x = src.step_x
						var/s_y = src.step_y
						var/s_z = src.pixel_z

						//src.MoveAng(D,16,0,0,null)
					//	src.Move(M.loc, 0, M.step_x + move_x, M.step_y - move_y)
						src.layer = MOB_LAYER + src.laymod - (src.y + src.step_y / 32) / world.maxy
						src.filters -= filter(type="motion_blur", x=1, y=0)
						src.filters += filter(type="motion_blur", x=1, y=0)
						spawn(2)
							if(src) src.filters -= filter(type="motion_blur", x=1, y=0)
						//src.set_shadow()
					//	src.set_dir(D)
						src.wings()
						var/removes = (1/src.mod_recovery) + (1/src.skill_super_speed.skill_lvl)
						src.energy -= removes
						src.skill_super_speed.skill_exp += ((5-(src.skill_super_speed.skill_lvl/20))*src.mod_skill)+0.5
					//	src.gain_stat("agility",1,0.1,"Super Speed",1)
						if(src.skill_super_speed.skill_exp >= 100 && src.skill_super_speed.skill_lvl < 100)
							src.skill_super_speed.skill_exp = 1
							src.skill_super_speed.skill_lvl += 1
						src.speed_image_reverse(s,s_x,s_y,s_z)
			/*
			spawn(src.attack_rate)
				if(src) src.can_attack = 1
			*/
			//if(M in get_step(src,src.dir))
			//if(bounds_dist(src,src.target) <= src.attack_range && src.target in get_step(src,src.dir))
			//var/turf/front = get_step(src, src.dir)
			//if(bounds_dist(src, src.target) <= src.attack_range)
			//if(src.target.loc == get_step(src, src.dir))
			///	if(M.percent_health == 0) return

				//src.energy-=1
			if(src.skill_touch_of_death && src.skill_touch_of_death.active)
				var/removes = (10/src.mod_recovery) + (10/src.skill_touch_of_death.skill_lvl)
				if(src.energy < removes) call(src.skill_touch_of_death.act)(src,src.skill_touch_of_death)
				else src.energy -=(removes*0.1)
			if(src.skill_ki_fist && src.skill_ki_fist.active)
				var/removes = (10/src.mod_recovery) + (10/src.skill_ki_fist.skill_lvl)
				if(src.energy < removes) call(src.skill_ki_fist.act)(src,src.skill_ki_fist)
				else src.energy -=(removes*0.1)
			if(src.skill_ki_blade && src.skill_ki_blade.active)
				var/removes = (10/src.mod_recovery) + (10/src.skill_ki_blade.skill_lvl)
				if(src.energy < removes) call(src.skill_ki_blade.act)(src,src.skill_ki_blade)
				else src.energy -=(removes*0.1)
			if(src.skill_attack)
				var/obj/skills/att = src.skill_attack
				att.skill_exp += ((5-(att.skill_lvl/20))*src.mod_skill)+0.5
				if(att.skill_exp >= 100 && att.skill_lvl < 100)
					att.skill_exp = 1
					att.skill_lvl += 1
					att.skill_up(src)
			//src << output("<font color = teal>1 energy removed from attacking","chat.system")
		//	flick(pick("RPunch","LPunch"),src)


			src.last_attacked = M
			var/Damage=((strength*mod_str_usage)*(psionic_power))/(M.endurance*M.psionic_power)//*rand(2,4)
			if(src.axe_pl > 0)
				Damage += Damage * (calc_weapon_boost(src.axe_pl, src.weapon_stance) / 100)

			if(src.hammer_pl > 0)
				Damage += Damage * (calc_weapon_boost(src.hammer_pl, src.weapon_stance) / 100)
			if(src.divine_weapon && M.divine_weapon) Damage=Damage*4
			var/criticalChance=((offence*mod_str_usage)*(psionic_power))/(M.defence*M.psionic_power)
			if(src.npc==0)
				switch(rand(1,2))
					if(1)flick(pick("RPunch","LPunch"),src)
					if(2)flick(pick("RKick","LKick"),src)
			else if(src.npc==1)
				flick("Attack",src)


			//	src.set_alert("You attack",src.icon,src.icon_state)

			//if(super_spd == 1) Damage*=0.5 //Super speed lets us attack at max speed, but do half dmg
			if(Damage <= 0) Damage = 0.1

			//var/Evasion=(M.defence*(1+(M.mod_agility/10)))/(offence*(1+(mod_agility/10)))
			if(M && M != src)
				//If both the attacker and defender went to hurt one another recently, give them gains. This is here to avoid players hitting other players who are fighting someone else.
				if(M.last_attacked == src && M.npc==0 && src.npc == 0)
					var/multi = 1
					var/growth_mult = clamp(0.25 + (src.PG), 0.25, 5) // PG gives modest scaling
					if(!src.last_gain_time || world.time >= src.last_gain_time + 25)
						//if(src.skill_super_speed && src.skill_super_speed.active) multi = src.mod_agility
						src.gain_stat("offence",1,src.mod_offence/multi,"Attacking in melee",1)
						if(prob(50))src.gain_stat("strength",1,(src.mod_strength)/multi,"Attacking in melee",1)
						if(prob(50))src.gain_stat("power",1,src.mod_psionic_power/multi,"Attacking in melee",1)
						M.gain_stat("defence",1,M.mod_defence/multi,"Defending in melee",1)
						if(prob(50))M.gain_stat("endurance",1,(M.mod_endurance)/multi,"Taking melee damage",1)
					//	if(prob(1))M.gain_stat("power",1,30/multi,"Taking melee damage",1)
						src.gain_stat("rating",1,growth_mult,"Attacking in melee",1)
						src.last_gain_time = world.time

			var/Evasion=src.evasion(src,M)//(src.psionic_power*(src.offence+(src.mod_agility*0.2)))/(M.psionic_power*(M.defence+(M.mod_agility*0.22)))
			var/EDeflection = handle_energy_deflection(src, M.Edeflection_skill, Damage,M)
			var/Blocking = handle_blocking(src,Damage,M)
			if(sword_pl > 0) Damage += (sword_pl*0.01)
			if(axe_pl > 0 ) Damage += (axe_pl*0.01)
			if(hammer_pl > 0 ) Damage += (hammer_pl*0.01)
			if(Blocking)
				if(M.guard>0)

					for(var/mob/races/MM in view(5,src))
						if(MM.battle_text)
							MM<<output("[MM.get_strangername(M)] blocked [MM.get_strangername(src)]'s attack!","actionoutput")
					M.guard-=Damage
				else if(M.guard <=0)
					M.guard = 0
					var/S = "1"
					if (S == "1") hearers(6, src) << sound('Modules/core/sound/sound files/Xia SFX v0.1/Ki_Deflect.wav', volume = 22)
					for(var/mob/races/MM in view(5,src))
						if(MM.battle_text)
							MM<<output("[MM.get_strangername(M)]'s guard was smashed from [MM.get_strangername(src)]'s attack!","actionoutput")

				return
			if(EDeflection)
				var/obj/deflect = new
				deflect.icon = 'energy_deflection.dmi'
				M.vis_contents += deflect
				var/S = "1"
				if (S == "1") hearers(6, src) << sound('Modules/core/sound/sound files/Xia SFX v0.1/Ki_Deflect.wav', volume = 24)
				for(var/mob/races/MM in view(5,src))
					if(MM.battle_text)
						MM<<output("[MM.get_strangername(M)] deflects [MM.get_strangername(src)]'s attack with their energy!","actionoutput")
				sleep(1)
				M.vis_contents -= deflect
				return
			if(Evasion)
				if(src.skill_touch_of_death && src.skill_touch_of_death.active)
					//src.skill_touch_of_death.hits = 0
					call(src.skill_touch_of_death.act)(src,src.skill_touch_of_death)
					src.skill_cooldown(src.skill_touch_of_death)
				var/S = pick("1", "2")
				if (S == "1") hearers(6, src) << sound('meleemiss1.ogg', volume = 24)
				if (S == "2") hearers(6, src) << sound('meleemiss2.ogg', volume = 24)
				for(var/mob/races/MM in view(5,src))
					if(MM.battle_text)
						MM<<output("[MM.get_strangername(M)] dodges [MM.get_strangername(src)]'s attack!","actionoutput")
				return

			else
				if(src.skill_touch_of_death && src.skill_touch_of_death.active)
					var/S = pick("1", "2")
					if (S == "1") hearers(6, src) << sound('mediumkick.ogg', volume = 24)
					if (S == "2") hearers(6, src) << sound('mediumpunch.ogg', volume = 24)
					src.skill_touch_of_death.hits += 1
					M.flash_red()
					if(src.skill_touch_of_death.hits >= src.skill_touch_of_death.max_hits)
						src.skill_touch_of_death.hits = 0

						//	for(var/obj/body_related/bodyparts/torso/heart/h in t)
						//M.damage_limb(src,0, 1, 100,randomlimb)
						if(prob(criticalChance))
							for(var/mob/races/MM in view(5,src))
								if(MM.battle_text)
									switch(rand(1,2))
										if(1)MM<<output("<font color=red>[MM.get_strangername(src)] attacks [MM.get_strangername(M)] and hits them precisely in their torso!</font>","actionoutput")
										if(2)MM<<output("<font color=red>[MM.get_strangername(src)] attacks [MM.get_strangername(M)] and hits them precisely in their head!</font>","actionoutput")

							Damage-= (Damage*0.1)

						call(src.skill_touch_of_death.act)(src,src.skill_touch_of_death)
						src.skill_cooldown(src.skill_touch_of_death)

				else if(src.skill_ki_blade && src.skill_ki_blade.active)
					var/S = pick("1", "2")
					if (S == "1") hearers(6, src) << sound('mediumkick.ogg', volume = 24)
					if (S == "2") hearers(6, src) << sound('mediumpunch.ogg', volume = 24)
					src.skill_ki_blade.hits += 1
					M.flash_red()
					if(src.skill_ki_blade.hits >= src.skill_ki_blade.max_hits)
						src.skill_ki_blade.hits = 0

						//	for(var/obj/body_related/bodyparts/torso/heart/h in t)
						//M.damage_limb(src,0, 1, 100,randomlimb)
						if(prob(criticalChance))
							for(var/mob/races/MM in view(5,src))
								if(MM.battle_text)
									switch(rand(1,2))
										if(1)MM<<output("<font color=red>[MM.get_strangername(src)] attacks [MM.get_strangername(M)] and hits them in their torso!</font>","actionoutput")
										if(2)MM<<output("<font color=red>[MM.get_strangername(src)] attacks [MM.get_strangername(M)] and hits them in their head!</font>","actionoutput")

							Damage-= (Damage*0.1)

						call(src.skill_ki_blade.act)(src,src.skill_ki_blade)
						src.skill_cooldown(src.skill_ki_blade)
				else if(src.skill_ki_fist && src.skill_ki_fist.active)
					var/S = pick("1", "2")
					if (S == "1") hearers(6, src) << sound('mediumkick.ogg', volume = 24)
					if (S == "2") hearers(6, src) << sound('mediumpunch.ogg', volume = 24)
					src.skill_ki_blade.hits += 1
					M.flash_red()
					if(src.skill_ki_fist.hits >= src.skill_ki_fist.max_hits)
						src.skill_ki_fist.hits = 0

						//	for(var/obj/body_related/bodyparts/torso/heart/h in t)
						//M.damage_limb(src,0, 1, 100,randomlimb)
						if(prob(criticalChance))
							for(var/mob/races/MM in view(5,src))
								if(MM.battle_text)
									switch(rand(1,2))
										if(1)MM<<output("<font color=red>[MM.get_strangername(src)] attacks [MM.get_strangername(M)] and hits them in their torso!</font>","actionoutput")
										if(2)MM<<output("<font color=red>[MM.get_strangername(src)] attacks [MM.get_strangername(M)] and hits them in their head!</font>","actionoutput")

							Damage-= (Damage*0.1)

						call(src.skill_ki_blade.act)(src,src.skill_ki_blade)
						src.skill_cooldown(src.skill_ki_blade)

		//	else
			//	src.create_chat_entry("alerts","<font color=red>[src.real_name] attacks [M.real_name] and hits them directly in their torso!</font>")

			if(M.trait_cn) if(prob(10))
				return
			var/S = pick("1", "2")
			if (S == "1") hearers(6, src) << sound('weakkick.ogg', volume = 24)
			if (S == "2") hearers(6, src) << sound('weakpunch.ogg', volume = 24)
			if(src.trait_ci) if(prob(25)) Damage*=1.5
			if(src.srs_mode) Damage*=1.25
			else if(src.spar_mode & src.srs_mode == 0) Damage = max(Damage * 0.1, 0.001)
			if(src.sparring_gloves)
				if(src.sparring_gloves)
					Damage = Damage * 0.001
					if(Damage < 0.0001) Damage = 0.0001
					if(Damage > 0.5) Damage = 0.5
			//Do the actual damage.
			if(M.armored_hp ==0) M.percent_health -= Damage
			else if(M.armored_hp > 0 )
				M.armored_hp -= Damage
				if(prob(5)) M.percent_health -= Damage
			if(src.sword_pl > 0 || src.axe_pl > 0 )
				if(src.laceration_skill > 0 && prob(src.laceration_skill+(src.axe_pl*0.25)))
					var/bleed_dur = rand(20, 30) // ~1.5-2 seconds
					var/bleed_dmg = Damage * 0.5 // damage per second

					if(!M.bleeding)
						M.apply_bleeding(bleed_dmg, bleed_dur)
						//var/obj/effects/blood_splatter/blood = new/obj/effects/blood_splatter(M.loc)
					//	blood.loc = M.loc
						// Optional: blood burst visual
						//new /obj/effects/blood_splatter(get_turf(M))

						// Optional: damage flavor text
						for(var/mob/races/viewer in viewers(M, null))
							if(viewer.battle_text)
								viewer << output("<font color=red><b>[src]</b> lacerates <b>[M]</b>, causing them to bleed!</font>", "actionoutput")



			if(M.eating) M.cancel_eat()
			//for(var/mob/h in view(8,M))
				//h << sound(pick(hits),0,0,2,100)
			M.anger(Damage) // Increase anger based on damage taken
			var/obj/body_related/bodyparts/randomlimb = pick(M.body)

			for(var/mob/races/MM in view(5,src))
				if(MM.battle_text)
					MM<<output("<font color=red>[MM.get_strangername(src)] attacks [MM.get_strangername(M)] they block with their [randomlimb]!</font>","actionoutput")
			//Pick a random limb and damage it.
			if(src.srs_mode && !M.npc) M.damage_limb(src,0, 1, (Damage*0.5+(BB/15)), randomlimb) //Normal
			else if(!M.npc) M.damage_limb(src,0, 1, (Damage*0.25+(BB/15)), randomlimb)


			//M.damage_limb(src,1, 1, 100) //100%

			if(M.skill_sleep && M.skill_sleep.active) call(M.skill_sleep.act)(M,M.skill_sleep)
			if(M.skill_selftrain && M.skill_selftrain.active) call(M.skill_selftrain.act)(M,M.skill_selftrain)
		//	if(M.client) M << output("[round(Damage,0.1)]% health removed from [src]'s melee attack.","chat.system")
		//	if(src.client) src << output("[round(Damage,0.1)]% health removed from [M].","chat.system")
			//M.dmg_nums("<font color = red>[round(Damage,0.1)]%")
			if(M.trait_aa) M.percent_energy += Damage/2
			if(istype(M, /mob/NPC/WorldBoss))
				var/mob/NPC/WorldBoss/WB = M
				WB.RegisterBossDamage(src, Damage)

			if(M.grab)
				if(M.trait_ig == null) M.letgo()
				else if(prob(25)) M.letgo()
			if(M && src) //Do a check here because letgo() has the reconnect_power() proc inside it, which itself has sleep() calls inside it.
				if(M.target == src)
					if(M.remembers_strength && M.remembers_strength.Find(src.id) == 0) M.remembers_strength += src.id
					if(M.remembers_agility && M.remembers_agility.Find(src.id) == 0) M.remembers_agility += src.id
				if(src.target == M)
					if(src.remembers_endurance && src.remembers_endurance.Find(M.id) == 0) src.remembers_endurance += M.id
					if(src.remembers_agility && src.remembers_agility.Find(M.id) == 0) src.remembers_agility += M.id
					if(src.remembers_regeneration && src.remembers_regeneration.Find(M.id) == 0) src.remembers_regeneration += M.id
				if(M.icon_state=="kb") M.icon_state=M.state()
				if(src.e_drainer_equipped)
					src.e_drainer_equipped.energy_supply += (M.energy_max*0.03)
					if(prob(5)) M<<output("You feel a poke from something.","actionoutput")
				if(M != src && src.mod_str_usage >= 0.4)
					var/kb_mod = (100-M.percent_health)/4
					M.KB=round(Damage+kb_mod)
					if(M.KB>32) M.KB=32
					if(M.KB > 32)
						if(M.KB_furrow == 0)
							//if(M.loc)
								/*
								var/turf/t = M.loc
								if(t.liquid == null)
									if(!M.skill_flight || M.skill_flight && M.skill_flight.active == 0)
										if(!M.skill_levitation || M.skill_levitation && M.skill_levitation.active == 0)
											for(var/mob/h in view(12,M))
												h << sound('rumble.mp3',0,0,13,100)
								*/
							new /obj/effects/shockwave_small (M.loc)
							var/obj/effects/hit/h = new
							h.loc = src.loc
							h.dir = src.dir
							if(src.dir == SOUTH ||src.dir == NORTH) h.pixel_x += 16
							h.step_x = src.step_x
							h.step_y = src.step_y
							var/KB_dir = src.dir//get_dir(src.loc,M.loc)
							//KB_dir = src.dir
							M.KB_furrow = 1
							M.dir = KB_dir
							M.KnockBack(KB_dir)
					else M.KB = 0 //Not far enough to make them slide back, so reset it to avoid them not being able to be attacked again.
					if(M.koed == 0) M.icon_state=M.state()
					if(M.KB == 0)
						M.dir = get_dir(M,src)
						//Reset rumble noise from knockback, but first check nobody else is being knocked back first.
						var/list/mobs = list()
						var/found_kb = 0
						for(var/mob/h in view(12,M))
							mobs += h
							if(h.KB > 0) found_kb = 1
						if(found_kb == 0)
							for(var/mob/h in mobs)
								h << sound(null,channel = 13)

					//Check if enemy is koed by attack, or harmed if they are already koed
					if(M.percent_health <= 0)
						if(src.boss)
							var/turf/safe = FindSafeBossRespawn(src)
							if(safe)
								M<<output("You managed to make it to safety before being killed.","actionoutput")
								M.loc = safe

						M.KO()

					/*
					if(src.super_jumps)
						var/list/turfs = list()
						for(var/turf/t in view(8,src))
							turfs += t
						src.speed_image(pick(turfs))
					*/
					//src.can_attack=1
				return
			return
			//else// if(src.can_attack >= 1)



			/*for(var/obj/items/O in get_step(src,dir))
				src.can_attack = 0
				spawn(src.attack_rate)
					if(src) src.can_attack = 1
				src.energy-=1
				flick("punch",src)
				var/dmg = src.strength/2
				O.hp -= dmg
				O.shake()
				if(O.hp <= 0)
					del(O)
				break
			*/
		rsc_nums(var/txt)
			for(var/obj/effects/over_displays/dmg_num/dn in global.rsc_nums)
				if(dn.loc == null)
					dn.loc = src.loc
					dn.stay_with = src
					dn.maptext = "[txt]"
					animate(dn, pixel_y = 112, time = 15)
					dn.remove()
					dn.activate()
					break
		charge_nums(var/txt)
			for(var/obj/effects/over_displays/dmg_num/dn in global.charge_nums)
				if(dn.loc == null)
					dn.loc = src.loc
					dn.stay_with = src
					dn.maptext = "[txt]"
					animate(dn, pixel_y = 112, time = 10)
					dn.remove()
					dn.activate()
					break
		dmg_nums(var/txt)
			return
			for(var/obj/effects/over_displays/dmg_num/dn in global.dmg_nums)
				if(dn.loc == null)
					dn.loc = src.loc
					dn.stay_with = src
					dn.maptext = "[css_outline][txt]"
					animate(dn, pixel_y = 96, time = 10)
					dn.remove()
					dn.activate()
					break
		state()
			if(src.started || src.client == null)
				//world << "DEBUG - [src] has started or isn't a client."
				var/return_state = ""
				var/flying = null
				var/attack = null
				if(src.skill_flight && src.skill_flight.active) flying = "Flight"
				if(src.skill_levitation && src.skill_levitation.active) flying = "levitate"
				if(src.current_attack && src.current_attack.active && src.active_attack) attack = src.current_attack.attack_state
				if(src.submerged) flying = "Flight"

				if(flying)
					if(attack) return_state = "fly [attack]"
					else if(src.grab) return_state = "fly beam"
					else return_state = flying
				else if(attack) return_state = "[attack]"
				else if(src.grab) return_state = "beam"
				if(src.KB) return_state = "KB"
				if(src.koed) return_state = "KO"
				return return_state