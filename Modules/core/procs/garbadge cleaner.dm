/// QDEL tool - Similar to TG Station's qdel implementation
/// Handles safe deletion of datum objects with proper cleanup

#define QDEL_HINT_IFFAIL 1
#define QDEL_HINT_CURRENT 2

/proc/qdel(datum/thing, force = FALSE)
	if(!thing)
		return
	
	// Check if object is already deleted
	if(QDEL_HINT_IFFAIL in thing.qdel_flags)
		return
	
	// Call before deletion hook
	if(istype(thing, /datum))
		thing._pre_qdel()
	
	// Attempt deletion
	if(force)
		qdel_impl(thing)
	else
		// Safe deletion with potential failure handling
		if(!thing.should_be_qdel())
			thing.qdel_flags |= QDEL_HINT_IFFAIL
			return
		qdel_impl(thing)

/proc/qdel_impl(datum/thing)
	if(!thing)
		return
	
	// Execute qdel hook
	thing._qdel()
	
	// Set deletion flags
	thing.qdel_flags |= QDEL_HINT_CURRENT
	
	// Clear references
	thing = null

/datum
	var/qdel_flags = 0

/datum/proc/_pre_qdel()
	return

/datum/proc/_qdel()
	return

/datum/proc/should_be_qdel()
	return TRUE
