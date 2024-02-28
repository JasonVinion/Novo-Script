-- do not set to true, this is for testing purposes and will result in instability and broken features.
Novo_running_in_dev_mode = false

-- Define file paths
mainpath = utils.get_appdata_path("PopstarDevs", "2Take1Menu")
blacklistPath = mainpath .. "\\scripts\\!Novo\\blacklist.txt"
attach_obj_path = mainpath .. "\\scripts\\!Novo\\attachments.txt"
attach_peds_path = mainpath .. "\\scripts\\!Novo\\attach_peds.txt"
attach_veh_path = mainpath .. "\\scripts\\!Novo\\attach_veh.txt"
ptfx_path = mainpath .. "\\scripts\\!Novo\\ptfx.txt"
sound_data_path = mainpath .. "\\scripts\\!Novo\\sounds.txt"
veh_names_path = mainpath .. "\\scripts\\!Novo\\veh_names.txt"
pickups_path = mainpath .. "\\scripts\\!Novo\\pickup.txt"
debug_log_path = mainpath .. "\\scripts\\!Novo\\debug.txt"

UpdateCheckThread = nil

function performUpdateCheck()
    local mainpath = utils.get_appdata_path("PopstarDevs", "2Take1Menu")
    local localVersionPath = mainpath .. "\\scripts\\!Novo\\Version.txt"
    local mainluaPath = mainpath .. "\\scripts\\!NovoScript.lua"
    local veh_names_path = mainpath .. "\\scripts\\!Novo\\veh_names.txt"
    local pickups_path = mainpath .. "\\scripts\\!Novo\\pickup.txt"
    local debug_log_path = mainpath .. "\\scripts\\!Novo\\debug.txt"
    local attach_obj_path = mainpath .. "\\scripts\\!Novo\\attachments.txt"
    local attach_peds_path = mainpath .. "\\scripts\\!Novo\\attach_peds.txt"
    local attach_veh_path = mainpath .. "\\scripts\\!Novo\\attach_veh.txt"
    local ptfx_path = mainpath .. "\\scripts\\!Novo\\ptfx.txt"
    local sound_data_path = mainpath .. "\\scripts\\!Novo\\sounds.txt"
    local blacklistPath = mainpath .. "\\scripts\\!Novo\\blacklist.txt"
    local arrayPath = mainpath .. "\\scripts\\!Novo\\Lib\\array_novo.lua"
    local funcPath = mainpath .. "\\scripts\\!Novo\\Lib\\func_novo.lua"
    local veh_optionsPath = mainpath .. "\\scripts\\!Novo\\Lib\\veh_options_novo.lua"
    local trollingPath = mainpath .. "\\scripts\\!Novo\\Lib\\trolling_novo.lua"
    local GriefingPath = mainpath .. "\\scripts\\!Novo\\Lib\\Griefing_novo.lua"
    local attackersPath = mainpath .. "\\scripts\\!Novo\\Lib\\attackers_novo.lua"
    local rockstar_eventsPath = mainpath .. "\\scripts\\!Novo\\Lib\\rockstar_events_novo.lua"
    local healthPath = mainpath .. "\\scripts\\!Novo\\Lib\\health_novo.lua"
    local sessionPath = mainpath .. "\\scripts\\!Novo\\Lib\\session_novo.lua"
    local session_vehPath = mainpath .. "\\scripts\\!Novo\\Lib\\session_veh_novo.lua"
    local selfPath = mainpath .. "\\scripts\\!Novo\\Lib\\self_novo.lua"
    local block_vehPath = mainpath .. "\\scripts\\!Novo\\Lib\\block_veh_novo.lua"
    local cagesPath = mainpath .. "\\scripts\\!Novo\\Lib\\cages_novo.lua"
    local trafficPath = mainpath .. "\\scripts\\!Novo\\Lib\\traffic_novo.lua"
    local maliciousPath = mainpath .. "\\scripts\\!Novo\\Lib\\malicious_novo.lua"
    local session_maliciousPath = mainpath .. "\\scripts\\!Novo\\Lib\\session_malicious_novo.lua"
    local Custom_EntitiesPath = mainpath .. "\\scripts\\!Novo\\Lib\\Custom_Entities_novo.lua"
    local friendlyPath = mainpath .. "\\scripts\\!Novo\\Lib\\friendly_novo.lua"
    local protectionsPath = mainpath .. "\\scripts\\!Novo\\Lib\\protections_novo.lua"
    local testingPath = mainpath .. "\\scripts\\!Novo\\Lib\\testing_novo.lua"
    local hintsPath = mainpath .. "\\scripts\\!Novo\\Lib\\hints_novo.lua"

    local remoteVersionUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Version.txt"
    local remoteMainluaUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!NovoScript.lua"
    local remoteVehNamesUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/veh_names.txt"
    local remotePickupsUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/pickup.txt"
    local remoteDebugLogUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/debug.txt"
    local remoteAttachObjUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/attachments.txt"
    local remoteAttachPedsUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/attach_peds.txt"
    local remoteAttachVehUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/attach_veh.txt"
    local remotePtfxUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/ptfx.txt"
    local remoteSoundDataUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/sounds.txt"
    local remoteBlacklistUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/blacklist.txt"
    local remoteArrayUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/array_novo.lua"
    local remoteFuncUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/func_novo.lua"
    local remoteVehOptionsUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/veh_options_novo.lua"
    local remoteTrollingUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/trolling_novo.lua"
    local remoteGriefingUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/Griefing_novo.lua"
    local remoteAttackersUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/attackers_novo.lua"
    local remoteRockstarEventsUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/rockstar_events_novo.lua"
    local remoteHealthUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/health_novo.lua"
    local remoteSessionUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/session_novo.lua"
    local remoteSessionVehUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/session_veh_novo.lua"
    local remoteSelfUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/self_novo.lua"
    local remoteBlockVehUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/block_veh_novo.lua"
    local remoteCagesUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/cages_novo.lua"
    local remoteTrafficUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/traffic_novo.lua"
    local remoteMaliciousUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/malicious_novo.lua"
    local remoteSessionMaliciousUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/session_malicious_novo.lua"
    local remoteCustomEntitiesUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/Custom_Entities_novo.lua"
    local remoteFriendlyUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/friendly_novo.lua"
    local remoteProtectionsUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/protections_novo.lua"
    local remoteTestingUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/testing_novo.lua"
    local remoteHintsUrl = "https://raw.githubusercontent.com/JasonVinion/Novo-Script/main/!Novo/Lib/hints_novo.lua"

    -- Read local version
    local localVersionFile = io.open(localVersionPath, "r")
    if not localVersionFile then
        print("Failed to open local version file")
        menu.notify("Failed to open local version file", "Error", 9, 50)
        return
    end
    local localVersion = localVersionFile:read("*all")
    localVersionFile:close()

    -- Fetch remote version
    local response_code, response_body, response_headers = web.get(remoteVersionUrl)
    if response_code ~= 200 then
        print("Failed to fetch remote version")
        menu.notify("Failed to fetch remote version", "Error", 9, 50)
        return
    end

    -- Compare versions
    if response_body:match("%S") ~= localVersion:match("%S") then  -- using match to ignore whitespace
        print("Update available. Starting update process...")
        menu.notify("Update available. Starting update process...", "Novo script", 9, 50)
        -- open the local files, write the remote file contents to them, then close them

        local fileMappings = {
            [mainluaPath] = remoteMainluaUrl,
            [veh_names_path] = remoteVehNamesUrl,
            [pickups_path] = remotePickupsUrl,
            [debug_log_path] = remoteDebugLogUrl,
            [attach_obj_path] = remoteAttachObjUrl,
            [attach_peds_path] = remoteAttachPedsUrl,
            [attach_veh_path] = remoteAttachVehUrl,
            [ptfx_path] = remotePtfxUrl,
            [sound_data_path] = remoteSoundDataUrl,
            [blacklistPath] = remoteBlacklistUrl,
            [arrayPath] = remoteArrayUrl,
            [funcPath] = remoteFuncUrl,
            [veh_optionsPath] = remoteVehOptionsUrl,
            [trollingPath] = remoteTrollingUrl,
            [GriefingPath] = remoteGriefingUrl,
            [attackersPath] = remoteAttackersUrl,
            [rockstar_eventsPath] = remoteRockstarEventsUrl,
            [healthPath] = remoteHealthUrl,
            [sessionPath] = remoteSessionUrl,
            [session_vehPath] = remoteSessionVehUrl,
            [selfPath] = remoteSelfUrl,
            [block_vehPath] = remoteBlockVehUrl,
            [cagesPath] = remoteCagesUrl,
            [trafficPath] = remoteTrafficUrl,
            [maliciousPath] = remoteMaliciousUrl,
            [session_maliciousPath] = remoteSessionMaliciousUrl,
            [Custom_EntitiesPath] = remoteCustomEntitiesUrl,
            [friendlyPath] = remoteFriendlyUrl,
            [protectionsPath] = remoteProtectionsUrl,
            [testingPath] = remoteTestingUrl,
            [hintsPath] = remoteHintsUrl
        }

        for localPath, remoteUrl in pairs(fileMappings) do
            local file = io.open(localPath, "w")
            file:write(web.get(remoteUrl))
            file:close()
        end

        print("Update complete. Please reload the script.")
        menu.notify("Update complete. Please reload the script.", "Novo script", 9, 50)
        

        -- updateScript(mainpath)  -- Uncomment this when the updateScript function is defined
    else
        print("No updates available.")
        menu.notify("No updates available", "Novo script", 9, 50)
    end
