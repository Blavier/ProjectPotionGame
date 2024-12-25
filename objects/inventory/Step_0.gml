/// @description Handle inventory interactions

// Check for number key presses (1-3)
for (var i = 0; i < 3; i++) {
    if (keyboard_check_pressed(ord(string(i + 1)))) {
        // If there's an item in this slot
        if (slots[i] != noone) {
            // If player is already holding something, swap it with the slot
            if (instance_exists(player_ref) && player_ref.held_item != noone) {
                var _temp = store_item(player_ref.held_item);
                instance_destroy(player_ref.held_item);
                
                // Create new instance from stored item
                var _new_item = instance_create_layer(player_ref.x, player_ref.y, "Instances", asset_get_index(slots[i].item_type));
                with (_new_item) {
                    sprite_index = other.slots[i].sprite;
                    item_power = other.slots[i].item_power;
                    rarity = other.slots[i].rarity;
                    picked_up = true;
                }
                
                player_ref.held_item = _new_item;
                slots[i] = _temp;
            } else {
                // Otherwise, just create the item from the slot
                if (instance_exists(player_ref)) {
                    var _new_item = instance_create_layer(player_ref.x, player_ref.y, "Instances", asset_get_index(slots[i].item_type));
                    with (_new_item) {
                        sprite_index = other.slots[i].sprite;
                        item_power = other.slots[i].item_power;
                        rarity = other.slots[i].rarity;
                        picked_up = true;
                    }
                    player_ref.held_item = _new_item;
                    slots[i] = noone;
                }
            }
        }
    }
}

// Update player reference if not set
if (player_ref == noone) {
    player_ref = instance_nearest(x, y, player);
}
