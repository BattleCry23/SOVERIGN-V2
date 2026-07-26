// ------------------------------------------------------------
// AUCTION HOUSE SYSTEM (Buyout-only, per-planet/realm)
// Planets/Realms: Earth, Namek, Vegeta, Icer, Heaven, Hell, Dark Realm
// Fee: 5% upfront
// Durations: 3 / 6 / 9 months (month = 2700 ticks based on your years() loop)
// Delivery: immediate zenni to seller, item to buyer via pickup(item,0)
// ------------------------------------------------------------

var/global/list/AUCTION_HOUSES = list() // name -> /datum/auction_house
var/global/obj/AUCTION_STORAGE = null    // escrow container

/proc/AuctionMonthTicks()
	// Your world/proc/years() runs every spawn(2700) and increments month counters.
	// So 1 "month" = 2700 ticks in your game.
	return 2700

/proc/SetupAuctionHouses()
	if(AUCTION_HOUSES && AUCTION_HOUSES.len) return

	if(!AUCTION_STORAGE)
		AUCTION_STORAGE = new /obj/auction_storage
		AUCTION_STORAGE.loc = null

	AUCTION_HOUSES["Earth"]      = new /datum/auction_house("Earth", 1)
	AUCTION_HOUSES["Namek"]      = new /datum/auction_house("Namek", 4)
	AUCTION_HOUSES["Icer"]       = new /datum/auction_house("Icer", 9)
	AUCTION_HOUSES["Vegeta"]     = new /datum/auction_house("Vegeta", 10)
	AUCTION_HOUSES["Heaven"]     = new /datum/auction_house("Heaven", 11)
	AUCTION_HOUSES["Hell"]       = new /datum/auction_house("Hell", 6)
	AUCTION_HOUSES["Dark Realm"] = new /datum/auction_house("Dark Realm", 12)

	world.log << "AuctionHouse: setup complete ([AUCTION_HOUSES.len])"

/proc/GetAuctionHouseByName(var/name)
	SetupAuctionHouses()
	return AUCTION_HOUSES[name]

/proc/GetAuctionHouseForZ(var/z)
	SetupAuctionHouses()
	for(var/name in AUCTION_HOUSES)
		var/datum/auction_house/A = AUCTION_HOUSES[name]
		if(A && A.z_level == z)
			return A
	// fallback
	return AUCTION_HOUSES["Earth"]


/proc/GetAuctionHouse(realm)
	if(!AUCTION_HOUSES[realm])
		AUCTION_HOUSES[realm] = list()
	return AUCTION_HOUSES[realm]

/proc/FormatTimeLeftVerbose(var/seconds)
	if(seconds <= 0) return "Expired"

	var/days = seconds / 86400
	seconds -= days * 86400
	var/hours = seconds / 3600
	seconds -= hours * 3600
	var/mins = seconds / 60
	seconds -= mins * 60

	var/list/parts = list()
	if(days)  parts += "[days] day[days==1?"":"s"]"
	if(hours) parts += "[hours] hour[hours==1?"":"s"]"
	if(mins)  parts += "[mins] minute[mins==1?"":"s"]"
	if(seconds) parts += "[seconds] second[seconds==1?"":"s"]"

	var/txt = ""
	for(var/i=1;i<=parts.len;i++)
		if(i==1) txt = parts[i]
		else txt += ", [parts[i]]"
	return txt

// ------------------------------------------------------------
// Escrow container for auction items
// ------------------------------------------------------------
obj/auction_storage
	name = "Auction Escrow"
	density = 0
	layer = 0
	invisibility = 101

// ------------------------------------------------------------
// Listing datum
// ------------------------------------------------------------
/datum/auction_listing
	var
		id
		house_name
		seller_ckey
		seller_name
		price = 0
		created_time = 0
		duration_ticks = 0
		obj/item_ref = null // escrowed item
		realm
		expire_year
		created_year
		status = "active"   // active, sold, expired, cancelled



	proc/IsExpired()
		if(!created_time || !duration_ticks) return 1
		return (world.time >= (created_time + duration_ticks))

	proc/SecondsLeft()
		var/left = (created_time + duration_ticks) - world.time
		if(left <= 0) return 0
		return round(left / 10)

	proc/TimeLeftText()
		return FormatTimeLeftVerbose(SecondsLeft())

