/// @description Draw inventory GUI
// Calculate total width of inventory
var _total_width = (slot_size * 3) + (slot_padding * 2);
var _total_height = slot_size;

// Calculate starting position (centered horizontally, bottom of screen)
var _start_x = (display_get_gui_width() - _total_width) / 2;
var _start_y = display_get_gui_height() - _total_height - slot_margin;

// Draw background
draw_set_alpha(background_alpha);
draw_set_color(c_black);
draw_rectangle(_start_x - slot_padding, _start_y - slot_padding, 
              _start_x + _total_width + slot_padding, _start_y + slot_size + slot_padding, false);
draw_set_alpha(1);

// Draw slots
for (var i = 0; i < 3; i++) {
    var _slot_x = _start_x + (i * (slot_size + slot_padding));
    
    // Draw slot background
    draw_set_color(c_dkgray);
    draw_rectangle(_slot_x, _start_y, _slot_x + slot_size, _start_y + slot_size, false);
    
    // Draw slot border (highlight if selected with number keys)
    draw_set_color(keyboard_check(ord(string(i + 1))) ? c_yellow : c_white);
    draw_rectangle(_slot_x, _start_y, _slot_x + slot_size, _start_y + slot_size, true);
    
    // Draw item sprite if slot is not empty and has a valid sprite
    if (!slots[i].is_empty && slots[i].sprite != noone && sprite_exists(slots[i].sprite)) {
        var _sprite = slots[i].sprite;
        var _scale = min(slot_size / sprite_get_width(_sprite), slot_size / sprite_get_height(_sprite));
        
        // Center the sprite in the slot
        var _sprite_x = _slot_x + (slot_size - sprite_get_width(_sprite) * _scale) / 2;
        var _sprite_y = _start_y + (slot_size - sprite_get_height(_sprite) * _scale) / 2;
        
        draw_sprite_ext(_sprite, 0, _sprite_x, _sprite_y, _scale, _scale, 0, c_white, 1);
    }
}

// Reset drawing properties
draw_set_color(c_white);
draw_set_alpha(1);
