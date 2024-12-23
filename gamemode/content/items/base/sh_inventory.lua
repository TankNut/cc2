function ITEM:GetInventory()
	return Inventory.Get(self.InventoryID)
end

function ITEM:OnMove(old, new, loading)
end

function ITEM:SetInventory(inventory, loading)
	if IsValid(self.Entity) then
		self.Entity.Item = nil
		self.Entity:Remove()
		self.Entity = nil
	end

	local old = self:GetInventory()

	if old then
		old:RemoveItem(self)
	end

	self.InventoryID = inventory.ID

	inventory:AddItem(self, loading)

	self:OnMove(old, inventory, loading)

	if SERVER then
		self:UpdateNetworking(old, inventory)

		if not loading then
			async.Start(self.SaveLocation, self)
		end
	end
end

function ITEM:SetWorldItem(pos, ang, frozen, loading)
	local old = self:GetInventory()

	if old then
		old:RemoveItem(self)
	end

	self.InventoryID = nil
	self:OnMove(old, nil, loading)

	if CLIENT then
		return
	end

	self:UpdateNetworking(old, nil)

	local ent = self.Entity

	if not IsValid(self.Entity) then
		ent = ents.Create("cc_item")
		ent:SetModel(self:GetModel())

		self:SetItemAppearance(ent)

		ent.Item = self
		ent:SetItemName(self:GetData("Name", self.Name))
		ent:SetItemWeight(self:GetWeight())

		ent:Spawn()
		ent:Activate()

		self.Entity = ent
	end

	ent:SetPos(pos)
	ent:SetAngles(ang)

	if not frozen then
		ent:PhysWake()
	end

	ent:SaveMoved()
end

if SERVER then
	function ITEM:UpdateNetworking(old, new)
		if not old and not new then
			return
		end

		if new then
			if old then
				local add, move, remove = new:CompareReceivers(old)

				netstream.Send(add, "AddItem", self.ClassName, self.ID, self.Data, new.ID)
				netstream.Send(move, "MoveItem", self.ID, new.ID)
				netstream.Send(remove, "RemoveItem", self.ID)
			elseif table.Count(new.Receivers) > 0 then
				netstream.Send(table.GetKeys(new.Receivers), "AddItem", self.ClassName, self.ID, self.Data, new.ID)
			end
		elseif table.Count(old.Receivers) > 0 then
			netstream.Send(table.GetKeys(old.Receivers), "RemoveItem", self.ID)
		end
	end
end
