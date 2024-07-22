// NEW stuff is in load and save data

scr_playerreset()
gml_Script_modRoom_init()
global.editingLevel = 1
gml_Script_instanceManager_reset()
stopSong()
global.panic = 0
global.gameframe_caption_text = "Create Your Own Pizza Tower"
window_set_cursor(cr_default)
draw_set_font(global.editorfont)
var comment = ""
level = global.editorLevelName
lvlRoom = global.editorRoomName
editorVersion = 5
data = roomData_new()
data2 = roomData_new()
port_mode = 0
levelSettings = level_load(level)
levelNameList = []
var dir = mod_folder("levels/")
levelFiles = gml_Script_find_files_recursive(dir, ".ini")
for (var i = 0; i < array_length(levelFiles); i++)
    array_push(levelNameList, string_replace(string_replace(filename_path(levelFiles[i]), dir, ""), "/", ""))
spriteList = global.sprite_names
audioList = global.audio_names
prevData = data
undo_stack = ds_stack_create()
redo_stack = ds_stack_create()
other_stack = ds_stack_create()
updateUndoMemory = 0
_stSet("data.properties.roomX", 0)
_stSet("data.properties.roomY", 0)
gridSize = 32
camZoom = 1
layer_instances = 0
layer_tilemap = 5
layer_background = 5
initialX = 0
initialY = 0
selectionList = ds_list_create()
copiedList = ds_list_create()
instanceIDList = ds_list_create()
copiedIDList = ds_list_create()
listIDList = ds_list_create()
inst = obj_bossdoor
addToList = 0
checkSelector = 0
levelList = global.levelNameList
roomNameList = []
randomize()
for (var rm = file_find_first((mod_folder("levels/") + level + "/rooms/*.json"), 0); rm != ""; rm = file_find_next())
{
    if (string_count("_wfixed", string(rm)) == 0)
        array_push(roomNameList, filename_name(filename_change_ext(rm, "")))
}
function array_clone(argument0) //gml_Script_array_clone
{
    var array = argument0
    var first = array
    array = first
    return array;
}

function roomPath() //gml_Script_roomPath
{
    return fstring(mod_folder("levels/{level}/rooms/{lvlRoom}.json"));
}

function roomPath2() //gml_Script_roomPath2
{
    return fstring(mod_folder("levels/{level}/rooms/{lvlRoom}_wfixed.json"));
}

function saveData() //gml_Script_saveData
{
    data.editorVersion = editorVersion
    var jText = json_stringify(data, 1)
    var b = 1
    var p = "levels/{level}/rooms/"
    var backup = mod_folder(fstring(p + "backups/{lvlRoom}_wfixed.backup"))
    var oldBackupDir = mod_folder(fstring(p + "backups"))
    var rBackup = "backups/" + backup


    // NEW: save ids as string
    for (var i = 0; i < array_length(data.instances); i++)
    {
        inst = data.instances[i]
        objectId = inst.object
        if (typeof(objectId) != "string") {
            objectId = object_get_name(objectId)
            inst.object = objectId
        }
    }
    // NEW: end of NEW


    if directory_exists(oldBackupDir)
    {
        var oldB = gml_Script_find_files_recursive((oldBackupDir + "/"), "")
        for (var i = 0; i < array_length(oldB); i++)
        {
            var bNum = gml_Script_SplitString(oldB[i], ".backup")
            file_copy(oldB[i], ("backups/" + oldB[i]))
            file_delete(oldB[i])
        }
    }
    directory_destroy(oldBackupDir)
    for (b = 0; b <= 4; b++)
    {
        if file_exists(rBackup + string(b))
        {
            if (b == 0)
                file_delete(rBackup + "0")
            else
                file_rename((rBackup + string(b)), (rBackup + (string(b - 1))))
        }
    }
    gml_Script_json_save(jText, roomPath2())
    gml_Script_json_save(jText, (rBackup + "4"))
    level_save(level, levelSettings)
    obj_modAssets.saveNotice = 120

    // NEW: reset object id as number
    for (var i = 0; i < array_length(data.instances); i++) {
        inst = data.instances[i]
        objectId = inst.object
        if (typeof(objectId) == "string")
        {
            objectId = asset_get_index(objectId)
            inst.object = objectId
        }
    }
    // NEW: end of NEW
}

