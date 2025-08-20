local inside = false
local npc 
local hasWarehouse = false
local lvl = 1

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(0)
    end
end

-- For exports

function isPlayerInside()
    return inside
end

function playerHasWarehouse()
    return hasWarehouse
end

function warehouseLevel()
    return lvl 
end

-- Code

function InitTarget()
    if Config.Blip.showBlip then 
        local blip = AddBlipForCoord(Config.NPC.coords.x, Config.NPC.coords.y, Config.NPC.coords.z)
        print(json.encode(Config.NPC))
        SetBlipSprite(blip, Config.Blip.blipModel)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Blip.blipScale)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, Config.Blip.blipColor)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('asd')
        EndTextCommandSetBlipName(blip)
    end

    local zone = lib.zones.sphere({
        coords = Config.NPC.coords,
        debug = Config.Debug.zoneDebug,
        radius = 30,
        onEnter = function(self)
            if not self.npc then
                LoadModel(Config.NPC.model)

                npc = CreatePed(4, Config.NPC.model, Config.NPC.coords, false, true)

                FreezeEntityPosition(npc, true)
                SetEntityInvincible(npc, true)
                SetBlockingOfNonTemporaryEvents(npc, true)
                SetEntityHeading(npc, Config.NPC.coords.h)
                PlaceObjectOnGroundProperly(npc)
                if Config.NPC.scenario then 
                    TaskStartScenarioInPlace(npc, Config.NPC.scenario, true, true)
                end

                --- OX TARGET ----

                exports.ox_target:addLocalEntity(npc, {
                    name = 'am_storage_target',
                    icon = 'box-open',
                    label = Config.Translate['npc_target'],
                    distance = 1.5,
                    canInteract = function(entity, distance, coords)
                        return true
                    end,
                    
                    onSelect = function(data)
                        OpenStorageMain()
                    end
                })
            end
        end,
        onExit = function(self)
            if npc then
                DeleteEntity(npc)
                npc = nil
            end
        end
    })
end

function OpenStorageMain()
    lib.callback('am_storages:getPlayerStorage', false, function(result)
        local options = {}
        print(json.encode(result))
        if result and #result > 0 and result[1].id then 
            table.insert(options, {
                title = Config.Translate['enter_storage'],
                description = Config.Translate['enter_storage_desc'],
                icon = 'door-open',
                iconColor = 'teal',
                onSelect = function()
                    EnterWarehouse(result[1])
                end
            })
            hasWarehouse = true
            lvl = result[1].level
        else
            table.insert(options, {
                title = Config.Translate['buy_storage'],
                description = string.format(Config.Translate['buy_storage_desc'], Config.StoragePrice),
                icon = 'money-bill',
                iconColor = 'teal',
                onSelect = function()
                    BuyWarehouse()
                end
            })
        end
        table.insert(options, {
            title = Config.Translate['shared_storages'],
            description = Config.Translate['shared_storages_desc'],
            icon = 'share',
            iconColor = 'blue',
            disabled = true
        })
        lib.registerContext({
            id = 'am_storage_main',
            title = Config.Translate['menu_header'],
            options = options
        })
        lib.showContext('am_storage_main')
    end)
end

function OpenManagementMenu()
    lib.callback('am_storages:getPlayerStorage', false, function(result)
        local options = {}
        if result and #result > 0 and result[1].id then 
            table.insert(options, {
                title = string.format(Config.Translate['current_level'], result[1].level),
                icon = 'info',
                iconColor = 'teal',
            })
            if result[1].level < 10 then 
                table.insert(options, {
                    title = Config.Translate['upgrade_warehouse'],
                    description = string.format(Config.Translate['upgrade_warehouse_desc'], result[1].level + 1, Config.Levels[result[1].level].upgradePrice),
                    icon = 'arrow-up',
                    iconColor = 'green',
                    onSelect = function()
                        UpgradeWarehouse(result[1])
                    end
                })
            end
            table.insert(options, {
                title = Config.Translate['share_warehouse'],
                description = Config.Translate['share_warehouse_desc'],
                icon = 'share',
                iconColor = 'blue',
                disabled = true,
                onSelect = function()
                    -- Share Menu Ui
                end
            })
            table.insert(options, {
                title = Config.Translate['sell_warehouse'],
                description = string.format(Config.Translate['sell_warehouse_desc'], result[1].level, Config.Levels[result[1].level].sellPrice),
                icon = 'money-bill-transfer',
                iconColor = 'red',
                disabled = false,
                onSelect = function()
                    SellWarehouse(result[1])
                end
            })
        end
        lib.registerContext({
            id = 'am_storage_management',
            title = Config.Translate['management_header'],
            options = options
        })
        lib.showContext('am_storage_management')
    end)
