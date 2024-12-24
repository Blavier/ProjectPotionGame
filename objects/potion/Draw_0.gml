// Draw Event of obj_potion
draw_self();
// Optional: Color the sprite with the potion color
image_blend = potion_color;

// Optional: Draw the potion name above the potion
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_text(x, y - sprite_height - 10, potion_name);
draw_set_halign(fa_left);