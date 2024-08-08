event_inherited()

execute_event = true

target_obj = noone
target_object_id = undefined

on_collide = false

// Particle Stuff
particle = false
particle_spr = spr_glasspiece
particle_amount = 4

p_hsp_min = -5; p_hsp_min = -5
p_vsp_min = -10; p_vsp_min = 10
p_grav = 0.4
p_img_sp = 0
p_rng_spr = true

destroy = function(argument0) {
    var object = argument0

    instance_destroy(object, execute_event)
    self.set_color()
    self.trigger_targets()

    if (particle) {
        repeat (particle_amount)
        {
            with (create_debris((x + (random_range(0, sprite_width))), (y + (random_range(0, sprite_height))), particle_spr, 1))
            {
                hsp = random_range(p_hsp_min, p_hsp_max)
                vsp = random_range(p_vsp_min, p_vsp_max)
                grav = p_grav
                image_speed = p_img_sp
                if (p_rng_spr) {
                    image_index = random_range(0, (image_number - 1))
                }
            }
        }
    }
}

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
                other.destroy(self);
            }
        } else {
            other.destroy(self);
        }
    }
}


