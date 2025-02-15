local CLASS = Hud.Class

CLASS.Name = "Unnamed Hud Element"

CLASS.Default = false -- Whether the element is added to the hud by default
CLASS.Setting = false -- If set, will add a setting to enable-disable the hud element based on the value of CLASS.Default

CLASS.AlwaysDraw = false -- Whether the element draws when the hud is disabled

CLASS.DrawOrder = 0

function CLASS:IsValid()
	return Hud.Lookup[self.ClassName] == self
end

function CLASS:ShouldAddElement()
	if self.Setting then
		return Settings.Get("Hud" .. self.Setting)
	end

	return self.Default
end

function CLASS:Initialize()
end

function CLASS:Think()
end

function CLASS:OnRemove()
end

function CLASS:GetCache(key, fallback)
	local val = Hud.Cache[key]

	return val != nil and val or fallback
end

function CLASS:SetCache(key, val)
	Hud.Cache[key] = val
end

function CLASS:ShouldDraw()
	if self.AlwaysDraw then
		return true
	end

	return Settings.Get("Hud")
end

function CLASS:DrawAlignedRect(x, y, w, h, color, xAlign, yAlign)
	if xAlign == TEXT_ALIGN_CENTER then
		x = x - w * 0.5
	elseif xAlign == TEXT_ALIGN_RIGHT then
		x = x - w
	end

	if yAlign == TEXT_ALIGN_CENTER then
		y = y - h * 0.5
	elseif yAlign == TEXT_ALIGN_BOTTOM then
		y = y - h
	end

	if color then
		surface.SetDrawColor(color)
	end

	surface.DrawRect(x, y, w, h)
end

function CLASS:Paint(w, h)
end

function CLASS:PaintBackground(w, h)
end
