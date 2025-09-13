local inside = false
local npc 

local targets = {}

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

-- Code

function InitParkIn(coords)
    local zone = lib.zones.sphere({
        coords = coords,
        debug = Config.Debug.zoneDebug,
        radius = 4,
        onEnter = function(self)
            lib.showTextUI(Config.Translate['enter_parkin'])
        end,
        inside = function()
            if IsControlJustPressed(0, 38) then
                if IsPedInAnyVehicle(PlayerPedId(), false) then 
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    OpenStorageMain(vehicle)
                end
            end
        end,
        onExit = function(self)
            lib.hideTextUI()
        end
    })
end

function InitTarget(data, blip, targetLabel, func)
    if Config.Blip.showBlip and blip then 
        local blip = AddBlipForCoord(Config.NPC.coords.x, Config.NPC.coords.y, Config.NPC.coords.z)
        SetBlipSprite(blip, Config.Blip.blipModel)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Blip.blipScale)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip, Config.Blip.blipColor)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Blip.blipLabel)
        EndTextCommandSetBlipName(blip)
    end

    local zone = lib.zones.sphere({
        coords = data.coords,
        debug = Config.Debug.zoneDebug,
        radius = 30,
        onEnter = function(self)
            if not self.npc then
                LoadModel(data.model)

                npc = CreatePed(4, data.model, data.coords, false, true)

                FreezeEntityPosition(npc, true)
                SetEntityInvincible(npc, true)
                SetBlockingOfNonTemporaryEvents(npc, true)
                SetEntityHeading(npc, data.coords.w)
                PlaceObjectOnGroundProperly(npc)
                if data.scenario then 
                    TaskStartScenarioInPlace(npc, data.scenario, true, true)
                end

                --- OX TARGET ----

                exports.ox_target:addLocalEntity(npc, {
                    name = 'am_storage_target',
                    icon = 'fa-solid fa-hand',
                    --iconColor = 'white',
                    label = targetLabel,
                    distance = 1.5,
                    canInteract = function(entity, distance, coords)
                        return true
                    end,
                    
                    onSelect = function(data)
                        func()
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

function OpenStorageMain(vehicle)
    lib.callback('am_storages:getPlayerStorage', false, function(result)
        local options = {}
        if result and #result > 0 and result[1].id then 
            table.insert(options, {
                title = string.format(Config.Translate['enter_storage'], result[1].name),
                description = Config.Translate['enter_storage_desc'],
                icon = 'door-open',
                iconColor = 'teal',
                onSelect = function()
                    if vehicle then 
                        EnterWarehouse(result[1], true, vehicle)
                    else
                        EnterWarehouse(result[1], true)
                    end
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
                    if vehicle and IsPedInAnyVehicle(PlayerPedId(), true) then 
                        Notify(Config.Translate['notify_header'], Config.Translate['exit_vehicle_first'], 'error')
                    else 
                        BuyWarehouse()
                    end
                end
            })
        end
        table.insert(options, {
            title = Config.Translate['shared_storages'],
            description = Config.Translate['shared_storages_desc'],
            icon = 'share',
            iconColor = 'blue',
            disabled = false,
            onSelect = function()
                if vehicle and IsPedInAnyVehicle(PlayerPedId(), true) then 
                    Notify(Config.Translate['notify_header'], Config.Translate['cannot_enter_shared'], 'error')
                else 
                    OpenShared()
                end
            end
        })
        lib.registerContext({
            id = 'am_storage_main',
            title = Config.Translate['menu_header'],
            options = options
        })
        lib.showContext('am_storage_main')
    end)
end

function OpenShared()
    lib.callback('am_storages:getSharedWithMe', false, function(result)
        local options = {}
        if result and #result > 0 then 
            for index, data in ipairs(result) do 
                table.insert(options, {
                    title = string.format(Config.Translate['shared_options'], data.wh_name),
                    description = string.format(Config.Translate['shared_options_desc'], data.player_name, data.wh_lvl),
                    icon = 'info',
                    iconColor = 'teal',
                    onSelect = function()
                        lib.callback('am_storages:getStorageFromID', false, function(data)
                            EnterWarehouse(data[1], false)
                        end, data.player_identifier)
                    end
                })
            end
        else 
            table.insert(options, {
                title = Config.Translate['shared_empty'],
                icon = 'x',
                iconColor = 'red',
            })
        end
        lib.registerContext({
            id = 'am_storage_shared',
            title = Config.Translate['shared_header'],
            options = options
        })
        lib.showContext('am_storage_shared')
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
                progress = result[1].level * 10
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
                disabled = false,
                onSelect = function()
                    OpenSharedManagement()
                end
            })
            table.insert(options, {
                title = Config.Translate['settings'],
                description = Config.Translate['settings_desc'],
                icon = 'gear',
                disabled = false,
                onSelect = function()
                    OpenSettingsManagement(result[1])
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
            options = options,
        })
        lib.showContext('am_storage_management')
    end)
end

function OpenSharedManagement()
    lib.registerContext({
        id = 'am_storage_shared_management',
        title = Config.Translate['share_warehouse'],
        options = {
            {
                title = Config.Translate['shared_add_new'],
                description = Config.Translate['shared_add_new_desc'],
                icon = 'plus',
                iconColor = 'green',
                onSelect = function()
                    lib.callback('am_storages:getPlayers', false, function(players)
                        if not players or #players == 0 then
                            Notify(Config.Translate['notify_header'], Config.Translate['shared_input_no_players'], 'error')
                            return
                        end
                        local input = lib.inputDialog(Config.Translate['shared_input_header'], {
                            {
                                type = 'select',
                                label = Config.Translate['shared_input_desc'],
                                options = players,
                                required = true
                            }
                        })

                        if input then
                            lib.callback('am_storages:addSharedPlayer', false, function(success)
                                if success and success > 0 then 
                                    Notify(Config.Translate['notify_header'], Config.Translate['shared_player_added'], 'success')
                                    OpenSharedManagement()
                                end
                            end, input[1])
                        end
                    end)
                end
            },
            {
                title = Config.Translate['shared_remove'],
                description = Config.Translate['shared_remove_desc'],
                icon = 'x',
                iconColor = 'red',
                onSelect = function()
                    OpenSharedRemove()
                end
            },
        },
    })
    lib.showContext('am_storage_shared_management')
end


function OpenSettingsManagement(data)
    lib.registerContext({
        id = 'am_storage_settings_management',
        title = Config.Translate['settings_header'],
        options = {
            {
                title = Config.Translate['rename_warehouse'],
                description = string.format(Config.Translate['rename_warehouse_desc'], data.name),
                icon = 'pencil',
                iconColor = 'blue',
                disabled = false,
                onSelect = function()
                    local input = lib.inputDialog(Config.Translate['input_rename_header'], {
                        {type = 'input', label = Config.Translate['input_rename'], description = Config.Translate['input_rename'], required = true, min = 4, max = 20},
                    })
                    if input[1] then 
                        lib.callback('am_storages:renameStorage', false, function(success)
                            if success and success > 0 then 
                                OpenManagementMenu()
                            end
                        end, input[1])
                    end
                end
            },
            --[[{
                title = Config.Translate['edit_icons'],
                description = Config.Tranlsate['edit_icon_desc'],
                icon = 'pencil',
                iconColor = 'teal',
                disabled = false,
                onSelect = function()
                    OpenIconSelectMenu(data)
                end
            }]]
        },
    })
    lib.showContext('am_storage_settings_management')
end

function OpenSharedRemove()
    lib.callback('am_storages:getSharedList', false, function(shared)
        local options = {}
        if shared and #shared > 0 then 
            for index, player in ipairs(shared) do 
                table.insert(options, {
                    title = player.name,
                    description = Config.Translate['remove_user'],
                    icon = 'person',
                    iconColor = 'teal',
                    onSelect = function()
                        lib.callback('am_storages:removeSharedPlayer', false, function(success)
                            if success and success > 0 then 
                                Notify(Config.Translate['notify_header'], string.format(Config.Translate['shared_player_removed'], player.name), 'success')
                                OpenSharedManagement()
                            end
                        end, player.identifier)
                    end
                })
            end
        else 
            table.insert(options, {
                title = Config.Translate['shared_list_empty'],
                description = Config.Translate['shared_list_empty_desc'],
                icon = 'x',
                iconColor = 'red'
            })
        end
        lib.registerContext({
            id = 'am_storage_management_shared_remove',
            title = Config.Translate['shared_remove_header'],
            options = options,
        })
        lib.showContext('am_storage_management_shared_remove')
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

local managementTarget = false 
local exitTarget = false
function EnterWarehouse(data, drawManagement, vehicle)
    DoScreenFadeOut(250)
    local netId
    if vehicle then 
        netId = NetworkGetNetworkIdFromEntity(vehicle)
    end
    Wait(250)
    lib.callback('am_storages:enterWarehouse', false, function(success, vehicleInside)
        if success == 'lowLevel' then 
            Notify(Config.Translate['notify_header'], Config.Translate['parkin_low_level'], 'error')
            Wait(500)
            DoScreenFadeIn(250)
            return
        end
        if success == 'notEmpty' then 
            Notify(Config.Translate['notify_header'], Config.Translate['parkin_busy'], 'error')
            Wait(500)
            DoScreenFadeIn(250)
            return
        end
        if success then 
            inside = true
            DrawStorages(data)
            DrawEntrance(data)
            if drawManagement then 
                DrawManagement(data)
            end
            if vehicle or vehicleInside then 
                DrawVehicleExit(data)
            end
            Wait(500)
            DoScreenFadeIn(250)
        else
            Notify(Config.Translate['notify_header'], Config.Translate['error_enter'], 'error')
            print("^2[am_storages]^7 The callback gave false back on \'am_storages:enterWarehouse\'")
        end
    end, data.id ,data.level, netId)
end

function ExitWarehouse(id, vehicle)
    DoScreenFadeOut(250)
    Wait(250)
    lib.callback('am_storages:exitWarehouse', false, function(success)
        if success then 
            lib.hideTextUI()
            inside = false
            Wait(250)
            DoScreenFadeIn(250)
        end
    end, id, vehicle)
end

local objects = {}
function CleareObjects()
    if #objects > 0 then 
        for index, object in ipairs(objects) do 
            DeleteEntity(object)
        end
        objects = {}
    end
end

function DrawStorages(data)
    CreateThread(function()
        local textUi = false
        for index, storage in ipairs(Config.Levels[data.level].storages) do 
            if Config.DefaultSettings.useTarget then 
                if storage.object then 
                    local prop = CreateObject(storage.object, storage.coords.x, storage.coords.y, storage.coords.z, true, true, false)
                    PlaceObjectOnGroundProperly(prop)
                    SetEntityHeading(prop, 100)
                    FreezeEntityPosition(prop, true)
                    table.insert(objects, prop)

                    exports.ox_target:addLocalEntity(prop, {
                        label = Config.Translate['open_stash_target'],
                        icon = 'fa-solid fa-box',
                        name = 'am_warehouses:storageTarget_' .. index,
                        onSelect = function()
                            lib.callback('am_storages:openStash', false, function(stashId)
                                if stashId then
                                    exports.ox_inventory:openInventory('stash', stashId)
                                end
                            end, index, data.level, data.player_identifier)             
                        end
                    })
                end
            else
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
                                    end, index, data.level, data.player_identifier)
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
        end
    end)
end

function DrawEntrance(data)
    if Config.DefaultSettings.useTarget then 
        local target = exports.ox_target:addSphereZone({
            coords = vector3(
                Config.Levels[data.level].inside.x,
                Config.Levels[data.level].inside.y,
                Config.Levels[data.level].inside.z
            ),
            name = 'am_warehouses:entranceTarget',
            radius = 2.0,
            drawSprite = true,
            options = {
                {
                    icon = "fa-solid fa-door-open",
                    iconColor = 'white',
                    label = Config.Translate['exit_warehouse_target'],
                    distance = 1.5,
                    onSelect = function()
                        ExitWarehouse(data.id)
                        exports.ox_target:removeZone('am_warehouses:entranceTarget')
                        exports.ox_target:removeZone('am_warehouses:vehicleExitTarget')
                        exports.ox_target:removeZone('am_warehouses:managementTarget')
                        CleareObjects()
                    end
                }
            }
        })
    else
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
                            ExitWarehouse(data.id)
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
end

function DrawVehicleExit(data)
    if Config.DefaultSettings.useTarget then 
        local target = exports.ox_target:addSphereZone({
            coords = vector3(
                Config.Levels[data.level].parkIn.x,
                Config.Levels[data.level].parkIn.y,
                Config.Levels[data.level].parkIn.z
            ),
            name = 'am_warehouses:vehicleExitTarget',
            radius = 4.0,
            drawSprite = true,
            options = {
                {
                    icon = "fa-solid fa-door-open",
                    iconColor = 'white',
                    label = Config.Translate['exit_warehouse_vehicle_target'],
                    distance = 1.5,
                    onSelect = function()
                        ExitWarehouse(data.id, true)
                        exports.ox_target:removeZone('am_warehouses:vehicleExitTarget')
                        exports.ox_target:removeZone('am_warehouses:entranceTarget')
                        exports.ox_target:removeZone('am_warehouses:managementTarget')
                        CleareObjects()
                    end
                }
            }
        })
    else
        CreateThread(function()
            local coords = vector3(
                Config.Levels[data.level].parkIn.x,
                Config.Levels[data.level].parkIn.y,
                Config.Levels[data.level].parkIn.z
            )
            while inside do
                local mycoords = GetEntityCoords(cache.ped)
                local dist = #(coords-mycoords)

                if dist < 8.0 then
                    DrawMarker(30, coords.x, coords.y, coords.z+0.2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 160, 255, 100, 150, false, true, 2, nil, nil, false)

                    if dist < 0.5 then
                        if IsControlJustPressed(0, 38) then
                            ExitWarehouse(data.id, true)
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
end

function DrawManagement(data)
    if Config.DefaultSettings.useTarget then 
        exports.ox_target:addSphereZone({
            coords = vector3(
                Config.Levels[data.level].management.x,
                Config.Levels[data.level].management.y,
                Config.Levels[data.level].management.z
            ),
            name = 'am_warehouses:managementTarget',
            radius = 2.0,
            drawSprite = true,
            options = {
                icon = "fa-solid fa-bars-progress",
                iconColor = 'white',
                label = Config.Translate['management_target'],
                distance = 1.5,
                onSelect = function()
                    OpenManagementMenu()   
                end
            }
        })
        managementTarget = true
    else
        CreateThread(function()
            local coords = vector3(
                Config.Levels[data.level].management.x,
                Config.Levels[data.level].management.y,
                Config.Levels[data.level].management.z
            )
            local heading = Config.Levels[data.level].management.w
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
end

function UpgradeWarehouse(data)
    if data.level +1 <= 10 then 
        local moneyAmount = exports.ox_inventory:Search('count', 'money')
        if moneyAmount >= Config.Levels[data.level].upgradePrice then 
            lib.callback('am_storages:upgradePlayerStorage', false, function(success)
                print(success)
                if success == 'removeVeh' then 
                    Notify(Config.Translate['notify_header'], Config.Translate['remove_veh_first'], 'error')
                    return
                end

                if success then 
                    exports.ox_target:removeZone('am_warehouses:vehicleExitTarget')
                    exports.ox_target:removeZone('am_warehouses:entranceTarget')
                    exports.ox_target:removeZone('am_warehouses:managementTarget')
                    CleareObjects()
                    Notify(Config.Translate['notify_header'], string.format(Config.Translate['successful_upgrade'], data.level +1, Config.Levels[data.level].upgradePrice), 'success')
                    lib.callback('am_storages:getPlayerStorage', false, function(result)
                        EnterWarehouse(result[1], true)
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
            end, data.level, data.id)
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

-- Robbery Essentials       Work in progres...
--[[
function OpenRobberyMain()
    lib.callback('am_storages:getWarehousesForRobbery', false, function(data)
        local options = {}
        if data and #data > 0 then 
            for index, item in ipairs(data) do 
                if item.level >= Config.Robbery.canRob.minLevel then 
                    table.insert(options, {
                        title = string.format(Config.Translate['rob_warehouse'], item.player_name),
                        description = string.format(Config.Translate['rob_warehouse_desc'], item.level),
                        icon = 'user-secret',
                        iconColor = 'blue',
                        onSelect = function()
                            if Config.Robbery.requiredItem.itemName then 
                                print('asd')
                                lib.callback('am_storages:removeItem', false, function(success)
                                    print(success)
                                    if success then 
                                        EnterWarehouse(item, false)
                                    else 
                                        Notify(Config.Translate['notify_header'], Config.Translate['missing_required_item'], 'error')
                                    end
                                end, Config.Robbery.requiredItem.itemName, Config.Robbery.requiredItem.itemCount)
                            end
                        end
                    })
                end
            end
        end
        if #options < 1 then 
            table.insert(options, {
                title = Config.Translate['list_empty'],
                description = Config.Translate['list_empty_desc'],
                icon = 'x',
                iconColor = 'red',
            })
        end

        lib.registerContext({
            id = 'am_storages_rob_warehouse',
            title = Config.Translate['robbery_header'],
            options = options,
        })
        lib.showContext('am_storages_rob_warehouse')
    end)
end]]
