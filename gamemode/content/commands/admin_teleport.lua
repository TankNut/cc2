local goTo = console.AddCommand("rpa_goto", function(ply, target)
	ply:SetPos(target)

	Log.Write("admin_teleport_goto", ply, target)
end)

goTo:SetCategory("Teleport Commands")
goTo:SetChatAlias("goto")
goTo:SetDescription("Teleports yourself to another player on the server")
goTo:SetExecutionContext(console.Server)
goTo:SetAccess(console.IsAdmin)
goTo:SetNoConsole()

goTo:AddParameter(console.Player({NoSelfTarget = true}))





local bring = console.AddCommand("rpa_bring", function(ply, target)
	target:SetPos(ply:GetPos())

	Log.Write("admin_teleport_bring", ply, target)
end)

bring:SetCategory("Teleport Commands")
bring:SetChatAlias("bring")
bring:SetDescription("Teleports another player on the server to yourself")
bring:SetExecutionContext(console.Server)
bring:SetAccess(console.IsAdmin)
bring:SetNoConsole()

bring:AddParameter(console.Player({NoSelfTarget = true}))





local send = console.AddCommand("rpa_send", function(ply, target, to)
	target:SetPos(to)

	Log.Write("admin_teleport_send", ply, target, to)
end)

send:SetCategory("Teleport Commands")
send:SetChatAlias("send")
send:SetDescription("Teleport players to another")
send:SetExecutionContext(console.Server)
send:SetAccess(console.IsAdmin)

send:AddParameter(console.Player())
send:AddParameter(console.Player())





local teleport = console.AddCommand("rpa_teleport", function(ply, target)
	target:SetPos(ply:GetEyeTrace().HitPos)

	Log.Write("admin_teleport_look", ply, target)
end)

teleport:SetCategory("Teleport Commands")
teleport:SetChatAlias("teleport")
teleport:SetDescription("Teleports a player to the point you're looking at")
teleport:SetExecutionContext(console.Server)
teleport:SetAccess(console.IsAdmin)
teleport:SetNoConsole()

teleport:AddParameter(console.Player())
