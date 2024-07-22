event_inherited();

target_obj = obj_player1
target_var = "x"
target_value = 10


execute = function() {
    // Set global var to targer local var
    var obj = instance_nearest(x, y, target_obj)
    set_global_to_local(obj, target_value, target_var);

    // Trigger target trigger
    self.trigger_targets()
}