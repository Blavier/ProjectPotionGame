if (keyboard_check_pressed(vk_space)) {
    // Create the request body
    var _body = {
        ingredients: ingredients,
        incantation: incantation
    };

    // Convert the body to JSON string
    var _json_body = json_stringify(_body);

    // Create header map
    var _headers = ds_map_create();
    ds_map_add(_headers, "Content-Type", "application/json");

    // Send the request
    request_id = http_request("http://localhost:5000/chat", "POST", _headers, _json_body);

    // Clean up the header map as it's no longer needed
    ds_map_destroy(_headers);
}

// Check for collision with mushrooms
var _colliding_mushroom = instance_place(x, y, mushroom);
if (_colliding_mushroom != noone) {
    // Only add the mushroom if it's not being held
    if (!_colliding_mushroom.picked_up) {
        // Add to ingredients if not already present
        if (array_length(ingredients) < 5) { // Limit to 5 ingredients
            array_push(ingredients, _colliding_mushroom);
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
			// play sound
			audio_play_sound(magic__2_, 0, 0)
        }
    }
}

// Update rotation angle for visual indicators
angle += rotation_speed;
if (angle >= 360) angle -= 360;