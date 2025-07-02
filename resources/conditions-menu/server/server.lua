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

RegisterServerEvent("conditions-menu:SERVER:OpenConditions")                                    -- Registers the event to be used cross client/server
RegisterNetEvent("conditions-menu:SERVER:OpenConditions", function()
    local src = source
    local Player = RPX.GetPlayer(src)
    if not Player then return end                                                               -- Exit if player object not found
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
                                                                                                -- Getting the player's Conditions from the conditions database
    hasConditionsRecord = MySQL.Sync.fetchScalar('SELECT citizenid FROM conditions WHERE citizenid = @citizenid', {Player.citizenid})
    if hasConditionsRecord == "" then
        print("Character has no record in the conditions database")
    else                                                                                        -- If the player has a record in the Conditions database, make condition1type/condition1 etc equal to what's in the database
        condition1type = MySQL.Sync.fetchScalar('SELECT condition1type FROM conditions WHERE citizenid = ? LIMIT 1', {Player.citizenid})
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

    TriggerClientEvent("conditions-menu:client:OpenConditions",src,condition1type, condition1, condition2type, condition2, condition3type, condition3, condition4type, condition4, condition5type, condition5)

end)

RegisterNetEvent("conditions-menu:Server:SaveConditions")
AddEventHandler("conditions-menu:Server:SaveConditions", function(condition1type, condition1, condition2type, condition2, condition3type, condition3, condition4type, condition4, condition5type, condition5)
    local src = source
    local Player = RPX.GetPlayer(src)

    TriggerEvent("SERVER:RPX:ConditionsSave",src,condition1type, condition1, condition2type, condition2, condition3type, condition3, condition4type, condition4, condition5type, condition5)
end)
