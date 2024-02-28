-- Initialize blockedAreas as an empty table
blockedAreas = {}

-- Block Areas feature
blockAreasFeature = menu.add_feature("Block Areas", "action_value_str", Session.id, function(feat)
    local selectedOption = feat.value + 1

    if selectedOption == 1 then
        blockArea("Maze Bank Garage", {
            { hash = gameplay.get_hash_key("prop_fnclink_04a"), x = -86.91, y = -780.44, z = 37.95, rot = {x = 0, y = 0, z = 25} },
            { hash = gameplay.get_hash_key("prop_fnclink_04a"), x = -83.27, y = -778.48, z = 38.17, rot = {x = 0, y = 0, z = 25} },
        })
    elseif selectedOption == 2 then
        blockArea("Casino Entrance", {
            { hash = gameplay.get_hash_key("stt_prop_stunt_bblock_qp2"), x = 932.63, y = 88.69, z = 50, rot = {x = 0, y = 0, z = -75.0} },
        })
    elseif selectedOption == 3 then
        blockArea("Maze Bank", {
            { hash = gameplay.get_hash_key("stt_prop_stunt_tube_fn_05"), x = -81.074, y = -795.246, z = 56.227, rot = {x = 0, y = 90, z = 0} },
        })
    elseif selectedOption == 4 then
        blockArea("Eclipse Towers", {
            { hash = gameplay.get_hash_key("stt_prop_stunt_tube_fn_05"), x = -777.094, y = 310.964, z = 97.698, rot = {x = 0, y = 90, z = 0} },
        })
    elseif selectedOption == 5 then
        blockArea("Military Base Hangers", {
            { hash = gameplay.get_hash_key("stt_prop_stunt_tube_fn_05"), x = -2023.520, y = 3158.270, z = 44.810, rot = {x = 0, y = 90, z = 0} },
            { hash = gameplay.get_hash_key("stt_prop_stunt_tube_fn_05"), x = -1921.740, y = 3131.740, z = 44.809, rot = {x = 0, y = 90, z = 0} },
            { hash = gameplay.get_hash_key("stt_prop_stunt_tube_fn_05"), x = -1877.739, y = 3107.727, z = 44.818, rot = {x = 0, y = 90, z = 0} },
        })
    elseif selectedOption == 6 then
        blockArea("LSIA", {
            { hash = gameplay.get_hash_key("stt_prop_stunt_tube_fn_05"), x = -980.665, y = -2828.060, z = 26.856, rot = {x = 0, y = 90, z = 0} },
            { hash = gameplay.get_hash_key("stt_prop_stunt_tube_fn_05"), x = -1143.019, y = -2722.906, z = 25.955, rot = {x = 0, y = 90, z = 0} },
        })
    elseif selectedOption == 7 then
        blockArea("Orbital Cannon Facility", {
            { hash = gameplay.get_hash_key("stt_prop_stunt_tube_fn_05"), x = 1864.194, y = 267.082, z = 175.791, rot = {x = 0, y = 90, z = 0} },
        })
    elseif selectedOption == 8 then
        blockArea("Bunker", {
            { hash = gameplay.get_hash_key("stt_prop_stunt_tube_fn_05"), x = 1572.405, y = 2225.186, z = 92.431, rot = {x = 0, y = 90, z = 0} },
        })
    elseif selectedOption == 9 then
        blockArea("Club House", {
            { hash = gameplay.get_hash_key("stt_prop_stunt_tube_fn_05"), x = -20.144, y = -194.276, z = 64.367, rot = {x = 0, y = 90, z = 0} },
        })
    elseif selectedOption == 10 then
        blockArea("Night Club", {
            { hash = gameplay.get_hash_key("stt_prop_stunt_tube_fn_05"), x = 5.067, y = 219.137, z = 119.586, rot = {x = 0, y = 90, z = 0} },
        })
    elseif selectedOption == 11 then
            -- Toggle block/unblock for Strip Club
            blockArea("StripClub", {
                { hash = 0x8250B39, x = 128.761, y = -1298.156, z = 28.609, rot = {x = 0, y = 0, z = 0} },
                
            })
    elseif selectedOption == 12 then
            -- Toggle block/unblock for Airport
            blockArea("Airport", {
                { hash = 0xdd9a1802, x = -1124.250, y = -2705.705, z = 12.952, rot = {x = 0, y = 0, z = -30.0} },
                { hash = 0xdd9a1802, x = -1130.550, y = -2701.750, z = 12.952, rot = {x = 0, y = 0, z = -30.0} },
                { hash = 0xdd9a1802, x = -1140.0, y = -2696.250, z = 12.803, rot = {x = 0, y = 0, z = -30.0} },
                { hash = 0xdd9a1802, x = -1135.0, y = -2699.250, z = 12.810, rot = {x = 0, y = 0, z = -30.0} },
                { hash = 0xdd9a1802, x = -962.0, y = -22775.250, z = 14.810, rot = {x = 0, y = 0, z = -30.0} },
                { hash = 0xdd9a1802, x = -963.994, y = -2791.250, z = 12.629, rot = {x = 0, y = 0, z = -30.0} },
                { hash = 0xdd9a1802, x = -957.5, y = -2795.250, z = 12.891, rot = {x = 0, y = 0, z = -30.0} },
                { hash = 0xdd9a1802, x = -963.0, y = -2775.250, z = 12.891, rot = {x = 0, y = 0, z = -30.0} },
            })
        elseif selectedOption == 13 then
                local objects = constructObjectsArray_ApartmentInteriors()
                blockArea("Apartment Interiors", objects)
    
        elseif selectedOption == 14 then
            blockArea("Impound Lots", {
                { hash = gameplay.get_hash_key("stt_prop_stunt_tube_fn_05"), x = -222.197, y = -1185.850, z = 23.02, rot = {x = 0, y = 90, z = 0} },
                { hash = gameplay.get_hash_key("stt_prop_stunt_tube_fn_05"), x = 391.47, y = -1637.97, z = 29.31, rot = {x = 0, y = 90, z = 0} },
            })
            end
end)

