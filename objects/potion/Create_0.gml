// Create Event of obj_potion
effectiveness = 0;
potion_name = "";
potion_color = c_white;
potion_effect = {
    size: 1.0,
    position: [0, 0],
    health: 0,
    jump_velocity: 1.0,
    speed: 0,
    duration: 0
};

// Pickup and interaction variables
picked_up = false;
drinking = false;
drink_progress = 0;
drink_speed = 0.02;  // How fast to animate the drinking
tilt_angle = 0;      // Current tilt of the potion
jiggle_offset = 0;   // Side-to-side jiggle
base_y_offset = 0;   // Base vertical offset when held

show_debug_message("Created potion with name: " + potion_name);