function build_map() {
    var _width = sprite_get_width(map_sprite);
    var _height = sprite_get_height(map_sprite);
    
    // Create surface to read pixel data
    var _surf = surface_create(_width, _height);
    surface_set_target(_surf);
    draw_sprite(map_sprite, 0, 0, 0);
    surface_reset_target();
    
    // Buffer to read pixel data
    var _buffer = buffer_create(_width * _height * 4, buffer_fixed, 1);
    buffer_get_surface(_buffer, _surf, 0);
    
    // Read pixels and create objects
    for (var _y = 0; _y < _height; _y++) {
        for (var _x = 0; _x < _width; _x++) {
            var _pos = (_y * _width + _x) * 4;
            
            // Read RGB values
            var _r = buffer_peek(_buffer, _pos, buffer_u8);
            var _g = buffer_peek(_buffer, _pos + 1, buffer_u8);
            var _b = buffer_peek(_buffer, _pos + 2, buffer_u8);
            
            var _color = make_color_rgb(_r, _g, _b);
            var _obj = tile_map[? _color];
            
            if (_obj != noone) {
                instance_create_layer(_x * tile_size, _y * tile_size, "Instances", _obj);
            }
        }
    }
    
    // Cleanup
    buffer_delete(_buffer);
    surface_free(_surf);
} 