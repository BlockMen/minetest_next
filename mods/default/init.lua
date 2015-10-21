-- Minetest 0.4 mod: default
-- See README.txt for licensing and other information.

-- The API documentation in here was moved into game_api.txt

-- Definitions made by this mod that other mods can use too
default = {}

default.LIGHT_MAX = 14

-- GUI related stuff
default.gui_bg = "bgcolor[#080808BB;true]"
default.gui_bg_img = "background[5,5;1,1;gui_formbg.png;true]"
default.gui_slots = "listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"

function default.get_hotbar_bg(x,y)
	local out = ""
	for i=0,7,1 do
		out = out .."image["..x+i..","..y..";1,1;gui_hb_bg.png]"
	end
	return out
end

default.gui_survival_form = "size[8,8.5]"..
			default.gui_bg..
			default.gui_bg_img..
			default.gui_slots..
			"list[current_player;main;0,4.25;8,1;]"..
			"list[current_player;main;0,5.5;8,3;8]"..
			"list[current_player;craft;1.75,0.5;3,3;]"..
			"list[current_player;craftpreview;5.75,1.5;1,1;]"..
			"image[4.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
			"listring[current_player;main]"..
			"listring[current_player;craft]"..
			default.get_hotbar_bg(0,4.25)

-- Load files
local modpath = minetest.get_modpath("default")
local mg_name = minetest.get_mapgen_params().mgname or ""

dofile(modpath .. "/functions.lua")
dofile(modpath .. "/environment.lua")
dofile(modpath .. "/nodes.lua")
dofile(modpath .. "/tools.lua")
dofile(modpath .. "/craftitems.lua")
dofile(modpath .. "/crafting.lua")
dofile(modpath .. "/mapgen.lua")
if mg_name == "v6" then
	dofile(modpath .. "/mapgenv6.lua")
elseif mg_name == "v5" or mg_name == "v7" then
	dofile(modpath .. "/mapgenv57.lua")
end
dofile(modpath .. "/player.lua")
dofile(modpath .. "/trees.lua")
dofile(modpath .. "/aliases.lua")
dofile(modpath .. "/legacy.lua")
