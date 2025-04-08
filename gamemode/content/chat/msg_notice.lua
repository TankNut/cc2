CLASS.Name = "NOTICE"

CLASS.Color = Color(229, 201, 98)

if CLIENT then
	function CLASS:OnReceive(data)
		return string.format("<c=%s>%s", self.Color, data.Text)
	end
end

Chat.Register({Base = "NOTICE", Name = "NOTICE_IC", LogFiles = {"ic"}})
Chat.Register({Base = "NOTICE", Name = "NOTICE_OOC", LogFiles = {"ooc"}})
Chat.Register({Base = "NOTICE", Name = "NOTICE_ADMIN", LogFiles = {"admin"}})