end

function startUpdateCheck()
    if not UpdateCheckThread then
        UpdateCheckThread = menu.create_thread(function()
                performUpdateCheck()  -- Execute the update check
        end, nil)
    end
end

startUpdateCheck()

-- Function to check trusted modes
function check_trusted_modes()
    local required_flags = eTrustedFlags.LUA_TRUST_NATIVES | eTrustedFlags.LUA_TRUST_SCRIPT_VARS | eTrustedFlags.LUA_TRUST_HTTP
    return menu.is_trusted_mode_enabled(required_flags)
end

function Unload_Lib_scripts()
    -- Remove features
    local featuresToDelete = {
        Novoscript.id, Session.id, session_veh.id, Self.id,
        -- rockstar_events.id, -- Commented out because of intergeration with menu features.
        protection_events.id, custom_entities.id, Health.id, Block_veh.id, traffic.id, ses_malicious.id, world_features.id
    }

    for _, featureId in ipairs(featuresToDelete) do
        menu.delete_feature(featureId, true)
    end

    -- Remove player features
    local featuresToDelete = {
        playerscript, cages, drops, veh_options, trolling, attackers, attachments_menu, malicious
    }

    for _, feature in ipairs(featuresToDelete) do
        menu.delete_feature(feature, true)
    end
end

