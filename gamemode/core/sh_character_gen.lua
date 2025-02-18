module("CharacterGen", package.seeall)

List = List or {}

local PLAYER = FindMetaTable("Player")

function Register(name, gen)
	gen.ID = name

	List[name] = inherit.Register("chargen", name, gen, gen.Base or "base")
end

function RegisterFolder(dir)
	file.Iterate(dir, "shared.lua", "LUA", function(path, folder)
		local name = string.FileName(path)

		if name == "shared" then
			name = string.FileName(folder)
		end

		_G.GENERATOR = {}

		GM:IncludeShared(path)

		Register(string.gsub(name, "^gen_", ""), GENERATOR)

		GENERATOR = nil
	end)
end

function Get(id)
	return List[id]
end

if SERVER then
	function Run(ply, id, temp)
		local generator = Get(id)
		local fields = generator:GetFields(ply)

		if temp then
			ply:CreateTempCharacter(fields)
		else
			ply:CreateCharacter(fields)
		end

		generator:PostCreateCharacter(ply)
	end

	netstream.Hook("GenCharacter", function(ply, id)
		if not ply:CanUseCharacterGenerator(id) then
			return
		end

		Run(ply, id, true)
	end)
end

function PLAYER:CanUseCharacterGenerator(id)
	return tobool(Get(id))
end

function PLAYER:GetCharacterGenerators()
	local tab = {}

	for id in SortedPairs(List) do
		if not self:CanUseCharacterType(id) then
			continue
		end

		table.insert(tab, id)
	end

	return tab
end
