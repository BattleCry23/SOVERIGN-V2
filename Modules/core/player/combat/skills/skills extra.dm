obj/skills/Cyborgification
	name = "Cyborgification"
	icon_state = "selfborg off"
	info_name = "cyborgification"
	passive_skill = 1
	max_level = 200
	skill_lvl = 1
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

	proc/ensure_cyberize(mob/m)
		if(!m) return
		if(!locate(/obj/skills/Cyberize) in m)
			m.contents += new /obj/skills/Cyberize(m)

	proc/activate(mob/m, amount)
		if(!m) return
		if(m.CYB >= 200) return

		var/add = max(0, amount)
		m.CYB = clamp(m.CYB + add, 0, 200)

		if(m.CYB >= 1)
			ensure_cyberize(m)


var/global/list/CYBER_MATS = list("Stone","Copper","Coal","Silver","Gold","Titanium","Mystille")
obj/skills/Cyberize
	name = "Cyberize"
	icon_state = "Cyberize off"
	info_name = "cyberize"
	max_level = 200
	cd_max = 6000
	skill_lvl = 1
	info_point_cost_type = "technology"
	info_energy_cost = 1
	info_mastery = 1
	info_point_cost = 3
	info_name = "cyberize"
	teach_energy = 9999999999999999999999999999999999999999
	info_buffs = "Create cybernetic parts!"
	info_duration = "Toggleable"
	info_point_cost_type = "technology"
	act = /obj/skills/Cyberize/proc/activate
	//info = "By sending excess Energy throughout your body, you're able to increase your strength significantly. Using this ability expands your muscles, draining your Energy slowly, but increasing your strength by 20%."
	hud_x = 20
	hud_y = 636
	var/kiicon
	var/kiicon2
	New()
		..()
		category = list("Technology")
	proc/activate(mob/m, var/obj/skills/Cyberize/i)
		if(m.koed || m.selftraining || m.meditating) return
		if(i.cd_state < 32)
			m << "Cyberize is on cooldown."
			return
		var/atom/target = input(m,"Cyberize who or what?") as null|anything in (list(m) + view(1,m))
		if(!target) return

		var/part = input(m,"Select cybernetic part") in list(
			"Left Arm","Right Arm","Left Leg","Right Leg","Torso","Head"
		)

		var/percent = input(m,"Cybernetic quality percent") as num
		percent = clamp(round(percent),50,5000)

		var/cost_each = Cyberize_CalcCost(m,percent,part)
		var/chance = Cyberize_CalcSuccess(m,percent,part,target)

		var/confirm = alert(m,
		"Target: [target]\nPart: [part]\nPercent: [percent]%\nCost per mineral: [cost_each]\nSuccess chance: [chance]%",
		"Cyberize","Proceed","Cancel")

		if(confirm != "Proceed") return

		if(!Cyberize_CanAfford(m,cost_each))
			m << "You do not have enough minerals."
			return

		if(!prob(chance))
			Cyberize_FailCooldown(m,i)
			m << "Cyberization failed."
			return

		Cyberize_Charge(m,cost_each)

		if(istype(target,/obj/items/misc/body))
			var/obj/items/misc/body/C = target
			Cyberize_AttemptReviveFromCorpse(m,C)

		var/obj/items/tech/cybernetic_part/P = Cyberize_CreatePart(part,percent)
		P.loc = get_turf(target)

		m << "Cyberization successful."
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
					if(m.skill_cyberize == null) m.skill_cyberize = src
					call(src.act)(m,src)

proc/Cyberize_CalcCostEach(mob/m, percent, part)
    percent = max(50, round(percent))

    // Base curve (tune freely)
    // 500% => ~45k
    // 1000% => ~115k
    var/base_each = round((percent * 70) + (max(0, percent - 500) * 80))

    // Part multipliers
    if(part == "Head") base_each = round(base_each * 1.25)
    else if(part == "Torso") base_each = round(base_each * 1.10)

    // Apply your discount (efficiency_skill)
    if(m) base_each = m.apply_discount(base_each)

    return base_each
proc/Cyberize_CalcCost(mob/m,percent,part)

    percent = max(50,percent)

    var/base_each = round((percent * 70) + (max(0,percent-500) * 80))

    if(part == "Head") base_each *= 1.25
    else if(part == "Torso") base_each *= 1.10

    base_each = round(base_each)

    if(m) base_each = m.apply_discount(base_each)

    return base_each
proc/Cyberize_CanAfford(mob/m, cost_each)
    if(!m) return 0
    for(var/mat in CYBER_MATS)
        if(m.count_material(mat) < cost_each)
            return 0
    return 1
proc/Cyberize_FailCooldown(mob/m, obj/skills/s)
    if(!m || !s) return
    s.cd_state = 32
    s.cd_max = 6000
    m.skill_cooldown(s)
proc/Cyberize_Charge(mob/m, cost_each)
    if(!m) return 0
    for(var/mat in CYBER_MATS)
        if(!m.remove_material(mat, cost_each))
            return 0
    return 1

