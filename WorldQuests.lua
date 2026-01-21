local _, addon = ...
local CONSTANTS = addon.CONSTANTS
--[[----
--
-- Broker_WorldQuests
--
-- World of Warcraft addon to display world quests in convenient list form.
-- It doesn't do anything on its own; requires a data broker addon!
--
-- Original Author: myno
--
--]]----

function BWQ:WorldQuestsUnlocked()
	if not BWQ.hasUnlockedWorldQuests then
		if (BWQ.expansion == CONSTANTS.EXPANSIONS.THEWARWITHIN) then
			BWQ.hasUnlockedWorldQuests = C_QuestLog.IsQuestFlaggedCompleted(79573) -- See effect #1 under https://www.wowhead.com/spell=434027/world-quests-adventure-mode
		elseif (BWQ.expansion == CONSTANTS.EXPANSIONS.DRAGONFLIGHT) then
			_, _, _, BWQ.hasUnlockedWorldQuests = GetAchievementInfo(16326)
			if not BWQ.hasUnlockedWorldQuests then
				BWQ.hasUnlockedWorldQuests = UnitLevel("player") >= 68 and C_QuestLog.IsQuestFlaggedCompleted(66221)
			end
		else
			BWQ.hasUnlockedWorldQuests = (BWQ.expansion == CONSTANTS.EXPANSIONS.SHADOWLANDS and UnitLevel("player") >= 51 and C_QuestLog.IsQuestFlaggedCompleted(57559))
				or (BWQ.expansion == CONSTANTS.EXPANSIONS.BFA and UnitLevel("player") >= 50 and
					(C_QuestLog.IsQuestFlaggedCompleted(51916) or C_QuestLog.IsQuestFlaggedCompleted(52451) -- horde
					or C_QuestLog.IsQuestFlaggedCompleted(51918) or C_QuestLog.IsQuestFlaggedCompleted(52450))) -- alliance
				or (BWQ.expansion == CONSTANTS.EXPANSIONS.LEGION and UnitLevel("player") >= 45 and
					(C_QuestLog.IsQuestFlaggedCompleted(43341) or C_QuestLog.IsQuestFlaggedCompleted(45727))) -- broken isles
		end
	end

	if not BWQ.hasUnlockedWorldQuests then
		if not BWQ.errorFS then BWQ:CreateErrorFS() end

		local level, quest, errorText
		if BWQ.expansion == CONSTANTS.EXPANSIONS.THEWARWITHIN then
			errorText = "You need to unlock The War Within World Quests\non one of your characters."
		elseif BWQ.expansion == CONSTANTS.EXPANSIONS.DRAGONFLIGHT then
			errorText = "You need to unlock Dragonflight World Quests\non one of your characters."
		elseif BWQ.expansion == CONSTANTS.EXPANSIONS.SHADOWLANDS then
			errorText = "You need to unlock Shadowlands World Quests\non one of your characters."
		elseif BWQ.expansion == CONSTANTS.EXPANSIONS.BFA then
			level = "50"
			quest = self.isHorde and "|cffffff00|Hquest:57559:-1|h[Uniting Zandalar]|h|r" or "|cffffff00|Hquest:51918:-1|h[Uniting Kul Tiras]|h|r"
			errorText = ("You need to reach Level %s and complete the\nquest %s to unlock World Quests."):format(level, quest)
		else -- legion
			level = "45"
			quest = "|cffffff00|Hquest:43341:-1|h[Uniting the Isles]|h|r"
			errorText = ("You need to reach Level %s and complete the\nquest %s to unlock World Quests."):format(level, quest)
		end

		BWQ:SetErrorFSPosition(BWQ.offsetTop)
		BWQ.errorFS:SetText(errorText)
		BWQ:SetSize(BWQ.errorFS:GetStringWidth() + 20, BWQ.errorFS:GetStringHeight() + 45)
		BWQ.errorFS:Show()

		return false
	else
		if BWQ.errorFS then
			BWQ.errorFS:Hide()
		end

		return true
	end
end

function BWQ:ShowNoWorldQuestsInfo()
	if not BWQ.errorFS then BWQ:CreateErrorFS() end

	BWQ.errorFS:ClearAllPoints()
	BWQ:SetErrorFSPosition(BWQ.offsetTop - 10)
	BWQ.errorFS:SetPoint("TOP", BWQ, "TOP", 0, BWQ.offsetTop - 10)

	BWQ.errorFS:SetText("There are no world quests available that match your filter settings.")
	BWQ.errorFS:Show()
end

function BWQ:SetErrorFSPosition(offsetTop)
	if (BWQ.expansion == CONSTANTS.EXPANSIONS.SHADOWLANDS or BWQ.expansion == CONSTANTS.EXPANSIONS.DRAGONFLIGHT or BWQ.expansion == CONSTANTS.EXPANSIONS.THEWARWITHIN) then  -- TODO:  We are not supporting bounty quests for these expansions atm, so the ErrorFS position should be at the top of BWQ
		BWQ.errorFS:SetPoint("TOP", BWQ, "TOP", 0, offsetTop)
	else
		if BWQ.factionDisplay:IsShown() then
			BWQ.errorFS:SetPoint("TOP", BWQ.factionDisplay, "BOTTOM", 0, -10)
		else 
			BWQ.errorFS:SetPoint("TOP", BWQ, "TOP", 0, offsetTop)
		end
	end
end

function BWQ:GetArtifactPowerValue(itemId)
	local millionSearchLocalized = { enUS = "million", enGB = "million", zhCN = "万", frFR = "million", deDE = "Million", esES = "mill", itIT = "milion", koKR = "만", esMX = "mill", ptBR = "milh", ruRU = "млн", zhTW = "萬", }
	local billionSearchLocalized = { enUS = "billion", enGB = "billion", zhCN = "亿", frFR = "milliard", deDE = "Milliarde", esES = "mil millones", itIT = "miliard", koKR = "억", esMX = "mil millones", ptBR = "bilh", ruRU = "млрд", zhTW = "億", }
	local itemInfo = C_Item.GetItemInfo(itemId)
	local itemLink = itemInfo and itemInfo.itemLink
	BWQ.ScanTooltip:SetOwner(BWQ, "ANCHOR_NONE")
	BWQ.ScanTooltip:SetHyperlink(itemLink)
	local numLines = BWQ.ScanTooltip:NumLines()
	local isArtifactPower = false
	for i = 2, numLines do
		local text = _G["BWQScanTooltipTextLeft" .. i]:GetText()

		if text then
			if text:find(ARTIFACT_POWER) then
				isArtifactPower = true
			end

			if isArtifactPower and text:find(ITEM_SPELL_TRIGGER_ONUSE) then
				-- gsub french special-space character (wtf..)
				local power = text:gsub(" ", ""):match("%d+%p?%d*") or "0"
				if (text:find(millionSearchLocalized[BWQ.locale])) then
					-- en locale only use ',' for thousands, shouldn't occur in these million digit numbers
					-- replace ',' for german etc comma numbers so we can do math with them.
					power = power:gsub(",", ".")
					power = power * 1000000
				elseif (text:find(billionSearchLocalized[BWQ.locale])) then
					power = power:gsub(",", ".")
					power = power * 1000000000
				else 
					-- get rid of thousands comma for non-million numbers
					power = power:gsub("%p", "")
				end

				return power
			end
		end
	end
	return "0"
end

function BWQ:GetItemLevelValueForQuestId(questID)
	BWQ.ScanTooltip:SetOwner(BWQ, "ANCHOR_NONE")
	BWQ.ScanTooltip:SetQuestLogItem("reward", 1, questID)
	local numLines = BWQ.ScanTooltip:NumLines()
	for i = 2, numLines do
		local text = _G["BWQScanTooltipTextLeft" .. i]:GetText()
		local e = ITEM_LEVEL_PLUS:find("%%d")
		if text and text:find(ITEM_LEVEL_PLUS:sub(1, e - 1)) then
			return text:match("%d+%+?") or ""
		end
	end
	return ""
end

function BWQ:ValueWithWarModeBonus(questID, value)
	local multiplier = BWQ.warmodeEnabled and 1.1 or 1
	return floor(value * multiplier + 0.5)
end

function BWQ:IsQuestAchievementCriteriaMissing(achievementId, questID)
	local criteriaId = CONSTANTS.ACHIEVEMENT_CRITERIAS[questID]
	if criteriaId then
		local _, _, completed = GetAchievementCriteriaInfo(achievementId, criteriaId)
		return not completed
	else
		return false
	end
end

local ShowQuestObjectiveTooltip = function(row)
	BWQ.tooltip:SetOwner(row, "ANCHOR_CURSOR")
	local color = WORLD_QUEST_QUALITY_COLORS[row.quest.quality]
	BWQ.tooltip:AddLine(row.quest.title, color.r, color.g, color.b, true)

	for objectiveIndex = 1, row.quest.numObjectives do
		local objectiveText, objectiveType, finished = GetQuestObjectiveInfo(row.quest.questID, objectiveIndex, false);
		if objectiveText and #objectiveText > 0 then
			color = finished and GRAY_FONT_COLOR or HIGHLIGHT_FONT_COLOR;
			BWQ.tooltip:AddLine(QUEST_DASH .. objectiveText, color.r, color.g, color.b, true);
		end
	end

	local percent = C_TaskQuest.GetQuestProgressBarInfo(row.quest.questID)
	if percent then
		GameTooltip_ShowProgressBar(BWQ.tooltip, 0, 100, percent, PERCENTAGE_STRING:format(percent))
	end

	BWQ.tooltip:Show()
end

local ShowQuestLogItemTooltip = function(button)
	local name, texture = GetQuestLogRewardInfo(1, button.quest.questID)
	if name and texture then
		BWQ.tooltip:SetOwner(button.reward, "ANCHOR_CURSOR")
		BWQ.ScanTooltip:SetQuestLogItem("reward", 1, button.quest.questID)
		local _, itemLink = BWQ.ScanTooltip:GetItem()
		BWQ.tooltip:SetHyperlink(itemLink)
		BWQ.tooltip:Show()
	end
end

local ShowWorldQuestPOITooltip = function(button,poi)
    BWQ.tooltip:SetOwner(button, "ANCHOR_CURSOR")
    BWQ.tooltip:SetText(poi.name)
	if button.quest.LockedWQ then
		local description = string.format("You must complete %d more %s in %s to unlock '%s', which rewards |5 %s.", button.quest.LockedWQ_questsRemaining, button.quest.LockedWQ_questsRemaining > 1 and "WQs" or "WQ", button.quest.LockedWQ_zone, poi.name, button.quest.reward.itemLink)
    	BWQ.tooltip:AddLine(description, 1, 1, 1, true)
	end
    BWQ.tooltip:Show()
end

function BWQ:QueryZoneQuestCoordinates(mapId)
	local quests = C_TaskQuest.GetQuestsOnMap(mapId)
	if quests then
		for _, v in next, quests do
			local quest = BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[v.questID] 
			if quest then
				quest.x = v.x
				quest.y = v.y
			end
		end
	end
end

function BWQ:CalculateMapPosition(x, y)
	return x * WorldMapFrame:GetCanvas():GetWidth() , -1 * y * WorldMapFrame:GetCanvas():GetHeight() 
end

local Row_OnClick = function(row)
	if IsShiftKeyDown() then
		if (C_QuestLog.GetQuestWatchType(row.quest.questID) == Enum.QuestWatchType.Manual or C_SuperTrack.GetSuperTrackedQuestID() == row.quest.questID) then
			C_QuestLog.RemoveWorldQuestWatch(row.quest.questID)
		else
			C_QuestLog.AddWorldQuestWatch(row.quest.questID, Enum.QuestWatchType.Manual)
		end
	else
		if not WorldMapFrame:IsShown() then ShowUIPanel(WorldMapFrame) end
		if WorldMapFrame:IsShown() then
			WorldMapFrame:SetMapID(row.mapId)
			if not row.quest.x or not row.quest.y then BWQ:QueryZoneQuestCoordinates(row.mapId) end
			if row.quest.x and row.quest.y then
				local x, y = BWQ:CalculateMapPosition(row.quest.x, row.quest.y)
				local scale = WorldMapFrame:GetCanvasScale()
				local size = 30 / scale * 1.35
				BWQ.mapTextures:ClearAllPoints()
				BWQ.mapTextures.highlightArrow:SetSize(size, size)
				BWQ.mapTextures:SetPoint("CENTER", WorldMapFrame:GetCanvas(), "TOPLEFT", x, y + 25 + (scale < 0.5 and 50 or 0))
				BWQ.mapTextures.animationGroup:Play()
			end
		end

		if TomTom and BWQ:C("enableTomTomWaypointsOnClick") then
			if C_AddOns.IsAddOnLoaded("TomTom") then 
				if not row.quest.x or not row.quest.y then BWQ:QueryZoneQuestCoordinates(row.mapId) end
				if row.quest.x and row.quest.y then
					if BWQ.TomTomWaypoints[row.quest.questID] then 
						TomTom:RemoveWaypoint(BWQ.TomTomWaypoints[row.quest.questID]) 
					else
						BWQ.TomTomWaypoints[row.quest.questID] = TomTom:AddWaypoint(row.mapId, row.quest.x, row.quest.y, { title = row.quest.title, silent = true, from = "Broker_WorldQuests" })
					end
				end
			end
		end
	end
end

