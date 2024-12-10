ITEM.Actions.Equip = {
	Categories = {Rightclick = true, InventoryButton = true},
	Priority = 10,

	CanRun = function(self, ply)
		return hook.Run("CanEquipItem", ply, self) and #self:GetEquipmentSlots() == 1
	end,
	Callback = function(self, ply)
		self:SetEquipmentSlot(ply, self:GetEquipmentSlots()[1])
	end
}

ITEM.Actions.EquipSlot = {
	Categories = {Rightclick = true, InventoryButton = true},
	Priority = 10,

	CanRun = function(self, ply)
		return hook.Run("CanEquipItem", ply, self) and #self:GetEquipmentSlots() > 1
	end,
	SubOptions = function(self, ply)
		local options = {}

		for _, slot in ipairs(self:GetEquipmentSlots()) do
			table.insert(options, {
				Name = "Equip as: " .. EquipmentSlot(slot),
				Value = slot
			})
		end

		return options
	end,
	Callback = function(self, ply, slot)
		if not slot then
			return false, "You need to specify an equipment slot!"
		end

		local ok, err = hook.Run("CanUseEquipmentSlot", ply, self, slot)

		if not ok then
			return false, err
		end

		self:SetEquipmentSlot(ply, slot)
	end
}

ITEM.Actions.Unequip = {
	Categories = {Rightclick = true, InventoryButton = true},
	Priority = 10,

	CanRun = function(self, ply)
		return hook.Run("CanUnequipItem", ply, self)
	end,
	Callback = function(self, ply)
		self:SetEquipmentSlot(ply, nil)
	end
}

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
	end
end

function ITEM:OnEquipmentSlotChanged(old, new)
	local ply = self:GetOwner()

	if new then
		self:OnEquipped(ply, new)
	else
		self:OnUnequipped(ply)
	end

	if CLIENT then
		if old then Equipment[old] = nil end
		if new then Equipment[new] = self end
	else
		if old then Inventory.Equipment[ply][old] = nil end
		if new then Inventory.Equipment[ply][new] = self end
	end
end


if SERVER then
	function ITEM:SetEquipmentSlot(ply, slot)
		if slot then
			local item = ply:GetEquipment(slot)

			if item then
				item:SetEquipmentSlot(ply, nil)
			end
		end

		self:SetData("EquipmentSlot", slot)
	end
end
