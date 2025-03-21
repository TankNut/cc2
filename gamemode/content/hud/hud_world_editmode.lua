local BaseClass = inherit.Get("hud", "base")

HUD.Name = "Edit Mode"

local colorButtonDisabled = Color(255, 0, 0)

function HUD:ShouldAddElement()
	if not lp:IsAdmin() then
		return false
	end

	return BaseClass.ShouldAddElement(self)
end

function HUD:ShouldDraw()
	if not lp:EditMode() then
		return false
	end

	return BaseClass.ShouldDraw(self)
end

function HUD:DrawButtons()
	for button in pairs(Buttons.List) do
		if not IsValid(button) or button:IsDormant() then
			continue
		end

		local color = button:ButtonDisabled() and colorButtonDisabled or color_white

		render.SetColorMaterial()
		render.DrawBox(button:GetPos(), button:GetAngles(), button:OBBMins() - Vector(0.1, 0.1, 0.1), button:OBBMaxs() + Vector(0.1, 0.1, 0.1), ColorAlpha(color, 50), true)
	end
end

function HUD:PostDrawTranslucentRenderables(depth, skybox)
	if skybox then
		return
	end

	self:DrawButtons()
end
