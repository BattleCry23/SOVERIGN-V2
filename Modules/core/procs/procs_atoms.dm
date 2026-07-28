obj/ship_interior_spawner
	New()
		..()  // Call parent constructor
		//GenerateShipInterior()
var/global/list/ship_instances = list()

proc/auraalignment(var/mob/m)
	if(m)
		//Negative Auras
		if(m.aura_alignment <= -5&&m.aura_alignment>=-1) return "Vulgar"
		if(m.aura_alignment <= -15&&m.aura_alignment>=-6) return "Tainted"
		if(m.aura_alignment <= -30&&m.aura_alignment>=-16) return "Corrupt"
		if(m.aura_alignment <= -50&&m.aura_alignment>=-31) return "Extremely Tainted"
		if(m.aura_alignment <= -75&&m.aura_alignment>=-51) return "Faithless"
		if(m.aura_alignment <= -100&&m.aura_alignment>=-76) return "Blackened"
		if(m.aura_alignment <= -115&&m.aura_alignment>=-101) return "Hellspawn"
		if(m.aura_alignment <= -150&&m.aura_alignment>=-116) return "Pure Darkness"
		if(m.aura_alignment <= -150) return "Pure Darkness"

		if(m.aura_alignment >0 && m.aura_alignment < 5) return "Neutral"
		//Positive Auras
		if(m.aura_alignment >5 && m.aura_alignment < 25) return "Honest"
		if(m.aura_alignment >25 && m.aura_alignment < 40) return "Pure"
		if(m.aura_alignment >40 && m.aura_alignment <65) return "Righteous"
		if(m.aura_alignment >65 && m.aura_alignment <80) return "Extremely Pure"
		if(m.aura_alignment >80 && m.aura_alignment <100) return "Virtuous"
		if(m.aura_alignment >100 && m.aura_alignment <115) return "Sinless"
		if(m.aura_alignment >115 && m.aura_alignment <150) return "Heavenly"
		if(m.aura_alignment >=150) return "Enlightened"
proc/get_turf(atom/A)
    if(!A) return null

    // If it's already a turf, just return it
    if(isturf(A))
        return A

    // If it's inside something, climb upward until we find the turf
    if(A.loc)
        return get_turf(A.loc)

    // No turf found
    return null

/*proc/LoadPreBuiltShipInterior(ship_id, ship_interior)
    var/turf/origin = locate(10,10,2)  // Example pre-built interior location
    var/width = 10
    var/height = 10

    for (var/x = 0; x < width; x++)
        for (var/y = 0; y < height; y++)
        {
            var/turf/T = locate(origin.x + x, origin.y + y, origin.z)
            if (T)
            {
                var/turf/newT = new T.type(ship_interior, x + 1, y + 1, ship_interior.z)
                CopyObjects(T, newT)  // Copies objects inside
            }
        }
        */
mob/proc/heal_limb(var/limb_name)
    if(!src.bodyparts || !length(src.bodyparts)) return 0

    var/index = 0

    switch(limb_name)
        if("Head") index = 1
        if("Torso") index = 2
        if("Left Arm") index = 3
        if("Right Arm") index = 4
        if("Right Leg") index = 5
        if("Left Leg") index = 6

    if(!index) return 0

    var/list/limb_container = src.bodyparts[index]
    if(!limb_container) return 0

    // Restore each internal part (bones, muscles, etc.)
    for(var/obj/body_related/part in limb_container)
        part.hp = part.hp_max
        part.damaged = 0
        part.disabled = 0

        if(src.hurt_limbs && part in src.hurt_limbs)
            src.hurt_limbs -= part

    // If limb was previously maimed, restore it
    if(src.maimed)
        src.restore_limb_if_missing(limb_name)

    // Refresh visuals
    if(src.hud_body)
        src.hud_body.color_paperdoll(src)

    src.update_limb_hud()

    return 1
mob/proc/restore_limb_if_missing(var/limb_name)
    var/index = 0

    switch(limb_name)
        if("Left Arm") index = 3
        if("Right Arm") index = 4
        if("Right Leg") index = 5
        if("Left Leg") index = 6

    if(!index) return

    var/list/container = src.bodyparts[index]
    if(!container || length(container) > 0) return // Already exists

    // Recreate base limb object
    var/obj/body_related/new_limb = new /obj/body_related/bodyparts
    new_limb.name = limb_name
    new_limb.hp = new_limb.hp_max

    container += new_limb

    src.maimed = 0
/*mob/proc/heal_all_limbs(var/heal_amount)
	for(var/list/limb_group in src.bodyparts)
		for(var/obj/body_related/bodyparts/p in limb_group)
			if(p.hp < p.hp_max && !p.disabled)
				p.hp = min(p.hp + heal_amount, p.hp_max)
				if(p.damaged && p.hp >= p.hp_max * 0.5)
					src.damage_part(p, 0, "", 0) // heal
	src.hud_body?.color_paperdoll(src)
	*/
proc/locate_main_limb_part(var/mob/player, var/limb_index)
	if(!player.bodyparts || !player.bodyparts[limb_index]) return null
	for(var/obj/body_related/bodyparts/p in player.bodyparts[limb_index])
		if(findtext("[p.type]", "bone")) // crude but works for now
			return p
	return null


proc/is_limb_missing(var/mob/player, var/limb_index)
	if(!player.bodyparts || !player.bodyparts.len || !limb_index) return 1
	return (player.bodyparts[limb_index].len == 0)


proc/apply_limb_damage(var/mob/player, var/limb_index, var/damage_amount)
	if(!player || !player.body || !player.body.len || !limb_index) return
	for(var/obj/body_related/bodyparts/p in player.body[limb_index])
		if(p.disabled) continue
		p.hp -= damage_amount
		if(p.hp <= 0 && !p.damaged)
			player.damage_part(p, 1, "broken", 1)



// Applies a temporary bleeding effect to a mob
mob/proc/apply_bleeding(var/damage_per_tick, var/duration = 20)
	if(src.bleeding) return // already bleeding, no stack
	var/obj/effects/blood_splatter/blood = new/obj/effects/blood_splatter(src.loc)
	blood.loc = src.loc

	src.bleeding = 1
	var/ticks = round(duration / 2) // 1 tick = roughly 0.5 sec if world.tick_lag = 1
	if(!damage_per_tick) damage_per_tick = 0.5

	spawn while(ticks-- > 0 && src && src.percent_health > 0)
		// Apply bleeding damage
		src.percent_health -= damage_per_tick
		src.flash_red()
		sleep(2)
		// Small blood splatter effect


	src.bleeding = 0

/proc/BuildItemTypeCache()
	ALL_ITEM_TYPES = list()

	for(var/path in typesof(/obj/items))
		if(path == /obj/items)
			continue

		// If this type has children, it's not concrete
		if(typesof(path).len > 1)
			continue

		ALL_ITEM_TYPES += path

	world.log << "Cached [ALL_ITEM_TYPES.len] concrete item types."



/*proc/get_limb_health(var/mob/player, var/limb_index)
	var/health = 0
	var/max_health = 0
	if(!player || !player.body || !player.body.len) return 100
	for(var/obj/body_related/bodyparts/p in player.body[limb_index])
		if(p.disabled || p.damaged) continue
		health += p.hp
		max_health += p.hp_max
	if(max_health <= 0) return 100
	return round((health / max_health) * 100)*/

proc/get_limb_health(var/mob/player, var/obj/body_related/bodyparts/L)
    if(!player || !L) return 100
    if(L.hp_max <= 0) return 100
    return round((L.hp / L.hp_max) * 100)

mob/proc/update_limb_hud()
    if(!src.body) return

    for(var/obj/body_related/bodyparts/L in src.body)
        var/health = get_limb_health(src, L)
        var/hud_id = get_limb_hud_id(L)
        if(hud_id)
            winset(src, hud_id, "value=[health]")
/*mob/proc/update_limb_hud()
	for(var/limb_index in body)
		var/health = get_limb_health(src, limb_index)
		var/hud_id = get_limb_hud_id(limb_index) // Write this function
		winset(src, hud_id, "value=[health]")

		*/
mob/proc/get_limb_hud_id(var/obj/body_related/bodyparts/L)
    switch(L.name)
        if("Left Arm")  return "hud.leftarm_bar"
        if("Right Arm") return "hud.rightarm_bar"
        if("Left Leg")  return "hud.leftleg_bar"
        if("Right Leg") return "hud.rightleg_bar"
    return null

mob/proc/heal_all_limbs()
    if(!src.body) return

    for(var/obj/body_related/bodyparts/L in src.body)
        L.hp = L.hp_max

    src.update_limb_hud()

    if(src.hud_body)
        src.hud_body.color_paperdoll(src)
    return 1
proc
	check_maim_limb(var/mob/attacker, var/obj/body_related/bodyparts/limb, var/mob/target, var/adminpass = 0)
		if(!limb || !attacker || !target)
			//world<<"No attacker or target, or limb."
		//	if(!limb) world<<"No limb"
			//if(!attacker) world<<"No attacker"
			//if(!target) world<<"no target."
			return

	//	if(!(limb.name in list("Left Arm", "Right Arm", "Left Leg", "Right Leg","left arm","right arm","left leg","right leg","rightleg","leftleg","rigtharm","leftarm")))
	///		world<<"no limb name."

		//	return // Skip maiming for non-limbs like torso/head
		if(!adminpass)
			if(limb.hp > 0) return
		//if(limb.hp > 0 && !adminpass|| !limb.status != "Broken" && !adminpass || !limb.disabled && !adminpass)
			//return // Can't maim unless limb is already broken or disabled
	//	world<<"Limb HP:[limb.hp] | Limb Status: [limb.status]"

		// Combat power comparison (adjust formula as you desire)
		if(adminpass)
			target.maim_limb(limb,attacker)

		else
			var/attacker_power = attacker.strength * attacker.mod_strength * (attacker.psionic_power || 1)
			var/defender_resist = target.endurance * target.mod_defence * (target.psionic_power || 1)

			var/maim_chance = clamp(round((attacker_power / max(defender_resist, 1)) * 10), 5, 90)

			if(prob(maim_chance))
				target.maim_limb(limb, attacker)


	/// Destroys the specified limb, removing it from bodyparts and HUD entirely.
/*mob/proc
	maim_limb(var/obj/body_related/limb, var/mob/attacker)
		if(!limb || !src.body || !limb in src.body) return

		// Announce the maim
		view(15, src) << output("[src]'s [limb.name] was torn off!", "actionoutput")

		// Find and remove from bodyparts lists
		for(var/obj/body_related/bp in src.body)
			if(limb in bp.contents)
				bp.contents -= limb
				break

		// Remove from hurt limbs list
		if(src.hurt_limbs && limb in src.hurt_limbs)
			src.hurt_limbs -= limb

		// Remove from paperdoll HUD (use your `bodyparts_background` ref)
		//if(src.hud_paperdoll)
		//	src.hud_paperdoll.remove_limb_doll(limb.name)
		if(src.hud_body)
			src.hud_body.remove_limb_doll(limb.name)
		// Permanently destroy the limb
		spawn_dropped_limb(limb, src)
		limb.destroy()
		limb.loc = null*/

mob/proc/maim_limb(var/obj/body_related/bodyparts/L, var/mob/attacker)

    if(!L || !(L in src.body)) return

    view(15, src) << output("[src]'s [L.name] was torn off!", "actionoutput")

    if(src.hurt_limbs && L in src.hurt_limbs)
        src.hurt_limbs -= L

    if(src.hud_body)
        src.hud_body.remove_limb_doll(L.name)

    spawn_dropped_limb(L, src)

    src.body -= L
    qdel(L)

    src.update_limb_hud()

proc/get_limb_item_type(var/limb_name)
	switch(limb_name)
		if("left arm","Left Arm") return /obj/items/skins/Left_Arm
		if("right arm","Right Arm") return /obj/items/skins/Right_Arm
		if("left leg","Left Leg") return /obj/items/skins/Left_Leg
		if("right leg","Right Leg") return /obj/items/skins/Right_Leg
		if("head") return /obj/items/skins/Head
		if("torso") return /obj/items/skins/Torso
	return null

