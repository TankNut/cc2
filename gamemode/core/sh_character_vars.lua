module("CharacterVar", package.seeall)

Vars = Vars or {}
Store = Store or {}

local PLAYER = FindMetaTable("Player")

function Add(name, data)
	local databaseType = data.DataType or BLOB()

	netvar.Add(name, data)

	data = {
		Name = name,
		-- Database persistence
		Persist = true,
		Field = data.Field or name,
		DataType = databaseType.DataType,
		Validate = data.Validate or databaseType.Validate,
		Encode = data.Encode or databaseType.Encode,
		Decode = data.Decode or databaseType.Decode,
		DatabaseIndex = tobool(data.DatabaseIndex)
	}

	Vars[name] = data

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

		if SERVER and not loading then
			Save(ply:CharID(), data, value)
		end
	end
end

if SERVER then
	function Save(id, var, value)
		if id == 0 then
			return
		end

		async.Start(function()
			if value == nil then
				value = NULL
			elseif var.Encode then
				value = var.Encode(value)
			end

			GAMEMODE.Database:Query(string.format("UPDATE `rp_characters` SET `%s` = :value WHERE `id` = :id", var.Field), {
				value = value,
				id = id
			})
		end)
	end
end
