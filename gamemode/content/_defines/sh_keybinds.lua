Binds.Add("ToggleHud", "Toggle Hud", KEY_NONE, function(ply)
	if SERVER or not IsFirstTimePredicted() then
		return
	end

	Settings.Set("Hud", not Settings.Get("Hud"))
end, "<b>Console Command:</b> rp_togglehud")

Binds.Add("ToggleHolster", "Holster/Unholster Weapon", KEY_B, function(ply)
	local weapon = ply:GetActiveWeapon()

	if weapon:IsType("weapon_cc_base") then
		weapon:ToggleHolster()
	end
end)

Binds.Add("Thirdperson", "Toggle Thirdperson", KEY_NONE, function(ply)
	if SERVER or not IsFirstTimePredicted() then
		return
	end

	Settings.Set("Thirdperson", not Settings.Get("Thirdperson"))
end, "<b>Console Command:</b> rp_thirdperson")
