/datum/resource_vein
    var/mineral
    var/quantity
    var/initial_quantity

    New(var/min, var/qty)
        mineral = min
        quantity = qty
        initial_quantity = qty

    proc/replenish()
        if (quantity <= 0)
            spawn(27000) // 45 minutes
                quantity = initial_quantity
var/global/planet_resources = list(
    "Earth" = list("Coal" = 40, "Stone" = 75, "Gold" = 5,"Titanium" = 20, "Copper" = 50, "Mystille" = 2,"Silver" = 4),
    "Vegeta" = list("Mystille" = 2, "Titanium" = 20, "Coal" = 30,"Copper"=40,"Gold"=5,"Stone"=75, "Silver" = 6),
    "Icer" = list("Titanium" = 30, "Gold" = 10, ,"Silver" = 6, "Mystille" = 3, "Copper" = 50,"Stone" = 65, "Coal" = 15),
    "Namek" = list("Gold" = 15, "Coal" = 30,"Copper" = 50, "Stone" = 75, "Titanium"=10,"Mystille" = 3,"Silver" = 8)
)

var/global/mineral_paths = list(
    "Stone" = /obj/items/minerals/Stone,
    "Silver" = /obj/items/minerals/Silver,
    "Copper" = /obj/items/minerals/Copper,
    "Coal" = /obj/items/minerals/Coal,
    "Gold" = /obj/items/minerals/Gold,
    "Mystille" = /obj/items/minerals/Mystille,
    "Titanium" = /obj/items/minerals/Titanium
)
// Global list of color profiles and who owns them
var/list/AdminColorProfiles = list(
    "Admin Grey" = "Grey",
    "Admin Blue" = "Blue",
    "Admin Cyan" = "Cyan",
    "Admin Gold" = "Gold",
    "Admin Green" = "Green",
    "Admin Orange" = "Orange",
    "Admin Pink" = "Pink",
    "Admin Purple" = "Purple",
    "Admin Red" = "Red",
    "Admin Silver" = "Silver",
    "Admin White" = "White",
    "Admin Yellow" = "Yellow"
)

var/list/ALL_ITEM_TYPES


var
	WorldTime
	ooc_allowed = 1
	list/ActiveChildren=list()
	list/ban_list=list()
	list/Testers=list()
	MonthClicks=0
	CheckClicks=0

