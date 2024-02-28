local spam_sounds = menu.add_player_feature("Sound Spam", "value_str", greifing, function(feat, pid)
    local selectedOption = feat.value + 1
    local remotePedCoords = entity.get_entity_coords(player.get_player_ped(pid))
    local remotePedHeading = entity.get_entity_heading(player.get_player_ped(pid))
    local models = {vehicle = 0x79FBB0C5, cop = 1581098148}
        for _, model in pairs(models) do
            streaming.request_model(model)
            while not streaming.has_model_loaded(model) do
                system.yield(25)
            end
        end
        
        sound_veh = vehicle.create_vehicle(models.vehicle, remotePedCoords, remotePedHeading, true, false)
        sound_cop = ped.create_ped(6, models.cop, remotePedCoords, remotePedHeading, true, false)
        
        ped.set_ped_into_vehicle(sound_cop, sound_veh, -1)
        native.call(0xF4924635A19EB37D, sound_veh, true)
        
        entity.set_entity_collision(sound_veh, false, false)
        entity.set_entity_visible(sound_veh, false)

        if selectedOption == 1 then
            while feat.on do
                remotePedCoords = entity.get_entity_coords(player.get_player_ped(pid)) -- Update coords each loop iteration
                ped.set_ped_into_vehicle(sound_cop, sound_veh, -1)
                native.call(0xF4924635A19EB37D, sound_veh, true)
                entity.set_entity_coords_no_offset(sound_veh, remotePedCoords)
                system.yield(25)
            end
        elseif selectedOption == 2 then
            while feat.on do
                audio.play_sound_from_coord(-1, "Object_Dropped_Remote", player.get_player_coords(pid), "GTAO_FM_Events_Soundset", true, 1, false)
                audio.play_sound_from_coord(-1, "Hum", player.get_player_coords(pid), "SECURITY_CAMERA", true, 1, false)
                audio.play_sound_from_coord(-1, "Event_Message_Purple", player.get_player_coords(pid), "GTAO_FM_Events_Soundset", true, 1, false)
                audio.play_sound_from_coord(-1, "Checkpoint_Cash_Hit", player.get_player_coords(pid), "GTAO_FM_Events_Soundset", true, 1, false)
                audio.play_sound_from_coord(-1, "Event_Start_Text", player.get_player_coords(pid), "GTAO_FM_Events_Soundset", true, 1, false)
                audio.play_sound_from_coord(-1, "Checkpoint_Hit", player.get_player_coords(pid), "GTAO_FM_Events_Soundset", true, 1, false)
                audio.play_sound_from_coord(-1, "Return_To_Vehicle_Timer", player.get_player_coords(pid), "GTAO_FM_Events_Soundset", true, 1, true)
                audio.play_sound_from_coord(-1, "5s", player.get_player_coords(pid), "MP_MISSION_COUNTDOWN_SOUNDSET", true, 1, false)
                audio.play_sound_from_coord(-1, "10s", player.get_player_coords(pid), "MP_MISSION_COUNTDOWN_SOUNDSET", true, 1, false)
                audio.play_sound_from_coord(-1, "Arrive_Horn", player.get_player_coords(pid), "DLC_Apartment_Yacht_Streams_Soundset", true, 1, false)
                audio.play_sound_from_coord(-1, "Biker_Ride_Off", player.get_player_coords(pid), "ARM_2_REPO_SOUNDS", true, 1, false)
                system.yield(10)
            end
        end

        entity.delete_entity(sound_veh)
        entity.delete_entity(sound_cop)
end)

spam_sounds:set_str_data({"Siren", "Regular"})


-- Parse the attachments files
local attachPeds = parseAttachPedsFile(attach_peds_path)
local attachments = parseAttachmentsFile(attach_obj_path)
local attachVehicles = parseAttachVehFile(attach_veh_path)

local attached_objects = {}
-- Add the feature

menu.add_player_feature("Remove Attachments", "action", attachments_menu, function(feat, pid)
    for i, object in ipairs(attached_objects) do
        network.request_control_of_entity(object)
        while not network.has_control_of_entity(object) do
            system.yield(0)
        end
        entity.delete_entity(object)
        attached_objects[i] = nil
    end
end)

