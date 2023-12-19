// Inventory Slots


#define MAX_ITEM_IN_SLOT 99
#define MAX_SLOTS_AMOUNT 4

/atom/movable/inventory_slot

	icon = 'icons/ui.dmi'
	icon_state = "slot1"
	plane = UI_PLANE                     // we need this to be high so nothing can overlap it

	var/obj/item/list/_contents = list() // reference to the objects inside the slot

	var/slot_id          // number of this slot. there are 4 of them in total
	var/selected = FALSE // is this slot selected now?

	var/datum/inventory/inventory = null // inventory datum our slot belongs to

/atom/movable/inventory_slot/New(var/slot_id)
	..()

	src.slot_id = slot_id
	icon_state = "slot[slot_id]" // 1

	var/offset_x = 34 * slot_id - 68  // calculating x coordinate of our slot on the screen
	screen_loc =  "CENTER:[offset_x],SOUTH:5"

/atom/movable/inventory_slot/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers["right"])
		RemoveItem(1)

	else
		if(selected)
			_contents[1].Use(usr)

		else
			Select()

/atom/movable/inventory_slot/proc/Select()
	var/atom/movable/inventory_slot/S = inventory.GetSlotSelected()
	if(S)
		S.UnSelect()

	selected = TRUE

	UpdateOverlays()

/atom/movable/inventory_slot/proc/UnSelect()
	selected = FALSE

	UpdateOverlays()

/atom/movable/inventory_slot/proc/UpdateOverlays()
	overlays = list()
	maptext = null

	if(selected)
		var/image/I = image('icons/ui.dmi', icon_state = "slot_outline", layer = UI_PLANE + 2)

		overlays += I

	if(length(_contents))
		var/obj/item/item = _contents[1]
		var/image/I = image(item.icon, icon_state = item.icon_state, layer = UI_PLANE + 1)

		overlays += I

		maptext_y = 32
		maptext = {"<span style='text-align: center; font-size: 3px; -dm-text-outline: 1px black; color: white; line-height: 1.1;'>[_contents[1].name] [length(_contents) > 1 ? "x[length(_contents)]" : ""]</span>"}


/atom/movable/inventory_slot/proc/TryInsertItem(var/obj/item/I)
	if(!length(_contents))
		InsertItem(I)
		return TRUE

	else if(I.type == _contents[1].type && length(_contents) + 1 <= MAX_ITEM_IN_SLOT)
		InsertItem(I)
		return TRUE

	return FALSE

/atom/movable/inventory_slot/proc/InsertItem(var/obj/item/I)
	if(!usr)
		return

	if(!I.icon || !I.icon_state)
		return

	_contents += I
	I.loc = usr

	UpdateOverlays()

/atom/movable/inventory_slot/proc/RemoveItem(amount)
	if(!usr)
		return

	if(!length(_contents))
		return

	if(amount > length(_contents))
		return

	for(var/i = 1; i <= amount; i++)
		var/obj/item/I = _contents[i]
		_contents -= I
		I.loc = GET_TURF(usr)

	UpdateOverlays()

/atom/movable/inventory_slot/proc/AddToScreen()
	usr.client.screen += src

// Actual inventory datum

/datum/inventory
	var/atom/movable/inventory_slot/list/slots = list()

/datum/inventory/New()
	if(!usr)
		del(src)
		return

	if(!usr.client)
		del(src)
		return

	for(var/i in 1 to MAX_SLOTS_AMOUNT)
		var/atom/movable/inventory_slot/slot = new(i)
		slots += slot
		slot.inventory = src

		slot.AddToScreen()

	slots[1].Select()

/datum/inventory/proc/GetItemSelected()
	for(var/atom/movable/inventory_slot/slot in slots)
		if(slot.selected)
			if(!length(slot._contents))
				continue

			return slot._contents[1]

/datum/inventory/proc/GetSlotSelected()
	for(var/atom/movable/inventory_slot/slot in slots)
		if(slot.selected)
			return slot

/datum/inventory/proc/SelectSlot(id)
	if(id > length(slots))
		return

	slots[id].Select()

/datum/inventory/proc/InsertItem(var/obj/item/I)
	var/atom/movable/inventory_slot/slot = GetSlotSelected()
	slot.TryInsertItem(I)

/datum/inventory/proc/RemoveItem(var/amount)
	GetSlotSelected().RemoveItem(amount)

// Inventory using stuff

/atom/Click()
	var/mob/player/P = usr

	if(!istype(P))
		return

	var/obj/item/I = P.GetItemHolding()

	if(!I)
		AttackedHand(P)
		return

	if(!istype(I))
		return

	if(get_dist(src, P) <= 1)
		I.Attack(src, P)


/atom/proc/Attacked(var/obj/item/ByWhat, var/mob/player/User)
	AttackedHand(User)
	return

/atom/proc/AttackedHand(var/mob/player/User)
	User.DoAlert("it is [name]")
	return