function saveData2() //gml_Script_saveData2
{
    data2.editorVersion = editorVersion
    data2.instances = [-4]
    var spawnind = 1
    for (var i = 0; i < array_length(data.instances); i++)
    {
        var data3 = [struct_new([["layer", 0], ["deleted", 0], ["variables", struct_new([["x", 0], ["flipX", 0], ["y", 0], ["flipY", 0]])], ["object", 0]])]
        if (!is_struct(data3[0]))
            data3[0] = array_get(data.instances, i)
        else
        {
            var st_names = variable_struct_get_names(data3[0])
            var pass = 1

            // NEW: more name id...
            objectId = array_get(data.instances, i).object
            if (typeof(objectId) == "string")
            {
                objectId = asset_get_index(objectId)
            }
            // NEW: end of NEW
    
            var st_valuetopass = objectId

            if (!is_real(st_valuetopass))
                array_delete(data.instances, i, 1)
            if (st_valuetopass == 1172 || st_valuetopass == 383 || st_valuetopass == 1174 || st_valuetopass == 1175 || st_valuetopass == 1122 || st_valuetopass == 1192 || st_valuetopass == 1171 || st_valuetopass == 936 || st_valuetopass == 1151 || st_valuetopass == 1152 || st_valuetopass == 576 || st_valuetopass == 577 || st_valuetopass == 578 || st_valuetopass == 1191 || st_valuetopass == 899 || st_valuetopass == 762 || st_valuetopass == 1025 || st_valuetopass == 1024 || st_valuetopass == 1153 || st_valuetopass == 1155 || st_valuetopass == 1015 || st_valuetopass == 1078 || st_valuetopass == 710 || st_valuetopass == 237 || st_valuetopass == 153 || st_valuetopass == 496 || st_valuetopass == 1180 || st_valuetopass == 1096 || st_valuetopass == 1023 || st_valuetopass == 1183 || st_valuetopass == 708 || st_valuetopass == 675 || st_valuetopass == 1188 || st_valuetopass == 1189 || st_valuetopass == 553 || st_valuetopass == 74 || st_valuetopass == 948 || st_valuetopass == 1194)
                pass = 0
            else
            {
                for (var j = 0; j < array_length(st_names); j++)
                {
                    var st_value = struct_get(data.instances[i], st_names[j])
                    variable_struct_set(data3[0], st_names[j], st_value)
                }
                if (st_valuetopass == 864)
                    variable_struct_set(data3[0], "object", 811)
                else if (st_valuetopass == 1181)
                {
                    variable_struct_set(data3[0], "object", 780)
                    var object_vars = struct_get(data3[0], "variables")
                    if (!(variable_struct_exists(object_vars, "sprite_index")))
                        variable_struct_set(object_vars, "sprite_index", 2144)
                    if (!(variable_struct_exists(object_vars, "image_speed")))
                        variable_struct_set(object_vars, "image_speed", 0.35)
                }
                else if (st_valuetopass == 1182)
                {
                    variable_struct_set(data3[0], "object", 1144)
                    object_vars = struct_get(data3[0], "variables")
                    if (!(variable_struct_exists(object_vars, "sprite_index")))
                        variable_struct_set(object_vars, "sprite_index", 2126)
                }
                else if (st_valuetopass == 598)
                {
                    object_vars = struct_get(data3[0], "variables")
                    if variable_struct_exists(object_vars, "superjumpable")
                    {
                        var var_vars = struct_get(object_vars, "superjumpable")
                        if (var_vars == 1 || var_vars == "true")
                        {
                            variable_struct_set(data3[0], "object", 730)
                            if (!(variable_struct_exists(object_vars, "sprite_index")))
                                variable_struct_set(object_vars, "sprite_index", 1217)
                        }
                    }
                }
                else if (st_valuetopass == 1176)
                {
                    variable_struct_set(data3[0], "object", 516)
                    data3[1] = struct_new([["layer", 0], ["deleted", 0], ["variables", struct_new([["x", 0], ["flipX", 0], ["y", 0], ["flipY", 0]])], ["object", 0]])
                    variable_struct_set(data3[1], "object", 672)
                    variable_struct_set(data3[1], "deleted", struct_get(data3[0], "deleted"))
                    object_vars = struct_get(data3[0], "variables")
                    var object_vars2 = struct_get(data3[1], "variables")
                    variable_struct_set(object_vars2, "x", struct_get(object_vars, "x"))
                    variable_struct_set(object_vars2, "flipX", (!(struct_get(object_vars, "flipX"))))
                    variable_struct_set(object_vars2, "y", struct_get(object_vars, "y"))
                    variable_struct_set(object_vars2, "flipY", struct_get(object_vars, "flipY"))
                }
                else if (st_valuetopass == 677)
                    variable_struct_set(data3[0], "object", 678)
                else if (st_valuetopass == 135)
                {
                    object_vars = struct_get(data3[0], "variables")
                    variable_struct_set(object_vars, "railmovespeed", 0)
                    variable_struct_set(object_vars, "turnstart", 0)
                    variable_struct_set(object_vars, "turner", 0)
                    variable_struct_set(object_vars, "turnmax", 200)
                    variable_struct_set(object_vars, "turntimer", 0)
                }
                else if (st_valuetopass == 1186)
                {
                    variable_struct_set(data3[0], "object", 646)
                    object_vars = struct_get(data3[0], "variables")
                    if (!(variable_struct_exists(object_vars, "grabbedspr")))
                        variable_struct_set(object_vars, "grabbedspr", 327)
                    if (!(variable_struct_exists(object_vars, "stunfallspr")))
                        variable_struct_set(object_vars, "stunfallspr", 327)
                    if (!(variable_struct_exists(object_vars, "walkspr")))
                        variable_struct_set(object_vars, "walkspr", 329)
                    if (!(variable_struct_exists(object_vars, "scaredspr")))
                        variable_struct_set(object_vars, "scaredspr", 334)
                    if (!(variable_struct_exists(object_vars, "spr_dead")))
                        variable_struct_set(object_vars, "spr_dead", 323)
                    if (!(variable_struct_exists(object_vars, "sprite_index")))
                        variable_struct_set(object_vars, "sprite_index", 329)
                }
                else if (st_valuetopass == 1187)
                    variable_struct_set(data3[0], "object", 720)
                else if (st_valuetopass == 596)
                {
                    variable_struct_set(data3[0], "object", 763)
                    object_vars = struct_get(data3[0], "variables")
                    variable_struct_set(object_vars, "value", 50)
                }
                else if ((st_valuetopass == 767 || st_valuetopass == 776 || st_valuetopass == 775) && spawnind)
                {
                    data3[1] = struct_new([["layer", 0], ["deleted", 0], ["variables", struct_new([["x", 0], ["flipX", 0], ["y", 0], ["flipY", 0]])], ["object", 0]])
                    variable_struct_set(data3[1], "object", 546)
                    spawnind = 0
                }
                else if (st_valuetopass == 460)
                    variable_struct_set(data3[0], "object", 748)
                else if (st_valuetopass == 708)
                    variable_struct_set(data3[0], "object", 112)
                else if (st_valuetopass == 1190)
                    variable_struct_set(data3[0], "object", 933)
                else if (st_valuetopass == 1170)
                    variable_struct_set(data3[0], "object", 494)
                else if (st_valuetopass == 725)
                    variable_struct_set(data3[0], "object", 192)
                else if (st_valuetopass == 744)
                    variable_struct_set(data3[0], "object", 250)
                else if (st_valuetopass == 737)
                    variable_struct_set(data3[0], "object", 250)
                else if (st_valuetopass == 409)
                    variable_struct_set(data3[0], "object", 598)
                else if (st_valuetopass == 768)
                    variable_struct_set(data3[0], "object", 769)
                else if (st_valuetopass == 796)
                    variable_struct_set(data3[0], "object", 764)
                else if (st_valuetopass == 292)
                {
                    object_vars = struct_get(data3[0], "variables")
                    variable_struct_set(object_vars, "showLadder", 1)
                }
                else if (st_valuetopass == 833)
                {
                    object_vars = struct_get(data3[0], "variables")
                    variable_struct_set(object_vars, "showLadder", 1)
                }
                data2.instances = gml_Script_array_concat(data2.instances, data3)
            }
        }
    }
    array_delete(data2.instances, 0, 1)
    var st_tile_data = struct_get(data, "tile_data")
    variable_struct_set(data2, "tile_data", st_tile_data)
    var st_backgroundsinst = struct_get(data, "backgrounds")
    variable_struct_set(data2, "backgrounds", st_backgroundsinst)
    var st_properties = struct_get(data, "properties")
    variable_struct_set(data2, "properties", st_properties)
    var jText = json_stringify(data2, 1)
    var b = 1
    var p = "levels/{level}/rooms/"
    var backup = mod_folder(fstring(p + "backups/{lvlRoom}.backup"))
    var oldBackupDir = mod_folder(fstring(p + "backups"))
    var rBackup = "backups/" + backup
    if directory_exists(oldBackupDir)
    {
        var oldB = gml_Script_find_files_recursive((oldBackupDir + "/"), "")
        for (i = 0; i < array_length(oldB); i++)
        {
            var bNum = gml_Script_SplitString(oldB[i], ".backup")
            file_copy(oldB[i], ("backups/" + oldB[i]))
            file_delete(oldB[i])
        }
    }
    directory_destroy(oldBackupDir)
    for (b = 0; b <= 4; b++)
    {
        if file_exists(rBackup + string(b))
        {
            if (b == 0)
                file_delete(rBackup + "0")
            else
                file_rename((rBackup + string(b)), (rBackup + (string(b - 1))))
        }
    }
    gml_Script_json_save(jText, roomPath())
    gml_Script_json_save(jText, (rBackup + "4"))
    level_save(level, levelSettings)
    obj_modAssets.saveNotice = 120
}

