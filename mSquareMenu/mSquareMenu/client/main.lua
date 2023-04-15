ESX = nil
_Client = {}
local PlayerData = {}

function UpdateClient(Name, data)
    _Client[Name] = data
end

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

local displayUI = false
local displayBilling = false
local displayWallet = false
local displayInventory = false
local displayIdentity = false

RegisterCommand("openmenu", function()
    SetDisplay(not displayUI, "container")
    deletePedScreen()
end)

RegisterKeyMapping("openmenu", "ouverture du menu personnal", "keyboard", _Config.openMenuKey)

RegisterNUICallback("exit", function(data)
    displayUI = false
    SetDisplay(displayUI, "container")
    displayBilling = false
    displayInventory = false
    displayWallet = false
    displayIdentity = false    
    deletePedScreen()
    SetDisplay(displayBilling, "billingPage")
    SetDisplay(displayInventory, "inventoryPage")
    SetDisplay(displayWallet, "walletPage")
    SetDisplay(displayIdentity, "identityPage")
end)

RegisterNUICallback("inventory", function(data)
    loadPlayerInventory()
end)

function loadPlayerInventory()
    displayBilling = false
    displayWallet = false
    displayIdentity = false    
    deletePedScreen()
    SetDisplay(displayBilling, "billingPage")
    SetDisplay(displayWallet, "walletPage")
    SetDisplay(displayIdentity, "identityPage")
    displayInventory = true
    _Config.GetItems(displayInventory)
end

RegisterNUICallback("wallet", function(data)
    displayBilling = false
    displayInventory = false
    displayIdentity = false    
    deletePedScreen()
    SetDisplay(displayBilling, "billingPage")
    SetDisplay(displayInventory, "inventoryPage")
    SetDisplay(displayIdentity, "identityPage")
    displayWallet = not displayWallet
    PlayerData = ESX.GetPlayerData()
    while not PlayerData do
        Wait(0)
    end
    local dataMoney = {
        Money = PlayerData["money"],
        blackMoney = PlayerData["accounts"][2]["money"]
    }
    SetDisplay(displayWallet, "walletPage", dataMoney)
end)

RegisterNUICallback("billing", function()
    displayInventory = false
    displayWallet = false
    displayIdentity = false    
    deletePedScreen()
    SetDisplay(displayInventory, "inventoryPage")
    SetDisplay(displayWallet, "walletPage")
    SetDisplay(displayIdentity, "identityPage")
    displayBilling = true
    _Config.GetBills(displayBilling)    
end)

RegisterNUICallback("PayBill", function(data)
    local amount = tonumber(data.bill.amount)
    local label = data.bill.label
    local id = data.bill.id
    ESX.TriggerServerCallback("esx_billing:payBill", function(success)
        ESX.ShowNotification("Vous avez payé votre amende pour ~r~" .. label .. "~s~.")
        displayInventory = false
        displayWallet = false
        displayIdentity = false    
        deletePedScreen()
        SetDisplay(displayInventory, "inventoryPage")
        SetDisplay(displayWallet, "walletPage")
        SetDisplay(displayIdentity, "identityPage")
        displayBilling = true
        _Config.GetBills(displayBilling)
    end, id)
end)

RegisterNUICallback("identity", function(data)
    displayBilling = false
    displayInventory = false
    displayWallet = false   
    deletePedScreen()
    SetDisplay(displayBilling, "billingPage")
    SetDisplay(displayInventory, "inventoryPage")
    SetDisplay(displayWallet, "walletPage")
    displayIdentity = true
    _Config.GetIdentity(displayIdentity)
    createPedScreen(false)
end)

RegisterNUICallback("give", function(data)
    giveMoney(data.type, data.amount)
end)

RegisterNUICallback("drop", function(data)
    item = {
        type = data.item,
        name = data.type,
        number = data.amount,
    }
    dropMoney(item)
end)

RegisterNUICallback("main", function(data)
    displayUI = false
    SetDisplay(displayUI, "container")
    displayBilling = false
    displayInventory = false
    displayWallet = false
    displayIdentity = false    
    deletePedScreen()
    SetDisplay(displayBilling, "billingPage")
    SetDisplay(displayInventory, "inventoryPage")
    SetDisplay(displayWallet, "walletPage")
    SetDisplay(displayIdentity, "identityPage")
end)

RegisterNUICallback("errorclose", function(data)
    displayUI = false
    SetDisplay(displayUI, "container")
    displayBilling = false
    displayInventory = false
    displayWallet = false
    displayIdentity = false    
    deletePedScreen()
    SetDisplay(displayBilling, "billingPage")
    SetDisplay(displayInventory, "inventoryPage")
    SetDisplay(displayWallet, "walletPage")
    SetDisplay(displayIdentity, "identityPage")
end)

RegisterNUICallback("errornoclose", function(data)
    Error(data.error)
end)

RegisterNUICallback("UseItem", function(data, cb)
    CreateThread(function()
        _Config.UseItem(data)
    end)

    Wait(250)
    loadPlayerInventory()
end)

RegisterNUICallback("GiveItem", function(data, cb)
    CreateThread(function()
        _Config.GiveItem(data)
    end)

    Wait(250)
    loadPlayerInventory()
end)

RegisterNUICallback("DropItem", function(data, cb)
    CreateThread(function()
        _Config.DropItem(data)
    end)

    Wait(250)
    loadPlayerInventory()
end)

RegisterNUICallback("ShowDMV", function()
    _Config.ShowDMV()
end)

RegisterNUICallback("ShowID", function()
    _Config.ShowID()
end)

function SetDisplay(bool, id, data)
    display = bool
    if id == "container" then 
        SetNuiFocus(bool, bool)
    end
    if data then
        SendNUIMessage({
            type = id,
            status = bool,
            data = data
        })
        return
    else
        SendNUIMessage({
            type = id,
            status = bool,
        })
    end
end

CreateThread(function()
    while display do 
        Wait(0)
        DisableControlAction(0, 1, display)
        DisableControlAction(0, 2, display)
        DisableControlAction(0, 142, display)
        DisableControlAction(0, 18, display)
        DisableControlAction(0, 322, display)
        DisableControlAction(0, 106, display)
    end
end)
