AddCSLuaFile()
DEFINE_BASECLASS("weapon_cc_base_gun")

SWEP.Base = "weapon_cc_base_gun"

SWEP.PrintName = "M319 Grenade Launcher"
SWEP.Category = "CombineControl - Halo"
SWEP.NPCCategory = "UNSC"

SWEP.Spawnable = true

SWEP.ViewModelFOV = 54

SWEP.UseHands   = true
SWEP.ViewModel  = Model("models/vuthakral/halo/weapons/c_hum_m139.mdl")
SWEP.WorldModel = Model("models/vuthakral/halo/weapons/w_m139.mdl")

SWEP.Stats = {
	Type = "Projectile",
	Class = "cc_projectile_m319",

	Offset = Vector(8, -8, -6),

	Accuracy = ACCURACY_AVERAGE,
	Range = RANGE_LAUNCHER
}

SWEP.Recoil = {
	Value = 2,

	PosMult = Vector(1),
	AngMult = Angle(),

	Punch = 0.6
}

SWEP.Settings = {
	LowerHoldType = "passive",
	BaseHoldType = "ar2",

	Firemodes = {FIREMODE_SEMI},
	FireRate = -1,

	ClipSize = 1
}

SWEP.Animations = {
	Fidget = ACT_VM_FIDGET
}

SWEP.Sounds = {
	Primary = Sound("Weapon_M319.Single")
}

SWEP.Offsets = {
	Default = {
		Vector(1, -1, -2),
		Angle(0, 0, 0)
	},
	Holster = {
		Vector(0, 0, 0),
		Angle(20, 10, 0)
	},
	Sprint = {
		Vector(0, 0, -1),
		Angle(25, 15, 0)
	},
	Aiming = {
		Vector(-1, 0, -1),
		Angle(0, 0, 0)
	}
}

SWEP.Itemize = {
	Description = "The M319 Individual Grenade Launcher is a single-shot, break-action grenade launcher used by the UNSC. This particular version includes a ballistics computer to aid with indirect fire across different levels of gravity.",
	Rarity = RARITY_RARE,

	Weight = 10,

	EquipmentSlots = {"primary", "secondary"},

	IconAngle = Angle(15, 45, 10),
	IconFOV = 12
}

if CLIENT then
	local fill = Color(37, 141, 170)
	local outline = Color(16, 60, 80)

	local err = Color(255, 0, 0)
	local errOutline = Color(100, 0, 0)

	function SWEP:GetFiringSolution()
		local owner = self:GetOwner()
		local target = owner:GetEyeTrace().HitPos

		local class = scripted_ents.Get(self.Stats.Class)
		local velocity = class.Velocity
		local gravity = -(physenv.GetGravity() * class.Gravity).z

		local origin = LocalToWorld(self.Stats.Offset or vector_origin, angle_zero, self:GetOwner():GetShootPos(), self:GetShootDir():Angle())
		local elevation = target.z - origin.z
		local distance = target:Distance2D(origin)

		return math.atan(((velocity ^ 2) * (1 - math.sqrt(1 - (gravity * (gravity * (distance ^ 2) + 2 * (velocity ^ 2) * elevation)) / (velocity ^ 4)))) / (gravity * distance))
	end

	function SWEP:DrawAmmoCounter(ent, scale)
		local matrix = ent:GetBoneMatrix(ent:LookupBone("b_gun"))

		matrix:Translate(Vector(5.73, 1.89, 5.65))
		matrix:Rotate(Angle(0, -90, 45))
		matrix:Scale(Vector(scale, scale, scale))

		local num = 0
		local mode
		local problem = false

		if self:Clip1() == 0 then
			mode = "AMMO"
			problem = true
		elseif self:ShouldLower() or self:GetHolstered() then
			mode = "READY"
		elseif self:GetAimState() > 0.2 then
			local solve = self:GetFiringSolution()

			if solve == solve then
				num = math.Round(math.deg(solve))
				mode = "SOLVE"
			else
				mode = "RANGE"
				problem = true
			end
		else
			num = math.Round(-ent:GetAngles().p)
			mode = "READY"
		end

		cam.Start3D2D(matrix:GetTranslation(), matrix:GetAngles(), 0.003 * scale)
			draw.SimpleTextOutlined(num, "reach_ammocounter", 0, 0, fill, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, outline)

			local col1 = problem and err or fill
			local col2 = problem and errOutline or outline

			draw.SimpleTextOutlined(mode, "reach_ammocounter", 0, 110, col1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, col2)
		cam.End3D2D()
	end

	function SWEP:PostDrawViewModel(vm, _, ply)
		BaseClass.PostDrawViewModel(self, vm, self, ply)

		self:DrawAmmoCounter(vm, 1)
	end

	function SWEP:DrawWorldModel(flags)
		BaseClass.DrawWorldModel(self, flags)

		local scale = 1
		local owner = self:GetOwner()

		if IsValid(owner) and owner:IsPlayer() then
			if owner:IsCloaked() then
				return
			end

			scale = owner:GetModelScale()
		else
			return
		end

		self:DrawAmmoCounter(self, scale)
	end
end

sound.Add({
	name = "Weapon_M319.Single",
	channel = CHAN_WEAPON,
	volume = 0.69,
	level = 90,
	pitch = {95, 105},
	sound = {
		")vuthakral/halo/weapons/m139/fire0.wav",
		")vuthakral/halo/weapons/m139/fire1.wav",
		")vuthakral/halo/weapons/m139/fire2.wav",
		")vuthakral/halo/weapons/m139/fire3.wav",
		")vuthakral/halo/weapons/m139/fire4.wav",
		")vuthakral/halo/weapons/m139/fire5.wav",
		")vuthakral/halo/weapons/m139/fire6.wav",
		")vuthakral/halo/weapons/m139/fire7.wav",
		")vuthakral/halo/weapons/m139/fire8.wav",
		")vuthakral/halo/weapons/m139/fire9.wav"
	}
})
