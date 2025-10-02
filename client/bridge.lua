local target = Config.FrameWork.target
local inventory = Config.FrameWork.inventory

function TargetEntity(entity, tName, tLabel, tIcon, func)
    if target == "ox" then 
        exports.ox_target:addLocalEntity(entity, {
            name = tName,                                                    -- 'am_storage_target'
            icon = tIcon,
            --iconColor = 'white',
            label = tLabel,
            distance = 1.5,
            canInteract = function(entity, distance, coords)
                return true
            end,
            
            onSelect = function(data)
                func()
            end
        })
    elseif target == "qb" then 
        exports['qb-target']:AddTargetEntity(entity, {
            options = {
            {
                type = "client",
                icon = tIcon,
                label = tLabel,
                targeticon = "fas fa-user",
                action = function(entity)
                    func()
                end,
            }
            },
            distance = 1.5
        })
    else 
        --
    end
end