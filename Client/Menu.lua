ESX = exports['es_extended']:getSharedObject()
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

LTDMenuOpen = false
local Quantity = nil
local BuyIndex = 1
local Type = 'liquide'


local LTDMenu = RageUI.CreateMenu('LTD', 'Menu principale')
local LTDBoisson = RageUI.CreateSubMenu(LTDMenu, 'LTD', 'Menu Boisson')
local LTDNourriture = RageUI.CreateSubMenu(LTDMenu, 'LTD', 'Menu nourriture')
local LTDBuyMenu = RageUI.CreateSubMenu(LTDMenu, 'LTD', 'Menu d\'achat')

LTDMenu.Closed = function ()
    LTDMenuOpen = false
end

function LoadModel()
    while not HasModelLoaded(GetHashKey(model)) do
    RequestModel(GetHashKey(model))
    Wait(0)
end
end

function LTD()
    if LTDMenuOpen then
        LTDMenuOpen = false
        RageUI.Visible(LTDMenu, false)
    else
        LTDMenuOpen = true
        RageUI.Visible(LTDMenu, true)
    end
    CreateThread(function()
    while LTDMenuOpen do
        Wait(0)
        RageUI.IsVisible(LTDMenu, function()			--
            
            RageUI.Separator('Bienvenue : '..GetPlayerName(PlayerId()))
            RageUI.Line()
            RageUI.Button('Nos nourriture', 'Voici la liste des aliments.', {RightLabel = ">"}, true, {}, LTDNourriture)
            RageUI.Button('Nos boisson', 'Voici la liste de nos boissons', {RightLabel = ">"}, true, {}, LTDBoisson)
        end)
        RageUI.IsVisible(LTDNourriture, function()
            for k,v in pairs(LTDConfig.Nourriture) do
                RageUI.Button(v.label, nil, {RightLabel = ("%s$"):format(v.price)}, true, {
                    onSelected = function()
                        label = v.label
                        name = v.name
                        price = v.price
                        Quantity = 1
                    end
                }, LTDBuyMenu)
        end
        end)
        RageUI.IsVisible(LTDBoisson, function()
            for k,v in pairs(LTDConfig.Boisson) do
                RageUI.Button(v.label, nil, {RightLabel = ("%s$"):format(v.price)}, true, {
                    onSelected = function()
                        label = v.label
                        name = v.name
                        price = v.price
                        Quantity = 1
                    end
                }, LTDBuyMenu)
        end
        end)
        RageUI.IsVisible(LTDBuyMenu, function()

            
                RageUI.Button('Choisir la quantité', 'Sélectionnez le nombre d\'articles désirés.', {RightLabel = ("%s"):format(Quantity)}, true, {
                    onSelected = function()
                        local input = lib.inputDialog('Dialog title', {
                            {type = 'number', label = 'Nombre', description = 'Nombre d\'item que vous voulez', icon = 'hashtag', required = true},
                          })
                        
                        local Nomber = input[1]
                            Quantity = Nomber
                    end
                })
                RageUI.Line()

                RageUI.List("Moyen de paiement", {"~g~Cash~s~", "~b~Banque~s~"},BuyIndex, nil, {}, true, {
                    onListChange = function(Index) 
                        BuyIndex = Index 
                    end,
                    onSelected = function(Index)
                        if Index == 1 then
                            Type = 'liquide'

                        elseif Index == 2 then
                            Type = 'bank'
                        end
                    end
                })

                RageUI.Button('Payé', nil, {RightLabel = ">"}, true, {
                    onSelected = function()
                        TriggerServerEvent('LTD:Buy', Type, label, name, price, Quantity)
                    end
                })

                
            
        end)
    end
    end)
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local Player = GetEntityCoords(PlayerPedId())
        for k,v in pairs(LTDConfig.position) do 

            if #(Player -v.pos) <= 3.0 then
                Timer = 0   
            end
            if #(Player -v.pos) <= 3.0 then
                ESX.ShowFloatingHelpNotification('~INPUT_CONTEXT~ Pour accéder à la boutique', v.pos)
                if IsControlJustPressed(1,51) then
                    --FreezeEntityPosition(PlayerPedId(), true)
                    LTD()
                end
        end
        end 
        Wait(Timer)
        lib.hideTextUI()

    end
end)

CreateThread(function()
    if LTDConfig.Blips then
    for k, info in pairs(LTDConfig.position) do
        local BlipShops = AddBlipForCoord(info.pos)
        SetBlipSprite(BlipShops, 52)
        SetBlipDisplay(BlipShops, 4)
        SetBlipScale(BlipShops, 0.6)
        SetBlipColour(BlipShops, 2)
        SetBlipAsShortRange(BlipShops, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Shop | Supérette 24/7")
        EndTextCommandSetBlipName(BlipShops)
    end
end
    for k,v in pairs(LTDConfig.Pnj) do
        local hash = GetHashKey("mp_m_shopkeep_01")
        while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
        end
        ped = CreatePed("PED_TYPE_CIVMALE", "mp_m_shopkeep_01", v.x, v.y, v.z, v.h, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)

    end

end)
