module("Doors", package.seeall)

Vars = Vars or {}

AccessTypes = AccessTypes or {}
TypeList = {}

EntityVar.Add("IsDoorOpen", {Default = false})

EntityVar.Add("_DoorLocked", {Default = false})
EntityVar.Add("_DoorTouchable", {Default = false})
EntityVar.Add("_DoorToggle", {Default = false})
EntityVar.Add("_DoorAutoClose", {Default = -1})
EntityVar.Add("_DoorSpeed", {Default = 0})
EntityVar.Add("_DoorForceClose", {Default = false})
EntityVar.Add("_DoorDamage", {Default = 0})

EntityVar.Add("_DoorGroup", {Default = ""})
EntityVar.Add("_DoorType", {Default = "default"})
EntityVar.Add("_DoorStartOpen", {Default = false})

GlobalVar.Add("DoorData", {
	Default = {},
	ServerOnly = true,
	Persist = true,
	Mode = GLOBALVAR_MAP_NO_OVERRIDE
})

local types = table.Lookup({
	"prop_door_rotating",
	"func_door_rotating",
	"func_door"
})

local ENTITY = FindMetaTable("Entity")

EntityCache.Add("doors", function(ent) return tobool(types[ent:GetClass()]) end)

function AddAccessType(name, data)
	local color = Color(data.Color) or util.GetSeededColor(name, 0.5, 1)
	color.a = 50

	AccessTypes[name] = {
		Name = data.Name or name,
		Color = color,
		CanAccess = data.CanAccess or function(ent, ply) return true end,
		CanLock = data.CanLock or function(ent, ply) return false end,
		OnAccessGranted = data.OnAccessGranted or function(ent, ply) end,
		OnAccessDenied = data.OnAccessDenied or function(ent, ply, reason) end,
		OnDoorLocked = data.OnDoorLocked or function(ent, ply) end,
		PreUseCallback = data.PreUseCallback or function(ent, ply) end,
		PostUseCallback = data.PostUseCallback or function(ent, ply) end
	}

	table.insert(TypeList, name)
end

function AddVar(name, data)
	Vars[name] = {
		Mode = data.Mode,
		NoProp = tobool(data.NoProp),
		Saved = tobool(data.Saved)
	}

	ENTITY["Door" .. name] = function(self)
		if data.Mode == DOOR_MASTER then
			return data.Get(self:GetMasterDoor())
		else
			return data.Get(self)
		end
	end

	if SERVER then
		ENTITY["SetDoor" .. name] = function(self, value, noSave)
			assert(not data.NoProp or not self:IsPropDoor(), "Attempt to set NoProp var on a prop_door_rotating")

			if data.Mode == DOOR_SEPARATE then
				data.Set(self, value)
			elseif data.Mode == DOOR_MASTER then
				data.Set(self:GetMasterDoor(), value)
			elseif data.Mode == DOOR_BOTH then
				data.Set(self, value)

				local other = self:GetOtherDoor()

				if IsValid(other) and other != self then
					data.Set(other, value)
				end
			end

			if data.Saved and not noSave then
				deferred.Call("doors.save", 60, Save)
			end
		end
	end
end

function GetAccessType(ent)
	return AccessTypes[ent:DoorType()]
end

function Iterator()
	return pairs(EntityCache.Get("doors"))
end

function ENTITY:IsDoor()
	return EntityCache.Contains("doors", self)
end

function ENTITY:IsPropDoor()
	return self:GetClass() == "prop_door_rotating"
end

function ENTITY:GetMasterDoor()
	if self:IsPropDoor() then
		local owner = self:GetOwner()

		return IsValid(owner) and owner or self
	end

	return self
end

function ENTITY:GetOtherDoor()
	if self:IsPropDoor() then
		local owner = self:GetOwner()

		return IsValid(owner) and owner or self:GetNWEntity("DoorChild", NULL)
	end

	return self
end

function ENTITY:DoorAutoCloses()
	return self:DoorAutoClose() == -1
end

