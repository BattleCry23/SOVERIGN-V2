var/global/list/ACTIVE_VOTE_MUTES = list()


datum/vote_mute
    var
        target_ckey
        starter_ckey
        list/yes_votes = list()
        list/no_votes = list()
        start_time
        active = 1

    New(var/target, var/starter)
        target_ckey = target
        starter_ckey = starter
        start_time = world.time

        spawn(300) // 30 seconds (10 ticks = 1 sec)
            FinishVote()

    proc/AddVote(var/mob/M, var/choice)
        if(!active) return

        if(M.ckey in yes_votes || M.ckey in no_votes || yes_votes[M.ckey] || no_votes[M.ckey])
            M << "You have already voted."
            return

        if(choice == "yes" )
            yes_votes += M.ckey
            M << "You voted <font color=green>YES</font>"

        else
            no_votes += M.ckey
            M << "You voted <font color=red>NO.</font>"

    proc/FinishVote()
        if(!active) return
        active = 0

        var/yes = yes_votes.len
        var/no = no_votes.len
        var/total = yes + no

        //world << "<b>Vote Mute Result for [target_ckey]:</b> YES([yes]) | NO([no])"

        if(total <= 1)
            world << "<b>No contest on [target_ckey]'s mute vote.</b>"
            ACTIVE_VOTE_MUTES -= src
            return

        if(yes > no)
            var/mob/target = GetMobByCkey(target_ckey)
            if(target)
                target.muted = 1
                target.mute_count += 1
                world << "<b>[yes] people voted <font color=green>Yes</font>, [no] people voted <font color=red>No</font> [target_ckey] has been muted!</b></font>"
        else
            world << "<b>[yes] people voted <font color=green>Yes</font>, [no] people voted <font color=red>No</font> [target_ckey] will not be muted!</b></font>"
            //world << "Vote mute failed."

        ACTIVE_VOTE_MUTES -= src
        yes_votes = list()
        no_votes = list()



/proc/GetMobByCkey(var/ck)
    for(var/mob/M in players)
        if(M.ckey == ck)
            return M
    return null
mob/proc/handle_vote_mute()
    if(!src.has_vote_mute)
        src << "You must purchase Vote Mute from the Dokuro Shop."
        return 1

    if(world.time < src.last_vote_mute_time + 100)
        src << "Vote Mute is on cooldown."
        return 1

    var/list/keys = list()
    for(var/mob/M in players)
        if(M.client && M != src)
            keys += M.key

    if(!keys.len)
        src << "No valid players."
        return 1

    var/choice = input(src, "Select player to vote mute:", "Vote Mute") as null|anything in keys
    if(!choice) return 1

    var/ck = ckey(choice)

    var/datum/vote_mute/V = new(ck, src.ckey)
    ACTIVE_VOTE_MUTES += V

    src.last_vote_mute_time = world.time

    world << "<b>[src.key] has started a vote mute against [choice]!</b>"
    world << "<b>Type <font color=green>/y</font> for Yes or <font color=red>/n</font> for No.</b>"

    return 1

mob/proc/handle_vote_response(var/type)
    if(!ACTIVE_VOTE_MUTES.len)
        src << "No active vote mutes."
        return 1

    var/datum/vote_mute/V

    if(ACTIVE_VOTE_MUTES.len == 1)
        V = ACTIVE_VOTE_MUTES[1]
    else
        var/list/options = list()
        for(var/datum/vote_mute/X in ACTIVE_VOTE_MUTES)
            options += X.target_ckey

        var/sel = input(src,"Multiple vote mutes active. Vote for which?") as null|anything in options
        if(!sel) return 1

        for(var/datum/vote_mute/X in ACTIVE_VOTE_MUTES)
            if(X.target_ckey == sel)
                V = X
                break

    if(!V) return 1

    V.AddVote(src, type)
    return 1
