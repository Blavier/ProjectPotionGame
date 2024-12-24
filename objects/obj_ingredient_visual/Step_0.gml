// Make sure parent still exists
if (!instance_exists(parent_cauldron)) {
    instance_destroy();
    exit;
}

// Calculate position on ellipse
var _current_angle = parent_cauldron.angle + angle_offset;
// X position moves in an ellipse
x = parent_cauldron.x + lengthdir_x(parent_cauldron.ellipse_width, _current_angle);
// Y position is above cauldron and moves in a smaller ellipse to create depth
y = parent_cauldron.y + parent_cauldron.float_height + lengthdir_y(parent_cauldron.ellipse_height, _current_angle);

// Add scaling based on position to enhance 3D effect
var scale_variation = 0.1; // How much the scale changes
var base_scale = 0.5; // Base scale of the visual
var scale_factor = base_scale + (scale_variation * sin(_current_angle * pi/180));
image_xscale = scale_factor;
image_yscale = scale_factor;

// Add subtle bobbing motion
y += sin(current_time/800) * 2;