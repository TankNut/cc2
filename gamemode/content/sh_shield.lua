module("shield", package.seeall)

function Get(ent)
	return ent:GetNWEntity("ShieldEntity")
end

if SERVER then
	function Enable(ent, class)
		local existing = Get(ent)

		if IsValid(existing) and math.IsNearlyEqual(existing:GetCreationTime(), CurTime(), 0.1) then
			return
		end

		SafeRemoveEntity(Get(ent))

		local shield = ents.Create(class or "cc_shield")

		shield:SetParent(ent)
		shield:Spawn()
		shield:Activate()

		ent:SetNWEntity("ShieldEntity", shield)
	end

	function Disable(ent)
		SafeRemoveEntity(Get(ent))
	end

	hook.Add("EntityTakeDamage", "shield", function(ent, dmg)
		local shield = Get(ent)

		if IsValid(shield) and shield:TakeShieldDamage(dmg) then
			return true
		end
	end)

	hook.Add("ScalePlayerDamage", "shield", function(ply, hitgroup, dmg)
		local shield = Get(ply)

		if IsValid(shield) and shield:TakeShieldDamage(dmg) then
			return true
		end
	end)
end

if CLIENT then
	matproxy.Add({
		name = "CC2Shield",
		init = function(self, mat, values) end,
		bind = function(self, mat, ent)
			mat:SetVector("$emissiveBlendTint", ent:GetShieldColor())
			mat:SetFloat("$emissiveBlendStrength", ent:GetShieldVisibility())
		end
	})
end
