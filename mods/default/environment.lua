--
-- Lavacooling
--

default.cool_lava_source = function(pos)
	minetest.set_node(pos, {name = "default:obsidian"})
	minetest.sound_play("default_cool_lava",
		{pos = pos, max_hear_distance = 16, gain = 0.25})
end

default.cool_lava_flowing = function(pos)
	minetest.set_node(pos, {name = "default:stone"})
	minetest.sound_play("default_cool_lava",
		{pos = pos, max_hear_distance = 16, gain = 0.25})
end

minetest.register_abm({
	nodenames = {"default:lava_flowing"},
	neighbors = {"group:water"},
	interval = 1,
	chance = 2,
	action = function(...)
		default.cool_lava_flowing(...)
	end,
})

minetest.register_abm({
	nodenames = {"default:lava_source"},
	neighbors = {"group:water"},
	interval = 1,
	chance = 2,
	action = function(...)
		default.cool_lava_source(...)
	end,
})


--
-- Growing
--

-- Grass
minetest.register_abm({
	nodenames = {"default:dirt"},
	interval = 2,
	chance = 200,
	action = function(pos, node)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		local name = minetest.get_node(above).name
		local nodedef = minetest.registered_nodes[name]
		if nodedef and (nodedef.sunlight_propagates or nodedef.paramtype == "light") and
				nodedef.liquidtype == "none" and
				(minetest.get_node_light(above) or 0) >= 13 then
			if name == "default:snow" or name == "default:snowblock" then
				minetest.set_node(pos, {name = "default:dirt_with_snow"})
			else
				minetest.set_node(pos, {name = "default:dirt_with_grass"})
			end
		end
	end
})

-- Remove grass
minetest.register_abm({
	nodenames = {"default:dirt_with_grass", "default:dirt_with_dry_grass"},
	interval = 2,
	chance = 20,
	action = function(pos, node)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		local name = minetest.get_node(above).name
		local nodedef = minetest.registered_nodes[name]
		if name ~= "ignore" and nodedef and not ((nodedef.sunlight_propagates or
				nodedef.paramtype == "light") and
				nodedef.liquidtype == "none") then
			minetest.set_node(pos, {name = "default:dirt"})
		end
	end
})


-- Cactus
function default.grow_cactus(pos, node)
	if node.param2 >= 4 then
		return
	end
	pos.y = pos.y - 1
	if minetest.get_item_group(minetest.get_node(pos).name, "sand") == 0 then
		return
	end
	pos.y = pos.y + 1
	local height = 0
	while node.name == "default:cactus" and height < 4 do
		height = height + 1
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if height == 4 or node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "default:cactus"})
	return true
end

minetest.register_abm({
	nodenames = {"default:cactus"},
	neighbors = {"group:sand"},
	interval = 50,
	chance = 20,
	action = function(...)
		default.grow_cactus(...)
	end
})


-- Papyrus
function default.grow_papyrus(pos, node)
	pos.y = pos.y - 1
	local name = minetest.get_node(pos).name
	if name ~= "default:dirt_with_grass" and name ~= "default:dirt" then
		return
	end
	if not minetest.find_node_near(pos, 3, {"group:water"}) then
		return
	end
	pos.y = pos.y + 1
	local height = 0
	while node.name == "default:papyrus" and height < 4 do
		height = height + 1
		pos.y = pos.y + 1
		node = minetest.get_node(pos)
	end
	if height == 4 or node.name ~= "air" then
		return
	end
	minetest.set_node(pos, {name = "default:papyrus"})
	return true
end

minetest.register_abm({
	nodenames = {"default:papyrus"},
	neighbors = {"default:dirt", "default:dirt_with_grass", "default:sand"},
	interval = 50,
	chance = 20,
	action = function(...)
		default.grow_papyrus(...)
	end
})


--
-- Leafdecay
--

default.leafdecay_trunk_cache = {}
default.leafdecay_enable_cache = true
-- Spread the load of finding trunks
default.leafdecay_trunk_find_allow_accumulator = 0

minetest.register_globalstep(function(dtime)
	local finds_per_second = 5000
	default.leafdecay_trunk_find_allow_accumulator =
			math.floor(dtime * finds_per_second)
end)

default.after_place_leaves = function(pos, placer, itemstack, pointed_thing)
	local node = minetest.get_node(pos)
	node.param2 = 1
	minetest.set_node(pos, node)
