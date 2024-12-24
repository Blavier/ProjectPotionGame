// In the Step Event of obj_cauldron
if (keyboard_check_pressed(vk_space)) { // Or whatever trigger you want to use
    // Create the request body
    var _body = {
        ingredients: ingredients,
        incantation: incantation
    };

    // Convert the body to JSON string
    var _json_body = json_stringify(_body);

    // Create header map
    var _headers = ds_map_create();
    ds_map_add(_headers, "Content-Type", "application/json");

    // Send the request
    request_id = http_request("http://localhost:5000/chat", "POST", _headers, _json_body);

    // Clean up the header map as it's no longer needed
    ds_map_destroy(_headers);
}

// decode json
/*
var _potion = instance_create_depth(x, y, 0, potion)
	_potion.effect_size = 123
	_potion.effect_position = 654
	_potion.effect_health = 4562