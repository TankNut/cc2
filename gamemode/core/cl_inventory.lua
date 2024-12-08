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

	Inventory[id] = Item.Instance(class, id, data)
end)

netstream.Hook("RemoveItem", function(id)
	Inventory[id] = nil

	GAMEMODE:PMUpdateInventory()
end)

netstream.Hook("UpdateItemData", function(id, key, val)
	if not Inventory[id] then
		return
	end

	Inventory[id]:SetData(key, val)
end)
