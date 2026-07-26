

/obj/hud/menus/tech_background/proc/ClearTechEntries()
    for(var/obj/O in src.buttons)
        if(O)
            // remove from any containers first
            if(src.tech_holder_special)
                src.tech_holder_special.vis_contents -= O
            src.vis_contents -= O
            del(O)
    if(src.tech_holder) src.tech_holder = null
    if(src.tech_holder_special) src.tech_holder_special = null
    if(src.tech_edge) src.tech_edge = null
    if(src.tech_tree_scrollbar1) src.tech_tree_scrollbar1 = null
    if(src.tech_tree_scrollbar2) src.tech_tree_scrollbar2 = null
    if(src.tech_tree_scroller1) src.tech_tree_scroller1.menu = null
    if(src.tech_tree_scroller2) src.tech_tree_scroller2.menu = null
    src.buttons.Cut()



obj/hud/menus/tech_background/proc/ClearTechEntriesFull()
    src.ClearTechEntries()
    src.populate_tech_tree()
    // now recreate ONLY the entry buttons and push them into src.buttons