function loadData() //gml_Script_loadData
{
    if file_exists(roomPath2())
    {
        var jText = file_text_read_all(roomPath2())
        if (jText == "")
        {
            show_message(string(roomPath2()) + " has unfortunately corrupted. It has been deleted from your list of rooms in order to maintain stability")
            file_delete(roomPath2())
        }
        data = json_parse(jText)
        data = gml_Script_data_compatibility(data)
        for (var i = 0; i < array_length(data.instances); i++)
        {

            // NEW: load object id as number
            inst = data.instances[i]
            objectId = inst.object
            if (typeof(objectId) == "string")
            {
                objectId = asset_get_index(objectId)
                inst.object = objectId
            }
            // NEW: end of NEW


            _temp = i
            if _stGet("data.instances[_temp].deleted")
                ds_stack_push(deletedIndexes, i)
        }
        return 1;
    }
    return 0;
}

function initStage(argument0) //gml_Script_initStage
{
    data = argument0
    instance_activate_object(obj_editorInst)
    with (obj_editorInst)
        instance_destroy()
    with (obj_customBG)
        instance_destroy()
    with (obj_tilemapDrawer)
        instance_destroy()
    for (var i = 0; i < array_length(struct_get(data, "instances")); i++)
    {
        _temp = i
        if (!_stGet("data.instances[_temp].deleted"))
            initInst(i)
    }
    var tileLayers = variable_struct_get_names(_stGet("data.tile_data"))
    for (i = 0; i < array_length(tileLayers); i++)
        initTileLayer(int64(tileLayers[i]))
    var bgLayers = variable_struct_get_names(_stGet("data.backgrounds"))
    for (i = 0; i < array_length(bgLayers); i++)
        editor_initBGLayer(int64(bgLayers[i]), "")
}