current_loaded_novo = false

function Load_Lib_scripts()
    if not check_trusted_modes() then
        menu.notify("Trusted natives, globals, HTTP are required to run this script.", "Error", 9, 50)
        menu.notify("Exiting script, please reload with trusted mode to continue", "Error", 9, 50)
        return
    end

    if current_loaded_novo then
        Unload_Lib_scripts()
    end
    current_loaded_novo = true

    -- Initialize the main menu features
    Novoscript = menu.add_feature("Novo script", "parent", scripts)
    Session = menu.add_feature("Session", "parent", Novoscript.id)
    session_veh = menu.add_feature("Session Vehicle Options", "parent", Novoscript.id)
    session_my_veh = menu.add_feature("My Vehicle Options", "parent", Novoscript.id)
    session_veh_trolls = menu.add_feature("Session Vehicle Trolls", "parent", session_veh.id)
    Self = menu.add_feature("Self", "parent", Novoscript.id)
    rockstar_events = menu.add_feature("Rockstar Events", "parent", Novoscript.id)
    protection_events = menu.add_feature("protections", "parent", Novoscript.id)
    custom_entities = menu.add_feature("Custom Entities", "parent", Novoscript.id)
    Health = menu.add_feature("Health", "parent", Self.id)
    Block_veh = menu.add_feature("Block Vehicles", "parent", session_veh.id)
    traffic = menu.add_feature("Traffic Options", "parent", session_veh.id)
    ses_malicious = menu.add_feature("Malicious", "parent", Session.id)
    world_features = menu.add_feature("World Features", "parent", Session.id)
    train_features = menu.add_feature("Train Features", "parent", Session.id)
    bodygaurd_features = menu.add_feature("BodyGuard Features", "parent", Novoscript.id)
    test_local_features = menu.add_feature("Testing Features", "parent", Novoscript.id)

    playerscript = menu.add_player_feature("Novo lua", "parent", 0, function(feat, pid) end).id
    cages = menu.add_player_feature("Novo cages", "parent", playerscript).id
    drops = menu.add_player_feature("Novo Drops", "parent", playerscript).id
    veh_options = menu.add_player_feature("Vehicle Options", "parent", playerscript).id
    veh_troll = menu.add_player_feature("Vehicle Trolls", "parent", veh_options).id
    veh_greif = menu.add_player_feature("Vehicle Griefing", "parent", veh_options).id
    veh_misc = menu.add_player_feature("Vehicle Misc", "parent", veh_options).id
    trolling = menu.add_player_feature("Novo Trolls", "parent", playerscript).id
    greifing = menu.add_player_feature("Novo Griefing", "parent", playerscript).id
    attackers = menu.add_player_feature("Attackers menu", "parent", trolling).id
    attachments_menu = menu.add_player_feature("Attachments menu", "parent", greifing).id
    malicious = menu.add_player_feature("Malicious", "parent", playerscript).id
