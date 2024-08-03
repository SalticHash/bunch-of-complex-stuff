event_inherited()

content = noone

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
    self.trigger_targets();
    self.set_color();
}

