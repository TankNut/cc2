BUFF.RemoveOnDeath = true

BUFF.Duration = 120
BUFF.Interval = 2

BUFF.HealPerTick = 2

function BUFF:Duplicate(stacks, time)
	-- Reset heal timer
	self.LastTimer = time
end

function BUFF:OnTick()
	if SERVER then
		local ply = self.Player
		local health = math.min(ply:Health() + self.HealPerTick, ply:GetMaxHealth())

		ply:SetHealth(health)

		if health >= ply:GetMaxHealth() then
			self:Remove()
		end
	end
end

if SERVER then
	-- Clear regen on damage
	function BUFF:OnDamaged(dmg)
		self:Remove()
	end
end
