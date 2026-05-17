local PANEL = {}

function PANEL:Init()
	self.Right = self:Add("Panel")
	self.Right:DockMargin(ui.Scale(10), 0, 0, 0)
	self.Right:Dock(RIGHT)
	self.Right:SetWide(ui.Scale(120))

	local margin = ui.Scale(5)

	self.LinksLabel = self.Right:Add("DLabel")
	self.LinksLabel:DockMargin(0, 0, 0, margin)
	self.LinksLabel:Dock(TOP)
	self.LinksLabel:SetFont("CombineControl.LabelMediumBold")
	self.LinksLabel:SetContentAlignment(5)
	self.LinksLabel:SetText("Important Links")

	local h = ui.Scale(22)

	for _, data in ipairs(Config.Get("CommunityLinks")) do
		local button = self.Right:Add("DButton")

		button:SetTall(h)
		button:DockMargin(0, 0, 0, margin)
		button:Dock(TOP)
		button:SetText(data[1])
		button.DoClick = function()
			gui.OpenURL(data[2])
		end
	end

	self.MOTD = self.Right:Add("DButton")
	self.MOTD:SetTall(h)
	self.MOTD:DockMargin(0, 0, 0, margin)
	self.MOTD:Dock(TOP)
	self.MOTD:SetText("Server Updates")
	self.MOTD.DoClick = function()
		ui.Open("MOTD")
	end

	self.Rejoin = self.Right:Add("DButton")
	self.Rejoin:SetTall(h)
	self.Rejoin:DockMargin(0, margin, 0, 0)
	self.Rejoin:Dock(BOTTOM)
	self.Rejoin:SetText("Rejoin")
	self.Rejoin.DoClick = function()
		RunConsoleCommand("retry")
	end

	self.Suicide = self.Right:Add("DButton")
	self.Suicide:SetTall(h)
	self.Suicide:DockMargin(0, margin, 0, 0)
	self.Suicide:Dock(BOTTOM)
	self.Suicide:SetText("Suicide")
	self.Suicide.DoClick = function()
		RunConsoleCommand("kill")
	end

	self.StopSounds = self.Right:Add("DButton")
	self.StopSounds:SetTall(h)
	self.StopSounds:DockMargin(0, margin, 0, 0)
	self.StopSounds:Dock(BOTTOM)
	self.StopSounds:SetText("Stop Sounds")
	self.StopSounds.DoClick = function(pnl)
		RunConsoleCommand("stopsound")
	end

	self.CategoryList = self:Add("DScrollPanel")
	self.CategoryList:Dock(FILL)

	self:Populate()
end

function PANEL:Populate()
	self.CategoryList:Clear()

	for _, category in ipairs(Settings.Categories) do
		local panel = self.CategoryList:Add("CC_Settings_Category")

		panel:Dock(TOP)
		panel:Setup(category)
	end
end

vgui.Register("CC_PlayerMenu_Settings", PANEL, "Panel")
