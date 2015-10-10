local leaves_def = {
	description = "Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	visual_scale = 1.3,
	tiles = {"default_leaves.png"},
	special_tiles = {"default_leaves_simple.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	sounds = default.node_sound_leaves_defaults(),
	after_place_node = default.after_place_leaves,
}

function default.register_leaves(name, special_def)
	local def = table.copy(leaves_def)
	for k,v in pairs(special_def) do
		def[k] = v
	end

	minetest.register_node(name, def)
end

default.register_leaves("default:leaves", {
	description = "Leaves",
	tiles = {"default_leaves.png"},
	special_tiles = {"default_leaves_simple.png"},
	drop = {
		max_items = 1,
		items = {
			{items = {'default:sapling'}, rarity = 20},
			{items = {'default:leaves'}}
		}
	}
})

default.register_leaves("default:jungleleaves", {
	description = "Jungle Leaves",
	tiles = {"default_jungleleaves.png"},
	special_tiles = {"default_jungleleaves_simple.png"},
	drop = {
		max_items = 1,
		items = {
			{items = {'default:junglesapling'}, rarity = 20},
			{items = {'default:jungleleaves'}}
		}
	}
})


default.register_leaves("default:pine_needles", {
	description = "Pine Needles",
	tiles = {"default_pine_needles.png"},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:pine_sapling"}, rarity = 20},
			{items = {"default:pine_needles"}}
		}
	}
})

default.register_leaves("default:acacia_leaves", {
	description = "Acacia Leaves",
	tiles = {"default_acacia_leaves.png"},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:acacia_sapling"}, rarity = 20},
			{items = {"default:acacia_leaves"}}
		}
	}
})