local attach_obj_feature = menu.add_player_feature("attach object: ", "action_value_str", attachments_menu, function(feat, pid)
    if not attachments or #attachments == 0 then
        menu.notify("No attachments found", "Error", 5)
        return
    end
    
    local selectedAttachment = attachments[feat.value + 1] -- +1 because Lua tables are 1-indexed
    local hash = gameplay.get_hash_key(selectedAttachment.hash)
    local target_ped = player.get_player_ped(pid)
    
    streaming.request_model(hash)
    while not streaming.has_model_loaded(hash) do
        system.yield(0)
    end
    
    local object = object.create_object(hash, entity.get_entity_coords(target_ped), true, false)
    entity.attach_entity_to_entity(object, target_ped, 0, v3(0, 0, 0), v3(0, 0, 0), false, true, false, 0, true)

    table.insert(attached_objects, object)

    streaming.set_model_as_no_longer_needed(hash)
end)

-- Set the string data for the feature based on parsed file
attach_obj_feature:set_str_data(getAttachmentNames(attachments))

local attach_ped_feature = menu.add_player_feature("Attach Ped: ", "action_value_str", attachments_menu, function(feat, pid)
    if not attachPeds or #attachPeds == 0 then
        menu.notify("No peds found", "Error", 5)
        return
    end
    
    local selectedPed = attachPeds[feat.value + 1] -- Lua tables are 1-indexed
    local hash = tonumber(selectedPed.hash)
    local targetPed = player.get_player_ped(pid)
    
    streaming.request_model(hash)
    while not streaming.has_model_loaded(hash) do
        system.yield(0)
    end
    
    local ped = ped.create_ped(26, hash, entity.get_entity_coords(targetPed), 0, true, false)
    entity.attach_entity_to_entity(ped, targetPed, 0, v3(0, 0, 0), v3(0, 0, 0), false, true, false, 0, true)
    table.insert(attached_objects, ped) -- Add to array for later deletion
end)

-- Set the string data for the feature based on parsed file
attach_ped_feature:set_str_data(getPedNames(attachPeds))

local attach_veh_feature = menu.add_player_feature("Attach Vehicle: ", "action_value_str", attachments_menu, function(feat, pid)
    if not attachVehicles or #attachVehicles == 0 then
        menu.notify("No vehicles found", "Error", 5)
        return
    end
    
    local selectedVehicle = attachVehicles[feat.value + 1] -- Lua tables are 1-indexed
    local hash = selectedVehicle.hash
    local targetPed = player.get_player_ped(pid)
    
    streaming.request_model(hash)
    while not streaming.has_model_loaded(hash) do
        system.yield(0)
    end
    
    local coords = entity.get_entity_coords(targetPed)
    local vehicle = vehicle.create_vehicle(hash, coords, 0, true, false)
    entity.attach_entity_to_entity(vehicle, targetPed, 0, v3(0, 0, 0), v3(0, 0, 0), false, true, false, 0, true)
    table.insert(attached_objects, vehicle) -- Add to array for later deletion
end)

-- Set the string data for the feature based on parsed file
attach_veh_feature:set_str_data(getVehicleNames(attachVehicles))


local attach_obj_to_veh_feature = menu.add_player_feature("Attach Object to Vehicle: ", "action_value_str", attachments_menu, function(feat, pid)
    if not attachments or #attachments == 0 then
        menu.notify("No attachments found", "Error", 5)
        return
    end
    
    local selectedAttachment = attachments[feat.value + 1]
    local hash = gameplay.get_hash_key(selectedAttachment.hash)
    local playerVeh = player.get_player_vehicle(pid)
    if playerVeh == 0 then
        menu.notify("Player is not in a vehicle", "Error", 5)
        return
    end
    
    streaming.request_model(hash)
    while not streaming.has_model_loaded(hash) do
        system.yield(0)
    end
    
    local vehCoords = entity.get_entity_coords(playerVeh)
    local object = object.create_object(hash, vehCoords, true, false)
    entity.attach_entity_to_entity(object, playerVeh, 0, v3(0, 0, 0), v3(0, 0, 0), false, true, false, 0, true)
    table.insert(attached_objects, object)
    streaming.set_model_as_no_longer_needed(hash)
end)
attach_obj_to_veh_feature:set_str_data(getAttachmentNames(attachments))