proc/spawn_dropped_limb(var/obj/body_related/limb, var/mob/m)
	var/obj/items/skins/type_path = get_limb_item_type(limb.name)
	if(!type_path) return
	var/turf/T
	for(var/turf/A in orange(1,m))
		if(isturf(A))
			T = A
			break
	if(!istype(T))
		return
//	world<<"SPAWNING LIMB"


	var/icon/base_icon = icon(m.icon)
	//var/icon/body_icon = icon(m.icon)

	switch(limb.name)
		if("left arm","Left Arm")
			var/obj/items/skins/Left_Arm/L = new type_path(T)
			base_icon.Crop(9, 16, 12,9)
			L.layer = T.layer + 1
			L.icon = base_icon
		//	L.set_shadow()
			spawn(1) apply_limb_mask_by_age(m, "Left Arm")
		if("right arm","Right Arm")
			var/obj/items/skins/Right_Arm/L = new type_path(T)
			base_icon.Crop(21, 9, 26,17)
			L.layer = T.layer + 1
			L.icon = base_icon
		//	L.set_shadow()
			spawn(1) apply_limb_mask_by_age(m, "Right Arm")

		if("left leg","Left Leg")
			var/obj/items/skins/Left_Leg/L = new type_path(T)
			base_icon.Crop(17, 1, 32,8)
			L.layer = T.layer + 1
			L.icon = base_icon
			//L.set_shadow()
			spawn(1) apply_limb_mask_by_age(m, "Left Leg")

		if("right leg","Right Leg")
			var/obj/items/skins/Right_Leg/L = new type_path(T)
			base_icon.Crop(9, 1, 15,8)
			L.layer = T.layer + 1
			L.icon = base_icon
		//	L.set_shadow()
			spawn(1) apply_limb_mask_by_age(m, "Right Leg")

	m.maimed = 1

proc/remove_limb_from_icon(var/mob/M, var/which_limb)
	var/icon/I = icon(M.icon)
	var/dir = M.dir

	switch(which_limb)
		if("right arm","Right Arm")
			switch(dir)
				if(SOUTH) I.DrawBox(rgb(0,0,0,0), 22, 9, 26, 17)
				if(EAST)  I.DrawBox(rgb(0,0,0,0), 24, 9, 28, 17)
				if(NORTH) I.DrawBox(rgb(0,0,0,0), 22, 10, 26, 17)
				if(WEST)  I.DrawBox(rgb(0,0,0,0), 21, 9, 25, 17)

		if("Left Arm")
			switch(dir)
				if(SOUTH) I.DrawBox(rgb(0,0,0,0), 6, 9, 10, 17)
				if(EAST)  I.DrawBox(rgb(0,0,0,0), 4, 9, 8, 17)
				if(NORTH) I.DrawBox(rgb(0,0,0,0), 6, 10, 10, 17)
				if(WEST)  I.DrawBox(rgb(0,0,0,0), 7, 9, 11, 17)

		if("Right Leg")
			switch(dir)
				if(SOUTH, EAST, NORTH, WEST) I.DrawBox(rgb(0,0,0,0), 19, 1, 24, 8)

		if("Left Leg")
			switch(dir)
				if(SOUTH, EAST, NORTH, WEST) I.DrawBox(rgb(0,0,0,0), 9, 1, 14, 8)

	M.icon = I


 // WORKING ONE THAT TAKES ALL ICON STATES AND DIRECTIONS
proc/export_limb_icon(var/mob/m, var/which_limb)
	if(!m || !m.icon)
		m << "❌ Invalid mob or missing icon."
		return

	//world << "🧩 Starting export for [which_limb]..."
	var/icon/full_icon = new(m.icon)
	var/icon/icon_out = new()

	var/list/coords = list()
	coords["SOUTH"] = alist("Right Arm" = list(22, 9, 26, 17), "Left Arm" = list(9, 16, 12, 9), "Right Leg" = list(19, 1, 24, 8), "Left Leg" = list(9, 1, 14, 8))
	coords["EAST"] = alist("Right Arm" = list(23, 9, 27, 17), "Left Arm" = list(6, 16, 10, 9), "Right Leg" = list(20, 1, 25, 8), "Left Leg" = list(8, 1, 13, 8))
	coords["NORTH"] = alist("Right Arm" = list(22, 10, 26, 17), "Left Arm" = list(9, 16, 12, 9), "Right Leg" = list(19, 1, 24, 8), "Left Leg" = list(9, 1, 14, 8))
	coords["WEST"] = alist("Right Arm" = list(21, 9, 25, 17), "Left Arm" = list(6, 9, 10, 17), "Right Leg" = list(18, 1, 23, 8), "Left Leg" = list(10, 1, 15, 8))
	for(var/state in full_icon.IconStates())
	//	world << "⚙️ Processing state: [state]"
		var/icon/new_state = new()

		for(var/d in list(SOUTH, EAST, NORTH, WEST))
			var/dir_key = "SOUTH"
			switch(d)
				if(EAST) dir_key = "EAST"
				if(NORTH) dir_key = "NORTH"
				if(WEST) dir_key = "WEST"

			var/list/crop = coords[dir_key][which_limb]
			if(!crop)
				continue

			var/icon/tmp = new(full_icon, state, d)
			tmp.Crop(crop[1], crop[2], crop[3], crop[4])
			new_state.Insert(tmp, icon_state=state, dir=d)

		icon_out.Insert(new_state, icon_state=state)

	// ✅ write to a safe temporary file first
	var/tmp_name = "limb_exports/tmp_[which_limb].dmi"
	var/f = file(tmp_name)
	f << icon_out

	/// ✅ Save as a real file using resource copy trick
	//var/file_path = "limb_exports/[which_limb]_exported.dmi"

	// First, make sure folder exists
	if(!fexists("limb_exports"))
		fdel("limb_exports") // just in case, clear invalid ref
	//	world << "📁 Creating limb_exports/ directory manually may be required."



	// ✅ Preview safely (browse_rsc doesn’t interfere now)
	m << browse_rsc(icon_out, "[which_limb]_preview.dmi")

	var/html = "<center><b>[which_limb] Exported Icon States</b><hr>"
	for(var/state in icon_out.IconStates())
		html += "<div><b>[state]</b><br><img src='[which_limb]_preview.dmi' icon_state='[state]'><br><br></div>"
	html += "</center>"

	m << browse(html, "window=preview;size=400x600")

// =============================================================
// Universal Limb Mask Application System
// Uses render_target + render_source alpha masking
// =============================================================

// Master proc to apply a mask based on limb + age
proc/apply_limb_mask_by_age(var/mob/m, var/which_limb)
	if(!m || !which_limb)
		return
	// 🔹 Decide icon file based on limb + age group
	var/icon_file
	var/render_id

	switch(which_limb)
		if("Left Arm", "left arm")
			icon_file = (m.age < 13) ? 'Modules/limbs/generics/leftarm_kid.dmi' : 'Modules/limbs/generics/leftarm_adult.dmi'
			render_id = "*LEFTARM_MASK"

		if("Right Arm", "right arm")
			icon_file = (m.age < 13) ? 'Modules/limbs/generics/rightarm_kid.dmi' : 'Modules/limbs/generics/rightarm_adult.dmi'
			render_id = "*RIGHTARM_MASK"

		if("left leg","Left Leg")
			icon_file = (m.age < 13) ? 'Modules/limbs/generics/leftleg_kid.dmi' : 'Modules/limbs/generics/leftleg_adult.dmi'
			render_id = "*LEFTLEG_MASK"

		if("Right Leg", "right leg")
			icon_file = (m.age < 13) ? 'Modules/limbs/generics/rightleg_kid.dmi' : 'Modules/limbs/generics/rightleg_adult.dmi'
			render_id = "*RIGHTLEG_MASK"


	// 🔹 Call the core helper that actually applies the render mask
	apply_limb_mask(m, icon_file, render_id)




proc/apply_limb_mask(var/mob/m, var/mask_icon, var/render_id)
	if(!m || !mask_icon) return

	// Create the mask object (invisible to players)
	var/obj/mask_obj = new()
	mask_obj.icon = mask_icon
	mask_obj.icon_state = "" // it’ll automatically follow mob’s icon states
	mask_obj.dir = m.dir
	mask_obj.appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
	mask_obj.render_target = render_id  // this is the "camera feed" name
	mask_obj.alpha = 255
	mask_obj.layer = m.layer + 0.1 // slightly above the mob to render cleanly
	//m.vis_contents += mask_obj
	m.overlays += mask_obj

	// Now, apply the visual filter to remove anything under white areas
	m.filters += filter(type="alpha", render_source=render_id, flags=MASK_INVERSE)

proc/remove_limb_mask(var/mob/m, var/which_limb)
	if(!m) return

	var/render_id
	switch(which_limb)
		if("Left Arm")  render_id = "*LEFTARM_MASK"
		if("Right Arm") render_id = "*RIGHTARM_MASK"
		if("Left Leg")  render_id = "*LEFTLEG_MASK"
		if("Right Leg") render_id = "*RIGHTLEG_MASK"

	if(!render_id)
		m << "⚠️ Unknown limb: [which_limb]"
		return

	// 🔹 Remove overlay with matching render_target
	for(var/obj/o in m.overlays)
		if(o && o.render_target == render_id)
			m.overlays -= o
			qdel(o)

	// 🔹 Remove matching filters
	for(var/f in m.filters)
		if(islist(f) && f["render_source"] == render_id)
			m.filters -= f

	//m << "🩹 [which_limb] restored successfully!"



/*
proc/export_limb_icon(var/mob/m, var/which_limb)
	if(!m || !m.icon)
		m << "❌ Invalid mob or missing icon."
		return
	m.dir = "SOUTH"
	var/icon/I = icon(m.icon)
	//I.SetDir(SOUTH)
	m << "Limb Exporting Attempt: [which_limb]"

	var/icon/cropped
	switch(which_limb)
		if("Right Arm")
			I.Crop(22, 9, 26, 17)
		if("Left Arm")
			I.Crop(9, 16, 12, 9)
		if("Right Leg")
			I.Crop(19, 1, 24, 8)
		if("Left Leg")
			I.Crop(9, 1, 14, 8)
		else
			m << "❌ Invalid limb selection."
			return

//	if(!cropped)
	//	m << "❌ Cropping failed!"
	//	return

	// Create new icon with the cropped state
	var/icon/icon_out = new()
	icon_out.Insert(I, "preview")

	// Save to server-side folder
	var/savefile/F = new("limb_exports/[which_limb]_exported.dmi")
	F["icon"] << icon_out
	world << "✅ Saved [which_limb]_exported.dmi to server files."

	// Send image to client cache so user can view it
	m << browse_rsc(icon_out, "[which_limb]_preview.dmi")
	m << browse("<center><b>[which_limb] Preview</b><br><img src='[which_limb]_preview.png'width=800 height=600></center>")
*/
/*
proc/export_limb_icon(var/mob/m, var/which_limb)
	var/icon/I = icon(m.icon)
	m<<"Limb Exporting Attempt: [which_limb]"
	switch(which_limb)
		if("Right Arm")
			//I.Crop(22, 9, 26, 17)
			//I.Insert(I.Crop(22, 9, 26, 17), "RIGHT_ARM")
			//var/savefile/F = new("limb_exports/[which_limb]_exported_test.dmi")
			//F << I.Insert(I.Crop(22, 9, 26, 17), "RIGHT_ARM")
			m << browse_rsc(I, "RightArm.png")
		if("Left Arm")  I.Crop(9, 16, 12, 9)
		if("Right Leg") I.Crop(19, 1, 24, 8)
		if("Left Leg")  I.Crop(9, 1, 14, 8)

	// Save it to disk as a DMI
	//var/icon/icon_out = new()
	I.Insert(I, "") // add it as a new state for safety

	var/savefile/F = new("limb_exports/[which_limb]_exported.dmi")
	F << I
	m << browse_rsc(I, "RightArm.png")
	world << "Exported limb icon to [which_limb]_exported.dmi"
*/
/*
proc/export_limb_icon(var/mob/m, var/which_limb)
    if(!m || !m.icon)
        world<<"cannot find mob or which limb!"
        return

    m << "Limb Exporting Attempt: [which_limb]"

    var/icon/full_icon = icon(m.icon)
    var/icon/cropped_icon = new()

    // Crop the relevant part into a new icon object with a state
    switch(which_limb)
        if("Right Arm") cropped_icon.Insert(full_icon.Crop(22, 9, 26, 17), "RIGHT_ARM")
        if("Left Arm")  cropped_icon.Insert(full_icon.Crop(9, 16, 12, 9), "LEFT_ARM")
        if("Right Leg") cropped_icon.Insert(full_icon.Crop(19, 1, 24, 8), "RIGHT_LEG")
        if("Left Leg")  cropped_icon.Insert(full_icon.Crop(9, 1, 14, 8), "LEFT_LEG")
        else
            m << "Invalid limb name."
            return

    // Save to a real .dmi file
    var/savefile/F = new("limb_exports/[which_limb]_exported.dmi")
    F << cropped_icon

    m << "Exported [which_limb] to [F.name]"

	*/
