Settings.Add("KeySensitivity", {
	Name = "Key Sensitivity",
	Hint = "Determines the time window for double-tapping or short presses.",
	Private = true,
	Default = 0.4,
	Validate = {
		validate.Min(0.1),
		validate.Max(1)
	},
	Panel = "CC_Setting_Slider",
	Args = {
		Max = 1,
		Notches = 10,
		Decimals = 2
	}
}, "Controls")

Settings.Add("AutoWalk", {
	Name = "Enable Auto-walk",
	Hint = "Double-tap any movement key to continuously walk in that direction.",
	ClientOnly = true,
	Default = false,
	Validate = validate.Bool(),
	Panel = "CC_Setting_Bool"
}, "Controls")

local keymodes = {
	[KEYMODE_HOLD] = "Hold",
	[KEYMODE_TOGGLE] = "Toggle",
	[KEYMODE_SMART] = "Smart"
}

local keymodeValidate = validate.InList(table.GetKeys(keymodes))
local keymodeArgs = table.Map(keymodes, function(...) return {...} end)

local keymodeHint = [[<b>Hold:</b> Hold to activate.
<b>Toggle:</b> Press to activate, press again to release.
<b>Smart:</b> Acts as Toggle on a short press, otherwise acts as Hold.]]

Settings.Add("CrouchKeymode", {
	Name = "Crouch Behavior",
	Hint = keymodeHint,
	ClientOnly = true,
	Default = KEYMODE_HOLD,
	Validate = keymodeValidate,
	Panel = "CC_Setting_Dropdown",
	Args = keymodeArgs
}, "Controls")

Settings.Add("SprintKeymode", {
	Name = "Sprint Behavior",
	Hint = keymodeHint,
	ClientOnly = true,
	Default = KEYMODE_HOLD,
	Validate = keymodeValidate,
	Panel = "CC_Setting_Dropdown",
	Args = keymodeArgs
}, "Controls")

Settings.Add("FreelookKeymode", {
	Name = "Freelook Behavior (+walk)",
	Hint = keymodeHint,
	ClientOnly = true,
	Default = KEYMODE_HOLD,
	Validate = keymodeValidate,
	Panel = "CC_Setting_Dropdown",
	Args = keymodeArgs
}, "Controls")

Settings.Add("SmartAim", {
	Name = "Smart Aiming",
	Hint = "Toggles aiming on a short press, otherwise it acts as normal.",
	Private = true,
	Default = false,
	Validate = validate.Bool(),
	Panel = "CC_Setting_Bool"
}, "Controls")
