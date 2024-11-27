function GM:OnPlayerReady(ply)
	async.Start(function()
		PlayerVar.Load(ply)
		GlobalVar.Sync(ply)
	end)
end
