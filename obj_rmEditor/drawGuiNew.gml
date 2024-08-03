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
                var tools = 9
                var canEdit = 0
                if (editor_state == 0 || editor_state == 1)
                {
                    tools = 10
                    canEdit = 1
                }
                for (var j = false; j < 11; j++)
                {
                    var xx = j * 50
                    var col = c_gray
                    if (editor_state == j || (j == st_edit && selectingMode))
                        col = c_white
                    if (j == st_edit && (!canEdit))
                        col = c_dkgray
                    draw_sprite_ext(_spr("toolbar_buttons"), 0, xx, 0, 1, 1, 0, col, 1)
                    col = c_silver
                    if (j != st_edit || canEdit)
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
                if (c.growx == ((c.x + c.width) * w_scale))
                {
                    var ofNames = objFolderOrder
                    var folderAmmo = array_length(ofNames)
                    for (j = false; j < folderAmmo; j++)
                    {
                        draw_rectangle(0, (j * _stGet("w_canvas.objFolders.gridSize[1]")), (_stGet("w_canvas.objFolders.gridSize[0]") - 1), ((j + 1) * _stGet("w_canvas.objFolders.gridSize[1]") - 1), objFolderSelected != j)
                        draw_text(0, (j * _stGet("w_canvas.objFolders.gridSize[1]") + 3), ofNames[j])
                    }
                    if (!instance_exists(obj_selectorobj))
                        editor_drawCanvasNotice(c, "Hold alt to select and edit objects\nPress X or Y to flip\nPress Ctrl and drag to select\nPress B to set an object's variables before placing")
                    else
                        editor_drawCanvasNotice(c, "Press Ctrl and drag to select\nPress C to copy selection\nPress V to paste copied selection\nPress K to delete objects in selection")
                }
                break
            case "objGrid":
                if (c.growx == ((c.x + c.width) * w_scale))
                {
                    var og = _stGet("w_canvas.objGrid")
                    var folderNames = objFolderOrder
                    var objs = _stGet("objFolders." + folderNames[objFolderSelected])
                    for (j = false; j < array_length(objs); j++)
                    {
                        var sep = og.gridSize * 2
                        var columns = og.columns
                        xx = sep * (j % columns)
                        var yy = sep * (floor(j / columns))
                        draw_set_color(c_silver)
                        draw_set_alpha(0.5)
                        if (objs[j] == objSelected)
                            draw_set_alpha(1)
                        draw_rectangle(xx, yy, (xx + sep - 1), (yy + sep - 1), false)
                        draw_set_color(c_gray)
                        draw_rectangle(xx, yy, (xx + sep - 1), (yy + sep - 1), true)
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
                }
                break
            case "layerDisplay":
                if (c.growx == ((c.x + c.width) * w_scale))
                {
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
                    else if (layer_tilemap > 10)
                        lStr = "(Unbreakable) " + (string(16 + layer_tilemap))
                    draw_text(4, 16, ("Tile layer: " + lStr))
                    editor_drawCanvasNotice(c, "Press left or right arrow keys to change layer")
                }
                break
            case "tilesetFolders":
                if (c.growx == ((c.x + c.width) * w_scale))
                {
                    var order = global.tilesetData.order
                    var jx = 110
                    for (j = false; j < array_length(order); j++)
                    {
                        draw_rectangle((jx * j), 0, (jx * (j + 1) - 1), (c.height - 1), tilesetFolder != j)
                        draw_set_halign(fa_center)
                        draw_text((jx * j + jx / 2), 1, order[j])
                        draw_set_halign(fa_left)
                    }
                }
                break
            case "tilesetList":
                if (c.growx == ((c.x + c.width) * w_scale))
                {
                    order = global.tilesetData.order
                    var sets = struct_get(global.tilesetData.folders, order[tilesetFolder])
                    for (j = false; j < array_length(sets); j++)
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
                            draw_rectangle(1, (j * c.sep + 1), (c.width - 2), ((j + 1) * c.sep - 2), true)
                            draw_rectangle(2, (j * c.sep + 2), (c.width - 3), ((j + 1) * c.sep - 3), true)
                        }
                        var name = string_replace(sets[j], "tile_", "")
                        name = string_replace(name, "spr_", "")
                        name = string_replace(name, "sprite_", "")
                        draw_text(0, (j * c.sep + 1), name)
                    }
                    editor_drawCanvasNotice(c, "Hold alt to select tiles\nPress F to fill selected area")
                }
                break
            case "tileset":
                if (c.growx == ((c.x + c.width) * w_scale))
                {
                    var tileSprite = _spr(tilesetSelected)
                    if ((!tileset_doAutoTile) || w_findCanvasIndex("autotileEditor") != -1)
                    {
                        var tScale = c.zoom * tilesetStruct.scale
                        draw_sprite_ext(tileSprite, 0, (sprite_get_xoffset(tileSprite) * tScale), (sprite_get_yoffset(tileSprite) * tScale), tScale, tScale, 0, c_white, 1)
                        draw_set_alpha(0.75)
                        var w = tilesetStruct.size[0] * tScale
                        var h = tilesetStruct.size[1] * tScale
                        draw_rectangle((tilesetCoord[0] * w), (tilesetCoord[1] * h), ((tilesetCoord[0] + tilesetCoord[2]) * w - 1), ((tilesetCoord[1] + tilesetCoord[3]) * h - 1), true)
                        draw_set_color(c_lime)
                        for (j = true; j < array_length(tilesetCoord_spread); j++)
                            draw_rectangle((tilesetCoord_spread[j][0] * w), (tilesetCoord_spread[j][1] * h), ((tilesetCoord_spread[j][0] + tilesetCoord_spread[j][2]) * w - 1), ((tilesetCoord_spread[j][1] + tilesetCoord_spread[j][3]) * h - 1), true)
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
                }
                break
            case "bgs":
                if (c.growx == ((c.x + c.width) * w_scale))
                {
                    var optName = ["Sprite", "Panic Sprite", "X", "Y", "X Scroll", "Y Scroll", "X Repeat", "Y Repeat", "Hor. Speed", "Ver. Speed", "Anim. Speed", "On Escape", "Show For Character", "Save BG Preset", "Delete"]
                    var opts = ["sprite", "panic_sprite", "x", "y", "scroll_x", "scroll_y", "tile_x", "tile_y", "hspeed", "vspeed", "image_speed", "escape", "character"]
                    var bgStruct = _stGet("data.backgrounds." + string(layer_background))
                    var dis = 14
                    if (!is_undefined(bgStruct))
                    {
                        for (j = false; j < array_length(optName); j++)
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
                                if (opts[j] != "escape" && opts[j] != "character")
                                    draw_set_color(c_white)
                                else
                                    draw_set_color(c_yellow)
                            }
                            draw_text(0, (yy + 1), txt)
                            draw_set_color(c_white)
                        }
                    }
                    else
                    {
                        yy = bgsHovering
                        if (bgsHovering != -1 && bgsHovering <= 1)
                            draw_rectangle(0, (yy * dis), 600, ((yy + 1) * dis - 1), false)
                        draw_text(0, 1, "Add image on this BG layer")
                        draw_text(0, (1 + dis), "Load BG Preset")
                    }
                }
                break
            case "rooms":
                if (c.growx == ((c.x + c.width) * w_scale))
                {
                    draw_sprite(_spr("ui_button"), 0, (_stGet("w_canvas.rooms.width") - 14), 2)
                    draw_sprite(_spr("ui_button"), 1, 2, 2)
                    if deletingRooms
                        draw_text(24, 2, "Delete Mode")
                    for (j = 0; j < array_length(roomNameList); j++)
                    {
                        draw_set_color(c_silver)
                        if (roomNameList[j] == lvlRoom)
                            draw_set_color(c_lime)
                        if (roomHovering == (j + 2))
                        {
                            if (!deletingRooms)
                                draw_set_color(c_white)
                            else
                                draw_set_color(c_orange)
                        }
                        draw_text(2, ((j + 2) * 12), roomNameList[j])
                        draw_set_color(c_white)
                    }
                }
                break
            case "debug":
                if (c.growx == ((c.x + c.width) * w_scale))
                {
                    var rectY = 16 * debugHovering
                    if (debugHovering != -1)
                        draw_rectangle(0, rectY, 300, (rectY + 16), false)
                    var debugList = [("Kill all rats: " + string(global.ratDeath)), ("Destroy transfo blocks: " + string(global.transfoBreak)), ("Enable Pizza Time: " + string(global.doPanic)), ("Give Supertaunt: " + string(global.setSupertaunt)), ("Starting Door: " + string(global.startingDoor)), ("Set State: " + string(global.startState)), ("Set Player Speed: " + string(global.startPlayerSpeed)), "Open Savestate", "Reload Asset Folder"]
                    draw_set_color(c_white)
                    for (j = 0; j < array_length(debugList); j++)
                        draw_text(0, (2 + j * 16), debugList[j])
                }
                break
            case "settingTypes":
                if (c.growx == ((c.x + c.width) * w_scale))
                {
                    rectY = 16 * settingsMode
                    draw_rectangle(0, rectY, 100, (rectY + 16), false)
                    draw_text(0, 2, "Room")
                    draw_text(0, 18, "Level")
                }
                break
            case "settings":
                if (c.growx == ((c.x + c.width) * w_scale))
                {
                    rectY = 16 * settingsHovering
                    if (settingsHovering != -1)
                        draw_rectangle(0, rectY, 400, (rectY + 16), false)
                    var song = _stGet("data.properties.song")
                    if variable_struct_exists(global.defaultSong_display, song)
                        song = struct_get(global.defaultSong_display, song)
                    var escapesong = levelSettings.escapeSong
                    if variable_struct_exists(global.defaultSong_display, escapesong)
                        escapesong = struct_get(global.defaultSong_display, escapesong)
                    var lap2song = levelSettings.lap2Song
                    if variable_struct_exists(global.defaultSong_display, lap2song)
                        lap2song = struct_get(global.defaultSong_display, lap2song)
                    var lap3song = levelSettings.lap3Song
                    if variable_struct_exists(global.defaultSong_display, lap3song)
                        lap3song = struct_get(global.defaultSong_display, lap3song)
                    var lap4song = levelSettings.lap4Song
                    if variable_struct_exists(global.defaultSong_display, lap4song)
                        lap4song = struct_get(global.defaultSong_display, lap4song)
                    var escapesongN = levelSettings.escapeSongN
                    if variable_struct_exists(global.defaultSong_display, escapesongN)
                        escapesongN = struct_get(global.defaultSong_display, escapesongN)
                    var lap2songN = levelSettings.lap2SongN
                    if variable_struct_exists(global.defaultSong_display, lap2songN)
                        lap2songN = struct_get(global.defaultSong_display, lap2songN)
                    var lap3songN = levelSettings.lap3SongN
                    if variable_struct_exists(global.defaultSong_display, lap3songN)
                        lap3songN = struct_get(global.defaultSong_display, lap3songN)
                    var lap4songN = levelSettings.lap4SongN
                    if variable_struct_exists(global.defaultSong_display, lap4songN)
                        lap4songN = struct_get(global.defaultSong_display, lap4songN)
                    var playtheme = levelSettings.escapePlay
                    var combotimer = _stGet("data.properties.pausecombo")
                    var stt = [("Song: " + song), ("Escape Song: " + escapesong), ("Lap 2 Song: " + lap2song), ("Lap 3 Song: " + lap3song), ("Lap 4 Song: " + lap4song), ("Noise Escape Song: " + escapesongN), ("Noise Lap 2 Song: " + lap2songN), ("Noise Lap 3 Song: " + lap3songN), ("Noise Lap 4 Song: " + lap4songN), ("Play Escape Theme: " + playtheme), ("Song transition time: " + string(_stGet("data.properties.songTransitionTime"))), ("Pause Combo Timer: " + string(combotimer)), "Resize room"]
                    if (settingsMode == 1)
                    {
                        stt = [("Level name: " + levelSettings.name), ("S rank score: " + string(levelSettings.pscore)), "Level type: Normal", ("Pizza Time limit: " + timeString_get_string(levelSettings.escape)), ("Final Escape: " + string(levelSettings.fescape)), ("Titlecard sprite: " + levelSettings.titlecardSprite), ("Title text sprite: " + levelSettings.titleSprite), ("Title Jingle: " + levelSettings.titleSong), ("Title Jingle Noise: " + levelSettings.titleSongN), "Add Titlecard Noise Heads"]
                        if (levelSettings.isWorld == 1)
                            stt[2] = "Level type: Hub world"
                        else if (levelSettings.isWorld == 2)
                            stt[2] = "Level type: Tutorial"
                        else if (levelSettings.isWorld == 3)
                            stt[2] = "Level type: SotW"
                        if (levelSettings.fescape == 1)
                            stt[4] = "Final Escape: True"
                        else if (levelSettings.fescape == 0)
                            stt[4] = "Final Escape: False"
                        if (settingsHovering >= 4 && levelSettings.titlecardSprite != "no titlecard")
                        {
                            surface_reset_target()
                            xx = c.x * w_scale
                            yy = (c.y + c.height) * w_scale + 6
                            draw_rectangle((xx - 4), (yy - 4), (xx + obj_screensizer.actual_width + 3), (yy + obj_screensizer.actual_height + 3), false)
                            draw_set_color(c_black)
                            draw_rectangle(xx, yy, (xx + obj_screensizer.actual_width - 1), (yy + obj_screensizer.actual_height - 1), false)
                            draw_set_color(c_white)
                            draw_sprite(_spr(levelSettings.titlecardSprite), 0, xx, yy)
                            var s = 1
                            draw_sprite(_spr(levelSettings.titleSprite), 0, (xx + 32 + (irandom_range((-s), s))), (yy + (irandom_range((-s), s))))
                            surface_set_target(c.surface)
                        }
                    }
                    if (stt[0] == "Song: ")
                        stt[0] = "Song: (not chosen)"
                    if (stt[1] == "Escape Song: ")
                        stt[1] = "Escape Song: (not chosen)"
                    if (stt[2] == "Lap 2 Song: ")
                        stt[2] = "Lap 2 Song: (not chosen)"
                    if (stt[3] == "Lap 3 Song: ")
                        stt[3] = "Lap 3 Song: (not chosen)"
                    if (stt[4] == "Lap 4 Song: ")
                        stt[4] = "Lap 4 Song: (not chosen)"
                    if (stt[5] == "Noise Escape Song: ")
                        stt[5] = "Noise Escape Song: (not chosen)"
                    if (stt[6] == "Noise Lap 2 Song: ")
                        stt[6] = "Noise Lap 2 Song: (not chosen)"
                    if (stt[7] == "Noise Lap 3 Song: ")
                        stt[7] = "Noise Lap 3 Song: (not chosen)"
                    if (stt[8] == "Noise Lap 4 Song: ")
                        stt[8] = "Noise Lap 4 Song: (not chosen)"
                    for (j = 0; j < array_length(stt); j++)
                        draw_text(0, (2 + j * 16), stt[j])
                }
                break
            case "editorSettings":
                if (c.growx == ((c.x + c.width) * w_scale))
                {
                    rectY = 16 * settingsHovering
                    draw_rectangle(0, rectY, 400, (rectY + 16), false)
                    ini_open("EditorSettings.ini")
                    var editorstyle = ini_read_string("Editor", "style", "New Default")
                    var editorsong = ini_read_string("Editor", "music", "")
                    if variable_struct_exists(global.defaultSong_display, editorsong)
                        editorsong = struct_get(global.defaultSong_display, editorsong)
                    var showtrails = ini_read_string("Editor", "showtrails", "True")
                    var windowstyle = ini_read_string("Editor", "windowstyle", "Fancy")
                    ini_close()
                    stt = [("Editor Style: " + editorstyle), ("Editor Song: " + editorsong), ("Player Trails: " + showtrails), ("Window Style: " + windowstyle)]
                    if (stt[1] == "Editor Song: ")
                        stt[1] = "Editor Song: (not chosen)"
                    for (j = 0; j < array_length(stt); j++)
                        draw_text(0, (2 + j * 16), stt[j])
                }
                break
            case "instanceMenu":
                if (c.growx == ((c.x + c.width) * w_scale))
                {
                    var ins = c.instance
                    if (!instance_exists(ins))
                        break
                    else
                    {
                        if (!preset)
                        {
                            var insData = _stGet("data.instances[" + string(ins.instID) + "]")
                            var instVars = insData.variables
                            var varInfo = instance_getVarList(insData.object, insData, 1)
                        }
                        else
                        {
                            insData = variable_instance_get(1227, "values")
                            instVars = insData.variables
                            varInfo = instance_getVarList(objSelected, insData, 1)
                        }
                        var varNames = varInfo[0]
                        
                        // NEW: Name and ID
                        instSelectedId = insData.object
                        instSelectedName = object_get_name(instSelectedId)
                        // NEW: end of NEW

                        for (j = 0; j < array_length(varNames); j++)
                        {
                            yy = 16 + j * 16 // New spacing

                            // NEW: alternating bg
                            if (j % 2 == 1) {
                                draw_set_color(c_black)
                                draw_set_alpha(0.25)
                                draw_rectangle(0, yy, c.width, yy + 15, 0)
                                draw_set_alpha(1)
                                draw_set_color(c_white)
                            }
                            // NEW: end of NEW

                            if (c.hovering == j)
                                draw_rectangle(0, yy, c.width, (yy + 15), 0)
                            
                            draw_sprite(_spr("ui_button"), 1, (c.width - 20), yy + 2) // NEW: Added the +2 for centering

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

                            draw_text(2, yy + 2, (vname + ": " + string(value)))
                        }

                        // NEW: draw the bg for the name and id
                        draw_set_color(c_black)
                        draw_set_alpha(0.85)
                        draw_rectangle(0, c.scroll_y, c.width, c.scroll_y + 15, 0)

                        draw_rectangle(0, c.scroll_y + (c.height - 16), c.width, c.scroll_y + (c.height), 0)

                        
                        draw_set_alpha(1)
                        draw_set_color(c_white)
                        draw_text(16, c.scroll_y + 2, fstring("{instSelectedName}: {instSelectedId}"))

                        draw_sprite(_spr("ui_button"), 2, 2, c.scroll_y + 2)

                        draw_sprite(_spr("ui_button"), 0, 2, c.scroll_y + (c.height - 14))
                        draw_text(16, c.scroll_y + (c.height - 14), "Add")
                        // NEW: end of NEW


                        surface_reset_target()
                        var sx = (c.x + 2) * w_scale
                        var sy = (c.y + 2) * w_scale
                        var ex = ((ins.bbox_right + ins.bbox_left) / 2 - cam_x) / camZoom * w_scale
                        var ey = ((ins.bbox_bottom + ins.bbox_top) / 2 - cam_y) / camZoom * w_scale
                        draw_sprite_ext(_spr("square"), 0, sx, sy, 1, ((point_distance(sx, sy, ex, ey)) / 4), ((point_direction(sx, sy, ex, ey)) + 90), c_white, 0.5)
                        surface_set_target(c.surface)
                        break
                    }
                }
                else
                    break
            case "autotileEditor":
                if (c.growx == ((c.x + c.width) * w_scale))
                {
                    atd = tilesetStruct.autotile[tileset_autotileIndex]
                    for (xx = 0; xx < 10; xx++)
                    {
                        for (yy = 0; yy < 5; yy++)
                            drawTile(tilesetSelected, atd[xx][yy], (xx * gridSize), (yy * gridSize))
                    }
                    draw_set_alpha(0.25 + (dcos(current_time / 10)) * 0.5)
                    draw_sprite(_spr("autotile_guide_stick"), 0, 0, 0)
                    draw_set_alpha(1)
                }
                break
            case "autotileEditButton":
                if (c.growx == ((c.x + c.width) * w_scale))
                {
                    txt = "Edit"
                    if (w_findCanvasIndex("autotileEditor") != -1)
                        txt = "Close"
                    draw_text(2, 2, txt)
                }
                break
            case "noiseheads":
                draw_sprite_ext(_spr(levelSettings.titlecardSprite), 0, 0, 0, cscale, cscale, 0, c_white, 1)
                for (j = false; j < array_length(levelSettings.noiseHeads); j++)
                {
                    xx = (struct_get(levelSettings.noiseHeads[j], "x")) * cscale
                    yy = (struct_get(levelSettings.noiseHeads[j], "y")) * cscale
                    var scale = (struct_get(levelSettings.noiseHeads[j], "scale")) * cscale
                    draw_sprite_ext(spr_titlecard_noise, currnoisehead, xx, yy, scale, scale, 0, c_white, 1)
                }
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
