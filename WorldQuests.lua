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

local defaultConfig = {
	-- general
	attachToWorldMap = false,
	showOnClick = false,
	usePerCharacterSettings = false,
	enableClickToOpenMap = false,
	enableTomTomWaypointsOnClick = true,
	spewDebugInfo = false,
	alwaysShowBountyQuests = true,
	alwaysShowEpicQuests = true,
	onlyShowRareOrAbove = false,
	showTotalsInBrokerText = true,
		brokerShowAP = true,
		brokerShowServiceMedals = true,
		brokerShowWakeningEssences = true,
		brokerShowWarResources = true,
		brokerShowPrismaticManapearl = true,
		brokerShowCyphersOfTheFirstOnes = true,
		brokerGratefulOffering = true,
		brokerShowResources = true,
		brokerShowLegionfallSupplies = true,
		brokerShowXP = true,
		brokerShowHonor = true,
		brokerShowGold = false,
		brokerShowGear = false,
		brokerShowMarkOfHonor = false,
		brokerShowHerbalism = false,
		brokerShowMining = false,
		brokerShowFishing = false,
		brokerShowSkinning = false,
		brokerShowBloodOfSargeras = false,
		brokerShowDragonIslesSupplies = true,
		brokerShowElementalOverflow = true,
		brokerShowFlightstones = true,
		brokerShowWhelplingsDreamingCrest = true,
		brokerShowDrakesDreamingCrest = true,
		brokerShowWyrmsDreamingCrest = true,
		brokerShowAspectsDreamingCrest = true,
		brokerShowWhelplingsAwakenedCrest = true,
		brokerShowDrakesAwakenedCrest = true,
		brokerShowWyrmsAwakenedCrest = true,
		brokerShowAspectsAwakenedCrest = true,
		brokerShowMysteriousFragment = true,
		brokerShowResonanceCrystals = true,
		brokerShowTheAssemblyoftheDeeps = true,
		brokerShowValorstones = true,
		brokerShowKej = true,
		brokerShowCouncilofDornogal = true,
		brokerShowHallowfallArathi = true,
		brokerShowTheWeaver = true,
		brokerShowTheGeneral = true,
		brokerShowTheVizier = true,
		brokerShowBloodyTokens = true,
		brokerShowPolishedPetCharms = false,
	sortByTimeRemaining = false,
	-- reward type
	showDragonIslesSupplies = true,
	showElementalOverflow = true,
	showFlightstones = true,
	showWhelplingsDreamingCrest = true,
	showDrakesDreamingCrest = true,
	showWyrmsDreamingCrest = true,
	showAspectsDreamingCrest = true,
	showWhelplingsAwakenedCrest = true,
	showDrakesAwakenedCrest = true,
	showWyrmsAwakenedCrest = true,
	showAspectsAwakenedCrest = true,
	showMysteriousFragment = true,
	showResonanceCrystals = true,
	showCouncilofDornogal = true,
	showTheAssemblyoftheDeeps = true,
	showHallowfallArathi = true,
	showTheWeaver = true,
	showTheGeneral = true,
	showTheVizier = true,
	showValorstones = true,
	showKej = true,
	showBloodyTokens = true,
	showArtifactPower = true,
	showPrismaticManapearl = true,
	showCyphersOfTheFirstOnes = true,
	showGratefulOffering = true,
	showItems = true,
		showGear = true,
		showRelics = true,
		showCraftingMaterials = true,
		showConduits = true,
		showMarkOfHonor = true,
		showOtherItems = true,
	showTWWReputation = true,
	showDFReputation = true,
	showSLReputation = true,
	showBFAReputation = true,
	showBFAServiceMedals = true,
	showXP = true,
	showHonor = true,
	showLowGold = true,
	showHighGold = true,
	showWarResources = true,
	showAnima = true,
	showResources = true,
	showLegionfallSupplies = true,
	showNethershards = true,
	showArgunite = true,
	showWakeningEssences = true,
	-- quest type
	showProfession = true,
		showProfessionAlchemy = true,
		showProfessionBlacksmithing = true,
		showProfessionInscription = true,
		showProfessionJewelcrafting = true,
		showProfessionLeatherworking = true,
		showProfessionTailoring = true,
		showProfessionEnchanting = true,
		showProfessionEngineering = true,
		showProfessionHerbalism = true,
		showProfessionMining = true,
		showProfessionSkinning = true,
		showProfessionCooking = true,
		showProfessionArchaeology = true,
		showProfessionFishing = true,
	showDungeon = true,
	showDragonRiderRacing = true,
	showPvP = true,
	hideFactionColumn = false,
	hideFactionParagonBars = false,
		-- Dragonflight
		alwaysShowDragonscaleExpedition = false,
		alwaysShowIskaaraTuskarr = false,
		alwaysShowMaruukCentaur = false,
		alwaysShowValdrakkenAccord = false,
		alwaysShowLoammNiffen = false,
		alwaysShowDreamWardens = false,
		-- Shadowlands
		alwaysShowAscended = false,
		alwaysShowUndyingArmy = false,
		alwaysShowCourtofHarvesters = false,
		alwaysShowAvowed = false,
		alwaysShowWildHunt = false,
		alwaysShowDeathsAdvance = false,
		alwaysShowEnlightened = false,
		-- BFA
		alwaysShow7thLegion = false,
		alwaysShowStormsWake = false,
		alwaysShowOrderOfEmbers = false,
		alwaysShowProudmooreAdmiralty = false,
		alwaysShowWavebladeAnkoan = false,
		alwaysShowTheHonorbound = false,
		alwaysShowZandalariEmpire = false,
		alwaysShowTalanjisExpedition = false,
		alwaysShowVoldunai = false,
		alwaysShowTheUnshackled = false,
		alwaysShowRustboltResistance = false,
		alwaysShowTortollanSeekers = false,
		alwaysShowChampionsOfAzeroth = false,
		-- Legion
		alwaysShowCourtOfFarondis = false,
		alwaysShowDreamweavers = false,
		alwaysShowHighmountainTribe = false,
		alwaysShowNightfallen = false,
		alwaysShowWardens = false,
		alwaysShowValarjar = false,
		alwaysShowArmiesOfLegionfall = false,
		alwaysShowArmyOfTheLight = false,
		alwaysShowArgussianReach = false,
	showPetBattle = true,
	hidePetBattleBountyQuests = false,
	alwaysShowPetBattleFamilyFamiliar = true,

	collapsedZones = {},
}
local C = function(k)
	if BWQcfg.usePerCharacterSettings then
		return BWQcfgPerCharacter[k]
	else
		return BWQcfg[k]
	end
end

local CreateErrorFS = function()
	BWQ.errorFS = BWQ:CreateFontString("BWQerrorFS", "OVERLAY", "SystemFont_Shadow_Med1")
	BWQ.errorFS:SetJustifyH("CENTER")
	BWQ.errorFS:SetTextColor(.9, .8, 0)
end

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
		if not BWQ.errorFS then CreateErrorFS() end

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
	if not BWQ.errorFS then CreateErrorFS() end

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

local locale = GetLocale()
local millionSearchLocalized = { enUS = "million", enGB = "million", zhCN = "万", frFR = "million", deDE = "Million", esES = "mill", itIT = "milion", koKR = "만", esMX = "mill", ptBR = "milh", ruRU = "млн", zhTW = "萬", }
local billionSearchLocalized = { enUS = "billion", enGB = "billion", zhCN = "亿", frFR = "milliard", deDE = "Milliarde", esES = "mil millones", itIT = "miliard", koKR = "억", esMX = "mil millones", ptBR = "bilh", ruRU = "млрд", zhTW = "億", }
local BWQScanTooltip = CreateFrame("GameTooltip", "BWQScanTooltip", nil, "GameTooltipTemplate,BackdropTemplate")
BWQScanTooltip:Hide()
function BWQ:GetArtifactPowerValue(itemId)
	local _, itemLink = GetItemInfo(itemId)
	BWQScanTooltip:SetOwner(BWQ, "ANCHOR_NONE")
	BWQScanTooltip:SetHyperlink(itemLink)
	local numLines = BWQScanTooltip:NumLines()
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
				if (text:find(millionSearchLocalized[locale])) then
					-- en locale only use ',' for thousands, shouldn't occur in these million digit numbers
					-- replace ',' for german etc comma numbers so we can do math with them.
					power = power:gsub(",", ".")
					power = power * 1000000
				elseif (text:find(billionSearchLocalized[locale])) then
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
function BWQ:GetItemLevelValueForQuestId(questId)
	BWQScanTooltip:SetOwner(BWQ, "ANCHOR_NONE")
	BWQScanTooltip:SetQuestLogItem("reward", 1, questId)
	local numLines = BWQScanTooltip:NumLines()
	for i = 2, numLines do
		local text = _G["BWQScanTooltipTextLeft" .. i]:GetText()
		local e = ITEM_LEVEL_PLUS:find("%%d")
		if text and text:find(ITEM_LEVEL_PLUS:sub(1, e - 1)) then
			return text:match("%d+%+?") or ""
		end
	end
	return ""
end

function BWQ:ValueWithWarModeBonus(questId, value)
	local multiplier = BWQ.warmodeEnabled and 1.1 or 1
	return floor(value * multiplier + 0.5)
end

function BWQ:IsQuestAchievementCriteriaMissing(achievementId, questId)
	local criteriaId = CONSTANTS.ACHIEVEMENT_CRITERIAS[questId]
	if criteriaId then
		local _, _, completed = GetAchievementCriteriaInfo(achievementId, criteriaId)
		return not completed
	else
		return false
	end
end

local AbbreviateNumber = function(number)
	number = tonumber(number)
	if number >= 1000000 then
		number = number / 1000000
		return string.format((number % 1 == 0) and "%.0f%s" or "%.1f%s", number, "M")
	elseif number >= 10000 then
		return string.format("%.0f%s", number / 1000, "K")
	end
	return number
end

local FormatTimeLeftString = function(timeLeft)
	if timeLeft <= 0 then return "" end
	local timeLeftStr = ""
	-- if timeLeft >= 60 * 24 then -- at least 1 day
	-- 	timeLeftStr = string.format("%.0fd", timeLeft / 60 / 24)
	-- end
	if timeLeft >= 60 then -- hours
		timeLeftStr = string.format("%.0fh", math.floor(timeLeft / 60))
	end
	timeLeftStr = string.format("%s%s%sm", timeLeftStr, timeLeftStr ~= "" and " " or "", timeLeft % 60) -- always show minutes

	if 		timeLeft <= 120 then timeLeftStr = string.format("|cffD96932%s|r", timeLeftStr)
	elseif 	timeLeft <= 240 then timeLeftStr = string.format("|cffDBA43B%s|r", timeLeftStr)
	elseif 	timeLeft <= 480 then timeLeftStr = string.format("|cffE6D253%s|r", timeLeftStr)
	elseif 	timeLeft <= 960 then timeLeftStr = string.format("|cffE6DA8E%s|r", timeLeftStr)
	end
	return timeLeftStr
end

local tip = GameTooltip
local ShowQuestObjectiveTooltip = function(row)
	tip:SetOwner(row, "ANCHOR_CURSOR")
	local color = WORLD_QUEST_QUALITY_COLORS[row.quest.quality]
	tip:AddLine(row.quest.title, color.r, color.g, color.b, true)

	for objectiveIndex = 1, row.quest.numObjectives do
		local objectiveText, objectiveType, finished = GetQuestObjectiveInfo(row.quest.questId, objectiveIndex, false);
		if objectiveText and #objectiveText > 0 then
			color = finished and GRAY_FONT_COLOR or HIGHLIGHT_FONT_COLOR;
			tip:AddLine(QUEST_DASH .. objectiveText, color.r, color.g, color.b, true);
		end
	end

	local percent = C_TaskQuest.GetQuestProgressBarInfo(row.quest.questId)
	if percent then
		GameTooltip_ShowProgressBar(tip, 0, 100, percent, PERCENTAGE_STRING:format(percent))
	end

	tip:Show()
end

local ShowQuestLogItemTooltip = function(button)
	local name, texture = GetQuestLogRewardInfo(1, button.quest.questId)
	if name and texture then
		tip:SetOwner(button.reward, "ANCHOR_CURSOR")
		BWQScanTooltip:SetQuestLogItem("reward", 1, button.quest.questId)
		local _, itemLink = BWQScanTooltip:GetItem()
		tip:SetHyperlink(itemLink)
		tip:Show()
	end
end

local ShowWorldQuestPOITooltip = function(button,poi)
    tip:SetOwner(button, "ANCHOR_CURSOR")
    tip:SetText(poi.name)
	if button.quest.LockedWQ then
		local description = string.format("You must complete %d more %s in %s to unlock '%s', which rewards |5 %s.", button.quest.LockedWQ_questsRemaining, button.quest.LockedWQ_questsRemaining > 1 and "WQs" or "WQ", button.quest.LockedWQ_zone, poi.name, button.quest.reward.itemLink)
    	tip:AddLine(description, 1, 1, 1, true)
	end
    tip:Show()
