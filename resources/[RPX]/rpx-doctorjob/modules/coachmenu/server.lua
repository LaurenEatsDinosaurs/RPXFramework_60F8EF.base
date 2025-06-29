RegisterServerEvent("rpx-doctorjob:server:RequestCoachMenu", function()
    local src = source
    local char = RPX.GetPlayer(src)
    if not char then return end
    if exports['rpx-core']:HasJobPermission(char.job.name, char.job.rank, "doctor:general") then
        TriggerClientEvent("rpx-doctorjob:client:CoachMenu", src)
    end
end)