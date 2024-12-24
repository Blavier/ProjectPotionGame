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
