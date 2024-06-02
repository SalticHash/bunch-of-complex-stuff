
// Returns a positive number else -1.0
function string_to_number(argument0) {
    var s = argument0;
    var digits = string_digits(s)
    var len = string_length(digits);
    if (len > 0 && len == string_length(s)) {
        return real(digits);
    }
    return -1;
}

// Does an operation step by step starting with 0
// example: op=,+1,-4,*5,
// real (1 - 4) * 5
function evaluate(argument0) {
    var operation = string_delete(argument0, 1, 4)
    var len = string_length(operation)
    var result = 0
    var section = ""
    for (var i = 1; i <= len; i++) {
        if (string_char_at(operation, i) != ",") {
            section += string_char_at(operation, i)
        } else {
            var operator = string_char_at(section, 1)
            var v = string_delete(section, 1, 1)
            var number = global.string_to_number(v)
            if (number == -1 && variable_global_exists(v))
                number = variable_global_get(v)
            if (operator == "+")
                result += number
            if (operator == "-")
                result -= number
            if (operator == "*")
                result *= number
            if (operator == "/")
                result /= number
            section = ""
        }
    }
    return result
}

// Parses a value, and if a global called that exists it returns its value
// Returns the value itself
// Returns a solved operation
// Returns a global variable's value
function parse_global(argument0)
{
    var _global = argument0;
    if (typeof(_global) != "string")
        return _global;
    if (string_starts_with(_global, "op=,"))
        return global.evaluate(_global)
    if (!variable_global_exists(_global))
        return _global;
    return variable_global_get(_global);
}

// Parses a value, and if a global called that exists it returns its value
// Returns a local variable's value or -1
function parse_local(argument0, argument1)
{
    var inst_id = argument0;
    var local = argument1;
    if (typeof(local) != "string")
        return 0;
    if (!variable_instance_exists(inst_id, local))
        return 0;
    return variable_instance_get(inst_id, local);
}

// Sets an instance's local variable to a global variable
// In the syntax g_example = local
// In the syntax g_example = op=,+1,+2,
// In the syntax g_example = spr_example
function set_local_to_global(argument0, argument1, argument2)
{
    var inst_id = argument0;
    var local = argument1;
    var _global = argument2;

    if (typeof(_global) != "string")
        return;
    if (!variable_global_exists(_global))
        return;
    
    var local_value = global.parse_local(inst_id, local);
    variable_global_set(_global, local_value);
}

// Sets a global variable to an instance's local variable
// In the syntax v_example = global
// In the syntax v_example = op=,+1,+2,
// In the syntax v_example = spr_example
function set_global_to_local(argument0, argument1, argument2)
{
    var inst_id = argument0;
    var _global = argument1;
    var local = argument2;

    if ((typeof(local) != "string"))
        return;
    if (!variable_instance_exists(inst_id, local))
        return;
    
    var global_value = global.parse_global(_global)
    variable_instance_set(inst_id, local, global_value);
}

// Says if it is a variable param
function is_variable_param(argument0) {
    var n = argument0;
    if string_starts_with(n, "g_")
        return true;
    if string_starts_with(n, "gs_")
        return true;
    if string_starts_with(n, "v_")
        return true;
    if string_starts_with(n, "vs_")
        return true;
    return false;
}

// Says if it is start on variable param
function is_start_variable_param(argument0) {
    var n = argument0;
    if string_starts_with(n, "gs_")
        return true;
    if string_starts_with(n, "vs_")
        return true;
    return false;
}