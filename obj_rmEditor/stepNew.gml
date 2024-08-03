global.currentsavefile = 10
global.globalRoomNames = roomNameList
if (!lockCursorMode)
{
    cursorMode = 0
    if (keyboard_check(vk_alt) || keyboard_check(ord("R")) || selectingMode)
        cursorMode = 1
}
cursorImage = 0
if (doubleClickTimer > 0)
    doubleClickTimer--
var updateUndo = (mouse_check_button_pressed(mb_left) ? true : (mouse_check_button_pressed(mb_right) ? true : (keyboard_check_pressed(ord("F")) ? true : keyboard_check_pressed(vk_backspace))))
if (updateUndo && (!inVarMenu))
{
    prevData = json_stringify(data)
    updateUndoMemory = 1
}
var zoomChange = 0
var onGridPos = [((floor(mouse_x / gridSize)) * gridSize), ((floor(mouse_y / gridSize)) * gridSize), ((round(mouse_x / gridSize)) * gridSize), ((round(mouse_y / gridSize)) * gridSize)]
if (w_isOnCanvas(w_openCanvas[0], (cursorX / w_scale), (cursorY / w_scale)) && (!inVarMenu))
{
    switch editor_state
    {
        case st_instances:
            switch cursorMode
            {
                case 0:
                    var objSpr = object_get_sprite(objSelected)
                    objFlipX += keyboard_check_pressed(ord("X"))
                    objFlipY += keyboard_check_pressed(ord("Y"))
                    objFlipX %= 2
                    objFlipY %= 2
                    var absorber = noone
                    var candidates = ds_list_create()
                    collision_circle_list(mouse_x, mouse_y, 16, 1216, 1, 1, candidates, 1)
                    for (var j = 0; j < ds_list_size(candidates); j++)
                    {
                        if (absorber == noone)
                        {
                            var cand = ds_list_find_value(candidates, j)
                            if (layer_instances == _stGet("data.instances[" + string(cand.instID) + "].layer"))
                            {
                                if gml_Script_array_value_exists(variable_struct_get_names(global.objectData.questionBlocks), object_get_name(_stGet("data.instances[" + string(cand.instID) + "].object")))
                                    absorber = cand
                            }
                        }
                    }
                    if (absorber == noone)
                    {
                        x = onGridPos[0]
                        y = onGridPos[1]
                        if object_compareToList(objSelected, global.objectData.snapToGround)
                        {
                            y += (sprite_get_yoffset(objSpr) - sprite_get_bbox_bottom(objSpr) + gridSize)
                            objSpr = object_get_sprite(objSelected)
                            var objOff = sprite_get_yoffset(objSpr)
                            var objBord = [sprite_get_bbox_top(objSpr), sprite_get_bbox_bottom(objSpr)]
                            var colls = ds_list_create()
                            collision_rectangle_list((x - gridSize / 2), (y - objOff + objBord[0]), (x + gridSize / 2), (y - objOff + objBord[1]), 1216, 1, 1, colls, 1)
                            for (var i = 0; i < ds_list_size(colls); i++)
                            {
                                var cInst = ds_list_find_value(colls, i)
                                repeat (4)
                                {
                                    if (collision_rectangle((x - gridSize / 2), (y - objOff + objBord[0]), (x + gridSize / 2), (y - objOff + objBord[1]), cInst, 1, 1) != -4)
                                    {
                                        var si = string(cInst.instID)
                                        var o = _stGet("data.instances[" + si + "].object")
                                        if object_compareToList(o, ["obj_solid", "obj_platform"])
                                            y -= 0.5
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        var targetx = (absorber.bbox_right + absorber.bbox_left) / 2 + sprite_get_xoffset(objSpr) - (sprite_get_bbox_left(objSpr) + sprite_get_bbox_right(objSpr)) / 2
                        var targety = (absorber.bbox_bottom + absorber.bbox_top) / 2 + sprite_get_yoffset(objSpr) - (sprite_get_bbox_top(objSpr) + sprite_get_bbox_bottom(objSpr)) / 2
                        x += ((targetx - x) / 6)
                        y += ((targety - y) / 6)
                        instOn = absorber
                    }
                    if (keyboard_check_pressed(ord("B")) && (!inMenu))
                    {
                        if (!instance_exists(obj_varstorage))
                        {
                            with (instance_create(x, y, obj_varstorage))
                            {
                                values = struct_new([["variables", struct_new()], ["object", 1227]])
                                absorberList = []
                            }
                        }
                        var c = wCanvas_open("instanceMenu", clamp((cursorX / w_scale), 100, (obj_screensizer.actual_width - 300)), clamp((cursorY / w_scale - 64), 100, (obj_screensizer.actual_height - 200)))
                        struct_set(c, [["instance", 1227]])
                        struct_set(c, [["hovering", -1]])
                        preset = 1
                        inMenu = 1
                    }
                    if (keyboard_check_pressed(ord("G")) && (!inMenu) && (!inVarMenu))
                    {
                        show_message(string(objSelected) + ", " + object_get_name(objSelected))
                        array_push(objFolders.Custom, object_get_name(objSelected))
                        show_message(struct_get(global.objectData.folders, "Custom"))
                        gml_Script_json_save(global.objectData, objDataPath())
                        show_message("Pass 3")
                    }
                    if keyboard_check(vk_shift)
                    {
                        x = mouse_x
                        y = mouse_y
                        if keyboard_check(vk_control)
                        {
                            objSpr = object_get_sprite(objSelected)
                            objOff = sprite_get_yoffset(objSpr)
                            objBord = [sprite_get_bbox_top(objSpr), sprite_get_bbox_bottom(objSpr)]
                            cInst = collision_rectangle((x - gridSize / 2), (y - objOff + objBord[0]), (x + gridSize / 2), (y - objOff + objBord[1]), obj_editorInst, 1, 1)
                            if (cInst != noone)
                            {
                                _temp = cInst.instID
                                o = _stGet("data.instances[_temp].object")
                                if (object_get_parent(o) == 574 || o == obj_solid)
                                {
                                    while (collision_rectangle((x - gridSize / 2), (y - objOff + objBord[0]), (x + gridSize / 2), (y - objOff + objBord[1]), cInst, 1, 1) != -4)
                                        y--
                                }
                            }
                        }
                    }
                    if (absorber == noone)
                    {
                        if (mouse_check_button(mb_left) && (onGridPos[0] != prevGridPos[0] || onGridPos[1] != prevGridPos[1]))
                        {
                            if instance_exists(obj_selectorobj)
                            {
                                instance_destroy(obj_selectorobj)
                                ds_list_destroy(obj_savesystem.selectionList)
                                ds_list_destroy(obj_savesystem.instanceIDList)
                                obj_savesystem.selectionList = ds_list_create()
                                obj_savesystem.instanceIDList = ds_list_create()
                            }
                            if (objSelected == obj_exitgate)
                                addInst(868, (x - 16), (y + 96))
                            o = addInst(objSelected, x, y, [])
                            inst_setVar(o.instID, "flipX", objFlipX)
                            inst_setVar(o.instID, "flipY", objFlipY)
                            if instance_exists(obj_varstorage)
                            {
                                var storedStructNames = variable_struct_get_names(obj_varstorage.values.variables)
                                for (k = 0; k < array_length(storedStructNames); k++)
                                {
                                    var storedStructVal = variable_struct_get(obj_varstorage.values.variables, storedStructNames[k])
                                    inst_setVar(o.instID, storedStructNames[k], storedStructVal)
                                }
                            }
                            instance_update_variables(o, _stGet("data.instances[" + string(o.instID) + "]"))
                        }
                    }
                    else if mouse_check_button_pressed(mb_left)
                    {
                        var abName = struct_get(global.objectData.questionBlocks, object_get_name(_stGet("data.instances[" + string(absorber.instID) + "].object")))
                        if instance_exists(obj_varstorage)
                        {
                            storedStructNames = variable_struct_get_names(obj_varstorage.values.variables)
                            array_push(obj_varstorage.absorberList, objSelected)
                            for (k = 0; k < array_length(storedStructNames); k++)
                            {
                                storedStructVal = variable_struct_get(obj_varstorage.values.variables, storedStructNames[k])
                                array_push(obj_varstorage.absorberList, struct_new([[storedStructNames[k], storedStructVal]]))
                            }
                            inst_setVar(absorber.instID, abName, obj_varstorage.absorberList)
                        }
                        else
                            inst_setVar(absorber.instID, abName, object_get_name(objSelected))
                        instance_update_variables(absorber, _stGet("data.instances[" + string(absorber.instID) + "]"))
                    }
                    cursorImage = 0
                    if mouse_check_button(mb_right)
                    {
                        if instance_exists(obj_selectorobj)
                        {
                            instance_destroy(obj_selectorobj)
                            ds_list_destroy(obj_savesystem.selectionList)
                            ds_list_destroy(obj_savesystem.instanceIDList)
                            obj_savesystem.selectionList = ds_list_create()
                            obj_savesystem.instanceIDList = ds_list_create()
                        }
                        var delList = ds_list_create()
                        var del = collision_point_list(mouse_x, mouse_y, 1216, 1, 1, delList, 1)
                        var foundIt = 0
                        cursorImage = 6
                        for (i = 0; i < ds_list_size(delList); i++)
                        {
                            if (!foundIt)
                            {
                                var delInst = ds_list_find_value(delList, i)
                                _temp = delInst.instID
                                if (layer_instances == _stGet("data.instances[_temp].layer"))
                                {
                                    _stSet("data.instances[_temp].deleted", 1)
                                    ds_stack_push(deletedIndexes, delInst.instID)
                                    instance_destroy(delInst)
                                    foundIt = 1
                                }
                            }
                        }
                    }
                    if keyboard_check(vk_control)
                    {
                        if (checkSelector == 0 && instance_exists(obj_selectorobj))
                            instance_destroy(obj_selectorobj)
                        checkSelector = 1
                        if (!instance_exists(obj_selectorobj))
                        {
                            with (instance_create(mouse_x, mouse_y, obj_selectorobj))
                                depth = -999
                            initialX = mouse_x
                            initialY = mouse_y
                        }
                        if instance_exists(obj_selectorobj)
                        {
                            obj_selectorobj.image_xscale = (-(((initialX - (mouse_x - 1)) / 32)))
                            obj_selectorobj.image_yscale = (-(((initialY - (mouse_y - 1)) / 32)))
                        }
                    }
                    break
                case 1:
                    cursorImage = 5
                    if mouse_check_button_released(mb_left)
                        doubleClickTimer = 20
                    if (!instance_exists(instSelected))
                        updateStretch = 1
                    if (!updateStretch)
                    {
                        o = instSelected
                        var anchor = [0, 0]
                        var growPos = [0, 0]
                        var sprSize = [sprite_get_width(o.sprite_index), sprite_get_height(o.sprite_index)]
                        var sprOff = [sprite_get_xoffset(o.sprite_index), sprite_get_yoffset(o.sprite_index)]
                        var spacePos = gridSize
                        var spaceX = sprSize[0]
                        var spaceY = sprSize[1]
                        if keyboard_check(vk_shift)
                        {
                            spacePos = 1
                            spaceX = 1
                            spaceY = 1
                        }
                        if (cursorStretch[0] == -1)
                        {
                            anchor[0] = selCarry[0] + ((-sprOff[0]) + sprSize[0]) * selCarry[2]
                            growPos = [(round((mouse_x - anchor[0]) / spaceX)) * spaceX]
                            var finalXScale = abs(growPos[0]) / sprSize[0]
                            o.image_xscale = finalXScale
                            o.x = anchor[0] + growPos[0] + sprOff[0] * finalXScale
                        }
                        else if (cursorStretch[0] == 1)
                        {
                            anchor[0] = selCarry[0] + (-sprOff[0]) * selCarry[2]
                            growPos = [(round((mouse_x - anchor[0]) / spaceX)) * spaceX]
                            finalXScale = growPos[0] / sprSize[0]
                            o.image_xscale = finalXScale
                            o.x = anchor[0] + sprOff[0] * finalXScale
                        }
                        if (cursorStretch[1] == -1)
                        {
                            anchor[1] = selCarry[1] + ((-sprOff[1]) + sprSize[1]) * selCarry[3]
                            growPos = (round((mouse_y - anchor[1]) / spaceY)) * spaceY
                            var finalYScale = abs(growPos) / sprSize[1]
                            o.image_yscale = finalYScale
                            o.y = anchor[1] + growPos + sprOff[1] * finalYScale
                        }
                        else if (cursorStretch[1] == 1)
                        {
                            anchor[1] = selCarry[1] + (-sprOff[1]) * selCarry[3]
                            growPos = (round((mouse_y - anchor[1]) / spaceY)) * spaceY
                            finalYScale = growPos / sprSize[1]
                            o.image_yscale = finalYScale
                            o.y = anchor[1] + sprOff[1] * finalYScale
                        }
                        if (cursorStretch[0] == 0 && cursorStretch[1] == 0)
                        {
                            o.x = selCarry[0] + (floor((mouse_x - selCarry[4]) / spacePos)) * spacePos
                            o.y = selCarry[1] + (floor((mouse_y - selCarry[5]) / spacePos)) * spacePos
                        }
                        inst_setVar(o.instID, "image_xscale", abs(o.image_xscale))
                        inst_setVar(o.instID, "image_yscale", abs(o.image_yscale))
                        inst_setVar(o.instID, "x", o.x)
                        inst_setVar(o.instID, "y", o.y)
                        instance_update_variables(o, _stGet("data.instances[" + string(o.instID) + "]"))
                        if (!mouse_check_button(mb_left))
                        {
                            updateStretch = 1
                            instSelected = -4
                            lockCursorMode = 0
                        }
                    }
                    var stretchDir = array_duplicate(cursorStretch)
                    var insList = ds_list_create()
                    var insNum = collision_circle_list(mouse_x, mouse_y, 600, 1216, 1, 1, insList, 1)
                    var onIns = noone
                    var isOn = 0
                    for (i = 0; i < insNum; i++)
                    {
                        var ins = ds_list_find_value(insList, i)
                        _temp = ins.instID
                        if (onIns == noone && _stGet("data.instances[_temp].layer") == layer_instances)
                        {
                            with (ins)
                            {
                                var bbLeft = x - sprite_get_xoffset(sprite_index) * image_xscale
                                var bbRight = x + ((-sprite_get_xoffset(sprite_index)) + sprite_get_width(sprite_index)) * image_xscale
                                var bbTop = y - sprite_get_yoffset(sprite_index) * image_yscale
                                var bbBottom = y + ((-sprite_get_yoffset(sprite_index)) + sprite_get_height(sprite_index)) * image_yscale
                                var off = 10
                                if (mouse_x > (bbLeft - off) && mouse_x < (bbRight + off) && mouse_y > (bbTop - off) && mouse_y < (bbBottom + off))
                                    isOn = 1
                            }
                            if isOn
                                onIns = ds_list_find_value(insList, i)
                        }
                    }
                    instOn = onIns
                    if (onIns != noone)
                    {
                        cursorNotice = "Double click to edit variables\nPress X/Y to flip"
                        if (keyboard_check_pressed(ord("V")) || (mouse_check_button_pressed(mb_left) && doubleClickTimer > 0))
                        {
                            if (w_findCanvasIndex("instanceMenu") != -1)
                            {
                                w_openCanvas[w_findCanvasIndex("instanceMenu")].quickerase = 1
                                wCanvas_close("instanceMenu")
                            }
                            c = wCanvas_open("instanceMenu", clamp((cursorX / w_scale), 100, (obj_screensizer.actual_width - 300)), clamp((cursorY / w_scale - 64), 100, (obj_screensizer.actual_height - 200)))
                            struct_set(c, [["instance", onIns]])
                            struct_set(c, [["hovering", -1]])
                        }
                        if keyboard_check_pressed(ord("X"))
                        {
                            _stSet(("data.instances[" + string(onIns.instID) + "].variables.flipX"), (!onIns.flipX))
                            onIns.flipX = (!onIns.flipX)
                        }
                        if keyboard_check_pressed(ord("Y"))
                        {
                            _stSet(("data.instances[" + string(onIns.instID) + "].variables.flipY"), (!onIns.flipY))
                            onIns.flipY = (!onIns.flipY)
                        }
                        instance_update_variables(onIns, _stGet("data.instances[" + string(onIns.instID) + "]"))
                        if updateStretch
                        {
                            stretchDir = [0, 0]
                            off = 8
                            var insSpr = onIns.sprite_index
                            bbLeft = onIns.x - sprite_get_xoffset(insSpr) * onIns.image_xscale
                            bbRight = onIns.x + ((-sprite_get_xoffset(insSpr)) + sprite_get_width(insSpr)) * onIns.image_xscale
                            bbTop = onIns.y - sprite_get_yoffset(insSpr) * onIns.image_yscale
                            bbBottom = onIns.y + ((-sprite_get_yoffset(insSpr)) + sprite_get_height(insSpr)) * onIns.image_yscale
                            if (mouse_x < (bbLeft + off))
                                stretchDir[0] = -1
                            else if (mouse_x > (bbRight - off))
                                stretchDir[0] = 1
                            if (mouse_y < (bbTop + off))
                                stretchDir[1] = -1
                            else if (mouse_y > (bbBottom - off))
                                stretchDir[1] = 1
                            cursorStretch = array_duplicate(stretchDir)
                        }
                        if mouse_check_button_pressed(mb_left)
                        {
                            updateStretch = 0
                            instSelected = onIns
                            selCarry = [onIns.x, onIns.y, onIns.image_xscale, onIns.image_yscale, mouse_x, mouse_y]
                            lockCursorMode = 1
                        }
                    }
                    if (onIns != noone || (!updateStretch))
                    {
                        if (abs(stretchDir[0]) == 1)
                            cursorImage = 3
                        if (abs(stretchDir[1]) == 1)
                            cursorImage = 1
                        if (abs(stretchDir[0]) == abs(stretchDir[1]))
                        {
                            if (stretchDir[0] == stretchDir[1])
                                cursorImage = 4
                            else
                                cursorImage = 2
                        }
                        if (stretchDir[0] == 0 && stretchDir[1] == 0)
                            cursorImage = 5
                    }
                    break
                case 2:
                    break
            }

            break
        case st_tiles:
            x = onGridPos[0]
            y = onGridPos[1]
            var xPlace = x - 2 * _stGet("data.properties.roomX")
            var yPlace = y - 2 * _stGet("data.properties.roomY")
            switch cursorMode
            {
                case 0:
                    var act = 0
                    if (mouse_check_button(mb_left) && (onGridPos[0] != prevGridPos[0] || onGridPos[1] != prevGridPos[1]))
                    {
                        act = 1
                        if tileset_doAutoTile
                            act = 3
                    }
                    if mouse_check_button(mb_right)
                    {
                        cursorImage = 6
                        if (onGridPos[0] != prevGridPos[0] || onGridPos[1] != prevGridPos[1])
                        {
                            act = 2
                            if tileset_doAutoTile
                                act = 4
                        }
                    }
                    if (keyboard_check_pressed(ord("X")) && tilesetCoord[2] == 1 && tilesetCoord[3] == 1)
                        tileFlipX = (-tileFlipX)
                    if (keyboard_check_pressed(ord("Y")) && tilesetCoord[2] == 1 && tilesetCoord[3] == 1)
                        tileFlipY = (-tileFlipY)
                    if (act != 0 && act < 3)
                    {
                        for (var tX = 0; tX < tilesetCoord[2]; tX++)
                        {
                            for (var tY = 0; tY < tilesetCoord[3]; tY++)
                            {
                                if (act == 1)
                                {
                                    var coords = [(tilesetCoord[0] + tX), (tilesetCoord[1] + tY)]
                                    addTile(tilesetSelected, coords, (x + tilesetStruct.size[0] * tX), (y + tilesetStruct.size[1] * tY), 0, tileFlipX, tileFlipY)
                                }
                                else
                                    deleteTile((x + tilesetStruct.size[0] * tX), (y + tilesetStruct.size[1] * tY))
                            }
                        }
                    }
                    else if (act >= 3)
                    {
                        x -= gridSize
                        y -= gridSize
                        editor_autotile(act == 3, 2, 2)
                        x += gridSize
                        y += gridSize
                    }
                    tile_selection_made = 0
                    tile_selection = [0, 0, 0, 0, 0, 0]
                    break
                case 1:
                    if (!tile_selection_made)
                    {
                        if mouse_check_button_pressed(mb_left)
                        {
                            lockCursorMode = 1
                            tile_selection = [xPlace, yPlace, 0, 0, x, y]
                        }
                        if mouse_check_button(mb_left)
                        {
                            tile_selection[2] = xPlace - tile_selection[0]
                            tile_selection[3] = yPlace - tile_selection[1]
                        }
                        if mouse_check_button_released(mb_left)
                        {
                            if (tile_selection[2] < 0)
                            {
                                tile_selection[2] *= -1
                                tile_selection[0] -= tile_selection[2]
                                tile_selection[4] -= tile_selection[2]
                            }
                            if (tile_selection[3] < 0)
                            {
                                tile_selection[3] *= -1
                                tile_selection[1] -= tile_selection[3]
                                tile_selection[5] -= tile_selection[3]
                            }
                            updateTileSelectionKeys()
                            tile_selection_made = 1
                        }
                    }
                    else
                    {
                        var isInArea = (xPlace >= tile_selection[0] && xPlace <= (tile_selection[0] + tile_selection[2]) && yPlace >= tile_selection[1] && yPlace <= (tile_selection[1] + tile_selection[3]))
                        if mouse_check_button_pressed(mb_left)
                        {
                            if isInArea
                            {
                                tile_selection_move_origin = [xPlace, yPlace, x, y]
                                tile_selection_moving = 1
                            }
                        }
                        if mouse_check_button_released(mb_left)
                        {
                            if tile_selection_moving
                            {
                                var xMove = xPlace - tile_selection_move_origin[0]
                                var yMove = yPlace - tile_selection_move_origin[1]
                                for (i = 0; i < array_length(tile_selection_keys); i++)
                                    deleteTile(tile_selection_keys[i][0][0], tile_selection_keys[i][0][1])
                                for (i = 0; i < array_length(tile_selection_keys); i++)
                                {
                                    var ogPos = [tile_selection_keys[i][0][0], tile_selection_keys[i][0][1]]
                                    addTile(tile_selection_keys[i][2], tile_selection_keys[i][1], (ogPos[0] + xMove), (ogPos[1] + yMove))
                                }
                                tile_selection[0] += xMove
                                tile_selection[4] += xMove
                                tile_selection[1] += yMove
                                tile_selection[5] += yMove
                                updateTileSelectionKeys()
                            }
                            else
                            {
                                tile_selection_made = 0
                                tile_selection = [0, 0, 0, 0, 0, 0]
                            }
                            tile_selection_moving = 0
                            lockCursorMode = 0
                        }
                        if keyboard_check_pressed(vk_backspace)
                        {
                            for (i = 0; i <= tile_selection[2]; i += gridSize)
                            {
                                for (j = 0; j <= tile_selection[3]; j += gridSize)
                                    deleteTile((tile_selection[4] + i), (tile_selection[5] + j))
                            }
                            tile_selection_moving = 0
                            lockCursorMode = 0
                        }
                        if keyboard_check_pressed(ord("F"))
                        {
                            var spreadIndices = []
                            var selW = tile_selection[2] / gridSize
                            var selH = tile_selection[3] / gridSize
                            for (i = 0; i <= selW; i++)
                            {
                                spreadIndices[i] = []
                                for (j = 0; j <= selH; j++)
                                    spreadIndices[i][j] = -1
                            }
                            for (i = 0; i <= tile_selection[2]; i += gridSize)
                            {
                                for (j = 0; j <= tile_selection[3]; j += gridSize)
                                {
                                    if (!tileset_doAutoTile)
                                    {
                                        var indX = i / gridSize
                                        var indY = j / gridSize
                                        var sInd = spreadIndices[indX][indY]
                                        if (sInd == -1)
                                        {
                                            sInd = irandom(array_length(tilesetCoord_spread) - 1)
                                            for (var p = 0; p < tilesetCoord_spread[sInd][2]; p++)
                                            {
                                                for (var q = 0; q < tilesetCoord_spread[sInd][3]; q++)
                                                    spreadIndices[(indX + p)][(indY + q)] = sInd
                                            }
                                        }
                                        var tx = tilesetCoord_spread[sInd][0]
                                        var ty = tilesetCoord_spread[sInd][1]
                                        var tw = tilesetCoord_spread[sInd][2]
                                        var th = tilesetCoord_spread[sInd][3]
                                        addTile(tilesetSelected, [(tx + ((i / gridSize) % tw)), (ty + ((j / gridSize) % th))], (tile_selection[4] + i), (tile_selection[5] + j))
                                    }
                                }
                            }
                            if tileset_doAutoTile
                            {
                                ogPos = [x, y]
                                x = tile_selection[4]
                                y = tile_selection[5]
                                editor_autotile(1, ((floor(tile_selection[2] / gridSize)) + 1), ((floor(tile_selection[3] / gridSize)) + 1))
                                x = ogPos[0]
                                y = ogPos[1]
                            }
                            tile_selection_moving = 0
                            lockCursorMode = 0
                        }
                    }
                    break
            }

            break
        case st_backgrounds:
            if variable_struct_exists(data.backgrounds, string(layer_background))
                cursorNotice = "Click and drag to move the background"
            if variable_instance_exists(id, "prevMousePos")
            {
                if mouse_check_button(mb_left)
                {
                    var bgs = "data.backgrounds." + string(layer_background)
                    _stSet((bgs + ".x"), ((_stGet(bgs + ".x")) + mouse_x - prevMousePos[0]))
                    _stSet((bgs + ".y"), ((_stGet(bgs + ".y")) + mouse_y - prevMousePos[1]))
                }
            }
            break
        case st_resize:
            cursorNotice = "Click and drag the room borders to resize it"
            if (!mouse_check_button(mb_left))
            {
                roomResize = [0, 0]
                if (onGridPos[2] <= _stGet("data.properties.roomX"))
                    roomResize[0] = -1
                else if (onGridPos[2] >= _stGet("data.properties.levelWidth"))
                    roomResize[0] = 1
                if (onGridPos[3] <= _stGet("data.properties.roomY"))
                    roomResize[1] = -1
                else if (onGridPos[3] >= _stGet("data.properties.levelHeight"))
                    roomResize[1] = 1
                roomResize[2] = onGridPos[2]
                roomResize[3] = onGridPos[3]
                roomPreResize = [_stGet("data.properties.roomX"), _stGet("data.properties.roomY"), _stGet("data.properties.levelWidth"), _stGet("data.properties.levelHeight")]
            }
            else
            {
                var xDiff = onGridPos[2] - roomResize[2]
                var yDiff = onGridPos[3] - roomResize[3]
                var maxSize = floor(512) * 32
                var prop = data.properties
                if (roomResize[0] == -1)
                    _stSet("data.properties.roomX", clamp((roomPreResize[0] + xDiff), ((-maxSize) + prop.levelWidth), (_stGet("data.properties.levelWidth") - obj_screensizer.actual_width)))
                else if (roomResize[0] == 1)
                    _stSet("data.properties.levelWidth", clamp((roomPreResize[2] + xDiff), (_stGet("data.properties.roomX") + obj_screensizer.actual_width), (maxSize + prop.roomX)))
                if (roomResize[1] == -1)
                    _stSet("data.properties.roomY", clamp((roomPreResize[1] + yDiff), ((-maxSize) + prop.levelHeight), (_stGet("data.properties.levelHeight") - obj_screensizer.actual_height)))
                else if (roomResize[1] == 1)
                    _stSet("data.properties.levelHeight", clamp((roomPreResize[3] + yDiff), (_stGet("data.properties.roomY") + obj_screensizer.actual_height), (maxSize + prop.roomY)))
            }
            cursorImage = 5
            if (roomResize[0] != 0)
                cursorImage = 3
            if (roomResize[1] != 0)
                cursorImage = 1
            if (roomResize[0] != 0 && roomResize[1] != 0 && abs(roomResize[0]) == abs(roomResize[1]))
            {
                cursorImage = 4
                if (roomResize[0] != roomResize[1])
                    cursorImage = 2
            }
            break
        case st_popup:
            if mouse_check_button(mb_left)
            {
                editor_state = st_edit
                editorWindowUpdate()
            }
            break
    }

    zoomChange = mouse_wheel_down() - mouse_wheel_up()
    if (zoomChange == 0)
        zoomChange = keyboard_check_pressed(ord("E")) - keyboard_check_pressed(ord("Q"))
    if (zoomChange != 0 && (!inVarMenu))
    {
        if (zoomChange > 0)
            camZoom *= 2
        else
            camZoom *= 0.5
        var l = camZoom
        camZoom = clamp(camZoom, power(2, -1), power(2, 3))
        if (l != camZoom)
            zoomChange = 0
        var ogCamSize = [camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0])]
    }
    if mouse_check_button(mb_middle)
    {
        cam_x -= (mouse_x - scroll_x)
        cam_y -= (mouse_y - scroll_y)
    }
    else
        camScroll = [cam_x, cam_y]
}
if (mouse_check_button(mb_left) || mouse_check_button(mb_right))
    prevGridPos = array_duplicate(onGridPos)
else
    prevGridPos = [-1, -1]
camera_set_view_size(view_camera[0], (obj_screensizer.actual_width * camZoom), (obj_screensizer.actual_height * camZoom))
if (zoomChange > 0)
{
    cam_x -= (camera_get_view_width(view_camera[0]) / 2 - ogCamSize[0] / 2)
    cam_y -= (camera_get_view_height(view_camera[0]) / 2 - ogCamSize[1] / 2)
}
else if (zoomChange < 0)
{
    cam_x += (ogCamSize[0] / 2 - camera_get_view_width(view_camera[0]) / 2)
    cam_y += (ogCamSize[1] / 2 - camera_get_view_height(view_camera[0]) / 2)
}
if (zoomChange != 0)
{
    with (obj_tilemapDrawer)
        initTilemapDrawer(other.data, layer_tilemap)
}
prevMousePos = [mouse_x, mouse_y]
var t = w_findCanvasIndex("tileset")
var canMoveCam = 1
if (t >= obj_noisecredit)
{
    if w_isOnCanvas(w_openCanvas[t], (cursorX / w_scale), (cursorY / w_scale))
        canMoveCam = 0
}
if (canMoveCam && (!inVarMenu))
{
    var scrollSpd = 8 + 8 * keyboard_check(vk_shift)
    cam_x += ((keyboard_check(ord("D")) - keyboard_check(ord("A"))) * scrollSpd * camZoom)
    cam_y += ((keyboard_check(ord("S")) - keyboard_check(ord("W"))) * scrollSpd * camZoom)
}
toolbarHovering = -1
bgsHovering = -1
for (i = 0; i < array_length(w_openCanvas); i++)
{
    c = w_openCanvas[i]
    var onX = cursorX / w_scale - c.x + c.scroll_x
    var onY = cursorY / w_scale - c.y + c.scroll_y
    wCanvas_step(c, onX, onY, (cursorX / w_scale), (cursorY / w_scale))
    if w_isOnCanvas(c, (cursorX / w_scale), (cursorY / w_scale))
    {
        if (c.growx == ((c.x + c.width) * w_scale))
        {
            switch c.name
            {
                case "toolbar":
                    var mInd = floor(onX / 50)
                    if (mInd > -1)
                        toolbarHovering = mInd
                    if mouse_check_button_pressed(mb_left)
                    {
                        if inVarMenu
                            inVarMenu = 0
                        if (mInd == editor_state)
                            editor_state = -1
                        else if (mInd > -1)
                        {
                            toolbarHovering = mInd
                            windowQuickErase = 1
                            switch mInd
                            {
                                case st_instances:
                                case st_tiles:
                                case st_backgrounds:
                                case st_rooms:
                                case st_settings:
                                case st_debug:
                                case st_editorsettings:
                                    editor_state = mInd
                                    break
                                case st_save:
                                    saveData()
                                    break
                                case st_play:
                                    fromStart = 0
                                    playRoom()
                                    break
                                case st_edit:
                                    if (editor_state == 0 || editor_state == 1)
                                        selectingMode = (!selectingMode)
                                    break
                                case st_start:
                                    fromStart = 1
                                    playRoom()
                                    break
                            }

                        }
                        editorWindowUpdate()
                    }
                    break
                case "objFolders":
                    var onFolder = clamp(floor(onY / _stGet("w_canvas.objFolders.gridSize[1]")), 0, (array_length(variable_struct_get_names(objFolders)) - 1))
                    struct_set(c, [["scrollBorders", [0, (array_length(variable_struct_get_names(objFolders)) * _stGet("w_canvas.objFolders.gridSize[1]") - c.height)]]])
                    if mouse_check_button_pressed(mb_left)
                        objFolderSelected = onFolder
                    break
                case "objGrid":
                    var og = _stGet("w_canvas.objGrid")
                    var folderNames = objFolderOrder
                    var objs = _stGet("objFolders." + folderNames[objFolderSelected])
                    struct_set(c, [["scrollBorders", [0, ((array_length(objs) / og.columns + 1) * og.gridSize - c.height)]]])
                    var objCoord = [floor(onX / og.gridSize), floor(onY / og.gridSize)]
                    if (objCoord[0] == clamp(objCoord[0], 0, og.columns) && objCoord[1] == clamp(objCoord[1], 0, (array_length(objs) / og.columns)))
                    {
                        var objInd = (objCoord[0] % og.columns) + objCoord[1] * og.columns
                        if (objInd < array_length(objs))
                        {
                            cursorNotice = object_get_name(objs[objInd])
                            if mouse_check_button_pressed(mb_left)
                            {
                                objSelected = objs[objInd]
                                if instance_exists(obj_varstorage)
                                {
                                    preset = 0
                                    inVarMenu = 0
                                    instance_destroy(obj_varstorage)
                                }
                            }
                        }
                    }
                    break
                case "tilesetFolders":
                    mInd = floor(onX / 110)
                    if (mInd == clamp(mInd, 0, (array_length(global.tilesetData.order) - 1)))
                    {
                        if mouse_check_button_pressed(mb_left)
                        {
                            tilesetFolder = mInd
                            windowQuickErase = 1
                            windowQuickDraw = 1
                            editorWindowUpdate()
                        }
                    }
                    break
                case "tilesetList":
                    mInd = floor(onY / c.sep)
                    tileset_listScroll = c.scroll_y
                    var order = global.tilesetData.order
                    var sets = struct_get(global.tilesetData.folders, order[tilesetFolder])
                    if (mInd == clamp(mInd, 0, (array_length(sets) - 1)))
                    {
                        if mouse_check_button_pressed(mb_left)
                        {
                            tilesetSelected = sets[mInd]
                            tileset_autotileIndex = 0
                            windowQuickErase = 1
                            windowQuickDraw = 1
                            editorWindowUpdate()
                            var tsSprite = _spr(tilesetSelected)
                            var tCanvas = w_openCanvas[w_findCanvasIndex("tileset")]
                            struct_set(tCanvas, [["scrollBorders", [(sprite_get_width(tsSprite) - tCanvas.width), (2 * sprite_get_height(tsSprite) - tCanvas.height)]]])
                        }
                    }
                    break
                case "tileset":
                    var tScale = tilesetStruct.scale
                    var w = tilesetStruct.size[0] * tScale
                    var h = tilesetStruct.size[1] * tScale
                    var sc = keyboard_check_pressed(ord("Q")) - keyboard_check_pressed(ord("E"))
                    if (sc != 0)
                    {
                        c.zoom *= power(1.25, sc)
                        struct_set(c, [["scroll_x", (c.scroll_x * (power(1.25, sc)))], ["scroll_y", (c.scroll_y * (power(1.25, sc)))]])
                    }
                    onX /= c.zoom
                    onY /= c.zoom
                    tsSprite = _spr(tilesetSelected)
                    var tex = sprite_get_texture(tsSprite, 0)
                    if ((!tileset_doAutoTile) || w_findCanvasIndex("autotileEditor") != -1)
                    {
                        struct_set(c, [["scrollBorders", [(sprite_get_width(tsSprite) * tScale - c.width), (texture_get_height(tex) / texture_get_texel_height(tex) * tScale - c.height)]]])
                        cursorNotice = "Press Q/E to zoom in/out"
                    }
                    else
                        struct_set(c, [["scrollBorders", [(10 * gridSize - c.width), 0]]])
                    mInd = [floor(onX / gridSize), floor(onY / gridSize)]
                    if mouse_check_button_pressed(mb_left)
                    {
                        if (!keyboard_check(vk_control))
                        {
                            tilesetCoord_editing = tilesetCoord
                            tilesetCoord_spread = [tilesetCoord]
                        }
                        else
                        {
                            var newArray = [0, 0, 1, 1]
                            array_push(tilesetCoord_spread, newArray)
                            tilesetCoord_editing = newArray
                        }
                        tilesetCoord_editing[0] = mInd[0]
                        tilesetCoord_editing[1] = mInd[1]
                        tilesetCoord_editing[2] = 1
                        tilesetCoord_editing[3] = 1
                    }
                    if mouse_check_button(mb_left)
                    {
                        tilesetCoord_editing[2] = clamp((mInd[0] - tilesetCoord_editing[0] + 1), 1, 200)
                        tilesetCoord_editing[3] = clamp((mInd[1] - tilesetCoord_editing[1] + 1), 1, 200)
                    }
                    break
                case "bgs":
                    if (_stGet("data.backgrounds." + string(layer_background)) == undefined)
                    {
                        bgsHovering = floor(onY / 14)
                        if mouse_check_button_pressed(mb_left)
                        {
                            switch bgsHovering
                            {
                                case 0:
                                    editor_initBGLayer(layer_background, "burger")
                                    break
                                case 1:
                                    var nd = wCanvas_open_dropdown("bgPresetDropdown", (cursorX / w_scale), (cursorY / w_scale), global.bgpreset_names, "", "bgPresetSelected")
                                    break
                            }

                        }
                    }
                    else
                    {
                        bgsHovering = floor(onY / 14)
                        if mouse_check_button_pressed(mb_left)
                        {
                            saveData()
                            bgString = "data.backgrounds." + string(layer_background)
                            switch bgsHovering
                            {
                                case 0:
                                    var txt = fstring("{bgString}.sprite")
                                    if (w_findCanvasIndex("bigDropdown") != -1)
                                    {
                                        w_openCanvas[w_findCanvasIndex("bigDropdown")].quickerase = 1
                                        wCanvas_close("bigDropdown")
                                    }
                                    nd = wCanvas_open_dropdown("bigDropdown", (cursorX / w_scale), (cursorY / w_scale), spriteList, _stGet(txt), "bgImageSelected", "Input sprite name")
                                    break
                                case 1:
                                    txt = fstring("{bgString}.panic_sprite")
                                    if (w_findCanvasIndex("bigDropdown") != -1)
                                    {
                                        w_openCanvas[w_findCanvasIndex("bigDropdown")].quickerase = 1
                                        wCanvas_close("bigDropdown")
                                    }
                                    nd = wCanvas_open_dropdown("bigDropdown", (cursorX / w_scale), (cursorY / w_scale), spriteList, _stGet(txt), "panicBgImageSelected", "Input sprite name")
                                    break
                                case 2:
                                case 3:
                                    txt = bgString
                                    if (bgsHovering == 3)
                                        txt += ".y"
                                    else
                                        txt += ".x"
                                    if (bgsHovering == 3)
                                        var showName = "Y"
                                    else
                                        showName = "X"
                                    inVarMenu = 1
                                    keyboard_string = _stGet(txt)
                                    test = wCanvas_open_dropdown("editVariable", 300, 150, ["mark1", "mark2", "mark3", "mark4", "mark5", "mark6", "mark7", "mark8", "mark9", "mark10", "mark11", "mark12", "mark13", "mark14", "mark15", "mark16", "mark17", "mark18", "mark19", "mark20", "mark21", "mark22", "mark23", "mark24", "mark25"], 0, "variableEdit")
                                    struct_set(test, [["instance", "background"], ["instID", txt], ["variableName", showName], ["variableValue", _stGet(txt)]])
                                    break
                                case 4:
                                case 5:
                                    txt = bgString
                                    if (bgsHovering == 5)
                                        txt += ".scroll_y"
                                    else
                                        txt += ".scroll_x"
                                    if (bgsHovering == 5)
                                        showName = "Scroll Y"
                                    else
                                        showName = "Scroll X"
                                    inVarMenu = 1
                                    keyboard_string = _stGet(txt)
                                    test = wCanvas_open_dropdown("editVariable", 300, 150, ["mark1", "mark2", "mark3", "mark4", "mark5", "mark6", "mark7", "mark8", "mark9", "mark10", "mark11", "mark12", "mark13", "mark14", "mark15", "mark16", "mark17", "mark18", "mark19", "mark20", "mark21", "mark22", "mark23", "mark24", "mark25"], 0, "variableEdit")
                                    struct_set(test, [["instance", "background"], ["instID", txt], ["variableName", showName], ["variableValue", _stGet(txt)]])
                                    break
                                case 6:
                                case 7:
                                    txt = bgString
                                    if (bgsHovering == 7)
                                        txt += ".tile_y"
                                    else
                                        txt += ".tile_x"
                                    _stSet(txt, (!_stGet(txt)))
                                    break
                                case 8:
                                case 9:
                                    txt = bgString
                                    if (bgsHovering == 9)
                                        txt += ".vspeed"
                                    else
                                        txt += ".hspeed"
                                    if (bgsHovering == 9)
                                        showName = "Vspeed"
                                    else
                                        showName = "Hspeed"
                                    inVarMenu = 1
                                    keyboard_string = _stGet(txt)
                                    test = wCanvas_open_dropdown("editVariable", 300, 150, ["mark1", "mark2", "mark3", "mark4", "mark5", "mark6", "mark7", "mark8", "mark9", "mark10", "mark11", "mark12", "mark13", "mark14", "mark15", "mark16", "mark17", "mark18", "mark19", "mark20", "mark21", "mark22", "mark23", "mark24", "mark25"], 0, "variableEdit")
                                    struct_set(test, [["instance", "background"], ["instID", txt], ["variableName", showName], ["variableValue", _stGet(txt)]])
                                    break
                                case 10:
                                    txt = fstring("{bgString}.image_speed")
                                    showName = "Image Speed"
                                    inVarMenu = 1
                                    keyboard_string = _stGet(txt)
                                    test = wCanvas_open_dropdown("editVariable", 300, 150, ["mark1", "mark2", "mark3", "mark4", "mark5", "mark6", "mark7", "mark8", "mark9", "mark10", "mark11", "mark12", "mark13", "mark14", "mark15", "mark16", "mark17", "mark18", "mark19", "mark20", "mark21", "mark22", "mark23", "mark24", "mark25"], 0, "variableEdit")
                                    struct_set(test, [["instance", "background"], ["instID", txt], ["variableName", showName], ["variableValue", _stGet(txt)]])
                                    break
                                case 11:
                                    txt = "none"
                                    if (w_findCanvasIndex("valueDropdown") != -1)
                                    {
                                        w_openCanvas[w_findCanvasIndex("valueDropdown")].quickerase = 1
                                        wCanvas_close("valueDropdown")
                                    }
                                    var escapeData = wCanvas_open_dropdown("valueDropdown", (cursorX / w_scale), (cursorY / w_scale), ["None", "Spawn", "Destroy"], txt, "bgEscapeData", "Set escape data")
                                    break
                                case 12:
                                    txt = "none"
                                    if (w_findCanvasIndex("valueDropdown") != -1)
                                    {
                                        w_openCanvas[w_findCanvasIndex("valueDropdown")].quickerase = 1
                                        wCanvas_close("valueDropdown")
                                    }
                                    escapeData = wCanvas_open_dropdown("valueDropdown", (cursorX / w_scale), (cursorY / w_scale), ["None", "Peppino", "Noise", "Pogo Noise", "Vigilante", "Pepperman", "Snick"], txt, "bgCharacterData", "Set character data")
                                    break
                                case 13:
                                    var bgpName = get_string("Set a name for the new Background Preset:", prevBGPreset)
                                    if (bgpName != "")
                                    {
                                        bgPreset_save(bgpName, data.backgrounds, 1)
                                        ass_addBGPreset(bgpName, data.backgrounds)
                                    }
                                    break
                                case 14:
                                    variable_struct_remove(_stGet("data.backgrounds"), string(layer_background))
                                    with (obj_customBG)
                                    {
                                        if (layer_background == other.layer_background)
                                            instance_destroy()
                                    }
                                    break
                            }

                        }
                    }
                    break
                case "rooms":
                    roomHovering = floor(onY / 12)
                    var onAdd = (onX > (_stGet("w_canvas.rooms.width") - 14) && onY < 16)
                    var onDelete = (onX < 14 && onY < 16)
                    if (roomHovering >= (array_length(roomNameList) + 2) || roomHovering < 2 || onAdd || onDelete)
                        roomHovering = -1
                    struct_set(c, [["scrollBorders", [0, ((array_length(roomNameList) + 2) * 12 - c.height)]]])
                    if mouse_check_button_pressed(mb_left)
                    {
                        if (roomHovering != -1)
                        {
                            if (!deletingRooms)
                            {
                                saveData()
                                global.editorRoomName = roomNameList[max((roomHovering - 2), 0)]
                                room_restart()
                            }
                            else
                            {
                                var fName = gml_Script_mod_folder_afom("levels/" + global.editorLevelName + "/rooms/" + (roomNameList[max((roomHovering - 2), 0)]) + "_wfixed.json")
                                if file_exists(fName)
                                    file_delete(fName)
                                fName = gml_Script_mod_folder_afom("levels/" + global.editorLevelName + "/rooms/" + (roomNameList[max((roomHovering - 2), 0)]) + ".json")
                                file_delete(fName)
                                array_delete(roomNameList, (roomHovering - 2), 1)
                            }
                        }
                        else if onAdd
                        {
                            showName = "New room name"
                            inVarMenu = 1
                            keyboard_string = ""
                            test = wCanvas_open_dropdown("editVariable", 300, 150, ["mark1", "mark2", "mark3", "mark4", "mark5", "mark6", "mark7", "mark8", "mark9", "mark10", "mark11", "mark12", "mark13", "mark14", "mark15", "mark16", "mark17", "mark18", "mark19", "mark20", "mark21", "mark22", "mark23", "mark24", "mark25"], 0, "variableEdit")
                            struct_set(test, [["instance", "rooms"], ["instID", roomNameAdd], ["variableName", showName], ["variableValue", ""]])
                        }
                        else if onDelete
                        {
                            if (deletingRooms == 0)
                                deletingRooms = 1
                            else
                                deletingRooms = 0
                        }
                    }
                    break
                case "debug":
                    mInd = floor(onY / 16)
                    if (mInd == clamp(mInd, 0, 8))
                        debugHovering = mInd
                    if mouse_check_button_pressed(mb_left)
                    {
                        switch debugHovering
                        {
                            case 0:
                                if (global.ratDeath == "False")
                                    global.ratDeath = "True"
                                else if (global.ratDeath == "True")
                                    global.ratDeath = "False"
                                break
                            case 1:
                                if (global.transfoBreak == "False")
                                    global.transfoBreak = "True"
                                else if (global.transfoBreak == "True")
                                    global.transfoBreak = "False"
                                break
                            case 2:
                                if (global.doPanic == "False")
                                    global.doPanic = "True"
                                else if (global.doPanic == "True")
                                    global.doPanic = "False"
                                break
                            case 3:
                                if (global.setSupertaunt == "False")
                                    global.setSupertaunt = "True"
                                else if (global.setSupertaunt == "True")
                                    global.setSupertaunt = "False"
                                break
                            case 4:
                                var valdropdown = wCanvas_open_dropdown("valueDropdown", (cursorX / w_scale), (cursorY / w_scale), ["A", "B", "C", "D", "E", "F", "G"], "A", "startingDoorData")
                                break
                            case 5:
                                txt = "startState"
                                showName = "Set Starting State"
                                inVarMenu = 1
                                keyboard_string = _stGet(txt)
                                test = wCanvas_open_dropdown("editVariable", 300, 150, ["mark1", "mark2", "mark3", "mark4", "mark5", "mark6", "mark7", "mark8", "mark9", "mark10", "mark11", "mark12", "mark13", "mark14", "mark15", "mark16", "mark17", "mark18", "mark19", "mark20", "mark21", "mark22", "mark23", "mark24", "mark25"], 0, "variableEdit")
                                struct_set(test, [["instance", "debug"], ["instID", txt], ["variableName", showName], ["variableValue", variable_global_get(txt)]])
                                break
                            case 6:
                                txt = "startPlayerSpeed"
                                showName = "Set Starting Speed"
                                inVarMenu = 1
                                keyboard_string = _stGet(txt)
                                test = wCanvas_open_dropdown("editVariable", 300, 150, ["mark1", "mark2", "mark3", "mark4", "mark5", "mark6", "mark7", "mark8", "mark9", "mark10", "mark11", "mark12", "mark13", "mark14", "mark15", "mark16", "mark17", "mark18", "mark19", "mark20", "mark21", "mark22", "mark23", "mark24", "mark25"], 0, "variableEdit")
                                struct_set(test, [["instance", "debug"], ["instID", txt], ["variableName", showName], ["variableValue", variable_global_get(txt)]])
                                break
                            case 7:
                                break
                            case 8:
                                switchAssetFolder(global.modFolder, 1)
                                room_goto(rmEditor)
                                break
                        }

                    }
                    break
                case "settingTypes":
                    if mouse_check_button_pressed(mb_left)
                        settingsMode = clamp(floor(onY / 16), 0, 1)
                    break
                case "settings":
                    settingsHovering = -1
                    if (settingsMode == 0)
                    {
                        mInd = floor(onY / 16)
                        if (mInd == clamp(mInd, 0, 13))
                            settingsHovering = mInd
                        if mouse_check_button_pressed(mb_left)
                        {
                            var switchsong = [".song", "escapeSong", "lap2Song", "lap3Song", "lap4Song", "escapeSongN", "lap2SongN", "lap3SongN", "lap4SongN"]
                            var switchsongname = ["", "Escape", "Lap2", "Lap3", "Lap4", "EscapeN", "Lap2N", "Lap3N", "Lap4N"]
                            switch settingsHovering
                            {
                                case 0:
                                case 1:
                                case 2:
                                case 3:
                                case 4:
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                    if (settingsHovering == 0)
                                        txt = "data.properties" + switchsong[settingsHovering]
                                    if (settingsHovering == 1)
                                        txt = levelSettings.escapeSong
                                    if (settingsHovering == 2)
                                        txt = levelSettings.lap2Song
                                    if (settingsHovering == 3)
                                        txt = levelSettings.lap3Song
                                    if (settingsHovering == 4)
                                        txt = levelSettings.lap4Song
                                    if (settingsHovering == 5)
                                        txt = levelSettings.escapeSongN
                                    if (settingsHovering == 6)
                                        txt = levelSettings.lap2SongN
                                    if (settingsHovering == 7)
                                        txt = levelSettings.lap3SongN
                                    if (settingsHovering == 8)
                                        txt = levelSettings.lap4SongN
                                    var opts = array_duplicate(audioList)
                                    opts = gml_Script_array_concat(opts, global.defaultSong_names)
                                    if (settingsHovering == 0)
                                        var def = _stGet(txt)
                                    else
                                        def = txt
                                    if variable_struct_exists(global.defaultSong_display, def)
                                        def = struct_get(global.defaultSong_display, def)
                                    if (w_findCanvasIndex("bgPresetDropdown") != -1)
                                    {
                                        w_openCanvas[w_findCanvasIndex("bgPresetDropdown")].quickerase = 1
                                        wCanvas_close("bgPresetDropdown")
                                    }
                                    nd = wCanvas_open_dropdown("bgPresetDropdown", (cursorX / w_scale), (cursorY / w_scale), opts, def, ("songSelected" + switchsongname[settingsHovering]))
                                    break
                                case 9:
                                    if (levelSettings.escapePlay == "true")
                                        levelSettings.escapePlay = "false"
                                    else if (levelSettings.escapePlay == "false" || levelSettings.escapePlay == "")
                                        levelSettings.escapePlay = "true"
                                    break
                                case 10:
                                    txt = "data.properties.songTransitionTime"
                                    showName = "Transition time in frames"
                                    inVarMenu = 1
                                    keyboard_string = _stGet(txt)
                                    test = wCanvas_open_dropdown("editVariable", 300, 150, ["mark1", "mark2", "mark3", "mark4", "mark5", "mark6", "mark7", "mark8", "mark9", "mark10", "mark11", "mark12", "mark13", "mark14", "mark15", "mark16", "mark17", "mark18", "mark19", "mark20", "mark21", "mark22", "mark23", "mark24", "mark25"], 0, "variableEdit")
                                    struct_set(test, [["instance", "settings"], ["instID", txt], ["variableName", showName], ["variableValue", _stGet(txt)]])
                                    break
                                case 11:
                                    txt = "data.properties.pausecombo"
                                    showName = "Pause time in frames"
                                    inVarMenu = 1
                                    keyboard_string = _stGet(txt)
                                    test = wCanvas_open_dropdown("editVariable", 300, 150, ["mark1", "mark2", "mark3", "mark4", "mark5", "mark6", "mark7", "mark8", "mark9", "mark10", "mark11", "mark12", "mark13", "mark14", "mark15", "mark16", "mark17", "mark18", "mark19", "mark20", "mark21", "mark22", "mark23", "mark24", "mark25"], 0, "variableEdit")
                                    struct_set(test, [["instance", "settings"], ["instID", txt], ["variableName", showName], ["variableValue", _stGet(txt)]])
                                    break
                                case 12:
                                    editor_state = st_resize
                                    windowQuickErase = 1
                                    editorWindowUpdate()
                                    break
                            }

                        }
                    }
                    else
                    {
                        mInd = floor(onY / 16)
                        if (mInd == clamp(mInd, 0, 9))
                            settingsHovering = mInd
                        opts = []
                        if mouse_check_button_pressed(mb_left)
                        {
                            switch settingsHovering
                            {
                                case 0:
                                    txt = "levelSettings.name"
                                    showName = "Level Name"
                                    inVarMenu = 1
                                    keyboard_string = _stGet(txt)
                                    test = wCanvas_open_dropdown("editVariable", 300, 150, ["mark1", "mark2", "mark3", "mark4", "mark5", "mark6", "mark7", "mark8", "mark9", "mark10", "mark11", "mark12", "mark13", "mark14", "mark15", "mark16", "mark17", "mark18", "mark19", "mark20", "mark21", "mark22", "mark23", "mark24", "mark25"], 0, "variableEdit")
                                    struct_set(test, [["instance", "settings"], ["instID", txt], ["variableName", showName], ["variableValue", _stGet(txt)]])
                                    break
                                case 1:
                                    txt = "levelSettings.pscore"
                                    showName = "Score for an S rank"
                                    inVarMenu = 1
                                    keyboard_string = _stGet(txt)
                                    test = wCanvas_open_dropdown("editVariable", 300, 150, ["mark1", "mark2", "mark3", "mark4", "mark5", "mark6", "mark7", "mark8", "mark9", "mark10", "mark11", "mark12", "mark13", "mark14", "mark15", "mark16", "mark17", "mark18", "mark19", "mark20", "mark21", "mark22", "mark23", "mark24", "mark25"], 0, "variableEdit")
                                    struct_set(test, [["instance", "settings"], ["instID", txt], ["variableName", showName], ["variableValue", _stGet(txt)]])
                                    break
                                case 2:
                                    txt = "levelSettings.isWorld"
                                    if (_stGet(txt) < 3)
                                        _stSet(txt, (_stGet(txt) + 1))
                                    else
                                        _stSet(txt, 0)
                                    break
                                case 3:
                                    txt = "levelSettings.escape"
                                    showName = "Escape Time"
                                    inVarMenu = 1
                                    keyboard_string = _stGet(txt)
                                    test = wCanvas_open_dropdown("editVariable", 300, 150, ["mark1", "mark2", "mark3", "mark4", "mark5", "mark6", "mark7", "mark8", "mark9", "mark10", "mark11", "mark12", "mark13", "mark14", "mark15", "mark16", "mark17", "mark18", "mark19", "mark20", "mark21", "mark22", "mark23", "mark24", "mark25"], 0, "variableEdit")
                                    struct_set(test, [["instance", "settings"], ["instID", txt], ["variableName", showName], ["variableValue", timeString_get_string(_stGet(txt))]])
                                    break
                                case 4:
                                    levelSettings.fescape = (!levelSettings.fescape)
                                    break
                                case 5:
                                case 6:
                                case 7:
                                case 8:
                                    opts = array_duplicate(spriteList)
                                    var cb = "cardSprite"
                                    var prompt = "sprite"
                                    txt = "levelSettings.titlecardSprite"
                                    if (settingsHovering == 4)
                                    {
                                        opts = []
                                        array_push(opts, "no titlecard")
                                        opts = gml_Script_array_concat(opts, spriteList)
                                    }
                                    if (settingsHovering == 5)
                                    {
                                        cb = "Sprite"
                                        txt = "levelSettings.titleSprite"
                                    }
                                    if (settingsHovering == 6)
                                    {
                                        opts = audioList
                                        prompt = "audio"
                                        cb = "Song"
                                        txt = "levelSettings.titleSong"
                                    }
                                    else if (settingsHovering == 7)
                                    {
                                        opts = audioList
                                        prompt = "audio"
                                        cb = "SongN"
                                        txt = "levelSettings.titleSongN"
                                    }
                                    if (w_findCanvasIndex("bigDropdown") != -1)
                                    {
                                        w_openCanvas[w_findCanvasIndex("bigDropdown")].quickerase = 1
                                        wCanvas_close("bigDropdown")
                                    }
                                    nd = wCanvas_open_dropdown("bigDropdown", (cursorX / w_scale), (cursorY / w_scale), opts, _stGet(txt), ("title" + cb), ("Input " + prompt + " name"))
                                    break
                                case 9:
                                    editor_state = st_popup
                                    currnoisehead = random_range(0, (sprite_get_number(spr_titlecard_noise) - 1))
                                    windowQuickErase = 1
                                    windowQuickDraw = 1
                                    editorWindowUpdate()
                                    wCanvas_open("noiseheads", noiseX, noiseY)
                                    break
                            }

                        }
                    }
                    break
                case "editorSettings":
                    mInd = floor(onY / 16)
                    if (mInd == clamp(mInd, 0, 3))
                        settingsHovering = mInd
                    if mouse_check_button_pressed(mb_left)
                    {
                        switch settingsHovering
                        {
                            case 0:
                                break
                            case 1:
                                ini_open("EditorSettings.ini")
                                txt = ini_read_string("Editor", "music", "")
                                ini_close()
                                opts = array_duplicate(audioList)
                                opts = gml_Script_array_concat(opts, global.defaultSong_names)
                                def = txt
                                if variable_struct_exists(global.defaultSong_display, def)
                                    def = struct_get(global.defaultSong_display, def)
                                if (w_findCanvasIndex("bgPresetDropdown") != -1)
                                {
                                    w_openCanvas[w_findCanvasIndex("bgPresetDropdown")].quickerase = 1
                                    wCanvas_close("bgPresetDropdown")
                                }
                                nd = wCanvas_open_dropdown("bgPresetDropdown", (cursorX / w_scale), (cursorY / w_scale), opts, def, "songSelectedEditor")
                                break
                            case 2:
                                ini_open("EditorSettings.ini")
                                txt = ini_read_string("Editor", "showtrails", "True")
                                if (txt == "True")
                                    ini_write_string("Editor", "showtrails", "False")
                                else if (txt == "False")
                                    ini_write_string("Editor", "showtrails", "True")
                                ini_close()
                                break
                            case 3:
                                ini_open("EditorSettings.ini")
                                txt = ini_read_string("Editor", "windowstyle", "Fancy")
                                if (txt == "Fancy")
                                    ini_write_string("Editor", "windowstyle", "Fast")
                                else if (txt == "Fast")
                                    ini_write_string("Editor", "windowstyle", "Fancy")
                                ini_close()
                                break
                            default:

                        }

                    }
                    break
                case "instanceMenu":
                    ins = c.instance
                    if (!instance_exists(ins))
                    {
                        inVarMenu = 0
                        inMenu = 0
                        c.quickerase = 1
                        wCanvas_close(c)
                        break
                    }
                    else
                    {
                        if (!preset)
                        {
                            var insData = _stGet("data.instances[" + string(ins.instID) + "]")
                            var varInfo = instance_getVarList(insData.object, insData, 1)
                        }
                        if preset
                        {
                            insData = variable_instance_get(1227, "values")
                            varInfo = instance_getVarList(objSelected, insData, 1)
                        }
                        if keyboard_check(vk_rcontrol)
                            show_message(varInfo)
                        var varList = varInfo[0]
                        variable_struct_set(c, "scrollBorders", [0, ((array_length(varList) + 2) * 16 + 16 - c.height)])
                        struct_set(c, [["hovering", floor((onY - 18) / 16)]])
                        if (c.hovering != clamp(c.hovering, 0, (array_length(varList) - 1)))
                            c.hovering = -1
                        if ((onY - c.scroll_y) <= 16 || onY >= (c.scroll_y + (c.height - 14))) {
                        c.hovering = -1
                        }
                        if mouse_check_button_pressed(mb_left)
                        {
                            if (onX < 16 && (onY - c.scroll_y) < 16)
                            {
                                inVarMenu = 0
                                inMenu = 0
                                wCanvas_close(c)
                            }
                            else if (onX < 48 && onY > (c.scroll_y + (c.height - 16)))
                            {
                                variableParamSelected = 0
                                keyboard_string = ""
                                inVarMenu = 1
                                if (w_findCanvasIndex("createVariable") != -1)
                                {
                                    w_openCanvas[w_findCanvasIndex("createVariable")].quickerase = 1
                                    wCanvas_close("createVariable")
                                }
                                if (w_findCanvasIndex("editVariable") != -1)
                                {
                                    w_openCanvas[w_findCanvasIndex("editVariable")].quickerase = 1
                                    wCanvas_close("editVariable")
                                }
                                var test = wCanvas_open_dropdown("createVariable", 300, 150, ["mark1", "mark2", "mark3", "mark4", "mark5", "mark6", "mark7", "mark8", "mark9", "mark10", "mark11", "mark12", "mark13", "mark14", "mark15", "mark16", "mark17", "mark18", "mark19", "mark20", "mark21", "mark22", "mark23", "mark24", "mark25"], 0, "variableCreate")
                                if (!preset)
                                    struct_set(test, [["instance", ins], ["instID", ins.instID]])
                                else
                                    struct_set(test, [["instance", ins], ["instID", obj_varstorage.values]])
                            }
                            else if (c.hovering != -1 && onX < (c.width - 8))
                            {
                                if (onX > (c.width - 20))
                                    variable_struct_remove(insData.variables, varList[c.hovering])
                                else
                                {
                                    var varName = varList[c.hovering]
                                    if is_array(varInfo[1][c.hovering])
                                    {
                                        var info = varInfo[1][c.hovering]
                                        var opList = []
                                        if is_string(info[1])
                                        {
                                            if variable_instance_exists(id, info[1])
                                                opList = variable_instance_get(id, info[1])
                                        }
                                        if is_array(info[1])
                                            opList = info[1]
                                        var cust = 1
                                        if (array_length(info) > 2)
                                        {
                                            if variable_struct_exists(info[2], "noCustom")
                                            {
                                                var cock = info[2]
                                                cust = (!cock.noCustom)
                                            }
                                        }
                                        if (!preset)
                                        {
                                            if (w_findCanvasIndex("valueDropdown") != -1)
                                            {
                                                w_openCanvas[w_findCanvasIndex("valueDropdown")].quickerase = 1
                                                wCanvas_close("valueDropdown")
                                            }
                                            var d = wCanvas_open_dropdown("valueDropdown", clamp((cursorX / w_scale), 0, (obj_screensizer.actual_width - c.width)), clamp((cursorY / w_scale), 0, (obj_screensizer.actual_height - c.height)), opList, _stGet("data.instances[" + string(ins.instID) + "].variables." + varName), "varValueSelected", "input custom value:")
                                            struct_set(d, [["instance", ins], ["instID", ins.instID], ["varName", varName], ["dropdownCustom", cust]])
                                        }
                                        else
                                        {
                                            if (w_findCanvasIndex("valueDropdown") != -1)
                                            {
                                                w_openCanvas[w_findCanvasIndex("valueDropdown")].quickerase = 1
                                                wCanvas_close("valueDropdown")
                                            }
                                            d = wCanvas_open_dropdown("valueDropdown", clamp((cursorX / w_scale), 0, (obj_screensizer.actual_width - c.width)), clamp((cursorY / w_scale), 0, (obj_screensizer.actual_height - c.height)), opList, struct_get(insData.variables, varName), "varValueSelected", "input custom value:")
                                            struct_set(d, [["instance", 1227], ["varName", varName], ["dropdownCustom", cust]])
                                        }
                                    }
                                    else
                                    {
                                        if (w_findCanvasIndex("editVariable") != -1)
                                        {
                                            w_openCanvas[w_findCanvasIndex("editVariable")].quickerase = 1
                                            wCanvas_close("editVariable")
                                        }
                                        if (w_findCanvasIndex("createVariable") != -1)
                                        {
                                            w_openCanvas[w_findCanvasIndex("createVariable")].quickerase = 1
                                            wCanvas_close("createVariable")
                                        }
                                        variableParamSelected = 1
                                        if (!preset)
                                            keyboard_string = string(_stGet("data.instances[" + string(ins.instID) + "].variables." + varName))
                                        else
                                            keyboard_string = string(variable_struct_get(obj_varstorage.values.variables, varName))
                                        if (keyboard_string == "undefined")
                                            keyboard_string = ""
                                        inVarMenu = 1
                                        test = wCanvas_open_dropdown("editVariable", 300, 150, ["mark1", "mark2", "mark3", "mark4", "mark5", "mark6", "mark7", "mark8", "mark9", "mark10", "mark11", "mark12", "mark13", "mark14", "mark15", "mark16", "mark17", "mark18", "mark19", "mark20", "mark21", "mark22", "mark23", "mark24", "mark25"], 0, "variableEdit")
                                        if (!preset)
                                            struct_set(test, [["instance", ins], ["instID", ins.instID], ["variableName", varName], ["variableValue", keyboard_string]])
                                        else
                                            struct_set(test, [["instance", ins], ["instID", obj_varstorage.values], ["variableName", varName], ["variableValue", keyboard_string]])
                                    }
                                }
                            }
                            instance_update_variables(ins, insData)
                        }
                        break
                    }
                case "autotileInd":
                    opts = []
                    var ts = _tileset(tilesetSelected)
                    for (j = 0; j < array_length(ts.autotile); j++)
                        opts[j] = j
                    if (array_length(opts) > 1)
                        struct_set(c, [["optionList", opts]])
                    else
                        wCanvas_close(c)
                    break
                case "autotileEditor":
                    var atd = tilesetStruct.autotile[tileset_autotileIndex]
                    if mouse_check_button(mb_left)
                    {
                        var xInd = floor(onX / gridSize)
                        var yInd = floor(onY / gridSize)
                        if (xInd == clamp(xInd, 0, 10) && yInd == clamp(yInd, 0, 5))
                        {
                            for (var xx = 0; xx < tilesetCoord[2]; xx++)
                            {
                                for (var yy = 0; yy < tilesetCoord[3]; yy++)
                                    atd[(xInd + xx)][(yInd + yy)] = [(tilesetCoord[0] + xx), (tilesetCoord[1] + yy)]
                            }
                            array_set(tilesetStruct.autotile, tileset_autotileIndex, atd)
                        }
                    }
                    if mouse_check_button_released(mb_left)
                    {
                        var atFile = "sprites/" + tilesetSelected + "_" + string(tileset_autotileIndex) + ".autotile"
                        if gml_Script_array_value_exists(global.defaultTilesets, tilesetSelected)
                            autotile_save(atd, gml_Script_editor_folder_afom(atFile))
                        else
                            autotile_save(atd, gml_Script_mod_folder_afom(atFile))
                    }
                    break
                case "autotileEditButton":
                    if mouse_check_button_pressed(mb_left)
                    {
                        var ind = w_findCanvasIndex("tileset")
                        if (ind != -1)
                        {
                            if (w_findCanvasIndex("autotileEditor") == -1)
                            {
                                t = w_openCanvas[ind]
                                wCanvas_open("autotileEditor", (t.x + t.width), t.y)
                            }
                            else
                                wCanvas_close("autotileEditor")
                        }
                    }
                    break
                case "noiseheads":
                    if (nselect == undefined)
                    {
                        cursorImage = 0
                        for (ind = 0; ind < array_length(levelSettings.noiseHeads); ind++)
                        {
                            xx = (struct_get(levelSettings.noiseHeads[ind], "x")) * cscale
                            yy = (struct_get(levelSettings.noiseHeads[ind], "y")) * cscale
                            var scale = (struct_get(levelSettings.noiseHeads[ind], "scale")) * cscale
                            var offset = 100 * scale
                            if point_in_rectangle(onX, onY, (xx - offset), (yy - offset), (xx + offset), (yy + offset))
                            {
                                cursorImage = 5
                                if mouse_check_button_pressed(mb_left)
                                    nselect = ind
                                if mouse_check_button(mb_right)
                                {
                                    array_delete(levelSettings.noiseHeads, ind, 1)
                                    ind -= 1
                                }
                            }
                        }
                        if mouse_check_button(mb_right)
                            cursorImage = 6
                        if (mouse_check_button_pressed(mb_left) && nselect == undefined)
                        {
                            var nstruct = struct_new([["x", (onX / cscale)], ["y", (onY / cscale)], ["scale", 1]])
                            array_push(levelSettings.noiseHeads, nstruct)
                            nselect = array_length(levelSettings.noiseHeads) - 1
                        }
                    }
                    else
                    {
                        cursorImage = 5
                        variable_struct_set(levelSettings.noiseHeads[nselect], "x", (onX / cscale))
                        variable_struct_set(levelSettings.noiseHeads[nselect], "y", (onY / cscale))
                        var scaling = mouse_wheel_up() - mouse_wheel_down()
                        scale = struct_get(levelSettings.noiseHeads[nselect], "scale")
                        variable_struct_set(levelSettings.noiseHeads[nselect], "scale", (scale + 0.05 * scaling))
                        if mouse_check_button_pressed(mb_left)
                            nselect = undefined
                    }
                    break
            }

        }
    }
}
instance_deactivate_object(obj_editorInst)
var v = view_camera[0]
instance_activate_region(camera_get_view_x(v), camera_get_view_y(v), camera_get_view_width(v), camera_get_view_height(v), true)
for (i = 0; i < array_length(unwanted); i++)
    instance_deactivate_object(unwanted[i])
with (obj_editorInst)
{
    image_speed = 0
    image_alpha = 1
    if (other.editor_state != other.st_instances && other.editor_state != -1)
        image_alpha = 0.5
    if (layer_get_name(layer) != gml_Script_layerFormat("Instances", other.layer_instances))
        image_alpha = 0.5
}
with (obj_tilemapDrawer)
{
    image_alpha = 1
    if (other.editor_state != other.st_tiles && other.editor_state != -1)
        image_alpha = 0.5
    if (layer_tilemap != other.layer_tilemap)
        image_alpha = 0.5
}
var edChange = keyboard_check_pressed(vk_tab)
editor_state += edChange
if (editor_state > st_popup)
    editor_state = -1
if (edChange != 0)
{
    windowQuickErase = 1
    windowQuickDraw = 1
    editorWindowUpdate()
}
if (!inVarMenu)
{
    switch editor_state
    {
        case st_instances:
            layer_instances += (keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left))
            break
        case st_tiles:
            layer_tilemap -= (keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left))
            break
        case st_backgrounds:
            layer_background -= (keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left))
            break
    }

}
layer_instances = clamp(layer_instances, 0, 100)
layer_tilemap = clamp(layer_tilemap, -8, 15)
var lvlW = struct_get(struct_get(data, "properties"), "levelWidth")
var lvlH = struct_get(struct_get(data, "properties"), "levelHeight")
var camW = camera_get_view_width(view_camera[0])
var camH = camera_get_view_height(view_camera[0])
cam_x = clamp(cam_x, ((-camW) + camW / 10 + _stGet("data.properties.roomX")), (lvlW - camW / 10))
cam_y = clamp(cam_y, ((-camH) + camH / 10 + _stGet("data.properties.roomY")), (lvlH - camH / 10))
camera_set_view_pos(view_camera[0], cam_x, cam_y)
scroll_x = mouse_x
scroll_y = mouse_y
if keyboard_check_pressed(vk_f5)
    playRoom()
