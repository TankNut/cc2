PlayerVar.Add("ToolTrust", {Default = TOOLTRUST_UNTRUSTED, Persist = true, DataType = TINYINT()})

function GM:GetToolTrust(ply)
	if ply:IsDeveloper() then
		return TOOLTRUST_DEVELOPER
	end

	if ply:IsAdmin() then
		return TOOLTRUST_ADMIN
	end

	return ply:ToolTrust()
end

function meta:GetToolTrust()
	return hook.Run("GetToolTrust", self)
end
