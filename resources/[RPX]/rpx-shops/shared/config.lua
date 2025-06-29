Config = {}

Config.ShopKeepModel = "u_m_m_sdexoticsshopkeeper_01"

Config.SpawnShopKeeps = true
Config.ThirdEye = true -- SpawnShopKeeps must be true for this, as the Shopkeep peds are the third eye targets.
Config.TargetResource = 'meta_target'

Config.Shops = {
    --[[
    {
        name = "Test Shop",
        showblip = true,
        coords = vector3(-322.3016, 803.86138, 117.88165),
        shopkeep = vector4(-324.245, 804.09722, 117.88165, 281.58432),
        walkto = {
            vector4(-323.2645568847656, 801.6615600585938, 117.88164520263672, 12.75),
            vector4(-322.7241, 801.79364, 117.88164, 9.9752063),
            vector4(-322.1096, 802.77014, 117.88164, 91.673744),
            vector4(-322.4897, 804.9035, 117.88165, 105.04376),
        },
        items = {
            { name = "Bread", item = "bread", img = "bread.png", price = 1, amount = 1 },
            { name = "Water", item = "water", img = "water.png", price = 2, amount = 1 },
        },

    },
    ]]
}