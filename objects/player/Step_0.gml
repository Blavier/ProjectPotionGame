var _key_left = keyboard_check(ord("A"));
var _key_right = keyboard_check(ord("D"));
var _key_up = keyboard_check(ord("W"));
var _key_down = keyboard_check(ord("S"));
var _key_action = keyboard_check(vk_space);
var _key_left_mouse = mouse_check_button(mb_left)
var _key_left_mouse_pressed = mouse_check_button_pressed(mb_left)
var _key_right_mouse = mouse_check_button(mb_right)
var _key_right_mouse_pressed = mouse_check_button_pressed(mb_right)

if _key_left
{
	xvel -= 0.5;
}
if _key_right
{
	xvel += 0.5;
}

xvel *= 0.91;
yvel *= 0.91;

x += xvel
y += yvel