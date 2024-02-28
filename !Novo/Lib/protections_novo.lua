-- protection_events

-- Yes, this is the code from when impulse was failing to make blame protection work, and it took them 3 updates and 1 post to unknowncheats to figure it out.
--[[
	if (vars.blame) {
		if (NETWORK::NetworkIsSessionActive()) {
			//OnlinePlayerCallback(false, [](SPlayer player) {
			//PED::SetCanAttackFriendly(GetLocalPlayer().m_ped, true, true);
			//PED::SetCanAttackFriendly(GetLocalPlayer().m_id, true, true);
			//PED::SetCanAttackFriendly(player.m_ped, true, true);
			//PED::SetCanAttackFriendly(player.m_id, true, true);
			//NETWORK::NetworkSetFriendlyFireOption(true);
			//});
		}
	}
]]

local blameProtectionThreadId = nil -- Variable to hold the thread identifier

blame_prot_v1 = menu.add_feature("blame protection", "toggle", protection_events.id, function(feat)
    local function blameProtectionThread()
        while feat.on do
            native.call(0xB3B1CB349FF9C75D, player.get_player_ped(player.player_id()), false, false)
            native.call(0xF808475FA571D823, false)
            system.yield(5) -- Add a slight delay to prevent the loop from running too fast
        end
        -- When the feature is turned off, reset to the default state
        native.call(0xB3B1CB349FF9C75D, player.get_player_ped(player.player_id()), false, true)
        native.call(0xF808475FA571D823, true)
    end

    if feat.on then
        -- Only create the thread if it doesn't already exist
        if blameProtectionThreadId == nil then
            blameProtectionThreadId = menu.create_thread(blameProtectionThread, {})
        end
    else
        -- Delete the thread if it exists when the feature is turned off
        if blameProtectionThreadId ~= nil then
            menu.delete_thread(blameProtectionThreadId)
            blameProtectionThreadId = nil
        end
    end
end)

local blameProtectionV2ThreadId = nil -- Variable to hold the thread identifier

blame_prot_v2 = menu.add_feature("blame protection V2", "toggle", protection_events.id, function(feat)
    local function blameProtectionV2Thread()
        while feat.on do
            local isAimingAtEntity = false
            local myPlayerId = player.player_id()
            local myPed = player.get_player_ped(myPlayerId)
            local entityAimedAt = player.get_entity_player_is_aiming_at(myPlayerId)

            if entityAimedAt then
                -- Check if the entity is a player's ped
                for pid = 0, 31 do -- Check all possible player IDs
                    if pid ~= myPlayerId then -- Exclude the player themselves
                        local otherPed = player.get_player_ped(pid)
                        if entityAimedAt == otherPed and otherPed ~= 0 then
                            isAimingAtEntity = true
                            break -- Exit the loop early if aiming at any player
                        end
                    end
                end
            else
                -- entityAimedAt is nil, meaning not aiming at anything
                isAimingAtEntity = false
            end

            if not isAimingAtEntity then
                -- Enable protections when not aiming at any player or not aiming at anything
                native.call(0xB3B1CB349FF9C75D, myPed, false, false)
                native.call(0xF808475FA571D823, false)
            else
                -- Disable protections when aiming at a player
                native.call(0xB3B1CB349FF9C75D, myPed, false, true)
                native.call(0xF808475FA571D823, true)
            end

            system.wait(100) -- Adjust the delay as needed
        end
    end

    if feat.on then
        -- Only create the thread if it doesn't already exist
        if blameProtectionV2ThreadId == nil then
            blameProtectionV2ThreadId = menu.create_thread(blameProtectionV2Thread, {})
        end
    else
        -- Delete the thread if it exists when the feature is turned off
        if blameProtectionV2ThreadId ~= nil then
            menu.delete_thread(blameProtectionV2ThreadId)
            blameProtectionV2ThreadId = nil
        end
    end
end)

-- Define a variable to hold the thread identifier outside the feature definition
local RemovetransactionthreadId = nil

menu.add_feature("Remove transaction error", "toggle", protection_events.id, function(feat)
    -- Function to run inside the thread

    if feat.on then
        -- Only create the thread if it's not already running
        if RemovetransactionthreadId == nil then
            RemovetransactionthreadId = menu.create_thread(RemovetransactionthreadFunction, {})
        end
        system.yield(0) -- Prevent the thread from hogging CPU cycles
    else
        -- Delete the thread if the feature is turned off and the thread exists
        if RemovetransactionthreadId ~= nil then
            menu.delete_thread(RemovetransactionthreadId)
            RemovetransactionthreadId = nil -- Reset the threadId to ensure it can be started again later
        end
    end
end)

-- make a new menu feature
drag_out = false
dragThread = nil
drag_out_protection = menu.add_feature("Drag out protection", "toggle", protection_events.id, function(feat)
     -- Declare the thread variable outside the loop

    if feat.on then
        if not dragThread then
            dragThread = menu.create_thread(function()
                while feat.on do
                    if drag_out == false then
                        local playerPed = player.get_player_ped(player.player_id())
                        native.call(0xC1670E958EEE24E5, playerPed, false)
                        drag_out = true
                        system.yield(0)
                    end
                    system.yield(0)
                end
            end)
        end
    else
        drag_out = false
        native.call(0xC1670E958EEE24E5, playerPed, true)
        if dragThread then
            menu.delete_thread(dragThread)
            dragThread = nil
        end
    end
end)