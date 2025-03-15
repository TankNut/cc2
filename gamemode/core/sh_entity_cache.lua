module("EntityCache", package.seeall)

Defines = Defines or {}
List = List or {}

function Add(name, func)
	Defines[name] = func

	if not List[name] then
		List[name] = {}
	end
end

function Get(name)
	return assert(List[name], "No entity cache with name '" .. name .. "' exists")
end

function OnCreated(ent)
	for name, func in pairs(Defines) do
		if func(ent) then
			List[name][ent] = true
		end
	end
end

function OnRemoved(ent)
	for _, entities in pairs(List) do
		entities[ent] = nil
	end
end
