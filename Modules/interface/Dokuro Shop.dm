mob
/mob/npc/dokuro_shop
	Click(location, control, params)
		usr.show_dokuro_shop()
	Earth_Doku_Shop
		name = "Dokuro Merchant"
		icon = 'EarthDoku.dmi'
		icon_state = ""
		mouse_opacity = 2
		density_factor = 1
		npc = 1
		hp = 999999999
		can_attack = 0


	Vegeta_Doku_Shop
		name = "Dokuro Merchant"
		icon = 'VegetaDoku.dmi'
		icon_state = ""
		mouse_opacity = 2
		density_factor = 1
		npc = 1
		hp = 999999999
		can_attack = 0

	Icer_Doku_Shop
		name = "Dokuro Merchant"
		icon = 'IcerDoku.dmi'
		icon_state = ""
		mouse_opacity = 2
		density_factor = 1
		npc = 1
		hp = 999999999
		can_attack = 0
	Namek_Doku_Shop
		name = "Dokuro Merchant"
		icon = 'NamekDoku.dmi'
		icon_state = ""
		mouse_opacity = 2
		density_factor = 1
		npc = 1
		hp = 999999999
		can_attack = 0
	Checkpoint_Doku_Shop
		name = "Dokuro Merchant"
		icon = 'EarthDoku.dmi'
		icon_state = ""
		mouse_opacity = 2
		density_factor = 1
		npc = 1
		hp = 999999999
		can_attack = 0
	Heaven_Doku_Shop
		name = "Dokuro Merchant"
		icon = 'EarthDoku.dmi'
		icon_state = ""
		mouse_opacity = 2
		density_factor = 1
		npc = 1
		hp = 999999999
		can_attack = 0
	Hell_Doku_Shop
		name = "Dokuro Merchant"
		icon = 'EarthDoku.dmi'
		icon_state = ""
		mouse_opacity = 2
		density_factor = 1
		npc = 1
		hp = 999999999
		can_attack = 0
	DarkRealm_Doku_Shop
		name = "Dokuro Merchant"
		icon = 'EarthDoku.dmi'
		icon_state = ""
		mouse_opacity = 2
		density_factor = 1
		npc = 1
		hp = 999999999
		can_attack = 0
client/var/tmp/dokuro_check_running = 0

/client/var/dokuro_points = 0
/proc/add_dokuro(client/C, amount)
    C.dokuro_points += amount
    C << "You received [amount] Dokuro. Total: [C.dokuro_points]"
