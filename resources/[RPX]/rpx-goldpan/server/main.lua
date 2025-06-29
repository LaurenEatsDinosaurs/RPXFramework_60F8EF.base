local RPX = exports["rpx-core"]:GetObject()

RegisterServerEvent("rpx-goldpan:server:TryGoldpan", function(districtChance, districtChance2)
    local src = source
    local Player = RPX.GetPlayer(src)
    if Player then
        local rewardChance = math.random(1, 12)
        if rewardChance <= districtChance then
            local amountChance = math.random(1,10)
            local amount = 1
            if amountChance <= districtChance2 then                
                amount = 2
            end

            exports['rpx-inventory']:AddItem(src, 'goldnugget', tonumber(amount))
        else
            lib.notify(src, {title = "No gold!", description = "You found nothing!", type = "error"})	
        end
    end
end)