if keyboard_check_pressed(vk_return)
{
    rp = roomPath()
    saveData()
}
if keyboard_check_pressed(vk_escape)
{
    saveData()
    room_goto(rmModMenu)
}
if updateUndoMemory
{
    ds_stack_clear(redo_stack)
    ds_stack_push(undo_stack, prevData)
    updateUndoMemory = 0
}
if keyboard_check(vk_control)
{
    if keyboard_check_pressed(ord("Z"))
    {
        if (!ds_stack_empty(undo_stack))
        {
            var memString = ds_stack_pop(undo_stack)
            ds_stack_push(redo_stack, json_stringify(data))
            initStage(json_parse(memString))
        }
    }
    if keyboard_check_pressed(ord("Y"))
    {
        if (!ds_stack_empty(redo_stack))
        {
            memString = ds_stack_pop(redo_stack)
            ds_stack_push(undo_stack, json_stringify(data))
            initStage(json_parse(memString))
        }
    }
}
variable_struct_set(global.editorMemory, lvlRoom, new_memoryVarStruct())


// NEW
if (keyboard_check_pressed(ord("K"))) {
    selectingMode = !selectingMode
}
if (keyboard_check(ord("P"))) {
    cx = round(mouse_x)
    cy = round(mouse_y)
    cursorNotice = fstring("{cx}, {cy}")
}