// Check if incantation box is active
var _can_move = !instance_exists(incantation_box) || !incantation_box.active;

var _key_left = _can_move ? keyboard_check(ord("A")) : false;
var _key_right = _can_move ? keyboard_check(ord("D")) : false;
var _key_up = _can_move ? keyboard_check(ord("W")) : false;
var _key_up_pressed = _can_move ? keyboard_check_pressed(ord("W")) : false;
var _key_down = _can_move ? keyboard_check(ord("S")) : false;
var _key_action = keyboard_check(vk_space);
var _key_pickup = keyboard_check_pressed(ord("E"));
var _key_left_mouse = mouse_check_button(mb_left)
var _key_left_mouse_pressed = mouse_check_button_pressed(mb_left)
var _key_right_mouse = mouse_check_button(mb_right)
var _key_right_mouse_pressed = mouse_check_button_pressed(mb_right)

var _onground = false
var _grid_collidable = game.grid_collidable

if (grid_place_meeting_pos(x, y + 1, _grid_collidable))
{
	_onground = true
	coyote_time = 6
}
else if (coyote_time > 0) coyote_time --;

if (_key_up_pressed) jump_input_linger = 6

if (_key_up && jumpingstate && yvel < 0.5 && timesincejumped < 24)
{
	yvel += -0.138 // jump
}

if (jump_input_linger) jump_input_linger --

if !jumpingstate
{
	if (jump_input_linger > 0)
	{
		if (coyote_time > 0) // on ground or was recently
		{
			yvel = _onground ? -5.3 : -4; // jump
			
			timesincejumped = 0;
			
			audio_play_sound(jump, 1, 0, 1+random(0.1), 0, 0.9 + random(0.2));
								
			jump_input_linger = 0;
			coyote_time = 0;
			fallingstate = 0;
			jumpingstate = 1;
		}
	}
}

timesincejumped ++;

if (jumpingstate || fallingstate)
{
	if (yvel > -1)
	{
		if (_onground)
		{
			jumpingstate = 0;
			fallingstate = 0;
		
			audio_play_sound(land, 1, 0, 1+random(0.1), 0, 0.9 + random(0.2));
		}
	}
}

if (yvel > 0)
{
	if (!_onground)
	{
		fallingstate = 1;	
	}
}

var _facing_right = 0;
var _facing_left = 0;
var _facing_up = 0;
var _facing_down = 0;

if (keyboard_check(vk_right))
{
	_facing_right = 1
	_facing_left = 0
}
else if (keyboard_check(vk_left))
{
	_facing_right = 0
	_facing_left = 1
}

if (_facing_right)
{
	image_xscale = 1;	
}
else if (_facing_left)
{
	image_xscale = -1;	
}
else if (_onground)
{
	// walking turning
	if (_key_left)
	{
		image_xscale = -1;	
	}
	else if (_key_right) {
		image_xscale = 1;	
	}
}


// Calculate movement speed based on potion effect
var _current_speed = base_move_speed;
if (variable_instance_exists(id, "active_potion_effect") && 
    active_potion_effect != undefined && 
    is_struct(active_potion_effect) &&
    variable_struct_exists(active_potion_effect, "speed") && 
    active_potion_effect.speed != undefined) {
    _current_speed *= (1 + active_potion_effect.speed);
}



yvel += 0.25; // gravity

if (grid_place_meeting_pos(x, y + 1, _grid_collidable))
{
	_onground = true;
}
	
var _hor = (_key_right - _key_left);
var _vertical = (_key_down - _key_up);

if (-1 > 0) { // for locking movement change this
	_hor = 0;
	_vertical = 0;
}
else
{
	var _inair_mod = 1.0;
		
	if (!_onground) _inair_mod = 0.25;

	var _speed_diagonal = _current_speed * 0.707;
	if (_hor != 0 && _vertical != 0) {
	    xvel += _hor * _speed_diagonal * _inair_mod;
	} else {
	    xvel += _hor * _current_speed * _inair_mod;
	}
}

// friction
var _airdrag = 0.025;
if (_onground)
{
	var _friction = 0.08;
	xvel *= (1.00 - _friction - _airdrag);
	yvel *= (1.00 - _friction - _airdrag);
}
else
{
	xvel *= (1.00 - _airdrag);
	yvel *= (1.00 - _airdrag);
}
		

// move obj
var _nx = x + xvel// * game.gamespeed;
var _ny = y + yvel// * game.gamespeed;

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



//// SPRITE

var _start_frame = 0;
var _anim_length = 0;
var _anim_speed = 0;

switch (anim)
{
	case anim_idle:
		_start_frame	= 0;
		_anim_length	= 1;
		_anim_speed		= 0;
	break;
		
	case anim_run:
		_start_frame	= 0;
		_anim_length	= 4;
		_anim_speed		= 8;
	break;
	
	case anim_jump:
		_start_frame	= 5;
		_anim_length	= 1;
		_anim_speed		= 0;
	break;
	
	case anim_fall:
		_start_frame	= 7;
		_anim_length	= 1;
		_anim_speed		= 0;
	break;
}

anim_current_frame = floor(anim_tick / _anim_speed);

if (anim == anim_run)
{
	var _current_frame = image_index;
	if ((anim_current_frame == 3 || anim_current_frame == 1) && !footstepcreated && _onground)
	{
		footstepcreated = true;
		
		audio_play_sound(choose(step_dirt, step_dirt2, step_dirt3),
								1, 0, 0.2+random(0.1), 0, 0.9 + (anim_current_frame-1)/10 + random(0.1));
		{
			// particle
		}
	}
	
	if (anim_current_frame == 2 || anim_current_frame == 0)
	{
		footstepcreated = false;
	}
}

if (jumpingstate) 
{
	anim = anim_jump;
			
	if (yvel > 1) {
		anim_frame = 0;
	}
	else if yvel < 0 {
		anim_frame = 2;
	}
	else
	{
		anim_frame = 1;
	}
}
else if (fallingstate)
{
	anim = anim_fall;
}
else
{
	if (_key_left || _key_right)
	{
		anim = anim_run;
	}
	else
	{
		anim = anim_idle;
	}
}

if (anim != old_anim)
{
	anim_frame = 0;
	anim_tick = 0;
	old_anim = anim;
}

//sprite_index = anim_index;
if (_anim_speed > 0) image_index = _start_frame + floor(anim_tick / _anim_speed);
else image_index = _start_frame + anim_frame;

if (image_index > _start_frame + _anim_length - 1)
{
	anim_tick = 0;
	image_index = min(image_index, _start_frame + (_anim_length - 1)); // dont go over
}
anim_tick ++;