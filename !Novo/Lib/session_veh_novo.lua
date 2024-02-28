
removeMissilesFeature = menu.add_feature("Remove Oppressor Missiles", "value_str", session_veh.id, function(feat)
    local missilesRemovedNotified = false

    while feat.on do
        local selectedOption = feat.value + 1

        local Missilesthread = menu.create_thread(function()
            removeMissiles(selectedOption)
        end)

        if not missilesRemovedNotified then
            local notifyMessage = "Attempting to remove Oppressor missiles for "
            if selectedOption == 1 then
                notifyMessage = notifyMessage .. "everyone."
            elseif selectedOption == 2 then
                notifyMessage = notifyMessage .. "everyone except you."
            elseif selectedOption == 3 then
                notifyMessage = notifyMessage .. "everyone except you and friends."
            elseif selectedOption == 4 then
                notifyMessage = notifyMessage .. "everyone except you and modders."
            end
            menu.notify(notifyMessage, "Notification", 5)
            missilesRemovedNotified = true
        end

        system.yield(1000) -- Yield for 1 second to prevent constant loop execution
        if menu.has_thread_finished(Missilesthread) then
            menu.delete_thread(Missilesthread)
        end
    end

    missilesRemovedNotified = false -- Reset the notification flag when the feature is turned off
    return HANDLER_POP
end)

removeMissilesFeature:set_str_data({"For Everyone", "Everyone Except Me", "Everyone Except Me and Friends", "Everyone Except Me and Modders"})


-- option to teleport their vehicle with different preset options
teleport_vehicle_ses = menu.add_feature("Teleport Session Vehicles", "action_value_str", session_veh.id, function(feat, pid)
    local selectedOption = feat.value + 1  -- Increment by 1 due to 0-indexing
    for pid = 0, 31 do -- Iterate through all possible players (0-31)
        if player.is_player_valid(pid) then
            local threadid = menu.create_thread(function()
                local playerVehicle = player.get_player_vehicle(pid)
                network.request_control_of_entity(playerVehicle)
                while not network.has_control_of_entity(playerVehicle) do
                    system.yield(25)
                end
                if playerVehicle ~= 0 then
                    local coords = player.get_player_coords(pid)

                    if selectedOption == 1 then
                        -- Teleport to player's coordinates
                        entity.set_entity_coords_no_offset(playerVehicle, coords)

                    elseif selectedOption == 2 then
                        -- Teleport super high
                        entity.set_entity_coords_no_offset(playerVehicle, v3(coords.x, coords.y, 10000))

                    elseif selectedOption == 3 then
                        -- Teleport under the map
                        entity.set_entity_coords_no_offset(playerVehicle, v3(-460, -260, -58))

                    end
                end
            end)
            if menu.has_thread_finished(threadid) then
                menu.delete_thread(threadid)
            end
        end
    end
end)
teleport_vehicle_ses:set_str_data({"To My Coords", "Super High", "Under the Map"})


