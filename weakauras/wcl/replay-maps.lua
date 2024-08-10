_G["WCL"] = {
	replayMapsHookInitialized = false,
	cache = {},
	frame = nil,
}

local function CreateAndShowEditBox(text)
	if WCL.frame == nil then
		local WCLEditBox = CreateFrame("Frame", "WCLEditBox", UIParent, "DialogBoxFrame")
		WCL.frame = WCLEditBox
		WCLEditBox:SetPoint("TOPLEFT", EncounterJournal, "TOPRIGHT", 0, 0)
		WCLEditBox:SetSize(600, 500)

		WCLEditBox:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
			edgeSize = 16,
			insets = { left = 8, right = 6, top = 8, bottom = 8 },
		})
		WCLEditBox:SetBackdropBorderColor(0, 0.44, 0.87, 0.5) -- darkblue

		-- Movable
		WCLEditBox:SetMovable(true)
		WCLEditBox:SetClampedToScreen(true)
		WCLEditBox:SetScript("OnMouseDown", function(self, button)
			if button == "LeftButton" then
				self:StartMoving()
			end
		end)
		WCLEditBox:SetScript("OnMouseUp", WCLEditBox.StopMovingOrSizing)

		-- ScrollFrame
		local WCLEditBoxScrollFrame =
			CreateFrame("ScrollFrame", "WCLEditBoxScrollFrame", WCLEditBox, "UIPanelScrollFrameTemplate")
		WCLEditBoxScrollFrame:SetPoint("LEFT", 16, 0)
		WCLEditBoxScrollFrame:SetPoint("RIGHT", -32, 0)
		WCLEditBoxScrollFrame:SetPoint("TOP", 0, -16)
		-- WCLEditBoxScrollFrame:SetPoint("BOTTOM", nil, "TOP", 0, 0)

		-- EditBox
		local WCLEditBoxEditBox = CreateFrame("EditBox", "WCLEditBoxEditBox", WCLEditBoxScrollFrame)
		WCLEditBoxEditBox:SetSize(WCLEditBoxScrollFrame:GetSize())
		WCLEditBoxEditBox:SetMultiLine(true)
		WCLEditBoxEditBox:SetAutoFocus(false) -- dont automatically focus
		WCLEditBoxEditBox:SetFontObject("ChatFontNormal")
		WCLEditBoxEditBox:SetScript("OnEscapePressed", function()
			WCLEditBox:Hide()
		end)
		WCLEditBoxScrollFrame:SetScrollChild(WCLEditBoxEditBox)

		-- Resizable
		WCLEditBox:SetResizable(true)
		WCLEditBox:SetResizeBounds(150, 100)

		local WCLEditBoxResizeButton = CreateFrame("Button", "WCLEditBoxResizeButton", WCLEditBox)
		WCLEditBoxResizeButton:SetPoint("BOTTOMRIGHT", -6, 7)
		WCLEditBoxResizeButton:SetSize(16, 16)

		WCLEditBoxResizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		WCLEditBoxResizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
		WCLEditBoxResizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

		WCLEditBoxResizeButton:SetScript("OnMouseDown", function(self, button)
			if button == "LeftButton" then
				WCLEditBox:StartSizing("BOTTOMRIGHT")
				self:GetHighlightTexture():Hide() -- more noticeable
			end
		end)
		WCLEditBoxResizeButton:SetScript("OnMouseUp", function(self, button)
			WCLEditBox:StopMovingOrSizing()
			self:GetHighlightTexture():Show()
			WCLEditBoxEditBox:SetWidth(WCLEditBoxScrollFrame:GetWidth())
		end)
		WCLEditBox:Show()

		hooksecurefunc(EncounterJournal, "Hide", function()
			WCLEditBox:Hide()
		end)
	end

	if text and WCLEditBoxEditBox:GetText() ~= text then
		WCLEditBoxEditBox:SetText(text)
	end
	WCLEditBox:Show()
end

local function Round(num)
	return floor(num + 0.5)
end

local function GetReplayMapData(zoneID)
	if zoneID == 0 or WCL.cache[zoneID] ~= nil then
		return ""
	end

	local minWorldPos = select(2, C_Map.GetWorldPosFromMapPos(zoneID, CreateVector2D(0, 0)))
	local maxWorldPos = select(2, C_Map.GetWorldPosFromMapPos(zoneID, CreateVector2D(1, 1)))

	if minWorldPos == nil or maxWorldPos == nil then
		return ""
	end

	local maxY, minX = minWorldPos:GetXY()
	local minY, maxX = maxWorldPos:GetXY()

	local lines = {}
	table.insert(lines, format("case %d: {", zoneID))
	table.insert(lines, format("    // %d %d", maxY, minX))
	table.insert(lines, format("    // %d %d", minY, maxX))
	table.insert(
		lines,
		format(
			"    jsonReplayMap(result, mapID, mapName, %d, %d, %d, %d, false);",
			Round(minX * 100 * -1),
			Round(maxX * 100 * -1),
			Round(minY * 100),
			Round(maxY * 100)
		)
	)
	table.insert(lines, "    break;")
	table.insert(lines, "}")
	table.insert(lines, "")

	local ret = table.concat(lines, "\n")

	WCL.cache[zoneID] = ret

	if zoneID == 1666 then
		-- necrotic wake is bugged
		local otherMaps = { 1667, 1668 }

		for k, id in ipairs(otherMaps) do
			if WCL.cache[zoneID] ~= nil then
				WCL.cache[id] = GetReplayMapData(id)
				ret = ret .. WCL.cache[id]
			end
		end
	else
		local mapLinks = C_Map.GetMapLinksForMap(zoneID)

		for k, v in ipairs(mapLinks) do
			if WCL.cache[zoneID] ~= nil then
				WCL.cache[v.linkedUiMapID] = GetReplayMapData(v.linkedUiMapID)
				ret = ret .. WCL.cache[v.linkedUiMapID]
			end
		end
	end

	return ret
end

function GetReplayMapsOutput()
	WCL.cache = {}

	local instanceName, _, _, _, _, _, dungeonAreaMapID = EJ_GetInstanceInfo()

	local lines = {}
	table.insert(lines, format("// Replay map data for %s (%d)", instanceName, dungeonAreaMapID))
	table.insert(lines, GetReplayMapData(dungeonAreaMapID))

	return table.concat(lines, "\n")
end

function aura_env.setup()
	if WCL.replayMapsHookInitialized then
		return
	end

	EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", function(owner, addonName)
		if addonName == "Blizzard_EncounterJournal" then
			EventRegistry:UnregisterFrameEventAndCallback("ADDON_LOADED", owner)

			hooksecurefunc("EncounterJournal_DisplayInstance", function()
				CreateAndShowEditBox(GetReplayMapsOutput())
			end)
		end
	end)

	WCL.replayMapsHookInitialized = true
end
