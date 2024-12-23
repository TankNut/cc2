netstream.Hook("AddItem", function(class, id, data, inventory)
	local item = Item.Instance(class, id, data)

	item:SetInventory(Inventory.Get(inventory))
end)

netstream.Hook("MoveItem", function(id, inventory)
	local item = assert(Item.Get(id))

	item:SetInventory(Inventory.Get(inventory))
end)

netstream.Hook("RemoveItem", function(id)
	local item = Item.Get(id)

	if item then
		item:Remove()
	end
end)

netstream.Hook("SetItemData", function(id, key, val)
	local item = assert(Item.Get(id))

	if item.Data[key] == val then
		return
	end

	item:SetData(key, val)
end)
