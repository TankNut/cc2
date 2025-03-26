Settings.Add("ToggleCrouch", {
	Name = "Toggle Crouch",
	ClientOnly = true,
	Default = false,
	Validate = validate.Bool(),
	Panel = "CC_Setting_Bool"
}, "Gameplay")

Settings.Add("ToggleSprint", {
	Name = "Toggle Sprint",
	ClientOnly = true,
	Default = false,
	Validate = validate.Bool(),
	Panel = "CC_Setting_Bool"
}, "Gameplay")
