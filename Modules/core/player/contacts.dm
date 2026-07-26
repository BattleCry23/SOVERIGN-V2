//var/savefile/S = new("saves/players/[src.client.key]/sav[src.sav_active].sav")

/*
- Player starts new character
- Pick a shell for them from player_shells
- Copy their name, key and icon and other info to the shell
- Add the shell to the global contacts list
- Make sure to save the contacts list

- Once all of the above is done, or player loads a char, add their shell to the contacts_online list.
- Less laggy to search through a list of, say, 100 players online, then include them all in a giant list of 1000+ characters/players.

.:Shell uses:.
- Act as a contacts system ic, so you can increase relations, remember who is who, what they looked like.
- Act as a means to track who is online via Who command
	- May need to find a way to hide their icon in this instance
- Way for admins to interact with player, regardless online and offline.
- Perhaps used in some kind of sense system?
- Way to keep track of friends in game?
*/
obj
	hud
		contact_del
			icon = 'hud_contact_del.dmi'
			icon_state = "normal"
			layer = 33
			plane = 28
			blend_mode = BLEND_INSET_OVERLAY
			appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
			var/obj/menu
			MouseEntered(object,location,control,params)
				src.icon_state = "hover"
			MouseExited(object,location,control,params)
				src.icon_state = "normal"
			New()
				return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
			MouseDrag()
				return //This is here so its not called when its parent's MouseDrag() is called, resulting in movement of HUD we don't wanna move. DO NOT REMOVE.
		contact
			icon = 'hud_contact.dmi'
			icon_state = "contact"
			plane = 28
			layer = 33
			blend_mode = BLEND_INSET_OVERLAY
			appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
			var/obj/txt_contact
			var/setup = 0
			var
				txt_energy = "???"
				txt_power = "???"
				txt_strength = "???"
				txt_endurance = "???"
				txt_agility = "???"
				txt_force = "???"
				txt_resistance = "???"
				txt_offence = "???"
				txt_defence = "???"
				txt_regen = "???"
				txt_recovery = "???"

			MouseEntered(object,location,control,params)
				src.filters = filter(type="outline",size=1,color = rgb(255,255,255))
			MouseExited(object,location,control,params)
				src.filters = null
			MouseWheel(delta_x,delta_y,location,control,params)
				var/obj/hud/menus/contacts_background/s = usr.hud_contacts
				var/obj/sc = s.scroller_main
				usr.check_mouse_loc(params)
				var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
				usr.mouse_y_true = true_y
				var/wheel_move = 0
				if(delta_y > 0) wheel_move = 16
				else if(delta_y < 0) wheel_move = -16
				var/result = sc.translated_y+wheel_move
				result = clamp(result,0,-228)
				var/matrix/m = matrix()
				m.Translate(0,result)
				sc.transform = m
				sc.translated_y = result

				s.scroller_transforms_main[s.selected] = m

				var/ratio = -1 + ((-228 + result) / -228)
				ratio = clamp(ratio,0,1)
				var/scroll_y = round(s.contacts_size*ratio)

				s.bar_pos_y_main[s.selected] = scroll_y

				for(var/obj/o in s.holder_main.vis_contents)
					var/matrix/m2 = matrix()
					m2.Translate(o.hud_x,o.hud_y+scroll_y)
					o.transform = m2
			proc
				contact(var/mob/m,var/mob/contact_owner)
					//Update general info, like their location, last seen, ect.
					src.info_last_loc = m.check_planet()
					//Update the contacts "Last known stats" section with the new stats seen from the contact

					if(m.id in contact_owner.remembers_strength) src.txt_strength = "[Commas(m.strength)]"
					if(m.id in contact_owner.remembers_endurance) src.txt_endurance = "[Commas(m.endurance)]"
					if(m.id in contact_owner.remembers_agility) src.txt_agility = "[m.mod_agility]"
					if(m.id in contact_owner.remembers_force) src.txt_force = "[Commas(m.force)]"
					if(m.id in contact_owner.remembers_resistance) src.txt_resistance = "[Commas(m.resistance)]"
					if(m.id in contact_owner.remembers_offence) src.txt_offence = "[Commas(m.offence)]"
					if(m.id in contact_owner.remembers_defence) src.txt_defence = "[Commas(m.defence)]"
					if(m.id in contact_owner.remembers_recovery) src.txt_recovery = "[m.mod_recovery]"
					if(m.id in contact_owner.remembers_regeneration) src.txt_regen = "[m.mod_regeneration]"
			New()
				return
				if(src.setup) return
				src.setup = 1
				var/obj/hud/contact_del/d = new
				d.menu = src
				var/matrix/x = matrix()
				x.Translate(226,74)
				d.transform = x
				src.vis_contents += d
			Click()
				if(src in usr.player_contacts)
					//if(usr.skill_telepathy) winset(usr,"contacts.button_telepath","is-visible=true")
					//else winset(usr,"contacts.button_telepath","is-visible=false")
					//Handle Telepathy and selecting a contact to speak with.
					if(usr.left_click_function == "telepath")
						if(src.info_path)
							for(var/mob/m in players)
								if(m.key == src.info_path)
									winset(usr,"numbers.label_numbers","text=\"What would you like to telepath?\"")
									winshow(usr,"numbers",1)
									usr.numbers_text = "telepath"
									usr.left_click_ref = m
									break
						usr.left_click_function = null
					//Handle selecting a contact via mouse click.
					usr.contact_selected = src
					if(usr.hud_contacts)
						var/obj/hud/menus/contacts_background/bg = usr.hud_contacts
						bg.contacts(usr,"one contact")
						bg.info_port.overlays = null
						bg.info_port.overlays += src.overlays
						bg.holder_info.vis_contents += bg.info_port
						bg.holder_info.vis_contents += bg.relations_box
