Inventory = Inventory or {}
Equipment = Equipment or {}

local meta = FindMetaTable("Player")

function meta:GetItems()
	return self == lp and Inventory or {}
end

function meta:GetEquipment(slot)
	if not slot then
		return self == lp and Equipment or {}
	else
		return self == lp and Equipment[slot] or nil
	end
end

netstream.Hook("AddItem", function(class, id, data)
	assert(not Inventory[id], "LocalPlayer inventory already contains item id: " .. id)

	local item = Item.Instance(class, id, data)

	item.StoreType = INV_PLAYER
	item.StoreRef = lp

	Inventory[id] = item
end)

netstream.Hook("RemoveItem", function(id)
	local item = Item.Get(id)

	if item then
		item:OnRemove()
	end

	Inventory[id] = nil
end)

netstream.Hook("UpdateItemData", function(id, key, val)
	if not Inventory[id] then
		return
	end

	Inventory[id]:SetData(key, val)
end)
