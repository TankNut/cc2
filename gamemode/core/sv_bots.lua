hook.Add("StartCommand", "bot", function(bot, cmd)
	if bot:IsBot() and not bot:Alive() then
		cmd:SetButtons(IN_JUMP)
	end
end)

hook.Add("PlayerSpawn", "bot", function(_, ply)
	if ply:IsBot() and not ply:HasCharacter() then
		async.Start(CharacterGen.Run, ply, Config.Get("BotGenerator"), true)
	end
end, POST_HOOK)

hook.Add("PlayerDisconnected", "bot", function(ply)
	if ply:IsBot() and ply:HasCharacter() then
		async.Start(Character.Delete, ply:CharID())
	end
end)
