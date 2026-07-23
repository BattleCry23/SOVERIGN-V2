world
	proc
		Save_All()
			set background = 1
		//	spawn(1)
			world.Save_Year()
			sleep(0.1)
			world.log << "AuctionHouse: Saving all auction data before shutdown..."
			SaveAllAuctionData()
			sleep(0.1)
			world.Save_Planets()
			//sleep(0.1)
			//world.Save_World_Tree()
			sleep(0.1)
			world.Save_objs()
			sleep(0.3)
			world.Save_Map()
			sleep(0.1)
			world.save_world_time()
			sleep(0.1)
			world.SaveChildren()
			sleep(0.1)
			world.SaveBan()

		Initialize()
			set background = 1
			//set waitfor =0
			world.Load_Year()
			world.log <<"Year Loaded."
			sleep(0.1)
			world.LoadChildren()
			world.log <<"Children Loaded."
			sleep(0.1)
			world.LoadBan()
			world.log <<"Bans Loaded."
			sleep(0.1)
			world.load_world_time()
			world.log <<"World Time Loaded."
			sleep(0.1)
			world.start_world_clock()
			world.log <<"World Clock Loaded."
			sleep(0.1)
			world<<"<font color=green>System Loading.....</font>"
			world.log<<"System Loading....."
			world.Load_Map2()
			//world.Auto_Reboot()
			sleep(0.1)
			roll_immersion_rng()
			//spawn(30) world.Load_Map()  // Delay map loading to avoid immediate CPU spike


		/*Save_World_Tree()
			set background = 1
			if(world_tree)
				var/obj/items/tech/world_tree/wt = world_tree
				wt.loc = null
				//var/old_vis = wt.vis_contents
				var/old_rays = wt.wt_rays
				//wt.vis_contents = null
				wt.wt_rays = null
				wt.particles = null
				//wt.cleanse_all_vars()
				var/savefile/S = new("saves/world/world_tree.sav")
				S["TREE"] << world_tree
				world_tree.loc = locate(250,250,4)
				//wt.vis_contents = old_vis
				wt.wt_rays = old_rays
				//world << "DEBUG - Saved [world_tree]"

		Load_World_Tree()
			if(fexists("saves/world/world_tree.sav"))
				var/savefile/S = new("saves/world/world_tree.sav")
				S["TREE"] >> world_tree
				if(world_tree)
					world_tree.loc = locate(250,250,4)
					//world << "DEBUG - Loaded [world_tree]"

				*/
		Save_Year()
			//set background = 1
			var/savefile/S = new("saves/world/year.sav")
			S["YEAR"] << global.year
			S["PSIONIC YEAR"] << global.psi_year
			S["YEAR COUNTER"] << global.counter
			S["EARTH"] << Earth_active
			S["NAMEK"] << Namek_active
			S["VEGETA"] << Vegeta_active
			S["ICER"] << Icer_active
			S["Global_CFT"] << cftglobal
			S["HBTC_Speed"] << global.hbtc_time
			world.save_world_time()

		Load_Year()
			if(fexists("saves/world/year.sav"))
				var/savefile/S = new("saves/world/year.sav")
				S["YEAR"] >> global.year
				S["PSIONIC YEAR"] >> global.psi_year
				S["YEAR COUNTER"] >> global.counter
				S["EARTH"] >>Earth_active
				S["NAMEK"] >> Namek_active
				S["VEGETA"] >> Vegeta_active
				S["ICER"] >> Icer_active
				S["Global_CFT"] >> cftglobal
				S["HBTC_Speed"] >> global.hbtc_time
		Save_Contacts()
			set background = 1
			var/savefile/S = new("saves/world/contacts.sav")
			S["CONTACTS"] << contacts
			S["NAMES"] << names_taken

			var/txtfile = file("saves/world/contacts.txt")
			S.ExportText("/",txtfile)

		Load_Contacts()
			if(fexists("saves/world/contacts.sav"))
				var/savefile/S = new("saves/world/contacts.sav")
				if(S["CONTACTS"]) S["CONTACTS"] >> contacts
				if(S["NAMES"]) S["NAMES"] >> names_taken
				//if(global.contacts == null || length(global.contacts) <= 0 || islist(global.contacts) == 0) global.contacts = list()
				//if(global.names_taken == null || length(global.names_taken) <= 0 || islist(global.names_taken) == 0) global.names_taken = list()