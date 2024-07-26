event_inherited();

name = "panic";
value = 1;

execute = function() {
    image_blend = c_white
    alarm[1] = room_speed * 0.25

    var ivalue = parse_global(value);
    
    variable_global_set(name, ivalue);

    self.trigger_targets();
}