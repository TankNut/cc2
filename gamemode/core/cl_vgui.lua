local PANEL = FindMetaTable("Panel")

function PANEL:SetCloseOnPause()
	hook.Add("OnPauseMenuShow", self, function()
		if vgui.FocusedHasParent(self) then
			self:Close()

			return false
		end
	end)
end
