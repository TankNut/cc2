GM.VarSyncCache = GM.VarSyncCache or {}

function GM:Think()
	self.BaseClass:Think()

	-- Legacy code
	self:MusicThink()
	self:CreateParticleEmitters()
	self:ToggleHolsterThink()
	self:DrugThink()

	self:CharCreateThink()

	if GetConVarNumber("physgun_wheelspeed") > 20 then
		RunConsoleCommand("physgun_wheelspeed", "20")
	end

	for _, v in pairs(player.GetAll()) do
		hook.Run("PlayerThink", v)
	end
	-- Legacy code ends

	if #self.VarSyncCache > 0 then
		netstream.Send("RequestEntityVars", self.VarSyncCache)

		table.Empty(self.VarSyncCache)
	end
end
