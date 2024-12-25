// In the Create Event of obj_cauldron
ingredients = []; // Array to store ingredients
incantation = "make me fly"; // String to store the incantation
request_id = -1;
total_power = 0; // Sum of all ingredient powers

// Variables for visual ingredient indicators
ellipse_width = 32; // Width of the ellipse path
ellipse_height = 16; // Height of the ellipse path
float_height = -32; // Height above cauldron
angle = 0;  // Current angle for rotating ingredients
rotation_speed = 2; // Speed of rotation

// Function to scale effect multipliers based on power
function scale_effect_multiplier(_base_multiplier, _power) {
    var _base_power = 10; // Reference power level
    var _multiplier_component = _base_multiplier - 1; // Extract the multiplier component (e.g., 0.2 from 1.2)
    
    if (_power <= _base_power) {
        // Scale down if power is less than base
        var _power_ratio = _power / _base_power;
        return 1 + (_multiplier_component * _power_ratio);
    } else {
        // Scale up if power is greater than base
        var _power_ratio = _power / _base_power;
        return 1 + (_multiplier_component * _power_ratio);
    }
}
