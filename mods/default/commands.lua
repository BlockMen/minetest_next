minetest.register_chatcommand("clearinv", {
	params = "<inventory>",
	description = "Clears an entire inventory, \"main\" if unspecified, \"craft\" is another possible choice",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		local player_inv = player:get_inventory()
		if not player then
			minetest.log("error", "Unable to clear inventory, no player.")
			return false, "Unable to clear inventory, no player."
		end
		if param == "" then
			player_inv:set_list("main", {})
			return true, "Inventory \"main\" cleared."
		else
			player_inv:set_list(param, {})
			return true, "Inventory \"" .. param .. "\" cleared."
		end
	end,
})

minetest.register_chatcommand("whoami", {
        params = "",
        description = "Tells your name",
        privs = {},
        func = function(name)
                minetest.chat_send_player(name, "Your name is: " .. name)
        end,
})

minetest.register_chatcommand("ip", {
        params = "",
        description = "Shows your IP address",
        privs = {},
        func = function(name)
                minetest.chat_send_player(name, "Your IP address is: "..minetest.get_player_ip(name))
        end
})

minetest.register_chatcommand("kill", {
        params = "",
        description = "Kills yourself",
        func = function(name, param)
                local player = minetest.get_player_by_name(name)
		if not player then return end
                if minetest.setting_getbool("enable_damage") == false then
                        minetest.chat_send_player(name, "Damage is disabled on this server.")
                else
			player:set_hp(0)
                        minetest.chat_send_player(name, "You suicided.")
                end
        end,
})
