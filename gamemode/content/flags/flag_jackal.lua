FLAG.Name = "Jackal"
FLAG.Team = TEAM_COVENANT

FLAG.Armor = 100

FLAG.Loadout = {"weapon_cc_hands"}

FLAG.EquipmentSlots = {
	"jackal",

	"primary",
	"secondary",
	"sidearm",
	"melee",
	"radio"
}

FLAG.Clothing = CLOTHING_NONE

FLAG.RunSpeed = 250
FLAG.JumpPower = 200

FLAG.NoFallDamage = true
FLAG.OmniSprint = true
FLAG.SprintFiring = true

local model = Model("models/halo_reach/characters/players/covenant/jackal_sniper.mdl")

function FLAG:GetModelData(ply)
	return {_base = {
		Model = model,
		Color = Color(100, 110, 140),
		Bodygroups = {
			Mask = 1
		}
	}}
end
