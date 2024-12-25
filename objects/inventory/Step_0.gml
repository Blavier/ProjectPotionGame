/// @description Handle inventory interactions

// Check for number key presses (1-3)
for (var i = 0; i < 3; i++) {
    if (keyboard_check_pressed(ord(string(i + 1)))) {
        show_debug_message("Slot " + string(i + 1) + " key pressed");
        
        // If player is holding an item, try to store it
        if (instance_exists(player_ref) && player_ref.held_item != noone && instance_exists(player_ref.held_item)) {
            if (slots[i].is_empty) {
                show_debug_message("Storing item in slot " + string(i + 1));
                // Store item info and destroy the instance
                var _item_to_store = player_ref.held_item;
                slots[i] = store_item(_item_to_store);
                instance_destroy(_item_to_store);
                player_ref.held_item = noone;
            }
        }
        // If player isn't holding an item and slot has an item, retrieve it
        else if (!slots[i].is_empty && instance_exists(player_ref)) {
            show_debug_message("Creating item from slot " + string(i + 1));
            // Create new instance from stored item
            var _new_item = instance_create_layer(player_ref.x, player_ref.y, "Instances", asset_get_index(slots[i].type));
            if (instance_exists(_new_item)) {
                with (_new_item) {
                    sprite_index = other.slots[i].sprite;
                    
                    // Set properties based on item type
                    if (object_index == item) {
                        item_power = other.slots[i].data.item_power;
                        rarity = other.slots[i].data.rarity;
                    }
                    else if (object_index == potion) {
                        potion_effect = other.slots[i].data.potion_effect;
                        potion_power = other.slots[i].data.potion_power;
                    }
                    
                    picked_up = true;
                }
                player_ref.held_item = _new_item;
                slots[i] = create_empty_slot();
                show_debug_message("Item retrieved from slot " + string(i + 1));
            } else {
                show_debug_message("Failed to create item from slot " + string(i + 1));
            }
        } else {
            show_debug_message("Cannot interact with slot " + string(i + 1) + 
                             ". Slot empty: " + string(slots[i].is_empty) + 
                             ", Player exists: " + string(instance_exists(player_ref)) + 
                             ", Player holding item: " + string(player_ref != noone && player_ref.held_item != noone) +
                             ", Item exists: " + string(player_ref != noone && player_ref.held_item != noone && instance_exists(player_ref.held_item)));
        }
    }
}

// Update player reference if not set
if (player_ref == noone) {
    player_ref = instance_nearest(x, y, player);
    if (player_ref != noone) {
        show_debug_message("Found player reference");
    }
}
