event_inherited();

target_obj = obj_player1
target_object_id = undefined
target_var = "x"
target_value = 10


execute = function() {
    // Set global var to targer local var
    var obj = instance_nearest(x, y, target_obj)
    if (!is_real(obj)) return;

    set_global_to_local(obj, target_value, target_var);

    // Trigger target trigger
    self.trigger_targets()
    self.set_color();
}