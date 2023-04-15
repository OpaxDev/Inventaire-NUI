RegisterNetEvent("mPersonal:client:refreshMoney")
AddEventHandler("mPersonal:client:refreshMoney", function()
    PlayerData = ESX.GetPlayerData()
    local dataMoney = {
        Money = PlayerData["money"],
        blackMoney = PlayerData["accounts"][2]["money"]
    }
    SetDisplay(displayWallet, "refreshMoney", dataMoney)
end)