local DebugRetrieveWQ = false
local RetrieveWorldQuests = function(mapId)
	local numQuests = 0
	local currentTime = GetTime()
	local questList = C_TaskQuest.GetQuestsOnMap(mapId)
	BWQ.warmodeEnabled = C_PvP.IsWarModeDesired()

	if questList then
		numQuests = 0
		BWQ.MAP_ZONES[BWQ.expansion][mapId].questsSort = {}

		local timeLeft, questTagInfo, title, factionId
		for i, q in ipairs(questList) do
			if DebugRetrieveWQ then
				print(string.format("[BWQ] questList.%d: ID: %s (mapId: %d)", i, tostring(q.questID), mapId))
			end
			if HaveQuestData(q.questID) and q.mapID == mapId then 
				timeLeft = C_TaskQuest.GetQuestTimeLeftMinutes(q.questID) or 0
				questTagInfo = C_QuestLog.GetQuestTagInfo(q.questID)

				if DebugRetrieveWQ then
					local _title, _factionId = C_TaskQuest.GetQuestInfoByQuestID(q.questID)
					print(string.format("[BWQ] questList.%d: %s", i, _title))
					if _factionId then print(string.format("[BWQ] questList.%d: faction: %d (%s)", i, _factionId, C_Reputation.GetFactionDataByID(_factionId).name)) end
					if questTagInfo then print(string.format("[BWQ] questList.%d: WorldQuestType: %d", i, questTagInfo.worldQuestType)) end
				end

				if questTagInfo and questTagInfo.worldQuestType then
					local questID = q.questID
					table.insert(BWQ.MAP_ZONES[BWQ.expansion][mapId].questsSort, questID)
					local quest = BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[questID] or {}

					if not quest.timeAdded then
						quest.wasSaved = BWQ.questIds[questID] ~= nil
					end
					quest.timeAdded = quest.timeAdded or currentTime
					if quest.wasSaved or currentTime - quest.timeAdded > 900 then
						quest.isNew = false
					else
						quest.isNew = true
					end

					quest.hide = true
					quest.sort = 0

					-- C_TaskQuest.GetQuestsOnMap fields
					quest.questID = questID
					quest.numObjectives = q.numObjectives
					quest.xFlight = q.x
					quest.yFlight = q.y

					-- C_QuestLog.GetQuestTagInfo fields
					quest.tagId = questTagInfo.tagID
					quest.worldQuestType = questTagInfo.worldQuestType
					quest.quality = questTagInfo.quality
					quest.isElite = questTagInfo.isElite

					title, factionId = C_TaskQuest.GetQuestInfoByQuestID(quest.questID)
					quest.title = title
					quest.factionId = factionId
					if factionId then
						quest.faction = C_Reputation.GetFactionDataByID(factionId).name
					end
					quest.timeLeft = timeLeft
					quest.bounties = {}

					quest.reward = {}
					local rewardType = {}
					local hasReward = false
					
					-- item reward
					if GetNumQuestLogRewards(quest.questID) > 0 then
						local itemName, itemTexture, quantity, quality, isUsable, itemId = GetQuestLogRewardInfo(1, quest.questID)
						if itemName then
							hasReward = true
							quest.reward.itemTexture = itemTexture
							quest.reward.itemId = itemId
							quest.reward.itemQuality = quality
							quest.reward.itemQuantity = quantity
							quest.reward.itemName = itemName
							--print(string.format("[BWQ] Quest %s - %s - %s - %s - %s", quest.questID, quest.title, itemName, itemId, quantity))    -- for debugging
							
							local equipSlot, classId, subClassId
							local itemInfo = C_Item.GetItemInfo(quest.reward.itemId)
							if not itemInfo then
								C_Item.RequestLoadItemDataByID(quest.reward.itemId)
								return  -- wait for item data event
							end
							equipSlot  = itemInfo.itemEquipLoc
							classId    = itemInfo.classID
							subClassId = itemInfo.subclassID

							if classId == 7 then
								quest.sort = quest.sort > CONSTANTS.SORT_ORDER.PROFESSION and quest.sort or CONSTANTS.SORT_ORDER.PROFESSION
								if quest.reward.itemId == 124124 then
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.BLOODOFSARGERAS
								end
								if BWQ:C("showItems") and BWQ:C("showCraftingMaterials") then quest.hide = false end
							elseif equipSlot ~= "" or itemId == 163857 --[[ Azerite Armor Cache ]] then
								quest.sort = quest.sort > CONSTANTS.SORT_ORDER.EQUIP and quest.sort or CONSTANTS.SORT_ORDER.EQUIP
								quest.reward.realItemLevel = BWQ:GetItemLevelValueForQuestId(quest.questID)
								rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.GEAR
								if BWQ:C("showItems") and BWQ:C("showGear") then quest.hide = false end
							elseif C_Soulbinds.IsItemConduitByItemInfo(itemId) == true then
								if BWQ:C("showConduits") then quest.hide = false end
							elseif C_Item.IsAnimaItemByID(itemId) == true then
								if BWQ:C("showAnima") then quest.hide = false end
							elseif itemId == 137642 then -- mark of honor
								quest.sort = quest.sort > CONSTANTS.SORT_ORDER.ITEM and quest.sort or CONSTANTS.SORT_ORDER.ITEM
								rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.MARK_OF_HONOR
								if BWQ:C("showItems") and BWQ:C("showMarkOfHonor") then quest.hide = false end
							elseif itemId == 163036 then -- polished pet charm
								quest.reward.polishedPetCharmsAmount = quest.reward.itemQuantity
								rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.POLISHED_PET_CHARM
							else
								quest.sort = quest.sort > CONSTANTS.SORT_ORDER.ITEM and quest.sort or CONSTANTS.SORT_ORDER.ITEM
								rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.IRRELEVANT
								if BWQ:C("showItems") and BWQ:C("showOtherItems") then quest.hide = false end
							end
						end
					end
					-- gold reward
					local money = GetQuestLogRewardMoney(quest.questID);
					if money > 20000 then -- >2g, hides these silly low gold extra rewards
						hasReward = true
						quest.reward.money = floor(BWQ:ValueWithWarModeBonus(quest.questID, money) / 10000) * 10000
						quest.sort = quest.sort > CONSTANTS.SORT_ORDER.MONEY and quest.sort or CONSTANTS.SORT_ORDER.MONEY
						rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.MONEY

						if money < 1000000 then
							if BWQ:C("showLowGold") then quest.hide = false end
						else
							if BWQ:C("showHighGold") then quest.hide = false end
						end
					end
					-- honor reward
					local honor = GetQuestLogRewardHonor(quest.questID)
					if honor > 0 then
						hasReward = true
						quest.reward.honor = honor
						quest.sort = quest.sort > CONSTANTS.SORT_ORDER.HONOR and quest.sort or CONSTANTS.SORT_ORDER.HONOR
						rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.HONOR

						if BWQ:C("showHonor") then quest.hide = false end
					end
					-- currency reward
					local rewardCurrencies = C_QuestInfoSystem.GetQuestRewardCurrencies(quest.questID)	
					if rewardCurrencies then
						quest.reward.currencies = {}
						for i, currencyInfo in ipairs(rewardCurrencies) do
							local name = currencyInfo.name
							local texture = currencyInfo.texture
							local numItems = currencyInfo.totalRewardAmount
							local currencyId = currencyInfo.currencyID
							--print(string.format("[BWQ] QuestID: %d", quest.questID))														-- Debugging
							--print(string.format("[BWQ] - currencyInfo: %d - %s - %d - %d - %d", i, name, texture, numItems, currencyId))	-- Debugging
							if name then
								hasReward = true
								local currency = {}
								if CONSTANTS.CURRENCIES_AFFECTED_BY_WARMODE[currencyId] then
									currency.amount = BWQ:ValueWithWarModeBonus(quest.questID, numItems)
								else
									currency.amount = numItems
								end
								currency.name = string.format("%d %s", currency.amount, name)
								currency.texture = texture

								--print(string.format("[BWQ] Quest %s - %s - %s - %s - %s - %s - %s", quest.questID, quest.title, name, currencyId, currency.name, currency.texture, currency.amount))    -- for debugging

								if currencyId == 1553 then -- azerite
									currency.name = string.format("|cffe5cc80[%d %s]|r", currency.amount, name)
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.ARTIFACTPOWER
									quest.reward.azeriteAmount = currency.amount -- todo: improve broker text values?
									if BWQ:C("showArtifactPower") then quest.hide = false end
								elseif CONSTANTS.THEWARWITHIN_REPUTATION_CURRENCY_IDS[currencyId] then
									currency.name = string.format("%s: %d %s", name, currency.amount, REPUTATION)
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.IRRELEVANT
									if BWQ:C("showTWWReputation") then quest.hide = false end
								elseif CONSTANTS.DRAGONFLIGHT_REPUTATION_CURRENCY_IDS[currencyId] then
									currency.name = string.format("%s: %d %s", name, currency.amount, REPUTATION)
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.IRRELEVANT
									if BWQ:C("showDFReputation") then quest.hide = false end
								elseif CONSTANTS.SHADOWLANDS_REPUTATION_CURRENCY_IDS[currencyId] then
									currency.name = string.format("%s: %d %s", name, currency.amount, REPUTATION)
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.IRRELEVANT
									if BWQ:C("showSLReputation") then quest.hide = false end
								elseif CONSTANTS.BFA_REPUTATION_CURRENCY_IDS[currencyId] then
									currency.name = string.format("%s: %d %s", name, currency.amount, REPUTATION)
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.IRRELEVANT
									if BWQ:C("showBFAReputation") then quest.hide = false end
								elseif currencyId == 1560 then -- war resources
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.WAR_RESOURCES
									quest.reward.warResourceAmount = currency.amount
									if BWQ:C("showWarResources") then quest.hide = false end
								elseif currencyId == 1716 or currencyId == 1717 then -- service medals
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.SERVICE_MEDAL
									quest.reward.serviceMedalAmount = currency.amount
									if BWQ:C("showBFAServiceMedals") then quest.hide = false end
								elseif currencyId == 1220 then -- order hall resources
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.RESOURCES
									quest.reward.resourceAmount = currency.amount
									if BWQ:C("showResources") then quest.hide = false end
								elseif currencyId == 1342 then -- legionfall supplies
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.LEGIONFALL_SUPPLIES
									quest.reward.legionfallSuppliesAmount = currency.amount
									if BWQ:C("showLegionfallSupplies") then quest.hide = false end
								elseif currencyId == 1226 then -- nethershard
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.NETHERSHARD
									if BWQ:C("showNethershards") then quest.hide = false end
								elseif currencyId == 1508 then -- argunite
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.ARGUNITE
									if BWQ:C("showArgunite") then quest.hide = false end
								elseif currencyId == 1533 then
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.WAKENING_ESSENCE
									quest.reward.wakeningEssencesAmount = currency.amount
									if BWQ:C("showWakeningEssences") then quest.hide = false end
								elseif currencyId == 1721 then -- prismatic manapearl
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.PRISMATIC_MANAPEARL
									quest.reward.prismaticManapearlAmount = currency.amount
									if BWQ:C("showPrismaticManapearl") then quest.hide = false end
								elseif currencyId == 1979 then -- cyphers of the first ones (Zereth Mortis - 9.2)
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.CYPHERS_OF_THE_FIRST_ONES
									quest.reward.cyphersOfTheFirstOnesAmount = currency.amount
									if BWQ:C("showCyphersOfTheFirstOnes") then quest.hide = false end
								elseif currencyId == 1885 then -- grateful offering
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.GRATEFUL_OFFERING
									quest.reward.gratefulOfferingAmount = currency.amount
									if BWQ:C("showGratefulOffering") then quest.hide = false end
								elseif currencyId == 2123 then -- bloody tokens
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.BLOODY_TOKENS
									quest.reward.bloodyTokensAmount = currency.amount
									if BWQ:C("showBloodyTokens") then quest.hide = false end
								elseif currencyId == 2003 then -- dragon isles supplies
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.DRAGON_ISLES_SUPPLIES
									quest.reward.dragonIslesSuppliesAmount = currency.amount
									if BWQ:C("showDragonIslesSupplies") then quest.hide = false end
								elseif currencyId == 2118 then -- elemental overflow
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.ELEMENTAL_OVERFLOW
									quest.reward.elementalOverflowAmount = currency.amount
									if BWQ:C("showElementalOverflow") then quest.hide = false end
								elseif currencyId == 2245 then -- flightstones
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.FLIGHTSTONES
									quest.reward.flightstonesAmount = currency.amount
									if BWQ:C("showFlightstones") then quest.hide = false end
								elseif currencyId == 2706 then -- Whelplings Dreaming Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.WHELPLINGS_DREAMING_CREST
									quest.reward.WhelplingsDreamingCrestAmount = currency.amount
									if BWQ:C("showWhelplingsDreamingCrest") then quest.hide = false end
								elseif currencyId == 2707 then -- Drakes Dreaming Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.DRAKES_DREAMING_CREST
									quest.reward.DrakesDreamingCrestAmount = currency.amount
									if BWQ:C("showDrakesDreamingCrest") then quest.hide = false end
								elseif currencyId == 2708 then -- Wyrms Dreaming Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.WYRMS_DREAMING_CREST
									quest.reward.WyrmsDreamingCrestAmount = currency.amount
									if BWQ:C("showWyrmsDreamingCrest") then quest.hide = false end
								elseif currencyId == 2709 then -- Aspects Dreaming Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.ASPECTS_DREAMING_CREST
									quest.reward.AspectsDreamingCrestAmount = currency.amount
									if BWQ:C("showAspectsDreamingCrest") then quest.hide = false end
								elseif currencyId == 2806 then -- Whelplings Awakened Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.WHELPLINGS_Awakened_CREST
									quest.reward.WhelplingsAwakenedCrestAmount = currency.amount
									if BWQ:C("showWhelplingsAwakenedCrest") then quest.hide = false end
								elseif currencyId == 2807 then -- Drakes Awakened Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.DRAKES_Awakened_CREST
									quest.reward.DrakesAwakenedCrestAmount = currency.amount
									if BWQ:C("showDrakesAwakenedCrest") then quest.hide = false end
								elseif currencyId == 2809 then -- Wyrms Awakened Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.WYRMS_Awakened_CREST
									quest.reward.WyrmsAwakenedCrestAmount = currency.amount
									if BWQ:C("showWyrmsAwakenedCrest") then quest.hide = false end
								elseif currencyId == 2812 then -- Aspects Awakened Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.ASPECTS_Awakened_CREST
									quest.reward.AspectsAwakenedCrestAmount = currency.amount
									if BWQ:C("showAspectsAwakenedCrest") then quest.hide = false end
								elseif currencyId == 2657 then -- Mysterious Fragment
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.MYSTERIOUS_FRAGMENT
									quest.reward.MysteriousFragmentAmount = currency.amount
									if BWQ:C("showMysteriousFragment") then quest.hide = false end
								elseif currencyId == 2815 then -- Resonance Crystals
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.RESONANCE_CRYSTALS
									quest.reward.ResonanceCrystalsAmount = currency.amount
									if BWQ:C("showResonanceCrystals") then quest.hide = false end
								elseif currencyId == 2902 then -- The Assembly of the Deeps
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.THE_ASSEMBLY_OF_THE_DEEPS
									quest.reward.TheAssemblyoftheDeepsAmount = currency.amount
									if BWQ:C("showTheAssemblyoftheDeeps") then quest.hide = false end
								elseif currencyId == 2899 then -- Hallowfall Arathi
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.HALLOWFALL_ARATHI
									quest.reward.HallowfallArathiAmount = currency.amount
									if BWQ:C("showHallowfallArathi") then quest.hide = false end
								elseif currencyId == 3008 then -- Valorstones
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.VALORSTONES
									quest.reward.ValorstonesAmount = currency.amount
									if BWQ:C("showValorstones") then quest.hide = false end
								elseif currencyId == 3056 then -- Kej
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.KEJ
									quest.reward.KejAmount = currency.amount
									if BWQ:C("showKej") then quest.hide = false end
								elseif currencyId == 2897 then -- Council of Dornogal
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.COUNCIL_OF_DORNOGAL
									quest.reward.CouncilofDornogalAmount = currency.amount
									if BWQ:C("showCouncilofDornogal") then quest.hide = false end
								elseif currencyId == 3002 then -- The Weaver
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.THE_WEAVER
									quest.reward.TheWeaverAmount = currency.amount
									if BWQ:C("showTheWeaver") then quest.hide = false end
								elseif currencyId == 3003 then -- The General
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.THE_GENERAL
									quest.reward.TheGeneralAmount = currency.amount
									if BWQ:C("showTheGeneral") then quest.hide = false end
								elseif currencyId == 3004 then -- The Vizier
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.THE_VIZIER
									quest.reward.TheVizierAmount = currency.amount
									if BWQ:C("showTheVizier") then quest.hide = false end
								elseif currencyId == 3100 then -- Bronze Celebration Token
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.BRONZE_CELEBRATION_TOKEN
									quest.reward.BronzeCelebrationTokenAmount = currency.amount
									if BWQ:C("showBronzeCelebrationToken") then quest.hide = false end
								elseif currencyId == 3107 then -- Weathered Undermine Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.WEATHERED_UNDERMINE_CREST
									quest.reward.WeatheredUndermineCrestAmount = currency.amount
									if BWQ:C("showWeatheredUndermineCrest") then quest.hide = false end
								elseif currencyId == 3108 then -- Carved Undermine Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.CARVED_UNDERMINE_CREST
									quest.reward.CarvedUndermineCrestAmount = currency.amount
									if BWQ:C("showCarvedUndermineCrest") then quest.hide = false end
								elseif currencyId == 3118 then -- The Cartels of Undermine
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.THE_CARTELS_OF_UNDERMINE
									quest.reward.TheCartelsOfUndermineAmount = currency.amount
									if BWQ:C("showTheCartelsOfUndermine") then quest.hide = false end
								elseif currencyId == 3169 then -- The Bilgewater Cartel
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.THE_BILGEWATER_CARTEL
									quest.reward.TheBilgewaterCartelAmount = currency.amount
									if BWQ:C("showTheBilgewaterCartel") then quest.hide = false end
								elseif currencyId == 3171 then -- The Blackwater Cartel
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.THE_BLACKWATER_CARTEL
									quest.reward.TheBlackwaterCartelAmount = currency.amount
									if BWQ:C("showTheBlackwaterCartel") then quest.hide = false end
								elseif currencyId == 3173 then -- The Steamwheedle Cartel
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.THE_STEAMWHEEDLE_CARTEL
									quest.reward.TheSteamwheedleCartelAmount = currency.amount
									if BWQ:C("showTheSteamwheedleCartel") then quest.hide = false end
								elseif currencyId == 3175 then -- The Venture Company
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.THE_VENTURE_COMPANY
									quest.reward.TheVentureCompanyAmount = currency.amount
									if BWQ:C("showTheVentureCompany") then quest.hide = false end		
								elseif currencyId == 3284 then -- Weathered Ethereal Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.WEATHERED_ETHEREAL_CREST
									quest.reward.WeatheredEtherealCrestAmount = currency.amount
									if BWQ:C("showWeatheredEtherealCrest") then quest.hide = false end								
								else 
									if BWQcfg.spewDebugInfo then print(string.format("[BWQ] Unhandled currency: ID %s", currencyId)) end
								end
								quest.reward.currencies[#quest.reward.currencies + 1] = currency

								if currencyId == 1553 then
									quest.sort = quest.sort > CONSTANTS.SORT_ORDER.ARTIFACTPOWER and quest.sort or CONSTANTS.SORT_ORDER.ARTIFACTPOWER
								else
									quest.sort = quest.sort > CONSTANTS.SORT_ORDER.RESOURCES and quest.sort or CONSTANTS.SORT_ORDER.RESOURCES
								end
							end
						end
					end
					-- xp reward [Only show if XP is the only reward (i.e., if none of the above are rewards)]
					if not hasReward then
						local xp = GetQuestLogRewardXP(quest.questID)
						if xp > 0 then
							hasReward = true
							quest.reward.xp = xp
							quest.sort = quest.sort > CONSTANTS.SORT_ORDER.XP and quest.sort or CONSTANTS.SORT_ORDER.XP
							rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.XP
							
							if BWQ:C("showXP") then quest.hide = false end
						end
					end
					if BWQcfg.spewDebugInfo and not hasReward and not HaveQuestData(quest.questID) then
						print(string.format("[BWQ] Quest with no reward found: ID %s (%s)", quest.questID, quest.title))
					end
					if not hasReward then BWQ.needsRefresh = true end -- in most cases no reward means api returned incomplete data
					
					for _, bounty in ipairs(BWQ.bounties) do
						if C_QuestLog.IsQuestCriteriaForBounty(quest.questID, bounty.questID) then
							quest.bounties[#quest.bounties + 1] = bounty.icon
						end
					end
					local questType = {}

					-- quest type filters
					if quest.worldQuestType == Enum.QuestTagType.PetBattle then
						if BWQ:C("showPetBattle") or (BWQ:C("alwaysShowPetBattleFamilyFamiliar") and CONSTANTS.FAMILY_FAMILIAR_QUEST_IDS[quest.questID] ~= nil) then
							quest.hide = false
						else
							quest.hide = true
						end

						quest.isMissingAchievementCriteria = BWQ:IsQuestAchievementCriteriaMissing(CONSTANTS.ACHIEVEMENT_IDS.PET_BATTLE_WQ[BWQ.expansion], quest.questID)
					elseif quest.worldQuestType == Enum.QuestTagType.Profession then
						if BWQ:C("showProfession") then

							if quest.tagId == 119 then
								questType[#questType+1] = CONSTANTS.QUEST_TYPES.HERBALISM
								if BWQ:C("showProfessionHerbalism")	then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 120 then
								questType[#questType+1] = CONSTANTS.QUEST_TYPES.MINING
								if BWQ:C("showProfessionMining") then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 130 then
								questType[#questType+1] = CONSTANTS.QUEST_TYPES.FISHING
								quest.isMissingAchievementCriteria = BWQ:IsQuestAchievementCriteriaMissing(CONSTANTS.ACHIEVEMENT_IDS.LEGION_FISHING_WQ, quest.questID)
								if BWQ:C("showProfessionFishing") then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 124 then
								questType[#questType+1] = CONSTANTS.QUEST_TYPES.SKINNING
								if BWQ:C("showProfessionSkinning") then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 118 then 	if BWQ:C("showProfessionAlchemy") 			then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 129 then	if BWQ:C("showProfessionArchaeology") 		then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 116 then 	if BWQ:C("showProfessionBlacksmithing") 	then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 131 then 	if BWQ:C("showProfessionCooking") 			then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 123 then 	if BWQ:C("showProfessionEnchanting") 		then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 122 then 	if BWQ:C("showProfessionEngineering") 		then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 126 then 	if BWQ:C("showProfessionInscription") 		then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 125 then 	if BWQ:C("showProfessionJewelcrafting") 	then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 117 then 	if BWQ:C("showProfessionLeatherworking") 	then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 121 then 	if BWQ:C("showProfessionTailoring") 		then quest.hide = false else quest.hide = true end
							end
						else
							quest.hide = true
						end
					elseif not BWQ:C("showPvP") and quest.worldQuestType == Enum.QuestTagType.PvP then quest.hide = true
					elseif not BWQ:C("showDungeon") and quest.worldQuestType == Enum.QuestTagType.Dungeon then quest.hide = true
					elseif not BWQ:C("showDragonRiderRacing") and quest.worldQuestType == Enum.QuestTagType.DragonRiderRacing then quest.hide = true
					end

					-- only show quest that are blue or above quality
					if (BWQ:C("onlyShowRareOrAbove") and quest.quality < 1) then quest.hide = true end

					-- always show bounty quests or reputation for faction filter
					if (BWQ:C("alwaysShowBountyQuests") and #quest.bounties > 0) or
						-- Dragonflight
						(BWQ:C("alwaysShowDragonscaleExpedition") and quest.factionId == 2507) or
						(BWQ:C("alwaysShowIskaaraTuskarr") and quest.factionId == 2511) or
						(BWQ:C("alwaysShowMaruukCentaur") and quest.factionId == 2503) or
						(BWQ:C("alwaysShowValdrakkenAccord") and quest.factionId == 2510) or
						(BWQ:C("alwaysShowLoammNiffen") and quest.factionId == 2564) or
						(BWQ:C("alwaysShowDreamWardens") and quest.factionId == 2574) or
						-- Shadowlands
						(BWQ:C("alwaysShowAscended") and quest.factionId == 2407) or
						(BWQ:C("alwaysShowUndyingArmy") and quest.factionId == 2410) or
						(BWQ:C("alwaysShowCourtofHarvesters") and quest.factionId == 2413) or
						(BWQ:C("alwaysShowAvowed") and quest.factionId == 2439) or
						(BWQ:C("alwaysShowWildHunt") and quest.factionId == 2465) or
						(BWQ:C("alwaysShowDeathsAdvance") and quest.factionId == 2470) or
						(BWQ:C("alwaysShowEnlightened") and quest.factionId == 2478) or
						-- bfa
						(BWQ:C("alwaysShow7thLegion") and quest.factionId == 2159) or
						(BWQ:C("alwaysShowStormsWake") and quest.factionId == 2162) or
						(BWQ:C("alwaysShowOrderOfEmbers") and quest.factionId == 2161) or
						(BWQ:C("alwaysShowProudmooreAdmiralty") and quest.factionId == 2160) or
						(BWQ:C("alwaysShowTheHonorbound") and quest.factionId == 2157) or
						(BWQ:C("alwaysShowZandalariEmpire") and quest.factionId == 2103) or
						(BWQ:C("alwaysShowTalanjisExpedition") and quest.factionId == 2156) or
						(BWQ:C("alwaysShowVoldunai") and quest.factionId == 2158) or
						(BWQ:C("alwaysShowTortollanSeekers") and quest.factionId == 2163) or
						(BWQ:C("alwaysShowChampionsOfAzeroth") and quest.factionId == 2164) or
						-- 8.2 --
						(BWQ:C("alwaysShowTheUnshackled") and quest.factionId == 2373) or
						(BWQ:C("alwaysShowWavebladeAnkoan") and quest.factionId == 2400) or
						(BWQ:C("alwaysShowRustboltResistance") and quest.factionId == 2391) or
						-- legion
						(BWQ:C("alwaysShowCourtOfFarondis") and (mapId == 630 or mapId == 790)) or
						(BWQ:C("alwaysShowDreamweavers") and mapId == 641) or
						(BWQ:C("alwaysShowHighmountainTribe") and mapId == 650) or
						(BWQ:C("alwaysShowNightfallen") and mapId == 680) or
						(BWQ:C("alwaysShowWardens") and quest.factionId == 1894) or
						(BWQ:C("alwaysShowValarjar") and mapId == 634) or
						(BWQ:C("alwaysShowArmiesOfLegionfall") and mapId == 646) or
						(BWQ:C("alwaysShowArmyOfTheLight") and quest.factionId == 2165) or
						(BWQ:C("alwaysShowArgussianReach") and quest.factionId == 2170) then

						-- pet battle override
						if BWQ:C("hidePetBattleBountyQuests") and not BWQ:C("showPetBattle") and quest.worldQuestType == Enum.QuestTagType.PetBattle then
							quest.hide = true
						else
							quest.hide = false
						end
					end
					-- don't filter epic quests based on setting
					if BWQ:C("alwaysShowEpicQuests") and (quest.quality == 2 or quest.worldQuestType == Enum.QuestTagType.Raid) then quest.hide = false end

					BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[questID] = quest

					if not quest.hide then
						numQuests = numQuests + 1

						if rewardType then
							for _, rtype in next, rewardType do
								if rtype == CONSTANTS.REWARD_TYPES.POLISHED_PET_CHARM then
									BWQ.totalPolishedPetCharms = BWQ.totalPolishedPetCharms + quest.reward.polishedPetCharmsAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.ARTIFACTPOWER and quest.reward.azeriteAmount then
									BWQ.totalArtifactPower = BWQ.totalArtifactPower + (quest.reward.azeriteAmount or 0)
								elseif rtype == CONSTANTS.REWARD_TYPES.WAKENING_ESSENCE and quest.reward.wakeningEssencesAmount then
									BWQ.totalWakeningEssences = BWQ.totalWakeningEssences + quest.reward.wakeningEssencesAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.WAR_RESOURCES and quest.reward.warResourceAmount then
									BWQ.totalWarResources = BWQ.totalWarResources + quest.reward.warResourceAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.SERVICE_MEDAL and quest.reward.serviceMedalAmount then
									BWQ.totalServiceMedals = BWQ.totalServiceMedals + quest.reward.serviceMedalAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.RESOURCES and quest.reward.resourceAmount then
									BWQ.totalResources = BWQ.totalResources + quest.reward.resourceAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.LEGIONFALL_SUPPLIES and quest.reward.legionfallSuppliesAmount then
									BWQ.totalLegionfallSupplies = BWQ.totalLegionfallSupplies + quest.reward.legionfallSuppliesAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.XP and quest.reward.xp then
									BWQ.totalXP = BWQ.totalXP + quest.reward.xp
								elseif rtype == CONSTANTS.REWARD_TYPES.HONOR and quest.reward.honor then
									BWQ.totalHonor = BWQ.totalHonor + quest.reward.honor
								elseif rtype == CONSTANTS.REWARD_TYPES.MONEY and quest.reward.money then
									BWQ.totalGold = BWQ.totalGold + quest.reward.money
								elseif rtype == CONSTANTS.REWARD_TYPES.BLOODOFSARGERAS and quest.reward.itemQuantity then
									BWQ.totalBloodOfSargeras = BWQ.totalBloodOfSargeras + quest.reward.itemQuantity
								elseif rtype == CONSTANTS.REWARD_TYPES.GEAR then
									BWQ.totalGear = BWQ.totalGear + 1
								elseif rtype == CONSTANTS.REWARD_TYPES.MARK_OF_HONOR then
									BWQ.totalMarkOfHonor = BWQ.totalMarkOfHonor + quest.reward.itemQuantity
								elseif rtype == CONSTANTS.REWARD_TYPES.PRISMATIC_MANAPEARL then
									BWQ.totalPrismaticManapearl = BWQ.totalPrismaticManapearl + quest.reward.prismaticManapearlAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.CYPHERS_OF_THE_FIRST_ONES then
									BWQ.totalCyphersOfTheFirstOnes = BWQ.totalCyphersOfTheFirstOnes + quest.reward.cyphersOfTheFirstOnesAmount
				 				elseif rtype == CONSTANTS.REWARD_TYPES.GRATEFUL_OFFERING then
									BWQ.totalGratefulOffering = BWQ.totalGratefulOffering + quest.reward.gratefulOfferingAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.BLOODY_TOKENS then
									BWQ.totalBloodyTokens = BWQ.totalBloodyTokens + quest.reward.bloodyTokensAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.DRAGON_ISLES_SUPPLIES then
									BWQ.totalDragonIslesSupplies = BWQ.totalDragonIslesSupplies + quest.reward.dragonIslesSuppliesAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.ELEMENTAL_OVERFLOW then
									BWQ.totalElementalOverflow = BWQ.totalElementalOverflow + quest.reward.elementalOverflowAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.FLIGHTSTONES then
									BWQ.totalFlightstones = BWQ.totalFlightstones + quest.reward.flightstonesAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.WHELPLINGS_DREAMING_CREST then
									BWQ.totalWhelplingsDreamingCrest = BWQ.totalWhelplingsDreamingCrest + quest.reward.WhelplingsDreamingCrestAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.DRAKES_DREAMING_CREST then
									BWQ.totalDrakesDreamingCrest = BWQ.totalDrakesDreamingCrest + quest.reward.DrakesDreamingCrestAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.WYRMS_DREAMING_CREST then
									BWQ.totalWyrmsDreamingCrest = BWQ.totalWyrmsDreamingCrest + quest.reward.WyrmsDreamingCrestAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.ASPECTS_DREAMING_CREST then
									BWQ.totalAspectsDreamingCrest = BWQ.totalAspectsDreamingCrest + quest.reward.AspectsDreamingCrestAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.WHELPLINGS_Awakened_CREST then
									BWQ.totalWhelplingsAwakenedCrest = BWQ.totalWhelplingsAwakenedCrest + quest.reward.WhelplingsAwakenedCrestAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.DRAKES_Awakened_CREST then
									BWQ.totalDrakesAwakenedCrest = BWQ.totalDrakesAwakenedCrest + quest.reward.DrakesAwakenedCrestAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.WYRMS_Awakened_CREST then
									BWQ.totalWyrmsAwakenedCrest = BWQ.totalWyrmsAwakenedCrest + quest.reward.WyrmsAwakenedCrestAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.ASPECTS_Awakened_CREST then
									BWQ.totalAspectsAwakenedCrest = BWQ.totalAspectsAwakenedCrest + quest.reward.AspectsAwakenedCrestAmount	
								elseif rtype == CONSTANTS.REWARD_TYPES.MYSTERIOUS_FRAGMENT then
									BWQ.totalMysteriousFragment = BWQ.totalMysteriousFragment + quest.reward.MysteriousFragmentAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.RESONANCE_CRYSTALS then
									BWQ.totalResonanceCrystals = BWQ.totalResonanceCrystals + quest.reward.ResonanceCrystalsAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.THE_ASSEMBLY_OF_THE_DEEPS then
									BWQ.totalTheAssemblyOfTheDeeps = BWQ.totalTheAssemblyOfTheDeeps + quest.reward.TheAssemblyoftheDeepsAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.HALLOWFALL_ARATHI then
									BWQ.totalHallowfallArathi = BWQ.totalHallowfallArathi + quest.reward.HallowfallArathiAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.VALORSTONES then
									BWQ.totalValorstones = BWQ.totalValorstones + quest.reward.ValorstonesAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.KEJ then
									BWQ.totalKej = BWQ.totalKej + quest.reward.KejAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.COUNCIL_OF_DORNOGAL then
									BWQ.totalCouncilofDornogal = BWQ.totalCouncilofDornogal + quest.reward.CouncilofDornogalAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.THE_WEAVER then
									BWQ.totalTheWeaver = BWQ.totalTheWeaver + quest.reward.TheWeaverAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.THE_GENERAL then
									BWQ.totalTheGeneral = BWQ.totalTheGeneral + quest.reward.TheGeneralAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.THE_VIZIER then
									BWQ.totalTheVizier = BWQ.totalTheVizier + quest.reward.TheVizierAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.BRONZE_CELEBRATION_TOKEN then
									BWQ.totalBronzeCelebrationToken = BWQ.totalBronzeCelebrationToken + quest.reward.BronzeCelebrationTokenAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.WEATHERED_UNDERMINE_CREST then
									BWQ.totalWeatheredUndermineCrest = BWQ.totalWeatheredUndermineCrest + quest.reward.WeatheredUndermineCrestAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.CARVED_UNDERMINE_CREST then
									BWQ.totalCarvedUndermineCrest = BWQ.totalCarvedUndermineCrest + quest.reward.CarvedUndermineCrestAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.THE_CARTELS_OF_UNDERMINE then
									BWQ.totalTheCartelsOfUndermine = BWQ.totalTheCartelsOfUndermine + quest.reward.TheCartelsOfUndermineAmount
								elseif rtype == CONSTANTS.REWARD_TYPES.THE_BILGEWATER_CARTEL then
									BWQ.totalTheBilgewaterCartel = BWQ.totalTheBilgewaterCartel + quest.reward.TheBilgewaterCartelAmount	
								elseif rtype == CONSTANTS.REWARD_TYPES.THE_BLACKWATER_CARTEL then
									BWQ.totalTheBlackwaterCartel = BWQ.totalTheBlackwaterCartel + quest.reward.TheBlackwaterCartelAmount	
								elseif rtype == CONSTANTS.REWARD_TYPES.THE_STEAMWHEEDLE_CARTEL then
									BWQ.totalTheSteamwheedleCartel = BWQ.totalTheSteamwheedleCartel + quest.reward.TheSteamwheedleCartelAmount	
								elseif rtype == CONSTANTS.REWARD_TYPES.THE_VENTURE_COMPANY then
									BWQ.totalTheVentureCompany = BWQ.totalTheVentureCompany + quest.reward.TheVentureCompanyAmount										
								elseif rtype == CONSTANTS.REWARD_TYPES.WEATHERED_ETHEREAL_CREST then
									BWQ.totalWeatheredEtherealCrest = BWQ.totalWeatheredEtherealCrest + quest.reward.WeatheredEtherealCrestAmount
								end
							end
						end
						if questType then
							for _, qtype in next, questType do
								if qtype == CONSTANTS.QUEST_TYPES.HERBALISM then
									BWQ.totalHerbalism = BWQ.totalHerbalism + 1
								elseif qtype == CONSTANTS.QUEST_TYPES.MINING then
									BWQ.totalMining = BWQ.totalMining + 1
								elseif qtype == CONSTANTS.QUEST_TYPES.FISHING then
									BWQ.totalFishing = BWQ.totalFishing + 1
								elseif qtype == CONSTANTS.QUEST_TYPES.SKINNING then
									BWQ.totalSkinning = BWQ.totalSkinning + 1
								end
							end
						end
					else
						--[[
						if BWQcfg.spewDebugInfo then
							print("-------")
							print("[BWQ] Quest Hidden!")
							print("[BWQ] -- Title: "..tostring(quest.title))
							print("[BWQ] -- ID: "..tostring(quest.questID))
							print("[BWQ] -- tagName: "..tostring(quest.tagName))
							print("[BWQ] -- tagId: "..tostring(quest.tagId))
							print("[BWQ] -- worldQuestType: "..tostring(quest.worldQuestType))
							if (quest.factionId) then
								print("[BWQ] -- faction: "..tostring(quest.faction).." (factionID: "..tostring(quest.factionId)..")")
							end
							print("-------")
						end
						]]
					end
				end
			end
			if DebugRetrieveWQ then
				print("[BWQ] ---")
			end
		end

		if BWQ:C("sortByTimeRemaining") then
			table.sort(BWQ.MAP_ZONES[BWQ.expansion][mapId].questsSort, function(a, b) return BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[a].timeLeft < BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[b].timeLeft end)
		else -- reward type
			table.sort(BWQ.MAP_ZONES[BWQ.expansion][mapId].questsSort, function(a, b) return BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[a].sort > BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[b].sort end)
		end

		BWQ.MAP_ZONES[BWQ.expansion][mapId].numQuests = numQuests
	end

	-- Retrieve locked world quests (i.e., capstone quests), which are handled differently
	local areaPoiIDs = C_AreaPoiInfo.GetAreaPOIForMap(mapId)
    if areaPoiIDs then
        for i, poiID in ipairs(areaPoiIDs) do
            local poi = C_AreaPoiInfo.GetAreaPOIInfo(mapId,poiID)
            if poi and string.find(poi.name, "Special Assignment") then		-- TODO:  Are there other "names" that should be showing other than "Special Assignment" quests?
				local questID = poi.areaPoiID
				table.insert(BWQ.MAP_ZONES[BWQ.expansion][mapId].questsSort, questID)
				local quest = BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[questID] or {}
				quest.title = poi.name
				quest.LockedWQ = true
				if not quest.timeAdded then
					quest.wasSaved = BWQ.questIds[questID] ~= nil
				end
				quest.timeAdded = quest.timeAdded or currentTime
				if quest.wasSaved or currentTime - quest.timeAdded > 900 then
					quest.isNew = false
				else
					quest.isNew = true
				end
				quest.hide = false											-- TODO:  Add option to hide locked world quests ...always showing them for now.
				quest.sort = 0
				quest.questID = questID
				quest.numObjectives = 0										-- Not used
				quest.xFlight = poi.position.x
				quest.yFlight = poi.position.x
				quest.tagId = -1
				quest.worldQuestType = Enum.QuestTagType.Capstone			-- TODO: all locked WQs are currently capstone types.  (Not sure if this is even needed to be set in this context?)
				quest.quality = Enum.WorldQuestQuality.Common				-- Set to 'Common' so that the quest title is white.
				quest.isElite = true										-- TODO: Any reason not to set these locked quests as 'elite'?
				quest.factionId = poi.factionID
				if factionId then
					quest.faction = C_Reputation.GetFactionDataByID(factionId).name
				end
				quest.bounties = {}
				quest.reward = {}
				local rewardType = {}
				local hasReward = false
				quest.isMissingAchievementCriteria = false					-- TODO:  set this properly?  Right now just setting to false as a default.
				quest.poi = poi

				-- Go through widgets to get reward and time remaining information
				if not poi.tooltipWidgetSet then
					quest.hide = true
				else
					local widgets = C_UIWidgetManager.GetAllWidgetsBySetID(poi.tooltipWidgetSet)
					if widgets then
						for j, widget in pairs(widgets) do
							if widget.widgetType == Enum.UIWidgetVisualizationType.TextWithState then
								local widgetInfo = C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo(widget.widgetID)
								if widgetInfo then
									if string.find(widgetInfo.text, "Time Left:") then
										local timeLeftStr = string.match(widgetInfo.text, "Time Left:%s*(.+)")

										-- Note that WoW uses escape codes for singular/plural type things like this, which will not show up
										-- with print().  To see them, you have to convert the string to a table, then use DevTools_Dump() -- for example: local tmp = { stringToDump }    DevTools_Dump(tmp)
										-- See also:  https://warcraft.wiki.gg/wiki/UI_escape_sequences#Plural
										local days = string.match(timeLeftStr, "(%d+)%s*|4Day:Days;")
										local hours = string.match(timeLeftStr, "(%d+)%s*|4Hour:Hours;")
										days = days and tonumber(days) or 0				-- Convert to numbers, default to 0 if not found
										hours = hours and tonumber(hours) or 0			-- Convert to numbers, default to 0 if not found
										local totalMinutes = (days * 24 * 60) + (hours * 60)
										quest.timeLeft = totalMinutes
										quest.timeLeftString = timeLeftStr
									elseif string.find(widgetInfo.text, "Complete") then
										local quests, zone = string.match(widgetInfo.text, "Complete (%d+) |4world quest:world quests; in ?(.-) to unlock")
										if zone then
											-- TODO:  Why am I parsing the zone name rather than just using C_Map.GetMapInfo(mapId).name or "UNKNOWN" ??
											if string.find(zone,"the") then
												zone = string.match(zone, "^the%s*(.+)")    -- remove the word "the" if it's the first word in the string and lowercase.
											end
										else
											quest.LockedWQ_QuestToComplete = string.match(widgetInfo.text, "Complete ?(.-) to unlock")
											--print(string.format("[BWQ]: %s", quest.LockedWQ_QuestToComplete))
											zone = C_Map.GetMapInfo(mapId).name or "UNKNOWN"
										end
										quest.LockedWQ_questsRemaining = quests and tonumber(quests) or 0
										quest.LockedWQ_zone = zone or ""
									end
								end
							elseif widget.widgetType == Enum.UIWidgetVisualizationType.ItemDisplay then
								local widgetInfo = C_UIWidgetManager.GetItemDisplayVisualizationInfo(widget.widgetID)
								if widgetInfo then
									local itemName, itemLink, itemQuality, itemLevel, _, itemType, itemSubType, itemStackCount = C_Item.GetItemInfo(widgetInfo.itemInfo.itemID)  -- https://warcraft.wiki.gg/wiki/API_C_Item.GetItemInfo
									hasReward = true
									quest.reward.itemTexture = poi.atlasName
									quest.reward.itemId = widgetInfo.itemInfo.itemID
									quest.reward.itemQuality = itemQuality
									quest.reward.itemQuantity = itemStackCount
									quest.reward.itemName = itemName
									quest.reward.itemLink = itemLink
								end 
							end
						end
					end
				end

				BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[questID] = quest
				numQuests = numQuests + 1
			end
		end

		if BWQ:C("sortByTimeRemaining") then
			table.sort(BWQ.MAP_ZONES[BWQ.expansion][mapId].questsSort, function(a, b)
				local questA = BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[a]
				local questB = BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[b]
				
				-- If either quest is nil, put it at the end
				if not questA or not questA.timeLeft then return false end
				if not questB or not questB.timeLeft then return true end
				
				return questA.timeLeft < questB.timeLeft
			end)
		else -- reward type
			table.sort(BWQ.MAP_ZONES[BWQ.expansion][mapId].questsSort, function(a, b)
				local questA = BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[a]
				local questB = BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[b]
				
				-- If either quest is nil, put it at the end
				if not questA or not questA.sort then return false end
				if not questB or not questB.sort then return true end
				
				return questA.sort > questB.sort
			end)
		end

		BWQ.MAP_ZONES[BWQ.expansion][mapId].numQuests = numQuests
	end
end

function BWQ:UpdateQuestData()
	BWQ.questIds = BWQcache.questIds or {}
	BWQ.totalArtifactPower, BWQ.totalGold, BWQ.totalWarResources, BWQ.totalServiceMedals, BWQ.totalResources, BWQ.totalLegionfallSupplies = 0, 0, 0, 0, 0, 0
	BWQ.totalHonor, BWQ.totalGear, BWQ.totalHerbalism, BWQ.totalMining, BWQ.totalFishing, BWQ.totalSkinning, BWQ.totalBloodOfSargeras = 0, 0, 0, 0, 0, 0, 0
	BWQ.totalWakeningEssences, BWQ.totalMarkOfHonor, BWQ.totalPrismaticManapearl, BWQ.totalCyphersOfTheFirstOnes, BWQ.totalGratefulOffering = 0, 0, 0, 0, 0
	BWQ.totalBloodyTokens, BWQ.totalDragonIslesSupplies, BWQ.totalElementalOverflow, BWQ.totalFlightstones, BWQ.totalWhelplingsDreamingCrest = 0, 0, 0, 0, 0
	BWQ.totalDrakesDreamingCrest, BWQ.totalWyrmsDreamingCrest, BWQ.totalAspectsDreamingCrest, BWQ.totalWhelplingsAwakenedCrest = 0, 0, 0, 0
	BWQ.totalDrakesAwakenedCrest, BWQ.totalWyrmsAwakenedCrest, BWQ.totalAspectsAwakenedCrest, BWQ.totalMysteriousFragment = 0, 0, 0, 0
	BWQ.totalResonanceCrystals, BWQ.totalTheAssemblyOfTheDeeps, BWQ.totalHallowfallArathi, BWQ.totalValorstones, BWQ.totalKej = 0, 0, 0, 0, 0
	BWQ.totalPolishedPetCharms, BWQ.totalCouncilofDornogal, BWQ.totalTheWeaver, BWQ.totalTheGeneral, BWQ.totalTheVizier = 0, 0, 0, 0, 0
	BWQ.totalXP, BWQ.totalBronzeCelebrationToken, BWQ.totalWeatheredUndermineCrest, BWQ.totalCarvedUndermineCrest, BWQ.totalTheCartelsOfUndermine = 0, 0, 0, 0, 0
	BWQ.totalTheBilgewaterCartel, BWQ.totalTheBlackwaterCartel, BWQ.totalTheSteamwheedleCartel, BWQ.totalTheVentureCompany, BWQ.totalWeatheredEtherealCrest = 0, 0, 0, 0, 0

	for mapId in next, BWQ.MAP_ZONES[BWQ.expansion] do
		RetrieveWorldQuests(mapId)
	end

	BWQ.numQuestsTotal = 0
	BWQ.hasCollapsedQuests = false
	for mapId in next, BWQ.MAP_ZONES[BWQ.expansion] do
		local num = BWQ.MAP_ZONES[BWQ.expansion][mapId].numQuests
		if num > 0 then
			if not BWQ:C("collapsedZones")[mapId] then
				BWQ.numQuestsTotal = BWQ.numQuestsTotal + num
			else
				BWQ.hasCollapsedQuests = true
			end
		end
	end

	-- save quests to saved vars to check new status after reload/relog
	if BWQ.numQuestsTotal ~= 0 then
		BWQ.questIds = {}
		for mapId in next, BWQ.MAP_ZONES[BWQ.expansion] do
			for _, questID in next, BWQ.MAP_ZONES[BWQ.expansion][mapId].questsSort do
				BWQ.questIds[questID] = true
			end
		end
		BWQcache.questIds = BWQ.questIds
	end

	if BWQ.needsRefresh and BWQ.updateTries < 3 then
		BWQ.updateTries = BWQ.updateTries + 1
		C_Timer.After(1, function() BWQ:UpdateBlock() end)
	end
end

function BWQ:RenderRows()
	local screenHeight = UIParent:GetHeight()
	local availableHeight = 0
	if BWQ.showDownwards then availableHeight = screenHeight - (screenHeight - BWQ.blockYPos) - 30
	else availableHeight = screenHeight - BWQ.blockYPos - 30 end

	local ROW_HEIGHT = -16
	local maxEntries = math.floor((availableHeight + BWQ.offsetTop - 10) / ( -1 * ROW_HEIGHT ))

	local numEntries = BWQ.numQuestsTotal
	for mapId in next, BWQ.MAP_ZONES[BWQ.expansion] do
		if BWQ.MAP_ZONES[BWQ.expansion][mapId].numQuests ~= 0 then
			numEntries = numEntries + 1
		end
	end

	if maxEntries >= numEntries then
		BWQ.slider:Hide()
		maxEntries = numEntries - 1
		BWQ.slider:SetMinMaxValues(0, numEntries - 1 - maxEntries)
	else
		BWQ.slider:Show()
		BWQ.slider:SetPoint("TOPRIGHT", BWQ, "TOPRIGHT", -5, BWQ.offsetTop)
		BWQ.slider:SetHeight((ROW_HEIGHT * -1) * (maxEntries + 1))
		BWQ.slider:SetMinMaxValues(0, numEntries - 1 - maxEntries)
	end

	-- all quests filtered or all done (haha.)
	if BWQ.numQuestsTotal == 0 and not BWQ.hasCollapsedQuests then
		BWQ:ShowNoWorldQuestsInfo()
		BWQ:SetHeight((BWQ.offsetTop * -1) + 10 + 30)
	else
		if BWQ.errorFS then BWQ.errorFS:Hide() end
		BWQ:SetHeight((BWQ.offsetTop * -1) + 10 + (ROW_HEIGHT * -1) * (maxEntries + 1))
	end

	local sliderval = math.floor(BWQ.slider:GetValue())
	local rowIndex = 0
	local rowInViewIndex = 0
	for _, mapId in next, BWQ.MAP_ZONES_SORT[BWQ.expansion] do
		local collapsed = BWQ:C("collapsedZones")[mapId]
		if BWQ.MAP_ZONES[BWQ.expansion][mapId] then
			if BWQ.MAP_ZONES[BWQ.expansion][mapId].numQuests == 0 or rowIndex < sliderval or rowIndex > sliderval + maxEntries then
				BWQ.MAP_ZONES[BWQ.expansion][mapId].zoneSep.fs:Hide()
				BWQ.MAP_ZONES[BWQ.expansion][mapId].zoneSep.texture:Hide()
			else
				BWQ.MAP_ZONES[BWQ.expansion][mapId].zoneSep.fs:Show()
				BWQ.MAP_ZONES[BWQ.expansion][mapId].zoneSep.fs:SetPoint("TOP", BWQ, "TOP", 15 + (BWQ.totalWidth / -2) + (BWQ.MAP_ZONES[BWQ.expansion][mapId].zoneSep.fs:GetStringWidth() / 2), BWQ.offsetTop + ROW_HEIGHT * rowInViewIndex - 2)
				BWQ.MAP_ZONES[BWQ.expansion][mapId].zoneSep.texture:Show()
				BWQ.MAP_ZONES[BWQ.expansion][mapId].zoneSep.texture:SetPoint("TOP", BWQ, "TOP", 5, BWQ.offsetTop + ROW_HEIGHT * rowInViewIndex - 3)

				BWQ.MAP_ZONES[BWQ.expansion][mapId].zoneSep.collapse:Show()
				BWQ.MAP_ZONES[BWQ.expansion][mapId].zoneSep.collapse:SetAllPoints(BWQ.MAP_ZONES[BWQ.expansion][mapId].zoneSep.fs)
				local color = not collapsed and {0.9, 0.8, 0} or {0.3, 0.3, 0.3}
				BWQ.MAP_ZONES[BWQ.expansion][mapId].zoneSep.fs:SetTextColor(unpack(color))
				
				rowInViewIndex = rowInViewIndex + 1
			end

			if BWQ.MAP_ZONES[BWQ.expansion][mapId].numQuests ~= 0 then
				rowIndex = rowIndex + 1 -- count up from row with zone name
			end

			BWQ.highlightedRow = true
			local buttonIndex = 1
			for _, button in ipairs(BWQ.MAP_ZONES[BWQ.expansion][mapId].buttons) do
				if not button.quest.hide and not collapsed and buttonIndex <= BWQ.MAP_ZONES[BWQ.expansion][mapId].numQuests then
					if rowIndex < sliderval  or rowIndex > sliderval + maxEntries then
						button:Hide()
					else
						button:Show()
						button:SetPoint("TOP", BWQ, "TOP", 0, BWQ.offsetTop + ROW_HEIGHT * rowInViewIndex)
						rowInViewIndex = rowInViewIndex + 1

						if BWQ.highlightedRow then
							button.rowHighlight:Show()
						else
							button.rowHighlight:Hide()
						end
					end
					BWQ.highlightedRow = not BWQ.highlightedRow
					buttonIndex = buttonIndex + 1
					rowIndex = rowIndex + 1
				else
					button:Hide()
				end
			end
		end
	end
end

function BWQ:SwitchExpansion(expac)
	if BWQ.expansion == expac then
		return
	else
		BWQ.expansion = expac
	end

	if not BWQ:C("usePerCharacterSettings") then
		BWQcfg["expansion"] = expac
	else
		BWQcfgPerCharacter["expansion"] = expac
	end
	BWQ:SetParagonFactionsByActiveExpansion()

	BWQ.buttonTheWarWithin:SetAlpha(expac == CONSTANTS.EXPANSIONS.THEWARWITHIN and 1 or 0.4)
	BWQ.buttonDragonflight:SetAlpha(expac == CONSTANTS.EXPANSIONS.DRAGONFLIGHT and 1 or 0.4)
	BWQ.buttonShadowlands:SetAlpha(expac == CONSTANTS.EXPANSIONS.SHADOWLANDS and 1 or 0.4)
	BWQ.buttonBFA:SetAlpha(expac == CONSTANTS.EXPANSIONS.BFA and 1 or 0.4)
	BWQ.buttonLegion:SetAlpha(expac == CONSTANTS.EXPANSIONS.LEGION and 1 or 0.4)

	BWQ:HideRowsOfInactiveExpansions()
	BWQ.hasUnlockedWorldQuests = false
	BWQ.updateTries = 0
	BWQ:UpdateBlock()
end 

function BWQ:HideRowsOfInactiveExpansions()
	for k, expac in next, BWQ.MAP_ZONES do
		if k ~= BWQ.expansion then
			for mapId, v in next, expac do
				if v.zoneSep then
					v.zoneSep.fs:Hide()
					v.zoneSep.texture:Hide()
					v.zoneSep.collapse:Hide()
				end
				for _, button in next, v.buttons do
					button:Hide()
				end
			end
		end
	end
	BWQ.slider:Hide()
	BWQ:UpdateBountyData()
end

function BWQ:RunUpdate()
	local currentTime = GetTime()
	if currentTime - BWQ.lastUpdate > 5 then
		BWQ.updateTries = 0
		BWQ:UpdateBlock()
		BWQ.lastUpdate = currentTime
	end
end

function BWQ:UpdateBlock()
	BWQ.offsetTop = -35 -- initial padding from top
	
	BWQ:UpdateInfoPanel()
	if not BWQ:WorldQuestsUnlocked() then
		BWQ:SetHeight(BWQ.offsetTop * -1 + 20 + 30) -- padding + errorFS height
		BWQ:SetWidth(math.max(BWQ.factionDisplay:GetWidth(), BWQ.errorFS:GetWidth()) + 20)
		return
	end

	BWQ:UpdateQuestData()
	-- refreshing is limited to 3 runs and then gets forced to render the block
	if BWQ.needsRefresh and BWQ.updateTries < 3 then
		-- skip updating the block, received data was incomplete
		BWQ.needsRefresh = false
		return
	end

	local titleMaxWidth, bountyMaxWidth, factionMaxWidth, rewardMaxWidth, timeLeftMaxWidth = 0, 0, 0, 0, 0
	for mapId in next, BWQ.MAP_ZONES[BWQ.expansion] do
		local buttonIndex = 1

		if not BWQ.MAP_ZONES[BWQ.expansion][mapId].zoneSep then
			local zoneSep = {
				fs = BWQ:CreateFontString("BWQzoneNameFS", "OVERLAY", "SystemFont_Shadow_Med1"),
				texture = BWQ:CreateTexture(),
				collapse = CreateFrame("Button", nil, BWQ, "BackdropTemplate")
			}
			local faction = BWQ.MAP_ZONES[BWQ.expansion][mapId].faction
			local zoneText = BWQ.MAP_ZONES[BWQ.expansion][mapId].name
			if faction then
				local factionIcon = faction == CONSTANTS.FACTIONS.HORDE and "Interface\\Icons\\inv_misc_tournaments_banner_orc" or "Interface\\Icons\\inv_misc_tournaments_banner_human"
				zoneText = ("%2$s   |T%1$s:12:12|t"):format(factionIcon, zoneText)
			end
			zoneSep.fs:SetJustifyH("LEFT")
			zoneSep.fs:SetText(zoneText)

			zoneSep.collapse:SetFrameLevel(15)
			zoneSep.collapse:RegisterForClicks("AnyUp")
			zoneSep.collapse:SetScript("OnClick" , function(self)
				BWQ:C("collapsedZones")[mapId] = not BWQ:C("collapsedZones")[mapId]
				BWQ:UpdateBlock()
			end)

			zoneSep.texture:SetTexture("Interface\\FriendsFrame\\UI-FriendsFrame-OnlineDivider")
			zoneSep.texture:SetHeight(8)

			BWQ.MAP_ZONES[BWQ.expansion][mapId].zoneSep = zoneSep
		end

		if not BWQ:C("collapsedZones")[mapId] then 
			for _, questID in next, BWQ.MAP_ZONES[BWQ.expansion][mapId].questsSort do
				local button = nil
				if buttonIndex > #BWQ.MAP_ZONES[BWQ.expansion][mapId].buttons then
					button = CreateFrame("Button", nil, BWQ)
					button:RegisterForClicks("AnyUp")

					button.highlight = button:CreateTexture()
					button.highlight:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
					button.highlight:SetBlendMode("ADD")
					button.highlight:SetAlpha(0)
					button.highlight:SetAllPoints(button)

					button.rowHighlight = button:CreateTexture()
					button.rowHighlight:SetTexture("Interface\\Buttons\\WHITE8x8")
					button.rowHighlight:SetBlendMode("ADD")
					button.rowHighlight:SetAlpha(0.05)
					button.rowHighlight:SetAllPoints(button)

					button:SetScript("OnLeave", function()				BWQ:Block_OnLeave()				button.highlight:SetAlpha(0)			end)
					button:SetScript("OnEnter", function(self)			button.highlight:SetAlpha(1)											end)

					button:SetScript("OnClick", function(self)			Row_OnClick(button)														end)

					button.icon = button:CreateTexture()
					button.icon:SetSize(12, 12)
					button.iconBorder = button:CreateTexture(nil, "BORDER")
					button.iconBorder:SetSize(12, 12)

					-- create font strings
					button.title = CreateFrame("Button", nil, button)
					button.title:SetScript("OnClick", function(self)	Row_OnClick(button)																end)
					button.title:SetScript("OnEnter", function(self)	button.highlight:SetAlpha(1)	ShowQuestObjectiveTooltip(button)				end)
					button.title:SetScript("OnLeave", function()		button.highlight:SetAlpha(0)	BWQ.tooltip:Hide()		BWQ:Block_OnLeave()		end)

					button.titleFS = button:CreateFontString("BWQtitleFS", "OVERLAY", "SystemFont_Shadow_Med1")
					--local font, size, flags = button.titleFS:GetFont()
					--button.titleFS:SetFont(font, 50, flags)  -- Change font size to 50
					button.titleFS:SetJustifyH("LEFT")
					button.titleFS:SetTextColor(.9, .9, .9)
					button.titleFS:SetWordWrap(false)

					button.track = button:CreateTexture()
					button.track:SetTexture("Interface\\COMMON\\FavoritesIcon")
					button.track:SetSize(24, 24)

					button.bountyFS = button:CreateFontString("BWQbountyFS", "OVERLAY", "SystemFont_Shadow_Med1")
					button.bountyFS:SetJustifyH("LEFT")
					button.bountyFS:SetWordWrap(false)

					button.factionFS = button:CreateFontString("BWQfactionFS", "OVERLAY", "SystemFont_Shadow_Med1")
					button.factionFS:SetJustifyH("LEFT")
					button.factionFS:SetTextColor(.9, .9, .9)
					button.factionFS:SetWordWrap(false)

					button.reward = CreateFrame("Button", nil, button)
					button.reward:SetScript("OnClick", function(self)	Row_OnClick(button)														end)

					button.rewardFS = button.reward:CreateFontString("BWQrewardFS", "OVERLAY", "SystemFont_Shadow_Med1")
					button.rewardFS:SetJustifyH("LEFT")
					button.rewardFS:SetTextColor(.9, .9, .9)
					button.rewardFS:SetWordWrap(false)

					button.timeLeftFS = button:CreateFontString("BWQtimeLeftFS", "OVERLAY", "SystemFont_Shadow_Med1")
					button.timeLeftFS:SetJustifyH("LEFT")
					button.timeLeftFS:SetTextColor(.9, .9, .9)
					button.timeLeftFS:SetWordWrap(false)

					BWQ.MAP_ZONES[BWQ.expansion][mapId].buttons[buttonIndex] = button
				else
					button = BWQ.MAP_ZONES[BWQ.expansion][mapId].buttons[buttonIndex]
				end

				button.mapId = mapId
				button.quest = BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[questID]
				button.questID = button.quest.questID
				button.worldQuest = true
				button.numObjectives = button.quest.numObjectives

				-- fill and format row
				local rewardText = ""
				if button.quest.LockedWQ then
					-- To find Atlas textures such as the "padlock" below.  Use the /tav command (Texture Atlas Viewer addon).
					if button.quest.LockedWQ_QuestToComplete then
						rewardText = string.format(
							"|cnWARNING_FONT_COLOR:|A:%s:14:14|a Complete the quest '%s' in %s|r",
							"Garr_LockedBuilding",
							button.quest.LockedWQ_QuestToComplete,
							button.quest.LockedWQ_zone and button.quest.LockedWQ_zone or "")
					else
						rewardText = string.format(
							"|cnWARNING_FONT_COLOR:|A:%s:14:14|a Complete %d more %s in %s|r",
							"Garr_LockedBuilding",
							button.quest.LockedWQ_questsRemaining and button.quest.LockedWQ_questsRemaining or "",
							button.quest.LockedWQ_questsRemaining > 1 and "WQs" or "WQ",
							button.quest.LockedWQ_zone and button.quest.LockedWQ_zone or "")
					end
					button.reward:SetScript("OnEvent", function(self, event)
						if event == "MODIFIER_STATE_CHANGED" then
							if button.reward:IsMouseOver() and button.reward:IsShown() then
								ShowWorldQuestPOITooltip(button, button.quest.poi)
							else
								button.reward:UnregisterEvent("MODIFIER_STATE_CHANGED")
							end
						end
					end)
					button.reward:SetScript("OnEnter", function(self)
						button.highlight:SetAlpha(1)
						self:RegisterEvent("MODIFIER_STATE_CHANGED")
						ShowWorldQuestPOITooltip(button, button.quest.poi)
					end)
					button.reward:SetScript("OnLeave", function()
						button.highlight:SetAlpha(0)
						self:UnregisterEvent("MODIFIER_STATE_CHANGED")
						BWQ.tooltip:Hide()
						BWQ:Block_OnLeave()
					end)
				else
					if button.quest.reward.itemName then
						local itemText = string.format(
							"%s[%s%s]|r",
							ITEM_QUALITY_COLORS[button.quest.reward.itemQuality].hex,
							button.quest.reward.realItemLevel and (button.quest.reward.realItemLevel .. " ") or "",
							button.quest.reward.itemName
						)
						rewardText = string.format(
							"|T%s$s:14:14|t %s%s",
							button.quest.reward.itemTexture,
							button.quest.reward.itemQuantity > 1 and button.quest.reward.itemQuantity .. "x " or "",
							itemText
						)
						button.reward:SetScript("OnEvent", function(self, event)
							if event == "MODIFIER_STATE_CHANGED" then
								if button.reward:IsMouseOver() and button.reward:IsShown() then
									ShowQuestLogItemTooltip(button)
								else
									button.reward:UnregisterEvent("MODIFIER_STATE_CHANGED")
								end
							end
						end)
						button.reward:SetScript("OnEnter", function(self)
							button.highlight:SetAlpha(1)
							self:RegisterEvent("MODIFIER_STATE_CHANGED")

							ShowQuestLogItemTooltip(button)
						end)
						button.reward:SetScript("OnLeave", function()
							button.highlight:SetAlpha(0)

							self:UnregisterEvent("MODIFIER_STATE_CHANGED")
							BWQ.tooltip:Hide()
							BWQ:Block_OnLeave()
						end)
					else
						button.reward:SetScript("OnEnter", function(self)
							button.highlight:SetAlpha(1)
						end)
						button.reward:SetScript("OnLeave", function()
							button.highlight:SetAlpha(0)

							BWQ.tooltip:Hide()
							BWQ:Block_OnLeave()
						end)
					end
					if button.quest.reward.xp and button.quest.reward.xp > 0 and not button.quest.reward.itemName then
						rewardText = string.format(
							"%1$s%2$s|T%3$s:14:14|t %4$d %5$s",
							rewardText,
							rewardText ~= "" and "   " or "", -- insert some space between rewards
							"Interface\\Icons\\xp_icon",
							button.quest.reward.xp,
							XP
						) 
					end
					if button.quest.reward.honor and button.quest.reward.honor > 0 then
						rewardText = string.format(
							"%1$s%2$s|T%3$s:14:14|t %4$d %5$s",
							rewardText,
							rewardText ~= "" and "   " or "", -- insert some space between rewards
							"Interface\\Icons\\Achievement_LegionPVPTier4",
							button.quest.reward.honor,
							HONOR
						) 
					end
					if button.quest.reward.money and button.quest.reward.money > 0 then
						local moneyText = GetCoinTextureString(button.quest.reward.money)
						rewardText = string.format(
							"%s%s%s",
							rewardText,
							rewardText ~= "" and "   " or "", -- insert some space between rewards
							moneyText
						)
					end
					if button.quest.reward.currencies then
						for _, currency in next, button.quest.reward.currencies do
							local currencyText = string.format("|T%1$s:14:14|t %s", currency.texture, currency.name)
							rewardText = string.format(
								"%s%s%s",
								rewardText,
								rewardText ~= "" and "   " or "", -- insert some space between rewards
								currencyText
							)
							-- Replace "Reputation" with "Rep." to shorten strings
							rewardText = rewardText:gsub("Reputation", "Rep.")
						end
					end
				end

				--====
				-- Set row icon based on quest.tagID
				--====
				button.icon:SetAlpha(0)
				button.iconBorder:SetAlpha(0)
				if CONSTANTS.WORLD_QUEST_ICONS_BY_TAG_ID[button.quest.tagId] then
					if CONSTANTS.WORLD_QUEST_ICONS_BY_TAG_ID[button.quest.tagId].icon ~= "N/A" then
						--print(string.format("[BWQ] Creating icon for '%s' (tagId: %d)", button.quest.title, button.quest.tagId))
						button.icon:SetAtlas(CONSTANTS.WORLD_QUEST_ICONS_BY_TAG_ID[button.quest.tagId].icon, true)
						button.icon:SetAlpha(1)
						button.icon:SetSize(12, 12)
						if CONSTANTS.WORLD_QUEST_ICONS_BY_TAG_ID[button.quest.tagId].border then
							--print(string.format("[BWQ] Creating border icon for '%s' (tagId: %d)", button.quest.title, button.quest.tagId))
							button.iconBorder:SetScale(0.5)
							button.iconBorder:SetAtlas(CONSTANTS.WORLD_QUEST_ICONS_BY_TAG_ID[button.quest.tagId].border, true)
							button.iconBorder:SetAlpha(1)
						end
					end
				else
					if BWQcfg.spewDebugInfo and button.quest.tagId and button.quest.tagId > 0 then
						print(string.format("[BWQ] Unhandled Quest TagId: %d (%s)", button.quest.tagId, button.quest.title))
					end
				end

				-- Set the first cell of the row (the quest title/name)
				local isNewText = ""
				if BWQ:C("showNEWTextWhenAppropriate") then
					isNewText = button.quest.isNew and "|cffe5cc80NEW|r  " or ""
				end
				button.titleFS:SetText(string.format("%s%s%s|r",
					isNewText,
					button.quest.isMissingAchievementCriteria and "|cff1EFF00" or WORLD_QUEST_QUALITY_COLORS[button.quest.quality].hex,
					button.quest.title
				))
				--local titleWidth = button.titleFS:GetStringWidth()
				--if titleWidth > titleMaxWidth then titleMaxWidth = titleWidth end

				if C_QuestLog.GetQuestWatchType(button.quest.questID) == Enum.QuestWatchType.Manual or C_SuperTrack.GetSuperTrackedQuestID() == button.quest.questID then
					button.track:Show()
				else
					button.track:Hide()
				end

				local bountyText = ""
				for _, bountyIcon in ipairs(button.quest.bounties) do
					bountyText = string.format("%s |T%s$s:14:14|t", bountyText, bountyIcon)
				end
				button.bountyFS:SetText(bountyText)
				local bountyWidth = button.bountyFS:GetStringWidth()
				if bountyWidth > bountyMaxWidth then bountyMaxWidth = bountyWidth end

				if not BWQ:C("hideFactionColumn") then
					button.factionFS:SetText(button.quest.factionID)
					local factionWidth = button.factionFS:GetStringWidth()
					if factionWidth > factionMaxWidth then factionMaxWidth = factionWidth end
				else
					button.factionFS:SetText("")
				end

				button.timeLeftFS:SetText(BWQ:FormatTimeLeftString(button.quest.timeLeft))
				--local timeLeftWidth = button.factionFS:GetStringWidth()
				--if timeLeftWidth > timeLeftMaxWidth then timeLeftMaxWidth = timeLeftWidth end

				button.rewardFS:SetText(rewardText)

				local rewardWidth = button.rewardFS:GetStringWidth()
				if rewardWidth > rewardMaxWidth then rewardMaxWidth = rewardWidth end
				button.reward:SetHeight(button.rewardFS:GetStringHeight())
				button.title:SetHeight(button.titleFS:GetStringHeight())

				button.icon:SetPoint("LEFT", button, "LEFT", 5, 0)
				if button.iconBorder:GetAlpha() > 0 then
					button.iconBorder:SetPoint("CENTER", button.icon, "CENTER", 0, 0)
				end
				button.titleFS:SetPoint("LEFT", button.icon, "RIGHT", 5, 0)
				button.title:SetPoint("LEFT", button.titleFS, "LEFT", 0, 0)
				button.rewardFS:SetPoint("LEFT", button.titleFS, "RIGHT", 10, 0)
				button.reward:SetPoint("LEFT", button.rewardFS, "LEFT", 0, 0)
				button.track:SetPoint("LEFT", button.rewardFS, "RIGHT", 5, -3)
				button.bountyFS:SetPoint("LEFT", button.rewardFS, "RIGHT", 25, 0)
				button.factionFS:SetPoint("LEFT", button.bountyFS, "RIGHT", 10, 0)
				button.timeLeftFS:SetPoint("LEFT", button.factionFS, "RIGHT", 10, 0)

				buttonIndex = buttonIndex + 1
			end -- quest loop
		end
	end -- maps loop

	titleMaxWidth = 300																								-- set max width of title (quest name)
	rewardMaxWidth = rewardMaxWidth < 235 and 235 or rewardMaxWidth > 385 and 385 or rewardMaxWidth					-- Set max width of reward cell
	factionMaxWidth = BWQ:C("hideFactionColumn") and 0 or factionMaxWidth < 100 and 100 or factionMaxWidth
	timeLeftMaxWidth = 65
	BWQ.totalWidth = titleMaxWidth + bountyMaxWidth + factionMaxWidth + rewardMaxWidth + timeLeftMaxWidth + 80		-- Set total max width

	local bountyBoardWidth = BWQ.bountyDisplay:GetWidth()
	local factionDisplayWidth = BWQ.factionDisplay:GetWidth()
	local infoPanelWidth = bountyBoardWidth > factionDisplayWidth and bountyBoardWidth or factionDisplayWidth
	if BWQ.totalWidth < infoPanelWidth then
		local diff = infoPanelWidth - BWQ.totalWidth
		BWQ.totalWidth = infoPanelWidth
		rewardMaxWidth = rewardMaxWidth + diff
	end

	for mapId in next, BWQ.MAP_ZONES[BWQ.expansion] do
		for i = 1, #BWQ.MAP_ZONES[BWQ.expansion][mapId].buttons do
			if not BWQ.MAP_ZONES[BWQ.expansion][mapId].buttons[i].quest.hide then -- dont care about the hidden ones
				BWQ.MAP_ZONES[BWQ.expansion][mapId].buttons[i]:SetHeight(15)
				BWQ.MAP_ZONES[BWQ.expansion][mapId].buttons[i]:SetWidth(BWQ.totalWidth)
				BWQ.MAP_ZONES[BWQ.expansion][mapId].buttons[i].title:SetWidth(titleMaxWidth)
				BWQ.MAP_ZONES[BWQ.expansion][mapId].buttons[i].titleFS:SetWidth(titleMaxWidth)
				BWQ.MAP_ZONES[BWQ.expansion][mapId].buttons[i].bountyFS:SetWidth(bountyMaxWidth)
				BWQ.MAP_ZONES[BWQ.expansion][mapId].buttons[i].factionFS:SetWidth(factionMaxWidth)
				BWQ.MAP_ZONES[BWQ.expansion][mapId].buttons[i].reward:SetWidth(rewardMaxWidth)
				BWQ.MAP_ZONES[BWQ.expansion][mapId].buttons[i].rewardFS:SetWidth(rewardMaxWidth)
				BWQ.MAP_ZONES[BWQ.expansion][mapId].buttons[i].timeLeftFS:SetWidth(timeLeftMaxWidth)
			else
				BWQ.MAP_ZONES[BWQ.expansion][mapId].buttons[i]:Hide()
			end
		end
		BWQ.MAP_ZONES[BWQ.expansion][mapId].zoneSep.texture:SetWidth(BWQ.totalWidth + 20)
	end

	BWQ.totalWidth = BWQ.totalWidth + 20
	BWQ:SetWidth(BWQ.totalWidth)

	if BWQ:C("showTotalsInBrokerText") then
		local brokerString = ""
		if BWQ:C("brokerShowBronzeCelebrationToken") and BWQ.totalBronzeCelebrationToken > 0 then brokerString = string.format("%s|TInterface\\Icons\\Inv_10_dungeonjewelry_dragon_necklace_1_bronze:16:16|t %d  ", brokerString, BWQ.totalBronzeCelebrationToken) end
		if BWQ:C("brokerShowPolishedPetCharms")    	and BWQ.totalPolishedPetCharms > 0  	then brokerString = string.format("%s|TInterface\\Icons\\inv_currency_petbattle:16:16|t %d  ", brokerString, BWQ.totalPolishedPetCharms) end
		if BWQ:C("brokerShowAP")                  	and BWQ.totalArtifactPower > 0      	then brokerString = string.format("%s|TInterface\\Icons\\inv_smallazeriteshard:16:16|t %s  ", brokerString, BWQ:AbbreviateNumber(BWQ.totalArtifactPower)) end
		if BWQ:C("brokerShowServiceMedals")       	and BWQ.totalServiceMedals > 0      	then brokerString = string.format("%s|T%s:16:16|t %s  ", brokerString, self.isHorde and "Interface\\Icons\\ui_horde_honorboundmedal" or "Interface\\Icons\\ui_alliance_7legionmedal", BWQ.totalServiceMedals) end
		if BWQ:C("brokerShowWakeningEssences")    	and BWQ.totalWakeningEssences > 0   	then brokerString = string.format("%s|TInterface\\Icons\\achievement_dungeon_ulduar80_25man:16:16|t %s  ", brokerString, BWQ.totalWakeningEssences) end
		if BWQ:C("brokerShowWarResources")        	and BWQ.totalWarResources > 0       	then brokerString = string.format("%s|TInterface\\Icons\\inv__faction_warresources:16:16|t %d  ", brokerString, BWQ.totalWarResources) end
		if BWQ:C("brokerShowPrismaticManapearl")  	and BWQ.totalPrismaticManapearl > 0 	then brokerString = string.format("%s|TInterface\\Icons\\Inv_misc_enchantedpearlf:16:16|t %d  ", brokerString, BWQ.totalPrismaticManapearl) end
		if BWQ:C("brokerShowCyphersOfTheFirstOnes")	and BWQ.totalCyphersOfTheFirstOnes > 0	then brokerString = string.format("%s|TInterface\\Icons\\inv_trinket_progenitorraid_02_blue:16:16|t %d  ", brokerString, BWQ.totalCyphersOfTheFirstOnes) end	
		if BWQ:C("brokerShowGratefulOffering")    	and BWQ.totalGratefulOffering > 0   	then brokerString = string.format("%s|TInterface\\Icons\\inv_misc_ornatebox:16:16|t %d  ", brokerString, BWQ.totalGratefulOffering) end
		if BWQ:C("brokerShowResources")           	and BWQ.totalResources > 0          	then brokerString = string.format("%s|TInterface\\Icons\\inv_orderhall_orderresources:16:16|t %d  ", brokerString, BWQ.totalResources) end
		if BWQ:C("brokerShowLegionfallSupplies")  	and BWQ.totalLegionfallSupplies > 0 	then brokerString = string.format("%s|TInterface\\Icons\\inv_misc_summonable_boss_token:16:16|t %d  ", brokerString, BWQ.totalLegionfallSupplies) end
		if BWQ:C("brokerShowXP")               		and BWQ.totalXP > 0              		then brokerString = string.format("%s|TInterface\\Icons\\xp_icon:16:16|t %d  ", brokerString, BWQ.totalXP) end
		if BWQ:C("brokerShowHonor")               	and BWQ.totalHonor > 0              	then brokerString = string.format("%s|TInterface\\Icons\\Achievement_LegionPVPTier4:16:16|t %d  ", brokerString, BWQ.totalHonor) end
		if BWQ:C("brokerShowGold")                	and BWQ.totalGold > 0               	then brokerString = string.format("%s|TInterface\\GossipFrame\\auctioneerGossipIcon:16:16|t %d  ", brokerString, math.floor(BWQ.totalGold / 10000)) end
		if BWQ:C("brokerShowGear")                	and BWQ.totalGear > 0               	then brokerString = string.format("%s|TInterface\\Icons\\Inv_chest_plate_legionendgame_c_01:16:16|t %d  ", brokerString, BWQ.totalGear) end
		if BWQ:C("brokerShowMarkOfHonor")         	and BWQ.totalMarkOfHonor > 0        	then brokerString = string.format("%s|TInterface\\Icons\\ability_pvp_gladiatormedallion:16:16|t %d  ", brokerString, BWQ.totalMarkOfHonor) end
		if BWQ:C("brokerShowHerbalism")           	and BWQ.totalHerbalism > 0          	then brokerString = string.format("%s|TInterface\\Icons\\Trade_Herbalism:16:16|t %d  ", brokerString, BWQ.totalHerbalism) end
		if BWQ:C("brokerShowMining")              	and BWQ.totalMining > 0             	then brokerString = string.format("%s|TInterface\\Icons\\Trade_Mining:16:16|t %d  ", brokerString, BWQ.totalMining) end
		if BWQ:C("brokerShowFishing")             	and BWQ.totalFishing > 0            	then brokerString = string.format("%s|TInterface\\Icons\\Trade_Fishing:16:16|t %d  ", brokerString, BWQ.totalFishing) end
		if BWQ:C("brokerShowSkinning")            	and BWQ.totalSkinning > 0           	then brokerString = string.format("%s|TInterface\\Icons\\inv_misc_pelt_wolf_01:16:16|t %d  ", brokerString, BWQ.totalSkinning) end
		if BWQ:C("brokerShowBloodOfSargeras")     	and BWQ.totalBloodOfSargeras > 0    	then brokerString = string.format("%s|T1417744:16:16|t %d", brokerString, BWQ.totalBloodOfSargeras) end
		if BWQ:C("brokerShowBloodyTokens")        	and BWQ.totalBloodyTokens > 0       	then brokerString = string.format("%s|TInterface\\Icons\\inv_10_dungeonjewelry_titan_trinket_2_color2:16:16|t %d  ", brokerString, BWQ.totalBloodyTokens) end
		if BWQ:C("brokerShowDragonIslesSupplies") 	and BWQ.totalDragonIslesSupplies > 0	then brokerString = string.format("%s|TInterface\\Icons\\inv_faction_warresources:16:16|t %d  ", brokerString, BWQ.totalDragonIslesSupplies) end
		if BWQ:C("brokerShowElementalOverflow") 	and BWQ.totalElementalOverflow > 0		then brokerString = string.format("%s|TInterface\\Icons\\inv_misc_powder_thorium:16:16|t %d  ", brokerString, BWQ.totalElementalOverflow) end
		if BWQ:C("brokerShowFlightstones") 			and BWQ.totalFlightstones > 0			then brokerString = string.format("%s|TInterface\\Icons\\flightstone-dragonflight:16:16|t %d  ", brokerString, BWQ.totalFlightstones) end
		if BWQ:C("brokerShowWhelplingsDreamingCrest") and BWQ.totalWhelplingsDreamingCrest > 0	then brokerString = string.format("%s|TInterface\\Icons\\Inv_10_gearupgrade_whelplingsdreamingcrest:16:16|t %d  ", brokerString, BWQ.totalWhelplingsDreamingCrest) end
		if BWQ:C("brokerShowDrakesDreamingCrest") 	and BWQ.totalDrakesDreamingCrest > 0	then brokerString = string.format("%s|TInterface\\Icons\\Inv_10_gearupgrade_drakesdreamingcrest:16:16|t %d  ", brokerString, BWQ.totalDrakesDreamingCrest) end
		if BWQ:C("brokerShowWyrmsDreamingCrest") 	and BWQ.totalWyrmsDreamingCrest > 0		then brokerString = string.format("%s|TInterface\\Icons\\Inv_10_gearupgrade_wyrmsdreamingcrest:16:16|t %d  ", brokerString, BWQ.totalWyrmsDreamingCrest) end
		if BWQ:C("brokerShowAspectsDreamingCrest") 	and BWQ.totalAspectsDreamingCrest > 0	then brokerString = string.format("%s|TInterface\\Icons\\Inv_10_gearupgrade_aspectsdreamingcrest:16:16|t %d  ", brokerString, BWQ.totalAspectsDreamingCrest) end
		if BWQ:C("brokerShowWhelplingsAwakenedCrest") and BWQ.totalWhelplingsAwakenedCrest > 0	then brokerString = string.format("%s|TInterface\\Icons\\inv_10_gearupgrade_whelplingsawakenedcrest:16:16|t %d  ", brokerString, BWQ.totalWhelplingsAwakenedCrest) end
		if BWQ:C("brokerShowDrakesAwakenedCrest") 	and BWQ.totalDrakesAwakenedCrest > 0	then brokerString = string.format("%s|TInterface\\Icons\\inv_10_gearupgrade_drakesawakenedcrest:16:16|t %d  ", brokerString, BWQ.totalDrakesAwakenedCrest) end
		if BWQ:C("brokerShowWyrmsAwakenedCrest") 	and BWQ.totalWyrmsAwakenedCrest > 0		then brokerString = string.format("%s|TInterface\\Icons\\Inv_10_gearupgrade_wyrmsawakenedcrest:16:16|t %d  ", brokerString, BWQ.totalWyrmsAwakenedCrest) end
		if BWQ:C("brokerShowAspectsAwakenedCrest") 	and BWQ.totalAspectsAwakenedCrest > 0	then brokerString = string.format("%s|TInterface\\Icons\\Inv_10_gearupgrade_aspectsawakenedcrest:16:16|t %d  ", brokerString, BWQ.totalAspectsAwakenedCrest) end
		if BWQ:C("brokerShowMysteriousFragment") 	and BWQ.totalMysteriousFragment > 0		then brokerString = string.format("%s|TInterface\\Icons\\Inv_7_0raid_trinket_05a:16:16|t %d  ", brokerString, BWQ.totalMysteriousFragment) end
		if BWQ:C("brokerShowResonanceCrystals") 	and BWQ.totalResonanceCrystals > 0		then brokerString = string.format("%s|TInterface\\Icons\\spell_azerite_essence14:16:16|t %d  ", brokerString, BWQ.totalResonanceCrystals) end
		if BWQ:C("brokerShowTheAssemblyoftheDeeps") and BWQ.totalTheAssemblyOfTheDeeps > 0	then brokerString = string.format("%s|TInterface\\Icons\\ui_majorfactions_candle:16:16|t %d  ", brokerString, BWQ.totalTheAssemblyOfTheDeeps) end
		if BWQ:C("brokerShowHallowfallArathi") 		and BWQ.totalHallowfallArathi > 0		then brokerString = string.format("%s|TInterface\\Icons\\ui_majorfactions_flame:16:16|t %d  ", brokerString, BWQ.totalHallowfallArathi) end
		if BWQ:C("brokerShowValorstones") 			and BWQ.totalValorstones > 0			then brokerString = string.format("%s|TInterface\\Icons\\inv_valorstone_base:16:16|t %d  ", brokerString, BWQ.totalValorstones) end
		if BWQ:C("brokerShowKej") 					and BWQ.totalKej > 0					then brokerString = string.format("%s|TInterface\\Icons\\inv_10_tailoring_silkrare_color3:16:16|t %d  ", brokerString, BWQ.totalKej) end
		if BWQ:C("brokerShowCouncilofDornogal") 	and BWQ.totalCouncilofDornogal > 0		then brokerString = string.format("%s|TInterface\\Icons\\ui_majorfactions_storm:16:16|t %d  ", brokerString, BWQ.totalCouncilofDornogal) end
		if BWQ:C("brokerShowTheWeaver") 			and BWQ.totalTheWeaver > 0				then brokerString = string.format("%s|TInterface\\Icons\\ui_notoriety_theweaver:16:16|t %d  ", brokerString, BWQ.totalTheWeaver) end
		if BWQ:C("brokerShowTheGeneral") 			and BWQ.totalTheGeneral > 0				then brokerString = string.format("%s|TInterface\\Icons\\ui_notoriety_thegeneral:16:16|t %d  ", brokerString, BWQ.totalTheGeneral) end
		if BWQ:C("brokerShowTheVizier") 			and BWQ.totalTheVizier > 0				then brokerString = string.format("%s|TInterface\\Icons\\ui_notoriety_thevizier:16:16|t %d  ", brokerString, BWQ.totalTheVizier) end
		if BWQ:C("brokerShowWeatheredUndermineCrest") and BWQ.totalWeatheredUndermineCrest > 0	then brokerString = string.format("%s|TInterface\\Icons\\inv_crestupgrade_undermine_weathered:16:16|t %d  ", brokerString, BWQ.totalWeatheredUndermineCrest) end
		if BWQ:C("brokerShowCarvedUndermineCrest") 	and BWQ.totalCarvedUndermineCrest > 0	then brokerString = string.format("%s|TInterface\\Icons\\inv_crestupgrade_undermine_carved:16:16|t %d  ", brokerString, BWQ.totalCarvedUndermineCrest) end
		if BWQ:C("brokerShowTheCartelsOfUndermine") and BWQ.totalTheCartelsOfUndermine > 0	then brokerString = string.format("%s|TInterface\\Icons\\ui_majorfactions_rocket:16:16|t %d  ", brokerString, BWQ.totalTheCartelsOfUndermine) end
		if BWQ:C("brokerShowTheBilgewaterCartel") 	and BWQ.totalTheBilgewaterCartel > 0	then brokerString = string.format("%s|TInterface\\Icons\\inv_1115_reputationcurrencies_bilgewater:16:16|t %d  ", brokerString, BWQ.totalTheBilgewaterCartel) end
		if BWQ:C("brokerShowTheBlackwaterCartel") 	and BWQ.totalTheBlackwaterCartel > 0	then brokerString = string.format("%s|TInterface\\Icons\\inv_1115_reputationcurrencies_blackwater:16:16|t %d  ", brokerString, BWQ.totalTheBlackwaterCartel) end
		if BWQ:C("brokerShowTheSteamwheedleCartel") and BWQ.totalTheSteamwheedleCartel > 0	then brokerString = string.format("%s|TInterface\\Icons\\inv_1115_reputationcurrencies_steamwheedle:16:16|t %d  ", brokerString, BWQ.totalTheSteamwheedleCartel) end
		if BWQ:C("brokerShowTheVentureCompany") 	and BWQ.totalTheVentureCompany > 0		then brokerString = string.format("%s|TInterface\\Icons\\inv_1115_reputationcurrencies_ventureco:16:16|t %d  ", brokerString, BWQ.totalTheVentureCompany) end
		if BWQ:C("brokerShowWeatheredEtherealCrest") and BWQ.totalWeatheredEtherealCrest > 0	then brokerString = string.format("%s|TInterface\\Icons\\inv_crestupgrade_ethereal_weathered:16:16|t %d  ", brokerString, BWQ.totalWeatheredEtherealCrest) end

		if brokerString and brokerString ~= "" then
			BWQ.WorldQuestsBroker.text = brokerString
		else
			BWQ.WorldQuestsBroker.text = "World Quests"
		end
	else
		BWQ.WorldQuestsBroker.text = "World Quests"
	end

	BWQ:RenderRows()
end

local SetFlightMapPins = function(self)
	for pin, active in self:GetMap():EnumeratePinsByTemplate("WorldQuestPinTemplate") do
		if C_SuperTrack.GetSuperTrackedQuestID() == pin.questID then
			pin:SetAlphaLimits(nil, 0.0, 1.0)
			pin:SetAlpha(1)
			pin:Show()
		else
			pin:SetAlphaLimits(1.0, 0.0, 1.0)
			if FlightMapFrame.ScrollContainer:IsZoomedOut() then pin:Hide() end
		end
	end
end
function BWQ:AddFlightMapHook()
	hooksecurefunc(WorldQuestDataProviderMixin, "RefreshAllData", SetFlightMapPins)
end

function BWQ:AttachToBlock(anchor)
	if not BWQ:C("attachToWorldMap") or (BWQ:C("attachToWorldMap") and not WorldMapFrame:IsShown()) then
		-- Close any open context menus (modern Menu API)
		local openMenu = Menu and Menu.GetOpenMenu and Menu.GetOpenMenu()
		if openMenu then
			openMenu:Close()
		end

		BWQ.blockYPos = select(2, anchor:GetCenter())
		BWQ.showDownwards = BWQ.blockYPos > UIParent:GetHeight() / 2
		BWQ:ClearAllPoints()
		BWQ:SetPoint(BWQ.showDownwards and "TOP" or "BOTTOM", anchor, BWQ.showDownwards and "BOTTOM" or "TOP", 0, 0)
		BWQ:SetFrameStrata("DIALOG")
		BWQ:Show()

		BWQ:RunUpdate()
	end
end

function BWQ:AttachToWorldMap()
	BWQ:ClearAllPoints()
	BWQ:SetPoint("TOPLEFT", WorldMapFrame, "TOPRIGHT", 3, 0)
	BWQ:SetFrameStrata("HIGH")
	BWQ:Show()
end

BWQ:RegisterEvent("PLAYER_ENTERING_WORLD")
BWQ:RegisterEvent("ADDON_LOADED")
BWQ:SetScript("OnEvent", function(self, event, arg1)
	if event == "QUEST_LOG_UPDATE" then
		--[[
		Opening quest details in the side bar of the world map fires QUEST_LOG_UPDATE event.
		To avoid setting the currently shown map again, which would hide the quest details,
		skip updating after a WORLD_MAP_UPDATE event happened
		--]]
		if not BWQ.skipNextUpdate then
			BWQ:RunUpdate()
		end
		BWQ.skipNextUpdate = false
	elseif event == "QUEST_WATCH_LIST_CHANGED" then
		BWQ:UpdateBlock()
	elseif event == "CHAT_MSG_COMBAT_FACTION_CHANGE" then
		BWQ:OnFactionUpdate(arg1)
	elseif event == "PLAYER_ENTERING_WORLD" then
		BWQ.slider:SetScript("OnLeave", Block_OnLeave )
		BWQ.slider:SetScript("OnValueChanged", function(self, value)
			BWQ:RenderRows()
		end)

		BWQ:SetScript("OnMouseWheel", function(self, delta)
			BWQ.slider:SetValue(BWQ.slider:GetValue() - delta * 3)
		end)

		if Aurora and Aurora[1] then
			Aurora[1].CreateBD(BWQ)
		elseif ElvUI then
			BWQ:SetTemplate("Transparent")
		elseif TipTac then
			local tiptacBKG = { tile = false, insets = {} }
			local cfg = TipTac_Config
			if cfg.tipBackdropBG and cfg.tipBackdropEdge and cfg.tipColor and cfg.tipBorderColor then
				tiptacBKG.bgFile = cfg.tipBackdropBG
				tiptacBKG.edgeFile = cfg.tipBackdropEdge
				tiptacBKG.edgeSize = cfg.backdropEdgeSize
				tiptacBKG.insets.left = cfg.backdropInsets
				tiptacBKG.insets.right = cfg.backdropInsets
				tiptacBKG.insets.top = cfg.backdropInsets
				tiptacBKG.insets.bottom = cfg.backdropInsets
				BWQ:SetBackdrop(tiptacBKG)
				BWQ:SetBackdropColor(unpack(cfg.tipColor))
				BWQ:SetBackdropBorderColor(unpack(cfg.tipBorderColor))
			end
		end

		hooksecurefunc(WorldMapFrame, "Hide", function(self)
			if BWQ:C("attachToWorldMap") then
				BWQ:Hide()
			end

			BWQ.mapTextures.animationGroup:Stop()
		end)
		hooksecurefunc(WorldMapFrame, "Show", function(self)
			if BWQ:C("attachToWorldMap") then
				BWQ:AttachToWorldMap()
				BWQ:RunUpdate()
			end
		end)
		hooksecurefunc(WorldMapFrame, "OnMapChanged", function(self)
			BWQ.skipNextUpdate = true
			local mapId = WorldMapFrame:GetMapID()
			if BWQ.currentMapId and BWQ.currentMapId ~= mapId then
				BWQ.mapTextures.animationGroup:Stop()
			end
			BWQ.currentMapId = mapId
		end)

		BWQ:UnregisterEvent("PLAYER_ENTERING_WORLD")

		BWQ:RegisterEvent("QUEST_LOG_UPDATE")
		BWQ:RegisterEvent("QUEST_WATCH_LIST_CHANGED")
		if (not BWQ:C("hideFactionParagonBars")) then
			BWQ:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
		end
		if TomTom then
			BWQ:RegisterEvent("PLAYER_LOGOUT")
			BWQ:RegisterEvent("QUEST_ACCEPTED")
		end
		if BWQ:C("autoChooseExpansionOnZone") then 
			BWQ:RegisterEvent("ZONE_CHANGED_NEW_AREA")
			BWQ:RegisterEvent("NEW_WMO_CHUNK")
		end
	elseif event == "ADDON_LOADED" then
		if arg1 == "Broker_WorldQuests" then
			BWQcfg = BWQcfg or BWQ.defaultConfig
			BWQcfgPerCharacter = BWQcfgPerCharacter and BWQcfgPerCharacter or BWQcfg and BWQcfg or BWQ.defaultConfig
			for i, v in next, BWQ.defaultConfig do
				if BWQcfg[i] == nil then BWQcfg[i] = v end
				if BWQcfgPerCharacter[i] == nil then BWQcfgPerCharacter[i] = v end
			end
			BWQcache = BWQcache or {}
			if not BWQ:C("expansion") then
				if UnitLevel("player") >= 71 then
					BWQ:SwitchExpansion(CONSTANTS.EXPANSIONS.THEWARWITHIN)	
				elseif UnitLevel("player") >= 61 then
					BWQ:SwitchExpansion(CONSTANTS.EXPANSIONS.DRAGONFLIGHT)	
				elseif UnitLevel("player") >= 51 then
					BWQ:SwitchExpansion(CONSTANTS.EXPANSIONS.SHADOWLANDS)
				elseif UnitLevel("player") >= 41 then
					BWQ:SwitchExpansion(CONSTANTS.EXPANSIONS.BFA)	
				else
					BWQ:SwitchExpansion(CONSTANTS.EXPANSIONS.LEGION)	
				end
			else
				BWQ:SwitchExpansion(BWQ:C("expansion"))
			end	

			if C_AddOns.IsAddOnLoaded('Blizzard_SharedMapDataProviders') then
				BWQ:AddFlightMapHook()
				BWQ:UnregisterEvent("ADDON_LOADED")
			end
		elseif arg1 == "Blizzard_SharedMapDataProviders" then
			BWQ:AddFlightMapHook()
			BWQ:UnregisterEvent("ADDON_LOADED")
		end
	elseif event == "QUEST_ACCEPTED" then
		if TomTom and BWQ.TomTomWaypoints[arg1] and C_AddOns.IsAddOnLoaded("TomTom") then 
			TomTom:RemoveWaypoint(BWQ.TomTomWaypoints[arg1]) 
			BWQ.TomTomWaypoints[arg1] = nil
		end
	elseif event == "PLAYER_LOGOUT" then
		if TomTom and #BWQ.TomTomWaypoints and C_AddOns.IsAddOnLoaded("TomTom") then
			for k, v in pairs(BWQ.TomTomWaypoints) do
				TomTom:RemoveWaypoint(BWQ.TomTomWaypoints[k])
				BWQ.TomTomWaypoints[k] = nil
			end
		end
	elseif event == "ZONE_CHANGED_NEW_AREA" or "NEW_WMO_CHUNK" then
		local mapID = C_Map.GetBestMapForUnit("player")
		if mapID then
			if mapID == BWQ.mapID then
				return
			else
				BWQ.mapID = mapID
			end
			local found, expansionName = BWQ:SearchMapZones(BWQ.MAP_ZONES_SORT, mapID)
			if not found then
				found, expansionName = BWQ:SearchMapZones(BWQ.MAP_ZONES_EXTRA, mapID)
			end
			
			if found then
				--local mapInfo = C_Map.GetMapInfo(mapID)
				--if BWQcfg.spewDebugInfo and mapInfo then
					--print(string.format("[BWQ] Entered new zone: %s (ID: %d) [%s vs. %s]", mapInfo.name, mapID, expansionName, BWQ.expansion))
				--end
				if expansionName ~= BWQ.expansion then
					--if BWQcfg.spewDebugInfo then
						--print(string.format("[BWQ] Calling BWQ:SwitchExpansion(%s)", expansionName))
					--end
					BWQ:SwitchExpansion(expansionName)
				end	
			--else
				--if BWQcfg.spewDebugInfo and mapInfo then
					--print(string.format("[BWQ] Entered new zone: %s (ID: %d) [N/A]", mapInfo.name, mapID))
				--end
			end
		end
	end
end)
