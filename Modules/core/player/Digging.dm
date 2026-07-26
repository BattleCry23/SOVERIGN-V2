obj/skills/Dig
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
        if(!m || !m.loc) return
        if(m.skill_selftrain && m.skill_selftrain.active) return
        if(m.meditating || m.selftraining || m.stunned) return

        s.shov = null
        s.dig_mod = 1

        if(s in m)
            if(!m.skill_dig) m.skill_dig = s

        if(s.active) return


        var/turf/t = m.loc
        if(t.liquid)
            m << output("<font color=teal>Can't do this in any sort of liquid.", "chat.system")
            m.set_alert("Need solid ground", 'alert.dmi', "alert")
            return

        // Cache planet + table ONCE
        var/planet_name = m.check_planet()
        if(!planet_name || !planet_resources[planet_name])
            planet_name = "Earth"
        var/list/mineral_table = planet_resources[planet_name]

        // Lazy-generate vein on the main tile (same as you had)
        EnsureVein(t, mineral_table)

        // Build targets
        var/obj/effects/craters/crater_small/c = new
        c.SetCenter(m)
        var/findChance = 55
        var/list/dig_targets = list(t)

        // Tool selection
        for(var/obj/items/tech/digging/sh in m)
            if(!sh.suffix) continue
            s.shov = sh

            if(istype(sh, /obj/items/tech/digging/Shovel))
                m.overlays += /obj/effects/Shovel_Dig
                s.dig_mod = 4 + clamp((sh.level*0.005), 1, 120)
                findChance = s.dig_mod + 55
            else if(istype(sh, /obj/items/tech/digging/Hand_Drill))
                m.overlays += /obj/effects/HandDrill_Dig
                s.dig_mod = 4 + clamp((sh.level*0.005), 1, 120)
                findChance = s.dig_mod + 60
                dig_targets += get_step(t, EAST)
                dig_targets += get_step(t, WEST)
            else if(istype(sh, /obj/items/tech/digging/Super_Drill))
                m.overlays += /obj/effects/SuperDrill_Dig
                s.dig_mod = 6 + clamp((sh.level*0.005), 1, 200)
                findChance = s.dig_mod + 75

                // 3x3 area in front (your logic, but safe)
                dig_targets.Cut() // clear
                var/turf/front = get_step(m, SOUTH)
                if(front) dig_targets += front
                for(var/dx = -1 to 1)
                    for(var/dy = -1 to 1)
                        var/turf/target = locate(front.x + dx, front.y + dy, front.z)
                        if(target) dig_targets += target
            break

        // Remove any nulls or duplicates
        dig_targets = (dig_targets & dig_targets) // cheap “unique-ify” trick in DM

        if(m.stance) m.disable_stances(null, 1)
        if(m.grab) m.letgo()

        if(m.energy < 1)
            m.set_alert("Need more energy", 'alert.dmi', "alert")
            return

        // Begin mining state
        m.stunned += 1
        m.stunned_pending += 1
        m.dir = SOUTH
        m.wings()

        if(m.digging_dust) m.vis_contents -= m.digging_dust
        var/turf/tt = locate(m.x, m.y - 1, m.z)
        if(tt && tt.tmp_dmg < 0)
            m.digging_dust = new /obj/effects/digging_snow
        else if(tt && (istype(tt, /turf/lava_cooled) || istype(tt, /turf/lava_cooling)))
            m.digging_dust = new /obj/effects/digging_ash
        else
            m.digging_dust = new /obj/effects/digging

        m.vis_contents += m.digging_dust
        s.active = 1
        s.icon_state = "Explosion"
        if(m.shadow) m.shadow.alpha = 0

        // Use IMAGE overlay so it can be removed cleanly and doesn't create objs
        var/image/dirt_overlay = image('mining_dirt.dmi')
        dirt_overlay.layer = m.layer-1

        spawn(25)
            set background = 1

            var/any_gained = 0

            for(var/turf/D in dig_targets)
                if(!D || D.liquid) continue
                for(var/obj/items/misc/body/B in D)
                    if(B.buried)

                        B.buried = 0
                        B.invisibility = 0
                        B.density = 0
                        B.loc = D

                        view(10,m) << output("[m] digs up a buried body!","actionoutput")

                // temporary overlay, REMOVED later
                D.overlays += dirt_overlay

                if(!prob(findChance))
                    m << "<font color=white>You failed to find anything."
                else
                    EnsureVein(D, mineral_table)

                    if(D.vein && D.vein.quantity > 0)
                        var/amount = round(s.dig_mod * rand(4,36), 1)
                        D.vein.quantity -= amount
                        D.vein.replenish()

                        var/mineral_path = mineral_paths[D.vein.mineral]
                        if(mineral_path)
                            var/obj/items/minerals/min = new mineral_path
                            min.stacks = amount
                            m.digging_mins(min, 1)
                            any_gained = 1
                            m << "<font color=white>You found x[amount] [min.name]."

                        // If chest has any probability, do that check INSIDE attempt_spawn_chest too
                        spawn(0) attempt_spawn_chest(m, D)
                    else
                        m << "There is nothing to mine."

                // small yield prevents hitching when many people mine
                sleep(0)

            // remove overlay after the dig finishes
            for(var/turf/D2 in dig_targets)
                if(D2) D2.overlays -= dirt_overlay

            // Reset
            if(m)
                if(any_gained) m.refresh_inv()
                s.active = 0
                m.stunned -= 1
                m.stunned_pending -= 1
                m.icon_state = ""
                s.icon_state = "Explosion off"
                m.overlays -= list(/obj/effects/Shovel_Dig, /obj/effects/HandDrill_Dig, /obj/effects/SuperDrill_Dig)
                if(m.digging_dust) m.vis_contents -= m.digging_dust
                if(m.shadow && (!m.skill_invis || !m.skill_invis.active)) m.shadow.alpha = 255


obj/skills/Dig
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
					call(src.act)(m, src)

proc/EnsureVein(var/turf/T, var/list/mineral_table)
    if(!T || T.vein) return
    var/mineral = pick(mineral_table)
    var/qty = mineral_table[mineral] + rand(5, 15)
    T.vein = new /datum/resource_vein(mineral, qty)


