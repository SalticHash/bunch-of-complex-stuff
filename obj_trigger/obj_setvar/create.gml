event_inherited();

target_obj = obj_player
target_var = "x"
target_value = 10


execute = function() {
    // Set global var to targer local var
    var obj = instance_nearest(x, y, target_obj)
    set_global_to_local(obj, target_value, target_var);

    // Trigger target trigger
    with (obj_trigger) {
        if (other.target_trigger_id == trigger_id)
            self.trigger()
    }
}