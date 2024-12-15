local PANEL = {}

local inventoryWidth = 350

function PANEL:Init()
	self:SetSize(800, 500)
	self:DockPadding(10, 10, 10, 10)

	self:SetCloseOnPause(true)

	self:MakePopup()
	self:Center()

	self.OurInventory = self:Add("CCItemList")
	self.OurInventory:Dock(LEFT)
	self.OurInventory:SetWide(inventoryWidth)

	self.OurInventory:PopulateLocal()

	self.TheirInventory = self:Add("CCItemList")
	self.TheirInventory:Dock(RIGHT)
	self.TheirInventory:SetWide(inventoryWidth)

	self.Buttons = self:Add("DPanel")
	self.Buttons:Dock(FILL)
	self.Buttons:DockMargin(10, 0, 10, 0)
	self.Buttons:SetPaintBackground(false)
end

function PANEL:GetInventoryName()
	if self.StoreType == INV_PLAYER then
		return string.format("%s (%s credits)", self.StoreRef:CharacterName(), self.StoreRef:GetMoney())
	end

	return "Unknown"
end

function PANEL:Setup(storeType, storeRef, items)
	self.StoreType = storeType
	self.StoreRef = storeRef

	local weight = 0
	local max = 0

	if storeType == INV_PLAYER then
		weight = storeRef:InventoryWeight()
		max = storeRef:MaxInventoryWeight()
	end

	self.TheirInventory:Populate(items, weight, max)
	self:SetTopBar("Inventory - " .. self:GetInventoryName())
end

derma.DefineControl("GUI_InventoryPopup", "", PANEL, "CCFrame")

GUI.Register("InventoryPopup", function(storeType, storeRef, items)
	local panel = vgui.Create("GUI_InventoryPopup")

	panel:Setup(storeType, storeRef, items)

	return panel
end, true)
