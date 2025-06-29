RegisterServerEvent('rpx-doctorjob:server:revive', function(target)
    local src = tonumber(source)
    local char = RPX.GetPlayer(src)
    if not char then return end
    if exports['rpx-core']:HasJobPermission(char.job.name, char.job.rank, "doctor:general") then
        TriggerClientEvent('redemrp_respawn:gotRevive', target)
    end
end)

RegisterServerEvent('rpx-doctorjob:server:heal', function(target)
    local src = tonumber(source)
    local char = RPX.GetPlayer(src)
    if not char then return end
    if exports['rpx-core']:HasJobPermission(char.job.name, char.job.rank, "doctor:general") then
        TriggerClientEvent('rpx-doctorjob:client:heal', target)
    end
end)

RegisterServerEvent('rpx-doctorjob:server:drag', function(target)
    local src = tonumber(source)
    local char = RPX.GetPlayer(src)
    if not char then return end
    if exports['rpx-core']:HasJobPermission(char.job.name, char.job.rank, "doctor:general") then
        TriggerClientEvent('rpx-doctorjob:client:drag', target, src)
    end
end)
