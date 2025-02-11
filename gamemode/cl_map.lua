GM.ConnectMessages = {}
GM.EntryPortSpawns = {}

local files = file.Find(GM.FolderName .. "/gamemode/maps/" .. game.GetMapOverride() .. ".lua", "LUA", "namedesc")

if #files > 0 then
	for _, v in pairs(files) do
		include("maps/" .. v)
	end

	MsgC(Color(200, 200, 200, 255), "Clientside map lua file for " .. game.GetMapOverride() .. " loaded.\n")
else
	MsgC(Color(200, 200, 200, 255), "Warning: No clientside map lua file for " .. game.GetMapOverride() .. ".\n")
end

if not GM.CurrentLocation then
	GM.CurrentLocation = LOCATION_CITY
end
