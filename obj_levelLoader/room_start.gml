// Put in file

// [start?, id, name, val], varInst format
for (var i = 0; i < array_length(varInsts); i++)
{   
    var inst = varInsts[i];

    var inst_start = inst[0];
    var inst_id = inst[1];
    var inst_name = inst[2];
    var inst_val = inst[3];

    var inst_local = string_starts_with(inst_name, "v");

    if (!inst_start) {
        continue;
    }
    else if (inst_local) {
        var target_local = string_delete(inst_name, 1, 3);
        var target_global = inst_val;

        set_global_to_local(inst_id, target_global, target_local);
    } else {
        var target_global = string_delete(inst_name, 1, 3);
        var target_local = inst_val;

        set_local_to_global(inst_id, target_local, target_global);
    }
}