proc/Cyberize_CalcSuccess(mob/m, percent, part, atom/target)
    var/cyb = 0
    if(m) cyb = clamp(m.CYB, 0, 200)

    // Base starts moderate, rises with CYB
    var/chance = 25 + round(cyb * 0.35)  // CYB 200 => +70 (so 95 base)

    // Higher % reduces chance
    chance -= round(percent / 40)        // 1000 => -25

    // Part difficulty
    if(part == "Head") chance -= 10
    else if(part == "Torso") chance -= 5

    // Corpse revival is harder
    if(istype(target, /obj/items/misc/body))
        chance -= 10

    return clamp(chance, 5, 95)
proc/Cyberize_CreatePart(part,percent)

    var/obj/items/tech/cybernetic_part/P = new

    P.percent = percent
    P.name = "Cybernetic [part] ([percent]%)"

    var/scale = percent / 50

    if(part == "Head")
        P.part_type = "Head"
        P.bonus_pl = round(percent / 20)

    else if(part == "Torso")
        P.part_type = "Torso"
        P.bonus_pl = round(percent / 50)

    else
        P.part_type = "Limb"

        P.bonus_end = round(scale)
        P.bonus_str = round(scale)
        P.bonus_for = round(scale)
        P.bonus_res = round(scale)
        P.bonus_off = round(scale * 0.8)
        P.bonus_def = round(scale * 0.8)

    return P

proc/Cyberize_AttemptReviveFromCorpse(mob/operator,obj/items/misc/body/C)

    if(!C) return

    var/mob/target

    for(var/mob/M in world)
        if(M.name == C.name)
            target = M
            break

    if(!target)
        operator << "No matching player found."
        return

    target.loc = get_turf(C)
    target.Revive()
    //target.dead = 0
    //target.koed = 0

    operator << "You restored [target] through cyberization."
    target << "You have been revived as a cybernetic being."

    qdel(C)
