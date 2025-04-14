local GENERATOR = {}

GENERATOR.Name = "Unnamed Character Generator"

function GENERATOR:GetFields(ply)
	return {}
end

function GENERATOR:PostCreateCharacter(ply)
end

inherit.Register("chargen", "base", GENERATOR)
