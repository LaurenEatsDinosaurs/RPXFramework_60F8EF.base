RegisterNetEvent('rpx-playershops:setProductPrice', function(shop, slot)
    local input = lib.inputDialog(Strings.sell_price, {Strings.amount_input})
    local price
    if not input then price = 0 end
    ---@diagnostic disable-next-line: need-check-nil
    price = tonumber(input[1])
    if price < 0 then price = 0 end
    TriggerEvent('rpx-inventory:closeInventory')
    TriggerServerEvent('rpx-playershops:setData', shop, slot, math.floor(price --[[@as number]]))
    lib.notify({
        title = Strings.success,
        description = (Strings.item_stocked_desc):format(price),
        type = 'success'
    })
end)

local function createBlip(coords, sprite, color, text, scale)
    local x,y,z = table.unpack(coords)
    local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, x, y, z)
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, text)
    SetBlipSprite(blip, sprite)
    return blip
end

CreateThread(function()
    for _,v in pairs(Config.Shops) do
        if v.blip.enabled then
            createBlip(v.blip.coords, v.blip.sprite, v.blip.color, v.blip.string, v.blip.scale)
        end
    end
end)

CreateThread(function()
    local textUI = nil
    while true do
        local sleep = 1500
        local coords = GetEntityCoords(PlayerPedId())
        for k,v in pairs(Config.Shops) do
            local stashLoc = v.locations.stash.coords
            local shopLoc = v.locations.shop.coords
            local distStash = #(coords - stashLoc)
            local distShop = #(coords - shopLoc)

            if distStash <= v.locations.stash.range and LocalPlayer.state.job.name == v.jobname then
                if not textUI then
                    lib.showTextUI(v.locations.stash.string)
                    textUI = true
                end
                sleep = 0
                if IsControlJustReleased(0, `INPUT_ENTER`) then
                    exports['rpx-inventory']:openInventory('stash', v.stashid)
                end
            elseif distShop <= v.locations.shop.range then
                if not textUI then
                    lib.showTextUI(v.locations.shop.string)
                    textUI = true
                end
                sleep = 0
                if IsControlJustReleased(0, `INPUT_ENTER`) then
                    exports['rpx-inventory']:openInventory('shop', { type = v.stashid, id = 1 })
                end
            elseif textUI then
                lib.hideTextUI()
                textUI = nil
            end
        end
        Wait(sleep)
    end
end)