obj/skills/Destructo_Disk
    name = "Destructo Disk"
    icon_state = "destructo disk off"
    disabled_switch = 1
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

    hud_x = 212
    hud_y = 588

    var/tmp/played_fire_sound = 0

    New()
        ..()
        category = list("Force","Offence")
        src.info = text_destructo_disk

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
                        if(src.played_fire_sound == 1) src.played_fire_sound = 0
                    else
                        src.icon_state = "destructo disk"
                        src.active = 1
                        m.current_attack = src
                        m.toggle_skill(src)

    proc
        // ------------------------------------------------------------
        // Single cleanup point. Call before EVERY return inside activate.
        // ------------------------------------------------------------
        CleanupDisk(mob/m, obj/ranged/disk_charge/b, obj/ray, do_shrink = 0)
            if(m)
                if(m.active_attack == b)
                    m.active_attack = null
                m.can_ki = 1
                m.icon_state = m.state()

            if(ray)
                qdel(ray)

            if(b)
                if(do_shrink)
                    var/matrix/M = matrix()
                    M.Scale(0,0)
                    animate(b, transform = M, time = 10)
                    spawn(10)
                        if(b) qdel(b)
                else
                    qdel(b)

        // ------------------------------------------------------------
        // Hardened activate
        // ------------------------------------------------------------
        activate(mob/m)
            if(!m) return
            if(!(src in m)) return

            var/base_can_move = m.can_move

            if(m.active_attack) return
            if(m.koed || m.stunned || m.meditating || m.selftraining) return
            if(m.can_ki == 0) return
            if(m.energy <= 10) return

            if(src.cd_state < 32)
                m << output("<font color = teal>Skill is on cooldown, please wait.","chat.system")
                src.icon_state = "cd"
                spawn(3)
                    if(src) src.icon_state = "destructo disk"
                return

            // Create charge object
            var/obj/ranged/disk_charge/b = new /obj/ranged/disk_charge
            b.plane = 1
            b.icon = 'DestructoDisk.dmi'
            b.icon_state = "disk"
            b.icon *= m.auracolor
            b.ki_owner = m

            // Visual ray (pure effect object)
            var/obj/ray = new
            ray.bolted = 2
            ray.icon = 'fx_ray.dmi'
            ray.icon *= m.auracolor
            ray.pixel_x = -144
            ray.pixel_y = -144
            ray.filters += filter(type="rays", x=0, y=0, size=96, color=rgb(255,255,255), offset=0, density=10, threshold=0.7, factor=0, flags=FILTER_OVERLAY)
            animate(ray.filters[1], offset = 100, time = 200, loop = -1)
            animate(offset = 0, time = 0)

            // Lock state
            m.active_attack = b
            m.icon_state = m.state()
            m.can_ki = 0
            src.played_fire_sound = 0

            // Cooldown
            src.cd_max = (initial(src.cd_max)/m.mod_agility)/(1 + src.skill_lvl/100)
            m.skill_cooldown(src)

            // Fire sound prepared once (play once when released)
            var/sound/S = sound('disc_fire.ogg')
            S.channel = 5
            S.volume = 100
            S.repeat = 0

            // Watchdog: guarantee cleanup if something breaks / hangs.
            // 200 ticks ~= 20s at default 10 TPS; tune as desired.
            spawn(200)
                if(m && m.active_attack == b)
                    src.CleanupDisk(m, b, ray, 1)

            var/charge_check = 1
            var/turf/t = null

            while(m)
                set background = 1

                // If charge object is gone/expired, bail cleanly.
                if(!b || b.expired)
                    src.CleanupDisk(m, b, ray, 0)
                    return

                // Cancel states
                if(m.koed || m.stunned || m.meditating || m.energy <= 1)
                    m.active_attack = null
                    src.CleanupDisk(m, b, ray, 1)
                    return

                // Validate aim (off-map / UI / other z-level)
                if(!isturf(m.mouse_saved_loc) || m.mouse_saved_loc.z != m.z)
                    m.active_attack = null
                    src.CleanupDisk(m, b, ray, 1)
                    return

                // If attack was externally canceled
                if(m.active_attack != b)
                    src.CleanupDisk(m, b, ray, 1)
                    return

                // Update during charge
                if(b.fired == 0)
                    // Skill exp and level handling
                    src.skill_exp += ((0.1 - (src.skill_lvl/1000)) * m.mod_skill) + 0.1
                    if(src.skill_exp >= 100 && src.skill_lvl < 100)
                        src.skill_exp = 1
                        src.skill_lvl += 1
                        src.skill_up(m)

                    b.loc = m.loc
                    m.dir = get_dir(m, m.mouse_saved_loc)
                    m.wings()

                    var/di = b.GetAngleStep(m.mouse_saved_loc)

                    b.step_x = m.step_x
                    b.step_y = m.step_y

                    // Too close check
                    t = get_step(m, m.dir)
                    var/too_close = 0
                    if(t && (t.density || t.density_factor == 2))
                        too_close = 1

                    if(!too_close)
                        b.MoveAng(di, b.pix_away, 0, 0, null)

                    // Stat snapshot
                    b.ki_power = (m.psionic_power * 0.75)
                    b.ki_force = ((m.force * 0.5) * b.charge_lvl)
                    b.force_usage = m.mod_force_usage
                    b.ki_offence = m.offence
                    b.ki_agility = m.mod_agility

                    // Ray follows
                    ray.loc = m.loc
                    ray.step_x = m.step_x
                    ray.step_y = m.step_y
                    ray.MoveAng(di, b.pix_away, 0, 0, null)

                // Charge while mouse held
                if(m.mouse_down)
                    if(b.just_started)
                        b.shockwave()
                        b.just_started = 0

                    if(b.finishing == 0 && b.size < 1)
                        // Energy drain (clamp if needed)
                        var/e = ((1/m.mod_recovery) + (1/src.skill_lvl) * b.charge_lvl)
                        m.energy -= e

                        b.charge_lvl += 0.01 * m.mod_recovery
                        var/charge_rounded = round(b.charge_lvl)
                        if(charge_rounded > charge_check)
                            charge_check = charge_rounded

                        b.size += 0.001 * m.mod_recovery
                        if(b.size > 1) b.size = 1

                        var/matrix/M = matrix()
                        M.Scale(b.size, b.size)
                        b.transform = M

                        b.pix_away += 0.07 * m.mod_recovery
                        if(b.pix_away >= 80) b.pix_away = 80

                        // Orb effect (optional). Keep very light.
                        if(prob(1))
                            var/obj/orb = new /obj/effects/orb
                            orb.icon *= m.auracolor
                            orb.loc = b.loc
                            orb.step_x = b.step_x
                            orb.step_y = b.step_y
                            orb.pixel_x = rand(-64, 64)
                            orb.pixel_y = rand(-64, 64)
                            animate(orb, pixel_x = 0, pixel_y = 0, alpha = 0, time = 10)
                            spawn(10)
                                if(orb) orb.loc = null

                // Release to fire
                else if(b.fired == 0 && m.active_attack == b)
                    var/controlled_disk = (src.skill_lvl >= 60)
                    var/di2 = m.GetAngleStep(m.mouse_saved_loc)
                    b.ang = di2
                    b.fired = 1
                    b.travel = 40
                    b.explode_impact = 1
                    b.manual_control = controlled_disk
                    b.go()

                    // Gains
                    m.gain_stat("force", 1, (m.mod_force * 0.095), "From Destructo Disk skill")

                    // Fire sound ONCE
                    if(!src.played_fire_sound)
                        view(8, m) << S
                        src.played_fire_sound = 1

                    // Ray no longer needed
                    if(ray) qdel(ray)

                    if(controlled_disk)
                        m.can_move = 0
                        m.icon_state = m.state()

                        spawn()
                            while(m && b && b.loc && !b.expired && m.active_attack == b)
                                sleep(1)

                            if(m)
                                if(m.active_attack == b)
                                    m.active_attack = null
                                m.can_move = base_can_move
                                m.can_ki = 1
                                m.icon_state = m.state()
                    else
                        m.active_attack = null
                        m.icon_state = m.state()

                        // Restore can_ki after a short delay
                        var/time = 7 / m.mod_agility
                        if(time < 1) time = 1
                        spawn(time)
                            if(m) m.can_ki = 1

                    return

                // IMPORTANT: never fractional sleep. 1 tick minimum.
                sleep(0.5)