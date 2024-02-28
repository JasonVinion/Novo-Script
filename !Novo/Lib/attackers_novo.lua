-- Main toggle feature for spawning attackers
local spawn_attackers = menu.add_player_feature("Spawn Basic Attackers", "value_str", attackers, function(feat, pid)
    local selectedOption = feat.value + 1
    local attacker_types = {"on foot", "in car", "in heli", "in plane", "in boat", "animals"}
    local selectedType = attacker_types[selectedOption]

    local attackers = {}
    attackers[selectedType] = {spawn_attacker(selectedType, pid)}

    while feat.on do
        if attackers[selectedType] and (attackers[selectedType][1] == nil or entity.is_entity_dead(attackers[selectedType][1])) then
            if attackers[selectedType][1] then entity.delete_entity(attackers[selectedType][1]) end
            if attackers[selectedType][2] then entity.delete_entity(attackers[selectedType][2]) end
            attackers[selectedType] = {spawn_attacker(selectedType, pid)}
        end

        if attackers[selectedType] then
            attackers[selectedType][1], attackers[selectedType][2] = manage_attackers(attackers[selectedType][1], attackers[selectedType][2], pid)
        end

        system.wait(1000) -- Adjust timing as needed
    end

    -- Cleanup when toggled off
    if attackers[selectedType] then
        if attackers[selectedType][1] then entity.delete_entity(attackers[selectedType][1]) end
        if attackers[selectedType][2] then entity.delete_entity(attackers[selectedType][2]) end
    end
end)

spawn_attackers:set_str_data({"On Foot", "In Car", "In Heli", "In Plane", "In Boat", "Animals"})

--RAYPISTOL MovAlien01

local alien_invasion = menu.add_player_feature("Alien Invasion", "toggle", attackers, function(feat, pid)
    local aliens = {}

    for i = 1, 10 do
        table.insert(aliens, spawn_alien(pid))
    end

    while feat.on do
        for i, alien in ipairs(aliens) do
            if entity.is_entity_dead(alien) then
                entity.delete_entity(alien)
                aliens[i] = spawn_alien(pid)
            end
        end
        system.wait(500)
    end

    for _, alien in ipairs(aliens) do
        if alien then
            entity.delete_entity(alien)
        end
    end
end)


local zombie_apocalypse = menu.add_player_feature("Zombie Apocalypse", "toggle", attackers, function(feat, pid)
    local zombies = {}

    for i = 1, 10 do
        table.insert(zombies, spawn_zombie(pid))
    end

    while feat.on do
        for i, zombie in ipairs(zombies) do
            if entity.is_entity_dead(zombie) then
                entity.delete_entity(zombie)
                zombies[i] = spawn_zombie(pid)
            end
        end
        system.yield(500)
    end

    for _, zombie in ipairs(zombies) do
        if zombie then
            entity.delete_entity(zombie)
        end
    end
end)

bodygaurds_knock_off = menu.add_feature("set bodyguard knocked off vehicle", "action_value_str", bodygaurd_features.id, function(feat)
    local selectedOption = feat.value + 1  -- Increment by 1 due to 0-indexing
    local playerGroup = native.call(0x0D127585F77030AF, player.player_id()) -- get player group
    local playerGroupInt = playerGroup:__tointeger()

    local allPeds = ped.get_all_peds()
    for _, pedsinarea in ipairs(allPeds) do
        local pedGroup = native.call(0xF162E133B4E7A675, pedsinarea) -- get ped group
        local pedGroupInt = pedGroup:__tointeger()

        if pedGroupInt == playerGroupInt and not ped.is_ped_a_player(pedsinarea) then
            if selectedOption == 1 then
                native.call(0x7A6535691B477C48, pedsinarea, 1) -- SET_PED_CAN_BE_KNOCKED_OFF_VEHICLE
            elseif selectedOption == 2 then
                native.call(0x7A6535691B477C48, pedsinarea, 2)
            end
        end
        system.yield(0)
    end
end)

bodygaurds_knock_off:set_str_data({"Can't be", "Can be"})

menu.add_feature("Set bodyguard accuracy", "action", bodygaurd_features.id, function(feat)
    local responseCode, accuracyInput = -1, ""
    while responseCode ~= eInputResponse.IR_SUCCESS and responseCode ~= eInputResponse.IR_FAILED do
        responseCode, accuracyInput = input.get("Enter ped accuracy (0-100)", "", 10, eInputType.IT_NUM)
        system.yield(0) -- Adjust yield time as needed to prevent blocking
    end

    if responseCode == eInputResponse.IR_SUCCESS then
        local accuracyValue = tonumber(accuracyInput)
        if accuracyValue then
            local playerGroup = native.call(0x0D127585F77030AF, player.player_id()) -- get player group
            local playerGroupInt = playerGroup:__tointeger()
            local allPeds = ped.get_all_peds()
            for _, pedsinarea in ipairs(allPeds) do
                local pedGroup = native.call(0xF162E133B4E7A675, pedsinarea) -- get ped group
                local pedGroupInt = pedGroup:__tointeger()
                if pedGroupInt == playerGroupInt and not ped.is_ped_a_player(pedsinarea) then
                    native.call(0x7AEFB85C1D49DEB6, pedsinarea, accuracyValue) -- SET_PED_ACCURACY
                end
                system.yield(0)
            end
        end
    else
        menu.notify("Ped accuracy input canceled.", "Novo Script", 5)
    end
end)