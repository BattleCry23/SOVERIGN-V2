// ---------- Admin profile globals ----------
// A simple alphabetized list of admin color *names*
var/list/AdminColorNames = list(
    "Admin Black",
    "Admin Blue",
    "Admin Cyan",
    "Admin Gold",
    "Admin Green",
    "Admin Orange",
    "Admin Pink",
    "Admin Purple",
    "Admin Red",
    "Admin Silver",
    "Admin White",
    "Admin Yellow"
)

// A mapping from color-name -> owning ckey (null if unclaimed).
// Use an associative list for mapping so we can test/claim easily.
var/list/AdminColorOwners = list()
for (var/name in AdminColorNames)
    AdminColorOwners[name] = null

// Icon options (kept small and static)
var/list/AdminIconOptions = list("Default", "Feline Humanoid", "Canine Humanoid", "Floating Cat")

// ---------- Utility: alphabetic sort for lists of text ----------
proc/sort_alpha(var/list/L)
    // Simple insertion/bubble style using your BubbleSort/Compare if present.
    // Use a basic bubble sort that works for text and numbers via sorttextEx
    if (!L || L.len <= 1) return L
    for (var/i = L.len; i >= 2; i--)
        for (var/j = 1; j < i; j++)
            if (sorttextEx(L[j], L[j+1]) == 1) // if L[j] > L[j+1] alphabetically
                var/temp = L[j]
                L[j] = L[j+1]
                L[j+1] = temp
    return L

// ---------- Admin setup proc (mob) ----------
// This uses plain input/alert/outputs so it is robust and won't produce prototype errors.
mob/proc/admin_setup()
    if (src.admin_setup_done)
        src << "You have already completed admin setup."
        return

    // 1) Build available color list
    var/list/available = list()
    for (var/name in AdminColorNames)
        if (!AdminColorOwners[name]) // unclaimed
            available += name

    // Sort available alphabetically for nice display
    sort_alpha(available)

    if (!available.len)
        src << "No color profiles are available. Contact a super-admin."
        return

    // Show available choices to player (output lines) and ask them to type exact name
    src << "<center><b>Available Admin Color Profiles</b></center>"
    for (var/n in available)
        src << "  - [n]"

    var/color_choice = input(src, "Type the EXACT Admin Color you want from the list above, or Cancel to abort:", "Admin Setup")
    if (!color_choice)
        src << "Admin setup canceled."
        return

    // Normalize and validate selection (allow case-insensitive matching)
    var/selected_name = null
    for (var/n in available)
        if (lowertext(n) == lowertext(color_choice))
            selected_name = n
            break

    if (!selected_name)
        src << "Invalid selection or color already taken. Re-run setup and choose one of the listed names exactly."
        return

    // Claim it (atomically-ish)
    if (AdminColorOwners[selected_name])
        // someone raced you and claimed it in the meantime
        src << "Sorry — that color was just taken by another admin. Please run setup again."
        return
    AdminColorOwners[selected_name] = src.ckey
    src.admin_color = selected_name

    // 2) Choose icon option (use alert buttons for a small list)
    var/buttons = ""
    for (var/opt in AdminIconOptions)
        buttons += "[opt],"

    // remove trailing comma from the buttons string
    if (buttons) buttons = copytext(buttons, 1, length(buttons)-1)

    // alert returns the text of the button clicked
    var/icon_choice = alert(src, "Choose your Admin Icon type:", "Admin Icon", Buttons = buttons)
    if (!icon_choice)
        // free the claimed color if they cancel icon selection
        AdminColorOwners[selected_name] = null
        src.admin_color = null
        src << "Icon selection canceled. Your color choice was released."
        return

    // Validate icon chosen
    var/icon_valid = 0
    for (var/i in AdminIconOptions)
        if (AdminIconOptions[i] == icon_choice) icon_valid = 1

    if (!icon_valid)
        // should not happen, but safe fallback
        AdminColorOwners[selected_name] = null
        src.admin_color = null
        src << "Invalid icon selection. Setup aborted."
        return

    src.admin_icon_type = icon_choice
    src.admin_setup_done = 1

    // Confirmation
    alert(src, "Admin setup complete!\n\nColor: [src.admin_color]\nIcon: [src.admin_icon_type]\n\nYou may now enter Admin Mode.", "Setup Complete", "OK")
    return