mob
	var
		list/stylometric_history = list()
mob/proc
	update_stylometric_history(var/new_fingerprint)
		if(length(stylometric_history) >= 10) // Keep last 10 entries
			stylometric_history.Cut(1,2) // Remove oldest entry
		stylometric_history += new_fingerprint

mob/proc
	get_average_stylometry()
		if(!stylometric_history.len) return null

		var/avg = list(
			"avg_word_length" = 0,
			"avg_sentence_length" = 0,
			"vocabulary_richness" = 0,
			"punctuation_freq" = 0,
			"functional_words_freq" = 0
		)

		for(var/entry in stylometric_history)
			for(var/key in avg)
				avg[key] += entry[key]

		for(var/key in avg)
			avg[key] /= stylometric_history.len

		return avg
proc/check_stylometric_deviation(var/mob/player, var/new_fingerprint)
	var/historical = player.get_average_stylometry()
	if(!historical)
		player.update_stylometric_history(new_fingerprint)
		return 0 // No previous data yet

	var/total_difference = 0
	var/keys_checked = 0

	for(var/key in historical)
		total_difference += abs(historical[key] - new_fingerprint[key])
		keys_checked += 1

	var/average_deviation = total_difference / keys_checked

	player.update_stylometric_history(new_fingerprint)

	return average_deviation



proc/CheckAntiRPT(var/text, var/mob/player)
    var/perplexity = calculate_perplexity(text)
    var/stylometry = analyze_style(text)
    var/deviation = check_stylometric_deviation(player, stylometry)

    var/threshold_perplexity = 50 // Example threshold value
    var/threshold_deviation = 1 // Example threshold value

    if(perplexity < threshold_perplexity || deviation > threshold_deviation)
        alert_staff(player, perplexity, deviation)
        return FALSE

    return TRUE

proc/alert_staff(var/mob/player, var/perplexity, var/deviation)
    for(var/mob/M in players)
        if(M.key in StaffTeam)
            M << "<font color=red>[player.key]</font> flagged by Anti-RPT | Perplexity: [perplexity] | Style deviation: [round(deviation*100)]%"
proc/save_text_directly_to_file(var/text, var/filename)
	var/escaped_text = replacetext(text, "\"", "\\\"")
	var/shell_cmd = {"echo "[escaped_text]" > [filename]"}
	shell(shell_cmd)
proc/run_external_python(var/script, var/inputfile, var/outputfile)
	var/command = "python3 [script] [inputfile] [outputfile]"
	shell(command)
proc/read_text_from_file(var/filename)
	var/result_file = file(filename)
	var/result_text = file2text(result_file)
	return result_text

proc/calculate_perplexity(var/text)
	var/inputfile = "input_text.txt"
	var/outputfile = "output_perplexity.txt"
	var/script = "perplexity_calculator.py"

	save_text_directly_to_file(text, inputfile)
	run_external_python(script, inputfile, outputfile)

	sleep(10) // short delay to ensure Python finishes writing result

	var/output = read_text_from_file(outputfile)

	var/perplexity_score = text2num(output)
	return perplexity_score


proc/analyze_style(text)
    // Save the RP text to a temporary file
    var/tempfile = "temp_rp.txt"
    var/f = file(tempfile)
    f << text
    f = null // Close the file to ensure data is written

    // Command to execute Python script
    var/command = "python3 stylometry_analyzer.py temp_rp.txt"
    var/result = world.Export(command)

    // Parse result (assuming the script returns a JSON string)
    var/fingerprint = json_decode(result)

    return fingerprint



/proc/calculate_efficiency_discount(efficiency_skill, max_discount = 0.90, scale_factor = 100)

	if(efficiency_skill <= 0)
		return 0

	var/percent = efficiency_skill / (efficiency_skill + scale_factor)

	return clamp(percent, 0, max_discount)
/proc/get_discounted_cost(original_cost, efficiency_skill)

	var/discount = calculate_efficiency_discount(efficiency_skill)

	var/new_cost = round(original_cost * (1 - discount))

	return max(new_cost, 1)
/proc/show_tech_costs(mob/m, obj/items/tech/w)
	var/efficiency = m.efficiency_skill
	var/stone = get_discounted_cost(w.stone_cost, efficiency)
	var/copper = get_discounted_cost(w.copper_cost, efficiency)
	var/coal = get_discounted_cost(w.coal_cost, efficiency)
	var/silver = get_discounted_cost(w.silver_cost, efficiency)
	var/gold = get_discounted_cost(w.gold_cost, efficiency)
	var/titanium = get_discounted_cost(w.titanium_cost, efficiency)
	var/mystille = get_discounted_cost(w.mystille_cost, efficiency)
	var/obj/I = m.hud_tech.txt
	var/power_needed = ""
	var/power_produced = ""
	var/can_upgrade = "No"
	var/can_move = "Yes"
	if(w.bolted > 1) can_move = "No"
	if(w.tech_upgradable > 0) can_upgrade = "Yes"
	if(w.uses > 0) power_needed = "Power Requirement: [w.uses]\n\n"
	if(w.generates > 0) power_produced = "Power Generated: [w.generates]\n\n"
	if(!I)
		winset(m, "tech.label_cost",
			"text=\"Needed Minerals: <text align=right valign=top> Stone: [stone]\nCopper: [copper]\nCoal: [coal]\nSilver: [silver]\nGold: [gold]\nTitanium: [titanium]\nMystille: [mystille]\n\n<text align=left valign=top>\"")
	else
		I.maptext = "[css_outline]<font size = 1><text align=center valign=top>[w.name]<text align=left valign=top>\n\nvalign=top> Stone: [stone]\nCopper: [copper]\nCoal: [coal]\nSilver: [silver]\nGold: [gold]\nTitanium: [titanium]\nMystille: [mystille]\n\n<text align=left valign=top>Tech Tree: [w.tech_tree]\n\nSubtech: [w.tech_subtech]\n\nCan Upgrade: [can_upgrade]\n\nMoveable: [can_move]\n\n[power_needed][power_produced][w.desc]"

proc/decimal_rand(min, max, precision=100)
	// Scale the range up (default 2 decimal places with 100)
	var/scaled_min = round(min * precision)
	var/scaled_max = round(max * precision)
	return rand(scaled_min, scaled_max) / precision

/proc/add_tspace(t, u)
	while(length(t) < u)
		t = "[t] "
	return t
/proc/dir2text(direction)
	switch(direction)
		if(1.0)
			return "North"
		if(2.0)
			return "South"
		if(4.0)
			return "East"
		if(8.0)
			return "West"
		if(5.0)
			return "NorthEast"
		if(6.0)
			return "SouthEast"
		if(9.0)
			return "NorthWest"
		if(10.0)
			return "SouthWest"
		else
	return

world/proc/SaveChildren()
	var/savefile/F = new("saves/ChildrenandAndroids/ActiveChildren.sav")
	F["ActiveChildren"] << ActiveChildren

world/proc/LoadChildren() if(fexists("saves/ChildrenandAndroids/ActiveChildren.sav"))
	var/savefile/F = new("saves/ChildrenandAndroids/ActiveChildren.sav")
	F["ActiveChildren"] >> ActiveChildren



world/proc/SaveBan()
	var/savefile/S=new("saves/BANS.sav")
	S["Bans"]<<ban_list

world/proc/LoadBan()
	if(fexists("saves/BANS.sav"))
		var/savefile/S=new("saves/BANS.sav")
		S["Bans"]>>ban_list


/proc/IsGuestKey(key)
	if (findtext(key, "Guest-", 1, 7) != 1) //was findtextEx
		return 0

	var/i, ch, len = length(key)

	for (i = 7, i <= len, ++i)
		ch = text2ascii(key, i)
		if (ch < 48 || ch > 57)
			return 0

	return 1

proc/browse_link(url,recipient,browse_options)
    recipient << browse(\
"<html><head></head><body onLoad=\"parent.location='[url]'\"></body></html>"\
,browse_options)


proc/FormatIntXP(num)
	if(!isnum(num)) return "???"

	if(num < 10)
		return "[round(num, 0.00001)]"
	else if(num < 100)
		return "[round(num, 0.0001)]"
	else if(num < 1000)
		return "[round(num, 0.001)]"
	else if(num < 10000)
		return "[round(num, 0.01)]"
	else if(num < 100000)
		return "[round(num, 0.1)]"
	else
		return "[round(num, 1)]"

/*
proc/SaveShipInterior(ship_id, ship_interior)
    var/list/data = list()

    for (var/turf/T in ship_interior)
    {
        var/list/turf_data = list(T.type, T.x, T.y)
        data += list(turf_data)

        for (var/obj/O in T.contents)
        {
            var/list/obj_data = list(O.type, O.x, O.y, O.vars)
            data += list(obj_data)
        }
    }

    world.Export("data/ship_interior/[ship_id].sav", data)

proc/LoadSavedShipInterior(ship_id, var/obj/ship_interior)
    var/list/data = world.Import("data/ship_interior/[ship_id].sav")
    if (!data) return

    for (var/entry in data)
    {
        if (length(entry) == 3) // Turf
        {
            var/type = entry[1]
            var/x = entry[2]
            var/y = entry[3]
            new type(ship_interior, x, y, ship_interior.z)
        }
        else if (length(entry) == 4) // Object
        {
            var/type = entry[1]
            var/x = entry[2]
            var/y = entry[3]
            var/vars = entry[4]

            var/obj/O = new type(ship_interior)
            O.x = x
            O.y = y

            for (var/v in vars)
                O.vars[v] = vars[v]
        }
    }



var/global/list/allocated_z_levels = list()
var/global/starting_instance_z = 20  // Start ship interiors from z-level 20
var/global/max_instance_z = 200  // Limit to avoid infinite z-levels

proc/FreeZLevel(z)
    if (z in allocated_z_levels)
        allocated_z_levels -= z
proc/CopyObjects(source_x, source_y, source_z, destination_x, destination_y, destination_z)
    for (var/x = 0; x < 57; x++) // Assuming a 57x36 ship size
        for (var/y = 0; y < 36; y++)
            for(var/mob/m in world)
                m.set_alert("Gathered 57x36 Ship Interior",'alert.dmi',"alert")

            var/obj/T = locate(source_x + x, source_y + y, source_z)
            if (T)

                // Copy the turf to the new ship instance
                for(var/mob/m in world)
                    m.set_alert("Testing NewT and NewO...Standby",'alert.dmi',"alert")
                var/obj/newT = new T.type(locate(destination_x + x, destination_y + y, destination_z))
                var/obj/newO = new T.type(newT)
                newO.dir = T.dir
                newO.icon = T.icon
                newO.icon_state = T.icon_state
                for(var/mob/m in world)
                    m.set_alert("NewO and NewT sanctioned.",'alert.dmi',"alert")
                // Copy objects inside the turf
                for (var/turf/O in range(57,T))

                    for(var/mob/m in world)
                        m.set_alert("Checking for turfs in obj contents.. Standby",'alert.dmi',"alert")
                    var/obj/newTT = new O.type(newT)
                    newTT.dir = O.dir
                    newTT.icon = O.icon
                    newTT.icon_state = O.icon_state
                    for(var/mob/m in world)
                        m.set_alert("Check Done",'alert.dmi',"alert")

                    for (var/v in O.vars)
                        newTT.vars[v] = T.vars[v]  // Copy all variables dynamically
                        for(var/mob/m in world)
                            m.set_alert("Vars established",'alert.dmi',"alert")
                for(var/mob/m in world)
                    m.set_alert("Successful Copy!",'alert.dmi',"alert")

                    */
