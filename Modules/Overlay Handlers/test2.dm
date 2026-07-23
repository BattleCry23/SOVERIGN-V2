// Overlay handling procs - TG Station style

/**
 * Checks if the given value is an image object
 * @param value - The value to check
 * @return TRUE if value is an image, FALSE otherwise
 */
/proc/isimage(value)
	return istype(value, /image)

/**
 * Colors an overlay properly
 * @param overlay - The overlay to color (image or obj)
 * @param color - The color to apply (hex string or color macro)
 * @param alpha - Optional alpha value (0-255)
 * @param blend_mode - Optional blend mode (BLEND_DEFAULT, BLEND_ADD, etc)
 * @param filter - Optional filter to apply
 * @param randomize - Optional randomize color instead of using provided color
 */
/proc/color_overlay(overlay, color, alpha = 255, blend_mode = BLEND_DEFAULT, filter = null, randomize = FALSE)
	if(!overlay) return FALSE
	var/final_color = color
	if(randomize)
		final_color = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
	if(isimage(overlay))
		var/image/img = overlay
		img.color = final_color
		img.alpha = alpha
		img.blend_mode = blend_mode
		if(filter)
			img.filters += filter
		return TRUE
	else if(isobj(overlay))
		var/obj/o = overlay
		o.color = final_color
		o.alpha = alpha
		o.blend_mode = blend_mode
		if(filter)
			o.filters += filter
		return TRUE
	return FALSE

/**
 * Removes color from an overlay and optionally applies grayscale or black
 * @param overlay - The overlay to modify (image or obj)
 * @param mode - "remove" (default), "grayscale", or "black"
 * @param alpha - Optional alpha value (0-255)
 */
/proc/desaturate_overlay(overlay, mode = "remove", alpha = 255)
	if(!overlay) return FALSE
	if(isimage(overlay))
		var/image/img = overlay
		switch(mode)
			if("black")
				img.color = "#000000"
			if("grayscale")
				img.color = "#808080"
			else
				img.color = null
		img.alpha = alpha
		return TRUE
	else if(isobj(overlay))
		var/obj/o = overlay
		switch(mode)
			if("black")
				o.color = "#000000"
			if("grayscale")
				o.color = "#808080"
			else
				o.color = null
		o.alpha = alpha
		return TRUE
	return FALSE

/**
 * Creates a colored icon
 * @param icon - The icon file or icon state to color
 * @param color - The color to apply (hex string or color macro)
 * @param icon_state - Optional icon state (if icon is a file)
 * @param blend - Optional blend mode for the color (ICON_ADD, ICON_MULTIPLY, etc)
 * @param randomize - Randomize the color instead of using the provided color
 * @return Colored icon or null
 */
/proc/color_icon(icon, color, icon_state = null, blend = ICON_MULTIPLY, randomize = FALSE)
	if(!icon) return null
	var/icon/colored = new(icon, icon_state)
	var/final_color = color
	if(randomize)
		final_color = rgb(rand(1, 255), rand(1, 255), rand(1, 255))
	colored.MapColors(final_color)
	if(blend)
		colored.Blend(final_color, blend)
	return colored

/**
 * Swaps colors on an overlay
 * @param overlay - The overlay to swap colors on (image or obj)
 * @param color1 - First color to swap (hex string or color macro)
 * @param color2 - Second color to replace it with
 * @return TRUE if successful, FALSE otherwise
 */
/proc/swap_overlay_color(overlay, old_color, new_color)
	if(!overlay) return FALSE
	if(isimage(overlay))
		var/image/img = overlay
		if(img.color == old_color)
			img.color = new_color
			return TRUE
	else if(isobj(overlay))
		var/obj/o = overlay
		if(o.color == old_color)
			o.color = new_color
			return TRUE
	return FALSE

/**
 * Adds an overlay to a mob
 * @param overlay - The overlay to add (icon/image or obj/overlay)
 * @param name - Optional name identifier for the overlay
 * @param use_vis_contents - Use vis_contents instead of overlays
 */
