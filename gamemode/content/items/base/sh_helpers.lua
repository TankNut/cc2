function ITEM:IsTemporaryItem()
	return self.ID < 0
end

function ITEM:IsOwner(ply)
	return self:GetOwner() == ply
end

function ITEM:GetOwner()
	return self.StoreRef
end

function ITEM:IsEquipped()
	return tobool(self:GetEquipmentSlot())
end

function ITEM:IsStashed()
	return self.StoreType == INV_STASH
end

function ITEM:IsDropped()
	return self.StoreType == INV_WORLD
end
