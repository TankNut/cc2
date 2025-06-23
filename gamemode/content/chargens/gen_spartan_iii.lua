GENERATOR.Name = "UNSC/Spartan-III"

local names = {
	"Spartan-III/Masculine",
	"Spartan-III/Feminine",
	"Spartan-III/Unisex"
}

function GENERATOR:GetFields(ply)
	return {
		CharacterName = CharacterCreate.GetRandomName(table.Random(names)),
		CharacterDescription = string.format([[A height between 5'2 - 6'2, [blank] accent, ect ect]]),
		Languages = Language.GetDefaultLanguages()
	}
end

function GENERATOR:PostCreateCharacter(ply)
	ply:SetCharacterFlag("spartan")

	local armor = ply:GiveItem("spartan")

	armor:Randomize()
	armor:SetEquipmentSlot("spartan")
end
