// Health variables
fullhp = 100;
hp = fullhp;

// Size and movement variables
size = 1.0;
jumpvelocity = 0.9;
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
held_item = noone;

// Create inventory if it doesn't exist
if (!instance_exists(inventory)) {
    instance_create_layer(0, 0, "Instances", inventory);
}

// Initialize potion effect variables
active_potion_effect = undefined;
active_potion_duration = undefined;

show_debug_message("Player created - initialized all variables");
show_debug_message("Initial stats - HP: " + string(hp) + "/" + string(fullhp));

// SPRITE / ANIMATION
image_speed = 0;

sprite_index = spr_player;
anim = anim_idle;
old_anim = anim_idle;
anim_tick = 0; // every tick of animation
anim_frame = 0; // useful when the animation has no speed
anim_current_frame = 0; // frame in the scope of the current anim