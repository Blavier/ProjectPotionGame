// Draw the player sprite
y += 1;
draw_self();
y -= 1;

// Draw debug stats
draw_set_font(-1); // Default font
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

var stats_x = 10;
var stats_y = 10;
var line_height = 20;
var current_line = 0;

// Draw base stats
draw_text(stats_x, stats_y + (line_height * current_line++), "Player Stats:");
draw_text(stats_x, stats_y + (line_height * current_line++), "HP: " + string(hp) + "/" + string(fullhp));
draw_text(stats_x, stats_y + (line_height * current_line++), "Size: " + string(size));
draw_text(stats_x, stats_y + (line_height * current_line++), "Jump Velocity: " + string(jumpvelocity));
draw_text(stats_x, stats_y + (line_height * current_line++), "Current Velocity: " + string(xvel) + ", " + string(yvel));
draw_text(stats_x, stats_y + (line_height * current_line++), "Base Move Speed: " + string(base_move_speed));
draw_text(stats_x, stats_y + (line_height * current_line++), "Scale: " + string(image_xscale) + " x " + string(image_yscale));
draw_text(stats_x, stats_y + (line_height * current_line++), "Position: " + string(x) + ", " + string(y));

// Draw active potion effects if they exist
if (variable_instance_exists(id, "active_potion_effect") && 
    active_potion_effect != undefined && 
    is_struct(active_potion_effect)) {
    
    draw_text(stats_x, stats_y + (line_height * current_line++), "Active Potion Effects:");
    
    if (variable_instance_exists(id, "active_potion_duration") && active_potion_duration != undefined) {
        draw_text(stats_x, stats_y + (line_height * current_line++), "- Duration: " + string(active_potion_duration));
    }
    
    // Only try to access struct members if we have a valid struct
    var effect = active_potion_effect;
    
    if (variable_struct_exists(effect, "speed") && effect.speed != undefined) {
        draw_text(stats_x, stats_y + (line_height * current_line++), "- Speed Modifier: " + string(effect.speed));
    }
    
    if (variable_struct_exists(effect, "jump_velocity") && effect.jump_velocity != undefined) {
        draw_text(stats_x, stats_y + (line_height * current_line++), "- Jump Velocity Modifier: " + string(effect.jump_velocity));
    }
    
    if (variable_struct_exists(effect, "size") && effect.size != undefined) {
        draw_text(stats_x, stats_y + (line_height * current_line++), "- Size Modifier: " + string(effect.size));
    }
    
    if (variable_struct_exists(effect, "health") && effect.health != undefined) {
        draw_text(stats_x, stats_y + (line_height * current_line++), "- Health Modifier: " + string(effect.health));
    }
    
    if (variable_struct_exists(effect, "position") && 
        effect.position != undefined && 
        is_array(effect.position) && 
        array_length(effect.position) >= 2) {
        draw_text(stats_x, stats_y + (line_height * current_line++), "- Position Offset: " + 
            string(effect.position[0]) + ", " + 
            string(effect.position[1]));
    }
} else {
    draw_text(stats_x, stats_y + (line_height * current_line++), "No Active Potion Effects");
}

// Reset draw properties
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);