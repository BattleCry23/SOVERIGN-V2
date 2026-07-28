// Beam struggle datum
datum/struggle
	var/obj/ranged/checker/beam_one = null
	var/obj/ranged/checker/beam_two = null
	var/struggle_power = 0
	var/struggle_timer = 0

    proc/struggle_start(obj/ranged/checker/beam_one, obj/ranged/checker/beam_two)
        struggle_power = 0
        struggle_timer = 0
        src.beam_one = b1
        src.beam_two = b2
        b1.in_clash = 1
        b2.in_clash = 1

        b1.clash_opponent = b2
        b2.clash_opponent = b1

        b1.layer = MOB_LAYER +2
        b2.layer = MOB_LAYER +2
        b1.density = 1
        b2.density = 1

        struggle_loop()

    proc/struggle_loop()
        while(beam_one && beam_two && !beam_one.in_origin && !beam_two.in_origin)
            sleep(2 * SECONDS)
            struggle_timer++

