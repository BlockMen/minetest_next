local modpath = minetest.get_modpath("default")

dofile(modpath .. "/nodes/old.lua")

-- full/natural/mapgen
dofile(modpath .. "/nodes/ores.lua")
dofile(modpath .. "/nodes/leaves.lua")


-- special
dofile(modpath .. "/nodes/torch.lua")
dofile(modpath .. "/nodes/furnace.lua")
dofile(modpath .. "/nodes/chests.lua")
dofile(modpath .. "/nodes/bookshelf.lua")
