-- Want to expand later to include more entities like custom xml veh or something.

--spawnAndCustomizeEntity
set_me_vis_feature = menu.add_feature("Reset ped visibility", "action", custom_entities.id, function(feat)
    setmenoinvisible()
end)

boat_car = menu.add_feature("Spawn drivable on land boat", "action", custom_entities.id, function(feat)
    spawnAndCustomizeEntity(-1043459709)
    setmenoinvisible()
end)

heli_car = menu.add_feature("Spawn drivable on land Heli", "action", custom_entities.id, function(feat)
    spawnAndCustomizeEntity(1075432268)
    setmenoinvisible()
end)

plane_car = menu.add_feature("Spawn drivable on land plane", "action", custom_entities.id, function(feat)
    spawnAndCustomizeEntity(-1214505995)
    setmenoinvisible()
end)

train_car = menu.add_feature("Spawn drivable on land train", "action", custom_entities.id, function(feat)
    spawnAndCustomizeEntity(1030400667)
    setmenoinvisible()
end)

trailer_car = menu.add_feature("Spawn drivable on land trailer", "action", custom_entities.id, function(feat)
    spawnAndCustomizeEntity(-877478386)
    setmenoinvisible()
end)


local attachVehicles = parseAttachVehFile(attach_veh_path)
local vehicleNames = getVehicleNames(attachVehicles)
local attachObjects = parseAttachmentsFile(attach_obj_path)
local ObjectNames = getAttachmentNames(attachObjects)

custom_entity_spawn_car = menu.add_feature("Spawn drivable on land custom vehicle", "action_value_str", custom_entities.id, function(feat)
    local selectedVehicle = attachVehicles[feat.value + 1] -- Get the selected vehicle based on menu choice
    if selectedVehicle then
        spawnAndCustomizeEntity(selectedVehicle.hash) -- Call spawn and customize function with the hash
        setmenoinvisible()
    else
        menu.notify("Invalid vehicle selection", "Error", 5)
    end
end)
custom_entity_spawn_car:set_str_data(vehicleNames)

custom_entity_spawn = menu.add_feature("Spawn drivable on land custom object", "action_value_str", custom_entities.id, function(feat)
    local selectedObject = attachObjects[feat.value + 1] -- Get the selected vehicle based on menu choice
    if selectedObject then
        spawnAndCustomizeObject(selectedObject.hash) -- Call spawn and customize function with the hash
        setmenoinvisible()
    else
        menu.notify("Invalid vehicle selection", "Error", 5)
    end
end)
custom_entity_spawn:set_str_data(ObjectNames)