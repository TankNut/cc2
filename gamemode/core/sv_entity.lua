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
