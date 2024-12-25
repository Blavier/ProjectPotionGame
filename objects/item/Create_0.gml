// Basic physics variables
picked_up = false;
throw_speed = 15;
xvel = 0;
yvel = 0;
grav = 0;

// Common items list (mushroom only)
var common_sprites = [spr_mushroom];
var common_names = ["mushroom"];

// Epic items list (pouch of coins)
var epic_sprites = [spr_pouch_of_coins];
var epic_names = ["pouch_of_coins"];

// Randomly decide if this will be an epic item (pouch) or common item (mushroom)
var is_epic = true //random(100) < 5;  // 5% chance for epic item

if (is_epic) {
    // Epic item (pouch of coins)
    sprite_index = epic_sprites[0];
    item_name = epic_names[0];
    item_power = 1000;  // Epic power level
    rarity = "epic";
} else {
    // Common item (mushroom)
    sprite_index = common_sprites[0];
    item_name = common_names[0];
    item_power = 1;  // Common power level
    rarity = "common";
}