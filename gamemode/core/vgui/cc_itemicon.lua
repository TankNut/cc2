local PANEL = {}
DEFINE_BASECLASS("DModelPanel")

AccessorFunc(PANEL, "Item", "Item")

function PANEL:Init()
	self:SetSize(48, 48)
end

function PANEL:SetItem(item)
	self.Item = item
	self.Item.Panels[self] = true
	self:SetModel(item:GetModel())

	local ent = self:GetEntity()

	item:SetItemAppearance(ent)

	local tab = PositionSpawnIcon(ent, ent:GetPos())

	self:SetFOV(tab.fov)
	self:SetCamPos(tab.origin)
	self:SetLookAng(tab.angles)
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
	GUI.Open("ItemPopup", self.Item)
end

function PANEL:DoRightClick(category)
	self.Item:OpenActionMenu(category)
end

function PANEL:Paint(w, h)
	local col = self.Item:GetHighlightColor()

	if col then
		draw.RoundedBox(8, 0, 0, w, h, col)
	end

	BaseClass.Paint(self, w, h)

	local rarity = self.Item:GetRarityData()

	if rarity.Color then
		draw.NoTexture()
		surface.SetDrawColor(rarity.Color.r, rarity.Color.g, rarity.Color.b, 230)

		draw.Circle(w - 6, h - 6, 4, 8)
		surface.DrawCircle(w - 6, h - 6, 4, 20, 20, 20, 230)
	end
end

derma.DefineControl("CCItemIcon", "", PANEL, "DModelPanel")
