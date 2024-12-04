Inventory = Inventory or {}

netstream.Hook("AddItem", function(class, id, data)
	local item = Inventory[id] or Item.Instance(class, id, data)

	if Inventory[id] then
		for k, v in pairs(data) do
			item:SetData(k, v)
		end
	else
		Inventory[id] = item
	end
end)

netstream.Hook("RemoveItem", function(id)
	Inventory[id] = nil

	-- Do ui updates
end)

netstream.Hook("UpdateItemData", function(id, key, val)
	if not Inventory[id] then
		return
	end

	Inventory[id]:SetData(key, val)
end)
