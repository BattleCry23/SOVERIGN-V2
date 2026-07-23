// ------------------------------------------------------------
// AUCTION HOUSE SYSTEM (Buyout-only, per-planet/realm)
// Planets/Realms: Earth, Namek, Vegeta, Icer, Heaven, Hell, Dark Realm
// Fee: 5% upfront
// Durations: 3 / 6 / 9 months (month = 2700 ticks)
// Delivery: buyer gets item via pickup(item,0)
// Seller gets Zenni immediately if online, otherwise stored for login payout
// ------------------------------------------------------------

var/global/list/AUCTION_HOUSES = list()           // name -> /datum/auction_house
var/global/obj/AUCTION_STORAGE = null             // escrow container

// Persistent-ish (in-memory) payout buffers (hook into Save later if desired)
var/global/list/GLOBAL_AUCTION_MAIL = list()      // ckey -> zenni amount
var/global/list/GLOBAL_AUCTION_RETURN = list()    // ckey -> list(obj/items)

// -------------------------
// Helpers
// -------------------------
/proc/AuctionMonthTicks()
	// 1 month = 45 minutes real time
	// 45 min * 60 sec * 10 ticks/sec = 27000 ticks
	return 27000 // originally 2700 for months

/proc/AuctionYearTicks()
	// 10 months = 1 year
	return AuctionMonthTicks() * 10

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

	// 🔥 LOAD SAVED DATA
	for(var/name in AUCTION_HOUSES)
		var/datum/auction_house/A = AUCTION_HOUSES[name]
		A.LoadAll()

	world.log << "AuctionHouse: setup complete & loaded."

/*/proc/SetupAuctionHouses()
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

	world.log << "AuctionHouse: setup complete ([AUCTION_HOUSES.len])" */

/proc/GetAuctionHouseByName(var/name)
	SetupAuctionHouses()
	return AUCTION_HOUSES[name]

/proc/GetAuctionHouseForZ(var/z)
	SetupAuctionHouses()
	for(var/name in AUCTION_HOUSES)
		var/datum/auction_house/A = AUCTION_HOUSES[name]
		if(A && A.z_level == z) return A
	return AUCTION_HOUSES["Earth"]

/proc/FormatTimeLeftVerbose(var/seconds)
	if(seconds <= 0) return "Expired"

	var/days = seconds / 86400
	seconds -= days * 86400
	var/hours = seconds / 3600
	seconds -= hours * 3600
	var/mins = seconds / 60
	seconds -= mins * 60

	var/list/parts = list()
	if(days) parts += "[days] day[days==1 ? "" : "s"]"
	if(hours) parts += "[hours] hour[hours==1 ? "" : "s"]"
	if(mins) parts += "[mins] minute[mins==1 ? "" : "s"]"
	if(seconds) parts += "[seconds] second[seconds==1 ? "" : "s"]"

	var/txt = ""
	for(var/i=1;i<=parts.len;i++)
		if(i==1) txt = parts[i]
		else txt += ", [parts[i]]"
	return txt

/proc/HtmlEscape(t as text)
	if(!t) return ""
	t = replacetext(t, "&", "&amp;")
	t = replacetext(t, "<", "&lt;")
	t = replacetext(t, ">", "&gt;")
	t = replacetext(t, "\"", "&quot;")
	return t

/proc/AuctionIconHTML(obj/O)
	if(!O) return ""
	var/icon/I = icon(O.icon, O.icon_state)
	I.Scale(32,32)
	var/r = fcopy_rsc(I)
	return "<img src='\ref[r]' width='32' height='32' style='vertical-align:middle;border:1px solid #333;border-radius:4px;'>"

// -------------------------
// Escrow container
// -------------------------
obj/auction_storage
	name = "Auction Escrow"
	density = 0
	layer = 0
	invisibility = 101

// -------------------
// Saving & Loading
//-------------------

/proc/SaveAllAuctionData()
    if(!AUCTION_HOUSES) return

    for(var/name in AUCTION_HOUSES)
        var/datum/auction_house/A = AUCTION_HOUSES[name]
        if(!A) continue

        for(var/id in A.listings)
            var/datum/auction_listing/L = A.listings[id]
            if(L)
                L.Save()

    SaveAuctionMail()

    world.log << "AuctionHouse: All listings and mail saved."

/proc/SaveAuctionMail()
    var/savefile/F = new("Saves/Auction/mail.sav")
    F["mail"] << GLOBAL_AUCTION_MAIL

/proc/LoadAuctionMail()
    if(fexists("Saves/Auction/mail.sav"))
        var/savefile/F = new("Saves/Auction/mail.sav")
        F["mail"] >> GLOBAL_AUCTION_MAIL

