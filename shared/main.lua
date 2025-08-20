Config = {}

Config.Blip = {
    showBlip = false,
    blipModel = 50,
    blipScale = 0.8,
    blipColor = 21
}

Config.NPC = {
    coords = vector4(1184.92, -3108.2, 5.04, 6.32),
    model = 'A_M_M_StLat_02',
    scenario = 'WORLD_HUMAN_CLIPBOARD_FACILITY',
}

Config.StoragePrice = 1000

Config.Levels = {                                                   -- Max 10 levels by default (you can change it in the code, only change it if you know what are you doing!)
    [1] = {
        inside = vector4(1087.5791, -3099.4136, -39.0000, 272.2493),
        management = vector3(1088.4, -3101.28, -39.0),
        upgradePrice = 5000,
        sellPrice = 800,
        storages = {
            {
                coords = vector3(1096.32, -3098.52, -39.0),
                slots = 10,
                weight = 10000,
            }
        }
    },
    [2] = {
        inside = vector4(1087.5791, -3099.4136, -39.0000, 272.2493),
        management = vector3(1088.4, -3101.28, -39.0),
        upgradePrice = 5000,
        sellPrice = 4000,
        storages = {
            {
                coords = vector3(1096.32, -3098.52, -39.0),
                slots = 10,
                weight = 10000,
            },
            {
                coords = vector3(1102.56, -3098.4, -39.0),
                slots = 10,
                weight = 10000,
            }
        }
    },
    [3] = {
        inside = vector4(1087.5791, -3099.4136, -39.0000, 272.2493),
        management = vector3(1088.4, -3101.28, -39.0),
        upgradePrice = 5000,
        sellPrice = 8000,
        storages = {
            {
                coords = vector3(1096.32, -3098.52, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1102.56, -3098.4, -39.0),
                slots = 10,
                weight = 10000,
            }
        }
    },
    [4] = {
        inside = vector4(1048.48, -3097.2, -39.0, 273.04),
        management = vector3(1049.24, -3101.6, -39.0),
        upgradePrice = 5000,
        sellPrice = 12000,
        storages = {
            {
                coords = vector3(1056.76, -3097.36, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1056.8, -3107.8, -39.0),
                slots = 20,
                weight = 20000,
            }
        }
    },
    [5] = {
        inside = vector4(1048.48, -3097.2, -39.0, 273.04),
        management = vector3(1049.24, -3101.6, -39.0),
        upgradePrice = 5000,
        sellPrice = 18000,
        storages = {
            {
                coords = vector3(1056.76, -3097.36, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1056.8, -3107.8, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1065.2, -3108.12, -39.0),
                slots = 10,
                weight = 10000,
            }
        }
    },
    [6] = {
        inside = vector4(1048.48, -3097.2, -39.0, 273.04),
        management = vector3(1049.24, -3101.6, -39.0),
        upgradePrice = 5000,
        sellPrice = 24000,
        storages = {
            {
                coords = vector3(1056.76, -3097.36, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1056.8, -3107.8, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1065.2, -3108.12, -39.0),
                slots = 10,
                weight = 10000,
            },
            {
                coords = vector3(1065.16, -3097.32, -39.0),
                slots = 10,
                weight = 10000,
            }
        }
    },
    [7] = {
        inside = vector4(997.84, -3092.0, -39.0, 266.56),
        management = vector3(994.64, -3100.0, -39.0),
        upgradePrice = 5000,
        sellPrice = 30000,
        storages = {
            {
                coords = vector3(1006.12, -3093.48, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1015.44, -3093.28, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1015.92, -3100.92, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1005.88, -3101.04, -39.0),
                slots = 10,
                weight = 10000,
            },
            {
                coords = vector3(1006.12, -3106.72, -39.0),
                slots = 10,
                weight = 10000,
            }
        }
    },
    [8] = {
        inside = vector4(997.84, -3092.0, -39.0, 266.56),
        management = vector3(994.64, -3100.0, -39.0),
        upgradePrice = 5000,
        sellPrice = 36000,
        storages = {
            {
                coords = vector3(1006.12, -3093.48, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1015.44, -3093.28, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1015.92, -3100.92, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1005.88, -3101.04, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1006.12, -3106.72, -39.0),
                slots = 10,
                weight = 10000,
            },
            {
                coords = vector3(1015.72, -3106.68, -39.0),
                slots = 10,
                weight = 10000
            }
        }
    },
    [9] = {
        inside = vector4(997.84, -3092.0, -39.0, 266.56),
        management = vector3(994.64, -3100.0, -39.0),
        upgradePrice = 5000,
        sellPrice = 41000,
        storages = {
            {
                coords = vector3(1006.12, -3093.48, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1015.44, -3093.28, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1015.92, -3100.92, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1005.88, -3101.04, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1006.12, -3106.72, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1015.72, -3106.68, -39.0),
                slots = 10,
                weight = 10000
            }
        }
    },
    [10] = {
        inside = vector4(997.84, -3092.0, -39.0, 266.56),
        management = vector3(994.64, -3100.0, -39.0),
        upgradePrice = 5000,
        sellPrice = 47000,
        storages = {
            {
                coords = vector3(1006.12, -3093.48, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1015.44, -3093.28, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1015.92, -3100.92, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1005.88, -3101.04, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1006.12, -3106.72, -39.0),
                slots = 20,
                weight = 20000,
            },
            {
                coords = vector3(1015.72, -3106.68, -39.0),
                slots = 20,
                weight = 20000
            }
        }
    },
}

function Notify(title, description, ntype)
    lib.notify({
        title = title,
        description = description,
        type = ntype
    })
end

Config.Debug = {
    zoneDebug = false,
    dataBase = false,
    server = false
}