RPX = {}

---@class RPX
---@field Config table
---@field Shared table
---@field Prompts table
---@field Debug table
---@field Logs table
---@field LogData table
---@field Player table
---@field Database table
---@field Players table
---@field ServerCallbacks table
---@field Permissions table
---@field UpdateStateBags function

RPX.Config = InternalConfig
RPX.Shared = InternalShared
RPX.Prompts = InternalPrompts
RPX.Debug = Internal_DebugLibrary
RPX.Logs = {}
RPX.LogData = {}
RPX.Player = {}
RPX.Database = {}
RPX.Players = {}
RPX.ServerCallbacks = {}

exports('GetObject', function()
    return RPX
end)

RPX = exports['rpx-core']:GetObject()

--TRIGGERED BY GetConditions() IN CLIENT.LUA - SETS CONDITION[X]TYPE AND CONDITION[X] VARIABLES EQUAL TO WHAT'S IN THE DATABASE
--THEN PASSES THOSE VARIABLES TO CLIENT ("conditions-menu:client:OpenConditions")
RegisterServerEvent("conditions-menu:SERVER:OpenConditions")                                                                                -- Registers the event to be used cross client/server
RegisterNetEvent("conditions-menu:SERVER:OpenConditions", function()
    local src = source
    local Player = RPX.GetPlayer(src)
    if not Player then return end                                                                                                           -- Exit if player object not found
    
    local hasConditionsRecord
    local condition1type
    local condition1
    local condition2type
    local condition2
    local condition3type
    local condition3
    local condition4type
    local condition4
    local condition5type
    local condition5
                                                                                                
    hasConditionsRecord = MySQL.Sync.fetchScalar('SELECT citizenid FROM conditions WHERE citizenid = @citizenid', {Player.citizenid})       -- Check for whether the player has an entry in the conditions database
    if hasConditionsRecord == "" then                                                                                                       -- If not, print an error in F8 menu
        print("Character has no record in the conditions database")
    else                                                                                                                                    -- If the player has a record in the Conditions database
        condition1type = MySQL.Sync.fetchScalar('SELECT condition1type FROM conditions WHERE citizenid = ? LIMIT 1', {Player.citizenid})    -- Make condition[x]type/condition[x] equal to corresponding database values
        condition1 = MySQL.Sync.fetchScalar('SELECT condition1 FROM conditions WHERE citizenid = ? LIMIT 1', {Player.citizenid})
        condition2type = MySQL.Sync.fetchScalar('SELECT condition2type FROM conditions WHERE citizenid = ? LIMIT 1', {Player.citizenid})
        condition2 = MySQL.Sync.fetchScalar('SELECT condition2 FROM conditions WHERE citizenid = ? LIMIT 1', {Player.citizenid})
        condition3type = MySQL.Sync.fetchScalar('SELECT condition3type FROM conditions WHERE citizenid = ? LIMIT 1', {Player.citizenid})
        condition3 = MySQL.Sync.fetchScalar('SELECT condition3 FROM conditions WHERE citizenid = ? LIMIT 1', {Player.citizenid})
        condition4type = MySQL.Sync.fetchScalar('SELECT condition4type FROM conditions WHERE citizenid = ? LIMIT 1', {Player.citizenid})
        condition4 = MySQL.Sync.fetchScalar('SELECT condition4 FROM conditions WHERE citizenid = ? LIMIT 1', {Player.citizenid})
        condition5type = MySQL.Sync.fetchScalar('SELECT condition5type FROM conditions WHERE citizenid = ? LIMIT 1', {Player.citizenid})
        condition5 = MySQL.Sync.fetchScalar('SELECT condition5 FROM conditions WHERE citizenid = ? LIMIT 1', {Player.citizenid})
    end

    --PASSES ALL CONDITION[X]TYPE AND CONDITION[X] VARIABLES BACK TO CLIENT (TO "conditions-menu:client:OpenConditions")
    TriggerClientEvent("conditions-menu:client:OpenConditions",src,condition1type, condition1, condition2type, condition2, condition3type, condition3, condition4type, condition4, condition5type, condition5)

end)


--TRIGGERED BY NUI CALLBACK "SaveConditions" IN CLIENT.LUA - SENDS CONDITION[X]TYPE/CONDITION[X] VARIABLES OVER TO RPX (rpx-core/server/functions.lua)
RegisterNetEvent("conditions-menu:Server:SaveConditions")
AddEventHandler("conditions-menu:Server:SaveConditions", function(condition1type, condition1, condition2type, condition2, condition3type, condition3, condition4type, condition4, condition5type, condition5)
    local src = source
    local Player = RPX.GetPlayer(src)

    TriggerEvent("SERVER:RPX:ConditionsSave",src,condition1type, condition1, condition2type, condition2, condition3type, condition3, condition4type, condition4, condition5type, condition5)
end)
