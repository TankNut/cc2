GlobalVar.Add("GlobalLua", {
	Default = "",
	Persist = true
})

GlobalVar.Add("MapLua", {
	Default = "",
	Persist = true,
	Mode = GLOBALVAR_MAP_NO_OVERRIDE
})

function GM:OnGlobalLuaChanged(old, new, loaded)
	if new == "" then
		return
	end

	CompileString(new, "cc2.GlobalLua")()
end

function GM:OnMapLuaChanged(old, new, loaded)
	if new == "" then
		return
	end

	CompileString(new, "cc2.MapLua")()
end

if SERVER then
	netstream.Hook("DevEditorSubmit", function(ply, code, map)
		if Access.SecureDeveloper(ply, "DevEditor") then
			return
		end

		if map == nil then
			GAMEMODE:SetGlobalLua(code)
		elseif map == game.GetMap() then
			GAMEMODE:SetMapLua(code)
		else
			local query

			if code == "" then
				query = GAMEMODE.Database:Delete("rp_globals")

				query:WhereEqual("Map", map)
				query:WhereEqual("Key", "MapLua")
			else
				query = GAMEMODE.Database:Upsert("rp_globals")

				query:Insert("Map", map)
				query:Insert("Key", "MapLua")
				query:Insert("Value", sfs.encode(code))
			end

			query:Execute()
		end
	end)
end
