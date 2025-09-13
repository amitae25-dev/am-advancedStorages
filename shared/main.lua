Config = {}

Config.DefaultSettings = {
    useTarget = true,
    parkIn = {
        enabled = true,
        enterPos = vector4(1189.4525, -3106.6699, 5.5906, 0.7470)
    }
}

Config.Blip = {
    showBlip = true,
    blipModel = 50,
    blipScale = 0.8,
    blipColor = 21,
    blipLabel = 'Warehouses'
}

Config.NPC = {
    coords = vector4(1184.92, -3108.2, 5.04, 6.32),
    model = 'A_M_M_StLat_02',
    scenario = 'WORLD_HUMAN_CLIPBOARD_FACILITY',                    -- Set to false if you dont want the NPC to do any scenario
}
--[[                Work in progress
Config.RobberyNPC = {
    coords = vector4(1070.1742, -2372.7656, 29.5969, 199.5699),
    model = 'U_M_M_JewelThief',
    scenario = false
}

Config.Robbery = {
    enabled = true,
    requiredItem = {
        itemName = 'WEAPON_CROWBAR',
        itemCount = 1,
        removeOnUser = true
    },
    canRob = {
        minLevel = 1                                               -- If warehouse reached this level, robbers can rob that specific warehouse
    }
}]]

Config.StoragePrice = 1000

