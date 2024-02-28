-- Table to store blacklisted vehicle hashes
blacklistedVehicles = {}

-- Feature to toggle blacklisted vehicle removal
menu.add_feature("Toggle Blacklisted Vehicle Removal", "toggle", Block_veh.id, function(feat)
    while feat.on do
        for pid = 0, 32 do
            local currentVehicle = player.get_player_vehicle(pid)
            local vehicleModelHash = entity.get_entity_model_hash(currentVehicle)
            if blacklistedVehicles[vehicleModelHash] then
                network.request_control_of_entity(currentVehicle)
                while not network.has_control_of_entity(currentVehicle) do
                    system.yield(25)
                end
                entity.delete_entity(currentVehicle)
            end
        end
        system.yield(500)
    end
end)

-- Feature to add the vehicle hash player is aiming at to the blacklist
menu.add_feature("Add Aiming at Vehicle to Blacklist", "action", Block_veh.id, function(feat)
    local aimedEntity = player.get_entity_player_is_aiming_at(player.player_id())
    if aimedEntity and entity.is_entity_a_vehicle(aimedEntity) then
        local vehicleHash = entity.get_entity_model_hash(aimedEntity)
        blacklistedVehicles[vehicleHash] = true
        menu.notify("Aimed vehicle added to blacklist.", "Success")
    else
        menu.notify("No vehicle aimed at.", "Error")
    end
end)

-- Feature to add vehicle to blacklist by name
menu.add_feature("Add Vehicle to Blacklist by Name", "action", Block_veh.id, function(feat)
    local responseCode, vehicleName = -1, ""
    while responseCode ~= eInputResponse.IR_SUCCESS and responseCode ~= eInputResponse.IR_FAILED do
        responseCode, vehicleName = input.get("Enter name of Vehicle", "", 10, eInputType.IT_STR or 0)
        system.wait(0) -- Prevent freezing, let the game process other events
    end

    if responseCode == eInputResponse.IR_SUCCESS then
        local vehicleHash = gameplay.get_hash_key(vehicleName)
        if vehicleHash ~= 0 then
            blacklistedVehicles[vehicleHash] = true
            menu.notify("Vehicle added to blacklist.", "Success")
        else
            menu.notify("Invalid vehicle name.", "Error")
        end
    elseif responseCode == eInputResponse.IR_FAILED then
        menu.notify("Vehicle input canceled.", "Error")
    end
end)

--feature to remove vehicle from blacklist by name
menu.add_feature("Remove Vehicle from Blacklist by Name", "action", Block_veh.id, function(feat)
    local responseCode, vehicleName = -1, ""
    while responseCode ~= eInputResponse.IR_SUCCESS and responseCode ~= eInputResponse.IR_FAILED do
        responseCode, vehicleName = input.get("Enter name of Vehicle", "", 10, eInputType.IT_STR or 0)
        system.wait(0) -- Prevent freezing, let the game process other events
    end

    if responseCode == eInputResponse.IR_SUCCESS then
        local vehicleHash = gameplay.get_hash_key(vehicleName)
        if vehicleHash ~= 0 then
            if blacklistedVehicles[vehicleHash] then
                blacklistedVehicles[vehicleHash] = nil
                menu.notify("Vehicle removed from blacklist.", "Success")
            else
                menu.notify("Vehicle not in blacklist.", "Error")
            end
        else
            menu.notify("Invalid vehicle name.", "Error")
        end
    elseif responseCode == eInputResponse.IR_FAILED then
        menu.notify("Vehicle input canceled.", "Error")
    end
end)

-- Feature to remove the vehicle hash player is aiming at from the blacklist
menu.add_feature("Remove Aiming at Vehicle from Blacklist", "action", Block_veh.id, function(feat)
    local aimedEntity = player.get_entity_player_is_aiming_at(player.player_id())
    if aimedEntity and entity.is_entity_a_vehicle(aimedEntity) then
        local vehicleHash = entity.get_entity_model_hash(aimedEntity)
        if blacklistedVehicles[vehicleHash] then
            blacklistedVehicles[vehicleHash] = nil
            menu.notify("Aimed vehicle removed from blacklist.", "Success")
        else
            menu.notify("Aimed vehicle not in blacklist.", "Error")
        end
    else
        menu.notify("No vehicle aimed at.", "Error")
    end
end)

-- option to remove all blacklisted vehicles
menu.add_feature("Remove All Blacklisted Vehicles", "action", Block_veh.id, function(feat)
    for vehicleHash, _ in pairs(blacklistedVehicles) do
        blacklistedVehicles[vehicleHash] = nil
    end
    menu.notify("All blacklisted vehicles removed.", "Success")
end)

-- Feature to show all blacklisted vehicle hashes
menu.add_feature("Show Blacklisted Vehicles", "action", Block_veh.id, function(feat)
    local vehicleNames = readVehicleNamesBlacklist(veh_names_path)
    local hasBlacklistedVehicles = false

    for vehicleHash, _ in pairs(blacklistedVehicles) do
        local name = vehicleNames[vehicleHash] or "error getting name"
        local message = "Vehicle name: " .. name .. "\nVehicle hash: " .. tostring(vehicleHash)
        menu.notify(message, "Blacklisted Vehicles", 9, 50)
        hasBlacklistedVehicles = true
    end

    if not hasBlacklistedVehicles then
        menu.notify("No vehicles are blacklisted.", "Blacklisted Vehicles", 9, 50)
    end

    --system.yield(5000)
    --menu.clear_all_notifications()
end)


-- Feature to provide blacklist save/load options
local black_save_load = menu.add_feature("Blacklist options", "action_value_str", Block_veh.id, function(feat)
    local selectedOption = feat.value + 1
    if selectedOption == 1 then
        saveBlacklistToFile()
    elseif selectedOption == 2 then
        loadBlacklistFromFile()
    else
        menu.notify("Invalid option selected.", "Error", 5)
    end
end)

-- Set the string data for the feature options
black_save_load:set_str_data({"Save", "Load"})