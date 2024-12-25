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

// Function to create an empty slot
create_empty_slot = function() {
    return {
        is_empty: true,
        type: "none",
        sprite: noone,
        data: {}
    };
}

// Initialize all slots as empty
for (var i = 0; i < 3; i++) {
    slots[i] = create_empty_slot();
}

// Function to store item info
store_item = function(_item) {
    var _slot_data = {
        is_empty: false,
        type: object_get_name(_item.object_index),
        sprite: _item.sprite_index,
        data: {}
    };
    
    // If it's a regular item, store item-specific properties
    if (_item.object_index == item) {
        _slot_data.data = {
            item_power: _item.item_power,
            rarity: _item.rarity
        };
    }
    // If it's a potion, store potion-specific properties
    else if (_item.object_index == potion) {
        _slot_data.data = {
            potion_effect: {},
            potion_power: variable_instance_exists(_item, "potion_power") ? _item.potion_power : 0
        };
        
        // Store the potion effect struct if it exists
        if (variable_instance_exists(_item, "potion_effect")) {
            var _effect = _item.potion_effect;
            var _stored_effect = _slot_data.data.potion_effect;
            
            // Copy all properties from the potion effect
            _stored_effect.size = variable_struct_exists(_effect, "size") ? _effect.size : undefined;
            _stored_effect.health = variable_struct_exists(_effect, "health") ? _effect.health : undefined;
            _stored_effect.jump_velocity = variable_struct_exists(_effect, "jump_velocity") ? _effect.jump_velocity : undefined;
            _stored_effect.speed = variable_struct_exists(_effect, "speed") ? _effect.speed : undefined;
            _stored_effect.duration = variable_struct_exists(_effect, "duration") ? _effect.duration : undefined;
            _stored_effect.position = variable_struct_exists(_effect, "position") ? _effect.position : undefined;
            _stored_effect.total_power = variable_struct_exists(_effect, "total_power") ? _effect.total_power : undefined;
        }
    }
    
    return _slot_data;
};