/datum/auction_listing/proc/Save()
	if(!house_name || !id) return

	var/path = GetSavePath()

	// Ensure directory exists
	fdel(path) // remove old file first (safe overwrite)

	var/savefile/F = new(path)

	F["id"] << id
	F["house_name"] << house_name
	F["seller_ckey"] << seller_ckey
	F["seller_name"] << seller_name
	F["price"] << price
	F["created_time"] << created_time
	F["duration_ticks"] << duration_ticks
	F["status"] << status
	F["quantity"] << quantity

	if(item_ref)
		F["item"] << item_ref

/proc/LoadAllAuctionListings()
	SetupAuctionHouses()

	for(var/house_name in AUCTION_HOUSES)
		var/datum/auction_house/A = AUCTION_HOUSES[house_name]
		if(!A) continue

		var/path = "data/auctions/[house_name]/"

		for(var/file in flist(path))
			var/full = "[path][file]"
			var/savefile/F = new(full)

			var/datum/auction_listing/L = new
			F["listing"] >> L

			if(L)
				A.listings[L.id] = L
				if(text2num(L.id) >= A.next_id)
					A.next_id = text2num(L.id) + 1

/proc/LoadAuctionListing(path)
	if(!fexists(path)) return null

	var/savefile/F = new(path)
	var/datum/auction_listing/L = new

	F["id"] >> L.id
	F["house_name"] >> L.house_name
	F["seller_ckey"] >> L.seller_ckey
	F["seller_name"] >> L.seller_name
	F["price"] >> L.price
	F["created_time"] >> L.created_time
	F["duration_ticks"] >> L.duration_ticks
	F["status"] >> L.status
	F["quantity"] >> L.quantity

	F["item"] >> L.item_ref

	if(L.item_ref)
		L.item_ref.loc = AUCTION_STORAGE

	LoadAuctionMail()

	return L

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
		obj/item_ref = null
		status = "active"   // active, sold, expired, cancelled
		quantity = 1



	proc/GetSavePath()
		return "data/auction/[house_name]/listing_[id].sav"
	proc/IsExpired()
		if(status != "active") return 0
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
	proc/SaveAll()
		for(var/id in listings)
			var/datum/auction_listing/L = listings[id]
			if(L)
				L.Save()
	proc/LoadAll()
		var/folder = "data/auction/[name]/"

		if(!fexists(folder))
			return

		var/list/files = flist(folder)

		for(var/f in files)
			if(findtext(f, ".sav"))
				var/full = "[folder][f]"
				var/datum/auction_listing/L = LoadAuctionListing(full)
				if(L)
					listings[L.id] = L
					if(text2num(L.id) >= next_id)
						next_id = text2num(L.id) + 1

	proc/AddListing(mob/seller, obj/items/I, price_per_unit, years, quantity)
		if(!seller || !seller.client) return "Invalid seller."
		if(!I) return "Invalid item."
		if(price_per_unit <= 0) return "Price must be above 0."
		if(!(years in list(1,2,3))) return "Invalid duration."
		if(quantity <= 0) return "Invalid quantity."

		var/available = (I.stacks <= 0 ? 1 : I.stacks)
		if(quantity > available)
			return "You do not have that many."

		// Determine deposit %
		var/deposit_percent = 0.05
		if(years == 2) deposit_percent = 0.06
		if(years == 3) deposit_percent = 0.07

		var/total_price = price_per_unit * quantity
		var/fee = round(total_price * deposit_percent)
		if(fee < 1) fee = 1

		if(seller.resources < fee)
			return "You need [fee] Zenni to pay the listing fee."

		seller.resources -= fee
		seller.refresh_inv()

		// HANDLE STACK SPLIT
		var/obj/items/auction_item

		if(available > 1 && quantity < available)
			// Split stack
			auction_item = new I.type
			auction_item.stacks = quantity
			auction_item.tech_lvl = I.tech_lvl
			auction_item.icon = I.icon
			auction_item.icon_state = I.icon_state
			auction_item.name = I.name
			auction_item.desc = I.desc
			I.stacks -= quantity
			if(I.stack_display)
			I.stack_display.maptext = "[css_outline]<font size=1><text align=right valign=bottom>[I.stacks]"
		else
			auction_item = I
			if(I.slot)
				if(seller.inv && seller.inv[I.slot] == I)
					seller.inv[I.slot] = null
				I.slot = 0
				I.vis_contents -= global.inv_slot

		seller.refresh_inv()

		auction_item.loc = AUCTION_STORAGE
		animate(auction_item)

		var/datum/auction_listing/L = new
		L.id = "[next_id++]"
		L.house_name = name
		L.seller_ckey = seller.ckey
		L.seller_name = seller.name
		L.price = total_price
		L.quantity = quantity
		L.created_time = world.time
		L.duration_ticks = years * AuctionMonthTicks()
		L.item_ref = auction_item

		listings[L.id] = L
		L.Save()

		return null

	/*proc/AddListing(mob/seller, obj/items/I, price, months)
		if(!seller || !seller.client) return "Invalid seller."
		if(!I) return "Invalid item."
		if(price <= 0) return "Price must be above 0."
		if(!(months in list(3,6,9))) return "Invalid duration."

		var/fee = round(price * 0.05)
		if(fee < 1) fee = 1

		if(seller.resources < fee)
			return "You need [fee] Zenni to pay the listing fee (5%)."

		if(I.bolted) return "This item is bolted."
		if(!I.can_pocket) return "This item cannot be auctioned."

		// charge fee
		seller.resources -= fee
		seller.refresh_inv()

		// remove from inventory slot if applicable
		if(I.slot)
			if(seller.inv && seller.inv[I.slot] == I)
				seller.inv[I.slot] = null
			I.slot = 0
			I.vis_contents -= global.inv_slot
			seller.refresh_inv()

		// escrow item
		I.loc = AUCTION_STORAGE
		animate(I)

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
		L.Save()

		return null*/

	proc/RemoveListing(var/id)
		var/datum/auction_listing/L = listings[id]
		if(!L) return

		// Delete save file FIRST
		fdel(L.GetSavePath())

		// Then remove from memory
		listings -= id


	proc/GetListing(var/id)
		return listings[id]

	proc/CleanupExpired()
		var/list/to_remove = list()

		for(var/id in listings)
			var/datum/auction_listing/L = listings[id]
			if(!L) continue
			if(!L.IsExpired()) continue

			L.status = "expired"
			var/obj/items/I = L.item_ref

			if(I && L.seller_ckey)
				if(!GLOBAL_AUCTION_RETURN[L.seller_ckey])
					GLOBAL_AUCTION_RETURN[L.seller_ckey] = list()
				GLOBAL_AUCTION_RETURN[L.seller_ckey] += I

			to_remove += id

		for(var/id2 in to_remove)
			RemoveListing(id2)


