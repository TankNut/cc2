FLAG.Name = "Grunt"
FLAG.Team = TEAM_COVENANT

FLAG.Armor = 50

FLAG.Loadout = {"weapon_cc_hands"}

FLAG.EquipmentSlots = {
	"grunt",

	"primary",
	"secondary",
	"sidearm",
	"melee",
	"radio"
}

FLAG.RunSpeed = 130
FLAG.JumpPower = 210

FLAG.Clothing = CLOTHING_NONE

local model = Model("models/valk/haloreach/covenant/characters/grunt/grunt_player.mdl")

function FLAG:GetModelData(ply)
	return {_base = {
		Model = model,
		Skin = 1
	}}
end
