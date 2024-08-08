event_inherited()

content = noone

// Particle Stuff
particle = false
particle_spr = spr_glasspiece
particle_amount = 4

p_hsp_min = -5; p_hsp_min = -5
p_vsp_min = -10; p_vsp_min = 10
p_grav = 0.4
p_img_sp = 0
p_rng_spr = true

execute = function()
{
    var _content = parse_global(content)
    if (!is_real(_content) && !is_array(_content))
        return

    if (!is_array(_content)) {
        instance_create(x, y, _content)
    }
    else
    {
        with (instance_create(x, y, _content[0]))
        {
            for (i = 1; i < array_length(other.content); i++)
            {
                var structname = variable_struct_get_names(other.content[i])
                var storedstruct = struct_get(other.content[i], structname[0])
                if (string_count("spr", structname[0]) != 0)
                    storedstruct = _spr(storedstruct)
                variable_instance_set(id, structname[0], storedstruct)
            }
        }
    }

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

    self.trigger_targets();
    self.set_color();
}

