var
	//Ability Help Topics and Descriptions

	text_eng = "This is your character's primary resource. Energy is used up with all your actions. The higher your energy, the more your character is able to do. The lower your energy, the less actions they can perform."

	text_str = "This is how strong your character is with melee attacks. The higher this stat, the harder you character will hit."

	text_end = "This helps to reduce the amount of damage your character takes when being hit in melee combat."

	text_agil = "This affects your attack speed in melee combat. The higher the stat, the faster your character can fight without pausing in between attacks."

	text_res = "This helps to reduce the amount of damage your character takes when being hit with psionic attacks."

	text_force = "This is how good your character is with psionic attacks. The higher this stat, the more damage your psionic attacks will do."

	text_acc = "This affects your offence in combat. The higher this stat, the more likely you are to hit your opponent with an attack in both melee and ranged combat."

	text_reflex = "This affects your chance to avoid or deflect an attack made against your character. The higher this stat, the more likely your character will be able to avoid incoming damage."
	text_health = "This is how well your life is functioning. It will lower as you take damage. Health is directly related to whether or not you will withstand a knockdown or not."
	text_vigour = "This is how well your body functions. It lowers when you get older and become frail and weak. Vigour is directly related to your power. If you have 100% vigour, you are at 100% Power. However, if you become old your vigour will start to decrease every month."

	text_recov = "This is how much energy your character recovers per second. The higher this stat, the quicker your character will return to full energy."

	text_weekly_resets = "\nAt the beginning of each week, excluding the initial week of a new wipe, all Roleplay Ranks are reset.\n\nMost characters will return to Rank F. In certain cases, players who achieved a sufficiently high rank during the previous week may reset to Rank E instead.\n\nThis reset affects rank only. You do not lose your accumulated Roleplay Points (RPP).\n\nRanks are a measure of weekly presence and activity. The reset ensures a renewed competitive landscape each cycle while preserving your long-term progress."

	text_general_information = "\nThe following knowledge standards apply in-character unless otherwise discovered through roleplay:\n\n - There is no inherent knowledge of Superforms. No character begins aware of transformations beyond their current state. Superforms only become known once achieved or properly witnessed.\n\n - Demons originally born in Hell are aware that an outer world exists beyond it, including a domain in their own realm, the Dark Realm. However, those originally born outside of Hell has no knowledge of the Dark Realm unless such information is revealed through roleplay.\n\n - Changelings begin with awareness that other planets exist beyond their own, but they do not know the names, cultures, or details of those worlds.\n\n - Newborn characters are aware of their parents’ names at birth.\n\nAll other knowledge must be gained through character interaction, discovery, or lived experience within the world."

	text_passive_points = "\nPassive Points are earned gradually as your Personal Growth (PG) increases. They accumulate naturally over time as you train, roleplay, and progress your character.\n\nPassive Points are used within the Passive Perk Tree, allowing you to unlock permanent enhancements and build-defining bonuses.\n\nThey are not gained instantly or on demand, they reward consistent development. As your character grows, so does your access to long-term specialization."

	text_needs_htt = "\nHTT represents your character’s physical condition. Hunger, Thirst, and Tiredness each scale up to 300%.\n\nThe higher these values are maintained, the stronger your training output becomes. A well-fed, well-hydrated, and well-rested character gains more from every action.\n\nIgnoring your Needs will slow progression. Maintaining them enhances Personal Growth and overall stat development.\n\nPhysical upkeep is not optional, it directly influences performance."

	text_personal_growth = "\nPersonal Gains are the core progression multiplier of your character. It influences how effectively you develop across all systems stats, gains, and long-term advancement.\n\nPG increases naturally through training, activity, and rating progression. The higher your Rating, the stronger your Personal Growth becomes.\n\nA percentage of Personal Growth transfers to offspring, combining with the other parent if applicable. Over generations, PG defines the strength of a bloodline.\n\nIt is one of the most important long-term attributes in Sovereign."

	text_cycling = "\nCycling is the structured training method of Sovereign.\n\nWhen you repeatedly use a single training type, your character becomes resilient to it. To reduce that resilience and maintain optimal gains, you must rotate between different training methods.\n\nA complete cycle typically includes a variety of methods, such as physical training, blasting, meditation, and sparring, in rotating sequence.\n\nCycling promotes balanced development across your stat profile and prevents stagnation.\n\nCycle Free Time (CFT) allows you to bypass resilience temporarily, letting you focus intensely on a single training type without penalty.\n\nMastering Cycling is essential for efficient long-term growth."

	text_phase_mode = "Roleplaying Procedure for Phase Mode:\n\n1.Phase Mode is activated using /rpm and selecting the second toggle option.\n2.Once activated, all participants are locked into a structured phase sequence where roleplay must occur before combat progresses.\n3.Each player involved must complete their roleplay action to fill their phase meter.\n4.Combat may only resume once all members in the phase have fulfilled their sequence.\n5.Any additional participant wishing to join must be accepted into the phase by the current members using /rpm.\n\nPhase Mode is designed to emulate dramatic battle pacing allowing characters to speak, power up, prepare techniques, or shift momentum before blows are exchanged. It creates intentional pauses within combat to enhance tension, strategy, and cinematic presence."

	text_roleplay_mode = "Roleplaying Procedure for Roleplay Mode:\n\n1.Roleplay Mode is activated using /rpm and selecting the primary toggle option.\n2.Damage is significantly amplified to reflect decisive, high-impact combat.\n3.Each player is limited to a maximum of three actions per roleplay response.\n4.Actions may include attacks, skill usage, or movement (movement counts per 5 tiles).\n5.After submitting a roleplay response, the player may optionally provide a countdown for their opponent to respond.\n6.Once both participants have completed their roleplay sequence, they should commence their declared actions after.\n7.Combat then pauses again until the next roleplay exchange begins.\n\nRoleplay Mode is designed for structured, round-based combat. It prioritizes immersion, pacing, and narrative weight over speed. Every exchange is deliberate, action for action, round for round, allowing combat to unfold as a fully realized scene rather than a rapid exchange of mechanics."

	text_lethal_combat = "Roleplaying Procedure for Lethal Combat:\n\n1.Initial roleplay to engage in lethal combat, ensuring lethal motive, action, and targets are all detailed in the roleplay.\n2.A 60-second timer for surrounding players to respond.\n3.Once the countdown is completed, all those involved in the roleplayed scenario are to engage in a mandatory verb-styled fighting scheme. This means all respective characters may use whatever action they please on one another without roleplay until the battle has ended."

	text_new_char_grace_period = "A 24-hour grace period is granted to new characters, during which they are protected from all limb damage and death, except in serious in-character incidents."

	text_energy_types = "The universe is teeming with different types of energy, each with its unique properties and abilities. At the heart of it all is pure energy, the fundamental force that underpins everything in existence. From this primordial energy, other forms of energy emerge through various processes.\

	When pure energy interacts with non-sentient beings or plants, it transforms into mana, a potent energy source that fuels spells and enchantments. However, when pure energy comes into contact with an intelligent creature, it undergoes a process known as toning, which transmutes it into energy for the body mind and spirit. This energy is incredibly powerful and is known to enhance cognitive abilities and grant telekinetic and telepathic powers.\

	If psionic energy is filtered through the lungs and into the dantian, the body's spiritual center, it becomes divine energy. This energy is imbued with the power of the divine and is capable of healing, purifying, and even resurrecting. The dantian acts as a furnace, refining and amplifying the divine energy for use.\

	Unfortunately, divine energy cannot last forever. Over time, it begins to fade, eventually devolving into dark matter, a form of energy that stagnates and contributes to the universe's entropy. It's believed that the fading of divine energy is due to the loss of the divine essence imbued within it.\

	The flow of energy is complex and can take various paths, but generally, it follows this sequence: pure energy > mana (non-sentient beings and plants) or psionic energy (intelligent creatures) > divine energy (through the dantian) > dark matter (after the loss of divine essence)."

	text_regen = "This is how much health your character regenerates per second. The higher this stat, the quicker your character will return to full health."

	text_bodysize_large = "Choosing a large bodysize will give +20% to your Strength, Endurance, Resistance and Regeneration stat mods. And -20% to your Force, Agility, Offence and Defence stat mods."
	text_bodysize_small = "Choosing a small bodysize will give +20% to your Force, Agility, Offence and Defence stat mods. And -20% to your Strength, Endurance, Resistance and Regeneration stat mods."
	text_bodysize_medium = "Choosing a medium bodysize gives no advantages or disadvantages to your characters stat mods."

	test_psiforging_lore = "Toning is the unique ability to forge ones own body parts into more powerful versions of themselves, strengthening bone density, muscle elasticity and organ functioning. Toning energy is focused and combined into a cascading force that washes over the body part, wreathing it in incomprehensible intensity, creating preternatural results. The results usually vary based on the body part being worked on, but generally speaking, the outcome is always positive."
	text_saiyan = "Saiyans are a proud warrior race known for their immense strength, combat instincts, and relentless drive to grow stronger.\n\
	Hailing from planet Vegeta, they are humanoid beings with tails that allow them to transform into powerful Great Apes under a full moon. \n\
	Saiyan society values strength above all, rewarding the strongest of their kind. \n\
	Once primitive survivalists, they evolved into ruthless conquerors with a natural potential for limitless growth, especially after recovering from near-death. \n\
	"


	text_saiyan_pros = " Lunar Transformation, \n\
	 Chance of power growth during critical moments\n\
	"



	text_saiyan_cons = " <center>Planet Vegeta \n\
	"


	text_doll = "Spirit Dolls are mystical constructs brought to life through the fusion of energy and craftsmanship. \
	Unlike other races, Spirit Dolls have no true form, no true self. They are manifestations of ki, shaped by the willpower of those who control them. \
	Some are summoned warriors, bound to ancient rites, while others are wandering spirits seeking purpose in battle. Because they are not bound by mortal limits, they can alter their density, phase through attacks, \
	or disperse into energy to reform elsewhere. But their strength is a double-edged sword—their existence is fragile, dependent on the ki that sustains them."
	text_doll_pros = " High Ki Resistance, \n\
	 Explosive Self-Sacrifice \n\
	"
	text_doll_cons = " <center>Planet Earth \n\
	"

	text_yukopian = "A race of mystics and warriors, bound to the sacred wisdom of their ancestors. \
	Namekians are deeply attuned to the natural flow of energy. They require no sustenance other than water, their bodies finely tuned to survive in even the harshest conditions. \
	Their regenerative abilities make them incredibly difficult to kill, and their mastery of spiritual energy grants them powerful techniques, \
	such as fusing with their kin to evolve beyond their limits. Some Namekians walk the path of warriors, while others embrace the role of mystics, unlocking powers unseen by mortal eyes."

	text_yukopian_pros = "Regenerative Limb Biology, \n\
	 Fusion Potential, \n\
	 Long Natural Lifespan \n\
	"

	text_yukopian_cons = " <center>Planet Namek \n\
	"

	text_tuffle = "Once a race of brilliant minds, the Tuffles were nearly wiped from existence—but intelligence never truly dies.\
	Tuffles are a species of technological geniuses, far surpassing most civilizations in science and bioengineering.\
	Though physically weaker than other races, their ability to create, adapt, and upgrade puts them in a league of their own. \
	Many Tuffles integrate cybernetics into their bodies, enhancing their combat abilities far beyond natural limits. Some rely on hacked genetics, unlocking powers stolen from other species."

	text_tuffle_pros = "Advanced Technological Aptitude, \n\
	Physically Frail Without Enhancement \n\
	"

	text_tuffle_cons = " <center>Planet Vegeta \n\
	"

	text_makyo = "A cursed bloodline, thriving in darkness, empowered by celestial anomalies. \
	Makyos are creatures of twilight, growing exponentially stronger under the influence of celestial bodies, especially the Makyo Star.\
	While their base power is modest compared to elite warriors, under the right conditions, they undergo terrifying power surges, pushing them beyond their natural limits.\
	Many Makyos possess demonic blood, granting them abilities such as unnatural longevity, and brutal transformations."

	text_makyo_pros = " Bound To HFIL Upon Death, \n\
	 Chance To Tether To Demon Realm, \n\
	 Natural Durability \n"

	text_makyo_cons = " <center>Planet Earth \n\
	"

	text_changeling = "Born into supremacy, the Changelings are one of the most feared races in the universe. \
	Possessing incomprehensible natural power, these beings are born conquerors, with forms designed for destruction.\
	Their bodies are highly resilient, resistant to most forms of damage, and their ki control is eerily efficient, wasting nothing in battle."

	text_changeling_pros = " Born With High Power Levels, \n\
	Struggles in gaining skill due to ego \n\
	"

	text_changeling_cons = " <center>Planet Icer \n\
	"

	text_cerebroid = "From distant stars and unknown worlds, the galaxy is filled with beings beyond comprehension. \
	There is no single form for an alien some have multiple limbs, others metallic skin, and some defy the laws of biology itself. \
	Some aliens rely on cybernetics, enhancing their natural abilities, while others tap into the ancient arts of their forgotten ancestors. \
	Whether they come as conquerors, survivors, or nomads, one thing is certain—their power is unlike anything the known universe has ever seen."

	text_cerebroid_pros = "Creative Pallette, \n\
	Special races and special skills \n\
	"

	text_cerebroid_cons = " <center>Planet Earth \n\
	 Planet Namek \n\
	 Planet Vegeta \n\
	 Planet Icer \n\
	"

	text_celestial = "Divine overseers, watchers of the universe, the Kais are the balance between creation and destruction.\
	Bestowed with godly wisdom and supernatural ki, Kais are celestial beings who guide the fate of the cosmos. \
	While mortals train their bodies, Kais refine their sacred techniques, allowing them to manipulate life force, foresee events, and sense disturbances across the universe."


	text_celestial_pros = " Dimensional Travel\n\
	 Can Ressurect Others \n\
	 Extended Lifespan \n\
	"

	text_celestial_cons = " <center>Afterlife \n\
	"

	text_demon = "Demons are chaotic beings born from the darker energies of the universe. Most hail from the Demon Realm, a place warped by corruption and raw power. \
	Unlike Kai who serve order, Demons thrive on ambition, destruction, and forbidden arts. They often clash with Kais, push past natural limits, and bend rules of life and death to grow stronger. \
	Some Demons follow ancient bloodlines, while others are twisted mutations or rogue souls reborn through hatred. Though often hunted, many Demons hide among mortals, seeking power, war, or immortality."

	text_demon_pros = " Can Steal Lifespan, \n\
	 Can Ressurrect Others, \n\
	 Extended Lifespan, \n\
	 Difficulty remaining in mortal realms \n\
	"

	text_demon_cons = " <center>HFIL \n\
	 Demon Realm \n\
	"
	text_imp_pros = " Can jump between the other and dark realms, \n\
	 Balanced affinity for Magic and Technology \n\
	"

	text_imp_cons = " <center>Afterlife \n\
	 HFIL \n\
	 Demon Realm \n\
	"


	text_imp = "Mischievous, diligent, and eternally bound to the cycle of souls—Oni serve as the custodians of the Otherworld. \
	What is known, is many of them spend their time watching over not only their native realm, but all of creation, writing down in vast scrolls all that they see. They can be considered \
	lore keepers and chroniclers too, but primarily they try to keep balance in the Other Realms, for if left unchecked, Demons would run amok and Kais would crusade and purge."

	text_newborns = "Newborns are the blank slates of the universe—creations or offspring molded by legacy, invention, or cosmic anomaly. \
	They are not defined by a singular race, but by the will and imagination of their origin. A Newborn could be the child of powerful warriors, \
	a custom-built android engineered for perfection, or a rare Majin birthed from pure magic or madness. \
	This selection offers unmatched creative freedom, allowing players to carve their own narrative path. \
	However, with such freedom comes uncertainty—Newborns start with no innate racial traits, relying entirely on player customization, roleplay, and in-game development to define their strength."

	text_human_pros = " Accelerated Skill Mastery, \n\
	 Easier Ascensions, \n\
	 Struggling Power Gain \n\
	"

	text_human_cons = " <center>Planet Earth \n\
	"

	text_android = "At some indeterminate date, hidden in the annals of time, Humans on Earth managed to perfect their technological magnum opus. Hubris and Human nature would not abide two \
	powerful ideological forces inhabit the same world, and thus apocalyptic doom washed over the world. For a time, the Androids remained alone, frozen in the darkness of time, in the depths of \
	their technological tombs. Being entirely mechanical in nature, Androids struggle to grow thier powers in the same ways as other species do. Instead relying on upgrading  their bodyparts painstakingly \
	with suitable engineered parts. They also have very few origins to choose from compared to other races."

	text_android_pros = " Heat, Cold, Toxic and Radiation Immunity, \n\
	 Dependent on Technological Advancement, \n\
	 No Natural Lifespan \n\
	"

	text_newborns_pros = " Limited creative control over race/origin, \n\
	 Potential to inherit traits from parents or creators, \n\
	 Roleplay-driven growth paths \n\
	"

	text_newborns_cons = " <center>Anywhere \n\
	"



	text_android_cons = " <center>Anywhere \n\
	"

	text_human = "Humans are the underdogs of the universe—ordinary in power, yet extraordinary in potential. \
    While they lack the raw, explosive energy of other races, their resilience, adaptability, and ingenuity set them apart. \
	hrough intense training, they can refine their ki control to master advanced techniques like energy sensing, ki manipulation, and martial arts styles that rival even the strongest warriors. \
	What they lack in sheer force, they make up for with tactical intelligence, discipline, and an uncanny ability to push past their limits."

	text_self_train = "Through relentless repetition and raw physical exertion, you push your body beyond comfort and into growth. Self Training strains your muscles and tests your endurance, slowly forging strength through hardship. The process consumes Energy over time, but with discipline and persistence, your body adapts and grows stronger."

	text_sleep = "Sleep is the quiet restoration of the mortal frame. While asleep, your body focuses entirely on recovery—restoring Health, Energy, and stabilizing your internal balance. Deep rest strengthens long-term vitality, helping preserve Vigour and maintain peak condition."

	text_meditation = "During meditation, you will recover your health and Energy at twice the normal rate. Using Meditation will increase and cultivate your stats, training your mind, body and soul. Forging each with great psionic power slowly over time."

	text_grabbing = "Grabbing allows you to manipulate and move objects and people around more easily than other means. You can let go of what you are holding by pressing E again. Double clicking anywhere with somehing held will throw the object or person toward where you clicked. How far the object travels when thrown is based on your strength."

	//text_train = "During self training, you will gain strength and endurance, but gradually lose Energy from the strain. You can activate Self Training by left clicking. Right clicking it will bring up a series of options,  \
	//which allow you to set the focus of your training."

	text_power_control = "Power Control allows you to consciously suppress or release your energy. By lowering your visible aura, you can conceal your true strength from prying senses. By releasing it, you let your presence be known. Mastery over your power is mastery over how the world perceives you."

	text_flight = "Flight can be activated by clicking, but will consume a moderate amount of Energy per second. Gradually, your skill in flying will increase until there's hardly a drain on your resources. Right clicking will change the flight mode, allowing faster movement, but at the cost of more Energy."

	text_super_speed = "Toggling this skill on will allow you to double click any location and nearly instantly transvere to it, at the cost of Energy. As you become better in its use, the Energy cost will decrease and the chance it will trigger in melee will increase."

	text_focus = "Activating this ability will cause your character to focus intensely, increasing their stats and raw power by 10%. However, the strain is a constant drain on your Energy reserves. The higher your Recovery and Energy mods, the less this skill will drain you. Focus also increases the chances of lightning striking you during a thunderstorm, which is beneficial for your resistance stat."

	text_destructo_disk = "You condense your energy into a razor-sharp, spinning disk and hurl it toward your target. Unlike brute-force blasts, this technique focuses on precision and cutting power, capable of slicing through defenses if it lands true."

	text_summon_mage_pot = "Through practiced ritual and energy shaping, you conjure a Mage Pot—an enchanted vessel that enhances magical processes and alchemical creations. The pot serves as a conduit, stabilizing volatile energies and improving the outcome of crafted works."

	text_create_energy_drainer = "You construct a device that siphons ambient or nearby energy and redirects it for personal use. Energy Drainers can weaken opponents or fuel your own reserves, depending on how they are applied. Mastery of this craft requires technical knowledge and careful control."

	text_spirit_reprieve = "Drawing upon spiritual force, you momentarily protect your soul from collapse. Spirit Reprieve delays the threshold of defeat, granting a brief window to recover or escape. It does not prevent death—but it may buy precious seconds when they matter most."

	text_majinize = "Through dark influence or willing submission, your being becomes infused with chaotic power. Majinization enhances your combat potential, but binds you to volatile energy that can warp personality and intention. Power gained this way always carries a cost."

	text_mysticize = "You unlock hidden reserves of power without explosive transformation. Mysticize refines your latent potential into a calm, controlled state of heightened strength. Unlike temporary surges, this awakening is stable—drawing from what already exists within you."

	text_unlock_potential = "A ritual or awakening that releases dormant strength sealed deep within your soul. Unlock Potential does not grant foreign power—it reveals what was always there. Once awakened, your natural abilities flow more freely, allowing greater growth moving forward."

	text_sense = "With this skill activated, you can get a general feel of the powers near you and the direction from which they orginiate. Anything stronger is always over 100% of your power and anything weaker is under 100%. This window will also display a comparison of stats for anyone you click, so long as you manage to hit your target."

	text_study = "Paces your intellectual gain while you are meditating."

	text_profusion = "Projects your inner force outward to increase your powers at the cost of draining your Energy slowly. With it active, your power, resistance and agility increase by 20%, and your force by 30%. However, the ability decreases your strength by 30% and your recovery by 20%, making it harder to recover or hurt others physically as easily."

	text_invisibility = "Using your psionic powers, you can slowly fade out of view and become almost entirely transparent. Higher levels of this technique will drain your Energy less, along with having high recovery and Energy mods."

	text_split_form = "By dividing your essence, you create autonomous copies of yourself. Each form shares your will, but your total power is divided between them. Split Form is a dangerous technique—granting versatility and tactical advantage at the cost of raw strength."

	text_energy_shield = "You manifest a barrier of concentrated energy around your body, reducing incoming damage. The shield absorbs force at the cost of continuous Energy drain. A steady mind and strong recovery allow the barrier to remain stable under pressure."

	text_telekinesis = "This ability will allow you to produce amazing feats of skill with only your mind. With it, you can manipulate objects at the cost of your own Energy. Clicking the skill will toggle it on or off. Holding the left mouse button and dragging an object will force it to move, so long as you have enrgy to power the ability. You can also forcefully pull stuck and bolted objects out of the ground. Right clicking this skill will begin to train your force statistic and enter a minigame."

	text_divine_energy = "This type of special energy is derived from the Other Realms, a dimension connected to all points, at all times, everywhere. [css_divine]Divine Energy<font color = white> is incredibly precious, rare and hard to attain. Gods and mortals alike covet such a resource and both can manipulate it in various ways.\n\nMortals can use [css_divine]Divine Energy<font color = white> to infuse their bodies, minds and souls with great power, eventually using it to ascend to demigod status. Some beings are able to twist this energy into its polar opposite, creating [css_dark]Dark Matter<font color = white> in its stead."

	text_dark_matter = "[css_dark]Dark Matter<font color = white> is a fundamental force of the universe, an underlying swirling current or mass invisible to most beings senses. Unlike [css_divine]Divine Energy<font color = white>, its polar opposite, [css_dark]Dark Matter<font color = white> is more easily able to congeal and fuse with inanimate objects, due to it being electromagnetically dead.\n\nWhere as [css_divine]Divine Energy<font color = white> relies on an electromagnetic current to self-perpetuate and interface with living beings, [css_dark]Dark Matter<font color = white> can more easily fuse with machines, undead and ectoplasm. Many ascensions of a scientific or occult nature rely on [css_dark]Dark Matter<font color = white> as a means to attain greater power."

	text_kaioken = "A forbidden amplification technique that forces your body beyond its natural limits. Kaioken dramatically increases your power for a short duration, but the strain ravages your body and rapidly drains Energy. Prolonged use can cause severe backlash if your body cannot withstand the pressure."

	//Tech Help Topics and Descriptions

	text_roleplay_points = "These offer a different way for players to progress in the game. They offer an opportunity to express creative writing and to become immersed in the game world. You can roleplay your character with others, or on your own, both are viable ways to supplement your character's growth."

	text_skill_points = "Nearly every stat you can raise has a Skill Point associated with it. For example, Strength has Strength Skill Points, and Energy has Energy Skill Points. Whenever you gain 10 levels in a stat, you gain a Skill Point. For example, if you level your Strength to 10, you will gain 1 Strength Skill Point for doing so. Skill Points can then be used to unlock skills related to the Skill Point in question. For example, Strength Skill Points could be used to unlock the Expand skill, but not the Flight skill. This is because the Expand skill is a Strength based skill which uses Strength Skill Points, and Flight is an Energy based skill which uses Energy Skill Points for its unlock."

	text_combat_levels = "This is the relative overall level of your character when all their combat stats are taken into consideration. Everytime you gain a level in a stat, your Combat Level xp raises. And every 10 times that happens, you gain a Combat Level. Every 10 Combat Levels, you gain 1 Trait Point to spend on Traits and Stances of your choice."

	text_trait_points = "Every 10 Combat Levels, you will gain a Trait Point. Trait Points can be spent on unlocking unique benefits that range from immediate advantages, to situational bonuses. Trait Points can also be used to unlock Stances."

	text_map = "Here you can find a visual representation of the various places in the game world. Some skills will require you to click a location on the map. For instance, teleportation will let you click a place on the map to travel to. The map is not available normally otherwise and exclusively locked behind some skills."

	text_underwater = "Entering water or another type of liquid, or other similar environmental area, causes your character to start gaining XP in Endurance and Power. Some races require oxygen to survive and running out will cause your character harm over time."

	text_bodypart_stats = "As you may know, bodyparts each have a specific stat increase associated with them. When that bodypart levels up, you also gain the listed stats. It is worth noting that the stats you gain from each bodypart upon leveling up, are actually enhanced by your stat multipliers. For example, if you have a 2 in your Strength multiplier, and the bodypart has a base Strength reward value of 1, you would gain 2 Strength. Where as a player with only a 1 in their Strength multiplier would only gain 1 Strength. The base value reward of each bodypart varies on which bodypart you choose to train, but generally speaking bones give Endurance and muscles give Strength."

	text_bodyparts = "The Body menu displays all the body parts contained within your character, from their very bones all the way to their skin. \
	\ Each part can be individually trained for stat increases, and even combined into Body Milestones that give even bigger bonuses. Generally, muscle parts give better Strength stats, bones give \
	\ better Endurance stats and organs tend to give many different attributes. As you gain xp toward a stat or a skills level, you also gain xp toward the bodypart you are training."

	text_death = "When your character dies, they usually goto the Other Realm, unless they have a means to avoid death. Death isn't permanent in Psiforged, but there are some drawbacks. While dead, you won't be effected by environmental means, but you also won't be able to gain benefits from training in them either. Since you don't have a body while dead, you will be unable to train and Psiforge your bodyparts. You will also not age. There are ways to return to life, mainly by using the Revivification skill."

	text_cybernetics = "Cybernetics are machine parts that interface and connect with organic bodyparts. Just like bodyparts, they have their own levels and stat rewards. You can view which cybernetics a bodypart has by clicking the Cybernetics tab, which displays after clicking a bodypart. Cybertech can be upgraded with a Mechanical Upgrade Kit. To add cybertech to a bodypart, click it while its in your inventory, then select a bodypart to apply it to. Keep in mind most cybertech can only be applied to certain bodyparts. Also, each bodypart has a limit on how many cybertech pieces can be applied. Cybernetics of the same type don't stack. When you die, all cybertech will be left at the location of your demise. You can also manually remove cybertech by right clicking it. Androids are unable to apply cybernetics to their bodyparts. Lastly, cybertech can't be fused with Divine Energy."

	text_gravity = "Gravity in Psiforged plays an important part to training your character. All gravity measurements are based on planet Earth, so 2 gravity in Psiforged refers to twice Earths gravity. Being in gravity thats higher than 1 will slowly raise your gravity mastery, but also cause you to take damage over time. Gravity mastery tells you how much gravity you can be inside without taking damage, and is also an indication to your progress and will also determine how much Power exp you will gain from all sources. A higher gravity mastery is desirable overall. Damage from gravity can be lowered from certain sources, such as having a well-trained spine or other quirk. The higher your gravity multiplier stat is for your race, the quicker you will master gravity. Gravity machines are always faster than natural phenomena such as black holes."
	tooltip_rating = "Ratings\n\n<font color=white>A number that accomodates to your personal gains."
	tooltip_psionic_power = "Power Multiplier\n\n<font color=white>Most of your other statistics are multiplied by this number."
	tooltip_strength = "Strength\n\n<font color=white>This is how hard you hit in melee. It is countered by [css_endurance]Endurance<font color = white>."
	tooltip_endurance = "Endurance\n\n<font color=white>A higher [css_endurance]Endurance<font color = white> lets you take harder melee hits. It is countered by [css_strength]Strength<font color = white>."
	tooltip_agility2 = "Agility\n\n<font color=white>This affects your attack speed in melee combat. The higher the stat, the faster your character can fight without pausing in between attacks."

	tooltip_agility = "Can Lift\n\n<font color=white>Affected by[css_strength]Strength<font color = white> and [css_endurance]Endurance<font color = white>, this determines how heavy the weights you can lift should be, and your overall physical power."
	tooltip_force = "Force\n\n<font color=white>Energy-based attacks use the [css_force]Force<font color = white> stat to determine damage. [css_resistance]Resistance<font color = white> counters [css_force]Force<font color = white>."
	tooltip_resistance = "Resistance\n\n<font color=white>This stat helps reduce the damage you take from energy-based attacks. [css_force]Force<font color = white> counters [css_resistance]Resistance<font color = white>."
	tooltip_energy = "Energy\n\n<font color=white>Many skills make use of [css_energy]Energy<font color = white> as a resource."
	tooltip_offence = "Offence\n\n<font color=white>This is how likely you are to hit someone with an attack versus their [css_def]Defence<font color = white>."
	tooltip_defence = "Defence\n\n<font color=white>This is how likely you are to avoid someones attacks. It is countered by [css_off]Offence<font color = white>."
	tooltip_recovery2 = "Recovery\n\n<font color=white>This is how good the rate at which you recover energy!"
	tooltip_regen2 = "Regeneration\n\n<font color=white>This is how good the rate at which you recover health and limb damage!"
	tooltip_recovery = "Magical Efficiency\n\n<font color=white>This is how strong and good the quality of your magical techniques and creations will come to be."
	tooltip_regen = "Quality Percentage\n\n<font color=white>This is how good the quality of your technological creations will come to be."
	tooltip_points = "Total Points\n\nThese are how many points you can spend on your statistics. You start with 5 or 15 for aliens to distribute to any of your mods <font color = white>."
	tooltip_tech = "This stat is perhaps the most singularly important attribute for someone wanting to focus on technology. It affects a whole range of aspects in regards to tech creation and research.\n\n[css_tech]Tech Potential<font color = white> represents a combination of many factors, such as character intelligence, species education, aptitude and inclination toward technology.\n\nGameplay-wise, [css_tech]Tech Potential<font color = white> is set when choosing a species and can be increased by toning your brain and reading/using certain objects.\n\nHaving a higher [css_tech]Tech Potential<font color = white> reduces the cost and research times of technology."
	tooltip_secondary_stats = "Secondary Stats\n\nThese statistics are nearly as important to your character as their core stats, but have wide ranging effects on different aspects of gameplay and progression."
	tooltip_core_stats = "Core Stats\n\nThese stats are the most important in regards to combat.\nAll core stats can be increased by training in the respective form.."
	tooltip_combat_levels = "Move Level\n\n<font color=white>This is the relative overall level of your character based on the time you spent training scaled by your [css_psionic_power]Rating Pts<font color=white>\n\nEverytime you gain a [css_combat]Move Level<font color = white> chances of learning new abilities increases.<font color = white>.\n"
	tooltip_stat_xp_bar = "Stat experience\n\nOnce this bar fills up and reaches the end, you will gain stats associated with this bar. Only experience earned outside toning contributes to these bars filling.\n\nAll core stats when leveled this way give xp toward your combat level."
	tooltip_needs = "Needs\n\nYour needs are merely a representation of what most living beings require to survive, in Sovereign, neglecting these may result in death.\n\nHowever, having these high results in postive changes to your core gain."
	tooltip_oxygen = "Oxygen\n\nThis is how long you can hold your breath.\n\nHolding your breath too long results in penalties to your core health, and can result to death.\n\nHowever, running out of oxygen while underwater or in space can be a good way to train your oxygen capacity also but just remember to keep an eye on your health."
	tooltip_hunger = "Hunger\n\nHow hungry you are. The lower the hunger %, the more hungry you become.\n\nWhen your hunger % hits a point below negative, you begin to starve which results in eventual death."
	tooltip_thirst = "Thirst\n\nOver time, your character will desire water. The lower your thirst %, the more thirsty you become.\n\nWhen your thirst % is below negative, you begin to dehydrate which leads to your eventual death."
	tooltip_sleep = "Tiredness\n\nThis is how rested your character is. The lower the tiredness %, the more tired you become.\n\nWhen your tiredness % is below negatives, you become exhausted can lead to eventual death."
	tooltip_tolerances = "Tolerances\n\nThese are a collection of environmental factors that your character is either resistant to, or weak against."
	tooltip_heat = "Heat\n\nThis is your characters heat tolerance and how well they can survive in hot environments.\n\nThe higher this is, the less damage you will take from sources of heat.\n\nHaving a heat tolerance of 100% means your character has immunity to lesser heat. When at or above 200%, it means you have perfect tolerance.\n\nThere are many ways to increase your tolerance, such as toning your skin for instance.\n\nWhen in a hot environment, your core statistics suffer temporary penalties."
	tooltip_cold = "Cold\n\nThis is your characters cold tolerance and how well they can survive in cold environments.\n\nThe higher this is, the less damage you will take from sources of cold.\n\nHaving a cold tolerance of 100% means your character has immunity to lesser cold. When at or above 200%, it means you have perfect tolerance.\n\nThere are many ways to increase your tolerance, such as toning your skin for instance.\n\nWhen in a cold environment, your core statistics suffer temporary penalties."
	tooltip_gravity = "Gravity\n\nThis is your characters gravity tolerance and how well they can survive in environments with higher gravity.\n\nThe higher this is, the less damage you will take from sources of high gravity.\n\nWhen in a high gravity environment, your core statistics suffer temporary penalties."
	tooltip_microwaves = "Microwaves\n\nThis is your characters tolerance toward microwave energy and how well they can survive in environments with microwaves in.\n\nThe higher this is, the less damage you will take from sources of microwave energy.\n\nThere are many ways to increase your microwave energy tolerance, such as toning your skin for instance.\n\nWhen in an environment with high microwave energy, your core statistics suffer temporary penalties, and can kill you."
	tooltip_radiation = "Radiation\n\nThis is your characters tolerance toward radiation and how well they can survive in environments with high levels of radiation.\n\nThe higher this is, the less damage you will take from sources of radiation.\n\nHaving a radiation tolerance of 100% means your character has immunity to lesser radiation. When at or above 200%, it means you have perfect tolerance.\n\nThere are many ways to increase your radiation tolerance, such as toning your skin for instance.\n\nWhen in an environment with high radiation, your core statistics suffer temporary penalties."
	tooltip_toxins = "Toxins\n\nThis is your characters tolerance toward toxins and how fast you can recover from them.\n\nThe higher this is, the more Toxicity you will flush from your system per second. Your [css_regen]Regeneration<font color = white> mod also helps with this.\n\nWhen at or above 200%, it means you have perfect tolerance and can risk going over your Toxicity.\n\nThere are many ways to increase your toxin tolerance, such as toning your liver for instance.\n\nWhen in an environment with high toxins or eating/drinking items that are toxic, your core statistics suffer temporary penalties and your toxicity will increase."
	tooltip_toxicity = "Toxicity\n\nThis is how much toxic material is in your system. At high markings you risk fatality.\n\n<font color = red>Getting to 200% Toxicity will result in death!"
	tooltip_adaptations = "Adaptations\n\nThese are a number of different environmental situations that your character can become better at withstanding and master which in turn helps them become stronger."
	text_general_faqs = "\n\
General questions that new and returning players frequently ask.\n\n\
<b>BASICS</b>\n\
○ How do I cook and water plants?\n\
  → Drag and drop the required items onto the correct target.\n\n\
○ How do I meditate Magic?\n\
  → Toggle your Hone skill.\n\n\
○ How do I meditate Intelligence (Quality Percentage)?\n\
  → Toggle your Study skill.\n\n\
○ Why am I so slow? Am I lagging?\n\
  → Toggle Run. If you still feel slow, your Speed stat is low.\n\
    Training over time increases it naturally.\n\n\
○ Help! My portrait is missing!\n\
  → Type /gf in the chat box and press Enter.\n\n\
○ How do I throw things?\n\
  → Click a direction on the screen while holding the object.\n\n\
<b>PROGRESSION</b>\n\
○ Why are my acceleration gains paused?\n\
  → You currently have Standing Gains active.\n\
    Train those off before acceleration resumes.\n\n\
○ What are skill levels for?\n\
  → Some skills scale with level and provide real benefits.\n\
    Others are cosmetic or mastery-based.\n\
    A level 100 attack may not change much,\n\
    but a level 100 gather type skill can significantly benefit you.\n\n\
Learn through experimentation.\n\
Growth comes with time and interaction.\n\
If unsure, asking the community is part of the experience.\n\
"
	text_world_boss = "\n\
World Bosses are large scale PvE encounters that impact the realm. \
They are not random mobs, they are event-level threats.\n\n\
<b>IMMERSION GUIDELINES</b>\n\
When a World Boss appears:\n\
○ Treat it as a real in-character threat.\n\
○ React to its presence.\n\
○ Coordinate IC.\n\
○ Do not reduce it to silent grinding.\n\n\
You are encouraged to speak, react, and engage mid-fight.\n\n\
<b>MECHANICS</b>\n\
○ Loot eligibility is based on damage contribution.\n\
○ Participation matters.\n\
○ Simply showing up does not guarantee rewards.\n\n\
Balance immersion with action.\n\
Fight it like a threat, not a training dummy.\n\n\
<font color=green><i>*Spawns every Saturday, ends 12:00am Monday*</font></i>"

	text_rules_6 = "\n\
  ○ Build responsibly.\n\
  ○ Do not obstruct map links.\n\
  ○ Avoid arbitrary or disruptive structures.\n\
  ○ Report improper builds to staff.\n"

	text_rules_5 = "\n\
Applications must be submitted through admin help with justification.\n\n\
Ranks must act accordingly or risk removal.\n\
Notify staff when forfeiting a rank.\n\n\
<b>RANK RESTRICTIONS:</b>\n\
  ○ Max two students per rank.\n\
  ○ Mentor relationship: minimum two in-game years.\n\
  ○ Rank-specific skill teaching cooldown: 3 in-game years.\n\
  ○ General teaching cooldown: 1 in-game year per student."

	text_rules_4 = "\n\
Murder requires justifiable in-character reasoning.\n\
Negative alignment lowers the threshold, but reason must still exist.\n\n\
AFK killing is strictly prohibited.\n\
Characters must value their own lives.\n\n\
If contesting death, do not roleplay in the afterlife and notify admins immediately.\n\n\
<b>MURDER PROCEDURE:</b>\n\
  ○ Target must be incapacitated.\n\
  ○ Declare lethal intent, action, and target.\n\
  ○ Provide a 60-second timer.\n\
  ○ If interrupted or target recovers, attempt is void.\n\n\
You must have been involved in the initial lethal roleplay.\n\
No murder during active verb combat.\n\n\
<b>SELF-SACRIFICE</b>\n\
  ○ Dice determines tile displacement.\n\
  ○ Movement is tile-based.\n\
  ○ ADMIN REQUIRED."

	text_rules_3 = "\n\
Respect is mandatory.\n\n\
Harassment, hate speech, impersonation, misinformation, trolling, and toxicity are prohibited.\n\
Keep IC and OOC separate.\n\
No attaching characters to keys.\n\
No spam or advertising.\n\n\
All members must uphold civility and take responsibility for their conduct.\n\n\
Violation of these standards results in an immediate day ban (non-appealable)."

	text_rules_2 = "\n\
The Sovereign universe is independent from all real-world media. Do not reference outside franchises or lore.\n\n\
<b>METAGAMING:</b>\n\
Using out-of-character knowledge in-character is prohibited.\n\n\
<b>PROHIBITED ROLEPLAY:</b>\n\
The following is strictly forbidden:\n\
  ○ Cybering\n\
  ○ Rape\n\
  ○ Sexual assault\n\
  ○ Suicide\n\
  ○ Cannibalization of real-world players\n\
  ○ Explicit mutilation\n\
  ○ Drug use (excluding alcohol)\n\
  ○ Real-world ethnic slurs\n\n\
If it exceeds what would reasonably occur in DBZ, it does not belong here."

	text_rules = "\n\
<b>DO:</b>\n\
  ○ Familiarize yourself with all rules.\n\
  ○ Ask questions if something is unclear.\n\
  ○ Report bugs or unintended behavior.\n\
  ○ Report player abuse.\n\
  ○ Remain in character at all times.\n\
  ○ Voice legitimate concerns about admin conduct through official channels.\n\
  ○ Request permission if sharing an IP with a sibling/roommate (Anti-Alt policy).\n\
  ○ Follow all combat guidelines.\n\
  ○ Be courteous to players waiting on administrative assistance.\n\n\
<b>DO NOT:</b>\n\
  ○ Abuse bugs, exploits, or unintended mechanics.\n\
  ○ Perform non-RP actions on other players without consent.\n\
  ○ Use third-party software.\n\
  ○ Exploit loopholes in wording or systems.\n\
  ○ Play multiple characters simultaneously (offspring exception only). One key at a time.\n\
  ○ Share characters or keys.\n\
  ○ Roleplay for other players.\n\
  ○ Ban evade.\n\
  ○ Provide false information to staff or players.\n\
  ○ Form out-of-character cliques.\n\n\