// ------------------------------------------------------------
// Auction house datum
// ------------------------------------------------------------
/datum/auction_house
	var
		name
		z_level
		list/listings = list() // id -> /datum/auction_listing
		next_id = 1

	New(_name, _z)
		..()
		name = _name
		z_level = _z

	proc/AddListing(mob/seller, obj/I, price, months)
		if(!seller || !seller.client) return "Invalid seller."
		if(!I) return "Invalid item."
		if(price <= 0) return "Price must be above 0."
		if(!(months in list(3,6,9))) return "Invalid duration."

		// Fee = 5% upfront
		var/fee = round(price * 0.05)
		if(fee < 1) fee = 1

		if(seller.resources < fee)
			return "You need [fee] Zenni to pay the listing fee (5%)."

		// Remove item from player (must be pocketable)
		if(I.bolted) return "This item is bolted."
		if(!I.can_pocket) return "This item cannot be auctioned."

		// Charge fee
		seller.resources -= fee
		seller.refresh_inv()

		// Take item out of inventory safely if it was in a slot
		if(istype(I, /obj/items))
			if(I.slot)
				// remove from inv slot
				if(seller.inv && seller.inv[I.slot] == I)
					seller.inv[I.slot] = null
				I.slot = 0
				I.vis_contents -= global.inv_slot
				seller.refresh_inv()

		// Escrow item
		I.loc = AUCTION_STORAGE
		animate(I) // stop any stray anims

		// Create listing
		var/datum/auction_listing/L = new
		L.id = "[next_id++]"
		L.house_name = name
		L.seller_ckey = seller.ckey
		L.seller_name = seller.name
		L.price = price
		L.created_time = world.time
		L.duration_ticks = months * AuctionMonthTicks()
		L.item_ref = I

		listings[L.id] = L

		return null // success

	proc/RemoveListing(var/id)
		if(listings[id])
			listings -= id

	proc/GetListing(var/id)
		return listings[id]

	proc/CleanupExpired()
		// Return expired items (simple behavior):
		// - If seller online -> give back via pickup(item,0)
		// - Else drop at a safe turf on that z (1,1,z) fallback
		var/list/to_remove = list()

		for(var/id in listings)
			var/datum/auction_listing/L = listings[id]
			if(!L) continue
			if(!L.IsExpired()) continue

			var/obj/I = L.item_ref
			if(I)
				var/mob/seller = null
				for(var/mob/M in players)
					if(M.client && M.ckey == L.seller_ckey)
						seller = M
						break

				if(seller)
					seller.pickup(I, 0)
					seller << "<b>Auction expired:</b> [I.name] was returned to you."
				else
					var/turf/T = locate(1,1,z_level)
					if(T) I.loc = T
					else I.loc = null

			to_remove += id

		for(var/id2 in to_remove)
			RemoveListing(id2)


// ------------------------------------------------------------
// Simple background cleanup loop
// ------------------------------------------------------------
/proc/AuctionHouseLoop()
	set background = 1
	SetupAuctionHouses()
	while(TRUE)
		for(var/name in AUCTION_HOUSES)
			var/datum/auction_house/A = AUCTION_HOUSES[name]
			if(A) A.CleanupExpired()
		sleep(600) // every 60 seconds (10 ticks/sec)



