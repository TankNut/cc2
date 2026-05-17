Buttons.AddAccessType("default", {
	Name = "Enabled",
	Color = Color("green")
})

Buttons.AddAccessType("disabled", {
	Name = "Disabled",
	Color = Color("red"),
	CanAccess = function(ent, ply) return false end
})
