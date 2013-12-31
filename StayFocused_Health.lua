StayFocusedHealth = CreateFrame("Frame", "StayFocusedHealth", UIParent)
local frame = StayFocusedHealth

function frame:ApplyOptions()
	local o = frame.db

	frame.text:SetPoint("LEFT", StayFocusedMainFrame, "RIGHT", 2, 0)

	frame.text:SetFont([=[Fonts\ARIALN.ttf]=], o.font_size, o.font_outline and "OUTLINE" or "")
	frame.text:SetTextColor(1, 1, 1)
	frame.text:SetText('')
end

frame:RegisterEvent("ADDON_LOADED")

frame:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...
		if addon:lower() ~= "stayfocused_health" then return end
		StayFocusedHealthDB = StayFocusedHealthDB or {
			style = 1,
		
			font_size = 12,
			font_outline = true,			
		}
		
		self.db = StayFocusedHealthDB
		
		frame.text = frame:CreateFontString(nil, "OVERLAY")
		frame.text:SetJustifyH("CENTER")
		frame.text:SetPoint("CENTER")
		
		self:ApplyOptions()
		self:UnregisterEvent("ADDON_LOADED")
	end
end)

local function getHpPercent(p, decimal, smart)
	local max_power = UnitHealthMax('player')
	if smart and (p == max_power or p == 0) then return '' end
	local v = p / max_power * 100.0
	return smart and (decimal and format(' (%.1f%%)', v) or format(' (%.0f%%)', v)) or (decimal and format('%.1f%%', v) or format('%.0f%%', v))
end

local function getText(v)
	local style = StayFocusedHealth.db.style
	if style == 1 then
		return v..getHpPercent(v, true, true)
	end
	if style == 2 then
		return v..getHpPercent(v, false, true)
	end
	if style == 3 then
		return v
	end
	if style == 4 then
		return getHpPercent(v, true, false)
	end
	if style == 5 then
		return getHpPercent(v, false, false)
	end
	return ''
end

local lastUpdate = 0
frame:SetScript("OnUpdate", function(self, elapsed)
	lastUpdate = lastUpdate + elapsed
	if color == '' then return end
	if lastUpdate > 0.1 then
		lastUpdate = 0

		local hp = UnitHealth('player')
		if hp == 0 then
			frame.text:SetText(' ')
		else			
			frame.text:SetText('|cffffffff'..getText(hp))
		end
	end
end)
