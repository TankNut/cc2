PlayerVar.Add("CharID", {Default = 0})
PlayerVar.Add("CharacterList", {Default = {}, Private = true})

PlayerVar.Add("VisibleRPName", {Default = "Unconnected"})
local meta = FindMetaTable("Player")

function meta:HasCharacter()
	return self:CharID() != 0
end

function meta:HasTemporaryCharacter()
	return self:CharID() < 0
end
