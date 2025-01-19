DEFINE_BASECLASS("CC_CharCreate")

local PANEL = {}

function PANEL:Init()
	self.Scroll = self.Canvas:Add("DScrollPanel")

	self.Layout = self.Scroll:Add("DTileLayout")
	self.Layout:SetBaseSize(56)
	self.Layout:Dock(FILL)
end

function PANEL:Setup(models, val)
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

function PANEL:PerformLayout(w, h)
	BaseClass.PerformLayout(self, w, h)

	local count = #self.Layout:GetChildren()

	self.Scroll:StretchToParent(nil, nil, 0, nil)
	self.Scroll:SetTall(math.min(math.ceil(count / 6), 4) * 56)
end

derma.DefineControl("CC_CharCreate_Model", "", PANEL, "CC_CharCreate")
