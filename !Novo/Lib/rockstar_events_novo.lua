
-- R*'s great coding allows for some intresting things to happen, this is a silly section to experiment with them.

--Rockstar_events
menu.add_feature("Disable Idle Camera", "toggle", rockstar_events.id, function(feat)

    function disableIdleCamera()
        native.call(0xF4F2C0D4EE209E20)
    end

    while feat.on do
        disableIdleCamera()
        system.yield(1000)
    end
end)

menu.add_feature("Disable Idle Vehicle Camera", "toggle", rockstar_events.id, function(feat)

    function disableIdleVehCamera()
        native.call(0x9E4CFFF989258472)
    end
    
    while feat.on do
        disableIdleVehCamera()
        system.yield(1000)
    end
end)

-- Assuming 'rockstar_events' is a pre-defined category in your menu
-- and 'native' is the API for calling native functions

menu.add_feature("Anti-Render Camera", "toggle", rockstar_events.id, function(feat, pid)
--    local get_cam_coord = 0xBAC038F7459AE5AE -- Native hash for GET_CAM_COORD
--    local set_cam_coord = 0x4D41783FB745E42E -- Native hash for SET_CAM_COORD
--    local get_rendering_cam = 0x5234F9F10919EABA -- Native hash for GET_RENDERING_CAM
--    local currentCamId = native.call(get_rendering_cam)
    -- Store the current camera coordinates before making changes
--    local normalcoords = native.call(get_cam_coord, currentCamId)
    -- The loop that runs while the feature is toggled on
--    streaming.request_model(gameplay.get_hash_key("tractor"))
--    while not streaming.has_model_loaded(gameplay.get_hash_key("tractor")) do
 --       system.yield(25)
---    end
--    local cam_veh = vehicle.create_vehicle(gameplay.get_hash_key("tractor"), v3(0,0,0), 0, true, false)
 --   entity.freeze_entity(cam_veh, true)
--    entity.set_entity_coords_no_offset(cam_veh, v3(-8292.664, -4596.8257, 14358.0))
--    while feat.on do
--       system.yield(100) -- This is important to prevent freezing the game in the loop
        -- Set camera coordinates to the new location
--        native.call(set_cam_coord, currentCamId, -8292.664, -4596.8257, 14358.0)
--        native.call(0xA2297E18F3E71C2E, cam_veh, 0, 0, 0, true, 100, 50, 50)
--    end
    -- When the feature is turned off, revert to original coordinates
--    native.call(set_cam_coord, currentCamId, normalcoords.x, normalcoords.y, normalcoords.z)
    normalcoords = player.get_player_coords(player.player_id())
    myPed = player.get_player_ped(player.player_id())

    while feat.on do
        system.yield(100) 
        entity.freeze_entity(myPed, true)
        entity.set_entity_coords_no_offset(myPed, v3(-8292.664, -4596.8257, 14358.0))
    end

    entity.freeze_entity(myPed, false)
    entity.set_entity_coords_no_offset(myPed, normalcoords)
end)

Force_Delete_entity = menu.add_feature("Force Delete Aimed at Entity", "action", rockstar_events.id, function(feat, pid)
    local aimedEntity = player.get_entity_player_is_aiming_at(player.player_id())
    if aimedEntity and entity.is_entity_a_vehicle(aimedEntity) or entity.is_entity_a_ped(aimedEntity) or entity.is_entity_an_object(aimedEntity)then
        local maxAttempts = 250
        local hasControl = false
        -- Somehow gets control of an entity if a menu has bad pasted protections against giving others control. 
        for i = 1, maxAttempts do
            if network.has_control_of_entity(aimedEntity) then
                hasControl = true
                break
            else
                network.request_control_of_entity(aimedEntity)
                system.yield(0)
            end
        end
        if not network.has_control_of_entity(aimedEntity) then
            for i = 1, maxAttempts do
                network.request_control_of_entity(aimedEntity)
                system.yield(0)
            end 
        end
    entity.set_entity_coords_no_offset(aimedEntity, v3(-5784.258,-8289.386,136.411)) -- Outside of map
    entity.set_entity_as_no_longer_needed(aimedEntity)
    end
end)

reset_sell_timer = menu.add_feature("Reset Cooldown Timer:", "action_value_str", rockstar_events.id, function(feat)
    local selectedOption = feat.value + 1  -- Increment by 1 due to 0-indexing
    if selectedOption == 1 then
        local statNames = {
            "MPPLY_VEHICLE_SELL_TIME",
            "MPPLY_NUM_CARS_SOLD_TODAY"
        }

        for _, statName in ipairs(statNames) do
            stats.stat_set_int(gameplay.get_hash_key(statName), 0, true)
        end
        menu.notify("Vehicle Sell Cooldown Timer Reset", "Success")
    elseif selectedOption == 2 then
        stats.stat_set_int(gameplay.get_hash_key(constructMPCharKey() .. "SALV23_VEHROB_CD"), -1, true)
        menu.notify("Salvage Yard Cooldown Timer Reset", "Success")
    end
end)

reset_sell_timer:set_str_data({"Vehicle Sell Cooldown Timer", "Salvage Yard Cooldown Timer"})

menu.add_feature("Unlock All Achievements", "action", rockstar_events.id, function()
    for i = 1,77 do
        native.call(0xBEC7076D64130195, i)
        system.yield(5)
    end
end)
