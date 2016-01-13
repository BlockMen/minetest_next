minetest.register_node("default:wood", {
	description = "Wooden Planks",
	tiles = {"default_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, wood = 1, fuel = 8},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:junglewood", {
	description = "Junglewood Planks",
	tiles = {"default_junglewood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, wood = 1, fuel = 8},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:pine_wood", {
	description = "Pine Wood Planks",
	tiles = {"default_pine_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, wood = 1, fuel = 8},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:acacia_wood", {
	description = "Acacia Wood Planks",
	tiles = {"default_acacia_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, wood = 1, fuel = 8},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:birch_wood", {
	description = "Birch Wood Planks",
	tiles = {"default_birch_wood.png"},
	is_ground_content = false,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})
