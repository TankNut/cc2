FLAG.Name = "Artifical Intelligence"
FLAG.Team = TEAM_AI

FLAG.Loadout = {"weapon_cc_hands"}

-- Letting AI's use UNSC appearances by default
FLAG.EquipmentSlots = {
	"unsc_headwear",
	"unsc_back",
	"unsc_armor",
	"unsc_undersuit"
}

FLAG.Clothing = CLOTHING_FULL

function FLAG:GetModelData(ply)
	return {_base = {
		Model = ply:CharacterModel(),
		Skin = ply:CharacterSkin()
	}}
end

function FLAG:PostModelData(ply, data, hasOverride)
	data._base.Materials = "models/effects/hologram"
end
