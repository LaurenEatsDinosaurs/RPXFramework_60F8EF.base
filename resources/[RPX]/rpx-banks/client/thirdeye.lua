if Config.ThirdEye then
    exports[Config.TargetResource]:addInternalPoly('rpx_bank_stdenis', "Bank", "fas fa-university", {
        vector2(2647.6384277344, -1293.2053222656),
        vector2(2645.2390136719, -1292.3439941406),
        vector2(2643.2731933594, -1293.3292236328),
        vector2(2642.5109863281, -1295.6859130859),
        vector2(2643.5612792969, -1297.7524414063),
        vector2(2644.0202636719, -1296.9995117188),
        vector2(2643.3745117188, -1295.5194091797),
        vector2(2643.9299316406, -1293.9603271484),
        vector2(2645.4152832031, -1293.1954345703),
        vector2(2647.1162109375, -1293.8334960938),
    }, {
        name="rpx_bank_stdenis",
        minZ=50.0,
        maxZ=52.35,
        debugGrid=false,
        gridDivisions=25
    }, 2.0, function(t, o) TriggerEvent("rpx-banks:client:OpenBanking") end, {
        {
            name = "rpx_bank_stdenis",
            label = "Access Bank"
        }
    },{})

    -----------------------------------------------------------------------------------------------------

    exports[Config.TargetResource]:addInternalPoly('rpx_bank_bw', "Bank", "fas fa-university", {
        vector2(-814.57, -1276.87),
        vector2(-814.57, -1275.94),
        vector2(-810.25, -1275.90),
        vector2(-810.18, -1276.81),
    }, {
        name="rpx_bank_bw",
        minZ=42.0,
        maxZ=43.85,
        debugGrid=false,
        gridDivisions=25
    }, 2.5, function(t, o) TriggerEvent("rpx-banks:client:OpenBanking") end, {
        {
            name = "rpx_bank_bw",
            label = "Access Bank"
        }
    },{})

    -----------------------------------------------------------------------------------------------------
    exports[Config.TargetResource]:addInternalPoly('rpx_bank_armadillo', "Bank", "fas fa-university", {
        vector2(-3663.47, -2637.01),
        vector2(-3663.47, -2626.47),
        vector2(-3668.63, -2626.47),
        vector2(-3668.75, -2626.99),
    }, {
        name="rpx_bank_armadillo",
        minZ=-14.59,
        maxZ=-13.22,
        debugGrid=false,
        gridDivisions=25
    }, 2.5, function(t, o) TriggerEvent("rpx-banks:client:OpenBanking") end, {
        {
            name = "rpx_bank_armadillo",
            label = "Access Bank"
        }
    },{})

    -----------------------------------------------------------------------------------------------------

    exports[Config.TargetResource]:addInternalPoly('rpx_bank_rhodes', "Bank", "fas fa-university", {
        vector2(1295.14, -1304.75),
        vector2(1294.54, -1305.49),
        vector2(1291.10, -1302.63),
        vector2(1291.78, -1301.72),
    }, {
        name="rpx_bank_rhodes",
        minZ=76.04,
        maxZ=78.04,
        debugGrid=false,
        gridDivisions=25
    }, 2.5, function(t, o) TriggerEvent("rpx-banks:client:OpenBanking") end, {
        {
            name = "rpx_bank_rhodes",
            label = "Access Bank"
        }
    },{})

    -----------------------------------------------------------------------------------------------------

    exports[Config.TargetResource]:addInternalPoly('rpx_bank_valentine', "Bank", "fas fa-university", {
        vector2(-303.49951171875, 771.72448730469),
        vector2(-303.9140625, 773.81536865234),
        vector2(-306.73550415039, 775.75921630859),
        vector2(-310.63687133789, 774.9853515625),
        vector2(-309.39544677734, 774.27404785156),
        vector2(-306.94345092773, 774.63403320313),
        vector2(-304.81903076172, 773.18505859375),
        vector2(-304.5426940918, 771.54541015625),
    }, {
        name="rpx_bank_valentine",
        minZ=116.70,
        maxZ=119.09,
        debugGrid=false,
        gridDivisions=25
    }, 2.5, function(t, o) TriggerEvent("rpx-banks:client:OpenBanking") end, {
        {
            name = "rpx_bank_valentine",
            label = "Access Bank"
        }
    },{})
end