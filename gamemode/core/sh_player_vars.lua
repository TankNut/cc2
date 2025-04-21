module("PlayerVar", package.seeall)

Vars = Vars or {}
Fields = Fields or {}

local PLAYER = FindMetaTable("Player")

function Add(name, data)
	local databaseType = data.DataType or BLOB()

	netvar.Add(name, data)

	data = {
		Name = name,
		-- Database persistence
		Persist = tobool(data.Persist),
		Field = data.Field or name,
		DataType = databaseType.DataType,
		Validate = data.Validate or databaseType.Validate,
		Encode = data.Encode or databaseType.Encode,
		Decode = data.Decode or databaseType.Decode,
		DatabaseIndex = tobool(data.DatabaseIndex)
	}

	Vars[name] = data

	if data.Persist then
		Fields[data.Field] = data
	end

	if data.ServerOnly and CLIENT then
		return
	end

	local validation = data.Validate

	PLAYER[name] = function(ply, raw) return netvar.Get(ply, name, raw) end
	PLAYER["Set" .. name] = function(ply, value, loading)
		if validation and value != nil and not validation(value) then
			error(string.format("Set value '%s' doesn't match database type %s", value, data.DataType), 2)
		end

		if netvar.Set(ply, name, value, loading) then
			return
		end

		if SERVER and data.Persist and not loading then
			Save(ply:SteamID(), data, value)
		end
	end
end

if SERVER then
	function GetOffline(steamid, name)
		local ply = player.GetBySteamID(steamid)

		if ply then
			return ply[name](ply)
		end

		local data = assert(Vars[name], name .. " is not a valid player var")
		local value = GAMEMODE.Database:Query(string.format("SELECT `%s` FROM `rp_players` WHERE `SteamID` = :steamId", data.Field), {
			steamId = steamid
		})

		if value then
			value = value[data.Field]
		else
			return util.SafeCopy(data.Default)
		end

		return data.Decode and data.Decode(value) or value
	end

	function SetOffline(steamid, name, value)
		local ply = player.GetBySteamID(steamid)

		if ply then
			ply["Set" .. name](ply, value)

			return
		end

		local data = assert(Vars[name], name .. " is not a valid player var")

		local default = data.Default
		local persist = assert(data.Persist, "Cannot SetOffline non-persist player vars")
		local dataType = data.DataType
		local validation = data.Validate

		if not persist then
			return
		end

		if value == default then value = nil end

		if validation and value != nil and not validation(value) then
			error(string.format("Set value '%s' doesn't match database type %s", value, dataType), 2)
		end

		Save(steamid, data, value)
	end

	function Save(steamid, var, value)
		async.Start(function()
			if value == nil then
				value = NULL
			elseif var.Encode then
				value = var.Encode(value)
			end

			GAMEMODE.Database:Query(string.format("UPDATE `rp_players` SET `%s` = :value WHERE `SteamID` = :steamId", var.Field), {
				value = value,
				steamId = steamid
			})
		end)
	end

	function Load(ply)
		local steamid = ply:SteamID()

		GAMEMODE.Database:Query("INSERT IGNORE INTO `rp_players` (`SteamID`) VALUES (:steamId)", {steamId = steamid})

		local data = GAMEMODE.Database:Query("SELECT * FROM `rp_players` WHERE `SteamID` = :steamId", {steamId = steamid})[1]

		for field, value in pairs(data) do
			local var = Fields[field]

			if not var then
				continue
			end

			if var.Decode then
				value = var.Decode(value)
			end

			ply["Set" .. var.Name](ply, value, true)
		end

		hook.Run("OnPlayerVarsLoaded", ply)
	end

	function GM:OnPlayerVarsLoaded(ply)
	end
end