mob/verb/telepath_contact()
	set name = ".telepath_contact"
	set hidden = 1
	if(usr.contact_selected && usr.skill_telepathy)
		var/obj/hud/contact/c = usr.contact_selected
		for(var/mob/m in players)
			if(m.key == c.info_path)
				winset(usr,"numbers.label_numbers","text=\"What would you like to telepath?\"")
				winshow(usr,"numbers",1)
				usr.numbers_text = "telepath"
				usr.left_click_ref = m
				winset(usr,"numbers.input_number","focus=true")
				break
mob/proc/new_contact_world()
	//Execute this proc only when a new character is finished being created. Then add them to the global list of contacts.
	var/found = 0
	for(var/obj/shell in contacts_online)
		if(shell.info_path == src.byond_key || src.client && shell.info_path == src.key)
			found = 1
			break
	if(found == 0)
		var/obj/hud/contact/shell = player_shells?[1]
		shell.icon_original = src.icon
		shell.name = src.key
		shell.info_name = src.real_name
		shell.info_path = src.key
		shell.info_stats = src.sav_active
		player_shells -= shell
		contacts += shell
		contacts_online += shell
mob/proc/new_contact(var/mob/m)
	//Execute this proc only when a player adds another player as a contact. Different from above proc.
	var/already_added = 0
	for(var/obj/contact in src.player_contacts)
		if(contact.info_name == m.real_name)// && contact.info_path == m.key)
			already_added = 1
			break
	if(already_added == 0)
		var/obj/hud/contact/shell = player_shells[1]
		if(m.port)
			var/obj/port_copy = new
			port_copy.icon = m.port.icon
			port_copy.icon_state = m.port.icon_state
			port_copy.plane = 28
			port_copy.layer = m.port.layer+32
			port_copy.appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
			port_copy.pixel_y = 4
			shell.overlays += port_copy
			for(var/obj/portrait/p in m.port.vis_contents)
				var/obj/o = new
				o.icon = p.icon
				o.icon_state = p.icon_state
				o.plane = 28
				o.layer = p.layer+32
				o.appearance_flags = KEEP_TOGETHER | PIXEL_SCALE | TILE_BOUND
				o.pixel_y = 4
				shell.overlays += o
		shell.name = m.name
		shell.info_name = m.real_name
		shell.info_race = m.race
		shell.info_last_loc = m.check_planet()
		if(m.client)
			shell.info_path = m.key
			shell.info_stats = m.sav_active
			shell.info_client = "Player"
		else
			shell.info_client = "NPC"
		shell.info = "Type notes here..."
		player_shells -= shell
		src.player_contacts += shell
		src << output("Added [m] to your list of contacts.", "chat.system")
		if(src.hud_contacts)
			var/obj/hud/menus/contacts_background/bg = src.hud_contacts
			bg.txt_relations.maptext = "[css_outline]<font size = 1><left>Contacts: [src.player_contacts.len]"
	else src << output("Already found [m] in your contacts.", "chat.system")
