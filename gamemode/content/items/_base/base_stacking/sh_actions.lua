local function drop(self, ply)
	Log.Write("item_drop", ply, self)

	self:SetWorldItem(Item.GetDropPosition(ply), Angle(0, ply:EyeAngles().y, 0))
end

local function dropAmount(self, ply, amount)
	if amount >= self:GetAmount() then
		drop(self, ply)

		return
	end

	Log.Write("item_split", ply, self)

	drop(self:Split(amount), ply)
end

ITEM.Actions = {}
ITEM.Actions.Drop = {
	Priority = ITEM_ACTION_DROP,

	Context = table.Lookup({"RightClick"}),

	CanRun = function(self, ply)
		return hook.Run("CanDropItem", ply, self)
	end,

	Validate = function(self, ply, amount)
		return validate.Value(amount, {
			validate.Number(),
			validate.Min(1),
			validate.Max(self:GetAmount())
		})
	end,

	Client = function(self, ply)
		return true, ui.Open("ItemDropAmount", "Drop", self)
	end,
	Callback = function(self, ply, amount)
		dropAmount(self, ply, math.Round(amount))
	end
}

ITEM.Actions.DropOne = {
	Name = "Drop\tDrop One",
	Priority = ITEM_ACTION_DROP - 1,

	Context = table.Lookup({"RightClick"}),

	CanRun = function(self, ply)
		return hook.Run("CanDropItem", ply, self)
	end,
	Callback = function(self, ply)
		dropAmount(self, ply, 1)
	end
}

ITEM.Actions.DropHalf = {
	Name = "Drop\tDrop Half",
	Priority = ITEM_ACTION_DROP - 2,

	Context = table.Lookup({"RightClick"}),

	CanRun = function(self, ply)
		return hook.Run("CanDropItem", ply, self)
	end,
	Callback = function(self, ply)
		dropAmount(self, ply, math.Round(self:GetAmount() * 0.5))
	end
}

ITEM.Actions.DropAll = {
	Name = "Drop\tDrop All",
	Priority = ITEM_ACTION_DROP - 3,

	Context = table.Lookup({"RightClick"}),

	CanRun = function(self, ply)
		return hook.Run("CanDropItem", ply, self)
	end,
	Callback = drop
}

ITEM.Actions.Store = {
	Hidden = true,

	Validate = function(self, ply, id, amount)
		local inventory = Inventory.Get(id)

		if not inventory then
			return false, "This inventory doesn't exist!"
		end

		amount = math.Round(amount)

		local ok, err = validate.Value(amount, {
			validate.Number(),
			validate.Min(1),
			validate.Max(self:GetAmount())
		})

		if not ok then
			return err
		end

		return hook.Run("CanStoreItem", ply, self, inventory, amount)
	end,

	Client = function(self, ply, id)
		return true, id, ui.Open("ItemDropAmount", "Store", self)
	end,
	Callback = function(self, ply, id, amount)
		amount = math.Round(amount)

		local inventory = Inventory.Get(id)

		if amount >= self:GetAmount() then
			self:SetInventory(inventory)
		end

		Log.Write("item_split", ply, self)

		self:Split(amount):SetInventory(inventory)
	end
}
