Settings.Add("Newbie", {
	Name = "Mark me as an Inexperienced Roleplayer",
	Default = true,
	Validate = validate.Bool(),
	Panel = "CC_Setting_Bool"
}, "General")

Settings.Add("UITransparency", {
	Name = "UI Transparency",
	ClientOnly = true,
	Default = 60,
	Validate = {
		validate.Min(0),
		validate.Max(100)
	},
	Panel = "CC_Setting_Slider",
	Args = {
		Max = 100,
		Notches = 20
	}
}, "General")

Settings.Add("EquipTogglesMenu", {
	Name = "Toggle the player menu when equipping items",
	Private = true,
	Default = true,
	Validate = validate.Bool(),
	Panel = "CC_Setting_Bool"
}, "General")

Settings.Add("ConfirmItemDestruction", {
	Name = "Request confirmation when destroying items",
	ClientOnly = true,
	Default = true,
	Validate = validate.Bool(),
	Panel = "CC_Setting_Bool"
}, "General")

local fonts = {
	[CHAT_FONT_DEFAULT] = "Default",
	[CHAT_FONT_LEGACY] = "Legacy",
	[CHAT_FONT_TACOSCRIPT] = "TacoScript 2"
}

local fontValidate = validate.InList(table.GetKeys(fonts))
local fontArgs = table.Map(fonts, function(...) return {...} end)

Settings.Add("ChatFont", {
	Name = "Chat Font",
	ClientOnly = true,
	Default = CHAT_FONT_DEFAULT,
	Validate = fontValidate,
	Panel = "CC_Setting_Dropdown",
	Args = fontArgs
}, "General")
