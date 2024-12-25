// Initialize variables
picked_up = false;
drinking = false;
drink_progress = 0;
drink_speed = 0.02;
tilt_angle = 0;
jiggle_offset = 0;
base_y_offset = 0;
effectiveness = 0;
potion_name = "";
potion_color = c_white;
potion_effect = {
    size: 1,
    position: [0, 0],
    health: 0,
    jump_velocity: 1,
    speed: 1,
    duration: 300
};

// Physics properties (matching item object)
throw_speed = 6;
xvel = 0;
yvel = 0;

// Set depth to draw above player
depth = -1000;  // Higher negative numbers are drawn on top

show_debug_message("Created potion with name: " + potion_name);