set_vehicle_option_ses = menu.add_feature("Set Session Vehicles", "action_value_str", session_veh_trolls.id, function(feat, pid)
    local selectedOption = feat.value + 1  -- Increment by 1 due to 0-indexing
    for pid = 0, 31 do -- Iterate through all possible players (0-31)
        if player.is_player_valid(pid) then
            local threadid = menu.create_thread(function()
                local playerVehicle = player.get_player_vehicle(pid)
                network.request_control_of_entity(playerVehicle)
                while not network.has_control_of_entity(playerVehicle) do
                    system.yield(25)
                end
                if playerVehicle ~= 0 then
                    if selectedOption == 1 then
                        vehicle.set_vehicle_fixed(playerVehicle)  -- Repair the vehicle
                        vehicle.set_vehicle_deformation_fixed(playerVehicle)
                    elseif selectedOption == 2 then
                        -- Max out the vehicle's stats
                        vehicle.set_vehicle_mod_kit_type(playerVehicle, 0)  -- Set mod kit before modifying
                        vehicle.set_vehicle_mod(playerVehicle, 11, vehicle.get_num_vehicle_mods(playerVehicle, 11) - 1, false) -- Engine
                        vehicle.set_vehicle_mod(playerVehicle, 12, vehicle.get_num_vehicle_mods(playerVehicle, 12) - 1, false) -- Brakes
                        vehicle.set_vehicle_mod(playerVehicle, 13, vehicle.get_num_vehicle_mods(playerVehicle, 13) - 1, false) -- Transmission
                        vehicle.set_vehicle_mod(playerVehicle, 16, vehicle.get_num_vehicle_mods(playerVehicle, 16) - 1, false) -- Armor
                        vehicle.set_vehicle_mod(playerVehicle, 18, vehicle.get_num_vehicle_mods(playerVehicle, 18) - 1, false) -- Turbo
                        vehicle.set_vehicle_tire_smoke_color(playerVehicle, 255, 255, 255) -- Tyre Smoke Color
                        vehicle.set_vehicle_wheel_type(playerVehicle, 7) -- High End Wheels
                        vehicle.set_vehicle_mod(playerVehicle, 23, vehicle.get_num_vehicle_mods(playerVehicle, 23) - 1, false) -- Front Wheels
                        vehicle.set_vehicle_mod(playerVehicle, 24, vehicle.get_num_vehicle_mods(playerVehicle, 24) - 1, true) -- Back Wheels (for bikes)
                    elseif selectedOption == 3 then
                        native.call(0xA1DD317EA8FD4F29, playerVehicle, 0.0, 0.0, 0.0, 1000.0, 1000.0, true)  -- Damage the vehicle
                        vehicle.set_vehicle_tires_can_burst(playerVehicle, true)
                        for index = 0, 5 do
                            native.call(0xEC6A202EE4960385, playerVehicle, index, false, 0.0)
                            vehicle.set_vehicle_tire_burst(playerVehicle, index, false, 1000.0)
                        end
                    elseif selectedOption == 4 then
                        network.request_control_of_entity(playerVehicle)
                        entity.delete_entity(playerVehicle)  -- Delete the vehicle
                    elseif selectedOption == 5 then
                        vehicle.set_vehicle_undriveable(playerVehicle, true)  -- Make the vehicle undriveable
                    elseif selectedOption == 6 then
                        vehicle.set_vehicle_gravity_amount(playerVehicle, 0)
                    end
                end
            end)
            if menu.has_thread_finished(threadid) then
                menu.delete_thread(threadid)
            end
        end
    end
end)
set_vehicle_option_ses:set_str_data({"Repaired", "Maxed Out", "Damaged", "Delete", "Undriveable", "No Gravity"})


set_engine_option_ses = menu.add_feature("Set Session Vehicles Engine", "action_value_str", session_veh_trolls.id, function(feat, pid)
    local selectedOption = feat.value + 1  -- Increment by 1 due to 0-indexing
    for pid = 0, 31 do -- Iterate through all possible players (0-31)
        if player.is_player_valid(pid) then
            local threadid = menu.create_thread(function()
                local playerVehicle = player.get_player_vehicle(pid)
                network.request_control_of_entity(playerVehicle)
                while not network.has_control_of_entity(playerVehicle) do
                    system.yield(25)
                end
                if playerVehicle ~= 0 then
                    if selectedOption == 1 then
                        -- Turn on the engine
                        vehicle.set_vehicle_engine_on(playerVehicle, true, false, false)
                    
                    elseif selectedOption == 2 then
                        -- Turn off the engine
                        vehicle.set_vehicle_engine_on(playerVehicle, false, false, false)
                    
                    elseif selectedOption == 3 then
                        -- Turn on slow engine
                        vehicle.set_vehicle_engine_on(playerVehicle, true, false, true)
                    
                    elseif selectedOption == 4 then
                        -- Turn off slow engine
                        vehicle.set_vehicle_engine_on(playerVehicle, false, false, true)
                    
                    end
                end
            end)
            if menu.has_thread_finished(threadid) then
                menu.delete_thread(threadid)
            end
        end 
    end
end)
set_engine_option_ses:set_str_data({"Engine On", "Engine Off", "Engine On Slowly", "Engine Off Slowly"})

