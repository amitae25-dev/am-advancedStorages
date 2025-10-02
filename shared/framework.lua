Config.FrameWork = {}

Config.FrameWork.target = 'ox'              -- "ox" or "qb"
Config.FrameWork.inventory = 'ox'           -- "ox" or "qb"

function Notify(title, description, ntype)
    lib.notify({
        title = title,
        description = description,
        type = ntype
    })
end