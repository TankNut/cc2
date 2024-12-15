Inventory = Inventory or {}
Equipment = Equipment or {}

InventoryPanels = InventoryPanels or {}

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

	for panel in pairs(InventoryPanels) do
		panel:PopulateLocal()
	end
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

netstream.Hook("InventoryPopup", function(storeType, storeRef, items)
	for k, v in pairs(items) do
		local item = Item.Instance(unpack(v))

		item.StoreType = storeType
		item.StoreRef = storeRef

		items[k] = item
	end

	local existing = GUI.Get("InventoryPopup")

	if IsValid(existing) then
		existing:Setup(storeType, storeRef, items)
		existing:MoveToFront()
	else
		GUI.Open("InventoryPopup", storeType, storeRef, items)
	end
end)
