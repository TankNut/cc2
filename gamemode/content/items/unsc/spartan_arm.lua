ITEM.Name = "MJOLNIR Prosthetic Arm"
ITEM.Description = "An artificial limb used to replace a spartan's missing right arm."
ITEM.Rarity = RARITY_LEGENDARY

ITEM.Category = "Spartan"

ITEM.Model = Model("models/rena_haloreach/crate_packing.mdl")

ITEM.IconAngle = Angle(30, 27, 0)
ITEM.IconFOV = 35

ITEM.Weight = 2

ITEM.EquipmentSlots = {"spartan_arm"}

if SERVER then
	function ITEM:GetModelData(ply, clothing)
		if not self:IsEquipped() then
			return
		end

		return {
			_base = {
				Bodygroups = {
					Arm = 1
				}
			}
		}
	end
end
