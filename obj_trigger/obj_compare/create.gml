event_inherited();

else_target_trigger_id = -1

a = 5;
b = 10;

op = "=";

execute = function() {
    var i = global.parse_global(a)
    var j = global.parse_global(b)
    
    if (((i == j) and (op == "=")) or 
        ((i != j) and (op == "!=")) or 
        ((i > j) and (op == ">")) or 
        ((i < j) and (op == "<")) or 
        ((i >= j) and (op == ">=")) or 
        ((i <= j) and (op == "<=")) or 
        ((i or j) and (op == "or")) or 
        ((i and j) and (op == "and")))
    {
        self.trigger_targets()
        self.set_color(c_white);
    } else {
        self.trigger_targets(self.else_target_trigger_id)
        self.set_color(c_green);
    }
}