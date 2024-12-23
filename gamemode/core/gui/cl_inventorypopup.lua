local PANEL = {}

local inventoryWidth = 350

function PANEL:Init()
	self:SetSize(800, 500)
	self:DockPadding(10, 10, 10, 10)

	self:SetDraggable(true)
	self:SetCloseOnPause(true)

	self:MakePopup()
	self:Center()

	self.OurInventory = self:Add("CCItemList")
	self.OurInventory:Dock(LEFT)
	self.OurInventory:SetWide(inventoryWidth)

	self.OurInventory:Populate(lp:GetInventory())

	self.TheirInventory = self:Add("CCItemList")
	self.TheirInventory:Dock(RIGHT)
	self.TheirInventory:SetWide(inventoryWidth)

	self.Buttons = self:Add("DPanel")
	self.Buttons:Dock(FILL)
	self.Buttons:DockMargin(10, 0, 10, 0)
	self.Buttons:SetPaintBackground(false)
end

function PANEL:GetInventoryName()
	local storeType = self.Inventory.StoreType
	local parent = self.Inventory:GetParent()

	if storeType == INV_PLAYER then
		return string.format("%s (%s credits)", parent:CharacterName(), parent:GetMoney())
	elseif self.StoreType == INV_ITEM then
		return parent:GetName()
	end

	return "Unknown"
end

function PANEL:Setup(inventory)
	self.Inventory = inventory
	self.TheirInventory:Populate(inventory)
	self:SetTopBar("Inventory - " .. self:GetInventoryName())
end

derma.DefineControl("GUI_InventoryPopup", "", PANEL, "CCFrame")

GUI.Register("InventoryPopup", function(id)
	local panel = vgui.Create("GUI_InventoryPopup")
	local inventory = Inventory.Get(id)

	panel:Setup(inventory)

	return panel
end, true)
