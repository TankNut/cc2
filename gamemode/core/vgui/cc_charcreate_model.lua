local PANEL = {}

function PANEL:Init()
	self.Scroll = self.Canvas:Add("DScrollPanel")
	self.Scroll:Dock(FILL)

	self.Layout = self.Scroll:Add("DTileLayout")
	self.Layout:SetBaseSize(56)
	self.Layout:Dock(FILL)
end

function PANEL:Setup(models, val)
	self.Scroll:SetTall(math.min(math.ceil(#models / 6), 4) * 56)

	for _, mdl in ipairs(models) do
		local icon = vgui.Create("SpawnIcon")

		icon:SetSize(56, 56)
		icon:SetModel(mdl)
		icon:SetTooltip()

		icon.DoClick = function()
			self:SetOption(mdl)
		end

		self.Layout:Add(icon)
	end

	if not val then
		self:SetOption(models[1])
	end
end

derma.DefineControl("CC_CharCreate_Model", "", PANEL, "CC_CharCreate")
