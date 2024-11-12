function GM:OnPlayerReady(ply)
	async.Start(function()
		PlayerVar.Load(ply)
	end)
end
