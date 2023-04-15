dropMoney = function(item)
    if IsPedSittingInAnyVehicle(playerPed) then
        return  
    end

    if tonumber(item.number) >= 1 then
        TriggerServerEvent("esx:removeInventoryItem", item.type, item.name, tonumber(item.number))
    end

    Wait(250)
end
