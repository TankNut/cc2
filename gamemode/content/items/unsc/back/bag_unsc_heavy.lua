ITEM.Base = "bag_unsc_light"

ITEM.Name = "Backpack (Heavy)"
ITEM.Description = "A sizeable backpack with room for several days worth of supplies."

ITEM.BaseWeight = 4
ITEM.MaxWeight = 20

if SERVER then
	function ITEM:GetModelData(ply, clothing)
		if not self:IsEquipped() then
			return
		end

		return {
			_base = {
				Bodygroups = {
					Backpacks = 2
				}
			}
		}
	end
end
