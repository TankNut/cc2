local CONTROLLER = {}

CONTROLLER.Models = {}

CONTROLLER.UseIK = true
CONTROLLER.CanAct = false

function CONTROLLER:GetPlaybackRate(ply, vel, max)
	local len = vel:Length()
	local rate = 1

	if len > 0.2 then
		rate = math.min(len / max, max)
	end

	return rate
end

function CONTROLLER:CalcMainActivity(ply, vel)
end

function CONTROLLER:UpdateAnimation(ply, vel, max)
	if CLIENT then
		ply:SetIK(self.UseIK)
	end
end

function CONTROLLER:TranslateActivity(ply, act)
end

function CONTROLLER:DoAnimationEvent(ply, event, data)
end

inherit.Register("animations", "base", CONTROLLER)
