CreateThread(function()
    Wait(2000)
    InitTarget(Config.NPC, true, Config.Translate['npc_target'], function()             -- Warehouse NPC
        OpenStorageMain()
    end)

    --[[if Config.Robbery.enabled then 
        InitTarget(Config.RobberyNPC, false, Config.Translate['robbery_target'], function()             -- Robbery NPC      Work in progress...
            OpenRobberyMain()
        end)
    end]]

    if Config.DefaultSettings.parkIn.enabled then 
        InitParkIn(Config.DefaultSettings.parkIn.enterPos)
    end
end)

exports("am_storages:isPlayerInside", isPlayerInside())
