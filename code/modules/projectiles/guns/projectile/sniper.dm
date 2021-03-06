/obj/item/weapon/gun/projectile/heavysniper
	name = "NT AMR \"Penetrator\""
	desc = "A portable anti-armour rifle, fitted with a scope, it was originally designed for use against armoured exosuits. It is capable of punching through windows and non-reinforced walls with ease. Fires armor piercing 14.5mm shells. Alt click it to access the chamber."
	icon_state = "heavysniper"
	item_state = "heavysniper"
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFULL
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	caliber = "14.5mm"
	recoil = 2 //extra kickback
	//fire_sound = 'sound/weapons/sniper.ogg'
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/a145
	fire_sound = 'sound/weapons/guns/fire/sniper_fire.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/rifle_load.ogg'
	matter = list(MATERIAL_PLASTEEL = 40, MATERIAL_PLASTIC = 20)
	var/bolt_open = 0
	zoom_factor = 2.0

/obj/item/weapon/gun/projectile/heavysniper/update_icon()
	if(bolt_open)
		icon_state = "heavysniper-open"
	else
		icon_state = "heavysniper"

/obj/item/weapon/gun/projectile/heavysniper/attack_self(mob/user) //Someone overrode attackself for this class, soooo.
	if(zoom)
		toggle_scope(zoom_factor)
		return
	var/list/options = list("firemode", "scope", "safety")
	for(var/option in options)
		options[option] = image(icon = 'icons/obj/gun_actions.dmi', icon_state = "[option]")
	var/selected
	selected = show_radial_menu(user, src, options, radius = 42)
	if(!selected)
		return
	switch(selected)
		if("firemode")
			var/datum/firemode/new_mode = switch_firemodes(user)
			if(new_mode)
				playsound(src.loc, 'sound/weapons/guns/interact/selector.ogg', 100, 1)
				to_chat(user, SPAN_NOTICE("\The [src] is now set to [new_mode.name]."))
		if("scope")
			toggle_scope(zoom_factor)
		if("safety")
			check_safety(user)

/obj/item/weapon/gun/projectile/heavysniper/AltClick(mob/user as mob)
	playsound(src.loc, 'sound/weapons/guns/interact/rifle_boltback.ogg', 75, 1)
	bolt_open = !bolt_open
	if(bolt_open)
		if(chambered)
			to_chat(user, SPAN_NOTICE("You work the bolt open, ejecting [chambered]!"))
			chambered.loc = get_turf(src)
			loaded -= chambered
			chambered = null
		else
			to_chat(user, SPAN_NOTICE("You work the bolt open."))
	else
		to_chat(user, SPAN_NOTICE("You work the bolt closed."))
		playsound(src.loc, 'sound/weapons/guns/interact/rifle_boltforward.ogg', 75, 1)
		bolt_open = 0
	add_fingerprint(user)
	update_icon()

/obj/item/weapon/gun/projectile/heavysniper/special_check(mob/user)
	if(bolt_open)
		to_chat(user, SPAN_WARNING("You can't fire [src] while the bolt is open!"))
		return 0
	return ..()

/obj/item/weapon/gun/projectile/heavysniper/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/weapon/gun/projectile/heavysniper/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()

/obj/item/weapon/gun/projectile/heavysniper/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(zoom_factor)
