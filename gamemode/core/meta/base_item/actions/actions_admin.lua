local showAdminActions = function(self, ply)
	if not ply:IsAdmin() then
		return false
	end

	local inventory = self:GetInventory()

	if inventory.StoreType == INV_PLAYER or inventory.StoreType == INV_STASH then
		return inventory:GetPlayer() != ply
	end

	return false
end

ITEM.Actions.AdminTake = {
	Name = "Take Item",
	Priority = 1,

	Context = table.Lookup({
		"RightClick"
	}),

	CanRun = showAdminActions,
	Callback = function(self, ply)
		local inventory = self:GetInventory()

		Log.Write("admin_item_take", ply, self, inventory:GetPlayer(), inventory.StoreType)

		self:SetInventory(ply:GetInventory())
	end
}

ITEM.Actions.AdminDestroy = {
	Name = "Destroy Item",

	Context = table.Lookup({
		"RightClick"
	}),

	CanRun = showAdminActions,
	Client = function(self, ply)
		return not Settings.Get("ConfirmItemDestruction") or ui.Open("Input", "confirm", "Destroy Item", {
			Prompt = string.format("Are you sure you'd like to destroy this %s?", self:GetName()),
		})
	end,
	Callback = function(self, ply)
		local inventory = self:GetInventory()

		Log.Write("admin_item_destroy", ply, self, inventory:GetPlayer(), inventory.StoreType)

		self:Delete()
	end
}
