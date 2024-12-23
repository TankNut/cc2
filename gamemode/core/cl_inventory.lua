netstream.Hook("InventoryCreated", function(id, storeType, storeID, parent, items)
	Inventory.Create(id, storeType, storeID, parent):LoadItems(items)
end)

netstream.Hook("InventoryRemoved", function(id)
	Inventory.Remove(id)
end)
