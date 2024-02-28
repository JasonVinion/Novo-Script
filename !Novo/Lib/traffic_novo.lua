menu.add_feature("Rainbow Traffic", "toggle", traffic.id, function(f)
    while f.on do
        local allVehicles = vehicle.get_all_vehicles()

        for _, v in pairs(allVehicles) do
            if not network.has_control_of_entity(v) then
                network.request_control_of_entity(v)
                while not network.has_control_of_entity(v) do
                    system.yield(25)
                end
            end
            local colorPrimary = math.random(0, 159)
            local colorSecondary = math.random(0, 159)
            local colorThird = math.random(0, 159)
            vehicle.set_vehicle_color(v, colorPrimary, colorSecondary, colorThird, 0)
        end
        system.yield(500) -- Check every half second
    end

    if not f.on then
        modifiedVehicles = {} -- Clear the table when feature is turned off
    end
end)


local modifiedVehicles = {}

menu.add_feature("Performance upgrade Traffic", "toggle", traffic.id, function(f)
    while f.on do
        local allVehicles = vehicle.get_all_vehicles()

        for _, v in pairs(allVehicles) do
            if not modifiedVehicles[v] then
                vehicle.modify_vehicle_top_speed(v, 1.5) -- Increase top speed by 50%
                -- Set max performance upgrades
                vehicle.set_vehicle_mod(v, 11, vehicle.get_num_vehicle_mods(v, 11) - 1, false) -- Engine
                vehicle.set_vehicle_mod(v, 12, vehicle.get_num_vehicle_mods(v, 12) - 1, false) -- Brakes
                vehicle.set_vehicle_mod(v, 13, vehicle.get_num_vehicle_mods(v, 13) - 1, false) -- Transmission
                vehicle.set_vehicle_mod(v, 16, vehicle.get_num_vehicle_mods(v, 16) - 1, false) -- Armor
                vehicle.set_vehicle_mod(v, 18, vehicle.get_num_vehicle_mods(v, 18) - 1, false) -- Turbo
                table.insert(modifiedVehicles, v)
            end
        end
        system.yield(1000) -- Check every second
    end

    if not f.on then
        modifiedVehicles = {} -- Clear the table when feature is turned off
    end
end)

local function freezeVehicle(vehicle, freeze)
        entity.set_entity_velocity(vehicle, v3(0, 0, 0))
        entity.freeze_entity(vehicle, freeze)
end

menu.add_feature("Freeze Traffic", "toggle", traffic.id, function(f)
    local allVehicles = vehicle.get_all_vehicles()
    while f.on do

        for _, v in pairs(allVehicles) do
                freezeVehicle(v, true)
        end
        system.yield(1000) -- Check every second
    end

    if not f.on then
        for _, v in pairs(allVehicles) do
            entity.freeze_entity(v, false)
        end
    end
end)

local playerVehicles = {} -- Table to store player vehicles

-- Function to check if a vehicle is tracked as a player vehicle
local function isPlayerVehicle(vehicle)
    return playerVehicles[vehicle] == true
end

-- Function to track player vehicles
-- I think the threading sucks for this, because of the pid loop in every thread, but I don't want to start too many threads and deplete resources. I'll look into it later.
local function trackPlayerVehicles()
    local allVehicles = vehicle.get_all_vehicles()
    for i = 1, #allVehicles do
        menu.create_thread(function()
            local vehicle = allVehicles[i]
            for pid = 0, 31 do
                if player.is_player_in_any_vehicle(pid) and player.get_player_vehicle(pid) == vehicle then
                -- Vehicle is being driven by a player, add to tracking table
                    playerVehicles[vehicle] = true
                end
            end
        end)
    end
end

-- Function to remove all non-player vehicles
local function removeNonPlayerVehicles()
    local vehicles = vehicle.get_all_vehicles()
    for i = 1, #vehicles do
        menu.create_thread(function()
            local vehicle = vehicles[i]
            if not isPlayerVehicle(vehicle) then
                -- Request control of the vehicle
                while not network.has_control_of_entity(vehicle) do
                    network.request_control_of_entity(vehicle)
                    system.yield(25) -- Wait until control is gained
                end
                -- Delete the vehicle
                entity.delete_entity(vehicle)
            end
        end)
    end
end

local removeTrafficFeature = menu.add_feature("Remove Traffic", "toggle", traffic.id, function(feat)
    while feat.on do
        trackPlayerVehicles()
        removeNonPlayerVehicles()
        system.yield(1000) -- Wait for 1 second before repeating the process
    end

    -- Clear tracked vehicles when feature is turned off
    if not feat.on then
        playerVehicles = {}
    end
end)

