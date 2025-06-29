Config = {}

Config.Shops = {
    [1] = { -- Job name
        label = 'StDenis Pharmacy',
        stashid = 'st-denis-pharmacy',
        jobname = 'doctor',
        blip = {
            enabled = true,
            coords = vec3(2721.3461, -1232.08, 50.36779),
            sprite = `blip_shop_doctor`,
            string = 'StDenis Pharmacy'
        },
        locations = {
            stash = {
                string = '[E] - Stock Shop',
                coords = vec3(2721.3461, -1232.08, 50.36779),
                range = 1.0
            },
            shop = {
                string = '[E] - Access Shop',
                coords = vec3(2719.3762, -1231.563, 50.367115),
                range = 1.0
            }
        }
    },
}

Strings = {
    sell_price = 'Sell Price',
    amount_input = 'Amount',
    inventory = 'Inventory',
    success = 'Success',
    item_stocked_desc = 'You stocked an item for $%s!',
}