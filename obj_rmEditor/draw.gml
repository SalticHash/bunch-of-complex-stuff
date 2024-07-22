// Not in mod, idk why it doesnt work
// triggers = {}
// for (var i = 0; i < array_length(data.instances); i++) {
//     inst = data.instances[i]
//     triggerid = inst.variables[$"trigger_id"]
//     if (triggerid == undefined)
//         continue
//     if (triggers[$triggerid] == undefined) {
//         triggers[$triggerid] = []
//     }
//     array_push(triggers[$triggerid], inst)
// }
// for (var i = 0; i < array_length(data.instances); i++) {

//     // NEW: load object id as number
//     inst = data.instances[i]
//     targetID = struct_get(inst.variables, "target_trigger_id")
//     instX = struct_get(inst.variables, "x")
//     instY = struct_get(inst.variables, "y")
//     if (targetID == undefined || instX == undefined || instY == undefined)
//         continue
//     for (var j = 0; j < array_length(triggers[targetID]); j++) {
//         targetInst = data.instances[j]
//         triggerID = struct_get(inst.variables, "trigger_id")
//         targetInstX = struct_get(inst.variables, "x")
//         targetInstY = struct_get(inst.variables, "y")
//         if (triggerID == undefined || targetInstX == undefined || targetInstY == undefined)
//             continue
//         var sx = (instX - cam_x) / camZoom * w_scale
//         var sy = (instY - cam_y) / camZoom * w_scale
//         var ex = (targetInstX - cam_x) / camZoom * w_scale
//         var ey = (targetInstY - cam_y) / camZoom * w_scale
//         draw_sprite_ext(_spr("square"), 0, sx, sy, 1, ((point_distance(sx, sy, ex, ey)) / 4), ((point_direction(sx, sy, ex, ey)) + 90), c_white, 0.5)

//     }
// }

draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_set_font(global.editorfont)
for (var i = 0; i < array_length(w_openCanvas); i++)
{
    var c = w_openCanvas[i]
    if (c.name != "screen")
    {
        _wCanvas_surfaceCheck(c)
        surface_set_target(c.surface)
        switch c.name
        {
            case "toolbar":
                var tools = 7
                var canEdit = 0
                if (editor_state == 0 || editor_state == 1)
                {
                    tools = 8
                    canEdit = 1
                }
                for (var j = 0; j < 8; j++)
                {
                    var xx = j * 50
                    var col = c_gray
                    if (editor_state == j || (j == st_edit && selectingMode))
                        col = c_white
                    if (j == st_edit && (!canEdit))
                        col = c_dkgray
                    draw_sprite_ext(_spr("toolbar_buttons"), 0, xx, 0, 1, 1, 0, col, 1)
                    col = c_silver
                    if (j < st_edit || canEdit)
                    {
                        if (toolbarHovering == j)
                            col = c_white
                    }
                    else
                        col = c_dkgray
                    draw_sprite_ext(_spr("toolbar_buttons"), (j + 1), xx, 0, 1, 1, 0, col, 1)
                }
                break
            case "objFolders":
                var ofNames = objFolderOrder
                var folderAmmo = array_length(ofNames)
                for (j = 0; j < folderAmmo; j++)
                {
                    draw_rectangle(0, (j * _stGet("w_canvas.objFolders.gridSize[1]")), (_stGet("w_canvas.objFolders.gridSize[0]") - 1), ((j + 1) * _stGet("w_canvas.objFolders.gridSize[1]") - 1), objFolderSelected != j)
                    draw_text(0, (j * _stGet("w_canvas.objFolders.gridSize[1]") + 3), ofNames[j])
                }
                editor_drawCanvasNotice(c, "Hold alt to select and edit objects\nPress X or Y to flip")
                break
            case "objGrid":
                var og = _stGet("w_canvas.objGrid")
                var folderNames = objFolderOrder
                var objs = _stGet("objFolders." + folderNames[objFolderSelected])
                for (j = 0; j < array_length(objs); j++)
                {
                    var sep = og.gridSize * 2
                    var columns = og.columns
                    xx = sep * (j % columns)
                    var yy = sep * (floor(j / columns))
                    draw_set_color(c_silver)
                    draw_set_alpha(0.5)
                    if (objs[j] == objSelected)
                        draw_set_alpha(1)
                    draw_rectangle(xx, yy, (xx + sep - 1), (yy + sep - 1), 0)
                    draw_set_color(c_gray)
                    draw_rectangle(xx, yy, (xx + sep - 1), (yy + sep - 1), 1)
                    draw_set_color(c_white)
                    draw_set_alpha(1)
                    var objSpr = object_get_sprite(objs[j])
                    if (!sprite_exists(objSpr))
                        objSpr = _spr("sprite_preview")
                    var sXoff = sprite_get_xoffset(objSpr)
                    var sYoff = sprite_get_yoffset(objSpr)
                    var sWidth = sprite_get_width(objSpr)
                    var sHeight = sprite_get_height(objSpr)
                    var sScale = 1
                    var maxLength = max(sWidth, sHeight)
                    var targetSize = 64
                    if (maxLength > targetSize)
                        sScale = targetSize / maxLength
                    draw_sprite_ext(objSpr, 0, (xx + sScale * sXoff + (sep - sWidth * sScale) / 2), (yy + sScale * sYoff + (sep - sHeight * sScale) / 2), sScale, sScale, 0, c_white, 1)
                }
                break
            case "layerDisplay":
                draw_text(4, 4, ("Instance layer: " + string(layer_instances)))
                var lbg = 10 - layer_background
                if (lbg > 10)
                    lbg = "(FG) " + (string(lbg - 10))
                draw_text(4, 30, ("BG Layer: " + string(lbg)))
                var lStr = string(10 - layer_tilemap)
                if (layer_tilemap <= -1)
                {
                    lStr = "(Top) " + string((-layer_tilemap))
                    if (layer_tilemap <= -5)
                        lStr = "(Secret) " + (string((-layer_tilemap) - 4))
                }
                draw_text(4, 16, ("Tile layer: " + lStr))
                editor_drawCanvasNotice(c, "Press left or right arrow keys to change layer")
                break
            case "tilesetFolders":
                var order = global.tilesetData.order
                var jx = 110
                for (j = 0; j < array_length(order); j++)
                {
                    draw_rectangle((jx * j), 0, (jx * (j + 1) - 1), (c.height - 1), tilesetFolder != j)
                    draw_set_halign(fa_center)
                    draw_text((jx * j + jx / 2), 1, order[j])
                    draw_set_halign(fa_left)
                }
                break
            case "tilesetList":
                order = global.tilesetData.order
                var sets = struct_get(global.tilesetData.folders, order[tilesetFolder])
                for (j = 0; j < array_length(sets); j++)
                {
                    var a = 0.9
                    var ts = _spr(sets[j])
                    xx = (current_time * 0.01) % (sprite_get_width(ts) - 64)
                    yy = (current_time * 0.01) % (sprite_get_height(ts) - c.sep)
                    xx = 0
                    yy = 0
                    var offs = global.tilesetData.previewOffset
                    if variable_struct_exists(offs, sets[j])
                    {
                        var off = struct_get(offs, sets[j])
                        xx = off[0] * 32
                        yy = off[1] * 32
                    }
                    draw_sprite_part_ext(ts, 0, xx, yy, 256, c.sep, 0, (j * c.sep), 1, 1, c_white, a)
                    if (sets[j] == tilesetSelected)
                    {
                        a = 1
                        draw_rectangle(1, (j * c.sep + 1), (c.width - 2), ((j + 1) * c.sep - 2), 1)
                        draw_rectangle(2, (j * c.sep + 2), (c.width - 3), ((j + 1) * c.sep - 3), 1)
                    }
                    var name = string_replace(sets[j], "tile_", "")
                    name = string_replace(name, "spr_", "")
                    name = string_replace(name, "sprite_", "")
                    draw_text(0, (j * c.sep + 1), name)
                }
                editor_drawCanvasNotice(c, "Hold alt to select tiles\nPress F to fill selected area")
                break
            case "tileset":
                var tileSprite = _spr(tilesetSelected)
                if ((!tileset_doAutoTile) || w_findCanvasIndex("autotileEditor") != -1)
                {
                    var tScale = c.zoom * tilesetStruct.scale
                    draw_sprite_ext(tileSprite, 0, (sprite_get_xoffset(tileSprite) * tScale), (sprite_get_yoffset(tileSprite) * tScale), tScale, tScale, 0, c_white, 1)
                    draw_set_alpha(0.75)
                    var w = tilesetStruct.size[0] * tScale
                    var h = tilesetStruct.size[1] * tScale
                    draw_rectangle((tilesetCoord[0] * w), (tilesetCoord[1] * h), ((tilesetCoord[0] + tilesetCoord[2]) * w - 1), ((tilesetCoord[1] + tilesetCoord[3]) * h - 1), 1)
                    draw_set_color(c_lime)
                    for (j = 1; j < array_length(tilesetCoord_spread); j++)
                        draw_rectangle((tilesetCoord_spread[j][0] * w), (tilesetCoord_spread[j][1] * h), ((tilesetCoord_spread[j][0] + tilesetCoord_spread[j][2]) * w - 1), ((tilesetCoord_spread[j][1] + tilesetCoord_spread[j][3]) * h - 1), 1)
                    draw_set_color(c_white)
                    draw_set_alpha(1)
                }
                else
                {
                    var atd = tilesetStruct.autotile[tileset_autotileIndex]
                    for (xx = 0; xx < 10; xx++)
                    {
                        for (yy = 0; yy < 5; yy++)
                            drawTile(tilesetSelected, atd[xx][yy], (xx * gridSize), (yy * gridSize))
                    }
                }
                break
            case "bgs":
                var optName = ["Sprite", "Panic Sprite", "X", "Y", "X Scroll", "Y Scroll", "X Repeat", "Y Repeat", "Hor. Speed", "Ver. Speed", "Anim. Speed", "Save BG Preset", "Delete"]
                var opts = ["sprite", "panic_sprite", "x", "y", "scroll_x", "scroll_y", "tile_x", "tile_y", "hspeed", "vspeed", "image_speed"]
                var bgStruct = _stGet("data.backgrounds." + string(layer_background))
                var dis = 14
                if (!is_undefined(bgStruct))
                {
                    for (j = 0; j < array_length(optName); j++)
                    {
                        yy = j * dis
                        draw_rectangle(0, yy, 600, (yy + dis - 1), (!(bgsHovering == j)))
                        var txt = optName[j]
                        draw_set_color(c_orange)
                        if (optName[j] == "Save BG Preset")
                            draw_set_color(c_lime)
                        if (j < array_length(opts))
                        {
                            _Temp = bgStruct
                            txt += (": " + (string(_stGet("_Temp." + opts[j]))))
                            if (opts[j] == "tile_x" || opts[j] == "tile_y")
                                txt = string_replace(string_replace(txt, "1", "On"), "0", "Off")
                            draw_set_color(c_white)
                        }
                        draw_text(0, (yy + 1), txt)
                        draw_set_color(c_white)
                    }
                }
                else
                {
                    yy = bgsHovering
                    if (bgsHovering != -1 && bgsHovering <= 1)
                        draw_rectangle(0, (yy * dis), 600, ((yy + 1) * dis - 1), 0)
                    draw_text(0, 1, "Add image on this BG layer")
                    draw_text(0, (1 + dis), "Load BG Preset")
                }
                break
            case "rooms":
                draw_sprite(_spr("ui_button"), 0, (_stGet("w_canvas.rooms.width") - 12), 2)
                for (j = 0; j < array_length(roomNameList); j++)
                {
                    draw_set_color(c_silver)
                    if (roomNameList[j] == lvlRoom)
                        draw_set_color(c_lime)
                    if (roomHovering == j)
                        draw_set_color(c_white)
                    draw_text(2, (j * 12), roomNameList[j])
                    draw_set_color(c_white)
                }
                break
            case "settingTypes":
                var rectY = 16 * settingsMode
                draw_rectangle(0, rectY, 100, (rectY + 16), 0)
                draw_text(0, 2, "Room")
                draw_text(0, 18, "Level")
                break
            case "settings":
                rectY = 16 * settingsHovering
                if (settingsHovering != -1)
                    draw_rectangle(0, rectY, 400, (rectY + 16), 0)
                var song = _stGet("data.properties.song")
                var combotimer = _stGet("data.properties.pausecombo")
                if variable_struct_exists(global.defaultSong_display, song)
                    song = struct_get(global.defaultSong_display, song)
                var stt = [("Song: " + song), ("Song transition time: " + string(_stGet("data.properties.songTransitionTime"))), ("Pause Combo Timer: " + string(combotimer)), "Resize room"]
                if (settingsMode == 1)
                {
                    stt = [("Level name: " + levelSettings.name), ("S rank score: " + string(levelSettings.pscore)), "Level type: Normal", ("Pizza Time limit: " + timeString_get_string(levelSettings.escape)), ("Titlecard sprite: " + levelSettings.titlecardSprite), ("Title text sprite: " + levelSettings.titleSprite), ("Title Jingle: " + levelSettings.titleSong)]
                    if levelSettings.isWorld
                        stt[2] = "Level type: Hub world"
                    if (settingsHovering >= 4 && levelSettings.titlecardSprite != "no titlecard")
                    {
                        surface_reset_target()
                        xx = c.x * w_scale
                        yy = (c.y + c.height) * w_scale + 6
                        draw_rectangle((xx - 4), (yy - 4), (xx + obj_screensizer.actual_width + 3), (yy + obj_screensizer.actual_height + 3), 0)
                        draw_set_color(c_black)
                        draw_rectangle(xx, yy, (xx + obj_screensizer.actual_width - 1), (yy + obj_screensizer.actual_height - 1), 0)
                        draw_set_color(c_white)
                        draw_sprite(_spr(levelSettings.titlecardSprite), 0, xx, yy)
                        var s = 1
                        draw_sprite(_spr(levelSettings.titleSprite), 0, (xx + 32 + (irandom_range((-s), s))), (yy + (irandom_range((-s), s))))
                        surface_set_target(c.surface)
                    }
                }
                if (stt[0] == "Song: ")
                    stt[0] = "Song: (not chosen)"
                for (j = 0; j < array_length(stt); j++)
                    draw_text(0, (2 + j * 16), stt[j])
                break
            case "instanceMenu":
                var ins = c.instance
                if (!instance_exists(ins))
                    break
                else
                {
                    var insData = _stGet("data.instances[" + string(ins.instID) + "]")

                    // NEW: Name and ID
                    instSelectedId = insData.object
                    instSelectedName = object_get_name(instSelectedId)
                    // NEW: end of NEW

                    var instVars = insData.variables
                    var varInfo = instance_getVarList(insData.object, insData, 1)
                    var varNames = varInfo[0]
                    draw_sprite(_spr("ui_button"), 0, 0, (16 + array_length(varNames) * 12))
                    for (j = 0; j < array_length(varNames); j++)
                    {
                        yy = 16 + j * 12
                        if (c.hovering == j)
                            draw_rectangle(0, yy, c.width, (yy + 12), 0)
                        draw_sprite(_spr("ui_button"), 1, (c.width - 24), (16 + j * 12))
                        var value = "-"
                        if variable_struct_exists(instVars, varNames[j])
                            value = struct_get(instVars, varNames[j])
                        var vname = varNames[j]
                        if is_array(varInfo[1][j])
                        {
                            if (array_length(varInfo[1][j]) > 2)
                            {
                                if variable_struct_exists(varInfo[1][j][2], "display")
                                    vname = struct_get(varInfo[1][j][2], "display")
                            }
                        }
                        draw_text(0, yy, (vname + ": " + string(value)))
                    }

                    // NEW: draw the bg for the name and id
                    draw_set_color(c_black)
                    draw_set_alpha(0.85)
                    draw_rectangle(0, c.scroll_y, c.width, c.scroll_y + 16, 0)
                    draw_set_alpha(1)
                    draw_set_color(c_white)
                    draw_text(14, c.scroll_y, fstring("{instSelectedName}: {instSelectedId}"))
                    // NEW: end of NEW

                    draw_sprite(_spr("ui_button"), 2, 0, c.scroll_y)

                    surface_reset_target()
                    var sx = (c.x + 2) * w_scale
                    var sy = (c.y + 2) * w_scale
                    var ex = ((ins.bbox_right + ins.bbox_left) / 2 - cam_x) / camZoom * w_scale
                    var ey = ((ins.bbox_bottom + ins.bbox_top) / 2 - cam_y) / camZoom * w_scale
                    draw_sprite_ext(_spr("square"), 0, sx, sy, 1, ((point_distance(sx, sy, ex, ey)) / 4), ((point_direction(sx, sy, ex, ey)) + 90), c_white, 0.5)
                    surface_set_target(c.surface)
                    break
                }
            case "autotileEditor":
                atd = tilesetStruct.autotile[tileset_autotileIndex]
                for (xx = 0; xx < 10; xx++)
                {
                    for (yy = 0; yy < 5; yy++)
                        drawTile(tilesetSelected, atd[xx][yy], (xx * gridSize), (yy * gridSize))
                }
                draw_set_alpha(0.25 + (dcos(current_time / 10)) * 0.5)
                draw_sprite(_spr("autotile_guide_stick"), 0, 0, 0)
                draw_set_alpha(1)
                break
            case "autotileEditButton":
                txt = "Edit"
                if (w_findCanvasIndex("autotileEditor") != -1)
                    txt = "Close"
                draw_text(2, 2, txt)
                break
        }

        surface_reset_target()
        wCanvas_draw(c, 0.5)
    }
}
var cpos = gml_Script_cursor_hud_position()
cursorX = cpos[0] * w_scale
cursorY = cpos[1] * w_scale
draw_sprite_ext(_spr("cursor"), cursorImage, cursorX, cursorY, 2, 2, 0, c_white, 1)
draw_set_alpha(0.7)
draw_text_transformed(cursorX, (cursorY + 24), cursorNotice, 2, 2, 0)
draw_set_alpha(1)
cursorNotice = ""
