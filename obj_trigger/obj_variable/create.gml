event_inherited();

name = "panic";
value = 1;

execute = function() {
    var ivalue = parse_global(value);
    
    variable_global_set(name, ivalue);

    self.trigger_targets();
    self.set_color();
}