end

-- super track map ping
local mapTextures = CreateFrame("Frame", "BWQ_MapTextures", WorldMapFrame:GetCanvas())
mapTextures:SetSize(400,400)
mapTextures:SetFrameStrata("DIALOG")
mapTextures:SetFrameLevel(2001)
local highlightArrow = mapTextures:CreateTexture("highlightArrow")
highlightArrow:SetTexture("Interface\\minimap\\MiniMap-DeadArrow")
highlightArrow:SetSize(56, 56)
highlightArrow:SetRotation(3.14)
highlightArrow:SetPoint("CENTER", mapTextures)
highlightArrow:SetDrawLayer("ARTWORK", 1)
mapTextures.highlightArrow = highlightArrow
local animationGroup = mapTextures:CreateAnimationGroup()
animationGroup:SetLooping("REPEAT")
animationGroup:SetScript("OnPlay", function(self)
	mapTextures.highlightArrow:Show()
end)
animationGroup:SetScript("OnStop", function(self)
	mapTextures.highlightArrow:Hide()
end)
local downAnimation = animationGroup:CreateAnimation("Translation")
downAnimation:SetChildKey("highlightArrow")
downAnimation:SetOffset(0, -10)
downAnimation:SetDuration(0.4)
downAnimation:SetOrder(1)
local upAnimation = animationGroup:CreateAnimation("Translation")
upAnimation:SetChildKey("highlightArrow")
upAnimation:SetOffset(0, 10)
upAnimation:SetDuration(0.4)
upAnimation:SetOrder(2)
mapTextures.animationGroup = animationGroup
BWQ.mapTextures = mapTextures

function BWQ:QueryZoneQuestCoordinates(mapId)
	local quests = C_TaskQuest.GetQuestsForPlayerByMapID(mapId)
	if quests then
		for _, v in next, quests do
			local quest = BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[v.questId] 
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
		if (C_QuestLog.GetQuestWatchType(row.quest.questId) == Enum.QuestWatchType.Manual or C_SuperTrack.GetSuperTrackedQuestID() == row.quest.questId) then
			C_QuestLog.RemoveWorldQuestWatch(row.quest.questId)
		else
			C_QuestLog.AddWorldQuestWatch(row.quest.questId, Enum.QuestWatchType.Manual)
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

		if TomTom and C("enableTomTomWaypointsOnClick") then
			if not row.quest.x or not row.quest.y then BWQ:QueryZoneQuestCoordinates(row.mapId) end
			if row.quest.x and row.quest.y then
				if BWQ.TomTomWaypoints[row.quest.questId] then 
					TomTom:RemoveWaypoint(BWQ.TomTomWaypoints[row.quest.questId]) 
				else
					BWQ.TomTomWaypoints[row.quest.questId] = TomTom:AddWaypoint(row.mapId, row.quest.x, row.quest.y, { title = row.quest.title, silent = true })
				end
			end
		end
	end
end

