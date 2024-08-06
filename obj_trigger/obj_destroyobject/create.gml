event_inherited()

target_obj = noone
target_object_id = undefined

on_collide = false

execute = function()
{
    if (!is_real(target_obj))
        return
    

    with (target_obj) {
        
        // If collided destroy
        if (other.on_collide) {
            var colliding = false
            // Ids are equal or theres no target object id
            var object_id = undefined
            if (variable_instance_exists(self, "object_id"))
                object_id = self.object_id
            
            if (other.target_object_id == object_id || is_undefined(other.target_object_id))
                colliding = place_meeting(x, y, other)
            
            if (colliding) {
                instance_destroy()
                other.trigger_targets();
                other.set_color();
            }
        } else {
            other.trigger_targets();
            other.set_color();
            instance_destroy()
        }
    }

}

