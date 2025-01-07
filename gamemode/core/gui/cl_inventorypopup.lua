local PANEL = {}

local inventoryWidth = 360

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

	self.OurInventory:Receiver("TakeItem", function(_, icons, dropped)
		if not dropped then
			return
		end

		icons[1]:GetItem():RunAction(lp, "Take")
	end)

	self.OurInventory.OnIconAdded = function(_, icon)
		icon:Droppable("StoreItem")

		-- Not the cleanest but it works
		if self.Inventory.StoreType == INV_ITEM and self.Inventory:GetItem() == icon:GetItem() then
			icon:Remove()
		end
	end

	self.TheirInventory = self:Add("CCItemList")
	self.TheirInventory:Dock(RIGHT)
	self.TheirInventory:SetWide(inventoryWidth)

	self.TheirInventory:Receiver("StoreItem", function(pnl, icons, dropped)
		if not dropped then
			return
		end

		icons[1]:GetItem():RunAction(lp, "Store", pnl.Inventory.ID)
	end)

	self.TheirInventory.OnIconAdded = function(_, icon)
		icon:Droppable("TakeItem")
	end
end

function PANEL:GetInventoryName()
	local storeType = self.Inventory.StoreType

	if storeType == INV_PLAYER then
		local ply = self.Inventory:GetPlayer()

		return string.format("%s (%s credits)", ply:CharacterName(), ply:GetMoney())
	elseif storeType == INV_ITEM then
		return self.Inventory:GetItem():GetName()
	end

	return "Unknown"
end

function PANEL:Setup(inventory)
	self.Inventory = inventory
	self.OurInventory:Populate(lp:GetInventory())
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
