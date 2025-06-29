local ConditionsOpen = false

--Citizen.CreateThread(function()                                     --Button prompt for opening others' View Conditions menu--
--    local str = "View Conditions"
--    local conditionsPrompt = PromptRegisterBegin()
--    PromptSetControlAction(conditionsPrompt, 0xE3BF959B)            --Set control action to INPUT_CONTEXT_X ("R" key)--
--    str = CreateVarString(10, "LITERAL_STRING", str)
--    PromptSetText(conditionsPrompt, str)
--    PromptSetEnabled(conditionsPrompt, true)
--    PromptSetVisible(conditionsPrompt, true)
--    PromptSetHoldMode(conditionsPrompt, false)
--
--    --Make prompt appear on NPCs (Does not work yet :( --
--    Citizen.InvokeNative(0x870708A6E147A9AD,1,"View Conditions",10,10,conditionsPrompt,false)        -- REGISTER_INTERACTION_LOCKON_PROMPT--
--
--
--    local pedGroupId = PromptGetGroupIdForTargetEntity(entity)      --Gets the group ID for peds-- (Might be UIPromptGetGroupIdForTargetEntity)
--    PromptSetGroup(conditionsPrompt, pedGroupId)                    --Adds prompt to ped entity group, to have it show when entity is focused--
--    PromptSetTransportMode(conditionsPrompt, 0)                     --Prompt will show on foot, in vehicles, and on mounts
--
--    PromptRegisterEnd(conditionsPrompt)
--end)

-- ATTEMPT TWO - GET ALL PEDS AND COMPARE TARGET PED TO PEDLIST TO DECIDE WHETHER TO ENABLE PROMPT - TARGET DISPLAYS 0 ALWAYS
--Citizen.CreateThread(function()
--    local pedPoolConditions = GetGamePool("CPed")                                    -- Get the list of peds (entities) from the pool--
--    local viewConditionsPrompt = UiPromptCreate(0xE3BF959B, "View Conditions")
--    local target, targetEntity = GetPlayerInteractionTargetEntity(source)
--    print(target,targetEntity)
--
--    for i = 1, #pedPoolConditions do                                                 -- Loop through each ped (entity)--
--        if pedPoolConditions[i] == target then                                       -- If target is a ped or player--
--            UiPromptSetVisible(viewConditionsPrompt, true)
--        end
--    end
--end)

-- ATTEMPT THREE - STILL DOESN'T WORK; ALL NATIVES REGARDING TARGETING RETURN 0 REGARDLESS OF WHETHER I'M DOING NOTHING, "FOCUSING" ON AN ENTITY, OR AIMING AT THEM
--Citizen.CreateThread(function()
--    local targetingyesno = IsPlayerTargettingAnything(source)
--    local freeaimingyesno = IsPlayerFreeAiming(source)
--    local targetgroupID = UiPromptGetGroupIdForTargetEntity(source)
--    print("Targeting?", targetingyesno)                                                    -- Temp - For debugging
--    print("GroupID", targetgroupID)                                                        -- Temp - For debugging
--    print("Free aiming", freeaimingyesno)                                                  -- Temp - For debugging
--    while(IsPlayerTargettingAnything(Citizen.source) == true) do                           -- If the player is targeting something
--        print("Targeting something...")                                                    -- Temp - For debugging
--        local targetedPed
--        local viewConditionsPrompt
--        targetedPed = GetPlayerTargetEntity(source)                             
--        if(IsEntityAPed(targetedPed) == true) then                                 -- If that something is a Ped, set the UI prompt to visible
--            print("Targeting ped...")                                                      -- Temp - For debugging
--            print("Targeted ped is...",targetedPed)                                        -- Temp - For debugging
--            UiPromptSetVisible(viewConditionsPrompt, true)
--            print("UI should be visible now")                                              -- Temp - For debugging
--            Citizen.Wait(100)
--        end
--    end
--end)

-- AT THIS POINT I'D SAY FUCK IT AND PUT IT ON THE ALT-RIGHTCLICK "THIRD EYE" MENU EVEN THOUGH THAT WASN'T THE ORIGINAL VISION, BUT RPX DOESN'T HAVE IT FOR NORMAL NPCS, ONLY SHOP ONES

local OpenConditions = function()     -- Turns off radar and HUD, sends the OPEN_CONDITIONS action, and grabs each current condition type and condition--
    DisplayRadar(false)
    DisplayHud(false)
    SendNUIMessage({ 
        action = "OPEN_CONDITIONS",                                                         -- Opens Conditions Menu and sends each conditions and their type (might grab this at the other end instead)
        condition1type = "Visual",
        condition1 = "Looks like shit",
        condition2type = "Smell",
        condition2 = "Smells like shit",
        condition3type = "Health",
        condition3 = "In terrible condition",
        condition4type = "Visual",
        condition4 = "Looks even more like shit",
        condition5type = "Smell", 
        condition5 = "Smells like chocolate also somehow"})
    SetNuiFocus(true, true)                                                                 -- Focuses NUI and gives it the cursor
    ConditionsOpen = true
    Citizen.InvokeNative(0xFA08722A5EA82DA7, 'RespawnLight')   	                            -- SET_TIMECYCLE_MODIFIER
    for i=0, 10 do 
        Citizen.InvokeNative(0xFDB74C9CC54C3F37, 0.1 + (i / 10)); 
        Wait(10) 
    end	                                                                                    -- SET_TIMECYCLE_MODIFIER_STRENGTHs
end

local CloseConditions = function()
    SendNUIMessage({action = "CLOSE_CONDITIONS"})
    SetNuiFocus(false, false)
    ConditionsOpen = false
    for i=1, 10 do 
        Citizen.InvokeNative(0xFDB74C9CC54C3F37, 1.0 - (i / 10));
        Wait(15) 
    end	                                                                                    -- SET_TIMECYCLE_MODIFIER_STRENGTHs
    Citizen.InvokeNative(0x0E3F4AF2D63491FB)
    DisplayRadar(true)
    DisplayHud(true)
end

RegisterNUICallback('CloseNUI', function()          
    CloseConditions()
end)

RegisterNUICallback('Transact', function(data)
    TriggerServerEvent('conditions-menu:Server:Transact', data.type, data.amount)
end)

AddStateBagChangeHandler("conditions", "", function(bagName, key, value) 
    if GetPlayerFromStateBagName(bagName) ~= PlayerId() then return end
    if not ConditionsOpen then return end
    SendNUIMessage({
        action = "UPDATE_CONDITIONS",                                                        -- Opens Conditions Menu and sends each conditions and their type (might grab this at the other end instead)
        condition1type = LocalPlayer.conditions.condition1type, 
        condition1 = LocalPlayer.conditions.condition1, 
        condition2type = LocalPlayer.conditions.condition2type, 
        condition2 = LocalPlayer.conditions.condition2, 
        condition3type = LocalPlayer.conditions.condition3type, 
        condition3 = LocalPlayer.conditions.condition3, 
        condition4type = LocalPlayer.conditions.condition4type, 
        condition4 = LocalPlayer.conditions.condition4, 
        condition5type = LocalPlayer.conditions.condition5type, 
        condition5 = LocalPlayer.conditions.condition5,})
end)

AddEventHandler("conditions-menu:client:OpenConditions", function()
    local PlayerCoords = GetEntityCoords(PlayerPedId())
    for id, bank in pairs(Config.Banks) do
        if #(PlayerCoords - bank) < 5.0 then
            OpenConditions()
            return
        end
    end
end)

Citizen.CreateThread(function ()
    function on_key_up()
        
    end
    function on_key_down()
        OpenConditions()
    end
    RegisterRawKeymap("conditions_keymap", on_key_up, on_key_down, 88, false)                     -- Keymap for key88 (X) , cannot be disabled
end)
