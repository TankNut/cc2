local restart = console.AddCommand("rpa_restart", function(ply)
	GAMEMODE:WriteLog("admin_restart", {Admin = GAMEMODE:LogPlayer(ply)})
	GAMEMODE:SendChat(nil, player.GetAll(), "ERRORBIG", console.FormatMessage("%s is restarting the server in 5 seconds", ply))

	timer.Simple(5, function()
		game.ConsoleCommand("changelevel " .. game.GetMap() .. "\n")
	end)
end)

restart:SetDescription("Restarts the server on the current map")
restart:SetExecutionContext(console.Server)
restart:SetAccess(console.IsAdmin)
