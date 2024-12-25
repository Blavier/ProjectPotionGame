// Check for collision with items
var _colliding_item = instance_place(x, y, item);
if (_colliding_item != noone) {
    // Only add the item if it's not being held
    if (!_colliding_item.picked_up) {
        // Add to ingredients if not already present
        if (array_length(ingredients) < 5) { // Limit to 5 ingredients
            // Store the item info
            var _ingredient_info = {
                name: _colliding_item.item_name,
                power: _colliding_item.item_power
            };
            array_push(ingredients, _ingredient_info);
            
            // Update total power
            total_power += _colliding_item.item_power;
            
            show_debug_message("Added " + _colliding_item.item_name + 
                " (power: " + string(_colliding_item.item_power) + ") to cauldron. Total power: " + 
                string(total_power));
            
            // Create a visual indicator
            with (instance_create_layer(x, y, "Instances", obj_ingredient_visual)) {
                parent_cauldron = other.id;
                sprite_index = _colliding_item.sprite_index;
                image_xscale = 0.75; // Make it smaller
                image_yscale = 0.75;
                angle_offset = other.angle + (360 / (array_length(other.ingredients))); // Spread evenly
            }
            // Destroy the original item
            instance_destroy(_colliding_item);
            // play sound
            audio_play_sound(magic__2_, 0, 0);
        } else {
            show_debug_message("Cauldron is full! Cannot add more ingredients.");
        }
    }
}

// Check for incantation input when ingredients are present and player is touching cauldron
var _player_touching = instance_place(x, y, player);
if (array_length(ingredients) > 0 && keyboard_check_pressed(ord("E")) && _player_touching != noone) {
    // Only create if one doesn't already exist
    if (!instance_exists(incantation_box)) {
        show_debug_message("Opening incantation box. Current incantation: " + string(incantation));
        var _box = instance_create_layer(x, y, "Instances", incantation_box);
        _box.parent_cauldron = id;
        keyboard_string = ""; // Clear keyboard buffer
    }
} else if (keyboard_check_pressed(ord("E")) && !_player_touching) {
    show_debug_message("Player must be touching cauldron to enter incantation");
} else if (keyboard_check_pressed(ord("E")) && array_length(ingredients) == 0) {
    show_debug_message("Need ingredients in cauldron to enter incantation");
}

// Update rotation angle for visual indicators
angle += rotation_speed;
if (angle >= 360) angle -= 360;