-- Set the string data for the feature options
blockAreasFeature:set_str_data({
"Maze Bank Garage Block", "Casino Entrance Block", "Maze Bank Block", "Eclipse Towers Block", "Military Base Hangers Block", "LSIA Block", "Orbital Cannon Facility Block", "Bunker Block", 
"Club House Block", "Night Club Block", "Strip Club Block", "Airport Entrance Block", "Apartment Interiors Block", "Impound Lots Block"
})


-- Example usage
-- blockArea("SomeAreaName", {
--     { hash = ObjectHash, x = XCoord, y = YCoord, z = ZCoord, rot = {x = RotX, y = RotY, z = RotZ} },
-- })

-- Menu feature to disable session chat with options for everyone or team only
local session_chat = menu.add_feature("Disable Session Chat", "value_str", Session.id, function(feat)
    local selectedOption = feat.value + 1 -- Adjust based on the option selected
    
    if feat.on then
        -- Ensure any existing thread is stopped before starting a new one
        if sessionChatThread then
            menu.delete_thread(sessionChatThread)
        end
        
        -- Start a new thread for the selected chat disabling method
        sessionChatThread = menu.create_thread(function()
            disableSessionChatMethod(selectedOption)
        end, nil)
    else
        -- Stop the thread if the feature is turned off
        if sessionChatThread then
            menu.delete_thread(sessionChatThread)
            sessionChatThread = nil
        end
    end
end)

-- Set the string data for the feature options
session_chat:set_str_data({"Everyone", "Team Only"})


menu.add_feature("Remove Everyones Weapon Attachments", "action", Session.id, function(feat)
    local allWeapons = weapon.get_all_weapon_hashes()
    for pid = 0, 31 do
        local threadid = menu.create_thread(function()
            if player.is_player_valid(pid) and not player.player_id() then
                local playerPed = player.get_player_ped(pid)
                weapon.remove_all_ped_weapons(playerPed)
                    for _, weaponHash in ipairs(allWeapons) do
                        weapon.give_delayed_weapon_to_ped(playerPed, weaponHash, 0, false)
                        system.yield(0) -- Yielding for each weapon given to manage performance
                    end
            end
        end)
        if menu.has_thread_finished(threadid) then
            menu.delete_thread(threadid)
        end
    end
end)

riot_mode_session = menu.add_feature("Set Riot Mode", "action_value_str", Session.id, function(feat)
selectedOption = feat.value + 1
if selectedOption == 1 then
    native.call(0x2587A48BC88DFADF, true)
elseif selectedOption == 2 then
    native.call(0x2587A48BC88DFADF, false)
    clearallpedtasksnonplayer()
end
end)

