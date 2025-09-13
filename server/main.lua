local inside = {}
local vehInside = {}
lib.callback.register('am_storages:getPlayerStorage', function(source)
    local identifier = GetLicenseIdentifier(source)
    local p = promise:new()
    if identifier then 
        GetPlayerStorage(identifier, function(result)
            if result and result ~= '[]' then 
                p:resolve(result)
            else
                p:resolve(false)
            end
        end)
    else
        if Config.Debug.server then 
            print("^2[am_storages]^7 Couldn\'t get player\'s identifier with server ID: ", source)
            p:resolve(false)
        end
        p:resolve(false)
    end
    return Citizen.Await(p)
end)

lib.callback.register('am_storages:upgradePlayerStorage', function(source, lvl, wh_id)
    local identifier = GetLicenseIdentifier(source)
    local p = promise:new()
    if vehInside[wh_id] ~= nil then 
        return 'removeVeh'
    end
    if identifier then 
        local success = removeMoney(source, Config.Levels[lvl].upgradePrice)
        if success then 
            UpgradeStorage(identifier, function(affectedRows)
                if affectedRows > 0 then
                    DiscordLog(string.format(Config.Translate['log_upgrade'], source, identifier, lvl, Config.Levels[lvl].upgradePrice), Server.Webhooks['upgrade_storage'])
                    p:resolve(true)
                else
                    p:resolve(nil)
                end
            end)
        else 
            print("^2[am_storages]^7 Couldn\'t remove money from player with server ID: ", source)
            p:resolve(nil)
        end
    else
        if Config.Debug.server then 
            print("^2[am_storages]^7 Couldn\'t get player\'s identifier with server ID: ", source)
            p:resolve(false)
        end
        p:resolve(false)
    end
    return Citizen.Await(p)
end)

lib.callback.register('am_storages:renameStorage', function(source, newName)
    local identifier = GetLicenseIdentifier(source)
    local p = promise:new()
    RenameStorage(identifier, newName, function(affectedRows)
        p:resolve(affectedRows)
    end)
    return Citizen.Await(p)
end)

lib.callback.register('am_storages:buyPlayerStorage', function(source)
    local identifier = GetLicenseIdentifier(source)
    local name = GetPlayerName(source)
    local p = promise:new()
    if identifier and name then 
        local success = removeMoney(source, Config.StoragePrice)
        if success then 
            BuyStorage(identifier, name, function(id)
                if id and id > 0 then 
                    DiscordLog(string.format(Config.Translate['log_buy'], source, identifier, Config.StoragePrice), Server.Webhooks['purchase_storage'])
                    p:resolve(id)
                else 
                    p:resolve(nil)
                end
            end)
        else 
            print("^2[am_storages]^7 Couldn\'t remove money from player with server ID: ", source)
            p:resolve(nil)
        end
    else
        if Config.Debug.server then 
            print("^2[am_storages]^7 Couldn\'t get player\'s identifier with server ID: ", source)
            p:resolve(false)
        end
        p:resolve(false)
    end
    return Citizen.Await(p)
end)

lib.callback.register('am_storages:sellPlayerStorage', function(source, lvl)
    local identifier = GetLicenseIdentifier(source)
    local p = promise:new()
    if identifier then 
        SellStorage(identifier, function(affectedRows)
            if affectedRows and affectedRows > 0 then 
                local success, response = exports.ox_inventory:AddItem(source, 'money', Config.Levels[lvl].sellPrice)
                if success then 
                    DiscordLog(string.format(Config.Translate['log_sell'], source, identifier, lvl, Config.Levels[lvl].sellPrice), Server.Webhooks['sell_storage'])
                    p:resolve(true)
                else 
                    print("^2[am_storages]^7 Couldn\'t give money for player with server ID: ", source)
                    print("^2[am_storages]^7 Couldn\'t give money for player error: ", response)
                    p:resolve(false)
                end
            else 
                print("^2[am_storages]^7 Couldn\'t delete warehouse from palyer with server ID: ", source)
                p:resolve(false)
            end
        end)
    else
        if Config.Debug.server then 
            print("^2[am_storages]^7 Couldn\'t get player\'s identifier with server ID: ", source)
            p:resolve(false)
        end
        p:resolve(false)
    end
    return Citizen.Await(p)
end)

lib.callback.register('am_storages:getSharedWithMe', function(source)
    local identifier = GetLicenseIdentifier(source)
    local p = promise:new()
    GetWarehousesForSharedPlayer(identifier, function(warehouses)
        p:resolve(warehouses)
    end)
    return Citizen.Await(p)
end)

lib.callback.register('am_storages:getStorageFromID', function(source, target)
    local p = promise:new()
    GetPlayerStorage(target, function(result)
        if result and result ~= '[]' then 
            p:resolve(result)
        else
            p:resolve(false)
        end
    end)
    return Citizen.Await(p)
end)

lib.callback.register('am_storages:addSharedPlayer', function(source, targetId)
    local ownerIdentifier = GetLicenseIdentifier(source)
    local targetIdentifier = GetLicenseIdentifier(targetId)
    local targetName = GetPlayerName(targetId)
    local p = promise:new()
    if ownerIdentifier and targetIdentifier then 
        AddSharedPlayer(ownerIdentifier, targetIdentifier, targetName, function(result)
            p:resolve(result)
        end)
    else
        p:resolve(false)
    end
    return Citizen.Await(p)
end)

