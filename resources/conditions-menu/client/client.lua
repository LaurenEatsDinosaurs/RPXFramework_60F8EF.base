local ConditionsOpen = false

--CALLED WHEN X IS PRESSED, TURNS OFF RADAR/HUD AND CALLS SERVER EVENT "conditions-menu:SERVER:OpenConditions"
local GetConditions = function()     
    DisplayRadar(false)                                                                     -- Turns off radar
    DisplayHud(false)                                                                       -- Turns off HUD
    TriggerServerEvent("conditions-menu:SERVER:OpenConditions")                             -- TRIGGERS "conditions-menu:SERVER:OpenConditions"
end


-- TRIGGERED BY "conditions-menu:SERVER:OpenConditions" IN SERVER.LUA
-- SENDS NUI THE CONDITION[X]TYPE/CONDITION[X] VARIABLES AND TELLS IT WE WANT IT TO OPEN
RegisterNetEvent("conditions-menu:client:OpenConditions")                                       --Registers the event to be used cross client/server--
AddEventHandler("conditions-menu:client:OpenConditions", function(condition1type, condition1, condition2type, condition2, condition3type, condition3, condition4type, condition4, condition5type, condition5)

    SendNUIMessage({ 
        action = "OPEN_CONDITIONS",                                                             --Sends NUI (script.js) the OPEN_CONDITIONS action, telling it we want to open the Conditions Menu
        condition1type = condition1type,                                                        --Sends each of the condition[x]type/condition[x] variables
        condition1 = condition1,
        condition2type = condition2type,
        condition2 = condition2,
        condition3type = condition3type,
        condition3 = condition3,
        condition4type = condition4type,
        condition4 = condition4,
        condition5type = condition5type,
        condition5 = condition5,
    })
    SetNuiFocus(true, true)                                                                     --Focuses NUI and gives it the cursor--
    ConditionsOpen = true
    Citizen.InvokeNative(0xFA08722A5EA82DA7, 'RespawnLight')   	                                --SET_TIMECYCLE_MODIFIER--
    for i=0, 10 do 
        Citizen.InvokeNative(0xFDB74C9CC54C3F37, 0.1 + (i / 10)); 
        Wait(10) 
    end	                                                                                        --SET_TIMECYCLE_MODIFIER_STRENGTHs--
end)


--TRIGGERED BY THE "$("#savebutton").click(function()" IN script.js (IE CLOSE BUTTON PRESS)
--SENDS NUI THE CLOSE_CONDITIONS ACTION, TELLING IT WE WANT IT TO CLOSE
local CloseConditions = function()
    SendNUIMessage({action = "CLOSE_CONDITIONS"})                                               --Sends NUI "CLOSE_CONDITIONS"
    SetNuiFocus(false, false)                                                                   --Conditions Menu does not have focus or cursor
    ConditionsOpen = false                          
    for i=1, 10 do 
        Citizen.InvokeNative(0xFDB74C9CC54C3F37, 1.0 - (i / 10));                               --SET_TIMECYCLE_MODIFIER--
        Wait(15) 
    end	                                                                                        --SET_TIMECYCLE_MODIFIER_STRENGTHs--
    Citizen.InvokeNative(0x0E3F4AF2D63491FB)
    DisplayRadar(true)
    DisplayHud(true)
end


--TRIGGERED BY THE "$("#savebutton").click(function()" IN script.js (IE SAVE BUTTON PRESSED)
--TRIGGERS SERVER EVENT saveConditions, AND SENDS IT THE CONDITION[X]TYPE/CONDITION[X] VARIABLES--
RegisterNUICallback('SaveConditions', function(data, cb)                                        --Receives what is in the html for each condition, triggers conditions-menu:Server:SaveConditions, sends condition[x]type/condition[x] variables
    TriggerServerEvent('conditions-menu:Server:SaveConditions',data.condition1type,data.condition1,data.condition2type,data.condition2,data.condition3type,data.condition3,data.condition4type,data.condition4,data.condition5type,data.condition5)
    cb('ok')
    CloseConditions()                                                                          --Calls CloseConditions()
end)

RegisterNUICallback('CloseNUI', function()          
    CloseConditions()
end)


--HOTKEY X BEGINS THE OPEN-CONDITIONS-MENU PROCESS BY CALLING GetConditions()--
Citizen.CreateThread(function ()                                                                --Sets Hotkey for Conditions Menu - X --
    function on_key_up()
    end
    function on_key_down()                                                                      --When X is pressed, call GetConditions()
        GetConditions()
    end
    RegisterRawKeymap("conditions_keymap", on_key_up, on_key_down, 88, false)                   --Keymap for key88 (X), sets to cannot be disabled--
end)


--STATE BAGS FOR CONDITIONS
AddStateBagChangeHandler("conditions", "", function(bagName, key, value) 
    local src = source
    local PlayerInfo = RPX.Players[source]
    local Player = RPX.GetPlayer(src)
    if GetPlayerFromStateBagName(bagName) ~= PlayerId() then return end
    if not ConditionsOpen then return end
end)





-- LEAVING THESE ATTEMPTS AT FIGURING OUT HOW TO GET THE PROMPT ON THE HOLD-RIGHT-CLICK FOCUS MENU IN HERE FOR NOW

-- ATTEMPT 1
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

-- ATTEMPT TWO - GET ALL PEDS AND COMPARE TARGET PED TO PEDLIST TO DECIDE WHETHER TO ENABLE PROMPT - TARGET DISPLAYS 0 ALWAYS (DOES IT MEAN AIMING WITH A GUN? NO, TESTED AND STILL 0)
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
--        if(IsEntityAPed(targetedPed) == true) then                                         -- If that something is a Ped, set the UI prompt to visible
--            print("Targeting ped...")                                                      -- Temp - For debugging
--            print("Targeted ped is...",targetedPed)                                        -- Temp - For debugging
--            UiPromptSetVisible(viewConditionsPrompt, true)
--            print("UI should be visible now")                                              -- Temp - For debugging
--            Citizen.Wait(100)
--        end
--    end
--end)

-- AT THIS POINT I'D SAY FUCK IT AND PUT IT ON THE ALT-RIGHTCLICK "THIRD EYE" MENU EVEN THOUGH THAT WASN'T THE ORIGINAL VISION, BUT RPX DOESN'T HAVE IT FOR NORMAL NPCS, ONLY SHOP ONES--