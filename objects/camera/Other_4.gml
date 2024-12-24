view_enabled = 1;
view_visible[0] = 1;

// Anti-aliasing
//display_reset(4, true);

if not instance_exists(camera_target) exit;

var _x = clamp(camera_target.x - view_width / 1, 0, room_width - view_width);
var _y = clamp(camera_target.y - view_height / 1, 0, room_height - view_height);

var _cur_x = camera_get_view_x(view);
var _cur_y = camera_get_view_y(view);

camera_set_view_pos(view, lerp(_cur_x, _x, 1), lerp(_cur_y, _y, 1));