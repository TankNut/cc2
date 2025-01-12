CLASS.Name = "GENERIC"

CLASS.Color = Color(200, 200, 200)

if CLIENT then
	function CLASS:OnReceive(data, colors)
		return string.format("<c=%s>%s", self.Color, data.Text)
	end
end
