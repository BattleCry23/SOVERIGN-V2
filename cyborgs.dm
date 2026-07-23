obj/items/tech/
	cybernetic_part
		change_icon = 0
		can_pocket = 1
		stacks = -1
		weight = 1

		appearance_flags = KEEP_TOGETHER
		has_subtech = 0
		tech_parent_path = /obj/items/tech/sub_tech/Engineering/Cybernetics

		desc = "A cybernetic augmentation designed to permanently replace a biological body part."

		act = /obj/items/tech/cybernetic_part/proc/use
		act_drop = /obj/items/tech/cybernetic_part/proc/drop
		proc/drop(var/mob/m,var/obj/items/tech/cybernetic_part/i)
			if(i in m.accessing)
				//Remove first
			//	i.icon_state = ""
				i.layer = 3
			//	i.suffix = null
			//	i.name = "[initial(i.name)] ([i.weight]kg)"
			//	i.desc_extra = "- [i.weight]kg weights\n\n"
			//	x.update_weight()
			//	x.redraw_appearance()
				m.drop(i)

		proc/use(var/mob/m,var/obj/items/tech/cybernetic_part/i)

			if(!(i in m.accessing))
				return

			// Age restriction
			if(m.age < 4)
				m << "Your body is too underdeveloped for cybernetic installation."
				return

			var/confirm = alert(m,
			"Install [i.name]?\n\nThis procedure is PERMANENT.",
			"Cybernetic Installation",
			"Install","Cancel")

			if(confirm != "Install")
				return

			if(!m.installed_cybernetics)
				m.installed_cybernetics = list()

			if(i.part_type in m.installed_cybernetics)
				m << "You already have a cybernetic [i.part_type] installed."
				return

			// Limb stat boosts
			if(i.part_type in list("Left Arm","Right Arm","Left Leg","Right Leg"))

				m.endurance += i.bonus_end
				m.strength += i.bonus_str
				m.force += i.bonus_for
				m.resistance += i.bonus_res
				m.offence += i.bonus_off
				m.defence += i.bonus_def

			else

				m.psionic_power_base += i.bonus_pl

			// Apply correct overlay based on age
			if(m.age >= 13)

				if(i.part_type == "Left Arm")  m.overlays += /obj/effects/cyber_left_arm
				if(i.part_type == "Right Arm") m.overlays += /obj/effects/cyber_right_arm
				if(i.part_type == "Left Leg")  m.overlays += /obj/effects/cyber_left_leg
				if(i.part_type == "Right Leg") m.overlays += /obj/effects/cyber_right_leg
				if(i.part_type == "Torso")     m.overlays += /obj/effects/cyber_torso
			//	if(i.part_type == "Head")      m.overlays += /obj/effects/cyber_head

			else

				if(i.part_type == "Left Arm")  m.overlays += /obj/effects/cyber_left_arm_kid
				if(i.part_type == "Right Arm") m.overlays += /obj/effects/cyber_right_arm_kid
				if(i.part_type == "Left Leg")  m.overlays += /obj/effects/cyber_left_leg_kid
				if(i.part_type == "Right Leg") m.overlays += /obj/effects/cyber_right_leg_kid
				if(i.part_type == "Torso")     m.overlays += /obj/effects/cyber_torso_kid
				if(i.part_type == "Head")      m.overlays += /obj/effects/cyber_head_kid

			m.installed_cybernetics += i.part_type

			m.redraw_appearance()
			m.refresh_inv()

			if(i in m)
				i.remove_item_from_inventory(m,i)

			m << "You successfully install the [i.name]."



obj/effects
	cyber_left_arm
		name = "Left Cybernetic Arm"
		icon = 'BorgLeftArm.dmi'
		icon_state = ""
		layer = FLOAT_LAYER
		appearance_flags = KEEP_TOGETHER

	cyber_right_arm
		name = "Right Cybernetic Arm"
		icon = 'BorgRightArm.dmi'
		icon_state = ""
		layer = FLOAT_LAYER
		appearance_flags = KEEP_TOGETHER

	cyber_left_leg
		name = "Left Cybernetic Leg"
		icon = 'BorgLeftLeg.dmi'
		icon_state = ""
		layer = FLOAT_LAYER
		appearance_flags = KEEP_TOGETHER

	cyber_right_leg
		name = "Right Cybernetic Leg"
		icon = 'BorgRightLeg.dmi'
		icon_state = ""
		layer = FLOAT_LAYER
		appearance_flags = KEEP_TOGETHER

	cyber_torso
		name = "Cybernetic Torso"
		icon = 'BorgTorso.dmi'
		icon_state = ""
		layer = FLOAT_LAYER
		appearance_flags = KEEP_TOGETHER

	cyber_head_kid
		name = "Cybernetic Head(Kid)"
		icon = 'BorgHeadKid.dmi'
		icon_state = ""
		layer = FLOAT_LAYER
		appearance_flags = KEEP_TOGETHER

	cyber_left_arm_kid
		name = "Left Cybernetic Arm(Kid)"
		icon = 'BorgLeftArmKid.dmi'
		icon_state = ""
		layer = FLOAT_LAYER
		appearance_flags = KEEP_TOGETHER

	cyber_right_arm_kid
		name = "Right Cybernetic Arm(Kid)"
		icon = 'BorgRightArmKid.dmi'
		icon_state = ""
		layer = FLOAT_LAYER
		appearance_flags = KEEP_TOGETHER

	cyber_left_leg_kid
		name = "Left Cybernetic Leg(Kid)"
		icon = 'BorgLeftLegKid.dmi'
		icon_state = ""
		layer = FLOAT_LAYER
		appearance_flags = KEEP_TOGETHER

	cyber_right_leg_kid
		name = "Right Cybernetic Leg(Kid)"
		icon = 'BorgRightLegKid.dmi'
		icon_state = ""
		layer = FLOAT_LAYER
		appearance_flags = KEEP_TOGETHER

	cyber_torso_kid
		name = "Cybernetic Torso(Kid)"
		icon = 'BorgKidTorso.dmi'
		icon_state = ""
		layer = FLOAT_LAYER
		appearance_flags = KEEP_TOGETHER