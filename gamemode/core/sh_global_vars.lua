module("GlobalVar", package.seeall)

Vars = Vars or {}
Fields = Fields or {}

function Add(name, data)
	netvar.AddGlobal(name, data)

	data = {
		Name = name,
		ServerOnly = tobool(data.ServerOnly),
		-- Database persistence
		Persist = tobool(data.Persist),
		Mode = data.Mode or GLOBALVAR_ALWAYS,
		Field = data.Field or name
	}

	Vars[name] = data

	if data.ServerOnly and CLIENT then
		return
	end

	if data.Persist then
		Fields[data.Field] = data
	end

	GM[name] = function(_, raw) return netvar.GetGlobal(name, raw) end
	GM["Set" .. name] = function(_, value, loading)
		if netvar.SetGlobal(name, value, loading) then
			return
		end

		if SERVER and data.Persist and not loading then
			Save(data, value)
		end
	end
end

if SERVER then
	function Save(var, value)
		async.Start(function()
			local map = ""

			if var.Mode == GLOBALVAR_MAP then
				map = game.GetMapOverride()
			elseif var.Mode == GLOBALVAR_MAP_NO_OVERRIDE then
				map = game.GetMap()
			end

			if value == nil then
				GAMEMODE.Database:Query("DELETE FROM `rp_globals` WHERE `Map` = :map AND `Key` = :key", {
					map = map,
					key = var.Field
				})
			else
				GAMEMODE.Database:Query("INSERT INTO `rp_globals` (`Map`, `Key`, `Value`) VALUES (:map, :key, :value) ON DUPLICATE KEY UPDATE `Value` = :value", {
					map = map,
					key = var.Field,
					value = sfs.encode(value)
				})
			end
		end)
	end

	function Load()
		local query = GAMEMODE.Database:Query("SELECT * FROM `rp_globals` WHERE `Map` IN :maps", {
			maps = {game.GetMap(), game.GetMapOverride(), ""}
		})

		for _, data in ipairs(query) do
			local var = Fields[data.Key]

			if not var then
				continue
			end

			GAMEMODE["Set" .. var.Name](GAMEMODE, sfs.decode(data.Value), true)
		end

		hook.Run("OnGlobalVarsLoaded")
	end

	function GM:OnGlobalVarsLoaded()
		Buttons.Load()
		Doors.Load()
	end
end
