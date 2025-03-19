HUD.Name = "Unconnected"

HUD.DrawOrder = math.huge

local textColor = Color("cc_normal")

function HUD:ShouldAddElement()
	return not lp:HasCharacter()
end

function HUD:ShouldDraw()
	return not lp:HasCharacter() and not vgui.CursorVisible()
end

function HUD:Paint(w, h)
	draw.DrawBackgroundBlur(1, 0, 0, w, h)

	draw.DrawText("Loading...", "CombineControl.LabelGiant", w / 2, h / 2, textColor, 1)
end