local attach_ped_to_veh_feature = menu.add_player_feature("Attach Ped to Vehicle: ", "action_value_str", attachments_menu, function(feat, pid)
    if not attachPeds or #attachPeds == 0 then
        menu.notify("No peds found", "Error", 5)
        return
    end
    
    local selectedPed = attachPeds[feat.value + 1]
    local hash = tonumber(selectedPed.hash)
    local playerVeh = player.get_player_vehicle(pid)
    if playerVeh == 0 then
        menu.notify("Player is not in a vehicle", "Error", 5)
        return
    end
    
    streaming.request_model(hash)
    while not streaming.has_model_loaded(hash) do
        system.yield(0)
    end
    
    local vehCoords = entity.get_entity_coords(playerVeh)
    local ped = ped.create_ped(26, hash, vehCoords, 0, true, false)
    entity.attach_entity_to_entity(ped, playerVeh, 0, v3(0, 0, 0), v3(0, 0, 0), false, true, false, 0, true)
    table.insert(attached_objects, ped)
end)
attach_ped_to_veh_feature:set_str_data(getPedNames(attachPeds))

local attach_veh_to_veh_feature = menu.add_player_feature("Attach Vehicle to Vehicle: ", "action_value_str", attachments_menu, function(feat, pid)
    if not attachVehicles or #attachVehicles == 0 then
        menu.notify("No vehicles found", "Error", 5)
        return
    end
    
    local selectedVehicle = attachVehicles[feat.value + 1] -- Lua tables are 1-indexed
    local hash = selectedVehicle.hash
    local targetPed = player.get_player_ped(pid)
    local targetveh = player.get_player_vehicle(pid)
    
    streaming.request_model(hash)
    while not streaming.has_model_loaded(hash) do
        system.yield(0)
    end
    
    local coords = entity.get_entity_coords(targetPed)
    local vehicle = vehicle.create_vehicle(hash, coords, 0, true, false)
    entity.attach_entity_to_entity(vehicle, targetveh, 0, v3(0, 0, 0), v3(0, 0, 0), false, true, false, 0, true)
    table.insert(attached_objects, vehicle) -- Add to array for later deletion
end)
attach_veh_to_veh_feature:set_str_data(getVehicleNames(attachVehicles))

menu.add_player_feature("Break Player Ped Physics", "action", greifing, function(feat, pid)
    local playerVehicle = player.get_player_ped(pid)
            local models = {1074457665, 916292624} -- Model hashes for ped and object
        for _, model in ipairs(models) do
            streaming.request_model(model)
            while not streaming.has_model_loaded(model) do
                system.yield(0)
            end
        end

        local playerPos = player.get_player_coords(pid)
        local pedId = ped.create_ped(4, models[1], playerPos, 0, true, false)
        local obj = object.create_object(models[2], playerPos, true, false)
        entity.attach_entity_to_entity(obj, pedId, 0, v3(0, 0, 0), v3(0, 0, 0), false, true, false, 0, true)

        entity.attach_entity_to_entity(pedId, playerVehicle, 0, v3(0, 0, 0), v3(0, 0, 0), false, true, false, 0, true)
        entity.set_entity_visible(pedId, false)
        entity.set_entity_visible(obj, false)
        entity.set_entity_collision(pedId, true)
        entity.set_entity_collision(obj, true)
end)

menu.add_player_feature("Vision Spasm Glitch", "toggle", greifing, function(feat, pid)
    if feat.on then
        -- Ensure cleanup at the start of the feature activation
        spawnedObjects = deleteEntities(spawnedObjects)
        spawnedVehicles = deleteEntities(spawnedVehicles)

        local playerPed = player.get_player_ped(pid)
        local playerCoords = entity.get_entity_coords(playerPed)

        -- Example Particle Effect
        requestAndLoadPtfxAsset("scr_indep_fireworks")
        graphics.start_networked_particle_fx_non_looped_at_coord("scr_indep_firework_trail_spawn", playerCoords, v3(0, 0, 0), 1.0, true, true, true)

        -- Spawn and attach objects example
        local objectHashes = {gameplay.get_hash_key("prop_xmas_ext"), gameplay.get_hash_key("prop_food_van_01")}
        for _, hash in ipairs(objectHashes) do
            local obj = createAndAttachObject(hash, playerCoords, playerPed)
            table.insert(spawnedObjects, obj)
        end

        -- Example of spawning and scheduling deletion of vehicles
        spawnAndDeleteVehicles(0x810369E2, playerCoords, 25)
    else
        -- Cleanup immediately when toggled off, if desired
        spawnedObjects = deleteEntities(spawnedObjects)
        spawnedVehicles = deleteEntities(spawnedVehicles)
    end
    return HANDLER_CONTINUE
end)


