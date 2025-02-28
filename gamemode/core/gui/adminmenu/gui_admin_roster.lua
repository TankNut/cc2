local PANEL = {}

function PANEL:CreateLabel(text, wide)
	local label = self:Add("DLabel")

	label:SetFont("CombineControl.LabelMedium")
	label:SetWide(wide or 190)
	label:SetText(text)

	return label
end

function PANEL:Init()
	self.UpdateAlias = self:Add("DButton")
	self.UpdateAlias:SetText("Update Alias")
	self.UpdateAlias:SetWide(100)
	self.UpdateAlias.DoClick = function()
		print("** UpdateAlias CLICKED **")
	end

	self.DemoteUser = self:Add("DButton")
	self.DemoteUser:SetText("Demote User")
	self.DemoteUser:SetWide(100)
	self.DemoteUser.DoClick = function()
		print("** DemoteUser CLICKED **")
	end

	self.List = self:Add("DListView")
	self.List:SetSize(780, 400)
	self.List:AddColumn("Usergroup")
	self.List:AddColumn("SteamID")
	self.List:AddColumn("Community Alias")
	self.List:AddColumn("Last Online Name")
	self.List:AddColumn("Last Online Time")

	for i = 1, 100 do
		self.List:AddLine("Superadmin", "STEAM_0:0:55407526", "Drewerth", "No Intent To RP", "0 Seconds Ago")
	end
end

function PANEL:Think()
end

function PANEL:PerformLayout(w, h)
	self.UpdateAlias:AlignLeft()
	self.UpdateAlias:AlignBottom()

	self.DemoteUser:MoveRightOf(self.UpdateAlias, 5)
	self.DemoteUser:AlignBottom()

	self.List:MoveAbove(self.UpdateAlias, 10)
end

derma.DefineControl("CC_AdminMenu_Roster", "", PANEL, "Panel")
