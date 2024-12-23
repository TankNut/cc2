function ITEM:IsTemporaryItem()
	return self.ID < 0
end

function ITEM:GetStoreType()
	if IsValid(self.Entity) then
		return INV_WORLD
	end

	return self:GetInventory().StoreType
end

function ITEM:GetOwner()
	if self:IsDropped() then
		return self.Entity
	end

	return self:GetInventory():GetParent()
end

function ITEM:IsOwner(ply)
	return self:GetOwner() == ply
end

function ITEM:IsEquipped()
	return tobool(self:GetEquipmentSlot())
end

function ITEM:IsStashed()
	return self:GetStoreType() == INV_STASH
end

function ITEM:IsDropped()
	return IsValid(self.Entity)
end