// ------------------------------------------------------------
// Background cleanup loop
// ------------------------------------------------------------
/proc/AuctionHouseLoop()
	set background = 1
	SetupAuctionHouses()
	while(TRUE)
		for(var/name in AUCTION_HOUSES)
			var/datum/auction_house/A = AUCTION_HOUSES[name]
			if(A) A.CleanupExpired()
		sleep(600)


// ------------------------------------------------------------
// Player payout + return delivery (call on login)
// ------------------------------------------------------------
/mob/proc/AuctionDeliverOfflineRewards()
	if(src.client && src.ckey)

		if(GLOBAL_AUCTION_MAIL[src.ckey] && GLOBAL_AUCTION_MAIL[src.ckey] > 0)
			var/amt = GLOBAL_AUCTION_MAIL[src.ckey]
			src.resources += amt
			src.refresh_inv()
			src << "<font color=yellow>You received [amt] Zenni from sold auctions.</font>"
			//GLOBAL_AUCTION_MAIL[src.ckey] = null
			GLOBAL_AUCTION_MAIL -= src.ckey


		if(GLOBAL_AUCTION_RETURN[src.ckey] && GLOBAL_AUCTION_RETURN[src.ckey].len)
			for(var/obj/items/I in GLOBAL_AUCTION_RETURN[src.ckey])
				if(I)
					I.loc = src
					src.pickup(I, 0)
			src << "<font color=yellow>Your expired/cancelled auction items were returned.</font>"
			GLOBAL_AUCTION_RETURN[src.ckey] = null