-- option to 'shoot' their vehicle with different preset options including up, down, left, right, random using entity.apply_force_to_entity(Ped ped, int forceType, float x, float y, float z, float rx, float ry, float rz, bool isRel, bool highForce)
shoot_vehicle_ses = menu.add_feature("Shoot Session Vehicles", "action_value_str",session_veh_trolls.id, function(feat, pid)
    local selectedOption = feat.value + 1  -- Increment by 1 due to 0-indexing
    for pid = 0, 31 do -- Iterate through all possible players (0-31)
        if player.is_player_valid(pid) then
            local threadid = menu.create_thread(function()
                local playerVehicle = player.get_player_vehicle(pid)
                network.request_control_of_entity(playerVehicle)
                while not network.has_control_of_entity(playerVehicle) do
                    system.yield(25)
                end
                    if selectedOption == 1 then
                        -- Shoot vehicle up
                        y = 100
                        entity.apply_force_to_entity(playerVehicle, 1, 0, y, 0, 0, 0, 0, true, true)
                    elseif selectedOption == 2 then
                        -- Shoot vehicle down
                        y = -100
                        entity.apply_force_to_entity(playerVehicle, 1, 0, y, 0, 0, 0, 0, true, true)
                    elseif selectedOption == 3 then
                        -- Shoot vehicle left
                        x = -100
                        entity.apply_force_to_entity(playerVehicle, 1, x, 0, 0, 0, 0, 0, true, true)
                    elseif selectedOption == 4 then
                        -- Shoot vehicle right
                        x = 100
                        entity.apply_force_to_entity(playerVehicle, 1, x, 0, 0, 0, 0, 0, true, true)
                    elseif selectedOption == 5 then
                        -- Shoot vehicle right
                        z = 100
                        entity.apply_force_to_entity(playerVehicle, 1, 0, 0, z, 0, 0, 0, true, true)
                    elseif selectedOption == 6 then
                        -- Shoot vehicle right
                        z = -100
                        entity.apply_force_to_entity(playerVehicle, 1, 0, 0, z, 0, 0, 0, true, true)
                    elseif selectedOption == 7 then
                        -- Shoot vehicle randomly
                        x = math.random(-100, 100)
                        y = math.random(-100, 100)
                        z = math.random(-100, 100)
                        entity.apply_force_to_entity(playerVehicle, 1, x, y, 0, 0, 0, 0, true, true)
                    end
            end)
            if menu.has_thread_finished(threadid) then
                menu.delete_thread(threadid)
            end
        end
    end
end)
shoot_vehicle_ses:set_str_data({"Foward", "Backawrds", "Left", "Right", "up", "down", "Random"})

god_mode_option_ses = menu.add_feature("Session Vehicles God Mode", "action_value_str", session_veh.id, function(feat, pid)
    local selectedOption = feat.value + 1  -- Increment by 1 due to 0-indexing
    for pid = 0, 31 do -- Iterate through all possible players (0-31)
        if player.is_player_valid(pid) then
            local threadid = menu.create_thread(function()
                local playerVehicle = player.get_player_vehicle(pid)
                network.request_control_of_entity(playerVehicle)
                while not network.has_control_of_entity(playerVehicle) do
                    system.yield(25)
                end
            
                    if selectedOption == 1 then
                        -- Enable god mode
                        entity.set_entity_god_mode(playerVehicle, true)
                    elseif selectedOption == 2 then
                        -- Disable god mode
                        entity.set_entity_god_mode(playerVehicle, false)
                    end
            end)
            if menu.has_thread_finished(threadid) then
                menu.delete_thread(threadid)
            end
        end
    end
end)
god_mode_option_ses:set_str_data({"Enable", "Disable"})

menu.add_feature("Peds steals their vehicles", "action", session_veh.id, function(feat, pid)
    for pid = 0, 31 do -- Iterate through all possible players (0-31)
        if player.is_player_valid(pid) then
            local threadid = menu.create_thread(function()
                local targetVehicle = player.get_player_vehicle(pid)

                if not entity.is_entity_dead(targetVehicle) then
                    local existingDriver = vehicle.get_ped_in_vehicle_seat(targetVehicle, -1) or 0
                
                    if ped.is_ped_a_player(existingDriver) then
                        local empty = {}
                        script.trigger_script_event(0xE1FFDAF2, pid, empty)
                        ped.clear_ped_tasks_immediately(existingDriver)
                    end
                
                    local pedHash = gameplay.get_hash_key("A_F_Y_Hipster_02")
                --    local spawnCoords = player.get_player_coords(pid)
                    local spawnCoords = entity.get_entity_coords(targetVehicle)
                
                    streaming.request_model(pedHash)
                    while not streaming.has_model_loaded(pedHash) do
                        system.wait(25)
                    end
                    local newPed = ped.create_ped(1, pedHash, spawnCoords, 0, true, true)
                    entity.set_entity_god_mode(newPed, true)
                
                    if newPed then
                        ped.set_ped_into_vehicle(newPed, targetVehicle, -1)
                        native.call(0xC20E50AA46D09CA8, newPed, targetVehicle, 1, 1, 16, 0, "", 0)
                        system.yield(100)
                        while ped.is_ped_in_vehicle(newPed, targetVehicle) == flase do
                            native.call(0xC20E50AA46D09CA8, newPed, targetVehicle, 1, 1, 16, 0, "", 0)
                            ped.set_ped_into_vehicle(newPed, targetVehicle, -1)
                            system.yield(100)
                        end
                        ped.set_ped_combat_attributes(newPed, 3, false)
                    
                        local targetCoords = v3(math.random(-7000, 7000), math.random(-7000, 7000), 50)
                        ai.task_vehicle_drive_to_coord_longrange(newPed, targetVehicle, targetCoords, 150, 0, 100)
                    
                    end
                streaming.set_model_as_no_longer_needed(pedHash)
                end
            end)
            if menu.has_thread_finished(threadid) then
                menu.delete_thread(threadid)
            end
        end
    end
end)