var/Ranks={"<html>
<head><title>Ranks</title><body>
<body bgcolor="#000000"><font size=2><font color="white">
<center><hr><br><font size=7><b><u>RANKS</u></b></font></hr>
<br><br>
<font size=5>
<u><b>Earth</b></u><br></font>

Gaurdian: <i>VACANT</i><br>
Red Ribbon Army Leader: <i>VACANT</i><br>
Turtle Hermit: <i>VACANT</i><br>
Crane Hermit: <I>VACANT</i><br>
Academy Masterr: <i>VACANT</i><br>
<br>

<font size=3><u><b>Namek</b></u><br></font>
Elder: <i>VACANT</i><br>
Academy Master: <i>VACANT</i><br>
<br>

<font size=3><u><b>Vegeta</b></u><br></font>
King/Queen: <i>VACANT</i><br>
General: <i>VACANT</i><br>
Academy Master: <i>VACANT</i><br>
<br>

<font size=3><u><b>Icer</b></u><br></font>
Icer Lord: <i>VACANT</i><br>
Icer General: <i>VACANT</i><br>
Academy Master: <i>VACANT</i><br>
<br>

<font size=3><u><b>Space</b></u><br></font>
Space Pirate: <i>VACANT</i><br>
Yardrat Master: <i>VACANT</i><br>
<br>

<font size=3><u><b>Checkpoint</b></u><br></font>
Supreme Kai: <i>VACANT</i><br>
Grand Kai: <i>VACANT</i><br>
North Kai: <i>VACANT</i><br>
South Kai: <i>VACANT</i><br>
East Kai: <i>VACANT</i><br>
West Kai: <i>VACANT</i><br>
Checkpoint Guardian: <i>VACANT</i><br>
<br>

<font size=3><u><b>Hell</b></u><br></font>
Demon Lord: <i>VACANT</i><br>
Academy Master: <i>VACANT</i><br>
<br>

<font size=3><u><b>Dark Realm</b></u><br></font>
Dark King: <i>VACANT</i><br>
<br>


</body><html>"}

var/Story={"<html>
<head><title>Story</title><body>
<center><body bgcolor="#000000"><font size=2><font color="#CCCCCC">



</body><html>"}

var/Help="<u><b>/ commands</b></u>\n/ahc - Admin Help Channel\n/cd - Countdown\n/gf - General Fix\n/help - List of commands\n/ranks - Check Ranks\n/music - Battle Music\n/rp - Emote \n/rps - Rock Paper Scissors\n/rpm - Roleplay Mode(Phase Mode)\n/rules - Review Rules\n/save - Save game\n/screenfix - Fix Offset Screen\n/settings - Open Settings\n/streamermode - Mutes Battle Music\n/story - Check Story\n/quit - Exit game\n/w | /whisper - Whisper to those nearby\n\n<b><u>Macros</u><b>\nB - Building Menu\nC - Stats Menu\nE - Grab\nG(or click) - Pick up\nI - Inventory\nT - Technology Menu\nV - Checker\nX - Switch Skillbar\nTAB - Target\nESC - Escape/Settings Menu\nCTRL + (E,F,1,Click,`) - Keys to control split forms, or your creations.\nCTRL + T - Teach Skills\n"
proc/FinalCountdown(seconds)
    for(var/i = seconds to 1 step -1)
        sleep(10)
        for(var/mob/M in range(20, src))
            M << output("<font color=red>[i]</font>", "actionoutput")

    for(var/mob/M in range(20, src))
        M << output("<font color=red>GO!</font>", "actionoutput")

proc/FinishCountdown(mob/m, seconds)
    if(m)
        for(var/mob/M in range(20, m))
            M << output("([m] has finished counting [seconds] seconds.)", "actionoutput")
var/global/ooc_on =1
atom
	var
		dirty = 0

	//movable/glide_size = 6
	movable/glide_size = 6
	movable
		var


			sealed = 0
			toxicity = 0
			culinaryxp = 0
			mod_culinary = 0.1
			intxp = 5
			magicxp = 5
			energy = 100
			energy_max = 100

			power_exp = 0
			rating_exp = 0
			energy_exp = 0
			strength_exp = 0
			endurance_exp = 0
			force_exp = 0
			resistance_exp = 0
			offence_exp = 0
			defence_exp = 0
			bodypcnt=100
			rating = 1
			psionic_power = 1
			strength = 1
			endurance = 1
			force = 1
			resistance = 1
			offence = 1
			defence = 1

			energy_base = 1
			psionic_power_base = 1
			strength_base = 1
			endurance_base = 1
			force_base = 1
			resistance_base = 1
			offence_base = 1
			defence_base = 1

			ki_power = 1
			ki_force = 1

			ki_offence = 1
			ki_spread = 2
			ki_agility = 1
			force_usage = 1
			tmp/mob/ki_owner = null

			resources = 0
	var
		hp = 100
		hp_max = 100
		id = 0;
		desc_extra = null
		spawned = 0 //Use this to determine if an obj was already created, and saved. For example, if a player has weights and those weights New() proc is called, make sure it doesn't rename them.

		percent_health = 100

		immune_dmg = 0

		level = 1 //Magic or Tech lvl of item or bodypart, or wall.


		submerged = 0
		radius = 5; //Size of effected area for things like gravity, ect.
		activated = 0


		image/img = null
		owner = null
		weight = 0
		bolted = 0 //1 means only tk can unbolt it and the player who created it, 2 means it can never be moved
		power = 0 //powered by batteries?
		fuel = 0
		value = 0
		obj/shadow = null
		obj/reflection = null
		can_pocket = 0 //Set to 1 if this item can be placed inside players inven
		can_activate = 0
		creator = null //As a key or number?
		density_factor = 0 //A var used to determine how dense an object is. For example, roofs are 2, which stops all forms of entry. Others are 1, which won't stop flying, and 0 allows all movement.
		dust = 1 //Set to 1 if hitting this whilst being knocked back creates dust, like a rock. trees do not.
		fake_x = 0
		fake_y = 0
		legendary = 0 //Set to 1 if this obj is a legendary, stops being destroyed.
		hashadow = 0
		hasreflect = 0//Does an obj have a reflection?
		laymod = 1 //The default layer assigned to a obj, which is then decreased based on that objs status, such as using the flight skill.
		shakes = 1
		explode_impact = 0
		mouse_button = "left" //Assigns which mouse button activates this item.
		shudders = 0
		is_node = 0
		go_x = 0
		go_y = 0
		go_z = 0
		i_width = 0 //Height and width in pixels
		i_height = 0
		weather // Sets this tile to have a specific weather type, which is then applied to player upon entering.
		flashing = 0;
		shaking = 0;
		change_icon = 0 //Can this atom have its icon changed?
		icon_original = null //This is the default icon for the atom.
		grav = 1;
		microwaves = 1;
		TextColor="red"

		//Tech power vars
		generator = 0; //Set to 1 if this obj makes power
		can_generate = 1; //Set to 0 for things like solar power at night or non windy days for turbines.
		generates = 0; //How much raw power this obj generates in power
		uses = 0 //How much power this tech drains

		tmp/tracked_y = 0 //Tracks how many micro movements are done on the y axis, to help calculate player layer.
		tmp/turf/lastloc
		tmp/last_step_x = 0
		tmp/last_step_y = 0
		tmp/tmp_dmg = 0 //Lower than 0 are cold locations, higher than 0 are hot.

		tmp/mob/grabbed_by = null //The mob you were grabbed by.
		tmp/tk = 0 //Set to 1 when an atom is being tked
		tmp/prev_loc = null
		tmp/prev_bump = null //the location that this item previously hit something at, so it doesn't happen twice in a row.
		tmp/travel = 0 //How many tiles this item has been moved by TK, and thus how much built up energy it has.
		tmp/KB = 0
		tmp/KB_furrow = 0
		//tmp/tk_pos
		//tmp/lifts = 0 //How many lifts up, or minus for down, this object is moved during the lifting minigame.
		//tmp/lift_delay = 0
		tmp/thrown_str = 1 //How hard this obj was thrown.
		tmp/thrown_offence = 1 //How accurate this obj was thrown.
		tmp/mob/lobber = null //Mob who threw this obj
		tmp/mob/used_by = null;

		//HUD vars
		screen_x = 0
		screen_y = 0
		screen_step_x = 0
		screen_step_y = 0
		hud_moves = 0 //Set to 1 if you can drag and move this hud around the screen.


var
	Earth=1
	Namek=1
	Vegeta=1
	Arconia=1
	Icer=1
	Desert=1
	Jungle=1
	Android=1
	Alien = 1
	FakeIcer=1
	FakeNamek=1
var/list/EarthParticipants=list("")
var/list/NamekParticipants=list("")
var/list/VegetaParticipants=list("")
var/list/IcerParticipants=list("")
var/list/HellParticipants=list("")
var/list/HeavenParticipants=list("")
var
	VegetaMoon=0
	IceMoon=0
	ArconiaMoon=0
	MakyoRMoon=0
	OozaruMoon=0
	MakyoMoon=0

	Earth_Contestants=0
	EarthTourny=0
	Earth_BattleOn=0
	EarthMatchRound=0
	EarthMatchNum


	Namek_Contestants=0
	NamekTourny=0
	Namek_BattleOn=0
	NamekMatchRound=0
	NamekMatchNum


	Vegeta_Contestants=0
	VegetaTourny=0
	Vegeta_BattleOn=0
	VegetaMatchRound=0
	VegetaMatchNum

	Icer_Contestants=0
	IcerTourny=0
	Icer_BattleOn=0
	IcerMatchRound=0
	IcerMatchNum


	Hell_Contestants=0
	HellTourny=0
	Hell_BattleOn=0
	HellMatchRound=0
	HellMatchNum


	Heaven_Contestants
	HeavenTourny=0
	Heaven_BattleOn=0
	HeavenMatchRound=0
	HeavenMatchNum
area/Inside
	var
		ownedland=0
		unownedland=1
		ownerofland
		sovereignland=0

SovereignLand
	parent_type=/obj
	name = ""

var/list
	PlanetaryHubs=list()
var/list
	StaffTeam=list("Bill Jobs","CaRnAgE cRaVeR","Roxas57","Symbiotic Nightmares","Alcryst","Jaja9090","ScrubwitSoapz", "Shadowbear22","KinglyAura")
	CodedStaff=list("Bill Jobs","CaRnAgE cRaVeR","Roxas57","Symbiotic Nightmares","Alcryst","Jaja9090","ScrubwitSoapz", "Shadowbear22")