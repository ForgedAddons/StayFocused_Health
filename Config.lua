local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame.name = "Health (plugin)"
frame.parent = "Stay Focused!"
frame:Hide()

local title, subtitle = LibStub("tekKonfig-Heading").new(frame, "|cffa0a0f0Stay Focused!|r Health", "Options for health text.")

local ICONSIZE, ICONGAP, GAP, EDGEGAP, BIGGAP = 32, 3, 8, 16, 16
local tekcheck = LibStub("tekKonfig-Checkbox")
local tekslide = LibStub("tekKonfig-Slider")

local styledropdown, styletext, stylecontainer, stylelabel = LibStub("tekKonfig-Dropdown").new(frame, "Style", "TOPLEFT", subtitle, "BOTTOMLEFT", 0, -GAP)
stylecontainer:SetHeight(28)
styledropdown:ClearAllPoints()
styledropdown:SetPoint("LEFT", stylelabel, "RIGHT", -8, -2)
styledropdown.tiptext = "How text should be displayed"

local function OnClick(self)
	local text = "9999 (100.0%)"
	if self.value == 2 then text = "9999 (100%)" end
	if self.value == 3 then text = "9999" end
	if self.value == 4 then text = "100.0%" end
	if self.value == 5 then text = "100%" end
	styletext:SetText(text)
	StayFocusedHealth.db.style = self.value
end

local font_size, font_size_l, font_size_c = tekslide.new(frame, "Font size", 6, 32, "TOPLEFT", stylecontainer, "BOTTOMLEFT", 0, -BIGGAP)
font_size:SetValueStep(1)
font_size:SetScript("OnValueChanged", function(self, newvalue)
	font_size_l:SetText(string.format("Font size: %d", newvalue))
	StayFocusedHealth.db.font_size = newvalue
	StayFocusedHealth:ApplyOptions()
end)
local font_outline = tekcheck.new(frame, nil, "Font Outline", "TOPLEFT", font_size_c, "TOPRIGHT", 4*GAP, 0)
local checksound = font_outline:GetScript("OnClick")
font_outline:SetScript("OnClick", function(self)
	checksound(self);
	StayFocusedHealth.db.font_outline = not StayFocusedHealth.db.font_outline
	StayFocusedHealth:ApplyOptions()
end)


frame:SetScript("OnShow", function(frame)

	local text = "9999 (100.0%)"
	if StayFocusedHealth.db.style == 2 then text = "9999 (100%)" end
	if StayFocusedHealth.db.style == 3 then text = "9999" end
	if StayFocusedHealth.db.style == 4 then text = "100.0%" end
	if StayFocusedHealth.db.style == 5 then text = "100%" end
	styletext:SetText(text)
	
	UIDropDownMenu_Initialize(styledropdown, function()
		local selected, info = StayFocusedHealth.db.style, UIDropDownMenu_CreateInfo()
	
		info.func = OnClick
	
		info.text = "value (percent [1 decimal place])"
		info.value = 1
		info.checked = 1 == selected
		UIDropDownMenu_AddButton(info)
	
		info.text = "value (percent [no decimal places])"
		info.value = 2
		info.checked = 2 == selected
		UIDropDownMenu_AddButton(info)
		
		info.text = "value"
		info.value = 3
		info.checked = 3 == selected
		UIDropDownMenu_AddButton(info)
	
		info.text = "percent [1 decimal place]"
		info.value = 4
		info.checked = 4 == selected
		UIDropDownMenu_AddButton(info)
		
		info.text = "percent [no decimal places]"
		info.value = 5
		info.checked = 5 == selected
		UIDropDownMenu_AddButton(info)
	end)

	font_size:SetValue(StayFocusedHealth.db.font_size)
	font_outline:SetChecked(StayFocusedHealth.db.font_outline)
end)

StayFocusedHealth.configframe = frame
InterfaceOptions_AddCategory(frame)