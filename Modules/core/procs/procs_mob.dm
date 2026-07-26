// Constants for Anger Phases
#define CALM 0
#define IRRITATED 1
#define ANNOYED 2
#define SLIGHTLY_ANGRY 3
#define ANGRY 4

// Define Anger Thresholds
#define IRRITATED_THRESHOLD 105
#define ANNOYED_THRESHOLD 110
#define SLIGHTLY_ANGRY_THRESHOLD 115
#define ANGRY_THRESHOLD 123
mob/proc
	set_path_type()
		if(src)
			switch(src.race)
				if("Human") src.path_type = "mob/races/Human"
				if("Kai") src.path_type = "mob/races/Celestial"
				if("Alien") src.path_type = "mob/races/Alien"
				if("Namekian") src.path_type = "mob/races/Yukopian"
				if("Oni") src.path_type = "mob/races/Imp"
				if("Demon") src.path_type = "mob/races/Demon"
				if("Saiyan") src.path_type = "mob/races/Saiyan"
				if("Spirit Doll") src.path_type = "mob/races/Spiritdoll"
				if("Changeling") src.path_type = "mob/races/Changeling"
				if("Tuffle") src.path_type = "mob/races/Tuffle"
				if("Makyo") src.path_type = "mob/races/Makyo"
mob/proc/open_wool_ui(obj/items/wool/w)
    if(!w) return

    var/html = "<html><body style='background:#1b1b1b; color:white; font-family:Verdana;'>"



    html += "<center><h2>Wool Crafting</h2></center>"
    html += "<div style='height:400px; overflow-y:auto;'>"

    for(var/name in WOOL_CRAFTING)
        var/typepath = WOOL_CRAFTING[name]
        var/obj/temp = new typepath
        var/icon/preview = icon(temp.icon, "", SOUTH, 1)

        html += "<div style='display:inline-block; width:120px; margin:6px; padding:6px; background:#2b2b2b; border-radius:6px; text-align:center;'>"
        html += "<img src='\ref[preview]' width=32 height=32><br>"
        html += "<b>[name]</b><br>"
        html += "<a href='byond://?src=\ref[src];craft=[name]'>Create</a>"
        html += "</div>"

        qdel(temp)

    html += "</div>"
    html += "<hr>"
    html += "<center><a href='byond://?src=\ref[src];close_craft=1'>Close</a></center>"
    html += "</body></html>"

    src << browse(html, "window=woolcraft;size=600x500")

/*mob/proc/craft_from_wool(var/name)
    if(!(name in WOOL_CRAFTING)) return

    var/obj/items/wool/w
    for(var/obj/items/wool/W in src.contents)
        w = W
        break

    if(!w)
        src.set_alert("You need wool!", 'alert.dmi', "alert")
        return
    src << browse(null, "window=woolcraft")
    var/typepath = WOOL_CRAFTING[name]

    var/newcolor = input(src, "Choose a color") as color
    if(!newcolor) return

    var/obj/items/clothing/item = new typepath(get_turf(src))
    item.icon *= newcolor

    w.use_obj(src)
    src.refresh_inv()

    src.set_alert("You created a [item]!", 'alert.dmi', "alert")*/
mob/proc/migrate_body_system()
    if(src.body_version >= 2)
        return
    // 1. Remove any legacy bodypart objects
    if(src.body)
        for(var/obj/O in src.body)
            if(!istype(O, /obj/body_related/bodyparts))
                qdel(O)

    // 2. Remove legacy bodyparts list completely
    if(src.bodyparts)
        for(var/obj/O in src.bodyparts)
            qdel(O)
        src.bodyparts = null

    // 3. Reset body list
    src.body = list()

    // 4. Create fresh 4-limb system
    src.create_body()

    // 5. Reset hurt limbs list
    src.hurt_limbs = list()

    // 6. Update HUD safely
    src.update_limb_hud()

    if(src.hud_body)
        src.hud_body.color_paperdoll(src)
    src.body_version = 2
mob/proc/FixScreenOffset()
	var/option = input("Select your offset\nRecommended: Auto") in list("Auto","Zero","Custom","Client Custom")

	if(option == "Auto")
		src.client.custom_view = 32
	if(option == "Zero")
		src.client.custom_view = 0
	if(option == "Custom")
		var/newoption = input("Type your offset(eg. -32, 32, -16, 16)") as num
		src.client.custom_view = newoption
	if(option == "Client Custom")
		var/clientx = input("Type the 'x' of the client view") as num
		var/clienty = input("Type the 'y' of the client view") as num
		var/pixelxoff = input("Type the 'pixel_x' number") as num
		var/pixelyoff = input("Type the 'pixel_y' number") as num
		switch(alert(src,"Your client view will be '[clientx]x[clienty]' and your pixel offsets will be: px: [pixelxoff] py: [pixelyoff], do you confirm?","","Yes","Cancel"))
			if("Yes")
				src.client.view = "[clientx]x[clienty]"
				src.pixel_y = pixelyoff
				src.pixel_x = pixelxoff
				src << "Your view was changed to [clientx]x[clienty]."
				return

	src.client.setMap(src.client)
	src << "Your view was changed to [option]"
	return 1
mob/proc/craft_from_wool(var/name)
    if(!(name in WOOL_CRAFTING)) return

    var/obj/items/wool/w
    for(var/obj/items/wool/W in src)
        w = W
        break

    if(!w)
        src.set_alert("You need wool!", 'alert.dmi', "alert")
        return

    src << browse(null, "window=woolcraft")

    var/typepath = WOOL_CRAFTING[name]

    // Create item FIRST
    var/obj/items/clothing/item = new typepath(get_turf(src))

    // === MULTI-PART SUPPORT ===
    if(item.top_icon != null && item.bottom_icon != null)

        var/choice = alert(src, "Color top and bottom separately?", "Color Options", "Yes", "Single Color")

        if(choice == "Yes")
            item.top_color = input(src, "Choose TOP color") as color
            item.bottom_color = input(src, "Choose BOTTOM color") as color
        else
            var/single = input(src, "Choose color") as color
            item.top_color = single
            item.bottom_color = single

        item.build_icon()

    else
        var/newcolor = input(src, "Choose a color") as color
        if(!newcolor)
            qdel(item)
            return

         // If NOT black, apply color
        if(lowertext(newcolor) != "#000000")
            item.icon *= newcolor

    w.use_obj(src,0)
    src.refresh_inv()

    src.set_alert("You created a [item]!", 'alert.dmi', "alert")

mob/proc/count_ingredient(name)

    var/total = 0

    for(var/i=1,i<=48,i++)
        var/obj/items/I = src.inv[i]

        if(!I) continue

        if(findtext(I.name, name))
            if(I.stacks)
                total += I.stacks
            else
                total++
    return total
/mob/proc/set_view(atom/A)
	if (src.client)
		if (istype(A, /atom))
			src.client.perspective = EYE_PERSPECTIVE
			src.client.eye = A
		else
			if (isturf(src.loc))
				src.client.eye = src.client.mob
				src.client.perspective = MOB_PERSPECTIVE
			else
				src.client.perspective = EYE_PERSPECTIVE
				src.client.eye = src.loc
	return
mob
	Click(location, control, params)
		// HARD INTERCEPT: delete mode always wins
		if(usr && usr.left_click_function == "delete stuff")
			var/mob/N = src
			usr.left_click_ref = N
			usr.hud_confirm.confirm_text(
				1,
				"You are about to delete [N]. Do you accept?",
				usr
			)
			usr.confirm = "accept delete mob"
			return  // ← THIS IS THE IMPORTANT PART

		// Otherwise, allow normal click behavior
		return ..()

// Proc to Check and Update Anger Phase
mob/proc/sense_targets(atom/center, statusr)
    var/cz = center.z //store center's z coordinate
    if (!cz || !src.psionic_power) return null  //we can't sense if we're off the map or passed out.
   // var/cx = center.x, cy = center.y
    //if we passed a statusr, don't worry about storing the targets.
    var/list/targets = statusr ? null : list() //set up our variable storage
    var/power_factor, sense_range, distance_scaling
    var/min_range = 10, base_range = 50, max_range = 300 //set up our range values

    for (var/mob/target in players) //loop over all players in the global Players list
        if (target == src || !target.client || target.z != cz || !target.psionic_power || target.BPpcnt<=0)
            continue

        power_factor = target.psionic_power / src.psionic_power //calculate our power factor
        if (power_factor >= 10)
            sense_range = max_range //use power factor to calculate sense range
        else if (power_factor > 1)
            sense_range = base_range + (max_range - base_range) * (power_factor - 1) / 9
        else
            sense_range = min_range + (base_range - min_range) * power_factor

        var/distance = get_dist(center, target) //calculate distance between center and target
        distance_scaling = (1 - distance / sense_range) * (target.BPpcnt / 100) //distance scaling factor

        if (distance_scaling > 0 && distance_scaling <= 1) //ensure distance scaling is within range
            if (statusr) //if we passed a statusr, let's call the stat() lines in this proc instead of looping through the results again.
                stat(target.sense_image(src))
            else
                targets += target

    return targets

mob/proc/sense_image(var/mob/watcher)
    var/sname, order
    var/power
    if (watcher == src)
        sname = watcher.get_strangername(src)
        power = max(src.BPpcnt,100)
    else
        sname = watcher.get_strangername(src)
        power = min(round(src.psionic_power / watcher.psionic_power * 100), 100000)

        order = " - [watcher.aura_txt]"
        if(power<=0) power = 1
    if (canSenseAlignments) return {"<IMG CLASS=icon SRC=\ref[src] ICONSTATE='' ICONDIR=SOUTH ICONFRAME=1>\t\t[sname]\n\n\t\t[power]%[order]"}
    else return {"<IMG CLASS=icon SRC=\ref[src] ICONSTATE='' ICONDIR=SOUTH ICONFRAME=1>\t\t[sname]\n\n\t\t[power]%"}

mob/var/canSenseAlignments = 0
mob/proc
	start_test_timer()
		if(!src.testtime) src.testtime=216000
		src.testing = 1
		while(src.started && src.testing)
			if(src.testtime > 0) src.testtime --

			else if(testtime <=0 )
				src.testtime=0
				src.testing=0
				src<<"<b><center>Your 6 hours of playtime is up, thanks for playing!</b></center>"
				src<<output("<b><center>Your 6 hours of playtime is up, thanks for playing!</b></center>","actionoutput")
				sleep(10)
				src.Logout()
				sleep(20)
				del(src)


			sleep(1)


mob/proc/apply_zenkai_old(var/mob/m)
	if(m.mod_zenkai && m.willpower <1)
		m.psionic_power += (m.psionic_power*m.mod_zenkai)
		m.willpower = 0
		m.anger=m.max_anger
		sleep(0.1)
		m.anger_check()
		return

mob/proc/anger_check()
    var/new_phase = CALM

    if(src.anger <= 10)
        src.anger = 100
        new_phase = CALM

    if(src.anger > 100 && src.anger <= IRRITATED_THRESHOLD)
        new_phase = IRRITATED

    if(src.anger > IRRITATED_THRESHOLD && src.anger <= ANNOYED_THRESHOLD)
        new_phase = ANNOYED

    if(src.anger > ANNOYED_THRESHOLD && src.anger <= SLIGHTLY_ANGRY_THRESHOLD)
        new_phase = SLIGHTLY_ANGRY

    if(src.anger > SLIGHTLY_ANGRY_THRESHOLD && src.anger <= ANGRY_THRESHOLD)
        new_phase = ANGRY
    if(src.anger >=ANGRY_THRESHOLD)
        new_phase = ANGRY


    // If anger phase has changed, update and send message ONCE
    if(new_phase != src.anger_phase)
        anger_phase = new_phase
        switch(anger_phase)
            if(CALM)
                for(var/mob/races/p in view(25,src))
                    if(p.anger_text)
                        p<<output("[src.real_name] is calm.","actionoutput")
            if(IRRITATED)
                for(var/mob/races/p in view(25,src))
                    if(p.anger_text)
                        p<<output("[src.real_name] is irritated.","actionoutput")
            if(ANNOYED)
                for(var/mob/races/p in view(25,src))
                    if(p.anger_text)
                        p<<output("[src.real_name] is annoyed.","actionoutput")
            if(SLIGHTLY_ANGRY)
                for(var/mob/races/p in view(25,src))
                    if(p.anger_text)
                        p<<output("[src.real_name] is slightly angry.","actionoutput")
            if(ANGRY)
                for(var/mob/races/p in view(25,src))
                    if(p.anger_text)
                        p<<output("<font color = red>[src.real_name] is angry!</font>","actionoutput")

// Proc to Modify Anger Based on Damage Received
mob/proc/anger(var/damage)
    var/anger_increase = damage * (1+src.anger / src.max_anger) // Scale increase based on current anger

    src.anger += (1+anger_increase)
    //world<<"Anger Check: Increase:[(1+anger_increase)] - Current Anger of [src]: [src.anger]"
    if(src.anger >= max_anger) src.anger = max_anger
    spawn() src.anger_check()

// Proc to Get Power Boost Based on Anger Phase
mob/proc/get_anger_power_boost()
    switch(src.anger_phase)
        if(CALM) return 1.0 // Normal Power
        if(IRRITATED) return 1+src.mod_anger // 10% boost
        if(ANNOYED) return 1.25+src.mod_anger // 25% boost
        if(SLIGHTLY_ANGRY) return 1.5+src.mod_anger // 50% boost
        if(ANGRY) return 2.0+src.mod_anger // Double Power

    return 1.0 // Default (failsafe)

// Proc to Reset Anger (Optional)
mob/proc/reset_anger()
    src.anger = 100
    src.anger_phase = CALM
    view(10,src)<<output("[src.real_name] calms down.","actionoutput")

/*
.:Cheat sheet for mob procs:.

	- List of procs that proc every few seconds for the player.
	- Most of the procs in this file don't proc, but the ones listed below do.
	- Also includes procs not in this file

	process_stats() - "procs_mob.dm"
		- procs every 10 seconds in game
	gain_relations() - "contacts.dm"
		- procs every 60 seconds in game

*/

mob/proc/TextPercent(num)
	var/mob/m = src

	if(!isnum(num) || num <= 0)
		return "(0%) Invalid"

	// Ensure all relevant stats are numeric and >= 0
	var/str = max(m.strength, 1)
	var/end = max(m.endurance, 1)
	var/spd = max(m.weight, 1)
	var/pow = max(m.force, 1)
	var/res = max(m.resistance, 1)
	var/off = max(m.offence, 1)
	var/def = max(m.defence, 1)

	// Total sum of all base stats
	var/total = round((str + end + spd + pow + res + off + def) / 1,1)

	if(total <= 0)
		return "(0%) Unrated"

	// Stat contribution percentage
	var/percent = max(round((num / total) * 100),1)

	// Percent Ranges (GAPLESS)
	if(percent <= 2) return "([percent]%) Extremely Low"
	if(percent > 2 && percent <= 5) return "([percent]%) Very Low"
	if(percent > 5 && percent <= 10) return "([percent]%) Low"
	if(percent > 10 && percent <= 15) return "([percent]%) Below Average"
	if(percent > 15 && percent <= 20) return "([percent]%) Average"
	if(percent > 20 && percent <= 30) return "([percent]%) Above Average"
	if(percent > 30 && percent <= 45) return "([percent]%) High"
	if(percent > 45 && percent <= 65) return "([percent]%) Very High"

	return "([percent]%) Extremely High"

mob/proc/RegisterBossDamage(mob/M, amount)
	if(!M || !M.client || amount <= 0) return

	var/ck = M.ckey
	if(!ck) return

	if(!damage_by_ckey[ck])
		damage_by_ckey[ck] = 0
		name_by_ckey[ck] = M.name

	damage_by_ckey[ck] += amount
	total_damage += amount
/*
mob/proc/TextPercent(num)
	var/mob/m = src

	// Ensure mods are at least 1 to avoid division by zero
	var/str = max(m.mod_strength, 1)
	var/end = max(m.mod_endurance, 1)
	var/spd = max(m.mod_agility, 1)
	var/pow = max(m.mod_force, 1)
	var/res = max(m.mod_resistance, 1)
	var/off = max(m.mod_offence, 1)
	var/def = max(m.mod_defence, 1)
	m<<"Str: [str]"
	m<<"End: [end]"
	m<<"Off: [off]"
	m<<"Def: [def]"
	m<<"Pow: [pow]"
	m<<"Res: [res]"

	// Ensure base stats are numeric
	var/StrTotal=m.strength/str
	var/EndTotal=m.endurance/end
	var/SpdTotal=m.weight/spd
	var/PowTotal=m.force/pow
	var/ResTotal=m.resistance/res
	var/OffTotal=m.offence/off
	var/DefTotal=m.defence/def
	m<<"StrTotal: [StrTotal]"
	m<<"EndTotal: [EndTotal]"
	m<<"OffTotal: [OffTotal]"
	m<<"DefTotal: [DefTotal]"
	m<<"PowTotal: [PowTotal]"
	m<<"ResTotal: [ResTotal]"


	// Calculate average
	var/Stat_Average = (StrTotal + EndTotal + SpdTotal + PowTotal + ResTotal + OffTotal + DefTotal) / 1

	// Fail-safe if num is not a number
	if(!isnum(num))
		return "(0%) Invalid"

	// Normalize num to a % of average
	var/ratio = (Stat_Average > 0) ? num / Stat_Average : 0

	// Clamp to prevent extreme or broken values
	ratio = clamp(ratio, 1, 9999)
	var/percent = round(ratio)

	// Graded descriptions
	if(ratio <= 0.1) return "([percent]%) Extremely Low"
	if(ratio <= 0.25 && ratio >0.1) return "([percent]%) Very Low"
	if(ratio <= 0.75 && ratio >0.25) return "([percent]%) Low"
	if(ratio <= 1.5 && ratio >0.75) return "([percent]%) Below Average"
	if(ratio <= 1.5 && ratio >1.0) return "([percent]%) Average"
	if(ratio <= 2.25 && ratio >1.5) return "([percent]%) Above Average"
	if(ratio <= 3.0 && ratio >2.25) return "([percent]%) High"
	if(ratio <= 5.0 && ratio >3.0) return "([percent]%) Very High"
	if(ratio > 5.0) return "([percent]%) Extremely High"

	return "([percent]%) Unranked"


*/




/* OG TEXT PERCENT
mob/proc/TextPercent(num)
	var/mob/m = src

	/*for(var/mob/player/P in Players)

		var/str = (P.StrMod_Temp<1 ? P.StrMod_Temp+1 : P.StrMod_Temp)
		var/end = (P.EndMod_Temp<1 ? P.EndMod_Temp+1 : P.EndMod_Temp)
		var/spd = (P.SpdMod_Temp<1 ? P.SpdMod_Temp+1 : P.SpdMod_Temp)
		var/pow = (P.PowMod_Temp<1 ? P.PowMod_Temp+1 : P.PowMod_Temp)
		var/res = (P.ResMod_Temp<1 ? P.ResMod_Temp+1 : P.ResMod_Temp)
		var/off = (P.OffMod_Temp<1 ? P.OffMod_Temp+1 : P.OffMod_Temp)
		var/def = (P.DefMod_Temp<1 ? P.DefMod_Temp+1 : P.DefMod_Temp)

		Str_Total+=P.Str/str
		End_Total+=P.End/end
		Spd_Total+=P.Spd/spd
		Pow_Total+=P.Pow/pow
		Res_Total+=P.Res/res
		Off_Total+=P.Off/off
		Def_Total+=P.Def/def*/

	var/str = (m.mod_strength<1 ? m.mod_strength+1 : m.mod_strength)
	var/end = (m.mod_endurance<1 ? m.mod_endurance+1 : m.mod_endurance)
	var/spd = (m.mod_agility<1 ? m.mod_agility+1 : m.mod_agility)
	var/pow = (m.mod_force<1 ? m.mod_force+1 : m.mod_force)
	var/res = (m.mod_resistance<1 ? src.mod_resistance+1 : src.mod_resistance)
	var/off = (m.mod_offence<1 ? src.mod_offence+1 : src.mod_offence)
	var/def = (m.mod_defence<1 ? src.mod_defence+1 : src.mod_defence)

	var/StrTotal=m.strength/str
	var/EndTotal=m.endurance/end
	var/SpdTotal=m.weight/spd
	var/PowTotal=m.force/pow
	var/ResTotal=m.resistance/res
	var/OffTotal=m.offence/off
	var/DefTotal=m.defence/def
	//var/Stat_Average=(usr.Str+usr.End+usr.Spd+usr.Pow+usr.Res+usr.Off+usr.Def)/1
	var/Stat_Average=(StrTotal+EndTotal+SpdTotal+PowTotal+ResTotal+OffTotal+DefTotal)/1
	if(!isnum(num)) return 0
	if(num<=10*Stat_Average/100) return "([num])% Extremely Low"
	if(num<=25*Stat_Average/100&&num>10*Stat_Average/100) return "([num])% Very Low"
	if(num<=75*Stat_Average/100&&num>25*Stat_Average/100) return "([num])% Low"
	if(num<=100*Stat_Average/100&&num>75*Stat_Average/100) return "([num])% Below Average"
	if(num<=150*Stat_Average/100&&num>100*Stat_Average/100) return "([num])% Average"
	if(num<=225*Stat_Average/100&&num>150*Stat_Average/100) return "([num])% Above Average"
	if(num<=300*Stat_Average/100&&num>225*Stat_Average/100) return "([num])% High"
	if(num<=500*Stat_Average/100&&num>300*Stat_Average/100) return "([num])% Very High"
	if(num>=1500*Stat_Average/100) return "([num])% Extremely High"

*/
//ADMIN STUFF

mob/proc
	admin_cmd_check(var/text)
		if(text == "/tp")
			if(src.key in StaffTeam)
				switch(input(src,"Where do you wish to teleport?") in list ("Earth","Namek","Vegeta","Icer","Space","Other Realm","Dark Realm"))
					if("Earth")
						src.loc=locate(rand(5,490),rand(5,490),1)
					if("Namek")
						src.loc=locate(rand(5,490),rand(5,490),3)
					if("Vegeta")
						src.loc=locate(rand(5,490),rand(5,490),10)
					if("Icer")
						src.loc=locate(rand(5,490),rand(5,490),9)
					if("Space")
						src.loc=locate(rand(5,490),rand(5,490),18)
					if("Other Realm")
						src.loc=locate(rand(5,490),rand(5,490),2)
					if("Dark Realm")
						src.loc=locate(rand(5,490),rand(5,490),6)
				return
	admin_kill(var/mob/m as mob in players)
		if(!src.key in StaffTeam) return
		if(m)
			m.KO()
			spawn(1) m.Death("Admin Killed")
			src.set_alert("[m] was killed",'alert.dmi',"alert")

mob
	var/list/StatMods = list()

	//var/tmp/StatModifiers[5] // Array to store stat modifiers
// Add a stat modifier to the Character
mob/proc/ScanPlanetCalc(var/list/M)
	var/list/outputplayers = list()
	outputplayers += M
	for(var/P in M)
		var/Lowest_Power=min(M)
		for(var/mob/A in players)
			if(Lowest_Power==round(A.psionic_power))
				if(A in outputplayers) continue
				var/text = add_tspace("<font color=green>( [dir2text(get_dir(A.loc,src.loc))]) - [src.get_strangername(A)]",20)
				text += " [Commas(min(M))]<br>"
				outputplayers += text
		M-=min(M)
		src<<"<b>-[outputplayers]</b>"
mob
	proc
		AddStatMod(name, value)
			//StatMods[ name ] = value
			if(!StatMods)
				StatMods = list()

			StatMods[name] = value


	    // Get the top three highest stat modifiers
		GetOthersTopThreeMods(var/mob/choice)
			var/top1
			var/top2
			var/top3

			var/v1 = 0
			var/v2 = 0
			var/v3 = 0

			for(var/stat in choice.StatMods)
				var/value = choice.StatMods[stat]

				if(value > v1)
					// Shift down
					v3 = v2
					top3 = top2

					v2 = v1
					top2 = top1

					v1 = value
					top1 = stat

				else if(value > v2)
					v3 = v2
					top3 = top2

					v2 = value
					top2 = stat

				else if(value > v3)
					v3 = value
					top3 = stat

			src << "<center><b>[choice]'s Best Modifiers</b></center>"

			if(top1) src << "<b>-[top1]</b>"
			if(top2) src << "<b>-[top2]</b>"
			if(top3) src << "<b>-[top3]</b>"
		GetTopThreeMods()
			var/top1
			var/top2
			var/top3

			var/v1 = 0
			var/v2 = 0
			var/v3 = 0

			for(var/stat in StatMods)
				var/value = StatMods[stat]

				if(value > v1)
					// Shift down
					v3 = v2
					top3 = top2

					v2 = v1
					top2 = top1

					v1 = value
					top1 = stat

				else if(value > v2)
					v3 = v2
					top3 = top2

					v2 = value
					top2 = stat

				else if(value > v3)
					v3 = value
					top3 = stat

			src << "<center><b>Best Modifiers</b></center>"

			if(top1) src << "<b>-[top1]</b>"
			if(top2) src << "<b>-[top2]</b>"
			if(top3) src << "<b>-[top3]</b>"



		/*GetTopThreeMods()
			var/list/sorted = list()

			// Copy only the keys (stat names)
			for(var/stat in StatMods)
				sorted += stat

			// Simple descending sort by value
			for(var/i = 1 to sorted.len)
				for(var/j = i + 1 to sorted.len)
					if(StatMods[sorted[j]] > StatMods[sorted[i]])
						var/temp = sorted[i]
						sorted[i] = sorted[j]
						sorted[j] = temp

			src << "<center><b>Best Modifiers</b></center>"

			for(var/k = 1 to min(3, sorted.len))
				src << "<b>-[sorted[k]]</b>"
				*/

mob/proc/AdjustAgeByYearMonth()
	// Round down to get full years and months from decimal year
	var/current_year = round(year)
	var/current_month = round((year - current_year) * 10)

	var/last_logout_year = round(LOYear)
	var/last_logout_month = round((LOYear - last_logout_year) * 10)

	// Calculate differences
	var/year_difference = current_year - last_logout_year
	var/month_difference = current_month - last_logout_month

	// Handle rollover (e.g., if they logged out in Month 9, now it's Month 1 of next year)
	if(month_difference < 0)
		year_difference -= 1
		month_difference += 10

	// Prevent negative values in edge cases (like corrupted data)
	if(year_difference < 0) year_difference = 0
	if(month_difference < 0) month_difference = 0

	// Calculate total time away as fractional years
	var/total_years_off = year_difference + (month_difference / 10)

	if(total_years_off <= 0)
		return

	// Apply to player
	age += total_years_off
	age_soul += total_years_off
	if(judgement_bid)
		judgement_bid -= year_difference

	src << "<font color=green>You grew older while offline by [year_difference] year(s), and [month_difference] month(s).</font>"

	// Update last seen year
	LOYear = year


mob/proc/BodyPcnt()
    //set background = 1
    var/mob/m = src
   // var/Primal = PrimeAt * 0.25
    //if(inDecline) return

   // Body = clamp(Body, 0.0001, 100)
    if(m.age < 4 )
        m.Body = 0.0001
    else if(m.age >= 4 && m.age <13)
        //m.Body = min(100, 25 + (75 * (m.age / m.prime) ** 2))
        m.Body = 0.2692
    else if(m.age >= 13 && m.age <21)
        //m.Body = min(100, 50 + (50 * (m.age / m.prime) ** 2))
        m.Body = 0.4528
    else if(m.age >=25)
        m.Body = 1
        /*if(m.age < m.prime)
            m.Body = min(100, 70 + (30 * ((m.age / m.prime) ** 3)))
        else if(m.age >= m.prime && m.age < m.lifespan)
            m.Body = 100*/
    if(m.age >= m.lifespan )
        var/age_over_decline = m.age - m.lifespan
        var/decline_rate = 0.03   // Decline rate: 3% per year over Decline
        m.Body = max(0.0001, 100 - (decline_rate * age_over_decline * 100))
        m.Body *= 0.01
          //  Body = 100 - max(1, 1 / ((Age / Decline) ** 4))
    // Changeling Race Modifier
    /*if(m.race == "Changeling")
        if(m.age >= 4 && m.age < 13)
            m.Body += 10*/


    // Ensure Body is within valid bounds
    m.Body = clamp(m.Body, 0.0001, 100)

    if(m.dead)
        if(m.has_body)
            m.Body = m.Body*0.12

    //if(isCyborged == 1)
   //     Body = 100

    //if(Immortal)	//Forever
  //      Body = 100

  //  if(Noobs.Find(key))
   //     Body = 1

    //m.Body *= 0.01
    //m<<"Body - [m.Body]"


mob/proc/start_lssj_rampage()
	if(src.skill_control_rampage.skill_lvl >=100)
		if(in_lssj_rampage) in_lssj_rampage = 0
		return
	if(in_lssj_rampage) return
	in_lssj_rampage = 1
	lssj_rampage_loop()

mob/proc/stop_lssj_rampage()
	in_lssj_rampage = 0

mob/proc/lssj_rampage_loop()
	set background = 1

	while(in_lssj_rampage && !src.koed && !src.stunned && !src.meditating && !src.selftraining)
		// Disable manual movement keys
		client.move_dir = 0
		client.input_dir = 0

		// Force random movement if not stunned or locked
		if(!src.koed && !src.stunned && !src.selftraining && !src.beaming && src.can_move)
			if(src.skill_control_rampage && prob(1))
				sleep(10)
				return
			var/dir_to_move = pick(NORTH, SOUTH, EAST, WEST)
			step(src, dir_to_move)

		// Random skill activation
		spawn(10)
			random_lssj_action()

		sleep(10) // adjust for pacing (1 = 0.1 sec, so 10 = 1 second)
mob/proc/random_lssj_action()
	// Add more chaos here if desired
	var/list/skills = list()
	for(var/obj/skills/s in src)
		if(!s.active && !s.disabled_switch && s.arsenal)
			skills += s

	if(skills.len)
		var/obj/skills/random_skill = pick(skills)
		call(random_skill.act)(src, random_skill)






mob/proc/start_oozaru_rampage()
	if(src.skill_control_oozaru.skill_lvl >=100)
		if(in_oozaru_rampage) in_oozaru_rampage = 0
		return
	if(in_oozaru_rampage) return
	in_oozaru_rampage = 1
	oozaru_rampage_loop()

mob/proc/stop_oozaru_rampage()
	in_oozaru_rampage = 0

mob/proc/oozaru_rampage_loop()
	set background = 1

	while(in_oozaru_rampage && !src.koed && !src.stunned && !src.meditating && !src.selftraining)
		// Disable manual movement keys
		client.move_dir = 0
		client.input_dir = 0

		// Force random movement if not stunned or locked
		if(!src.koed && !src.stunned && !src.selftraining && !src.beaming && src.can_move)
			if(src.skill_control_oozaru && prob(1))
				sleep(10)
				return
			var/dir_to_move = pick(NORTH, SOUTH, EAST, WEST)
			step(src, dir_to_move)

		// Random skill activation
		spawn(10)
			random_oozaru_action()

		sleep(10) // adjust for pacing (1 = 0.1 sec, so 10 = 1 second)
mob/proc/random_oozaru_action()
	// Add more chaos here if desired
	var/list/skills = list()
	for(var/obj/skills/s in src)
		if(!s.active && !s.disabled_switch && s.arsenal)
			skills += s

	if(skills.len)
		var/obj/skills/random_skill = pick(skills)
		call(random_skill.act)(src, random_skill)

mob
	proc
		update_body_age()
			//Find out if we're changing a clones appearance, a players, or the settings of a cloning tank.
			var/mob/target = src

			//if(target && target.race == "Alien")
			///	target.set_icon(target)
			//	return
			if(target)
				target.filters = null
				if(target.hair) target.overlays -= target.hair


			if(target.midget && target.age>12.9)
				return
			//Reset hair for some races, since they don't have any.
			var/obj/h = null
			if(target)
				/*if(target.race == "Saiyan" && target.skin_pos == 2)
					h = null
					if(target.hair)
						target.overlays -= target.hair
						target.hair = null
						target.hair_icon = null*/
				if(target.race == "Oni")
					if(age>=13) h = hairs_male[target.hair_pos]
					else if(age<13) h = kid_hairs_male[target.hair_pos]

				else if(target.race == "Namekian")
					if(age>=13) h = hairs_male[target.hair_pos]
					else if(age<13) h = kid_hairs_male[target.hair_pos]
				else if(target.gen == "Male")
					if(age>=13) h = hairs_male[target.hair_pos]
					else if (age<13) h = kid_hairs_male[target.hair_pos]
				else if(target.gen == "Female")
					if(age>=13) h = hairs_female[target.hair_pos]
					else if (age<13) h = kid_hairs_female[target.hair_pos]


			var/icon/i_race
			var/icon/i_horn
			var/obj/horn = new
			if(target)
				//Celestial icon creation

				if(target.race == "Spirit Doll")
					target.has_hair = 1
					if(target.skin_pos == 1)
						if(age>=13||age==null||age==21)
							i_race = 'spiritdoll.dmi'
						else if(age>=4 && age <13) i_race= 'spiritdoll_kid.dmi'
						else if(age<=0||age==0.1) i_race ='human_babymale.dmi'


					if(target.skin_pos == 2)
						if(age>=13||age==null||age==21)
							i_race = 'spiritdoll_tan.dmi'
						else if(age>=4 && age <13) i_race= 'spiritdoll_kidtan.dmi'
						else if(age<=0||age==0.1) i_race ='human_babymale.dmi'




				if(target.race == "Changeling")
					target.has_hair=0
					if(target.skin_pos == 1)
						if(age>=13||age==null||age==21)
							i_race = 'Frieza_1st_form.dmi'
						else if(age>=4 && age <13) i_race= 'Frieza_1st_form_kid.dmi'
						else if(age<=0||age==0.1) i_race = 'alien_egg.dmi'

					if(target.skin_pos == 2)
						if(age>13||age==null||age==21)
							i_race = '1stFriezaBlue.dmi'
						else if(age>=4 && age <13) i_race= '1stFriezaKid_Blue.dmi'
						else if(age<=0||age==0.1) i_race = 'alien_egg.dmi'

					if(target.skin_pos == 3)
						if(age>=13||age==null||age==21)
							i_race = '1stFriezaGreen.dmi'
						else if(age>=4 && age <13) i_race= '1stFriezaKid_Green.dmi'
						else if(age<=0||age==0.1) i_race = 'alien_egg.dmi'

					if(target.skin_pos == 4)
						if(age>=13||age==null|age==21)
							i_race = '1stFriezaOrange.dmi'
						else if(age>=4 && age <13) i_race= '1stFriezaKid_Orange.dmi'
						else if(age<=0||age==0.1) i_race = 'alien_egg.dmi'

					if(target.skin_pos == 5)
						if(age>=13||age==null||age==21)
							i_race = '1stFriezaRed.dmi'
						else if(age>=4 && age <13) i_race= '1stFriezaKid_Red.dmi'
						else if(age<=0||age==0.1) i_race = 'alien_egg.dmi'





				if(target.race == "Makyo")
					target.has_hair = 1
					if(target.skin_pos == 1)
						if(age>=13||age==null||age==21)
							i_race = 'makyo.dmi'
						else if(age>=4 && age <13) i_race= 'makyo_kid.dmi'
						else if(age<=0||age==0.1) i_race = 'alien_egg.dmi'

					if(target.skin_pos == 2)
						if(age>=13||age==null||age==21)
							i_race = 'makyo_red.dmi'
						else if(age>=4 && age <13) i_race= 'makyo_kidred.dmi'
						else if(age<=0||age==0.1) i_race = 'alien_egg.dmi'

					if(target.skin_pos == 3)
						if(age>=13||age==null||age==21)
							i_race = 'makyo_tan.dmi'
						else if(age>=4 && age <13) i_race= 'makyo_kidtan.dmi'
						else if(age<=0||age==0.1) i_race = 'alien_egg.dmi'

					if(target.skin_pos == 4)
						if(age>=13||age==null||age==21)
							i_race = 'makyo_purple.dmi'
						else if(age>=4 && age <13) i_race= 'makyo_kidpurple.dmi'
						else if(age<=0||age==0.1) i_race = 'alien_egg.dmi'




				if(target.race == "Kai")
					target.has_hair = 1
					if(target.gen == "Male")
						if(age>=13||age==null||age==21)
							i_race = 'humanoid_no_colour2.dmi'
						else if(age>=4 && age <13) i_race= 'humanoid_no_colour2_kid.dmi'
						else if(age<=0||age==0.1) i_race = 'alien_egg.dmi'

					if(target.gen == "Female")
						if(age>=13||age==null||age==21)
							i_race = 'humanoid_no_colour_female2.dmi'
						else if(age>=4 && age <13) i_race= 'humanoid_no_colour_female2_kid.dmi'
						else if(age<=0||age==0.1) i_race = 'alien_egg.dmi'




				if(target.race == "Alien")
					target.has_hair = 1
					if(target.skin_pos == 1)
						if(age>=13||age==null||age==21)
							i_race = 'Alien_Captin_Ginyu_Naked.dmi'
						else if(age>=4 && age <13) i_race= 'alien_captginyu_kid.dmi'
						else if(age<=0||age==0.1) i_race = 'alien_egg.dmi'

					if(target.skin_pos == 2)
						if(age>=13||age==null||age==21)
							i_race =  'Alien_Immecka_Naked.dmi'
						else if(age>=4 && age <13) i_race = 'alien_immecka_kid.dmi'
						else if(age<=0||age==0.1) i_race = 'alien_egg.dmi'


					if(target.skin_pos == 3)
						if(age>=13||age==null||age==21)
							i_race = 'Alien_Kanassa_Naked.dmi'
						else if(age>=4 && age <13) i_race = 'alien_kanassa_kid.dmi'
						else if(age<=0||age==0.1) i_race = 'alien_egg.dmi'


					if(target.skin_pos == 4)
						if(age>=13||age==null||age==21)
							i_race ='Alien_Kui_Naked.dmi'
						else if(age>=4 && age <13) i_race = 'alien_kui_kid.dmi'
						else if(age<=0||age==0.1) i_race = 'alien_egg.dmi'

					if(target.skin_pos == 5)
						if(age>=13||age==null||age==21)
							i_race ='Alien_Yardrat_Naked.dmi'
						else if(age>=4 && age <13) i_race = 'alien_yardrat_kid.dmi'
						else if(age<=0||age==0.1) i_race = 'alien_egg.dmi'

					if(target.skin_pos == 6)
						if(age>=13||age==null||age==1||age==21)
							i_race = 'NewMalesWhite.dmi'
						else if(age>=4 && age <13) i_race = 'human_male_white_kid.dmi'
						else if(age<=0||age==0.1) i_race = 'human_babymale.dmi'


					if(target.skin_pos == 7)
						if(age>=13||age==null||age==1||age==21)
							i_race = 'NewMalesTan.dmi'
						else if(age>=4 && age <13) i_race = 'human_male_tan_kid.dmi'
						else if(age<=0||age==0.1) i_race = 'human_babymale_tan.dmi'


					if(target.skin_pos == 8)
						if(age>=13||age==null||age==1||age==21)
							i_race = 'NewMalesBlack.dmi'
						else if(age>=4 && age <13) i_race = 'human_male_black_kid.dmi'
						else if(age<=0||age==0.1) i_race = 'human_babymale_black.dmi'

				if(target.race == "Demon")
					target.has_hair =1
					if(target.age>=13)
						i_horn = 'Demonic Horns.dmi'
						target.horn_pos = 1
					else if(target.age<=12.9)
						i_horn = 'demonic_horns_kid.dmi'
						target.horn_pos = 2
					if(target.gen == "Male")
						if(target.skin_pos == 1)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'demon_default_male.dmi'
								target.horn_pos = 1
								if(target.horn_pos == 1) i_horn = 'Demonic Horns.dmi'
							//	target.overlays += target.body_horns
							else if(age>=4 && age <13)
								target.horn_pos = 2
								if(target.horn_pos == 2) i_horn = 'demonic_horns_kid.dmi'
								i_race = 'Humanoid_Kid_Colorable.dmi'
							else if(age<=0||age==0.1)
								target.horn_pos = 2
								if(target.horn_pos == 2) i_horn = 'demonic_horns_kid.dmi'
								i_race = 'alien_egg.dmi'

						if(target.skin_pos == 2)
							if(age>=13||age==null||age==1||age==21)
								target.horn_pos = 1
								if(target.horn_pos == 1) i_horn = 'Demonic Horns.dmi'
								i_race = 'demon_male.dmi'

							//	target.overlays += target.body_horns
							else if(age>=4 && age <13)
								target.horn_pos = 2
								if(target.horn_pos == 2) i_horn = 'demonic_horns_kid.dmi'
								i_race = 'Humanoid_Kid_Colorable.dmi'
							else if(age<=0||age==0.1)
								target.horn_pos = 2
								if(target.horn_pos == 2) i_horn = 'demonic_horns_kid.dmi'
								i_race = 'alien_egg.dmi'
						if(target.skin_pos == 3)
							if(age>=13||age==null||age==1||age==21)
								target.horn_pos = 1
								if(target.horn_pos == 1) i_horn = 'Demonic Horns.dmi'
								i_race = 'NewMalesWhite.dmi'
								target.overlays += target.body_horns
							else if(age>=4 && age <13)
								target.horn_pos = 2
								if(target.horn_pos == 2) i_horn = 'demonic_horns_kid.dmi'
								i_race = 'human_male_white_kid.dmi'
							else if(age<=0||age==0.1)
								target.horn_pos = 2
								if(target.horn_pos == 2) i_horn = 'demonic_horns_kid.dmi'
								i_race = 'human_babymale.dmi'

						if(target.skin_pos == 4)
							if(age>=13||age==null||age==1||age==21)
								target.horn_pos = 1
								if(target.horn_pos == 1) i_horn = 'Demonic Horns.dmi'
								i_race = 'NewMalesTan.dmi'
							//	target.overlays += target.body_horns
							else if(age>=4 && age <13)
								target.horn_pos = 2
								if(target.horn_pos == 2) i_horn = 'demonic_horns_kid.dmi'
								i_race = 'human_male_tan_kid.dmi'
							else if(age<=0||age==0.1)
								target.horn_pos = 2
								if(target.horn_pos == 2) i_horn = 'demonic_horns_kid.dmi'
								i_race = 'human_babymale_tan.dmi'

						if(target.skin_pos == 5)
							if(age>=13||age==null||age==1||age==21)
								target.horn_pos = 1
								if(target.horn_pos == 1) i_horn = 'Demonic Horns.dmi'
								i_race = 'NewMalesBlack.dmi'
							//	target.overlays += target.body_horns
							else if(age>=4 && age <13)
								target.horn_pos = 2
								if(target.horn_pos == 2) i_horn = 'demonic_horns_kid.dmi'
								i_race = 'human_male_black_kid.dmi'
							else if(age<=0||age==0.1)
								target.horn_pos = 2
								if(target.horn_pos == 2) i_horn = 'demonic_horns_kid.dmi'
								i_race = 'human_babymale_black.dmi'

					if(target.gen == "Female")
						target.has_hair = 1
						if(age>=13||age==null||age==1||age==21)
							target.horn_pos = 1
							if(target.horn_pos == 1) i_horn = 'Demonic Horns.dmi'
						//	target.overlays += target.body_horns
						else if(age>=4 && age <13)
							target.horn_pos = 2
							if(target.horn_pos == 2) i_horn = 'demonic_horns_kid.dmi'
						if(target.skin_pos == 1)
							target.horn_pos = 1
							if(target.horn_pos == 1) i_horn = 'Demonic Horns.dmi'
							i_race = 'demon_default_female.dmi'
							target.has_hair = 1
						if(target.skin_pos == 2)
							target.horn_pos = 1
							if(target.horn_pos == 1) i_horn = 'Demonic Horns.dmi'
							i_race = 'demon_female.dmi'
							target.has_hair = 1
						if(target.skin_pos == 3)
							if(age>=13||age==null||age==1||age==21)
								target.horn_pos = 1
								if(target.horn_pos == 1) i_horn = 'Demonic Horns.dmi'
								i_race = 'FemaleBaseWhite.dmi'
							//	target.overlays += target.body_horns
							else if(age>=4 && age <13)
								target.horn_pos = 2
								if(target.horn_pos == 2) i_horn = 'demonic_horns_kid.dmi'
								i_race = 'human_female_white_kid.dmi'
							else if(age<=0||age==0.1)
								target.horn_pos = 2
								if(target.horn_pos == 2) i_horn = 'demonic_horns_kid.dmi'
								i_race = 'human_babyfemale.dmi'
						if(target.skin_pos == 4)
							if(age>=13||age==null||age==1||age==21)
								target.horn_pos = 1
								if(target.horn_pos == 1) i_horn = 'Demonic Horns.dmi'
								i_race = 'FemaleBaseTan.dmi'
							//	target.overlays += target.body_horns
							else if(age>=4 && age <13)
								target.horn_pos = 2
								if(target.horn_pos == 2) i_horn = 'demonic_horns_kid.dmi'
								i_race = 'human_female_tan_kid.dmi'
							else if(age<=0||age==0.1)
								target.horn_pos = 2
								if(target.horn_pos == 2) i_horn = 'demonic_horns_kid.dmi'
								i_race = 'human_babyfemale_tan.dmi'
						if(target.skin_pos == 5)
							if(age>=13||age==null||age==1||age==21)
								target.horn_pos = 1
								if(target.horn_pos == 1) i_horn = 'Demonic Horns.dmi'
								i_race = 'FemaleBaseBlack.dmi'
							//	target.overlays += target.body_horns
							else if(age>=4 && age <13)
								target.horn_pos = 2
								if(target.horn_pos == 2) i_horn = 'demonic_horns_kid.dmi'
								i_race = 'human_female_black_kid.dmi'
							else if(age<=0||age==0.1)
								target.horn_pos = 2
								if(target.horn_pos == 2) i_horn = 'demonic_horns_kid.dmi'
								i_race = 'human_babyfemale_black.dmi'


				//Yukopian horns
				if(target.race == "Namekian")
					/*if(target.horn_pos == 1) i_horn = 'horns_yukopian_01.dmi'
					if(target.horn_pos == 2) i_horn = 'horns_yukopian_02.dmi'
					if(target.horn_pos == 3) i_horn = 'horns_yukopian_03.dmi'
					if(target.horn_pos == 4) i_horn = 'horns_yukopian_04.dmi' */
					if(target.skin_pos == 1)
						if(age>=13||age==null||age==1||age==21)
							i_race = 'NewNamekianAdult4.dmi'
						else if(age>=4 && age <13)
							i_race = 'NewKidNamekian4.dmi'

						else if(age<=0||age==0.1)
							i_race = 'namekian_egg.dmi'

					if(target.skin_pos == 2)
						if(age>=13||age==null||age==1||age==21)
							i_race = 'NewNamekianAdult3.dmi'
						else if(age>=4 && age <13)
							i_race = 'NewKidNamekian3.dmi'

						else if(age<=0||age==0.1)
							i_race = 'namekian_egg.dmi'



					if(target.skin_pos == 3)
						if(age>=13||age==null||age==1||age==21)
							i_race = 'NewNamekianAdult2.dmi'
						else if(age>=4 && age <13)
							i_race = 'NewKidNamekian2.dmi'

						else if(age<=0||age==0.1)
							i_race = 'namekian_egg.dmi'


					if(target.skin_pos == 4)
						if(age>=13||age==null||age==1||age==21)
							i_race = 'NewNamekianAdult1.dmi'
						else if(age>=4 && age <13)
							i_race = 'NewKidNamekian1.dmi'

						else if(age<=0||age==0.1)
							i_race = 'namekian_egg.dmi'

				//Android icon creation
				if(target.race == "Saiyan")
					target.has_hair = 1
					i_horn = 'SaiyanTailBrown.dmi'
					//i_horn = 'SaiyanTailBlack.dmi'
					if(target.gen == "Male")
						if(target.skin_pos == 1)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'NewMalesWhite.dmi'
							else if(age>=4 && age <13) i_race = 'human_male_white_kid.dmi'
							else if(age<=0||age==0.1) i_race = 'human_babymale.dmi'
						if(target.skin_pos == 2)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'NewMalesTan.dmi'
							else if(age>=4 && age <13) i_race = 'human_male_tan_kid.dmi'
							else if(age<=0||age==0.1) i_race = 'human_babymale_tan.dmi'
						if(target.skin_pos == 3)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'NewMalesBlack.dmi'
							else if(age>=4 && age <13) i_race = 'human_male_black_kid.dmi'
							else if(age<=0||age==0.1) i_race = 'human_babymale_black.dmi'

					if(target.gen == "Female")
						if(target.skin_pos == 1)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'FemaleBaseWhite.dmi'
							else if(age>=4 && age <13) i_race = 'human_female_white_kid.dmi'
							else if(age<=0||age==0.1) i_race = 'human_babyfemale.dmi'

						if(target.skin_pos == 2)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'FemaleBaseTan.dmi'
							else if(age>=4 && age <13) i_race = 'human_female_tan_kid.dmi'
							else if(age<=0||age==0.1) i_race = 'human_babyfemale_tan.dmi'
						if(target.skin_pos == 3)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'FemaleBaseBlack.dmi'
							else if(age>=4 && age <13) i_race = 'human_female_black_kid.dmi'
							else if(age<=0||age==0.1) i_race = 'human_babyfemale_black.dmi'

				if(target.race == "Half God")
					target.has_hair = 1
					if(target.gen == "Male")
						if(target.skin_pos == 1) i_race = 'NewMalesWhite.dmi'
						if(target.skin_pos == 2) i_race = 'NewMalesTan.dmi'
						if(target.skin_pos == 3) i_race = 'NewMalesBlack.dmi'
					if(target.gen == "Female")
						if(target.skin_pos == 1) i_race = 'FemaleBaseWhite.dmi'
						if(target.skin_pos == 2) i_race = 'FemaleBaseTan.dmi'
						if(target.skin_pos == 3) i_race = 'FemaleBaseBlack.dmi'
				if(target.race == "Tuffle")
					target.has_hair = 1
					if(target.gen == "Male")
						if(target.skin_pos == 1)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'NewMalesWhite.dmi'
							else if(age>=4 && age <13) i_race = 'human_male_white_kid.dmi'
							else if(age<=0||age==0.1) i_race = 'human_babymale.dmi'
						if(target.skin_pos == 2)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'NewMalesTan.dmi'
							else if(age>=4 && age <13) i_race = 'human_male_tan_kid.dmi'
							else if(age<=0||age==0.1) i_race = 'human_babymale_tan.dmi'
						if(target.skin_pos == 3)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'NewMalesBlack.dmi'
							else if(age>=4 && age <13) i_race = 'human_male_black_kid.dmi'
							else if(age<=0||age==0.1) i_race = 'human_babymale_black.dmi'


					if(target.gen == "Female")
						if(target.skin_pos == 1)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'FemaleBaseWhite.dmi'
							else if(age>=4 && age <13) i_race = 'human_female_white_kid.dmi'
							else if(age<=0||age==0.1) i_race = 'human_babyfemale.dmi'

						if(target.skin_pos == 2)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'FemaleBaseTan.dmi'
							else if(age>=4 && age <13) i_race = 'human_female_tan_kid.dmi'
							else if(age<=0||age==0.1) i_race = 'human_babyfemale_tan.dmi'
						if(target.skin_pos == 3)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'FemaleBaseBlack.dmi'
							else if(age>=4 && age <13) i_race = 'human_female_black_kid.dmi'
							else if(age<=0||age==0.1) i_race = 'human_babyfemale_black.dmi'
				//Human icon creation

				if(target.race == "Human")
					target.has_hair = 1
					if(target.gen == "Male")
						if(target.skin_pos == 1)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'NewMalesWhite.dmi'
							else if(age>=4 && age <13) i_race = 'human_male_white_kid.dmi'
							else if(age<=0||age==0.1) i_race = 'human_babymale.dmi'
						if(target.skin_pos == 2)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'NewMalesTan.dmi'
							else if(age>=4 && age <13) i_race = 'human_male_tan_kid.dmi'
							else if(age<=0||age==0.1) i_race = 'human_babymale_tan.dmi'
						if(target.skin_pos == 3)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'NewMalesBlack.dmi'
							else if(age>=4 && age <13) i_race = 'human_male_black_kid.dmi'
							else if(age<=0||age==0.1) i_race = 'human_babymale_black.dmi'

					if(target.gen == "Female")
						if(target.skin_pos == 1)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'FemaleBaseWhite.dmi'
							else if(age>=4 && age <13) i_race = 'human_female_white_kid.dmi'
							else if(age<=0||age==0.1) i_race = 'human_babyfemale.dmi'

						if(target.skin_pos == 2)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'FemaleBaseTan.dmi'
							else if(age>=4 && age <13) i_race = 'human_female_tan_kid.dmi'
							else if(age<=0||age==0.1) i_race = 'human_babyfemale_tan.dmi'
						if(target.skin_pos == 3)
							if(age>=13||age==null||age==1||age==21)
								i_race = 'FemaleBaseBlack.dmi'
							else if(age>=4 && age <13) i_race = 'human_female_black_kid.dmi'
							else if(age<=0||age==0.1) i_race = 'human_babyfemale_black.dmi'
				//Imp icon creation
				if(target.race == "Oni")
					i_horn = 'OniHorns.dmi'
					if(target.skin_pos == 1)
						if(age>=13||age==null||age==1||age==21)
							i_race = 'oni_male_light.dmi'
							target.horn_pos = 1
							if(target.horn_pos == 1) i_horn = 'OniHorns.dmi'

							//target.overlays += target.body_horns
						else if(age>=4 && age <13)
							target.horn_pos = 2
							if(target.horn_pos == 2) i_horn = 'oni_horns_kid.dmi'
							i_race = 'oni_male_light_kid.dmi'
						else if(age<=0||age==0.1)
							target.horn_pos = 2
							if(target.horn_pos == 2) i_horn = 'oni_horns_kid.dmi'
							i_race = 'alien_egg.dmi'

					if(target.skin_pos == 2)
						if(age>=13||age==null||age==1||age==21)
							target.horn_pos = 1
							if(target.horn_pos == 1) i_horn = 'OniHorns.dmi'
							i_race = 'oni_male_dark.dmi'
						//	target.overlays += target.body_horns
						else if(age>=4 && age <13)
							target.horn_pos = 2
							if(target.horn_pos == 2) i_horn = 'oni_horns_kid.dmi'
							i_race = 'oni_male_dark_kid.dmi'
						else if(age<=0||age==0.1)
							target.horn_pos = 2
							if(target.horn_pos == 2) i_horn = 'oni_horns_kid.dmi'
							i_race = 'alien_egg.dmi'
						target.has_hair = 1
					if(target.skin_pos == 3)
						if(age>=13||age==null||age==1||age==21)
							target.horn_pos = 1
							if(target.horn_pos == 1) i_horn = 'OniHorns.dmi'
							i_race = 'oni_male_light.dmi'
						//	target.overlays += target.body_horns
						else if(age>=4 && age <13)
							target.horn_pos = 2
							if(target.horn_pos == 2) i_horn = 'oni_horns_kid.dmi'
							i_race = 'oni_male_light_kid.dmi'
						else if(age<=0||age==0.1)
							target.horn_pos = 2
							if(target.horn_pos == 2) i_horn = 'oni_horns_kid.dmi'
							i_race = 'alien_egg.dmi'

			if(target) target.icon = i_race

			//world << "Debug - i_race = [i_race]"
			var/icon/I = icon(i_race,"",SOUTH,1,0)
			I.Scale(128,128)

			//Do hair and hair color
			if(h)

				var/icon/E = icon(h.icon,"",SOUTH,1,0)
				var/icon/E_hair = icon(h.icon)
				E.Scale(128,128)

				if(target && target.hair_c)
					E.Blend(target.hair_c)
					E_hair.Blend(target.hair_c)

				I.Blend(E,ICON_OVERLAY,1,13)

				if(target && target.has_hair >= 1)
					var/obj/new_hair = new h.type
					new_hair.icon = E_hair
					target.hair = new_hair
					target.hair_icon = new_hair.icon
					target.overlays = null
					target.overlays += target.hair
					target.vis_contents += E_hair

			//target.set_icon(target)

			//Do eye color next
			if(target.eyes)
				target.vis_contents -= target.eyes
				target.eyes = null
			if(target.eyes_white)
				target.vis_contents -= target.eyes_white
				target.eyes_white = null
			var/i_white = 'eye_whites.dmi'
			var/i_iris = 'eye_pupils.dmi'
			if(target.age<13 && target.age >3.9) i_white = 'eye_whites_kid.dmi'
			if(target.age<13 && target.age >3.9) i_iris = 'eye_pupils_kid.dmi'
			/*if(target.race == "Android" && target.skin_pos == 1)
				i_white = 'humanoid_eyes_iris_android.dmi'
				i_iris = 'humanoid_eyes_iris_android.dmi'*/
			if(target.race == "Oni")
				if(target.age<13 && target.age >3.9) i_white = 'eye_whites_kid.dmi'
				if(target.age<13 && target.age >3.9) i_iris = 'eye_pupils_kid.dmi'
				i_white = 'eye_whites.dmi'
				i_iris = 'eye_pupils.dmi'
			var/icon/P_white = icon(i_white,"",SOUTH,1,0)
			var/icon/P_eyecolor = icon(i_iris,"",SOUTH,1,0)
			if(target.has_eyes)
				var/proceed_eyes = 1


				if(proceed_eyes)
					var/has_white = 1
					//if(target.race == "Android" && target.skin_pos == 1) has_white = 0
					if(has_white)
						P_white.Scale(128,128)
						I.Blend(P_white,ICON_OVERLAY)

					P_eyecolor.Scale(128,128)
					if(target.eye_c) P_eyecolor.Blend(target.eye_c)
					else P_eyecolor.Blend(rgb(0,0,155))
					I.Blend(P_eyecolor,ICON_OVERLAY)

					if(has_white)
						var/obj/eye_white = new
						eye_white.icon = i_white
						eye_white.layer = 10
						eye_white.vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_ICON_STATE// | VIS_INHERIT_ID
						if(target.age>=13)
							target.eyes_white = eye_white
							target.vis_contents += target.eyes_white

					var/obj/eye_iris = new
					eye_iris.icon = i_iris
					var/icon/eye = new(eye_iris.icon)
					if(target.eye_c) eye.icon *= eye_c
						//eye.Blend(target.eye_c)
					eye_iris.icon = eye
					eye_iris.layer = 11
					eye_iris.vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_ICON_STATE// | VIS_INHERIT_ID // | VIS_INHERIT_DIR// | VIS_INHERIT_LAYER
					target.eyes = eye_iris
					if(target.age>=13)
						target.eyes.pixel_x = 0
						target.eyes_white.pixel_y = 0
						target.vis_contents += target.eyes_white
						target.vis_contents += target.eyes
						target.overlays+= target.eyes_white
						target.overlays += target.eyes
					if(target.age<13)
						target.eyes_white.pixel_x = -1
						target.eyes_white.pixel_y = -5
						target.eyes.pixel_x = -1
						target.eyes.pixel_y = -5
						target.vis_contents += target.eyes_white
						target.vis_contents += target.eyes
						target.overlays+= target.eyes_white
						target.overlays += target.eyes
					//target.overlays += P_eyecolor

				/*
				if(target.race == "Android")
					if(target.skin_pos == 1 || target.skin_pos == 2)
						target.vis_contents -= target.eyes
						target.eyes = null
						target.vis_contents -= target.eyes_white
						target.eyes_white = null
				*/
			if(target.race == "Demon")
				if(target.age>=13 || target.age == null || target.age == 1)
					target.overlays += 'Demonic Horns.dmi'
				else if(target.age<=4)
					target.overlays += 'demonic_horns_kid.dmi'
			else if(target.race == "Oni")
				if(target.age>=13 || target.age == null || target.age == 1)
					target.overlays += 'OniHorns.dmi'
				else if(target.age<=4)
					target.overlays += 'oni_horns_kid.dmi'
			//Now set the actual in game portrait
			if(i_horn)
				var/icon/race = icon(i_race,"",SOUTH,1,0)
				var/icon/horns = icon(i_horn,"",SOUTH,1,0)
				var/obj/hrn_chosen
				if(target.race == "Saiyan") hrn_chosen = saiyan_tails[target.horn_pos]
				if(target.race == "Oni") hrn_chosen = horns_oni[target.horn_pos]
				if(target.race == "Demon") hrn_chosen = body_horns[target.horn_pos]
				var/icon/hrn = icon(hrn_chosen.icon)
				horn.icon = hrn
				//horn.pixel_x = -8
				horn.layer = 25
				race.Shift(EAST,8)
				horns.Blend(race,ICON_UNDERLAY)
				P_white.Scale(88,88)
				P_eyecolor.Scale(88,88)
				P_white.Shift(EAST,20)
				P_eyecolor.Shift(EAST,20)
				P_white.Shift(SOUTH,2)
				P_eyecolor.Shift(SOUTH,2)
				horns.Scale(128,128)
				horns.Blend(P_white,ICON_OVERLAY)
				horns.Blend(P_eyecolor,ICON_OVERLAY)
				target.save_icon = horns

				target.horns = horn
				//target.overlays = null
				target.overlays += target.horns

mob
	proc
		autolearn()
			set background = 1
			var/mob/m = src
			if(m.move_lvl>0)
				if(m.age>=18&&!(locate(/obj/skills/Conceive_Offspring) in src))
					if(prob(1))
						var/obj/skills/Conceive_Offspring/co = new
						co.loc = m
						//for(var/obj/skills/Flight/A in src)
						//	A.learning=1
						//	A.suffix="Test"//"-  [A.learnpcnt]%"
							//src.LearningSkills+=A
							//src.isLearning=1
						//m << output("<font color = white><b>You learn the basics of Blast on your own!</b></font>","chat.alerts")
						m.set_alert("You learn the basics of Mating on your own!",'alert.dmi',"skill")
						m<<"<b>You learn the basics of Mating on your own!</b>"
				// RANKED SKILLS
				if(m.occupation!="None")
					switch(m.occupation)
						if("Spr. Demon Lord")
							if(m.energy_max>=5000&&m.move_lvl>=1&&!(locate(/obj/skills/Soul_Absorb) in src))
								if(prob(1))
									var/obj/skills/Soul_Absorb/bl = new
									bl.loc = m
									//for(var/obj/skills/Flight/A in src)
									//	A.learning=1
									//	A.suffix="Test"//"-  [A.learnpcnt]%"
										//src.LearningSkills+=A
										//src.isLearning=1
									//m << output("<font color = white><b>You learn the basics of Blast on your own!</b></font>","chat.alerts")
									m.set_alert("You learn the basics of Soul Absorb on your own!",'alert.dmi',"skill")
									m<<"<b>You learn the basics of Soul Absorb on your own!</b>"
							if(m.energy_max>=10000&&m.move_lvl>=20&&!(locate(/obj/skills/Decline_Absorb) in src))
								if(m.race == "Demon")

									if(prob(1))
										var/obj/skills/Decline_Absorb/Ex = new
										Ex.loc = m
										m.set_alert("You learn the basics of Decline Absorb on your own!",'alert.dmi',"skill")
										m<<"<b>You learn the basics of Decline Absorb on your own!</b>"
						if("Demon Lord")
							if(m.energy_max>=10000&&m.move_lvl>=20&&!(locate(/obj/skills/Decline_Absorb) in src))
								if(m.race == "Demon")

									if(prob(1))
										var/obj/skills/Decline_Absorb/Ex = new
										Ex.loc = m
										m.set_alert("You learn the basics of Decline Absorb on your own!",'alert.dmi',"skill")
										m<<"<b>You learn the basics of Decline Absorb on your own!</b>"
						if("Supreme Kai")
							if(m.magicxp>=2000&&m.move_lvl>=10&&!(locate(/obj/skills/Divine_Weapon) in src))
								if(m.race == "Kai" && m.magicxp>=2500 && m.energy_max >=100000)
									if(prob(0.1))
										var/obj/skills/Divine_Weapon/Ex = new
										Ex.loc = m
										m.set_alert("You learn the basics of Creating Divine Weapons on your own!",'alert.dmi',"skill")
										m<<"<b>You learn the basics of Creating Divine Weapons on your own!</b>"
							if(m.energy_max>=10000&&m.move_lvl>=20&&!(locate(/obj/skills/UnlockPotential) in src))
								if(m.race == "Kai")

									if(prob(1))
										var/obj/skills/UnlockPotential/Ex = new
										Ex.loc = m
										m.set_alert("You learn the basics of Unlock Potential on your own!",'alert.dmi',"skill")
										m<<"<b>You learn the basics of Unlock Potential on your own!</b>"
						if("North Kai")
							if(m.energy_max>=10000&&m.move_lvl>=10&&!(locate(/obj/skills/Kaioken) in src))
								if(m.race == "Kai")

									if(prob(1))
										var/obj/skills/Kaioken/Ex = new
										Ex.loc = m
										m.set_alert("You learn the basics of Kaioken on your own!",'alert.dmi',"skill")
										m<<"<b>You learn the basics of Kaioken on your own!</b>"
						if("South Kai")
							if(m.energy_max>=10000&&m.move_lvl>=10&&!(locate(/obj/skills/Kaioryu) in src))
								if(m.race == "Kai")

									if(prob(1))
										var/obj/skills/Kaioryu/Ex = new
										Ex.loc = m
										m.set_alert("You learn the basics of Kaioryu on your own!",'alert.dmi',"skill")
										m<<"<b>You learn the basics of Kaioryu on your own!</b>"
						if("East Kai")
							if(m.energy_max>=10000&&m.move_lvl>=10&&!(locate(/obj/skills/Kaiosoku) in src))
								if(m.race == "Kai")

									if(prob(1))
										var/obj/skills/Kaiosoku/Ex = new
										Ex.loc = m
										m.set_alert("You learn the basics of Kaiosoku on your own!",'alert.dmi',"skill")
										m<<"<b>You learn the basics of Kaiosoku on your own!</b>"
						if("West Kai")
							if(m.energy_max>=10000&&m.move_lvl>=10&&!(locate(/obj/skills/Kaioenjin) in src))
								if(m.race == "Kai")

									if(prob(1))
										var/obj/skills/Kaioenjin/Ex = new
										Ex.loc = m
										m.set_alert("You learn the basics of Kaioenjin on your own!",'alert.dmi',"skill")
										m<<"<b>You learn the basics of Kaioenjin on your own!</b>"
						if("Elder")
							if(m.magicxp>=2000&&m.move_lvl>=10&&!(locate(/obj/skills/Divine_Weapon) in src))
								if(m.race == "Namekian" && m.magicxp>=2500 && m.energy_max >=100000)
									if(prob(0.1))
										var/obj/skills/Divine_Weapon/Ex = new
										Ex.loc = m
										m.set_alert("You learn the basics of Creating Divine Weapons on your own!",'alert.dmi',"skill")
										m<<"<b>You learn the basics of Creating Divine Weapons on your own!</b>"
							if(m.energy_max>=10000&&m.move_lvl>=20&&!(locate(/obj/skills/UnlockPotential) in src))
								if(m.race == "Namekian")

									if(prob(1))
										var/obj/skills/UnlockPotential/Ex = new
										Ex.loc = m
										m.set_alert("You learn the basics of Unlock Potential on your own!",'alert.dmi',"skill")
										m<<"<b>You learn the basics of Unlock Potential on your own!</b>"
							if(m.energy_max>=10000&&m.move_lvl>=10&&!(locate(/obj/skills/Create_Namekian_Dragonballs) in src))
								if(m.race == "Namekian")

									if(prob(1))
										var/obj/skills/Create_Namekian_Dragonballs/Ex = new
										Ex.loc = m
										m.set_alert("You learn the basics of Summoning Dragonalls on your own!",'alert.dmi',"skill")
										m<<"<b>You learn the basics of Summoning Dragonalls on your own!</b>"
						if("Guardian")
							if(m.energy_max>=10000&&m.move_lvl>=10&&!(locate(/obj/skills/Create_Dragonballs) in src))
								if(prob(1))
									var/obj/skills/Create_Dragonballs/Ex = new
									Ex.loc = m
									m.set_alert("You learn the basics of Summoning Dragonalls on your own!",'alert.dmi',"skill")
									m<<"<b>You learn the basics of Summoning Dragonalls on your own!</b>"

				// GENERIC SKILLS
				if(m.race == "Saiyan" && m.move_lvl>=8&&!(locate(/obj/skills/Control_Oozaru) in src))
					if(prob(1))
						var/obj/skills/Control_Oozaru/oz = new
						oz.loc = m
						//for(var/obj/skills/Flight/A in src)
						//	A.learning=1
						//	A.suffix="Test"//"-  [A.learnpcnt]%"
							//src.LearningSkills+=A
							//src.isLearning=1
						//m << output("<font color = white><b>You learn the basics of Blast on your own!</b></font>","chat.alerts")
						m.set_alert("You learn the basics of Control Oozaru on your own!",'alert.dmi',"skill")
						m<<"<b>You learn the basics of Control Oozaru on your own!</b>"
				if(m.race == "Saiyan" && m.move_lvl>=8&&m.LSSJ&&!(locate(/obj/skills/Control_Rampage) in src))
					if(prob(1))
						var/obj/skills/Control_Rampage/oz = new
						oz.loc = m
						//for(var/obj/skills/Flight/A in src)
						//	A.learning=1
						//	A.suffix="Test"//"-  [A.learnpcnt]%"
							//src.LearningSkills+=A
							//src.isLearning=1
						//m << output("<font color = white><b>You learn the basics of Blast on your own!</b></font>","chat.alerts")
						m.set_alert("You learn the basics of Control Rampage on your own!",'alert.dmi',"skill")
						m<<"<b>You learn the basics of Control Rampage on your own!</b>"
				if(m.race_class == "Speed" && m.move_lvl>=2&&!(locate(/obj/skills/Precision) in src) &&m.mod_agility>=1.75)
					if(prob(1))
						var/obj/skills/Precision/pr = new
						pr.loc = m
						//for(var/obj/skills/Flight/A in src)
						//	A.learning=1
						//	A.suffix="Test"//"-  [A.learnpcnt]%"
							//src.LearningSkills+=A
							//src.isLearning=1
						//m << output("<font color = white><b>You learn the basics of Blast on your own!</b></font>","chat.alerts")
						m.set_alert("You learn the basics of Precision on your own!",'alert.dmi',"skill")
						m<<"<b>You learn the basics of Precision on your own!</b>"

				if(m.energy_max>=5000&&m.move_lvl>=1&&!(locate(/obj/skills/Blast) in src))
					if(prob(1))
						var/obj/skills/Blast/bl = new
						bl.loc = m
						//for(var/obj/skills/Flight/A in src)
						//	A.learning=1
						//	A.suffix="Test"//"-  [A.learnpcnt]%"
							//src.LearningSkills+=A
							//src.isLearning=1
						//m << output("<font color = white><b>You learn the basics of Blast on your own!</b></font>","chat.alerts")
						m.set_alert("You learn the basics of Blast on your own!",'alert.dmi',"skill")
						m<<"<b>You learn the basics of Blast on your own!</b>"
				if(m.energy_max>=7500&&m.move_lvl>=1&&!(locate(/obj/skills/Flight) in src))
					if(prob(1))
						var/obj/skills/Flight/fl = new
						fl.loc = m
						//for(var/obj/skills/Flight/A in src)
						//	A.learning=1
						//	A.suffix="Test"//"-  [A.learnpcnt]%"
							//src.LearningSkills+=A
							//src.isLearning=1
						m << output("<font color = white><b>You learn the basics of Fly on your own!</b></font>","chat.alerts")
						m.set_alert("You learn the basics of Fly on your own!",'alert.dmi',"skill")
						m<<"<b>You learn the basics of Fly on your own!</b>"
				if(m.energy_max>=10000&m.move_lvl>=1&&!(locate(/obj/skills/Zanzoken) in src))
					if(prob(0.8))
						var/obj/skills/Zanzoken/Ss = new
						Ss.loc = m
						m.set_alert("You learn the basics of Zanzoken on your own!",'alert.dmi',"skill")
						m<<"<b>You learn the basics of Zanzoken on your own!</b>"
				if(m.energy_max>=18000&&m.move_lvl>=2&&!(locate(/obj/skills/Charge) in src))
					if(prob(1))
						var/obj/skills/Charge/C = new
						C.loc = m
						m.set_alert("You learn the basics of Charge Blast on your own!",'alert.dmi',"skill")
						m<<"<b>You learn the basics of Charge Blast on your own!</b>"
				if(m.energy_max>=15000&&m.move_lvl>=2&&!(locate(/obj/skills/Destructo_Disk) in src))
					if(prob(1))
						var/obj/skills/Destructo_Disk/C = new
						C.loc = m
						m.set_alert("You learn the basics of Destructo Disk on your own!",'alert.dmi',"skill")
						m<<"<b>You learn the basics of Destructo Disk on your own!</b>"
				if(m.energy_max>=25000&&m.move_lvl>=3&&!(locate(/obj/skills/Beam) in src)&&!(locate(/obj/skills/Ki_Fist) in src)&&!(locate(/obj/skills/Ki_Blade) in src))
					if(prob(1))
						var/obj/skills/Beam/B = new
						var/obj/skills/Ki_Fist/KF = new
						var/obj/skills/Ki_Blade/KB = new
						B.loc = m
						KF.loc = m
						KB.loc = m
						m.set_alert("You learn the basics of Energy Manipulation on your own!",'alert.dmi',"skill")
						m<<"<b>You learn the basics of Energy Manipulation on your own!</b>"
				if(m.energy_max>=40000&&m.move_lvl>=3&&!(locate(/obj/skills/Power_Control) in src))
					if(prob(1))
						var/obj/skills/Power_Control/PC = new
						PC.loc = m
						m.set_alert("You learn the basics of Power Control on your own!",'alert.dmi',"skill")
						m<<"<b>You learn the basics of Power Control on your own!</b>"
				if(m.energy_max>=25000&&m.move_lvl>=3&&!(locate(/obj/skills/Sense) in src))
					if(prob(1))
						if(m.race == "Namekian" || m.race == "Spirit Doll" || m.race == "Changeling" || m.race == "Makyo" || m.race == "Kai" || m.race == "Demon" || m.race == "Alien" || m.race == "Oni")
							var/obj/skills/Sense/S = new
							S.loc = m
							m.set_alert("You learn the basics of Sense on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Sense on your own!</b>"
				if(m.energy_max>=50000&&m.move_lvl>=5&&(locate(/obj/skills/Sense) in src) && m.skill_sense && m.skill_sense.super_sense == 0)
					if(prob(1))
						if(m.race == "Namekian" || m.race == "Spirit Doll" || m.race == "Changeling" || m.race == "Makyo" || m.race == "Kai" || m.race == "Demon" || m.race == "Alien" || m.race == "Oni")
							if(!m.skill_sense)
								var/obj/skills/Sense/S = new
								S.loc = m
								m.skill_sense = S
								m.skill_sense.super_sense = 1
							else m.skill_sense.super_sense = 1
							m.set_alert("You learn the basics of Sense Planet on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Sense Planet on your own!</b>"
				if(m.energy_max>=25000&&m.move_lvl>=8&&!(locate(/obj/skills/Expand) in src))
					if(m.race == "Alien" || m.race == "Namekian" || m.race == "Demon" || m.race == "Makyo")

						if(prob(1))
							var/obj/skills/Expand/Ex = new
							Ex.loc = m
							m.set_alert("You learn the basics of Body Expand on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Body Expand on your own!</b>"
				/*if(m.energy_max>=10000&&m.move_lvl>=20&&!(locate(/obj/skills/Decline_Absorb) in src))
					if(m.race == "Demon")

						if(prob(1))
							var/obj/skills/Decline_Absorb/Ex = new
							Ex.loc = m
							m.set_alert("You learn the basics of Decline Absorb on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Decline Absorb on your own!</b>" */
				/*if(m.energy_max>=88888&&m.move_lvl>=62&&!(locate(/obj/skills/Soul_Absorb) in src))
					if(m.race == "Demon")

						if(prob(1))
							var/obj/skills/Soul_Absorb/Ex = new
							Ex.loc = m
							m.set_alert("You learn the basics of Soul Absorb on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Decline Absorb on your own!</b>" */
				if(m.mod_strength>=2.1&&m.energy_max>=1500&&m.move_lvl>=2&&!(locate(/obj/skills/Stunning_Blow) in src))
					if(prob(1))
						var/obj/skills/Stunning_Blow/Ex = new
						Ex.loc = m
						m.set_alert("You learn the basics of Stunning Blow on your own!",'alert.dmi',"skill")
						m<<"<b>You learn the basics of Stunning Blow on your own!</b>"
				if(m.energy_max>=125000&&m.move_lvl>=20&&!(locate(/obj/skills/Teleportation) in src))
					if(m.race == "Demon")
						if(prob(1))
							var/obj/skills/Teleportation/Ex = new
							Ex.loc = m
							m.set_alert("You learn the basics of Teleportation on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Teleportation on your own!</b>"
					else if(m.race == "Kai")
						if(prob(1))
							var/obj/skills/Teleportation/Ex = new
							Ex.loc = m
							m.set_alert("You learn the basics of Teleportation on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Teleportation on your own!</b>"
				if(m.magicxp>=1200&&m.move_lvl>=5&&!(locate(/obj/skills/Astral_Projection) in src))
					if(m.race_class == "Yardrat")
						if(prob(1))
							var/obj/skills/Astral_Projection/Ex = new
							Ex.loc = m
							m.set_alert("You learn the basics of Astral Projecting on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Astral Projecting on your own!</b>"
					if(m.race == "Spirit Doll" && m.energy_max >= 100000)
						if(prob(0.1))
							var/obj/skills/Astral_Projection/Ex = new
							Ex.loc = m
							m.set_alert("You learn the basics of Astral Projecting on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Astral Projecting on your own!</b>"

				if(m.energy_max>=150000&&m.move_lvl>=16&&!(locate(/obj/skills/Remote_Viewing) in src))
					if(m.race == "Kai")
						if(prob(1))
							var/obj/skills/Remote_Viewing/Ex = new
							Ex.loc = m
							m.set_alert("You learn the basics of Remotely Viewing others on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Remotely Viewing others on your own!</b>"
				if(m.energy_max>=190000&&m.move_lvl>=30&&!(locate(/obj/skills/Ressurect) in src))
					if(m.race == "Demon")
						if(prob(3))
							if(m.z == 12)
								var/obj/skills/Ressurect/Ex = new
								Ex.loc = m
								m.set_alert("You learn the basics of Reviving others on your own!",'alert.dmi',"skill")
								m<<"<b>You learn the basics of Reviving others on your own!</b>"
					else if(m.race == "Kai")
						if(prob(1))
							var/obj/skills/Ressurect/Ex = new
							Ex.loc = m
							m.set_alert("You learn the basics of Reviving others on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Reviving others on your own!</b>"
				if(m.energy_max>=8000&&m.move_lvl>=4&&!(locate(/obj/skills/Energy_Shield) in src))
					if(prob(1))
						var/obj/skills/Energy_Shield/Ex = new
						Ex.loc = m
						m.set_alert("You learn the basics of Energy Shield on your own!",'alert.dmi',"skill")
						m<<"<b>You learn the basics of Energy Shield on your own!</b>"

				if(m.magicxp>=300&&m.move_lvl>=3&&!(locate(/obj/skills/Telekinesis) in src))
					if(m.race_class == "Wizard" || m.race_class == "Witch" )
						if(prob(1))
							var/obj/skills/Telekinesis/Ex = new
							Ex.loc = m
							m.set_alert("You learn the basics of Telekinesis on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Telekinesis on your own!</b>"

				if(m.magicxp>=5000&&m.move_lvl>=25&&!(locate(/obj/skills/Majinize) in src))
					if(m.race_class == "Wizard")
						if(prob(1))
							var/obj/skills/Majinize/Ex = new
							Ex.loc = m
							m.set_alert("You learn the basics of Majinize on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Majinize on your own!</b>"
				if(m.magicxp>=5000&&m.move_lvl>=25&&!(locate(/obj/skills/Mysticize) in src))
					if(m.race_class == "Witch")
						if(prob(1))
							var/obj/skills/Mysticize/Ex = new
							Ex.loc = m
							m.set_alert("You learn the basics of Mysticize on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Mysticize on your own!</b>"
				if(m.magicxp>=1500&&m.move_lvl>=15&&!(locate(/obj/skills/Summon_Mage_Pot) in src))
					if(m.race_class == "Witch")
						if(prob(1))
							var/obj/skills/Summon_Mage_Pot/Ex = new
							Ex.loc = m
							m.set_alert("You learn the basics of Summoning Mage Pots on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Summoning Mage Pots on your own!</b>"
				if(m.magicxp>=2500&&m.move_lvl>=30&&!(locate(/obj/skills/Spirit_Reprieve) in src))
					if(m.race_class == "Witch")
						if(prob(1))
							var/obj/skills/Spirit_Reprieve/Ex = new
							Ex.loc = m
							m.set_alert("You learn the basics of Spirit Reprieve on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Spirit Reprieve on your own!</b>"
				if(m.magicxp>=600&&m.move_lvl>=6 &&m.race == "Alien"&&!(locate(/obj/skills/Split_Form) in src))
					if(prob(1))
						var/obj/skills/Split_Form/Ex = new
						Ex.loc = m
						m.set_alert("You learn the basics of Split Form on your own!",'alert.dmi',"skill")
						m<<"<b>You learn the basics of Split Form on your own!</b>"
				if(m.magicxp>=1525&&m.move_lvl>=15&&!(locate(/obj/skills/Underworld_Portal) in src))
					if(m.race_class == "Wizard")
						if(prob(1))
							var/obj/skills/Underworld_Portal/Ex = new
							Ex.loc = m
							m.set_alert("You learn the basics of Underworld Portal on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Underworld Portal on your own!</b>"
				if(m.magicxp>=1000&&m.move_lvl>=13&&!(locate(/obj/skills/Create_Energy_Drainer) in src))
					if(m.race_class == "Wizard")
						if(prob(1))
							var/obj/skills/Create_Energy_Drainer/Ex = new
							Ex.loc = m
							m.set_alert("You learn the basics of Creating Energy Drainers on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Creating Energy Drainers on your own!</b>"
				if(m.energy_max>=100000&&m.move_lvl>=20&&!(locate(/obj/skills/Self_Destruct) in src))
					if(m.race == "Spirit Doll")
						if(prob(1))
							var/obj/skills/Self_Destruct/Ex = new
							Ex.loc = m
							m.set_alert("You learn the basics of Self Destruct on your own!",'alert.dmi',"skill")
							m<<"<b>You learn the basics of Self Destruct on your own!</b>"

			//MAGE SKILLS

		makyoboost_disable(var/mob/m)
			m.makyo_boost = 0
			m.reset_anger()
			m.letgo()
		makyoboost_enable(var/mob/m)
			if(m.race != "Makyo" || m.makyo_dna <50) return
			if(m.makyo_boost) return // If they are already Oozaru
			if(m.in_space_ship || m.in_space_pod) return // if they are in a ship/pod.
			if(m.dead && !m.has_body) return // If they don't have body while dead.
			if(m.looking_at_moon == 0) return // If they are not looking at the moon.
			if(NorthMoon || SouthMoon)
				if(m.onEarth || m.onNamek)
					if(NorthMoon)
						m.makyo_boost = 1
						m.letgo()
					//	m.disable_skills()
						m<<output("<font color=red>[m.real_name] has gained power under the full moon!</font>","actionoutput")
						var/maxboost=(m.max_anger*0.015)*5
						m.anger = (m.max_anger+maxboost)
						spawn(m.max_anger+maxboost)
							m.makyoboost_disable(m)
				else if(m.onVegeta || m.onIcer)
					if(SouthMoon)
						m.makyo_boost = 1
						m.letgo()
						//m.disable_skills()
						m<<output("<font color=red>[m.real_name] has gained power under the full moon!</font>","actionoutput")
						var/maxboost=(m.max_anger*0.015)*5
						m.anger = (m.max_anger+maxboost)
						spawn(m.max_anger+maxboost)
							m.makyoboost_disable(m)

		check_ban()
			if(findtext(ban_list,"[src.client.computer_id]"))
				src.client.screen += new /obj/bannedbackground
				sleep(0.1)
				src.Logout()
				sleep(50)
				del(src.client)
		lssj_disable(mob/m)
			m.lssj_form = 0
			m.reset_anger()
			m.letgo()
			//m.overlays = initial(m.overlays)
			//if(m.overlays == null) m.redraw_appearance()
			if(m.rampid) m.rampid = 0
			if(in_lssj_rampage == 1) m.stop_lssj_rampage()
			//if(prob(1)) m.lssj_mastery += 1


		lssj_enable(var/mob/m)
			if(m.race != "Saiyan" || m.saiyan_dna <10) return
			if(m.lssj_form) return // If they are already Oozaru
			if(m.dead && !m.has_body) return // If they don't have body while dead.
			m.lssj_form = 1
			m.letgo()
			//m.disable_skills()
			if(m.lssj_mastery>=100)
				view(10,m)<<output("<font color=red>[m.real_name] has transformed into a rampage under the new season!</font>","actionoutput")
				//m<<output("<font color=red>[m.real_name] has transformed under the full moon!</font>","actionoutput")
			else if(m.lssj_mastery<100)
				if(prob(m.lssj_mastery))
					view(10,m)<<output("<font color=red>[m.real_name] has transformed into a rampage under the new season!</font>","actionoutput")
				//	m.<<output("<font color=red>[m.real_name] has transformed under the full moon!</font>","actionoutput")
				else
					//hearers(15,m) << sound('Roar.ogg',volume=20)
					view(10,m)<<output("<font color=red><b>[m.real_name] has transformed into a rampage under the new season and lost control!</b></font>","actionoutput")
				//	m<<output("<font color=red>[m.real_name] has transformed under the full moon and lost control!</font>","actionoutput")
					m.rampid = 1
					spawn(2) m.start_lssj_rampage()

			//m.saved_icon = "[m.icon]"
			//m.icon = 'NewOozaruBrown_1.dmi'
			//m.overlays = null
			var/maxboost=(m.max_anger*0.025)*7
			m.anger = (m.max_anger+maxboost)
			for(var/obj/skills/s in src)
				if(istype(s,/obj/skills/Power_Control))
					call(s.act)(src, s)

			//m.pixel_x=-32
			spawn(m.max_anger+maxboost*3)
			//	m.icon = saved_icon
				m.redraw_appearance()
				m.lssj_disable(m)
			//	m.pixel_x = 0


		oozaru_disable(mob/m)
			m.oozaru_form = 0
			m.reset_anger()
			m.letgo()
			//m.overlays = initial(m.overlays)
			//if(m.overlays == null) m.redraw_appearance()
			if(m.rampid) m.rampid = 0
			if(in_oozaru_rampage == 1) m.stop_oozaru_rampage()
			//if(prob(1)) m.oozaru_mastery += 1


		oozaru_enable(var/mob/m)
			if(m.race != "Saiyan" || m.saiyan_dna <10) return
			if(m.oozaru_form) return // If they are already Oozaru
			if(m.in_space_ship || m.in_space_pod) return // if they are in a ship/pod.
			if(m.dead && !m.has_body) return // If they don't have body while dead.
			if(m.looking_at_moon == 0) return // If they are not looking at the moon.

			if(NorthMoon || SouthMoon)
				if(m.onEarth || m.onNamek)
					if(NorthMoon)
						m.oozaru_form = 1
						var/saved_icon = m.icon
						m.letgo()
						//m.disable_skills()
						if(m.oozaru_mastery>=100)
							view(10,m)<<output("<font color=red>[m.real_name] has transformed under the full moon!</font>","actionoutput")
							//m<<output("<font color=red>[m.real_name] has transformed under the full moon!</font>","actionoutput")
						else if(m.oozaru_mastery<100)
							if(prob(m.oozaru_mastery))
								view(10,m)<<output("<font color=red>[m.real_name] has transformed under the full moon!</font>","actionoutput")
							//	m.<<output("<font color=red>[m.real_name] has transformed under the full moon!</font>","actionoutput")
							else
								hearers(15,m) << sound('Roar.ogg',volume=20)
								view(10,m)<<output("<font color=red><b>[m.real_name] has transformed under the full moon and lost control!</b></font>","actionoutput")
							//	m<<output("<font color=red>[m.real_name] has transformed under the full moon and lost control!</font>","actionoutput")
								m.rampid = 1
								spawn(2) m.start_oozaru_rampage()
						//m.saved_icon = "[m.icon]"
						m.icon = 'NewOozaruBrown_1.dmi'
						m.overlays = null
						var/maxboost=(m.max_anger*0.025)*8
						m.anger = (m.max_anger+maxboost)

						m.pixel_x=-32
						spawn(m.max_anger+maxboost*5)
							m.icon = saved_icon
							m.redraw_appearance()
							m.oozaru_disable(m)
							m.pixel_x = 0
				else if(m.onVegeta || m.onIcer)
					if(SouthMoon)
						m.oozaru_form = 1
						var/saved_icon = m.icon
						m.letgo()
					//	m.disable_skills()
						if(m.oozaru_mastery>=10)
							view(10,m)<<output("<font color=red>[m.real_name] has transformed under the full moon!</font>","actionoutput")
						//	m<<output("<font color=red>[m.real_name] has transformed under the full moon!</font>","actionoutput")
						else if(m.oozaru_mastery<100)
							if(prob(m.oozaru_mastery))
								view(10,m)<<output("<font color=red>[m.real_name] has transformed under the full moon!</font>","actionoutput")
								//m<<output("<font color=red>[m.real_name] has transformed under the full moon!</font>","actionoutput")
							else
								hearers(15,m) << sound('Roar.ogg',volume=20)
								view(10,m)<<output("<font color=red>[m.real_name] has transformed under the full moon and lost control!</font>","actionoutput")
								//m.create_chat_entry("local","<font color=red>[m.real_name] has transformed under the full moon and lost control!</font>",0,1)
								m.rampid = 1
								spawn(2) m.start_oozaru_rampage()

						m.icon = 'NewOozaruBrown_1.dmi'
						m.overlays = null
						m.vis_contents = null
						var/maxboost=(m.max_anger*0.025)*8
						m.anger = (m.max_anger+maxboost)

					//	m.pixel_x=-32
						m.pixel_x=-32

						spawn(m.max_anger+maxboost*5)
							m.icon = saved_icon
							m.redraw_appearance()
							m.oozaru_disable(m)
							m.pixel_x = 0


		auto_skill_learning()
			set background = 1
			var/mob/m = src
			while(m)
				sleep(200)
				m.autolearn()
				sleep(0.1)
		rng_intelpts(var/mob/m,var/obj/items/misc/o)
		//	var/rng = (m.mod_tech_potential*10)
			if(m.intel_gauge >= m.max_intelgauge)
				m.intel_points += 1
				m.intel_gauge = 0
				if(prob(50)) m.max_intelgauge += (m.max_intelgauge*0.125*m.mod_tech_potential)
				if(prob(25)) o.destroy()

			else if(m.intel_gauge < m.max_intelgauge)
				m.intel_gauge += (m.intxp/m.mod_tech_potential)*0.50
				if(m.intel_gauge >= m.max_intelgauge)
					m.intel_points += 1
					m.intel_gauge = 0
					if(prob(50)) m.max_intelgauge += (m.max_intelgauge*0.125*m.mod_tech_potential)
					if(prob(25)) o.destroy()
			return
			/*switch(rand(1,10))
				if(1)
					if(prob(rng))
						switch(rand(1,5))
							if(2)
								m.intel_points +=1
								if(prob(25)) o.destroy()
					return
				if(2)
					if(prob(rng/2))
						switch(rand(1,5))
							if(4)
								m.intel_points +=1
								if(prob(50)) o.destroy()
					return
					return
				if(9)
					if(prob(m.mod_tech_potential))
						m.intel_points +=1
						o.destroy()
					return
				if(10)
					switch(rand(1,3))
						if(3)
							if(prob(m.mod_tech_potential+10))
								m.intel_points +=1
								o.destroy()

					return*/
		check_location()
			var/mob/m = src
			if(m.z == 1)
				m.onEarth=1
				m.onVegeta=0
				m.onNamek=0
				m.onIcer=0
				m.onOtherRealm=0
				m.inSpace=0
			if(m.z == 2)
				m.onOtherRealm=1
				m.onEarth=0
				m.onVegeta=0
				m.onIcer=0
				m.onNamek=0
				m.inSpace=0
				m.onDarkRealm=0
			if(m.z == 4)
				m.onNamek = 1
				m.onEarth=0
				m.onVegeta=0
				m.onIcer=0
				m.onOtherRealm=0
				m.inSpace=0
			if(m.z == 9)
				m.onIcer=1
				m.onNamek=0
				m.onVegeta=0
				m.onEarth=0
				m.onOtherRealm=0
				m.inSpace=0
			if(m.z == 10)
				m.onVegeta=1
				m.onNamek=0
				m.onEarth=0
				m.onIcer=0
				m.onOtherRealm=0
				m.inSpace=0
			if(m.z == 16)
				m.inSpace=1
				m.onVegeta=0
				m.onNamek=0
				m.onEarth=0
				m.onIcer=0
				m.onOtherRealm=0
			m.check_glow_planes()
		check_survival(var/mob/m)
			if(m.hunger<0)
				if(prob(1))
					view(10,m)<<output("[m] is dying of starvation!","actionoutput")

				if(prob(!50))
					m.KO()
				//	m.Death("starvation")
					return
			if(m.hunger<=-20)
				if(prob(!50))
					m.KO()
				//	m.Death("starvation")
					return
				if(prob(1))
					if(m.koed==1 && m.dead == 0)
						m.Death("starvation")
						return
					else
						m.KO()
						sleep(2)
						if(m.dead == 0) m.Death("starvation")
						return
			if(m.thirst<0)
				if(prob(1))
					view(10,m)<<output("[m] is dying of thirst!","actionoutput")
				if(prob(!50))
					m.KO()
				//	m.Death("starvation")
					return
			if(m.thirst<=-20)
				if(prob(!50))
					m.KO()
				//	m.Death("starvation")
					return
				if(prob(1))
					if(m.koed==1 && m.dead ==0)
						m.Death("starvation")
						return
					else
						m.KO()
						sleep(2)
						if(m.dead == 0) m.Death("starvation")
						return

			if(m.restedness<=-30)
				if(prob(!50))
					m.KO()
				//	m.Death("starvation")
					return
				if(prob(1))
					if(m.koed==1 && m.dead == 0)
						m.Death("fatigue")
						return
					else
						m.KO()
						sleep(2)
						if(m.dead == 0)m.Death("fatigue")
						return
		process_HTT_decay()
			set background = 1
			var/mob/m = src
			while(m.client && m.started)
			// Wait 3 minutes (10 ticks ≈ 1 s → 18000 ≈ 3 min)
				sleep(1800)

			// Hunger
				if(src.race != "Namekian")
					src.hunger --

				// Thirst
				src.thirst --

				// Restedness drains only when not sleeping
				if(prob(75))
					if(!src.skill_sleep || (src.skill_sleep && !src.skill_sleep.active))
						src.restedness --

				// Safety clamps
				src.hunger = clamp(src.hunger, -99, 325)
				src.thirst = clamp(src.thirst, -99, 325)
				src.restedness = clamp(src.restedness, -99, 100)

				// Survival check still handled here
				src.check_survival(src)
				//sleep(0.1)
		process_standing_gains()
			set background = 1
			var/mob/m = src
			startoff
			// Wait 3 minutes (10 ticks ≈ 1 s → 18000 ≈ 3 min)
			if(m.started)
				if(m.gaining_endurance<=0 && m.gaining_energy<=0  && m.gaining_strength<=0  && m.gaining_force<=0  && m.gaining_resistance<=0  && m.gaining_offence<=0  && m.gaining_defence<=0 && m.icon_state !="Train" && m.icon_state != "Meditate" && m.afk == 0 || m.skill_sleep && m.skill_sleep.active && m.icon_state == "Meditate" && m.afk == 0 )
					if(!m.afk)
						m.standing_gains_timer ++
			//	m<<"Standing Gains Time: [m.standing_gains_timer](s)"
			sleep(60)
			goto startoff

		process_stats()
			set background = 1
			var/mob/m = src



			m.stats() // Checked V 0.10 for crashes
			//Melee attack speed

			if(m.client && m.started)
				m.check_location()
				m.skill_exp()
				m.body_exp_hp()
				m.lift = (m.strength+m.endurance)*2

				if(m.open_stats)
					//Then set the core stats
					//if(m && m.client && winget(m,"stats.tab_stats","current-tab") == "stats_other") winset(m,null,"stats_other.label_rads.text=\"Radiation tolerance: [m.mod_immune_rads*100]%\";stats_other.label_cold.text=\"Cold tolerance: [m.mod_immune_cold*100]%\";stats_other.label_heat.text=\"Heat tolerance: [m.mod_immune_heat*100]%\";stats_other.label_lift.text=\"Lift: [m.lift]\";stats_other.label_age.text=\"Physical Age: [m.age]\";stats_other.label_soul_age.text=\"Soul Age: [m.age_soul]\";stats_other.label_decline_age.text=\"Decline Age: [m.oldage]\";stats_other.label_lifespan.text=\"Lifespan: [m.lifespan]\";stats_other.label_vigour.text=\"Vigour: [m.vigour]%\";stats_other.label_traits.text=\"Trait Points: [m.skill_points_combat]\";stats_other.label_grav_mas.text=\"Gravity Mastered: [m.gravity_mastered]\";stats_other.label_grav_res.text=\"Gravity tolerance: [m.mod_immune_gravity]\"")
					//else if(m && m.client && winget(m,"stats.tab_stats","current-tab") == "stats_core")
					//Calculate and show buffs/debuffs and boosts to power in percentages
					//Update and display stats
					m.hud_stats.bars(m)
					m.hud_stats.player_info(m)
					//m.hmods(m)
					//m.hud_stats.mods(m)

				if(m.mouse_skill && m.client) winset(m,null,"skills.bar_skill.value=[m.mouse_skill.skill_exp];skills.label_lvl.text=\"[m.mouse_skill.skill_lvl]\"")
				//Underwater
				if(m) m.check_underwater() // Checked V 0.10 for crashes
				//Adjust estimates
				if(m && m.target) m.estimates() // Checked V 0.10 for crashes
				//Inventory check
				if(m.accessing)
					if(ismob(m.accessing))
						var/mob/m_inv = m.accessing
						//If the mob is not ko, then switch back to player if not already done so.
						if(m_inv.owner != m.real_name && m_inv.koed == 0 && m_inv != m)
							m.accessing = m
							m.refresh_inv()
					//If the mob is too far away, switch back to player.
					if(get_dist(m,m.accessing) > 2)
						m.accessing = m
						m.refresh_inv() // Checked V 0.10 for crashes
						if(m.left_click_function == "revive defibrillator")
							m.left_click_function = null
							m.left_click_ref = null

				else
					//When not accessing a container, switch back to players inv
					m.accessing = m
					m.refresh_inv() // Checked V 0.10 for crashes
			if(m)
				//Hunger/Thirst/Tiredness
				var/hunger_ratio = m.hunger / 325 // Normalize between 0-1
				var/thirst_ratio = m.thirst / 325 // Normalize between 0-1
				var/tiredness_ratio = m.restedness / 325 // Normalize between 0-1
				var/HTTs = ((hunger_ratio * 0.45) + (thirst_ratio * 0.45) + (tiredness_ratio * 0.25)) * 350
				m.HTT = clamp(round(HTTs), 0, 350)
				//if(m.has_body)
				//if(prob(10) && m.race != "Namekian" ) m.hunger -= m.metabolic_rate
				//if(prob(14)) m.thirst -= m.dehydration_rate
				//if(prob(1)) if(m.skill_sleep == null || m.skill_sleep && m.skill_sleep.active == 0) m.restedness -= m.tiredness_rate
				//else
				//	m.hunger = 0
				//	m.thirst = 0
				//	m.restedness = 0
				//m.hunger = clamp(m.hunger,-99,325)
			//	m.thirst = clamp(m.thirst,-99,325)
				//m.restedness = clamp(m.restedness,-99,100)
				//m.check_survival(m)

				if(m.percent_energy < 0 || m.energy < 0)
					m.percent_energy = 0
					m.energy = 0
				//if(m.client) m.client.images -= m.bar_ko
				if(m.bar_ko)
					if(m.client) m.client.images -= m.bar_ko
					m.bar_ko.icon_state = round(m.percent_ko,10)
					if(m.client) m.client.images += m.bar_ko
					/*
					var/image/ko = image('bars_ko.dmi',m,"[round(m.percent_ko,10)]",1000)
					ko.pixel_y = -14;
					ko.pixel_x = 6;
					m.bar_ko = ko
					if(m.client) m.client.images += m.bar_ko
					*/

			//	m.textpercentages()
				if(m.slice_eng) m.slice_eng.pixel_x = (m.percent_energy/3)-33 //m.bar_energy.icon_state = "[round(m.percent_energy,10)]"
				if(m.slice_hp) m.slice_hp.pixel_x = (m.percent_health/3)-33 //m.bar_health.icon_state = "[round(m.percent_health,10)]"
				if(m.slice_o2) m.slice_o2.pixel_x = (((m.o2/m.o2_max)*100)/3)-33 //m.bar_o2.icon_state = "[round(m.o2,10)]"
				if(m.target)
					var/mob/t = m.target
					var/p = round((t.psionic_power/m.psionic_power)*100)
					if(m.skill_sense && m.skill_sense.active)
						//if(m.skill_sense.skill_lvl<=74)
						for(var/obj/hud/menus/sense_box/b in m.sense_boxes)
							for(var/obj/o in b)
								o.maptext = "[css_outline]<font size = 1>Direction: [dir2text_sense(get_dir(m.loc,t.loc))]\nPower: [p]%"
								break
						/*if(m.skill_sense.skill_lvl>=75)
							for(var/obj/hud/menus/sense_box/b in m.sense_boxes)
								for(var/obj/o in b)
									o.maptext = "[css_outline]<font size = 1>Direction: [dir2text_sense(get_dir(m.loc,t.loc))]\nPower: [p]%\nOffence: 100%\nDefence: 100%\nStrength:100%\nEndurance: 100%\nForce: 100%\nResistance: 100%\nAgility: 100%\nRegeneration: 100%\nRecovery: 100%"
									break*/


					else
						for(var/obj/hud/menus/sense_box/b in m.sense_boxes)
							for(var/obj/o in b)
								o.maptext = "[css_outline]<font size = 1>[m.target.name]"
								break


				//Environmental damage/training
				if(m && m.started)
					if(m.origin)
						if(istype(m.origin,/obj/origins/exalted))
							for(var/mob/x in view(6,m))
								if(x != m && x.debuff_exalted)
									if(x.skill_active_meditation == null || x.skill_active_meditation && x.skill_active_meditation.active == 0)
										if(x.skill_meditation == null || x.skill_meditation && x.skill_meditation.active == 0)
											x.debuff_exalted.active = 1
											x.blinding_light = 1
											for(var/obj/body_related/bodyparts/head/hd in x.bodyparts)
												for(var/obj/body_related/bodyparts/head/left_eye/le in hd)
													x.damage_limb(x,0, 1, 0.2*x.mod_regeneration,le)
													break
												for(var/obj/body_related/bodyparts/head/right_eye/re in hd)
													x.damage_limb(x,0, 1, 0.2*x.mod_regeneration,re)
													break
						else if(istype(m.origin,/obj/origins/baleful))
							for(var/mob/x in view(4,m))
								if(x != m && x.debuff_baleful)
									x.debuff_baleful.active = 1
									x.baleful_light = 1
									var/eng = (x.energy_max/80)*x.mod_recovery
									x.energy -= eng
									m.energy += eng
						else if(istype(m.origin,/obj/origins/solar_powered))
							if(m.z == 1 || m.z == 2 || m.z == 4 || m.z == 5)
								m.gain_stat("energy",1,10,"Solar Powered")
						else if(istype(m.origin,/obj/origins/self_learning_algorithms))
							var/obj/body_related/h = m.bodyparts[1]
							for(var/obj/body_related/bodyparts/head/artificial_brain/b in h)
								if(b.disabled == 0 && b.damaged == 0)
									b.part_exp += 4
									b.part_reward(m,1,null,0)

					if(m.z == 2 || m.z == 6)
						//if(prob(10)) m << sound(pick(thunder),0,1,5,100)
					//	m.gain_stat("power",1,0.1,"Other Realm saturation")
					//	m.gain_stat("energy",1,10,"Psionic Realm saturation")
						m.gain_stat("divine",1,1,"Other Realm saturation")
						m.divine_energy += 0.01*m.divine_energy_mod

					if(m.tmp_dmg != 0)
						if(m.has_body && m.afk == 0)
							//if(m && m.percent_health >= 1)
								//m.check_quest("tutorial_environmentals",1)
								//m.gain_stat("endurance",1,10,"Environmental",1)
							//	m.lvl_typesof_bodypart(list("Skin"),1,1)
							if(m && m.tmp_dmg > 0)
								if(m.debuff_hot && m.debuff_hot.active == 0)
									call(m.debuff_hot.act)(m,m.debuff_hot)
									if(m && m.debuff_cold && m.debuff_cold.active)
										call(m.debuff_cold.act)(m,m.debuff_cold)
										if(m.client) m.client.screen -= m.debuff_cold
								if(m && m.percent_health >= 1)
									var/dmg = abs(m.tmp_dmg)-m.mod_immune_heat
									//world << "DEBUG - heat dmg is [dmg]"
									if(dmg > 0)
										m.percent_health -= dmg
								//	m.check_quest("env_heat",1,1,1)
							if(m && m.tmp_dmg < 0 && m.in_space_pod == 0 && m.race != "Changeling")
								if(m.debuff_cold && m.debuff_cold.active == 0 && m.in_space_pod == 0)
									call(m.debuff_cold.act)(m,m.debuff_cold)
									if(m && m.debuff_hot && m.debuff_hot.active)
										call(m.debuff_hot.act)(m,m.debuff_hot)
										if(m.client) m.client.screen -= m.debuff_hot
								if(m && m.percent_health >= 1)
									var/dmg = abs(m.tmp_dmg)-m.mod_immune_cold
									if(dmg > 0)
										m.percent_health -= dmg
										if(prob(0.5)) m.mod_immune_cold += 0.01

								//	m.check_quest("env_cold",1,1,1)
					else
						if(m && m.debuff_hot && m.debuff_hot.active)
							call(m.debuff_hot.act)(m,m.debuff_hot)
							if(m.client) m.client.screen -= m.debuff_hot
						if(m && m.debuff_cold && m.debuff_cold.active && m.in_space_pod == 0)
							call(m.debuff_cold.act)(m,m.debuff_cold)
							if(m.client) m.client.screen -= m.debuff_cold
						if(m && m.client && m.started) m.endurance_sources -= "Environmental"
					//Check if player weighted
					//if(m.weight > 1)
						//if(m.debuff_weights && m.debuff_weights.active == 0) call(m.debuff_weights.act)(m,m.debuff_weights)
						//m.gain_stat("power",1,1+(m.weight/100)/m.mod_psionic_power,"Weights")
						//m.gain_stat("strength",1,10,"Weights")
					//Check if player inside a high gravity field.
					if(m.loc)
						//Handle blackholes and neutron stars here
						var/turf/t = m.loc
						if(t.grav < 0) t.grav =1
						//if(t.microwaves < 0) m.microwaves = m.microwaves_mastered+0.1

						//Set grav/micro records
						if(m.grav > m.grav_highest) m.grav_highest = m.grav
						if(m.microwaves > m.micro_highest) m.micro_highest = m.microwaves
					if(m.in_space_pod == 0)
						if(m.grav >= (m.gravity_mastered+19) && m.koed)
							if(prob(50))
								m.Death("Gravity")
							else
								view(m)<<output("<font color=red>[m] is being crushed by gravity!</font>","actionoutput")
							sleep(30)
						else if(m.grav > m.gravity_mastered && m.koed == 0 && m.grav > 0)

							if(world.time < m.last_gravity_tick + 10)
								goto skip_gravity_damage

							m.last_gravity_tick = world.time
							//m.check_quest("tutorial_environmentals",1)
							m.in_gravity = 2;
							if(m.debuff_gravity && m.debuff_gravity.active == 0)
							//	if(m.debuff_gravity && !m.debuff_gravity.active)
								m.debuff_gravity.active = 1
								 	//call(m.debuff_gravity.act)(m,m.debuff_gravity)
							if(m.koed == 0 && m.percent_health >= 1 && m.afk == 0)
								//m.check_quest("env_grav",1,1,1)
								var/DMG = 1+ (m.grav/m.gravity_mastered)/(1+m.mod_immune_gravity)
								if(m.grav >= (m.gravity_mastered+19)) DMG *= 10

								if(DMG > 0) m.percent_health -= DMG
								if(m.percent_health < 0 && m.koed == 0)
									m.KO()
								//var/obj/body_related/bodyparts/randomlimb = null
								if(prob(20)) // only sometimes
									var/obj/body_related/bodyparts/randomlimb = pick(m.body)
									m.damage_limb(m,1, 1, DMG, randomlimb)
									//return

							//	else m.gain_stat("strength",1,1,"High gravity")
							//	m.gain_stat("endurance",1,1,"High gravity")
							//	m.gain_stat("dark matter",1,5,"High gravity")
								//m.dark_matter += 0.01*m.dark_matter_mod

								if(m.grav > 1) m.gain_stat("power",1,1+(m.grav/100)/m.mod_psionic_power,"High gravity")
								if(m.grav > 1) m.gravity_mastered += ((0.005*m.mod_endurance)*m.mod_gravity)*(m.grav/m.gravity_mastered) //Did a grav check as there might be a tiny delay in gain_stat?


						//	m.lvl_typesof_bodypart(list("Muscle","Bone"),1,1)
					/*if(m.microwaves > m.microwaves_mastered && m.koed == 0 && m.microwaves > 0 && m.afk == 0)
						m.check_quest("tutorial_environmentals",1)
						m.in_microwaves = 2;
						if(m.debuff_microwaves && m.debuff_microwaves.active == 0) call(m.debuff_microwaves.act)(m,m.debuff_microwaves)
						if(m.koed == 0 && m.percent_health > 10 && m.afk == 0)
							m.check_quest("env_micro",1,1,1)
							var/DMG = (m.microwaves/m.microwaves_mastered)
							DMG = DMG/(1+m.mod_immune_microwaves)
							if(DMG > 0) m.percent_health -= DMG
							m.percent_health -= DMG
							if(m.percent_health < 0)
								m.KO()
								//return
						//	m.gain_stat("energy",1,1,"High microwaves")
						//	m.gain_stat("force",1,1,"High microwaves")
							m.gain_stat("resistance",1,0.5,"High microwaves")
							if(islist(m.tutorials))
								var/obj/help_topics/H = m.tutorials[14]
								if(H.seen == 0)
									H.seen = 1
									H.skill_up(m)
							if(islist(m.tutorials))
								var/obj/help_topics/H = m.tutorials[15]
								if(H.seen == 0)
									H.seen = 1
									H.skill_up(m)
							if(m.microwaves > 0) m.gain_stat("power",1,1+(m.microwaves/100),"High microwaves")
							if(m.microwaves > 0) m.microwaves_mastered += ((0.005*m.mod_resistance)*m.mod_microwaves)*(m.microwaves/m.microwaves_mastered)

							*/

							//m.lvl_typesof_bodypart(list("Organ"),1,1)
						////	for(var/obj/body_related/bodyparts/meridians/dantian/d in m.meridians)
							//	var/xp = 1
							//	d.part_exp += xp
							//	d.part_reward(m,1,null,1)
								//break
				skip_gravity_damage
				//Update the buffs and debuffs screen locs. Do this after any stat gains.
				if(m.client && m.started)
					m.debuffs() // Checked V 0.10 for crashes
					//While we're here, check if player went afk.
					/*if(m.afk == 0)
						if(m.client && m.client.inactivity >= 3000)
							m.overlays -= /obj/effects/afk
							m.overlays += /obj/effects/afk
							m.afk = 1
							if(m.client) winset(m,"chat.afk","is-checked=true")
							for(var/mob/x in view(8,m))
								x << output("[m] automatically went afk.","chat.local")
					else if(m.client && m.afk == 1 && m.client.inactivity <= 100 && m.client.inactivity >= 0)
						m.overlays -= /obj/effects/afk
						m.afk = 0
						if(m.client) winset(m,"chat.afk","is-checked=false")
						for(var/mob/x in view(8,m))
							x << output("[m] came back from afk.","chat.local") */

			spawn(10)
				if(m) m.process_stats()

		create_target_bars(var/mob/m)
			if(src.sense_boxes == null || length(src.sense_boxes) <= 0)
				src.sense_boxes = list()
				var/obj/hud/menus/sense_box/b = new
				b.layer = m.layer - 1
				src.sense_boxes += b



				var/obj/hud/menus/sense_button/bu = new
				bu.layer = m.layer - 1
				src.sense_boxes += bu

				var/obj/box_text = new
				box_text.maptext_width = 160
				box_text.maptext_height = 64
				box_text.appearance_flags = KEEP_APART | RESET_COLOR | NO_CLIENT_COLOR | RESET_TRANSFORM
				//if(m.fullname in src.known_people)
				box_text.maptext = "[css_outline]<font size = 1>[src.get_strangername(m)]"
				box_text.filters += filter(type="outline", size=1, color=rgb(0,0,0))
				box_text.screen_loc = "2:18,14:-23"
				box_text.loc = b
				if(m.skill_sense && m.skill_sense.skill_lvl>=75)
					var/obj/hud/menus/sense_box_advanced/ba = new
					ba.layer = m.layer - 1
					src.sense_boxes += ba

					var/obj/box_text_advanced = new
					box_text_advanced.layer = ba.layer + 1
					box_text_advanced.maptext_width = 160
					box_text_advanced.maptext_height = 320
					box_text_advanced.appearance_flags = KEEP_APART | RESET_COLOR | NO_CLIENT_COLOR | RESET_TRANSFORM
					box_text_advanced.maptext = "<font size = 1>Offence: 100%\nDefence: 100%\nStrength:100%\nEndurance: 100%\nForce: 100%\nResistance: 100%\nAgility: 100%\nRegeneration: 100%\nRecovery: 100%"
					box_text_advanced.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					box_text_advanced.screen_loc = "1:6,9:-2"
					box_text_advanced.loc = ba
			if(!m.bar_health)
				var/image/hp_shell = image('bars_health.dmi',m,"shell",20)
				var/matrix/mat = matrix()
				mat.Translate(abs(src.pixel_x_og),src.i_height+5)
				hp_shell.transform = mat
				hp_shell.appearance_flags = KEEP_APART// | RESET_TRANSFORM

				var/obj/hp = new
				hp.icon = 'bars_health.dmi'
				hp.icon_state = "bar"
				hp.layer = 20
				hp.appearance_flags = KEEP_TOGETHER// | RESET_TRANSFORM

				var/obj/hud/bars/hp_slice/hp_s = new
				hp_shell.vis_contents += hp
				hp.vis_contents += hp_s

				m.slice_hp = hp_s
				m.bar_health = hp_shell
			if(!m.bar_energy)
				var/image/eng_shell = image('bars_health.dmi',m,"shell",20)
				var/matrix/mat = matrix()
				mat.Translate(abs(src.pixel_x_og),src.i_height)
				eng_shell.transform = mat
				eng_shell.appearance_flags = KEEP_APART// | RESET_TRANSFORM

				var/obj/eng = new
				eng.icon = 'bars_health.dmi'
				eng.icon_state = "bar"
				eng.layer = 20
				eng.appearance_flags = KEEP_TOGETHER// | RESET_TRANSFORM

				var/obj/hud/bars/hp_slice/eng_s = new
				eng_s.icon_state = "bar eng"
				eng_shell.vis_contents += eng
				eng.vis_contents += eng_s

				m.slice_eng = eng_s
				m.bar_energy = eng_shell
		drop_cybertech()
			var/list/cybertech = list()
			for(var/obj/body_related/bodyparts/limb in src.bodyparts)
				for(var/obj/body_related/bodyparts/part in limb)
					for(var/obj/body_related/bodyparts/cybernetics/c in part)
						part.cybernetics_current -= 1
						cybertech += c
			if(length(cybertech) > 0)
				src.disable_parts(cybertech,0,1,0)
				for(var/obj/body_related/bodyparts/cybernetics/c in cybertech)
					c.loc = src.loc
					c.desc = "Level: [c.level]/1000 \n[initial(c.info)]"
				if(src.client) src.refresh_inv()
				src.set_alert("All cybertech removed",'alert.dmi',"alert")


		add_to_skillbar(var/obj/skills/skill, var/obj/h)
			// Resolve AA skill copies
			if(skill.type == /obj/skills/AA_Skill_Copy)
				for(var/obj/skills/s in src)
					if(skill.cloned == "[s.name] aa_clone_aa")
						skill = s
						break

			var/bar = skillbar_slots[active_skillbar]

			// ---------------- SLOT 1 ----------------
			if(istype(h,/obj/hud/buttons/skillbar/skillbar_one) || (istype(h,/obj/skills) && one && length(one) && one[1] == h))
				check_skillbar(skill)

				bar["one"] = list(skill)
				sync_active_skillbar()

				if(istype(h,/obj/skills)) client.screen -= h

				skill.screen_loc = "12:-13,1:4"
				client.screen += skill

				for(var/obj/hud/buttons/skillbar/skillbar_one/h1 in hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_one_overlay
					break

				if(skill.repeat)
					if(!one_rep)
						winset(src,"macro.1","name=1+REP")
						one_rep = 1
				else if(one_rep)
					winset(src,"macro.1+REP","name=1")
					one_rep = 0
				return

			// ---------------- SLOT 2 ----------------
			if(istype(h,/obj/hud/buttons/skillbar/skillbar_two) || (istype(h,/obj/skills) && two && length(two) && two[1] == h))
				check_skillbar(skill)

				bar["two"] = list(skill)
				sync_active_skillbar()

				if(istype(h,/obj/skills)) client.screen -= h

				skill.screen_loc = "13:-12,1:4"
				client.screen += skill

				for(var/obj/hud/buttons/skillbar/skillbar_two/h1 in hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_two_overlay
					break

				if(skill.repeat)
					if(!two_rep)
						winset(src,"macro.2","name=2+REP")
						two_rep = 1
				else if(two_rep)
					winset(src,"macro.2+REP","name=2")
					two_rep = 0
				return

			// ---------------- SLOT 3 ----------------
			if(istype(h,/obj/hud/buttons/skillbar/skillbar_three) || (istype(h,/obj/skills) && three && length(three) && three[1] == h))
				check_skillbar(skill)

				bar["three"] = list(skill)
				sync_active_skillbar()

				if(istype(h,/obj/skills)) client.screen -= h

				skill.screen_loc = "14:-11,1:4"
				client.screen += skill

				for(var/obj/hud/buttons/skillbar/skillbar_three/h1 in hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_three_overlay
					break

				if(skill.repeat)
					if(!three_rep)
						winset(src,"macro.3","name=3+REP")
						three_rep = 1
				else if(three_rep)
					winset(src,"macro.3+REP","name=3")
					three_rep = 0
				return

			// ---------------- SLOT 4 ----------------
			if(istype(h,/obj/hud/buttons/skillbar/skillbar_four) || (istype(h,/obj/skills) && four && length(four) && four[1] == h))
				check_skillbar(skill)

				bar["four"] = list(skill)
				sync_active_skillbar()

				if(istype(h,/obj/skills)) client.screen -= h

				skill.screen_loc = "15:-10,1:4"
				client.screen += skill

				for(var/obj/hud/buttons/skillbar/skillbar_four/h1 in hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_four_overlay
					break

				if(skill.repeat)
					if(!four_rep)
						winset(src,"macro.4","name=4+REP")
						four_rep = 1
				else if(four_rep)
					winset(src,"macro.4+REP","name=4")
					four_rep = 0
				return

			// ---------------- SLOT 5 ----------------
			if(istype(h,/obj/hud/buttons/skillbar/skillbar_five) || (istype(h,/obj/skills) && five && length(five) && five[1] == h))
				check_skillbar(skill)

				bar["five"] = list(skill)
				sync_active_skillbar()

				if(istype(h,/obj/skills)) client.screen -= h

				skill.screen_loc = "16:-9,1:4"
				client.screen += skill

				for(var/obj/hud/buttons/skillbar/skillbar_five/h1 in hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_five_overlay
					break

				if(skill.repeat)
					if(!five_rep)
						winset(src,"macro.5","name=5+REP")
						five_rep = 1
				else if(five_rep)
					winset(src,"macro.5+REP","name=5")
					five_rep = 0
				return

			// ---------------- SLOT 6 ----------------
			if(istype(h,/obj/hud/buttons/skillbar/skillbar_six) || (istype(h,/obj/skills) && six && length(six) && six[1] == h))
				check_skillbar(skill)

				bar["six"] = list(skill)
				sync_active_skillbar()

				if(istype(h,/obj/skills)) client.screen -= h

				skill.screen_loc = "17:-8,1:4"
				client.screen += skill

				for(var/obj/hud/buttons/skillbar/skillbar_six/h1 in hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_six_overlay
					break

				if(skill.repeat)
					if(!six_rep)
						winset(src,"macro.6","name=6+REP")
						six_rep = 1
				else if(six_rep)
					winset(src,"macro.6+REP","name=6")
					six_rep = 0
				return

			// ---------------- SLOT 7 ----------------
			if(istype(h,/obj/hud/buttons/skillbar/skillbar_seven) || (istype(h,/obj/skills) && seven && length(seven) && seven[1] == h))
				check_skillbar(skill)

				bar["seven"] = list(skill)
				sync_active_skillbar()

				if(istype(h,/obj/skills)) client.screen -= h

				skill.screen_loc = "18:-7,1:4"
				client.screen += skill

				for(var/obj/hud/buttons/skillbar/skillbar_seven/h1 in hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_seven_overlay
					break

				if(skill.repeat)
					if(!seven_rep)
						winset(src,"macro.7","name=7+REP")
						seven_rep = 1
				else if(seven_rep)
					winset(src,"macro.7+REP","name=7")
					seven_rep = 0
				return

			// ---------------- SLOT 8 ----------------
			if(istype(h,/obj/hud/buttons/skillbar/skillbar_eight) || (istype(h,/obj/skills) && eight && length(eight) && eight[1] == h))
				check_skillbar(skill)

				bar["eight"] = list(skill)
				sync_active_skillbar()

				if(istype(h,/obj/skills)) client.screen -= h

				skill.screen_loc = "19:-6,1:4"
				client.screen += skill

				for(var/obj/hud/buttons/skillbar/skillbar_eight/h1 in hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_eight_overlay
					break

				if(skill.repeat)
					if(!eight_rep)
						winset(src,"macro.8","name=8+REP")
						eight_rep = 1
				else if(eight_rep)
					winset(src,"macro.8+REP","name=8")
					eight_rep = 0
				return

			// ---------------- SLOT 9 ----------------
			if(istype(h,/obj/hud/buttons/skillbar/skillbar_nine) || (istype(h,/obj/skills) && nine && length(nine) && nine[1] == h))
				check_skillbar(skill)

				bar["nine"] = list(skill)
				sync_active_skillbar()

				if(istype(h,/obj/skills)) client.screen -= h

				skill.screen_loc = "20:-5,1:4"
				client.screen += skill

				for(var/obj/hud/buttons/skillbar/skillbar_nine/h1 in hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_nine_overlay
					break

				if(skill.repeat)
					if(!nine_rep)
						winset(src,"macro.9","name=9+REP")
						nine_rep = 1
				else if(nine_rep)
					winset(src,"macro.9+REP","name=9")
					nine_rep = 0
				return

			// ---------------- SLOT 0 ----------------
			if(istype(h,/obj/hud/buttons/skillbar/skillbar_zero) || (istype(h,/obj/skills) && zero && length(zero) && zero[1] == h))
				check_skillbar(skill)

				bar["zero"] = list(skill)
				sync_active_skillbar()

				if(istype(h,/obj/skills)) client.screen -= h

				skill.screen_loc = "21:-4,1:4"
				client.screen += skill

				for(var/obj/hud/buttons/skillbar/skillbar_zero/h1 in hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_zero_overlay
					break

				if(skill.repeat)
					if(!zero_rep)
						winset(src,"macro.0","name=0+REP")
						zero_rep = 1
				else if(zero_rep)
					winset(src,"macro.0+REP","name=0")
					zero_rep = 0
				return

		/*add_to_skillbar(var/obj/skills/skill,var/obj/h)
			if(skill.type == /obj/skills/AA_Skill_Copy)
				for(var/obj/skills/s in src)
					if(skill.cloned == "[s.name] aa_clone_aa")
						skill = s
						break
			if(istype(h,/obj/hud/buttons/skillbar/skillbar_one) || istype(h,/obj/skills) && src.one && length(src.one) > 0 && src.one[1] == h)
				src.check_skillbar(skill)
				src.one = list(skill)
				if(istype(h,/obj/skills)) src.client.screen -= h
				skill.screen_loc = "12:-13,1:4"
				for(var/obj/hud/buttons/skillbar/skillbar_one/h1 in src.hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_one_overlay
					break
				src.client.screen += skill
				if(skill.repeat == 1)
					if(src.one_rep == 0)
						winset(src,"macro.1","name= 1+REP")
						src.one_rep = 1;
				else if(src.one_rep == 1)
					winset(src,"macro.1+REP","name= 1")
					src.one_rep = 0;
				return
			if(istype(h,/obj/hud/buttons/skillbar/skillbar_two) || istype(h,/obj/skills) && src.two && length(src.two) > 0 && src.two[1] == h)
				src.check_skillbar(skill)
				src.two = list(skill)
				if(istype(h,/obj/skills)) src.client.screen -= h
				skill.screen_loc = "13:-12,1:4"
				src.client.screen += skill
				for(var/obj/hud/buttons/skillbar/skillbar_two/h1 in src.hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_two_overlay
					break
				if(skill.repeat == 1)
					if(src.two_rep == 0)
						winset(src,"macro.2","name= 2+REP")
						src.two_rep = 1;
				else if(src.two_rep == 1)
					winset(src,"macro.2+REP","name= 2")
					src.two_rep = 0;
				return

			if(istype(h,/obj/hud/buttons/skillbar/skillbar_three) || istype(h,/obj/skills) && src.three && length(src.three) > 0 && src.three[1] == h)
				src.check_skillbar(skill)
				src.three = list(skill)
				if(istype(h,/obj/skills)) src.client.screen -= h
				skill.screen_loc = "14:-11,1:4"
				src.client.screen += skill
				for(var/obj/hud/buttons/skillbar/skillbar_three/h1 in src.hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_three_overlay
					break
				if(skill.repeat == 1)
					if(src.three_rep == 0)
						winset(src,"macro.3","name= 3+REP")
						src.three_rep = 1;
				else if(src.three_rep == 1)
					winset(src,"macro.3+REP","name= 3")
					src.three_rep = 0;
				return

			if(istype(h,/obj/hud/buttons/skillbar/skillbar_four) || istype(h,/obj/skills) && src.four && length(src.four) > 0 && src.four[1] == h)
				src.check_skillbar(skill)
				src.four = list(skill)
				if(istype(h,/obj/skills)) src.client.screen -= h
				skill.screen_loc = "15:-10,1:4"
				src.client.screen += skill
				for(var/obj/hud/buttons/skillbar/skillbar_four/h1 in src.hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_four_overlay
					break
				if(skill.repeat == 1)
					if(src.four_rep == 0)
						winset(src,"macro.4","name= 4+REP")
						src.four_rep = 1;
				else if(src.four_rep == 1)
					winset(src,"macro.4+REP","name= 4")
					src.four_rep = 0;
				//world.log << "DEBUG - Set skill bar four as [skill]"
				return

			if(istype(h,/obj/hud/buttons/skillbar/skillbar_five) || istype(h,/obj/skills) && src.five && length(src.five) > 0 && src.five[1] == h)
				src.check_skillbar(skill)
				src.five = list(skill)
				if(istype(h,/obj/skills)) src.client.screen -= h
				skill.screen_loc = "16:-9,1:4"
				src.client.screen += skill
				for(var/obj/hud/buttons/skillbar/skillbar_five/h1 in src.hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_five_overlay
					break
				if(skill.repeat == 1)
					if(src.five_rep == 0)
						winset(usr,"macro.5","name= 5+REP")
						src.five_rep = 1;
				else if(src.five_rep == 1)
					winset(usr,"macro.5+REP","name= 5")
					src.five_rep = 0;
				return

			if(istype(h,/obj/hud/buttons/skillbar/skillbar_six) || istype(h,/obj/skills) && src.six && length(src.six) > 0 && src.six[1] == h)
				src.check_skillbar(skill)
				src.six = list(skill)
				if(istype(h,/obj/skills)) src.client.screen -= h
				skill.screen_loc = "17:-8,1:4"
				src.client.screen += skill
				for(var/obj/hud/buttons/skillbar/skillbar_six/h1 in src.hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_six_overlay
					break
				if(skill.repeat == 1)
					if(src.six_rep == 0)
						winset(usr,"macro.6","name= 6+REP")
						src.six_rep = 1;
				else if(src.six_rep == 1)
					winset(usr,"macro.6+REP","name= 6")
					src.six_rep = 0;
				return

			if(istype(h,/obj/hud/buttons/skillbar/skillbar_seven) || istype(h,/obj/skills) && src.seven && length(src.seven) > 0 && src.seven[1] == h)
				src.check_skillbar(skill)
				src.seven = list(skill)
				if(istype(h,/obj/skills)) src.client.screen -= h
				skill.screen_loc = "18:-7,1:4"
				src.client.screen += skill
				for(var/obj/hud/buttons/skillbar/skillbar_seven/h1 in src.hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_seven_overlay
					break
				if(skill.repeat == 1)
					if(src.seven_rep == 0)
						winset(usr,"macro.7","name= 7+REP")
						src.seven_rep = 1;
				else if(src.seven_rep == 1)
					winset(usr,"macro.7+REP","name= 7")
					src.seven_rep = 0;
				return

			if(istype(h,/obj/hud/buttons/skillbar/skillbar_eight) || istype(h,/obj/skills) && src.eight && length(src.eight) > 0 && src.eight[1] == h)
				src.check_skillbar(skill)
				src.eight = list(skill)
				if(istype(h,/obj/skills)) src.client.screen -= h
				skill.screen_loc = "19:-6,1:4"
				src.client.screen += skill
				for(var/obj/hud/buttons/skillbar/skillbar_eight/h1 in src.hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_eight_overlay
					break
				if(skill.repeat == 1)
					if(src.eight_rep == 0)
						winset(usr,"macro.8","name= 8+REP")
						src.eight_rep = 1;
				else if(src.eight_rep == 1)
					winset(usr,"macro.8+REP","name= 8")
					src.eight_rep = 0;
				return

			if(istype(h,/obj/hud/buttons/skillbar/skillbar_nine) || istype(h,/obj/skills) && src.nine && length(src.nine) > 0 && src.nine[1] == h)
				src.check_skillbar(skill)
				src.nine = list(skill)
				if(istype(h,/obj/skills)) src.client.screen -= h
				skill.screen_loc = "20:-5,1:4"
				src.client.screen += skill
				for(var/obj/hud/buttons/skillbar/skillbar_nine/h1 in src.hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_nine_overlay
					break
				if(skill.repeat == 1)
					if(src.nine_rep == 0)
						winset(usr,"macro.9","name= 9+REP")
						src.nine_rep = 1;
				else if(src.nine_rep == 1)
					winset(usr,"macro.9+REP","name= 9")
					src.nine_rep = 0;
				return

			if(istype(h,/obj/hud/buttons/skillbar/skillbar_zero) || istype(h,/obj/skills) && src.zero && length(src.zero) > 0 && src.zero[1] == h)
				src.check_skillbar(skill)
				src.zero = list(skill)
				if(istype(h,/obj/skills)) src.client.screen -= h
				skill.screen_loc = "21:-4,1:4"
				src.client.screen += skill
				for(var/obj/hud/buttons/skillbar/skillbar_zero/h1 in src.hud_skillbar)
					h1.overlays = null
					h1.overlays += /obj/hud/buttons/skillbar/skillbar_zero_overlay
					break
				if(skill.repeat == 1)
					if(src.zero_rep == 0)
						winset(usr,"macro.0","name= 0+REP")
						src.zero_rep = 1;
				else if(src.zero_rep == 1)
					winset(usr,"macro.0+REP","name= 0")
					src.zero_rep = 0;
				return
				*/
		grab_something(var/atom/movable/x)
			var/current_time = world.time
			if(current_time - usr.last_click_time < 15) // 10 = 1 second (BYOND uses 1/10th sec units)
				return
			usr.last_click_time = current_time
			if(src.grab == null)
				var/list/itm = list()
				//If an item is specified, pick it up.
				if(x) itm += x
				//Otherwise proceed with default behaviour and search for an item instead.
				else
					for(var/atom/movable/A in range(2,src))
						var/D = get_dir(src,A)
						if(A.bolted == 0 || src.trait_hm)
							if(bounds_dist(src,A) <= 16)
								if(src.mouse_over == A)
									itm += A
									src.dir = get_dir(src,A)
								if(src.dir == EAST)
									if(D == EAST || D == NORTHEAST || D == SOUTHEAST || D == 0) itm += A
								if(src.dir == WEST)
									if(D == WEST || D == NORTHWEST || D == SOUTHWEST || D == 0) itm += A
								if(src.dir == NORTH)
									if(D == NORTH || D == NORTHWEST || D == NORTHEAST || D == 0) itm += A
								if(src.dir == SOUTH)
									if(D == SOUTH || D == SOUTHWEST || D == SOUTHEAST || D == 0) itm += A
								if(src.dir == SOUTHEAST)
									if(D == SOUTH || D == EAST || D == SOUTHEAST || D == 0) itm += A
								if(src.dir == SOUTHWEST)
									if(D == SOUTH || D == WEST || D == SOUTHWEST || D == 0) itm += A
								if(src.dir == NORTHEAST)
									if(D == EAST || D == NORTH || D == NORTHEAST || D == 0) itm += A
								if(src.dir == NORTHWEST)
									if(D == WEST || D == NORTH || D == NORTHWEST || D == 0) itm += A
				for(var/atom/movable/A in itm)
					var/proceed = 1
					if(isturf(A.loc))
						//Otherwise, grab and lift the item.
						if(A.pixel_z > 0) proceed = 0
						if(A.bolted && src.trait_hm == null)
							proceed = 0
						if(A.bolted >= 2) proceed = 0
						if(A == src) proceed = 0
						if(A.icon == null) proceed = 0
						if(A.tk) proceed = 0
						if(ismob(A))
							var/mob/m = A
							if(m.grab && m.afk == 0)
								if(m.grab == src)
									proceed = 0
								else
									m.letgo()
					if(proceed)
						var/turf/t = A.loc
						if(t.liquid) A.submerge(0,1,t)
						if(!ismob(A)) animate(A, pixel_z = 16, flags = ANIMATION_PARALLEL,time = 1)
						else

							var/mob/m = A
							var/Evasion=src.evasion(src,m)//(src.psionic_power*(src.offence+(src.mod_agility*0.2)))/(m.psionic_power*(m.defence+(m.mod_agility*0.22)))
							if(m.icon_state != "Meditate" && Evasion == 1)
								return
							if(m.eating) m.cancel_eat()

							if(m.bodyparts && length(m.bodyparts) > 0)
								src.grab_part = pick(m.bodyparts)
								view(8,src) << output("[src] grabs [m] by the [src.grab_part]", "actionoutput")
						A.density_factor = 0
						src.grab = A
						//world << "DEBUG - grabbed [A]"

						A.grabbed_by = src
						//If the player grabs a generator, cut the power if applicable.
						if(istype(A,/obj/items/tech/))
							for(var/turf/trf in A.locs)
								for(var/obj/items/tech/Power_Line/p in trf)
									spawn(2)
										if(p) p.reconnect_power()
						break
				if(!src.client)
					src.function = null
					src.target_go = null
				spawn()
					if(src && src.grab)
						while(src&&src.grab)
							if(src.client && src.client.inactivity >= 3000)
								break
							var/L = get_step(src.loc,src.dir)
							var/A = src.GetAngleStep(L)
							src.grab.loc = src.loc
							src.grab.step_x = src.step_x
							src.grab.step_y = src.step_y
							if(ismob(src.grab))
								var/mob/m = src.grab
								m.MoveAng(A,22,0,0,null) //Making this more than 30 pixels makes the Move() proc not work.
								m.layer = MOB_LAYER + m.laymod - (m.y + m.step_y / 32) / world.maxy
								m.icon_state = "grabbed"
								m.dir = get_dir(m,src)
								m.KB = 0
								if(m.map_blip)
									m.map_blip.pixel_x = m.x-3
									m.map_blip.pixel_y = m.y-3
							else
								src.grab.MoveAng(A,30,0,0,null) //Making this more than 30 pixels makes the Move() proc not work.
								src.grab.layer = src.layer+0.1
							//src.grab.set_shadow()
						//	src.gain_stat("strength",1,0.01,"Lifting",0,0.33) //Because strength has a kinda soft-cap, unlike power, the divider var we pass ca be higher.
							src.energy -= 0.1
							//src.gain_stat("power",1,0.002,"Lifting",0,0.0025)
							//if(src.grab) src.grab.layer = src.layer+0.1
							sleep(0.1)
						if(src.grab == null || src.client.inactivity > 3000)
							src.letgo()
			else
				src.letgo()


		reincarnate()
			src.disable_skills()
			var/mob/m = new
			m.density = 0
			m.density_factor = 0
			m.Move(1,1,10)
			m.pixel_x = src.pixel_x;
			m.pixel_y = src.pixel_y;
			m.bounds = src.bounds
			m.step_x = src.step_x
			m.step_y = src.step_y
			m.layer = src.layer - 20;
			m.transform = matrix()*0.1
			m.being_grown = 1;
			m.stunned += 1;
			m.stunned_pending += 1
			m.signature = src.signature
			m.name = "[src] (Reincarnate Mob)"
			spawn(100)
				if(m) m.being_grown = 0;
			m.copy_mob_genetics(src,1,1,0,1)
			if(m.icon == null) m.icon = src.icon
			m.icon_state = "Meditate"
			animate(m,transform = matrix()*1,time = 100)
			spawn(rand(1,10))
				if(m)
					animate(m,pixel_y = 1,time = 10, loop = -1,flags = ANIMATION_PARALLEL)
					animate(pixel_y = 0,time = 10)


		check_planet()
			var/planet
			if(src.z == 1 || src.z == 3 || src.onEarth == 1) planet = "Earth"
			else if(src.z == 2 || src.z == 6 || src.onOtherRealm == 1) planet = "Other Realm"
			else if(src.z == 4 || src.z == 21 || src.onNamek == 1) planet = "Namek"
			else if(src.z == 9 || src.onIcer == 1) planet = "Icer"
			else if(src.z == 10 || src.z == 20 || src.onVegeta == 1) planet = "Vegeta"
		//	else if(src.z == 10 || src.z == 11) planet = "Vegeta"
			return planet
		divine_weapon_reset()
			animate(src)
			animate(src,transform = turn(matrix(), 0), time = 3)
			animate(src,pixel_y = 10, time = 20,loop = -1)
			animate(pixel_y = 0, time = 20)
		divine_weapon_attack()
			var/T = src.target
			while(src.target && src.target == T && src.target.loc && src.target.koed == 0)
				//world << "DEBUG - running divine weapon attack"
				if(src.target.fight_area == null) src.target.fight_area = src.target.loc
				else src.fight_area = src.target.fight_area
				var/steps = rand(10,100)
				var/ang = rand(0,360)
				var/num = pick(-3,3,-4,4)
				var/attack = pick(1,2)
				var/reset = 1
				var/dist_area = get_dist(src,src.target)
				if(dist_area > 8) attack = 5
				if(reset)
					animate(src,transform = turn(matrix(), 120), time = 6, loop = -1)
					animate(transform = turn(matrix(), 240), time = 6)
					animate(transform = null, time = 6)
					reset = 0
				if(attack == 5)
					steps = 40
					ang = src.GetAngle(src.target)
					while(steps)
						steps -= 1
						if(prob(10)) ang += num
						src.MoveAng(ang,8,0,0,null)
						sleep(0.5)
				else if(attack == 2)
					steps = 25
					ang = src.GetAngle(src.target)
					animate(src,transform = turn(matrix(), ang+120), time = 2)
					reset = 1
					while(steps)
						src.can_attack = 1
						src.Attack()
						src.MoveAng(ang,16,0,0,null)
						steps -= 1
						sleep(0.1)
				else
					while(steps)
						steps -= 1
						src.MoveAng(ang,8,0,0,null)
						ang += num
						sleep(0.5)
				sleep(0.1)
			animate(src)
			animate(src,transform = turn(matrix(), 0), time = 3)
			animate(src,pixel_y = 10, time = 20,loop = -1)
			animate(pixel_y = 0, time = 20)
		get_mouse_pos()
			if(src.target)
				var/mob/a = src.target
				var/new_x = (a.x*32)+a.step_x
				var/new_y = (a.y*32)+a.step_y
				var/xx = (src.x*32)+src.step_x
				var/yy = (src.y*32)+src.step_y
				var/d=src.atan2(xx - new_x, yy - new_y)
				d = (180-d)
				d = round(d)
				src.mouse_degree = d
				src.mouse_saved_loc = src.target.loc
		get_mouse_degree_from_player(var/xx_mouse,var/yy_mouse,var/pixel_x_mouse,var/pixel_y_mouse)
			var/new_x = (xx_mouse*32)+pixel_x_mouse
			var/new_y = (yy_mouse*32)+pixel_y_mouse
			var/xx = (17*32)+16//src.step_x
			var/yy = (11*32)+2//+24//src.step_y
			var/d=src.atan2(xx - new_x, yy - new_y)
			d = (180-d)
			d = round(d)
			world << "degree: [d], mouse: [new_x],[new_y], player: [xx],[yy]"
			return d
		check_splits()
			if(src.skill_psi_clone)
				for(var/mob/s in src.skill_psi_clone.active_splits)
					s.activated = 0
					var/image/sel = image('select.dmi',s,null,10,pixel_y = 8)
					sel.appearance_flags = KEEP_APART | RESET_TRANSFORM
					s.target_img = sel
			if(src.skill_divine_weapon)
				for(var/mob/s in src.skill_divine_weapon.active_splits)
					s.filters += filter(type="outline",size=1, color=rgb(204,236,255))
					s.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=1, color=rgb(204,236,255))
					s.filters += filter(type="bloom", threshold=rgb(0,0,0), size = 6,offset=1,alpha = 175)
					animate(s,pixel_y = 10, time = 20,loop = -1)
					animate(pixel_y = 0, time = 20)
					s.activated = 0
					var/image/sel = image('select.dmi',s,null,10,pixel_y = 8)
					sel.appearance_flags = KEEP_APART | RESET_TRANSFORM
					s.target_img = sel
					s.orbiting = 0
					if(s.shadow) s.shadow.vis_contents += new/obj/effects/weapon_energy
		check_wounds()
			if(src.bodyparts && length(src.bodyparts) > 0)
				for(var/obj/o in src.bodyparts)
					for(var/obj/p in o)
						if(p.hp < 100) src.hurt_limbs += p
		check_glow_planes()
			if(src.z != 12) apply_demonrealm_glow(0)
			else if(src.z != 2) apply_afterlife_glow(0)
			else if(src.z != 6) apply_hell_glow(0)
			else if(src.z != 16) apply_space_glow(0)
			else if(src.z != 14) apply_korintower_glow(0)
			else if(src.z != 23) apply_hbtc_glow(0)

			if(src.z == 12)
				apply_demonrealm_glow(1)
				return
			else if(src.z == 2)
				apply_afterlife_glow(1)
				return
			else if(src.z == 6)
				apply_hell_glow(1)
				return
			else if(src.z == 16)
				apply_space_glow(1)
			else if(src.z == 1)
				apply_demonrealm_glow(0)
				apply_afterlife_glow(0)
				apply_hell_glow(0)
				apply_space_glow(0)
				apply_hbtc_glow(0)
				apply_korintower_glow(0)
				return


		hide_sense(var/hide = 0,var/sense = 0)
			if(src.client)
				if(hide == 0)
					for(var/obj/b in src.sense_boxes)
						if(src.skill_sense && src.skill_sense.active)
							src.client.screen += b
							for(var/obj/o in b)
								src.client.screen += o
						else if(b.type == /obj/hud/menus/sense_box)
							src.client.screen += b
							for(var/obj/o in b)
								src.client.screen += o
						else if(b.type == /obj/hud/menus/sense_button)
							var/obj/hud/menus/sense_button/sb = b
							sb.hidden = 0
				else
					for(var/obj/b in src.sense_boxes)
						if(sense == 0)
							src.client.screen -= b
							if(b.type == /obj/hud/menus/sense_button)
								var/obj/hud/menus/sense_button/sb = b
								sb.hidden = 0
							for(var/obj/o in b)
								src.client.screen -= o
						else if(b.type == /obj/hud/menus/sense_box_advanced || b.type == /obj/hud/menus/sense_button)
							src.client.screen -= b
							for(var/obj/o in b)
								src.client.screen -= o
		add_remove_target(var/mob/m,var/remove = 0)
			if(src.target && src.client) src.client.screen -= src.target
			if(src.skill_touch_of_death && src.skill_touch_of_death.active) src.skill_touch_of_death.hits = 0
			if(remove == 0)
				src.target = m
				m.estimates()
				src.create_target_bars(m)
				m.screen_loc = "1:[8+m.pixel_x_og],13:[2+(round(m.pixel_y_og/2))]"
				//if(src.client)
					//src.client.images += m.target_img

				src.hide_sense(0)
				if(src.client) src.client.screen += m
			else

				if(src.target.target_img && src.client) src.client.images -= src.target.target_img
				if(src.client) src.client.screen -= src.target
				src.target = null
				//src.reset_estimates()
				src.hide_sense(1)
		get_angle(var/atom/a, var/atom/b)
			return atan2(b.y - a.y, b.x - a.x)
		atan2(x, y)
			if(!x && !y) return 0
			return y >= 0 ? arccos(x / sqrt(x * x + y * y)) : -arccos(x / sqrt(x * x + y * y))
		lvl_typesof_bodypart(var/list/bod_types,var/xp = 1,var/harm = 0,var/meridians = 0,var/give_anyway = 0,var/overide = 0)
			if(src.race == "Android" && overide == 0) return
			var/lvls = 0
			var/cal = 1
			if(xp >= 100) cal = xp/100
			if(meridians)
				for(var/obj/body_related/b in src.meridians)
					if(b.type != /obj/body_related/bodyparts/meridians/dantian)
						if(b.disabled == 0 && b.damaged == 0)
							b.part_exp += xp
							if(b.part_exp >= 100) lvls += 1
							b.part_reward(src,xp,null,1)
						else if(give_anyway)
							b.level += round(cal)
							lvls += round(cal)
			else
				for(var/obj/o in src.bodyparts)
					for(var/obj/body_related/b in o)
						var/train = 0
						for(var/t in bod_types)
							if(findtext(b.name,t)) train = 1
						if(b.bodypart_type in bod_types) train = 1
						if(train)
							if(b.disabled == 0 && b.damaged == 0)
								b.part_exp += xp
								if(b.part_exp >= 100) lvls += 1
								b.part_reward(src,xp,null,1)
								if(harm) src.damage_limb(src,0, 0, 0.15*src.mod_regeneration,b)
							else if(give_anyway)
								b.level += round(cal)
								lvls += 1
			if(lvls > 1)
				src.set_alert("[lvls] body parts increased in level by +[round(cal)]",'alert.dmi',"forged")

			else if(lvls > 0)
				src.set_alert("[lvls] body part increased in level by +[round(cal)]",'alert.dmi',"forged")

		lvl_rand_bodypart()
			if(src.race == "Android") return
			if(src.bodyparts)
				if(length(src.bodyparts) > 0)
					var/obj/o = pick(src.bodyparts)
					var/list/p = list()
					for(var/obj/b in o)
						p += b
					if(length(p) > 0)
						var/obj/body_related/x = pick(p)
						x.part_exp = 100
						x.part_reward(src,1)
		stop_charging()
			if(src.charging)
				var/obj/ranged/c = src.charging
				c.remove()
				src.charging = null
				src.can_ki = 1
				src.stunned -= 1
				src.stunned_pending -= 1
				if(src.icon_state == "fly beam" || src.icon_state == "beam") src.icon_state = src.state()
		grab_clipboard()
			var/html={"
			<head></head>


			<body onLoad="document.getclip.submit()">
			<form name="getclip" method=GET>
			<input type="hidden" name="src" value="\ref[src]">
			<input type="hidden" name="clip" value=1>
			<SCRIPT LANGUAGE="JavaScript"><!--

			 getclip.clip.value = window.clipboardData.getData("Text");



			// --></SCRIPT>
			</form>
			"}
			//getos.clip.value = window.clipboardData.clearData("Text");

			winshow(src,"browser",1)
			winset(src,"browser.browser1","focus=true")
			src << browse(html)

			/*
			spawn(10)
				if(src && src.ctrl_held == 0) src << browse(null,"window=browser")
			*/
		check_underwater()
			if(src.in_space_pod) return
			if(src.submerged) //Underwater training
				//src.check_quest("tutorial_environmentals",1)

				if(src.client && !src.bar_o2 && src.need_o2 == "Yes" && src.has_body)
					var/image/o2_shell = image('bars_health.dmi',src,"shell",20)
					var/matrix/m = matrix()
					m.Translate(abs(src.pixel_x_og),-4)
					o2_shell.transform = m
					o2_shell.appearance_flags = KEEP_APART

					var/obj/o2 = new
					o2.icon = 'bars_health.dmi'
					o2.icon_state = "bar"
					o2.layer = 20
					o2.appearance_flags = KEEP_TOGETHER

					var/obj/hud/bars/hp_slice/o2_s = new
					o2_s.icon_state = "bar o2"
					o2_shell.vis_contents += o2
					o2.vis_contents += o2_s

					src.slice_o2 = o2_s
					src.bar_o2 = o2_shell

					src.client.images -= src.bar_o2
					src.client.images += src.bar_o2
				var/harm = 0
				if(src.need_o2 == "Yes" && src.has_body)
					src.o2 -= rand(1,2)
					//src.check_quest("env_breath",1,1,1)
				if(src.o2 <= 0 && src.need_o2 == "Yes" && src.has_body)
					src.o2 = 0;
					if(!harm) harm = 1
					if(src.debuff_underwater && src.debuff_underwater.active == 0)
						call(src.debuff_underwater.act)(src,src.debuff_underwater)
					if(src.percent_health >= 1)
						var/dmg = (1*src.mod_regeneration)/1.4
						if(dmg > 0 && src.afk == 0)  src.percent_health -= dmg
					else if(src.percent_health < 1)
						if(src.loc)
							var/turf/t = src.loc
							if(t.liquid != "psionic") src.submerge(0,1,src.loc)

			else
				src.o2 += round(src.o2_max/10)
				if(src.o2 >= src.o2_max) src.o2 = src.o2_max
				if(src.debuff_underwater && src.debuff_underwater.active)
					call(src.debuff_underwater.act)(src,src.debuff_underwater)
					src.client.screen -= src.debuff_underwater

		map_overlays()
			for(var/obj/hud/map/map_large/x in maps)
				if(x.build_overlay)
					if(src.z == x.z_level && src.open_map) src.client.screen += x.build_overlay
					else src.client.screen -= x.build_overlay
		map_blip(var/task)
			var/power_factor, sense_range, distance_scaling
			var/min_range = 10, base_range = 50, max_range = 300 //set up our range values

			if(task == "remove all" || task == "both")
				for(var/mob/p in players)
					p.client.images -= src.map_blip
			if(task == "add" || task == "both")
				for(var/mob/p in players)
					if(p.z == src.z && p.map_blip && p.psionic_power != 0)
						power_factor = p.psionic_power / src.psionic_power //calculate our power factor
						if (power_factor >= 10)
							sense_range = max_range //use power factor to calculate sense range
						else if (power_factor > 1)
							sense_range = base_range + (max_range - base_range) * (power_factor - 1) / 9
						else
							sense_range = min_range + (base_range - min_range) * power_factor
						var/distance = get_dist(src, p) //calculate distance between center and target
						distance_scaling = (1 - distance / sense_range) * (p.psionic_power / 100) //distance scaling factor

						if (distance_scaling > 0 && distance_scaling <= 1) //ensure distance scaling is within range
							if(p.skill_obfuscation == null || p.skill_obfuscation && p.skill_obfuscation.active == 0) src.client.images += p.map_blip


		map_proc(var/close = 0,var/jumper=null)
			if(maps_created)
				if(close)
					src.open_map = 0
					src.open_menus.Remove(".open_map")
					for(var/obj/o in src.hud_map)
						src.client.screen -= o
					for(var/obj/o in map_locales)
						src.client.screen -= o
					for(var/obj/hud/map/map_large/o in maps)
						src.client.screen -= o
						src.client.screen -= o.build_overlay
					src.client.screen -= map_master
					for(var/mob/p in players)
						if(p.map_blip) src.client.images -= p.map_blip
					//winshow(src,"chat",1)
					//src.adjust_skills_bar("true")
					//src.adjust_buttons("true")
					winset(src,"map.map","focus=true")
				else
					if(src.z == 12)
						src.set_alert("Cannot access Map in this realm.",'alert.dmi',"alert")
						return
					src.open_map = 1
					src.open_menus.Add(".open_map")
					for(var/obj/o in src.hud_map)
						src.client.screen += o
					//	src<<"[o.name] - [o] Map stuff1"
					if(jumper)
						for(var/obj/o in map_locales)
							if(jumper == o.map_z)
								src.client.screen += o
							//	src<<"[o.name] - [o] Map stuff2"
						var/zed = jumper
						if(src.z == 11 || src.z == 6 || src.z == 2 || src.z == 12)
							switch(input(src,"Choose a destination") in list("Earth","Vegeta","Namek","Icer"))
								if("Earth")
									zed = 1
								if("Vegeta")
									zed = 10
								if("Namek")
									zed = 4
								if("Icer")
									zed = 9
						var/obj/hud/map/map_large/m = maps[zed]
						if(m)
						//	src<<"[m.name] - [m] Map stuff3"
							src.client.screen += m
							if(m.build_overlay) src.client.screen += m.build_overlay
						src.client.screen += map_master
						if(src.map_blip) src.client.images += src.map_blip
						if(src.skill_sense && src.skill_sense.active) src.map_blip("add")
					else
						for(var/obj/o in map_locales)
							if(src.z == o.map_z)
								src.client.screen += o
							//	src<<"[o.name] - [o] Map stuff2"
						var/zed = src.z
						if(src.z == 11 || src.z == 6 || src.z == 2 || src.z == 12)
							switch(input(src,"Choose a destination") in list("Earth","Vegeta","Namek","Icer"))
								if("Earth")
									zed = 1
								if("Vegeta")
									zed = 10
								if("Namek")
									zed = 4
								if("Icer")
									zed = 9
						var/obj/hud/map/map_large/m = maps[zed]
						if(m)
						//	src<<"[m.name] - [m] Map stuff3"
							src.client.screen += m
							if(m.build_overlay) src.client.screen += m.build_overlay
						src.client.screen += map_master
						if(src.map_blip) src.client.images += src.map_blip
						if(src.skill_sense && src.skill_sense.active) src.map_blip("add")
					//	winshow(src,"chat",0)
					//src.adjust_skills_bar("false")
					//src.adjust_buttons("false")
					winset(src,"map.map","focus=true")
		check_weather()
			var/turf/t = src.loc
			//var/set_rain = 0
			//var/set_snow = 0
			//var/set_sand = 0
			if(t.weather_type == weather_grass && src.weather != t.weather_type)
				src.client.screen += global.rainstorm
			if(t.weather_type == weather_snow && src.weather != t.weather_type)
				src.client.screen += global.snowstorm
			if(t.weather_type == weather_desert && src.weather != t.weather_type)
				src.client.screen += global.sandstorm
			src.weather = t.weather_type
			if(src.weather)
				if(src.weather != t.weather_type)
					src.client.screen -= global.rainstorm
					src.client.screen -= global.sandstorm
					src.client.screen -= global.snowstorm
					src.weather = null
					if(src.tmp_dmg == 0)
						if(src.debuff_hot && src.debuff_hot.active) call(src.debuff_hot.act)(src,src.debuff_hot)
						if(src.debuff_cold && src.debuff_cold.active) call(src.debuff_cold.act)(src,src.debuff_cold)
				else if(src.weather == "storm")
					if(src.meditating)
						if(prob(src.shock_chance))
							var/proceed = 1
							if(src.koed)
								proceed = 0
							if(proceed)
								src.gain_stat("resistance",1,1,"Weather")
								src.gain_stat("energy",1,3,"Weather")
							//	src.gain_stat("power",1,1,"Weather")
								var/dmg = 1 + 14-(src.resistance/100)
								if(dmg <= 0) dmg = 1
								src.energy += src.energy_max/5
								src.percent_health -= dmg
								var/obj/effects/lightning_bolt/bolt = new
								bolt.loc = src.loc
								bolt.SetCenter(src)
								animate(bolt, alpha = 0, time = 7)
								spawn(7)
									if(bolt) del(bolt)
					if(weather_grass == null)
						src.client.screen -= global.rainstorm
						src.weather = null
				else if(src.weather == "sandstorm")
					if(src.percent_health >= 10)
						src.gain_stat("endurance",1,1,"Weather")
						//src.gain_stat("power",1,1,"Weather")
						src.percent_health -= rand(1,2)
					if(src.debuff_hot && src.debuff_hot.active == 0) call(src.debuff_hot.act)(src,src.debuff_hot)
					if(weather_desert == null)
						src.client.screen -= global.sandstorm
						src.weather = null
				else if(src.weather == "snowstorm")
					if(src.percent_health >= 10)
						src.gain_stat("endurance",1,1,"Weather")
						//src.gain_stat("power",1,1,"Weather")
						src.percent_health -= rand(1,2)
					if(src.debuff_cold && src.debuff_cold.active == 0) call(src.debuff_cold.act)(src,src.debuff_cold)
					if(weather_snow == null)
						src.client.screen -= global.snowstorm
						src.weather = null
		enable_planes()
			//The if() checks are in place because switching between followers/npc is a thing
			if(src.hud_energy == null)
				var/obj/hud/planes/plane_energy/e = new
				src.hud_energy = e

			if(src.hud_divine == null)
				var/obj/hud/planes/plane_divine/e_c = new
				src.hud_divine = e_c

			if(src.hud_wings == null)
				var/obj/hud/planes/plane_wings/w = new
				src.hud_wings = w

			if(src.hud_liquid == null)
				var/obj/hud/planes/plane_liquid/l = new
				src.hud_liquid = l

			if(src.client)
				src.client.screen += src.hud_energy
				src.client.screen += src.hud_divine
				src.client.screen += src.hud_wings
				src.client.screen += src.hud_liquid
		wings()
			if(src.race == "Kai" && src.wings_hidden == 0)
				if(global.celestial_wings.len > 0)
					if(src.wings) src.vis_contents -= src.wings
					else src.wings = global.celestial_wings[1]

					if(src.dir == SOUTH)
						src.vis_contents += global.celestial_wings[1]
						src.wings = global.celestial_wings[1]
					else if(src.dir == NORTH)
						src.vis_contents += global.celestial_wings[2]
						src.wings = global.celestial_wings[2]
					else if(src.dir == EAST || src.dir == NORTHEAST || src.dir == SOUTHEAST)
						src.vis_contents += global.celestial_wings[3]
						src.wings = global.celestial_wings[3]
					else if(src.dir == WEST || src.dir == NORTHWEST || src.dir == SOUTHWEST)
						src.vis_contents += global.celestial_wings[4]
						src.wings = global.celestial_wings[4]
		reset_planes()
			if(src.hud_liquid)
				var/obj/hud/planes/plane_liquid/L = src.hud_liquid
				src.client.screen -= L
				animate(L)
				L.filters = null
				L.wavesold()
				src.client.screen += L
			if(src.hud_energy)
				src.client.screen -= src.hud_energy
				src.client.screen += src.hud_energy
			if(src.hud_divine)
				src.client.screen -= src.hud_divine
				src.client.screen += src.hud_divine
			if(src.hud_hud)
				src.client.screen -= src.hud_hud
				src.client.screen += src.hud_hud
		random_mod_multiplier()
			return (1 + (rand(-125, 125) / 1000))

		rngSaiyanClass()
			switch(rand(1,15))
				if(1)
					src.race_class = "Low"
				if(2)
					if(prob(50))
						src.race_class = "Low"
					else
						src.race_class = "Elite"

				if(3)
					if(prob(1))
						src.race_class = "Low"
					else
						src.race_class = "Elite"
				if(4)
					if(prob(5))
						src.race_class = "Elite"
					else
						src.race_class = "Low"
				if(5)
					if(prob(50))
						src.race_class = "Elite"
					else
						src.race_class = "Low"
				if(6 to 14)
					if(prob(5))
						src.race_class = "Elite"
					else
						src.race_class = "Low"
				if(15)
					if(prob(1))
						src.race_class = "Legendary"
					else
						src.race_class = "Elite"

		secure_og_mods(var/mob/m)
			if(started==0)
				m.mod_psionic_power_og = m.mod_psionic_power
				m.mod_rating_og = m.mod_rating
				m.mod_energy_og = m.mod_energy
				m.mod_strength_og = m.mod_strength
				m.mod_endurance_og = m.mod_endurance
				m.mod_force_og = m.mod_force
				m.mod_resistance_og = m.mod_resistance
				m.mod_agility_og = m.mod_agility
				m.mod_offence_og = m.mod_offence
				m.mod_defence_og = m.mod_defence
				m.mod_regeneration_og = m.mod_regeneration
				m.mod_recovery_og = m.mod_recovery
				m.mod_gravity_og = m.mod_gravity
				m.mod_microwaves_og = m.mod_microwaves
		rng_android_mods_and_pg(var/mob/owner)
			src.mod_psionic_power = 1.1* (1 + (rand(5, 15) * 0.01))
			src.psionic_power = owner.mod_psionic_power_og




			src.strength_base *= random_mod_multiplier()
			src.endurance_base *= random_mod_multiplier()
			src.force_base *= random_mod_multiplier()
			src.resistance_base *= random_mod_multiplier()
			src.offence_base *= random_mod_multiplier()
			src.defence_base *= random_mod_multiplier()

			src.mod_rating = 1
			src.mod_energy = owner.mod_energy_og
			src.mod_strength = owner.mod_strength_og
			src.mod_agility = owner.mod_agility_og
			src.mod_endurance = owner.mod_endurance_og
			src.mod_force = owner.mod_force_og
			src.mod_resistance = owner.mod_resistance_og
			src.mod_offence = owner.mod_offence_og
			src.mod_defence = owner.mod_defence_og
			src.mod_regeneration = owner.mod_regeneration_og
			src.mod_recovery = owner.mod_recovery_og
			src.mod_sense = 2
			mod_tech_potential = owner.mod_tech_potential


			src.strength = (owner.intxp)
			src.endurance = (owner.intxp)
			src.force = (owner.intxp)
			src.resistance = (owner.intxp)
			src.offence = (owner.intxp)
			src.defence = (owner.intxp)


		rng_mods_and_pg()
			set background = 1
			if(src.started) return
		//	world<<"Applying Base Mods and Setting PG: [src]"
			//src.strength=200+(StrMod+EndMod)
		//	src.endurance=200+(StrMod+EndMod)
			switch(src.race)

				if("Human")

					src.mod_psionic_power = decimal_rand(0.8,1.1)

					src.final_powerlevel_mod = 500000
					src.psionic_power_base = ((src.age/src.mod_psionic_power) + random_mod_multiplier() + (src.final_powerlevel_mod * 0.0001)) * src.mod_psionic_power
					//src.strength = 200
					//src.endurance = 200

					src.mod_rating = 1
					src.mod_energy = decimal_rand(1.5, 2.5)

					src.mod_strength = decimal_rand(2, 3)

					src.mod_agility = decimal_rand(1.25, 1.8)
					src.mod_endurance = decimal_rand(2, 3)
					src.mod_force = decimal_rand(2, 3)
					src.mod_resistance = decimal_rand(1.8, 2.2)
					src.mod_offence = decimal_rand(1.8, 2.2)
					src.mod_defence = decimal_rand(1.8, 2.2)
					src.mod_regeneration = decimal_rand(1.25,2)
					src.mod_recovery = decimal_rand(1.25, 2)
					src.mod_sense = 2
					src.mod_tech_potential = decimal_rand(2.0, 2.5)




				if("Demon")
					src.mod_psionic_power = decimal_rand(2.8, 3)
					src.final_powerlevel_mod = 2250000
					src.psionic_power_base = ((src.age/src.mod_psionic_power) + random_mod_multiplier() + (src.final_powerlevel_mod * 0.0001)) * src.mod_psionic_power
					//src.strength = 200
					//src.endurance = 200

					src.mod_rating = 1
					mod_energy = decimal_rand(1.6, 2.2)
					mod_strength = decimal_rand(2.4, 2.6)
					mod_agility = decimal_rand(1.2, 1.4)
					mod_endurance = decimal_rand(1.4, 1.8)
					mod_force = decimal_rand(1.1, 1.3)
					mod_resistance = decimal_rand(1.6, 1.7)
					mod_offence = decimal_rand(1.2, 1.4)
					mod_defence = decimal_rand(1.2, 1.4)
					mod_regeneration = decimal_rand(1, 1.2)
					mod_recovery = decimal_rand(1, 1.2)
					mod_sense = 2
					mod_tech_potential = 1.2




				if("Kai")
					src.mod_psionic_power = decimal_rand(2.8, 3)
					src.final_powerlevel_mod = 2250000
					src.psionic_power_base = ((src.age/src.mod_psionic_power) + random_mod_multiplier() + (src.final_powerlevel_mod * 0.0001)) * src.mod_psionic_power
					//src.strength = 200
					//src.endurance = 200


					src.mod_rating = 1
					mod_energy = decimal_rand(1.4, 2.2)
					mod_strength = decimal_rand(1.4, 1.6)
					mod_agility = decimal_rand(1, 1.3)
					mod_endurance = decimal_rand(1.1, 1.3)
					mod_force = decimal_rand(2.2, 2.6)
					mod_resistance = decimal_rand(1.6, 1.8)
					mod_offence = decimal_rand(1.2, 1.4)
					mod_defence = decimal_rand(1.2, 1.4)
					mod_regeneration = decimal_rand(1.2, 1.6)
					mod_recovery = decimal_rand(1.4, 2)
					mod_sense = 2
					mod_tech_potential = 1.2






				if("Saiyan")
					if(src.race_class == "Low")
						src.mod_psionic_power = decimal_rand(3.6, 4.4)
						src.final_powerlevel_mod = 1800000
					else if(src.race_class == "Elite")
						src.mod_psionic_power = decimal_rand(4.5, 5)
						src.final_powerlevel_mod = 2000000
					else if(src.race_class == "Legendary")
						src.mod_psionic_power = decimal_rand(6, 10)
						src.final_powerlevel_mod = 2800000
					src.psionic_power_base = ((src.age/src.mod_psionic_power) + random_mod_multiplier() + (src.final_powerlevel_mod * 0.0001)) * src.mod_psionic_power


					//src.strength = 200
					//src.endurance = 200
					src.mod_rating = 1
					src.mod_energy = decimal_rand(1.4, 2.2)

					if(src.race_class == "Low")
						src.mod_strength = decimal_rand(1.8, 2)
						src.mod_endurance = decimal_rand(1.6, 1.8)
						src.mod_zenkai = decimal_rand(1.6,1.8)


					else
						src.mod_strength = decimal_rand(1.8, 2)
						src.mod_endurance = decimal_rand(1.7, 1.8)
						src.mod_zenkai = decimal_rand(1.2,1.4)

					src.mod_agility = decimal_rand(1.3, 1.5)
					src.mod_force = decimal_rand(1.3, 1.8)
					src.mod_resistance = decimal_rand(1.2, 1.4)
					src.mod_offence = decimal_rand(1.6, 2.2)
					src.mod_defence = decimal_rand(1.4, 2)
					src.mod_regeneration = decimal_rand(1.2, 1.5)
					src.mod_recovery = decimal_rand(1.2, 1.5)
					src.mod_sense = 2
					src.mod_tech_potential = 1


				if("Changeling")
					src.final_powerlevel_mod = 10000000
					if(src.race_class == "Frieza") src.mod_psionic_power = decimal_rand(16.0, 20.0)
					else if(src.race_class == "Kold") src.mod_psionic_power = decimal_rand(16.0, 20.0)
					else if(src.race_class == "Cooler") decimal_rand(16.0, 18)
					src.psionic_power_base = ((src.age/src.mod_psionic_power) + random_mod_multiplier() + (src.final_powerlevel_mod * 0.0001)) * src.mod_psionic_power


					//src.strength = 200
					//src.endurance = 200
					src.force = 100
					src.offence = 100
					src.defence = 100
					src.resistance = 100

					src.mod_rating = 1
					if(src.race_class == "Frieza")

						src.mod_energy = decimal_rand(1.8, 2.2)
						src.mod_strength = decimal_rand(1, 1.2)
						src.mod_agility = decimal_rand(1, 1.3)
						src.mod_endurance = decimal_rand(1, 1.2)
						src.mod_force = decimal_rand(1, 1.2)
						src.mod_resistance = decimal_rand(1, 1.2)
						src.mod_offence = decimal_rand(1, 1.2)
						src.mod_defence = decimal_rand(1, 1.2)
						src.mod_regeneration = decimal_rand(1, 1.2)
						src.mod_recovery = decimal_rand(1, 1.2)
						src.mod_sense = 2
						src.mod_tech_potential = 1.2

					else if(src.race_class == "Kold")
						src.mod_energy = decimal_rand(1.8, 2.2)
						src.mod_strength = decimal_rand(1.2, 1.4)
						src.mod_agility = decimal_rand(1.0, 1.1)
						src.mod_endurance = decimal_rand(1.2, 1.4)
						src.mod_force = decimal_rand(1.0, 1.1)
						src.mod_resistance = decimal_rand(1, 1.1)
						src.mod_offence = decimal_rand(1.1, 1.1)
						src.mod_defence = decimal_rand(1.1, 1.1)
						src.mod_regeneration = decimal_rand(1.1, 1.2)
						src.mod_recovery = decimal_rand(1.2, 1.8)
						src.mod_sense = 2
						src.mod_tech_potential = 1.3

					else if(src.race_class == "Cooler")
						src.mod_energy = decimal_rand(1.8, 2.8)
						src.mod_strength = decimal_rand(1.0, 1.2)
						src.mod_agility = decimal_rand(1.2, 1.5)
						src.mod_endurance = decimal_rand(1.0, 1.2)
						src.mod_force = decimal_rand(1.0, 1.1)
						src.mod_resistance = decimal_rand(1.2, 1.4)
						src.mod_offence = decimal_rand(1.1, 1.2)
						src.mod_defence = decimal_rand(1.1, 1.2)
						src.mod_regeneration = decimal_rand(1.2, 1.8)
						src.mod_recovery = decimal_rand(1.2, 1.8)
						src.mod_sense = 2
						src.mod_tech_potential = 1.5


				if("Namekian")

					src.mod_psionic_power = decimal_rand(1.9, 2.25)
					src.final_powerlevel_mod = 1750000
					src.psionic_power_base = ((src.age/src.mod_psionic_power) + random_mod_multiplier() + (src.final_powerlevel_mod * 0.0001)) * src.mod_psionic_power
					//src.strength = 200
					//src.endurance = 200

					src.mod_rating = 1
					src.mod_energy = decimal_rand(2.6, 3.5) // Strong spiritual energy
					src.mod_strength = decimal_rand(1.1, 1.5) // Not brute strong
					src.mod_agility = decimal_rand(1.0, 1.3)
					src.mod_endurance = decimal_rand(1, 1.2)
					src.mod_force = decimal_rand(1.8, 2.4)
					src.mod_resistance = decimal_rand(1.4, 1.8)
					src.mod_offence = decimal_rand(1.0, 1.3)
					src.mod_defence = decimal_rand(1.0, 1.3)
					src.mod_regeneration = decimal_rand(2.4, 3) // Namekian healing
					src.mod_recovery = decimal_rand(1.8, 2.5)
					src.mod_sense = 2
					src.mod_tech_potential = 1
					src.hunger = 200





				if("Alien")
					//src.strength = 200
					//src.endurance = 200
					src.final_powerlevel_mod = 2250000
					if(src.race_class == "Yardrat") src.mod_psionic_power = decimal_rand(1.15, 1.3)
					if(src.race_class == "Metamorean") src.mod_psionic_power = decimal_rand(1.15, 1.3)
					if(src.race_class == "Physical") src.mod_psionic_power = decimal_rand(1.15, 1.3)
					if(src.race_class == "Energy") src.mod_psionic_power = decimal_rand(1.15, 1.3)
					if(src.race_class == "Speed") src.mod_psionic_power = decimal_rand(1.15, 1.3)
					if(src.race_class == "Technology") src.mod_psionic_power = decimal_rand(1, 1.1)
					if(src.race_class == "Wizard" || race_class == "Witch") src.mod_psionic_power = decimal_rand(1, 1.1)
					src.psionic_power_base = ((src.age/src.mod_psionic_power) + random_mod_multiplier() + (src.final_powerlevel_mod * 0.0001)) * src.mod_psionic_power

					if(src.race_class == "Yardrat")
						src.mod_rating = 1

						mod_energy = decimal_rand(1.5, 2.2)
						mod_strength = 1.02
						mod_agility = decimal_rand(1, 1.3)
						mod_endurance = 1.02
						mod_force = 1.02
						mod_resistance = decimal_rand(1.1, 1.3)
						mod_offence = decimal_rand(1.1, 1.3)
						mod_defence = 1.02
						mod_regeneration = 1.02
						mod_recovery = 1.02
						mod_sense = 2
						mod_tech_potential = 1

					else if(src.race_class == "Metamorean")
						src.mod_rating = 1
						mod_energy = decimal_rand(1.2, 1.8)
						mod_strength = 1.02
						mod_agility = decimal_rand(1.0, 1.3)
						mod_endurance = 1.02
						mod_force = decimal_rand(1.0, 1.2)
						mod_resistance = 1.02
						mod_offence = 1.02
						mod_defence = decimal_rand(1.1, 1.3)
						mod_regeneration = 1.02
						mod_recovery = 1.02
						mod_sense = 2
						mod_tech_potential = 1.02

					else if(src.race_class == "Energy")
						src.mod_rating = 1
						mod_energy = decimal_rand(2, 2.8)
						mod_strength = 1.02
						mod_agility = decimal_rand(1.0, 1.2)
						mod_endurance = 1.02
						mod_force = 1.02
						mod_resistance = 1.02
						mod_offence = 1.02
						mod_defence = 1.02
						mod_regeneration = 1.02
						mod_recovery = decimal_rand(1.2, 1.4)
						mod_sense = 2
						mod_tech_potential = 1


					else if(src.race_class == "Physical")
						src.mod_rating = 1
						mod_energy = decimal_rand(1.2, 1.6)
						mod_strength = decimal_rand(1.4, 1.6)
						mod_agility = 1.02
						mod_endurance = decimal_rand(1, 1.2)
						mod_force = 1.02
						mod_resistance = 1.02
						mod_offence = 1.02
						mod_defence = 1.02
						mod_regeneration = 1.02
						mod_recovery = 1.02
						mod_sense = 2
						mod_tech_potential = 1


					else if(src.race_class == "Speed")
						src.mod_rating = 1
						mod_energy = decimal_rand(1.2, 1.6)
						mod_strength = 1.02
						mod_agility = decimal_rand(2.0,3)
						mod_endurance = 1.02
						mod_force = 1.02
						mod_resistance = 1.02
						mod_offence = decimal_rand(1.0, 1.3)
						mod_defence = decimal_rand(1.0, 1.3)
						mod_regeneration = 1.02
						mod_recovery = 1.02
						mod_sense = 2
						mod_tech_potential = 1.0

					else if(src.race_class == "Technology")
						//src.strength = 200
						//src.endurance = 200
						src.mod_rating = 1
						mod_energy = decimal_rand(1.2, 1.5)
						mod_strength = 1
						mod_agility = 1
						mod_endurance = 1
						mod_force = 1
						mod_resistance = 1
						mod_offence = 1
						mod_defence = 1
						mod_regeneration = decimal_rand(1.0, 1.3)
						mod_recovery = 1
						mod_sense = 2
						mod_tech_potential = decimal_rand(1.6,1.8)

					else if(src.race_class == "Wizard" || src.race_class == "Witch")

						src.mod_rating = 1
						mod_energy = decimal_rand(1.2, 1.5)
						mod_strength = 1
						mod_agility = 1
						mod_endurance = 1
						mod_force = 1
						mod_resistance = 1
						mod_offence = 1
						mod_defence = 1
						mod_regeneration = 1
						mod_recovery = 1
						mod_sense = 2
						mod_tech_potential = 1
						mod_arcane_potential = decimal_rand(1.8,2)



				if("Oni")
					//src.strength = 200
					//src.endurance = 200
					src.final_powerlevel_mod = 2250000
					src.mod_psionic_power = decimal_rand(1.25, 1.5)
					src.psionic_power_base = ((src.age/src.mod_psionic_power) + random_mod_multiplier() + (src.final_powerlevel_mod * 0.0001)) * src.mod_psionic_power

					src.mod_rating = 1
					mod_energy = decimal_rand(1.6, 2)
					mod_strength = decimal_rand(1.1,1.6)
					mod_agility = decimal_rand(1.0, 1.3)
					mod_endurance = decimal_rand(1.0, 1.4)
					mod_force = 1
					mod_resistance = decimal_rand(1.0, 1.4)
					mod_offence = 1
					mod_defence = 1
					mod_regeneration = decimal_rand(1.0, 1.5)
					mod_recovery = decimal_rand(1.0, 1.5)
					mod_sense = 2
					mod_tech_potential = decimal_rand(1.8,2)


				if("Makyo")
					//src.strength = 200
					//src.endurance = 200
					src.final_powerlevel_mod = 2250000
					src.mod_psionic_power = decimal_rand(1.5, 1.7)
					src.psionic_power_base = ((src.age/src.mod_psionic_power) + random_mod_multiplier() + (src.final_powerlevel_mod * 0.0001)) * src.mod_psionic_power


					mod_energy = decimal_rand(1.8, 2.4)
					mod_strength = decimal_rand(1.3, 1.6)
					mod_agility = 1
					mod_endurance = decimal_rand(2.0, 3)
					mod_force = 1
					mod_resistance = decimal_rand(1.0, 1.3)
					mod_offence = decimal_rand(1.0, 1.2)
					mod_defence = decimal_rand(1.1, 1.3)
					mod_regeneration = decimal_rand(1.0, 1.4)
					mod_recovery = 1
					mod_sense = 2
					mod_tech_potential = 1





				if("Spirit Doll")
					//src.strength = 200
					//src.endurance = 200
					src.final_powerlevel_mod = 2250000
					src.mod_psionic_power = decimal_rand(1.4, 1.6)
					src.psionic_power_base = ((src.age/src.mod_psionic_power) + random_mod_multiplier() + (src.final_powerlevel_mod * 0.0001)) * src.mod_psionic_power

					src.mod_rating = 1
					mod_energy = decimal_rand(1.5, 2)
					mod_strength = 1
					mod_agility = decimal_rand(1.2, 1.7)
					mod_endurance = 1
					mod_force = decimal_rand(1.4, 2.2)
					mod_resistance = decimal_rand(1.4, 2.2)
					mod_offence = decimal_rand(1.0, 1.25)
					mod_defence = decimal_rand(1.0, 1.25)
					mod_regeneration = decimal_rand(1.1, 1.4)
					mod_recovery = decimal_rand(1.0, 1.2)
					mod_sense = 2
					mod_tech_potential = 1





				if("Tuffle")
					//src.strength = 200
					//src.endurance = 200
					src.final_powerlevel_mod = 2250000
					src.mod_psionic_power = decimal_rand(1, 1.1)
					src.psionic_power_base = ((src.age/src.mod_psionic_power) + random_mod_multiplier() + (src.final_powerlevel_mod * 0.0001)) * src.mod_psionic_power



					src.mod_rating = 1
					mod_energy = decimal_rand(1.0, 1.3)
					mod_strength = 1
					mod_agility = 1
					mod_endurance = 1
					mod_force = 1
					mod_resistance = 1
					mod_offence = 1
					mod_defence = 1
					mod_regeneration = 1
					mod_recovery = 1
					mod_sense = 2
					mod_tech_potential = decimal_rand(3.4,3.6)


			if(src.psionic_power <=0) src.psionic_power = 1
			secure_og_mods(src)
			//world<<"Mods applied and secured: [src]"
			apply_points_to_mods(src)

		apply_points_to_mods(var/mob/m)
			set background = 1
			if(started) return
		//	world<<"Applying Points to Mods: [src] "
		//	world<<"Before Mods:\n Energy: [m.mod_energy]\nStr: [m.mod_strength]\nEnd [m.mod_endurance]\n For [m.mod_force]\n Res[m.mod_resistance]\n Off[m.mod_offence]\n Def[m.mod_defence]\n Reg[m.mod_regeneration]\n Rec[m.mod_recovery]\n Spd[m.mod_agility]"
			if(m.race != "Alien")
				//Positives
				if(m.mod_energy_points>0)
					var/multi = rand(20,30) / 100
					m.mod_energy += (m.mod_energy_points * multi)

				if(m.mod_strength_points>0)
					var/multi = rand(20,30) / 100
					m.mod_strength += (m.mod_strength_points*multi)

				if(m.mod_endurance_points>0)
					var/multi = rand(20,30) / 100
					m.mod_endurance += (m.mod_endurance_points*multi)

				if(m.mod_force_points>0)
					var/multi = rand(20,30) / 100
					m.mod_force += (m.mod_force_points*multi)

				if(m.mod_resistance_points>0)
					var/multi = rand(20,30) / 100
					m.mod_resistance += (m.mod_resistance_points*multi)

				if(m.mod_offence_points>0)
					var/multi = rand(20,30) / 100
					m.mod_offence += (m.mod_offence_points*multi)

				if(m.mod_defence_points>0)
					var/multi = rand(20,30) / 100
					m.mod_defence += (m.mod_defence_points*multi)

				if(m.mod_regeneration_points>0)
					var/multi = rand(20,30) / 100
					m.mod_regeneration += (m.mod_regeneration_points*multi)

				if(m.mod_recovery_points>0)
					var/multi = rand(20,30) / 100
					m.mod_recovery += (m.mod_recovery_points*multi)

				if(m.mod_agility_points>0)
					var/multi = rand(20,30) / 100
					m.mod_agility += (m.mod_agility_points*multi)

				// Negatives



				if(m.mod_energy_points<0)
					var/multi = rand(25,45) / 100
					m.mod_energy -= (m.mod_energy_points*multi)

				if(m.mod_strength_points<0)
					var/multi = rand(25,45) / 100
					m.mod_strength -= (m.mod_strength_points*multi)

				if(m.mod_endurance_points<0)
					var/multi = rand(25,45) / 100
					m.mod_endurance -= (m.mod_endurance_points*multi)

				if(m.mod_force_points<0)
					var/multi = rand(25,45) / 100
					m.mod_force -= (m.mod_force_points*multi)

				if(m.mod_resistance_points<0)
					var/multi = rand(25,45) / 100
					m.mod_resistance -= (m.mod_resistance_points*multi)

				if(m.mod_offence_points<0)
					var/multi = rand(25,45) / 100
					m.mod_offence -= (m.mod_offence_points*multi)

				if(m.mod_defence_points<0)
					var/multi = rand(25,45) / 100
					m.mod_defence -= (m.mod_defence_points*multi)
				if(m.mod_regeneration_points<0)
					var/multi = rand(25,45) / 100
					m.mod_regeneration -= (m.mod_regeneration_points*multi)
				if(m.mod_recovery_points<0)
					var/multi = rand(25,45) / 100
					m.mod_recovery -= (m.mod_recovery_points*multi)
				if(m.mod_agility_points<0)
					var/multi = rand(25,45) / 100
					m.mod_agility -= (m.mod_agility_points*multi)
			//	world<<"Applyied non-alien Mod Setup: [src]"

			else if(m.race == "Alien")

				if(m.mod_energy_points>0)
					var/multi = rand(5,20) / 100
					m.mod_energy += (m.mod_energy_points * multi)

				if(m.mod_strength_points>0)
					var/multi = rand(5,20) / 100
					m.mod_strength += (m.mod_strength_points*multi)

				if(m.mod_endurance_points>0)
					var/multi = rand(5,20) / 100
					m.mod_endurance += (m.mod_endurance_points*multi)

				if(m.mod_force_points>0)
					var/multi = rand(5,20) / 100
					m.mod_force += (m.mod_force_points*multi)

				if(m.mod_resistance_points>0)
					var/multi = rand(5,20) / 100
					m.mod_resistance += (m.mod_resistance_points*multi)

				if(m.mod_offence_points>0)
					var/multi = rand(5,20) / 100
					m.mod_offence += (m.mod_offence_points*multi)

				if(m.mod_defence_points>0)
					var/multi = rand(5,20) / 100
					m.mod_defence += (m.mod_defence_points*multi)

				if(m.mod_regeneration_points>0)
					var/multi = rand(5,20) / 100
					m.mod_regeneration += (m.mod_regeneration_points*multi)

				if(m.mod_recovery_points>0)
					var/multi = rand(5,20) / 100
					m.mod_recovery += (m.mod_recovery_points*multi)

				if(m.mod_agility_points>0)
					var/multi = rand(5,20) / 100
					m.mod_agility += (m.mod_agility_points*multi)

				// Negatives



				if(m.mod_energy_points<0)
					var/multi = rand(10,25) / 100
					m.mod_energy -= (m.mod_energy_points*multi)

				if(m.mod_strength_points<0)
					var/multi = rand(10,25) / 100
					m.mod_strength -= (m.mod_strength_points*multi)

				if(m.mod_endurance_points<0)
					var/multi = rand(10,25) / 100
					m.mod_endurance -= (m.mod_endurance_points*multi)

				if(m.mod_force_points<0)
					var/multi = rand(10,25) / 100
					m.mod_force -= (m.mod_force_points*multi)

				if(m.mod_resistance_points<0)
					var/multi = rand(10,25) / 100
					m.mod_resistance -= (m.mod_resistance_points*multi)

				if(m.mod_offence_points<0)
					var/multi = rand(10,25) / 100
					m.mod_offence -= (m.mod_offence_points*multi)

				if(m.mod_defence_points<0)
					var/multi = rand(10,25) / 100
					m.mod_defence -= (m.mod_defence_points*multi)
				if(m.mod_regeneration_points<0)
					var/multi = rand(10,25) / 100
					m.mod_regeneration -= (m.mod_regeneration_points*multi)
				if(m.mod_recovery_points<0)
					var/multi = rand(10,25) / 100
					m.mod_recovery -= (m.mod_recovery_points*multi)
				if(m.mod_agility_points<0)
					var/multi = rand(10,25) / 100
					m.mod_agility -= (m.mod_agility_points*multi)

			//	world<<"Applied Alien Setup: [src]"
			if(m.mod_energy<= 0.5) m.mod_energy = 0.5
			if(m.mod_agility<=0.75) m.mod_agility = 0.75
			if(m.mod_strength<= 0.5) m.mod_strength =  0.5
			if(m.mod_endurance<= 0.5) m.mod_endurance = 0.5
			if(m.mod_offence<= 0.5) m.mod_offence = 0.5
			if(m.mod_defence<= 0.5) m.mod_defence = 0.5
			if(m.mod_resistance<= 0.5) m.mod_resistance = 0.5
			if(m.mod_force<= 0.5) m.mod_force = 0.5
			if(m.mod_regeneration<= 0.5) m.mod_regeneration = 0.5
			if(m.mod_recovery<= 0.5) m.mod_recovery = 0.5
			//world<<"After Mods:\n Energy: [m.mod_energy]\nStr: [m.mod_strength]\nEnd [m.mod_endurance]\n For [m.mod_force]\n Res[m.mod_resistance]\n Off[m.mod_offence]\n Def[m.mod_defence]\n Reg[m.mod_regeneration]\n Rec[m.mod_recovery]\n Spd[m.mod_agility]"


		alive_drainer(var/drain,var/mob/tar)
			spawn(10)
				if(tar)
					while(tar.online)
						if(tar.dead == 0)
							src.energy -= drain
							if(src.energy <=0 ) src.energy = 0
						else
							src.reprievee = null
							tar.repriever = null
							break


						sleep(30)
		alive_ticker(var/mob/tar)
			spawn(10)
				if(src)
					while(src.online ** src.repriever_timer)
						if(src.repriever_timer <= 3000)
							src.set_alert("You have 5 minutes left alive!",src.icon,src.icon_state)
							src.<<"You have 5 minutes left alive!"
						if(src.dead == 0)
							src.repriever_timer -= 1
							if(src.repriever_timer <=0 ) src.repriever_timer = 0
						else if(src.dead == 1)
							src.reprievee = null
							tar.repriever = null
							break
						else if(src.repriever_timer<=0)
							src.reprievee = null
							tar.repriever = null
							tar.reprievee_drain = null
							src.ReDie(tar)

						sleep(20)





		round_mods()
			if(src.mod_energy <=-0.1) src.mod_energy = 0.1
			if(src.mod_psionic_power <=-0.1) src.mod_psionic_power = 0.1
			if(src.mod_strength <=-0.1) src.mod_strength = 0.1
			if(src.mod_endurance <=-0.1) src.mod_endurance =0.1
			if(src.mod_agility <=-0.1) src.mod_agility = 0.1
			if(src.mod_resistance <=-0.1) src.mod_resistance = 0.1
			if(src.mod_offence <=-0.1) src.mod_offence = 0.1
			if(src.mod_defence <=-0.1) src.mod_defence = 0.1
			if(src.mod_regeneration <=-0.1) src.mod_regeneration = 0.1
			if(src.mod_recovery <=-0.1) src.mod_recovery = 0.1
			src.mod_psionic_power = round(src.mod_psionic_power,0.01)
			src.mod_energy = round(src.mod_energy,0.01)
			src.mod_strength = round(src.mod_strength,0.01)
			src.mod_agility = round(src.mod_agility,0.01)
			src.mod_endurance = round(src.mod_endurance,0.01)
			src.mod_force = round(src.mod_force,0.01)
			src.mod_resistance = round(src.mod_resistance,0.01)
			src.mod_offence = round(src.mod_offence,0.01)
			src.mod_defence = round(src.mod_defence,0.01)
			src.mod_regeneration = round(src.mod_regeneration,0.01)
			src.mod_recovery = round(src.mod_recovery,0.01)
			src.mod_gravity = round(src.mod_gravity,0.01)
		cancel_build()
			if(src.build_mouse && src.build_tech)
				src.client.images -= src.build_mouse
				src.build_mouse.loc = null
				src.build_mouse = null
				//del(src.build_mouse)
				src.build_tech = null
				if(src.hud_build) src.client.screen += src.hud_build
				//winshow(src,"build_open",1)
				return
		cancel_tech()
			if(src.build_mouse && src.build_tech)
				src.client.images -= src.build_mouse
				src.build_mouse.loc = null
				src.build_mouse = null
				//del(src.build_mouse)
				src.build_tech = null
				//winshow(src,"tech_panes",1)
				if(src.hud_tech) src.client.screen += src.hud_tech
				for(var/obj/t in global.tech)//src.technology_researched)
					src.client.images -= t.img_select
				return
		astral_ripple()
			var/start = src.filters.len
			var/i,f
			for(i=1, i<=WAVE_COUNT, ++i)
				src.filters += filter(type="wave", x=15, y=15, size=1, offset=1)
			for(i=1, i<=WAVE_COUNT, ++i)
				// animate phase of each wave from its original phase to phase-1 and then reset;
				// this moves the wave forward in the X,Y direction
				f = src.filters[start+i]
				animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
				animate(offset=f:offset-1, time=20)
		cloning()
			spawn(600)
				if(src)
					//src.being_cloned = 0;
					if(src.stunned > 0)
						src.stunned -= 1;
						src.stunned_pending -= 1
		cancel_eat()
			src.eating = null
			src.icon_state = src.state()
			if(src.hud_eat)
				src.stunned -= 1
				src.stunned_pending -= 1
				src.hud_eat.flash_red()
				src.hud_eat.shake()
				//flick("cancel",src.hud_eat)
				spawn(2)
					if(src && src.hud_eat && src.eating == null) src.vis_contents -= src.hud_eat
		eat()
			//src.dir = SOUTH
			src.stunned += 1
			src.stunned_pending += 1
			if(src.hud_eat)
				src.vis_contents += src.hud_eat
				flick("eat",src.hud_eat)
			if(src.skill_flight && src.skill_flight.active || src.submerged) src.icon_state = "fly eat"
			else if(src.skill_levitation && src.skill_levitation.active || src.submerged) src.icon_state = "fly eat"
			else src.icon_state = "eat"
				/*
				spawn(global.eat_time)
					if(src && src.eating)
						src.icon_state = src.state()
						if(src.hud_eat)
							src.vis_contents -= src.hud_eat
							src.stunned -= 1
							src.stunned_pending -= 1
				*/
		/*show_worldtree(var/show = 1,var/overide = 0)
			if(world_tree)
				if(src.z == 4 || overide == 1)
					if(show)
						var/obj/items/tech/world_tree/wt = world_tree
						if(src.client && wt)
							if(wt.wt_trunk) src.client.images += wt.wt_trunk
							if(wt.wt_top) src.client.images += wt.wt_top
							for(var/image/i in wt.wt_rays)
								src.client.images += i
					else
						var/obj/items/tech/world_tree/wt = world_tree
						if(src.client && wt)
							if(wt.wt_trunk) src.client.images -= wt.wt_trunk
							if(wt.wt_top) src.client.images -= wt.wt_top
							for(var/image/i in wt.wt_rays)
								src.client.images -= i
								*/
		open_close_eyes(var/close = 1)
			if(close)
				//Close players eyes, if they have any.
				if(src.port)
					if(src.race == "Alien") src.port.icon_state = "skin1 blink"
					if(src.port.port_iris) src.port.vis_contents -= src.port.port_iris
					if(src.port.port_eyes)
						var/obj/portrait/p = src.port
						if(p.port_eyes.state_og == null && p.port_eyes.icon) p.port_eyes.state_og = p.port_eyes.icon_state
						p.port_eyes.icon_state = "[p.port_eyes.state_og] blink"
				if(src.eyes) src.vis_contents -= src.eyes
				if(src.eyes_white) src.vis_contents -= src.eyes_white
			else
				//Open players eyes, if they have any.
				if(src.port)
					var/obj/portrait/p = src.port
					if(src.race == "Alien") src.port.icon_state = "skin1"
					if(p.port_eyes) p.port_eyes.icon_state = "[p.port_eyes.state_og]"
					if(p.port_iris) p.vis_contents += p.port_iris
				if(src.eyes) src.vis_contents += src.eyes
				if(src.eyes_white) src.vis_contents += src.eyes_white
		/*place_percise(var/params)

			if(!src || !src.client) return
			if(!src.loc) return

			if(!params) return

			var/list/p = params2list(params)
			if(!p || !p["screen-loc"]) return

			var/screen_loc = p["screen-loc"]

			var/comma = findtext(screen_loc, ",")
			if(!comma) return

			var/screen_x = copytext(screen_loc, 1, comma)
			var/screen_y = copytext(screen_loc, comma + 1)

			var/colon_x = findtext(screen_x, ":")
			var/colon_y = findtext(screen_y, ":")

			if(!colon_x || !colon_y) return

			var/xx = text2num(copytext(screen_x, 1, colon_x))
			var/yy = text2num(copytext(screen_y, 1, colon_y))

			src.new_x = src.x - (16 - xx)
			src.new_y = src.y - (9 - yy)

			src.client.client_mouse_screen_x = xx
			src.client.client_mouse_screen_y = yy
			*/
		place_percise(var/params)
			if(!src || !src.client) return
			if(!src.loc) return
			var screen_loc = params2list(params)["screen-loc"]
			var position = 1
			var colons = 0
			var first_colon
			for(var/_ in 1 to 3)
				var colon = findtext(screen_loc, ":", position)
				if(colon)
					if(!first_colon) first_colon = colon
					position = colon + 1
					colons ++
				else break
			if(colons > 2) screen_loc = copytext(screen_loc, first_colon + 1)
			//  We split "x:px,y:py" into "x:px" and "y:py".
			var comma = findtext(screen_loc, ",")
			var screen_x = copytext(screen_loc, 1, comma)
			var screen_y = copytext(screen_loc, comma + 1)
			//  Split "x:px" into x and px.
			var colon_x = findtext(screen_x, ":")
			var xx = text2num(copytext(screen_x, 1, colon_x))
			//var px = text2num(copytext(screen_x, colon_x + 1))
			//  Split "y:py" into y and py.
			var colon_y = findtext(screen_y, ":")
			var yy = text2num(copytext(screen_y, 1, colon_y))
			//var py = text2num(copytext(screen_y, colon_y + 1))
			src.new_x = src.x-(16-xx)
			src.new_y = src.y-(9-yy)
			if(src)src.client.client_mouse_screen_x = xx
			if(src)src.client.client_mouse_screen_y = yy
		/// Attempts to maim a limb, based on damage state, attacker strength, and RNG.


		toggle_skill(var/obj/o)
			for(var/obj/skills/s in src)
				if(s.disabled_switch && s != o)
					if(s.active)
						src.mouse_dir = "left"
						s.Click()
						s.active = 0
						src.mouse_dir = null
						//world << "DEBUG - Toggled [s] off"
		stun_cd(var/time)
			if(time)
				spawn(time)
					if(src)
						src.stunned -= 1
						src.stunned_pending -= 1
						src.overlays -= 'fx_stun.dmi'
		refresh_shop()
			if(src.accessing)
				var/mob/owner = src.accessing
				if(owner != src)
					for(var/sl=1, sl<49, sl++)
						if(src.shop[sl] != null)
							src.hud_invshop.vis_contents -= src.shop[sl]
				if(src.hud_invshop.title) src.hud_invshop.title.maptext = "[css_outline]<font size = 1><text align=left valign=top>[owner]'s Inventory"
				if(src.hud_invshop.rsc) src.hud_invshop.update_rsc(src)
				var/n_x = -2
				var/n_y = 0
				var/xx = 0
				var/yy = 0
				for(var/sl=1, sl<49, sl++)
					if(n_x >= 4)
						n_x = -2
						n_y += 1
						//world << "reset x - [n_x]"
					if(n_y >= 8)
						n_y = 0
						//world << "reset x - [n_x]"
					n_x += 1
					if(owner.shop[sl] != null)
						xx = sl%6
						if(xx == 0 && sl > 0) xx = 6
						//world << "xx = [xx]"
						yy = ((sl-xx)+6)/6
						//world << "yy = [yy]"
						var/matrix/m = matrix()
						m.Translate((xx*32-21)+n_x,(288-yy*32)-n_y)
						owner.shop[sl].transform = m
						//src.inv[sl].vis_flags = VIS_INHERIT_PLANE | VIS_INHERIT_LAYER
						src.hud_invshop.vis_contents -= shop[sl]
						src.hud_invshop.vis_contents += shop[sl]
						if(owner != src && owner.hud_invshop)
							owner.hud_invshop.vis_contents -= shop[sl]
							owner.hud_invshop.vis_contents += shop[sl]
						//world << "item = [inv[sl]]"
						var/obj/I = shop[sl]
						if(I.stack_display == null) shop[sl].create_stack_display()
						if(I.stack_exempt == 0)
							src.client.images += shop[sl].stack_display
							if(owner != src && owner.client) owner.client.images += shop[sl].stack_display
						if(owner != src)
							if(istype(I,/obj/items/tech) && I == owner.item_selected && owner.hud_invshop && src.intxp>=I.tech_lvl) owner.hud_invshop.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality: [I.tech_lvl]%\n[I.desc_extra][I.desc]"
							else if(istype(I,/obj/items/tech) && I == owner.item_selected && owner.hud_invshop && src.intxp<I.tech_lvl) owner.hud_invshop.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality: Unknown\n[I.desc_extra][I.desc]"
							else if(I == owner.item_selected && owner.hud_invshop) owner.hud_invshop.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality:[I.tech_lvl]%\n[I.desc_extra][I.desc]"
							else src.hud_invshop.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality: [I.tech_lvl]%\n[I.desc_extra][I.desc]"
						else
							if(istype(I,/obj/items/tech) && I == src.item_selected && src.intxp>=I.tech_lvl) src.hud_invshop.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality: [I.tech_lvl]%\n[I.desc_extra][I.desc]"
							else if(istype(I,/obj/items/tech) && I == src.item_selected && src.intxp<I.tech_lvl) src.hud_invshop.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality: Unknown\n[I.desc_extra][I.desc]"
							else if(I == src.item_selected) src.hud_invshop.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality: [I.tech_lvl]%\n[I.desc_extra][I.desc]"
						/*
						inv.xx += 33
						N += 1
						if(N >= 6)
							N = 0
							inv.xx = 10
							inv.yy -= 33
						return
						*/

		refresh_inv()
			if(!src.hud_inv) return

			var/mob/owner = src.accessing ? src.accessing : src

			// 1️⃣ HARD CLEAR VISUALS FIRST
			//src.hud_inv.vis_contents.Cut()
			if(src.client)
				src.client.images.Cut()

			// 2️⃣ Clear selection if invalid
			if(src.item_selected && src.item_selected.loc != owner)
				src.item_selected = null

			if(src.hud_inv.item_desc)
				src.hud_inv.item_desc.maptext = null
			if(owner != src)
				for(var/sl=1, sl<49, sl++)
					if(src.inv[sl] != null)
						src.hud_inv.vis_contents -= src.inv[sl]
			// 3️⃣ Rebuild inventory grid cleanly
			if(src.hud_inv.title) src.hud_inv.title.maptext = "[css_outline]<font size = 1><text align=left valign=top>[owner]'s Inventory"
			if(src.hud_inv.rsc) src.hud_inv.update_rsc(src)
			// ---- UPDATE MINERAL COUNTS ----
			for(var/obj/O in src.hud_inv.vis_contents)

				if(O.tag == "stone_num")
					O.maptext = "[css_outline]<font size=1>[src.stone_count]"

				else if(O.tag == "silver_num")
					O.maptext = "[css_outline]<font size=1>[src.silver_count]"

				else if(O.tag == "copper_num")
					O.maptext = "[css_outline]<font size=1>[src.copper_count]"

				else if(O.tag == "coal_num")
					O.maptext = "[css_outline]<font size=1>[src.coal_count]"

				else if(O.tag == "gold_num")
					O.maptext = "[css_outline]<font size=1>[src.gold_count]"

				else if(O.tag == "myst_num")
					O.maptext = "[css_outline]<font size=1>[src.mystille_count]"

				else if(O.tag == "titanium_num")
					O.maptext = "[css_outline]<font size=1>[src.titanium_count]"

			var/n_x = -2
			var/n_y = 0
			var/xx = 0
			var/yy = 0
			for(var/sl=1, sl<49, sl++)
				if(n_x >= 4)
					n_x = -2
					n_y += 1
					//world << "reset x - [n_x]"
				if(n_y >= 8)
					n_y = 0
					//world << "reset x - [n_x]"
				n_x += 1
				if(owner.inv[sl] != null)
					xx = sl%6
					if(xx == 0 && sl > 0) xx = 6
					//world << "xx = [xx]"
					yy = ((sl-xx)+6)/6
					//world << "yy = [yy]"
					var/matrix/m = matrix()
					m.Translate((xx*32-21)+n_x,(288-yy*32)-n_y)
					owner.inv[sl].transform = m
					//src.inv[sl].vis_flags = VIS_INHERIT_PLANE | VIS_INHERIT_LAYER
					src.hud_inv.vis_contents -= inv[sl]
					src.hud_inv.vis_contents += inv[sl]
					if(owner != src && owner.hud_inv)
						owner.hud_inv.vis_contents -= inv[sl]
						owner.hud_inv.vis_contents += inv[sl]
					//world << "item = [inv[sl]]"
					var/obj/I = inv[sl]
					if(I.stack_display == null) inv[sl].create_stack_display()
					if(I.stack_exempt == 0)
						src.client.images += inv[sl].stack_display
						if(owner != src && owner.client) owner.client.images += inv[sl].stack_display
					if(owner != src)
						if(istype(I,/obj/items/tech) && I == owner.item_selected && owner.hud_inv && src.intxp>=I.tech_lvl) owner.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality: [I.tech_lvl]%\n[I.desc_extra][I.desc]"
						else if(istype(I,/obj/items/tech) && I == owner.item_selected && owner.hud_inv && src.intxp<I.tech_lvl) owner.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality: Unknown\n[I.desc_extra][I.desc]"
						else if(I == owner.item_selected && owner.hud_inv) owner.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality:[I.tech_lvl]%\n[I.desc_extra][I.desc]"
						else src.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality: [I.tech_lvl]%\n[I.desc_extra][I.desc]"
					else
						if(istype(I,/obj/items/tech) && I == src.item_selected && src.intxp>=I.tech_lvl) src.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality: [I.tech_lvl]%\n[I.desc_extra][I.desc]"
						else if(istype(I,/obj/items/tech) && I == src.item_selected && src.intxp<I.tech_lvl) src.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality: Unknown\n[I.desc_extra][I.desc]"
						else if(I == src.item_selected) src.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality: [I.tech_lvl]%\n[I.desc_extra][I.desc]"

		/*refresh_inv()
			if(src.accessing || src.hud_inv)
				var/mob/owner = src.accessing
				if(owner != src)
					for(var/sl=1, sl<49, sl++)
						if(src.inv[sl] != null)
							src.hud_inv.vis_contents -= src.inv[sl]
				if(src.hud_inv.title) src.hud_inv.title.maptext = "[css_outline]<font size = 1><text align=left valign=top>[owner]'s Inventory"
				if(src.hud_inv.rsc) src.hud_inv.update_rsc(src)
				var/n_x = -2
				var/n_y = 0
				var/xx = 0
				var/yy = 0
				for(var/sl=1, sl<49, sl++)
					if(n_x >= 4)
						n_x = -2
						n_y += 1
						//world << "reset x - [n_x]"
					if(n_y >= 8)
						n_y = 0
						//world << "reset x - [n_x]"
					n_x += 1
					if(owner.inv[sl] != null)
						xx = sl%6
						if(xx == 0 && sl > 0) xx = 6
						//world << "xx = [xx]"
						yy = ((sl-xx)+6)/6
						//world << "yy = [yy]"
						var/matrix/m = matrix()
						m.Translate((xx*32-21)+n_x,(288-yy*32)-n_y)
						owner.inv[sl].transform = m
						//src.inv[sl].vis_flags = VIS_INHERIT_PLANE | VIS_INHERIT_LAYER
						src.hud_inv.vis_contents -= inv[sl]
						src.hud_inv.vis_contents += inv[sl]
						if(owner != src && owner.hud_inv)
							owner.hud_inv.vis_contents -= inv[sl]
							owner.hud_inv.vis_contents += inv[sl]
						//world << "item = [inv[sl]]"
						var/obj/I = inv[sl]
						if(I.stack_display == null) inv[sl].create_stack_display()
						if(I.stack_exempt == 0)
							src.client.images += inv[sl].stack_display
							if(owner != src && owner.client) owner.client.images += inv[sl].stack_display
						if(owner != src)
							if(istype(I,/obj/items/tech) && I == owner.item_selected && owner.hud_inv && src.intxp>=I.tech_lvl) owner.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality: [I.tech_lvl]%\n[I.desc_extra][I.desc]"
							else if(istype(I,/obj/items/tech) && I == owner.item_selected && owner.hud_inv && src.intxp<I.tech_lvl) owner.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality: Unknown\n[I.desc_extra][I.desc]"
							else if(I == owner.item_selected && owner.hud_inv) owner.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality:[I.tech_lvl]%\n[I.desc_extra][I.desc]"
							else src.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality: [I.tech_lvl]%\n[I.desc_extra][I.desc]"
						else
							if(istype(I,/obj/items/tech) && I == src.item_selected && src.intxp>=I.tech_lvl) src.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality: [I.tech_lvl]%\n[I.desc_extra][I.desc]"
							else if(istype(I,/obj/items/tech) && I == src.item_selected && src.intxp<I.tech_lvl) src.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality: Unknown\n[I.desc_extra][I.desc]"
							else if(I == src.item_selected) src.hud_inv.item_desc.maptext = "[css_outline]<font size = 1><text align=center valign=top>[I.name]<text align=left valign=top>\n\nRarity: [global.rarity_color[I.rarity]]\n\nQuality: [I.tech_lvl]%\n[I.desc_extra][I.desc]"
						*/


						/*
						inv.xx += 33
						N += 1
						if(N >= 6)
							N = 0
							inv.xx = 10
							inv.yy -= 33
						return
						*/
				/*
				if(src.client) winset(src,"inven.label_inven","text=\"[src.accessing]'s inventory\"")
				src << output(null,"inven.grid_inven")
				var/count = 0
				for(var/obj/O in src.accessing)
					if(istype(O,/obj/items/) == 1 || istype(O,/obj/body_related/bodyparts/cybernetics/) == 1) src << output(O,"inven.grid_inven:[++count]")
				if(src.client) winset(src, "inven.grid_inven", "cells=\"[count]\"")
				*/
		refresh_skills_tab(var/t)
			//Clear grid first
			winset(src, "skills.grid_skills", "cells=0")
			src << output(null,"skills.grid_skills")
			//Then continue
			winset(src,null,"skills.button_all.is-flat = false;skills.button_power.is-flat = false;skills.button_energy.is-flat = false;skills.button_strength.is-flat = false;skills.button_endurance.is-flat = false;skills.button_force.is-flat = false;skills.button_resistance.is-flat = false;skills.button_agility.is-flat = false;skills.button_offence.is-flat = false;skills.button_defence.is-flat = false;skills.button_regen.is-flat = false;skills.button_recovery.is-flat = false;skills.button_utility.is-flat = false;skills.button_buffs.is-flat = false")
			//winset(src,"skills.button_all","is-flat = false")
			//winset(src,"skills.button_power","is-flat = false")
			//winset(src,"skills.button_energy","is-flat = false")
			//winset(src,"skills.button_strength","is-flat = false")
			//winset(src,"skills.button_endurance","is-flat = false")
			//winset(src,"skills.button_force","is-flat = false")
			//winset(src,"skills.button_resistance","is-flat = false")
			//winset(src,"skills.button_agility","is-flat = false")
			//winset(src,"skills.button_offence","is-flat = false")
			//winset(src,"skills.button_defence","is-flat = false")
			//winset(src,"skills.button_regen","is-flat = false")
			//winset(src,"skills.button_recovery","is-flat = false")
			//winset(src,"skills.button_utility","is-flat = false")
			//winset(src,"skills.button_buffs","is-flat = false")
			var/count = 0
			if(t == "All")
				winset(src,"skills.button_all","is-flat = true")
				for(var/obj/skills/o in src)
					src << output(o,"skills.grid_skills:[++count]")
				for(var/obj/stances/o in src)
					src << output(o,"skills.grid_skills:[++count]")
			if(t == "Energy")
				winset(src,"skills.button_energy","is-flat = true")
				for(var/obj/skills/o in src)
					if(!o.category) o.category = list()
					if(o.category.Find("Energy"))
						src << output(o,"skills.grid_skills:[++count]")
			if(t == "Strength")
				winset(src,"skills.button_strength","is-flat = true")
				for(var/obj/skills/o in src)
					if(!o.category) o.category = list()
					if(o.category.Find("Strength"))
						src << output(o,"skills.grid_skills:[++count]")
			if(t == "Endurance")
				winset(src,"skills.button_endurance","is-flat = true")
				for(var/obj/skills/o in src)
					if(!o.category) o.category = list()
					if(o.category.Find("Endurance"))
						src << output(o,"skills.grid_skills:[++count]")
			if(t == "Force")
				winset(src,"skills.button_force","is-flat = true")
				for(var/obj/skills/o in src)
					if(!o.category) o.category = list()
					if(o.category.Find("Force"))
						src << output(o,"skills.grid_skills:[++count]")
			if(t == "resistance")
				winset(src,"skills.button_resistance","is-flat = true")
				for(var/obj/skills/o in src)
					if(!o.category) o.category = list()
					if(o.category.Find("resistance"))
						src << output(o,"skills.grid_skills:[++count]")
			if(t == "Offence")
				winset(src,"skills.button_offence","is-flat = true")
				for(var/obj/skills/o in src)
					if(!o.category) o.category = list()
					if(o.category.Find("Offence"))
						src << output(o,"skills.grid_skills:[++count]")
			if(t == "Defence")
				winset(src,"skills.button_defence","is-flat = true")
				for(var/obj/skills/o in src)
					if(!o.category) o.category = list()
					if(o.category.Find("Defence"))
						src << output(o,"skills.grid_skills:[++count]")
			if(t == "Regen")
				winset(src,"skills.button_regen","is-flat = true")
				for(var/obj/skills/o in src)
					if(!o.category) o.category = list()
					if(o.category.Find("Regeneration"))
						src << output(o,"skills.grid_skills:[++count]")
			if(t == "Physical")
				winset(src,"skills.button_recovery","is-flat = true")
				for(var/obj/skills/o in src)
					if(!o.category) o.category = list()
					if(o.category.Find("Physical"))
						src << output(o,"skills.grid_skills:[++count]")
			if(t == "Agility")
				winset(src,"skills.button_agility","is-flat = true")
				for(var/obj/skills/o in src)
					if(!o.category) o.category = list()
					if(o.category.Find("Agility"))
						src << output(o,"skills.grid_skills:[++count]")
			if(t == "Technology")
				winset(src,"skills.button_power","is-flat = true")
				for(var/obj/skills/o in src)
					if(!o.category) o.category = list()
					if(o.category.Find("Technology"))
						src << output(o,"skills.grid_skills:[++count]")
			if(t == "Buff")
				winset(src,"skills.button_buffs","is-flat = true")
				for(var/obj/skills/o in src)
					if(!o.category) o.category = list()
					if(o.category.Find("Buff"))
						src << output(o,"skills.grid_skills:[++count]")
			if(t == "Utility")
				winset(src,"skills.button_utility","is-flat = true")
				for(var/obj/skills/o in src)
					if(!o.category) o.category = list()
					if(o.category.Find("Utility"))
						src << output(o,"skills.grid_skills:[++count]")
			winset(src, "skills.grid_skills", "cells=\"[count]\"")
		disable_skills()
			set background = 1
			if(!src) return
			if(!src.client) return
			for(var/obj/skills/s in src)
				if(!istype(s,/obj/skills/Majin))
					if(istype(s,/obj/skills/Attack))

						s.active = 0
						s.icon_state = "Attack off"
					if(istype(s,/obj/skills/Dig))
						s.active = 0
						s.icon_state = "Explosion off"
					//spawn call(s, s.act)(src,s)
					//s.active = 0

					if(s.active && s.act)
						spawn call(s, s.act)(src,s)
		disable_stances(var/obj/st,var/all)
			set background = 1
			if(all)
				for(var/obj/stances/s in src)
					if(s.active && s.act)
						call(s.act)(src,s)
			else
				for(var/obj/stances/s in src)
					if(s.active && s.act && s != st)
						call(s.act)(src,s)
		fps_display()
			set waitfor = 0
			var/obj/ticks = new
			ticks.maptext = "tick usage = [world.tick_usage]"
			ticks.maptext_height = 128
			ticks.maptext_width  = 128
			ticks.screen_loc = "1,1:500"
			src.client.screen += ticks
			var/obj/cpu = new
			cpu.maptext = "cpu usage = [world.cpu]"
			cpu.maptext_height = 128
			cpu.maptext_width  = 128
			cpu.screen_loc = "1,1:468"
			src.client.screen += cpu
			var/obj/fps = new
			fps.maptext = "fps = [client.fps]"
			fps.maptext_height = 128
			fps.maptext_width  = 128
			fps.screen_loc = "1,1:436"
			src.client.screen += fps
			while(1)
				ticks.maptext = "tick usage = [world.tick_usage]"
				cpu.maptext = "cpu usage = [world.cpu]"
				fps.maptext = "fps = [client.fps]"
				sleep(0.1)
		clear_minigame_tk()
			return
			/*
			src.minigame = null
			for(var/obj/skills/Ranged/Telekinesis/T in src)
				T.spin_speed = 4
				src.tk_multiplier = 1
				T.tk_pointer.spin_speed = 1
				T.tk_range.icon_state = "0"
				T.tk_pointer.bar_passes = 0
				for(var/obj/hud/h in T)
					src.client.screen -= h
					h.spin_speed = 0.7
				for(var/obj/I in src.tk_minigame)
					src.tk_minigame -= I
					I.pos = null
					I.tk = 0
					I.density_factor = initial(I.density_factor)
					animate(I, pixel_z = initial(I.pixel_z), time = 2, easing = BOUNCE_EASING)
					sleep(3)
					animate(I, pixel_x = initial(I.pixel_x),pixel_y = initial(I.pixel_y), time = 10)
					if(istype(I,/obj/items/tech/Battery))
						var/obj/items/tech/Battery/b = I
						b.check_power_lines("battery movement")
			*/
		create_map_box(var/params,var/obj/i)

			if(src.mouse_txt == null)
				var/obj/txt = new
				src.mouse_txt = txt
				txt.maptext_height = 64
				txt.maptext_width = 128
				txt.maptext_y = -53
				txt.maptext_x = -23
				txt.mouse_opacity = 0
				txt.appearance_flags = TILE_BOUND
				txt.layer = 50
				//txt.appearance_flags = KEEP_TOGETHER
				var/obj/o = new
				o.icon = 'mouse_box.dmi'
				o.pixel_y = -34
				o.pixel_x = 6
				o.layer = 49
				txt.underlays += o
				txt.filters = filter(type="outline", size=1, color=rgb(0,0,0))
				//txt.alpha = 225
			src.mouse_txt.maptext = "<text align=center valign=middle><font size = 1>[i.name]"
			src.mouse_txt.screen_loc = src.client.client_mouse_screen_loc
			src.client.screen += src.mouse_txt
		clear_states()
			//src.states -= "teleporting"
			//src.states -= "lifting"
		del_elec(var/time)
			spawn(time)
				if(src) src.overlays -= /obj/effects/elec


		/*
		create_research()
			var/list/tech_creation = typesof(/obj/items/tech/)
			tech_creation -= /obj/items/tech
			tech_creation -= /obj/items/tech/Ship
			tech_creation -= /obj/items/tech/Conveyor_Belt
			tech_creation -= /obj/items/tech/Resource_Cache
			tech_creation -= /obj/items/tech/Container_Tech
			tech_creation -= /obj/items/tech/Robot_Factory
			tech_creation -= /obj/items/tech/Silo
			tech_creation -= /obj/items/tech/world_tree
			tech_creation -= /obj/items/tech/sub_tech
			for(var/x in tech_creation)
				var/obj/items/tech/I = new x()
				src.technology += I
		*/
		output_msg(var/t)
			src << output("[t].", "chat.world")
			src << output("[t].", "chat.local")
			src << output("[t].", "chat.system")
		redraw_appearance()
			src.overlays = null
			if(src.hair) src.overlays += src.hair
			if(src.horns) src.overlays += src.horns
			if(src.halo) src.overlays += src.halo
			//if(src.divine_elec) src.overlays += src.divine_elec
			//if(src.skill_focus && src.skill_focus.active) src.overlays += /obj/effects/elec
			for(var/obj/items/i in src)
				if(i.suffix == "worn")
					var/matrix/m = i.transform
					i.transform = null
					src.overlays += i
					i.transform = m
				if(i.suffix == "equipped")
					if(src.skill_dig && src.skill_dig.active)
						if(i.type == /obj/items/tech/digging/Shovel) src.overlays += 'spade_dig.dmi'
						else if(i.type == /obj/items/tech/digging/Drill) src.overlays += 'drill_dig.dmi'
		remove(var/obj/i,var/amount)
			if(src.accessing == null) src.accessing = src
			var/mob/x = src.accessing
			for(var/sl=1, sl<49, sl++)
				if(x.inv[sl] == i)
					if(i.stacks <=1)
						x.inv[sl] = null
						i.slot = -1
						break
			if(i.stacks <=1)
				if(i == x.eating) x.cancel_eat()
				i.transform = null
				i.vis_contents -= global.inv_slot
				i.loc = x.loc
				i.step_x = x.step_x
				i.step_y = x.step_y
				x.overlays -= i
				x.underlays -= i
				i.underlays = null
				i.layer = initial(i.layer)
				if(src.client)
					src.client.screen -= i
					src.client.images -= i.stack_display
					if(src.hud_inv) src.hud_inv.vis_contents -= i
					if(i == src.item_selected)
						src.item_selected = null
						src.hud_inv.item_desc.maptext = null
					if(i == src.mouse_down) src.mouse_down = null
					if(i == src.mouse_over) src.mouse_over = null
					src.refresh_inv()
				if(x.client && x != src)
					x.client.screen -= i
					x.client.images -= i.stack_display
					if(x.hud_inv) x.hud_inv.vis_contents -= i
					if(i == x.item_selected)
						x.item_selected = null
						x.hud_inv.item_desc.maptext = null
					if(i == x.mouse_down) x.mouse_down = null
					if(i == x.mouse_over) x.mouse_over = null
					x.refresh_inv()
			else
				if(i == x.eating) x.cancel_eat()
				i.stacks -= amount
				if(src.client)
					if(i == src.mouse_down) src.mouse_down = null
					if(i == src.mouse_over) src.mouse_over = null
					src.refresh_inv()
				if(x.client && x != src)
					if(i == x.mouse_down) x.mouse_down = null
					if(i == x.mouse_over) x.mouse_over = null
					x.refresh_inv()
			i.overlays -= /obj/effects/select_item
		drop(var/obj/i,var/dying=0)
			if(!i || !istype(i)) return

			if(!src.accessing) src.accessing = src
			var/mob/x = src.accessing

			if(i == x.eating) x.cancel_eat()

			var newamount = 1

			if(i.stacks >= 2 && dying == 0)
				var/amount = input("How many [i.name] do you want to drop?") as num
				if(amount < 1) return
				if(amount > i.stacks) amount = i.stacks
				newamount = amount
			else if(i.stacks >=2 && dying == 1)
				fully_drop_item(i, x, src)

			if(i.stacks > 1)
				if(newamount < i.stacks)
					// Create a new item on the ground with the dropped amount
					//var/obj/ii = new i.type(x.loc)
					var/obj/ii
					if(istype(i,/obj/items/consumables/seeds))
						ii = new i.type(1,i,x.loc)
					else //ii.name = "[i.name]"
						ii = new i.type(x.loc)

					i.stacks -= newamount
					ii.stacks = newamount

					ii.loc = x.loc
					ii.step_x = x.step_x
					ii.step_y = x.step_y
					ii.layer = 3
					//ii.set_shadow()
					if(ii.floor_state) ii.icon_state = ii.floor_state

					// Update maptext
					i.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[i.stacks]"

					i.handle_inventory_stacking(i, src)

					// Refresh both player's HUDs (src and x if different)
					refresh_hud(i, src)
					if(x != src) refresh_hud(i, x)
				else if(newamount>= i.stacks)
					// Dropping the full stack
					fully_drop_item(i, x, src)
			else
				// Not a stackable or is already at 1
				fully_drop_item(i, x, src)
		refresh_hud(var/obj/i, var/mob/user)
			if(!user.client) return

			user.client.screen -= i
			user.client.images -= i.stack_display
			if(user.hud_inv) user.hud_inv.vis_contents -= i

			if(i == user.item_selected)
				user.item_selected = null
				user.hud_inv.item_desc.maptext = null

			if(i == user.mouse_down) user.mouse_down = null
			if(i == user.mouse_over) user.mouse_over = null

			user.refresh_inv()

		fully_drop_item(var/obj/i, var/mob/x, var/mob/src)
			for(var/sl = 1; sl < 49; sl++)
				if(x.inv[sl] == i)
					x.inv[sl] = null
					break

			i.slot = -1
			i.loc = x.loc
			i.step_x = x.step_x
			i.step_y = x.step_y
			i.transform = null
			i.vis_contents -= global.inv_slot
			i.underlays = null
			i.layer = initial(i.layer)
		//	i.set_shadow()
			if(i.floor_state) i.icon_state = i.floor_state
			i.handle_inventory_stacking(i, src)

			i.overlays -= /obj/effects/select_item

			// Remove from both players’ HUD and visuals
			refresh_hud(i, src)
			if(x != src) refresh_hud(i, x)

		/* drop(var/obj/i) // OG DROP
			if(src.accessing == null) src.accessing = src
			var/mob/x = src.accessing
			var/newamount=1

			if(i == x.eating) x.cancel_eat()
			if(i.stacks>=2)
				var/amount=input("How much [i] are you dropping?") as num
				if(amount<=0) return
				if(amount>i.stacks)
					src.set_alert("You do not have that amount.",'alert.dmi',"alert")
					return
				newamount = amount
			if(i.stacks !=1)
				if(newamount<=i.stacks)
					var/obj/ii = new i.type (x.loc)
					i.stacks -= newamount
					ii.loc = x.loc
					ii.step_x = x.step_x
					ii.step_y = x.step_y
					ii.underlays = null
					ii.layer = 3
					ii.stacks = newamount
					i.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[i.stacks]"
					i.handle_inventory_stacking(i, src)
					if(src.client)
						if(i.stacks <=0)
							src.client.screen -= i
							src.client.images -= i.stack_display
							if(src.hud_inv) src.hud_inv.vis_contents -= i
							x.overlays -= i
							x.underlays -= i
						if(i == src.item_selected)
							src.item_selected = null
							src.hud_inv.item_desc.maptext = null
						if(i == src.mouse_down) src.mouse_down = null
						if(i == src.mouse_over) src.mouse_over = null
						src.refresh_inv()
					if(x.client && x != src)
						if(i.stacks <=0)
							x.client.screen -= i
							x.client.images -= i.stack_display
							if(x.hud_inv) x.hud_inv.vis_contents -= i
							x.overlays -= i
							x.underlays -= i
						if(i == x.item_selected)
							x.item_selected = null
							x.hud_inv.item_desc.maptext = null
						if(i == x.mouse_down) x.mouse_down = null
						if(i == x.mouse_over) x.mouse_over = null
						x.refresh_inv()
					i.overlays -= /obj/effects/select_item
					ii.set_shadow()
					if(ii.floor_state) ii.icon_state = ii.floor_state

				else
					src<<"You don't have that amount."
					return

			else if(newamount == 0 || i.stacks == 1)
				for(var/sl=1, sl<49, sl++)
					if(x.inv[sl] == i)
						x.inv[sl] = null
						i.slot = -1
						break
				i.transform = null
				i.vis_contents -= global.inv_slot
				i.loc = x.loc
				i.step_x = x.step_x
				i.step_y = x.step_y
				x.overlays -= i
				x.underlays -= i
				i.underlays = null
				i.layer = initial(i.layer)
				i.handle_inventory_stacking(i, src)
				if(src.client)
					src.client.screen -= i
					src.client.images -= i.stack_display
					if(src.hud_inv) src.hud_inv.vis_contents -= i
					if(i == src.item_selected)
						src.item_selected = null
						src.hud_inv.item_desc.maptext = null
					if(i == src.mouse_down) src.mouse_down = null
					if(i == src.mouse_over) src.mouse_over = null
					src.refresh_inv()
				if(x.client && x != src)
					x.client.screen -= i
					x.client.images -= i.stack_display
					if(x.hud_inv) x.hud_inv.vis_contents -= i
					if(i == x.item_selected)
						x.item_selected = null
						x.hud_inv.item_desc.maptext = null
					if(i == x.mouse_down) x.mouse_down = null
					if(i == x.mouse_over) x.mouse_over = null
					x.refresh_inv()
				i.overlays -= /obj/effects/select_item
				i.set_shadow()
				if(i.floor_state) i.icon_state = i.floor_state
				*/
		soul_absorb(var/mob/m)
			var/rng = rand(0.10,0.25)
			var/deduction = (m.psionic_power_base * rng)
			src.psionic_power_base += deduction
			m.psionic_power_base -= deduction
			animate(m,alpha = 1, time = 7)
			sleep(5)
			if(m && src) m.shockwave()
			sleep(3)
			m.Death("Soul Absorbed")
		decline_absorb(var/mob/m)
			var/rng = rand(0.10,0.25)
			var/deduction = (m.lifespan * rng)
			src.lifespan += deduction
			m.lifespan -= deduction
			sleep(5)
			if(m && src) m.shockwave()
			sleep(3)
		give_water(var/obj/items/consumables/water/water_bottle_dirty/i,var/bypass=0)
			if(bypass==1)
				var/found_stack = 0
				var/overflow = 0
				if(i.stacks > -1)
					if(i.stack_display == null) i.create_stack_display()
					for(var/sl=1, sl<49, sl++)
						if(src.inv[sl] != null)
							if(src.inv[sl] != i && src.inv[sl].type == i.type && src.inv[sl].stacks > -1 && src.inv[sl].stacks < 98 && i.tech_lvl == src.inv[sl].tech_lvl)
								if(src.inv[sl].stack_display == null) src.inv[sl].create_stack_display()
								var/total = (i.stacks + src.inv[sl].stacks)
								if(total > 999999999)
									overflow = total-999999999
									i.stacks = overflow
									total = 999999999
									src.inv[sl].stacks = total
									i.stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[i.stacks]"
									src.inv[sl].stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[src.inv[sl].stacks]"
								else
									src.inv[sl].stacks = total
									src.inv[sl].stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[src.inv[sl].stacks]"
									found_stack = 1
								break
				//If it doesn't stack, or we can't kind an existing stack, simply add it into the inventory as normal.
				if(found_stack == 0)
					//Find empty slot for this item to go into
					var/found_slot = 0
					for(var/sl=1, sl<49, sl++)
						if(src.inv[sl] == null)
							src.inv[sl] = i
							i.slot = sl
							i.vis_contents += global.inv_slot
							found_slot = sl
							break
					if(found_slot)
						i.loc = src
						animate(i)
						i.pixel_y = initial(i.pixel_y)
						if(i.shadow) i.shadow.loc = null
						if(i.inven_state) i.icon_state = i.inven_state
						i.overlays -= /obj/effects/select_item
						src.mouse_down = null
						src.mouse_over = null
						if(src.client) src.refresh_inv()

						return
					else
						src.set_alert("Inventory full",'alert.dmi',"alert")

						return
				else
					i.destroy()
					return
		/*digging_mins(var/obj/i,var/bypass=0)
			if(bypass==1)
				var/found_stack = 0
				var/overflow = 0
				if(i.stacks > -1)
					if(i.stack_display == null) i.create_stack_display()
					for(var/sl=1, sl<49, sl++)
						if(src.inv[sl] != null)
							//if(src.inv[sl] != i && src.inv[sl].type == i.type && src.inv[sl].stacks > -1 && src.inv[sl].stacks < 98 && i.tech_lvl == src.inv[sl].tech_lvl)
							if(src.inv[sl] != i && src.inv[sl].type == i.type && i.tech_lvl == src.inv[sl].tech_lvl)

								if(src.inv[sl].stack_display == null) src.inv[sl].create_stack_display()
								var/total = (i.stacks + src.inv[sl].stacks)
								if(total > 999999999)
									overflow = total-999999999
									i.stacks = overflow
									total = 999999999
									src.inv[sl].stacks = total
									i.stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[i.stacks]"
									src.inv[sl].stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[src.inv[sl].stacks]"
								else
									src.inv[sl].stacks = total
									src.inv[sl].stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[src.inv[sl].stacks]"
									found_stack = 1
								break
				//If it doesn't stack, or we can't kind an existing stack, simply add it into the inventory as normal.
				src.refresh_inv()
				if(found_stack == 0)
					//Find empty slot for this item to go into
					var/found_slot = 0
					for(var/sl=1, sl<49, sl++)
						if(src.inv[sl] == null)
							src.inv[sl] = i
							i.slot = sl
							i.vis_contents += global.inv_slot
							found_slot = sl
							src.refresh_inv()
							break
					if(found_slot)
						i.loc = src
						animate(i)
						i.pixel_y = initial(i.pixel_y)
						if(i.shadow) i.shadow.loc = null
						if(i.inven_state) i.icon_state = i.inven_state
						i.overlays -= /obj/effects/select_item
						src.mouse_down = null
						src.mouse_over = null
						if(i.name == "Stone") src.their_stone += i.stacks
						if(i.name == "Copper") src.their_copper += i.stacks
						if(i.name == "Coal") src.their_coal += i.stacks
						if(i.name == "Gold") src.their_gold += i.stacks
						if(i.name == "Silver") src.their_silver += i.stacks
						if(i.name == "Titanium") src.their_titanium += i.stacks
						if(i.name == "Mystille") src.their_mystille += i.stacks
						src.refresh_inv()
						return
					else
						src.set_alert("Inventory full",'alert.dmi',"alert")

						return
				else
					i.destroy()
					return*/

		digging_mins(var/obj/i,var/bypass=0)

			if(!i) return

			var/amount = i.stacks || 1

			if(istype(i,/obj/items/minerals/Stone))
				src.stone_count += amount

			else if(istype(i,/obj/items/minerals/Silver))
				src.silver_count += amount

			else if(istype(i,/obj/items/minerals/Copper))
				src.copper_count += amount

			else if(istype(i,/obj/items/minerals/Coal))
				src.coal_count += amount

			else if(istype(i,/obj/items/minerals/Gold))
				src.gold_count += amount

			else if(istype(i,/obj/items/minerals/Mystille))
				src.mystille_count += amount

			else if(istype(i,/obj/items/minerals/Titanium))
				src.titanium_count += amount

			i.destroy()

			src.refresh_inv()
		store_in_store(var/obj/i,var/radius = 1)
			if(i in range(radius,src))
				if(i.bolted == 0 && i.can_pocket)
					var/found_stack = 0
					var/overflow = 0
					//If this item stacks, search for another stack of the same item and fuse them
					if(i.stacks > -1)
						if(i.stack_display == null)
							i.create_stack_display()
						for(var/sl=1, sl<49, sl++)
							if(src.shop[sl] != null)
								if(src.shop[sl] != i && src.shop[sl].type == i.type && src.shop[sl].stacks > -1 && src.shop[sl].stacks < 98 && i.tech_lvl == src.shop[sl].tech_lvl)
									if(src.shop[sl].stack_display == null) src.shop[sl].create_stack_display()
									var/total = (i.stacks + src.shop[sl].stacks)
									if(total > 99)
										overflow = total-99
										i.stacks = overflow
										total = 99
										src.shop[sl].stacks = total
										i.stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[i.stacks]"
										src.shop[sl].stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[src.shop[sl].stacks]"
									else
										src.shop[sl].stacks = total
										src.shop[sl].stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[src.shop[sl].stacks]"
										found_stack = 1
									break
					src.refresh_shop()
					//If it doesn't stack, or we can't kind an existing stack, simply add it into the inventory as normal.
					if(found_stack == 0)
						//Find empty slot for this item to go into
						var/found_slot = 0
						for(var/sl=1, sl<49, sl++)
							if(src.shop[sl] == null)
								src.shop[sl] = i
								i.slot = sl
								i.vis_contents += global.inv_slot
								found_slot = sl
								src.refresh_shop()
								break
						if(found_slot)
							i.loc = src
							animate(i)
							i.pixel_y = initial(i.pixel_y)
							if(i.shadow) i.shadow.loc = null
							if(i.inven_state) i.icon_state = i.inven_state
							i.overlays -= /obj/effects/select_item
							src.mouse_down = null
							src.mouse_over = null
							if(i.stacks == null || i.stacks == 0) i.stacks = 1
							src.refresh_shop()

							return
						else
							src.set_alert("Inventory full",'alert.dmi',"alert")
							return

					else
						i.destroy()
						return
		pickup(var/obj/i,var/radius = 1)
			if(!i) return
			if(istype(i, /obj/items/minerals))
				var/amount = i.stacks
				if(!amount || amount <= 0) amount = 1

				if(istype(i, /obj/items/minerals/Stone))
					src.stone_count += amount

				else if(istype(i, /obj/items/minerals/Silver))
					src.silver_count += amount

				else if(istype(i, /obj/items/minerals/Copper))
					src.copper_count += amount

				else if(istype(i, /obj/items/minerals/Coal))
					src.coal_count += amount

				else if(istype(i, /obj/items/minerals/Gold))
					src.gold_count += amount

				else if(istype(i, /obj/items/minerals/Mystille))
					src.mystille_count += amount

				else if(istype(i, /obj/items/minerals/Titanium))
					src.titanium_count += amount

				src.refresh_inv()

				i.destroy()
				return
			if(radius == 0)

				if(i.is_dokuro)
					src.client.dokuro_points += i.stacks
					src.refresh_inv()
					//view(15,src)<<output("[src] picks up [i]","actionoutput")
					i.destroy()
					return
				if(i.is_zenni)
					src.resources += i.stacks
					src.refresh_inv()
					//view(15,src)<<output("[src] picks up [i]","actionoutput")
					i.destroy()
					return
				if(i.bolted == 0 && i.can_pocket && i.grabbed_by == null)
					var/found_stack = 0
					var/overflow = 0
					//If this item stacks, search for another stack of the same item and fuse them
					if(i.stacks > -1)
						if(i.stack_display == null)
							i.create_stack_display()
						for(var/sl=1, sl<49, sl++)
							if(src.inv[sl] != null)
								if(src.inv[sl] != i && src.inv[sl].type == i.type && src.inv[sl].stacks > -1 && src.inv[sl].stacks < 98 && i.tech_lvl == src.inv[sl].tech_lvl)
									if(src.inv[sl].stack_display == null) src.inv[sl].create_stack_display()
									var/total = (i.stacks + src.inv[sl].stacks)
									if(total > 99)
										overflow = total-99
										i.stacks = overflow
										total = 99
										src.inv[sl].stacks = total
										i.stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[i.stacks]"
										src.inv[sl].stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[src.inv[sl].stacks]"
									else
										src.inv[sl].stacks = total
										src.inv[sl].stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[src.inv[sl].stacks]"
										found_stack = 1
									break
					src.refresh_inv()
					//If it doesn't stack, or we can't kind an existing stack, simply add it into the inventory as normal.
					if(found_stack == 0)
						//Find empty slot for this item to go into
						var/found_slot = 0
						for(var/sl=1, sl<49, sl++)
							if(src.inv[sl] == null)
								src.inv[sl] = i
								i.slot = sl
								i.vis_contents += global.inv_slot
								found_slot = sl
								if(src.client) src.refresh_inv()
								break
						if(found_slot)
							i.loc = src
							animate(i)
							i.pixel_y = initial(i.pixel_y)
							if(i.shadow) i.shadow.loc = null
							if(i.inven_state) i.icon_state = i.inven_state
							i.overlays -= /obj/effects/select_item
							src.mouse_down = null
							src.mouse_over = null
							if(i.stacks == null || i.stacks == 0) i.stacks = 1
							src.refresh_inv()

							return
						else
							src.set_alert("Inventory full",'alert.dmi',"alert")
							return

					else
						i.destroy()
						return
			if(i in range(radius,src))
				if(i.is_dokuro)
					src.client.dokuro_points += i.stacks
					src.refresh_inv()
					view(15,src)<<output("[src] picks up [i]","actionoutput")
					i.destroy()
					return
				if(i.is_zenni)
					src.resources += i.stacks
					src.refresh_inv()
					view(15,src)<<output("[src] picks up [i]","actionoutput")
					i.destroy()
					return
				if(i.bolted == 0 && i.can_pocket && i.grabbed_by == null)
					var/found_stack = 0
					var/overflow = 0
					//If this item stacks, search for another stack of the same item and fuse them
					if(i.stacks > -1)
						if(i.stack_display == null)
							i.create_stack_display()
						for(var/sl=1, sl<49, sl++)
							if(src.inv[sl] != null)
								if(src.inv[sl] != i && src.inv[sl].type == i.type && src.inv[sl].stacks > -1 && src.inv[sl].stacks < 98 && i.tech_lvl == src.inv[sl].tech_lvl)
									if(src.inv[sl].stack_display == null) src.inv[sl].create_stack_display()
									var/total = (i.stacks + src.inv[sl].stacks)
									if(total > 99)
										overflow = total-99
										i.stacks = overflow
										total = 99
										src.inv[sl].stacks = total
										i.stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[i.stacks]"
										src.inv[sl].stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[src.inv[sl].stacks]"
									else
										src.inv[sl].stacks = total
										src.inv[sl].stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[src.inv[sl].stacks]"
										found_stack = 1
									break
					src.refresh_inv()
					//If it doesn't stack, or we can't kind an existing stack, simply add it into the inventory as normal.
					if(found_stack == 0)
						//Find empty slot for this item to go into
						var/found_slot = 0
						for(var/sl=1, sl<49, sl++)
							if(src.inv[sl] == null)
								src.inv[sl] = i
								i.slot = sl
								i.vis_contents += global.inv_slot
								found_slot = sl
								if(src.client) src.refresh_inv()
								break

						if(found_slot)
							i.loc = src
							animate(i)
							i.pixel_y = initial(i.pixel_y)
							if(i.shadow) i.shadow.loc = null
							if(i.inven_state) i.icon_state = i.inven_state
							i.overlays -= /obj/effects/select_item
							src.mouse_down = null
							src.mouse_over = null
							if(i.stacks == null || i.stacks == 0) i.stacks = 1
							src.refresh_inv()


							return
						else
							src.set_alert("Inventory full",'alert.dmi',"alert")
							return

					else
						i.destroy()
						return
		drop_tk()
			if(src) if(src.tk)
				if(ismovable(src.tk))
					var/atom/movable/A = src.tk
					A.filters -= filter(type="drop_shadow", x=0, y=0, size=5, offset=0, color=rgb(102,0,204))
					A.tk = 0
					animate(A, pixel_z = initial(A.pixel_z), time = 2, easing = BOUNCE_EASING)
					spawn(2)
						if(A)
							var/obj/effects/dust_medium/d = new
							d.SetCenter(A)
					A.layer = initial(A.layer)
					A.density_factor = initial(A.density_factor)
					A.mouse_opacity = initial(A.mouse_opacity)
					if(src.client) src.force_sources -= "Telekinesis"
					src.tk = null
					//A.recycle()
					A.set_shadow()
		letgo()
			//src.clear_minigame_lift()
			if(src.grab)
				if(src.client)
					src.strength_sources -= "Lifting"
					src.power_sources -= "Lifting"
				src.held = 0
				var/atom/movable/a = src.grab
				//world << output("Debug - Dropped [a]", "chat.system")
				//var/icon/I = new(a.icon,a.icon_state,a.dir)
				animate(a, pixel_z = initial(a.pixel_z),pixel_x = initial(a.pixel_x),pixel_y = initial(a.pixel_y), time = 2,easing = BOUNCE_EASING,flags = ANIMATION_PARALLEL)
				if(a.shadow) animate(a.shadow, pixel_z = initial(a.shadow.pixel_z),pixel_x = initial(a.pixel_x),pixel_y = a.pixel_y-2, time = 2,easing = BOUNCE_EASING,flags = ANIMATION_PARALLEL)
				//del(I)
				a.layer = MOB_LAYER + a.laymod - (a.y + a.step_y / 32) / world.maxy
				a.density_factor = initial(a.density_factor)
				if(ismob(src.grab))
					var/mob/m = src.grab
					m.icon_state = m.state()
				src.grab = null
				src.grab_part = null
				src.wrestle_stage = null
				src.lift_multiplier = 0
				a.grabbed_by = null
				//a.recycle()
				src.icon_state = src.state()
				var/turf/t = a.loc
				if(t.liquid) a.submerge(1,5,t)
				for(var/turf/trf in a.locs)
					for(var/obj/items/tech/Power_Line/p in trf)
						p.reconnect_power()

						return
		milestone_check()
			if(src.move_lvl>=src.lastmilestonelvl&&src.rp_total>=src.lastrpmeter&&src.milestone_checked==0)
				src.milestone_checked =1
				src.milestonecurrent_lvls = src.milestonecurrent_lvls
				src.max_milestonecurrent_lvls = src.max_milestonecurrent_lvls + 6
				src.show_milestones()
				src.lastmilestonelvl = src.move_lvl + (src.prime/2)
				src.lastrpmeter = src.rp_total * 2
		show_milestones()
			if(src.milestone_checked==1)
				for(var/obj/hud/h in src.milestone_hud)
					if(src.client) src.client.screen += h
		show_adminpanel()
			if(src.key in StaffTeam || src.service_lvl)
				for(var/obj/hud/h in src.admin_panel)
					if(src.client) src.client.screen += h
			else
				for(var/obj/hud/h in src.admin_panel)
					if(src.client) src.client.screen -= h
		show_map_button()
			if(src.skill_sense.active==1)
				for(var/obj/hud/h in src.hud_sub)
					if(src.client) src.client.screen +=h
			else
				for(var/obj/hud/h in src.hud_sub)
					if(src.client) src.client.screen -=h

		show_ui()
			for(var/obj/hud/h in src.hud_main)
				src.client.screen += h
			for(var/obj/hud/h in src.hud_skillbar)
				src.client.screen += h

			//winshow(src,"chat",1)

			//winset(src,null,"main.bar_energy.is-visible=true;main.bar_health.is-visible=true;main.power_percent.is-visible=true;main.pp.is-visible=true;main.percent_hp.is-visible=true;main.percent_eng.is-visible=true;main.label_background_percents.is-visible=true")

			winset(src,"map.map","focus=true")

			//winset(src,"percents.bar_health","bar-color=#FF0000")

			//if(src.vision) src.client.screen += src.vision
		reset_ui_proc()
			winshow(src,"resolution",1)
			winset(src,"resolution","size=1920x1080")
			//src.scrwidth = getWinX("resolution")
			//src.scrheight = getWinY("resolution")
			winset(src,"main","pos=0,0")
			winshow(src,"resolution",0)
			/*
			winset(src,"inven","size=[src.og_player_inven]")
			winset(src,"help","size=[src.og_player_help]")
			winset(src,"percents","size=[src.og_player_percents]")
			winset(src,"skills","size=[src.og_player_skills]")
			winset(src,"tech_panes","size=[src.og_player_tech]")
			winset(src,"settings","size=[src.og_player_settings]")
			winset(src,"build_open","size=[src.og_player_build]")
			winset(src,"stats","size=[src.og_player_stats]")
			winset(src,"sense","size=[src.og_player_sense]")
			winset(src,"chat","size=[src.og_player_chat]")
			*/
			//winset(src,"chat","pos=[scrwidth/1.25],[scrheight/1.25]")
			//winset(src,"sense","pos=0,[scrheight-10]")
			//winset(src,"settings_main.bar_ui_scale","value=100")
		build_menu()
			if(src.build == "floors")
				src << output(null,"build_open.grid_build")
				var/count = 0
				for(var/obj/buildings/floors/O in floors)
					src << output(O,"build_open.grid_build:[++count]")
				if(demolish) src << output(demolish,"build_open.grid_build:[++count]")
				winset(src, "build_open.grid_build", "cells=\"[count]\"")
				//winshow(src,"build_open.grid_build",1)
			if(src.build == "walls")
				src << output(null,"build_open.grid_build")
				var/count = 0
				for(var/obj/buildings/walls/O in walls)
					src << output(O,"build_open.grid_build:[++count]")
				if(demolish) src << output(demolish,"build_open.grid_build:[++count]")
				winset(src, "build_open.grid_build", "cells=\"[count]\"")
				//winshow(src,"build_open.grid_build",1)
			if(src.build == "roofs")
				src << output(null,"build_open.grid_build")
				var/count = 0
				for(var/obj/buildings/roofs/O in roofs)
					src << output(O,"build_open.grid_build:[++count]")
				if(demolish) src << output(demolish,"build_open.grid_build:[++count]")
				winset(src, "build_open.grid_build", "cells=\"[count]\"")
				//winshow(src,"build_open.grid_build",1)
		display_gain(var/stat)
			var/obj/I = new
			I.icon = 'stats.dmi'
			I.loc = src.loc
			I.icon_state = "[stat]"
			I.layer = 33
			I.pixel_x = src.stat_pixel
			I.pixel_y = rand(16,32)
			I.display_gain_reset()
		/*
		learn()
			for(var/mob/teacher in range(6,src))
				if(teacher != src)
					var/Chance = 0.02
					for(var/obj/skills/s in teacher)
						if(s.active)
							if(prob((src.energy_max*Chance)/s.difficulty)&&!locate(s) in src)
								new s.type(src)
		*/
		mods(var/list/mods)
			if(src && src.loc)
				for(var/obj/o in src.hud_stats)
					for(var/txt in mods)
						if(txt == "Energy")
							if(o.name == "Energy bar") o.icon_state = "[round(energy_exp,10)]"
							if(o.name == "Energy lvl") o.maptext = "<font size = 1>[css_outline][round(src.energy)] ([round(src.mod_energy,0.1)])"
						if(txt == "Strength")
							if(o.name == "Strength bar") o.icon_state = "[round(strength_exp,10)]"
							if(o.name == "Strength lvl") o.maptext = "<font size = 1>[css_outline][round(src.strength)] ([round(src.mod_strength,0.1)])"
						if(txt == "Endurance")
							if(o.name == "Endurance bar") o.icon_state = "[round(endurance_exp,10)]"
							if(o.name == "Endurance lvl") o.maptext = "<font size = 1>[css_outline][round(src.endurance)] ([round(src.mod_endurance,0.1)])"
						if(txt == "force")
							if(o.name == "force bar") o.icon_state = "[round(force_exp,10)]"
							if(o.name == "force lvl") o.maptext = "<font size = 1>[css_outline][round(src.force)] ([round(src.mod_force,0.1)])"
						if(txt == "resistance")
							if(o.name == "resistance bar") o.icon_state = "[round(resistance_exp,10)]"
							if(o.name == "resistance lvl") o.maptext = "<font size = 1>[css_outline][round(src.resistance)] ([round(src.mod_resistance,0.1)])"
						if(txt == "offence")
							if(o.name == "offence bar") o.icon_state = "[round(offence_exp,10)]"
							if(o.name == "offence lvl") o.maptext = "<font size = 1>[css_outline][round(src.offence)] ([round(src.mod_offence,0.1)])"
						if(txt == "defence")
							if(o.name == "defence bar") o.icon_state = "[round(defence_exp,10)]"
							if(o.name == "defence lvl") o.maptext = "<font size = 1>[css_outline][round(src.defence)] ([round(src.mod_defence,0.1)])"
						if(txt == "Recovery")
							if(o.name == "Recovery lvl") o.maptext = "<font size = 1>[css_outline][round(src.mod_recovery,0.1)]"
						if(txt == "Regeneration")
							if(o.name == "Regeneration lvl") o.maptext = "<font size = 1>[css_outline][round(src.mod_regeneration,0.1)]"
						//if(txt == "Agility")
					//	if(o.name == "Agility lvl") o.maptext = "<font size = 1>[css_outline][round(src.mod_agility,0.1)]"


			/*
			var/combat = (src.strength_base/src.mod_strength)+(src.endurance_base/src.mod_endurance)+(src.resistance_base/src.mod_resistance)+(src.force_base/src.mod_force)+(src.offence_base/src.mod_offence)+(src.defence_base/src.mod_defence)
			var/combat_lvl = combat/10 // 600 stats total = lvl 60
			combat_lvl = round(combat_lvl)
			if(combat_lvl <= 0)
				combat_lvl = 1

			//var/combat = src.strength_base+src.endurance_base+src.resistance_base+src.force_base+src.offence_base+src.defence_base
			var/combat_real = combat/10
			combat = round(combat/10)
			src.combat_lvl = combat
			src.combat_exp = combat_real - src.combat_lvl
			src.combat_exp = round(abs(src.combat_exp),0.1)
			src.combat_exp_max = round(1 - src.combat_exp,0.1)
			if(src.combat_lvl <= 1)
				src.combat_lvl = 1
			*/
		mysticize(var/mob/m)
			if(m)
				var/obj/skills/Mystic/mys = new
				mys.loc = m
				m.has_mystic = 1
				m.set_alert("You learn the basics of Mystic",'alert.dmi',"alert")
				m<<"<b>You learn the basics of Mytsic</b>"

		majinize(var/setlvl,var/mob/m)
			if(m)
				var/obj/skills/Majin/mjn = new
				mjn.majin_level = setlvl
				mjn.loc = m
				m.has_majin = setlvl
				m.set_alert("You learn the basics of Majin",'alert.dmi',"alert")
				m<<"<b>You learn the basics of Majin</b>"


		set_announce(var/N,var/I,var/IS,var/msg)
			if(src.started)
				if(src.client)
					var/obj/help_topics/H = src.tutorials[10]
					H.name = N
					H.icon = I
					H.icon_state = IS
					H.help_text = msg
					H.skill_up(src)
		set_alert(var/N,var/I,var/IS)
			if(src.started)
				if(src.client)
					var/obj/help_topics/H = src.tutorials[10]
					H.name = N
					H.icon = I
					H.icon_state = IS
					H.skill_up(src)




		set_decline()
			if(src.hair)
				src.grey_hair = 100-(((src.oldage+10)-src.age)*10)
				src.grey_hair = clamp(src.grey_hair,0,100)
				src.overlays -= src.hair
				src.hair.icon = src.hair_icon
				src.hair.icon += rgb(src.grey_hair,src.grey_hair,src.grey_hair)
				src.redraw_appearance()
		name_txt()
			var/image/txt = image(null,src,null,100)
			txt.maptext_x = -64
			txt.maptext_y = -14
			txt.maptext_width = 160
			txt.maptext_height = 64
			txt.appearance_flags = KEEP_APART | RESET_COLOR | NO_CLIENT_COLOR | RESET_TRANSFORM
			txt.maptext = "[css_outline]<font size = 1><center>[src.name]"
			//txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
			txt.pixel_x -= src.pixel_x
			txt.pixel_y -= src.pixel_y
			/*
			var/len = length(src.name)
			var/len_x = 22
			while(len)
				len_x -= 2
				len -= 1
			txt.maptext_x = len_x
			*/
			src.name_txt = txt
		tech_unlocking(var/mob/m)
			set background = 1
			if(!m) return

			for(var/obj/items/tech/t in global.tech)
				if(t)
					var/needed = t.needed_qp
					var/already_unlocked = (m.tech_unlocked[t.list_pos] == t.type)

					// --- REMOVE TECH FROM HUD TREE IF TOO LOW INTXP ---
					if(m.intxp < needed && !locate(t) in m || m.intxp < needed)
						if(istype(t,/obj/items/tech/sub_tech/Engineering/))

							m.hud_tech.tree_engineering_list -= t
						else if(istype(t,/obj/items/tech/sub_tech/Physics/))
							m.hud_tech.tree_physics_list -= t
						else if(istype(t,/obj/items/tech/sub_tech/Genetics/))
							m.hud_tech.tree_genetics_list -= t
						continue
					// --- ADD TECH TO HUD TREE WHEN INTXP IS SUFFICIENT ---
					if(m.intxp >= needed && !locate(t) in m)
						if(istype(t,/obj/items/tech/sub_tech/Engineering/))
							m.hud_tech.tree_engineering_list += t
						else if(istype(t,/obj/items/tech/sub_tech/Physics/))
							m.hud_tech.tree_physics_list += t
						else if(istype(t,/obj/items/tech/sub_tech/Genetics/))
							m.hud_tech.tree_genetics_list += t

						// --- AUTO UNLOCK TECH IF INTXP IS HIGH ENOUGH ---
					if(m.intxp >= needed && !already_unlocked)
						// Optional: Check prerequisites first
						var/has_all_prereqs = TRUE
						if(t.tech_prerequisites && length(t.tech_prerequisites))
							has_all_prereqs = FALSE
							var/matched = 0
							for(var/p in t.tech_prerequisites)
								for(var/obj/items/tech/z in global.tech)
									if(m.tech_unlocked[z.list_pos] == z.type && z.type == p)
										matched++
							if(matched >= length(t.tech_prerequisites))
								has_all_prereqs = TRUE

						if(has_all_prereqs)
							t.lvl_up_tech(m)
						//m.output_msg("[t] has been automatically researched due to your Intelligence growth!")

	/*	tech_unlocking(var/mob/m)
		//	set background = 1
			for(var/obj/items/tech/t in global.tech)
				if(m.intxp < t.needed_qp && locate(t) in m || m.intxp < t.needed_qp)
					if(istype(t,/obj/items/tech/sub_tech/Engineering/))
						m.hud_tech.tree_engineering_list -= t
					if(istype(t,/obj/items/tech/sub_tech/Physics/))
						m.hud_tech.tree_physics_list -= t
					if(istype(t,/obj/items/tech/sub_tech/Genetics/))
						m.hud_tech.tree_genetics_list -= t
				if(istype(t,/obj/items/tech/sub_tech/Engineering/))
					if(m.intxp >= t.needed_qp && !locate(t) in m)
						m.hud_tech.tree_engineering_list += t
				else if(istype(t,/obj/items/tech/sub_tech/Physics/))
					if(m.intxp >= t.needed_qp && !locate(t) in m)
						m.hud_tech.tree_physics_list += t

				else if(istype(t,/obj/items/tech/sub_tech/Genetics/))
					if(m.intxp >= t.needed_qp && !locate(t) in m)
						m.hud_tech.tree_genetics_list += t */

		/*pg_increaser(var/mob/m)
			if(m.generation_lvl<=1)                                          /// 1ST GENS PG%
				//if(isCyborged==0)
				//	if(ifocus||magicfocus)
				//		ratingmultiplier = 1 + LifeExperience / 1000000000
				//	else
					//	ratingmultiplier = 1 + LifeExperience / 100000
				if(m.ifocus||m.magicfocus)
					m.rating_mult = 1 + m.rating / 1000000000
				else
					m.rating_mult = 1 + m.rating / 100000
			else                                                    /// 2ND GENS+ PG%
				//if(isCyborged==0)
				//	if(ifocus||magicfocus)
				//		ratingmultiplier = max(1, ratingmultiplier*0.1) + LifeExperience / 1000000000 + GenLv
				//	else
				//		ratingmultiplier = max(1, ratingmultiplier*0.1) + LifeExperience / 100000 + GenLv

				if(m.ifocus||m.magicfocus)
					m.rating_mult = max(1, m.rating_mult*0.1) + m.rating / 1000000000 + m.generation_lvl
				else
					m.rating_mult = max(1, m.rating_mult*0.1) + m.rating / 100000 + m.generation_lvl
*/
		pg_increaser(var/mob/m)
			if(m.generation_lvl <= 1)
				if(m.ifocus || m.magicfocus)
					m.rating_mult = max(1, 1 + m.rating / 1000000000)
				else
					m.rating_mult = max(1, 1 + m.rating / 100000)
			else
				if(m.ifocus || m.magicfocus)
					m.rating_mult = max(1, m.rating_mult * 0.1 + m.rating / 1000000000 + m.generation_lvl)
				else
					m.rating_mult = max(1, m.rating_mult * 0.1 + m.rating / 100000 + m.generation_lvl)
		apply_rating_multiplier(var/mob/m)
			if(!m) return

			// Recalculate safe rating multiplier
			pg_increaser(m) // Ensures rating_mult is updated

			var/mult = m.rating_mult
			if(mult < 1) mult = 1

			// PG Gains for 1st Gens
			if(m.generation_lvl <= 1)
				if(prob(9))
					switch(rand(1, 6))
						if(1, 4)
							m.mod_strength   = m.mod_strength_og   * mult
							m.mod_endurance  = m.mod_endurance_og  * mult
							m.mod_force      = m.mod_force_og      * mult
							m.mod_resistance = m.icon_state == "Meditate" ? m.mod_resistance_og * mult : m.mod_resistance
							m.mod_offence    = m.mod_offence_og    * mult
							m.mod_defence    = m.mod_defence_og    * mult

							if(m.icon_state == "Meditate")
								m.mod_energy = m.mod_energy_og * mult
							else if(prob(2))
								m.mod_energy = m.mod_energy_og * mult

				// Meditation boosts for potential stats
				if(prob(10) && m.icon_state == "Meditate")
					if(m.skill_study?.active)
						switch(rand(1,4))
							if(1) m.mod_tech_potential += mult * 0.001
							if(2) m.mod_tech_potential += mult * 0.002

					if(m.skill_hone?.active)
						switch(rand(1,4))
							if(1) m.mod_arcane_potential += mult * 0.001
							if(2) m.mod_arcane_potential += mult * 0.002

					if(!m.has_FPLM)
						m.mod_psionic_power = m.mod_psionic_power_og * mult

			// PG Gains for 2nd Gen+
			else
				if(prob(9))
					switch(rand(1, 6))
						if(1, 4)
							var/focus_mult = (m.ifocus || m.magicfocus) ? (1 + m.rating / 100000000) : (1 + m.rating / 100000)
							focus_mult = max(1, focus_mult)

							m.mod_strength   = m.mod_strength_og   * focus_mult
							m.mod_endurance  = m.mod_endurance_og  * focus_mult
							m.mod_force      = m.mod_force_og      * focus_mult
							m.mod_resistance = m.icon_state == "Meditate" ? m.mod_resistance_og * focus_mult : m.mod_resistance
							m.mod_offence    = m.mod_offence_og    * focus_mult
							m.mod_defence    = m.mod_defence_og    * focus_mult

							if(m.icon_state == "Meditate")
								m.mod_energy = m.mod_energy_og * focus_mult
							else if(prob(2) || prob(5))
								m.mod_energy = m.mod_energy_og * focus_mult

				if(prob(5) && m.icon_state == "Meditate")
					switch(rand(1, 4))
						if(1, 2)
							var/is_tuffle = (m.race == "Tuffle" || m.race_class == "Technology")
							var/tech_scale = is_tuffle ? m.rating / 100000000 : m.rating / 10000000
							var/add_amount = (m.mod_tech_potential + tech_scale) * 0.001
							if(rand(1,2) == 2)
								add_amount *= 2
							m.mod_tech_potential += add_amount


					if(!m.has_FPLM)
						if(m.race == "Tuffle" || m.race_class == "Technology")
							m.mod_psionic_power_og *= (1 + m.rating / 1000000000)
						else
							m.mod_psionic_power = m.mod_psionic_power_og * (1 + m.rating / 1000000)

		/*apply_rating_multiplier(var/mob/m)
			if(m.generation_lvl<=1)
				if(prob(9))
					switch(rand(1,6))
						if(1)
							src.pg_increaser(m)
							m.mod_strength = m.mod_strength_og * m.rating_mult
							m.mod_endurance = m.mod_endurance_og * m.rating_mult
							//SpdMod_Temp = SpdMod * ratingmultiplier
							m.mod_force = m.mod_force_og * m.rating_mult
							if(m.icon_state=="Meditate")mod_resistance = m.mod_resistance_og * m.rating_mult
							m.mod_offence = m.mod_offence_og * m.rating_mult
							m.mod_defence = m.mod_defence_og * m.rating_mult
							if(m.icon_state=="Meditate")
								m.mod_energy = m.mod_energy_og * m.rating_mult
							else
								if(prob(2)) m.mod_energy = m.mod_energy_og * m.rating_mult
						if(4)
							m.mod_strength = m.mod_strength_og * m.rating_mult
							m.mod_endurance = m.mod_endurance_og * m.rating_mult
							//SpdMod_Temp = SpdMod * ratingmultiplier
							m.mod_force = m.mod_force_og * m.rating_mult
							if(m.icon_state=="Meditate")m.mod_resistance = m.mod_resistance_og * m.rating_mult
							m.mod_offence = m.mod_offence_og * m.rating_mult
							m.mod_defence = m.mod_defence_og * m.rating_mult
							if(m.icon_state=="Meditate")
								m.mod_energy = m.mod_energy_og * m.rating_mult
							else
								if(prob(5)) m.mod_energy = m.mod_energy_og * m.rating_mult

				if(prob(10)&&m.icon_state=="Meditate")
					if(m.skill_study && m.skill_study.active)
						switch(rand(1,4))
							if(1) m.mod_tech_potential+= m.rating_mult*0.001
							if(2) m.mod_tech_potential+= m.rating_mult*0.002
					if(m.skill_hone && m.skill_hone.active)
						switch(rand(1,4))
							if(1) m.mod_arcane_potential+= m.rating_mult*0.001
							if(2) m.mod_arcane_potential+= m.rating_mult*0.002

					if(m.has_FPLM==0||!m.has_FPLM)
						m.mod_psionic_power = m.mod_psionic_power_og * m.rating_mult
			else
				if(prob(9))
					switch(rand(1,6))
						if(1)
							if(m.ifocus||m.magicfocus)
								src.pg_increaser(m)
								m.mod_strength = m.mod_strength_og * (1 + m.rating / 100000000)
								m.mod_endurance = m.mod_endurance_og * (1 + m.rating / 100000000)
								//SpdMod_Temp = SpdMod * ratingmultiplier
								m.mod_force = m.mod_force_og * (1 + m.rating / 100000000)
								if(m.icon_state=="Meditate")mod_resistance = mod_resistance_og * (1 + m.rating / 100000000)
								m.mod_offence = m.mod_offence_og * (1 + m.rating / 100000000)
								m.mod_defence = m.mod_defence_og * (1 + m.rating / 100000000)
								if(m.icon_state=="Meditate")
									m.mod_energy = m.mod_energy_og * (1 + m.rating / 100000000)
								else
									if(prob(2)) m.mod_energy = m.mod_energy_og * (1 + m.rating / 100000000)
							else
								src.pg_increaser(m)
								m.mod_strength = m.mod_strength_og * (1 + m.rating / 100000)
								m.mod_endurance = m.mod_endurance_og * (1 + m.rating / 100000)
								//SpdMod_Temp = SpdMod * ratingmultiplier
								m.mod_force = m.mod_force_og * (1 + m.rating / 100000)
								if(m.icon_state=="Meditate")mod_resistance = mod_resistance_og * (1 + m.rating / 100000)
								m.mod_offence = m.mod_offence_og * (1 + m.rating / 100000)
								m.mod_defence = m.mod_defence_og * (1 + m.rating / 100000)
								if(m.icon_state=="Meditate")
									m.mod_energy = m.mod_energy_og * (1 + m.rating / 100000)
								else
									if(prob(2)) m.mod_energy = m.mod_energy_og * (1 + m.rating / 100000)
						if(4)
							if(ifocus||magicfocus)
								m.mod_strength = m.mod_strength_og * (1 + m.rating / 100000000)
								m.mod_endurance = m.mod_endurance_og * (1 + m.rating / 100000000)
								//SpdMod_Temp = SpdMod * ratingmultiplier
								m.mod_force = m.mod_force_og * (1 + m.rating / 100000000)
								if(m.icon_state=="Meditate")mod_resistance = mod_resistance_og * (1 + m.rating / 100000000)
								m.mod_offence = m.mod_offence_og * (1 + m.rating / 100000000)
								m.mod_defence = m.mod_defence_og * (1 + m.rating / 100000000)
								if(m.icon_state=="Meditate")
									m.mod_energy = m.mod_energy_og * (1 + m.rating / 100000000)
								else
									if(prob(5)) m.mod_energy = m.mod_energy_og * (1 + m.rating / 100000000)
							else
								m.mod_strength = m.mod_strength_og * (1 + m.rating / 100000)
								m.mod_endurance = m.mod_endurance_og * (1 + m.rating / 100000)
								//SpdMod_Temp = SpdMod * ratingmultiplier
								m.mod_force = m.mod_force_og * (1 + m.rating / 100000)
								if(m.icon_state=="Meditate")mod_resistance = mod_resistance_og * (1 + m.rating / 100000)
								m.mod_offence = m.mod_offence_og * (1 + m.rating / 100000)
								m.mod_defence = m.mod_defence_og * (1 + m.rating / 100000)
								if(m.icon_state=="Meditate")
									m.mod_energy = m.mod_energy_og * (1 + m.rating / 100000)
								else
									if(prob(5)) m.mod_energy = m.mod_energy_og * (1 + m.rating / 100000)

				if(prob(5)&&m.icon_state=="Meditate")

					switch(rand(1,4))

						if(1)
							if(m.race=="Tuffle"||m.race_class=="Technology")
								m.mod_tech_potential+= (mod_tech_potential + m.rating / 100000000)*0.001
							else
								m.mod_tech_potential+= (mod_tech_potential + m.rating / 10000000)*0.001
						if(2)
							if(m.race=="Tuffle"||m.race_class=="Technology")
								m.mod_tech_potential+= (mod_tech_potential + m.rating / 100000000)*0.002
							else
								m.mod_tech_potential+= (mod_tech_potential + m.rating / 10000000)*0.002
					if(m.race=="Tuffle"||m.race_class=="Technology")
						if(m.has_FPLM==0||!m.has_FPLM)

							m.mod_psionic_power_og = m.mod_psionic_power_og * (1 + m.rating / 1000000000)
					else
						if(m.has_FPLM==0||!m.has_FPLM)

							m.mod_psionic_power = m.mod_psionic_power_og * (1 + m.rating / 1000000)

							*/

		trait_proc_fervent_fury(var/act = 0)
			if(act)
				src.mod_strength*=1.2
				src.mod_endurance*=1.2
				src.mod_resistance*=1.2
				src.mod_force*=1.2
				src.mod_offence*=1.2
				src.mod_defence*=1.2
				src.mod_agility*=1.2
				src.mod_regeneration*=1.2
			else
				src.mod_strength/=1.2
				src.mod_endurance/=1.2
				src.mod_resistance/=1.2
				src.mod_force/=1.2
				src.mod_offence/=1.2
				src.mod_defence/=1.2
				src.mod_agility/=1.2
				src.mod_regeneration/=1.2
		update_weight()
			var/w_current = 0
			var/w_max_level = 0
			var/list/valid_weights = list()

			for(var/obj/items/tech/weights/wgt in src)
				if(wgt.suffix) // Only count valid training weights
					w_current += wgt.weight
					valid_weights += wgt
					if(wgt.level > w_max_level)
						w_max_level = wgt.level

			var/capacity = max(1, src.strength + src.endurance)
			var/efficiency = min(w_current / capacity, 1.5) // Cap at 150% overload

			// You can tweak gain_factor to control how much weight training boosts PL gain
			var/gain_factor = 2.0

			// Smoothed exponential gain with weight quality
			var/w_gain = (efficiency ** 1.2) * (w_max_level + 1) * gain_factor

			src.weight = efficiency
			src.current_weight_gain = round(w_gain, 0.1) // Slight rounding

			//src << "Applied weight training: [round(w_current,1)]kg (efficiency: [round(efficiency,2)])"
			//src << "Calculated weight gain bonus: [src.current_weight_gain] (based on weight level [w_max_level])"

			if(src.weight < 1)
				src.weight = 1

		/*update_weight()
			var/w_current = 0
			var/w_gain = 0
			for(var/obj/items/tech/weights/wgt in src)
				if(wgt.suffix)
					w_current += wgt.weight
					w_gain = (wgt.weight
			src.weight = (w_current/(src.strength+src.endurance))
			src<<"applied weight ([src.weight]kg - ([(w_current/(src.strength+src.endurance))])"
			if(src.weight < 1) src.weight = 1*/
			//world << "DEBUG - Player weight multi is [src.weight]"
		set_weather_imgs()
			for(var/image/I in sandstorm_imgs)
				src.client.images += I
			for(var/image/I in snowstorm_imgs)
				src.client.images += I
			for(var/image/I in rainstorm_imgs)
				src.client.images += I
		check_mouse_loc(params)
			var/s = params2list(params)["screen-loc"]
			if(ScreenLocParser.Find(s))
				var tile_x = text2num(ScreenLocParser.group[2])
				var step_x = text2num(ScreenLocParser.group[3])
				var tile_y = text2num(ScreenLocParser.group[4])
				var step_y = text2num(ScreenLocParser.group[5])
				if(tile_x) src.mouse_x = tile_x
				if(tile_y) src.mouse_y = tile_y
				if(step_x) src.mouse_pix_x = step_x
				if(step_y) src.mouse_pix_y = step_y
				src.mouse_screen_loc = "[tile_x]:[step_x],[tile_y]:[step_y]"
				//world << "Test mouse = [src.mouse_screen_loc]"
		create_info_tooltips()
			var/image/o = new
			o.maptext_width = 160
			o.maptext_height = 160
			o.appearance_flags = KEEP_APART | RESET_COLOR | NO_CLIENT_COLOR | RESET_TRANSFORM
			o.maptext = "<font size = 1>"
			o.filters += filter(type="outline", size=1, color=rgb(0,0,0))
			o.layer = 30
			o.plane = 12
			o.pixel_x = 33
			src.mouse_over_tooltip = o


			var/image/v = new
			v.icon = 'mouse_over_visual.dmi'
			v.layer = 30
			v.plane = 12
			src.mouse_over_visual = v
		show_info_tech(var/obj/o)
			if(src.mouse_over_tooltip == null)
				src.create_info_tooltips()
			if(src.client) src.client.images += src.mouse_over_tooltip
			var/build = "???"
			var/health = "???"
			var/lvl = "???"
			if(src.hp < src.hp_max/4) health = "Falling apart"
			else if(src.hp < src.hp_max/3) health = "Badly damaged"
			else if(src.hp < src.hp_max/2) health = "Damaged"
			else if(src.hp < src.hp_max) health = "Slightly damaged"
			else health = "Fine"
			if(src.seen_build == null) src.seen_build = list()
			if(o.owner == src.real_name)
				build = "[src.real_name]"
				lvl = "[o.level]"
			else if(o.owner in src.seen_build) build = "[src.real_name]"
			if(o.owner == null) build = "none"
			src.mouse_over_tooltip.pixel_y = -19
			src.mouse_over_tooltip.loc = o.loc
			src.mouse_over_visual.loc = null
			src.mouse_over_tooltip.maptext = "<font size = 1><u>Tech Info</u>\nName: [o.name]\nLevel: [lvl]\nHealth: [health]\nBuilder: [build]"
			//world << "DEBUG - updated tooltip - lvl = [o.tech_lvl]"
		/*show_mob_info(var/mob/x)
			if(x)
				if(src.mouse_over_tooltip == null)
					src.create_info_tooltips()
				if(src.client)
					src.client.images += src.mouse_over_tooltip
					src.client.images += src.mouse_over_visual

				var/pow = 0
				if(t.bats_list)
					for(var/obj/o in t.bats_list)
						pow += o.capacity
				var/build = "???"
				var/health = "???"
				if(t.hp < t.hp_max/4) health = "Falling apart"
				else if(t.hp < t.hp_max/3) health = "Badly damaged"
				else if(t.hp < t.hp_max/2) health = "Damaged"
				else if(t.hp < t.hp_max) health = "Slightly damaged"
				else health = "Fine"
				var/lvl = "???"
				if(src.tech_pos_se > 0)
					if(src.tech_lvls[src.tech_pos_se] >= t.level) lvl = "[t.level]"
				if(src.seen_build == null) src.seen_build = list()
				if(x.builder in src.seen_build) build = "[src.real_name]"
				else if(x.builder == src.real_name) build = "[src.real_name]"
				if(x.builder == null) build = "none"

				//Power Gain
				var/c_gain = "<font color = white>"
				if(t.excess_grid < 0) c_gain = "<font color = red>"
				else if(t.excess_grid > 0) c_gain = "<font color = green>"

				//Power Drain
				var/c_drain
				//If there is a power drain, but there is NO battery with power inside it: red.
				if(t.used_grid > t.excess_grid && pow <= 0) c_drain = "<font color = red>"
				//If there is a power drain, but there is a battery with power inside it: yellow.
				else if(t.used_grid > t.excess_grid && pow > 0) c_drain = "<font color = yellow>"
				//No drain and no power
				else if(t.used_grid == 0) c_drain = "<font color = white>"
				//No power drain: green
				else if(t.currents_grid > t.used_grid) c_drain = "<font color = green>"

				//Power Total
				var/c_total = "<font color = white>"
				if(t.currents_grid == 0 && t.excess_grid < 0) c_total = "<font color = red>"
				else if(t.currents_grid > 0) c_total = "<font color = green>"

				//Power Stored
				var/c_stored = "<font color = white>"
				if(t.excess_grid < 0 && pow <= 0) c_stored = "<font color = red>"
				else if(t.excess_grid < 0 && pow > 0) c_stored = "<font color = yellow>"
				else if(pow > 0) c_stored = "<font color = green>"

				var/powered = ""
				if(t.layer == 2.1)//if(t.power_grid || t.layer == 2.1)
					powered = "\n<u>Power Line</u>\nPower Gain: [c_gain][Commas(t.excess_grid)]</font>\nPower Drain: [c_drain][Commas(t.used_grid)]</font>\nPower Stored: [c_stored][Commas(pow)]</font>\nPower Total: [c_total][Commas(t.currents_grid)]</font>"
					src.mouse_over_tooltip.pixel_y = -84
				else
					src.mouse_over_tooltip.pixel_y = -19


				src.mouse_over_tooltip.loc = x
				src.mouse_over_visual.loc = x
				src.mouse_over_tooltip.maptext = "<font size = 1><u>Tile Info</u>\nLevel: [lvl]\nHealth: [health]\nBuilder: [build][powered]"
				*/
		show_info(var/turf/x)
			if(x)
				var/area/t = null
				for(var/area/a in world)
					if(x in a.contents)
						t = a
				if(t)
					if(src.mouse_over_tooltip == null)
						src.create_info_tooltips()
					if(src.client)
						src.client.images += src.mouse_over_tooltip
						src.client.images += src.mouse_over_visual
					if(t.level)
						var/pow = 0
						if(t.bats_list)
							for(var/obj/o in t.bats_list)
								pow += o.capacity
						var/build = "???"
						var/health = "???"
						if(t.hp < t.hp_max/4) health = "Falling apart"
						else if(t.hp < t.hp_max/3) health = "Badly damaged"
						else if(t.hp < t.hp_max/2) health = "Damaged"
						else if(t.hp < t.hp_max) health = "Slightly damaged"
						else health = "Fine"
						var/lvl = "???"
						if(src.tech_pos_se > 0)
							if(src.tech_lvls[src.tech_pos_se] >= t.level) lvl = "[t.level]"
						if(src.seen_build == null) src.seen_build = list()
						if(x.builder in src.seen_build) build = "[src.real_name]"
						else if(x.builder == src.real_name) build = "[src.real_name]"
						if(x.builder == null) build = "none"

						//Power Gain
						var/c_gain = "<font color = white>"
						if(t.excess_grid < 0) c_gain = "<font color = red>"
						else if(t.excess_grid > 0) c_gain = "<font color = green>"

						//Power Drain
						var/c_drain
						//If there is a power drain, but there is NO battery with power inside it: red.
						if(t.used_grid > t.excess_grid && pow <= 0) c_drain = "<font color = red>"
						//If there is a power drain, but there is a battery with power inside it: yellow.
						else if(t.used_grid > t.excess_grid && pow > 0) c_drain = "<font color = yellow>"
						//No drain and no power
						else if(t.used_grid == 0) c_drain = "<font color = white>"
						//No power drain: green
						else if(t.currents_grid > t.used_grid) c_drain = "<font color = green>"

						//Power Total
						var/c_total = "<font color = white>"
						if(t.currents_grid == 0 && t.excess_grid < 0) c_total = "<font color = red>"
						else if(t.currents_grid > 0) c_total = "<font color = green>"

						//Power Stored
						var/c_stored = "<font color = white>"
						if(t.excess_grid < 0 && pow <= 0) c_stored = "<font color = red>"
						else if(t.excess_grid < 0 && pow > 0) c_stored = "<font color = yellow>"
						else if(pow > 0) c_stored = "<font color = green>"

						var/powered = ""
						if(t.layer == 2.1)//if(t.power_grid || t.layer == 2.1)
							powered = "\n<u>Power Line</u>\nPower Gain: [c_gain][Commas(t.excess_grid)]</font>\nPower Drain: [c_drain][Commas(t.used_grid)]</font>\nPower Stored: [c_stored][Commas(pow)]</font>\nPower Total: [c_total][Commas(t.currents_grid)]</font>"
							src.mouse_over_tooltip.pixel_y = -84
						else
							src.mouse_over_tooltip.pixel_y = -19


						src.mouse_over_tooltip.loc = x
						src.mouse_over_visual.loc = x
						src.mouse_over_tooltip.maptext = "<font size = 1><u>Tile Info</u>\nLevel: [lvl]\nHealth: [health]\nBuilder: [build][powered]"
		build(var/obj/o,var/obj/i)
			if(i == null) return
			else
				var/turf/t = i.loc
				if(t && isturf(t))
					if(t.liquid)
						src.set_alert("Must build on solid foundation",'alert.dmi',"alert")

						return
					if(o == demolish)
						if(t.builder == src.real_name)
							if(t.og_type) new t.og_type(t)
							turfs[1][t.z] -= t
							var/obj/effects/dust_medium/d = new
							d.SetCenter(t)
							t.create_worldmap_building()
							t.og_type = null
						else
							//src.set_alert("Tile must belong to you",'alert.dmi',"alert")
							src << "Tile must belong to you."
					else if(o.icon_state != "demolish")
						if(src.resources>=12)
							var/obj/item = new o.type(i.loc)
							item.alpha = 100
							item.pixel_z = 32
							src.resources -= 12
							animate(item, pixel_z = initial(item.pixel_z), alpha = 255,time = 2, easing = BOUNCE_EASING)
							sleep(1)
							var/obj/effects/dust_medium/d = new
							d.SetCenter(item)
							sleep(6)
							//item.loc = null
							item.destroy()

							if(o.build)
								var/og_t = t.type
								new o.build(t)
								turfs[1][t.z] += t
								t.builder = src.real_name
								t.builder_key = src.key
								t.og_type = og_t
								//Dynamically change the worldmap to mirror the changes made when building.
								t.create_worldmap_building()
								//Update the info for anyone near, so they know who built what.
								for(var/mob/m in view(16,src))
									if(m.seen_build == null) m.seen_build = list()
									if(m.seen_build.Find(src.real_name) == 0) m.seen_build += src.real_name
								//Remove any plants when building.
								for(var/obj/items/plants/p in range(1,t))
									p.destroy()
									t.overlays = null
							items += o
						else
							src<<"Not enough Zenni!"
							src.set_alert("Not enough Zenni!",'alert.dmi',"alert")
							return
		/*count_material(material)
			var/total = 0
			for (var/obj/item in src.contents)
				if (item.name == material)
					total += item.stacks
			return total*/
		count_material(material)

			switch(material)

				if("Stone") return src.stone_count
				if("Silver") return src.silver_count
				if("Copper") return src.copper_count
				if("Coal") return src.coal_count
				if("Gold") return src.gold_count
				if("Titanium") return src.titanium_count
				if("Mystille") return src.mystille_count

			return 0
		remove_material(material, amount)

			if(amount <= 0) return 1

			switch(material)

				if("Stone")
					if(src.stone_count < amount) return 0
					src.stone_count -= amount

				if("Silver")
					if(src.silver_count < amount) return 0
					src.silver_count -= amount

				if("Copper")
					if(src.copper_count < amount) return 0
					src.copper_count -= amount

				if("Coal")
					if(src.coal_count < amount) return 0
					src.coal_count -= amount

				if("Gold")
					if(src.gold_count < amount) return 0
					src.gold_count -= amount

				if("Titanium")
					if(src.titanium_count < amount) return 0
					src.titanium_count -= amount

				if("Mystille")
					if(src.mystille_count < amount) return 0
					src.mystille_count -= amount

			src.refresh_inv()
			return 1
		get_efficiency_discount()
			// 0.11% per point => 10 points = 1.1% (0.011)
			var/d = src.efficiency_skill * 0.0011
			if(d < 0) d = 0
			if(d > 0.50) d = 0.50 // cap at 50% so it can’t go crazy
			return d
		ceil_num(n)
			return (round(n) < n) ? (round(n) + 1) : round(n)
		apply_discount(cost)
			if(cost <= 0) return 0
			var/d = src.get_efficiency_discount()
		    // round up so discount never makes something "free" due to rounding
			return max(0, round(cost * (1 - d), 1))



		/*remove_material(material, amount)
			for (var/obj/items/minerals/item in src)
				if (item.name == material)
					if (item.stacks >= amount)
						item.stacks -= amount
						item.stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[item.stacks]"


						if (item.stacks <= 0)
							item.remove_item_from_inventory(src,item)
						return
					else
						amount -= item.stacks
						item.remove_item_from_inventory(src,item)
						return
						//del(item)

						*/
		/*remove_material(material, amount)
			if(amount <= 0) return 1

			// remove across multiple stacks if needed
			for(var/obj/items/minerals/item in src.contents)
				if(item.name != material) continue

				if(item.stacks >= amount)
					item.stacks -= amount
					if(item.stack_display)
						item.stack_display.maptext = "[css_outline]<font size = 1><text align=right valign=bottom>[item.stacks]"
					if(item.stacks <= 0)
						item.remove_item_from_inventory(src, item)
					return 1

				else
			        // consume this stack entirely and continue
					amount -= item.stacks
					item.remove_item_from_inventory(src, item)
					if(amount <= 0) return 1

			return 0 // not enough found (should not happen if you checked afford first)
			*/

		start_phase()
			//set background = 1
			spawn(180)
				src.phase_ready=1
				src.phased=1
				src<<output("<b>Phase Ended (Prepare for next phase)</b>","actionoutput")
				src<<output("<i>Cancel anytime by typing /rpm to change your rp mode</i>","actionoutput")
				src.overlays += src.phase_icon
				return
		check_cft()
			set background = 1
			if(!src || !src.client) return

			var/should_have_cft = (src.cycle_free_time >= 1 || cftglobal)

			if(cftglobal && src.cycle_free_time <= 0)
				src.cycle_free_time = 25

			if(!should_have_cft)
				// If they shouldn't have it, ensure it's removed once.
				if(src.hud_cft && (src.hud_cft in src.client.screen))
					src.client.screen -= src.hud_cft
				return

			// CFT is active: apply stat-side effects once (lightweight, fine)
			blastres = 0; blast_ressed = 0
			medres = 0;   med_ressed = 0
			trainres = 0; train_ressed = 0
			sparres = 0;  spar_ressed = 0

			// Create HUD once
			if(!src.hud_cft)
				var/obj/hud/menus/cft_gains_txt/cftb = new
				src.hud_cft = cftb
				src.hud_cft.cycler = src

			// Add to screen only if not already present
			if(!(src.hud_cft in src.client.screen))
				src.client.screen += src.hud_cft

			// Only show the big message once per activation (optional)
			if(src.first_cft)
				src.first_cft = 0
				src << output("<b><font color=yellow>Cycle Free Time Active:<i> Resilience is disabled during this time, offering you an opportunity to train stats without tire.</font></b></i>","actionoutput")
				src << output("<b><font color=yellow><u>Debut Curtesy</u></font>\nCurtesy of your IC debut, you have been gifted Cycle Free Time. Click the TBMS box at the top left corner to activate it.\n<i>Note: Resilience is disabled during this time, offering you an opportunity to train stats without tire.","actionoutput")

		/*check_cft()
			if(src.cycle_free_time>=1 || cftglobal)
				if(cftglobal && src.cycle_free_time<=0) src.cycle_free_time = 25
				blastres = 0
				blast_ressed = 0
				medres = 0
				med_ressed = 0
				trainres = 0
				train_ressed = 0
				sparres = 0
				spar_ressed = 0
				if(src.hud_cft == null)
					var/obj/hud/menus/cft_gains_txt/cftb = new
					src.hud_cft = cftb
					src.hud_cft.cycler = src
					if(src.cycle_free_time) src.client.screen += src.hud_cft
				else
					src.client.screen -= src.hud_cft
					src.client.screen += src.hud_cft
				src<<output("<b><font color=yellow>Cycle Free Time Active:<i> Resilience is disabled during this time, offering you an opportunity to train stats without tire.</font></b></i>","actionoutput")

				if(src.first_cft )
					src.first_cft = 0
					src<<output("<b><font color=yellow><u>Debut Curtesy</u></font>\nCurtesy of your IC debut, you have been gifted Cycle Free Time. Click the TBMS box at the top left corner to activate it.\n<i>Note: Resilience is disabled during this time, offering you an opportunity to train stats without tire.","actionoutput")
*/
					//src.hud_cft.icon_state = "active"
		remove_cft()
			src.cycle_free_time = 0
			src.cft_activated = 0
			src.client.screen -= src.hud_cft
			src.rp_cycle_free_time = 0



		build_tech(var/obj/o,var/obj/i)
			set background = 1
			if(!o || !i) return
			var/turf/t = i.loc
			if(t && isturf(t) && t.liquid && src.build_tech && src.build_tech.tech_water == 0)
				src.set_alert("Must build on solid foundation",'alert.dmi',"alert")
				return
			if(src.skill_selected) src.skill_selected = null

			var/afford = 1
			var/admin_pass = (src.key == "VOXTECH")
			if(src.skill_selected) src.skill_selected = null
			var/val_multi = 1
			var/lvl = 1
			if(src.hud_tech)
				var/obj/hud/menus/tech_background/s = src.hud_tech
				if(s && s.num_to_make) val_multi = s.num_to_make
				if(s && s.lvl_to_make) lvl = max(1, s.lvl_to_make)
				if(lvl <=0 ) lvl = 1

			var/is_weights = istype(o, /obj/items/tech/weights/) || (src.build_tech && src.build_tech.type == /obj/items/tech/weights/)

			var/newweight = 0
			var/weight_multi = 1

			if(is_weights)
				newweight = input(src, "How heavy are these weights?", "Weights", max(1, o:weight)) as num
				if(newweight <= 0) return
				var/base_weight = (o:weight > 0) ? o:weight : 1
				// scale linearly; 4kg vs 1kg => 4x
				weight_multi = ceil_num(newweight / base_weight)
				if(weight_multi < 1) weight_multi = 1



				// ----------------------------
				// Build required metals
				// Apply val_multi and weight_multi BEFORE discount
				// ----------------------------
				var/stone_cost    = o.stone_cost    * val_multi * weight_multi
				var/copper_cost   = o.copper_cost   * val_multi * weight_multi
				var/coal_cost     = o.coal_cost     * val_multi * weight_multi
				var/silver_cost   = o.silver_cost   * val_multi * weight_multi
				var/gold_cost     = o.gold_cost     * val_multi * weight_multi
				var/titanium_cost = o.titanium_cost * val_multi * weight_multi
				var/mystille_cost = o.mystille_cost * val_multi * weight_multi

				// Efficiency discount
				stone_cost    = src.apply_discount(stone_cost)
				copper_cost   = src.apply_discount(copper_cost)
				coal_cost     = src.apply_discount(coal_cost)
				silver_cost   = src.apply_discount(silver_cost)
				gold_cost     = src.apply_discount(gold_cost)
				titanium_cost = src.apply_discount(titanium_cost)
				mystille_cost = src.apply_discount(mystille_cost)

				var/list/required_metals = list(
				"Stone" = stone_cost,
				"Copper" = copper_cost,
				"Coal" = coal_cost,
				"Silver" = silver_cost,
				"Gold" = gold_cost,
				"Titanium" = titanium_cost,
				"Mystille" = mystille_cost
				)

				// ----------------------------
				// Afford check
				// ----------------------------
				//var/afford = 1
				if(!admin_pass)
					for(var/material in required_metals)
						var/required_amount = required_metals[material]
						if(required_amount <= 0) continue

						var/inventory_amount = src.count_material(material)
						if(inventory_amount < required_amount)
							afford = 0
							src << "You lack the required [material]! Needed: [required_amount], You have: [inventory_amount]."
							src.set_alert("You lack [material]: need [required_amount], have [inventory_amount].",'alert.dmi',"alert")
							break

				if(!afford) return
				// ----------------------------
				// Create the item once costs are paid
				// ----------------------------
				var/obj/item = new o.type(i.loc)
				item.owner = src.real_name
				item.level = lvl

				if(is_weights)
					item.standby = 1
					item.weight = newweight
					var/iconcolor = input(src, "Pick a color", "Weights") as color
					item.icon *= iconcolor
					item.desc_extra = "- [item.weight]kg weights\n\n"
			else
				//var/has_all_materials = 1
				var/titanium_cost = o.titanium_cost * val_multi
				var/mystille_cost = o.mystille_cost * val_multi
				var/coal_cost = o.coal_cost * val_multi
				var/gold_cost = o.gold_cost * val_multi
				var/silver_cost = o.silver_cost * val_multi
				var/copper_cost = o.copper_cost * val_multi
				var/stone_cost = o.stone_cost * val_multi
				var/required_metals = list(
					"Stone" = stone_cost,
					"Copper" = copper_cost,
					"Coal" = coal_cost,
					"Silver" = silver_cost,
					"Gold" = gold_cost,
					"Titanium" = titanium_cost,
					"Mystille" = mystille_cost,
				)


				for (var/material in required_metals)

					var/required_amount = required_metals[material]
					if (required_amount > 0) // Skip if no cost for this material
						var/inventory_amount = src.count_material(material)
						if (inventory_amount < required_amount)
							afford=0
							src << "You lack the required [material]! Needed: [required_amount], You have: [inventory_amount]."
							src.set_alert("You lack the required [material] needed: [required_amount], You have: [inventory_amount]",'alert.dmi',"alert")
							break


				if(src.key == "VOXTECH")
					src.set_alert("Admin Pass: [o] created!",'alert.dmi',"alert")
					afford = 1
				if(!afford) return
				if(src.hud_tech)
					var/obj/hud/menus/tech_background/s = src.hud_tech
					if(val_multi) val_multi = s.num_to_make
					lvl = s.lvl_to_make
					if(lvl <=0 ) lvl = 1
				var/val = o.value*val_multi
				if(src.trait_ic) val/=2



				//src.update_rsc()
				if(afford)
					for (var/material in required_metals)
						var/required_amount = required_metals[material]
						if (required_amount > 0)
							src.remove_material(material, required_amount)
					//src.update_rsc()
					var/obj/item = new o.type(i.loc)
					item.weight = o.weight
					item.owner = src.real_name
					/*if(istype(o,/obj/items/tech/weights/)|| src.build_tech.type == /obj/items/tech/weights/)
						var/newweight=input("How heavy are these weights?") as num
						if(newweight<=-0) return
						if(newweight<=0) return
						item.standby = 1
						item.weight = newweight
						var/iconcolor = input("Pick a color") as color
						item.icon *= iconcolor
						item.desc_extra = "- [item.weight]kg weights\n\n"*/
					if(istype(o, /obj/items/drugs/))
						var/fail_chance = src.get_drug_fail_chance(lvl)

						if(prob(fail_chance))
							src << output("The synthesis destabilizes and fails!","actionoutput")
							src.set_alert("Drug synthesis failed!", 'alert.dmi', "alert")
							item.loc=null
							// Optional: partial material loss
							for(var/material in required_metals)
								var/required_amount = required_metals[material]
								if(required_amount > 0)
									src.remove_material(material, round(required_amount * 0.5))

							return

					else if(istype(o,/obj/items/tech/Fuel) || src.build_tech.type == /obj/items/tech/Fuel)
						var/fueltomake=input("How much fuel are you making?") as num
						if(fueltomake<=-0) return
						if(fueltomake<=0) fueltomake = 1
						item.fuel = fueltomake
						item.desc_extra = "Fuel: [item.fuelamount]\n\n"
					else if(istype(o,/obj/items/tech/weapons/Battle_Hammer) || src.build_tech.type == /obj/items/tech/weapons/Battle_Hammer)

						var/hammercolor = input("Select a color") as color
						item.filters += filter(type="color", color=hammercolor)

						item.desc_extra = "Endurance Quality: +1%\n\n"
						item.desc_extra += "Defence Quality: -1%\n"
					else if(istype(o,/obj/items/tech/weapons/Battle_Axe) || src.build_tech.type == /obj/items/tech/weapons/Battle_Axe)

						var/axecolor = input("Select a color") as color
						item.filters += filter(type="color", color=axecolor)

						item.desc_extra = "Laceration Quality: +1%\n"//"Laceration Quality: +[(item.level)]%\n"
						item.desc_extra += "Offence Quality: -1%\n\n"

					else if(istype(o,/obj/items/tech/weapons/Sword) || src.build_tech.type == /obj/items/tech/weapons/Sword || istype(o,/obj/items/tech/weapons/Kid_Sword || src.build_tech.type == /obj/items/tech/weapons/Kid_Sword))

						var/swordcolor = input("Select a color") as color
						item.filters += filter(type="color", color=swordcolor)
						switch(input("Select the type of sword you wish to create:\n+Speed, -Offence\nOR\n+Offence, -Speed") in list ("Speed","Offence"))
							if("Speed")
								item:sword_spd = lvl
							if("Offence")
								item:sword_off = lvl
						if(item:sword_spd) item.desc_extra = "Speed Quality: +1%\n\n"
						if(item:sword_off) item.desc_extra = "Offence Quality: +1%\n\n"
					else if(istype(o,/obj/items/tech/armors/))

						if(istype(o,/obj/items/tech/armors/Alien_Armor)|| istype(o,/obj/items/tech/armors/Kid_Alien_Armor)|| istype(o,/obj/items/tech/armors/Basic_Armor) || istype(o,/obj/items/tech/armors/Kid_Basic_Armor))
							goto end
						var/basecolorz = input("Select a color") as color
						var/obj/base = new/obj

						if(istype(o,/obj/items/tech/armors/Saiyan_Armor))
							base.icon = 'Saiyan_Armor_Base.dmi'
							base.icon *= basecolorz
							item:basecolor = basecolorz
						else if(istype(o,/obj/items/tech/armors/Kid_Saiyan_Armor))
							base.icon = 'Saiyan_Armor_kid_base.dmi'
							base.icon *= basecolorz
							item:basecolor = basecolorz
						else if(istype(o,/obj/items/tech/armors/Saiyan_Armor_Single_Shoulder))
							base.icon = 'Saiyan_Armor_SingleShoulder_Base.dmi'
							base.icon *= basecolorz
							item:basecolor = basecolorz
						else if(istype(o,/obj/items/tech/armors/Kid_Saiyan_Armor_Single_Shoulder))
							base.icon = 'Saiyan_Armor_SingleShoulder_kid_base.dmi'
							base.icon *= basecolorz
							item:basecolor = basecolorz
						else if(istype(o,/obj/items/tech/armors/Saiyan_Armor_Shoulderless))
							base.icon = 'Saiyan_Armor_Shoulderless_Base.dmi'
							base.icon *= basecolorz
							item:basecolor = basecolorz
						else if(istype(o,/obj/items/tech/armors/Kid_Saiyan_Armor_Shoulderless))
							base.icon = 'Saiyan_Armor_Shoulderless_kid_base.dmi'
							base.icon *= basecolorz
							item:basecolor = basecolorz
						else if(istype(o,/obj/items/tech/armors/Saiyan_Armor_Full))
							base.icon = 'Saiyan_Armor_Full_Base.dmi'
							base.icon *= basecolorz
							item:basecolor = basecolorz
						else if(istype(o,/obj/items/tech/armors/Kid_Saiyan_Armor_Full))
							base.icon = 'Saiyan_Armor_Full_kid_base.dmi'
							base.icon *= basecolorz
							item:basecolor = basecolorz
						//	lens.filters += filter(type="color", color=lenscolor)

						item.vis_contents += base
						item.overlays += base
						item:armor_health = lvl
						item.desc_extra = "Armor Quality: [lvl]   Health:[item:armor_health]\n\n"
						end

						//item.filters += filter(type="color", color=basecolor)

					else if(istype(o,/obj/items/tech/Scouters/))
						var/lenscolor = input("Select a color") as color
						var/obj/lens = new/obj
						if(istype(o,/obj/items/tech/Scouters/Kid_Scouter))
							lens.icon = 'scouter_lens_kid.dmi'
							lens.icon *= lenscolor
							item:lenscolor = lenscolor
						//	lens.filters += filter(type="color", color=lenscolor)
						if(istype(o,/obj/items/tech/Scouters/Scouter))
							lens.icon = 'scouter_lens.dmi'
							lens.icon *= lenscolor
							item:lenscolor = lenscolor
							//lens.filters += filter(type="color", color=lenscolor)
						item.vis_contents += lens
						item.overlays += lens

					/*else if(istype(o, /obj/items/tech/Scouter) || src.build_tech.type == /obj/items/tech/Scouter)
						var/icon/finali = new // Final icon
						var/newcolor = input("Choose a color:") as color

						// Define the color you want to replace (e.g., gray or black)
						var/oldcolor = rgb(84, 84, 84) // Replace this with the color in your icon
						var/oldcolor2 = rgb(0,0,0)
						var/list/states = list(
							"", "KB", "Flight", "Train", "Fall", "KO",
							"2HCharge", "2HBlast", "Meditate", "Power upF", "Power up",
							"Superform", "RPunch", "LPunch", "RKick", "LKick",
							"Block", "1HCharge", "1HBlastR", "1HBlastL"
						)

						for(var/state in states)
							var/icon/base = icon('item_scouter.dmi', state)

							// Replace all pixels matching oldcolor with newcolor
							base.MapColors(list(oldcolor = newcolor))
							base.MapColors(list(oldcolor2 = newcolor))

							finali.Insert(base, state)

						item.icon = finali
						*/

					if(istype(item,/obj/items/tech/Power_Line))
						var/obj/items/tech/Power_Line/pl = item
						pl.built = 1
					//item.loc = i.loc
					if(item.pixel_x > 0) item.step_x = abs(item.pixel_x)/2
					if(src.build_tech.type == /obj/items/tech/Conveyor_Belt)
						item.dir = src.dir
					if(istype(item,/obj/items/drugs/) == 1)
						if(lvl<=3400)
							item.tech_lvl = 3400
						else item.tech_lvl = lvl
					//	for(var/obj/items/tech/sub_tech/Genetics/Drug_Synthesis/DS in global.tech)//src.technology_researched)
							//item.tech_lvl = src.tech_lvls[DS.list_pos]//DS.tech_lvl
							//item.level = lvl
						//	break
					if(istype(item,/obj/items/tech/doors/) == 1)
						item.icon = o.icon
						if(winget(src,"confirm","is-visible") == "false")
							winset(src,"numbers.label_numbers","text=\"Set door password.\"")
							winshow(src,"numbers",1)
							src.numbers_text = "set door password"
							src.left_click_ref = item
					item.alpha = 100
					item.pixel_z = 32
					item.level = lvl
					if(item.needs_to_be_active) item.active = 1
					item.desc += "([item.level]%)"
				//	item.tech_lvl = lvl
					animate(item, pixel_z = initial(item.pixel_z), alpha = 255,time = 2, easing = BOUNCE_EASING)
					//spawn(1)
					//	if(item) item.set_shadow()
					for(var/obj/x in item.loc)
						if(x != item)
							if(istype(x,/obj/items/tech/Power_Line) && istype(src.build_tech,/obj/items/tech/Power_Line))
								src << "There is already a powerline there."
								del(item)
								return
					items += item
					src.client.images -= src.build_mouse
					sleep(1)
					var/obj/effects/dust_medium/d = new
					d.SetCenter(item)
					sleep(1)
					if(src.build_mouse) src.client.images += src.build_mouse

					/*
					var/image/txt = image(null,src,null,1000)
					txt.maptext_x = 14
					txt.maptext_y = 50
					txt.maptext_width = 128
					txt.filters += filter(type="outline", size=1, color=rgb(0,0,0))
					var/total_val = 0
					for(var/obj/items/resources/r in src)
						txt.maptext = "[Commas(r.value)]<font color = red> - [Commas(val)]"
						total_val = r.value
					src.overlays += txt
					var/tens = 0
					var/target = total_val-o.value
					while(total_val != target)
						total_val -= 1
						tens += 1
						if(tens == 100)
							tens = 0
							src.overlays -= txt
							txt.maptext = "[Commas(total_val)]<font color = red> - [Commas(val)]"
							src.overlays += txt
							sleep(0.1)
					src.overlays -= txt
					txt.maptext = "[Commas(total_val)]"
					src.overlays += txt
					spawn(15)
						if(src && txt)
							src.overlays -= txt
							del(txt)
					*/
				else
					src << "Not enough resources."
					src.set_alert("Not enough resources",'alert.dmi',"alert")

		get_drug_fail_chance(var/lvl)
			var/int_val = lvl  // or whatever your real int var is
			var/fail = 80

			if(int_val >= 10000) fail = 1
			else if(int_val >= 9000) fail = 5
			else if(int_val >= 7500) fail = 10
			else if(int_val >= 4500) fail = 20
			else if(int_val >= 3000) fail = 40
			else if(int_val >= 1500) fail = 60
			else fail = 80

			return fail

		reset_estimates()
			if(src.started)
				winset(src,null,"sense.label_img.image=;sense.bar_hp.value=100;sense.bar_eng.value=100;sense.lab_psi.text=\"???\";sense.lab_name.text=;sense.lab_str.text=\"???\";sense.lab_end.text=\"???\";sense.lab_agility.text=\"???\";sense.lab_acc.text=\"???\";sense.lab_def.text=\"???\";sense.lab_force.text=\"???\";sense.lab_recov.text=\"???\";sense.lab_res.text=\"???\";sense.lab_regen.text=\"???\"")


		StopSounds()
			//Stops all MIDI and sound effects played for this mob.
			if(!src.key || !src.client) return

			src << sound(null)
		update_rsc()
			if(src.hud_inv) src.hud_inv.update_rsc(src)
		//	if(src.hud_tech) src.hud_tech.rsc(src)
		estimates()
			if(src.started)
				var/mob/m = src.target
				var/scanneron=0
				var/est_m = round((m.psionic_power/src.psionic_power)*100)
				est_m = "[est_m]%"
				for(var/obj/items/tech/Scouters/s in src)
					if(s.suffix)
						var/max_pp = s.level*1000
						if(m.psionic_power > max_pp) est_m = "???"
						else est_m = "[Commas(m.psionic_power)]"
						scanneron=1
						break

				if(src.client) winset(src,"sense.lab_psi","text=\"[est_m]\"")
				if(src.skill_sense && src.skill_sense.active && !scanneron)



					if(src.client)
						src << output(null,"sense.grid_sense")
						src << output(m,"sense.grid_sense:1,1")

						//winset(src,"sense.bar_psi","value=[round(est_src/2)]")

						if(src.client) winset(src,"sense.lab_psi","text=\"[est_m]\"")
						if(src.client) winset(src,"sense.lab_name","text=\"[m.name]\"")


					var/see_stat = 0
					var/e_strength = "???"
					var/e_endurance = "???"
					var/e_agility = "???"
					var/e_offence = "???"
					var/e_defence = "???"
					var/e_force = "???"
					var/e_regen = "???"
					var/e_res = "???"
					var/e_recov = "???"

					if(src.trait_ta) see_stat = 10

					//Estimate strength
					if(m.id in src.remembers_strength) see_stat += 1
					if(see_stat)
						//var/e_src = round((src.strength/m.strength)*100)
						e_strength = round((m.strength/src.strength)*100)
						//winset(src,"sense.bar_str","value=[round(e_src/2)]")
						//winset(src,"sense.lab_str","text=\"[e_m]%\"")
						see_stat -= 1
					//else winset(src,"sense.lab_str","text=\"???\"")

					//Estimate endurance
					if(m.id in src.remembers_endurance) see_stat += 1
					if(see_stat)
						//var/e_src = round((src.endurance/m.endurance)*100)
						e_endurance = round((m.endurance/src.endurance)*100)
						//winset(src,"sense.bar_end","value=[round(e_src/2)]")
						//winset(src,"sense.lab_end","text=\"[e_m]%\"")
						see_stat -= 1
					//else winset(src,"sense.lab_end","text=\"???\"")

					//Estimate agility
					if(m.id in src.remembers_agility) see_stat += 1
					if(see_stat)
						//var/e_src = round((src.mod_agility/m.mod_agility)*100)
						e_agility = round((m.mod_agility/src.mod_agility)*100)
						//winset(src,"sense.bar_str","value=[round(e_src/2)]")
						//winset(src,"sense.lab_agility","text=\"[e_m]%\"")
						see_stat -= 1
					//else winset(src,"sense.lab_agility","text=\"???\"")

					//Estimate offence
					if(m.id in src.remembers_offence) see_stat += 1
					if(see_stat)
						//var/e_src = round((src.offence/m.offence)*100)
						e_offence = round((m.offence/src.offence)*100)
						//winset(src,"sense.bar_off","value=[round(e_src/2)]")
						//winset(src,"sense.lab_acc","text=\"[e_m]%\"")
						see_stat -= 1
					//else winset(src,"sense.lab_acc","text=\"???\"")

					//Estimate defence
					if(m.id in src.remembers_defence) see_stat += 1
					if(see_stat)
						//var/e_src = round((src.defence/m.defence)*100)
						e_defence = round((m.defence/src.defence)*100)
						//winset(src,"sense.bar_def","value=[round(e_src/2)]")
						//winset(src,"sense.lab_def","text=\"[e_m]%\"")
						see_stat -= 1
					//else winset(src,"sense.lab_def","text=\"???\"")

					//Estimate force
					if(m.id in src.remembers_force) see_stat += 1
					if(see_stat)
						//var/e_src = round((src.force/m.force)*100)
						e_force = round((m.force/src.force)*100)
						//winset(src,"sense.bar_force","value=[round(e_src/2)]")
						//winset(src,"sense.lab_force","text=\"[e_m]%\"")
						see_stat -= 1
					//else winset(src,"sense.lab_force","text=\"???\"")

					//Estimate recovery
					if(m.id in src.remembers_recovery) see_stat += 1
					if(see_stat)
						//var/e_src = round((src.mod_recovery/m.mod_recovery)*100)
						e_recov = round((m.mod_recovery/src.mod_recovery)*100)
						//winset(src,"sense.bar_recov","value=[round(e_src/2)]")
						//winset(src,"sense.lab_recov","text=\"[e_m]%\"")
						see_stat -= 1
					//else winset(src,"sense.lab_recov","text=\"???\"")

					//Estimate resistance
					if(m.id in src.remembers_resistance) see_stat += 1
					if(see_stat)
						//var/e_src = round((src.resistance/m.resistance)*100)
						e_res = round((m.resistance/src.resistance)*100)
						//winset(src,"sense.bar_res","value=[round(e_src/2)]")
						//winset(src,"sense.lab_res","text=\"[e_m]%\"")
						see_stat -= 1
					//else winset(src,"sense.lab_res","text=\"???\"")

					//Estimate regen
					if(m.id in src.remembers_regeneration) see_stat += 1
					if(see_stat)
						//var/e_src = round((src.mod_regeneration/m.mod_regeneration)*100)
						e_regen = round((m.mod_regeneration/src.mod_regeneration)*100)
						//winset(src,"sense.bar_regen","value=[round(e_src/2)]")
						//winset(src,"sense.lab_regen","text=\"[e_m]%\"")
						see_stat -= 1
					//else winset(src,"sense.lab_regen","text=\"???\"")

					for(var/obj/hud/menus/sense_box_advanced/a in src.sense_boxes)
						for(var/obj/o in a)
							o.maptext = "<font size = 1>Offence: [e_offence]%\nDefence: [e_defence]%\nStrength:[e_strength]%\nEndurance: [e_endurance]%\nForce: [e_force]%\nResistance: [e_res]%\nAgility: [e_agility]%\nRegeneration: [e_regen]%\nRecovery: [e_recov]%"
							break
		create_stance(var/obj/skills/Create_Stance/s)
			var/StanceName


			switch(input("What kind of stance are you creating?") in list ("All Around","Offense","Defense"))
				if("All Around")
					StanceName = input ("What will you name this stance?") as text
					if(StanceName == "")
						alert(usr,"Name cannot be blank.")
						return
					var/offbonus = input ("How much points will you put into [StanceName]'s offense?\n Max Points: [usr.stance_points]") as num
					if(offbonus>usr.stance_points)
						offbonus = usr.stance_points
					if(offbonus<=-0) offbonus=0
					var/remainder = (usr.stance_points-offbonus)
					var/defbonus = input ("How much points will you put into [StanceName]'s defense?\n Max Points: [remainder]") as num
					if(defbonus>(usr.stance_points-offbonus))
						defbonus = usr.stance_points-offbonus
					if(defbonus<=-0) defbonus=0

					switch(alert(usr,"[StanceName] | [offbonus*0.02]x Offense multiplier, [defbonus*0.02]x Defense multiplier, do you wish to create this stance?","","Yes","No"))
						if("Yes")

							var/datum/custom_stance/customstance = new
							customstance.name = StanceName
							customstance.power = (offbonus+defbonus)*0.50
							customstance.stance_type = "All Around"
							usr.stance_points-=(offbonus+defbonus)
							if(!(locate(/obj/skills/Stance) in src))
								var/obj/skills/Stance/ss=new(src)
								ss.customs += customstance  // Add custom
							else
								if(src.skill_stance)
									src.skill_stance.customs += customstance
								else
									if(s)
										s.customs += customstance


							usr<<output("You have created a new stance: <b>[customstance.name]</b>","actionoutput")
							return


				if("Offense")
					StanceName = input ("What will you name this stance?") as text
					if(StanceName == "")
						alert(usr,"Name cannot be blank.")
						return
					var/offbonus = input ("How much points will you put into [StanceName]'s offense?\n Max Points: [usr.stance_points]") as num
					if(offbonus>usr.stance_points)
						offbonus = usr.stance_points
					if(offbonus<=-0) offbonus=0

					switch(alert(usr,"[StanceName] | [offbonus*0.02]x Offense multiplier, do you wish to create this stance?","","Yes","No"))
						if("Yes")

							var/datum/custom_stance/customstance = new
							customstance.name = StanceName
							customstance.power = (offbonus*0.02)
							customstance.stance_type = "Offence"

							if(!(locate(/obj/skills/Stance) in src))
								var/obj/skills/Stance/ss=new(src)
								ss.customs += customstance  // Add custom
							else
								if(src.skill_stance)
									src.skill_stance.customs += customstance
								else
									if(s)
										s.customs += customstance

							usr.stance_points-=(offbonus)
							usr<<output("You have created a new stance: <b>[customstance.name]</b>","actionoutput")
							return

				if("Defense")
					StanceName = input ("What will you name this stance?") as text
					if(StanceName == "")
						alert(usr,"Name cannot be blank.")
						return
					var/defbonus = input ("How much points will you put into [StanceName]'s defense?\n Max Points: [usr.stance_points]") as num
					if(defbonus>(usr.stance_points))
						defbonus = usr.stance_points
					if(defbonus<=-0) defbonus=0

					switch(alert(usr,"[StanceName] | [defbonus*0.02]x Defense multiplier, do you wish to create this stance?","","Yes","No"))
						if("Yes")

							var/datum/custom_stance/customstance = new
							customstance.name = StanceName
							customstance.power = (defbonus*0.02)
							customstance.stance_type = "Defence"

							if(!(locate(/obj/skills/Stance) in src))
								var/obj/skills/Stance/ss=new(src)
								ss.customs += customstance  // Add custom
							else
								if(src.skill_stance)
									src.skill_stance.customs += customstance
								else
									if(s)
										s.customs += customstance

							usr.stance_points-=(defbonus)
							usr<<output("You have created a new stance: <b>[customstance.name]</b>","actionoutput")
							return
		create_android(var/obj/skills/Create_Android/s)

			var/afford = 1
			var/efficiency = src.efficiency_skill

			var/titanium_cost = get_discounted_cost(1000, efficiency)
			var/mystille_cost = get_discounted_cost(2500, efficiency)
			var/coal_cost = get_discounted_cost(1200, efficiency)
			var/gold_cost = get_discounted_cost(400, efficiency)
			var/silver_cost = get_discounted_cost(1200, efficiency)
			var/copper_cost = get_discounted_cost(1600, efficiency)
			var/stone_cost = get_discounted_cost(3000, efficiency)

			var/list/required_metals = list(
				"Stone" = stone_cost,
				"Copper" = copper_cost,
				"Coal" = coal_cost,
				"Silver" = silver_cost,
				"Gold" = gold_cost,
				"Titanium" = titanium_cost,
				"Mystille" = mystille_cost
			)

			// Check resources
			for(var/material in required_metals)

				var/required_amount = required_metals[material]
				if(required_amount <= 0) continue

				var/inventory_amount = src.count_material(material)

				if(inventory_amount < required_amount)
					afford = 0
					src << "You lack the required [material]! Needed: [required_amount], You have: [inventory_amount]."
					src.set_alert("Missing [material]", 'alert.dmi', "alert")
					break

			if(src.key == "VOXTECH")
				src.set_alert("Admin Pass: Android created!", 'alert.dmi', "alert")
				afford = 1

			if(!afford) return
			var/lvltomake = input("Quality %:") as num
			if(lvltomake <=0 || lvltomake <=-0) return
			if(lvltomake >= src.intxp)
				src.set_alert("You cannot manifest tech of that quality",'alert.dmi',"alert")
				src<<"You cannot manifest tech of that quality!"
				return

		//	var/val = o.value*val_multi
		//	if(src.trait_ic) val/=2
			src.update_rsc()
			if(afford)

				var/mob/races/Android/newandroid = new/mob/races/Android
				switch(input(src,"Select the mineral for their skin profile. This is purely aesthetic.") in list ("Stone","Copper","Coal","Silver","Titanium","Gold","Mystille"))
					if("Stone")
						newandroid.icon = 'android_default.dmi'
					if("Copper")
						newandroid.icon = 'android_copper.dmi'
					if("Coal") newandroid.icon = 'android_coal.dmi'
					if("Silver") newandroid.icon = 'android_silver.dmi'
					if("Titanium") newandroid.icon = 'android_titanium.dmi'
					if("Gold") newandroid.icon = 'android_gold.dmi'
					if("Mystille") newandroid.icon = 'android_mystille.dmi'
				for (var/material in required_metals)
					var/required_amount = required_metals[material]
					if (required_amount > 0)
						src.remove_material(material, required_amount)
				//var/obj/item = new o.type(src.loc)
				src.update_rsc()
				var/chosenname = input("What will you name this Android?") as text
				switch(input(src,"Will you give them a password?") in list ("Yes","No"))
					if("Yes")
						var/setpassword = input("What is the password?(Note: This will be for players to create into this android, keep your password safe!)") as text
						newandroid.pw = setpassword
				newandroid.loc = src.loc
				newandroid.name = "[chosenname]"
				newandroid.owner = src.real_name
				if(newandroid.pixel_x > 0) newandroid.step_x = abs(newandroid.pixel_x)/2
				newandroid.alpha = 100
				newandroid.pixel_z = 32

			//	item.tech_lvl = lvl
				animate(newandroid, pixel_z = initial(newandroid.pixel_z), alpha = 255,time = 2, easing = BOUNCE_EASING)
				spawn()
					if(newandroid)
						newandroid.eye_c = src.eye_c
						newandroid.hair_c = src.hair_c
						newandroid.hair_pos = src.hair_pos
						newandroid.ear_pos = src.ear_pos
						newandroid.skin_pos = src.skin_pos
						newandroid.horn_pos = src.horn_pos
						newandroid.expand_icon = src.expand_icon
						newandroid.eye_pos = src.eye_pos
						newandroid.nose_pos = src.nose_pos
						newandroid.mouth_pos = src.mouth_pos
						newandroid.body_pos = src.body_pos
						newandroid.save_icon = src.save_icon
						newandroid.rng_android_mods_and_pg(src)
						ActiveChildren += newandroid
						var/savefile/F = new("saves/ChildrenandAndroids/ActiveChildren.bdb")
						F["ActiveChildren"] << ActiveChildren
					//	s.started = 1
						//s.choosing_character = 0
					//	s.create_login_menus()
						newandroid.set_shadow()




mob/proc/fplm_checker()
	//set background = 1
	if(!started) return
	if(src.in_fplm)
		if(src.psionic_power_base < src.final_powerlevel_mod)
			src.in_fplm = 0
			return
	else if(!src.in_fplm)
		if(src.psionic_power_base >= src.final_powerlevel_mod)
			src.in_fplm = 1
			src<<"<b>You have unlocked the true depths of your power!</b>"
			return
// Core beard logic

// Periodic beard check
mob/proc/beard_checker()
	if(src.age < 21 || src.has_beard) return

	switch(src.race)
		if("Saiyan")
			if(src.age >= 25)
				src.apply_beard_growth(0.35, 0.50, 0.75)
		if("Human")
			if(src.age >= 21)
				src.apply_beard_growth(0.25, 0.50, 0.75)
		if("Tuffle")
			if(src.age >= 25)
				src.apply_beard_growth(0.35, 0.50, 0.75)




// Core beard application handler
mob/proc/apply_beard_growth(stage1, stage2, stage3)
	if(src.age <= (src.lifespan * stage1))
		src.set_beard_stage(1)
	else if(src.age <= (src.lifespan * stage2))
		src.set_beard_stage(2)
	else if(src.age <= (src.lifespan * stage3))
		src.set_beard_stage(3)
	else if(src.age <= src.lifespan)
		src.set_beard_stage(4)
	else if(src.age >= (src.lifespan + 2)) // 2 years into decline
		src.set_beard_stage(5)


// Sets the stage and refreshes in-game + portrait beards
mob/proc/set_beard_stage(stage)
	if(src.beard == stage) return

	src.beard = stage
	src.has_beard = 1

	var/icon_path = src.get_beard_icon(stage)
	src.beard_icon = icon_path

	var/portrait_path = src.get_portrait_beard_icon(stage)
	src.portrait_beard_icon = portrait_path

	src.update_beard_icon()
	src.update_icon(src)


// Returns in-game beard .dmi name
mob/proc/get_beard_icon(stage)
	var/prefix = "Beard_"
	var/midget_prefix = (src.midget ? "Midget_" : "")
	var/icon_name

	switch(stage)
		if(1) icon_name = "Moustache_Black.dmi"
		if(2) icon_name = "Goatee_Black.dmi"
		if(3) icon_name = "Short_Black.dmi"
		if(4) icon_name = "Full_Black.dmi"
		if(5) icon_name = "Big_Black.dmi"
		else return null

	return "[prefix][midget_prefix][icon_name]"


// Returns portrait beard icon name
mob/proc/get_portrait_beard_icon(stage)
	switch(stage)
		if(1) return "portrait_beard_moustache.dmi"
		if(2) return "portrait_beard_goatee.dmi"
		if(3) return "portrait_beard_short.dmi"
		if(4) return "portrait_beard_full.dmi"
		if(5) return "portrait_beard_big.dmi"
		else return null

mob/proc/remove_beard()
	if(src.beard_overlay)
		src.overlays -= src.beard_overlay
		src.beard_overlay = null

	src.beard = 0
	src.has_beard = 0
	src.beard_icon = null
	src.portrait_beard_icon = null

	src.update_icon(src)
	src.update_portrait_beard()

// Updates in-game beard overlay and recolors it
mob/proc/update_beard_icon()
	if(!src.beard_icon) return

	var/icon_file
	switch(src.beard_icon)
		if("Beard_Moustache_Black.dmi") icon_file = 'Beard_Moustache_Black.dmi'
		if("Beard_Midget_Moustache_Black.dmi") icon_file = 'Beard_Midget_Moustache_Black.dmi'
		if("Beard_Goatee_Black.dmi") icon_file = 'Beard_Goatee_Black.dmi'
		if("Beard_Midget_Goatee_Black.dmi") icon_file = 'Beard_Midget_Goatee_Black.dmi'
		if("Beard_Short_Black.dmi") icon_file = 'Beard_Short_Black.dmi'
		if("Beard_Midget_Short_Black.dmi") icon_file = 'Beard_Midget_Short_Black.dmi'
		if("Beard_Full_Black.dmi") icon_file = 'Beard_Full_Black.dmi'
		if("Beard_Midget_Full_Black.dmi") icon_file = 'Beard_Midget_Full_Black.dmi'
		if("Beard_Big_Black.dmi") icon_file = 'Beard_Big_Black.dmi'
		if("Beard_Midget_Big_Black.dmi") icon_file = 'Beard_Midget_Big_Black.dmi'

	if(!icon_file) return

	// Remove old beard overlay
	if(src.beard_overlay)
		src.overlays -= src.beard_overlay
		src.beard_overlay = null

	// Build new recolored beard overlay
	var/icon/I = icon(icon_file)
	if(src.hair_c)
		I.Blend(src.hair_c, ICON_MULTIPLY)

	var/image/new_beard = image(icon = I)
	src.beard_overlay = new_beard
	src.overlays += src.beard_overlay
	src.update_icon(src)
	// Update portrait too
	//src.update_portrait_beard()


// Builds & applies recolored portrait beard overlay
mob/proc/update_portrait_beard()
	if(!src.portrait_beard_icon) return

	var/icon_file
	switch(src.portrait_beard_icon)
		if("portrait_beard_moustache.dmi") icon_file = 'portrait_beard_moustache.dmi'
		if("portrait_beard_goatee.dmi") icon_file = 'portrait_beard_goatee.dmi'
		if("portrait_beard_short.dmi") icon_file = 'portrait_beard_short.dmi'
		if("portrait_beard_full.dmi") icon_file = 'portrait_beard_full.dmi'
		if("portrait_beard_big.dmi") icon_file = 'portrait_beard_big.dmi'

	if(!icon_file) return

	var/icon/I = icon(icon_file,"",SOUTH,1,0)
	I.Scale(128,128)
	if(src.hair_c)
		I.Blend(src.hair_c, ICON_MULTIPLY)

	//src.portrait_beard_overlay = I

	/*
	// Apply to portrait if your system uses update_portrait_transform()
	if(src.hud_char && src.port)
		var/icon/portrait = src.hud_char.portrait_icon
		portrait.Blend(I, ICON_OVERLAY)
		src.hud_char.portrait_icon = portrait
		sleep(1)
		src.hud_char.update_portrait_transform() */

	// === Apply beard to portrait ===
	if(src && src.has_beard && src.beard_icon)
		var/icon/beard_icon_portrait
		switch(src.beard)
			if(1) beard_icon_portrait = 'portrait_beard_moustache.dmi'
			if(2) beard_icon_portrait = 'portrait_beard_goatee.dmi'
			if(3) beard_icon_portrait = 'portrait_beard_short.dmi'
			if(4) beard_icon_portrait = 'portrait_beard_full.dmi'
			if(5) beard_icon_portrait = 'portrait_beard_big.dmi'

		if(beard_icon_portrait)
			var/icon/B = icon(beard_icon_portrait, "", SOUTH, 1, 0)
			//B.Scale(128, 128)
			if(src.hair_c)
				B.Blend(src.hair_c, ICON_MULTIPLY)
			I.Blend(B, ICON_OVERLAY, 1, 13)
			src.hud_char.vis_contents += B
			src.hud_char.update_portrait_transform()

mob/verb/emote_button_click()
	usr.overlays -= 'roleplay_alert.dmi'
	usr.overlays += 'roleplay_alert.dmi'

	var/Secs_Open = world.time / 10

	var/msg = input("Emote") as message

	if(!msg)
		usr.overlays -= 'roleplay_alert.dmi'
		return

	//var/icon/I = usr.getIconImage()
	//var/Old_Sight=see_invisible
	//	see_invisible=101
	var/speaker_color = usr.text_color_ic ? usr.text_color_ic : "#FFFFFF"
	var/Secs_Close = world.time / 10
	Secs_Close -= Secs_Open
	//	src.RP_Actual = msg
	msg = quotify(msg,speaker_color)
	//	var/officialmsg
	var/icon/PI = usr.GetPortraitIcon()
	var/portrait_ref = null

	if(PI)
		portrait_ref = fcopy_rsc(PI)

	var/RP = rand(0.08,0.15)
	for(var/mob/M in hearers(20,usr))
		if(!M || !M.client) continue
		/*if(M.observed)
			for(var/mob/player/P in Players)
				if(P.observee==M)
					if(P.client)
						P<<output("<span class=\"emote\"><b><font size=[M.TextSize]><font color=yellow>*</font> (OBSERVE) | [usr.name] <font color='yellow'>[src.ICText(msg, M)]*</font></span>", "rpoutput")*/
		if(M.client)
			if(RP < 0.005)
				RP += 0.0005
			//	officialmsg = "<span class=\"emote\"><b><font color=yellow>*</font> [usr.name] <font color='yellow'>[usr.ICText(msg, M)]*</font> (" + roleplay_link + ")</span>"

			//M<<output("<span class=\"emote\"><b><font size=3<font color=yellow>*</font> <font color = [usr.text_color_ic]>[M.get_strangername(usr)]</font> <font color='yellow'>[usr.ICText(msg, usr)]","actionoutput")
			var/portrait_html = ""
			if(portrait_ref)
				portrait_html = "<img src='\ref[portrait_ref]' width=64 height=82 style='vertical-align:middle;'> "

			M << output("<span class=\"emote\"><b>[portrait_html]<font color=yellow>*</font> <font color=[usr.text_color_ic]>[M.get_strangername(usr)]</font> <font color='yellow'>[usr.ICText(msg, usr)]*</font></span>", "actionoutput")


			//officialmsg = "<span class=\"emote\"><b><font color=yellow>*</font> [usr.name] <font color='yellow'>[usr.ICText(msg, M)]*</font></span>"



	usr.Check_RP(msg,RP,Secs_Close,"Emote")
	world<<output("<font color=[speaker_color]>[usr]([usr.key]) RP: *[usr.ICText(msg, usr)]*</font>\n","rpspy.output2")
	//	see_invisible=Old_Sight
	//for(var/mob/player/MM in Players) if(MM.client.holder)	MM << output("<br> <span class=\"emote\">*[src] [msg]*</span>\n","rpspy.output1")

	usr.overlays -= 'roleplay_alert.dmi'
	usr.Roleplay_Spark()
	usr.overlays.Remove('roleplay_alert.dmi')
	if(usr.rp_mode == "Phase" && usr.phase_ready && usr.phased)
		if(prob(75))
			usr.overlays -= usr.phase_icon
			usr.phased=0
			usr.phase_ready=0
	return


// Sync beard color to hair color
mob/proc/update_beard_color_from_hair()
	if(src.has_beard)
		src.update_beard_icon()
		src.update_portrait_beard()
// Background process for aging and beard evolution
mob/proc/beard_growth()
	set background = 1
	while(src)
		sleep(36000) // Roughly one in-game month or year tick depending on your system
		src.age++
		src.beard_checker()


mob/proc/ScouterScan(var/mob/targ,var/obj/items/tech/Scouters/T)
	//src<<output("<font color=green>----------\nScanning...</font>","actionoutput")
	sleep(5)
	ScouterUpdate(src,targ,T)


proc/ScouterUpdate(var/mob/ScannerOwner,var/mob/ScannerTarget,var/obj/items/tech/Scouters/SaveUsable)

	var/tmp/NumShownReal
	var/randChannel=rand(1,1000)
	SaveUsable.AllowedScan=0
	NumShownReal=round(ScannerTarget.psionic_power)
	NumShownReal=ScannerOwner.OrganizadorDeNumeros(NumShownReal)
	view(ScannerOwner) << sound('scouter.ogg',channel = randChannel,volume=30)
	sleep(10)
	view(15,ScannerOwner) <<sound('scouterbeeps.ogg',0,channel=randChannel)
	if((round(ScannerTarget.psionic_power))<=((SaveUsable.level/200*5000)))
		var/rounded_power
		if(ScannerTarget.psionic_power >= 100000000)
			rounded_power = round(ScannerTarget.psionic_power / 1000000) * 1000000
		else
			if(ScannerTarget.psionic_power >= 10000000)
				rounded_power = round(ScannerTarget.psionic_power / 100000) * 100000
			else
				if(ScannerTarget.psionic_power >= 1000000)
					rounded_power = round(ScannerTarget.psionic_power / 10000) * 10000
				else
					if(ScannerTarget.psionic_power >= 100000)
						rounded_power = round(ScannerTarget.psionic_power / 1000) * 1000
					else
						if(ScannerTarget.psionic_power >=1000)
							rounded_power = round(ScannerTarget.psionic_power / 100) * 100
						else
							if(ScannerTarget.psionic_power >=100)
								rounded_power = round(ScannerTarget.psionic_power / 10) * 10
							else
								rounded_power = round(ScannerTarget.psionic_power)
		//NumShownReal=round((ScannerTarget.BP))
		NumShownReal=round(rounded_power)
		NumShownReal=ScannerOwner.OrganizadorDeNumeros(NumShownReal)
		if(ScannerTarget.koed==1||ScannerTarget.icon_state=="KO") NumShownReal=0
		view(15,ScannerOwner) << sound('scouterend.ogg',channel = randChannel)
		ScannerOwner<<output("<font color=green>Power Level: [(CommasADV(round(rounded_power)))]</font>","actionoutput")
		ScannerOwner<<output("<font color=green>Scanning Complete!\n-----------</font>","actionoutput")

	else
		ScannerOwner.DestroyScouter(ScannerOwner,SaveUsable);
		view(ScannerOwner) << sound('scouterexplode.ogg',channel = randChannel,volume=20)
		ScannerOwner<<output("<font color=green>Power Level: ERR0R 0V3RL0~#@!%!</font>","actionoutput")
		ScannerOwner<<output("<font color=green>Scanning Failed!\n-----</font>","actionoutput")

		for(var/mob/P in view(ScannerOwner))
			P << output("<font color=red>[P.real_name]'s scouter suddenly explodes!</font>", "actionoutput")
		SaveUsable.suffix = null
		//i.name = "Scouter(Kid)"
		SaveUsable.layer = initial(SaveUsable.layer)
		ScannerOwner.redraw_appearance()
		ScannerOwner.overlays -= SaveUsable.icon
		ScannerOwner.scouter_on = 0
		ScannerOwner.update_icon(ScannerOwner)

	spawn(50)
		SaveUsable.AllowedScan=1
mob/proc/DestroyScouter(mob/ScannerOwner,obj/items/tech/Scouters/X)
	ScannerOwner.scouter_crushes += 1
	remove_overlays(ScannerOwner,X.icon)
	X.remove_item_from_inventory(ScannerOwner,X)
	//X.suffix=null
	//X.loc=null

mob/proc/OrganizadorDeNumeros(var/NumShown)
	var/tmp/NumCalcPrint
	var/tmp/contadorCasasS=0
	if(round(NumShown)>=100000)
		do
			NumShown=round(NumShown/1000)
			contadorCasasS++
		while(round(NumShown)>=1000)
	switch(contadorCasasS)
	//123000000
	//NumShown="[round(LifeExperienceShown/1000**contadorCasas)]"
		if(1)
			NumCalcPrint=",000"
		if(2)
			NumCalcPrint=",000,000"
		if(3)
			NumCalcPrint=",000,000,000"
		if(4)
			NumCalcPrint="Trillion"
		if(5)
			NumCalcPrint="Quadrillion"
		if(6)
			NumCalcPrint="Quintillion"
		if(7)
			NumCalcPrint="Sextillion"
		if(8)
			NumCalcPrint="Septillion"
		if(9)
			NumCalcPrint="Octillion"
	NumShown="[NumShown]"+"[NumCalcPrint]"
	return NumShown

//General fix stuff
mob/proc/update_gravity(var/mob/player)
	if(!player.hud_stats.mastered_grav)
		world.log << "Rating bar is null for [player]"
		return

	var/last_display = player.hud_stats.mastered_grav.maptext
	var/new_rating = "[css_outline]<font size = 1><left>x[player.grav]<font color = white> | x[round(player.gravity_mastered,0.1)]"

	if(last_display != new_rating)
		player.hud_stats.mastered_grav.maptext = null
		player.hud_stats.mastered_grav.maptext = new_rating



mob/proc/update_rating(var/mob/player)
	if(!player.hud_stats.mod_power)
		world.log << "Rating bar is null for [player]"
		return

	var/last_display = player.hud_stats.mod_power.maptext
	var/new_rating = "[css_outline]<font size = 1><left>[css_rating][Commas(player.rating)]"

	if(last_display != new_rating)
		player.hud_stats.mod_power.maptext = null
		player.hud_stats.mod_power.maptext = new_rating


mob/proc/update_qp(var/mob/player)
	if(!player.hud_stats.mod_agility)
		world.log << "Rating bar is null for [player]"
		return

	var/last_display = player.hud_stats.mod_agility.maptext
	var/new_rating = "[css_outline]<font size = 1><left>[css_lift][round((player.strength+player.endurance*4)*0.45359237)*0.01] kg ([round(player.strength+player.endurance*4)*0.01] lbs)"


	if(last_display != new_rating)
		player.hud_stats.mod_agility.maptext = null
		player.hud_stats.mod_agility.maptext = new_rating



mob/proc/admin_setup()
    if (src.client.admin_setup_done)
        src << "You’ve already configured your admin profile."
        return

    // 1️⃣  Filter available colors (unclaimed)
    var/list/available_colors = list()
    for (var/c in AdminColorProfiles)
        available_colors += c

    if (!available_colors.len)
        src << "No available color profiles left — contact the owner to add more."
        return

    var/choice_color = input(src, "Choose your Admin Color Profile", "Admin Setup") as null|anything in available_colors
    if (!choice_color) return

    // Claim it
    //AdminColorProfiles[choice_color] = src.ckey

    src.client.admin_color = AdminColorProfiles[choice_color]
    AdminColorProfiles -= choice_color



    // 2️⃣  Choose icon type
    //var/list/icons = list("Default" = 'NewMaleColorable.dmi', "Feline Humanoid" = 'Cat_Male_Adult_fix.dmi', "Canine Humanoid" = 'Dog_Base.dmi', "Floating Cat" = 'Floating_Cat_Base_Gray.dmi')
    var/list/icons = list("Default", "Feline Humanoid", "Canine Humanoid", "Floating Cat")
    var/choice_icon = input(src, "Choose your Admin Icon", "Admin Setup") as null|anything in icons
    if (!choice_icon)
        // free color if they cancel here
        AdminColorProfiles[choice_color] = null
        src.client.admin_color = null
        return

    src.client.admin_icon_type = choice_icon
    src.client.admin_setup_done = 1
    save_admin_profile(src.client)


    // 3️⃣  Confirm
    alert(src, "Setup complete!\n\nYour profile: [src.client.admin_color] using [src.client.admin_icon_type] icon.\nYou can now enter admin mode by pressing the 'F3' key", "Admin Setup", "OK")



mob/proc/open_chest(var/resources, var/tier)
    if(!src) return

    // Minerals in the exact order you display them
    var/list/mineral_names = list("Stone","Copper","Coal","Titanium","Gold","Silver","Mystille")
    var/list/generated = list()

    // Create minerals exactly like Dig does
    for(var/mineral_name in mineral_names)
        var/path = mineral_paths[mineral_name]
        if(!path) continue

        var/obj/items/minerals/min = new path(src.loc)
        min.stacks = rand(resources / 2, resources)

        // --- CRITICAL FIX ---
        // Dig minerals ALWAYS have correct inven_state / icon_state BEFORE stacking.
        if(min.inven_state)
            min.icon_state = min.inven_state
        else
            min.inven_state = initial(min.icon_state)

        // Dig minerals always have tech_lvl defined
        if(isnull(min.tech_lvl)) min.tech_lvl = 0

        generated += min

    sleep(1)

    // Stack them the same way Dig stacks
    for(var/obj/items/minerals/min in generated)
        src.digging_mins(min, 1)


    sleep(1)

    // Build output the same way your Dig popup works
    var text = "<b>--Treasure Chest([tier])--</b><br>"
    for(var/mineral_name in mineral_names)
        // find the generated mineral by name
        for(var/obj/items/minerals/min in generated)
            if(min.name == mineral_name)
                text += "<b>[min.name]:</b> [min.stacks]<br>"
                break

    src << output(text, "actionoutput")
mob/proc/Check_Injuries()
	if(src.hud_body)
		src.hud_body.color_paperdoll(src)

mob/verb/ExitGame()
	set hidden = 1
	usr.client.images = null
	winset(usr, null, "command=.quit")
	usr.client.Del()
mob/proc/ValidatePassiveTree()

    if(!hud_unlocks) return

    var/obj/hud/menus/unlocks_background/bg = hud_unlocks
    if(!bg) return

    // What should be there
    var/list/should_have = list()
    for(var/obj/traits/T in global.learnable_traits)
        should_have += T

    // What is currently visible
    var/list/current = list()
    for(var/obj/O in bg.holder_special.vis_contents)
        if(istype(O, /obj/traits))
            current += O

    // Add missing ones
    for(var/obj/traits/T in should_have)
        if(!(T in current))
            bg.holder_special.vis_contents += T

		/*create_android(var/obj/skills/Create_Android/s)
			var/afford=1
			//var/discount = s.skill_lvl
			//var/has_all_materials = 1
			var/titanium_cost = 1000 //* val_multi
			var/mystille_cost = 2500 //* val_multi
			var/coal_cost = 1200 //* val_multi
			var/gold_cost = 400 //* val_multi
			var/silver_cost = 1200 //* val_multi
			var/copper_cost = 1600 //* val_multi
			var/stone_cost = 3000 //* val_multi
			var/required_metals = list(
				"Stone" = stone_cost,
				"Copper" = copper_cost,
				"Coal" = coal_cost,
				"Silver" = silver_cost,
				"Gold" = gold_cost,
				"Titanium" = titanium_cost,
				"Mystille" = mystille_cost,
			)
			for (var/material in required_metals)
				var/required_amount = required_metals[material]
				//if (required_amount > 0) // Skip if no cost for this material
				var/inventory_amount = src.count_material(material)
				if (inventory_amount < required_amount)
					afford=0
					src << "You lack the required [material]! Needed: [required_amount], You have: [inventory_amount]."
					src.set_alert("You lack the required [material] needed: [required_amount], You have: [inventory_amount]",'alert.dmi',"alert")
					src<<"You lack the required [material] needed: [required_amount], You have: [inventory_amount]"
					break
			if(src.key == "VOXTECH")
				src.set_alert("Admin Pass: Android created!",'alert.dmi',"alert")
				afford = 1
			if(!afford) return
			var/lvltomake = input("Quality %:") as num
			if(lvltomake <=0 || lvltomake <=-0) return
			if(lvltomake >= src.intxp)
				src.set_alert("You cannot manifest tech of that quality",'alert.dmi',"alert")
				src<<"You cannot manifest tech of that quality!"
				return

		//	var/val = o.value*val_multi
		//	if(src.trait_ic) val/=2
			src.update_rsc()
			if(afford)

				var/mob/races/Android/newandroid = new/mob/races/Android
				switch(input(src,"Select the mineral for their skin profile. This is purely aesthetic.") in list ("Stone","Copper","Coal","Silver","Titanium","Gold","Mystille"))
					if("Stone")
						newandroid.icon = 'android_default.dmi'
					if("Copper")
						newandroid.icon = 'android_copper.dmi'
					if("Coal") newandroid.icon = 'android_coal.dmi'
					if("Silver") newandroid.icon = 'android_silver.dmi'
					if("Titanium") newandroid.icon = 'android_titanium.dmi'
					if("Gold") newandroid.icon = 'android_gold.dmi'
					if("Mystille") newandroid.icon = 'android_mystille.dmi'
				for (var/material in required_metals)
					var/required_amount = required_metals[material]
					if (required_amount > 0)
						src.remove_material(material, required_amount)
				//var/obj/item = new o.type(src.loc)
				src.update_rsc()
				var/chosenname = input("What will you name this Android?") as text
				switch(input(src,"Will you give them a password?") in list ("Yes","No"))
					if("Yes")
						var/setpassword = input("What is the password?(Note: This will be for players to create into this android, keep your password safe!)") as text
						newandroid.pw = setpassword
				newandroid.loc = src.loc
				newandroid.name = "[chosenname]"
				newandroid.owner = src.real_name
				if(newandroid.pixel_x > 0) newandroid.step_x = abs(newandroid.pixel_x)/2
				newandroid.alpha = 100
				newandroid.pixel_z = 32

			//	item.tech_lvl = lvl
				animate(newandroid, pixel_z = initial(newandroid.pixel_z), alpha = 255,time = 2, easing = BOUNCE_EASING)
				spawn()
					if(newandroid)
						newandroid.eye_c = src.eye_c
						newandroid.hair_c = src.hair_c
						newandroid.hair_pos = src.hair_pos
						newandroid.ear_pos = src.ear_pos
						newandroid.skin_pos = src.skin_pos
						newandroid.horn_pos = src.horn_pos
						newandroid.expand_icon = src.expand_icon
						newandroid.eye_pos = src.eye_pos
						newandroid.nose_pos = src.nose_pos
						newandroid.mouth_pos = src.mouth_pos
						newandroid.body_pos = src.body_pos
						newandroid.save_icon = src.save_icon
						newandroid.rng_android_mods_and_pg(src)
						ActiveChildren += newandroid
						var/savefile/F = new("saves/ChildrenandAndroids/ActiveChildren.bdb")
						F["ActiveChildren"] << ActiveChildren
					//	s.started = 1
						//s.choosing_character = 0
					//	s.create_login_menus()
						newandroid.set_shadow()
						*/