function initInst(argument0) //gml_Script_initInst
{
    var insts = struct_get(data, "instances")
    var insData = insts[argument0]
    var l = struct_get(insData, "layer")
    if (l == undefined)
    {
        insData.deleted = 1
        return -4;
    }
    gml_Script_layerConfirm("Instances", l)
    var ins = instance_create_layer(struct_get(struct_get(insData, "variables"), "x"), struct_get(struct_get(insData, "variables"), "y"), layer_get_id(gml_Script_layerFormat("Instances", l)), obj_editorInst)
    

    // NEW: more name id...
    objectId = insData.object
    if (typeof(objectId) == "string")
    {
        objectId = asset_get_index(objectId)
        insData.object = objectId
    }
    // NEW: end of NEW


    ins.sprite_index = object_get_sprite(struct_get(insData, "object"))
    ins.instID = argument0
    instance_update_variables(ins, insData)
    return ins;
}

function addInst(argument0, argument1, argument2) //gml_Script_addInst
{
    var newInst = struct_new([["object", argument0], ["deleted", 0], ["variables", struct_new([["x", argument1], ["y", argument2]])], ["layer", layer_instances]])
    var instInd = array_length(struct_get(data, "instances"))
    if (!ds_stack_empty(deletedIndexes))
        instInd = ds_stack_pop(deletedIndexes)
    _temp = instInd
    data.instances[_temp] = newInst
    if (!port_mode)
        return initInst(instInd);
    return struct_new([["instID", instInd]]);
}

