ITEM.Base = "base_covenant"
ITEM.Category       = "Skirmisher Armor"

ITEM.EquipmentSlots = {"skirmisher"}

ItemDataFunc("SkirmisherModel", Model("models/halo_reach/characters/players/covenant/skirmisher_major.mdl"))
ItemDataFunc("SkirmisherColor", Color(140, 60, 40))

if SERVER then
	function ITEM:GetModelData(ply, clothing)
		if not self:IsEquipped() then
			return
		end

		return {
			_base = {
				Model = self:GetSkirmisherModel(),
				Color = self:GetSkirmisherColor()
			}
		}
	end
end
