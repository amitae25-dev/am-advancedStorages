CreateThread(function()
    Wait(2000)
    for index, item in ipairs(Config.Entrance) do 
        InitBlip(item.blip.showBlip, item.coords, item.blip.model, item.blip.scale, item.blip.color, item.blip.label)
        InitTarget(item.coords, item.model, item.scenario, Config.Translate['npc_target'], index, function()
            OpenStorageMain()
        end)
        if item.parkIn.enabled then 
            InitParkIn(item.parkIn.enterPos)
        end
    end
end)

exports("am_storages:isPlayerInside", isPlayerInside())