tp_glitch = menu.add_player_feature("teleport player glitched location", "action_value_str", greifing, function(feat, pid)
    local meped = player.get_player_ped(player.player_id())
    local startcoords = player.get_player_coords(player.player_id())
    
    -- make a table of glitched locations:
    local glitched_locations = {
        { "Race Bunker", { 403.78, -961.35, -99.00 } },
        { "FIB Roof", { 135.9541, -749.8984, 258.1520 } },
        { "Police Lockup", { 459.414, -980.884, 30.690 } },
        { "Behind Bar", { 126.1211, -1278.5130, 29.2696 } },
        { "In Build", { -91.6870, 33.0948, 71.4655 } },
        { "Glasses Store", { -1244.379, -1454.591, 4.348 } },
        { "In Wall", { -254.9432, -147.3534, 42.7314 } },
        { "Casino Light", { 928.937, 41.536, 85.995 } },
        { "In House", { -1907.3500, -577.2352, 20.1223 } },
        { "Under Bridge", { 721.6599, -1000.6510, 23.5455 } }
    }
    
    local selectedOption = feat.value + 1  -- Increment by 1 due to 0-indexing
    local selectedLocation = glitched_locations[selectedOption]
    entity.set_entity_coords_no_offset(meped, v3(selectedLocation[2][1], selectedLocation[2][2], selectedLocation[2][3]))
    
    system.yield(100)
    player_tp = menu.get_feature_by_hierarchy_key('online.online_players.player_' ..pid.. '.teleport.teleport_player_to_me')
    player_tp.on = true
    -- tp_player_to_me.on = true
    
    system.yield(500)
    entity.set_entity_coords_no_offset(meped, startcoords)
end)

tp_glitch:set_str_data({
    "Race Bunker",
    "FIB Roof",
    "Police Station Lockup",
    "Behind Strip Bar",
    "Inside Building",
    "Stuck In Objects",
    "In Wall",
    "Casino Entrence",
    "In House",
    "Under A Bridge"
})

menu.add_player_feature("Kidnap Player", "toggle", greifing, function(feat, pid)
    local me = player.get_player_ped(player.player_id())
    local there_coords = player.get_player_coords(pid)
    
    streaming.request_model(gameplay.get_hash_key("Benson"))
    while not streaming.has_model_loaded(gameplay.get_hash_key("Benson")) do
        system.yield(0)
    end
    
    local veh = vehicle.create_vehicle(gameplay.get_hash_key("Benson"), player.get_player_coords(player.player_id()), 0, true, false)
    entity.set_entity_god_mode(veh, true)
    ped.set_ped_into_vehicle(me, veh, -1)

    freeze_player_ped = menu.get_feature_by_hierarchy_key('online.online_players.player_' ..pid.. '.griefing.freeze')
    freeze_player_ped:toggle()
    system.yield(400)
    freeze_player_ped:toggle(false)

    entity.set_entity_coords_no_offset(veh, v3(there_coords.x, there_coords.y + 0.5 , there_coords.z - 0.2))
    
    while feat.on do
        native.call(0x781B3D62BB013EF5, veh, true)
        system.yield(0)
    end
    
    entity.delete_entity(veh)
    streaming.set_model_as_no_longer_needed(gameplay.get_hash_key("Benson"))
end)