riot_mode_session:set_str_data({"Enable", "Disable"})

-- thanks to @gee_man521 for implementing the function and helping improve the ocde.
local removeall = menu.add_feature("Remove All:", "action_value_str", Session.id, function(feat)
    local selectedOption = feat.value + 1 -- because of lua's 1-indexing
    local myId = player.player_id()
    local allTheThings = {}
    local exceptTheseThings = {
    [player.get_player_ped(myId)] = true,
    [player.get_player_vehicle(myId)] = true -- includes the vehicle you exited
    }
    -- Remove All Objects
    if selectedOption == 1 then
        allTheThings = object.get_all_objects()
    -- Remove All Vehicles
    elseif selectedOption == 2 then
        allTheThings = vehicle.get_all_vehicles()
    -- Remove All Peds
    elseif selectedOption == 3 then
        allTheThings = ped.get_all_peds()
    -- Remove All Pickups
    elseif selectedOption == 4 then
        allTheThings = object.get_all_pickups()
    -- Remove All Entities
    elseif selectedOption == 5 then
        for _, entityArray in ipairs({object.get_all_objects(), vehicle.get_all_vehicles(), ped.get_all_peds(), object.get_all_pickups()}) do
            for _, ent in ipairs(entityArray) do
                table.insert(allTheThings, ent)
            end
        end
    end
    for i = 1, #allTheThings do
        local ent = allTheThings[i]
        if not exceptTheseThings[ent] then
            local threadid = menu.create_thread(function()
                if getControl2(ent) then
                    entity.set_entity_as_no_longer_needed(ent)
                    entity.delete_entity(ent)
                end
            end)
            if menu.has_thread_finished(threadid) then
                menu.delete_thread(threadid)
            end
        end
    end
end)
removeall:set_str_data({"objects", "vehicles", "peds", "pickups", "all"})


local time_scale = menu.add_feature("Set Slow Mo: ", "action_value_str", Session.id, function(feat)
    local selectedOption = feat.value + 1
    if selectedOption == 1 then
        native.call(0x1D408577D440E81E, 0)
    elseif selectedOption == 2 then
        native.call(0x1D408577D440E81E, 0.2)
    elseif selectedOption == 3 then
        native.call(0x1D408577D440E81E, 0.4)
    elseif selectedOption == 4 then
        native.call(0x1D408577D440E81E, 0.6)
    elseif selectedOption == 5 then
        native.call(0x1D408577D440E81E, 0.8)
    elseif selectedOption == 6 then
        -- I don't know why it won't accept 1 has a value, but this works good enough for now.
        native.call(0x1D408577D440E81E, 0.99)
    end
end)

time_scale:set_str_data({"slowest", "20%", "40%", "60%", "80%", "normal"})

local mark_players = menu.add_feature("Mark all players", "action_value_str", Session.id, function(feat)
    local selectedOption = feat.value + 1
    if selectedOption == 1 then
        menu.create_thread(markAllPlayersAsModders, {})
    elseif selectedOption == 2 then
        menu.create_thread(unmarkAllPlayersAsModders, {})
    end
end)

mark_players:set_str_data({"As modders", "As non-modders"})