if SERVER then
	function ENTITY:DoorGroupCall(func, ...)
		local group = self:DoorGroup()

		if #group > 0 then
			for ent in Iterator() do
				if ent:DoorGroup() == group then
					func(ent, ...)
				end
			end
		else
			func(self, ...)
		end
	end

	function ENTITY:ResetDoor(initial)
		for key, data in pairs(Vars) do
			if key == "Usable" then
				continue
			end

			if door.IsProp(self) and data.NoProp then
				continue
			end

			if initial then
				self["SetDoor" .. key](self, self.InitialValues[key])
			else
				self["SetDoor" .. key](self, self["Door" .. key](self), true)
			end
		end
	end

	function GM:OnDoorDataChanged(old, new, loaded)
		if not loaded then
			return -- We only care about this when GlobalVars are loading in.
		end

		Load()
	end

	function Load()
		local doorData = GAMEMODE:DoorData()

		for ent in Iterator() do
			local id = ent:MapCreationID()

			if id == -1 then
				continue
			end

			local initial = {}
			local data = doorData[id]

			for key in pairs(Vars) do
				initial[key] = ent["Door" .. key](ent)
			end

			if data then
				for key in pairs(Vars) do
					if data[key] then
						ent["SetDoor" .. key](ent, data[key])
					end
				end
			end

			ent.InitialValues = initial

			if not ent:IsPropDoor() then
				door.SetUsable(ent, false)
			end

			if ent:DoorStartOpen() then
				door.LockOpen(ent)
			end
		end
	end

	function Save()
		local doorData = {}

		for ent in Iterator() do
			if not ent:CreatedByMap() then
				continue
			end

			local master = door.GetMaster(ent)

			for name, data in pairs(Vars) do
				if not data.Saved then
					continue
				end

				local targetEnt = (data.Mode == DOOR_MASTER or data.Mode == DOOR_BOTH) and master or ent

				if data.Saved and targetEnt:CreatedByMap() then
					local get = targetEnt["Door" .. name](ent)
					local id = targetEnt:MapCreationID()

					if get != targetEnt.InitialValues[name] then
						if not doorData[id] then
							doorData[id] = {}
						end

						doorData[id][name] = get
					end
				end
			end
		end

		GAMEMODE:SetDoorData(doorData)
	end

	local isOpenCallbacks = {
		["prop_door_rotating"] = function(self) return self:GetInternalVariable("m_eDoorState") != 0 end,
		["func_door_rotating"] = function(self) return self:GetInternalVariable("m_toggle_state") == 0 end,
		["func_door"] = function(self) return self:GetInternalVariable("m_toggle_state") == 0 end
	}

	function UpdateOpenDoors()
		for ent in Iterator() do
			local open = isOpenCallbacks[ent:GetClass()](ent)

			if ent:IsDoorOpen() != open then
				ent:SetIsDoorOpen(open)
			end
		end
	end

	function OnUse(ply, ent)
		if not ent:IsDoor() or ent:IsPropDoor() then
			return
		end

		ply:ConCommand("-use")

		local define = GetAccessType(ent)
		local allowed, reason = define.CanAccess(ent, ply)

		if not allowed then
			define.OnAccessDenied(ent, ply, reason)

			return false
		end

		if ent:DoorLocked() then
			define.OnDoorLocked(ent, ply)

			return false
		end

		define.OnAccessGranted(ent, ply)
		define.PreUseCallback(ent, ply)

		if ent:DoorToggle() then
			ent:DoorGroupCall(door.SetOpen, ply, not ent:IsDoorOpen())
		else
			ent:DoorGroupCall(door.Open, ply)
		end

		define.PostUseCallback(ent, ply)

		return false
	end

	function EntityKeyValue(ent, key, value)
		if not ent:IsDoor() then
			return
		end

		key = string.lower(key)

		if key == "spawnflags" then
			ent:Set_DoorLocked(bit.Check(value, DOOR_SF_LOCKED), true)
			ent:Set_DoorToggle(ent:IsPropDoor() and bit.Check(value, DOOR_SF_TOGGLE_PROP) or bit.Check(value, DOOR_SF_TOGGLE), true)

			if not ent:IsPropDoor() then
				ent:Set_DoorTouchable(bit.Check(value, DOOR_SF_TOUCHABLE), true)
			end
		elseif key == "returndelay" or key == "wait" then
			ent:Set_DoorAutoClose(tonumber(value), true)
		elseif key == "speed" then
			ent:Set_DoorSpeed(tonumber(value), true)
		elseif key == "forceclosed" then
			ent:Set_DoorForceClose(tobool(value), true)
		elseif key == "dmg" then
			ent:Set_DoorDamage(tonumber(value), true)
		end
	end
end
