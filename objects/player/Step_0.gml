// Check if incantation box is active
var _can_move = !instance_exists(incantation_box) || !incantation_box.active;

var _key_left = _can_move ? keyboard_check(ord("A")) : false;
var _key_right = _can_move ? keyboard_check(ord("D")) : false;
var _key_up = _can_move ? keyboard_check(ord("W")) : false;
var _key_down = _can_move ? keyboard_check(ord("S")) : false;
var _key_action = keyboard_check(vk_space);
var _key_pickup = keyboard_check_pressed(ord("E"));
var _key_left_mouse = mouse_check_button(mb_left)
var _key_left_mouse_pressed = mouse_check_button_pressed(mb_left)
var _key_right_mouse = mouse_check_button(mb_right)
var _key_right_mouse_pressed = mouse_check_button_pressed(mb_right)

// Calculate movement speed based on potion effect
var _current_speed = base_move_speed;
if (variable_instance_exists(id, "active_potion_effect") && 
    active_potion_effect != undefined && 
    is_struct(active_potion_effect) &&
    variable_struct_exists(active_potion_effect, "speed") && 
    active_potion_effect.speed != undefined) {
    _current_speed *= (1 + active_potion_effect.speed);
}

if _key_left
{
    xvel -= _current_speed;
    image_xscale = -abs(image_xscale); // Face left
}
if _key_right
{
    xvel += _current_speed;
    image_xscale = abs(image_xscale); // Face right
}

xvel *= 0.91;
yvel *= 0.91;

x += xvel
y += yvel

// Update potion duration
if (variable_instance_exists(id, "active_potion_effect") && 
    active_potion_effect != undefined && 
    is_struct(active_potion_effect)) {
    if (active_potion_duration > 0) {
        active_potion_duration--;
        show_debug_message("Potion duration: " + string(active_potion_duration));
    } else {
        // Reset effects
        image_xscale = sign(image_xscale); // Keep facing direction but reset scale
        image_yscale = 1;
        show_debug_message("Potion effects wore off");
        active_potion_effect = undefined;
    }
}

// Pickup/throw logic
if (_key_pickup) {
    show_debug_message("E pressed - checking for items to pick up");
    var _held_mushroom = noone;
    var _held_potion = noone;
    
    // Check if we're already holding a mushroom
    with (mushroom) {
        if (variable_instance_exists(id, "picked_up") && picked_up) {
            _held_mushroom = id;
        }
    }
    
    // Check if we're already holding a potion
    with (potion) {
        if (picked_up) {
            _held_potion = id;
        }
    }
    
    show_debug_message("Currently held: Mushroom=" + string(_held_mushroom) + ", Potion=" + string(_held_potion));
    
    if (_held_mushroom != noone) {
        // Throw the held mushroom
        with (_held_mushroom) {
            picked_up = false;
            // Calculate direction to mouse
            var _dir = point_direction(x, y, mouse_x, mouse_y);
            // Convert direction to x and y components
            xvel = lengthdir_x(throw_speed, _dir);
            yvel = lengthdir_y(throw_speed, _dir);
            show_debug_message("Threw mushroom");
            audio_play_sound(impact, 0, 0);
        }
    } else if (_held_potion != noone) {
        // Drop the held potion
        with (_held_potion) {
            picked_up = false;
            show_debug_message("Dropped potion");
        }
    } else {
        // Try to pick up a nearby item
        var _nearest_mushroom = instance_nearest(x, y, mushroom);
        var _nearest_potion = instance_nearest(x, y, potion);
        
        var _mushroom_dist = _nearest_mushroom != noone ? distance_to_object(_nearest_mushroom) : 999999;
        var _potion_dist = _nearest_potion != noone ? distance_to_object(_nearest_potion) : 999999;
        
        show_debug_message("Nearest items - Mushroom: " + string(_mushroom_dist) + ", Potion: " + string(_potion_dist));
        
        // Pick up the closest item within range
        if (_mushroom_dist < 32 && _mushroom_dist <= _potion_dist) {
            with (_nearest_mushroom) {
                if (!variable_instance_exists(id, "picked_up")) {
                    picked_up = false;
                    throw_speed = 15;
                    xvel = 0;
                    yvel = 0;
                }
                picked_up = true;
                show_debug_message("Picked up mushroom");
                audio_play_sound(impact_high, 0, 0);
            }
        } else if (_potion_dist < 32) {
            with (_nearest_potion) {
                picked_up = true;
                show_debug_message("Picked up potion");
            }
        } else {
            show_debug_message("No items within range to pick up");
        }
    }
}

// Update position of held mushroom
with (mushroom) {
    if (variable_instance_exists(id, "picked_up") && picked_up) {
        x = other.x + (other.image_xscale * 16); // Offset to the side the player is facing
        y = other.y + 8; // Hold at waist level instead of above head
    }
}