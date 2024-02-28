local instantEnter = false

dev_logo_on_outfit = menu.add_feature("Add Rockstar logo to Outfit", "action", Self.id, function(feat)
    local myped = player.get_player_ped(player.player_id())
    native.call(0x5F5D1665E352A839, myped, -1398869298, -1730534702)
end)

local player_silent_thread = nil

player_silent = menu.add_feature("No noise", "toggle", Self.id, function(feat)
    if feat.on then
        player_silent_thread = menu.create_thread(togglePlayerSilent)
    else
        if player_silent_thread then
            menu.delete_thread(player_silent_thread)
        end
        player_silent_thread = nil
    end
end)


test_fire_breath = menu.add_feature("Continuous PTFX", "toggle", Self.id, function(feat)
    local dict = "core"
    local ptfx = "ent_sht_flame"
    local playerPed = player.get_player_ped(player.player_id())
    local offset = v3(-0.04, 0.4, 0.65)
    local rot = v3(90.0, 100.0, 90.0)

    local ptfxLoop

    while feat.on do
        if not toggle_fire.on then
            feat.on = false
        end

        graphics.set_next_ptfx_asset(dict)

        while not graphics.has_named_ptfx_asset_loaded(dict) do
            graphics.request_named_ptfx_asset(dict)
            system.wait(0)
        end

        ptfxLoop = graphics.start_networked_ptfx_looped_on_entity(ptfx, playerPed, offset, rot, 1.0)
        system.yield(0) 

        if not feat.on then
            break
        end
    end

    if ptfxLoop then
        graphics.remove_ptfx_from_entity(playerPed)  
        graphics.remove_particle_fx(ptfxLoop, true)
    end

    graphics.remove_ptfx_in_range(player.get_player_coords(player.player_id()), 10.0)
end)


test_fire_breath.hidden = true


toggle_fire = menu.add_feature("Fire Breath", "toggle", Self.id, function(feat)
    local playerPed = player.get_player_ped(player.player_id())
    while feat.on do
        test_fire_breath:toggle()
        system.yield(7000)
        test_fire_breath:toggle(false)
        system.yield(10)
        if not test_fire_breath.on then
            graphics.remove_ptfx_from_entity(playerPed) 
            if ptfxLoop ~= nil then
                graphics.remove_particle_fx(ptfxLoop, true)
            end
            graphics.remove_ptfx_in_range(player.get_player_coords(player.player_id()), 10.0)
        end
    end
end)




menu.add_feature("Instant Vehicle Entry", "toggle", Self.id, function(feat)
    instantEnter = feat.on
    while instantEnter do
        system.yield(0) -- Always yield in loops to prevent freezing

        local playerPed = player.get_player_ped(player.player_id())

        -- Check if the player is not already in a vehicle
        if not player.is_player_in_any_vehicle(playerPed) then

            local isTryingToEnter = native.call(0xB0760331C7AA4155, playerPed, 160):__tointeger() -- GET_IS_TASK_ACTIVE, task code 160 = entering vehicle

            if isTryingToEnter ~= 0 then
                local vehTryingToEnter = native.call(0x814FA8BE5449445D, playerPed):__tointeger() -- GET_VEHICLE_PED_IS_TRYING_TO_ENTER
                
                -- Check if there is already a driver in the car
                local driverPed = vehicle.get_ped_in_vehicle_seat(vehTryingToEnter, -1)
                if driverPed and driverPed ~= 0 and driverPed ~= playerPed then
                    -- If there's a driver, clear their tasks so they exit the vehicle
                    ped.clear_ped_tasks_immediately(driverPed)
                    system.yield(10) -- Give 10ms for the driver to get outda
                end

                -- Set the player into the vehicle they're trying to enter, in the driver seat (-1)
                ped.set_ped_into_vehicle(playerPed, vehTryingToEnter, -1) -- SET_PED_INTO_VEHICLE
            end

        else
            system.yield(500) -- If the player is already in a vehicle, wait for half a second before the next check
        end
    end
end)

-- Add the feature to the menu
local feature = menu.add_feature("Instant Resurrect Player", "toggle", Self.id, function(feat)
    if feat.on then
        shouldMonitorHealth = true
        -- Create and start the thread when the feature is activated
        check_health_thread = menu.create_thread(monitorAndResurrectPlayer, {})
    else
        shouldMonitorHealth = false
        menu.delete_thread(check_health_thread)
        -- No need to explicitly delete the thread; it exits when shouldMonitorHealth is false
    end
end)

