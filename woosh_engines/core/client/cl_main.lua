local QBCore = exports['qb-core']:GetCoreObject()
local vehicleEngines = nil
local cachedVehicles = {}

RegisterNetEvent('woosh_engines:getEngineSyncs_cl', function(_vehicleEngines)
    vehicleEngines = _vehicleEngines
    local nearbyVehs = GetGamePool("CVehicle")
    cachedVehicles = {}
    for k, v in pairs(nearbyVehs) do
        if vehicleEngines[GetVehicleNumberPlateText(v)] ~= nil then
            ForceVehicleEngineAudio(v, vehicleEngines[GetVehicleNumberPlateText(v)])
        end
    end
end)

RegisterNetEvent('woosh_engines:setEngine', function()
    local plyPed = PlayerPedId()
    if IsPedInAnyVehicle(plyPed, false) then
        local veh = GetVehiclePedIsIn(plyPed, false)
        if GetPedInVehicleSeat(veh, -1) == plyPed then
            local dialog = exports['qb-input']:ShowInput({
                header = 'New Engine Sound',
                submitText = "Set Engine Sound",
                inputs = { { type = 'text', isRequired = true, name = 'carname', text = 'Engine to mimic' } } })
            if dialog then
                if not dialog.carname then return end
                local chosenCar = dialog.carname
                TriggerServerEvent("woosh_engines:fakeSyncEngine", GetVehicleNumberPlateText(veh), dialog.carname)
                ForceVehicleEngineAudio(v, dialog.carname)
            end
        end
    end
end)

CreateThread(function()
    while vehicleEngines == nil do
        TriggerServerEvent("woosh_engines:getEngineSyncs_sv")
        Wait(500)
    end
    while true do

        local nearbyVehs = GetGamePool("CVehicle")

        for k, v in pairs(nearbyVehs) do
            local plateText = GetVehicleNumberPlateText(v)
            if not cachedVehicles[v] then
                if vehicleEngines[plateText] ~= nil then
                    cachedVehicles[v] = true
                    ForceVehicleEngineAudio(v, vehicleEngines[GetVehicleNumberPlateText(v)])
                end
            end
        end

        Wait(5000)
    end
end)