<b>AVOIDING CONFLICT:</b>\n\
Logging out to avoid roleplay, death, or consequences is prohibited."




obj
	help_topics
		icon = 'help_expand_buttons.dmi'
		icon_state = "expanded"
		maptext_width = 320
		maptext_height = 16
		plane = 35
		layer = 34
		blend_mode = BLEND_INSET_OVERLAY
		appearance_flags = KEEP_TOGETHER | TILE_BOUND | PIXEL_SCALE
		var/category
		var/displayed = 0
		/*
		Categories
			- Combat
			- Training
			- Environmental
			- Skills
			- Stats
			- Lore
			- Gameplay
			- Misc
			- Controls
			- GUI
		*/
		MouseEntered(object,location,control,params)
			src.icon_state = "expanded moused"
		MouseExited(location,control,params)
			src.icon_state = "expanded"
		MouseWheel(delta_x,delta_y,location,control,params)
			var/obj/hud/menus/help_background/s = usr.hud_help
			var/obj/sc = s.help_scroller

			usr.check_mouse_loc(params)
			var/true_y = ((usr.mouse_y-1)*32)+usr.mouse_pix_y
			usr.mouse_y_true = true_y
			var/wheel_move = 0
			if(delta_y > 0) wheel_move = 16
			else if(delta_y < 0) wheel_move = -16
			var/result = sc.translated_y+wheel_move
			result = clamp(result,0,-218)

			var/matrix/m = matrix()
			m.Translate(0,result)
			sc.transform = m
			sc.translated_y = result
			var/ratio = -1 + ((-218 + result) / -218)
			ratio = clamp(ratio,0,1)
			var/scroll_y = round(200*ratio)

			s.help_holder_y = scroll_y

			for(var/obj/txt in s.help_holder.vis_contents)
				var/matrix/m2 = matrix()
				m2.Translate(txt.hud_x,txt.hud_y+scroll_y)
				txt.transform = m2
		Click()
			if(src.type != /obj/help_topics/Alert_Misc)
				var/obj/hud/menus/help_background/s = usr.hud_help
				var/obj/hud/menus/help_background/txt_raw/txt = s.txt_raw
				txt.maptext = "[css_outline]<font size = 1><text align=center valign=top><u>[src.name]</u>\n<text align=left valign=top>[src.help_text]"
		Help_General_FAQS
			category = "faqs"
			name = "General Questions"
			New()
				help_text = text_general_faqs
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel

		Help_Rules
			name = "General Guidelines"
			category = "rules"
			New()
				help_text = text_rules
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel

		Help_Rules2
			name = "Roleplay Standards"
			category = "rules"
			New()
				help_text = text_rules_2
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Rules3
			name = "LOOC / OOC Conduct"
			category = "rules"
			New()
				help_text = text_rules_3
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Rules4
			name = "Murder / Sacrifice"
			category = "rules"
			New()
				help_text = text_rules_4
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Rules5
			name = "Ranks"
			category = "rules"
			New()
				help_text = text_rules_5
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Rules6
			name = "Building"
			category = "rules"
			New()
				help_text = text_rules_6
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel

		Help_Weekly_Resets
			name = "Weekly Resets"
			category = "gameplay"
			New()
				help_text = text_weekly_resets
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_General_Information
			category = "lore"
			name = "General Information"
			New()
				help_text = text_general_information
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Energy
			category = "stats"
			name = "Energy"
			New()
				help_text = text_eng
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Strength
			category = "stats"
			name = "Strength"
			New()
				help_text = text_str
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Endurance
			category = "stats"
			name = "Endurance"
			New()
				help_text = text_end
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Agility
			category = "stats"
			name = "Agility"
			New()
				help_text = text_agil
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Resistance
			category = "stats"
			name = "Resistance"
			New()
				help_text = text_res
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Offence
			category = "stats"
			name = "Offence"
			New()
				help_text = text_acc
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Force
			category = "stats"
			name = "Force"
			New()
				help_text = text_force
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Defence
			category = "stats"
			name = "Defence"
			New()
				help_text = text_reflex
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Recovery
			category = "stats"
			name = "Recovery"
			New()
				help_text = text_recov
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Regeneration
			category = "stats"
			name = "Regeneration"
			New()
				help_text = text_regen
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel

		Help_Meditation
			name = "Meditation"
			category = "skills"
			New()
				help_text = text_meditation
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Flight
			name = "Flight"
			category = "skills"
			New()
				help_text = text_flight
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Map
			name = "The Map"
			category = "gameplay"
			New()
				help_text = text_map
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Super_Speed
			name = "Super Speed"
			category = "skills"
			New()
				help_text = text_super_speed
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		/*
		Help_Telekinesis_Minigame
			name = "Telekinesis Minigame"
			New()
				help_text = text_telekinesis_minigame
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		*/
		Help_Grabbing
			name = "Grabbing & Throwing"
			category = "gameplay"
			New()
				help_text = text_grabbing
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel

		/*
		Help_Lightning
			name = "Lightning"
			New()
				help_text = text_lightning
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		*/


		Help_Focus
			name = "Focus"
			category = "skills"
			New()
				help_text = text_focus
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Personal_Gains
			name = "Personal Gains"
			category = "training"
			New()
				help_text = text_personal_growth
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Passive_Points
			name = "Passive Points"
			category = "training"
			New()
				help_text = text_passive_points
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Needs_HTT
			name = "Needs/HTT"
			category = "training"
			New()
				help_text = text_needs_htt
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Cycling
			name = "Cycling"
			category = "training"
			New()
				help_text = text_cycling
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Alert_Misc
			name = "Alert"
			New()
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel

		Help_Gravity
			name = "Gravity"
			category = "environmental"
			New()
				help_text = text_gravity
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_New_Character_Grace_Period
			category = "combat"
			name = "New Character Grace Period"
			New()
				help_text = text_new_char_grace_period
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Lethal_Combat
			category = "combat"
			name = "Lethal Combat"
			New()
				help_text = text_lethal_combat
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Roleplay_Mode
			category = "combat"
			name = "Roleplay Mode"
			New()
				help_text = text_roleplay_mode
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_Phase_Mode
			category = "combat"
			name = "Phase Mode"
			New()
				help_text = text_phase_mode
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel
		Help_World_Bosses
			category = "lore"
			name = "World Bosses"
			New()
				help_text = text_world_boss
				var/image/sel = image('fx.dmi',src,"select item",1000)
				src.img_select = sel