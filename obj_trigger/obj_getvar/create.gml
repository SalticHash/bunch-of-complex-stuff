event_inherited();

target_obj = obj_player
target_var = "x"
target_global_var = "player_x"

execute = function() {
    // Set global var to targer local var
    var obj = instance_nearest(x, y, target_obj)
    set_local_to_global(obj, target_global_var, target_var);

    // Trigger target trigger
    with (obj_trigger) {
        if (other.target_trigger_id == trigger_id)
            self.trigger()
    }
}