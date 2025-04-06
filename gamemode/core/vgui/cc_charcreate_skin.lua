DEFINE_BASECLASS("CC_CharCreate")

local PANEL = {}

function PANEL:Init()
	self.Scroll = self.Canvas:Add("DScrollPanel")

	self.Layout = self.Scroll:Add("DTileLayout")
	self.Layout:SetBaseSize(56)
	self.Layout:Dock(TOP)
end

function PANEL:Setup(key, val, options)
	self.WatchedKey = key

	if not val then
		self:SetOption(0)
	end

	local mdl = options[key]

	if mdl then
		self:Populate(mdl)
	end
end

function PANEL:Populate(mdl)
	self.Layout:Clear()

	local skinCount = util.GetModelSkins(mdl)

	for i = 0, skinCount - 1 do
		local icon = vgui.Create("SpawnIcon")

		icon:SetSize(56, 56)
		icon:SetModel(mdl, i)
		icon:SetTooltip(false)

		icon.DoClick = function()
			self:SetOption(i)
		end

		self.Layout:Add(icon)
	end

	self.Layout:InvalidateLayout(true)
end

function PANEL:OnOptionChanged(key, val)
	if key == self.WatchedKey then
		self:SetOption(0)
		self:Populate(val)
	end
end

function PANEL:PerformLayout(w, h)
	BaseClass.PerformLayout(self, w, h)

	self.Scroll:StretchToParent(nil, nil, 0, nil)
	self.Scroll:SetTall(56)
end

derma.DefineControl("CC_CharCreate_Skin", "", PANEL, "CC_CharCreate")
