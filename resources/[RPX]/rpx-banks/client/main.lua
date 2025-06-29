local BankOpen = false
local BankBlips = {}

local OpenBank = function()
    DisplayRadar(false)
    DisplayHud(false)
    SendNUIMessage({action = "OPEN_BANK", balance = LocalPlayer.state.money.bank})
    SetNuiFocus(true, true)
    BankOpen = true
    Citizen.InvokeNative(0xFA08722A5EA82DA7, 'RespawnLight')   	-- SET_TIMECYCLE_MODIFIER
    for i=0, 10 do Citizen.InvokeNative(0xFDB74C9CC54C3F37, 0.1 + (i / 10)); Wait(10) end	-- SET_TIMECYCLE_MODIFIER_STRENGTHs
end

local CloseBank = function()
    SendNUIMessage({action = "CLOSE_BANK"})
    SetNuiFocus(false, false)
    BankOpen = false
    for i=1, 10 do Citizen.InvokeNative(0xFDB74C9CC54C3F37, 1.0 - (i / 10)); Wait(15) end	-- SET_TIMECYCLE_MODIFIER_STRENGTHs
    Citizen.InvokeNative(0x0E3F4AF2D63491FB)
    DisplayRadar(true)
    DisplayHud(true)
end

CreateThread(function()
    for id, bank in pairs(Config.Banks) do
        local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, bank)
        SetBlipSprite(blip, GetHashKey('blip_proc_bank'), 52)
        SetBlipScale(blip, 0.2)
        BankBlips[id] = blip
        
        if not Config.ThirdEye then
            exports['rpx-core']:createPrompt('rpx_bank_'..id, bank, 0xF3830D8E, 'Access Bank', {
                func = function()
                    OpenBank()
                end
            })
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end

    for id, bank in pairs(Config.Banks) do
        if Config.ThirdEye then
            exports['meta_target']:removeTarget('rpx_bank_stdenis')
            exports['meta_target']:removeTarget('rpx_bank_bw')
            exports['meta_target']:removeTarget('rpx_bank_armadillo')
            exports['meta_target']:removeTarget('rpx_bank_rhodes')
            exports['meta_target']:removeTarget('rpx_bank_valentine')
        else
            exports['rpx-core']:deletePrompt('rpx_bank_'..id)
        end

        RemoveBlip(BankBlips[id])
    end
end)

RegisterNUICallback('CloseNUI', function()
    CloseBank()
end)

RegisterNUICallback('Transact', function(data)
    TriggerServerEvent('rpx-banking:Server:Transact', data.type, data.amount)
end)

AddStateBagChangeHandler("bank", nil, function(bagName, key, value) 
    if GetPlayerFromStateBagName(bagName) ~= PlayerId() then return end
    if not BankOpen then return end
    SendNUIMessage({action = "UPDATE_BALANCE", balance = value})
end)

AddEventHandler("rpx-banks:client:OpenBanking", function()
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    for id, bank in pairs(Config.Banks) do
        if #(PlayerCoords - bank) < 5.0 then
            OpenBank()
            return
        end
    end
end)