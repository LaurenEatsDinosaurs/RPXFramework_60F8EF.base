math.randomseed(GetGameTimer())
local CancelPrompt
local PanPrompt
local GoldPanning = false
local SearchingForGold = false
local Prop = nil

local GoldPanPromptGroup = GetRandomIntInRange(0, 0xffffff)
local GoldPanningPromptName = CreateVarString(10, "LITERAL_STRING", "Gold Panning")

Citizen.CreateThread(function()
    local str = 'Pan'
    PanPrompt = PromptRegisterBegin()
    PromptSetControlAction(PanPrompt, 0x5181713D)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(PanPrompt, str)
    PromptSetEnabled(PanPrompt, true)
    PromptSetVisible(PanPrompt, true)
    PromptSetHoldMode(PanPrompt, false)
    PromptSetGroup(PanPrompt, GoldPanPromptGroup)
    PromptRegisterEnd(PanPrompt)

    str = 'Cancel'
    CancelPrompt = PromptRegisterBegin()
    PromptSetControlAction(CancelPrompt, 0x8E90C7BB)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(CancelPrompt, str)
    PromptSetEnabled(CancelPrompt, true)
    PromptSetVisible(CancelPrompt, true)
    PromptSetHoldMode(CancelPrompt, true)
    PromptSetGroup(CancelPrompt, GoldPanPromptGroup)
    PromptRegisterEnd(CancelPrompt)
end)

function EnablePanningMode()
    GoldPanning = true
    SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
    if not Prop then
        local playerPed = PlayerPedId()
        local pc = GetEntityCoords(playerPed)
        local pname = 's_miningpan01x'
        RequestAnimDict("SCRIPT_RE@GOLD_PANNER@GOLD_SUCCESS")
        while not HasAnimDictLoaded("SCRIPT_RE@GOLD_PANNER@GOLD_SUCCESS") do
            Citizen.Wait(50)
        end
        if IsPedMale(playerPed) then
            Prop = CreateObject(GetHashKey(pname), pc.x, pc.y, pc.z + 0.2, true, true, true)
            AttachEntityToEntity(Prop, playerPed, GetEntityBoneIndexByName(playerPed, "SKEL_R_Finger12"), 0.150, -0.03, 0.010, 90.0, -60.0, -30.0, true, true, false, true, 1, true)
        else
            Prop = CreateObject(GetHashKey(pname), pc.x, pc.y, pc.z + 0.2, true, true, true)
            AttachEntityToEntity(Prop, playerPed, 387, 0.150, -0.03, 0.010, 90.0, -60.0, -30.0, true, true, false, true, 1, true)
        end
        lib.notify({title = "Gold panning mode enabled!", type = "inform"})	
    end
end
exports('EnablePanningMode', EnablePanningMode)

function StartGoldpan()
    SearchingForGold = true
    local success = lib.skillCheck({'easy', 'easy'}, {'1', '2', '3', '4'})
    if not success then IsActive = false ; SearchingForGold = false ; return end
   
    IsActive = true
    local playerPed = PlayerPedId()
    for k,v in pairs(Config.GoldPanAnimations) do
        TaskPlayAnim(playerPed, "SCRIPT_RE@GOLD_PANNER@GOLD_SUCCESS", v, 8.0, -8.0, -1, 1, 0, true)
        Citizen.Wait(3000)
    end
    ClearPedTasks(playerPed)
    local x, y, z =  table.unpack(GetEntityCoords(playerPed))

    local current_district = Citizen.InvokeNative(0x43AD8FC02B429D33, x, y, z, 10)
    if current_district then
        if Config.DistrictChances[current_district] then
            if not Config.DistrictChances[current_district].chanceToGet then
                lib.notify({title = "No gold!", description = "You found nothing!", type = "error"})	
            else
                TriggerServerEvent("rpx-goldpan:server:TryGoldpan", Config.DistrictChances[current_district].chanceToGet, Config.DistrictChances[current_district].chanceOfTwo)
            end
        else
            lib.notify({title = "No gold!", description = "You found nothing!", type = "error"})	
        end
    end
    IsActive = false

    SearchingForGold = false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if GoldPanning then
            PromptSetActiveGroupThisFrame(GoldPanPromptGroup, GoldPanningPromptName)
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
            RemoveAllPedWeapons(PlayerPedId(), true)

            if IsControlJustReleased(0, 0x5181713D) and not SearchingForGold then
                if IsEntityInWater(PlayerPedId()) then
                    StartGoldpan()
                else
                    lib.notify({title = "Not in water!", description = "You must be in water to pan for gold!", type = "error"})	
                end
            end

            if PromptHasHoldModeCompleted(CancelPrompt) and not SearchingForGold then
                GoldPanning = false
                DeleteEntity(Prop)
                Prop = nil
                lib.notify({title = "Gold panning mode disabled!", type = "inform"})	
            end
        end
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    if Prop then if DoesEntityExist(Prop) then DeleteEntity(Prop) end end
    PromptDelete(PanPrompt)
    PromptDelete(CancelPrompt)
end)