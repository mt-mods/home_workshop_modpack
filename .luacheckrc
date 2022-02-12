unused_args = false
allow_defined_top = true

exclude_files = {".luacheckrc"}

globals = {
    "minetest", "core",

    --mod provided
    "home_vending_machines", "computers",
}

read_globals = {
    string = {fields = {"split"}},
    table = {fields = {"copy", "getn"}},

    --luac
    "math", "table",

    -- Builtin
    "vector", "ItemStack", "dump", "DIR_DELIM", "VoxelArea", "Settings", "PcgRandom", "VoxelManip", "PseudoRandom",

    --mod produced
    "default", "screwdriver", "unifieddyes", "formspec_ast", 
}