-- There is probably a better way to do this, but this is the best I could come up with. God i hate inputs in the 2t1 api so much.
local test_feature = menu.add_feature("World: ", "action_value_str", world_features.id, function(feat)
    local selectedOption = feat.value + 1
    if selectedOption == 1 then
        local responseCode, wave_input = -1, ""
        while responseCode ~= eInputResponse.IR_SUCCESS and responseCode ~= eInputResponse.IR_FAILED do
            responseCode, wave_input = input.get("Enter height value", "", 10, eInputType.IT_NUM)
            system.wait(0) -- Prevent freezing, let the game process other events
        end

        if responseCode == eInputResponse.IR_SUCCESS then
            water.set_waves_intensity(tonumber(wave_input))
            menu.notify("Wave Height Set: " .. wave_input, "Novo Script", 5)
        elseif responseCode == eInputResponse.IR_FAILED then
            menu.notify("Wave input canceled.", "Novo Script", 5)
        end
    elseif selectedOption == 2 then
        water.reset_waves_intensity()
    elseif selectedOption == 3 then
        local responseCode, wave_input = -1, ""
        while responseCode ~= eInputResponse.IR_SUCCESS and responseCode ~= eInputResponse.IR_FAILED do
            responseCode, wave_input = input.get("Enter Rain value", "", 10, eInputType.IT_NUM)
            system.wait(0) -- Prevent freezing, let the game process other events
        end

        if responseCode == eInputResponse.IR_SUCCESS then
            native.call(0x643E26EA6E024D92, tonumber(wave_input))
            menu.notify("Rain Level Set: " .. wave_input, "Novo Script", 5)
        elseif responseCode == eInputResponse.IR_FAILED then
            menu.notify("Rain input canceled.", "Novo Script", 5)
        end
    elseif selectedOption == 4 then
        local responseCode, wave_input = -1, ""
        while responseCode ~= eInputResponse.IR_SUCCESS and responseCode ~= eInputResponse.IR_FAILED do
            responseCode, wave_input = input.get("Enter Snow value", "", 10, eInputType.IT_NUM)
            system.wait(0) -- Prevent freezing, let the game process other events
        end

        if responseCode == eInputResponse.IR_SUCCESS then
            native.call(0x7F06937B0CDCBC1A, tonumber(wave_input))
            menu.notify("Snow Level Set: " .. wave_input, "Novo Script", 5)
        elseif responseCode == eInputResponse.IR_FAILED then
            menu.notify("Snow input canceled.", "Novo Script", 5)
        end
    elseif selectedOption == 5 then
        local responseCode, wave_input = -1, ""
        while responseCode ~= eInputResponse.IR_SUCCESS and responseCode ~= eInputResponse.IR_FAILED do
            responseCode, wave_input = input.get("Enter Cloud Alpha value", "", 10, eInputType.IT_NUM)
            system.wait(0) -- Prevent freezing, let the game process other events
        end

        if responseCode == eInputResponse.IR_SUCCESS then
            native.call(0xF36199225D6D8C86, tonumber(wave_input))
            menu.notify("Cloud Alpha Set: " .. wave_input, "Novo Script", 5)
        elseif responseCode == eInputResponse.IR_FAILED then
            menu.notify("Cloud Alpha input canceled.", "Novo Script", 5)
        end
    elseif selectedOption == 6 then
        local responseCode, wave_input = -1, ""
        while responseCode ~= eInputResponse.IR_SUCCESS and responseCode ~= eInputResponse.IR_FAILED do
            responseCode, wave_input = input.get("Enter Wind Speed value", "", 10, eInputType.IT_NUM)
            system.wait(0) -- Prevent freezing, let the game process other events
        end

        if responseCode == eInputResponse.IR_SUCCESS then
            native.call(0xEE09ECEDBABE47FC, tonumber(wave_input))
            menu.notify("Wind Speed Set: " .. wave_input, "Novo Script", 5)
        elseif responseCode == eInputResponse.IR_FAILED then
            menu.notify("Wind Speed input canceled.", "Novo Script", 5)
        end
    elseif selectedOption == 7 then
        local responseCode, wave_input = -1, ""
        while responseCode ~= eInputResponse.IR_SUCCESS and responseCode ~= eInputResponse.IR_FAILED do
            responseCode, wave_input = input.get("Enter Gravity Level value", "", 10, eInputType.IT_NUM)
            system.wait(0) -- Prevent freezing, let the game process other events
        end

        if responseCode == eInputResponse.IR_SUCCESS then
            native.call(0x740E14FAD5842351, tonumber(wave_input))
            menu.notify("Gravity Level Set: " .. wave_input, "Novo Script", 5)
        elseif responseCode == eInputResponse.IR_FAILED then
            menu.notify("Gravity Level input canceled.", "Novo Script", 5)
        end
    elseif selectedOption == 8 then
        native.call(0x957E790EA1727B64)
        menu.notify("Cleared All Cloud Hats", "Novo Script", 5)
    end
end)

test_feature:set_str_data({"set wave height", "reset wave height", "set rain level", "set snow level", "set cloud alpha", "set wind speed", "set gravity level", "Unload Cloud Hats"})