// ------------------------------------------------------------
// Main AH handler (called by client.Topic)
// ------------------------------------------------------------
/mob/proc/HandleAuctionHouse(list/h)
	SetupAuctionHouses()

	var/house = h["house"]
	if(!house || house == "")
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
	// BUY
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

		var/obj/items/I = L.item_ref
		if(!I)
			A.RemoveListing(id)
			src << "That item is no longer available."
			src.OpenAuctionHouse(house, "buy")
			return

		if(src.ckey == L.seller_ckey)
			src << "You cannot buy your own listing."
			src.OpenAuctionHouse(house, "buy")
			return

		if(src.resources < L.price)
			src << "You don't have enough Zenni."
			src.OpenAuctionHouse(house, "buy")
			return

		if(alert(src, "Buy [I.name] for [L.price] Zenni?\n\nSeller: [src.get_strangername(null,L.seller_name)]\nTime left: [L.TimeLeftText()]", "Confirm Purchase", "Yes", "No") != "Yes")
			src.OpenAuctionHouse(house, "buy")
			return

		// charge buyer
		src.resources -= L.price
		src.refresh_inv()

		// pay seller (online -> immediate, offline -> stored)
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
			if(!GLOBAL_AUCTION_MAIL[L.seller_ckey])
				GLOBAL_AUCTION_MAIL[L.seller_ckey] = 0
			GLOBAL_AUCTION_MAIL[L.seller_ckey] += L.price
		GLOBAL_AUCTION_MAIL -= L.seller_ckey

		// deliver item to buyer
		src.pickup(I, 0)
		src << "<b>Purchased:</b> [I.name]"

		A.RemoveListing(id)
		src.OpenAuctionHouse(house, "buy")
		L.Save()

		return

		// ----------------------------
	// SELL PICK
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

		// ------------------------
		// Determine max quantity
		// ------------------------
		var/max_qty = (I2.stacks <= 0 ? 1 : I2.stacks)
		var/quantity = 1

		if(max_qty > 1)
			quantity = input(src, "How many would you like to list?\n(Max: [max_qty])", "Quantity") as num|null
			if(!quantity || quantity <= 0 || quantity > max_qty)
				src.OpenAuctionHouse(house, "sell")
				return

		// ------------------------
		// Price PER UNIT
		// ------------------------
		var/price_per = input(src, "Set buyout price PER UNIT for [I2.name]:", "Auction Price") as num|null
		if(!price_per || price_per <= 0)
			src.OpenAuctionHouse(house, "sell")
			return

		// ------------------------
		// Duration
		// ------------------------
		var/years = input(src, "Choose duration (in years):", "Auction Duration") as null|anything in list(1,2,3)
		if(!years)
			src.OpenAuctionHouse(house, "sell")
			return

		// ------------------------
		// Determine deposit %
		// ------------------------
		var/deposit_percent = 0.05
		if(years == 2) deposit_percent = 0.06
		if(years == 3) deposit_percent = 0.07

		var/total_price = price_per * quantity
		var/fee = round(total_price * deposit_percent)
		if(fee < 1) fee = 1

		if(src.resources < fee)
			src << "You do not have enough Zenni to pay the deposit fee ([fee])."
			src.OpenAuctionHouse(house, "sell")
			return

		// ------------------------
		// Confirmation
		// ------------------------
		if(alert(src,
			"List [quantity]x [I2.name]\n\nPrice Per Unit: [price_per]\nTotal Price: [total_price] Zenni\n\nDuration: [years] year(s)\nDeposit: [round(deposit_percent*100)]%\nFee: [fee] Zenni\n\nDeposit is non-refundable.",
			"Confirm Listing",
			"Yes","No") != "Yes")
			src.OpenAuctionHouse(house, "sell")
			return

		// ------------------------
		// Call AddListing (NEW signature)
		// ------------------------
		var/err = A.AddListing(src, I2, price_per, years, quantity)
		if(err)
			src << err
			src.OpenAuctionHouse(house, "sell")
			return

		src << "<b>Listed:</b> [quantity]x [I2.name] for [total_price] Zenni ([years] years)."
		src.OpenAuctionHouse(house, "sell")
		return


	// ----------------------------
	// CANCEL MY LISTING
	// ----------------------------
	if(action == "my_cancel")
		var/idc = h["id"]
		var/datum/auction_listing/Lc = A.GetListing(idc)
		if(!Lc || Lc.seller_ckey != src.ckey)
			src << "That listing is no longer yours."
			src.OpenAuctionHouse(house, "my")
			return

		if(alert(src, "Cancel auction for [Lc.item_ref ? Lc.item_ref.name : "item"]?\n\nThis returns the item but does NOT refund the 5% fee.", "Cancel Listing", "Yes", "No") != "Yes")
			src.OpenAuctionHouse(house, "my")
			return

		Lc.status = "cancelled"
		var/obj/items/It = Lc.item_ref
		if(It)
			if(!GLOBAL_AUCTION_RETURN[src.ckey])
				GLOBAL_AUCTION_RETURN[src.ckey] = list()
			GLOBAL_AUCTION_RETURN[src.ckey] += It

		A.RemoveListing(idc)
		src.AuctionDeliverOfflineRewards()
		src.OpenAuctionHouse(house, "my")
		return

	// default
	src.OpenAuctionHouse(house, "buy")


