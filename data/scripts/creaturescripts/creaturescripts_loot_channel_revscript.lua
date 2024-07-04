
local lootChannel = CreatureEvent("onLootChannel")
lootChannel:type("login")
lootChannel:register(function(player)
    if player:getStorageValue(STORAGEVALUE_LOOT) == 12345 then
        player:openChannel(13)
    end
    return true
end)

local lootChannelLeave = CreatureEvent("onLootChannelLeave")
lootChannelLeave:type("logout")
lootChannelLeave:register(function(player)
    if player:getStorageValue(STORAGEVALUE_LOOT) == 12345 then
        player:closeChannel(13)
    end
    return true
end)