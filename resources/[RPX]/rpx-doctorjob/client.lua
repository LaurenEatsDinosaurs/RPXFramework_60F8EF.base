local dragStatus = { isDragged = false }
local DoctorBlips = {}

RegisterNetEvent("rpx-doctorjob:client:DoctorAction", function(action)
    local closestPlayer, closestDistance = exports['rpx-core']:GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        action = action[1]
        if not Citizen.InvokeNative(0x3AA24CCC0D451379, PlayerPedId()) then
            if not LocalPlayer.state.isDead then
                if action == "revive" then
                    TriggerServerEvent("rpx-doctorjob:server:revive", GetPlayerServerId(closestPlayer))
                elseif action == "drag" then
                    TriggerServerEvent('rpx-doctorjob:server:drag', GetPlayerServerId(closestPlayer))
                end
            else
                lib.notify({title = "You can't do this right now!", type = "error" })
            end
        else
            lib.notify({title = "You can't do this right now!", type = "error" })
        end
    else
        lib.notify({title = "Can't Find", description = "No players nearby!", type = "error" })
    end
end)

Citizen.CreateThread(function()
    for _, station in pairs(Config.Stations) do
        local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, station.x, station.y, station.z)
        SetBlipSprite(blip, 1047294027, 1)
        SetBlipScale(blip, 1.5)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, station.label)
        Citizen.InvokeNative(0x662D364ABF16DE2F, blip, GetHashKey("BLIP_MODIFIER_MP_COLOR_13"))
        DoctorBlips[#DoctorBlips+1] = blip
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    for _, blip in pairs(DoctorBlips) do
        RemoveBlip(blip)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if dragStatus.isDragged then
            if dragStatus.DoctorId ~= nil then
                local targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.DoctorId))
                AttachEntityToEntity(PlayerPedId(),	targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                if IsPedDeadOrDying(targetPed, true) then
                    dragStatus.isDragged = false
                    DetachEntity(PlayerPedId(), true, false)
                end
            end
        end
    end
end)

RegisterNetEvent('rpx-doctorjob:client:drag', function(doctorId)
    dragStatus.isDragged = not dragStatus.isDragged
    dragStatus.DoctorId = doctorId
    if dragStatus.isDragged then
        lib.notify({ title = "You are being escorted!", type = "inform" })
    else
        lib.notify({ title = "You are no longer being escorted!", type = "inform" })
        DetachEntity(PlayerPedId(), true, false)
    end
end)