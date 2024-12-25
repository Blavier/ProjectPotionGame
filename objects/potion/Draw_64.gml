if (picked_up)
{
    
    draw_set_halign(fa_center);
    var _stats_x = (camera.view_width*camera.window_scale)/2;  // Since camera follows player, this will be center of screen
    var _stats_y = 100;  // Move down from player position
    var _line_height = 15;
    
    // Draw name and stats
	draw_set_color(potion_color);
    draw_text(_stats_x, _stats_y, potion_name);
    _stats_y += _line_height;
    
	draw_set_color(c_white);
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
