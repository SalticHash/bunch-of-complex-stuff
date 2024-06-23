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
        with (obj_trigger)
        {
            if (other.target_trigger_id == trigger_id)
                self.trigger()
        }
    } else {
        with (obj_trigger)
        {
            if (other.else_target_trigger_id == trigger_id)
                self.trigger()
        }
    }
}