local hotWireThread = nil

menu.add_feature("Instant Hot Wire Vehicle", "toggle", Self.id, function(feat)
    if feat.on then
        if hotWireThread == nil then
            hotWireThread = menu.create_thread(function()
                while feat.on do
                    system.yield(0) -- Always yield in loops to prevent freezing

                    local playerPed = player.get_player_ped(player.player_id())

                    -- Check if the player is not already in a vehicle
                    if not player.is_player_in_any_vehicle(playerPed) then

                        local isTryingToEnter = native.call(0xB0760331C7AA4155, playerPed, 160):__tointeger() -- GET_IS_TASK_ACTIVE, task code 160 = entering vehicle

                        if isTryingToEnter ~= 0 then
                            local vehTryingToEnter = native.call(0x814FA8BE5449445D, playerPed):__tointeger() -- GET_VEHICLE_PED_IS_TRYING_TO_ENTER

                            -- Check if there is already a driver in the car
                            local driverPed = vehicle.get_ped_in_vehicle_seat(vehTryingToEnter, -1)
                            if driverPed and driverPed ~= 0 and driverPed ~= playerPed then
                                -- If there's a driver, clear their tasks so they exit the vehicle
                                ped.clear_ped_tasks_immediately(driverPed)
                                system.yield(10) -- Give 10ms for the driver to get out
                            end
                            native.call(0xFBA550EA44404EE6, vehTryingToEnter, false) -- SET_VEHICLE_NEEDS_TO_BE_HOTWIRED
                        end

                    else
                        system.yield(500) -- If the player is already in a vehicle, wait for half a second before the next check
                    end
                end
            end)
        end
    else
        if hotWireThread ~= nil then
            menu.delete_thread(hotWireThread)
            hotWireThread = nil
        end
    end
end)

walk_under_water = menu.add_feature("Walk Under Water", "toggle", Self.id, function(feat)
    local walkUnderWaterThread = nil -- Declare the thread variable outside the loop
    local playerPed = player.get_player_ped(player.player_id())
    
    if entity.is_entity_in_water(playerPed) then
        ped.clear_ped_tasks_immediately(playerPed)
    end
    
    if feat.on then
        if not walkUnderWaterThread then
            walkUnderWaterThread = menu.create_thread(function()
                while feat.on do
                    local playerPed = player.get_player_ped(player.player_id())
                    
                    if entity.is_entity_in_water(playerPed) then
                        native.call(0x1913FE4CBF41C463, playerPed, 65, false)
                        native.call(0x1913FE4CBF41C463, playerPed, 66, false)
                        native.call(0x1913FE4CBF41C463, playerPed, 168, false)
                        
                        local playerPos = entity.get_entity_coords(playerPed)
                        
                        if native.call(0xCEDABC5900A0BF97, playerPed) then
                        end
                        
                        local userdata = native.call(0x1DD55701034110E5, playerPed)
                        local userdata_int = userdata:__tointeger()
                        
                        if userdata_int > -9999999999999 then
                            if ped.is_ped_swimming(playerPed) then
                                ped.clear_ped_tasks_immediately(playerPed)
                            end
                            
                            native.call(0x1913FE4CBF41C463, playerPed, 60, false)
                            native.call(0x1913FE4CBF41C463, playerPed, 61, false)
                            native.call(0x1913FE4CBF41C463, playerPed, 104, false)
                            native.call(0x1913FE4CBF41C463, playerPed, 276, false)
                            native.call(0x1913FE4CBF41C463, playerPed, 76, true)
                            
                            entity.apply_force_to_entity(playerPed, 1, 0, 0, -0.7, 0, 0, 0, true, true)
                            
                            if ped.is_ped_swimming(playerPed) then
                                ped.clear_ped_tasks_immediately(playerPed)
                            end
                        end
                        
                        if ped.is_ped_swimming(playerPed) then
                            ped.clear_ped_tasks_immediately(playerPed)
                        end
                    end
                    
                    system.yield(0)
                end
            end)
        end
    else
        if walkUnderWaterThread then
            menu.delete_thread(walkUnderWaterThread)
            walkUnderWaterThread = nil
        end
    end
end)