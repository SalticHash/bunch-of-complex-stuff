trigger_id = -1;
target_trigger_id = -1;

on_enter = 1;
on_touch = 0;
on_trigger = 0;
on_repeat = 0;

multi = 0;
activated = 0;

// Gml_Script_Create_0_0_ansuhbd
execute = function() {}

trigger = function() {
    if (on_trigger && (!activated))
    {
        self.execute()
        if (!multi)
            activated = 1
    }
}