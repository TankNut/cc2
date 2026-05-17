local prefixes = {
	["sh_"] = shared,
	["cl_"] = client,
	["cc_"] = client,
	["gui_"] = client,
	["sv_"] = server
}

function GM:Include(path)
	local filename = string.Filename(path)

	for prefix, func in pairs(prefixes) do
		if string.sub(filename, 1, #prefix) == prefix then
			return func(path)
		end
	end

	return shared(path)
end

function GM:IncludeFolder(dir, entrypoint)
	file.Iterate(dir, entrypoint, "LUA", function(path)
		self:Include(path)
	end)
end

function GM:IncludeRecursive(dir, entrypoint)
	file.IterateRecursive(dir, entrypoint, "LUA", function(path)
		self:Include(path)
	end)
end

function GM:LoadContent(folder)
	Animation.RegisterFolder(folder .. "animations/")
	CharacterCreate.RegisterFolder(folder .. "chartypes/")
	CharacterFlag.RegisterFolder(folder .. "flags/")
	CharacterGen.RegisterFolder(folder .. "chargens/")
	Chat.RegisterFolder(folder .. "chat/")
	Item.RegisterFolder(folder .. "items/")
	Hud.RegisterFolder(folder .. "hud/")
	buff.RegisterFolder(folder .. "buffs/")
end

-- Loading external utilities
shared("utils/_utils.lua")

-- Constants and config module
shared("enums.lua")
shared("config.lua")

GM:IncludeFolder(engine.ActiveGamemode() .. "/gamemode/config/")
GM:IncludeFolder("cc2_config/")

ContentFolder = "cc2_content/"
DataFolder = "cc2/" .. Config.Get("InternalName") .. "/"
PluginFolder = "cc2_plugins/"

shared("core/_core.lua")

GM:LoadPlugins()
GM:Include(ContentFolder .. "_content.lua")

Loaded = true
