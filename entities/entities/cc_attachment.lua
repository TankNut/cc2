AddCSLuaFile()

ENT.Type = "anim"

if CLIENT then
	function ENT:Draw(flags)
		local shouldDraw = true

		-- We're a honest to god entity, so our parent is too (nothing vgui related), so we do some extra checks to see if we should bother drawing
		if self:EntIndex() != -1 then
			local parent = self:GetParent()

			if parent:GetNoDraw() or not parent:Alive() then
				shouldDraw = false
			elseif parent == lp and not parent:ShouldDrawLocalPlayer() then
				shouldDraw = false
			end
		end

		if shouldDraw then
			self:DrawModel(flags)
			self:CreateShadow()
		else
			self:DestroyShadow()
		end
	end
end
