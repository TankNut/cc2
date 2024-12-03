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
		Hull.Clear(ent)
	end
end

if SERVER then
	netstream.Hook("RequestEntityVars", function(ply, entities)
		for _, ent in ipairs(entities) do
			if not IsValid(ent) then
				continue
			end

			if ent:IsPlayer() then
				PlayerVar.Sync(ent, ply)
				CharacterVar.Sync(ent, ply)
			end
		end
	end)
end
