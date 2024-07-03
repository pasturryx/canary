--local rope = Action()

--function rope.onUse(player, item, fromPosition, target, toPosition, isHotkey)
--	return onUseRope(player, item, fromPosition, target, toPosition, isHotkey)
--end

--rope:id(3003, 646)
--rope:register()
local rope = Action()

-- Asegúrate de definir holeId si no está definido en otra parte
local holeId = {294, 383, 469, 470, 482, 484, 485, 489, 7932, 7933, 8281, 8282, 435}

function rope.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if toPosition.x == CONTAINER_POSITION then
		return false
	end

	local tile = Tile(toPosition)
	if tile and tile:isRopeSpot() then
		player:teleportTo(toPosition:moveUpstairs())
		if target.itemid == 7762 then
			if player:getStorageValue(Storage.RookgaardTutorialIsland.TutorialHintsStorage) < 22 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have successfully used your rope to climb out of the hole. Congratulations! Now continue to the east.")
			end
		end
	elseif table.contains(holeId, target.itemid) then
		toPosition.z = toPosition.z + 1
		tile = Tile(toPosition)
		if tile then
			local thing = tile:getTopVisibleThing()
			if thing then
				if thing:isItem() and thing:getType():isMovable() then
					return thing:moveTo(toPosition:moveUpstairs())
				elseif thing:isCreature() or thing:isPlayer() then
					return thing:teleportTo(toPosition:moveUpstairs())
				end
			end
		end
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	else
		return false
	end
	return true
end

rope:id(3003, 646)
rope:register()