proc/Apply_Solar_Flare_Blind(mob/target)
	if(!target || !target.client) return

	var/list/flare_color1 = list(1.4, 1.1, 0.6, 1.0, 1.2, 0.6, 0.6, 0.6, 0.4, 255)
	var/list/flare_color2 = list(1.2, 1.0, 0.5, 1.0, 1.0, 0.5, 0.5, 0.5, 0.3, 50.3)

	target.client.color = flare_color1
	animate(target.client, color = flare_color2, time = 13)
	animate(color = flare_color1, time = 6)
	animate(color = null, time = 80)


world/proc/set_hells_gravity()
    var/z_level = 6  // Dark Realm is on Z=12

    spawn()
        //world << "Applying Hell Gravity (Lower Level)..."
        for(var/y = 1 to 480)
            for(var/x = 1 to 480)
                var/turf/T = locate(x, y, z_level)
                if(T) T.grav = 10
            if(y % 10 == 0) sleep(0.05)  // Allow CPU breathing room every 10 rows


    world.log <<"Hell Gravity Created."

world/proc/set_dark_realm_gravity()
    var/z_level = 12  // Dark Realm is on Z=12

    spawn()
        //world << "Applying Dark Realm Gravity (Lower Level)..."
        for(var/y = 1 to 143)
            for(var/x = 1 to 400)
                var/turf/T = locate(x, y, z_level)
                if(T) T.grav = 9
            if(y % 10 == 0) sleep(0.05)  // Allow CPU breathing room every 10 rows

    spawn(2)
       // world << "Applying Dark Realm Gravity (Mid Level)..."
        for(var/y = 144 to 317)
            for(var/x = 1 to 480)
                var/turf/T = locate(x, y, z_level)
                if(T) T.grav = 18
            if(y % 10 == 0) sleep(0.05)  // Allow CPU breathing room every 10 rows

    spawn(3)
      //  world << "Applying Dark Realm Gravity (Upper Level)..."
        for(var/y = 318 to 480)
            for(var/x = 1 to 480)
                var/turf/T = locate(x, y, z_level)
                if(T) T.grav = 30
            if(y % 10 == 0) sleep(0.05)  // Allow CPU breathing room every 10 rows
    world.log <<"Dark Realm Gravity Created."

/*
proc/LoadPreBuiltShipInterior(var/obj/ship_interior_spawner/ship_interior)
    var/turf/origin = locate(24, 10, 15)  // Example prebuilt location on map
    CopyObjects(origin.x, origin.y, origin.z, 24, 11, ship_interior.z)  // Copy to new ship instance
    */
world/proc/orbit()
	set background = 1
	if(TheSun)
		for(var/obj/items/Planets/Mains/ms in world)
			if(ms.orbit_chance <= 10) // ~1% yearly chance for orbital adjustment
				var/orbit_direction = pick("towards_sun", "away", "sideways") // Randomized movement
				var/orbit_distance = rand(1,3) // Minimal step movement per year

				if(orbit_direction == "towards_sun")
					step_towards(ms, TheSun, orbit_distance) // Moves slightly towards the sun

				else if(orbit_direction == "away")
					step_away(ms, TheSun, orbit_distance) // Moves slightly away from the sun

				else if(orbit_direction == "sideways")
					var/side_step_dir = pick(NORTH, SOUTH, EAST, WEST)
					step(ms, side_step_dir, orbit_distance) // Slight left/right movement

				sleep(10)
				return

				// Ensuring a realistic long-term orbital drift
				// The planet should take ~500+ years to reach the Sun if it only moves forward


			else if(prob(ms.orbit_chance))
				switch(rand(1,6))
					if(1)
						var/orbit_direction = pick("towards_sun", "away", "sideways") // Randomized movement
						var/orbit_distance = rand(1,3) // Minimal step movement per year

						if(orbit_direction == "towards_sun")
							step_towards(ms, TheSun, orbit_distance) // Moves slightly towards the sun

						else if(orbit_direction == "away")
							step_away(ms, TheSun, orbit_distance) // Moves slightly away from the sun

						else if(orbit_direction == "sideways")
							var/side_step_dir = pick(NORTH, SOUTH, EAST, WEST)
							step(ms, side_step_dir, orbit_distance) // Slight left/right movement

						// Ensuring a realistic long-term orbital drift
						// The planet should take ~500+ years to reach the Sun if it only moves forward
						return
					if(3)
						var/orbit_direction = pick("towards_sun", "away", "sideways") // Randomized movement
						var/orbit_distance = rand(1,3) // Minimal step movement per year

						if(orbit_direction == "towards_sun")
							step_towards(ms, TheSun, orbit_distance) // Moves slightly towards the sun

						else if(orbit_direction == "away")
							step_away(ms, TheSun, orbit_distance) // Moves slightly away from the sun

						else if(orbit_direction == "sideways")
							var/side_step_dir = pick(NORTH, SOUTH, EAST, WEST)
							step(ms, side_step_dir, orbit_distance) // Slight left/right movement
						return
						// Ensuring a realistic long-term orbital drift
						// The planet should take ~500+ years to reach the Sun if it only moves forward
			sleep(10)
			return


var/cosmic_black_hole_server_limit = 2000

world/proc/start_galaxy()
	set background = 1
	set waitfor=0


	world<<"<center><b>-------Galaxy created-------</b></center>"
	/*while(1)
		if(cosmic_black_hole_server_limit)

			switch(rand(1,3))
				if(1)
					if(prob(1))
						cosmic_black_hole_server_limit -= 1
						var/obj/Cosmic_Black_Hole/cbh = new
						cosmic_holes += cbh
						cbh.loc = locate(rand(2,499),rand(3,488),16)
				if(2)
					if(prob(2))
						cosmic_black_hole_server_limit -= 1
						var/obj/Cosmic_Black_Hole/cbh = new
						cosmic_holes += cbh
						cbh.loc = locate(rand(2,499),rand(2,488),16)

		sleep(3000)*/

world/proc/start_world_clock()
	set background = 1
	set waitfor=0
	while(1)
		WorldTime+=1
		sleep(2)
world/proc/save_world_time()
	set background = 1
	var/savefile/S=new("saves/world/time.sav")
	S["World Time by clicks"] << WorldTime
	//world<<"Time Saved."
world/proc/load_world_time()
	set background = 1
	if(fexists("saves/world/time.sav"))
		var/savefile/S=new("saves/world/time.sav")
		S["World Time by clicks"] >> WorldTime
proc/Clean_Unused_Objects()
    for(var/obj/o in world)
        if(o.contents.len == 0 && !o.loc)
            qdel(o)
    sleep(10)  // Run every 10 seconds
    spawn(10) Clean_Unused_Objects()

