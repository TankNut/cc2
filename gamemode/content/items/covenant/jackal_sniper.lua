ITEM.Base = "base_covenant"
ITEM.Category = "Jackal Armor"

ITEM.EquipmentSlots = {"jackal"}

if SERVER then
	function ITEM:GetModelData(ply, clothing)
		if not self:IsEquipped() then
			return
		end

		return {
			_base = {
				Bodygroups = {
					Mask = 0
				}
			}
		}
	end
end
