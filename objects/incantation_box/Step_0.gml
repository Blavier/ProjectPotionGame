if (!active) {
    // Fade out when not active
    alpha -= fade_speed;
    if (alpha <= 0) {
        show_debug_message("Incantation box destroyed");
        instance_destroy();
    }
    exit;
}

// Update position relative to cauldron
if (instance_exists(parent_cauldron)) {
    x = parent_cauldron.x;
    y = parent_cauldron.y + y_offset;
} else {
    show_debug_message("Parent cauldron not found, destroying incantation box");
    instance_destroy();
    exit;
}

// Handle keyboard input
if (keyboard_cooldown > 0) keyboard_cooldown--;

// Check for escape key first
if (keyboard_check_pressed(vk_escape)) {
    show_debug_message("Escape pressed, closing incantation box without saving");
    if (instance_exists(parent_cauldron)) {
        parent_cauldron.incantation = ""; // Clear the incantation
    }
    active = false;
    exit;
}

if (keyboard_cooldown <= 0) {
    // Get keyboard input
    var _input = keyboard_string;
    
    // Handle backspace
    if (keyboard_check_pressed(vk_backspace) && string_length(text) > 0) {
        text = string_delete(text, string_length(text), 1);
        keyboard_string = text;
        keyboard_cooldown = keyboard_cooldown_max;
        show_debug_message("Backspace pressed. Current text: " + text);
    }
    // Handle enter key
    else if (keyboard_check_pressed(vk_enter)) {
        show_debug_message("Enter pressed. Final text: " + text);
        // Set the incantation in the cauldron
        if (instance_exists(parent_cauldron)) {
            parent_cauldron.incantation = text;
            show_debug_message("Set incantation in cauldron to: " + text);
            // Only send HTTP request if we have both ingredients and incantation
            if (array_length(parent_cauldron.ingredients) > 0 && string_length(text) > 0) {
                show_debug_message("Triggering HTTP request with ingredients count: " + 
                    string(array_length(parent_cauldron.ingredients)) + 
                    " and incantation: " + text);
                
                with(parent_cauldron) {
                    // Create the request body with ingredient names
                    var _body = {
                        ingredients: ingredients,
                        incantation: incantation
                    };
                    
                    show_debug_message("Created request body with ingredients: " + json_stringify(ingredients));

                    // Convert the body to JSON string
                    var _json_body = json_stringify(_body);
                    show_debug_message("JSON body: " + _json_body);

                    // Create header map
                    var _headers = ds_map_create();
                    ds_map_add(_headers, "Content-Type", "application/json");
                    show_debug_message("Created headers");

                    // Send the request
                    show_debug_message("Sending HTTP request...");
                    request_id = http_request("http://localhost:5000/chat", "POST", _headers, _json_body);
                    show_debug_message("Request sent with ID: " + string(request_id));

                    // Clean up the header map as it's no longer needed
                    ds_map_destroy(_headers);
                    
                    // Clear ingredients and incantation
                    ingredients = [];
                    incantation = "";
                    show_debug_message("Cleared cauldron ingredients and incantation");
                    
                    // Destroy all visual indicators
                    with(obj_ingredient_visual) {
                        if(parent_cauldron == other.id) {
                            instance_destroy();
                        }
                    }
                }
            } else {
                show_debug_message("Not sending request. Ingredients: " + 
                    string(array_length(parent_cauldron.ingredients)) + 
                    ", Incantation length: " + string(string_length(text)));
            }
        }
        // Start fading out
        active = false;
        show_debug_message("Starting fade out of incantation box");
    }
    // Normal text input
    else if (string_length(_input) > string_length(text) && string_length(text) < max_length) {
        text = _input;
        keyboard_cooldown = keyboard_cooldown_max;
        show_debug_message("Text updated: " + text);
    }
}
