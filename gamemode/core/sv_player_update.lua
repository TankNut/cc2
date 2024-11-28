local meta = FindMetaTable("Player")

-- This might change later but for now I'm just stuffing all the generic 'recalculate this' functions into one file to ease my suffering

function meta:UpdateVisibleName()
	local name

	if #ply:NameOverride() > 0 then
		name = ply:NameOverride()
	end

	ply:SetVisibleRPName(name or ply:RunCharFlag("VisibleRPName"))
end
