trigger_id = -1;
target_trigger_id = -1;

on_enter = 1;
on_touch = 0;
on_trigger = 0;
on_repeat = 0;
on_repeat_after = 0;

multi = 0;
activated = 0;

execute = function() {}

trigger = function() {
    if (on_trigger && (!activated))
    {
        self.execute()
        if (!multi)
            activated = 1
    }
}

trigger_targets = function(argument0) {
    var custom_target_trigger = argument0
    with (obj_trigger)
    {
        if (other.id == id)
            continue
        
        if (custom_target_trigger == undefined) {
            if (other.target_trigger_id == trigger_id)
                self.trigger()
        } else {
            if (custom_target_trigger == trigger_id)
                self.trigger()
        }
    }
}