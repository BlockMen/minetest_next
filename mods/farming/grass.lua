for i = 1, 5 do		
	minetest.override_item("default:grass_"..i, {drop = {
		max_items = 1,
		items = {
			{items = {'farming:seed_wheat'},rarity = 5},
			{items = {'default:grass_1'}},
		}
	}})
end
	
minetest.override_item("default:junglegrass", {drop = {
	max_items = 1,
	items = {
		{items = {'farming:seed_cotton'},rarity = 8},
		{items = {'default:junglegrass'}},
	}
}})
