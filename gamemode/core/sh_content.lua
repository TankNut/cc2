local folderEntrypoints = {
	["/cl_init.lua"] = client,
	["/shared.lua"] = shared,
	["/init.lua"] = server
}

function GM:LoadEntities(folder)
	local files, folders = file.Find(folder .. "*", "LUA")

	for _, path in ipairs(files) do
		if string.GetExtensionFromFilename(path) != "lua" then
			continue
		end

		local name = string.Filename(path)

		_G.ENT = {
			Folder = "entities/" .. name
		}

		shared(folder .. path)

		local t = _G.ENT
		_G.ENT = nil

		scripted_ents.Register(t, name)
	end

	for _, name in ipairs(folders) do
		_G.ENT = {
			Folder = "entities/" .. name
		}

		for filepath, func in pairs(folderEntrypoints) do
			local path = folder .. name .. filepath

			if file.Exists(path, "LUA") then
				func(path)
			end
		end

		local t = _G.ENT
		_G.ENT = nil

		scripted_ents.Register(t, name)
	end
end

function GM:LoadWeapons(folder)
	local files, folders = file.Find(folder .. "*", "LUA")

	for _, path in ipairs(files) do
		if string.GetExtensionFromFilename(path) != "lua" then
			continue
		end

		local name = string.Filename(path)

		_G.SWEP = {
			Folder = "weapons/" .. name
		}

		shared(folder .. path)

		local t = _G.SWEP
		_G.SWEP = nil

		weapons.Register(t, name)
	end

	for _, name in ipairs(folders) do
		_G.SWEP = {
			Folder = "weapons/" .. name
		}

		for filepath, func in pairs(folderEntrypoints) do
			local path = folder .. name .. filepath

			if file.Exists(path, "LUA") then
				func(path)
			end
		end

		local t = _G.SWEP
		_G.SWEP = nil

		weapons.Register(t, name)
	end
end

function GM:LoadEffects(folder)
	local files = file.Find(folder .. "*.lua", "LUA")

	for _, path in ipairs(files) do
		local name = string.Filename(path)

		if CLIENT then
			_G.EFFECT = {
				Folder = "effects/" .. name
			}

			include(folder .. path)

			local t = _G.EFFECT
			_G.EFFECT = nil

			effects.Register(t, name)
		else
			AddCSLuaFile(folder .. path)
		end
	end
end

function GM:RegisterContent(folder)
	Animation.RegisterFolder(folder .. "animations/")
	CharacterCreate.RegisterFolder(folder .. "chartypes/")
	CharacterFlag.RegisterFolder(folder .. "flags/")
	CharacterGen.RegisterFolder(folder .. "chargens/")
	Chat.RegisterFolder(folder .. "chat/")
	Item.RegisterFolder(folder .. "items/")
	Hud.RegisterFolder(folder .. "hud/")
	buff.RegisterFolder(folder .. "buffs/")

	self:LoadEntities(folder .. "entities/")
	self:LoadWeapons(folder .. "weapons/")
	self:LoadEffects(folder .. "effects/")
end
