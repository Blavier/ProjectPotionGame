// 640 by 360, 16:9

view_width = 640;
view_height = 360;

#macro view view_camera[0]

base_view_width = view_width;
base_view_height = view_height;

window_scale = 2; //3

window_set_fullscreen(false);

screen_shake = 0;
zoom_out = 0;

camera_target = player;

//display_reset(0, true) // for screen tearing / pixel perfect

window_set_size(view_width * window_scale, view_height * window_scale);
alarm[0] = 1;

surface_resize(application_surface, view_width * window_scale, view_height * window_scale);