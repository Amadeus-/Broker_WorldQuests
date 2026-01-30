local _, addon = ...
local CONSTANTS = addon.CONSTANTS
--==========================================================
-- Factions / Paragon
--==========================================================
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
	if BWQ:C("hideFactionParagonBars") then return end
	if issecretvalue and issecretvalue(msg) then return end

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
	if BWQ:C("hideFactionParagonBars") then return end

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
	if not BWQ:C("hideFactionParagonBars") then
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