lib.callback.register('am_storages:removeSharedPlayer', function(source, targetIdentifier)
    local ownerIdentifier = GetLicenseIdentifier(source)
    local p = promise:new()
    if ownerIdentifier and targetIdentifier then 
        RemoveSharedPlayer(ownerIdentifier, targetIdentifier, function(result)
            p:resolve(result)
        end)
    else
        p:resolve(false)
    end
    return Citizen.Await(p)
end)

lib.callback.register('am_storages:getSharedList', function(source)
    local identifier = GetLicenseIdentifier(source)
    local p = promise:new()
    if identifier then 
        GetSharedList(identifier, function(result)
            p:resolve(result)
        end)
    else
        p:resolve(false)
    end
    return Citizen.Await(p)
end)

lib.callback.register('am_storages:enterWarehouse', function(source, wh_id, lvl, vehicle)
    local identifier = GetLicenseIdentifier(source)
    if vehicle then 
        if Config.Levels[lvl].parkIn ~= false then 
            if vehInside[wh_id] ~= nil then return 'notEmpty' end
            SetPlayerRoutingBucket(source, wh_id)
            local entity = NetworkGetEntityFromNetworkId(vehicle)
            SetEntityRoutingBucket(entity, wh_id)
            SetEntityCoords(entity, Config.Levels[lvl].parkIn.x, Config.Levels[lvl].parkIn.y, Config.Levels[lvl].parkIn.z)
            SetEntityHeading(entity, Config.Levels[lvl].parkIn.w)
            Wait(500)
            FreezeEntityPosition(entity, true)
            vehInside[wh_id] = vehicle
        else 
            return 'lowLevel'
        end
    else 
        SetPlayerRoutingBucket(source, wh_id)
        SetEntityCoords(GetPlayerPed(source), Config.Levels[lvl].inside.x, Config.Levels[lvl].inside.y, Config.Levels[lvl].inside.z)
        SetEntityHeading(GetPlayerPed(source), Config.Levels[lvl].inside.w)
    end
    DiscordLog(string.format(Config.Translate['log_enter'], source, identifier), Server.Webhooks['enter_exit'])
    local isVehicleInside = vehInside[wh_id]
    --table.insert(inside[wh_id], source)
    return true, isVehicleInside
end)

lib.callback.register('am_storages:exitWarehouse', function(source, wh_id, vehicle)
    local identifier = GetLicenseIdentifier(source)
    if vehicle then 
        local entity = NetworkGetEntityFromNetworkId(vehInside[wh_id])
        SetPlayerRoutingBucket(source, 0)
        SetEntityRoutingBucket(entity, 0)
        SetEntityCoords(entity, Config.DefaultSettings.parkIn.enterPos.x, Config.DefaultSettings.parkIn.enterPos.y, Config.DefaultSettings.parkIn.enterPos.z)
        SetEntityHeading(entity, Config.DefaultSettings.parkIn.enterPos.w)
        TaskWarpPedIntoVehicle(GetPlayerPed(source), entity, -1)
        Wait(500)
        FreezeEntityPosition(entity, false)
        DiscordLog(string.format(Config.Translate['log_exit'], source, identifier), Server.Webhooks['enter_exit'])
        vehInside[wh_id] = nil
    else
        SetPlayerRoutingBucket(source, 0)
        SetEntityCoords(GetPlayerPed(source), Config.NPC.coords.x + 1.0, Config.NPC.coords.y + 1.0, Config.NPC.coords.z)
        SetEntityHeading(GetPlayerPed(source), Config.NPC.coords.w)
        DiscordLog(string.format(Config.Translate['log_exit'], source, identifier), Server.Webhooks['enter_exit'])
        --tableRemove(inside[wh_id], source)
    end
    return true
end)

lib.callback.register('am_storages:openStash', function(source, index, lvl, targetIdentifier)
    local identifier = targetIdentifier or GetLicenseIdentifier(source)
    local p = promise:new()
    OpenStash(index, identifier, Config.Levels[lvl].storages[index].slots, Config.Levels[lvl].storages[index].weight, function(stashId)
        DiscordLog(string.format(Config.Translate['log_stash'], source, identifier, stashId), Server.Webhooks['open_stash'])
        p:resolve(stashId)
    end)
    return Citizen.Await(p)
end)

lib.callback.register('am_storages:getPlayers', function(source)
    local src = source
    local players = {}
    for _, id in ipairs(GetPlayers()) do
        if tonumber(src) ~= tonumber(id) then 
            local name = GetPlayerName(id)
            players[#players+1] = {
                label = string.format("[%s] - %s", id, name),
                value = tonumber(id)
            }
        end
    end
    return players
end)


RegisterNetEvent('am_storages:onStopBucketReset')
AddEventHandler('am_storages:onStopBucketReset', function()
    local src = source 
    SetPlayerRoutingBucket(src, 0)
    print("^2[am_storages]^7 Script got restarted while player was inside! Please avoid doing this, because it might result with RoutinBucket problems!")
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    InitDataBase()
end)

-- Robbery Esentials            Work in progress
--[[
lib.callback.register('am_storages:getWarehousesForRobbery', function(source)
    local p = promise:new()
    GetAllWarehouses(function(data)
        if data and #data > 0 then 
            p:resolve(data)
        else 
            p:resolve(false)
        end
    end)
    return Citizen.Await(p)
end)

lib.callback.register('am_storages:removeItem', function(source, item, count)
    local itemCount = exports.ox_inventory:Search(source, 'count', item)

    if itemCount >= count then
        local removed = exports.ox_inventory:RemoveItem(source, item, count)
        if removed then
            return true
        end
    end
    return false
end)]]
