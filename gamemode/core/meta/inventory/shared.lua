local meta = CustomMetaTable("Inventory")

GM:Include("sh_items.lua")
GM:Include("sv_networking.lua")

function meta:Initialize()
	self.Items = {}
	self.Weight = 0

	if CLIENT then
		self.Panels = {}
	else
		self.Listeners = {}
		self.Receivers = {}

		self:LoadItems()
		self:UpdateReceivers()
	end
end

function meta:Remove()
	Inventory.Remove(self.ID)
end

function meta:OnRemove()
	for _, item in pairs(self.Items) do
		item:Remove(true)
	end

	if CLIENT then
		self:CallPanels("Remove")
	else
		netstream.Send(table.GetKeys(self.Receivers), "InventoryRemoved", self.ID)
	end
end

function meta:GetMaxWeight()
	if self.StoreType == INV_PLAYER then
		return self:GetParent():MaxInventoryWeight()
	end

	return 0
end

function meta:RecalculateWeight()
	local weight = 0

	for _, item in pairs(self.Items) do
		weight = weight + item:GetWeight()
	end

	self.Weight = weight

	if self.StoreType == INV_PLAYER then
		self:GetParent():SetInventoryWeight(weight)
	end

	if CLIENT then
		for panel in pairs(self.Panels) do
			panel:UpdateWeight()
		end
	end
end

function meta:GetParent()
	if self.StoreType == INV_PLAYER or self.StoreType == INV_STASH or self.StoreType == INV_CONTAINER then
		return Entity(self.Parent)
	elseif self.StoreType == INV_ITEM then
		return Item.Get(self.Parent)
	end
end

if CLIENT then
	function meta:CallPanels(func, ...)
		for panel in pairs(self.Panels) do
			panel[func](panel, ...)
		end
	end
end
