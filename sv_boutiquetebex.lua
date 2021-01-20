ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('OneFive:GetPoint', function(source, cb)
    local xPlayer  = ESX.GetPlayerFromId(source)
    if xPlayer then
        MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = '".. xPlayer.identifier .."'", {}, function (result)
            if result[1] then
                cb(result[1].onefivecoin)
            else
                return
            end        
        end)
    end
end)

ESX.RegisterServerCallback('OneFive:GetCodeBoutique', function(source, cb)
    local xPlayer  = ESX.GetPlayerFromId(source)
    if xPlayer then
        MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = '".. xPlayer.identifier .."'", {}, function (result)
            if result[1] then
                cb(result[1].id_boutique)
            else
                return
            end
        end)
    end
end)

ESX.RegisterServerCallback('OneFive:BuyItem', function(source, cb, item, option)
    local xPlayer  = ESX.GetPlayerFromId(source)

    for k, v in pairs(Config.Vehicle) do
        if item == v.data.NameVehicle then
            MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = '".. xPlayer.identifier .."'", {}, function (result)
                if result[1].onefivecoin >= tonumber(v.data.Point) then
                    local newpoint = result[1].onefivecoin - tonumber(v.data.Point)
                    MySQL.Async.execute("UPDATE `users` SET `onefivecoin`= '".. newpoint .."' WHERE `identifier` = '".. xPlayer.identifier .."'", {}, function() end)   
                    ESX.SavePlayer(xPlayer, function(cb) end)
                    PerformHttpRequest('mettretonwebhooknelson', function(err, text, headers) end, 'POST', json.encode({username = "Boutique", content = xPlayer.getName() .. " a acheter " .. item}), { ['Content-Type'] = 'application/json' })
                    TriggerClientEvent("OneFive:VehicleGang", source, v.data.NameVehicle, false)
                    cb(true)         
                else
                    cb(false)
                end
            end)
        end    
    end

end)


ESX.RegisterServerCallback('OneFive:BuyMoney', function(source, cb, item, option)
    local xPlayer  = ESX.GetPlayerFromId(source)

    for k, v in pairs(Config.Argent) do
        if item == v.data.AmountMoney then
            MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = '".. xPlayer.identifier .."'", {}, function (result)
                if result[1].onefivecoin >= tonumber(v.data.Point) then
                    local newpoint = result[1].onefivecoin - tonumber(v.data.Point)
                    MySQL.Async.execute("UPDATE `users` SET `onefivecoin`= '".. newpoint .."' WHERE `identifier` = '".. xPlayer.identifier .."'", {}, function() end)   
                    ESX.SavePlayer(xPlayer, function(cb) end)
                    PerformHttpRequest('mettretonwebhookvmh', function(err, text, headers) end, 'POST', json.encode({username = "Boutique", content = xPlayer.getName() .. " a acheter " .. item}), { ['Content-Type'] = 'application/json' })
	                xPlayer.addMoney(v.data.AmountMoney)
                    cb(true)         
                else
                    cb(false)
                end
            end)
        end    
    end

end)

ESX.RegisterServerCallback('OneFive:BuyWeapon', function(source, cb, item, option)
    local xPlayer  = ESX.GetPlayerFromId(source)

    for k, v in pairs(Config.Armes) do
        if item == v.data.WeaponName then
            MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = '".. xPlayer.identifier .."'", {}, function (result)
                if result[1].onefivecoin >= tonumber(v.data.Point) then
                    local newpoint = result[1].onefivecoin - tonumber(v.data.Point)
                    MySQL.Async.execute("UPDATE `users` SET `onefivecoin`= '".. newpoint .."' WHERE `identifier` = '".. xPlayer.identifier .."'", {}, function() end)   
                    ESX.SavePlayer(xPlayer, function(cb) end)
                    PerformHttpRequest('mettretonwebhookvmh', function(err, text, headers) end, 'POST', json.encode({username = "Boutique", content = xPlayer.getName() .. " a acheter " .. item}), { ['Content-Type'] = 'application/json' })
                    xPlayer.addWeapon(v.data.WeaponName, 250)
                    cb(true)         
                else
                    cb(false)
                end
            end)
        end    
    end

end)





