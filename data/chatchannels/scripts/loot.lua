local STORAGEVALUE_LOOT = 12345

function onSpeak(player, type, message)
    if player:getLevel() <= 10000 then
        player:sendCancelMessage("You may not speak into loot channel.")
        return true
    end

    if player:getStorageValue(STORAGEVALUE_LOOT) == 12345 then
        player:sendChannelMessage("", message, TALKTYPE_CHANNEL_O, 13)
        return true
    end

    player:sendTextMessage(MESSAGE_INFO_DESCR, message)
    return false
end

function onJoin(player)
    player:setStorageValue(STORAGEVALUE_LOOT, 12345)
    return true
end

function onLeave(player)
    player:setStorageValue(STORAGEVALUE_LOOT, -1)
    return true
end
