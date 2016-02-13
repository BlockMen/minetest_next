function default.register_table(itemstring, def)
	local material = def.material
	
	-- set defaults if nothing is set already
	if not def.groups then
		def.groups = {choppy = 2, flammable = 2, oddly_breakable_by_hand = 2, fuel = 6}
	end
	if not def.sounds then
		def.sounds = default.node_sound_wood_defaults()
	end

	-- set table properties
	def.paramtype = "light"
	def.drawtype = "nodebox"
	def.node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.375, -0.5, 0.5, 0.5, 0.5},
			{-0.1875, -0.5, -0.1875, 0.1875, 0.375, 0.1875}
		}
	}
	
	-- clean up variables
	def.material = nil
	
	-- register the table node
	minetest.register_node(itemstring, def)
	
	-- and register the crafting recipe
	minetest.register_craft({
		output = itemstring .. " 4",
		recipe = {
			{material, material, material},
			{   "",    material,    ""   },
			{   "",    material,    ""   },
		}
	})

end

default.register_table("default:table_wood", {
	description = "Wooden Table",
	tiles = {"default_wood.png"},
	material = "default:wood"
})

default.register_table("default:table_junglewood", {
	description = "Junglewood Table",
	tiles = {"default_junglewood.png"},
	material = "default:junglewood"
})

default.register_table("default:table_pinewood", {
	description = "Pine Wood Table",
	tiles = {"default_pine_wood.png"},
	material = "default:pinewood"
})

default.register_table("default:table_acaciawood", {
	description = "Acacia Wood Table",
	tiles = {"default_acacia_wood.png"},
	material = "default:acacia_wood"
})

default.register_table("default:table_birchwood", {
	description = "Birch Wood Table",
	tiles = {"default_birch_wood.png"},
	material = "default:birch_wood"
})

default.register_table("default:table_stone", {
	description = "Stone Table",
	tiles = {"default_stone.png"},
	material = "default:stone",
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults()
})

default.register_table("default:table_cobble", {
	description = "Cobblestone Table",
	tiles = {"default_cobble.png"},
	material = "default:cobble",
	groups = {cracky = 2},
	sounds = default.node_sound_stone_defaults()
})
