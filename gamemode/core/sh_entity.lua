function GM:InitPostEntity()
	-- Legacy code
	hook.Run("CC.SH.InitEnts")

	if CLIENT then
		net.Start("nRequestPData")
		net.SendToServer()

		return
	end
	-- Legacy code ends

	hook.Run("LoadDatabase")
end

function GM:OnEntityCreated(ent)
	if CLIENT and ent:EntIndex() > 0 then
		table.insert(self.VarSyncCache, ent)
	end
end

function GM:EntityRemoved(ent, fullUpdate)
	if SERVER then
		self:LegacyEntityRemoved(ent)
	end

	if ent:IsPlayer() and not fullUpdate then
		PlayerVar.Clear(ent)
		CharacterVar.Clear(ent)
	end
end
