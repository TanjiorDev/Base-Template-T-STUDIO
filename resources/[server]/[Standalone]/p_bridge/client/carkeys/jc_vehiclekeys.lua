if (Config.CarKeys == 'auto' and not checkResource('jc_vehiclekeys')) or (Config.CarKeys ~= 'auto' and Config.CarKeys ~= 'jc_vehiclekeys') then
    return
end

while not Bridge do
    Citizen.Wait(0)
end

if Config.Debug then
    lib.print.info('[CarKeys] Loaded: jc_vehiclekeys')
end

Bridge.CarKeys = {}

--@param vehiclePlate: string [the plate of the vehicle]
--@param vehicleEntity: number [the entity ID of the vehicle]
Bridge.CarKeys.CreateKeys = function(vehiclePlate, vehicleEntity)
    exports['jc_vehiclekeys']:GiveKeys(vehiclePlate)
end

--@param vehiclePlate: string [the plate of the vehicle]
Bridge.CarKeys.RemoveKeys = function(vehiclePlate)
    exports['jc_vehiclekeys']:RemoveKeys(vehiclePlate)
end