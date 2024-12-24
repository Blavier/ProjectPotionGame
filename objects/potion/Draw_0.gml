// Draw the potion
if (picked_up) {
    // Draw with drinking animation
    var _draw_x = x + jiggle_offset;
    var _draw_y = y;
    
    draw_sprite_ext(sprite_index, image_index, _draw_x, _draw_y, 
        image_xscale, image_yscale, tilt_angle, potion_color, 1);
        
    // Draw debug info
    draw_set_color(c_yellow);
    draw_text(_draw_x, _draw_y - 20, "HELD");
} else {
    // Normal drawing
    draw_sprite_ext(sprite_index, image_index, x, y, 
        image_xscale, image_yscale, 0, potion_color, 1);
}

// Draw debug info
draw_set_color(c_white);
draw_text(x, y - 30, "Potion: " + potion_name);
draw_text(x, y - 40, "Picked up: " + string(picked_up));
