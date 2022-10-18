local QBCore = exports['qb-core']:GetCoreObject()
local vehicleEngines = {}
local ValidJobs = {
    "mechanic",
}

function isAllowed(src)
    local Player = QBCore.Functions.GetPlayer(src)
    local isValidJob = false
    for k, v in pairs(ValidJobs) do
        if Player.PlayerData.job.name == v then
            isValidJob = true
            break
        end
    end
    return isValidJob
end

RegisterCommand('engines', function(source, args)
    local src = source
    if isAllowed(src) then
        TriggerClientEvent("woosh_engines:setEngine", src)
    end
end, false)

RegisterNetEvent('woosh_engines:fakeSyncEngine', function(plate, newEngine)
    vehicleEngines[plate] = newEngine
    TriggerClientEvent("woosh_engines:getEngineSyncs_cl", -1, vehicleEngines)
end)

RegisterNetEvent('woosh_engines:getEngineSyncs_sv', function()
    TriggerClientEvent("woosh_engines:getEngineSyncs_cl", source, vehicleEngines)
end)