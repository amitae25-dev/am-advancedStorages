lib.callback.register('am_storages:getPlayerStorage', function(source)
    local identifier = GetLicenseIdentifier(source)
    local p = promise:new()
    if identifier then 
        GetPlayerStorage(identifier, function(result)
            print(result)
            if result and result ~= '[]' then 
                p:resolve(result)
            else
                print('asd')
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

lib.callback.register('am_storages:upgradePlayerStorage', function(source, lvl)
    local identifier = GetLicenseIdentifier(source)
    local p = promise:new()
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

lib.callback.register('am_storages:buyPlayerStorage', function(source)
    local identifier = GetLicenseIdentifier(source)
    local p = promise:new()
    if identifier then 
        local success = removeMoney(source, Config.StoragePrice)
        if success then 
            BuyStorage(identifier, function(id)
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

lib.callback.register('am_storages:enterWarehouse', function(source, lvl)
    SetEntityRoutingBucket(GetPlayerPed(source), source)
    SetEntityCoords(GetPlayerPed(source), Config.Levels[lvl].inside.x, Config.Levels[lvl].inside.y, Config.Levels[lvl].inside.z)
    SetEntityHeading(GetPlayerPed(source), Config.Levels[lvl].inside.h)
    DiscordLog(string.format(Config.Translate['log_enter'], source, identifier), Server.Webhooks['enter_exit'])
    return true
end)

lib.callback.register('am_storages:exitWarehouse', function(source)
    SetEntityRoutingBucket(GetPlayerPed(source), 0)
    SetEntityCoords(GetPlayerPed(source), Config.NPC.coords.x + 1.0, Config.NPC.coords.y + 1.0, Config.NPC.coords.z)
    SetEntityHeading(GetPlayerPed(source), Config.NPC.coords.h)
    DiscordLog(string.format(Config.Translate['log_exit'], source, identifier), Server.Webhooks['enter_exit'])
    return true
end)

lib.callback.register('am_storages:openStash', function(source, index, lvl)
    local identifier = GetLicenseIdentifier(source)
    local p = promise:new()
    OpenStash(index, identifier, Config.Levels[lvl].storages[index].slots, Config.Levels[lvl].storages[index].weight, function(stashId)
        DiscordLog(string.format(Config.Translate['log_stash'], source, identifier, stashId), Server.Webhooks['open_stash'])
        p:resolve(stashId)
    end)
    return Citizen.Await(p)
end)

RegisterNetEvent('am_storages:onStopBucketReset')
AddEventHandler('am_storages:onStopBucketReset', function()
    local src = source 
    SetEntityRoutingBucket(GetPlayerPed(src), 0)
    print("^2[am_storages]^7 Script got restarted while player was inside! Please avoid doing this, because it might result with RoutinBucket problems!")
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    InitDataBase()
end)
