event_inherited();

name = "panic";
value = 1;

execute = function() {
    variable_global_set(name, value);

    with (obj_trigger)
    {
        if (other.target_trigger_id == trigger_id)
            self.trigger()
    }
}