// ------------------------------------------------------------
// UI
// ------------------------------------------------------------
/mob/proc/OpenAuctionHouse(var/house_name, var/tab = "buy")
	var/datum/auction_house/A = GetAuctionHouseByName(house_name)
	if(!A)
		src << "Auction house not found."
		return

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
	.footer{margin-top:10px;color:#7f8aa0;font-size:11px;}
	</style>
	"}

	var/tabs = {"
	<div class='tabs'>
		<a class='tab [tab=="buy"?"active":""]' href='?src=\ref[src];ah=1;house=[url_encode(A.name)];tab=buy'>Buy</a>
		<a class='tab [tab=="sell"?"active":""]' href='?src=\ref[src];ah=1;house=[url_encode(A.name)];tab=sell'>Sell</a>
		<a class='tab [tab=="my"?"active":""]' href='?src=\ref[src];ah=1;house=[url_encode(A.name)];tab=my'>My Listings</a>
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
			<div class='sub'>Listing fee: <b>5%</b> | Durations: <b>1 / 2 / 3 year(s)</b></div>
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
				if(L.status != "active") continue
				var/obj/items/O = L.item_ref
				if(!O) continue

				var/icon_html = AuctionIconHTML(O)
				var/name = HtmlEscape(O.name)
				var/desc = HtmlEscape(O.desc)
				if(!desc || desc=="") desc = "No description."

				var/left = L.TimeLeftText()
				var/left_class = (L.SecondsLeft() <= 60) ? "bad" : "muted"

				html += {"
				<tr class='row' title='[desc]'>
					<<td>[icon_html] <b>[name]</b> <span class='muted'>(x[L.quantity])</span></td>
					<td class='muted'>[HtmlEscape(L.seller_name)]</td>
					<td><b>[L.price]</b> Zenni</td>
					<td class='[left_class]'>[left]</td>
					<td><a class='btn' href='?src=\ref[src];ah=1;action=buy;house=[url_encode(A.name)];id=[id]'>Buy</a></td>
				</tr>
				"}

		html += "</table>"
		html += "<div class='footer'>Tip: Hover a listing to see the item's description.</div>"

	if(tab == "sell")
		var/list/sellables = list()
		for(var/obj/items/I in src)
			if(I && I.loc !=null)
				if(I && I.can_pocket)
					if(!I.bolted && !I.is_zenni && !I.is_dokuro && !I.food && !I.artifact)
						sellables += I

		html += "<div class='muted'>Choose an item to list. You pay <b>5-7%</b> of your chosen price as a listing fee depending on the duration set (non-refundable).</div><br>"
		html += "<table><tr><th>Item</th><th>Info</th><th></th></tr>"

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
					<td><a class='btn' href='?src=\ref[src];ah=1;action=sell_pick;house=[url_encode(A.name)];ref=\ref[I2]'>Sell</a></td>
				</tr>
				"}

		html += "</table>"
		html += "<div class='footer'>Tip: Hover an item to see its description.</div>"

	if(tab == "my")
		html += "<table>"
		html += "<tr><th>Item</th><th>Price</th><th>Time Left</th><th></th></tr>"

		var/found = 0
		for(var/id in A.listings)
			var/datum/auction_listing/Lm = A.listings[id]
			if(!Lm) continue
			if(Lm.status != "active") continue
			if(Lm.seller_ckey != src.ckey) continue

			found = 1
			var/obj/items/O2 = Lm.item_ref
			var/icon_html3 = AuctionIconHTML(O2)
			var/name3 = HtmlEscape(O2 ? O2.name : "Item")
			var/desc3 = HtmlEscape(O2 ? O2.desc : "")
			if(!desc3 || desc3=="") desc3 = "No description."

			html += {"
			<tr class='row' title='[desc3]'>
				<td>[icon_html3] <b>[name3]</b> <span class='muted'>(x[Lm.quantity])</span></td>
				<td><b>[Lm.price]</b> Zenni</td>
				<td class='muted'>[Lm.TimeLeftText()]</td>
				<td><a class='btn' href='?src=\ref[src];ah=1;action=my_cancel;house=[url_encode(A.name)];id=[id]'>Cancel</a></td>
			</tr>
			"}

		if(!found)
			html += "<tr><td colspan=4 class='muted'>You have no active listings.</td></tr>"

		html += "</table>"
		html += "<div class='footer'>Cancel returns the item, but does not refund the 5% fee.</div>"

	html += "</div></body></html>"
	src << browse(html, "window=auction_house;size=720x560")
