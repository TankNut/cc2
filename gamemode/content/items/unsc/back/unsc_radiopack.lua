ITEM.Base = "base_unsc_clothing"

ITEM.Name = "Radio Pack"
ITEM.Description = "A portable long-range radio."
ITEM.Rarity = RARITY_RARE

ITEM.Category = "UNSC Backpack"

ITEM.Weight = 6

ITEM.EquipmentSlots = {"unsc_back"}
ITEM.ModelGroups = {"Marine", "ODST", "Insurrection"}

if SERVER then
	function ITEM:GetModelData(ply, clothing)
		if not self:IsEquipped() then
			return
		end

		return {
			_base = {
				Bodygroups = {
					Backpacks = 3
				}
			}
		}
	end
end
