randomize(); // random seed

gametime = 0;
world_gravity = 0.25;

// Tile System
#macro CELL_WIDTH 16
#macro CELL_HEIGHT 16

#macro WALL 1
#macro AIR 0

// grids
grid_width = room_width div CELL_WIDTH;
grid_height = room_height div CELL_HEIGHT;

tilemap = layer_tilemap_get_id(layer_get_id("Tiles"));
grid_collidable = ds_grid_create(grid_width, grid_height);

ds_grid_set_region(grid_collidable, 0, 0, grid_width - 1, grid_height - 1, AIR);

for (var _y = 0; _y < grid_height; _y++) {
	for (var _x = 0; _x < grid_width; _x++) {		
		var _data = tilemap_get_at_pixel(tilemap, _x*CELL_WIDTH,_y*CELL_HEIGHT) & tile_index_mask;
		if _data != 0 {
			grid_collidable[# _x, _y] = WALL;
		}
	}
}