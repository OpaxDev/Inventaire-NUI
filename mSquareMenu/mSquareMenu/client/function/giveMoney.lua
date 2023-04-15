giveMoney = function(typeMoney, amount)
    local coordsPlayer = GetEntityCoords(GetPlayerPed(-1))
    local playerTarget, platerDistance = ESX.Game.GetClosestPlayer()
    local distance = GetDistanceBetweenCoords(coordsPlayer, GetEntityCoords(GetPlayerPed(playerTarget)), true)

    if distance <= 3.0 then
        local idTarget = GetPlayerServerId(playerTarget)
        TriggerServerEvent("mPersonal:server:giveMoney", typeMoney, amount, idTarget)
    else
        TriggerEvent("esx:showNotification", "~r~Vous n'avez personne autour de vous.")
    end
end