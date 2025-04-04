CLASS.Name = "NOTICE"

CLASS.Color = Color(229, 201, 98)

if CLIENT then
	function CLASS:OnReceive(data)
		return string.format("<c=%s>%s", self.Color, data.Text)
	end
end

Chat.Register({Base = "NOTICE", Name = "IC_NOTICE", ClientLog = {"ic"}})
Chat.Register({Base = "NOTICE", Name = "ADMIN_NOTICE", ClientLog = {"admin"}})
