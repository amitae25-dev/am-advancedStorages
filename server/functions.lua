function GetLicenseIdentifier(src)
    local identifiers = GetPlayerIdentifiers(src)
    for _, v in ipairs(identifiers) do
        if string.sub(v, 1, 8) == "license:" then
            return v
        end
    end
    return nil
end

function InitDataBase()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS am_storages (
            id INT AUTO_INCREMENT PRIMARY KEY,
            player_identifier VARCHAR(50) NOT NULL,
            player_name VARCHAR(20) NOT NULL,
            name VARCHAR(20) NOT NULL,
            level TINYINT NOT NULL CHECK (level BETWEEN 1 AND 10),
            shared JSON DEFAULT (JSON_ARRAY())
        );
    ]], {}, function()
        if Config.Debug.dataBase then 
            print("^2[am_storages]^7 SQL table uploaded / checked.")
        end
    end)
end

function GetPlayerStorage(identifier, cb)
    MySQL.query('SELECT id, player_identifier, player_name, name, level FROM am_storages WHERE player_identifier = ? LIMIT 1', {
        identifier
    }, function(result)
        if cb then 
            cb(result)
        end
    end)
end

function UpgradeStorage(identifier, cb)
    MySQL.update('UPDATE am_storages SET level = level + 1 WHERE player_identifier = ? AND level < 10', {
        identifier
    }, function(affectedRows)
        if cb then 
            cb(affectedRows)
        end
    end)
end

function RenameStorage(identifier, newName, cb)
    MySQL.update('UPDATE am_storages SET name = ? WHERE player_identifier = ?', {
        newName, identifier
    }, function(affectedRows)
        if cb then 
            cb(affectedRows)
        end
    end)
end

function BuyStorage(identifier, name, cb)
    MySQL.insert('INSERT INTO am_storages (player_identifier, player_name, name, level) VALUES (?, ?, ?, ?)', {
        identifier, name, 'Warehouse', 1
    }, function(insertId)
        if cb then 
            cb(insertId)
        end
    end)
end

function SellStorage(identifier, cb)
    MySQL.execute('DELETE FROM am_storages WHERE player_identifier = ?', {
        identifier
    }, function(result)
        if cb then
            cb(result.affectedRows)
        end
    end)
end

function AddSharedPlayer(ownerIdentifier, targetIdentifier, targetName, cb)
    local obj = {
        identifier = targetIdentifier,
        name = targetName
    }
    local jsonValue = json.encode(obj)
    MySQL.update(
        'UPDATE am_storages SET shared = JSON_ARRAY_APPEND(shared, "$", ? ) WHERE player_identifier = ?',
        { jsonValue, ownerIdentifier },
        function(affectedRows)
            if cb then cb(affectedRows) end
        end
    )
end

function GetWarehousesForSharedPlayer(targetIdentifier, cb)
    MySQL.query(
        [[
            SELECT * 
            FROM am_storages 
            WHERE JSON_SEARCH(
                JSON_EXTRACT(shared, '$[*]'),
                'one',
                CONCAT('%', ?, '%')
            ) IS NOT NULL
        ]],
        { targetIdentifier },
        function(result)
            local ownerIdentifiers = {}
            if result and #result > 0 then
                for _, row in ipairs(result) do
                    local data = {
                        player_identifier = row.player_identifier,
                        player_name = row.player_name,
                        wh_name = row.name,
                        wh_lvl = row.level,
                        wh_id = row.id
                    }
                    table.insert(ownerIdentifiers, data)
                end
            end
            cb(ownerIdentifiers)
        end
    )
end

function RemoveSharedPlayer(ownerIdentifier, targetIdentifier, cb)
    GetSharedList(ownerIdentifier, function(result)
        local data = json.encode(result)
        if not result or not result[1] then
            if cb then cb(0) end
            return
        end

        local newList = {}

        for _, v in ipairs(result) do
            if tostring(v.identifier) ~= tostring(targetIdentifier) then
                table.insert(newList, v)
            end
        end

        MySQL.update(
            'UPDATE am_storages SET shared = ? WHERE player_identifier = ?',
            { json.encode(newList), ownerIdentifier },
            function(affectedRows)
                if cb then cb(affectedRows) end
            end
        )
    end)
end

function GetSharedList(ownerIdentifier, cb)
    MySQL.query(
        'SELECT shared FROM am_storages WHERE player_identifier = ? LIMIT 1',
        { ownerIdentifier },
        function(result)
            if not result or not result[1] or not result[1].shared then
                cb({})
                return
            end

            local decoded = json.decode(result[1].shared) or {}
            local sharedList = {}

            for _, v in ipairs(decoded) do
                if type(v) == "string" then
                    local entry = json.decode(v)
                    if entry then
                        table.insert(sharedList, entry)
                    end
                elseif type(v) == "table" then
                    table.insert(sharedList, v)
                end
            end

            cb(sharedList)
        end
    )
end

function GetPlayerIdByIdentifier(identifier)
    for _, playerId in ipairs(GetPlayers()) do
        local identifiers = GetPlayerIdentifiers(playerId)
        for _, id in ipairs(identifiers) do
            if id == identifier then
                return tonumber(playerId)
            end
        end
    end
    return nil
end


function removeMoney(source, amount)
    local success = exports.ox_inventory:RemoveItem(source, 'money', amount)
    return success
end

function tableRemove(table, item)
    for i, x in ipairs(table) do 
        if x == item then 
            table.remove(table, i)
        end
    end
end

function OpenStash(index, identifier, slot, weight, cb)
    exports.ox_inventory:RegisterStash('am_storages:stash:'.. index..'-'.. identifier, string.format(Config.Translate['storage_name'], index), slot, weight)
    cb('am_storages:stash:'.. index..'-'.. identifier)
end
