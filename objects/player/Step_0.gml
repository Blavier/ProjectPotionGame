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

if _key_left
{
	xvel -= 0.5;
	image_xscale = -abs(image_xscale); // Face left
}
if _key_right
{
	xvel += 0.5;
	image_xscale = abs(image_xscale); // Face right
}

xvel *= 0.91;
yvel *= 0.91;

x += xvel
y += yvel

// Pickup/throw logic
if (_key_pickup) {
	var _held_mushroom = noone;
	
	// Check if we're already holding a mushroom
	with (mushroom) {
		if (variable_instance_exists(id, "picked_up") && picked_up) {
			_held_mushroom = id;
		}
	}
	
	if (_held_mushroom != noone) {
		// Throw the held mushroom
		with (_held_mushroom) {
			picked_up = false;
			// Calculate direction to mouse
			var _dir = point_direction(x, y, mouse_x, mouse_y);
			// Convert direction to x and y components
			xvel = lengthdir_x(throw_speed, _dir);
			yvel = lengthdir_y(throw_speed, _dir);
		}
	} else {
		// Try to pick up a nearby mushroom
		var _nearest = instance_nearest(x, y, mushroom);
		if (_nearest != noone && distance_to_object(_nearest) < 32) {
			with (_nearest) {
				if (!variable_instance_exists(id, "picked_up")) {
					picked_up = false;
					throw_speed = 15;
					xvel = 0;
					yvel = 0;
				}
				picked_up = true;
			}
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