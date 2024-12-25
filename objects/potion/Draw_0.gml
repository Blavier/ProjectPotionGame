// Draw the potion
if (picked_up) {
    // Draw with drinking animation
    var _draw_x = x + jiggle_offset;
    var _draw_y = y;
    
    draw_sprite_ext(sprite_index, 0, _draw_x, _draw_y, 
        image_xscale, image_yscale, tilt_angle, c_white, 1);
	//draw liquid color
	draw_sprite_ext(sprite_index, 1, _draw_x, _draw_y, 
        image_xscale, image_yscale, tilt_angle, potion_color, 1);
} else {
    // Normal drawing
    draw_sprite_ext(sprite_index, 0, x, y, 
        image_xscale, image_yscale, 0, c_white, 1);
	//draw liquid color
	draw_sprite_ext(sprite_index, 1, x, y, 
        image_xscale, image_yscale, 0, potion_color, 1);
}