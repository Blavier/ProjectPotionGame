if (keyboard_check_released(vk_escape) && !keyboard_check(vk_lcontrol)) game_end();

if (keyboard_check_pressed(ord("R")) && !instance_exists(incantation_box)) room_restart();