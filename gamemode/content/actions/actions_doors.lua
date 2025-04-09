Action.Add("SetDoorType", {
	Name = "Set Door Type...",
	Priority = 3,

	Access = ACTION_EDITMODE,
	Target = ACTION_INTERACT,

	CanRun = function(self, ply)
		return door.Is(self) and self:CreatedByMap()
	end,
	SubOptions = function(self)
		local tab = {}

		for _, index in ipairs(Doors.TypeList) do
			table.insert(tab, {
				Name = Doors.AccessTypes[index].Name,
				Value = index
			})
		end

		return tab
	end,
	Validate = function(self, ply, index)
		return validate.Value(index, validate.InLookup(Doors.AccessTypes))
	end,
	Callback = function(self, ply, value)
		self:SetDoorType(value)
	end
})

local validation = {
	validate.Max(32)
}

Action.Add("SetDoorGroup", {
	Name = "Set Door Group...",
	Priority = 2,

	Access = ACTION_EDITMODE,
	Target = ACTION_INTERACT,

	CanRun = function(self, ply)
		return door.Is(self) and self:CreatedByMap()
	end,
	Validate = function(self, ply, name)
		return validate.Value(name, validation)
	end,
	Client = function(self)
		return true, GUI.Open("Input", "string", "Change Door Group", {
			Default = self:DoorGroup(),
			Validate = validation,
			Name = "Door groups"
		})
	end,
	Callback = function(self, ply, name)
		self:SetDoorGroup(name)
	end
})

Action.Add("LockDoor", {
	Name = "Lock",
	Priority = 1,

	Target = ACTION_INTERACT,

	CanRun = function(self, ply)
		return door.Is(self) and not self:IsDoorLocked() and hook.Run("CanLockDoor", ply, ent)
	end,
	Callback = function(self, ply)
		self:SetDoorLocked(true)
		ply:EmitSound("DoorHandles.Locked1")
	end
})

Action.Add("UnlockDoor", {
	Name = "Unlock",
	Priority = 1,

	Target = ACTION_INTERACT,

	CanRun = function(self, ply)
		return door.Is(self) and self:IsDoorLocked() and hook.Run("CanLockDoor", ply, ent)
	end,
	Callback = function(self, ply)
		self:SetDoorLocked(false)
		ply:EmitSound("DoorHandles.Unlocked1")
	end
})

