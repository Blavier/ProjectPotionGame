// Set text properties
draw_set_alpha(alpha);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Draw text box background
var _padding = 10;
var _width = max(200, string_width(text) + _padding * 2);
var _height = string_height("M") + _padding;

// Draw black background
draw_set_color(c_black);
draw_rectangle(x - _width/2, y - _height/2, x + _width/2, y + _height/2, false);

// Draw white border
draw_set_color(c_white);
draw_rectangle(x - _width/2, y - _height/2, x + _width/2, y + _height/2, true);

// Draw text with cursor
draw_set_color(c_white);
draw_text(x, y, text + (active ? "|" : "")); // Add cursor when active

// Reset drawing properties
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white); 