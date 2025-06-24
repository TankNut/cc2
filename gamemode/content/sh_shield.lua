module("shield", package.seeall)

if SERVER then
	function Enable(ent)
		if ent.ShieldActive then
			Disable(ent)
		end

		ent.ShieldActive = true

		local shield = ents.Create("cc_shield_model")

		shield:SetParent(ent)
		shield:Spawn()
		shield:Activate()

		ent.ShieldEntity = shield
	end

	function Disable(ent)
		SafeRemoveEntity(ent.ShieldEntity)

		ent.ShieldActive = false
	end

	hook.Add("EntityTakeDamage", "shield", function(ent, dmg)
		if ent.ShieldActive and ent.ShieldEntity:TakeShieldDamage(dmg) then
			return true
		end
	end)

	hook.Add("ScalePlayerDamage", "shield", function(ply, hitgroup, dmg)
		if ply.ShieldActive and ply.ShieldEntity:TakeShieldDamage(dmg) then
			return true
		end
	end)
end

if CLIENT then
	matproxy.Add({
		name = "cc2_shield",
		init = function(self, mat, values) end,
		bind = function(self, mat, ent)
			mat:SetVector("$emissiveBlendTint", Vector(1, 0.75, 0))
			mat:SetFloat("$emissiveBlendStrength", ent:GetShieldVisibility())
		end
	})
end
