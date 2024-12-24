// Draw Event of obj_potion
draw_self();

// Optional: Color the sprite with the potion color
image_blend = potion_color;

// Optional: Draw the potion name above the potion
draw_set_color(potion_color);
draw_set_halign(fa_center);
draw_text(x, y - sprite_height - 10, potion_name);


// Display all potion effects
draw_set_color(c_white); // Set text color to the potion color
var effects_text = "Potion Effects:\n";
var effect_keys = variable_struct_get_names(potion_effect);

for (var i = 0; i < array_length(effect_keys); i++) {
    var key = effect_keys[i];
    var value = potion_effect[$ key]; // Dynamically access struct fields
    effects_text += string(key) + ": " + string(value) + "\n";
}

// Draw the effects text
var x_offset = 10;
var y_offset = 10;
draw_text(x + x_offset, y + y_offset, effects_text);

// Reset the draw color to white
draw_set_color(c_white);

// Save the original color and angle
var _original_color = draw_get_color();
draw_set_color(potion_color);

// Draw the potion with animation if being drunk
if (drinking) {
    // Apply tilt and jiggle to position
    var _draw_x = x + jiggle_offset;
    var _draw_y = y;
    
    // Draw the potion tilted
    draw_sprite_ext(sprite_index, image_index, _draw_x, _draw_y, 
        image_xscale, image_yscale, tilt_angle, potion_color, image_alpha);
} else {
    // Normal drawing
    draw_sprite_ext(sprite_index, image_index, x, y, 
        image_xscale, image_yscale, 0, potion_color, image_alpha);
}

// Reset color
draw_set_color(_original_color);
