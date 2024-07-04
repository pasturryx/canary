--local callback = EventCallback()

--function Player:canReceiveLoot()
--	return self:getStamina() > 840
--end

--function callback.monsterOnDropLoot(monster, corpse)
--	local player = Player(corpse:getCorpseOwner())
--	local factor = 1.0
--	local msgSuffix = ""
--	if player and player:canReceiveLoot() then
--		local config = player:calculateLootFactor(monster)
--		factor = config.factor
--		msgSuffix = config.msgSuffix
--	end
--	local mType = monster:getType()
--	if not mType then
--		logger.warning("monsterOnDropLoot: monster has no type")
--		return
--	end

--	local charm = player and player:getCharmMonsterType(CHARM_GUT)
	--local gut = charm and charm:raceId() == mType:raceId()
--
--	local lootTable = mType:generateLootRoll({ factor = factor, gut = gut }, {})
	--corpse:addLoot(lootTable)
--	for _, item in ipairs(lootTable) do
--		if item.gut then
--			msgSuffix = msgSuffix .. " (active charm bonus)"
--		end
--	end
--	local existingSuffix = corpse:getAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX) or ""
	--corpse:setAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX, existingSuffix .. msgSuffix)
--end
--
--callback:register()
local STORAGEVALUE_LOOT = 12345
local callback = EventCallback()

function Player:canReceiveLoot()
    return self:getStamina() > 840
end

function callback.monsterOnDropLoot(monster, corpse)
    local player = Player(corpse:getCorpseOwner())
    if player and player:getStorageValue(STORAGEVALUE_LOOT) == 12345 then
        local factor = 1.0
        local msgSuffix = ""
        if player:canReceiveLoot() then
            local config = player:calculateLootFactor(monster)
            factor = config.factor
            msgSuffix = config.msgSuffix
        end
        local mType = monster:getType()
        if not mType then
            logger.warning("monsterOnDropLoot: monster has no type")
            return true
        end
        local charm = player:getCharmMonsterType(CHARM_GUT)
        local gut = charm and charm:raceId() == mType:raceId()

        local lootTable = mType:generateLootRoll({ factor = factor, gut = gut }, {})
        corpse:addLoot(lootTable)
        for _, item in ipairs(lootTable) do
            if item.gut then
                msgSuffix = msgSuffix .. " (active charm bonus)"
            end
        end
        local existingSuffix = corpse:getAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX) or ""
        corpse:setAttribute(ITEM_ATTRIBUTE_LOOTMESSAGE_SUFFIX, existingSuffix .. msgSuffix)

        local text
        if player:canReceiveLoot() then
           -- text = ("Loot of %s: %s"):format(mType:getNameDescription(), corpse:getContentDescription())
        else
            text = ("Loot of %s: nothing (due to low stamina)"):format(mType:getNameDescription())
        end

        local party = player:getParty()
        if party then
            party:broadcastPartyLoot(text)
        else
            if player:getStorageValue(STORAGEVALUE_LOOT) == 12345 then
                player:sendChannelMessage("", text, TALKTYPE_CHANNEL_O, 13)
            end
        end
        return true
    end

    return false
end
callback:register()