/proc/add_overlay(mob/target, overlay, use_vis_contents = FALSE, name)
	if(!target) return
	if(use_vis_contents)
		target.vis_contents += overlay
	else
		target.overlays += overlay
	if(name)
		target.overlay_names[name] = overlay

/**
 * Adds multiple overlays at once via list
 * @param target - The mob to add overlays to
 * @param overlays - List of overlays to add
 * @param names - Optional list of names for the overlays
 * @param use_vis_contents - Use vis_contents instead of overlays
 */
/proc/add_overlays(mob/target, list/overlays, use_vis_contents = FALSE, list/names)
	if(!target || !overlays || !overlays.len) return
	for(var/i = 1 to overlays.len)
		var/overlay = overlays[i]
		var/name = names && names.len >= i ? names[i] : null
		add_overlay(target, overlay, name, use_vis_contents)

/**
 * Removes an overlay by reference or name
 * @param target - The mob to remove overlay from
 * @param overlay - The overlay to remove (icon/image or name string)
 * @param use_vis_contents - Use vis_contents instead of overlays
 */
/proc/remove_overlay(mob/target, overlay, use_vis_contents = FALSE)
	if(!target) return
	if(istext(overlay))
		// Remove by name
		if(target.overlay_names && target.overlay_names[overlay])
			var/overlay_ref = target.overlay_names[overlay]
			if(use_vis_contents)
				target.vis_contents -= overlay_ref
			else
				target.overlays -= overlay_ref
			target.overlay_names -= overlay
	else
		// Remove by reference
		if(use_vis_contents)
			target.vis_contents -= overlay
		else
			target.overlays -= overlay

/**
 * Removes multiple overlays at once via list
 * @param target - The mob to remove overlays from
 * @param overlays - List of overlays to remove (references or name strings)
 * @param use_vis_contents - Use vis_contents instead of overlays
 */
/proc/remove_overlays(mob/target, list/overlays, use_vis_contents = FALSE)
	if(!target || !overlays || !overlays.len) return
	for(var/overlay in overlays)
		remove_overlay(target, overlay, use_vis_contents)

/**
 * Replaces an overlay
 * @param target - The mob to modify
 * @param old_overlay - The overlay to replace (can be name or reference)
 * @param new_overlay - The new overlay
 * @param name - Optional name for the new overlay
 * @param icon_state - Optional icon_state to set on the new overlay
 * @param use_vis_contents - Use vis_contents instead of overlays
 */
/proc/replace_overlay(mob/target, old_overlay, new_overlay, icon_state, use_vis_contents = FALSE, name)
	if(!target) return
	remove_overlay(target, old_overlay, use_vis_contents)
	if(icon_state)
		if(isimage(new_overlay))
			var/image/img = new_overlay
			img.icon_state = icon_state
		else if(isobj(new_overlay))
			var/obj/o = new_overlay
			o.icon_state = icon_state
	add_overlay(target, new_overlay, use_vis_contents, name)

/**
 * Clears all overlays from a mob
 * @param target - The mob to clear
 * @param use_vis_contents - Use vis_contents instead of overlays
 */
/proc/clear_overlays(mob/target, use_vis_contents = FALSE)
	if(!target) return
	if(use_vis_contents)
		target.vis_contents.Cut()
	else
		target.overlays.Cut()
	if(target.overlay_names)
		target.overlay_names.Cut()

/**
 * Fast overlay removal - directly clears overlays list
 * @param target - The mob to clear
 * @param use_vis_contents - Use vis_contents instead of overlays
 */
/proc/remove_overlays_fast(mob/target, use_vis_contents = FALSE)
	if(!target) return
	if(use_vis_contents)
		target.vis_contents = list()
	else
		target.overlays = list()
	target.overlay_names = list()

/**
 * Gets an overlay by name
 * @param target - The mob to search
 * @param name - The overlay name
 * @return The overlay or null
 */
/proc/get_overlay(mob/target, name)
	if(!target || !target.overlay_names) return null
	return target.overlay_names[name]

/**
 * Checks if an overlay exists
 * @param target - The mob to check
 * @param name - The overlay name or reference
 * @param use_vis_contents - Use vis_contents instead of overlays
 * @return TRUE if overlay exists
 */
