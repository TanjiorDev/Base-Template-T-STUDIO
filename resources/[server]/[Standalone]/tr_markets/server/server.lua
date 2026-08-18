local ESX = exports["es_extended"]:getSharedObject()

local function SendToDiscord(webhookName, title, message, color, tagEveryone)
    local webhook = Config.Webhooks[webhookName]
    local datum = os.date("%d-%m-%Y")
    local vreme = os.date('*t')
    if not webhook then
        print('^1[TR_Markets] Webhook ' .. webhookName .. ' not found!^7')
        return
    end

    local embed = {
        {
            ["color"] = color or 14423100,
            ["title"] = title or "Title",
            ["description"] = message or "No description",
            ["footer"] = {
                ["text"] = "Time: " .. vreme.hour .. ":" .. vreme.min .. ":" .. vreme.sec .. "\nDate: " .. datum,
            },
        }
    }

    PerformHttpRequest(webhook, function(err, text, headers)
    end, 'POST', json.encode({
        content = tagEveryone and "@everyone" or nil,
        embeds = embed,
    }), { ['Content-Type'] = 'application/json' })
end

ESX.RegisterServerCallback('tr_marketi:getPlayerData', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(nil)
        return
    end

    local playerData = {
        money = xPlayer.getMoney(),
        bank = xPlayer.getAccount('bank').money,
        blackMoney = xPlayer.getAccount('money') and xPlayer.getAccount('money').money or 0,
        vCoins = 0
    }

    if Config.GetVipCoinsCallback then
        Config.GetVipCoinsCallback(source, function(vCoins)
            playerData.vCoins = vCoins or 0
            cb(playerData)
        end)
    else
        cb(playerData)
    end
end)

ESX.RegisterServerCallback('tr_marketi:buyItems', function(source, cb, marketType, items, paymentMethod, totalPrice)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(false, "Player not found")
        return
    end
    
    if not Config.Markets[marketType] then
        cb(false, "Invalid market type")
        return
    end
    
    local shopData = Config.Markets[marketType]
    local totalCost, totalVipCost = 0, 0
    local itemsToGive, logItems = {}, {}
    
    for _, cartItem in pairs(items) do
        local foundItem
        for _, category in pairs(shopData.categories) do
            for _, shopItem in pairs(category.items) do
                if shopItem.name == cartItem.item then
                    foundItem = shopItem
                    break
                end
            end
            if foundItem then break end
        end
        
        if not foundItem then
            cb(false, "Item not found: " .. cartItem.item)
            return
        end

        if foundItem.isVip then
            local itemTotal = foundItem.vipPrice * cartItem.quantity
            totalVipCost = totalVipCost + itemTotal
            table.insert(logItems, string.format("%s x%d (%d vCoins)", cartItem.item, cartItem.quantity, itemTotal))
        else
            local itemTotal = foundItem.price * cartItem.quantity
            totalCost = totalCost + itemTotal
            table.insert(logItems, string.format("%s x%d ($%d)", cartItem.item, cartItem.quantity, itemTotal))
        end

        table.insert(itemsToGive, {
            item = cartItem.item,
            count = cartItem.quantity,
            isVip = foundItem.isVip
        })
    end

    if totalVipCost > 0 then
        local vCoins = MySQL.Sync.fetchScalar('SELECT vCoins FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }) or 0

        if vCoins < totalVipCost then
            cb(false, "Not enough vCoins")
            return
        end
    end

    local hasEnoughMoney = false
    if totalCost > 0 then
        if shopData.type == "illegal" then
            if xPlayer.getAccount('money').money >= totalCost then
                hasEnoughMoney = true
            end
        else
            if paymentMethod == "cash" then
                if xPlayer.getMoney() >= totalCost then
                    hasEnoughMoney = true
                end
            elseif paymentMethod == "bank" then
                if xPlayer.getAccount('bank').money >= totalCost then
                    hasEnoughMoney = true
                end
            end
        end
    else
        hasEnoughMoney = true
    end

    if not hasEnoughMoney then
        cb(false, "Not enough money")
        return
    end

    if totalCost > 0 then
        if shopData.type == "illegal" then
            xPlayer.removeAccountMoney('money', totalCost)
        else
            if paymentMethod == "cash" then
                xPlayer.removeMoney(totalCost)
            elseif paymentMethod == "bank" then
                xPlayer.removeAccountMoney('bank', totalCost)
            end
        end
    end

    if totalVipCost > 0 then
        MySQL.Async.execute('UPDATE users SET vCoins = vCoins - @amount WHERE identifier = @identifier', {
            ['@amount'] = totalVipCost,
            ['@identifier'] = xPlayer.identifier
        })
    end

    for _, itemData in pairs(itemsToGive) do
        xPlayer.addInventoryItem(itemData.item, itemData.count)
    end

    local paidText = {}
    if totalCost > 0 then
        local currency = (shopData.type == "illegal" and "money" or paymentMethod)
        table.insert(paidText, string.format("%d %s", totalCost, currency))
    end
    if totalVipCost > 0 then
        table.insert(paidText, string.format("%d vCoins", totalVipCost))
    end

    local ime = kurac
    if marketType == 'regular' then 
        ime = "24/7" 
    elseif marketType == 'liquor' then 
        ime = "Liquor" 
    elseif marketType == 'ltd' then 
        ime = "LTD Gas station" 
    elseif marketType == 'illegal' then 
        ime = "Black Market" 
    end

    local logMessage = string.format(
        "**Player:** %s\n**Identifier:** %s\n**Shop:** %s\n**Bought items:**\n- %s\n**Payed:** %s",
        xPlayer.getName(),
        xPlayer.identifier,
        ime,
        table.concat(logItems, "\n- "),
        table.concat(paidText, " + ")
    )

    SendToDiscord(marketType, ime .. " Shop", logMessage, 3066993, false)

    cb(true, "Kupovina uspešna!")
end)