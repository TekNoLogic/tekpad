
local LINEHEIGHT, maxoffset, offset = 12, 0, 0


local panel = LibStub("tekPanel-Auction").new("tekPadPanel", "tekPad")


local scroll = CreateFrame("ScrollFrame", nil, panel)
scroll:SetPoint("TOPLEFT", 21, -73)
scroll:SetPoint("BOTTOMRIGHT", -10, 38)
local HEIGHT = scroll:GetHeight()

local editbox = CreateFrame("EditBox", nil, scroll)
scroll:SetScrollChild(editbox)
editbox:SetPoint("TOP")
editbox:SetPoint("LEFT")
editbox:SetPoint("RIGHT")
editbox:SetHeight(1000)
editbox:SetFontObject(GameFontHighlightSmall)
editbox:SetTextInsets(2,2,2,2)
editbox:SetMultiLine(true)
editbox:SetAutoFocus(false)
editbox:SetScript("OnEscapePressed", editbox.ClearFocus)
editbox:SetScript("OnEditFocusLost", function(self) tekPadDB = self:GetText() end)


editbox:SetScript("OnShow", function(self)
	local text = tekPadDB or ""
	self:SetText(text)
	self:SetFocus()
end)


local function doscroll(v)
	offset = math.max(math.min(v, 0), maxoffset)
	scroll:SetVerticalScroll(-offset)
	editbox:SetPoint("TOP", 0, offset)
end


editbox:SetScript("OnCursorChanged", function(self, x, y, width, height)
	LINEHEIGHT = height
	if offset < y then
		doscroll(y)
	elseif math.floor(offset - HEIGHT + height*2) > y then
		local v = y + HEIGHT - height*2
		maxoffset = math.min(maxoffset, v)
		doscroll(v)
	end
end)


scroll:UpdateScrollChildRect()
scroll:EnableMouseWheel(true)
scroll:SetScript("OnMouseWheel", function(self, val) doscroll(offset + val*LINEHEIGHT*3) end)


local butt = CreateFrame("Button", nil, panel)
butt:SetWidth(80) butt:SetHeight(22)
butt:SetPoint("BOTTOMRIGHT", -7, 14)

butt:SetHighlightFontObject(GameFontHighlightSmall)
butt:SetNormalFontObject(GameFontNormalSmall)

butt:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
butt:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
butt:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
butt:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
butt:GetNormalTexture():SetTexCoord(0, 0.625, 0, 0.6875)
butt:GetPushedTexture():SetTexCoord(0, 0.625, 0, 0.6875)
butt:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
butt:GetDisabledTexture():SetTexCoord(0, 0.625, 0, 0.6875)
butt:GetHighlightTexture():SetBlendMode("ADD")

butt:SetText("Run")
butt:SetScript("OnClick", function() RunScript(editbox:GetText()) end)


-----------------------------
--      Slash Handler      --
-----------------------------

SLASH_TEKPADSLASH1 = "/pad"
SLASH_TEKPADSLASH2 = "/tekpad"
function SlashCmdList.TEKPADSLASH() ShowUIPanel(panel) end


----------------------------------------
--      Quicklaunch registration      --
----------------------------------------

local ldb = LibStub and LibStub:GetLibrary("LibDataBroker-1.1", true)
if ldb then
	local dataobj = ldb:GetDataObjectByName("tekPad") or ldb:NewDataObject("tekPad", {type = "launcher", icon = "Interface\\Icons\\INV_Misc_Note_01"})
	dataobj.OnClick = SlashCmdList.TEKPADSLASH
end
