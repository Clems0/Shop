ESX = exports['es_extended']:getSharedObject()

RegisterServerEvent('LTD:Buy')
AddEventHandler('LTD:Buy', function(type, label, name, price, Quantity)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Total = price * Quantity

    if type == 'liquide' then
        if xPlayer.getMoney() >= Total then
            xPlayer.removeMoney(Total)
            xPlayer.addInventoryItem(name, Quantity)
            TriggerClientEvent('esx:showAdvancedNotification', source, 'LTD', 'Achat', ('Vous venez d\'acheter ~b~%s %s ~s~pour ~r~%s$ ~g~(En espèces)'):format(Quantity, label, Total), 'CHAR_247')
        else
            TriggerClientEvent('esx:showAdvancedNotification', source, 'LTD', 'Achat', ('Vous n\'avez pas assez d\'argent')'CHAR_247')
        end
    elseif type == 'bank' then
        if xPlayer.getAccount('bank').money >= Total then
            xPlayer.removeAccountMoney('bank', Total)
            xPlayer.addInventoryItem(name, Quantity)
            TriggerClientEvent('esx:showAdvancedNotification', source, 'LTD', 'Achat', ('Vous venez d\'acheter ~b~%s %s ~s~pour ~r~%s$ ~b~(En banque)'):format(Quantity, label, price), 'CHAR_247')
        else
            TriggerClientEvent('esx:showAdvancedNotification', source, 'LTD', 'Achat', ('Vous n\'avez pas assez d\'argent sur votre compte banquaire')'CHAR_247')
        end
    end
end)