event_inherited();

a = 5;
b = 10;
op = "=";

execute = function() {
    if ((a == b and op == "=") or 
        (a != b and op == "!=") or 
        (a > b and op == ">") or 
        (a < b and op == "<") or 
        (a >= b and op == ">=") or 
        (a <= b and op == "<=") or 
        (a or b and op == "or") or 
        (a and b and op == "and"))
    {
        with (obj_trigger)
        {
            if (other.target_trigger_id == trigger_id)
                self.trigger()
        }
    }
}