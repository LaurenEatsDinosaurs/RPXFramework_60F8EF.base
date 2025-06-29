RPX = exports['rpx-core']:GetObject()

--@NetEvent: rpx-banking:Server:Transact
--@description: This event is called by a client when a player is trying to transact money.
RegisterNetEvent("rpx-banking:Server:Transact", function(type, amount)
    local src = source
    local player = RPX.GetPlayer(src)
    amount = tonumber(amount)
    if amount <= 0 then
        lib.notify(src, {title = "Invalid amount.", type = "error"})
        return
    end
    if type == 1 then
        if player.money.bank >= amount then
            player.RemoveMoney('bank', amount)
            player.AddMoney('cash', amount)
        else
            lib.notify(src, {title = "Insufficient funds.", type = "error"})
        end
    elseif type == 2 then
        if player.money.cash >= amount then
            player.RemoveMoney('cash', amount)
            player.AddMoney('bank', amount)
        else
            lib.notify(src, {title = "Insufficient funds.", type = "error"})
        end
    end
end)