local BaseClass = inherit.Get("item", "base_medical")

ITEM.Base = "base_medical"

ITEM.Name = "Biofoam Canister"
ITEM.Description = "A single-use canister of biofoam, acts as a temporary sealant to help keep damaged organs in place and to stop bleeding. For best results, inject directly into the wound."
ITEM.Rarity = RARITY_UNCOMMON

ITEM.Model = Model("models/valk/h3odst/unsc/props/biofoam/biofoam.mdl")

ITEM.Weight = 1

ITEM.IconAngle = Angle(0, 160, 90)
ITEM.IconFOV = 10

ITEM.CanSelfApply = true
ITEM.SelfApplyTime = 5

ITEM.CanApply = true
ITEM.ApplyTime = 1

function ITEM:CanTarget(ply)
	if not BaseClass.CanTarget(self, ply) then
		return false
	end

	return ply:Health() < math.Round(ply:GetMaxHealth() * 0.6)
end

if SERVER then
	function ITEM:OnStartApply(ply, target)
		local message = ply == target and
			string.format("%s jabs themselves with a %s...", ply:VisibleRPName(), self:GetName(true)) or
			string.format("%s jabs a %s into %s's wounds...", ply:VisibleRPName(), self:GetName(true), target:VisibleRPName())

		ply:VisibleMessage("NOTICE", message)
	end

	function ITEM:OnApply(ply, target)
		local message = ply == target and
			string.format("%s injects themselves with a %s", ply:VisibleRPName(), self:GetName(true)) or
			string.format("%s injects %s's wounds with a %s", ply:VisibleRPName(), target:VisibleRPName(), self:GetName(true))

		ply:VisibleMessage("NOTICE", message)

		target:SetHealth(math.Round(target:GetMaxHealth() * 0.6))

		self:AddAmount(-1)
	end
end
