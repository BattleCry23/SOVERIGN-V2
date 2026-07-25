proc/SpawnTechItem(var/mob/m, var/year, var/ultra)
	var/list/tech_pool = list()

	for(var/typepath in typesof(/obj/items/tech/))
		if(typepath == /obj/items/tech/) continue
		if(typepath == /obj/items/tech/Fuel) continue
		if(typepath == /obj/items/tech/Oxygen) continue
		if(typepath == /obj/items/Scissors) continue
		if(typepath == /obj/items/Hair_Dye) continue
		if(typepath == /obj/items/Bedroll) continue
		if(typepath == /obj/items/tech/armors/) continue
		if(typepath == /obj/items/tech/weapons/) continue
		if(typepath == /obj/items/tech/Capsule) continue

		// Create temp object to inspect vars
		var/obj/items/tech/T = new typepath
		if(!T) continue

		// 🚫 Skip perks or anything not pocketable
		if(!T.can_pocket)
			//del(T)
			continue

		// Era lock
		if(year < 30)
			if(findtext("[typepath]", "pod")) { continue }
			if(findtext("[typepath]", "ship")) { continue }

		tech_pool += typepath
		qdel(T)

	if(!tech_pool.len)
		SpawnZenni(m, year)
		return

	var/path = pick(tech_pool)
	var/obj/items/tech/NewTech = new path(m.loc)

	// Randomized tech level scaling
	var/max_lvl = clamp(round(year + rand(100,1000) / 2), 1, 10000)

	if(ultra)
		NewTech.tech_lvl = rand(max_lvl, max_lvl*2)
	else
		NewTech.tech_lvl = rand(400, max_lvl)
	if(istype(NewTech, /obj/items/tech/weights/))
		var/obj/items/tech/weights/W = NewTech

		// Base scaling by year
		var/base_weight = max(5, round(year * 1.5))

		// Quality multiplier
		var/quality_mult = max(1, W.tech_lvl)

		// Ultra multiplier
		if(ultra)
			quality_mult *= pick(1.1,1.2,1.3,1.4,1.1,1.5,2,3,4)

		// Final randomized weight
		W.weight = round(rand(base_weight, base_weight * 1.25) * quality_mult)

		// Safety floor
		if(W.weight < 5)
			W.weight = rand(5, 50)

		// Update name + description
		W.name = "[initial(W.name)] ([W.weight]kg)"
		W.desc_extra = "- [W.weight]kg weights\n\n"

	m.pickup(NewTech)


	m << "<font color=green>Mystery Box: You obtained [NewTech.name] (Quality: [NewTech.tech_lvl]%)!</font>"
proc/SpawnFoodItem(var/mob/m)
	var/list/food_pool = typesof(/obj/items/consumables/food/)
	if(!food_pool.len) return

	var/path = pick(food_pool)
	var/obj/items/I = new path(m.loc)

	var/list/stack_rng = list(1,2,3,4,5,10)
	if(istype(I,/obj/items/consumables/food/special/))
		I.stacks = -1
	else I.stacks = pick(stack_rng)

	m.pickup(I)
	m << "<font color=orange>Mystery Box: You obtained [I.stacks]x [I.name]!</font>"

proc/SpawnSpecialItem(var/mob/m)
	var/list/special_pool = list()

	special_pool += typesof(/obj/items/consumables/food/special/)

	if(!special_pool.len) return

	var/path = pick(special_pool)
	var/obj/items/I = new path(m.loc)
	//I.stacks = 1

	m.pickup(I)
	m << "<font color=#66ffff>Mystery Box: You obtained a [I.name]!</font>"

proc/SpawnZenni(var/mob/m, var/year)
	var/base = rand(100,1050)

	// Scale by year
	var/mult = clamp(year / 10, 1, 50)

	var/amount = round(base * (1 + mult*0.5))
	amount *= pick (1,1,1.2,1.1,1.3,1.4,1.5,1.6,1.7,1.8,1.1,1.2,1)
	m.resources += round(amount,1)
	m.update_rsc()

	m << "<font color=yellow>Mystery Box: You found [round(amount,1)] Zenni inside!</font>"

proc/SpawnMineral(var/mob/m, var/year)

	var/list/mineral_pool = list(
		/obj/items/minerals/Stone,
		/obj/items/minerals/Copper,
		/obj/items/minerals/Coal,
		/obj/items/minerals/Gold,
		/obj/items/minerals/Silver,
		/obj/items/minerals/Titanium,
		/obj/items/minerals/Mystille
	)

	// Era lock stronger minerals
	if(year < 3)
		mineral_pool -= /obj/items/minerals/Titanium
		mineral_pool -= /obj/items/minerals/Mystille

	if(!mineral_pool.len)
		return

	// RNG how many types (extremely random feel)
	var/type_count = pick(1,1,1,2,2,3,4,5,6,2,3,1,3,4,1,5,2,3) // weighted toward 1

	if(type_count > mineral_pool.len)
		type_count = mineral_pool.len

	// Shuffle pool
	mineral_pool = ShuffleList(mineral_pool)

	for(var/i = 1, i <= type_count, i++)
		var/path = mineral_pool[i]
		var/obj/items/minerals/MIN = new path()

		// RNG stack size
		var/list/stack_rng = list(500,1000,1500,2000,2500,3000,4000,5000,7500,8000,9000)
		MIN.stacks = pick(stack_rng)

		// Era scaling
		if(year <= 50)
			MIN.stacks = round(MIN.stacks * rand(1.1,1.2))
		else
			MIN.stacks = round(MIN.stacks * rand(1.25,2))

		// Give using mineral logic
		m.digging_mins(MIN,1)

		m << "<font color=#b3ff66>Mystery Box: You discovered [MIN.stacks]x [MIN.name] inside the Mystery Box!</font>"

proc/ShuffleList(var/list/L)
	for(var/i = L.len, i > 1, i--)
		var/j = rand(1, i)
		var/temp = L[i]
		L[i] = L[j]
		L[j] = temp
	return L
