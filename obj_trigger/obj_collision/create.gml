event_inherited()

target_obj = obj_player1

enter_target_trigger_id = undefined
// target_trigger_id = -1 For on inside
exit_target_trigger_id = undefined

target_object_id = undefined

inside = false
colliding = false

execute = function() {
    if (!is_real(target_obj))
        return
    
    colliding = false
    with (target_obj) {
        var has_id = variable_instance_exists(self, "object_id")
        // Blud has no id and we are searching for one 
        if (!has_id && !is_undefined(other.target_object_id))
            continue
        
        var object_id = undefined
        if (variable_instance_exists(self, "object_id"))
            object_id = self.object_id

        // Ids are equal or theres no target object id
        if (other.target_object_id == object_id || is_undefined(other.target_object_id))
            other.colliding = place_meeting(x, y, other)
        
        if (other.colliding)
            break
    }

    if (inside != colliding) {
        inside = colliding
        if (inside) {
            self.trigger_targets(self.enter_target_trigger_id)
        } else {
            self.trigger_targets(self.exit_target_trigger_id)
        }
    }
    if (inside) {
        self.trigger_targets();
        self.set_color();
    }
}