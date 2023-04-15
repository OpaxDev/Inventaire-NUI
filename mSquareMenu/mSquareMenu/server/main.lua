ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("mPersonal:server:giveMoney")
AddEventHandler("mPersonal:server:giveMoney", function(typeMoney, amount, idTarget)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local xPlayerName = xPlayer.getName()
    local xTarget = ESX.GetPlayerFromId(idTarget)
    local xTargetName = xTarget.getName()
    local count = tonumber(amount)
    
    if count >= 1 then 
        if typeMoney == 'money' then 
            if xPlayer.getMoney() >= count then 
                xPlayer.removeMoney(count)
                xTarget.addMoney(count)
                TriggerClientEvent('m:showNotification', _src, "Vous avez donné ~r~"..count.."~s~ $ à "..xTargetName..".")      
                TriggerClientEvent('m:showNotification', xTarget.source, "Vous avez reçus ~r~"..count.."~s~ $ à "..xPlayerName..".")
                TriggerClientEvent("mPersonal:client:refreshMoney", _src)
                TriggerClientEvent("mPersonal:client:refreshMoney", xTarget.source)
            else 
                TriggerClientEvent('m:showNotification', _src, "Vous n'avez pas assez d'argent sur vous.")
            end
        elseif typeMoney == 'black_money' then 
            if xPlayer.getAccount('black_money') >= count then 
                xPlayer.removeAccountMoney('black_money', count)
                xTarget.addAccountMoney('black_money', count)
                TriggerClientEvent('m:showNotification', _src, "Vous avez donné ~r~"..count.."~s~ $ à "..xTargetName..".")      
                TriggerClientEvent('m:showNotification', xTarget.source, "Vous avez reçus ~r~"..count.."~s~ $ à "..xPlayerName..".")
                TriggerClientEvent("mPersonal:client:refreshMoney", _src)
                TriggerClientEvent("mPersonal:client:refreshMoney", xTarget.source)
            else
                TriggerClientEvent('m:showNotification', _src, "Vous n'avez pas assez d'argent sur vous.")
            end
        end
    end
end)

ESX.RegisterServerCallback("mPersonal:getPlayerInventory",function(source, cb, target)
    local targetXPlayer = ESX.GetPlayerFromId(target)

    if targetXPlayer ~= nil then
        if _Config.getCashMoney == "money" then 
            cb({inventory = targetXPlayer.inventory, money = targetXPlayer.getMoney(), accounts = targetXPlayer.accounts, weapons = targetXPlayer.loadout})
        elseif _Config.getCashMoney == "cash" then 
            cb({inventory = targetXPlayer.inventory, money = targetXPlayer.getCash(), accounts = targetXPlayer.accounts, weapons = targetXPlayer.loadout})
        end 
    else
        cb(nil)
    end
end)

ESX.RegisterServerCallback("mPersonal:getIdentity", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

	MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height, job, job2 FROM users WHERE identifier = @identifier', 
    {
        ['@identifier'] = identifier
    }, function (result)
		if (result[1] ~= nil) then
            player = result[1]

            local dataID = {
                firstname = player.firstname,
                lastname = player.lastname,
                dateofbirth = player.dateofbirth,
                sex = player.sex,
                height = player.height,
            }
            cb(dataID)
		end
	end)
end)
-- , leak by shadow leaks
ESX.RegisterServerCallback('mPersonal:getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bills = {}

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount
			})
		end
		cb(bills)
	end)
end)
