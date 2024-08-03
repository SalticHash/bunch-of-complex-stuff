data = global.roomData
var prop = data.properties
if is_undefined(data)
    return;

varInsts = [] // New

roomInsts = []
respawnOnLap2 = struct_new()
layerForce = []
var insts = struct_get(data, "instances")
for (var i = 0; i < array_length(data.instances); i++)
{
    insData = insts[i]
    levelInst = gml_Script_instanceManager_getKey(i)
    if (!insData.deleted)
    {
        var l = _stGet("insData.layer")
        gml_Script_layerConfirm("Instances", l)

        // NEW: Dont worry about objects moving in the json cuz they can now use names!
        var objIndex = _stGet("insData.object")
        if (typeof(objIndex) == "string")
            objIndex = asset_get_index(objIndex)
        // NEW: End of NEW. 

        if (objIndex >= obj_noisecredit)
        {
            var ins = instance_create_layer((_stGet("insData.variables.x") - _stGet("data.properties.roomX")), (_stGet("insData.variables.y") - _stGet("data.properties.roomY")), layer_get_id(gml_Script_layerFormat("Instances", l)), objIndex)
            if instance_exists(ins)
            {
                gml_Script_instanceManager_checkAndSwitch(levelInst, ins)
                ins.flipX = 0
                ins.flipY = 0
                ins.targetRoom = "main"
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

                // NEW: All variable basis
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
                // NEW: end of NEW.
            }
        }
    }
}
for (var k = 0; k < array_length(varInsts); k++)
{
    var inst = varInsts[k]
    var inst_start = inst[0]
    var inst_id = inst[1]
    var inst_name = inst[2]
    var inst_val = inst[3]
    var inst_local = string_starts_with(inst_name, "v")
    if inst_local
    {
        var target_local = string_delete(inst_name, 1, 3)
        var target_global = inst_val
        set_global_to_local(inst_id, target_global, target_local)
    }
    else
    {
        target_global = string_delete(inst_name, 1, 3)
        target_local = inst_val
        set_local_to_global(inst_id, target_local, target_global)
    }
}
var tileLayers = variable_struct_get_names(_stGet("data.tile_data"))
for (i = 0; i < array_length(tileLayers); i++)
    initTileLayer(int64(tileLayers[i]), 1)
var bgLayers = variable_struct_get_names(_stGet("data.backgrounds"))
for (i = 0; i < array_length(bgLayers); i++)
    initBGLayer(global.roomData, int64(bgLayers[i]))
var levelData = level_load(global.levelName)
if (prop.song != "" && ((!global.panic) || global.insecret || levelData.escapeSong == "false") && prop.song != obj_customAudio.levelSongPlaying)
{
    with (obj_customAudio)
        levelSongPlaying = prop.song
    customSong_switch(prop.song, prop.songTransitionTime)
}
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
        targetDoor = global.startingDoor
        if instance_exists(obj_exitgate)
            state = states.comingoutdoor
        else
            state = states.normal
        if (global.doPanic == "True")
        {
            global.panic = 1
            var d = level_load(global.levelName)
            global.minutes = floor(d.escape / 60)
            global.seconds = d.escape % 60
            global.fill = d.escape * 60 * 0.2
            with (obj_tv)
                chunkmax = global.fill
        }
        if (global.setSupertaunt == "True")
            supercharged = true
        movespeed = real(global.startPlayerSpeed)
        if (movespeed < 0)
        {
            xscale = (-xscale)
            movespeed = (-movespeed)
        }
        if (movespeed != 0)
        {
            if (movespeed <= 12)
            {
                sprite_index = spr_mach
                state = states.mach2
            }
            else
            {
                sprite_index = spr_mach4
                state = states.mach3
            }
        }
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