/mob/proc/HandleAuctionHouse(list/h)
	SetupAuctionHouses()

	var/house = h["house"]
	if(!house || house == "")
		// fallback based on your current z
		var/datum/auction_house/A0 = GetAuctionHouseForZ(src.z)
		house = A0.name

	var/tab = h["tab"]
	if(tab && tab != "")
		src.OpenAuctionHouse(house, tab)
		return

	var/action = h["action"]

	var/datum/auction_house/A = GetAuctionHouseByName(house)
	if(!A)
		src << "Auction house not found."
		return

	// ----------------------------
	// BUY FLOW
	// ----------------------------
	if(action == "buy")
		var/id = h["id"]
		var/datum/auction_listing/L = A.GetListing(id)
		if(!L)
			src << "That listing no longer exists."
			src.OpenAuctionHouse(house, "buy")
			return

		if(L.IsExpired())
			A.CleanupExpired()
			src << "That listing expired."
			src.OpenAuctionHouse(house, "buy")
			return

		var/obj/I = L.item_ref
		if(!I)
			A.RemoveListing(id)
			src << "That item is no longer available."
			src.OpenAuctionHouse(house, "buy")
			return

		// Prevent buying your own auction (optional)
		if(src.ckey == L.seller_ckey)
			src << "You cannot buy your own listing."
			src.OpenAuctionHouse(house, "buy")
			return

		if(src.resources < L.price)
			src << "You don't have enough Zenni."
			src.OpenAuctionHouse(house, "buy")
			return

		if(alert(src, "Buy [I.name] for [L.price] Zenni?\n\nSeller: [L.seller_name]\nTime left: [L.TimeLeftText()]", "Confirm Purchase", "Yes", "No") != "Yes")
			src.OpenAuctionHouse(house, "buy")
			return

		// Charge buyer
		src.resources -= L.price
		src.refresh_inv()

		// Pay seller (online only, as you requested no mailbox)
		var/mob/seller = null
		for(var/mob/M in players)
			if(M.client && M.ckey == L.seller_ckey)
				seller = M
				break

		if(seller)
			seller.resources += L.price
			seller.refresh_inv()
			seller << "<b>Auction Sold:</b> [I.name] sold for [L.price] Zenni."
		else
			// Seller offline: per your spec, "automatically gets zenni" implies online.
			// If you truly want offline too, you'd need persistence.
			world.log << "AuctionHouse: Seller offline for listing [id] ([L.seller_ckey]); zenni not delivered."

		// Deliver item to buyer
		src.pickup(I, 0)
		src << "<b>Purchased:</b> [I.name]"

		// Remove listing
		A.RemoveListing(id)

		src.OpenAuctionHouse(house, "buy")
		return

	// ----------------------------
	// SELL FLOW (pick item -> set price -> pick duration)
	// ----------------------------
	if(action == "sell_pick")
		var/refstr = h["ref"]
		var/obj/items/I2 = locate(refstr)
		if(!I2 || I2.loc != src)
			src << "That item is no longer in your inventory."
			src.OpenAuctionHouse(house, "sell")
			return

		if(!I2.can_pocket || I2.bolted)
			src << "That item cannot be auctioned."
			src.OpenAuctionHouse(house, "sell")
			return

		var/price = input(src, "Set buyout price for [I2.name]:", "Auction Price") as num|null
		if(!price || price <= 0)
			src.OpenAuctionHouse(house, "sell")
			return

		var/months = input(src, "Choose duration (in months):", "Auction Duration") as null|anything in list(3,6,9)
		if(!months)
			src.OpenAuctionHouse(house, "sell")
			return

		var/fee = round(price * 0.05)
		if(fee < 1) fee = 1

		if(alert(src, "List [I2.name] for [price] Zenni?\n\nDuration: [months] months\nListing fee (5%): [fee] Zenni\n\nFee is paid immediately.", "Confirm Listing", "Yes", "No") != "Yes")
			src.OpenAuctionHouse(house, "sell")
			return

		var/err = A.AddListing(src, I2, price, months)
		if(err)
			src << err
			src.OpenAuctionHouse(house, "sell")
			return

		src << "<b>Listed:</b> [I2.name] for [price] Zenni ([months] months)."
		src.OpenAuctionHouse(house, "sell")
		return

	// Default: reopen
	src.OpenAuctionHouse(house, "buy")



// ------------------------------------------------------------
// UI Helpers
// ------------------------------------------------------------

/proc/AuctionIconHTML(obj/O)
	if(!O) return ""
	// Create a render resource for the icon/state (small)
	var/icon/I = icon(O.icon, O.icon_state)
	I.Scale(32,32)
	var/r = fcopy_rsc(I)
	return "<img src='\ref[r]' width='32' height='32' style='vertical-align:middle;border:1px solid #333;border-radius:4px;'>"

/proc/HtmlEscape(t as text)
	if(!t) return ""
	t = replacetext(t, "&", "&amp;")
	t = replacetext(t, "<", "&lt;")
	t = replacetext(t, ">", "&gt;")
	t = replacetext(t, "\"", "&quot;")
	return t

