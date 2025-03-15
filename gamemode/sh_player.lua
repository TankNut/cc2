local PLAYER = FindMetaTable("Player")

GM.PlayerAccessors = {
	{"Holstered", 			false, 	"Bit", 		true},
	{"InAttack2",			false,	"Bit",		false},
	{"PropProtection",		true,	"Table",	{}},
	{"RagdollIndex",		false,	"Float",	-1}
}

for k, v in pairs(GM.PlayerAccessors) do
	local name, private, vartype, default = v[1], v[2], v[3], v[4]

	PLAYER["Set" .. name] = function(ply, val, force)
		if val == nil then
			return
		end

		if SERVER then
			if ply[name .. "Val"] == val and vartype != "Table" and not force then
				return
			end

			ply[name .. "Val"] = val

			hook.Run("On" .. name .. "Changed", ply, val)

			if private then
				if ply:IsBot() then
					return
				end

				net.Start("nSet" .. name)
					net["Write" .. vartype](val)
				net.Send(ply)
			else
				net.Start("nSet" .. name)
					net.WriteEntity(ply)
					net["Write" .. vartype](val)
				net.Broadcast()
			end
		end

		if CLIENT then
			if vartype == "Bit" then
				val = tobool(val)
			end

			ply[name .. "Val"] = val
		end

		return val
	end

	PLAYER[name] = function(ply)
		if ply[name .. "Val"] == nil then
			return default
		end

		if ply[name .. "Val"] == false then
			return false
		end

		return ply[name .. "Val"]
	end

	if SERVER then
		util.AddNetworkString("nSet" .. name)
	end

	if CLIENT then
		net.Receive("nSet" .. name, function()
			local ply
			local val

			if private then
				ply = LocalPlayer()
				val = net["Read" .. vartype]()

				if vartype == "Bit" then
					val = tobool(val)
				end

				LocalPlayer()[name .. "Val"] = val
			else
				ply = net.ReadEntity()
				val = net["Read" .. vartype]()

				if vartype == "Bit" then
					val = tobool(val)
				end

				ply[name .. "Val"] = val
			end

			if IsValid(ply) then
				hook.Run("On" .. name .. "Changed", ply, val)
			end
		end)
	end
end

function PLAYER:SyncAllData(ply)
	for _, v in pairs(GAMEMODE.PlayerAccessors) do
		local name, private, vartype = v[1], v[2], v[3]

		if not private then

			net.Start("nSet" .. name)
				net.WriteEntity(self)
				net["Write" .. vartype](self[name](self))
			if ply then
				net.Send(ply)
			else
				net.Broadcast()
			end
		end
	end
end

function PLAYER:SyncAllOtherData()
	for _, v in player.Iterator() do

		if v != self then

			for _, n in pairs(GAMEMODE.PlayerAccessors) do

				if not n[2] then

					net.Start("nSet" .. n[1])
						net.WriteEntity(v)
						net["Write" .. n[3]](v[n[1]](v))
					net.Send(self)

				end

			end

		end

	end
end

net.Receive("nRequestPlayerData", function(len, ply)
	if CLIENT then return end

	local ent = net.ReadEntity()
	if not ent or not ent:IsValid() then return end

	ent:SyncAllData(ply)
end)

net.Receive("nRequestAllPlayerData", function(len, ply)
	if CLIENT then return end

	if not ply.NextSyncPlayerData then ply.NextSyncPlayerData = 0 end

	if CurTime() < ply.NextSyncPlayerData then return end

	ply.NextSyncPlayerData = CurTime() + 1

	ply:SyncAllOtherData()
end)

function GM:FreezePlayer(ply, time)
	ply.FreezeTime = math.max(ply.FreezeTime or 0, CurTime() + time)
end

function GM:Move(ply, move)
	if not ply:HasCharacter() then
		return true
	end

	if ply.FreezeTime and CurTime() < ply.FreezeTime then
		move:SetMaxSpeed(0)
		move:SetMaxClientSpeed(0)
		move:SetVelocity(Vector())
	end

	local func = ply:RunCharFlag("Move")

	if func then
		func(ply, move)
	end

	return self.BaseClass:Move(ply, move)
end

function GM:SetupMove(ply, move)
	if ply.FreezeTime and CurTime() < ply.FreezeTime then
		move:SetMaxSpeed(0)
		move:SetMaxClientSpeed(0)
		move:SetVelocity(Vector())
	end

	return self.BaseClass:SetupMove(ply, move)
end
