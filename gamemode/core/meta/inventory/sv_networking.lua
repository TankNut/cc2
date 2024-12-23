local meta = CustomMetaTable("Inventory")

function meta:GetReceivers()
	local receivers = {}

	for listener in pairs(self.Listeners) do
		-- Check listeners for validity once per tick
	end

	table.Merge(receivers, self.Listeners)

	if self.StoreType == INV_PLAYER or self.StoreType == INV_STASH then
		receivers[self:GetParent()] = true
	elseif self.StoreType == INV_ITEM then
		local inventory = self:GetParent():GetInventory()

		if inventory then
			table.Merge(receivers, inventory.Receivers)
		end
	end

	return receivers
end

function meta:UpdateReceivers()
	local old = self.Receivers
	local new = self:GetReceivers()

	local add = {}
	local remove = {}

	for ply in pairs(new) do
		if not old[ply] then
			table.insert(add, ply)
		end
	end

	for ply in pairs(old) do
		if not new[ply] then
			table.insert(remove, ply)
		end
	end

	if #add > 0 then
		local items = {}

		for _, item in pairs(self.Items) do
			table.insert(items, {
				item.ClassName,
				item.ID,
				item.Data
			})
		end

		netstream.Send(targets, "InventoryCreated", self.ID, self.StoreType, self.StoreID, self.Parent, items)
	end

	if #remove > 0 then
		netstream.Send(remove, "InventoryRemoved", self.ID)
	end

	self.Receivers = new

	for _, item in pairs(self.Items) do
		if item.Contents then
			item.Contents:UpdateReceivers()
		end
	end
end

function meta:CompareReceivers(other)
	local receivers = self.Receivers
	local otherReceivers = other.Receivers

	local ours = {}
	local both = {}
	local theirs = {}

	for ply in pairs(receivers) do
		if otherReceivers[ply] then
			table.insert(both, ply)
		else
			table.insert(ours, ply)
		end
	end

	for ply in pairs(otherReceivers) do
		if not receivers[ply] then
			table.insert(theirs, ply)
		end
	end

	return ours, both, theirs
end

function meta:AddListener(ply)
	if self.Listeners[ply] then
		return
	end

	self.Listeners[ply] = true
	self:UpdateReceivers()
end

function meta:RemoveListener(ply)
	if not self.Listeners[ply] then
		return
	end

	self.Listeners[ply] = nil
	self:UpdateReceivers()
end

netstream.Hook("RemoveInventoryListener", function(ply, id)
	local inventory = Inventory.Get(id)

	if inventory then
		inventory:RemoveListener(ply)
	end
end)
