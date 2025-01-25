event_inherited();

else_target_trigger_id = -1

a = 5;
b = 10;

op = "=";

function compare_number(operator, i, j) {
	if (!is_numeric(i) or !is_numeric(j)) return false
	
	// Compares numbers
    return ((op == "=") and (i == j)) or 
        ((op == "!=") and (i != j)) or 
        ((op == ">") and (i > j)) or 
        ((op == "<") and (i < j)) or 
        ((op == ">=") and (i >= j)) or 
        ((op == "<=") and (i <= j)) or 
        ((op == "or") and (i or j)) or 
        ((op == "and") and (i and j))
}


function compare_string(operator, i, j) {
	if (!is_string(i)) return false
	
    return
		// Compares logical conditions for j being a string
		(is_string(j) and
			// Compares string equality
			((op == "=") and (i == j)) or 
	        ((op == "!=") and (i != j)) or
			
			// Compares length of two strings
			((op == "len=") and (string_length(i) == string_length(j))) or 
            ((op == "len!=") and (string_length(i) != string_length(j))) or 
            ((op == "len>") and (string_length(i) > string_length(j))) or 
            ((op == "len<") and (string_length(i) < string_length(j))) or 
            ((op == "len>=") and (string_length(i) >= string_length(j))) or 
            ((op == "len<=") and (string_length(i) <= string_length(j)))
		) or
        // Compares logical conditions for j being numeric
        (is_numeric(j) and
            ((op == "len=") and (string_length(i) == j)) or 
            ((op == "len!=") and (string_length(i) != j)) or 
            ((op == "len>") and (string_length(i) > j)) or 
            ((op == "len<") and (string_length(i) < j)) or 
            ((op == "len>=") and (string_length(i) >= j)) or 
            ((op == "len<=") and (string_length(i) <= j))
        )
}

execute = function() {
    var i = global.parse_global(a)
    var j = global.parse_global(b)
    
    if (compare_number(i, j) or compare_string(i, j)) {
        self.trigger_targets()
        self.set_color(c_white);
    } else {
        self.trigger_targets(self.else_target_trigger_id)
        self.set_color(c_green);
    }
}