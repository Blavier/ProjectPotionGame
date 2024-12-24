// Helper function to convert hex to decimal (add this in a Script resource)
function hex_to_dec(_hex_string) {
    var _dec = 0;
    var _digit = "";
    var _len = string_length(_hex_string);
    
    for(var i = 1; i <= _len; i++) {
        _digit = string_char_at(_hex_string, i);
        switch(_digit) {
            case "A": case "a": _digit = "10"; break;
            case "B": case "b": _digit = "11"; break;
            case "C": case "c": _digit = "12"; break;
            case "D": case "d": _digit = "13"; break;
            case "E": case "e": _digit = "14"; break;
            case "F": case "f": _digit = "15"; break;
        }
        _dec = _dec * 16 + real(_digit);
    }
    return _dec;
}