end

minetest.register_abm({
	nodenames = {"group:leafdecay"},
	neighbors = {"air", "group:liquid"},
	-- A low interval and a high inverse chance spreads the load
	interval = 2,
	chance = 5,

	action = function(p0, node, _, _)
		local do_preserve = false
		local d = minetest.registered_nodes[node.name].groups.leafdecay
		if not d or d == 0 then
			--print("not groups.leafdecay")
			return
		end
		local n0 = minetest.get_node(p0)
		if n0.param2 ~= 0 then
			return
		end
		local p0_hash = nil
		if default.leafdecay_enable_cache then
			p0_hash = minetest.hash_node_position(p0)
			local trunkp = default.leafdecay_trunk_cache[p0_hash]
			if trunkp then
				local n = minetest.get_node(trunkp)
				local reg = minetest.registered_nodes[n.name]
				-- Assume ignore is a trunk, to make the thing
				-- work at the border of the active area
				if n.name == "ignore" or (reg and reg.groups.tree and
						reg.groups.tree ~= 0) then
					return
				end
				-- Cache is invalid
				table.remove(default.leafdecay_trunk_cache, p0_hash)
			end
		end
		if default.leafdecay_trunk_find_allow_accumulator <= 0 then
			return
		end
		default.leafdecay_trunk_find_allow_accumulator =
				default.leafdecay_trunk_find_allow_accumulator - 1
		-- Assume ignore is a trunk, to make the thing
		-- work at the border of the active area
		local p1 = minetest.find_node_near(p0, d, {"ignore", "group:tree"})
		if p1 then
			do_preserve = true
			if default.leafdecay_enable_cache then
				-- Cache the trunk
				default.leafdecay_trunk_cache[p0_hash] = p1
			end
		end
		if not do_preserve then
			-- Drop stuff other than the node itself
			local itemstacks = minetest.get_node_drops(n0.name)
			for _, itemname in ipairs(itemstacks) do
				if minetest.get_item_group(n0.name, "leafdecay_drop") ~= 0 or
						itemname ~= n0.name then
					local p_drop = {
						x = p0.x - 0.5 + math.random(),
						y = p0.y - 0.5 + math.random(),
						z = p0.z - 0.5 + math.random(),
					}
					minetest.add_item(p_drop, itemname)
				end
			end
			-- Remove node
			minetest.remove_node(p0)
			nodeupdate(p0)
		end
	end
})

--
-- Item pick-up
--

minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		if player:get_hp() > 0 or not minetest.setting_getbool("enable_damage") then
			local pos = player:getpos()
			pos.y = pos.y+0.5
			local inv = player:get_inventory()
			
			for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 1)) do
				if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
					if inv and inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
						inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
						if object:get_luaentity().itemstring ~= "" then
							minetest.sound_play("default_item_pickup", {
								to_player = player:get_player_name(),
								gain = 0.4,
							})
						end
						object:get_luaentity().itemstring = ""
						object:remove()
					end
				end
			end
			
			for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 2)) do
				if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
					if object:get_luaentity().collect then
						if inv and inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
							local pos1 = pos
							pos1.y = pos1.y+0.2
							local pos2 = object:getpos()
							local vec = {x=pos1.x-pos2.x, y=pos1.y-pos2.y, z=pos1.z-pos2.z}
							vec.x = vec.x*3
							vec.y = vec.y*3
							vec.z = vec.z*3
							object:setvelocity(vec)
							object:get_luaentity().physical_state = false
							object:get_luaentity().object:set_properties({
								physical = false
							})
							
							minetest.after(1, function(args)
								local lua = object:get_luaentity()
								if object == nil or lua == nil or lua.itemstring == nil then
									return
								end
								if inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
									inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
									if object:get_luaentity().itemstring ~= "" then
										minetest.sound_play("item_drop_pickup", {
											to_player = player:get_player_name(),
											gain = 0.4,
										})
									end
									object:get_luaentity().itemstring = ""
									object:remove()
								else
									object:setvelocity({x=0,y=0,z=0})
									object:get_luaentity().physical_state = true
									object:get_luaentity().object:set_properties({
										physical = true
									})
								end
							end, {player, object})
							
						end
					end
				end
			end
		end
	end
end)