function initTileLayer(argument0, argument1) //gml_Script_initTileLayer
{
    gml_Script_layerConfirm("Tiles", argument0)
    var off = [0, 0]
    if (argument1 == 1)
        off = [_stGet("data.properties.roomX"), _stGet("data.properties.roomY")]
    with (obj_tilemapDrawer)
    {
        if (layer_get_name(layer) == gml_Script_layerFormat("Tiles", argument0))
        {
            initTilemapDrawer(other.data, argument0)
            return;
        }
    }
    var tmd = instance_create_layer(0, 0, layer_get_id(gml_Script_layerFormat("Tiles", argument0)), obj_tilemapDrawer)
    with (tmd)
        initTilemapDrawer(other.data, argument0)
}

pleaseExist = ""
function addTile(argument0, argument1, argument2, argument3, argument4) //gml_Script_addTile
{
    var name = argument0
    var coord = argument1
    var xx = int64(argument2)
    var yy = int64(argument3)
    if (argument4 == undefined)
        argument4 = 0
    tileLayerConfirm(layer_tilemap)
    var tLayer = string(layer_tilemap)
    _stSet(("data.tile_data." + tLayer + "." + string(xx) + "_" + string(yy)), struct_new([["tileset", name], ["coord", coord], ["autotile", argument4], ["autotile_index", tileset_autotileIndex]]))
    if port_mode
        return;
    var itExists = 0
    var camScale = camera_get_view_width(view_camera[0])
    with (obj_tilemapDrawer)
    {
        if (layer_tilemap == other.layer_tilemap)
        {
            drawTileToSurface(name, coord, xx, yy)
            itExists = 1
        }
    }
    if (!itExists)
        initTileLayer(layer_tilemap)
}

function deleteTile(argument0, argument1) //gml_Script_deleteTile
{
    var xx = int64(argument0)
    var yy = int64(argument1)
    var camScale = camera_get_view_width(view_camera[0])
    var tLayer = string(layer_tilemap)
    addTile(tilesetSelected, [0, 0], xx, yy, 0)
    variable_struct_remove(_stGet("data.tile_data." + tLayer), (string(xx) + "_" + string(yy)))
    with (obj_tilemapDrawer)
    {
        if (layer_tilemap == other.layer_tilemap)
            eraseTileFromSurface(xx, yy)
    }
}

