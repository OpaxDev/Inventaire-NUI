_Config = {

    openMenuKey = "F5", -- Key to open the menu
    getCashMoney = "money", -- money or cash
    
    GetItems = function(displayInventory)
        ESX.TriggerServerCallback("mPersonal:getPlayerInventory",function(data)
            items = {}
            inventory = data.inventory
            accounts = data.accounts
            weapons = data.weapons
    
            if inventory ~= nil then
                for key, value in pairs(inventory) do
                    if inventory[key].count <= 0 then
                        inventory[key] = nil
                    else
                        inventory[key].type = "item_standard"
                        table.insert(items, inventory[key])
                    end
                end
            end
    
            for key, value in pairs(weapons) do
                local weaponHash = GetHashKey(weapons[key].name)
                local playerPed = PlayerPedId()
                if HasPedGotWeapon(playerPed, weaponHash, false) and weapons[key].name ~= "WEAPON_UNARMED" then
                    local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
                    table.insert(
                        items,
                        {
                            label = weapons[key].label,
                            count = ammo,
                            weight = -1,
                            type = "item_weapon",
                            name = weapons[key].name,
                            usable = false,
                            rare = false,
                            canRemove = true
                        }
                    )
                end
            end
    
            local dataItems = {
                Items = items
            }
            SetDisplay(displayInventory, "inventoryPage", dataItems)
        end, GetPlayerServerId(PlayerId()))
    end,
    GetIdentity = function(displayIdentity)
        PlayerData = ESX.GetPlayerData()
        ESX.TriggerServerCallback("mPersonal:getIdentity", function(data)
            data.job = PlayerData.job.label
            data.job2 = PlayerData.job2.label
            SetDisplay(displayIdentity, "identityPage", data)
        end)
    end,
    GetBills = function(displayBilling)
        ESX.TriggerServerCallback("mPersonal:getBills", function(data)
            UpdateClient("Billing", data)
            
            SetDisplay(displayBilling, "billingPage", _Client["Billing"])
        end)
    end,
    ShowID = function()
        closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()				
        if closestDistance ~= -1 and closestDistance <= 2.0 then
            ESX.ShowNotification("[~b~Inventaire~s~]~n~ La personne à bien reçu votre carte.")
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
        else
            ESX.ShowNotification("[~b~Inventaire~s~]~n~~r~Vous n'avez personne à qui la présenter.")
        end
    end,
    ShowDMV = function()
        closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()				
        if closestDistance ~= -1 and closestDistance <= 2.0 then
            ESX.ShowNotification("[~b~Inventaire~s~]~n~ La personne à bien reçu votre carte.")
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
        else
            ESX.ShowNotification("[~b~Inventaire~s~]~n~~r~Vous n'avez personne à qui la présenter.")
        end
    end,
    UseItem = function(data)
        TriggerServerEvent("esx:useItem", data.item.name)
        local Number = 1
        if data.number == nil then
            return
        end
        while Number ~= data.number do
            TriggerServerEvent("esx:useItem", data.item.name)
            Number = Number + 1
        end
    end,
    GiveItem = function(data)
        local foundPlayers = false
        closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

        if closestDistance ~= -1 and closestDistance <= 3 then
            foundPlayers = true
        end
        if foundPlayers == true then
            local closestPed = GetPlayerPed(closestPlayer)
            if data.number == nil then
                data.number = 1
            end
            quantity = data.number
            count = data.item.count 
            value = data.item.name
-- , leak by shadow leaks
            if not IsPedSittingInAnyVehicle(closestPed) then
                if quantity ~= nil and count > 0 then
                    TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), data.item.type, value, quantity)

                    while not HasAnimDictLoaded("mp_common") do
                        RequestAnimDict("mp_common")
                        Citizen.Wait(1)
                    end
                    TaskPlayAnim(GetPlayerPed(-1), "mp_common", "givetake1_a", 2.0, 2.0, -1, 0, 0, false, false, false) 
                else
                    ESX.ShowNotification(("~r~Quantité de x%s %s invalide"):format(data.number, data.item.label))
                end
            else
                ESX.ShowNotification(("Impossible de donner %s dans un véhicule"):format(data.item.label))
            end
        else
            ESX.ShowNotification("~r~Aucun joueur à proximité")
        end
    end,
    DropItem = function(data)
        if data.number == nil then
            data.number = data.item.count
        end
        local playerPed = PlayerPedId()
        if IsPedSittingInAnyVehicle(playerPed) then
            return (ESX.ShowNotification("~r~Impossible de jeter un objet dans un véhicule"))
        end

        if type(data.number) == "number" and math.floor(data.number) == data.number  then
            TriggerServerEvent("esx:removeInventoryItem", data.item.type, data.item.name, data.number)
        end
    end
}