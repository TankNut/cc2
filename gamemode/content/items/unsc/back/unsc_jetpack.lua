ITEM.Base = "base_unsc_clothing"

ITEM.Name           = "Series 8 SOLA Pack"
ITEM.Description    = "A light assault pack for carrying combat gear"

ITEM.Rarity         = RARITY_EPIC
ITEM.Category       = "UNSC Backpack"

ITEM.Weight         = 12

ITEM.EquipmentSlots = {"unsc_back"}

ITEM.ModelGroups 	= {"Marine", "ODST", "Insurrection"}

if SERVER then
	function ITEM:GetModelData(ply, clothing)
		if not self:IsEquipped() then
			return
		end

		return {
			_base = {
				Bodygroups = {
					Backpacks = 4
				}
			}
		}
	end
end
