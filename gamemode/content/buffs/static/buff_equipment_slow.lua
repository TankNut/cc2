BUFF.SlowPerStack = 0.1 -- Fraction

function BUFF:SetupMove(mv, cmd)
	local ply = self.Player

	mv:LimitSpeed(Lerp(self.SlowPerStack * self.Stacks, ply:GetRunSpeed(), ply:GetWalkSpeed()))
end
