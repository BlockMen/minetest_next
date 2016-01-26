function default.register_table(itemstring, def)
	
	if not def.groups then
		def.groups = {choppy = 2, flammable = 2, oddly_breakable_by_hand = 2, fuel = 6}
	end
	if not def.sounds then
		def.sounds = default.node_sound_wood_defaults()
	end
	
	minetest.register_node(itemstring, {
		description = def.description,
		tiles = {def.texture},
		drawtype = "nodebox",
		paramtype = "light",
		groups = def.groups,
		sounds = def.sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5},
				{-0.1875, -0.5, -0.1875, 0.1875, 0.375, 0.1875},
			}
		}
	})

	minetest.register_craft({
		output = itemstring .. " 4",
		recipe = {
			{def.material, def.material, def.material},
			{      "",     def.material,      ""     },
			{      "",     def.material,      ""     },
		}
	})
end

default.register_table("default:table_wood", {
	description = "Wooden Table",
	texture = "default_wood.png",
	material = "default:wood"
})

default.register_table("default:table_junglewood", {
	description = "Junglewood Table",
	texture = "default_junglewood.png",
	material = "default:junglewood"
})

default.register_table("default:table_pinewood", {
	description = "Pine Wood Table",
	texture = "default_pine_wood.png",
	material = "default:pinewood"
})

default.register_table("default:table_acaciawood", {
	description = "Acacia Wood Table",
	texture = "default_acacia_wood.png",
	material = "default:acacia_wood"
})

default.register_table("default:table_birchwood", {
	description = "Birch Wood Table",
	texture = "default_birch_wood.png",
	material = "default:birch_wood"
})

default.register_table("default:table_stone", {
	description = "Stone Table",
	texture = "default_stone.png",
	material = "default:stone"
})

default.register_table("default:table_cobble", {
	description = "Cobblestone Table",
	texture = "default_cobble.png",
	material = "default:cobble"
})
