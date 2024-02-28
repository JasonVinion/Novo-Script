-- Object CREATE_AMBIENT_PICKUP(Hash pickupHash, float posX, float posY, float posZ, int flags, int value, Hash modelHash, BOOL p7, BOOL p8) // 0x673966A0C0FD7171 0x17B99CE7 b323

menu.add_player_feature("1k money + rp drop", "toggle", drops, function(feat, pid)
    local droprp = gameplay.get_hash_key("vw_prop_vw_colle_prbubble")
    streaming.request_model(droprp)
    while not streaming.has_model_loaded(droprp) do
        system.yield(0)
    end
    while feat.on do
        coords = player.get_player_coords(pid)
        native.call(0x673966A0C0FD7171, -1009939663, coords.x, coords.y, coords.z, 0, 1, droprp, false, true)
        system.yield(25)
    end
end)

casino_card_drop = menu.add_player_feature("Playing Cards Drop", "toggle", drops, function(feat, pid)
    local drop = gameplay.get_hash_key("vw_prop_vw_lux_card_01a")
    streaming.request_model(drop)
    while not streaming.has_model_loaded(drop) do
        system.yield(0)
    end
    while feat.on do
        coords = player.get_player_coords(pid)
        native.call(0x673966A0C0FD7171, -1009939663, coords.x, coords.y, coords.z, 0, 1, drop, false, true)
        system.yield(25)
    end
end)

menu.add_player_feature("health pack drop", "toggle", drops, function(feat, pid)
    local drop = gameplay.get_hash_key("prop_ld_health_pack")
    streaming.request_model(drop)
    while not streaming.has_model_loaded(drop) do
        system.yield(0)
    end
    while feat.on do
        coords = player.get_player_coords(pid)
        native.call(0x673966A0C0FD7171, 2406513688, coords.x, coords.y, coords.z, 0, 1, drop, false, true)
        system.yield(25)
    end
end)

menu.add_player_feature("snacks drop", "toggle", drops, function(feat, pid)
    local drop = gameplay.get_hash_key("PROP_CHOC_PQ")
    streaming.request_model(drop)
    while not streaming.has_model_loaded(drop) do
        system.yield(0)
    end
    while feat.on do
        coords = player.get_player_coords(pid)
        native.call(0x673966A0C0FD7171, 483577702, coords.x, coords.y, coords.z, 0, 1, drop, false, true)
        system.yield(25)
    end
end)

menu.add_player_feature("parachute drop", "toggle", drops, function(feat, pid)
    local drop = gameplay.get_hash_key("p_parachute_s_shop")
    streaming.request_model(drop)
    while not streaming.has_model_loaded(drop) do
        system.yield(0)
    end
    while feat.on do
        coords = player.get_player_coords(pid)
        native.call(0x673966A0C0FD7171, 1735599485, coords.x, coords.y, coords.z, 0, 1, drop, false, true)
        system.yield(25)
    end
end)

parse_and_update_feature(pickups_path)
-- Example of how to use the parsed data in your custom drop function
custom_drop = menu.add_player_feature("custom drop", "value_str", drops, function(feat, pid)
    local drop_index = feat.value + 1 -- Lua arrays start at 1
    local drop = gameplay.get_hash_key(models_pickup[drop_index])
    streaming.request_model(drop)
    while not streaming.has_model_loaded(drop) do
        system.yield(0)
    end
    while feat.on do
        local coords = player.get_player_coords(pid)
        -- Assuming the hash value is used correctly in the native call
        native.call(0x673966A0C0FD7171, hashes_pickup[drop_index], coords.x, coords.y, coords.z, 0, 1, drop, false, true)
        system.yield(25)
    end
end)

-- Set the string data for the custom drop to the names array
custom_drop:set_str_data(names_pickup)
