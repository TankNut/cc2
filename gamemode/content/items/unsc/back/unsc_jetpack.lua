ITEM.Base = "base_unsc_clothing"

ITEM.Name = "Series 8 SOLA Pack"
ITEM.Description = "The Series 8 Single Operator Lift Apparatus is a back-mounted, user-operated jump-jet system designed for quick repositioning during tactical movement."
ITEM.Rarity = RARITY_EPIC

ITEM.Category = "UNSC Backpack"

ITEM.Weight = 12

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
					Backpacks = 4
				}
			}
		}
	end
end
