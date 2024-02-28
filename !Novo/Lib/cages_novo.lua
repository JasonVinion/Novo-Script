cage_vehkick_toggle = menu.add_player_feature("Kick from vehicle before caging", "toggle", cages, function(feat)
end)

-- Menu feature to cage player
cage_player = menu.add_player_feature("Cage player", "action_value_str", cages, function(feat, pid)
    local selectedOption = feat.value + 1  -- Increment by 1 due to 0-indexing
    local coords = player.get_player_coords(pid)

    if cage_vehkick_toggle.on then
        local empty = {}
        script.trigger_script_event(0xE1FFDAF2, pid, empty)  -- Kick player from vehicle
        ped.clear_ped_tasks_immediately(player.get_player_ped(pid)) -- untested
        system.yield(2700)
    end

    if selectedOption == 1 then
        streaming.request_model(gameplay.get_hash_key("prop_partsbox_01"))
        while not streaming.has_model_loaded(gameplay.get_hash_key("prop_partsbox_01")) do
            system.yield(25)
        end

        local heading = player.get_player_heading(pid)
        local cageObject = object.create_world_object(gameplay.get_hash_key("prop_partsbox_01"), v3(0,0,0), true, false)
        entity.set_entity_rotation(cageObject, v3(180, 0, 0))
        entity.set_entity_coords_no_offset(cageObject, v3(coords.x, coords.y, coords.z + 1))
        configure_cage_entity(cageObject)

    elseif selectedOption == 2 then
        streaming.request_model(gameplay.get_hash_key("prop_feeder1_cr"))
        while not streaming.has_model_loaded(gameplay.get_hash_key("prop_feeder1_cr")) do
            system.yield(25)
        end
        local cageObject = object.create_world_object(gameplay.get_hash_key("prop_feeder1_cr"), coords, true, false)
        configure_cage_entity(cageObject)

    elseif selectedOption == 3 then
        streaming.request_model(gameplay.get_hash_key("metrotrain"))
        streaming.request_model(0xc6c3242d)
        while not streaming.has_model_loaded(0xc6c3242d) do
            system.yield(25)
        end
        --local cageObject = native.call(0x63C6CCA8E68AE8C8, 0xc6c3242d, coords.x, coords.y, coords.z, true, 0, 0)
        local cageCoords = v3(coords.x, coords.y, coords.z - 1.25)
        local cageObject = vehicle.create_vehicle(gameplay.get_hash_key("metrotrain"), cageCoords, 0, true, false)
        local cageObject2 = vehicle.create_vehicle(gameplay.get_hash_key("metrotrain"), cageCoords, 90, true, false)
        configure_cage_entity(cageObject)
    elseif selectedOption == 4 then
        streaming.request_model(gameplay.get_hash_key("prop_towercrane_02e"))
        while not streaming.has_model_loaded(gameplay.get_hash_key("prop_towercrane_02e")) do
            system.yield(25)
        end
        local cageObject = object.create_object(gameplay.get_hash_key("prop_tollbooth_1"), coords, true, false)
        local cageObject2 = object.create_object(gameplay.get_hash_key("prop_tollbooth_1"), coords, true, false)
        entity.set_entity_rotation(cageObject, v3(270, 270, 0))
        configure_cage_entity(cageObject)
        configure_cage_entity(cageObject2)
    elseif selectedOption == 5 then
        streaming.request_model(gameplay.get_hash_key("prop_skip_05b"))
        while not streaming.has_model_loaded(gameplay.get_hash_key("prop_skip_05b")) do
            system.yield(25)
        end
    --    local cageObject = object.create_object(gameplay.get_hash_key("prop_skip_05b"), coords, true, false)
    local cageObject = object.create_object(gameplay.get_hash_key("prop_skip_05b"), v3(0,0,0), true, false)
    entity.set_entity_rotation(cageObject, v3(0, -180, -180))
    entity.set_entity_coords_no_offset(cageObject, v3(coords.x, coords.y, coords.z + 0.50))
        configure_cage_entity(cageObject)
    elseif selectedOption == 6 then
        streaming.request_model(gameplay.get_hash_key("prop_1st_hostage_scene"))
        while not streaming.has_model_loaded(gameplay.get_hash_key("prop_1st_hostage_scene")) do
            system.yield(25)
        end
        local cageObject = object.create_object(gameplay.get_hash_key("p_ld_coffee_vend_s"), coords, true, false)
        configure_cage_entity(cageObject)  
    end

end)
cage_player:set_str_data({"V1", "V2", "V3", "V4", "V5", "V6"})

local cage_player = menu.add_player_feature("force ladder climb", "toggle", cages, function(feat, pid)
while feat.on do
        local coords = player.get_player_coords(pid)
        local cageCoords = v3(coords.x, coords.y, coords.z - 0.5)
        streaming.request_model(gameplay.get_hash_key("prop_towercrane_02e"))
        while not streaming.has_model_loaded(gameplay.get_hash_key("prop_towercrane_02e")) do
            system.yield(25)
        end
        -- Then, in your main code where you want to spawn the object:
        local player_heading = entity.get_entity_heading(player.get_player_ped(pid)) -- Get the player's current heading
        local offset_forward = 0 -- How far in front of the player to spawn the object
        local offset_right = 0.0 -- How far to the right of the player to spawn the object (use negative for left)
        local offset_up = -0.5 -- How far above (or below) the player's feet to spawn the object

        local forward_x, forward_y = get_forward_vector_from_heading(player_heading)
        local right_x, right_y = forward_y, -forward_x -- Right vector is perpendicular to the forward vector

        -- Calculate the new position for the object
        local new_x = cageCoords.x + forward_x * offset_forward + right_x * offset_right
        local new_y = cageCoords.y + forward_y * offset_forward + right_y * offset_right
        local new_z = cageCoords.z + offset_up

        local cageobjecttest = object.create_world_object(gameplay.get_hash_key("prop_towercrane_02e"), v3(new_x, new_y, new_z), true, false)
       -- system.yield(25)
        entity.set_entity_heading(cageobjecttest, player_heading)
        entity.set_entity_collision(cageobjecttest, true)
       -- configure_cage_entity(cageobjecttest)
       entity.set_entity_visible(cageobjecttest, false)
        system.yield(1500)
        entity.delete_entity(cageobjecttest)

    end
    return HANDLER_POP
end)
