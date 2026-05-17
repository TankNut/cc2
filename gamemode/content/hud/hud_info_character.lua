HUD.Name = "Character Info"

HUD.Setting = "CharacterInfo"

HUD.DrawOrder = 0

HUD.BoxColor = Color("cc_fill_dark", 200)

function HUD:Paint(w, h)
	local offset = ui.Scale(20)
	local margin = ui.Scale(2)

	local x, y = offset, h - offset

	local lines = hook.Run("GetHUDCharacterInfo")
	local scribeW, scribeH = 0, 0

	for k, v in ipairs(lines) do
		local parsed = scribe.Parse(v)

		scribeW = math.max(scribeW, parsed:GetWide())
		scribeH = scribeH + parsed:GetTall()

		lines[k] = parsed
	end

	local boxW = math.max(scribeW + margin * 2, ui.Scale(220))
	local boxH = scribeH + margin * 2

	self:DrawAlignedRect(x, y, boxW, boxH, self.BoxColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

	local drawY = 0

	for _, parsed in ipairs(lines) do
		parsed:Draw(x + boxW - margin, y - boxH + margin + drawY, 1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		drawY = drawY + parsed:GetTall()
	end

	self:SetCache("LOffset", y - boxH)
end

function GM:GetHUDCharacterInfo(ply)
	return {
		"<giant><ol><c=cc_normal>" .. lp:VisibleRPName(),
		"<giant><ol><c=cc_normal>" .. team.GetName(lp:Team())
	}
end