end

function BuyWarehouse()
    local moneyAmount = exports.ox_inventory:Search('count', 'money')
    if moneyAmount >= Config.StoragePrice then 
        lib.callback('am_storages:buyPlayerStorage', false, function(id)
            if id == false then 
                Notify(Config.Translate['notify_header'], Config.Translate['error_buy'], 'error')
                print("^2[am_storages]^7 Couldn\'t get player\'s identifier")
            elseif id == nil then 
                Notify(Config.Translate['notify_header'], Config.Translate['error_buy'], 'error')
                print("^2[am_storages]^7 Couldn\'t insert SQL line")
            elseif id > 0 then 
                Notify(Config.Translate['notify_header'], Config.Translate['successful_purchase'], 'success')
                OpenStorageMain()
            end
        end)
    else 
        Notify(Config.Translate['notify_header'], Config.Translate['not_enough_money'], 'error')
    end
end

function EnterWarehouse(data)
    local storages
    DoScreenFadeOut(250)
    lib.callback('am_storages:enterWarehouse', false, function(success)
        if success then 
            inside = true
            DrawStorages(data)
            DrawEntrance(data)
            DrawManagement(data)
            Wait(250)
            DoScreenFadeIn(250)
        else
            Notify(Config.Translate['notify_header'], Config.Translate['error_enter'], 'error')
            print("^2[am_storages]^7 The callback gave false back on \'am_storages:enterWarehouse\'")
        end
    end, data.level)
end

function ExitWarehouse()
    DoScreenFadeOut(250)
    lib.callback('am_storages:exitWarehouse', false, function(success)
        if success then 
            lib.hideTextUI()
            inside = false
            Wait(250)
            DoScreenFadeIn(250)
        end
    end)
end

function DrawStorages(data)
    CreateThread(function()
        local textUi = false
        print(json.encode(Config.Levels[data.level].storages))
        for index, storage in ipairs(Config.Levels[data.level].storages) do 
            CreateThread(function()
                local coords = storage.coords
                while inside do
                    local mycoords = GetEntityCoords(cache.ped)
                    local dist = #(coords-mycoords)

                    if dist < 8.0 then
                        DrawMarker(22, coords.x, coords.y, coords.z+0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 173, 216, 230, 150, false, true, 2, nil, nil, false)

                        if dist < 0.5 then
                            if IsControlJustPressed(0, 38) then
                                lib.callback('am_storages:openStash', false, function(stashId)
                                    if stashId then
                                        exports.ox_inventory:openInventory('stash', stashId)
                                    end
                                end, index, data.level)
                            end

                            if not textUi then
                                textUi = true
                                lib.showTextUI(string.format(Config.Translate['storage_open'], index))
                            end
                        else
                            if textUi then
                                textUi = nil
                                lib.hideTextUI()
                            end
                        end
                    end
                    Wait(1)
                end
            end)
        end
    end)
end

