if (picked_up)
{
	
	
	return;
}

var _onground = false
var _grid_collidable = game.grid_collidable

yvel += game.world_gravity;

if (grid_place_meeting_pos(x, y + 1, _grid_collidable))
{
	_onground = true
}

// friction
var _airdrag = 0.025;
if (_onground)
{
	var _friction = 0.08;
	xvel *= (1.00 - _friction - _airdrag);
	yvel *= (1.00 - _friction - _airdrag);
}
else
{
	xvel *= (1.00 - _airdrag);
	yvel *= (1.00 - _airdrag);
}
		

// move obj
var _nx = x + xvel// * game.gamespeed;
var _ny = y + yvel// * game.gamespeed;

// collision
if (xvel != 0) {
	if (!grid_place_meeting_pos(_nx, y, _grid_collidable)) {
		x = _nx;
	} else {
		while (!grid_place_meeting_pos(sign(xvel) + x, y, _grid_collidable)) {
			x += sign(xvel);
		}
		xvel = 0;
	}
}
	
if (yvel != 0) {
	if (!grid_place_meeting_pos(x, _ny, _grid_collidable)) {
		y = _ny;
	} else {
		while (!grid_place_meeting_pos(x, sign(yvel) + y, _grid_collidable)) {
			y += sign(yvel);
		}
		yvel = 0;
	}
}
	
// clamp position to room
x = clamp(x, 0, room_width);
y = clamp(y, 0, room_height);