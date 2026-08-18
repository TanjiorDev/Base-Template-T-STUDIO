-- ==========================================
-- KZB EMOTES - CÔTÉ SERVEUR (Synchronisation)
-- ==========================================

-- 1. Le lanceur demande à faire une animation avec quelqu'un
RegisterNetEvent('kzb_emotes:requestShared')
AddEventHandler('kzb_emotes:requestShared', function(targetServerId, emoteId)
    local requesterId = source
    
    -- On envoie la demande (Y/N) uniquement au joueur ciblé
    TriggerClientEvent('kzb_emotes:receiveRequest', targetServerId, requesterId, emoteId)
end)

-- 2. Le joueur ciblé a appuyé sur 'Y' (Accepter)
RegisterNetEvent('kzb_emotes:acceptShared')
AddEventHandler('kzb_emotes:acceptShared', function(requesterId, emoteId)
    local targetId = source
    
    -- On dit au LANCEUR de démarrer son animation (isTarget = false)
    TriggerClientEvent('kzb_emotes:syncShared', requesterId, emoteId, false, targetId)
    
    -- On dit à la CIBLE de s'accrocher au lanceur et de faire l'animation (isTarget = true)
    TriggerClientEvent('kzb_emotes:syncShared', targetId, emoteId, true, requesterId)
end)