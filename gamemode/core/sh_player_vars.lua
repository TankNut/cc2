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

	local validate = data.Validate

	PLAYER[name] = function(ply, raw) return netvar.Get(ply, name, raw) end
	PLAYER["Set" .. name] = function(ply, value, loading)
		if validate and value != nil and not validate(value) then
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

		local query = GAMEMODE.Database:Select("rp_players")
			query:Select(data.Field)
			query:WhereEqual("SteamID", steamid)
		local value = query:Execute()[1]

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
		local validate = data.Validate

		if not persist then
			return
		end

		if value == default then value = nil end

		if validate and value != nil and not validate(value) then
			error(string.format("Set value '%s' doesn't match database type %s", value, dataType), 2)
		end

		Save(steamid, data, value)
	end

	function Save(steamid, var, value)
		async.Start(function()
			local query = GAMEMODE.Database:Upsert("rp_players")
				query:Insert("SteamID", steamid)

			if value == nil then
				query:InsertRaw(var.Field, "NULL")
			else
				value = var.Encode and var.Encode(value) or value

				query:Insert(var.Field, value)
			end

			query:Execute()
		end)
	end

	function Load(ply)
		local steamid = ply:SteamID()
		local query

		query = GAMEMODE.Database:InsertIgnore("rp_players")
			query:Insert("SteamID", steamid)
		query:Execute()

		query = GAMEMODE.Database:Select("rp_players")
			query:WhereEqual("SteamID", steamid)
		local data = query:Execute()[1]

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
