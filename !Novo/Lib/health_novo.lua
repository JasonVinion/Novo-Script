menu.add_feature("Set Custom Health", "action", Health.id, function(feat)
    local responseCode, healthInput = -1, ""
    while responseCode ~= eInputResponse.IR_SUCCESS and responseCode ~= eInputResponse.IR_FAILED do
        responseCode, healthInput = input.get("Enter health value", "", 10, eInputType.IT_NUM)
        system.yield(0) -- Adjust yield time as needed to prevent blocking
    end

    if responseCode == eInputResponse.IR_SUCCESS then
        local healthValue = tonumber(healthInput)
        if healthValue then
            local playerPed = player.get_player_ped(player.player_id())
            ped.set_ped_max_health(playerPed, healthValue)
            ped.set_ped_health(playerPed, healthValue)
            local get_health = ped.get_ped_health(playerPed)
            local get_max_health = ped.get_ped_max_health(playerPed)   
        end
    else
        menu.notify("Health input canceled.", "Novo Script", 5)
    end
end)


menu.add_feature("Set Max Health", "action", Health.id, function(feat)
    local responseCode, maxHealthInput = -1, ""
    while responseCode ~= eInputResponse.IR_SUCCESS and responseCode ~= eInputResponse.IR_FAILED do
        responseCode, maxHealthInput = input.get("Enter max health value", "", 10, eInputType.IT_NUM)
        system.yield(0) -- Adjust yield time as needed to prevent blocking
    end

    if responseCode == eInputResponse.IR_SUCCESS then
        local maxHealthValue = tonumber(maxHealthInput)
        if maxHealthValue then
            local playerPed = player.get_player_ped(player.player_id())
            ped.set_ped_max_health(playerPed, maxHealthValue)
            menu.notify("Max health set to " .. maxHealthValue, "Novo Script", 5)
        else
            menu.notify("Invalid max health value.", "Novo Script", 5)
        end
    else
        menu.notify("Max health input canceled.", "Novo Script", 5)
    end
end)

menu.add_feature("Refill Armor", "action", Health.id, function(feat)
    for i = 1, 5 do
        local statKey = constructMPCharKey() .. "MP_CHAR_ARMOUR_" .. i .. "_COUNT"
        stats.stat_set_int(gameplay.get_hash_key(statKey), 10, true)
    end
end)

menu.add_feature("Refill snacks", "action", Health.id, function(feat)
    -- Define a table of snack types and their refill quantities
    local snacks = {
        {"NO_BOUGHT_YUM_SNACKS", 30},
        {"NO_BOUGHT_HEALTH_SNACKS", 15},
        {"NO_BOUGHT_EPIC_SNACKS", 5},
        {"NUMBER_OF_CHAMP_BOUGHT", 5},
        {"NUMBER_OF_ORANGE_BOUGHT", 11},
        {"NUMBER_OF_BOURGE_BOUGHT", 10},
        {"NUMBER_OF_SPRUNK_BOUGHT", 10},
    }

    -- Loop through the table and set each stat
    for _, snack in ipairs(snacks) do
        local statKey = constructMPCharKey() .. snack[1]
        stats.stat_set_int(gameplay.get_hash_key(statKey), snack[2], true)
    end
end)

local healTwiceQuick = menu.add_feature("Heal Twice as Quick", "toggle", Health.id, function(feat)
    while feat.on do
        local playerPed = player.get_player_ped(player.player_id())
        local currentHealth = ped.get_ped_health(playerPed)
        ped.set_ped_health(playerPed, currentHealth + 1)
        system.yield(250)
    end
end)

local healInCombat = menu.add_feature("Heal in Combat", "toggle", Health.id, function(feat)
    while feat.on do
        if native.call(0x4859F1FC66A6278E, player.get_player_ped(player.player_id()), ped.get_all_peds()) then
            local playerPed = player.get_player_ped(player.player_id())
            local currentHealth = ped.get_ped_health(playerPed)
            ped.set_ped_health(playerPed, currentHealth + 1)
        end
        system.yield(500)
    end
end)

local healInVehicle = menu.add_feature("fast Heal in Vehicle", "toggle", Health.id, function(feat)
    while feat.on do
        local playerPed = player.get_player_ped(player.player_id())
        local playerVehicle = player.get_player_vehicle(player.player_id())
        if playerVehicle ~= 0 then
            local currentHealth = ped.get_ped_health(playerPed)
            ped.set_ped_health(playerPed, currentHealth + 1)
        end
        system.yield(175)
    end
end)


