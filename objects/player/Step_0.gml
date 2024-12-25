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

// Calculate jump velocity based on potion effect
var _current_jump = jumpvelocity;
if (variable_instance_exists(id, "active_potion_effect") && 
    active_potion_effect != undefined && 
    is_struct(active_potion_effect) &&
    variable_struct_exists(active_potion_effect, "jump_velocity") && 
    active_potion_effect.jump_velocity != undefined) {
    _current_jump *= active_potion_effect.jump_velocity;
}

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
	yvel += -0.138 * (_current_jump / jumpvelocity); // scale the jump boost
}

if (jump_input_linger) jump_input_linger --

if !jumpingstate
{
	if (jump_input_linger > 0)
	{
		if (coyote_time > 0) // on ground or was recently
		{
			yvel = _onground ? -5.3 * (_current_jump / jumpvelocity) : -4 * (_current_jump / jumpvelocity); // scale initial jump velocity
			
			timesincejumped = 0;
			
			audio_play_sound(step_dirt2, 1, 0, 1+random(0.1), 0, 1.2 + random(0.2));
								
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
    _current_speed *= active_potion_effect.speed;
}

yvel += game.world_gravity; // gravity

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
		
	if (!_onground) _inair_mod = 0.2;

	var _speed_diagonal = _current_speed * 0.707;
	if (_hor != 0 && _vertical != 0) {
	    xvel += _hor * _speed_diagonal * _inair_mod;
	} else {
	    xvel += _hor * _current_speed * _inair_mod;
	}
}

// friction
var _airdrag = 0.03;
if (_onground)
{
	var _friction = 0.18;
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
    show_debug_message("E pressed - checking for items to pick up or throw");
    var _held_item = noone;
    
    // Check if we're already holding an item or potion
    with (item) {
        if (variable_instance_exists(id, "picked_up") && picked_up) {
            _held_item = id;
        }
    }
    with (potion) {
        if (picked_up) {
            _held_item = id;
        }
    }
    
    show_debug_message("Currently held: Item=" + string(_held_item));
    
    if (_held_item != noone) {
        // Throw the item
        with (_held_item) {
            picked_up = false;
            // Calculate direction to mouse
            var _dir = point_direction(x, y, mouse_x, mouse_y);
            // Convert direction to x and y components
            xvel = lengthdir_x(throw_speed, _dir) + other.xvel;
            yvel = lengthdir_y(throw_speed, _dir) + other.yvel;
        }
        held_item = noone;
    } else {
        // Try to pick up a nearby item or potion
        var _nearest_item = instance_nearest(x, y, item);
        var _nearest_potion = instance_nearest(x, y, potion);
        
        var _item_dist = _nearest_item != noone ? distance_to_object(_nearest_item) : 999999;
        var _potion_dist = _nearest_potion != noone ? distance_to_object(_nearest_potion) : 999999;
        
        // Pick up the closest one within range
        if (_item_dist < 32 && _item_dist <= _potion_dist) {
            with (_nearest_item) {
                picked_up = true;
                xvel = 0;
                yvel = 0;
            }
            held_item = _nearest_item;
            show_debug_message("Picked up item");
        } else if (_potion_dist < 32) {
            with (_nearest_potion) {
                picked_up = true;
            }
            held_item = _nearest_potion;
            show_debug_message("Picked up potion");
        } else {
            show_debug_message("No items within range to pick up");
        }
    }
}

// Drink potion with F key
var _key_drink = keyboard_check_pressed(ord("F"));
if (_key_drink && held_item != noone) {
    if (object_get_name(held_item.object_index) == "potion") {
        with (held_item) {
            event_user(0); // Trigger the drink event
        }
    }
}

// Update position of held item
if (held_item != noone) {
    with (held_item) {
        x = other.x + (other.image_xscale * 4); // Offset to the side the player is facing
        y = other.y - 4; // Hold at waist level
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