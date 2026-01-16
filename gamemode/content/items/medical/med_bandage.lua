local BaseClass = inherit.Get("item", "base_medical")

ITEM.Base = "base_medical"

ITEM.Name = "Bandage"
ITEM.Description = "A basic roll of medical gauze, good for a quick patchup but not much else."
ITEM.Rarity = RARITY_COMMON

ITEM.Model = Model("models/props_wasteland/prison_toiletchunk01f.mdl")

ITEM.Weight = 0.1

ITEM.IconAngle = Angle(25, -40, -25)
ITEM.IconFOV = 10

ITEM.CanSelfApply = true
ITEM.SelfApplyTime = 3

ITEM.CanApply = true
ITEM.ApplyTime = 1

function ITEM:CanTarget(ply)
	if not BaseClass.CanTarget(self, ply) then
		return false
	end

	return ply:Health() < math.Round(ply:GetMaxHealth() * 0.8)
end

if SERVER then
	function ITEM:OnStartApply(ply, target)
		local message = ply == target and
			string.format("%s starts to bandage themselves...", ply:VisibleRPName()) or
			string.format("%s starts to bandage up %s...", ply:VisibleRPName(), target:VisibleRPName())

		ply:VisibleMessage("NOTICE", message)
	end

	function ITEM:OnApply(ply, target)
		local message = ply == target and
			string.format("%s finishes bandaging themselves", ply:VisibleRPName()) or
			string.format("%s finishes bandaging %s", ply:VisibleRPName(), target:VisibleRPName())

		ply:VisibleMessage("NOTICE", message)

		local max = math.Round(target:GetMaxHealth() * 0.8)

		target:SetHealth(math.min(target:Health() + 10, max))

		self:AddAmount(-1)
	end
end
