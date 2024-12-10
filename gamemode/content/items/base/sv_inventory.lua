function ITEM:RemoveFromCurrent(keepEntity)
	if not keepEntity and IsValid(self.Entity) then
		self.Entity.Item = nil
		self.Entity:Remove()
		self.Entity = nil
	end

	local inventory = self.Inventory

	if inventory then
		inventory:ItemRemoved(self)
	end

	self.Inventory = nil

	self.StoreType = INV_NULL
	self.StoreRef = nil

	return inventory
end

function ITEM:SetInventory(inventory, loading)
	self:PreItemMove(loading)

	local old = self:RemoveFromCurrent()

	inventory:ItemAdded(self, loading)

	self.Inventory = inventory

	self:OnMove(old, inventory, loading)
	self.StoreType = inventory.StoreType
	self.StoreRef = inventory.Ref

	if not loading then
		async.Start(self.SaveLocation, self)
	end
end

function ITEM:SetWorldItem(pos, ang, frozen, loading)
	self:PreItemMove(loading)

	local old = self:RemoveFromCurrent(true)

	self:OnMove(old, nil)

	local ent = IsValid(self.Entity) and self.Entity or ents.Create("cc_item")

	self.StoreType = INV_WORLD
	self.StoreRef = ent

	ent:SetPos(pos)
	ent:SetAngles(ang)

	if not IsValid(self.Entity) then
		ent:SetModel(self:GetModel())
		self:SetItemAppearance(ent)

		ent.Item = self
		ent:SetItemName(self:GetData("Name", self.Name))
		ent:SetItemWeight(self:GetWeight())

		ent:Spawn()
		ent:Activate()

		self.Entity = ent
	end

	if not frozen then
		ent:PhysWake()
	end

	ent:SaveMoved()

	if not loading then
		async.Start(self.SaveLocation, self)
	end
end

function ITEM:Cleanup()
end

function ITEM:PreItemMove(loaded)
	if self:IsEquipped() and not loaded then
		self:SetEquipmentSlot(ply, nil)
	end
end

function ITEM:OnMove(old, new, loaded)
end
