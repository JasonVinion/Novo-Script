local tazeFeature = menu.add_player_feature("Taze player", "toggle", trolling, function(feature, pid)
    local spawnedCop = nil
  
    local function spawnCop(pos)
        local copModel = gameplay.get_hash_key("s_m_y_hwaycop_01")
        local taserHash = gameplay.get_hash_key("weapon_stungun")
        streaming.request_model(copModel)
        while not streaming.has_model_loaded(copModel) do
            system.yield(25)
        end
        spawnedCop = ped.create_ped(6, copModel, pos, pos.z, true, false)
        weapon.give_delayed_weapon_to_ped(spawnedCop, taserHash, 1, 1)
        entity.set_entity_god_mode(spawnedCop, true)
    end

    local pos = player.get_player_coords(pid)
    spawnCop(pos)
    system.yield(1)
    entity.set_entity_visible(spawnedCop, false, false)
    while feature.on do
        if entity.is_entity_dead(spawnedCop) then
            entity.delete_entity(spawnedCop)
            spawnCop(pos)
            if selectedOption == 2 then
                system.wait(1)
                entity.set_entity_visible(spawnedCop, false, false)
            end
        end
        local targetPed = player.get_player_ped(pid)
        ai.task_combat_ped(spawnedCop, targetPed, 0, 16)

        local distance = get_distance_between(targetPed, spawnedCop, false)
        if distance > 7 then
            local targetPos = player.get_player_coords(pid)
            entity.set_entity_coords_no_offset(spawnedCop, targetPos)
        end

        local maxHealth = player.get_player_max_health(pid)
        local currentHealth = player.get_player_health(pid)
        if currentHealth < maxHealth then
            local healthPos = entity.get_entity_coords(targetPed)
            native.call(0x673966A0C0FD7171, 2406513688, healthPos.x, healthPos.y, healthPos.z, 0, 0, "prop_ld_health_pack", true, true)
           -- menu.notify("spawned", "debug", 9, 50)
        end

        system.wait(25)
    end

    if spawnedCop then
        entity.delete_entity(spawnedCop)
    end
    spawnedCop = nil
end)

local removeweaponattach = menu.add_player_feature("Remove weapon attachments", "action_value_str", trolling, function(feat, pid)
    local selectedOption = feat.value + 1
    local playerPed = player.get_player_ped(pid)

    if selectedOption == 1 then -- "All" is selected
        local allWeapons = weapon.get_all_weapon_hashes()
        weapon.remove_all_ped_weapons(playerPed)
        for _, weaponHash in ipairs(allWeapons) do
            weapon.give_delayed_weapon_to_ped(playerPed, weaponHash, 0, false)
            system.yield(0) -- Yielding for each weapon given to manage performance
        end
    elseif selectedOption == 2 then -- "Current" is selected
        local currentWeapon = ped.get_current_ped_weapon(playerPed)
        if currentWeapon and currentWeapon ~= -1 then -- Check if a valid weapon is equipped
            native.call(0x4899CB088EDF59B8, playerPed, currentWeapon)
            weapon.give_delayed_weapon_to_ped(playerPed, currentWeapon, 0, true)
        end
    end
end)

removeweaponattach:set_str_data({"All", "Current"})

