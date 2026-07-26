#define ADMIN_SAVE_FILE "data/admin_profiles.sav"

proc/load_map_screen(client/C)

	if(!C || !C.ckey) return

	var/ckey = uppertext(C.ckey)
	if(fexists("saves/players/[ckey]/[ckey]_map_size.txt"))
		var/savefile/F = new("saves/players/[ckey]/[ckey]_map_size.txt")
	// Use temporary vars to avoid loading corrupt data directly into client
		var/name
		var/map_size

		F["name"] >> name
		F["map_size"] >> map_size
		winset(C, "map.map", "size=[map_size]")
		//world<<"Loaded Map Size."
	else
		winset(C, "map.map", "size")

proc/save_map_screen(client/C)
	if(!C || !C.ckey) return
	var/ckey = uppertext(C.ckey)
	var/savefile/F = new("saves/players/[ckey]/[ckey]_map_size.txt")

	// Use temporary vars to avoid loading corrupt data directly into client
	var/name = ckey
	var/map_size=winget(src,"map.map","size")

	F["name"] >> name
	F["map_size"] >> map_size

// Save admin profile to file safely
proc/save_admin_profile(client/C)
	if(!C || !C.ckey) return
	var/savefile/F = new(ADMIN_SAVE_FILE)
	var/ckey = lowertext(C.ckey)

	// Use string keys to avoid object reference issues
	F["[ckey]_name"] << C.admin_name
	F["[ckey]_color"] << C.admin_color
	F["[ckey]_icon"] << C.admin_icon_type
	F["[ckey]_setup"] << C.admin_setup_done
	F["[ckey]_setdone"] << C.admin_mode_set

// Load admin profile from file safely
proc/load_admin_profile(client/C)
	if(!C || !C.ckey) return
	var/savefile/F = new(ADMIN_SAVE_FILE)
	var/ckey = lowertext(C.ckey)

	// Use temporary vars to avoid loading corrupt data directly into client
	var/name, color, icon, setup, setdone
	F["[ckey]_name"] >> name
	F["[ckey]_color"] >> color
	F["[ckey]_icon"] >> icon
	F["[ckey]_setup"] >> setup
	F["[ckey]_setdone"] >> setdone

	// Apply only if all exist
	//if(name && color && icon && setup && setdone)
	if(!isnull(name) && !isnull(color) && !isnull(icon) && !isnull(setup) && !isnull(setdone))
		C.admin_name = name
		C.admin_color = color
		C.admin_icon_type = icon
		C.admin_setup_done = setup
		C.admin_mode_set = setdone
		//C.mob<<"Profile Loaded."
// Check if the ckey exists in the savefile (admin marker)
proc/is_ckey_in_admin_save(var/ckey)
	if(!ckey) return FALSE
	var/savefile/F = new(ADMIN_SAVE_FILE)
	return F.dir.Find("[lowertext(ckey)]_name")