local world_weather = menu.add_feature("Set weather: ", "action_value_str", world_features.id, function(feat)
    local weatherTypes = {
        "CLEAR", "EXTRASUNNY", "CLOUDS", "OVERCAST", "RAIN", "CLEARING", "THUNDER",
        "SMOG", "FOGGY", "XMAS", "SNOW", "SNOWLIGHT", "BLIZZARD", "HALLOWEEN", "NEUTRAL"
    }
    local selectedWeather = weatherTypes[feat.value + 1]

    -- Set the weather
    native.call(0x29B487C359E19889, selectedWeather)
    native.call(0xED712CA327900C8A, selectedWeather)
    menu.notify("Weather set to " .. selectedWeather, "Weather Features", 5)
end)

world_weather:set_str_data({
    "CLEAR", "EXTRASUNNY", "CLOUDS", "OVERCAST", "RAIN", "CLEARING", "THUNDER",
    "SMOG", "FOGGY", "XMAS", "SNOW", "SNOWLIGHT", "BLIZZARD", "HALLOWEEN", "NEUTRAL"
})



-- 
-- local responseCode, healthInput = -1, ""
-- while responseCode ~= eInputResponse.IR_SUCCESS and responseCode ~= eInputResponse.IR_FAILED do
--     responseCode, healthInput = input.get("Enter health value", "", 10, eInputType.IT_NUM)
--     system.yield(0) -- Adjust yield time as needed to prevent blocking
-- end
-- 
-- if responseCode == eInputResponse.IR_SUCCESS then
--     local healthValue = tonumber(healthInput)


--[[

	void splitthesea() {
			Vector3 Coords = ENTITY::GetEntityCoords(GetLocalPlayer().m_ped, true);
			WATER::ModifyWater(Coords.x, Coords.y, -10, 10);
			WATER::ModifyWater(Coords.x + 2, Coords.y, -10, 10);
			WATER::ModifyWater(Coords.x, Coords.y + 2, -10, 10);
			WATER::ModifyWater(Coords.x + 2, Coords.y + 2, -10, 10);
			WATER::ModifyWater(Coords.x + 4, Coords.y, -10, 10);
			WATER::ModifyWater(Coords.x, Coords.y + 4, -10, 10);
			WATER::ModifyWater(Coords.x + 4, Coords.y + 4, -10, 10);
			WATER::ModifyWater(Coords.x + 6, Coords.y, -10, 10);
			WATER::ModifyWater(Coords.x, Coords.y + 6, -10, 10);
			WATER::ModifyWater(Coords.x + 6, Coords.y + 6, -10, 10);
			WATER::ModifyWater(Coords.x + 8, Coords.y, -10, 10);
			WATER::ModifyWater(Coords.x, Coords.y + 8, -10, 10);
			WATER::ModifyWater(Coords.x + 8, Coords.y + 8, -10, 10);
	}

}
]]

--void MODIFY_WATER(float x, float y, float radius, float height) // 0xC443FD757C3BA637 0xC49E005A b323
-- should probably improve th code and make it more readable and stuffs but i'll do that later.
split_the_sea = menu.add_feature("Split The Sea", "toggle", world_features.id, function(feat)
    while feat.on do
    local coords = player.get_player_coords(player.player_id())
--native.call(0xC443FD757C3BA637, coords.x + 5, coords.y + 5, 5, 0)
    native.call(0xC443FD757C3BA637, coords.x, coords.y, -10, 10)
    native.call(0xC443FD757C3BA637, coords.x + 2, coords.y, -10, 10)
    native.call(0xC443FD757C3BA637, coords.x, coords.y + 2, -10, 10)
    native.call(0xC443FD757C3BA637, coords.x + 2, coords.y + 2, -10, 10)
    native.call(0xC443FD757C3BA637, coords.x + 4, coords.y, -10, 10)
    native.call(0xC443FD757C3BA637, coords.x, coords.y + 4, -10, 10)
    native.call(0xC443FD757C3BA637, coords.x + 4, coords.y + 4, -10, 10)
    native.call(0xC443FD757C3BA637, coords.x + 6, coords.y, -10, 10)
    native.call(0xC443FD757C3BA637, coords.x, coords.y + 6, -10, 10)
    native.call(0xC443FD757C3BA637, coords.x + 6, coords.y + 6, -10, 10)
    native.call(0xC443FD757C3BA637, coords.x + 8, coords.y, -10, 10)
    native.call(0xC443FD757C3BA637, coords.x, coords.y + 8, -10, 10)
    native.call(0xC443FD757C3BA637, coords.x + 8, coords.y + 8, -10, 10)
system.yield(1)
    end
end)

