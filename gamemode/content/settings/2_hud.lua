Settings.Add("EnableThirdperson", {
	Name = "Enable Thirdperson",
	ClientOnly = true,
	Default = false,
	Validate = validate.Bool(),
	Panel = "CC_Setting_Bool"
}, "HUD")

Settings.Add("EnableHUD", {
	Name = "Enable HUD",
	ClientOnly = true,
	Default = true,
	Validate = validate.Bool(),
	Panel = "CC_Setting_Bool"
}, "HUD")

hook.Add("OnEnableThirdpersonSettingChanged", "settings.hud.EnableThirdperson", function(ply, old, new)
	if new and ply:Alive() then
		ctp:Enable()
	else
		ctp:Disable()
	end
end)
