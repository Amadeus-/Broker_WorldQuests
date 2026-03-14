local _, addon = ...
local CONSTANTS = addon.CONSTANTS
local GetQuestObjectiveInfo = C_QuestLog and C_QuestLog.GetQuestObjectiveInfo or GetQuestObjectiveInfo
--==========================================================
-- Bounties
--==========================================================
BWQ.bountyCache = {}
BWQ.bountyDisplay = CreateFrame("Frame", "BWQ_BountyDisplay", BWQ)
function BWQ:UpdateBountyData()
	-- TODO: get map id for retrieving bounties
	if (BWQ.expansion == CONSTANTS.EXPANSIONS.MIDNIGHT or BWQ.expansion == CONSTANTS.EXPANSIONS.THEWARWITHIN or BWQ.expansion == CONSTANTS.EXPANSIONS.DRAGONFLIGHT or BWQ.expansion == CONSTANTS.EXPANSIONS.SHADOWLANDS) then
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
											BWQ:FormatTimeLeftString(timeleft)
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
			bountyCacheItem.button:SetScript("OnLeave", function(self) BWQ.tooltip:Hide() end)
			
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

function BWQ:ShowBountyTooltip(button, questID)
	local questIndex = C_QuestLog.GetLogIndexForQuestID(questID)
	local title = C_QuestLog.GetTitleForLogIndex(questIndex)
	if title then
		BWQ.tooltip:SetOwner(button, "ANCHOR_BOTTOM")
		if BWQ.tooltip.ItemTooltip then BWQ.tooltip.ItemTooltip:Hide() end
		BWQ.tooltip:SetText(title, HIGHLIGHT_FONT_COLOR:GetRGB())

		local questDescription
		if C_QuestLog.GetQuestText then
			local textInfo = C_QuestLog.GetQuestText(questIndex)
			questDescription = textInfo and textInfo.description
		else
			_, questDescription = GetQuestLogQuestText(questIndex)
		end

		BWQ.tooltip:AddLine(questDescription, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)

		local objectiveText, objectiveType, finished = GetQuestObjectiveInfo(questID, 1, false)
		if objectiveText and #objectiveText > 0 then
			local color = finished and GRAY_FONT_COLOR or HIGHLIGHT_FONT_COLOR;
			BWQ.tooltip:AddLine(QUEST_DASH .. objectiveText, color.r, color.g, color.b, true);
		end

		pcall(GameTooltip_AddQuestRewardsToTooltip, BWQ.tooltip, questID, TOOLTIP_QUEST_REWARDS_STYLE_EMISSARY_REWARD)
		BWQ.tooltip:Show()
		button.UpdateTooltip = function(self) BWQ:ShowBountyTooltip(button, questID) end
	end
end