/proc/has_overlay(mob/target, overlay, use_vis_contents = FALSE)
	if(!target) return FALSE
	if(istext(overlay))
		return target.overlay_names && (overlay in target.overlay_names)
	if(use_vis_contents)
		return (overlay in target.vis_contents)
	return (overlay in target.overlays)

/**
 * Gets the count of overlays on a mob
 * @param target - The mob to check
 * @param use_vis_contents - Use vis_contents instead of overlays
 * @return Number of overlays
 */
/proc/count_overlays(mob/target, use_vis_contents = FALSE)
	if(!target) return 0
	if(use_vis_contents)
		return length(target.vis_contents)
	return length(target.overlays)

/**
 * Lists all named overlays on a mob
 * @param target - The mob to check
 * @return List of overlay names
 */
/proc/list_overlay_names(mob/target)
	if(!target || !target.overlay_names) return list()
	return target.overlay_names.Copy()

/**
 * Lists all overlays (named and unnamed)
 * @param target - The mob to check
 * @param use_vis_contents - Use vis_contents instead of overlays
 * @return List of all overlays
 */
/proc/list_all_overlays(mob/target, use_vis_contents = FALSE)
	if(!target) return list()
	if(use_vis_contents)
		return target.vis_contents.Copy()
	return target.overlays.Copy()

/**
 * Removes all named overlays, keeping unnamed ones
 * @param target - The mob to modify
 * @param use_vis_contents - Use vis_contents instead of overlays
 */
/proc/clear_named_overlays(mob/target, use_vis_contents = FALSE)
	if(!target) return
	if(target.overlay_names)
		for(var/name in target.overlay_names)
			remove_overlay(target, name, use_vis_contents)

/**
 * Syncs overlays between source and target mob
 * Updates target's overlays to match source
 * @param source - The mob to sync from
 * @param target - The mob to sync to
 * @param use_vis_contents - Use vis_contents instead of overlays
 */
/proc/sync_overlays(mob/source, mob/target, use_vis_contents = FALSE)
	if(!source || !target) return
	clear_overlays(target, use_vis_contents)
	var/source_list = use_vis_contents ? source.vis_contents : source.overlays
	var/target_list = use_vis_contents ? target.vis_contents : target.overlays
	for(var/overlay in source_list)
		target_list += overlay
		target.update_looks()
	if(source.overlay_names)
		for(var/name in source.overlay_names)
			target.overlay_names[name] = source.overlay_names[name]

/**
 * Auto-syncs overlays on overlay change
 * Call this after modifying overlays to propagate changes
 * @param target - The mob whose overlays changed
 * @param observers - List of mobs to sync to
 * @param use_vis_contents - Use vis_contents instead of overlays
 */
/proc/broadcast_overlay_update(mob/target, list/observers, use_vis_contents = FALSE)
	if(!target || !observers) return
	for(var/mob/observer in observers)
		sync_overlays(target, observer, use_vis_contents)

/**
 * Auto-centers overlays that are bigger than the mob
 * @param target - The mob to add overlay to
 * @param overlay - The overlay to add and center if needed
 * @param name - Optional name identifier for the overlay
 * @param use_vis_contents - Use vis_contents instead of overlays
 */
/proc/add_overlay_centered(mob/target, overlay, name, use_vis_contents = FALSE)
	if(!target) return
	if(use_vis_contents)
		target.vis_contents += overlay
	else
		target.overlays += overlay
	if(name)
		target.overlay_names[name] = overlay
	
	// Center overlay if it's bigger than the mob
	if(isimage(overlay))
		var/image/img = overlay
		var/icon_width = img.icon:Width()
		var/icon_height = img.icon:Height()
		var/mob_width = target.icon:Width()
		var/mob_height = target.icon:Height()
		
		if(icon_width > mob_width || icon_height > mob_height)
			img.pixel_x = -(icon_width - mob_width) / 2
			img.pixel_y = -(icon_height - mob_height) / 2

// Add to mob initializer if not present
/mob
	var/list/overlay_names = list()  // Stores named overlays for easy access
	var/list/overlay_observers = list()  // Mobs that should sync overlays from this mob
