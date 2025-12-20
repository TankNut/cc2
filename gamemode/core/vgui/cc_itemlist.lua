local PANEL = {}
DEFINE_BASECLASS("Panel")

function PANEL:Init()
	self.Weight = self:Add("CC_ProgressBar")
	self.Weight:DockMargin(0, ui.Scale(10), 0, 0)
	self.Weight:Dock(BOTTOM)
	self.Weight:SetTall(ui.Scale(20))

	self.Scroll = self:Add("DScrollPanel")
	self.Scroll:Dock(FILL)

	local space = ui.Scale(3)

	self.Layout = self.Scroll:Add("DTileLayout")
	self.Layout:SetBaseSize(ui.Scale(48))
	self.Layout:SetBorder(space)
	self.Layout:SetSpaceX(space)
	self.Layout:SetSpaceY(space)
end

function PANEL:PerformLayout(w, h)
	self.Weight:SetPos(0, h - ui.Scale(20))
	self.Layout:SetSize(w, h - ui.Scale(30))
end

function PANEL:Populate(inventory)
	inventory.Panels[self] = true

	self.Inventory = inventory
	self.Layout:Clear()

	for _, item in pairs(inventory.Items) do
		local icon = vgui.Create("CC_ItemIcon")
		icon:SetItem(item)

		self.Layout:Add(icon)
		self:OnIconAdded(icon)
	end

	self:Sort()
	self:UpdateWeight()
end

function PANEL:OnIconAdded(icon)
end

function PANEL:Think()
	if self.Inventory.Weight != self.CachedWeight then
		self:UpdateWeight()
	end
end

function PANEL:UpdateWeight()
	local weight = self.Inventory.Weight
	local max = self.Inventory:GetMaxWeight()

	if max == 0 then
		self.Weight:SetProgress(weight / 100)
		self.Weight:SetProgressText("Weight: " .. weight)
	else
		self.Weight:SetProgress(weight / max)
		self.Weight:SetProgressText(string.format("Weight: %s/%s", weight, max))
	end

	self.CachedWeight = weight
end

function PANEL:OnRemove()
	self.Inventory.Panels[self] = nil
end

function PANEL:Sort()
	local children = self.Layout:GetChildren()

	for _, v in pairs(children) do
		v:SetParent(nil)
	end

	table.sort(children, function(a, b)
		a = a.Item
		b = b.Item

		-- Move temp items back
		if a:IsTemporaryItem() != b:IsTemporaryItem() then
			return b:IsTemporaryItem()
		end

		-- Move stacking items back
		if a:IsType("base_stacking") != b:IsType("base_stacking") then
			return b:IsType("base_stacking")
		end

		return a.ID < b.ID
	end)

	for _, v in pairs(children) do
		self.Layout:Add(v)
	end
end

function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "ItemList", self, w, h - ui.Scale(30))
end

vgui.Register("CC_ItemList", PANEL, "Panel")
