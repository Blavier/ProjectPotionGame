var _key_left = keyboard_check(ord("A"));
var _key_right = keyboard_check(ord("D"));
var _key_up = keyboard_check(ord("W"));
var _key_down = keyboard_check(ord("S"));
var _key_action = keyboard_check(vk_space);
var _key_left_mouse = mouse_check_button(mb_left)
var _key_left_mouse_pressed = mouse_check_button_pressed(mb_left)
var _key_right_mouse = mouse_check_button(mb_right)
var _key_right_mouse_pressed = mouse_check_button_pressed(mb_right)

if keyboard_check_pressed(ord("W"))
{
	
}
if keyboard_check_pressed(ord("S"))
{
	
}

var _hor = (_key_right - _key_left);
var _vertical = (_key_down - _key_up);

_hor = 0;
_vertical = 0;

var _speed_diagonal = walkvelocity * 0.707;

if (_hor != 0 && _vertical != 0) {
	xvel += _hor * _speed_diagonal;
	yvel += _vertical * _speed_diagonal;
} else {
	xvel += _hor * walkvelocity;
	yvel += _vertical * walkvelocity;
}

// friction

xvel *= (1.00 - 0.01);
yvel *= (1.00 - 0.01);


x += xvel
y += yvel