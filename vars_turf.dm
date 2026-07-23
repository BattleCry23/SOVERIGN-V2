turf
	vis_flags = VIS_INHERIT_LAYER
	appearance_flags = TILE_BOUND | KEEP_TOGETHER
	var
		liquid = null //Water, lava, ect
		fragile = 1 //Id set to 1, this turf leaves trenches when a mob is punched too hard and knocked back.
		changed = null
		weather_type = null
		furrowed = 0 //Number of furrows in this turf, helps stop them stacking too much and piling on one turf.
		red = 0 //How much red was added to this icon via rgb()
		damaged = 0
		builder_key = null
		builder = null
		og_type = null
		og_grav = 1 //Use this to reset the turfs gravity.
		og_microwaves = 1
		tmp/activated_damage = 0
		tmp/icon/saved_icon = null
		tmp/obj/damage = null
		tmp/obj/glow = null

		power_grid = 0
		currents_grid = 0
		excess_grid = 0
		stored_grid = 0
		used_grid = 0
		autotile = 0
		wall = 0
		tmp/list/bats_list = null //List of batteries.
//turf/var/vein = null
/turf/var/datum/resource_vein/vein = null

turf
	var
		ownedland=0
		unownedland=1
		ownerofland
		sovereignland=0