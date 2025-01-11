local meta = FindMetaTable("Player")

CharacterVar.Add("CharacterMoney", {
	Default = 0,
	Private = true,
	Field = "Money",
	DataType = INT()
})

function meta:GetMoney()
	return self:CharacterMoney()
end

function meta:HasMoney(amt)
	return self:CharacterMoney() >= amt
end

function meta:AddMoney(amt)
	self:SetMoney(self:CharacterMoney() + amt)
end

function meta:SetMoney(amt)
	self:SetCharacterMoney(math.max(amt, 0))
end