function DrawEntrance(data)
    CreateThread(function()
        local coords = vector3(
            Config.Levels[data.level].inside.x,
            Config.Levels[data.level].inside.y,
            Config.Levels[data.level].inside.z
        )
        while inside do
            local mycoords = GetEntityCoords(cache.ped)
            local dist = #(coords-mycoords)

            if dist < 8.0 then
                DrawMarker(30, coords.x, coords.y, coords.z+0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 160, 255, 100, 150, false, true, 2, nil, nil, false)

                if dist < 0.5 then
                    if IsControlJustPressed(0, 38) then
                        ExitWarehouse()
                    end

                    if not textUi then
                        textUi = true
                        lib.showTextUI(Config.Translate['storage_entrance'])
                    end
                else
                    if textUi then
                        textUi = nil
                        lib.hideTextUI()
                    end
                end
            end
            Wait(1)
        end
    end)
end

function DrawManagement(data)
    CreateThread(function()
        local coords = Config.Levels[data.level].management
        while inside do
            local mycoords = GetEntityCoords(cache.ped)
            local dist = #(coords-mycoords)

            if dist < 8.0 then
                DrawMarker(31, coords.x, coords.y, coords.z+0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 100, 0, 150, false, true, 2, nil, nil, false)

                if dist < 0.5 then
                    if IsControlJustPressed(0, 38) then
                        OpenManagementMenu()
                    end

                    if not textUi then
                        textUi = true
                        lib.showTextUI(Config.Translate['storage_management'])
                    end
                else
                    if textUi then
                        textUi = nil
                        lib.hideTextUI()
                    end
                end
            end
            Wait(1)
        end
    end)
end

function UpgradeWarehouse(data)
    if data.level +1 <= 10 then 
        local moneyAmount = exports.ox_inventory:Search('count', 'money')
        if moneyAmount >= Config.Levels[data.level].upgradePrice then 
            lib.callback('am_storages:upgradePlayerStorage', false, function(success)
                if success then 
                    Notify(Config.Translate['notify_header'], Config.Translate['successful_upgrade'], 'success')
                    lib.callback('am_storages:getPlayerStorage', false, function(result)
                        EnterWarehouse(result[1])
                    end)
                elseif success == nil then 
                    Notify(Config.Translate['notify_header'], Config.Translate['error_palyerIdentifier'], 'error')
                    print("^2[am_storages]^7 Couldn\'t get player\'s identifier")
                elseif success == false then 
                    Notify(Config.Translate['notify_header'], Config.Translate['error_palyerIdentifier'], 'error')
                    print("^2[am_storages]^7 Couldn\'t get player\'s identifier")
                else 
                    Notify(Config.Translate['notify_header'], Config.Translate['error_unexpected'], 'error')
                    print("^2[am_storages]^7 Unexpected error at \'am_storages:upgradePlayerStorage\' at \'client/functions.lua/324\'")
                end
            end, data.level)
        else 
            Notify(Config.Translate['notify_header'], Config.Translate['not_enough_money'], 'error')
            return
        end
    else 
        Notify(Config.Translate['notify_header'], Config.Translate['error_noLevel'], 'error')
    end
end

function SellWarehouse(data)
    local approve = lib.alertDialog({
        header = Config.Translate['sell_warehouse'],
        content = string.format(Config.Translate['sell_warehouse_desc'], data.level, Config.Levels[data.level].sellPrice),
        centered = true,
        cancel = true
    })

    if approve then 
        lib.callback('am_storages:sellPlayerStorage', false, function(success)
            if success then  
                Notify(Config.Translate['notify_header'], string.format(Config.Translate['successful_sell'], Config.Levels[data.level].sellPrice), 'success')
                ExitWarehouse()
            else 
                Notify(Config.Translate['notify_header'], Config.Translate['error_sell'], 'error')
            end
        end, data.level)
    else 
        OpenManagementMenu()
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end

    if npc then 
        DeleteEntity(npc)
        npc = nil
    end

    if inside then 
        Notify(Config.Translate['notify_header'], Config.Translate['error_restart'], 'error')
        TriggerServerEvent('am_storages:onStopBucketReset')
        SetEntityCoords(PlayerPedId(), Config.NPC.coords)
        inside = false
    end
end)