function ITEM:GetEquipmentSlots()
	local slots = {}
	local flagSlots = self:GetOwner():RunCharFlag("EquipmentSlots")

	for _, slot in ipairs(flagSlots) do
		if self.EquipmentLookup[slot] then
			table.insert(slots, slot)
		end
	end

	return slots
end

function ITEM:GetEquipmentSlot()
	return self:GetData("EquipmentSlot", false)
end

function ITEM:OnEquipped(ply, slot)
	if SERVER then
		if self.GetModelData or self.PostModelData then
			ply:UpdateAppearance()
		end

		if self.Armor > 0 then
			ply:UpdateArmor()
		end

		self:GetInventory():RecalculateWeight()
	end
end

function ITEM:OnUnequipped(ply)
	if SERVER then
		if self.GetModelData or self.PostModelData then
			ply:UpdateAppearance()
		end

		if self.Armor > 0 then
			ply:UpdateArmor()
		end

		self:GetInventory():RecalculateWeight()
	end
end

function ITEM:OnEquipmentSlotChanged(old, new)
	local ply = self:GetOwner()

	if new then
		self:OnEquipped(ply, new)
	else
		self:OnUnequipped(ply)
	end

	if old then Inventory.Equipment[ply][old] = nil end
	if new then Inventory.Equipment[ply][new] = self end
end

function ITEM:SetEquipmentSlot(slot)
	local ply = self:GetOwner()

	if slot then
		local item = ply:GetEquipment(slot)

		if item then
			item:SetEquipmentSlot(ply, nil)
		end
	end

	self:SetData("EquipmentSlot", slot)
end
