default.register_fence(name, def)
	local fence_texture_1 = "default_fence_overlay.png^"
	local fence_texture_2 = "^default_fence_overlay.png^[makealpha:255,126,126"
	
	if not def.groups then
		def.groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, fuel = 4}
	end
	if not def.sounds then
		def.sounds = default.node_sound_wood_defaults()
	end
	
	minetest.register_node(name), {
		description = def.description,
		drawtype = "fencelike",
		tiles = {def.texture},
		inventory_image = fence_texture_1 .. def.texture .. fence_texture_2,
		wield_image = fence_texture_1 .. def.texture .. fence_texture_2,
		paramtype = "light",
		sunlight_propagates = true,
		is_ground_content = false,
		selection_box = {
			type = "fixed",
			fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
		},
		groups = def.groups,
		sounds = def.sounds,
	})
end

default.register_fence("default:fence_wood", {
	description = "Wooden Fence",
	texture = "default_wood.png",
})

default.register_fence("default:fence_junglewood", {
	description = "Junglewood Fence",
	texture = "default_junglewood.png",
})

default.register_fence("default:fence_pinewood", {
	description = "Pine Wood Fence",
	texture = "default_pine_wood.png",
})

default.register_fence("default:fence_acaciawood", {
	description = "Acacia Wood Fence",
	texture = "default_acacia_wood.png",
})
