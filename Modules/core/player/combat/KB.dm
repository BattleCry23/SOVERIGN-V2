mob/var/tmp/in_knockback = 0
mob/var/tmp/knockback_fail_count = 0
mob/proc/KnockBack(var/KB_dir)
    if(src.in_knockback) return
    src.in_knockback = 1
    src.knockback_fail_count = 0

    // Always ensure cleanup even if loop exits unexpectedly
    try
        if(src.eating) src.cancel_eat()
        if(src.charging && src.KB > 1) src.stop_charging()

        // cache plume once
        var/obj/plume = null
        for(var/obj/p in plumes)
            if(p.loc == null)
                plume = p
                break

        if(plume)
            plume.dir = src.dir

        view(10,src) << sound('strongpunch.ogg', volume=25, channel=20)

        // Pre-calc “needs dust” check once per step, not nested every time
        while(src && src.KB > 0)
            // If deleted / moved to null turf, abort safely
            if(!src.loc || !isturf(src.loc))
                src.KB = 0
                break

            // canonical KB icon state (ONE spelling)
            if(src.icon_state != "KB")
                src.icon_state = "KB"

            // Move attempt
            var/moved = step(src, KB_dir, src.step_size)

            // If we can't move (blocked), reduce KB faster and break after a few fails
            if(!moved)
                src.knockback_fail_count++
                src.KB = max(0, src.KB - 2)

                if(src.knockback_fail_count >= 4)
                    // escape hatch: stop knockback so they don't freeze forever
                    src.KB = 0
                    break
            else
                src.knockback_fail_count = 0
                src.KB--

            // Only do heavier visuals sometimes
            if(plume && src.KB % 2 == 0)
                var/turf/t = src.loc
                if(t)
                    if(t.tmp_dmg < 0) plume.icon = 'fx_dust_plume_snow.dmi'
                    else if(istype(t,/turf/lava_cooled) || istype(t,/turf/lava_cooling)) plume.icon = 'fx_ash_plume.dmi'
                    else plume.icon = 'fx_dust_plume.dmi'

                    plume.loc = get_step(src, src.dir)
                    plume.step_x = src.step_x
                    plume.step_y = src.step_y

            // Avoid a tight loop (lag + deadlocks)
            sleep(1)


        // FULL CLEANUP — always runs
        if(src)
            src.KB = 0
            src.KB_furrow = 0
            src.impact_cd = 0

            // ensure recovery clears no matter what
            src.recovering = 1
            spawn(max(1, src.attack_rate))
                if(src) src.recovering = 0

            // restore normal state
            src.icon_state = src.state()
            src.wings()

        src.in_knockback = 0
        if(plume) plume.remove_obj(0.1)
    catch