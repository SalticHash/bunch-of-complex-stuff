// Add 
//|| (object_index == obj_variable) || (object_index == obj_compare) || (object_index == obj_getvar) || (object_index == obj_delay)
// In the end of show collision debug expr

if DEBUG
{
    with (all)
    {
        if ((visible != true) || variable_instance_exists(id, "toggle"))
        {
            if ((object_index == obj_doorA) || (object_index == obj_doorB) || (object_index == obj_doorC) || (object_index == obj_doorD) || (object_index == obj_doorE) || (object_index == obj_doorF) || (object_index == obj_doorG) || (object_index == obj_solid) || (object_index == obj_secretblock) || (object_index == obj_secretbigblock) || (object_index == obj_secretmetalblock) || (object_index == obj_slope) || (object_index == obj_platform) || (object_index == obj_ladder) || (object_index == obj_hallway) || (object_index == obj_tvtrigger) || (object_index == obj_supriseenemyarea) || (object_index == obj_hiddenobjecttrigger) || (object_index == obj_secretroomtrigger) || (object_index == obj_iceblock) || (object_index == obj_iceblockslope) || (object_index == obj_mach3solid) || (object_index == obj_unclimbablewall) || (object_index == obj_pineapplemonsterzone) || (object_index == obj_frontcanongoblin_trigger) || (object_index == obj_moving_hstop) || (object_index == obj_moving_vstop) || (object_index == obj_warp_number) || (object_index == obj_verticalhallway) || (object_index == obj_tubeleft) || (object_index == obj_tuberight) || (object_index == obj_tubedown) || (object_index == obj_tubeup) || (object_index == obj_horseyleft) || (object_index == obj_horseyright) || (object_index == obj_horseydown) || (object_index == obj_horseyup) || (object_index == obj_racestart) || (object_index == obj_raceend) || (object_index == obj_lightsource) || (object_index == obj_chateaulight) || (object_index == obj_vigilantespot) || (object_index == obj_fakepepsolid) || (object_index == obj_tutorialtrap) || (object_index == obj_conveyordespawner) || (object_index == obj_arenalimit) || (object_index == obj_pizzaarrowtrap) || (object_index == obj_grindrail) || (object_index == obj_grindrailslope)|| (object_index == obj_variable) || (object_index == obj_compare) || (object_index == obj_getvar) || (object_index == obj_delay))
            {
                visible = other.showcollisions
                variable_instance_set(id, "toggle", 1)
            }
        }
    }
}
