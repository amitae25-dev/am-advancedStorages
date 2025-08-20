CreateThread(function()
    Wait(2000)
    InitTarget()
end)

exports("am_storages:isPlayerInside", isPlayerInside())
exports("am_storages:playerHasWarehouse", playerHasWarehouse())
export("am_storages:warehouseLevel", warehouseLevel())