local climbingThread = nil -- Initialize the climbingThread variable outside the feature function

climbing_options = menu.add_feature("Make Climbing:", "value_str", Session.id, function(feat)
    if feat.on then
        if not climbingThread then
            climbingThread = menu.create_thread(function()
                while feat.on do
                    local selectedoption = feat.value + 1 -- Dynamically check feat.value inside the thread
                    local all_objs = object.get_all_objects()
                    for _, obj in ipairs(all_objs) do
                        if not network.has_control_of_entity(obj) then
                            network.request_control_of_entity(obj)
                        end
                        if selectedoption == 1 then
                            -- Option 1: Make All Objects Solid
                            native.call(0x4D89D607CB3DD1D2, obj, true)
                            native.call(0xA80AE305E0A3044F, obj, true)
                        elseif selectedoption == 2 then
                            -- Option 2: Make No Objects Solid
                            native.call(0x4D89D607CB3DD1D2, obj, false)
                            native.call(0xA80AE305E0A3044F, obj, false)
                        end
                    end
                    system.yield(0) -- Prevent freezing
                end
            end)
        end
    else
        if climbingThread then
            menu.delete_thread(climbingThread)
            climbingThread = nil -- Reset the variable when the feature is turned off
        end
    end
end)

climbing_options:set_str_data({
    "Eaiser",
    "Harder"
})

spawned_train = nil

menu.add_feature("Spawn Train", "action", train_features.id, function(feat)
    local train_models = {
        0x3D6AAA9B,
        0x0AFD22A6,
        0x264D9262,
        0x36DCFF98,
        0x0E512E79,
        0xD1ABB666
    }
    
    for _, model in ipairs(train_models) do
        streaming.request_model(model)
        
        while not streaming.has_model_loaded(model) do
            system.yield(0)
        end
    end
    
    local coords = entity.get_entity_coords(player.get_player_ped(player.player_id()))
    local veh = native.call(0x63C6CCA8E68AE8C8, 15, coords.x, coords.y, coords.z, true, 0, 0)
    spawned_train = veh:__tointeger()
end)

enter_train = menu.add_feature("Train:", "action_value_str", train_features.id, function(feat)
local selectedOption = feat.value + 1  -- Increment by 1 due to 0-indexing
if selectedOption == 1 then
    local train = spawned_train
    ped.set_ped_into_vehicle(player.get_player_ped(player.player_id()), spawned_train, -1)
elseif selectedOption == 2 then
ped.clear_ped_tasks_immediately(player.get_player_ped(player.player_id()))
elseif selectedOption == 3 then
    entity.delete_entity(spawned_train)
end
end)

enter_train:set_str_data({
    "Enter Train",
    "Exit Train",
    "Delete Train"
})

menu.add_feature("Derail Train", "action", train_features.id, function(feat)
    local coords = entity.get_entity_coords(spawned_train)
    
    vehicle.set_vehicle_undriveable(spawned_train, true)
    vehicle.set_vehicle_engine_health(spawned_train, 0)
    native.call(0x70DB57649FA8D0D8, spawned_train, 0)
    native.call(0xE3AD2BDBAEE269AC, coords.x, coords.y, coords.z, 29, 9999, true, false, false, 1)
    native.call(0x317B11A312DF5534, spawned_train, true)
    native.call(0x730F5F8D3F0F2050, spawned_train, true)
    native.call(0x16469284DB8C62B5, spawned_train, 0)
    native.call(0xAA0BC91BE0B796E3, spawned_train, 0)
    entity.set_entity_coords_no_offset(spawned_train, v3(coords.x, coords.y, coords.z + 1))
end)

menu.add_feature("Glitch Train", "action", train_features.id, function(feat)
local train_speed_native = native.call(0xD5037BA82E12416F, spawned_train)
local train_speed = train_speed_native:__tointeger()
TrainSpeed_new = train_speed + 200.0
native.call(0x16469284DB8C62B5, spawned_train, TrainSpeed_new)
native.call(0xAA0BC91BE0B796E3, spawned_train, TrainSpeed_new)
end)