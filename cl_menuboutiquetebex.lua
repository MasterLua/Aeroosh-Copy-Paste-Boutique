ESX = nil
local point = 0
local code = 0
local BoutiqueTebex = {}
local imagepre = nil
local PlayerData = {}
local active = false
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)

local NumberCharset = {}
local Charset = {}

for i = 48, 57 do table.insert(NumberCharset, string.char(i)) end
for i = 65, 90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
    local generatedPlate
    local doBreak = false

    while true do
        Citizen.Wait(2)
        math.randomseed(GetGameTimer())
        generatedPlate = string.upper(GetRandomLetter(4) .. GetRandomNumber(4))

        ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function (isPlateTaken)
            if not isPlateTaken then
                doBreak = true
            end
        end, generatedPlate)

        if doBreak then
            break
        end
    end

    return generatedPlate
end

function IsPlateTaken(plate)
    local callback = 'waiting'

    ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function(isPlateTaken)
        callback = isPlateTaken
    end, plate)

    while type(callback) == 'string' do
        Citizen.Wait(0)
    end

    return callback
end

function GetRandomNumber(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())

    if length > 0 then
        return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ''
    end
end

function GetRandomLetter(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())

    if length > 0 then
        return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
    else
        return ''
    end
end

function getVehicleType(model)
    return 'car'
end


function GetActuallyParticul(assetName)
    RequestNamedPtfxAsset(assetName)
    if not (HasNamedPtfxAssetLoaded(assetName)) then
        while not HasNamedPtfxAssetLoaded(assetName) do
            Citizen.Wait(1.0)
        end
        return assetName;
    else
        return assetName;
    end
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end



RMenu.Add('boutique', 'main', RageUI.CreateMenu("ONEFIVE", "~g~Boutique OneFive"))
RMenu.Add('boutique', 'premierboutton', RageUI.CreateSubMenu(RMenu:Get("boutique", "main"),"ONEFIVE", "~g~Boutique OneFive"))
RMenu.Add('boutique', 'deuxiemeboutton', RageUI.CreateSubMenu(RMenu:Get("boutique", "main"),"ONEFIVE", "~g~Boutique OneFive"))
RMenu.Add('boutique', 'troisiemeboutton', RageUI.CreateSubMenu(RMenu:Get("boutique", "main"),"ONEFIVE", "~g~Boutique OneFive"))
RMenu:Get('boutique', 'main'):SetRectangleBanner(0,0,0,500)
RMenu:Get('boutique', 'premierboutton'):SetRectangleBanner(0,0,0,500)
RMenu:Get('boutique', 'deuxiemeboutton'):SetRectangleBanner(0,0,0,500)
RMenu:Get('boutique', 'troisiemeboutton'):SetRectangleBanner(0,0,0,500)
RMenu:Get('boutique', 'main').EnableMouse = false
RMenu:Get('boutique', 'main').Closed = function()
    BoutiqueTebex.Menu = false
end

