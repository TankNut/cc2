local PANEL = {}
DEFINE_BASECLASS("DModelPanel")

AccessorFunc(PANEL, "Item", "Item")
AccessorFunc(PANEL, "OrbitDistance", "OrbitDistance")

function PANEL:Init()
	local size = ui.Scale(48)

	self:SetSize(size, size)
end

function PANEL:SetItem(item)
	self.Item = item
	self.Item.Panels[self] = true
	self:SetModel(item:GetModel())

	local ent = self:GetEntity()

	item:SetItemAppearance(ent)

	self:SetOrbitDistance(ent:GetModelRadius() + 75)

	local angle, fov = item:GetIconCamera()

	self:SetLookAng(angle)
	self:SetFOV(fov)
end

function PANEL:OnRemove()
	BaseClass.OnRemove(self)

	self.Item.Panels[self] = nil

	if GAMEMODE.CursorItem == self.Item then
		GAMEMODE.CursorItem = nil
	end
end

function PANEL:LayoutEntity(ent)
	self.colColor = ent:GetColor()

	local mins, maxs = ent:GetModelBounds()

	self.OrbitPoint = (mins + maxs) / 2
	self.vCamPos = self.OrbitPoint - self.aLookAngle:Forward() * self.OrbitDistance
end

function PANEL:OnCursorEntered()
	GAMEMODE.CursorItem = self.Item
end

function PANEL:OnCursorExited()
	if GAMEMODE.CursorItem and GAMEMODE.CursorItem == self.Item then
		GAMEMODE.CursorItem = nil
	end
end

function PANEL:DoDoubleClick()
	ui.Open("ItemPopup", self.Item)
end

function PANEL:DoRightClick()
	self.Item:OpenActionMenu("RightClick")
end

function PANEL:ItemUpdated()
	self:SetItem(self.Item)
end

function PANEL:PreDrawModel(ent)
	local x, y = self:LocalToScreen(1, 1)
	local x2, y2 = self:LocalToScreen(self:GetWide() - 1, self:GetTall() - 1)

	render.SetScissorRect(x, y, x2, y2, true)
end

function PANEL:Paint(w, h)
	local col = self.Item:GetHighlightColor()

	if col then
		draw.RoundedBox(8, 0, 0, w, h, col)
	end

	BaseClass.Paint(self, w, h)

	local offset = ui.Scale(6)
	local radius = ui.Scale(4)

	if self.Item:GetRarity() != RARITY_COMMON then
		local color = self.Item:GetRarityData().Color

		draw.NoTexture()
		surface.SetDrawColor(color.r, color.g, color.b, 230)

		draw.Circle(w - offset, h - offset, radius, 8)
		surface.DrawCircle(w - offset, h - offset, radius, 20, 20, 20, 230)
	end

	local amount = self.Item:GetAmount()

	if amount > 1 then
		surface.SetTextColor(200, 200, 200)
		surface.SetFont("CombineControl.LabelSmall")

		local corner = ui.Scale(2)
		local text = amount .. "x"
		local _, y = surface.GetTextSize(text)

		surface.SetTextPos(corner, h - corner - y)
		surface.DrawText(text)
	end

	self.Item:DrawItemIcon(w, h)
end

vgui.Register("CC_ItemIcon", PANEL, "DModelPanel")
