local swapHooks, createHooks = {}, {}

CreateThread(function()
	while GetResourceState('rpx-inventory') ~= 'started' do Wait(1000) end
	for k,v in pairs(Config.Shops) do
		local stash = {
			id = v.stashid,
			label = v.label..' '..Strings.inventory,
			slots = 50,
			weight = 100000,
		}
		exports['rpx-inventory']:RegisterStash(stash.id, stash.label, stash.slots, stash.weight)
		local items = exports['rpx-inventory']:GetInventoryItems(v.stashid, false)
		local stashItems = {}
		if items and items ~= {} then
			for k,v in pairs(items) do
				if v and v.name then
					stashItems[#stashItems + 1] = { name = v.name, metadata = v.metadata, count = v.count, price = (v.metadata.shopData.price or 0) }
				end
			end
			local x,y,z = table.unpack(v.locations.shop.coords)
			exports['rpx-inventory']:RegisterShop(v.stashid, {
				name = v.label,
				inventory = stashItems,
				locations = {
					vec3(x,y,z),
				}
			})
		end
		swapHooks[v.stashid] = exports['rpx-inventory']:registerHook('swapItems', function(payload)
			if payload.fromInventory == v.stashid then
				TriggerEvent('rpx-playershops:refreshShop', v.stashid)
			elseif payload.toInventory == v.stashid and tonumber(payload.fromInventory) ~= nil then
				TriggerClientEvent('rpx-playershops:setProductPrice', payload.fromInventory, v.stashid, payload.toSlot)
			end
		end, {})

		createHooks[v.stashid] = exports['rpx-inventory']:registerHook('createItem', function(payload)
		   local metadata = payload.metadata
			if metadata?.shopData then
				local price = metadata.shopData.price
				local count = payload.count
				exports['rpx-inventory']:RemoveItem(metadata.shopData.shop, payload.item.name, payload.count)
				--[[
				TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..metadata.shopData.shop, function(account)
					account.addMoney(price)
				end)]]
				print("Adding money to shop"..metadata.shopData.shop.." for "..price.." for "..count.." items.")
			end
		end, {})
	end
end)

RegisterServerEvent('rpx-playershops:refreshShop', function(shop)
	Wait(250)
	local items = exports['rpx-inventory']:GetInventoryItems(shop, false)
	local stashItems = {}
	for k,v in pairs(items) do
		if v and v.name then
			local metadata = v.metadata
			if metadata?.shopData then
				stashItems[#stashItems + 1] = { name = v.name, metadata = metadata, count = v.count, price = metadata.shopData.price }
			end
		end
	end
	exports['rpx-inventory']:RegisterShop(shop, {
		name = Config.Shops[shop].label,
		inventory = stashItems,
		locations = {
			Config.Shops[shop].locations.shop.coords,
		}
	})
end)

RegisterServerEvent('rpx-playershops:setData', function(shop, slot, price)
	local item = exports['rpx-inventory']:GetSlot(shop, slot)
	if not item then return end
	local metadata = item.metadata
	metadata.shopData = {
		shop = shop,
		price = price
	}
	exports['rpx-inventory']:SetMetadata(shop, slot, metadata)
	TriggerEvent('rpx-playershops:refreshShop', shop)
end)


AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then return end
	for i=1, #swapHooks do
		exports['rpx-inventory']:removeHooks(swapHooks[i])
	end
	for i=1, #createHooks do
		exports['rpx-inventory']:removeHooks(createHooks[i])
	end
end)