function OpenboutiqueRageUIMenu()

    if BoutiqueTebex.Menu then
        BoutiqueTebex.Menu = false
    else
        BoutiqueTebex.Menu = true
        RageUI.Visible(RMenu:Get('boutique', 'main'), true)

        Citizen.CreateThread(function()
			while BoutiqueTebex.Menu do
                RageUI.IsVisible(RMenu:Get('boutique', 'main'), true, true, true, function()
                    RageUI.Separator("OneFive".. " : ~g~"..point)
                    RageUI.Separator("Votre ~g~ID~s~ boutique : "..code)
                    RageUI.Button("Véhicules", false, {RightLabel = "→"}, true, function(h,a,s)
                    end, RMenu:Get("boutique","premierboutton"))
                    RageUI.Button("Armes", false, {RightLabel = "→"}, true, function(h,a,s)
                    end, RMenu:Get("boutique","deuxiemeboutton"))
                    RageUI.Button("Argent", false, {RightLabel = "→"}, true, function(h,a,s)
                    end, RMenu:Get("boutique","troisiemeboutton"))
                end)
                RageUI.IsVisible(RMenu:Get('boutique', 'premierboutton'), true, true, true, function()
                    for k, v in pairs(Config.Vehicle) do
                        RageUI.Button(v.name, v.desc, { RightLabel = v.data.Point .. " " .. "OneFivecoin", Color = {BackgroundColor = { v.data.CouleurBackground1, v.data.CouleurBackground2, v.data.CouleurBackground3, 25 }}}, true,function(h,a,s)
                            if a then
                                if v.data.Preview then
                                    imagepre = v.data.Preview
                                end
                            end
                            if s then
                                ESX.TriggerServerCallback('OneFive:BuyItem', function(callback)
                                    if callback then
                                        local coords = GetEntityCoords(GetPlayerPed(PlayerId()))
                                        GetActuallyParticul('core')
                                        SetPtfxAssetNextCall('core')
                                        StartParticleFxNonLoopedAtCoord_2('ent_dst_gen_gobstop', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 5.0, false, false, false)
                                        ESX.ShowNotification("Merci pour votre achat dans la boutique !")
                                    else
                                        ESX.ShowNotification("Vous n'avez pas assez de fond pour acheter ceci !")
                                    end
                                end, v.data.NameVehicle)  
                            end
                        end)
                    end
                    if imagepre ~= nil then
                        RageUI.DrawBoutique(imagepre)
                    end
                end)
                RageUI.IsVisible(RMenu:Get('boutique', 'deuxiemeboutton'), true, true, true, function()
                    for k, v in pairs(Config.Armes) do
                        RageUI.Button(v.name, v.desc, { RightLabel = v.data.Point .. " " .. "OneFivecoin", Color = {BackgroundColor = { v.data.CouleurBackground1, v.data.CouleurBackground2, v.data.CouleurBackground3, 25 }}}, true,function(h,a,s)
                            if s then
                                ESX.TriggerServerCallback('OneFive:BuyWeapon', function(callback)
                                    if callback then
                                        local coords = GetEntityCoords(GetPlayerPed(PlayerId()))
                                        GetActuallyParticul('core')
                                        SetPtfxAssetNextCall('core')
                                        StartParticleFxNonLoopedAtCoord_2('ent_dst_gen_gobstop', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 5.0, false, false, false)
                                        ESX.ShowNotification("Merci pour votre achat dans la boutique !")
                                    else
                                        ESX.ShowNotification("Vous n'avez pas assez de fond pour acheter ceci !")
                                    end
                                end, v.data.WeaponName)  
                            end
                        end)
                    end
                end)
                RageUI.IsVisible(RMenu:Get('boutique', 'troisiemeboutton'), true, true, true, function()
                    for k, v in pairs(Config.Argent) do
                        RageUI.Button(v.name, v.desc, { RightLabel = v.data.Point .. " " .. "OneFivecoin", Color = {BackgroundColor = { v.data.CouleurBackground1, v.data.CouleurBackground2, v.data.CouleurBackground3, 25 }}}, true,function(h,a,s)
                            if s then
                                ESX.TriggerServerCallback('OneFive:BuyMoney', function(callback)
                                    if callback then
                                        local coords = GetEntityCoords(GetPlayerPed(PlayerId()))
                                        GetActuallyParticul('core')
                                        SetPtfxAssetNextCall('core')
                                        StartParticleFxNonLoopedAtCoord_2('ent_dst_gen_gobstop', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 5.0, false, false, false)
                                        ESX.ShowNotification("Merci pour votre achat dans la boutique !")
                                    else
                                        ESX.ShowNotification("Vous n'avez pas assez de fond pour acheter ceci !")
                                    end
                                end, v.data.AmountMoney)  
                            end
                        end)
                    end
                end)
				Wait(0)
			end
		end)
	end

end

RegisterNetEvent('OneFive:VehicleGang')
AddEventHandler('OneFive:VehicleGang', function(vehicle_menu, custom)
    if custom then
        local pos = GetEntityCoords(GetPlayerPed(PlayerId()))
        ESX.Game.SpawnVehicle(vehicle_menu, vector3(pos.x, pos.y, pos.z + 500), nil, function(vehicle)
            local newPlate = GeneratePlate()
            local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
            vehicleProps.plate = newPlate
            SetVehicleNumberPlateText(vehicle, newPlate)
            TriggerServerEvent('esx_vehicleshop:setVehicleOwned', vehicleProps, getVehicleType(vehicleProps.model))
        end)
    else
        local pos = GetEntityCoords(GetPlayerPed(PlayerId()))
        ESX.Game.SpawnVehicle(vehicle_menu, vector3(pos.x, pos.y, pos.z), nil, function(vehicle)
            TaskWarpPedIntoVehicle(GetPlayerPed(PlayerId()), vehicle, -1)
            local newPlate = GeneratePlate()
            local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
            vehicleProps.plate = newPlate
            SetVehicleNumberPlateText(vehicle, newPlate)
            TriggerServerEvent('esx_vehicleshop:setVehicleOwned', vehicleProps, getVehicleType(vehicleProps.model))
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        att = 500
            if not BoutiqueTebex.Menu then
                att = 1
                if IsControlJustPressed(0, 288) then
                    ESX.TriggerServerCallback('OneFive:GetPoint', function(thepoint)
                        point = thepoint
                    end)        
                    ESX.TriggerServerCallback('OneFive:GetCodeBoutique', function(thecode)
                        code = thecode
                    end)
                    OpenboutiqueRageUIMenu()
                end
            end
        Citizen.Wait(att)
    end
end)