menu.add_player_feature("Keep Wanted", "toggle", trolling, function(feat, pid)
    local remotePedCoords = entity.get_entity_coords(player.get_player_ped(pid))
    local remotePedHeading = entity.get_entity_heading(player.get_player_ped(pid))
    streaming.request_model(1581098148)
    while not streaming.has_model_loaded(1581098148) do
        system.yield(25)
    end

    police = ped.create_ped(6, 1581098148, remotePedCoords, remotePedHeading, true, false)

    entity.set_entity_collision(police, false, false)
    entity.set_entity_visible(police, false)

    while feat.on do
        remotePedCoords = entity.get_entity_coords(player.get_player_ped(pid)) -- Update coords each loop iteration
        entity.set_entity_coords_no_offset(police, remotePedCoords)
        system.yield(25)
    end

end)

 
 menu.add_player_feature("Squash Player", "action", trolling, function(feat, pid)
     local model = gameplay.get_hash_key("khanjali")
     local pid_coords = player.get_player_coords(pid)
     local playerpos = pid_coords + v3(0, 0, 3)
 
     streaming.request_model(model)
     while not streaming.has_model_loaded(model) do system.yield(25) end
 
     local heading = math.rad(player.get_player_heading(pid) + 180)
     local offset = v3(math.sin(heading) * 2, math.cos(heading) * 2, 3)
     local spawn_pos = pid_coords - offset
 
     local vehicles = {}
     for i = 1, 4 do
         vehicles[i] = vehicle.create_vehicle(model, (i == 1) and spawn_pos or playerpos, (i == 1) and player.get_player_heading(pid) or 0, true, false)
         if i > 1 then
             network.request_control_of_entity(vehicles[i])
             entity.attach_entity_to_entity(vehicles[i], vehicles[1], 0, v3(0, 3, 0), v3(0, 0, -180), false, true, false, 0, true)
         end
     end
 
     entity.set_entity_visible(vehicles[1], false)
     system.yield(2300)
     for _, vehicle in ipairs(vehicles) do entity.delete_entity(vehicle) end
 end)

-- Array to hold parsed ptfx data
ptfxList = {}

-- Parse the ptfx file
parsePtfxFile(ptfx_path)


-- Add the feature for triggering particle effects
local ptfx_action = menu.add_player_feature("Trigger Particle Effect: ", "action_value_str", trolling, function(feat, pid)
    if not ptfxList or #ptfxList == 0 then
        menu.notify("No particle effects found", "Error", 5)
        return
    end
    
    local selectedPtfx = ptfxList[feat.value + 1] -- Lua tables are 1-indexed
    local playerPed = player.get_player_ped(pid)
    local playerCoords = entity.get_entity_coords(playerPed)

    for i=1,2 do
        graphics.request_named_ptfx_asset(selectedPtfx.assetName)
        graphics.set_next_ptfx_asset(selectedPtfx.assetName)

        while not graphics.has_named_ptfx_asset_loaded(selectedPtfx.assetName) do
            system.yield(0)
        end
    
        graphics.start_networked_particle_fx_non_looped_at_coord(selectedPtfx.effectName, playerCoords, v3(0, 0, 0), 1.0, true, true, true)
    end

end)

ptfx_action:set_str_data(getEffectNames(ptfxList))

local ptfx_toggle = menu.add_player_feature("Trigger Particle Effect: ", "value_str", trolling, function(feat, pid)
    while feat.on do
        if not ptfxList or #ptfxList == 0 then
            menu.notify("No particle effects found", "Error", 5)
            return
        end

        local selectedPtfx = ptfxList[feat.value + 1] -- Lua tables are 1-indexed
        local playerPed = player.get_player_ped(pid)
        local playerCoords = entity.get_entity_coords(playerPed)

        graphics.request_named_ptfx_asset(selectedPtfx.assetName)
        graphics.set_next_ptfx_asset(selectedPtfx.assetName)

        while not graphics.has_named_ptfx_asset_loaded(selectedPtfx.assetName) do
            system.yield(0)
        end
    
        graphics.start_networked_particle_fx_non_looped_at_coord(selectedPtfx.effectName, playerCoords, v3(0, 0, 0), 1.0, true, true, true)
        system.yield(75)
    end
end)

ptfx_toggle:set_str_data(getEffectNames(ptfxList))

vent_objs = {}
menu.add_player_feature("Make Player Stumble", "toggle", trolling, function(feat, pid)
    objecttest = gameplay.get_hash_key("prop_roofvent_06a")
    streaming.request_model(objecttest)
    while not streaming.has_model_loaded(objecttest) do
        system.yield(0)
    end
    while feat.on do 
        pos = player.get_player_coords(pid)
        for i = -1.2, 1.2, 0.2 do
            for j = -1.2, 1.2, 0.2 do
                if i ~= 0 or j ~= 0 then
                    local vent = object.create_object(objecttest, v3(pos.x + i, pos.y + j, pos.z - 2.4), true, false, false)
                    table.insert(vent_objs, vent)
                    entity.set_entity_visible(vent, false)
                end
            end
        end
        system.yield(275)
        for _, obj in ipairs(vent_objs) do
            entity.delete_entity(obj)
        end
        vent_objs = {}
    end
end)
