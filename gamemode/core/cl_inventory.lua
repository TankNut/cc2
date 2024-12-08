Inventory = Inventory or {}

local meta = FindMetaTable("Player")

function meta:GetItems()
	return self == lp and Inventory or {}
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
