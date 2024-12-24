/// @description Insert description here
// You can write your code in this editor

show_debug_message("Creating incantation box...");

// Initialize text input variables
text = "";
max_length = 50;
active = true;
alpha = 1;
fade_speed = 0.05;

// Reference to parent cauldron
parent_cauldron = noone;

// Position relative to cauldron
y_offset = -64; // Above the cauldron

// Keyboard check cooldown
keyboard_cooldown = 0;
keyboard_cooldown_max = 5;

// Clear keyboard string when created
keyboard_string = "";

// Set depth to draw above other objects
depth = -1000;

show_debug_message("Incantation box created at position: " + string(x) + ", " + string(y));
