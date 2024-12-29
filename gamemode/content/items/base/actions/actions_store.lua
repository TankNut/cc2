ITEM.Actions.Store = {
	Hidden = true,

	Client = function(self, ply, id)
		local inventory = Inventory.Get(id)

		if not inventory then
			return false, "This inventory doesn't exist!"
		end

		local ok, err = hook.Run("CanStoreItem", ply, self, inventory)

		if not ok then
			return false, err
		end

		return true, id
	end,
	Callback = function(self, ply, id)
		local inventory = Inventory.Get(id)

		if not inventory then
			return false, "This inventory doesn't exist!"
		end

		local ok, err = hook.Run("CanStoreItem", ply, self, inventory)

		if not ok then
			if err then
				ply:SendChat(nil, "ERROR", err)
			end

			return
		end

		self:SetInventory(Inventory.Get(id))
	end
}

ITEM.Actions.Take = {
	Hidden = true,

	CanRun = function(self, ply)
		return hook.Run("CanTakeItem", ply, self)
	end,
	Callback = function(self, ply)
		self:SetInventory(ply:GetInventory())
	end
}