Config.Levels = {                                                   -- Max 10 levels by default (you can change it in the code, only change it if you know what are you doing!)
    [1] = {
        inside = vector4(1087.5791, -3099.4136, -39.0000, 272.2493),
        management = vector4(1088.3536, -3101.2981, -39.0000, 96.1188),
        parkIn = false,
        upgradePrice = 5000,
        sellPrice = 800,
        storages = {
            {
                coords = vector3(1096.32, -3098.52, -39.0),
                slots = 10,
                weight = 10000,
                object = `xm_prop_rsply_crate04a`,
            }
        }
    },
    [2] = {
        inside = vector4(1087.5791, -3099.4136, -39.0000, 272.2493),
        management = vector4(1088.3536, -3101.2981, -39.0000, 89.1188),
        parkIn = false,
        upgradePrice = 5000,
        sellPrice = 4000,
        storages = {
            {
                coords = vector3(1096.32, -3098.52, -39.0),
                slots = 10,
                weight = 10000,
                object = `xm_prop_rsply_crate04a`,
            },
            {
                coords = vector3(1102.56, -3098.4, -39.0),
                slots = 10,
                weight = 10000,
                object = `xm_prop_rsply_crate04a`,
            }
        }
    },
    [3] = {
        inside = vector4(1087.5791, -3099.4136, -39.0000, 272.2493),
        management = vector4(1088.3536, -3101.2981, -39.0000, 89.1188),
        parkIn = false,
        upgradePrice = 5000,
        sellPrice = 8000,
        storages = {
            {
                coords = vector3(1096.32, -3098.52, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1102.56, -3098.4, -39.0),
                slots = 10,
                weight = 10000,
                object = `xm_prop_rsply_crate04a`,
            }
        }
    },
    [4] = {
        inside = vector4(1048.48, -3097.2, -39.0, 273.04),
        management = vector4(1048.9535, -3100.7112, -39.0000, 91.3417),
        parkIn = vector4(1071.2435, -3101.8140, -39.0000, 180.3704),
        upgradePrice = 5000,
        sellPrice = 12000,
        storages = {
            {
                coords = vector3(1056.76, -3097.36, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1056.8, -3107.8, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            }
        }
    },
    [5] = {
        inside = vector4(1048.48, -3097.2, -39.0, 273.04),
        management = vector4(1048.9535, -3100.7112, -39.0000, 91.3417),
        parkIn = vector4(1071.2435, -3101.8140, -39.0000, 180.3704),
        upgradePrice = 5000,
        sellPrice = 18000,
        storages = {
            {
                coords = vector3(1056.76, -3097.36, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1056.8, -3107.8, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1065.2, -3108.12, -39.0),
                slots = 10,
                weight = 10000,
                object = `xm_prop_rsply_crate04a`,
            }
        }
    },
    [6] = {
        inside = vector4(1048.48, -3097.2, -39.0, 273.04),
        management = vector4(1048.9535, -3100.7112, -39.0000, 91.3417),
        parkIn = vector4(1071.2435, -3101.8140, -39.0000, 180.3704),
        upgradePrice = 5000,
        sellPrice = 24000,
        storages = {
            {
                coords = vector3(1056.76, -3097.36, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1056.8, -3107.8, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1065.2, -3108.12, -39.0),
                slots = 10,
                weight = 10000,
                object = `xm_prop_rsply_crate04a`,
            },
            {
                coords = vector3(1065.16, -3097.32, -39.0),
                slots = 10,
                weight = 10000,
                object = `xm_prop_rsply_crate04a`,
            }
        }
    },
    [7] = {
        inside = vector4(997.84, -3092.0, -39.0, 266.56),
        management = vector4(994.4815, -3100.0662, -38.9959, 266.1508),
        parkIn = vector4(1024.3523, -3101.5586, -38.9999, 88.2186),
        upgradePrice = 5000,
        sellPrice = 30000,
        storages = {
            {
                coords = vector3(1006.12, -3093.48, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1015.44, -3093.28, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1015.92, -3100.92, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1005.88, -3101.04, -39.0),
                slots = 10,
                weight = 10000,
                object = `xm_prop_rsply_crate04a`,
            },
            {
                coords = vector3(1006.12, -3106.72, -39.0),
                slots = 10,
                weight = 10000,
                object = `xm_prop_rsply_crate04a`,
            }
        }
    },
    [8] = {
        inside = vector4(997.84, -3092.0, -39.0, 266.56),
        management = vector4(994.4815, -3100.0662, -38.9959, 266.1508),
        parkIn = vector4(1024.3523, -3101.5586, -38.9999, 88.2186),
        upgradePrice = 5000,
        sellPrice = 36000,
        storages = {
            {
                coords = vector3(1006.12, -3093.48, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1015.44, -3093.28, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1015.92, -3100.92, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1005.88, -3101.04, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1006.12, -3106.72, -39.0),
                slots = 10,
                weight = 10000,
                object = `xm_prop_rsply_crate04a`,
            },
            {
                coords = vector3(1015.72, -3106.68, -39.0),
                slots = 10,
                weight = 10000,
                object = `xm_prop_rsply_crate04a`,
            }
        }
    },
    [9] = {
        inside = vector4(997.84, -3092.0, -39.0, 266.56),
        management = vector4(994.4815, -3100.0662, -38.9959, 266.1508),
        parkIn = vector4(1024.3523, -3101.5586, -38.9999, 88.2186),
        upgradePrice = 5000,
        sellPrice = 41000,
        storages = {
            {
                coords = vector3(1006.12, -3093.48, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1015.44, -3093.28, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1015.92, -3100.92, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1005.88, -3101.04, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1006.12, -3106.72, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1015.72, -3106.68, -39.0),
                slots = 10,
                weight = 10000,
                object = `xm_prop_rsply_crate04a`,
            }
        }
    },
    [10] = {
        inside = vector4(997.84, -3092.0, -39.0, 266.56),
        management = vector3(994.64, -3100.0, -39.0),
        parkIn = vector4(1024.3523, -3101.5586, -38.9999, 88.2186),
        upgradePrice = 5000,
        sellPrice = 47000,
        storages = {
            {
                coords = vector3(1006.12, -3093.48, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1015.44, -3093.28, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1015.92, -3100.92, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1005.88, -3101.04, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1006.12, -3106.72, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
            },
            {
                coords = vector3(1015.72, -3106.68, -39.0),
                slots = 20,
                weight = 20000,
                object = `m23_1_prop_m31_crate_04b`,
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
