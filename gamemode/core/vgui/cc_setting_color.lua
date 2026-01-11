local PANEL = {}

local function updateButton(pnl, val)
	pnl:SetTextColor(val:GetBrightness() > 0.5 and Color("black") or color_white)
	pnl:SetText(string.format("%s %s %s", val.r, val.g, val.b))
	pnl.Color = val
end

function PANEL:Init()
	self.Preview = self:Add("DButton")
	self.Preview:SetSize(100, 15)

	self.Preview.DoClick = function(pnl)
		local combo = vgui.Create("DColorCombo")
		combo:SetTall(260)
		combo:SetColor(pnl.Color)

		combo.OnValueChanged = function(_, val)
			updateButton(pnl, val)

			self.Save:SetDisabled(val == self:GetSetting())
		end

		local popup = DermaMenu(false, pnl)
		popup:AddPanel(combo)
		popup:SetPaintBackground(false)
		popup:Open(gui.MouseX() + 8, gui.MouseY() + 10)
	end

	self.Preview.Paint = function(pnl, w, h)
		surface.SetDrawColor(pnl.Color)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(0, 0, 0, 150)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	self.Save = self:Add("DButton")
	self.Save:DockMargin(0, 1, 5, 1)
	self.Save:Dock(RIGHT)
	self.Save:SetText("Save")
	self.Save:SizeToContentsX(20)

	self.Save.DoClick = function(pnl)
		self:SaveSetting(self.Preview.Color)
		pnl:SetDisabled(true)
	end
end

function PANEL:ApplySetting(value)
	updateButton(self.Preview, value)

	self.Save:SetDisabled(true)
end

function PANEL:PerformLayout(w, h)
	self.Preview:MoveRightOf(self.Label, 5)
	self.Preview:CenterVertical(0.5)
	self.Preview:SetTall(20)
	self.Preview:SetWide(100)
end

vgui.Register("CC_Setting_Color", PANEL, "CC_Setting")
