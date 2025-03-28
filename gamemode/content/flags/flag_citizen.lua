FLAG.Name = "Citizen"
FLAG.Team = TEAM_CITIZEN

FLAG.Loadout = {"weapon_cc_hands"}

FLAG.EquipmentSlots = {
	"test"
}

FLAG.UseClothing = true

util.PrecacheModel("models/tnb/clothing/trp/body/male_survivor.mdl")
util.PrecacheModel("models/tnb/clothing/trp/body/female_survivor.mdl")

function FLAG:GetModelData(ply, addClothing)
	local mdl = ply:CharacterModel()
	local appearance = {
		_base = {
			Model = mdl,
			Skin = ply:CharacterSkin()
		}
	}

	if addClothing then
		appearance.Body = {
			Model = string.format("models/tnb/clothing/trp/body/%s_survivor.mdl", util.GetModelGender(mdl))
		}
	end

	return appearance
end
