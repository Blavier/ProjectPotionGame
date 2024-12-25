// Handle movement and effects when picked up
if (picked_up) {
    // Update position to follow player
    var _player = instance_nearest(x, y, player);
    if (_player != noone) {
        // Position relative to player
        x = _player.x + (_player.image_xscale * 16); // Offset to the side
        y = _player.y + base_y_offset;
        
        // Handle drinking
        if (keyboard_check(ord("F"))) {
            if (!drinking) {
                drinking = true;
            }
            
            // Update drinking animation
            if (drink_progress < 1) {
                drink_progress += drink_speed;
                
                // Calculate tilt and jiggle
                // Tilt towards the player (positive angle if player is facing right, negative if facing left)
                tilt_angle = 45 * drink_progress * sign(_player.image_xscale); 
                jiggle_offset = sin(drink_progress * 20) * (1 - drink_progress) * 3; // Jiggle less as we progress
                base_y_offset = -4 * drink_progress; // Move slightly up while drinking
                
                // Apply effects when drinking is complete
                if (drink_progress >= 1) {
                    // Apply effects to player
                    with(_player) {
                        // Store the effects
                        active_potion_effect = other.potion_effect;
                        active_potion_duration = other.potion_effect.duration;
                        
                        // Apply immediate effects - check for null values
                        if (other.potion_effect.size != undefined) {
                            // Calculate target size
                            var _target_scale = image_xscale * other.potion_effect.size;
                            // Smoothly interpolate to new size
                            image_xscale = lerp(image_xscale, _target_scale, 0.1);
                            image_yscale = lerp(image_yscale, _target_scale, 0.1);
                        }
                        
                        // Apply speed modifier
                        if (other.potion_effect.speed != undefined) {
                            // Reset to base speed first
                            base_move_speed = 0.5; // Reset to default value
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
        }
    } else {
        picked_up = false;
    }
    return;
}

// Physics when not picked up
var _onground = false;
var _grid_collidable = game.grid_collidable;

yvel += game.world_gravity;

if (grid_place_meeting_pos(x, y + 1, _grid_collidable)) {
    _onground = true;
}

// friction
var _airdrag = 0.025;
if (_onground) {
    var _friction = 0.08;
    xvel *= (1.00 - _friction - _airdrag);
    yvel *= (1.00 - _friction - _airdrag);
} else {
    xvel *= (1.00 - _airdrag);
    yvel *= (1.00 - _airdrag);
}

// move obj
var _nx = x + xvel;
var _ny = y + yvel;

// collision
if (xvel != 0) {
    if (!grid_place_meeting_pos(_nx, y, _grid_collidable)) {
        x = _nx;
    } else {
        while (!grid_place_meeting_pos(sign(xvel) + x, y, _grid_collidable)) {
            x += sign(xvel);
        }
        xvel = 0;
    }
}

if (yvel != 0) {
    if (!grid_place_meeting_pos(x, _ny, _grid_collidable)) {
        y = _ny;
    } else {
        while (!grid_place_meeting_pos(x, sign(yvel) + y, _grid_collidable)) {
            y += sign(yvel);
        }
        yvel = 0;
    }
}

// clamp position to room
x = clamp(x, 0, room_width);
y = clamp(y, 0, room_height); 