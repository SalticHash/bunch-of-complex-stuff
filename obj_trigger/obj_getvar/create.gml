event_inherited();

target_obj = obj_player1
target_var = "x"
target_global_var = "player_x"

execute = function() {
    image_blend = c_white
    alarm[1] = room_speed * 0.25

    // Set global var to targer local var
    var obj = instance_nearest(x, y, target_obj)
    set_local_to_global(obj, target_var, target_global_var);

    // Trigger target trigger
    self.trigger_targets()
}