CLASS.Name = "Health"

CLASS.Default = true
CLASS.Setting = "Health"

CLASS.Width = 220
CLASS.Height = 14

CLASS.HealthColor = Color(150, 20, 20, 255)
CLASS.ArmorColor = Color(37, 84, 158, 255)

CLASS.DrawOrder = 1

function CLASS:Initialize()
	self.HP = lp:Health()
	self.Armor = lp:Armor()
end

function CLASS:Think()
	self.HP = math.min(math.ApproachSpeed(self.HP, lp:Health(), 20), lp:GetMaxHealth())
	self.Armor = math.min(math.ApproachSpeed(self.Armor, lp:Armor(), 20), lp:GetMaxArmor())
end

function CLASS:Paint(w, h)
	local offset = self:GetCache("LOffset", 0)

	if offset == 0 then
		offset = 20
	else
		offset = offset + 10
	end

	local y = h - offset
	local background = Color("cc_fill_dark", 200)

	do
		local ratio = math.min(self.HP / lp:GetMaxHealth(), 1)

		self:DrawAlignedRect(20, y, self.Width, self.Height, background, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		self:DrawAlignedRect(22, y - 2, (self.Width - 4) * ratio, self.Height - 4, self.HealthColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

		y = y - self.Height - 2
	end

	if self.Armor >= 0.5 then
		local ratio = math.min(self.Armor / lp:GetMaxArmor(), 1)

		self:DrawAlignedRect(20, y, self.Width, self.Height, background, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		self:DrawAlignedRect(22, y - 2, (self.Width - 4) * ratio, self.Height - 4, self.ArmorColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

		y = y - self.Height - 2
	end

	self:SetCache("LOffset", y + 2)
end