deletedIndexes = ds_stack_create()
cursorMode = 0
lockCursorMode = 0
cursorImage = 0
cursorStretch = [0, 0]
prevGridPos = [0, 0]
updateStretch = 1
cursorNotice = ""
editor_state = -1
tilesetFolder = 0
tilesetSelected = "tile_entrance1"
tilesetCoord = [0, 0, 1, 1]
tilesetCoord_editing = tilesetCoord
tilesetCoord_spread = [tilesetCoord]
tileset_doAutoTile = 0
tileset_autotileIndex = 0
tileset_listScroll = 0
tile_selection = [0, 0, 0, 0, 0, 0]
tile_selection_made = 0
tile_selection_keys = []
tile_selection_moving = 0
tile_selection_move_origin = [0, 0, 0, 0]
roomHovering = -1
bgsHovering = -1
prevBGPreset = ""
settingsMode = 0
settingsHovering = -1
toolbarHovering = -1
instSelected = -4
instOn = -4
selCarry = []
objIndex = 517
global.currentRoom = lvlRoom
var exists = loadData()
var prop = data.properties
if ((prop.levelWidth - prop.roomX) > 16384)
{
    prop.levelWidth = floor(512) * 32 + prop.roomX
    prop.levelHeight = floor(512) * 32 + prop.roomY
}
var createtest = 0
var fName2 = mod_folder("levels/") + level + "/rooms/" + lvlRoom + "_wfixed.json"
if (!file_exists(fName2))
{
    fName2 = mod_folder("levels/") + level + "/rooms/" + lvlRoom + ".json"
    if (!file_exists(fName2))
        createtest = 1
}
if (createtest == 0)
{
    var jText2 = file_text_read_all(fName2)
    var pText2 = json_parse(jText2)
    pText2 = gml_Script_data_compatibility(pText2)
}
else
    pText2 = data
