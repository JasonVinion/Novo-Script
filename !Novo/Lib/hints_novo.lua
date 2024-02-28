-- this is needed as features will not be fully loaded and will be nil, so we need to wait a bit before we can load the hints.
-- this is a coroutine so it will not block the main thread, and because it does not attempt to yield from outside a coroutine, it will not error.
function loadhints()
--    coroutine.wrap(function()
--        system.wait(100)
        blockAreasFeature.hint = "Press once to block\nPress twice to unblock"
        Force_Delete_entity.hint = "can sometimes delete entities that are not controlled by you / are modder controlled"
        custom_entity_spawn_car.hint = "Spawn any vehicle that can be driven like a car"
        custom_entity_spawn.hint = "Spawn any object that can be driven like a car"
        boat_car.hint = "Spawn a boat that can be driven like a car"
        heli_car.hint = "Spawn a helicopter that can be driven like a car"
        plane_car.hint = "Spawn a plane that can be driven like a car"
        train_car.hint = "Spawn a train that can be driven like a car"
        trailer_car.hint = "Spawn a trailer that can be driven like a car"
        set_me_vis_feature.hint = "Should not be needed, but here just in case"
        cage_player.hint = "V1-3 use world objects \nV4-6 use normal objects \nV5 works against most modders, V1 works against most of the rest"
        JOB_SE.hint = "Sends invaild job share script event"
        blame_prot_v1.hint = "stops you from killing or shooting at other players\nstops modders from killing people while saying it was you"
        blame_prot_v2.hint = "temporarily disables protections when aiming at a player\nstops modders from killing people while saying it was you"
        casino_card_drop.hint = "Players can only get 54 cards per session"
        riot_mode_session.hint = "All NPCs are are hostile to each other and players\nAll NPCs are given random weapons"
        reset_sell_timer.hint = "Allows you to reset the timer which stops you fro doing certian things."
        split_the_sea.hint = "Splits the sea like moses\nallows you to walk on sea floor with no water there"
        Corrupted_Model_Crash.hint = "Overwhelms the game with invaild props"
        dev_logo_on_outfit.hint = "Adds the rockstar logo to your outfit\nNormally a Dev only feature!"
        invaild_weapon_ped_crash.hint = "this may take a second to send, be patient"
        climbing_options.hint = "Eaiser - allows climbing on most objects\nHarder - allows climbing on very few objects\nalso works for players around you"
        drag_out_protection.hint = "Stops you from being dragged out of your vehicle\ncan block kick from vehicles"
        Menu_Instability.hint = "Causes some menus to become very unstable"
        better_menu_crash_features.hint = "teleport to player before using\nmay have to press twice if you don't see a notification"
        walk_under_water.hint = "Allows you to walk under water\nre-enable if it breaks"
        drive_through_things.hint = "Allows you to drive through most objects, walls, vehicles, peds, etc"
        set_veh_speed.hint = "Warning if max speed is 0, you can not change it again"
        break_veh_phy.hint = "V1 - requires a free seat in vehicle\nV2 - attaches a broken physics object \nV3 - unrenders vehicle after a short time"
        player_silent.hint = "disables player sounds\nmakes stealth much easier"
        toggle_fire.hint = "if used in quick succession, it may take up to 7 seconds to load"
        fly_up_feature.hint = "Works both on foot and in vehicle!"
end

--Anything commented out has to be added when the feature is loaded because this feature has no polish and loves to throw errors every 2 seconds. 
--Please sub1to fix this feature, it is very annoying to work with.

-- this hints feature is very not polished so we have to use this hacky way to make it work.
load_hint_feature = menu.add_feature("Load Hints", "action", 0, function()
    system.wait(100)
    loadhints()
end)
load_hint_feature.hidden = true
load_hint_feature.on = true




