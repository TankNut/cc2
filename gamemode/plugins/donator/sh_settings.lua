local function isDonator(ply)
	return ply:IsSuperAdmin() or ply:IsDonator()
end

Settings.Add("ShowDonatorBadge", {
	Name = "Show contributor badge",
	Default = true,
	Validate = validate.Bool(),
	Panel = "CC_Setting_Bool",
	-- No superadmin check because that doesn't do anything
	CanAccess = function(ply) return ply:IsDonator() end
}, "Contributor")

Settings.Add("ScoreboardTitle", {
	Name = "Scoreboard title",
	Default = "",
	Validate = {
		validate.String(),
		validate.Max(80)
	},
	Panel = "CC_Setting_Text",
	CanAccess = isDonator
}, "Contributor")

Settings.Add("ScoreboardTitleColor", {
	Name = "Scoreboard title color",
	Default = Color(255, 0, 0),
	Validate = validate.Color(),
	Panel = "CC_Setting_Color",
	CanAccess = isDonator
}, "Contributor")

Settings.Add("PhysgunColor", {
	Name = "Physics Gun color",
	Default = Color(36, 219, 255),
	Validate = validate.Color(),
	Panel = "CC_Setting_Color",
	CanAccess = isDonator
}, "Contributor")