initStage(pText2)
if (!exists)
{
    saveData()
    saveData2()
    var rn = lvlRoom
    array_push(roomNameList, rn)
}
cam_x = 0
cam_y = 0
scroll_x = mouse_x
scroll_y = mouse_y
camScroll = [0, 0]
roomResize = [0, 0]
roomPreResize = [0, 0, 100, 100]
objFile = global.objectData
objFolders = objFile.folders
objFolderSelected = 0
objFolderOrder = objFile.order
for (i = 0; i < array_length(objFolderOrder); i++)
{
    var oF = _stGet("objFolders." + objFolderOrder[i])
    for (var j = 0; j < array_length(oF); j++)
    {
        var o = oF[j]
        if is_string(o)
        {
            _temp = j
            _stSet(("objFolders." + objFolderOrder[i] + "[_temp]"), asset_get_index(o))
        }
    }
}
objSelected = 517
objFlipX = 0
objFlipY = 0
windows_init()
w_scale = 2
_stSet("w_canvas.toolbar", _wCanvas(400, 48, "toolbar"))
_stSet("w_canvas.objFolders", _wCanvas(86, 324, "objFolders"))
_stSet("w_canvas.objFolders.gridSize", [86, 24])
_stSet("w_canvas.objGrid", _wCanvas(256, 200, "objGrid"))
_stSet("w_canvas.objGrid.gridSize", 36)
_stSet("w_canvas.objGrid.columns", 7)
struct_set(w_canvas.objGrid, [["surfaceScale", 0.5]])
_stSet("w_canvas.layerDisplay", _wCanvas(250, 48, "layerDisplay"))
_stSet("w_canvas.tilesetList", _wCanvas(100, 296, "tilesetList"))
_stSet("w_canvas.tileset", _wCanvas(256, 256, "tileset"))
windows_add_canvas((110 * array_length(global.tilesetData.order)), 14, "tilesetFolders")
windows_add_canvas(100, 32, "tilesetMode")
windows_add_canvas(32, 48, "autotileInd")
windows_add_canvas(48, 16, "autotileEditButton")
windows_add_canvas(320, 160, "autotileEditor")
var r = _wCanvas(90, 256, "rooms")
_stSet("w_canvas.rooms", r)
_stSet("w_canvas.bgs", _wCanvas(256, 180, "bgs"))
windows_add_canvas(200, 200, "bgPresetDropdown")
_stSet("w_canvas.settingTypes", _wCanvas(64, 32, "settingTypes"))
_stSet("w_canvas.settings", _wCanvas(300, 128, "settings"))
_stSet("w_canvas.instanceMenu", _wCanvas(256, 128, "instanceMenu"))
windows_add_canvas(100, 150, "valueDropdown")
wCanvas_open("toolbar", 10, 10)
wCanvas_open("layerDisplay", 10, 460)
windows_add_canvas(200, 200, "bigDropdown")
st_instances = 0
st_tiles = 1
st_backgrounds = 2
st_rooms = 3
st_settings = 4
st_save = 5
st_play = 6
st_edit = 7
st_resize = 8
function editorWindowUpdate(argument0) //gml_Script_editorWindowUpdate
{
    wCanvas_close("objFolders")
    wCanvas_close("objGrid")
    wCanvas_close("tilesetList")
    wCanvas_close("tileset")
    wCanvas_close("rooms")
    wCanvas_close("bgs")
    wCanvas_close("settingTypes")
    wCanvas_close("settings")
    wCanvas_close("instanceMenu")
    wCanvas_close("tilesetMode")
    wCanvas_close("tilesetFolders")
    wCanvas_close("autotileInd")
    wCanvas_close("autotileEditor")
    wCanvas_close("autotileEditButton")
    wCanvas_close("bgPresetDropdown")
    wCanvas_close("bigDropdown")
    if (argument0 == 1)
    {
    }
    switch editor_state
    {
        case st_instances:
            wCanvas_open("objFolders", 10, 68)
            wCanvas_open("objGrid", 96, 68)
            break
        case st_tiles:
            var sep = 8
            var tf = wCanvas_open("tilesetFolders", 10, (74 - sep))
            var tl = wCanvas_open("tilesetList", 10, (tf.y + tf.height + sep))
            struct_set(tl, [["sep", 24]])
            var fs = global.tilesetData.folders
            var sets = struct_get(fs, global.tilesetData.order[tilesetFolder])
            struct_set(tl, [["scrollBorders", [0, max((array_length(sets) * tl.sep - tl.height), 0)]]])
            struct_set(tl, [["scroll_y", tileset_listScroll]])
            var t = wCanvas_open("tileset", 110, (tf.y + tf.height + sep))
            struct_set(t, [["zoom", 1]])
            var ts = _tileset(tilesetSelected)
            if (array_length(ts.autotile) > 0)
            {
                var tOpt = ["Tileset", "Auto Tile"]
                var dd = wCanvas_open_dropdown("tilesetMode", t.x, (t.y + t.height), tOpt, tOpt[tileset_doAutoTile], "tilesetModeChanged")
                struct_set(dd, [["canExit", 0]])
            }
            if tileset_doAutoTile
            {
                var opts = []
                for (var i = 0; i < array_length(ts.autotile); i++)
                    opts[i] = i
                if (array_length(opts) > 1)
                {
                    var nd = wCanvas_open_dropdown("autotileInd", (dd.x + dd.width), dd.y, opts, tileset_autotileIndex, "autotileIndexChanged")
                    struct_set(nd, [["canExit", 0]])
                    if (!(gml_Script_array_value_exists(global.defaultTilesets, tilesetSelected)))
                        wCanvas_open("autotileEditButton", (nd.x + nd.width), nd.y)
                }
            }
            break
        case st_backgrounds:
            wCanvas_open("bgs", 10, 68)
            break
        case st_rooms:
            wCanvas_open("rooms", 10, 68)
            break
        case st_settings:
            wCanvas_open("settingTypes", 10, 68)
            wCanvas_open("settings", 74, 68)
            break
    }

}

if (!(variable_struct_exists(global.editorMemory, lvlRoom)))
    struct_set(global.editorMemory, [[lvlRoom, new_memoryVarStruct()]])
__mem = global.editorMemory
varStruct = _stGet("__mem." + lvlRoom)
var varsToSet = variable_struct_get_names(varStruct)
for (i = 0; i < array_length(varsToSet); i++)
    variable_instance_set(id, varsToSet[i], _stGet("varStruct." + varsToSet[i]))
tilesetFolder = clamp(tilesetFolder, 0, (array_length(global.tilesetData.order) - 1))
editorWindowUpdate()
doubleClickTimer = 0
selectingMode = 0
