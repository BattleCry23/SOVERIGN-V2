
area
	mouse_opacity = 1
	//plane = 1
	var
		resources
		outside = 1

		power_grid = 0
		currents_grid = 0
		excess_grid = 0
		stored_grid = 0
		used_grid = 0
		tmp/list/bats_list = null //List of batteries.
	void
		layer = 1
		plane = -2
	water
		icon = 'terrain.dmi'
		icon_state = "lake5"
		plane = -1
		layer = 2
		//appearance_flags = KEEP_TOGETHER
	//blank
		//icon = 'terrain.dmi'
		//icon_state = "blank"
	//earth
	//network_dead
		//layer = 2.1
		//icon = 'terrain.dmi'
		//icon_state = "tech floor"
	//safe
	//villages
		//village_southwest
	/*world_tree_trunk
		Entered(atom/movable/a)
			if(world_tree)
				var/obj/items/tech/world_tree/wt = world_tree
				if(ismob(a))
					var/mob/m = a
					if(m.client)
						m.client.images -= wt.wt_trunk
						m.client.images += wt.wt_trunk_opaque
		Exited(atom/movable/a)
			if(world_tree)
				var/obj/items/tech/world_tree/wt = world_tree
				if(ismob(a))
					var/mob/m = a
					if(m.client)
						m.client.images += wt.wt_trunk
						m.client.images -= wt.wt_trunk_opaque
	world_tree_top
		Entered(atom/movable/a)
			if(world_tree)
				var/obj/items/tech/world_tree/wt = world_tree
				if(ismob(a))
					var/mob/m = a
					if(m.client)
						m.client.images -= wt.wt_top
						for(var/image/i in wt.wt_rays)
							m.client.images -= i
		Exited(atom/movable/a)
			if(world_tree)
				var/obj/items/tech/world_tree/wt = world_tree
				if(ismob(a))
					var/mob/m = a
					if(m.client)
						m.client.images += wt.wt_top
						for(var/image/i in wt.wt_rays)
							m.client.images += i
*/