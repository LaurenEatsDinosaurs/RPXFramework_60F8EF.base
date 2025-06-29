local ShopOpen = false
local CurrentShop = nil
local ShopkeepPeds = {}

local function CloseShop()
    SendNUIMessage({ action = 'CLOSE_SHOP' })
    SetNuiFocus(false, false)
    ClearPedTasks(PlayerPedId())
    ShopOpen = false
    CurrentShop = nil
end

local function OpenShop(id)
    local shopData = Config.Shops[id]
    ShopOpen = true
    CurrentShop = id

    local walkto = shopData.walkto
    local lowestdist = 999
    local walktopos = nil
    for k,v in pairs(shopData.walkto) do
        local v3 = vector3(v.x, v.y, v.z)
        if(#(GetEntityCoords(PlayerPedId()) - v3) < lowestdist) then
            lowestdist = #(GetEntityCoords(PlayerPedId()) - v3)
            walktopos = v
        end
    end
    TaskGoToCoordAnyMeans(PlayerPedId(), walktopos.x, walktopos.y, walktopos.z, 1.0, 0.0, false, 0.0)
    while GetScriptTaskStatus(PlayerPedId(), 0x93399E79) ~= 8 do
        Citizen.Wait(0)
    end
    Wait(500)
    SetEntityCoords(PlayerPedId(), walktopos.x, walktopos.y, walktopos.z - 1.0)
    SetEntityHeading(PlayerPedId(), walktopos.w)
    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_SHOP_BROWSE_COUNTER'), 0, 1, 0)
    
    SendNUIMessage({ action = 'OPEN_SHOP', data = shopData })
    SetNuiFocus(true, true)
end

--@thread: main
--@description: Main thread for the shops resource.
Citizen.CreateThread(function()
    for id, shop in pairs(Config.Shops) do
        if not Config.ThirdEye then
            exports['rpx-core']:createPrompt('rpx_shop_'..id, shop.coords, 0xF3830D8E, 'Open ' .. shop.name, {
                func = function()
                    OpenShop(id)
                end
            })
        end
        if shop.showblip == true then
            shop.StoreBlip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, shop.coords)
            SetBlipSprite(shop.StoreBlip, GetHashKey('blip_shop_market_stall'), 52)
            SetBlipScale(shop.StoreBlip, 0.2)
        end
    end
end)

--@thread: SpawnShopKeeps
--@description: Spawns the shop keeps for the shops.
CreateThread(function()
    if Config.SpawnShopKeeps or Config.ThirdEye then
        for id, shop in pairs(Config.Shops) do
            local model = GetHashKey(Config.ShopKeepModel)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            local ped = CreatePed(model, shop.shopkeep.x, shop.shopkeep.y, shop.shopkeep.z-1.0, shop.shopkeep.w, false, true)
            Wait(1)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetPedCanPlayAmbientAnims(ped, true)
            SetPedCanRagdollFromPlayerImpact(ped, false)
            SetEntityInvincible(ped, true)
            SetPedFleeAttributes(ped, 0, false)
            FreezeEntityPosition(ped, true)
            SetRandomOutfitVariation(ped, true)
    
            if Config.ThirdEye then
                local menuItems = {
                    {
                        name = 'Open Shop',
                        label = 'Open Shop',
                        onSelect = function(targetData,itemData)
                            OpenShop(id)
                        end,
                    },
                }
    
                exports[Config.TargetResource]:addLocalEnt('rpx_shop_target_'..ped, shop.name, 'fas fa-dollar', ped, 2.0, false, menuItems,{})
            end
            table.insert(ShopkeepPeds, ped)
        end
    end
end)

--@event: onResourceStop
--@description: Destructs the shops resource.
AddEventHandler('onResourceStop', function(resName)
    if resName ~= GetCurrentResourceName() then
        return
    end
    -- Destruct logic here.
    for _,ent in pairs(ShopkeepPeds) do
        SetEntityAsMissionEntity(ent, true, true)
        DeleteEntity(ent)
        if Config.ThirdEye then
            exports[Config.TargetResource]:removeTarget('rpx_shop_target_'..ent)
        end
    end
    for id, shop in pairs(Config.Shops) do
        if not Config.ThirdEye then
            exports['rpx-core']:deletePrompt('rpx_shop_'..id)
        end
        if shop.showblip == true then
            RemoveBlip(shop.StoreBlip)
        end
    end
end)

RegisterNetEvent("RPXShops:CLIENT:PurchaseItem", function()
    Citizen.InvokeNative(0x0F2A2175734926D8, "PURCHASE", "Ledger_Sounds")   -- load sound frontend
    Citizen.InvokeNative(0x67C540AA08E4A6F5, "PURCHASE", "Ledger_Sounds", true, 0)  -- play sound frontend
end)

--@NUICallback: CloseNUI
--@description: Closes the shop menu.
RegisterNUICallback('CloseNUI', function(data, cb)
    CloseShop()
    cb('ok')
end)

--@NUICallback: PurchaseItem
--@description: Purchases an item from the shop.
RegisterNUICallback('PurchaseItem', function(data, cb)
    TriggerServerEvent("RPXShops:SERVER:PurchaseItem", CurrentShop, data.item, data.amount)
    cb('ok')
end)

GetScriptTaskStatus = function(...)
    return Citizen.InvokeNative(0x77F1BEB8863288D5, ...)
end

SetRandomOutfitVariation = function(...)
	Citizen.InvokeNative(0x283978A15512B2FE, ...)
end