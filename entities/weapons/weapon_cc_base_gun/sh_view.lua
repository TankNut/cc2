DEFINE_BASECLASS("weapon_cc_base")
AddCSLuaFile()

function SWEP:InScope()
	local index = self.Settings.ScopeIndex

	if not index then
		return false
	end

	return self:GetZoomIndex() >= index and self:GetAimState() > 0.2
end

if CLIENT then
	function SWEP:GetViewModelTarget()
		local targetPos, targetAng = BaseClass.GetViewModelTarget(self)
		local offsets = self.Offsets

		if self:ShouldAim() then
			targetPos:Set(offsets.Aiming[1])
			targetAng:Set(offsets.Aiming[2])
		end

		self:AddComputedOffsets(targetPos, targetAng)

		return targetPos, targetAng
	end

	function SWEP:AddComputedOffsets(pos, ang)
		local ply = self:GetOwner()
		local eye = ply:EyeAngles()
		local roll = 10

		 -- Offset the weapon depending on the view pitch
		if self:GetHolstered() or self:IsSprinting() then
			roll = 20

			local pitch = eye.p
			local vOffset = math.ease.InOutSine(math.Remap(pitch, 0, 90, 0, 1))
			local factor = ply:GetFOV() / self.ViewModelFOV

			pos:SubZ(math.abs(vOffset * 3))

			ang:SetPitch(math.min(ang.p + vOffset * 30 - (pitch / factor), ang.p))
			ang:MulYaw(1 - vOffset)
		end

		local vel = ply:GetVelocity()
		local sidewaysVelocity = vel:GetNormalized():Dot(eye:Right()) * vel:Length()

		ang:AddRoll(math.ClampedRemap(sidewaysVelocity, -ply:GetRunSpeed(), ply:GetRunSpeed(), -roll, roll))

		local crouch = ply:GetCrouchState()

		pos:SubX(crouch)
		pos:SubZ(crouch * 1.5)

		ang:SubPitch(crouch)
		ang:SubRoll(crouch * 5)
	end

	function SWEP:GetStaticViewModelOffset()
		return self:GetVMRecoil()
	end

	function SWEP:PreDrawViewModel(vm, _, ply)
		if BaseClass.PreDrawViewModel(self, vm, self, ply) then
			return true
		end

		if self:InScope() then
			return true
		end
	end

	function SWEP:ShouldDoThirdPerson(ply)
		if self:InScope() then
			return false
		end
	end
end
