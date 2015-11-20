local dyes = {
	{"white",	"White"},
	{"grey",	"Grey"},
	{"black",	"Black"},
	{"red",		"Red"},
	{"yellow",	"Yellow"},
	{"green",	"Green"},
	{"cyan",	"Cyan"},
	{"blue",	"Blue"},
	{"magenta",	"Magenta"},
	{"orange",	"Orange"},
	{"violet",	"Violet"},
	{"brown",	"Brown"},
	{"pink",	"Pink"},
	{"dark_grey",	"Dark Grey"},
	{"dark_green",	"Dark Green"}
}

for _, row in ipairs(dyes) do
	local name = row[1]
	local desc = row[2]
	
	-- Node Definition
	minetest.register_node("default:carpet_"..name, {
		description = desc.." Carpet",
		tiles = {"wool_"..name..".png"},
		is_ground_content = true,
		paramtype = "light",
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5,  0.5, -0.57+2/16, 0.5},
			},
		},
		groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, flammable = 3, carpet = 1, attached_node = 1},
		sounds = default.node_sound_defaults(),
	})
	
	-- Crafting from wool
	minetest.register_craft({
		output = "default:carpet_" .. name .. " 3",
		recipe = {
			{"wool:" .. name, "wool:" .. name},
		},
	})
end
