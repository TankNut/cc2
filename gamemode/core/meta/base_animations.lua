local CONTROLLER = {}

CONTROLLER.Models = {}

CONTROLLER.UseIK = true
CONTROLLER.CanAct = false

function CONTROLLER:CalcMainActivity(ply, vel)
end

function CONTROLLER:UpdateAnimation(ply, vel, max)
	if CLIENT then
		ply:SetIK(self.UseIK)
	end
end

inherit.Register("animations", "base", CONTROLLER)