-- Adding the 'pop_tires' feature to the menu
local pop_tires_ses = menu.add_feature("Pop Session vehicles Tires", "action_value_str", session_veh_trolls.id, function(feat, pid)
    local selectedOption = feat.value + 1  -- Increment due to 0-indexing
    for pid = 0, 31 do -- Iterate through all possible players (0-31)
        if player.is_player_valid(pid) then
           local threadid = menu.create_thread(function()
                local playerVehicle = player.get_player_vehicle(pid)
                network.request_control_of_entity(playerVehicle)

                local controlAttempts = 0
                while not network.has_control_of_entity(playerVehicle) do
                    system.yield(25)  -- Wait until control is gained
                    controlAttempts = controlAttempts + 1
                    if controlAttempts >= 10 then
                        break
                    end
                end
            
                native.call(0x890E2C5ABED7236D, playerVehicle, true)  -- NETWORK::NETWORK_TRIGGER_DAMAGE_EVENT_FOR_ZERO_DAMAGE Allows vehicle wheels to be destructible even when the vehicle entity is invincible.

                vehicle.set_vehicle_tires_can_burst(playerVehicle, true)
            
                -- Handling different options
                if selectedOption == 1 then
                    burstTire(playerVehicle, 0)  -- Front Left
                elseif selectedOption == 2 then
                    burstTire(playerVehicle, 1)  -- Front Right
                elseif selectedOption == 3 then
                    burstTire(playerVehicle, 4)  -- Back Left
                elseif selectedOption == 4 then
                    burstTire(playerVehicle, 5)  -- Back Right
                elseif selectedOption == 5 then
                    burstTire(playerVehicle, 0)  -- Both Left Side
                    burstTire(playerVehicle, 4)
                elseif selectedOption == 6 then
                    burstTire(playerVehicle, 1)  -- Both Right Side
                    burstTire(playerVehicle, 5)
                elseif selectedOption == 7 then
                    for i = 0, 7 do  -- All tires
                        burstTire(playerVehicle, i)
                    end
                end
            end)
            if menu.has_thread_finished(threadid) then
                menu.delete_thread(threadid)
            end
        end
    end
end)
pop_tires_ses:set_str_data({"Front Left", "Front Right", "Back Left", "Back Right", "Both Left Side", "Both Right Side", "All"})

local flip_car_ses = menu.add_feature("Flip Session Vehicles", "action_value_str", session_veh_trolls.id, function(feat, pid)
    local selectedOption = feat.value + 1
    for pid = 0, 31 do -- Iterate through all possible players (0-31)
        if player.is_player_valid(pid) then
            local threadid = menu.create_thread(function()
                local playerVehicle = player.get_player_vehicle(pid)
                network.request_control_of_entity(playerVehicle)

                while not network.has_control_of_entity(playerVehicle) do
                    system.yield(25)
                end
            
                local rot = entity.get_entity_rotation(playerVehicle)
            
                if selectedOption == 1 then
                    rot.y = -90  -- Flip on right side
                elseif selectedOption == 2 then
                    rot.y = 90   -- Flip on left side
                elseif selectedOption == 3 then
                    rot.x = 180  -- Upside down
                elseif selectedOption == 4 then
                    rot.x = 0    -- Right side up
                elseif selectedOption == 5 then
                    -- Random rotation
                    rot.x = math.random(-180, 180)
                    rot.y = math.random(-180, 180)
                    rot.z = math.random(-180, 180)
                end
            
                entity.set_entity_rotation(playerVehicle, rot)
            end)
            if menu.has_thread_finished(threadid) then
                menu.delete_thread(threadid)
            end
        end
    end
end)

flip_car_ses:set_str_data({"Right Side", "Left Side", "Upside Down", "Right Side Up", "Random"})

local threadIDs = {}

