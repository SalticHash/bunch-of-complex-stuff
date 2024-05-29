// Everything else is here for reference on where to put the things

data = global.roomData
varInsts = [] // ***PUT HERE*** //

for (var i = 0; i < array_length(data.instances); i++)
{
    var insts = struct_get(data, "instances")
    insData = insts[i]
    if (!insData.deleted)
    {
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
