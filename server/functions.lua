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
    MySQL.query('SELECT id, player_identifier, level FROM am_storages WHERE player_identifier = ? LIMIT 1', {
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

function BuyStorage(identifier, cb)
    MySQL.insert('INSERT INTO am_storages (player_identifier, level) VALUES (?, ?)', {
        identifier, 1
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

--[[
function AddSharedPlayer(ownerIdentifier, targetIdentifier)
    MySQL.update('UPDATE am_storages SET shared = JSON_ARRAY_APPEND(shared, "$", ?) WHERE player_identifier = ?', {
        targetIdentifier, ownerIdentifier
    }, function(affectedRows)
        if affectedRows > 0 then
            return true
        else
            return false
        end
    end)
end

function RemoveSharedIdentifier(ownerIdentifier, targetIdentifier)
    local list = GetSharedList(ownerIdentifier)
    if not list then
        return nil
    end
    local newList = {}
    for _, v in ipairs(list) do
        if v ~= targetIdentifier then
            table.insert(newList, v)
        end
    end

    MySQL.update(
        'UPDATE am_storages SET shared = ? WHERE player_identifier = ?',
        { json.encode(newList), ownerIdentifier },
        function(affectedRows)
            return affectedRows
        end
    )
end


function GetSharedList(ownerIdentifier)
    MySQL.query(
        'SELECT shared FROM am_storages WHERE player_identifier = ? LIMIT 1',
        { ownerIdentifier },
        function(result)
            if result[1] then
                local shared = json.decode(result[1].shared)
                return shared
            else
                return nil
            end
        end
    )
end]]

function removeMoney(source, amount)
    local success = exports.ox_inventory:RemoveItem(source, 'money', amount)
    return success
end

function OpenStash(index, identifier, slot, weight, cb)
    exports.ox_inventory:RegisterStash('am_storages:stash:'.. index..'-'.. identifier, string.format(Config.Translate['storage_name'], index), slot, weight)
    cb('am_storages:stash:'.. index..'-'.. identifier)
end