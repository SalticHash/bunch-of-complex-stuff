trigger_id = undefined;
target_trigger_id = undefined;

on_start = 1;
on_touch = 0;
on_trigger = 0;
on_repeat = 0;
on_repeat_after = 0;

multi = 0;
activated = 0;

image_blend = c_gray

execute = function() {
    self.set_color()
    self.trigger_targets()
}

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

    if (is_undefined(custom_target_trigger))
        custom_target_trigger = self.target_trigger_id
    
    if (is_undefined(custom_target_trigger))
        return
    
    with (obj_trigger)
    {
        // Dont self trigger
        if (other.id == id)
            continue
        
        // If ids match trigger!
        if (custom_target_trigger == trigger_id)
            self.trigger()
    }
}

set_color = function(argument0, argument1) {
    if (alarm[1] >= 0.05) return

    var color = argument0
    var time = argument1 // In seconds
    if (is_undefined(color)) color = c_white
    if (is_undefined(time)) time = 0.25

    image_blend = color
    alarm[1] = room_speed * time
}