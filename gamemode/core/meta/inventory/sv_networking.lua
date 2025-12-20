local INVENTORY = CustomMetaTable("Inventory")

function INVENTORY:GetReceivers()
	local receivers = table.Copy(self.Listeners)

	if self.StoreType == INV_PLAYER or self.StoreType == INV_STASH then
		local ply = self:GetParent()

		if IsValid(ply) then
			receivers[ply] = true
		end
	elseif self.StoreType == INV_ITEM then
		local inventory = self:GetParent():GetInventory()

		if inventory then
			table.Merge(receivers, inventory.Receivers)
		end
	end

	return receivers
end

function INVENTORY:UpdateReceivers()
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

		netstream.Send(add, "CreateInventory", self.ID, self.StoreType, self.StoreID, self.Parent, items)
	end

	if #remove > 0 then
		netstream.Send(remove, "RemoveInventory", self.ID)
	end

	self.Receivers = new

	for _, item in pairs(self.Items) do
		if item.Contents then
			item.Contents:UpdateReceivers()
		end
	end
end

function INVENTORY:UpdateListeners()
	local update = false

	for ply in pairs(self.Listeners) do
		if not self:CheckListener(ply) then
			update = true
			self.Listeners[ply] = nil
		end
	end

	if update then
		self:UpdateReceivers()
	end
end

function INVENTORY:CheckListener(ply)
	local id = self.Listeners[ply]

	if not id then
		return false
	end

	if id == LISTENER_ADMIN then
		return true
	end

	if not ply:CanAct() then
		return false
	end

	-- Not using CanAccessInventory for players and stashes because we're dealing with patdowns here and that hook is used for 'full' interactions
	if self.StoreType == INV_PLAYER then
		return ply:WithinInteractRange(self:GetParent())
	elseif self.StoreType == INV_STASH then
		return ply:WithinInteractRange(self:GetParent())
	else
		return hook.Run("CanAccessInventory", ply, self)
	end
end

function INVENTORY:AddListener(ply, id)
	if self.Listeners[ply] then
		return
	end

	self.Listeners[ply] = id
	self:UpdateReceivers()
end

function INVENTORY:RemoveListener(ply)
	if not self.Listeners[ply] then
		return
	end

	self.Listeners[ply] = nil
	self:UpdateReceivers()
end

function INVENTORY:ClearListeners()
	self.Listeners = {}
	self:UpdateReceivers()
end