-- Improved version of old "force under map" feature
local force_under_map = menu.add_player_feature("Force Under Map", "value_str", greifing, function(feat, pid)
    local selectedVersion = feat.value + 1
    if feat.on then
        if selectedVersion == 1 then
            local playerPos = player.get_player_coords(pid)
            local objHash = gameplay.get_hash_key("prop_food_van_01")
            local Collison_object = object.create_object(objHash, playerPos, true, false)
            system.yield(150)
            entity.delete_entity(Collison_object)
        elseif selectedVersion == 2 then
            local depthAdjustments = {-0.11, -0.50, -0.75, -1.00} -- Depth adjustments for each object
            local objHash = gameplay.get_hash_key("prop_xmas_ext")
            local Collison_objects = {}

            for _, adjustment in ipairs(depthAdjustments) do
                local adjustedPos = player.get_player_coords(pid)
                adjustedPos.z = adjustedPos.z + adjustment
                table.insert(Collison_objects, object.create_object(objHash, adjustedPos, true, false))
            end

            system.yield(150)

            for _, obj in ipairs(Collison_objects) do
                entity.delete_entity(obj)
            end
        end
    end
    return HANDLER_CONTINUE
end)

force_under_map:set_str_data({"V1", "V2"})



fly_upwards_thread = nil

fly_up_feature = menu.add_player_feature("make player fly upwards", "toggle", greifing, function(feat, pid)
    local modelHash = gameplay.get_hash_key("vw_prop_vw_casino_podium_01a")
    streaming.request_model(modelHash)
    while not streaming.has_model_loaded(modelHash) do
        system.yield(0)
    end

    if feat.on then
        if not fly_upwards_thread then
            fly_upwards_thread = menu.create_thread(function()
                while feat.on do
                    local coords = player.get_player_coords(pid)
                    local offset = player.is_player_in_any_vehicle(pid) and -0.5 or -1
                    local obj = object.create_object(modelHash, v3(coords.x, coords.y, coords.z + offset), true, false)
                --    entity.set_entity_visible(obj, false)
                    entity.set_entity_collision(obj, true)
                    system.yield(0)
                    entity.delete_entity(obj)
                end
            end)
        end
    else
        if fly_upwards_thread then
            menu.delete_thread(fly_upwards_thread)
            fly_upwards_thread = nil
        end
    end

end)

tp_all_to_player = menu.add_player_feature("Teleport All to Player", "action_value_str", greifing, function(feat, pid)
    local all_objs = object.get_all_objects()
    local all_peds = ped.get_all_peds()
    local all_vehs = vehicle.get_all_vehicles()
    local all_pickups = object.get_all_pickups()
    local selectedOption = feat.value + 1  -- Increment by 1 due to 0-indexing

    if selectedOption == 1 then
        for _, obj in ipairs(all_objs) do
            network.request_control_of_entity(obj)
            entity.set_entity_coords_no_offset(obj, player.get_player_coords(pid))
        end
    elseif selectedOption == 2 then
        for _, ped in ipairs(all_peds) do
            network.request_control_of_entity(ped)
            entity.set_entity_coords_no_offset(ped, player.get_player_coords(pid))
        end
    elseif selectedOption == 3 then
        for _, veh in ipairs(all_vehs) do
            network.request_control_of_entity(veh)
            entity.set_entity_coords_no_offset(veh, player.get_player_coords(pid))
        end
    elseif selectedOption == 4 then
        for _, pickup in ipairs(all_pickups) do
            network.request_control_of_entity(pickup)
            entity.set_entity_coords_no_offset(pickup, player.get_player_coords(pid))
        end
    elseif selectedOption == 5 then
        for _, obj in ipairs(all_objs) do
            network.request_control_of_entity(obj)
            entity.set_entity_coords_no_offset(obj, player.get_player_coords(pid))
        end
        for _, ped in ipairs(all_peds) do
            network.request_control_of_entity(ped)
            entity.set_entity_coords_no_offset(ped, player.get_player_coords(pid))
        end
        for _, veh in ipairs(all_vehs) do
            network.request_control_of_entity(veh)
            entity.set_entity_coords_no_offset(veh, player.get_player_coords(pid))
        end
        for _, pickup in ipairs(all_pickups) do
            network.request_control_of_entity(pickup)
            entity.set_entity_coords_no_offset(pickup, player.get_player_coords(pid))
        end
    end
end)

tp_all_to_player:set_str_data({
    "Objects",
    "Peds",
    "Vehicles",
    "Pickups",
    "All"
})