// In the Async HTTP Event of obj_cauldron
if (async_load[? "id"] == request_id) {
    if (async_load[? "status"] == 0) { // If the request was successful
        var _response = async_load[? "result"];
        
        // Parse the JSON response
        var _potion_details = json_parse(_response);
        show_debug_message("Potion created: " + string(_potion_details));
        
        // Create potion object slightly above the cauldron
        var _potion = instance_create_layer(player.x, player.y, "Instances", potion);
		
		//play_sound_world(cool_sound,player.x,player.y,500,1,250,0,0)
        
        // Configure the potion with the response data
        with(_potion) {
            effectiveness = _potion_details.effectiveness;
            potion_name = _potion_details.potion_name;
            
            // Convert hex color to GameMaker color
            // Remove the # from hex color and convert to decimal
            var _color_hex = string_replace(_potion_details.potion_color, "#", "");
            var _red = hex_to_dec(string_copy(_color_hex, 1, 2));
            var _green = hex_to_dec(string_copy(_color_hex, 3, 2));
            var _blue = hex_to_dec(string_copy(_color_hex, 5, 2));
            potion_color = make_color_rgb(_red, _green, _blue);
            
            // Copy all effect properties
            potion_effect.size = _potion_details.potion_effect.size;
            potion_effect.position = _potion_details.potion_effect.position;
            potion_effect.health = _potion_details.potion_effect.health;
            potion_effect.jump_velocity = _potion_details.potion_effect.jump_velocity;
            potion_effect.speed = _potion_details.potion_effect.speed;
            potion_effect.duration = _potion_details.potion_effect.duration;
        }
    } else {
        show_debug_message("Error in HTTP request: " + string(async_load[? "status"]));
    }
}

