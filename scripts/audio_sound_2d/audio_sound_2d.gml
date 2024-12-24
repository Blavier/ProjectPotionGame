/// play_sound_world(_id, _x, _y, _max_dist, _falloff_rate, _full_volume_radius)
/// @param _id Sound ID
/// @param _x Sound source X coordinate
/// @param _y Sound source Y coordinate
/// @param _max_dist Maximum distance for sound falloff
/// @param _falloff_rate Rate of sound falloff
/// @param _full_volume_radius Radius within which sound plays at full volume
/// @param _pitch_variation Amount to randomly vary pitch 0, 0.1, 0.2
/// @param _volume_variation Amount to randomly vary volume 0, 0.1, 0.2
function play_sound_world(_id, _x, _y, _max_dist, _falloff_rate, _full_volume_radius, _pitch_variation, _volume_variation) {
    panning_divisor = 500;
	min_sound_threshold = 0.01;
	min_pitch = 0.01;
	pitch_with_distance = -0.1;

	if (!instance_exists(spr_player)) return;

    var _dist = point_distance(_x, _y, spr_player.x, spr_player.y);
    var _volume = 1 - _volume_variation;

	if (_dist < _full_volume_radius) {
	    _volume = (1 - _volume_variation);
	} else if (_dist < _max_dist) {
		// inverse square law
	    _volume = (1 - _volume_variation) / ((_dist / _full_volume_radius) * (_dist / _full_volume_radius));
	} else {
	    // over the maximum distance, no sound
		return;
	}

    var _pos_x = (_x - spr_player.x) / panning_divisor / 10; // amount of panning
    var _pos_y = (_y - spr_player.y) / panning_divisor;
	
	var _rnd_volume	= max(random_volume(_volume, _volume_variation), min_sound_threshold);
	var _rnd_pitch = max(random_pitch(game.gamespeed, _pitch_variation) + (pitch_with_distance * (_dist / _max_dist)), min_pitch);

    audio_play_sound_at(_id, -_pos_x, _pos_y, 0, false, 1, 1, 0, 1, _rnd_volume, 0, _rnd_pitch);
	
  
	if (global.debug_mode) { // DEBUG
		var _info_name = audio_get_name(_id);
		
	    var _show_detailed_info = true;
	    var _debug_x = _pos_x + _x;
	    var _debug_y = _pos_y + _y;

	    with (obj_debug_audio) {
	        if (info_name != "Na" && info_name != _info_name && distance_to_point(_debug_x, _debug_y) < 100) {
				_show_detailed_info = false;
	        }
	    }

	    var _debug_instance = instance_create_depth(_debug_x, _debug_y, 0, obj_debug_audio);
	    if (_show_detailed_info) {
	        _debug_instance.info_name = _info_name;
	        _debug_instance.info_volume = _rnd_volume;
	        _debug_instance.info_pitch = _rnd_pitch;
	    }
	}
}

function play_grid_world_debug(_id, _x, _y) {
	
	var _gridSize = 28;
	var _spacing = 40;
	
    var halfGrid = floor(_gridSize / 2);
    for (var i = -halfGrid; i <= halfGrid; i++) {
        for (var j = -halfGrid; j <= halfGrid; j++) {
            // Calculate the position for this point in the grid
            var soundX = _x + i * _spacing;
            var soundY = _y + j * _spacing;

            // Play the sound at this position
			play_sound_world(_id, soundX, soundY,
			400,	// max distance
			1,		// falloff rate
			90,		// full vol radius
			0.0,	// pitch variation
			0.0);	// vol variation
        }
    }
}

function play_sound_world_doppler(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7) {
    var _id = argument0;
    var _x = argument1;
    var _y = argument2;
	var _x_previous = argument3;
    var _y_previous = argument4;
    var _max_dist = argument5;
    var _falloff_rate = argument6;
    var _full_volume_radius = argument7;

    if (!instance_exists(spr_player)) {
        return; // Exit
    }

    var _dist = point_distance(_x, _y, spr_player.x, spr_player.y);
    var _volume = 1;

    if (_dist > _full_volume_radius) {
        var _adjusted_dist = _dist - _full_volume_radius;
        _volume = calculate_falloff_volume(_adjusted_dist, _max_dist, _falloff_rate, _full_volume_radius);
    }

    var _pos_x = (_x - spr_player.x) / 12; // amount of panning
    var _pos_y = (_y - spr_player.y);
	
	var _doppler_pitch = calculate_doppler_pitch(_x, _y, _x_previous, _y_previous, spr_player.x, spr_player.y, game.gamespeed);
	
    audio_play_sound_at(_id, -_pos_x, _pos_y, 0, false, 1, 1, 0, 1, _volume, 0, _doppler_pitch);
    if (global.debug_mode) {
        instance_create_depth(_x + _pos_x, _y + _pos_y, 0, obj_debugpointer);
    }
}

/// calculate_falloff_volume(_dist, _max_dist, _falloff_rate, _full_volume_radius)
/// @param _dist Adjusted distance from sound source
/// @param _max_dist Maximum distance for sound falloff
/// @param _falloff_rate Rate of sound falloff
/// @param _full_volume_radius Radius of full volume
function calculate_falloff_volume(_dist, _max_dist, _falloff_rate, _full_volume_radius) {
    return exp(-_dist / (_max_dist - _full_volume_radius) * _falloff_rate);
}

/// random_pitch(_gamespeed, _amount)
/// @param _gamespeed Game's speed factor
/// @param _amount Amount of variation 0, 0.1, 0.2
function random_pitch(_gamespeed, _amount) {
    return random_range(1.0 - _amount, 1.0 + _amount) * _gamespeed;
}

/// random_volume(_volume, _amount)
/// @param _volume Volume
/// @param _amount Amount of variation 0, 0.1, 0.2
function random_volume(_volume, _amount) {
    return random_range(-_amount, _amount) + _volume;
}

function calculate_doppler_pitch(_x, _y, _x_previous, _y_previous, player_x, player_y, gamespeed) {
    // Constants for the Doppler effect
    var speedOfSound = 343; // Speed of sound in m/s (you might need to adjust this based on your game's scale) def 343
    var dopplerFactor = 1.0; // Adjust this to amplify or reduce the Doppler effect

    // Calculate velocity of the sound source
    var source_velocity_x = (_x - _x_previous) * gamespeed;
    var source_velocity_y = (_y - _y_previous) * gamespeed;

    // Calculate velocity of the listener (player)
    var listener_velocity_x = (player_x - spr_player.xprevious) * gamespeed;
    var listener_velocity_y = (player_y - spr_player.yprevious) * gamespeed;

    // Calculate the change in frequency using the Doppler effect formula
    var relative_velocity_x = listener_velocity_x - source_velocity_x;
    var relative_velocity_y = listener_velocity_y - source_velocity_y;

    var relative_velocity = sqrt(relative_velocity_x * relative_velocity_x + relative_velocity_y * relative_velocity_y);

    var doppler_shift = dopplerFactor * (speedOfSound / (speedOfSound + relative_velocity));
    return doppler_shift;
}