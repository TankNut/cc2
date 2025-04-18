module("EntityVar", package.seeall)

local ENTITY = FindMetaTable("Entity")

function Add(name, data, metatable)
	metatable = metatable or "Entity"

	local meta = assert(FindMetaTable(metatable), "Attempt to add an entity var to nil metatable " .. metatable)

	if meta != ENTITY then
		assert(meta.MetaBaseClass == ENTITY, "Attempt to add an entity var to non-entity metatable " .. metatable)
	end

	netvar.Add(name, data)

	if data.ServerOnly and CLIENT then
		return
	end

	meta[name] = function(ent, raw) return netvar.Get(ent, name, raw) end
	meta["Set" .. name] = function(ent, value, loading)
		netvar.Set(ent, name, value, loading)
	end
end
