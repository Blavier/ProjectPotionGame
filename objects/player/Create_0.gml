// Health variables
fullhp = 100;
hp = fullhp;

// Size and movement variables
size = 1.0;
walkvelocity = 6.0;
jumpvelocity = 1.0;
base_move_speed = 0.5;

// Velocity variables
xvel = 0;
yvel = 0;


// Platforming
footstepcreated = false;
fallingstate = 0;
jumpingstate = 0;
timesincejumped = 0;
// assist
coyote_time = 0;
jump_input_linger = 0;


// Initialize held items
held_mushroom = noone;
held_potion = noone;

// Initialize potion effect variables
active_potion_effect = undefined;
active_potion_duration = undefined;

show_debug_message("Player created - initialized all variables");
show_debug_message("Initial stats - HP: " + string(hp) + "/" + string(fullhp));
show_debug_message("Initial movement - Walk: " + string(walkvelocity) + ", Jump: " + string(jumpvelocity));
