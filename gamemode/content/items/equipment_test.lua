ITEM.Model = Model("models/nova/w_headcrab.mdl")

ITEM.Weight = 1

ITEM.EquipmentSlots = {
	"test"
}

ITEM.Armor = 50
ITEM.Buffs = {
	"nofalldamage"
}

ITEM.IconAngle = Angle(-80, -175, 90)
ITEM.IconFOV = 14

function ITEM:GetModelData(ply, addClothing)
	if not self:IsEquipped() or not addClothing then
		return
	end

	return {
		Head = {
			Model = Model("models/nova/w_headcrab.mdl")
		}
	}
end
