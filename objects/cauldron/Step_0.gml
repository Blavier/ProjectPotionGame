// Check for collision with mushrooms
var _colliding_mushroom = instance_place(x, y, mushroom);
if (_colliding_mushroom != noone) {
    // Only add the mushroom if it's not being held
    if (!_colliding_mushroom.picked_up) {
        // Add to ingredients if not already present
        if (array_length(ingredients) < 5) { // Limit to 5 ingredients
            // Store the object name instead of the instance
            var _ingredient_name = object_get_name(_colliding_mushroom.object_index);
            array_push(ingredients, _ingredient_name);
            show_debug_message("Added mushroom to cauldron. Total ingredients: " + string(array_length(ingredients)));
            
            // Create a visual indicator
            with (instance_create_layer(x, y, "Instances", obj_ingredient_visual)) {
                parent_cauldron = other.id;
                sprite_index = _colliding_mushroom.sprite_index;
                image_xscale = 0.5; // Make it smaller
                image_yscale = 0.5;
                angle_offset = other.angle + (360 / (array_length(other.ingredients))); // Spread evenly
            }
            // Destroy the original mushroom
            instance_destroy(_colliding_mushroom);
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