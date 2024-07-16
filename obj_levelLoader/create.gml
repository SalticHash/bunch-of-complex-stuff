data = global.roomData
varInsts = [] // ***PUT HERE*** //

var prop = data.properties
if is_undefined(data)
    return;
roomInsts = []
respawnOnLap2 = struct_new()
layerForce = []
for (var i = 0; i < array_length(data.instances); i++)
{
    var insts = struct_get(data, "instances")
    insData = insts[i]
    levelInst = global.currentRoom + "_" + string(i)
    if (!insData.deleted)
    {
        var l = _stGet("insData.layer")
        gml_Script_layerConfirm("Instances", l)
        var ins = instance_create_layer((_stGet("insData.variables.x") - _stGet("data.properties.roomX")), (_stGet("insData.variables.y") - _stGet("data.properties.roomY")), layer_get_id(gml_Script_layerFormat("Instances", l)), _stGet("insData.object"))
        gml_Script_instanceManager_checkAndSwitch(i, ins)
        ins.flipX = 0
        ins.flipY = 0
        ins.targetRoom = "main"
        var varNames = variable_struct_get_names(struct_get(insData, "variables"))
        for (var j = 0; j < array_length(varNames); j++)
        {
            if (varNames[j] != "x" && varNames[j] != "y")
                variable_instance_set(ins, varNames[j], gml_Script_varValue_ressolve(struct_get(struct_get(insData, "variables"), varNames[j]), gml_Script_varName_getType(varNames[j])))
        }
        ins.instID = i
        if (!(variable_instance_exists(ins, "escape")))
            ins.escape = 0
        if variable_instance_exists(ins, "useLayerDepth")
            array_push(layerForce, [ins, layer_get_id(gml_Script_layerFormat("Instances", l))])
        array_push(roomInsts, [ins.id, i, ins.object_index, ins.escape])
        if (ins.escape || gml_Script_array_value_exists(struct_get(global.objectData, "respawnOnLap2"), object_get_name(ins.object_index)))
            struct_set(respawnOnLap2, [[string(i), "true"]])
        if ins.flipX
        {
            var horDifference = sprite_get_width(ins.sprite_index) - sprite_get_xoffset(ins.sprite_index) * 2
            ins.x += (horDifference * ins.image_xscale)
            ins.image_xscale *= -1
        }
        if ins.flipY
        {
            var verDifference = sprite_get_height(ins.sprite_index) - sprite_get_yoffset(ins.sprite_index) * 2
            ins.y += (verDifference * ins.image_yscale)
            ins.image_yscale *= -1
        }
        // ***PUT BETWEEN HERE*** //
        var varNames = variable_struct_get_names(struct_get(insData, "variables"))
        for (var j = 0; j < array_length(varNames); j++)
        {
            if is_variable_param(varNames[j])
            {
                show_debug_message("WHY NO WORKL")
                var val = gml_Script_varValue_ressolve(struct_get(struct_get(insData, "variables"), varNames[j]))
                array_push(varInsts, [is_start_variable_param(varNames[j]), ins.id, varNames[j], val])
            }
            if (varNames[j] != "x" && varNames[j] != "y")
                variable_instance_set(ins, varNames[j], gml_Script_varValue_ressolve(struct_get(struct_get(insData, "variables"), varNames[j]), gml_Script_varName_getType(varNames[j])))
        }
        // ***AND HERE*** //
    }
}
var tileLayers = variable_struct_get_names(_stGet("data.tile_data"))
for (i = 0; i < array_length(tileLayers); i++)
    initTileLayer(int64(tileLayers[i]), 1)
var bgLayers = variable_struct_get_names(_stGet("data.backgrounds"))
for (i = 0; i < array_length(bgLayers); i++)
    initBGLayer(global.roomData, int64(bgLayers[i]))
if (prop.song != "" && ((!global.panic) || obj_player.replacemusic == 0))
    customSong_switch(prop.song, prop.songTransitionTime)
if variable_struct_exists(prop, "pausecombo")
{
    if (prop.pausecombo != undefined)
        global.combotimepause = prop.pausecombo
}
else
{
    variable_struct_set(prop, "pausecombo", 0)
    global.combotimepause = 0
}
if (global.fromEditor || global.fromMenu)
{
    with (obj_player)
    {
        if global.fromEditor
            backtohubroom = rmEditor
        targetDoor = "A"
        if instance_exists(obj_exitgate)
            state = states.comingoutdoor
        else
            state = states.normal
    }
    global.fromEditor = 0
    global.fromMenu = 0
}
var lv = level_load(global.levelName)
isHubLevel = lv.isWorld
if (global.levelName == global.hubLevel)
{
    isHubLevel = 1
    with (obj_player)
        backtohubroom = rmModMenu
}
