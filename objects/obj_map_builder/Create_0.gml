// Map building configuration
tile_size = 32;

// Color to object mapping
tile_map = ds_map_create();
tile_map[? make_color_rgb(0, 0, 0)] = noone;           // Empty/background
tile_map[? make_color_rgb(255, 0, 0)] = player;        // Red = Player
tile_map[? make_color_rgb(0, 255, 0)] = mushroom;      // Green = Mushroom
tile_map[? make_color_rgb(0, 0, 255)] = cauldron;      // Blue = Cauldron

// Load the map sprite
map_sprite = spr_test_map;
build_map(); 