--    test_Player_features = menu.add_player_feature("Testing Features", "parent", playerscript).id

    Novo_reload = menu.add_feature("Reload Novo Dev", "action", Novoscript.id, function(feat)
        Load_Lib_scripts()
        menu.notify("Novo script reloaded", "Novo script", 9, 50)
    end)

    -- This is a really hacky way to do it, but it won't be run normally so doesn't matter. 
Novo_show = menu.add_feature("Show Debug Scripts", "toggle", Novoscript.id, function(feat)
    if feat.on then
        -- Create and start the thread when the feature is activated
        show_debug_scripts_thread = menu.create_thread(function()
            while feat.on do
                better_menu_crash.hidden = false
                better_menu_crash2.hidden = false
                frag_crash.hidden = false
                tp_player_to_me.hidden = false
                system.yield(0) --  prevent the thread from hogging CPU cycles
            end
        end, {})
    else
        if show_debug_scripts_thread then
            menu.delete_thread(show_debug_scripts_thread)
        end
    end
end)

    -- you still can use to all of these with dev mode off, this is just to make it easier to find errors when testing.

    if not Novo_running_in_dev_mode then
        Novo_reload.hidden = true
        Novo_show.hidden = true
        test_local_features.hidden = true
    --    test_Player_features.hidden = true
    else
    --    Novo_reload.hidden = false
    --    test_local_features.hidden = false
    --    test_Player_features.hidden = false
        ui.notify_above_map("Novo Script Developer Mode Activated", "Novo Script", 30)
    end


-- to make a reload i would have to delete all the online features and im too lazy rn, might add it later
-- tried to make a reload using a thread and get_feature_by_hierarchy_key to disable then enable run feature but it didnt work, which is honestly for the best as
-- it would be a massive security risk as it would enable http, mem, native, globals, to be set to enable without the user knowing or having any input. 


    local rootPath = utils.get_appdata_path("PopstarDevs\\2Take1Menu\\scripts\\!Novo\\Lib", "")
    -- Always load func first, then array second, then hints last.
    local scriptNames = {
        "func", "array", "veh_options", "trolling", "Griefing", "attackers", "rockstar_events", "health", "session", "session_veh", "self", "block_veh", "cages", "traffic", "malicious", "session_malicious", 
        "Custom_Entities", "friendly", "protections", "testing", "hints"
        --testing
    }
    
    for _, script in ipairs(scriptNames) do
        local fullPath = rootPath .. "\\" .. script .. "_novo.lua"
        
        if utils.file_exists(fullPath) then
            local load, files_missing = loadfile(fullPath)
            if files_missing then
                local missingFiles = {}
                for _, script in ipairs(scriptNames) do
                    local fullPath = rootPath .. "\\" .. script .. "_novo.lua"
                    if not utils.file_exists(fullPath) then
                        table.insert(missingFiles, script)
                    end
                end

                if #missingFiles > 0 then
                    local missingFilesStr = table.concat(missingFiles, ", ")
                    menu.notify("Missing Lib files: " .. missingFilesStr, "Error", 9, 50)
                end
            else
                load()
            end
        end
    end
end

Load_Lib_scripts()
menu.notify("Novo script loaded\nDev: unitedpenguin1043", "Novo script", 9, 33)

-- Helper function to debug print or notify (toggle based on your preference)
--  local function debugNotify(message)
--      print(message)  -- For console output, if applicable
--      menu.notify(message, "Debug", 9, 50)  -- For in-game notification
--  end
--  
--  -- Function to load a specific script and notify if not found
--  function loadSpecificScript(scriptName)
--      local rootPath = utils.get_appdata_path("PopstarDevs\\2Take1Menu\\scripts\\!Novo\\Lib", "")
--      local fullPath = rootPath .. "\\" .. scriptName .. "_novo.lua"
--      
--      debugNotify("Attempting to load script: " .. scriptName)
--  
--      if utils.file_exists(fullPath) then
--          debugNotify(scriptName .. " exists. Loading...")
--          local loadStatus, loadResult = pcall(loadfile(fullPath))
--          if loadStatus then
--          --    loadResult()  -- Execute the loaded script if successfully loaded
--              debugNotify(scriptName .. " loaded successfully.")
--          else
--              debugNotify("Error loading " .. scriptName .. ": " .. tostring(loadResult))
--          end
--      else
--          debugNotify("Script not found: " .. scriptName)
--      end
--  end
--  
--  -- Example usage of the function for a specific script
--  loadSpecificScript("testing")


Anti_Crash_Cam = v3(-8292.664, -4596.8257, 14358.0)
Out_Of_Bounds = v3(173663.281250, 915722.00, 362299.75)
