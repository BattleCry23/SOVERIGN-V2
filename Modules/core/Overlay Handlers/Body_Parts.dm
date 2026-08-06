obj/overlay

    horns
        layer = HAIR_LAYER + 1
        density_factor = 0
        appearance_flags = KEEP_TOGETHER
        vis_flags = VIS_INHERIT_ICON_STATE | VIS_INHERIT_DIR | VIS_INHERIT_LAYER | VIS_INHERIT_ID | VIS_INHERIT_ICON

        oni
            icon = 'OniHorns.dmi'

            kid_horn
                icon = 'oni_horns_kid.dmi'

        demon
            icon = 'demon_horns.dmi'

            demon_2
                icon = 'Demonic Horns.dmi'

            kid_horn
                icon = 'demonic_horns_kid.dmi'

    eyes_iris
        //plane = EYES_LAYER
        layer = MOB_LAYER + 2
        density_factor = 0
        appearance_flags = KEEP_TOGETHER
        vis_flags = VIS_INHERIT_ICON_STATE | VIS_INHERIT_DIR | VIS_INHERIT_LAYER | VIS_INHERIT_ID | VIS_INHERIT_ICON
        icon = 'eye_pupils.dmi'
        hasreflect = 1
        hashadow = 0
        var/original_color
        var/icon_color

        kid
            icon = 'eye_pupils_kid.dmi'
        starteffect()
            original_color = container.saved_eye_c
            if(container.race == "Saiyan" || container.saiyan_dna)
                if(container.superform)
                    icon_color = rgb(80, 200, 120)
                    color_overlay(icon, icon_color)
                else
                    icon_color = original_color
                    color_overlay(icon, icon_color)
                ..()

    sclera
        //plane = EYES_LAYER
        layer = MOB_LAYER + 1
        density_factor = 0
        appearance_flags = KEEP_TOGETHER
        vis_flags = VIS_INHERIT_ICON_STATE | VIS_INHERIT_DIR | VIS_INHERIT_LAYER | VIS_INHERIT_ID | VIS_INHERIT_ICON
        icon = 'eye_whites.dmi'
        hasreflect = 1
        hashadow = 0

        kid
            icon = 'eye_whites_kid.dmi'

    tails
        name = "Saiyan Tail"
        layer = MOB_LAYER + 4
        density_factor = 0
        appearance_flags = KEEP_TOGETHER | PIXEL_SCALE
        vis_flags = VIS_INHERIT_DIR | VIS_INHERIT_LAYER | VIS_INHERIT_ID | VIS_INHERIT_ICON

        saiyan
            brown_tail
                icon = 'SaiyanTailBrown.dmi'
            colorable_tail
                icon = 'SaiyanTailColorable.dmi'
            black_tail
                icon = 'SaiyanTailBlack.dmi'

        /*wrapped
            icon = 'SaiyanTailWrapped.dmi'*/
