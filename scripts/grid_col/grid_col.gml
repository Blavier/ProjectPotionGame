function grid_place_meeting_multilayer(argument0, argument1, argument2, argument3) {
	var _obj = argument0;
	var _grid_ground = argument1;
	var _grid_middle = argument2;
	var _grid_top = argument3;

	return (grid_place_meeting(_obj, _grid_ground) || grid_place_meeting(_obj, _grid_middle) || grid_place_meeting(_obj, _grid_top));
}

function grid_place_meeting(argument0, argument1) {
	var _object = argument0;
	var _grid = argument1;

	var _top_right = _grid[# (_object.bbox_right-1) div CELL_WIDTH, _object.bbox_top div CELL_HEIGHT] >= WALL;
	var _top_left = _grid[# _object.bbox_left div CELL_WIDTH, _object.bbox_top div CELL_HEIGHT] >= WALL;
	var _bottom_right = _grid[# (_object.bbox_right-1) div CELL_WIDTH, (_object.bbox_bottom-1) div CELL_HEIGHT] >= WALL;
	var _bottom_left = _grid[# _object.bbox_left div CELL_WIDTH, (_object.bbox_bottom-1) div CELL_HEIGHT] >= WALL;

	return _top_right || _top_left || _bottom_right || _bottom_left;
}

function grid_place_meeting_type(argument0, argument1, argument2) {
	var _object = argument0;
	var _grid = argument1;
	var _type = argument2;

	var _top_right = _grid[# (_object.bbox_right-1) div CELL_WIDTH, _object.bbox_top div CELL_HEIGHT] == _type;
	var _top_left = _grid[# _object.bbox_left div CELL_WIDTH, _object.bbox_top div CELL_HEIGHT] == _type;
	var _bottom_right = _grid[# (_object.bbox_right-1) div CELL_WIDTH, (_object.bbox_bottom-1) div CELL_HEIGHT] == _type;
	var _bottom_left = _grid[# _object.bbox_left div CELL_WIDTH, (_object.bbox_bottom-1) div CELL_HEIGHT] == _type;

	return _top_right || _top_left || _bottom_right || _bottom_left;
}

function grid_place_meeting_pos(argument0, argument1, argument2) {
	var _x = argument0;
	var _y = argument1;
	var _grid = argument2;


	var _collides = _grid[# _x div CELL_WIDTH, _y div CELL_HEIGHT] >= WALL;

	return _collides;
}

function grid_place_meeting_pos_type(argument0, argument1, argument2, argument3) {
	var _x = argument0;
	var _y = argument1;
	var _grid = argument2;
	var _type = argument3;


	var _collides = _grid[# _x div CELL_WIDTH, _y div CELL_HEIGHT] == _type;

	return _collides;
}