mob/proc/contact_logout()
	//world << "DEBUG - [src] logged out, calling contact_logout() proc."
	for(var/obj/shell in contacts_online)
		if(shell.info_path == src.byond_key)
			contacts_online -= shell
			break
mob/proc/contact_login()
	for(var/obj/shell in contacts)
		if(shell.info_path == src.key)
			contacts_online += shell
			break
mob/verb/add_contact()
	set name = ".add_contact"
	set hidden = 1
	usr.left_click_function = "add contact"
	usr.client.mouse_pointer_icon = 'mouse_left_interact.dmi'
	winshow(usr,"contacts",0)
	usr.open_contacts = 0
	usr.open_menus.Remove(".open_contacts")
mob/verb/remove_contact()
	set name = ".remove_contact"
	set hidden = 1
	if(usr.contact_selected)
		winset(usr,"contacts.input_notes","text=\"\"")
		winset(usr,"contacts.label_name","text=\"\"")
		winset(usr,"contacts.label_img","image=")
		usr.player_contacts -= usr.contact_selected
		usr.contact_selected.loc = null
		usr.contact_selected = null
		winset(usr,"contacts.label_points","text=\"Relation Points: 0\"")
		winset(usr,"contacts.relation_num","text=\"0\"")
mob/verb/adjust_relations(var/t as text)
	set name = ".adjust_relations"
	set hidden = 1
	if(usr.contact_selected)
		var/obj/c = usr.contact_selected
		if(t == "+")
			if(c.relations != c.relation_points)
				c.relations += 1
		if(t == "-")
			if(c.relations != (0-c.relation_points))
				c.relations -= 1
		winset(usr,"contacts.relation_num","text=\"[c.relations]\"")
mob/proc/gain_relations()
	spawn(60)
		if(src)
			while(src)
				var/found_someone = 60
				for(var/mob/m in view(10,src))
					if(m)// != src)// && m.client)
						var/obj/hud/contact/found = null
						for(var/obj/contact in src.player_contacts)
							if(contact.info_name == m.real_name)// && contact.info_path == m.key)
								found = contact
								contact.info_relation_points += 1
								if(src.origin && istype(src.origin,/obj/origins/empath)) contact.info_relation_points += 1
								found_someone = 60
								break
						if(found == null && m.name in src.known_people)

							src.new_contact(m)
						else found.contact(m,src)
				sleep(found_someone)
				sleep(0.1)

obj
	relation_perks
	/*
	Few ideas for relation perks

	Relations build up over time and translate into Relation Points.

	Relation Points earned from being near someone over time.

	Then it is up to player how they wish to assign those Relation Points to someone.

	Different catergories for different types of relationships.

	.:Relationship type categories:.

	Friendship
		- Acquaintance
		- Friend
		- Close Friend
		- Best Friend
	Rivalry
		- Competitor
		- Rival
		- Leading Rival
		- Prime Rival
	Romantic
		- Interest
		- Infatuated
		- Committed
		- Lover
	Trust
		- Associate
		- Colleague
		- Partner
		- Ally
	Animosity
		- Dislike
		- Contempt
		- Hatred
		- Nemesis
	Respect
		- Acknowledged
		- Respected
		- Admired
		- Venerated
	Envy
		- Covetous
		- Jealous
		- Obsessed
		- Resentful
	Deception
		- Distrust
		- Deceiver
		- Betrayer
		- Traitor
	*/
		soulmate
		rival
		friend
		enemy
		training_partner
		master
		student
		lover
		leader
		follower
		family