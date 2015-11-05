bucket = {}
bucket.liquids = {}

local function check_protection(pos, name, text)
	if minetest.is_protected(pos, name) then
		minetest.log("action", (name ~= "" and name or "A mod")
			.. " tried to " .. text
			.. " at protected position "
			.. minetest.pos_to_string(pos)
			.. " with a bucket")
		minetest.record_protection_violation(pos, name)
		return true
	end
	return false
end

local function place_liquid(pos, node, user, source, flowing)
	if check_protection(pos, user and user:get_player_name() or "",
			"place " .. source) or node.name == source then
		return
	end
	minetest.add_node(pos, {name = source})
end

local function check_rightclick(ndef, node, user, pointed_thing, itemstack)
	-- Call on_rightclick if the pointed node defines it
	if ndef and ndef.on_rightclick and
		 user and not user:get_player_control().sneak then
		return ndef.on_rightclick(
			pointed_thing.under,
			node, user,
			itemstack) or itemstack
	end
end

-- Register a new liquid
--   source = name of the source node
--   flowing = name of the flowing node
--   itemname = name of the new bucket item (or nil if liquid is not takeable)
--   inventory_image = texture of the new bucket item (ignored if itemname == nil)
--   groups = (optional) groups of the bucket item, for example {water_bucket = 1}
-- This function can be called from any mod (that depends on bucket).
function bucket.register_liquid(source, flowing, itemname, inventory_image, name, groups)
	bucket.liquids[source] = {
		source = source,
		flowing = flowing,
		itemname = itemname,
	}
	bucket.liquids[flowing] = bucket.liquids[source]

	if itemname ~= nil then
		minetest.register_craftitem(itemname, {
			description = name,
			inventory_image = inventory_image,
			stack_max = 1,
			groups = groups or {bucket = 1},
			on_place = function(itemstack, user, pointed_thing)
				-- Must be pointing to node
				if pointed_thing.type ~= "node" then
					return
				end

				local above_node = minetest.get_node_or_nil(pointed_thing.above)
				local under_node = minetest.get_node_or_nil(pointed_thing.under)
				local na_def = minetest.registered_nodes[above_node.name]
				local nu_def = minetest.registered_nodes[under_node.name]


				local abort = check_rightclick(nu_def, under_node, user, pointed_thing, itemstack)
				if abort then
					return abort
				end

				-- Check if pointing to a buildable node
				if na_def and na_def.buildable_to and (na_def.liquidtype == "none" or
				 		source == na_def.liquid_alternative_source) then
					place_liquid(pointed_thing.above, above_node, user,	source, flowing)
				else
					-- do not remove the bucket with the liquid
					return
				end
				local retval = {name = "bucket:bucket_empty"}
				if minetest.setting_getbool("creative_mode") == true then
					retval = nil
				end
				return retval
			end
		})
	end
end

minetest.register_craftitem("bucket:bucket_empty", {
	description = "Empty Bucket",
	inventory_image = "bucket.png",
	stack_max = 99,
	on_place = function(itemstack, user, pointed_thing)
		-- Must be pointing to node
		if pointed_thing.type ~= "node" then
			return
		end

		local above_node = minetest.get_node_or_nil(pointed_thing.above)
		local under_node = minetest.get_node_or_nil(pointed_thing.under)
		local na_def = minetest.registered_nodes[above_node.name]
		local nu_def = minetest.registered_nodes[under_node.name]

		local abort = check_rightclick(nu_def, under_node, user, pointed_thing, itemstack)
		if abort then
			return abort
		end

		local liquiddef = bucket.liquids[above_node.name]
		local item_count = user:get_wielded_item():get_count()

		if liquiddef ~= nil
		and liquiddef.itemname ~= nil
		and above_node.name == liquiddef.source then
			if check_protection(pointed_thing.above,
					user:get_player_name(),
					"take " .. above_node.name) then
				return
			end

			-- default set to return filled bucket
			local giving_back = liquiddef.itemname

			-- check if holding more than 1 empty bucket
			if item_count > 1 then

				-- if space in inventory add filled bucked, otherwise drop as item
				local inv = user:get_inventory()
				if inv:room_for_item("main", {name = liquiddef.itemname}) then
					inv:add_item("main", liquiddef.itemname)
				else
					local pos = user:getpos()
					pos.y = math.floor(pos.y + 0.5)
					core.add_item(pos, liquiddef.itemname)
				end

				-- set to return empty buckets minus 1
				giving_back = "bucket:bucket_empty " .. tostring(item_count-1)

			end

			minetest.add_node(pointed_thing.above, {name = "air"})

			local retval = ItemStack(giving_back)
			if minetest.setting_getbool("creative_mode") == true then
				retval = itemstack
			end
			return retval
		end
	end,
})


-- Register buckets
bucket.register_liquid(
	"default:water_source",
	"default:water_flowing",
	"bucket:bucket_water",
	"bucket_water.png",
	"Water Bucket"
)

bucket.register_liquid(
	"default:lava_source",
	"default:lava_flowing",
	"bucket:bucket_lava",
	"bucket_lava.png",
	"Lava Bucket",
	{bucket = 1, fuel = 60}
)

minetest.register_craft({
	output = 'bucket:bucket_empty 1',
	recipe = {
		{'default:steel_ingot', '', 'default:steel_ingot'},
		{'', 'default:steel_ingot', ''},
	}
})

minetest.register_alias("bucket", "bucket:bucket_empty")
minetest.register_alias("bucket_water", "bucket:bucket_water")
minetest.register_alias("bucket_lava", "bucket:bucket_lava")