local lastUpdate, updateTries = 0, 0
local needsRefresh = false
local DebugRetrieveWQ = false
local RetrieveWorldQuests = function(mapId)
	local numQuests = 0
	local currentTime = GetTime()
	local questList = C_TaskQuest.GetQuestsForPlayerByMapID(mapId)
	BWQ.warmodeEnabled = C_PvP.IsWarModeDesired()

	if questList then
		numQuests = 0
		BWQ.MAP_ZONES[BWQ.expansion][mapId].questsSort = {}

		local timeLeft, questTagInfo, title, factionId
		for i, q in ipairs(questList) do
			if DebugRetrieveWQ then
				print(string.format("[BWQ] questList.%d: ID: %s (mapId: %d)", i, tostring(q.questId), mapId))
			end
			if HaveQuestData(q.questId) and q.mapID == mapId then 
				timeLeft = C_TaskQuest.GetQuestTimeLeftMinutes(q.questId) or 0
				questTagInfo = C_QuestLog.GetQuestTagInfo(q.questId)

				if DebugRetrieveWQ then
					local _title, _factionId = C_TaskQuest.GetQuestInfoByQuestID(q.questId)
					print(string.format("[BWQ] questList.%d: %s", i, _title))
					if _factionId then print(string.format("[BWQ] questList.%d: faction: %d (%s)", i, _factionId, C_Reputation.GetFactionDataByID(_factionId).name)) end
					if questTagInfo then print(string.format("[BWQ] questList.%d: WorldQuestType: %d", i, questTagInfo.worldQuestType)) end
				end

				if questTagInfo and questTagInfo.worldQuestType then
					local questId = q.questId
					table.insert(BWQ.MAP_ZONES[BWQ.expansion][mapId].questsSort, questId)
					local quest = BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[questId] or {}

					if not quest.timeAdded then
						quest.wasSaved = BWQ.questIds[questId] ~= nil
					end
					quest.timeAdded = quest.timeAdded or currentTime
					if quest.wasSaved or currentTime - quest.timeAdded > 900 then
						quest.isNew = false
					else
						quest.isNew = true
					end

					quest.hide = true
					quest.sort = 0

					-- C_TaskQuest.GetQuestsForPlayerByMapID fields
					quest.questId = questId
					quest.numObjectives = q.numObjectives
					quest.xFlight = q.x
					quest.yFlight = q.y

					-- C_QuestLog.GetQuestTagInfo fields
					quest.tagId = questTagInfo.tagID
					quest.worldQuestType = questTagInfo.worldQuestType
					quest.quality = questTagInfo.quality
					quest.isElite = questTagInfo.isElite

					title, factionId = C_TaskQuest.GetQuestInfoByQuestID(quest.questId)
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
					if GetNumQuestLogRewards(quest.questId) > 0 then
						local itemName, itemTexture, quantity, quality, isUsable, itemId = GetQuestLogRewardInfo(1, quest.questId)
						if itemName then
							hasReward = true
							quest.reward.itemTexture = itemTexture
							quest.reward.itemId = itemId
							quest.reward.itemQuality = quality
							quest.reward.itemQuantity = quantity
							quest.reward.itemName = itemName
							--print(string.format("[BWQ] Quest %s - %s - %s - %s - %s", quest.questId, quest.title, itemName, itemId, quantity))    -- for debugging
							
							local _, _, _, _, _, _, _, _, equipSlot, _, _, classId, subClassId = GetItemInfo(quest.reward.itemId)
							if classId == 7 then
								quest.sort = quest.sort > CONSTANTS.SORT_ORDER.PROFESSION and quest.sort or CONSTANTS.SORT_ORDER.PROFESSION
								if quest.reward.itemId == 124124 then
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.BLOODOFSARGERAS
								end
								if C("showItems") and C("showCraftingMaterials") then quest.hide = false end
							elseif equipSlot ~= "" or itemId == 163857 --[[ Azerite Armor Cache ]] then
								quest.sort = quest.sort > CONSTANTS.SORT_ORDER.EQUIP and quest.sort or CONSTANTS.SORT_ORDER.EQUIP
								quest.reward.realItemLevel = BWQ:GetItemLevelValueForQuestId(quest.questId)
								rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.GEAR
								if C("showItems") and C("showGear") then quest.hide = false end
							elseif C_Soulbinds.IsItemConduitByItemInfo(itemId) == true then
								if C("showConduits") then quest.hide = false end
							elseif C_Item.IsAnimaItemByID(itemId) == true then
								if C("showAnima") then quest.hide = false end
							elseif itemId == 137642 then -- mark of honor
								quest.sort = quest.sort > CONSTANTS.SORT_ORDER.ITEM and quest.sort or CONSTANTS.SORT_ORDER.ITEM
								rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.MARK_OF_HONOR
								if C("showItems") and C("showMarkOfHonor") then quest.hide = false end
							elseif itemId == 163036 then -- polished pet charm
								quest.reward.polishedPetCharmsAmount = quest.reward.itemQuantity
								rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.POLISHED_PET_CHARM
							else
								quest.sort = quest.sort > CONSTANTS.SORT_ORDER.ITEM and quest.sort or CONSTANTS.SORT_ORDER.ITEM
								rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.IRRELEVANT
								if C("showItems") and C("showOtherItems") then quest.hide = false end
							end
						end
					end
					-- gold reward
					local money = GetQuestLogRewardMoney(quest.questId);
					if money > 20000 then -- >2g, hides these silly low gold extra rewards
						hasReward = true
						quest.reward.money = floor(BWQ:ValueWithWarModeBonus(quest.questId, money) / 10000) * 10000
						quest.sort = quest.sort > CONSTANTS.SORT_ORDER.MONEY and quest.sort or CONSTANTS.SORT_ORDER.MONEY
						rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.MONEY

						if money < 1000000 then
							if C("showLowGold") then quest.hide = false end
						else
							if C("showHighGold") then quest.hide = false end
						end
					end
					-- honor reward
					local honor = GetQuestLogRewardHonor(quest.questId)
					if honor > 0 then
						hasReward = true
						quest.reward.honor = honor
						quest.sort = quest.sort > CONSTANTS.SORT_ORDER.HONOR and quest.sort or CONSTANTS.SORT_ORDER.HONOR
						rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.HONOR

						if C("showHonor") then quest.hide = false end
					end
					-- currency reward
					local rewardCurrencies = C_QuestInfoSystem.GetQuestRewardCurrencies(quest.questId)	
					if rewardCurrencies then
						quest.reward.currencies = {}
						for i, currencyInfo in ipairs(rewardCurrencies) do
							local name = currencyInfo.name
							local texture = currencyInfo.texture
							local numItems = currencyInfo.totalRewardAmount
							local currencyId = currencyInfo.currencyID
							--print(string.format("[BWQ] QuestID: %d", quest.questId))														-- Debugging
							--print(string.format("[BWQ] - currencyInfo: %d - %s - %d - %d - %d", i, name, texture, numItems, currencyId))	-- Debugging
							if name then
								hasReward = true
								local currency = {}
								if CONSTANTS.CURRENCIES_AFFECTED_BY_WARMODE[currencyId] then
									currency.amount = BWQ:ValueWithWarModeBonus(quest.questId, numItems)
								else
									currency.amount = numItems
								end
								currency.name = string.format("%d %s", currency.amount, name)
								currency.texture = texture

								--print(string.format("[BWQ] Quest %s - %s - %s - %s - %s - %s - %s", quest.questId, quest.title, name, currencyId, currency.name, currency.texture, currency.amount))    -- for debugging

								if currencyId == 1553 then -- azerite
									currency.name = string.format("|cffe5cc80[%d %s]|r", currency.amount, name)
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.ARTIFACTPOWER
									quest.reward.azeriteAmount = currency.amount -- todo: improve broker text values?
									if C("showArtifactPower") then quest.hide = false end
								elseif CONSTANTS.THEWARWITHIN_REPUTATION_CURRENCY_IDS[currencyId] then
									currency.name = string.format("%s: %d %s", name, currency.amount, REPUTATION)
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.IRRELEVANT
									if C("showTWWReputation") then quest.hide = false end
								elseif CONSTANTS.DRAGONFLIGHT_REPUTATION_CURRENCY_IDS[currencyId] then
									currency.name = string.format("%s: %d %s", name, currency.amount, REPUTATION)
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.IRRELEVANT
									if C("showDFReputation") then quest.hide = false end
								elseif CONSTANTS.SHADOWLANDS_REPUTATION_CURRENCY_IDS[currencyId] then
									currency.name = string.format("%s: %d %s", name, currency.amount, REPUTATION)
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.IRRELEVANT
									if C("showSLReputation") then quest.hide = false end
								elseif CONSTANTS.BFA_REPUTATION_CURRENCY_IDS[currencyId] then
									currency.name = string.format("%s: %d %s", name, currency.amount, REPUTATION)
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.IRRELEVANT
									if C("showBFAReputation") then quest.hide = false end
								elseif currencyId == 1560 then -- war resources
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.WAR_RESOURCES
									quest.reward.warResourceAmount = currency.amount
									if C("showWarResources") then quest.hide = false end
								elseif currencyId == 1716 or currencyId == 1717 then -- service medals
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.SERVICE_MEDAL
									quest.reward.serviceMedalAmount = currency.amount
									if C("showBFAServiceMedals") then quest.hide = false end
								elseif currencyId == 1220 then -- order hall resources
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.RESOURCES
									quest.reward.resourceAmount = currency.amount
									if C("showResources") then quest.hide = false end
								elseif currencyId == 1342 then -- legionfall supplies
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.LEGIONFALL_SUPPLIES
									quest.reward.legionfallSuppliesAmount = currency.amount
									if C("showLegionfallSupplies") then quest.hide = false end
								elseif currencyId == 1226 then -- nethershard
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.NETHERSHARD
									if C("showNethershards") then quest.hide = false end
								elseif currencyId == 1508 then -- argunite
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.ARGUNITE
									if C("showArgunite") then quest.hide = false end
								elseif currencyId == 1533 then
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.WAKENING_ESSENCE
									quest.reward.wakeningEssencesAmount = currency.amount
									if C("showWakeningEssences") then quest.hide = false end
								elseif currencyId == 1721 then -- prismatic manapearl
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.PRISMATIC_MANAPEARL
									quest.reward.prismaticManapearlAmount = currency.amount
									if C("showPrismaticManapearl") then quest.hide = false end
								elseif currencyId == 1979 then -- cyphers of the first ones (Zereth Mortis - 9.2)
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.CYPHERS_OF_THE_FIRST_ONES
									quest.reward.cyphersOfTheFirstOnesAmount = currency.amount
									if C("showCyphersOfTheFirstOnes") then quest.hide = false end
								elseif currencyId == 1885 then -- grateful offering
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.GRATEFUL_OFFERING
									quest.reward.gratefulOfferingAmount = currency.amount
									if C("showGratefulOffering") then quest.hide = false end
								elseif currencyId == 2123 then -- bloody tokens
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.BLOODY_TOKENS
									quest.reward.bloodyTokensAmount = currency.amount
									if C("showBloodyTokens") then quest.hide = false end
								elseif currencyId == 2003 then -- dragon isles supplies
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.DRAGON_ISLES_SUPPLIES
									quest.reward.dragonIslesSuppliesAmount = currency.amount
									if C("showDragonIslesSupplies") then quest.hide = false end
								elseif currencyId == 2118 then -- elemental overflow
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.ELEMENTAL_OVERFLOW
									quest.reward.elementalOverflowAmount = currency.amount
									if C("showElementalOverflow") then quest.hide = false end
								elseif currencyId == 2245 then -- flightstones
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.FLIGHTSTONES
									quest.reward.flightstonesAmount = currency.amount
									if C("showFlightstones") then quest.hide = false end
								elseif currencyId == 2706 then -- Whelplings Dreaming Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.WHELPLINGS_DREAMING_CREST
									quest.reward.WhelplingsDreamingCrestAmount = currency.amount
									if C("showWhelplingsDreamingCrest") then quest.hide = false end
								elseif currencyId == 2707 then -- Drakes Dreaming Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.DRAKES_DREAMING_CREST
									quest.reward.DrakesDreamingCrestAmount = currency.amount
									if C("showDrakesDreamingCrest") then quest.hide = false end
								elseif currencyId == 2708 then -- Wyrms Dreaming Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.WYRMS_DREAMING_CREST
									quest.reward.WyrmsDreamingCrestAmount = currency.amount
									if C("showWyrmsDreamingCrest") then quest.hide = false end
								elseif currencyId == 2709 then -- Aspects Dreaming Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.ASPECTS_DREAMING_CREST
									quest.reward.AspectsDreamingCrestAmount = currency.amount
									if C("showAspectsDreamingCrest") then quest.hide = false end
								elseif currencyId == 2806 then -- Whelplings Awakened Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.WHELPLINGS_Awakened_CREST
									quest.reward.WhelplingsAwakenedCrestAmount = currency.amount
									if C("showWhelplingsAwakenedCrest") then quest.hide = false end
								elseif currencyId == 2807 then -- Drakes Awakened Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.DRAKES_Awakened_CREST
									quest.reward.DrakesAwakenedCrestAmount = currency.amount
									if C("showDrakesAwakenedCrest") then quest.hide = false end
								elseif currencyId == 2809 then -- Wyrms Awakened Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.WYRMS_Awakened_CREST
									quest.reward.WyrmsAwakenedCrestAmount = currency.amount
									if C("showWyrmsAwakenedCrest") then quest.hide = false end
								elseif currencyId == 2812 then -- Aspects Awakened Crest
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.ASPECTS_Awakened_CREST
									quest.reward.AspectsAwakenedCrestAmount = currency.amount
									if C("showAspectsAwakenedCrest") then quest.hide = false end
								elseif currencyId == 2657 then -- Mysterious Fragment
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.MYSTERIOUS_FRAGMENT
									quest.reward.MysteriousFragmentAmount = currency.amount
									if C("showMysteriousFragment") then quest.hide = false end
								elseif currencyId == 2815 then -- Resonance Crystals
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.RESONANCE_CRYSTALS
									quest.reward.ResonanceCrystalsAmount = currency.amount
									if C("showResonanceCrystals") then quest.hide = false end
								elseif currencyId == 2902 then -- The Assembly of the Deeps
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.THE_ASSEMBLY_OF_THE_DEEPS
									quest.reward.TheAssemblyoftheDeepsAmount = currency.amount
									if C("showTheAssemblyoftheDeeps") then quest.hide = false end
								elseif currencyId == 2899 then -- Hallowfall Arathi
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.HALLOWFALL_ARATHI
									quest.reward.HallowfallArathiAmount = currency.amount
									if C("showHallowfallArathi") then quest.hide = false end
								elseif currencyId == 3008 then -- Valorstones
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.VALORSTONES
									quest.reward.ValorstonesAmount = currency.amount
									if C("showValorstones") then quest.hide = false end
								elseif currencyId == 3056 then -- Kej
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.KEJ
									quest.reward.KejAmount = currency.amount
									if C("showKej") then quest.hide = false end
								elseif currencyId == 2897 then -- Council of Dornogal
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.COUNCIL_OF_DORNOGAL
									quest.reward.CouncilofDornogalAmount = currency.amount
									if C("showCouncilofDornogal") then quest.hide = false end
								elseif currencyId == 3002 then -- The Weaver
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.THE_WEAVER
									quest.reward.TheWeaverAmount = currency.amount
									if C("showTheWeaver") then quest.hide = false end
								elseif currencyId == 3003 then -- The General
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.THE_GENERAL
									quest.reward.TheGeneralAmount = currency.amount
									if C("showTheGeneral") then quest.hide = false end
								elseif currencyId == 3004 then -- The Vizier
									rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.THE_VIZIER
									quest.reward.TheVizierAmount = currency.amount
									if C("showTheVizier") then quest.hide = false end																		
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
						local xp = GetQuestLogRewardXP(quest.questId)
						if xp > 0 then
							hasReward = true
							quest.reward.xp = xp
							quest.sort = quest.sort > CONSTANTS.SORT_ORDER.XP and quest.sort or CONSTANTS.SORT_ORDER.XP
							rewardType[#rewardType+1] = CONSTANTS.REWARD_TYPES.XP
							
							if C("showXP") then quest.hide = false end
						end
					end
					if BWQcfg.spewDebugInfo and not hasReward and not HaveQuestData(quest.questId) then
						print(string.format("[BWQ] Quest with no reward found: ID %s (%s)", quest.questId, quest.title))
					end
					if not hasReward then needsRefresh = true end -- in most cases no reward means api returned incomplete data
					
					for _, bounty in ipairs(BWQ.bounties) do
						if C_QuestLog.IsQuestCriteriaForBounty(quest.questId, bounty.questID) then
							quest.bounties[#quest.bounties + 1] = bounty.icon
						end
					end
					local questType = {}

					-- quest type filters
					if quest.worldQuestType == Enum.QuestTagType.PetBattle then
						if C("showPetBattle") or (C("alwaysShowPetBattleFamilyFamiliar") and CONSTANTS.FAMILY_FAMILIAR_QUEST_IDS[quest.questId] ~= nil) then
							quest.hide = false
						else
							quest.hide = true
						end

						quest.isMissingAchievementCriteria = BWQ:IsQuestAchievementCriteriaMissing(CONSTANTS.ACHIEVEMENT_IDS.PET_BATTLE_WQ[BWQ.expansion], quest.questId)
					elseif quest.worldQuestType == Enum.QuestTagType.Profession then
						if C("showProfession") then

							if quest.tagId == 119 then
								questType[#questType+1] = CONSTANTS.QUEST_TYPES.HERBALISM
								if C("showProfessionHerbalism")	then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 120 then
								questType[#questType+1] = CONSTANTS.QUEST_TYPES.MINING
								if C("showProfessionMining") then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 130 then
								questType[#questType+1] = CONSTANTS.QUEST_TYPES.FISHING
								quest.isMissingAchievementCriteria = BWQ:IsQuestAchievementCriteriaMissing(CONSTANTS.ACHIEVEMENT_IDS.LEGION_FISHING_WQ, quest.questId)
								if C("showProfessionFishing") then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 124 then
								questType[#questType+1] = CONSTANTS.QUEST_TYPES.SKINNING
								if C("showProfessionSkinning") then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 118 then 	if C("showProfessionAlchemy") 			then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 129 then	if C("showProfessionArchaeology") 		then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 116 then 	if C("showProfessionBlacksmithing") 	then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 131 then 	if C("showProfessionCooking") 			then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 123 then 	if C("showProfessionEnchanting") 		then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 122 then 	if C("showProfessionEngineering") 		then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 126 then 	if C("showProfessionInscription") 		then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 125 then 	if C("showProfessionJewelcrafting") 	then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 117 then 	if C("showProfessionLeatherworking") 	then quest.hide = false else quest.hide = true end
							elseif quest.tagId == 121 then 	if C("showProfessionTailoring") 		then quest.hide = false else quest.hide = true end
							end
						else
							quest.hide = true
						end
					elseif not C("showPvP") and quest.worldQuestType == Enum.QuestTagType.PvP then quest.hide = true
					elseif not C("showDungeon") and quest.worldQuestType == Enum.QuestTagType.Dungeon then quest.hide = true
					elseif not C("showDragonRiderRacing") and quest.worldQuestType == Enum.QuestTagType.DragonRiderRacing then quest.hide = true
					end

					-- only show quest that are blue or above quality
					if (C("onlyShowRareOrAbove") and quest.quality < 1) then quest.hide = true end

					-- always show bounty quests or reputation for faction filter
					if (C("alwaysShowBountyQuests") and #quest.bounties > 0) or
						-- Dragonflight
						(C("alwaysShowDragonscaleExpedition") and quest.factionId == 2507) or
						(C("alwaysShowIskaaraTuskarr") and quest.factionId == 2511) or
						(C("alwaysShowMaruukCentaur") and quest.factionId == 2503) or
						(C("alwaysShowValdrakkenAccord") and quest.factionId == 2510) or
						(C("alwaysShowLoammNiffen") and quest.factionId == 2564) or
						(C("alwaysShowDreamWardens") and quest.factionId == 2574) or
						-- Shadowlands
						(C("alwaysShowAscended") and quest.factionId == 2407) or
						(C("alwaysShowUndyingArmy") and quest.factionId == 2410) or
						(C("alwaysShowCourtofHarvesters") and quest.factionId == 2413) or
						(C("alwaysShowAvowed") and quest.factionId == 2439) or
						(C("alwaysShowWildHunt") and quest.factionId == 2465) or
						(C("alwaysShowDeathsAdvance") and quest.factionId == 2470) or
						(C("alwaysShowEnlightened") and quest.factionId == 2478) or
						-- bfa
						(C("alwaysShow7thLegion") and quest.factionId == 2159) or
						(C("alwaysShowStormsWake") and quest.factionId == 2162) or
						(C("alwaysShowOrderOfEmbers") and quest.factionId == 2161) or
						(C("alwaysShowProudmooreAdmiralty") and quest.factionId == 2160) or
						(C("alwaysShowTheHonorbound") and quest.factionId == 2157) or
						(C("alwaysShowZandalariEmpire") and quest.factionId == 2103) or
						(C("alwaysShowTalanjisExpedition") and quest.factionId == 2156) or
						(C("alwaysShowVoldunai") and quest.factionId == 2158) or
						(C("alwaysShowTortollanSeekers") and quest.factionId == 2163) or
						(C("alwaysShowChampionsOfAzeroth") and quest.factionId == 2164) or
						-- 8.2 --
						(C("alwaysShowTheUnshackled") and quest.factionId == 2373) or
						(C("alwaysShowWavebladeAnkoan") and quest.factionId == 2400) or
						(C("alwaysShowRustboltResistance") and quest.factionId == 2391) or
						-- legion
						(C("alwaysShowCourtOfFarondis") and (mapId == 630 or mapId == 790)) or
						(C("alwaysShowDreamweavers") and mapId == 641) or
						(C("alwaysShowHighmountainTribe") and mapId == 650) or
						(C("alwaysShowNightfallen") and mapId == 680) or
						(C("alwaysShowWardens") and quest.factionId == 1894) or
						(C("alwaysShowValarjar") and mapId == 634) or
						(C("alwaysShowArmiesOfLegionfall") and mapId == 646) or
						(C("alwaysShowArmyOfTheLight") and quest.factionId == 2165) or
						(C("alwaysShowArgussianReach") and quest.factionId == 2170) then

						-- pet battle override
						if C("hidePetBattleBountyQuests") and not C("showPetBattle") and quest.worldQuestType == Enum.QuestTagType.PetBattle then
							quest.hide = true
						else
							quest.hide = false
						end
					end
					-- don't filter epic quests based on setting
					if C("alwaysShowEpicQuests") and (quest.quality == 2 or quest.worldQuestType == Enum.QuestTagType.Raid) then quest.hide = false end

					BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[questId] = quest

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
							print("[BWQ] -- ID: "..tostring(quest.questId))
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

		if C("sortByTimeRemaining") then
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
				local questId = poi.areaPoiID
				table.insert(BWQ.MAP_ZONES[BWQ.expansion][mapId].questsSort, questId)
				local quest = BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[questId] or {}
				quest.title = poi.name
				quest.LockedWQ = true
				if not quest.timeAdded then
					quest.wasSaved = BWQ.questIds[questId] ~= nil
				end
				quest.timeAdded = quest.timeAdded or currentTime
				if quest.wasSaved or currentTime - quest.timeAdded > 900 then
					quest.isNew = false
				else
					quest.isNew = true
				end
				quest.hide = false											-- TODO:  Add option to hide locked world quests ...always showing them for now.
				quest.sort = 0
				quest.questId = questId
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
										if string.find(zone,"the") then
											zone = string.match(zone, "^the%s*(.+)")    -- remove the word "the" if it's the first word in the string and lowercase.
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

				BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[questId] = quest
				numQuests = numQuests + 1
			end
		end

		if C("sortByTimeRemaining") then
			table.sort(BWQ.MAP_ZONES[BWQ.expansion][mapId].questsSort, function(a, b) return BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[a].timeLeft < BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[b].timeLeft end)
		else -- reward type
			table.sort(BWQ.MAP_ZONES[BWQ.expansion][mapId].questsSort, function(a, b) return BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[a].sort > BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[b].sort end)
		end

		BWQ.MAP_ZONES[BWQ.expansion][mapId].numQuests = numQuests
	end
end

-- --- BOUNTIES --- --
BWQ.bountyCache = {}
BWQ.bountyDisplay = CreateFrame("Frame", "BWQ_BountyDisplay", BWQ)
function BWQ:UpdateBountyData()
	if BWQ.expansion == CONSTANTS.EXPANSIONS.THEWARWITHIN then -- TODO: get map id for retrieving bounties
		BWQ.bountyDisplay:Hide()
		for i, item in pairs(BWQ.bountyCache) do
			item.button:Hide()
		end
		return
	end
	if BWQ.expansion == CONSTANTS.EXPANSIONS.DRAGONFLIGHT then -- TODO: get map id for retrieving bounties
		BWQ.bountyDisplay:Hide()
		for i, item in pairs(BWQ.bountyCache) do
			item.button:Hide()
		end
		return
	end
	if BWQ.expansion == CONSTANTS.EXPANSIONS.SHADOWLANDS then -- TODO: get map id for retrieving bounties
		BWQ.bountyDisplay:Hide()
		for i, item in pairs(BWQ.bountyCache) do
			item.button:Hide()
		end
		return
	end
	for i, item in pairs(BWQ.bountyCache) do
		item.button:Show()
	end

	BWQ.bounties = C_QuestLog.GetBountiesForMapID(BWQ.expansion == CONSTANTS.EXPANSIONS.BFA and CONSTANTS.MAPID_KUL_TIRAS or CONSTANTS.MAPID_DALARAN_BROKEN_ISLES) or {}
	if #BWQ.bounties == 0 then
		BWQ.bountyDisplay:Hide()
		return
	end

	local bountyWidth = 0 -- added width of all items inside the bounty block
	for bountyIndex, bounty in ipairs(BWQ.bounties) do
		local questIndex = C_QuestLog.GetLogIndexForQuestID(bounty.questID)
		local title = C_QuestLog.GetTitleForLogIndex(questIndex)
		local timeleft = C_TaskQuest.GetQuestTimeLeftMinutes(bounty.questID)
		local _, _, finished, numFulfilled, numRequired = GetQuestObjectiveInfo(bounty.questID, 1, false)

		local bountyCacheItem
		if not BWQ.bountyCache[bountyIndex] then
			bountyCacheItem = {}
			bountyCacheItem.icon = BWQ.bountyDisplay:CreateTexture()
			bountyCacheItem.icon:SetSize(28, 28)

			bountyCacheItem.text = BWQ.bountyDisplay:CreateFontString("BWQ_BountyDisplayText"..bountyIndex, "OVERLAY", "SystemFont_Shadow_Med1")
			
			bountyCacheItem.button = CreateFrame("Button", nil, BWQ, "BackdropTemplate")
			bountyCacheItem.button:SetPoint("TOPLEFT", bountyCacheItem.icon)
			bountyCacheItem.button:SetPoint("BOTTOM", bountyCacheItem.icon)
			bountyCacheItem.button:SetPoint("RIGHT", bountyCacheItem.text)
			
			BWQ.bountyCache[bountyIndex] = bountyCacheItem
		else
			bountyCacheItem = BWQ.bountyCache[bountyIndex]
		end 

		if bounty.icon and title then

			bountyCacheItem.text:SetText(string.format(
											"|cff%s%s\n %s/%s      |r%s",
											numFulfilled == numRequired and "49d65e" or "fafafa",
											title,
											numFulfilled or 0,
											numRequired or 0,
											FormatTimeLeftString(timeleft)
										))
			bountyCacheItem.icon:SetTexture(bounty.icon)
			if bountyIndex == 1 then
				bountyCacheItem.icon:SetPoint("LEFT", BWQ.bountyDisplay, "LEFT", 0, 0)
			else
				bountyCacheItem.icon:SetPoint("LEFT", BWQ.bountyCache[bountyIndex-1].text, "RIGHT", 25, 2)
				bountyWidth = bountyWidth + 25
			end
			bountyCacheItem.text:SetPoint("LEFT", bountyCacheItem.icon, "RIGHT", 5, -2)

			bountyCacheItem.button:SetScript("OnEnter", function(self) BWQ:ShowBountyTooltip(self, bounty.questID) end)
			bountyCacheItem.button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
			
			bountyWidth = bountyWidth + bountyCacheItem.text:GetStringWidth() + 33
		end
	end

	-- remove obsolete bounty entries (completed or disappeared)
	if #BWQ.bounties < #BWQ.bountyCache then
		for i = #BWQ.bounties + 1, #BWQ.bountyCache do
			BWQ.bountyCache[i].icon:Hide()
			BWQ.bountyCache[i].text:Hide()
			BWQ.bountyCache[i].button:Hide()
			BWQ.bountyCache[i] = nil
		end
	end

	-- show if bounties available, otherwise hide the bounty block
	if #BWQ.bounties > 0 then
		BWQ.bountyDisplay:Show()
		BWQ.bountyDisplay:SetSize(bountyWidth, 30)
		BWQ.bountyDisplay:SetPoint("TOP", BWQ, "TOP", 0, BWQ.offsetTop)
		BWQ.offsetTop = BWQ.offsetTop - 40
	else
		BWQ.bountyDisplay:Hide()
	end
end

function BWQ:ShowBountyTooltip(button, questId)
	local questIndex = C_QuestLog.GetLogIndexForQuestID(questId)
	local title = C_QuestLog.GetTitleForLogIndex(questIndex)
	if title then
		GameTooltip:SetOwner(button, "ANCHOR_BOTTOM")
		GameTooltip:SetText(title, HIGHLIGHT_FONT_COLOR:GetRGB())
		local _, questDescription = GetQuestLogQuestText(questIndex)
		GameTooltip:AddLine(questDescription, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
	
		local objectiveText, objectiveType, finished = GetQuestObjectiveInfo(questId, 1, false)
		if objectiveText and #objectiveText > 0 then
			local color = finished and GRAY_FONT_COLOR or HIGHLIGHT_FONT_COLOR;
			GameTooltip:AddLine(QUEST_DASH .. objectiveText, color.r, color.g, color.b, true);
		end

		GameTooltip_AddQuestRewardsToTooltip(GameTooltip, questId, TOOLTIP_QUEST_REWARDS_STYLE_EMISSARY_REWARD)
		GameTooltip:Show()
		GameTooltip.recalculatePadding = true
		button.UpdateTooltip = function(self) BWQ:ShowBountyTooltip(button, questId) end
	end
end


-- --- PARAGON REWARDS --- --
BWQ.factionFramePool = {
	rows = {},
	bars = {}
}
BWQ.factionDisplay = CreateFrame("Frame", nil, BWQ)

local paragonFactions
local factionIncreaseString1 = FACTION_STANDING_INCREASED:gsub("%%d", "([0-9]+)"):gsub("%%s", "(.*)")
local factionIncreaseString2 = FACTION_STANDING_INCREASED_ACH_BONUS:gsub("%%d", "([0-9]+)"):gsub("%%s", "(.*)"):gsub(" %(%+.*%)" ,"")
local factionIncreaseString3 = FACTION_STANDING_INCREASED_GENERIC:gsub("%%s", "(.*)"):gsub(" %(%+.*%)" ,"")

function BWQ:SetParagonFactionsByActiveExpansion()
	if BWQ.expansion == CONSTANTS.EXPANSIONS.THEWARWITHIN then 
		paragonFactions = CONSTANTS.PARAGON_FACTIONS.thewarwithin
	elseif BWQ.expansion == CONSTANTS.EXPANSIONS.DRAGONFLIGHT then 
		paragonFactions = CONSTANTS.PARAGON_FACTIONS.dragonflight
	elseif BWQ.expansion == CONSTANTS.EXPANSIONS.SHADOWLANDS then 
		paragonFactions = CONSTANTS.PARAGON_FACTIONS.shadowlands
	elseif
		BWQ.expansion == CONSTANTS.EXPANSIONS.BFA then paragonFactions = self.isHorde and CONSTANTS.PARAGON_FACTIONS.bfahorde or CONSTANTS.PARAGON_FACTIONS.bfaalliance
	else
		paragonFactions = CONSTANTS.PARAGON_FACTIONS.legion
	end
end
BWQ:SetParagonFactionsByActiveExpansion()

function BWQ:OnFactionUpdate(msg)
	if C("hideFactionParagonBars") then return end

	msg = msg:gsub(" %(%+.*%)" ,"")
	local faction = msg:match(factionIncreaseString1)
	if not faction then
		faction = msg:match(factionIncreaseString2)
		if not faction then
			faction = msg:match(factionIncreaseString3)
			if not faction then
				return
			end
		end
	end

	local factionData
	for i = 1, C_Reputation.GetNumFactions() do
		factionData = C_Reputation.GetFactionDataByIndex(i)
		if factionData then
			if faction == factionData.name and paragonFactions[factionData.factionId] then
				BWQ:UpdateParagonData()
			end
		end
	end
end

function BWQ:UpdateParagonData()
	if C("hideFactionParagonBars") then return end

	local i = 0
	local maxWidth = 0
	local rowIndex = 0
	
	local row
	local factionId
	for _, factionId in next, paragonFactions.order do
		if C_Reputation.IsFactionParagon(factionId) then
			
			local factionFrame

			rowIndex = math.floor(i / 6)
			if not BWQ.factionFramePool.rows[rowIndex] then
				row = CreateFrame("Frame", nil, BWQ.factionDisplay, "BackdropTemplate")
				BWQ.factionFramePool.rows[rowIndex] = row
			else row = BWQ.factionFramePool.rows[rowIndex] end
			
			if not BWQ.factionFramePool.bars[i] then
				factionFrame = {}
				factionFrame.name = row:CreateFontString("BWQ_FactionDisplayName"..i, "OVERLAY", "SystemFont_Shadow_Med1")

				factionFrame.bg = CreateFrame("Frame", "BWQ_FactionFrameBG"..i, row, "BackdropTemplate")
				factionFrame.bg:SetSize(50, 12)
				factionFrame.bg:SetPoint("LEFT", factionFrame.name, "RIGHT", 5, 0)
				
				factionFrame.bg:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", tile = false, tileSize = 0, edgeSize = 2, insets = { left = 0, right = 0, top = 0, bottom = 0 }, })
				factionFrame.bg:SetBackdropColor(0.2,0.2,0.2,0.5)

				factionFrame.bar = CreateFrame("Frame", "BWQ_FactionFrameBar"..i, factionFrame.bg, "BackdropTemplate")
				factionFrame.bar:SetPoint("TOPLEFT", factionFrame.bg, "TOPLEFT")
				factionFrame.bar:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8", tile = false, tileSize = 0, edgeSize = 2, insets = { left = 0, right = 0, top = 0, bottom = 0 }, })

				BWQ.factionFramePool.bars[i] = factionFrame
			else
				factionFrame = BWQ.factionFramePool.bars[i]
			end

			local index = i % 6
			if (index == 0) then
				factionFrame.name:SetPoint("TOPLEFT", row, "TOPLEFT", 8, 0)
			else
				factionFrame.name:SetPoint("LEFT", BWQ.factionFramePool.bars[i - 1].bg, "RIGHT", 18, 0)
			end

			row:SetSize(85 * (index + 1), 15)
			if (rowIndex == 0) then row:SetPoint("TOP", BWQ.factionDisplay, "TOP", 0, 0)
			else row:SetPoint("TOP", BWQ.factionFramePool.rows[rowIndex - 1], "BOTTOM", 0, -5) end
			row:Show()

			local name = C_Reputation.GetFactionDataByID(factionId).name
			local current, threshold, rewardQuestId, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionId)
			
			local progress = 0
			if current and threshold then progress = (current % threshold) / threshold * 50 end
			if hasRewardPending then factionFrame.bar:SetBackdropColor(0, 0.8, 0.1)
			else factionFrame.bar:SetBackdropColor(0.1, 0.55, 0.1, 0.4) end
			if progress == 0 then factionFrame.bar:Hide() else factionFrame.bar:Show() end
			factionFrame.bar:SetSize(hasRewardPending and 50 or progress, 12)
			factionFrame.name:Show()
			factionFrame.bg:Show()
			factionFrame.bar:Show()
			
			factionFrame.name:SetText(string.format("|TInterface\\Icons\\%1$s:12:12|t", paragonFactions[factionId]))
			
			maxWidth = maxWidth > row:GetWidth() and maxWidth or row:GetWidth()
			i = i + 1
		end
	end

	-- hide not needed rows
	local j = rowIndex + 1
	while(BWQ.factionFramePool.rows[j]) do
		BWQ.factionFramePool.rows[j]:Hide()
		j = j + 1
	end
	-- hide not needed bars
	local barsInPool = #BWQ.factionFramePool.bars
	if barsInPool > 0 then
		local j = i
		while (j <= barsInPool) do
			BWQ.factionFramePool.bars[j].name:Hide()
			BWQ.factionFramePool.bars[j].bg:Hide()
			BWQ.factionFramePool.bars[j].bar:Hide()
			j = j + 1
		end
	end

	if (i > 0) then
		BWQ.factionDisplay:Show()
		BWQ.factionDisplay:SetSize(maxWidth, 20 * (rowIndex + 1))
		BWQ.factionDisplay:SetPoint("TOP", BWQ, "TOP", 0, BWQ.offsetTop)
		BWQ.offsetTop = BWQ.offsetTop - 20 * (rowIndex + 1)
	else
		BWQ.factionDisplay:Hide()
	end
end
function BWQ:UpdateFactionDisplayVisible()
	if not C("hideFactionParagonBars") then
		BWQ:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
		BWQ.factionDisplay:Show()
	else
		BWQ:UnregisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
		BWQ.factionDisplay:Hide()
	end
end

function BWQ:UpdateInfoPanel()
	BWQ:UpdateBountyData()
	BWQ:UpdateParagonData()
end


local originalMap, originalContinent, originalDungeonLevel
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
	BWQ.totalXP = 0

	for mapId in next, BWQ.MAP_ZONES[BWQ.expansion] do
		RetrieveWorldQuests(mapId)
	end

	BWQ.numQuestsTotal = 0
	BWQ.hasCollapsedQuests = false
	for mapId in next, BWQ.MAP_ZONES[BWQ.expansion] do
		local num = BWQ.MAP_ZONES[BWQ.expansion][mapId].numQuests
		if num > 0 then
			if not C("collapsedZones")[mapId] then
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
			for _, questId in next, BWQ.MAP_ZONES[BWQ.expansion][mapId].questsSort do
				BWQ.questIds[questId] = true
			end
		end
		BWQcache.questIds = BWQ.questIds
	end

	if needsRefresh and updateTries < 3 then
		updateTries = updateTries + 1
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
		
		local collapsed = C("collapsedZones")[mapId]

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

function BWQ:SwitchExpansion(expac)
	BWQ.expansion = expac
	if not C("usePerCharacterSettings") then
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
	updateTries = 0
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
	if currentTime - lastUpdate > 5 then
		updateTries = 0
		BWQ:UpdateBlock()
		lastUpdate = currentTime
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
	if needsRefresh and updateTries < 3 then
		-- skip updating the block, received data was incomplete
		needsRefresh = false
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
				C("collapsedZones")[mapId] = not C("collapsedZones")[mapId]
				BWQ:UpdateBlock()
			end)

			zoneSep.texture:SetTexture("Interface\\FriendsFrame\\UI-FriendsFrame-OnlineDivider")
			zoneSep.texture:SetHeight(8)

			BWQ.MAP_ZONES[BWQ.expansion][mapId].zoneSep = zoneSep
		end

		if not C("collapsedZones")[mapId] then 
			for _, questId in next, BWQ.MAP_ZONES[BWQ.expansion][mapId].questsSort do
				local button
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
					button.icon:SetTexture("Interface\\QUESTFRAME\\WorldQuest")
					button.icon:SetSize(12, 12)

					-- create font strings
					button.title = CreateFrame("Button", nil, button)
					button.title:SetScript("OnClick", function(self)	Row_OnClick(button)														end)
					button.title:SetScript("OnEnter", function(self)	button.highlight:SetAlpha(1)	ShowQuestObjectiveTooltip(button)		end)
					button.title:SetScript("OnLeave", function()		button.highlight:SetAlpha(0)	tip:Hide()		BWQ:Block_OnLeave()		end)

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
				button.quest = BWQ.MAP_ZONES[BWQ.expansion][mapId].quests[questId]
				button.questID = button.quest.questId
				button.worldQuest = true
				button.numObjectives = button.quest.numObjectives

				-- fill and format row
				local rewardText = ""
				if button.quest.LockedWQ then
					-- To find Atlas textures such as the "padlock" below.  Use the /tav command (Texture Atlas Viewer addon).
					rewardText = string.format(
						"|cnWARNING_FONT_COLOR:|A:%s:14:14|a Complete %d more %s in %s|r",
						"Garr_LockedBuilding",
						button.quest.LockedWQ_questsRemaining and button.quest.LockedWQ_questsRemaining or "",
						button.quest.LockedWQ_questsRemaining > 1 and "WQs" or "WQ",
						button.quest.LockedWQ_zone and button.quest.LockedWQ_zone or "")
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
						tip:Hide()
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
							tip:Hide()
							BWQ:Block_OnLeave()
						end)
					else
						button.reward:SetScript("OnEnter", function(self)
							button.highlight:SetAlpha(1)
						end)
						button.reward:SetScript("OnLeave", function()
							button.highlight:SetAlpha(0)

							tip:Hide()
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

				-- if button.quest.tagId == 136 or button.quest.tagId == 111 or button.quest.tagId == 112 then
				--button.icon:SetTexCoord(.81, .84, .68, .79) -- skull tex coords
				if CONSTANTS.WORLD_QUEST_ICONS_BY_TAG_ID[button.quest.tagId] then
					button.icon:SetAtlas(CONSTANTS.WORLD_QUEST_ICONS_BY_TAG_ID[button.quest.tagId], true)
					button.icon:SetAlpha(1)
				else
					if BWQcfg.spewDebugInfo and button.quest.tagId and button.quest.tagId > 0 and button.quest.tagId ~= 109 then	-- 109 is just your standard world quest
						print(string.format("[BWQ] Unhandled Quest TagId: %d (%s)", button.quest.tagId, button.quest.title))
					end
					button.icon:SetAlpha(0)
				end
				button.icon:SetSize(12, 12)

				-- Set the first cell of the row (the quest title/name)
				button.titleFS:SetText(string.format("%s%s%s|r",
					button.quest.isNew and "|cffe5cc80NEW|r  " or "",
					button.quest.isMissingAchievementCriteria and "|cff1EFF00" or WORLD_QUEST_QUALITY_COLORS[button.quest.quality].hex,
					button.quest.title
				))
				--local titleWidth = button.titleFS:GetStringWidth()
				--if titleWidth > titleMaxWidth then titleMaxWidth = titleWidth end

				if C_QuestLog.GetQuestWatchType(button.quest.questId) == Enum.QuestWatchType.Manual or C_SuperTrack.GetSuperTrackedQuestID() == button.quest.questId then
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

				if not C("hideFactionColumn") then
					button.factionFS:SetText(button.quest.factionID)
					local factionWidth = button.factionFS:GetStringWidth()
					if factionWidth > factionMaxWidth then factionMaxWidth = factionWidth end
				else
					button.factionFS:SetText("")
				end

				button.timeLeftFS:SetText(FormatTimeLeftString(button.quest.timeLeft))
				--local timeLeftWidth = button.factionFS:GetStringWidth()
				--if timeLeftWidth > timeLeftMaxWidth then timeLeftMaxWidth = timeLeftWidth end

				button.rewardFS:SetText(rewardText)

				local rewardWidth = button.rewardFS:GetStringWidth()
				if rewardWidth > rewardMaxWidth then rewardMaxWidth = rewardWidth end
				button.reward:SetHeight(button.rewardFS:GetStringHeight())
				button.title:SetHeight(button.titleFS:GetStringHeight())

				button.icon:SetPoint("LEFT", button, "LEFT", 5, 0)
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
	factionMaxWidth = C("hideFactionColumn") and 0 or factionMaxWidth < 100 and 100 or factionMaxWidth
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

	if C("showTotalsInBrokerText") then
		local brokerString = ""
		if C("brokerShowPolishedPetCharms")    	and BWQ.totalPolishedPetCharms > 0  	then brokerString = string.format("%s|TInterface\\Icons\\inv_currency_petbattle:16:16|t %d  ", brokerString, BWQ.totalPolishedPetCharms) end
		if C("brokerShowAP")                  	and BWQ.totalArtifactPower > 0      	then brokerString = string.format("%s|TInterface\\Icons\\inv_smallazeriteshard:16:16|t %s  ", brokerString, AbbreviateNumber(BWQ.totalArtifactPower)) end
		if C("brokerShowServiceMedals")       	and BWQ.totalServiceMedals > 0      	then brokerString = string.format("%s|T%s:16:16|t %s  ", brokerString, self.isHorde and "Interface\\Icons\\ui_horde_honorboundmedal" or "Interface\\Icons\\ui_alliance_7legionmedal", BWQ.totalServiceMedals) end
		if C("brokerShowWakeningEssences")    	and BWQ.totalWakeningEssences > 0   	then brokerString = string.format("%s|TInterface\\Icons\\achievement_dungeon_ulduar80_25man:16:16|t %s  ", brokerString, BWQ.totalWakeningEssences) end
		if C("brokerShowWarResources")        	and BWQ.totalWarResources > 0       	then brokerString = string.format("%s|TInterface\\Icons\\inv__faction_warresources:16:16|t %d  ", brokerString, BWQ.totalWarResources) end
		if C("brokerShowPrismaticManapearl")  	and BWQ.totalPrismaticManapearl > 0 	then brokerString = string.format("%s|TInterface\\Icons\\Inv_misc_enchantedpearlf:16:16|t %d  ", brokerString, BWQ.totalPrismaticManapearl) end
		if C("brokerShowCyphersOfTheFirstOnes")	and BWQ.totalCyphersOfTheFirstOnes > 0	then brokerString = string.format("%s|TInterface\\Icons\\inv_trinket_progenitorraid_02_blue:16:16|t %d  ", brokerString, BWQ.totalCyphersOfTheFirstOnes) end	
		if C("brokerShowGratefulOffering")    	and BWQ.totalGratefulOffering > 0   	then brokerString = string.format("%s|TInterface\\Icons\\inv_misc_ornatebox:16:16|t %d  ", brokerString, BWQ.totalGratefulOffering) end
		if C("brokerShowResources")           	and BWQ.totalResources > 0          	then brokerString = string.format("%s|TInterface\\Icons\\inv_orderhall_orderresources:16:16|t %d  ", brokerString, BWQ.totalResources) end
		if C("brokerShowLegionfallSupplies")  	and BWQ.totalLegionfallSupplies > 0 	then brokerString = string.format("%s|TInterface\\Icons\\inv_misc_summonable_boss_token:16:16|t %d  ", brokerString, BWQ.totalLegionfallSupplies) end
		if C("brokerShowXP")               		and BWQ.totalXP > 0              		then brokerString = string.format("%s|TInterface\\Icons\\xp_icon:16:16|t %d  ", brokerString, BWQ.totalXP) end
		if C("brokerShowHonor")               	and BWQ.totalHonor > 0              	then brokerString = string.format("%s|TInterface\\Icons\\Achievement_LegionPVPTier4:16:16|t %d  ", brokerString, BWQ.totalHonor) end
		if C("brokerShowGold")                	and BWQ.totalGold > 0               	then brokerString = string.format("%s|TInterface\\GossipFrame\\auctioneerGossipIcon:16:16|t %d  ", brokerString, math.floor(BWQ.totalGold / 10000)) end
		if C("brokerShowGear")                	and BWQ.totalGear > 0               	then brokerString = string.format("%s|TInterface\\Icons\\Inv_chest_plate_legionendgame_c_01:16:16|t %d  ", brokerString, BWQ.totalGear) end
		if C("brokerShowMarkOfHonor")         	and BWQ.totalMarkOfHonor > 0        	then brokerString = string.format("%s|TInterface\\Icons\\ability_pvp_gladiatormedallion:16:16|t %d  ", brokerString, BWQ.totalMarkOfHonor) end
		if C("brokerShowHerbalism")           	and BWQ.totalHerbalism > 0          	then brokerString = string.format("%s|TInterface\\Icons\\Trade_Herbalism:16:16|t %d  ", brokerString, BWQ.totalHerbalism) end
		if C("brokerShowMining")              	and BWQ.totalMining > 0             	then brokerString = string.format("%s|TInterface\\Icons\\Trade_Mining:16:16|t %d  ", brokerString, BWQ.totalMining) end
		if C("brokerShowFishing")             	and BWQ.totalFishing > 0            	then brokerString = string.format("%s|TInterface\\Icons\\Trade_Fishing:16:16|t %d  ", brokerString, BWQ.totalFishing) end
		if C("brokerShowSkinning")            	and BWQ.totalSkinning > 0           	then brokerString = string.format("%s|TInterface\\Icons\\inv_misc_pelt_wolf_01:16:16|t %d  ", brokerString, BWQ.totalSkinning) end
		if C("brokerShowBloodOfSargeras")     	and BWQ.totalBloodOfSargeras > 0    	then brokerString = string.format("%s|T1417744:16:16|t %d", brokerString, BWQ.totalBloodOfSargeras) end
		if C("brokerShowBloodyTokens")        	and BWQ.totalBloodyTokens > 0       	then brokerString = string.format("%s|TInterface\\Icons\\inv_10_dungeonjewelry_titan_trinket_2_color2:16:16|t %d  ", brokerString, BWQ.totalBloodyTokens) end
		if C("brokerShowDragonIslesSupplies") 	and BWQ.totalDragonIslesSupplies > 0	then brokerString = string.format("%s|TInterface\\Icons\\inv_faction_warresources:16:16|t %d  ", brokerString, BWQ.totalDragonIslesSupplies) end
		if C("brokerShowElementalOverflow") 	and BWQ.totalElementalOverflow > 0		then brokerString = string.format("%s|TInterface\\Icons\\inv_misc_powder_thorium:16:16|t %d  ", brokerString, BWQ.totalElementalOverflow) end
		if C("brokerShowFlightstones") 			and BWQ.totalFlightstones > 0			then brokerString = string.format("%s|TInterface\\Icons\\flightstone-dragonflight:16:16|t %d  ", brokerString, BWQ.totalFlightstones) end
		if C("brokerShowWhelplingsDreamingCrest") and BWQ.totalWhelplingsDreamingCrest > 0	then brokerString = string.format("%s|TInterface\\Icons\\Inv_10_gearupgrade_whelplingsdreamingcrest:16:16|t %d  ", brokerString, BWQ.totalWhelplingsDreamingCrest) end
		if C("brokerShowDrakesDreamingCrest") 	and BWQ.totalDrakesDreamingCrest > 0	then brokerString = string.format("%s|TInterface\\Icons\\Inv_10_gearupgrade_drakesdreamingcrest:16:16|t %d  ", brokerString, BWQ.totalDrakesDreamingCrest) end
		if C("brokerShowWyrmsDreamingCrest") 	and BWQ.totalWyrmsDreamingCrest > 0		then brokerString = string.format("%s|TInterface\\Icons\\Inv_10_gearupgrade_wyrmsdreamingcrest:16:16|t %d  ", brokerString, BWQ.totalWyrmsDreamingCrest) end
		if C("brokerShowAspectsDreamingCrest") 	and BWQ.totalAspectsDreamingCrest > 0	then brokerString = string.format("%s|TInterface\\Icons\\Inv_10_gearupgrade_aspectsdreamingcrest:16:16|t %d  ", brokerString, BWQ.totalAspectsDreamingCrest) end
		if C("brokerShowWhelplingsAwakenedCrest") and BWQ.totalWhelplingsAwakenedCrest > 0	then brokerString = string.format("%s|TInterface\\Icons\\inv_10_gearupgrade_whelplingsawakenedcrest:16:16|t %d  ", brokerString, BWQ.totalWhelplingsAwakenedCrest) end
		if C("brokerShowDrakesAwakenedCrest") 	and BWQ.totalDrakesAwakenedCrest > 0	then brokerString = string.format("%s|TInterface\\Icons\\inv_10_gearupgrade_drakesawakenedcrest:16:16|t %d  ", brokerString, BWQ.totalDrakesAwakenedCrest) end
		if C("brokerShowWyrmsAwakenedCrest") 	and BWQ.totalWyrmsAwakenedCrest > 0		then brokerString = string.format("%s|TInterface\\Icons\\Inv_10_gearupgrade_wyrmsawakenedcrest:16:16|t %d  ", brokerString, BWQ.totalWyrmsAwakenedCrest) end
		if C("brokerShowAspectsAwakenedCrest") 	and BWQ.totalAspectsAwakenedCrest > 0	then brokerString = string.format("%s|TInterface\\Icons\\Inv_10_gearupgrade_aspectsawakenedcrest:16:16|t %d  ", brokerString, BWQ.totalAspectsAwakenedCrest) end
		if C("brokerShowMysteriousFragment") 	and BWQ.totalMysteriousFragment > 0		then brokerString = string.format("%s|TInterface\\Icons\\Inv_7_0raid_trinket_05a:16:16|t %d  ", brokerString, BWQ.totalMysteriousFragment) end
		if C("brokerShowResonanceCrystals") 	and BWQ.totalResonanceCrystals > 0		then brokerString = string.format("%s|TInterface\\Icons\\spell_azerite_essence14:16:16|t %d  ", brokerString, BWQ.totalResonanceCrystals) end
		if C("brokerShowTheAssemblyoftheDeeps") and BWQ.totalTheAssemblyOfTheDeeps > 0	then brokerString = string.format("%s|TInterface\\Icons\\ui_majorfactions_candle:16:16|t %d  ", brokerString, BWQ.totalTheAssemblyOfTheDeeps) end
		if C("brokerShowHallowfallArathi") 		and BWQ.totalHallowfallArathi > 0		then brokerString = string.format("%s|TInterface\\Icons\\ui_majorfactions_flame:16:16|t %d  ", brokerString, BWQ.totalHallowfallArathi) end
		if C("brokerShowValorstones") 			and BWQ.totalValorstones > 0			then brokerString = string.format("%s|TInterface\\Icons\\inv_valorstone_base:16:16|t %d  ", brokerString, BWQ.totalValorstones) end
		if C("brokerShowKej") 					and BWQ.totalKej > 0					then brokerString = string.format("%s|TInterface\\Icons\\inv_10_tailoring_silkrare_color3:16:16|t %d  ", brokerString, BWQ.totalKej) end
		if C("brokerShowCouncilofDornogal") 	and BWQ.totalCouncilofDornogal > 0		then brokerString = string.format("%s|TInterface\\Icons\\ui_majorfactions_storm:16:16|t %d  ", brokerString, BWQ.totalCouncilofDornogal) end
		if C("brokerShowTheWeaver") 			and BWQ.totalTheWeaver > 0				then brokerString = string.format("%s|TInterface\\Icons\\ui_notoriety_theweaver:16:16|t %d  ", brokerString, BWQ.totalTheWeaver) end
		if C("brokerShowTheGeneral") 			and BWQ.totalTheGeneral > 0				then brokerString = string.format("%s|TInterface\\Icons\\ui_notoriety_thegeneral:16:16|t %d  ", brokerString, BWQ.totalTheGeneral) end
		if C("brokerShowTheVizier") 			and BWQ.totalTheVizier > 0				then brokerString = string.format("%s|TInterface\\Icons\\ui_notoriety_thevizier:16:16|t %d  ", brokerString, BWQ.totalTheVizier) end

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


local configMenu
local info = {}
function BWQ:SetupConfigMenu()
	local options = {
		{ text = "Attach list frame to world map", check = "attachToWorldMap" },
		{ text = "Show list frame on click instead of mouse-over", check = "showOnClick" },
		{ text = "Use per-character settings", check = "usePerCharacterSettings" },
		{ text = "" },
		{ text = "Always show |cffa335eeepic|r world quests (e.g. world bosses)", check = "alwaysShowEpicQuests" },
		{ text = "Only show world quests with |cff0070ddrare|r or above quality", check = "onlyShowRareOrAbove" },
		{ text = "Don't filter quests for active bounties", check = "alwaysShowBountyQuests" },
		{ text = "Show total counts in broker text", check = "showTotalsInBrokerText", submenu = {
				{ text = ("|T%1$s:16:16|t  Polished Pet Charms"):format("Interface\\Icons\\inv_currency_petbattle"), check = "brokerShowPolishedPetCharms" },
				{ text = ("|T%1$s:16:16|t  Artifact Power"):format("Interface\\Icons\\inv_smallazeriteshard"), check = "brokerShowAP" },
				{ text = ("|T%1$s:16:16|t  Service Medals"):format(self.isHorde and "Interface\\Icons\\ui_horde_honorboundmedal" or "Interface\\Icons\\ui_alliance_7legionmedal"), check = "brokerShowServiceMedals" },
				{ text = ("|T%1$s:16:16|t  Wakening Essences"):format("Interface\\Icons\\achievement_dungeon_ulduar80_25man"), check = "brokerShowWakeningEssences" },
				{ text = ("|T%1$s:16:16|t  Prismatic Manapearls"):format("Interface\\Icons\\Inv_misc_enchantedpearlf"), check = "brokerShowPrismaticManapearl" },
				{ text = ("|T%1$s:16:16|t  Cyphers of the First Ones"):format("Interface\\Icons\\inv_trinket_progenitorraid_02_blue"), check = "brokerShowCyphersOfTheFirstOnes" },
				{ text = ("|T%1$s:16:16|t  Grateful Offerings"):format("Interface\\Icons\\inv_misc_ornatebox"), check = "brokerShowGratefulOffering" },
				{ text = ("|T%1$s:16:16|t  War Resources"):format("Interface\\Icons\\inv__faction_warresources"), check = "brokerShowWarResources" },
				{ text = ("|T%1$s:16:16|t  Order Hall Resources"):format("Interface\\Icons\\inv_orderhall_orderresources"), check = "brokerShowResources" },
				{ text = ("|T%1$s:16:16|t  Legionfall War Supplies"):format("Interface\\Icons\\inv_misc_summonable_boss_token"), check = "brokerShowLegionfallSupplies" },
				{ text = ("|T%1$s:16:16|t  XP Only Quests"):format("Interface\\Icons\\xp_icon"), check = "brokerShowXP" },
				{ text = ("|T%1$s:16:16|t  Honor"):format("Interface\\Icons\\Achievement_LegionPVPTier4"), check = "brokerShowHonor" },
				{ text = ("|T%1$s:16:16|t  Bloody Tokens"):format("Interface\\Icons\\inv_10_dungeonjewelry_titan_trinket_2_color2"), check = "brokerShowBloodyTokens" },
				{ text = ("|T%1$s:16:16|t  Gold"):format("Interface\\GossipFrame\\auctioneerGossipIcon"), check = "brokerShowGold" },
				{ text = ("|T%1$s:16:16|t  Gear"):format("Interface\\Icons\\Inv_chest_plate_legionendgame_c_01"), check = "brokerShowGear" },
				{ text = ("|T%1$s:16:16|t  Mark Of Honor"):format("Interface\\Icons\\ability_pvp_gladiatormedallion"), check = "brokerShowMarkOfHonor" },
				{ text = ("|T%1$s:16:16|t  Herbalism Quests"):format("Interface\\Icons\\Trade_Herbalism"), check = "brokerShowHerbalism" },
				{ text = ("|T%1$s:16:16|t  Mining Quests"):format("Interface\\Icons\\Trade_Mining"), check = "brokerShowMining" },
				{ text = ("|T%1$s:16:16|t  Fishing Quests"):format("Interface\\Icons\\Trade_Fishing"), check = "brokerShowFishing" },
				{ text = ("|T%1$s:16:16|t  Skinning Quests"):format("Interface\\Icons\\inv_misc_pelt_wolf_01"), check = "brokerShowSkinning" },
				{ text = ("|T%s$s:16:16|t  Blood of Sargeras"):format("1417744"), check = "brokerShowBloodOfSargeras" },
				{ text = ("|T%1$s:16:16|t  Dragon Isles Supplies"):format("Interface\\Icons\\inv_faction_warresources"), check = "brokerShowDragonIslesSupplies" },
				{ text = ("|T%1$s:16:16|t  Elemental Overflow"):format("Interface\\Icons\\inv_misc_powder_thorium"), check = "brokerShowElementalOverflow" },
				{ text = ("|T%1$s:16:16|t  Flightstones"):format("Interface\\Icons\\flightstone-dragonflight"), check = "brokerShowFlightstones" },
				{ text = ("|T%1$s:16:16|t  Whelplings Dreaming Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_whelplingsdreamingcrest"), check = "brokerShowWhelplingsDreamingCrest" },
				{ text = ("|T%1$s:16:16|t  Drakes Dreaming Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_drakesdreamingcrest"), check = "brokerShowDrakesDreamingCrest" },
				{ text = ("|T%1$s:16:16|t  Wyrms Dreaming Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_wyrmsdreamingcrest"), check = "brokerShowWyrmsDreamingCrest" },
				{ text = ("|T%1$s:16:16|t  Aspects Dreaming Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_aspectsdreamingcrest"), check = "brokerShowAspectsDreamingCrest" },
				{ text = ("|T%1$s:16:16|t  Whelplings Awakened Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_whelplingsAwakenedcrest"), check = "brokerShowWhelplingsAwakenedCrest" },
				{ text = ("|T%1$s:16:16|t  Drakes Awakened Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_drakesAwakenedcrest"), check = "brokerShowDrakesAwakenedCrest" },
				{ text = ("|T%1$s:16:16|t  Wyrms Awakened Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_wyrmsAwakenedcrest"), check = "brokerShowWyrmsAwakenedCrest" },
				{ text = ("|T%1$s:16:16|t  Aspects Awakened Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_aspectsAwakenedcrest"), check = "brokerShowAspectsAwakenedCrest" },
				{ text = ("|T%1$s:16:16|t  Mysterious Fragment"):format("Interface\\Icons\\Inv_7_0raid_trinket_05a"), check = "brokerShowMysteriousFragment" },
				{ text = ("|T%1$s:16:16|t  Resonance Crystals"):format("Interface\\Icons\\spell_azerite_essence14"), check = "brokerShowResonanceCrystals" },
				{ text = ("|T%1$s:16:16|t  The Assembly of the Deeps"):format("Interface\\Icons\\ui_majorfactions_candle"), check = "brokerShowTheAssemblyoftheDeeps" },
				{ text = ("|T%1$s:16:16|t  Hallowfall Arathi"):format("Interface\\Icons\\ui_majorfactions_flame"), check = "brokerShowHallowfallArathi" },
				{ text = ("|T%1$s:16:16|t  Valorstones"):format("Interface\\Icons\\inv_valorstone_base"), check = "brokerShowValorstones" },
				{ text = ("|T%1$s:16:16|t  Kej"):format("Interface\\Icons\\inv_10_tailoring_silkrare_color3"), check = "brokerShowKej" },
				{ text = ("|T%1$s:16:16|t  Council of Dornogal"):format("Interface\\Icons\\ui_majorfactions_storm"), check = "brokerShowCouncilofDornogal" },
				{ text = ("|T%1$s:16:16|t  The Weaver"):format("Interface\\Icons\\ui_notoriety_theweaver"), check = "brokerShowTheWeaver" },
				{ text = ("|T%1$s:16:16|t  The General"):format("Interface\\Icons\\ui_notoriety_thegeneral"), check = "brokerShowTheGeneral" },
				{ text = ("|T%1$s:16:16|t  The Vizier"):format("Interface\\Icons\\ui_notoriety_thevizier"), check = "brokerShowTheVizier" },
			}
		},
		{ text = "Sort list by time remaining instead of reward type", check = "sortByTimeRemaining" },
		{ text = "" },
		{ text = "Filter by reward...", isTitle = true },
		{ text = ("|T%1$s:16:16|t  Items"):format("Interface\\Minimap\\Tracking\\Banker"), check = "showItems", submenu = {
				{ text = ("|T%1$s:16:16|t  Gear"):format("Interface\\Icons\\Inv_chest_plate_legionendgame_c_01"), check = "showGear" },
				{ text = ("|T%s$s:16:16|t  Crafting Materials"):format("1417744"), check = "showCraftingMaterials" },
				{ text = ("|T%1$s:16:16|t  Mark Of Honor"):format("Interface\\Icons\\ability_pvp_gladiatormedallion"), check = "showMarkOfHonor" },
				{ text = "Other", check = "showOtherItems" },
			}
		},
		{ text = ("|T%1$s:16:16|t  XP Only Quests"):format("Interface\\Icons\\xp_icon"), check = "showXP" },
		{ text = ("|T%1$s:16:16|t  Honor"):format("Interface\\Icons\\Achievement_LegionPVPTier4"), check = "showHonor" },
		{ text = ("|T%1$s:16:16|t  Bloody Tokens"):format("Interface\\Icons\\inv_10_dungeonjewelry_titan_trinket_2_color2"), check = "showBloodyTokens" },
		{ text = ("|T%1$s:16:16|t  Low gold reward"):format("Interface\\GossipFrame\\auctioneerGossipIcon"), check = "showLowGold" },
		{ text = ("|T%1$s:16:16|t  High gold reward"):format("Interface\\GossipFrame\\auctioneerGossipIcon"), check = "showHighGold" },
		{ text = "      The War Within", submenu = {
				{ text = ("|T%1$s:16:16|t  Reputation Tokens"):format("Interface\\Icons\\inv_scroll_11"), check = "showTWWReputation" },
				{ text = ("|T%s$s:16:16|t  Resonance Crystals"):format("Interface\\Icons\\spell_azerite_essence14"), check = "showResonanceCrystals" },
				{ text = ("|T%s$s:16:16|t  The Assembly of the Deeps"):format("Interface\\Icons\\ui_majorfactions_candle"), check = "showTheAssemblyoftheDeeps" },
				{ text = ("|T%s$s:16:16|t  Hallowfall Arathi"):format("Interface\\Icons\\ui_majorfactions_flame"), check = "showHallowfallArathi" },
				{ text = ("|T%1$s:16:16|t  Valorstones"):format("Interface\\Icons\\inv_valorstone_base"), check = "showValorstones" },
				{ text = ("|T%1$s:16:16|t  Kej"):format("Interface\\Icons\\inv_10_tailoring_silkrare_color3"), check = "showKej" },
				{ text = ("|T%1$s:16:16|t  Council of Dornogal"):format("Interface\\Icons\\ui_majorfactions_storm"), check = "showCouncilofDornogal" },
				{ text = ("|T%1$s:16:16|t  The Weaver"):format("Interface\\Icons\\ui_notoriety_theweaver"), check = "ShowTheWeaver" },
				{ text = ("|T%1$s:16:16|t  The General"):format("Interface\\Icons\\ui_notoriety_thegeneral"), check = "ShowTheGeneral" },
				{ text = ("|T%1$s:16:16|t  The Vizier"):format("Interface\\Icons\\ui_notoriety_thevizier"), check = "ShowTheVizier" },
			}
		},
		{ text = "      Dragonflight", submenu = {
				{ text = ("|T%1$s:16:16|t  Reputation Tokens"):format("Interface\\Icons\\inv_scroll_11"), check = "showDFReputation" },
				{ text = ("|T%1$s:16:16|t  Dragon Isles Supplies"):format("Interface\\Icons\\inv_faction_warresources"), check = "showDragonIslesSupplies" },
				{ text = ("|T%1$s:16:16|t  Elemental Overflow"):format("Interface\\Icons\\inv_misc_powder_thorium"), check = "ShowElementalOverflow" },
				{ text = ("|T%1$s:16:16|t  Flightstones"):format("Interface\\Icons\\flightstone-dragonflight"), check = "showFlightstones" },
				{ text = ("|T%1$s:16:16|t  Whelplings Dreaming Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_whelplingsdreamingcrest"), check = "showWhelplingsDreamingCrest" },
				{ text = ("|T%1$s:16:16|t  Drakes Dreaming Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_drakesdreamingcrest"), check = "showDrakesDreamingCrest" },
				{ text = ("|T%1$s:16:16|t  Wyrms Dreaming Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_wyrmsdreamingcrest"), check = "showWyrmsDreamingCrest" },
				{ text = ("|T%1$s:16:16|t  Aspects Dreaming Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_aspectsdreamingcrest"), check = "showAspectsDreamingCrest" },
				{ text = ("|T%1$s:16:16|t  Whelplings Awakened Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_whelplingsAwakenedcrest"), check = "showWhelplingsAwakenedCrest" },
				{ text = ("|T%1$s:16:16|t  Drakes Awakened Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_drakesAwakenedcrest"), check = "showDrakesAwakenedCrest" },
				{ text = ("|T%1$s:16:16|t  Wyrms Awakened Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_wyrmsAwakenedcrest"), check = "showWyrmsAwakenedCrest" },
				{ text = ("|T%1$s:16:16|t  Aspects Awakened Crest"):format("Interface\\Icons\\Inv_10_gearupgrade_aspectsAwakenedcrest"), check = "showAspectsAwakenedCrest" },
				{ text = ("|T%1$s:16:16|t  Mysterious Fragment"):format("Interface\\Icons\\Inv_7_0raid_trinket_05a"), check = "showMysteriousFragment" },
			}
		},
		{ text = "      Shadowlands", submenu = {
				{ text = ("|T%1$s:16:16|t  Reputation Tokens"):format("Interface\\Icons\\inv_scroll_11"), check = "showSLReputation" },
				{ text = ("|T%s$s:16:16|t  Anima Item"):format("3528288"), check = "showAnima" },
				{ text = ("|T%s$s:16:16|t  Conduits"):format("3586269"), check = "showConduits" },
				{ text = ("|T%1$s:16:16|t  Cyphers of the First Ones"):format("Interface\\Icons\\inv_trinket_progenitorraid_02_blue"), check = "showCyphersOfTheFirstOnes" },
				{ text = ("|T%1$s:16:16|t  Grateful Offerings"):format("Interface\\Icons\\inv_misc_ornatebox"), check = "showGratefulOffering" },
			}
		},
		{ text = "      Battle for Azeroth", submenu = {
				{ text = ("|T%1$s:16:16|t  Reputation Tokens"):format("Interface\\Icons\\inv_scroll_11"), check = "showBFAReputation" },
				{ text = ("|T%1$s:16:16|t  War Resources"):format("Interface\\Icons\\inv__faction_warresources"), check = "showWarResources" },
				{ text = ("|T%1$s:16:16|t  Azerite"):format("Interface\\Icons\\inv_smallazeriteshard"), check = "showArtifactPower" },
				{ text = ("|T%1$s:16:16|t  Service Medals"):format(self.isHorde and "Interface\\Icons\\ui_horde_honorboundmedal" or "Interface\\Icons\\ui_alliance_7legionmedal"), check = "showBFAServiceMedals" },
				{ text = ("|T%1$s:16:16|t  Prismatic Manapearl"):format("Interface\\Icons\\Inv_misc_enchantedpearlf"), check = "showPrismaticManapearl" },
			}
		},
		{ text = "      Legion", submenu = {
				{ text = ("|T%1$s:16:16|t  Order Hall Resources"):format("Interface\\Icons\\inv_orderhall_orderresources"), check = "showResources" },
				{ text = ("|T%1$s:16:16|t  Legionfall War Supplies"):format("Interface\\Icons\\inv_misc_summonable_boss_token"), check = "showLegionfallSupplies" },
				{ text = ("|T%1$s:16:16|t  Nethershard"):format("Interface\\Icons\\inv_datacrystal01"), check = "showNethershards" },
				{ text = ("|T%1$s:16:16|t  Veiled Argunite"):format("Interface\\Icons\\oshugun_crystalfragments"), check = "showArgunite" },
				{ text = ("|T%1$s:16:16|t  Wakening Essences"):format("Interface\\Icons\\achievement_dungeon_ulduar80_25man"), check = "showWakeningEssences" },
			}
		},
		{ text = "" },
		{ text = "Filter by type...", isTitle = true },
		{ text = "Profession Quests", check = "showProfession", submenu = {
				{ text = "Alchemy", check="showProfessionAlchemy" },
				{ text = "Blacksmithing", check="showProfessionBlacksmithing" },
				{ text = "Inscription", check="showProfessionInscription" },
				{ text = "Jewelcrafting", check="showProfessionJewelcrafting" },
				{ text = "Leatherworking", check="showProfessionLeatherworking" },
				{ text = "Tailoring", check="showProfessionTailoring" },
				{ text = "Enchanting", check="showProfessionEnchanting" },
				{ text = "Engineering", check="showProfessionEngineering" },
				{ text = "" },
				{ text = "Herbalism", check="showProfessionHerbalism" },
				{ text = "Mining", check="showProfessionMining" },
				{ text = "Skinning", check="showProfessionSkinning" },
				{ text = "" },
				{ text = "Cooking", check="showProfessionCooking" },
				{ text = "Archaeology", check="showProfessionArchaeology" },
				{ text = "Fishing", check="showProfessionFishing" },
			}
		},
		{ text = "Dragon Rider Racing", check = "showDragonRiderRacing" },
		{ text = "Dungeon Quests", check = "showDungeon" },
		{ text = "PvP Quests", check = "showPvP" },
		{ text = "Pet Battle Quests", check = "showPetBattle", submenu = {
				{ text = "Hide Pet Battle Quests even when active bounty", check = "hidePetBattleBountyQuests" },
				{ text = "Always show quests for \"Family Familiar\" achievement", check = "alwaysShowPetBattleFamilyFamiliar" },
			}
		},
		{ text = "" },
		{ text = "Hide faction column", check="hideFactionColumn" },
		{ text = "Hide faction paragon bars", check="hideFactionParagonBars" },
		{ text = "Always show quests for faction...", isTitle = true },
		{ text = "       Dragonflight", submenu = {
				{ text = "Dragonscale Expedition", check="alwaysShowDragonscaleExpedition" },
				{ text = "Iskaara Tuskarr", check="alwaysShowIskaaraTuskarr" },
				{ text = "Maruuk Centaur", check="alwaysShowMaruukCentaur" },
				{ text = "Valdrakken Accord", check="alwaysShowValdrakkenAccord" },
				{ text = "Loamm Niffen", check="alwaysShowLoammNiffen" },
				{ text = "Dream Wardens", check="alwaysShowDreamWardens" },
			}
		},
		{ text = "       Shadowlands", submenu = {
				{ text = "The Avowed", check="alwaysShowAvowed" },
				{ text = "The Wild Hunt", check="alwaysShowWildHunt" },
				{ text = "Court of Harvesters", check="alwaysShowCourtofHarvesters" },
				{ text = "The Undying Army", check="alwaysShowUndyingArmy" },
				{ text = "The Ascended", check="alwaysShowAscended" },
				{ text = "Death's Advance", check="alwaysShowDeathsAdvance" },
				{ text = "The Enlightened", check="alwaysShowEnlightened" },
			}
		},
		{ text = "       Battle for Azeroth", submenu = {
				{ text = "Rustbolt Resistance", check="alwaysShowRustboltResistance" },
				{ text = "Tortollan Seekers", check="alwaysShowTortollanSeekers" },
				{ text = "Champions of Azeroth", check="alwaysShowChampionsOfAzeroth" },
				{ text = ("|T%1$s:16:16|t  7th Legion"):format("Interface\\Icons\\inv_misc_tournaments_banner_human"), check="alwaysShow7thLegion" },
				{ text = ("|T%1$s:16:16|t  Storm's Wake"):format("Interface\\Icons\\inv_misc_tournaments_banner_human"), check="alwaysShowStormsWake" },
				{ text = ("|T%1$s:16:16|t  Order of Embers"):format("Interface\\Icons\\inv_misc_tournaments_banner_human"), check="alwaysShowOrderOfEmbers" },
				{ text = ("|T%1$s:16:16|t  Proudmoore Admiralty"):format("Interface\\Icons\\inv_misc_tournaments_banner_human"), check="alwaysShowProudmooreAdmiralty" },
				{ text = ("|T%1$s:16:16|t  Waveblade Ankoan"):format("Interface\\Icons\\inv_misc_tournaments_banner_human"), check="alwaysShowWavebladeAnkoan" },
				{ text = ("|T%1$s:16:16|t  The Honorbound"):format("Interface\\Icons\\inv_misc_tournaments_banner_orc"), check="alwaysShowTheHonorbound" },
				{ text = ("|T%1$s:16:16|t  Zandalari Empire"):format("Interface\\Icons\\inv_misc_tournaments_banner_orc"), check="alwaysShowZandalariEmpire" },
				{ text = ("|T%1$s:16:16|t  Talanji's Expedition"):format("Interface\\Icons\\inv_misc_tournaments_banner_orc"), check="alwaysShowTalanjisExpedition" },
				{ text = ("|T%1$s:16:16|t  Voldunai"):format("Interface\\Icons\\inv_misc_tournaments_banner_orc"), check="alwaysShowVoldunai" },
				{ text = ("|T%1$s:16:16|t  The Unshackled"):format("Interface\\Icons\\inv_misc_tournaments_banner_orc"), check="alwaysShowTheUnshackled" },
			}
		},
		{ text = "       Legion", submenu = {
				{ text = "Court of Farondis", check="alwaysShowCourtOfFarondis" },
				{ text = "Dreamweavers", check="alwaysShowDreamweavers" },
				{ text = "Highmountain Tribe", check="alwaysShowHighmountainTribe" },
				{ text = "The Nightfallen", check="alwaysShowNightfallen" },
				{ text = "The Wardens", check="alwaysShowWardens" },
				{ text = "Valarjar", check="alwaysShowValarjar" },
				{ text = "Armies of Legionfall", check="alwaysShowArmiesOfLegionfall" },
				{ text = "Army of the Light", check="alwaysShowArmyOfTheLight" },
				{ text = "Argussian Reach", check="alwaysShowArgussianReach" },
			}
		},
	}
	if TomTom then
		table.insert(options, { text = "" })
		table.insert(options, { text = "Add TomTom waypoint on row click", check = "enableTomTomWaypointsOnClick" })
	end
	table.insert(options, { text = "" })
	table.insert(options, { text = "Spew Debug Information", check = "spewDebugInfo" })

	configMenu = CreateFrame("Frame", "BWQ_ConfigMenu")
	configMenu.displayMode = "MENU"

	local SetOption = function(bt, var, val)
		if var == "usePerCharacterSettings" or not BWQcfg.usePerCharacterSettings then
			BWQcfg[var] = val or not BWQcfg[var]
		else
			BWQcfgPerCharacter[var] = val or not BWQcfgPerCharacter[var]
		end

		-- refresh radio buttons
		if val then
			local sub = bt:GetName():sub(1, 19).."%i"
			for i = 1, bt:GetParent().numButtons do
				local subi = sub:format(i)
				if _G[subi] == bt then
					_G[subi.."Check"]:Show()
				else
					_G[subi.."Check"]:Hide()
					_G[subi.."UnCheck"]:Show()
				end
			end
		end

		if var == "expansion" then
			BWQ.expansion = C("expansion")
			BWQ:HideRowsOfInactiveExpansions()
			BWQ.hasUnlockedWorldQuests = false
		end

		if var == "hideFactionParagonBars" then
			BWQ:UpdateFactionDisplayVisible()
		end

		BWQ:UpdateBlock()

		-- toggle block when changing attach setting
		if var == "attachToWorldMap" then
			BWQ:Hide()
			if C(var) == true and WorldMapFrame:IsShown() then
				BWQ:AttachToWorldMap()
			end
		end

		if var == "usePerCharacterSettings" then
			CloseDropDownMenus()
			ToggleDropDownMenu(1, nil, configMenu, configMenu.anchor, 0, 0)
		end
	end

	configMenu.initialize = function(self, level)
		if not level then return end
		local opt = level > 1 and UIDROPDOWNMENU_MENU_VALUE or options
		for i, v in ipairs(opt) do
			info = wipe(info)
			info.text = v.text
			info.isTitle = v.isTitle

			if v.check then
				if (v.check == "usePerCharacterSettings") then info.checked = BWQcfg[v.check]
				elseif v.radio then info.checked = C(v.check) == v.val
				else info.checked = C(v.check)
				end
				info.func, info.arg1 = SetOption, v.check 
				if v.radio then info.arg2 = v.val end
				info.isNotRadio = not v.radio
				info.keepShownOnClick = true
			elseif v.submenu then
				info.notCheckable = true
			else
				info.notCheckable = true
				info.disabled = true
			end
			info.hasArrow, info.value = v.submenu, v.submenu
			UIDropDownMenu_AddButton( info, level )
		end
	end

	BWQ.SetupConfigMenu = nil
end


function BWQ:OpenConfigMenu(anchor)
	if not configMenu and anchor then
		BWQ:SetupConfigMenu()
	end
	configMenu.anchor = anchor
	ToggleDropDownMenu(1, nil, configMenu, configMenu.anchor, 0, 0)
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
	if not C("attachToWorldMap") or (C("attachToWorldMap") and not WorldMapFrame:IsShown()) then
		CloseDropDownMenus()

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

local skipNextUpdate = false
BWQ:RegisterEvent("PLAYER_ENTERING_WORLD")
BWQ:RegisterEvent("ADDON_LOADED")
BWQ:SetScript("OnEvent", function(self, event, arg1)
	if event == "QUEST_LOG_UPDATE" then
		--[[
		Opening quest details in the side bar of the world map fires QUEST_LOG_UPDATE event.
		To avoid setting the currently shown map again, which would hide the quest details,
		skip updating after a WORLD_MAP_UPDATE event happened
		--]]
		if not skipNextUpdate then
			BWQ:RunUpdate()
		end
		skipNextUpdate = false
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
			if C("attachToWorldMap") then
				BWQ:Hide()
			end

			BWQ.mapTextures.animationGroup:Stop()
		end)
		hooksecurefunc(WorldMapFrame, "Show", function(self)
			if C("attachToWorldMap") then
				BWQ:AttachToWorldMap()
				BWQ:RunUpdate()
			end
		end)
		hooksecurefunc(WorldMapFrame, "OnMapChanged", function(self)
			skipNextUpdate = true
			local mapId = WorldMapFrame:GetMapID()
			if BWQ.currentMapId and BWQ.currentMapId ~= mapId then
				BWQ.mapTextures.animationGroup:Stop()
			end
			BWQ.currentMapId = mapId
		end)

		BWQ:UnregisterEvent("PLAYER_ENTERING_WORLD")

		BWQ:RegisterEvent("QUEST_LOG_UPDATE")
		BWQ:RegisterEvent("QUEST_WATCH_LIST_CHANGED")
		if (not C("hideFactionParagonBars")) then
			BWQ:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
		end
		if TomTom then
			BWQ:RegisterEvent("PLAYER_LOGOUT")
			BWQ:RegisterEvent("QUEST_ACCEPTED")
		end
	elseif event == "ADDON_LOADED" then
		if arg1 == "Broker_WorldQuests" then
			BWQcfg = BWQcfg or defaultConfig
			BWQcfgPerCharacter = BWQcfgPerCharacter and BWQcfgPerCharacter or BWQcfg and BWQcfg or defaultConfig
			for i, v in next, defaultConfig do
				if BWQcfg[i] == nil then BWQcfg[i] = v end
				if BWQcfgPerCharacter[i] == nil then BWQcfgPerCharacter[i] = v end
			end
			BWQcache = BWQcache or {}
			if not C("expansion") then
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
				BWQ:SwitchExpansion(C("expansion"))
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
		if TomTom and BWQ.TomTomWaypoints[arg1] then 
			TomTom:RemoveWaypoint(BWQ.TomTomWaypoints[arg1]) 
			BWQ.TomTomWaypoints[arg1] = nil
		end
	elseif event == "PLAYER_LOGOUT" then
		if TomTom and #BWQ.TomTomWaypoints then
			for k, v in pairs(BWQ.TomTomWaypoints) do
				TomTom:RemoveWaypoint(BWQ.TomTomWaypoints[k])
				BWQ.TomTomWaypoints[k] = nil
			end
		end
	end
end)

-- data broker object
local ldb = LibStub("LibDataBroker-1.1")
BWQ.WorldQuestsBroker = ldb:NewDataObject("WorldQuests", {
	type = "data source",
	text = "World Quests",
	icon = "Interface\\ICONS\\Achievement_Dungeon_Outland_DungeonMaster",
	OnEnter = function(self)
		if not C("showOnClick") then
			BWQ:AttachToBlock(self)
		end
	end,
	OnLeave = function() BWQ:Block_OnLeave() end,
	OnClick = function(self, button)
		if button == "LeftButton" then
			if C("showOnClick") then
				BWQ:AttachToBlock(self)
			else
				BWQ:RunUpdate()
			end
		elseif button == "RightButton" then
			BWQ:Block_OnLeave()
			BWQ:OpenConfigMenu(self)
		end
	end,
})
