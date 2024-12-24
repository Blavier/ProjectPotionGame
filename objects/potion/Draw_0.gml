// Draw the potion
if (picked_up) {
    // Draw with drinking animation
    var _draw_x = x + jiggle_offset;
    var _draw_y = y;
    
    draw_sprite_ext(sprite_index, image_index, _draw_x, _draw_y, 
        image_xscale, image_yscale, tilt_angle, potion_color, 1);
} else {
    // Normal drawing
    draw_sprite_ext(sprite_index, image_index, x, y, 
        image_xscale, image_yscale, 0, potion_color, 1);
}

// Show potion stats when 'i' is pressed
if (keyboard_check(ord("I"))) {
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    var _stats_x = x;  // Since camera follows player, this will be center of screen
    var _stats_y = y + 80;  // Move down from player position
    var _line_height = 15;
    
    // Draw name and stats
    draw_text(_stats_x, _stats_y, "Name: " + potion_name);
    _stats_y += _line_height;
    
    // Draw effects if they exist
    if (is_struct(potion_effect)) {
        if (potion_effect.size != 1.0) draw_text(_stats_x, _stats_y, "Size: x" + string(potion_effect.size));
        _stats_y += _line_height;
        
        if (potion_effect.speed != 0) draw_text(_stats_x, _stats_y, "Speed: " + string(potion_effect.speed));
        _stats_y += _line_height;
        
        if (potion_effect.jump_velocity != 1.0) draw_text(_stats_x, _stats_y, "Jump: x" + string(potion_effect.jump_velocity));
        _stats_y += _line_height;
        
        if (potion_effect.health != 0) draw_text(_stats_x, _stats_y, "Health: " + string(potion_effect.health));
        _stats_y += _line_height;
        
        draw_text(_stats_x, _stats_y, "Duration: " + string(potion_effect.duration));
    }
    
    // Reset text alignment
    draw_set_halign(fa_left);
}