menu.add_feature("Rainbow Player Vehicles", "toggle", session_veh.id, function(feat)
    while feat.on do
        for pid = 0, 31 do
            if player.is_player_valid(pid) then
                local threadID = menu.create_thread(function()

                    local playerVehicle = player.get_player_vehicle(pid)
                    if playerVehicle ~= 0 then
                        network.request_control_of_entity(playerVehicle)
                        while not network.has_control_of_entity(playerVehicle) do
                            system.yield(25)
                        end
                        local colorPrimary = math.random(0, 159)
                        local colorSecondary = math.random(0, 159)
                        local colorThird = math.random(0, 159)
                        vehicle.set_vehicle_color(playerVehicle, colorPrimary, colorSecondary, colorThird, 0)
                        system.yield(1000)
                    end
                end, nil)

                table.insert(threadIDs, threadID)
            end
        end

        -- Check and delete finished threads
        for i = #threadIDs, 1, -1 do
            if menu.has_thread_finished(threadIDs[i]) then
                menu.delete_thread(threadIDs[i])
                table.remove(threadIDs, i)
            end
        end

        system.yield(0)
    end

    -- Cleanup: Delete any remaining threads when feature is turned off
    for _, threadID in ipairs(threadIDs) do
        if not menu.has_thread_finished(threadID) then
            menu.delete_thread(threadID)
        end
    end
    threadIDs = {} -- Reset the thread list
end)

menu.add_feature("Set all license plates", "action", session_veh.id, function(feat, pid)
    local threadIDs_plates = {}

    for pid = 0, 31 do
        if player.is_player_valid(pid) then
            local threadID = menu.create_thread(function()
                local playerVehicle = player.get_player_vehicle(pid)
                local responseCode, licensePlateInput = -1, ""

                while responseCode ~= eInputResponse.IR_SUCCESS and responseCode ~= eInputResponse.IR_FAILED do
                    responseCode, licensePlateInput = input.get("Enter license plate value", "", 8, eInputType.IT_ASCII)
                    system.yield(0) -- Adjust yield time as needed to prevent blocking
                end

                if responseCode == eInputResponse.IR_SUCCESS then
                --    menu.notify("License plate set to: " .. licensePlateInput, "Novo Script", 140)
                    vehicle.set_vehicle_number_plate_text(playerVehicle, licensePlateInput)
                end
            end, nil)

            table.insert(threadIDs_plates, threadID)
        end
    end

    -- Check and delete finished threads
    for i = #threadIDs_plates, 1, -1 do
        if menu.has_thread_finished(threadIDs_plates[i]) then
            menu.delete_thread(threadIDs_plates[i])
            table.remove(threadIDs_plates, i)
        end
    end
end)

-- add traffic monkey feature (make it a toggle so it updates when new traffic spawns, and keep what was changed into a table so we don't do the same things again and use memory for no reason)
-- get all peds
-- get all vehs
-- check if ped is in veh
-- make sure ped is not player
-- get control of ped
-- delete ped
-- spawn moneky ped
-- pedmonkey ped in car
-- task monkey ped drive like normal ped
 
-- add rainbow traffic feature (make it a toggle so it updates when new traffic spawns, and keep what was changed into a table so we don't do the same things again and use memory for no reason)
-- get all veh
-- make sure veh is not player veh
-- get control of all veh
-- set color to random

-- add super car traffic feature (make it a toggle so it updates when new traffic spawns, and keep what was changed into a table so we don't do the same things again and use memory for no reason)
-- get all veh
-- get all ped
-- make sure veh is not player veh
-- get control of all veh
-- delete veh
-- spawn random super car
-- put ped into super car
-- task ped to drive like normal ped

-- feature to have super speed traffic (make it a toggle so it updates when new traffic spawns, and keep what was changed into a table so we don't do the same things again and use memory for no reason)
-- get all veh
-- make sure veh is not player veh
-- get control of all veh
-- remove max speed limit
-- set high acceleration
-- set max performance upgrades
-- check for other functions to add
 
-- feature to freeze traffic (toggle) (make it a toggle so it updates when new traffic spawns, and keep what was changed into a table so we don't do the same things again and use memory for no reason)
-- get all veh
-- make sure veh is not player veh
-- get control of all veh
-- freeze all veh entites
-- unfreeze if toggled off

-- feature for big traffic (make it a toggle so it updates when new traffic spawns, and keep what was changed into a table so we don't do the same things again and use memory for no reason)
-- make a txt with all veh names that are large like tractors and stuff
-- get all veh
-- get all ped
-- make sure veh is not player veh
-- get control of all veh
-- delete veh
-- spawn random large veh
-- put ped into large veh
-- task ped to drive like normal ped

-- feature for all bike traffic (make it a toggle so it updates when new traffic spawns, and keep what was changed into a table so we don't do the same things again and use memory for no reason)
-- make a txt with all veh names that are bikes
-- get all veh
-- get all ped
-- make sure veh is not player veh
-- get control of all veh
-- delete veh
-- spawn random bike
-- put ped into bike
-- task ped to drive like normal ped

