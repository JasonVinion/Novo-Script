
--1214250852 use to spawn objects to make player stumble

-- debug_log_path = mainpath .. "\\scripts\\!Novo\\debug.txt"

debug_attached_entity = menu.add_player_feature("debug", "action", test_Player_features, function(feat, pid)
    local player_veh = player.get_player_vehicle(pid)

    -- Process all objects
    for _, obj in ipairs(object.get_all_objects()) do
        if entity.get_entity_attached_to(player_veh) == obj then
            menu.notify("entity: "..tostring(obj).." is attached to player veh", pid)
            logEntityAndHash(entity)
        end
        if entity.get_entity_attached_to(obj) == player_veh then
            menu.notify("entity: "..tostring(obj).." is attached to player veh", pid)
            logEntityAndHash(obj)
        end
    end

    -- Process all peds
    for _, ped in ipairs(ped.get_all_peds()) do
        if entity.get_entity_attached_to(player_veh) == ped then
            menu.notify("entity: "..tostring(ped).." is attached to player veh", pid)
            logEntityAndHash(entity)
        end
        if entity.get_entity_attached_to(ped) == player_veh then
            menu.notify("entity: "..tostring(ped).." is attached to player veh", pid)
            logEntityAndHash(ped)
        end
    end

    -- Process all vehicles
    for _, veh in ipairs(vehicle.get_all_vehicles()) do
        if entity.get_entity_attached_to(player_veh) == veh then
            menu.notify("entity: "..tostring(veh).." is attached to player veh", pid)
            logEntityAndHash(entity)
        end
        if entity.get_entity_attached_to(veh) == player_veh then
            menu.notify("entity: "..tostring(veh).." is attached to player veh", pid)
            logEntityAndHash(veh)
        end
    end

    -- Uncomment to process all pickups, if needed
    --[[ for _, pickup in ipairs(pickup.get_all_pickups()) do
        checkAndNotifyEntityAttached(player_veh, pickup)
    end ]]
end).hidden = true


-- entity: 522281 hash: 2627665880
-- 2627665880
-- 0xf63af8ac
-- po1_08_props_proplo_l15



menu.add_feature("Bike crate rider", "action", test_local_features.id, function(feat)
    local veh = player.get_player_vehicle(player.player_id())
    -- local coords = native.call(0x3FEF770D40960D5A, veh) `alive` = Unused by the game, potentially used by debug builds of GTA in order to assert whether or not an entity was alive.
    local coords = entity.get_entity_coords(veh)
    local rotation = native.call(0xAFBD61CC738D9EB9, veh, 1)
        streaming.request_model(gameplay.get_hash_key("prop_container_old1"))
        while not streaming.has_model_loaded(gameplay.get_hash_key("prop_container_old1")) do
            system.yield(0)
        end
        crateriderent = object.create_object(gameplay.get_hash_key("prop_container_old1"), v3(coords.x, coords.y, coords.z - 1.910), true, false, false)
    end)

    menu.add_feature("Drive On Water", "toggle", test_local_features.id, function(feat)
        local pid = player.player_id()
        if feat.on then
            if not driveThread_self then
                driveThread_self = menu.create_thread(function()
                    while feat.on do
                        if player.is_player_in_any_vehicle(pid) and entity.is_entity_in_water(player.get_player_vehicle(pid)) then
                            if drive_on_this_height_num_self % 2 == 0 then
                                slow_fall_veh(pid, 1.5) -- 1.5
                            else
                                slow_fall_veh(pid, 1.345) -- 1.9
                            end
                            drive_on_this_height_num_self = drive_on_this_height_num_self + 1
                        end
                    --    system.yield(0) -- Adjust yield as necessary for performance and responsiveness
                    end
                end)
            end
        else
            if driveThread_self then
                menu.delete_thread(driveThread_self)
                driveThread_self = nil
            end
        end
    end)
     





