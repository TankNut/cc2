local HUD = {}

HUD.Name = "Unnamed Hud Element"

HUD.Setting = nil -- If set, will add a setting to enable-disable the hud element based on the value of CLASS.Default
HUD.ExtraSettings = {}

HUD.RequireCharacter = true -- Will only be added if the player has a valid character
HUD.AlwaysDraw = nil -- Whether the element draws when the hud is disabled

HUD.DrawOrder = 0

function HUD:IsValid()
	return Hud.Lookup[self.ClassName] == self
end

function HUD:ShouldAddElement()
	if self.RequireCharacter and not lp:HasCharacter() then
		return false
	end

	if self.Setting then
		return Settings.Get("Hud" .. self.Setting)
	end

	return true
end

function HUD:Initialize()
end

function HUD:Think()
end

function HUD:OnRemove()
end

function HUD:GetExtraSetting(key)
	return Settings.Get("Hud" .. (self.Setting or "") .. key)
end

function HUD:GetCache(key, fallback)
	local val = Hud.Cache[key]

	return val != nil and val or fallback
end

function HUD:SetCache(key, val)
	Hud.Cache[key] = val
end

local convar = GetConVar("cl_drawhud")

function HUD:ShouldDraw()
	if self.AlwaysDraw then
		return true
	end

	if not convar:GetBool() then
		return false
	end

	return Settings.Get("Hud")
end

function HUD:GetPlayer(ply)
	return ply:IsRagdolled() and ply:GetRagdoll() or ply
end

function HUD:DrawAlignedRect(x, y, w, h, color, xAlign, yAlign)
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

function HUD:DrawBar(ratio, x, y, w, h, border, background, fill, xAlign, yAlign)
	local border2 = border * 2

	if background != nil then
		self:DrawAlignedRect(x, y, w, h, background, xAlign, yAlign)
	end

	self:DrawAlignedRect(x + border, y - border, (w - border2) * ratio, h - border2, fill, xAlign, yAlign)
end

function HUD:AddWorldLabel(pos, lines)
	Hud.AddWorldLabel(pos, lines)
end

function HUD:Paint(w, h)
end

function HUD:PaintBackground(w, h)
end

function HUD:PostDrawTranslucentRenderables(depth, skybox)
end

inherit.Register("hud", "base", HUD)