/mob/proc/OpenAuctionHouse(var/house_name, var/tab = "buy")
	var/datum/auction_house/A = GetAuctionHouseByName(house_name)
	if(!A)
		src << "Auction house not found."
		return

	// Clean expired before render
	A.CleanupExpired()

	var/title = "Auction House - [A.name]"
	var/css = {"
	<style>
	body{background:#0b0e14;color:#d6d6d6;font-family:Verdana;margin:0;padding:12px;}
	.header{display:flex;align-items:center;justify-content:space-between;margin-bottom:10px;}
	.h1{font-size:22px;font-weight:bold;color:#ffcc55;letter-spacing:1px;}
	.sub{font-size:12px;color:#9aa4b2;}
	.tabs{display:flex;gap:8px;margin:10px 0;}
	.tab{padding:8px 12px;border:1px solid #2b3442;border-radius:8px;background:#121722;color:#d6d6d6;text-decoration:none;}
	.tab.active{background:#1b2433;border-color:#4a5a74;color:#ffffff;}
	.panel{border:1px solid #2b3442;border-radius:10px;background:#111620;padding:10px;}
	table{width:100%;border-collapse:collapse;}
	th{font-size:12px;text-align:left;color:#ffaa00;padding:8px;border-bottom:1px solid #2b3442;}
	td{padding:8px;border-bottom:1px solid #1f2734;font-size:12px;vertical-align:middle;}
	.row:hover{background:#141c28;}
	.btn{display:inline-block;padding:6px 10px;border-radius:8px;border:1px solid #3b465a;background:#1b2433;color:white;text-decoration:none;}
	.btn:hover{background:#263247;}
	.muted{color:#9aa4b2;}
	.bad{color:#ff7777;}
	.good{color:#7dff9a;}
	.small{font-size:11px;}
	.footer{margin-top:10px;color:#7f8aa0;font-size:11px;}
	</style>
	"}

	var/tabs = {"
	<div class='tabs'>
		<a class='tab [tab=="buy"?"active":""]' href='?src=\ref[src];ah=1;house=[url_encode(A.name)];tab=buy'>Buy</a>
		<a class='tab [tab=="sell"?"active":""]' href='?src=\ref[src];ah=1;house=[url_encode(A.name)];tab=sell'>Sell</a>
		<a class='tab' href='?src=\ref[src];ah=1;house=[url_encode(A.name)];tab=close'>Close</a>
	</div>
	"}

	if(tab == "close")
		src << browse(null, "window=auction_house")
		return

	var/html = "<html><head>[css]</head><body>"

	html += {"
	<div class='header'>
		<div>
			<div class='h1'>[title]</div>
			<div class='sub'>Listing fee: <b>5%</b> | Durations: <b>3 / 6 / 9 months</b></div>
		</div>
		<div class='sub'>Your Zenni: <b>[src.resources]</b></div>
	</div>
	[tabs]
	<div class='panel'>
	"}

	if(tab == "buy")
		html += "<table>"
		html += "<tr><th>Item</th><th>Seller</th><th>Buyout</th><th>Time Left</th><th></th></tr>"

		if(!A.listings.len)
			html += "<tr><td colspan=5 class='muted'>No listings right now.</td></tr>"
		else
			for(var/id in A.listings)
				var/datum/auction_listing/L = A.listings[id]
				if(!L) continue
				var/obj/O = L.item_ref
				if(!O) continue

				var/icon_html = AuctionIconHTML(O)
				var/name = HtmlEscape(O.name)
				var/desc = HtmlEscape(O.desc)
				if(!desc || desc=="") desc = "No description."

				var/left = L.TimeLeftText()
				var/left_class = (L.SecondsLeft() <= 60) ? "bad" : "muted"

				html += {"
				<tr class='row' title='[desc]'>
					<td>[icon_html] <b>[name]</b></td>
					<td class='muted'>[HtmlEscape(L.seller_name)]</td>
					<td><b>[L.price]</b> Zenni</td>
					<td class='[left_class]'>[left]</td>
					<td>
						<a class='btn' href='?src=\ref[src];ah=1;action=buy;house=[url_encode(A.name)];id=[id]'>Buy</a>
					</td>
				</tr>
				"}

		html += "</table>"
		html += "<div class='footer'>Tip: Hover a listing to see the item's description.</div>"

	if(tab == "sell")
		// Gather auctionable items from inventory (src contents)
		var/list/sellables = list()
		for(var/obj/items/I in src.contents)
			if(!I) continue
			if(I.can_pocket && !I.bolted && !I.is_zenni && !I.is_dokuro)
				sellables += I

		html += "<div class='small muted'>Choose an item to list. You will pay <b>5%</b> of your chosen price as a listing fee (non-refundable).</div><br>"
		html += "<table>"
		html += "<tr><th>Item</th><th>Info</th><th></th></tr>"

		if(!sellables.len)
			html += "<tr><td colspan=3 class='muted'>You have no auctionable items in your inventory.</td></tr>"
		else
			for(var/obj/items/I2 in sellables)
				var/icon_html2 = AuctionIconHTML(I2)
				var/n2 = HtmlEscape(I2.name)
				var/d2 = HtmlEscape(I2.desc)
				if(!d2 || d2=="") d2 = "No description."

				html += {"
				<tr class='row' title='[d2]'>
					<td>[icon_html2] <b>[n2]</b></td>
					<td class='muted'>Stacks: [I2.stacks <= 0 ? 1 : I2.stacks] | Tech Lv: [I2.tech_lvl]</td>
					<td>
						<a class='btn' href='?src=\ref[src];ah=1;action=sell_pick;house=[url_encode(A.name)];ref=\ref[I2]'>Sell</a>
					</td>
				</tr>
				"}

		html += "</table>"
		html += "<div class='footer'>Tip: Hover an item to see its description.</div>"

	html += "</div></body></html>"

	src << browse(html, "window=auction_house;size=720x560")