atom
	proc
		destroy()
			if(ismovable(src))
				var/atom/movable/o = src
				for(var/obj/x in o)
					if(x.can_pocket)
						x.loc = o.loc
						x.step_x = o.step_x
						x.step_y = o.step_y
					else x.destroy()
				if(ismob(o.loc))
					var/mob/m = o.loc

					if(o == m.item_selected) m.item_selected = null
					if(o == m.mouse_down) m.mouse_down = null
					if(o == m.mouse_over) m.mouse_over = null
					if(o == m.left_click_ref) m.left_click_ref = null
					if(o == m.right_click_ref) m.right_click_ref = null
				else if(ismob(src))
					var/mob/m = src
					m.ref = null
					m.target = null
				else if(isobj(o))
					var/obj/ob = o
					ob.on = 0

				o.Move(null)
				o.loc = null
				o.used_by = null
				o.tag = null
				o.ki_owner = null
				o.owner = null
				o.particles = null
				o.vis_contents = null

			src.overlays = null
			src.underlays = null
			src.grabbed_by = null
			if(src.shadow)
				src.shadow.loc = null
				src.shadow = null
			if(src.reflection)
				src.reflection.loc = null
				src.reflection = null
			if(src in items) items -= src
			/*if(ismob(src.loc))
				var/mob/m = src.loc
				if(m.client) m.client.mob = null
			else
				var/mob/m = src
				if(m.client) m.client.mob = null*/

		/*
		cleanse_all_vars()
			for(var/V in src.vars)
				var/atom/VV = src.vars[V]
				if(ismovable(VV))
					var/atom/movable/o = VV
					o.filters = null
					o.particles = null
					//world << "Found [o]"
					for(var/V2 in o.vars)
						var/atom/VV2 = o.vars[V2]
						if(ismovable(VV2))
							var/atom/movable/o2 = VV2
							//world << "Found2 [o2]"
							o2.filters = null
							o2.particles = null
		*/
		throw_damage(var/mob/lobee, var/Damage,var/mob/lobber)
			set background = 1
			var/randomlimb
			for(var/obj/body_related/bodyparts/t in lobee.bodyparts)
				randomlimb = pick(t)
			if(lobber.srs_mode) lobee.damage_limb(lobber,0, 1, Damage, randomlimb) //Normal
			else if(prob(25)) lobee.damage_limb(lobber,0,1,Damage,randomlimb)
		throwing(var/atom/dest,var/mob/thrower,var/degree,var/turf/t)
			var/atom/movable/A = src
			var/DIR = thrower.dir
			A.dir = DIR
			  // 50% of travel distance
			//thrower.gain_stat("strength",1,1,"Throwing")
			//thrower.gain_stat("power",1,2,"Throwing")
			var/DIST = round(get_dist(thrower,t)*3)

			if(tk) DIST = A.travel
			A.KB = DIST
			A.density_factor = 2
			A.thrown_str = thrower.strength*thrower.mod_str_usage
			A.thrown_offence = thrower.offence
			A.lobber = thrower
			if(A.weight > 1) A.KB_furrow = 1
			if(thrower.trait_pt)
				DIST*=2
				A.thrown_str*=2
			if(A.grabbed_by)
				var/mob/m = A.grabbed_by
				m.grab = null
				m.grab_part = null
				m.wrestle_stage = null
				A.grabbed_by = null
			while(A.KB)
				A.KB -= 1

				if(ismob(A))
					var/mob/M = A
					M.icon_state = "KB"
				A.MoveAngInstant(degree,12,0,0,t)
				//A.density_factor = 2
				if(A.KB == round(DIST/2)) animate(A, pixel_z = 0, time = 1)
				if(A.KB < round(DIST/2)) if(A.weight) A.dust_and_furrows()
				sleep(0.1)
			if(A.pixel_z > 0) animate(A, pixel_z = 0, time = 1)
			A.lobber = null
			if(ismob(src))
				var/mob/M = src
				M.icon_state = M.state()
				M.set_shadow()
				M.layer = MOB_LAYER + M.laymod - (M.y + M.step_y / 32) / world.maxy
				if(M.skill_flight && M.skill_flight.active) M.density_factor = initial(M.density_factor)
				else if(M.skill_levitation && M.skill_levitation.active) M.density_factor = initial(M.density_factor)
			else
				src.density_factor = initial(src.density_factor)
				if(istype(src,/obj/items/tech/))
					for(var/obj/items/tech/Power_Line/p in src.loc)
						p.reconnect_power()
				if(src.loc && isturf(src.loc))
					var/turf/trf = src.loc
					if(trf.liquid) src.submerge(1,5,trf)
			/*
			while(src.pixel_z > 0)
				//src.dust_and_furrows()
				var/z_remove = rand(1,2)
				animate(src, pixel_z = src.pixel_z-z_remove, time = 0.1)
				//step(src,src.dir,8)
				src.MoveAngInstant(degree,6,0,0,t)
				sleep(0.1)
			*/
		submerge(var/go_under,var/t,var/turf/L)
			if(go_under)
				var/a = 100;
				if(L.liquid == "psionic") a = 255
				else
					src << sound(null,channel = 8)
					//src << sound('underwater.mp3',1,0,6,100)
				src.submerged = 1
				src.underlays -= src.reflection
				if(src.reflection) src.reflection.loc = null
				if(ismob(src))
					var/mob/m = src
					if(m.started)
						if(L.liquid != "psionic")
							if(m.skill_invis)
								if(m.skill_invis.active == 0) animate(m, alpha = a,pixel_z = -15, time = t)
							else animate(m, alpha = a,pixel_z = -15, time = t)
						m.icon_state = m.state()
				else
					animate(src, alpha = a,pixel_z = -15, time = t,flags = ANIMATION_PARALLEL)

				if(src.shadow) src.shadow.alpha = 0
				return
			else
				src << sound(null,channel = 6)
				//if(src.z == 2 || src.z == 6) src << sound('wind.mp3',1,0,8,40)
				src.underlays -= src.reflection
				src.underlays += src.reflection
				src.submerged = 0
				if(src.shadow) src.shadow.alpha = 255
				if(ismob(src))
					var/mob/m = src
					if(m.started)
						m.icon_state = m.state()
						if(m.client)
							m.client.images -= m.bar_o2
						if(L.liquid != "psionic")
							if(m.skill_invis)
								if(m.skill_invis.active == 0) animate(m, alpha = 255,pixel_z = 0, time = t)
							else animate(m, alpha = 255,pixel_z = 0, time = t)
				else animate(src, alpha = 255,pixel_z = 0, time = t,flags = ANIMATION_PARALLEL)
				return
		bounce()
			var/turf/t = src.loc
			for(var/obj/items/tech/x in t)
				if(x != src) if(istype(src,/obj/items/tech/)) if(!istype(x,/obj/items/tech/Power_Line))
					var/obj/o = src
					var/list/turfs = list()
					for(var/turf/t2 in orange(1,o))
						turfs += t2
					o.loc = pick(turfs)
					if(o.shadow) o.shadow.loc = o.loc
		/*
		lift_delay_proc()
			spawn(0.1)
				if(src) src.lift_delay = 0
		*/
		flash_red()
			if(src.flashing == 0)
				src.flashing = 1;
				animate(src,color = "red", time = 2,flags = ANIMATION_PARALLEL)
				animate(color = null, time = 2)
				spawn(8)
					if(src) src.flashing = 0;
		shake()
			if(src.shakes && src.shaking == 0)
				src.shaking = 1
				var/og_px = src.pixel_x
				animate(src, pixel_x = og_px+3, time = 1,flags = ANIMATION_PARALLEL)
				animate(pixel_x = og_px-3, time = 1)
				animate(pixel_x = og_px, time = 1)

				if(src.shadow)
					animate(src.shadow, pixel_x = og_px+3, time = 1,flags = ANIMATION_PARALLEL)
					animate(pixel_x = og_px-3, time = 1)
					animate(pixel_x = og_px, time = 1)
				spawn(6)
					if(src) src.shaking = 0
		waves()
			var/start = filters.len
			var/i,f
			for(i=1, i<=WAVE_COUNT, ++i)
				filters += filter(type="wave", x=20, y=20, size=1, offset=1)
			for(i=1, i<=WAVE_COUNT, ++i)
				// animate phase of each wave from its original phase to phase-1 and then reset;
				// this moves the wave forward in the X,Y direction
				f = filters[start+i]
				animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
				animate(offset=f:offset-1, time=33)
		/*
		vibrate()
			var/x_og = src.pixel_x
			animate(src, pixel_x = x_og+3, time = 1,easing = ELASTIC_EASING)
			sleep(0.3)
			animate(src, pixel_x = x_og, time = 1,easing = ELASTIC_EASING)
			sleep(0.3)
			animate(src, pixel_x = x_og-3, time = 1,easing = ELASTIC_EASING)
			sleep(0.3)
			animate(src, pixel_x = x_og, time = 1,easing = ELASTIC_EASING)
		*/
		levitate()
			var/Z = src.pixel_z
			animate(src,pixel_z = Z+10, time = 10)
			spawn(10)
				animate(src,pixel_z = Z, time = 10)
				spawn(10)
					src.levitate()
		cloud_circle()
			set background = 1
			var/atom/movable/a = src
			var/list/wave_one = list()
			var/list/wave_two = list()
			var/list/wave_three = list()
			var/list/wave_four = list()
			var/list/all_dusts = list()
			var/obj/cs = new
			cs.icon = 'fx_lightning_shadow.dmi'
			cs.appearance_flags = KEEP_TOGETHER
			cs.loc = a.loc
			cs.step_x = a.step_x
			cs.step_y = a.step_y+170
			cs.layer = 10
			animate(cs,pixel_y = cs.pixel_y + 1, time = 20, loop = -1)
			animate(pixel_y = cs.pixel_y - 1, time = 20)

			src.icon_state = "Meditate"
			animate(src,pixel_y = cs.pixel_y + 2, time = 20, loop = -1)
			animate(pixel_y = cs.pixel_y - 4, time = 20)

			var/obj/shad = new
			shad.icon = 'fx_shadow_player.dmi'
			shad.loc = a.loc
			shad.step_x = a.step_x
			shad.step_y = a.step_y
			shad.bolted = 2


			if(ismob(a))
				var/mob/m = a
				m.stunned += 1
				m.stunned_pending += 1

				var/steps = 144
				while(steps)
					steps -= 1
					step(a,NORTH,2)
					//sleep(0.1)
				spawn(80)
					if(m)
						steps = 144
						while(steps)
							steps -= 1
							step(a,SOUTH,2)
							sleep(0.1)
						m.stunned -= 1
						m.stunned_pending -= 1
						animate(m)
						m.icon_state = ""
						if(shad) shad.destroy()

			var/p = 200
			while(p)
				if(prob(25))
					sleep(1)
				p -= 1;
				var/obj/pix = new
				pix.icon = 'fx_dust.dmi'
				pix.icon_state = "[pick(1,2,3,4,5,6,7,8)]"
				pix.loc = locate(a.x,a.y,a.z)
				pix.step_x = a.step_x
				pix.step_y = a.step_y
				pix.pixel_x = rand(-300,300)
				pix.pixel_y = rand(-200,-500)
				pix.bolted = 2
				animate(pix,pixel_x = 0, pixel_y = 0, time = rand(5,10), alpha = 0,loop = -1)
				animate(pixel_x = rand(-300,300), pixel_y = rand(-200,-500), time = 0, alpha = 255)
				all_dusts += pix

			a.shockwave()
			var/wave = 1
			while(wave)
				var/dusts = 120
				var/deg = 360
				while(dusts)
					for(var/obj/effects/dust/d in global.dusts)
						if(d.loc == null)
							d.SetCenter(src)
							d.loc = locate(a.x,a.y,a.z)
							d.step_x = a.step_x
							d.step_y = a.step_y-12
							//d.pixel_x = -36
							//d.pixel_y = 12
							d.icon = 'fx_dust.dmi'
							var/px = cos(deg)
							var/py = sin(deg)
							animate(d, pixel_x = px*120, pixel_y = py*60, time = 5)
							animate(d,pixel_y = d.pixel_y + 2, time = 20, loop = -1, flags = ANIMATION_PARALLEL)
							animate(pixel_y = d.pixel_y - 4, time = 20)
							wave_one += d
							spawn(1000)
								if(d)
									d.pixel_y = 0
									d.pixel_x = -20
									d.alpha = 255
									d.loc = null
									d.layer = 3
							break
					dusts -= 1
					deg -= 3
				wave -= 1

			var/icon/I = icon(cs.icon)
			for(var/obj/c in wave_one)
				var/icon/I_C = icon(c.icon,c.icon_state)
				I.Blend(I_C,ICON_OVERLAY,300+c.pixel_x,300+c.pixel_y)
			cs.icon = I
			cs.icon -= rgb(255,255,255)
			cs.alpha = 100
			cs.pixel_x = -300
			cs.pixel_y = -500

			sleep(5)

			wave = 1

			a.shockwave()
			while(wave)
				var/dusts = 140
				var/deg = 360
				while(dusts)
					for(var/obj/effects/dust/d in global.dusts)
						if(d.loc == null)
							d.SetCenter(src)
							d.loc = locate(a.x,a.y,a.z)
							d.step_x = a.step_x
							d.step_y = a.step_y-12
							d.icon = 'fx_dust.dmi'
							var/px = cos(deg)
							var/py = sin(deg)
							animate(d, pixel_x = px*200, pixel_y = py*100, time = 6)
							animate(d,pixel_y = d.pixel_y + 2, time = 20, loop = -1, flags = ANIMATION_PARALLEL)
							animate(pixel_y = d.pixel_y - 4, time = 20)
							wave_two += d
							spawn(995)
								if(d)
									d.pixel_y = 0
									d.pixel_x = -20
									d.alpha = 255
									d.loc = null
									d.layer = 3
							break
					dusts -= 1
					deg -= 3
				wave -= 1

			for(var/obj/c in wave_two)
				var/icon/I_C = icon(c.icon,c.icon_state)
				I.Blend(I_C,ICON_OVERLAY,300+c.pixel_x,300+c.pixel_y)
			cs.icon = I
			cs.icon -= rgb(255,255,255)
			cs.alpha = 100
			cs.pixel_x = -300
			cs.pixel_y = -500

			sleep(6)

			wave = 1

			a.shockwave()
			while(wave)
				var/dusts = 200
				var/deg = 360
				while(dusts)
					for(var/obj/effects/dust/d in global.dusts)
						if(d.loc == null)
							d.SetCenter(src)
							d.loc = locate(a.x,a.y,a.z)
							d.step_x = a.step_x
							d.step_y = a.step_y-12
							d.icon = 'fx_dust.dmi'
							var/px = cos(deg)
							var/py = sin(deg)
							animate(d, pixel_x = px*250, pixel_y = py*150, time = 7)
							animate(d,pixel_y = d.pixel_y + 2, time = 20, loop = -1, flags = ANIMATION_PARALLEL)
							animate(pixel_y = d.pixel_y - 4, time = 20)
							wave_three += d
							spawn(989)
								if(d)
									d.pixel_y = 0
									d.pixel_x = -20
									d.alpha = 255
									d.loc = null
									d.layer = 3
							break
					dusts -= 1
					deg -= 3
				wave -= 1

			for(var/obj/c in wave_three)
				var/icon/I_C = icon(c.icon,c.icon_state)
				I.Blend(I_C,ICON_OVERLAY,300+c.pixel_x,300+c.pixel_y)
			cs.icon = I
			cs.icon -= rgb(255,255,255)
			cs.alpha = 100
			cs.pixel_x = -300
			cs.pixel_y = -500

			sleep(7)

			wave = 1

			a.shockwave()
			while(wave)
				var/dusts = 250
				var/deg = 360
				while(dusts)
					for(var/obj/effects/dust/d in global.dusts)
						if(d.loc == null)
							d.SetCenter(src)
							d.loc = locate(a.x,a.y-1,a.z)
							d.step_x = a.step_x
							d.step_y = a.step_y+14
							d.icon = 'fx_dust.dmi'
							var/px = cos(deg)
							var/py = sin(deg)
							animate(d, pixel_x = px*300, pixel_y = py*200, time = 8)
							animate(d,pixel_y = d.pixel_y + 2, time = 20, loop = -1, flags = ANIMATION_PARALLEL)
							animate(pixel_y = d.pixel_y - 4, time = 20)
							wave_four += d
							spawn(982)
								if(d)
									d.pixel_y = 0
									d.pixel_x = -20
									d.alpha = 255
									d.loc = null
									d.layer = 3
							break
					dusts -= 1
					deg -= 3
				wave -= 1

			sleep(8)

			for(var/obj/c in wave_four)
				var/icon/I_C = icon(c.icon,c.icon_state)
				I.Blend(I_C,ICON_OVERLAY,300+c.pixel_x,300+c.pixel_y)
			cs.icon = I
			cs.icon -= rgb(255,255,255)
			cs.alpha = 100
			cs.pixel_x = -300
			cs.pixel_y = -500

			spawn(974)
				if(cs)
					cs.destroy()
					for(var/obj/o in all_dusts)
						all_dusts -= o
						o.destroy()
		shockwave_huge()
			var/obj/effects/dust_medium/d_m = new
			d_m.SetCenter(src)
			var wave = 1
			while(wave)
				var/dusts = 140
				var/deg = 360
				while(dusts)
					for(var/obj/effects/dust/d in global.dusts)
						if(d.loc == null)
							d.SetCenter(src)
							if(src.loc.tmp_dmg < 0 && prob(50)) d.icon = 'fx_dust.dmi'
							else if(src.loc.tmp_dmg > 0 || istype(src.loc,/turf/lava_cooled)) d.icon = 'fx_ash.dmi'
							else d.icon = 'fx_dust_dirt.dmi'
							var/px = cos(deg)
							var/py = sin(deg)
							var/multi = 320
							animate(d, pixel_x = px*400, pixel_y = py*multi,alpha = 0, time = 10)
							spawn(10)
								if(d)
									d.pixel_y = 0
									d.pixel_x = -20
									d.alpha = 255
									d.loc = null
									d.layer = 3
							break
					dusts -= 1
					deg -= 3
				wave -= 1
		shockwave_inverse(var/extra = 0)
			var/obj/effects/shockwave_inverse/b = new
			if(isturf(src)) b.loc = src
			else b.loc = src.loc
			if(isobj(src) || ismob(src))
				var/atom/movable/x = src
				b.SetCenter(x)
				b.step_y += 10
				b.step_y += extra
			//b.transform *= 0.1
			animate(b, transform = matrix()*0.1, alpha = 0, time = 9)
			spawn(9)
				if(src && b)
					b.destroy()
		shockwave(var/extra = 0)
			//Normal shockwave 1st
			var/obj/effects/shockwave_medium/b = new
			if(isturf(src)) b.loc = src
			else b.loc = src.loc
			if(isobj(src) || ismob(src))
				var/atom/movable/x = src
				b.SetCenter(x)
				b.step_y += 10
				b.step_y += extra
			b.transform *= 0.1
			animate(b, transform = matrix()*1, alpha = 0, time = 3)
		//power_wave(var/extra = 0)

		lvlupwave(var/extra = 0,var/mob/m)
			//Normal shockwave 1st
			var/obj/effects/shockwave_lvl/b = new
			if(isturf(src)) b.loc = src
			else b.loc = src.loc
			b.icon *= m.auracolor
			if(isobj(src) || ismob(src))
				var/atom/movable/x = src
				b.SetCenter(x)
				b.step_y += 10
				b.step_y += extra
			b.transform *= 0.1
			animate(b, transform = matrix()*1, alpha = 0, time = 3)
			/*
			//Water shockwave 1st
			var/obj/effects/ripple_water/w = new
			if(isturf(src)) w.loc = src
			else w.loc = src.loc
			if(isobj(src) || ismob(src))
				var/atom/movable/x = src
				w.SetCenter(x)
				w.step_y += 10
				w.step_y += extra
			w.transform *= 0.1
			animate(w, transform = matrix()*3, alpha = 0, time = 3)
			*/
			spawn(3)
				if(src && b)
					b.destroy() //del(b)
					/*
					var/obj/effects/shockwave_medium/b2 = new
					if(isturf(src)) b2.loc = src
					else b2.loc = src.loc
					if(isobj(src) || ismob(src))
						var/atom/movable/x = src
						b2.SetCenter(x)
						b2.step_y += 10
						b2.step_y += extra
						b2.transform *= 0.1
					animate(b2, transform = matrix()*1.25, alpha = 0, time = 3)
					if(b) b.destroy() //del(b)
					b.destroy() //del(b2)
					*/
		creation()
			var/turf/t1 = locate(src.x-1,src.y-1,src.z)
			var/turf/t2 = locate(src.x,src.y-1,src.z)
			var/turf/t3 = locate(src.x+1,src.y-1,src.z)
			var/turf/t4 = locate(src.x-1,src.y,src.z)
			var/turf/t6 = locate(src.x+1,src.y,src.z)
			var/turf/t7 = locate(src.x-1,src.y+1,src.z)
			var/turf/t8 = locate(src.x,src.y+1,src.z)
			var/turf/t9 = locate(src.x+1,src.y+1,src.z)
			if(t1)
				t1.overlays = null
				t1.overlays += /turf/dirts/dirt1
			if(t2)
				t2.overlays = null
				t2.overlays += /turf/dirts/dirt2
			if(t3)
				t3.overlays = null
				t3.overlays += /turf/dirts/dirt3
			if(t4)
				t4.overlays = null
				t4.overlays += /turf/dirts/dirt4
			if(t6)
				t6.overlays = null
				t6.overlays += /turf/dirts/dirt6
			if(t7)
				t7.overlays = null
				t7.overlays += /turf/dirts/dirt7
			if(t8)
				t8.overlays = null
				t8.overlays += /turf/dirts/dirt8
			if(t9)
				t9.overlays = null
				t9.overlays += /turf/dirts/dirt9
		wave_effect()
			//src.filters += filter(type="drop_shadow", x=0, y=0, size=4, offset=1, color=rgb(102,0,0))
			//src.filters += filter(type="motion_blur", x=1, y=0)
			var/start = filters.len
			var/i,f
			for(i=1, i<=WAVE_COUNT, ++i)
				/*
				// choose a wave with a random direction and a period between 10 and 30 pixels
				do
					X = 60*rand() - 30
					Y = 60*rand() - 30
					rsq = X*X + Y*Y
				while(rsq<100 || rsq>900)
				// keep distortion small, from 0.5 to 3 pixels
				// choose a random phase
				*/
				filters += filter(type="wave", x=20, y=20, size=1, offset=1)
			for(i=1, i<=WAVE_COUNT, ++i)
				// animate phase of each wave from its original phase to phase-1 and then reset;
				// this moves the wave forward in the X,Y direction
				f = filters[start+i]
				animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
				animate(offset=f:offset-1, time=33)
		explosion_small()
			var/obj/o_dust = new
			if(isturf(src)) o_dust.loc = src
			else if(ismovable(src))
				var/atom/movable/a = src
				o_dust.loc = a.loc
				o_dust.step_x = a.step_x
				o_dust.step_y = a.step_y
			o_dust.layer = 201
			o_dust.bolted = 2
			var/snow = 0
			if(isturf(src))
				var/turf/t = src
				if(t.tmp_dmg < 0) snow = 1
			else if(ismovable(src))
				if(src.loc)
					var/turf/t = src.loc
					if(t.tmp_dmg < 0) snow = 1
			if(snow) o_dust.particles = new/particles/explosion_dust_snow_small
			else o_dust.particles = new/particles/explosion_dust_dirt_small
			sleep(1)
			if(o_dust && o_dust.particles) o_dust.particles.spawning = 0
			spawn(15)
				if(o_dust && o_dust && o_dust.particles)
					o_dust.particles = null
					o_dust.loc = null
		waves_slow()
			var/start = filters.len
			var/i,f
			for(i=1, i<=WAVE_COUNT, ++i)
				filters += filter(type="wave", x=20, y=20, size=1, offset=1)
			for(i=1, i<=WAVE_COUNT, ++i)
				// animate phase of each wave from its original phase to phase-1 and then reset;
				// this moves the wave forward in the X,Y direction
				f = filters[start+i]
				animate(f, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
				animate(offset=f:offset-1, time=33)
		getCircle(turf/origin,radius)
			var/ox = origin.x, oy = origin.y, oz = origin.z
			var/lx = max(ox-radius,1), hx = min(ox+radius,world.maxx)
			var/ly = max(oy-radius,1), hy = min(oy+radius,world.maxy)
			var/list/turfs = block(locate(lx,ly,oz),locate(hx,hy,oz))
			lx -= ox
			hx -= ox
			ly -= oy
			hy -= oy
			var/list/l = list()
			var/mdist = radius*radius, count = 1, x, y
			for(y in hy to ly step -1)
				for(x in hx to lx step -1)
					if(x*x + y*y<=mdist)
						l += turfs[count++]
					else
						count++
			return l
		explosion(var/spins = 7,var/flammable=1)
			if(spins > 7) spins = 7
			var/turf/LOC
			if(isturf(src)) LOC = src
			else if(src.loc) LOC = src.loc
			if(LOC == null) return
			var/obj/o_fire = new
			if(LOC.z == 3 || LOC.z == 6 || LOC.z == 7 || LOC.z == 8)
				var/list/turfs = getCircle(LOC,spins)
				for(var/turf/stone_roof/t in turfs)
					t.set_destroyed()
					for(var/obj/map/cliffs/c in t)
						c.destroy()
					for(var/obj/map/cliffs/c in locate(t.x,t.y-1,t.z))
						c.destroy()
				world.edges_solid_rock(LOC.x-(spins+1),LOC.y+(spins+1),LOC.x+(spins+1),LOC.y-(spins+1),LOC.z)

			//for(var/mob/h in view(8,LOC))
				//h << sound('explosion2.mp3',0,0,4,100)
			var/obj/effects/shockwave_medium/b = new
			b.loc = LOC
			b.pixel_x -= 79
			b.pixel_y -= 79
			b.transform *= 0.1
			animate(b, transform = matrix()*1, alpha = 0, time = 3)

			var/obj/effects/dust_medium/wav = new
			wav.SetCenter(LOC)

			if(spins > 0.5)
				if(flammable)
					o_fire.loc = LOC
					o_fire.layer = 202
					o_fire.bolted = 2
					o_fire.particles = new/particles/fire_particles

				var/obj/o_dust = new
				o_dust.loc = LOC
				o_dust.layer = 201
				o_dust.bolted = 2
				if(LOC.tmp_dmg < 0) o_dust.particles = new/particles/explosion_dust_snow
				else if(LOC.tmp_dmg > 0 && flammable || istype(LOC,/turf/lava_cooled)) o_dust.particles = new/particles/explosion_ash
				else o_dust.particles = new/particles/explosion_dust_dirt

				src.shockwave_huge()

				if(spins >= 1.5)
					if(LOC)
						var/turf/x = LOC
						if(x.liquid == null)
							var/obj/effects/craters/crater_medium/c = new
							c.pixel_x = -64
							c.loc = LOC
							c.transform *= 0.1
							animate(c, transform = matrix()*1, time = 3)
				else if(LOC)
					var/turf/x = LOC
					if(x.liquid == null)
						var/obj/effects/craters/crater_small/c = new
						c.pixel_x = -8
						c.pixel_y = -8
						c.loc = LOC

				src.shockwave_huge()
				sleep(2)

				if(LOC && LOC.z != 3 && LOC.z != 6 && LOC.z != 7 && LOC.z != 8)
					//var/turf/tt = LOC
					if(LOC.liquid == null)
						var/obj/effects/furrow/ff = furrows[1]
						furrows -= ff
						ff.loc = LOC
						if(istype(ff.loc,/turf/lava_cooled) || istype(ff.loc,/turf/lava_cooling)) ff.icon = 'fx_furrow_ash_large.dmi'
						else if(istype(ff.loc,/turf/dirts/)) ff.icon = 'fx_furrow_dirt_large.dmi'
						spawn(600)
							ff.loc = null
							furrows += ff
							ff.icon = initial(ff.icon)
						var/obj/effects/furrow/ff2 = furrows[1]
						furrows -= ff2
						ff2.loc = LOC
						if(istype(ff2.loc,/turf/lava_cooled) || istype(ff2.loc,/turf/lava_cooling)) ff.icon = 'fx_furrow_ash_large.dmi'
						else if(istype(ff2.loc,/turf/dirts/)) ff2.icon = 'fx_furrow_dirt_large.dmi'
						ff2.pixel_x += 16
						spawn(600)
							ff2.loc = null
							furrows += ff2
							ff2.icon = initial(ff2.icon)
						var/obj/effects/furrow/ff3 = furrows[1]
						furrows -= ff3
						ff3.loc = LOC
						if(istype(ff3.loc,/turf/lava_cooled) || istype(ff3.loc,/turf/lava_cooling)) ff.icon = 'fx_furrow_ash_large.dmi'
						else if(istype(ff3.loc,/turf/dirts/)) ff3.icon = 'fx_furrow_dirt_large.dmi'
						ff3.pixel_x -= 16
						spawn(600)
							ff3.loc = null
							furrows += ff3
							ff3.icon = initial(ff3.icon)
					var/pix = 40
					var/deg_ring = 360
					var/obj/q = new
					q.loc = LOC
					while(spins)
						while(deg_ring)
							var/x=(pix+40)*(cos(deg_ring)); var/y=pix*(sin(deg_ring));
							var/movesx=round((x)/32);var/movesy=round((y)/32)
							x-=movesx*32; y-=movesy*32;
							var/turf/begin=locate(LOC.x+movesx,LOC.y+movesy,LOC.z)
							if(begin && begin.liquid) begin = null
							else if(begin)
								q.Move(begin,,x,y)
								var/obj/effects/furrow/f = furrows[1]
								furrows -= f
								f.loc = q.loc
								if(istype(f.loc,/turf/lava_cooled) || istype(f.loc,/turf/lava_cooling)) f.icon = 'fx_furrow_ash_large.dmi'
								else if(istype(f.loc,/turf/dirts/)) f.icon = 'fx_furrow_dirt_large.dmi'
								f.step_x = q.step_x
								f.step_y = q.step_y
								for(var/turf/t in f.locs)
									for(var/obj/items/plants/p in t)
										if(p.immune_dmg == 0)
											p.destroy()
									for(var/obj/items/consumables/cn in t)
										cn.destroy()
								spawn(600)
									f.loc = null;
									furrows += f;
									f.icon = initial(f.icon)
							deg_ring -= 10
						pix += 40
						deg_ring = 360
						spins -= 1
						sleep(0.1)
				sleep(1)
				if(o_dust && o_dust.particles) o_dust.particles.spawning = 0
				if(o_fire && o_fire.particles) o_fire.particles.spawning = 0
				spawn(15)
					if(o_dust && o_dust.particles)
						o_dust.particles = null
						o_dust.loc = null
					if(o_fire && o_fire.particles)
						o_fire.particles = null
						o_fire.loc = null
atom/movable
	proc
		set_shadow()
			//return
			src.hasreflect = 0
			if(src.hasreflect && src.loc && src.reflection == null)
				var/obj/r = new
				/*
				r.appearance = src.appearance
				var/matrix/m = matrix()
				m.Turn(-180)
				r.transform = m
				if(ismob(src))
					var/mob/m = src
					r.overlays -= m.halo;
				*/
				r.plane = -1
				//r.blend_mode = BLEND_MULTIPLY
				var/icon/I = new(src.icon)
				I.Shift(WEST,src.pixel_x)
				I.Flip(NORTH)
				r.icon = I
				r.icon += rgb(0,0,55)
				r.alpha = 200
				src.reflection = r
				r.pixel_x = src.pixel_x
				r.pixel_y = src.pixel_y
				r.pixel_y -= 34
				r.vis_flags = VIS_INHERIT_ICON_STATE | VIS_INHERIT_DIR
				r.filters = src.filters
				src.vis_contents += src.reflection
				//src.underlays += src.reflection
			if(src.shadow == null)
				if(src.hashadow)
					if(ismob(src))
						//var/mob/m = src
						var/obj/s = new
						s.icon = 'fx_shadow_player.dmi'
						s.pixel_y = -4
						//if(m.race == "Alien") s.pixel_y = -12
						s.bounds = src.bounds
						s.step_size = src.step_size
						s.appearance_flags = LONG_GLIDE
						s.bolted = 2
						s.hp = 1.#INF
						src.shadow = s
						return
					else src.create_shadow()
			else
				src.shadow.loc = src.loc
				src.shadow.step_x = src.step_x
				src.shadow.step_y = src.step_y
				if(src.shadow.icon != 'fx.dmi')
					src.shadow.icon_state = src.icon_state
					src.shadow.dir = src.dir
		gravity_well()
			var/wait = 10;
			for(var/atom/movable/a in range(src.radius,src))
				if(a.bolted == 0)
					wait = 1;
					var/di = a.GetAngleStep(src.loc)
					a.MoveAng(di,2,0,0,null)
			spawn(wait)
				if(src) src.gravity_well()
		divine_field()
			spawn(10)
				if(src)
					while(src)
						for(var/mob/m in range(src.radius,src))
							m.gain_stat("divine",1,10,"World Tree")
							//m.divine_energy_max += 0.003*m.divine_energy_mod
							m.divine_energy += 0.01*m.divine_energy_mod

							//spawn(10)
								//if(m) m.energy_sources -= "Soul Stream"
						sleep(50)
		energy_field()
		//	spawn(10)
			//	if(src)
					//while(src)
					//	for(var/mob/m in range(src.radius,src))
						//	if(m.started)
								//m.gaining_energy = 1;
								//if(m.debuff_radiation && m.debuff_radiation.active == 0) call(m.debuff_radiation.act)(m,m.debuff_radiation)
								//if(m.percent_health > 10)
									//m.percent_health -= 1;
								//m.gain_stat("energy",1,10,"Soul Stream",1)
								//spawn(10)
									//if(m) if(m.energy_sources && islist(m.energy_sources)) m.energy_sources -= "Soul Stream"
					//	sleep(50)
		rad_field()
			spawn(10)
				if(src)
					while(src)
						for(var/mob/m in range(src.radius,src))
							if(m.mod_immune_rads < 1 && m.has_body && m.afk == 0) //If not totally immune, apply some damage and debuffs.
							//	m.check_quest("tutorial_environmentals",1)
								//m.check_quest("env_rads",1,1,1)
								m.in_rads = 2;
								if(m.debuff_radiation && m.debuff_radiation.active == 0) call(m.debuff_radiation.act)(m,m.debuff_radiation)
								if(prob(!50))
									if(m.restedness >0)
										m.restedness-= (1+m.mod_immune_rads)
										if(m.restedness <=0) m.restedness = 0

								//if(m.percent_health > 10)
								//	var/dmg = 1-m.mod_immune_rads
									//if(dmg > 0) m.percent_health -= dmg;
						//	if(m.percent_health > 10 && m != src) m.gain_stat("resistance",1,100,"Radiation",1)
						sleep(50)
		heat_field()
			spawn(10)
				if(src)
					while(src)
						for(var/mob/m in range(src.radius,src))
							if(m.tmp_dmg == 0) m.tmp_dmg = 1
						sleep(50)
		create_shadow()
			if(src.shadow == null)
				var/obj/shad = new
				shad.appearance_flags = TILE_BOUND
				var/icon/I = new(src.icon,src.icon_state,src.dir)
				I.icon -= rgb(255,255,255)
				shad.icon = I
				shad.alpha = 100
				shad.loc = src.loc
				shad.pixel_x = src.pixel_x
				shad.pixel_y = src.pixel_y
				shad.pixel_y = shad.pixel_y-(I.Height()/20)
				shad.layer = 2.1
				shad.bolted = 2
				shad.hp = 1.#INF
				src.shadow = shad
				qdel(I)
		reset_tk()
			src.filters -= filter(type="drop_shadow", x=0, y=0, size=5, offset=0, color=rgb(102,0,204))
			src.tk = 0
			animate(src, pixel_z = initial(src.pixel_z), time = 2, easing = BOUNCE_EASING)
			src.layer = initial(src.layer)
			src.density_factor = initial(src.density_factor)
			src.mouse_opacity = initial(src.mouse_opacity)
			src.tk = null
			//src.recycle()
			src.set_shadow()
		dust_and_furrows(var/n = rand(3,6),var/beam=0)
			if(src.loc == null) return
			if(beam)
				n = 0
				if(src && src.ki_power >= 1000)
					if(prob(5)) n=pick(1,2,3,4,5,6,7,0,0,0,0,0,0,0,0,0,0,0,0,0)
				else if(src && src.ki_force >= 250000 && src.ki_power >= (src.ki_force*0.25))
					if(prob(3)) n=pick(1,2,3,4,5,6,7,0,0,0,0,0,0,0,0,0,0,0,0,0)
				else if(src && src.ki_force >= 100000 && src.ki_power >= (src.ki_force*0.25))
					if(prob(2)) n=pick(1,2,3,4,5,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
				else if(src && src.ki_force >= 50000 && src.ki_power >= (src.ki_force*0.25))
					if(prob(2)) n=pick(1,2,3,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
				else if(src && src.ki_force >= 50000 && src.ki_power >= (src.ki_force*0.125))
					if(prob(1)) n=pick(1,2,3,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)


			if(!n || n == 0 ) return
			for(var/turf/x in range(1,src))
			//for(var/turf/x in bounds(src,0))
				if(x.liquid) return
				//for(var/turf/x2 in range(1,x))
					//if(x2.liquid) return
			var/turf/t = src.loc
			if(src.KB_furrow && furrow && t.furrowed <= 6)
				var/obj/o = furrow
				o.pixel_x = src.step_x
				o.pixel_y = src.step_y
				if(istype(t,/turf/grass)) o.icon = 'fx_furrow_grass.dmi'
				else if(istype(t,/turf/lava_cooled) || istype(t,/turf/lava_cooling)) o.icon = 'fx_furrow_ash.dmi'
				else o.icon = 'fx_furrow_dirt.dmi'
				t.overlays += o
				t.furrowed += 1
				t.furrow_remove()
			for(var/obj/items/plants/p in t)
				if(p.immune_dmg == 0)
					if(istype(p,/obj/items/plants/plant))
						p.destroy() //del(p)
					if(istype(p,/obj/items/plants/flower))
						p.destroy() //del(p)
			var/dust = n
			while(dust)
				dust -= 1
				var/X = rand(-16,16)
				var/Y = rand(50,100)
				for(var/obj/d in dusts)
					if(d.loc == null)
						d.loc = locate(t.x,t.y,t.z)
						//d.loc = src.loc
						if(t.tmp_dmg < 0 && prob(50)) d.icon = 'fx_dust.dmi'
						else if(istype(t,/turf/lava_cooled) || istype(t,/turf/lava_cooling)) d.icon = 'fx_ash.dmi'
						else d.icon = 'fx_dust_dirt.dmi'
						//d.pixel_x -= Width(src.icon)/3
						d.step_x = src.step_x //- Width(src.icon)/3
						d.step_y = src.step_y
						//if(Width(src.icon) > 32) d.pixel_x -= 32
						//if(src.dir == EAST || src.dir == WEST) d.pixel_y += 12
						animate(d, pixel_y = Y,pixel_x = X,alpha = 0, time = 20)
						/*
						spawn(10)
							d.layer = src.layer+1
						*/
						spawn(20)
							//d.pixel_x = rand(-10,10)
							if(d)
								d.pixel_y = 0
								d.alpha = 255
								d.loc = null
								d.layer = 3
						break


// is screen_loc a valid screen_loc?
atom/movable/proc/check_screen_loc()
	if(ScreenLocParser.Find(src.screen_loc))
		// just by calling regex.Find(), the regex.group variable now contains the relevant pieces:
		// (if any of the optional parts are missing, they'll be null here)
		//var map_id = ScreenLocParser.group[1]
		var tile_x = text2num(ScreenLocParser.group[2])
		var step_x = text2num(ScreenLocParser.group[3])
		var tile_y = text2num(ScreenLocParser.group[4])
		var step_y = text2num(ScreenLocParser.group[5])
		if(tile_x) src.screen_x = tile_x
		if(tile_y) src.screen_y = tile_y
		if(step_x) src.screen_step_x = step_x
		if(step_y) src.screen_step_y = step_y
		//world << "[map_id]:[tile_x]:[step_x],[tile_y]:[step_y]"

atom/movable/proc/set_screen_loc()
	if(src.screen_step_x || src.screen_step_x > 0)
		src.screen_step_x = ":[src.screen_step_x]"
	else src.screen_step_x = null
	if(src.screen_step_y || src.screen_step_y > 0)
		src.screen_step_y = ":[src.screen_step_y]"
	else src.screen_step_y = null
	src.screen_loc = "[src.screen_x][src.screen_step_x],[src.screen_y][src.screen_step_y]"


proc/CommasADV(s)
    s = "[s]"
    var inc = 0, r = ""
    for(var/p = length(s) to 1 step -1)
        if(inc == 3)
            inc = 0
            r = ",[r]"
        inc++
        r = "[s[p]][r]"
    return r
atom/var
	tmp_deleting
//=====================//
//=== GLOBAL HELPERS ===//
//=====================//

// Safe delete helper
proc/qdel_safe(var/atom/A)
	if(!A) return
	if(istype(A,/atom))
		spawn(1) del(A)
obj/proc/qdel_obj_safe(var/obj/A)
	if(!A) return
	if(istype(A,/obj))
		spawn(1) A.loc=null
// Mob-level right-click cancel logic
mob/proc/CancelBeam()
	if(active_attack && istype(active_attack, /obj/skills/Beam))
		var/obj/skills/Beam/B = active_attack
		B.safe_cancel = TRUE
		active_attack = null


var/global/list/treasure_spawn_rates = list(
    "Bronze" = 5,   // 1 in X chance
    "Silver" = 10,   // 1 in X chance AFTER bronze fails
    "Gold"   = 20   // 1 in X chance AFTER silver fails
)
/turf
    var/last_chest_spawn = 0


/*proc/attempt_spawn_chest(var/mob/m, var/turf/t)
    // Prevent the same tile spamming chests
    if(world.time < t.last_chest_spawn + 3000) // 3000 = 50 seconds
        return

    // Basic cold gate to reduce load: 1 in 200 chance that we even attempt a spawn roll
    if(!prob(0.5)) // 0.5% base chance of even starting a rarity roll
        return

    // Bronze check
    if(prob(100 / treasure_spawn_rates["Bronze"]))
        spawn_chest(m, t, "Bronze")
        t.last_chest_spawn = world.time
        return

    // Silver check (only if bronze fails)
    if(prob(100 / treasure_spawn_rates["Silver"]))
        spawn_chest(m, t, "Silver")
        t.last_chest_spawn = world.time
        return

    // Gold check (rarest)
    if(prob(100 / treasure_spawn_rates["Gold"]))
        spawn_chest(m, t, "Gold")
        t.last_chest_spawn = world.time
        return*/
proc/attempt_spawn_chest(var/mob/m, var/turf/t)

    if(world.time < t.last_chest_spawn + 3000)
        return

    var/discovery_bonus = 1
    if(m.rp_gift_discovery)
        discovery_bonus += 0.05
    var/spawn_chance = 0.5

    if(m.rp_gift_discovery)
        spawn_chance *= 1.05   // +5%

    if(!prob(spawn_chance))
        return
    //if(!prob(0.5))
       // return



    if(prob((100 / treasure_spawn_rates["Bronze"]) * discovery_bonus))
        spawn_chest(m, t, "Bronze")
        t.last_chest_spawn = world.time
        return

    if(prob((100 / treasure_spawn_rates["Silver"]) * discovery_bonus))
        spawn_chest(m, t, "Silver")
        t.last_chest_spawn = world.time
        return

    if(prob((100 / treasure_spawn_rates["Gold"]) * discovery_bonus))
        spawn_chest(m, t, "Gold")
        t.last_chest_spawn = world.time
        return

proc/spawn_chest(var/mob/m, var/turf/t, var/tier)
    if(tier == "Bronze")
        new /obj/items/misc/bronze_chest(t)
    else if(tier == "Silver")
        new /obj/items/misc/silver_chest(t)
    else if(tier == "Gold")
        new /obj/items/misc/gold_chest(t)

    m << "<b>You found a Treasure Chest!</b>"
    m.set_alert("Treasure Found!", 'alert.dmi', "alert")
/// Rebuilds missing portrait parts from saved configuration (eye_pos, mouth_pos, etc.)
/// Completely rebuilds ALL portrait parts using saved appearance vars.
/// Safe to run after login / load. Mirrors update_icon() logic.
proc/General_Portrait_Fix(mob/target, var/ascend = 0)
	if(!target) return

	// -----------------------------
	// DESTROY EXISTING PORTRAIT
	// -----------------------------
	if(target.port)
		target.port.port_eyes = null
		target.port.port_iris = null

		for(var/obj/portrait/p in target.port)
			p.destroy()

		if(target.client) target.client.screen -= target.port
		if(target.hud_char) target.hud_char.vis_contents -= target.port
		if(target.hud_load) target.hud_load.vis_contents -= target.port

		target.port.destroy()

	// -----------------------------
	// CREATE NEW PORTRAIT CONTAINER
	// -----------------------------
	target.port = new /obj/portrait/body
	target.port.plane = 25

	// -----------------------------
	// CREATE ALL PORTRAIT PART OBJECTS
	// -----------------------------
	var/obj/portrait/portrait_part/portrait_horns = new(target.port)
	var/obj/portrait/portrait_part/portrait_hair  = new(target.port)
	var/obj/portrait/portrait_part/portrait_mouth = new(target.port)
	var/obj/portrait/portrait_part/portrait_nose  = new(target.port)
	var/obj/portrait/eyes/portrait_eyes            = new(target.port)
	var/obj/portrait/portrait_part/portrait_iris  = new(target.port)

	portrait_hair.layer = 5.3
	portrait_iris.layer = 5.2

	portrait_eyes.p_owner = target
	portrait_iris.p_owner = target

	target.port.port_eyes = portrait_eyes
	target.port.port_iris = portrait_iris

	target.port.overlays += /obj/portrait/border
	target.port.underlays += /obj/portrait/background

	// -----------------------------
	// BODY STATE
	// -----------------------------
	var/b_state = "body1"
	if(target.body_pos == 2) b_state = "body2"
	else if(target.body_pos == 3) b_state = "body3"

	var/icon/P

	// =====================================================
	// FEMALE PORTRAITS
	// =====================================================
	if(target.gen == "Female")
		switch(target.race)

			if("Demon")
				var/p_icon
				var/p_state
				var/list/eye_list

				if(target.skin_pos == 1)
					p_icon = 'portrait_demon_female.dmi'
					p_state = "[b_state] skin1"
					eye_list = eyes_portrait_female_demon
				if(target.skin_pos == 2)
					p_icon = 'portrait_demon_female.dmi'
					p_state = "[b_state] skin2"
					eye_list = eyes_portrait_female_demon
				if(target.skin_pos == 3)
					p_icon = 'portrait_human_female.dmi'
					p_state = "[b_state] skin1"
					eye_list = eyes_portrait_female
				if(target.skin_pos == 4)
					p_icon = 'portrait_human_female.dmi'
					p_state = "[b_state] skin2"
					eye_list = eyes_portrait_female
				if(target.skin_pos == 5)
					p_icon = 'portrait_human_female.dmi'
					p_state = "[b_state] skin3"
					eye_list = eyes_portrait_female

				if(target.eye_pos > length(eye_list)) target.eye_pos = 1

				P = icon(p_icon, p_state, SOUTH, 1, 0)
				target.port.icon = P

				var/obj/eyes = eye_list[target.eye_pos]
				portrait_eyes.icon = eyes.icon
				portrait_eyes.icon_state = eyes.icon_state

				var/icon/P_eyes_c = icon(eyes.icon, "[eyes.icon_state] color", SOUTH, 1, 0)
				if(target.eye_c) P_eyes_c.Blend(target.eye_c)
				else P_eyes_c.Blend(rgb(0,0,155))

				portrait_iris.icon = P_eyes_c
				P.Blend(P_eyes_c, ICON_OVERLAY)

				var/obj/nose = nose_portrait_female[target.nose_pos]
				portrait_nose.icon = nose.icon
				portrait_nose.icon_state = nose.icon_state

				var/obj/mouth = mouth_portrait_female[target.mouth_pos]
				portrait_mouth.icon = mouth.icon
				portrait_mouth.icon_state = mouth.icon_state

				if(target.hair_pos == 14) target.hair_pos = 1
				var/obj/hair = hairs_portrait_female[target.hair_pos]
				var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH, 1, 0)
				if(target.hair_c) P_hair_c.Blend(target.hair_c)

				P.Blend(P_hair_c, ICON_OVERLAY)
				portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")

	// =====================================================
	// MALE PORTRAITS
	// =====================================================
	if(target.gen == "Male")
		switch(target.race)

			if("Human", "Saiyan", "Half God", "Tuffle")
				var/p_state = "[b_state] skin[target.skin_pos]"
				P = icon('portrait_human_male.dmi', p_state, SOUTH, 1, 0)
				target.port.icon = P

				var/obj/eyes = eyes_portrait_male[target.eye_pos]
				portrait_eyes.icon = eyes.icon
				portrait_eyes.icon_state = eyes.icon_state

				var/icon/P_eyes_c = icon(eyes.icon, "[eyes.icon_state] color", SOUTH, 1, 0)
				if(target.eye_c) P_eyes_c.Blend(target.eye_c)
				else P_eyes_c.Blend(rgb(0,0,155))

				portrait_iris.icon = P_eyes_c
				P.Blend(P_eyes_c, ICON_OVERLAY)

				var/obj/nose = nose_portrait_male[target.nose_pos]
				portrait_nose.icon = nose.icon
				portrait_nose.icon_state = nose.icon_state

				var/obj/mouth = mouth_portrait_male[target.mouth_pos]
				portrait_mouth.icon = mouth.icon
				portrait_mouth.icon_state = mouth.icon_state

				var/obj/hair = hairs_portrait_male[target.hair_pos]
				var/icon/P_hair_c = icon(hair.icon, "[hair.icon_state] color", SOUTH, 1, 0)
				if(target.hair_c) P_hair_c.Blend(target.hair_c)

				P.Blend(P_hair_c, ICON_OVERLAY)
				portrait_hair.icon = icon(P_hair_c.icon, "[hair.icon_state]")

			if("Oni")
				var/p_state = "[b_state] skin[target.skin_pos]"
				P = icon('portrait_oni.dmi', p_state, SOUTH, 1, 0)
				target.port.icon = P

				var/obj/horn = horns_portrait_oni[target.horn_pos]
				portrait_horns.icon = horn.icon
				portrait_horns.icon_state = horn.icon_state

	// -----------------------------
	// FINALIZE VIS CONTENTS
	// -----------------------------
	for(var/obj/portrait/p in target.port)
		if(p.icon)
			target.port.vis_contents += p
		else
			p.destroy()

	if(portrait_iris.icon)
		target.port.vis_contents += portrait_iris

	target.client.screen += target.port

	if(target && target.HUD)
		target.HUD.Rescale_HUD(target)
proc/Planet_Restore(Z) spawn if(1)
	if(Z==1) Earth_active=1
	if(Z==3) Namek_active=1
	if(Z==10) Vegeta_active=1
	if(Z==9) Icer_active=1
