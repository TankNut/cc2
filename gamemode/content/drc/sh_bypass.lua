if CLIENT then
	local disableList = {
		"drc_PlayerWeaponColours",
		"drc_ReflectionTint_WeaponColour"
	}

	for _, name in ipairs(disableList) do
		matproxy.Add({
			name = name,
			init = function() end,
			bind = function() end
		})
	end
else
	-- DRC shields are broken
	function DRC:SetShieldInfo() end
end