/proc/shop_item(mob/M, name, cost, id)
    return {"
    <div class='shop-item'>
        <div class='item-title'>[name]</div>
        <div class='item-price'>Cost: [cost]d</div>
        <a class='shop-button' href='?src=\ref[M];buy=[id]'>Buy</a>
    </div>
    "}

/proc/get_dokuro_cost(id)
    return list(
        "change_eye_color" = 100,
        "aura_color" = 200,
        "child_slot_char" = 1000,
        "mystery_box_1" = 500,
        "custom_obj" = 700,
        "custom_icon" = 1000,
        "mystery_box_5" = 1500,
        "child_slot_global" = 2000,
        "vote_mute" = 2000,
        "tanto_icon" = 80,
        "tail_ring" = 100,
        "elder_skin" = 250,
        "demon_horns" = 600,
        "changeling_form" = 3000
    )[id]

/proc/get_dokuro_name(id)
    return list(
        "aura_color" = "Change Aura Color",
        "change_eye_color" = "Change Eye Color",
        "child_slot_char" = "+1 Child Slot(Key based)",
        "mystery_box_1" = "+1 Mystery Box",
        "custom_obj" = "Custom Object Sprite",
        "custom_icon" = "Custom Icon Sprite",
        "mystery_box_5" = "+5 Mystery Box",
        "child_slot_global" = "+1 Max Child Slot(Key based)",
        "vote_mute" = "Vote Mute Verb",
        "tanto_icon" = "Tanto Icon Weapon",
        "tail_ring" = "Saiyan Tail w/ Ring",
        "elder_skin" = "Namekian Elder Skin",
        "demon_horns" = "Demon Unique Horns",
        "changeling_form" = "Changeling Custom Form"
    )[id]


/proc/grant_shop_item(mob/M, id)
	switch(id)
		if("rename")
			var/c  = input ("Choose a new name for your character.") as text
			if(c)
				if(global.names_taken.Find(c) || findtext(c,"npc") || findtext(c,"Name"))
					M.confirm_text = "That name is already taken."
					return
				else
					M.real_name = c
					M.fullname = c
					M.name = c
					M.known_people += c
			M << "<b>Your name was change!(-200d)</b>"

		if("eye_color")
			var/mob/target = M
			var/c  = input ("Choose a color for your eyes.") as color
			if(target)
				target.eye_c = c
				winset(target,"char_creation.eye_color","background-color=[c]")

				target.update_looks("eye color")
				if(M.port && M.hud_char)
					//Adjust players portrait first.
					M.hud_char.update_portrait_transform()
					//Adjust players in-game avatar next.
					M.hud_char.menu_avatar()
				M << "<b>Your Eye color was change!(-200d)</b>"
		if("aura_color")
			var/c  = input ("Choose a color for your Aura.") as color
			M.auracolor = c
			M << "<b>Your aura color was change!(-200d)</b>"
		if("child_slot_char")
			M.client.childslots += 1
			M << "<b>You gained +1 Child Slot for this account!(-1000d)</b>"
		if("child_slot_global")
			M.client.max_childslots += 1
			M.client.childslots += 1
			M << "<b>You gained +1 Max Child Slot for this account!(-1200d)</b>"

		if("mystery_box_1")
			var/obj/items/misc/mystery_box/O = new /obj/items/misc/mystery_box(M.loc)
			M.pickup(O)
			M << "<b>You received +1 Mystery Box!(-500d)</b>"
		if("mystery_box_5")
			var/obj/items/misc/mystery_box/O = new /obj/items/misc/mystery_box(M.loc)
			O.stacks = 5
			M.pickup(O)
			M << "<b>You received +5 Mystery Box!(-1500d)</b>"
		if("custom_icon")
			var/newicon = input(M, "Select icon file") as icon|null
			if(newicon) M.icon = newicon

			M << "<b>You customized your icon!(-1000d)</b>"
		if("custom_obj")
			var/obj/items/custom_icon_object/O = new /obj/items/custom_icon_object(M.loc)
			M.pickup(O)
			M << "<b>You gained A Custom Object Sprite! Rightclick it in your inventory to customize.(-700d)</b>"

			//M << "TODO: <b>You gained a custom hair sprite item!(-700d)</b>"

		if("vote_mute")
		//M.verbs += /mob/verb/VoteMute
			M.has_vote_mute = 1
			M<<"<b>You were granted access to Vote Mute, use /votem to  start a vote!(-2000d)</b>"
		// Add more logic as needed
		else
			M << "TODO: Grant [id]"

/proc/prompt_paypal_redirect(mob/M)
    var/list/options = list(
        "100 Dokuro (1 USD)" = "93LG5JY5RV92N",     // Example Button ID for 100
        "500 Dokuro (5 USD)" = "P4NKR7XST8JGJ",
        "1000 Dokuro (10 USD)" = "NG56EJAG7UTJQ",
        "2200 Dokuro (20 USD)" = "WUWNKZTWVVW68",
        "5500 Dokuro (50 USD)" = "CST984KPQZDZS",
        "12500 Dokuro (100 USD)" = "VKBUJZDLCX2TC"
    )

    var/choice = input(M, "Choose how many Dokuro Coins to buy:\nNote: *For faster service, DM the owner on discord, as transfers can take up to anywhere from 1-hr to 2 business days.*", "Buy Dokuro") as null|anything in options
    if(!choice) return

    var/button_id = options[choice]
    var/paypal_url = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=[button_id]&custom=[M.key]"

    M << "Opening PayPal in your browser..."
    spawn()
        dokuro_checker_loop(M) // Start IPN check loop
    M << link(paypal_url)  // THIS OPENS THE BROWSER, which is what you want

    //if(!M.dokuro_shop_open) M.dokuro_shop_open = 1



/proc/dokuro_checker_loop(mob/m)
    while(TRUE)
        m<<"Waiting for Payment..."
        if(m.dokuro_shop_open != 1)
            m.client<<"Payment Check Canceled."
            m.client.dokuro_check_running = FALSE
            break

        var/list/filenames = list()
        var/url = "https://sovereign.onlinewebshop.net/list_pending.php"

        var/http = world.Export(url)
        if(islist(http) && http["CONTENT"])
            var/text = file2text(http["CONTENT"])
            filenames = splittext(text, "\n")

        for(var/fname in filenames)
            if(!fname || !length(fname)) continue

            var/file_url = "https://sovereign.onlinewebshop.net/pending/[fname]"
            var/result = world.Export(file_url)

            if(!islist(result) || !"CONTENT" in result) continue

            var/data = file2text(result["CONTENT"])
            var/list/parts = splittext(data, "|")
            if(length(parts) != 2) continue

            var/key = parts[0]
            var/amount = text2num(parts[1])

            for(var/client/C)
                if(C.key == key)
                    add_dokuro(C, amount)
                    C << "Your PayPal purchase of [amount] Dokuro has been received!"
                    m.client.dokuro_check_running = FALSE
                    break

            // Optional: Mark processed (see below)

        sleep(100)


/client/proc/load_dokuro_images()
    src << browse_rsc('DokuCoin.png')

   // browse_rsc('dokuro_shop/hair.png')
   // browse_rsc('dokuro_shop/childslot.png')
   // browse_rsc('dokuro_shop/mystery.png')
   // browse_rsc('dokuro_shop/icon.png')
   // browse_rsc('dokuro_shop/tanto.png')
    // ... add all relevant images

/mob/proc/show_dokuro_shop()
    var/client/C = src.client
    if(!C) return
    src.dokuro_shop_open=1
    src << browse_rsc('DokuCoin.png')

    var/html = {"
    <html>
    <head>
    <style>
        body {
            background-color: #111;
            color: #fff;
            font-family: Arial, sans-serif;
            padding: 10px;
        }
        h1 {
            text-align: center;
            color: #ff3366;
        }
        .section {
            margin-bottom: 20px;
            padding: 10px;
            border: 2px solid #ff3366;
            border-radius: 8px;
            background-color: #1a1a1a;
        }
        .section-title {
            text-align: center;
            font-size: 20px;
            color: #ff6699;
            margin-bottom: 10px;
        }
        .shop-grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }
        .shop-item {
            background-color: #222;
            border: 2px solid #fff;
            border-radius: 8px;
            width: 30%;
            margin: 1%;
            padding: 10px;
            text-align: center;
            transition: transform 0.2s, background-color 0.2s;
        }
        .shop-item:hover {
            background-color: #444;
            transform: scale(1.05);
        }
        .item-title {
            font-weight: bold;
            margin-bottom: 5px;
            font-size: 16px;
        }
        .item-price {
            color: #00ffff;
            margin-top: 5px;
        }
        .shop-button {
            margin-top: 8px;
            padding: 5px 10px;
            background-color: #333;
            border: 1px solid white;
            color: white;
            text-decoration: none;
            display: inline-block;
        }
        .shop-button:hover {
            background-color: white;
            color: black;
        }
        .dokuro-footer {
            text-align: center;
            margin-top: 20px;
            font-size: 16px;
        }
        .dokuro-icon {
            vertical-align: middle;
            width: 24px;
            height: 24px;
            margin-left: 8px;
        }
    </style>
    </head>
    <body>
    <h1>Dokuro Shop</h1>

    <div class='section'>
        <div class='section-title'>General Items</div>
        <div class='shop-grid'>
    "}



    // General Items
    html += shop_item(src, "Change Aura Color", 200, "aura_color")
    html += shop_item(src, "Change Eye Color", 100, "change_eye_color")
    html += shop_item(src, "+1 Child Slot (Key based)", 500, "child_slot_char")
    html += shop_item(src, "+1 Mystery Box", 500, "mystery_box_1")
    html += shop_item(src, "+1 Custom Object Sprite", 700, "custom_obj")
    html += shop_item(src, "+1 Custom Icon Sprite", 1000, "custom_icon")
    html += shop_item(src, "+5 Mystery Box", 1500, "mystery_box_5")
    html += shop_item(src, "+1 Max Child Slot (Key based)", 2000, "child_slot_global")
    html += shop_item(src, "Vote Mute Verb", 2000, "vote_mute")

    html += {"</div></div>"}

    // Custom Items
    html += {"
    <div class='section'>
        <div class='section-title'>Custom Items</div>
        <div class='shop-grid'>
    "}

   // html += shop_item(src, "Tanto Icon Weapon", 80, "tanto_icon")
   // html += shop_item(src, "Saiyan Tail with Ring", 100, "tail_ring")
    //html += shop_item(src, "Namekian Elder Skin", 250, "elder_skin")
    //html += shop_item(src, "Demon Unique Horns", 600, "demon_horns")
    //html += shop_item(src, "Custom Changeling Form (1st-4th)", 3000, "changeling_form")

    html += {"</div></div>"}

    // Dokuro Footer
    html += {"
    <div class='dokuro-footer'>
        <img class='dokuro-icon' src='DokuCoin.png'>
        You have <b>[C.dokuro_points]</b> Dokuro Coins
    </div>
    </body></html>
    "}
    html += {"
<div class='section'>
    <div style='text-align: center;'>
        <a class='shop-button' href='?src=\ref[src];dokuro_buy=1'>Buy Dokuro Coins</a>
    </div>
</div>
"}
    html += {"
<script>
    window.onunload = function() {
        document.location = '?src=\ref[src];dokuro_window_closed=1';
    };
</script>
</body></html>
"}


    C << browse(html, "window=dokuro_shop;size=700x600;params=1")



/*
/mob/proc/show_dokuro_shop()
    var/client/C = src.client
    if(!C) return

    var/html = {"
    <html>
    <head>
    <style>
        body {
            background-color: #111;
            color: #fff;
            font-family: Arial;
            padding: 10px;
        }
        h1 {
            text-align: center;
            color: #ff3366;
        }
        .shop-grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }
        .shop-item {
            background-color: #222;
            border: 2px solid #fff;
            border-radius: 8px;
            width: 30%;
            margin: 1%;
            padding: 10px;
            text-align: center;
            transition: transform 0.2s, background-color 0.2s;
        }
        .shop-item:hover {
            background-color: #444;
            transform: scale(1.05);
        }
        .item-title {
            font-weight: bold;
            margin-bottom: 5px;
            font-size: 16px;
        }
        .item-price {
            color: #00ffff;
            margin-top: 5px;
        }
        .shop-button {
            margin-top: 8px;
            padding: 5px 10px;
            background-color: #333;
            border: 1px solid white;
            color: white;
            text-decoration: none;
            display: inline-block;
        }
        .shop-button:hover {
            background-color: white;
            color: black;
        }
    </style>
    </head>
    <body>
    <h1>Dokuro Shop</h1>
    <div class='shop-grid'>
    "}

    // Main items
    html += shop_item("Change Eye Color/Aura Color", 200, "eye_color")
    html += shop_item("+1 Child Slot (This character)", 500, "child_slot_char")
    html += shop_item("+1 Mystery Box", 500, "mystery_box_1")
    html += shop_item("+1 Custom Hair Sprite", 700, "custom_hair")
    html += shop_item("+1 Custom Icon Sprite", 1000, "custom_icon")
    html += shop_item("+5 Mystery Box", 1500, "mystery_box_5")
    html += shop_item("+1 Child Slot (Global)", 2000, "child_slot_global")
    html += shop_item("Vote Mute Verb", 2000, "vote_mute")

    // Extra items
    html += shop_item("Tanto Icon Weapon", 80, "tanto_icon")
    html += shop_item("Saiyan Tail with Ring", 100, "tail_ring")
    html += shop_item("Namekian Elder Skin", 250, "elder_skin")
    html += shop_item("Demon Unique Horns", 600, "demon_horns")
    html += shop_item("Custom Changeling Form (1st-4th)", 3000, "changeling_form")

    html += {"</div></body></html>"}

    C << browse(html, "window=dokuro_shop;size=600x500")
*/
/*
/client/Topic(href, list/href_list)
    //set popup_menu = 0  // <--- Required to allow hrefs in browse() to trigger this!
    //world << "Topic() triggered. href: [href]"
    if(href_list["buy"])
        var/id = href_list["buy"]
        var/client/C = src
        if(!C) return

        world << "[src] is attempting to buy: [id]"

        var/cost = get_dokuro_cost(id)
        if(isnull(cost))
            C << "Invalid item."
            return

        if(C.dokuro_points < cost)
            C << "You do not have enough Dokuro."
            return

        C.dokuro_points -= cost
        C << "You purchased: [get_dokuro_name(id)] for [cost] Dokuro."

        grant_shop_item(src, id)

*/
obj/items/dokuro_coin
	abstract = TRUE
	admin_spawnable = FALSE
	can_pocket = 1
	stacks = 0
	density_factor = 0
	name = "Dokuro Coin"
	icon = 'Dokuro Coin.dmi'
	icon_state = ""
	rarity = 5
	is_dokuro = 1
	desc = "Raw meat, the worst quality of food."
	//Toxic buildup from taking drug
	base_type = "Strength"
	Click(location,control,params)
		..()
		//Removes this item from the global Items list.
		if(items)
			if(src in items) items -= src
		params = params2list(params)
		if(params["left"])
			if(isturf(src.loc))
				usr.pickup(src)

			else if(ismob(src.loc))
				if(usr.item_selected) usr.item_selected.overlays -= /obj/effects/select_item
				usr.item_selected = src
				src.overlays -= /obj/effects/select_item
				src.overlays += /obj/effects/select_item
//client/New()
//    ..()
 //   browse_rsc('sword.png')
 //   browse_rsc('armor.png')
