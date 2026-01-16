local BaseClass = inherit.Get("item", "base_medical")

ITEM.Base = "base_medical"

ITEM.Name = "Medical Kit"
ITEM.Description = "A standard UNSC first aid kit containing various medical supplies. Can stabilize even the most grievous of wounds as long as the patient gets some rest."
ITEM.Rarity = RARITY_UNCOMMON

ITEM.Model = Model("models/ishi/halo_rebirth/props/human/health_kit.mdl")

ITEM.Weight = 2

ITEM.IconAngle = Angle(50, 0, 0)
ITEM.IconFOV = 18

ITEM.CanSelfApply = true
ITEM.SelfApplyTime = 5

ITEM.CanApply = true
ITEM.ApplyTime = 2

function ITEM:CanTarget(ply)
	if not BaseClass.CanTarget(self, ply) then
		return false
	end

	return ply:Health() < ply:GetMaxHealth()
end

if SERVER then
	function ITEM:OnStartApply(ply, target)
		local message = ply == target and
			string.format("%s starts to tend to their own wounds with a %s...", ply:VisibleRPName(), self:GetName(true)) or
			string.format("%s starts to perform first aid on %s with a %s...", ply:VisibleRPName(), target:VisibleRPName(), self:GetName(true))

		ply:VisibleMessage("NOTICE", message)
	end

	function ITEM:OnApply(ply, target)
		local message = ply == target and
			string.format("%s finishes tending to their own wounds with a %s", ply:VisibleRPName(), self:GetName(true)) or
			string.format("%s finishes tending to %s's wounds with a %s", ply:VisibleRPName(), target:VisibleRPName(), self:GetName(true))

		ply:VisibleMessage("NOTICE", message)

		target:AddBuff("regen")

		self:AddAmount(-1)
	end
end
