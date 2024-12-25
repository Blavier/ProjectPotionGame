// In the Async HTTP Event of obj_cauldron
if (async_load[? "id"] == request_id) {
    if (async_load[? "status"] == 0) { // If the request was successful
        var _response = async_load[? "result"];
        
        // Parse the JSON response
        var _potion_details = json_parse(_response);
        show_debug_message("Raw potion details: " + string(_response));
        
        // Create potion object slightly above the cauldron
        var _potion = instance_create_layer(player.x, player.y, "Instances", potion);
        
        // Play sound
        audio_play_sound(magic, 0, 0);
        
        // Configure the potion with the response data
        with(_potion) {
            effectiveness = _potion_details.effectiveness;
            potion_name = _potion_details.potion_name;
            
            // Convert hex color to GameMaker color
            var _color_hex = string_replace(_potion_details.potion_color, "#", "");
            var _red = hex_to_dec(string_copy(_color_hex, 1, 2));
            var _green = hex_to_dec(string_copy(_color_hex, 3, 2));
            var _blue = hex_to_dec(string_copy(_color_hex, 5, 2));
            potion_color = make_color_rgb(_red, _green, _blue);
            
            // Scale effects based on cauldron power
            var _base_effects = _potion_details.potion_effect;
            
            // Initialize default values
            var _size = 1.0;
            var _health = 0;
            var _jump = 1.0;
            var _speed = 0;
            var _duration = 300;  // 5 seconds at 60fps
            var _position = [0, 0];
            
            // Apply scaling only if effects exist
            if (_base_effects != undefined) {
                show_debug_message("Original Potion Stats:");
                show_debug_message("- Size: " + string(_base_effects.size));
                show_debug_message("- Health: " + string(_base_effects.health));
                show_debug_message("- Jump: " + string(_base_effects.jump_velocity));
                show_debug_message("- Speed: " + string(_base_effects.speed));
                show_debug_message("- Duration: " + string(_base_effects.duration));
                
                if (_base_effects.size != undefined) 
                    _size = other.scale_effect_multiplier(_base_effects.size, other.total_power);
                
                if (_base_effects.health != undefined) 
                    _health = _base_effects.health * other.total_power;
                
                if (_base_effects.jump_velocity != undefined) 
                    _jump = other.scale_effect_multiplier(_base_effects.jump_velocity, other.total_power);
                
                if (_base_effects.speed != undefined) 
                    _speed = other.scale_effect_multiplier(_base_effects.speed, other.total_power);
                
                if (_base_effects.duration != undefined && _base_effects.duration > 0) {
                    _duration = _base_effects.duration;
                    // Scale duration with power (1 power = normal duration, more power = longer duration)
                    _duration = _duration * (1 + (other.total_power / 10));
                }
                // Ensure minimum duration of 5 seconds (300 frames at 60fps)
                _duration = max(_duration, 300);
                
                if (_base_effects.position != undefined) 
                    _position = _base_effects.position;
                    
                show_debug_message("Power-Scaled Potion Stats (Power: " + string(other.total_power) + "):");
                show_debug_message("- Size: " + string(_size));
                show_debug_message("- Health: " + string(_health));
                show_debug_message("- Jump: " + string(_jump));
                show_debug_message("- Speed: " + string(_speed));
                show_debug_message("- Duration: " + string(_duration));
            }
            
            // Create the effect struct with safe values
            potion_effect = {
                size: _size,
                position: _position,
                health: _health,
                jump_velocity: _jump,
                speed: _speed,
                duration: _duration
            };
        }
        
        // Clear ingredients and power
        ingredients = [];
        total_power = 0;
        incantation = "";
        
        // Destroy all visual indicators
        with(obj_ingredient_visual) {
            if(parent_cauldron == other.id) {
                instance_destroy();
            }
        }
    }
}

