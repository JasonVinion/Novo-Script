-- option to teleport their vehicle with different preset options
local teleport_vehicle = menu.add_player_feature("Teleport Vehicle", "action_value_str", veh_troll, function(feat, pid)
    local selectedOption = feat.value + 1  -- Increment by 1 due to 0-indexing
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
teleport_vehicle:set_str_data({"To My Coords", "Super High", "Under the Map"})


local set_vehicle_option = menu.add_player_feature("Set Vehicle", "action_value_str", veh_troll, function(feat, pid)
    local selectedOption = feat.value + 1  -- Increment by 1 due to 0-indexing
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
            -- Clone the vehicle
            local targetVehicleentity = player.get_player_vehicle(pid)
            local targetVehicle = entity.get_entity_model_hash(targetVehicleentity) 
            menu.notify("Target vehicle: " .. tostring(targetVehicle), "Notification", 5)
            if targetVehicle ~= 0 then
                local myCoords = player.get_player_coords(player.player_id())
                streaming.request_model(targetVehicle)
                while not streaming.has_model_loaded(targetVehicle) do
                    system.yield(25)
                end
                local clone = vehicle.create_vehicle(targetVehicle, myCoords, 0, true, false)
                -- Apply modifications and colors
                system.yield(25)
                vehicle.set_vehicle_mod_kit_type(clone, 0)  -- Set mod kit before modifying
                for modType = 0, 48 do  -- Iterate through all mod types
                    local modIndex = vehicle.get_vehicle_mod(targetVehicle, modType)
                    vehicle.set_vehicle_mod(clone, modType, modIndex, false)
                end
                -- Copy color and other attributes
                local colorPrimary = 0
                local colorSecondary = 0
                native.call(0xA19435F193E081AC, targetVehicle, colorPrimary, colorSecondary)
                native.call(0x4F1D4BE3A7F24601, clone, colorPrimary, colorSecondary)
                local pearlescentColor = 0
                local wheelColor = 0
                native.call(0x3BC4245933A166F7, targetVehicle, pearlescentColor, wheelColor)
                native.call(0x2036F561ADD12E33, clone, pearlescentColor, wheelColor)
            end
        elseif selectedOption == 5 then
            network.request_control_of_entity(playerVehicle)
            entity.delete_entity(playerVehicle)  -- Delete the vehicle
        elseif selectedOption == 6 then
            vehicle.set_vehicle_undriveable(playerVehicle, true)  -- Make the vehicle undriveable
        elseif selectedOption == 7 then
            vehicle.set_vehicle_gravity_amount(playerVehicle, 0)
        end
    end
end)
set_vehicle_option:set_str_data({"Repaired", "Maxed Out", "Damaged", "Clone", "Delete", "Undriveable", "No Gravity"})


local set_engine_option = menu.add_player_feature("Set Engine", "action_value_str", veh_troll, function(feat, pid)
    local selectedOption = feat.value + 1  -- Increment by 1 due to 0-indexing
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
set_engine_option:set_str_data({"Engine On", "Engine Off", "Engine On Slowly", "Engine Off Slowly"})

local shoot_vehicle = menu.add_player_feature("Shoot Vehicle", "action_value_str",veh_troll, function(feat, pid)
    local selectedOption = feat.value + 1  -- Increment by 1 due to 0-indexing
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
shoot_vehicle:set_str_data({"Foward", "Backawrds", "Left", "Right", "up", "down", "Random"})

local god_mode_option = menu.add_player_feature("Vehicle God Mode", "action_value_str", veh_troll, function(feat, pid)
    local selectedOption = feat.value + 1  -- Increment by 1 due to 0-indexing
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
god_mode_option:set_str_data({"Enable", "Disable"})

local steal_with_heli = menu.add_player_feature("Steal Vehicle with Heli", "action", veh_greif, function(feat, pid)
    -- Step 1: Spawn a Cargobob
    local cargobob_model = gameplay.get_hash_key("cargobob")
    streaming.request_model(cargobob_model)
    while not streaming.has_model_loaded(cargobob_model) do
        system.yield(25)
    end
    local player_coords = player.get_player_coords(pid)
    local cargobob = vehicle.create_vehicle(cargobob_model, v3(0,0, 250), player.get_player_heading(pid), true, false)
    streaming.set_model_as_no_longer_needed(cargobob_model)

    -- Step 2: Set Heli speed
    native.call(0xFD280B4D7F3ABC4D, cargobob, 100)
    native.call(0xA178472EBB8AE60D, cargobob)

    -- Step 3: Enable rope and magnet
    native.call(0x7BEB0C7A235F6F3B, cargobob, 1)
    native.call(0x9A665550F8DA349B, cargobob, true)
    native.call(0x685D5561680D088B, cargobob, 10.0)

    -- Step 4: Teleport above the target player
    entity.set_entity_coords_no_offset(cargobob, v3(player_coords.x, player_coords.y, player_coords.z + 250))

    -- Step 5: Place yourself in the driver's seat
    ped.set_ped_into_vehicle(player.get_player_ped(player.player_id()), cargobob, -1)

    -- Step 6: Gain control of target player's vehicle
    local target_vehicle = player.get_player_vehicle(pid)
    network.request_control_of_entity(target_vehicle)
    while not network.has_control_of_entity(target_vehicle) do
        system.yield(25)
    end

    -- Step 7: Attach target vehicle to Cargobob
    native.call(0x4127F1D84E347769, cargobob, target_vehicle, 0, 0, 0, 0)

end)

local steal_with_tow = menu.add_player_feature("Steal Vehicle with TowTruck", "action", veh_greif, function(feat, pid)
    -- Step 1: Spawn a TowTruck
    local towtruck_model = gameplay.get_hash_key("towtruck")
    streaming.request_model(towtruck_model)
    while not streaming.has_model_loaded(towtruck_model) do
        system.yield(25)
    end
    local my_ped = player.get_player_ped(player.player_id())
    local my_coords = entity.get_entity_coords(my_ped)
    local towtruck = vehicle.create_vehicle(towtruck_model, my_coords, player.get_player_heading(player.player_id()), true, false)
    streaming.set_model_as_no_longer_needed(towtruck_model)

    -- Step 2: Set you as the driver
    ped.set_ped_into_vehicle(my_ped, towtruck, -1)

    -- Step 3: Teleport to the target player
    local target_coords = player.get_player_coords(pid)
 --   local distance_in_front = -6  -- distance to teleport in front of the player
 --   local radians = math.rad(player.get_player_heading(pid))  -- convert heading to radians for trigonometry

    -- Calculate the offset
 --   local offsetX = math.sin(radians) * distance_in_front
 --   local offsetY = math.cos(radians) * distance_in_front

    -- Apply offset to the current coordinates
--    local new_x = target_coords.x + offsetX
--    local new_y = target_coords.y + offsetY

-- Teleport the tow truck
entity.set_entity_coords_no_offset(towtruck, target_coords)


    -- Step 4: Get control of target player's vehicle
    local target_vehicle = player.get_player_vehicle(pid)
    network.request_control_of_entity(target_vehicle)
    while not network.has_control_of_entity(target_vehicle) do
        system.yield(25)
    end

    -- Step 5: Set your vehicle to be on the ground properly
    entity.set_entity_velocity(towtruck, v3(0.0, 0.0, 0.0))

    -- Step 6: Set the speed of the target vehicle to 0
    entity.set_entity_velocity(target_vehicle, v3(0.0, 0.0, 0.0))

    -- Step 7: Attach the target vehicle to the TowTruck
    native.call(0xFE54B92A344583CA, towtruck, 0.5)
    native.call(0x48BD57D0DD17786A, towtruck, target_vehicle)
    native.call(0x29A16F8D621C4508, towtruck, target_vehicle, true, 0, 0, 0)
end)

menu.add_player_feature("Ped steals their vehicle", "action", veh_greif, function(feat, pid)
    local targetVehicle = player.get_player_vehicle(pid)

    if not entity.is_entity_dead(targetVehicle) then
        local existingDriver = vehicle.get_ped_in_vehicle_seat(targetVehicle, -1) or 0

        if ped.is_ped_a_player(existingDriver) then
            local empty = {}
            script.trigger_script_event(0xE1FFDAF2, pid, empty)  -- Kick player from vehicle
            ped.clear_ped_tasks_immediately(existingDriver)
        end

        local pedHash = gameplay.get_hash_key("A_F_Y_Hipster_02")
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

local pop_tires = menu.add_player_feature("Pop Their Tires", "action_value_str", veh_troll, function(feat, pid)
    local selectedOption = feat.value + 1  -- Increment due to 0-indexing
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
pop_tires:set_str_data({"Front Left", "Front Right", "Back Left", "Back Right", "Both Left Side", "Both Right Side", "All"})

local flip_car = menu.add_player_feature("Flip Car", "action_value_str", veh_troll, function(feat, pid)
    local selectedOption = feat.value + 1
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

flip_car:set_str_data({"Left Side", "Right Side", "Upside Down", "Right Side Up", "Random"})

local speed = nil

local testfeature = menu.add_player_feature("Rainbow car", "toggle", veh_misc, function(feat, pid)
    while feat.on do
        if speed == nil then
            local responseCode, inputSpeed = input.get("Enter color change speed (in ms)", "", 10, eInputType.IT_NUM)
            ::continue::
            if input.is_open() then
                system.wait(100)
                goto continue
            end
                speed = tonumber(inputSpeed)
        end

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
            system.yield(speed)
        end
        system.yield(0) -- Yield at the end of the loop
    end
    -- Reset speed when feature is turned off
    if not feat.on then
        speed = nil
    end
end)

break_veh_phy = menu.add_player_feature("Break Vehicle Physics", "action_value_str", veh_greif, function(feat, pid)
    network.request_control_of_entity(player.get_player_vehicle(pid))
    local playerVehicle = player.get_player_vehicle(pid)
    local playerped = player.get_player_ped(pid)
    local selectedOption = feat.value + 1  -- Increment by 1 due to 0-indexing

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

        if selectedOption == 1 then
            local seatFound = false
            for seatNum = -1, 7 do -- Adjust seatNum start to -1 for the driver's seat
                -- Attempt to seat the ped
                ped.set_ped_into_vehicle(pedId, playerVehicle, seatNum) -- Seat the ped if the seat is free
                    if ped.is_ped_in_vehicle(pedId, playerVehicle) then -- Check if the ped is now in the vehicle
                        seatFound = true
                        break -- Break from the loop if the ped was successfully placed
                    end
            end

            if not seatFound then
                -- Notify the user only if no empty seat was found after checking all seats
                menu.notify("Vehicle must have an empty seat.", "Error", 5, 50)
                entity.delete_entity(obj)
                entity.delete_entity(pedId)
            end
        elseif selectedOption == 2 then
            entity.attach_entity_to_entity(pedId, playerped, 0, v3(0, 0, 0), v3(0, 0, 0), false, true, false, 0, true)
            entity.set_entity_visible(pedId, false)
            entity.set_entity_visible(obj, false)
            entity.set_entity_collision(pedId, true)
            entity.set_entity_collision(obj, true)
        elseif selectedOption == 3 then
            local counter = 0

            while counter < 100 do
                local playerVehicle = player.get_player_vehicle(pid)
                if playerVehicle ~= 0 then
                    -- Check if the player is in the vehicle
                    if ped.is_ped_in_vehicle(player.get_player_ped(pid), playerVehicle) then
                        unrenderveh(playerVehicle)
                        messwithveh(playerVehicle)
                        counter = counter + 1
                    else
                        break -- Stop the loop if the player is not in the vehicle
                    end
                else
                    break -- Stop the loop if there is no player vehicle
                end
                system.wait(1000) -- Wait for 1 second before the next run
            end
        end
end)

break_veh_phy:set_str_data({"V1", "V2", "V3"})

set_veh_speed = menu.add_player_feature("Set Vehicle Speed", "action_value_str", veh_troll, function(feat, pid)
    local responseCode, speedInput = -1, ""
    while responseCode ~= eInputResponse.IR_SUCCESS and responseCode ~= eInputResponse.IR_FAILED do
        responseCode, speedInput = input.get("Enter vehicle speed", "", 10, eInputType.IT_NUM)
        system.yield(0) -- Adjust yield time as needed to prevent blocking
    end

    if responseCode == eInputResponse.IR_SUCCESS then
        local speedValue = tonumber(speedInput)
        if speedValue then
            local playerVeh = player.get_player_vehicle(pid)
            if playerVeh ~= 0 then
                network.request_control_of_entity(playerVeh)
                system.yield(25) -- Yield to ensure control is established before setting speed
                local selectionOption = feat.value + 1
                if selectionOption == 1 then
                    vehicle.set_vehicle_forward_speed(playerVeh, speedValue)
                elseif selectionOption == 2 then
                    entity.set_entity_max_speed(playerVeh, speedValue)
                end
            end
        end
    else
        menu.notify("Vehicle speed input canceled.", "Novo Script", 5)
    end
end)

set_veh_speed:set_str_data({"Set Speed", "Set Max Speed"})

menu.add_player_feature("Veh slow fall", "toggle", veh_misc, function(feat, pid)
    local fallThread = nil -- Declare the thread variable outside the loop

    if feat.on then
        -- Create the thread only if it does not exist or has finished
        if not fallThread or menu.has_thread_finished(fallThread) then
            fallThread = menu.create_thread(function()
                while feat.on do
                    if player.is_player_in_any_vehicle(pid) then
                        slow_fall_veh(pid, 1.8)
                    end
                    system.yield(0) -- Adjust yield time as necessary for performance and effectiveness
                end
                -- Once the loop exits (feature turned off), delete the object here if needed
            end)
        end
    else
        -- If the feature is turned off and the thread exists, ensure it is deleted properly
        if fallThread then
            menu.delete_thread(fallThread)
            fallThread = nil
        end
    end
end)

local waterThread = nil -- Declare the thread variable outside the loop

menu.add_player_feature("drive on water", "toggle", veh_misc, function(feat, pid)
    if feat.on then
        if not waterThread then
            waterThread = menu.create_thread(function()
                while feat.on do
                    if player.is_player_in_any_vehicle(pid) and entity.is_entity_in_water(player.get_player_vehicle(pid)) then
                        if drive_on_this_height_num_self % 2 == 0 then
                            slow_fall_veh(pid, 1.5) -- 1.5
                        else
                            slow_fall_veh(pid, 1.345) -- 1.9
                        end
                        drive_on_this_height_num_self = drive_on_this_height_num_self + 1
                    end
                    system.yield(0) -- Adjust yield as necessary for performance and responsiveness
                end
            end)
        end
    else
        if waterThread then
            menu.delete_thread(waterThread)
            waterThread = nil
        end
    end
end)

being_remote_controlled = false

remote_control = menu.add_player_feature("Control Their Vehicle", "action", veh_greif, function(feat, pid)

    -- Maybe add a gloab var to say weather its controled or no, then ad a stop control feature that will unfreeze there, or auto unfreeze when player exits veh. 
        local veh = player.get_player_vehicle(pid)
        network.request_control_of_entity(veh)
        system.yield(25)
        local hash = entity.get_entity_model_hash(veh)
        streaming.request_model(hash)
        while not streaming.has_model_loaded(hash) do
            system.yield(0)
        end
        remote_veh = vehicle.create_vehicle(hash, entity.get_entity_coords(veh), 0, true, false)
        entity.set_entity_visible(remote_veh, false)
        entity.set_entity_god_mode(remote_veh, true)
        ped.set_ped_into_vehicle(player.get_player_ped(player.player_id()), remote_veh, -1)
        system.yield(50)
        entity.freeze_entity(veh, true)
        entity.set_entity_coords_no_offset(remote_veh, entity.get_entity_coords(veh))
        entity.set_entity_rotation(remote_veh, entity.get_entity_rotation(veh))
        being_remote_controlled = true
        while being_remote_controlled do
            entity.attach_entity_to_entity(veh, remote_veh, 0, v3(0,0,0), v3(0,0,0), true, false, false, 0, true)
            system.yield(500)
        end

end)

    
drive_on_this_height_num = 0
menu.add_player_feature("drive on this height", "toggle", veh_misc, function(feat, pid)
    local driveThread = nil -- Declare the thread variable outside the loop

    if feat.on then
        if not driveThread then
            driveThread = menu.create_thread(function()
                while feat.on do
                    if player.is_player_in_any_vehicle(pid) then
                        if drive_on_this_height_num % 2 == 0 then
                            slow_fall_veh(pid, 1.5) -- 1.5
                        else
                            slow_fall_veh(pid, 1.345) -- 1.9
                        end
                        drive_on_this_height_num = drive_on_this_height_num + 1
                    end
                    system.yield(0) -- Adjust yield as necessary for performance and responsiveness
                end
            end)
        end
    else
        if driveThread then
            menu.delete_thread(driveThread)
            driveThread = nil
        end
    end
end)

menu.add_player_feature("drive on walls", "toggle", veh_misc, function(feat, pid)
    local driveThread = nil -- Declare the thread variable outside the loop

    if feat.on then
        if not driveThread or menu.has_thread_finished(driveThread) then
            if driveThread then
                -- Clean up the finished thread before starting a new one
                menu.delete_thread(driveThread)
            end

            driveThread = menu.create_thread(function()
                while feat.on do
                    if player.is_player_in_any_vehicle(pid) then
                        local veh = player.get_player_vehicle(pid)
                        native.call(0xC5F68BE9613E2D18, veh, 1, 0, 0, -0.4, 0, 0, 0, false, true, true, true, false, true)
                    end
                    system.yield(0)
                end
            end)
        end
    else
        if driveThread then
            -- If the feature is turned off and a thread exists, clean it up
            menu.delete_thread(driveThread)
            driveThread = nil
        end
    end
end)


--######################################################################################################################


    
drive_on_this_height_num_self = 0
menu.add_feature("drive on this height", "toggle", session_my_veh.id, function(feat)
    local pid = player.player_id()
    local driveThread_self = nil -- Declare the thread variable outside the loop

    if feat.on then
        if not driveThread_self then
            driveThread_self = menu.create_thread(function()
                while feat.on do
                    if player.is_player_in_any_vehicle(pid) then
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

menu.add_feature("drive on walls", "toggle", session_my_veh.id, function(feat)
    local pid = player.player_id()
    local driveThread_wall = nil -- Declare the thread variable outside the loop

    if feat.on then
        if not driveThread_wall or menu.has_thread_finished(driveThread_wall) then
            if driveThread_wall then
                -- Clean up the finished thread before starting a new one
                menu.delete_thread(driveThread_wall)
            end

            driveThread_wall = menu.create_thread(function()
                while feat.on do
                    if player.is_player_in_any_vehicle(pid) then
                        local veh = player.get_player_vehicle(pid)
                        native.call(0xC5F68BE9613E2D18, veh, 1, 0, 0, -0.4, 0, 0, 0, false, true, true, true, false, true)
                    end
                    system.yield(0)
                end
            end)
        end
    else
        if driveThread_wall then
            -- If the feature is turned off and a thread exists, clean it up
            menu.delete_thread(driveThread_wall)
            driveThread_wall = nil
        end
    end
end)

menu.add_feature("Veh slow fall", "toggle", session_my_veh.id, function(feat)
    local pid = player.player_id()
    local fallThread_self = nil -- Declare the thread variable outside the loop

    if feat.on then
        -- Create the thread only if it does not exist or has finished
        if not fallThread_self or menu.has_thread_finished(fallThread_self) then
            fallThread_self = menu.create_thread(function()
                while feat.on do
                    if player.is_player_in_any_vehicle(pid) then
                        slow_fall_veh(pid, 1.8)
                    end
                    system.yield(0) -- Adjust yield time as necessary for performance and effectiveness
                end
                -- Once the loop exits (feature turned off), delete the object here if needed
            end)
        end
    else
        -- If the feature is turned off and the thread exists, ensure it is deleted properly
        if fallThread_self then
            menu.delete_thread(fallThread_self)
            fallThread_self = nil
        end
    end
end)

local waterThread_self = nil -- Declare the thread variable outside the loop

menu.add_feature("drive on water", "toggle", session_my_veh.id, function(feat)
    local pid = player.player_id()
    if feat.on then
        if not waterThread then
            waterThread = menu.create_thread(function()
                while feat.on do
                    if player.is_player_in_any_vehicle(pid) and entity.is_entity_in_water(player.get_player_vehicle(pid)) then
                        if drive_on_this_height_num_self % 2 == 0 then
                            slow_fall_veh(pid, 1.5) -- 1.5
                        else
                            slow_fall_veh(pid, 1.345) -- 1.9
                        end
                        drive_on_this_height_num_self = drive_on_this_height_num_self + 1
                    end
                    system.yield(0) --necessary for performance and responsiveness
                end
            end)
        end
    else
        if waterThread then
            menu.delete_thread(waterThread)
            waterThread = nil
        end
    end
end)

bombThread = nil -- Declare the thread variable outside the loop

bomb_features = menu.add_feature("Unlimited Plane Bombs", "toggle", session_my_veh.id, function(feat)
    
    if feat.on then
        if not bombThread then
            bombThread = menu.create_thread(function()
                while feat.on do
                    local veh = player.get_player_vehicle(player.player_id())
                    native.call(0xF4B2ED59DEB5D774, veh, 10)
                    system.yield(0)
                end
            end)
        end
    else
        if bombThread then
            menu.delete_thread(bombThread)
            bombThread = nil
        end
    end
end)
--  

thread_through_wall = nil

drive_through_things = menu.add_feature("drive through things", "toggle", session_my_veh.id, function(feat)
    local myveh = player.get_player_vehicle(player.player_id())
    entity.set_entity_collision(myveh, false, true, false)
    
    if feat.on then
        if not thread_through_wall then
            thread_through_wall = menu.create_thread(function()
                while feat.on do
                    vehicle.set_vehicle_on_ground_properly(myveh)
                    system.yield(1)
                end
                system.yield(0)
            end)
        end
    else
        entity.set_entity_collision(myveh, true, true, false)
        if thread_through_wall then
            menu.delete_thread(thread_through_wall)
            thread_through_wall = nil
        end
    end
end)

menu.add_player_feature("Set license plate", "action", veh_troll, function(feat, pid)
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
end)

