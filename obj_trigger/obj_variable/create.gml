event_inherited();

name = "panic";
value = 1;

execute = function() {
    var ivalue = parse_global(value);
    
    variable_global_set(name, ivalue);

    with (obj_trigger)
    {
        if (other.target_trigger_id == trigger_id)
            self.trigger()
    }
}