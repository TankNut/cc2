local PANEL = {}

function PANEL:Init()
	self:DockMargin(0, 0, 0, 15)
	self:Dock(TOP)

	self:SetPaintBackground(false)

	local left = self:Add("DPanel")

	left:DockMargin(0, 0, 10, 0)
	left:Dock(LEFT)
	left:SetWide(115)
	left:SetPaintBackground(false)

	self.Label = left:Add("DLabel")
	self.Label:Dock(TOP)
	self.Label:SetFont("CombineControl.LabelGiant")
	self.Label:SetText("")
	self.Label:SetContentAlignment(9)

	self.Canvas = self:Add("DPanel")
	self.Canvas:Dock(FILL)
	self.Canvas:SetPaintBackground(false)
end

function PANEL:SetTitle(title)
	self.Label:SetText(title)
	self.Label:SizeToContentsY()
end

function PANEL:GetOption()
	return self.CharCreate.Options[self.ID]
end

function PANEL:SetOption(val)
	self.CharCreate:SetOption(self.ID, val)
end

function PANEL:Setup(args)
end

function PANEL:OnOptionChanged(key, val)
end

function PANEL:PerformLayout(w, h)
	self.Canvas:SizeToChildren(false, true)
	self:SizeToChildren(false, true)
end

derma.DefineControl("CC_CharCreate", "", PANEL, "DPanel")
