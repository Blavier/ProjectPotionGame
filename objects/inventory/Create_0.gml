// Initialize inventory slots (array of item info structs)
slots = array_create(3, noone);

// UI properties
slot_size = 32;  // Size of each inventory slot
slot_padding = 4;  // Padding between slots
slot_margin = 10;  // Margin from screen edge
background_alpha = 0.7;  // Alpha for the background

// Reference to player
player_ref = noone;

// Set depth to draw on top
depth = -10000;

// Function to store item info
store_item = function(_item) {
    return {
        sprite: _item.sprite_index,
        item_power: _item.item_power,
        rarity: _item.rarity,
        item_type: object_get_name(_item.object_index)
    };
};