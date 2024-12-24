// Handle movement and effects when picked up
if (picked_up) {
    show_debug_message("Potion is picked up, following player");
    // Update position to follow player
    var _player = instance_nearest(x, y, player);
    if (_player != noone) {
        // Position relative to player
        x = _player.x + (_player.image_xscale * 16); // Offset to the side
        y = _player.y + base_y_offset;
        show_debug_message("Updated potion position to: " + string(x) + ", " + string(y));
        
        // Handle drinking
        if (keyboard_check(ord("F"))) {
            if (!drinking) {
                drinking = true;
                show_debug_message("Started drinking potion");
            }
            
            // Update drinking animation
            if (drink_progress < 1) {
                drink_progress += drink_speed;
                show_debug_message("Drinking progress: " + string(drink_progress));
                
                // Calculate tilt and jiggle
                // Tilt towards the player (negative angle if player is facing right, positive if facing left)
                tilt_angle = -45 * drink_progress * sign(_player.image_xscale); 
                jiggle_offset = sin(drink_progress * 20) * (1 - drink_progress) * 3; // Jiggle less as we progress
                base_y_offset = -4 * drink_progress; // Move slightly up while drinking
                
                // Apply effects when drinking is complete
                if (drink_progress >= 1) {
                    show_debug_message("Finished drinking potion");
                    
                    // Apply effects to player
                    with(_player) {
                        // Store the effects
                        active_potion_effect = other.potion_effect;
                        active_potion_duration = other.potion_effect.duration;
                        
                        // Apply immediate effects - check for null values
                        if (other.potion_effect.size != undefined) {
                            image_xscale *= other.potion_effect.size;
                            image_yscale *= other.potion_effect.size;
                        }
                        
                        // Check if position exists and is an array before accessing indices
                        if (other.potion_effect.position != undefined && is_array(other.potion_effect.position)) {
                            if (array_length(other.potion_effect.position) > 0 && other.potion_effect.position[0] != undefined) {
                                x += other.potion_effect.position[0];
                            }
                            if (array_length(other.potion_effect.position) > 1 && other.potion_effect.position[1] != undefined) {
                                y += other.potion_effect.position[1];
                            }
                        }
                        
                        show_debug_message("Applied potion effects - Size: " + string(image_xscale) + 
                            ", Speed: " + string(other.potion_effect.speed) + 
                            ", Duration: " + string(active_potion_duration));
                    }
                    
                    // Destroy the potion
                    instance_destroy();
                }
            }
        } else if (drinking) {
            // Reset drinking progress if player releases F
            drinking = false;
            drink_progress = 0;
            tilt_angle = 0;
            jiggle_offset = 0;
            base_y_offset = 0;
            show_debug_message("Stopped drinking potion");
        }
    } else {
        show_debug_message("No player found, dropping potion");
        picked_up = false;
    }
} else {
    show_debug_message("Potion is not picked up. Position: " + string(x) + ", " + string(y));
} 