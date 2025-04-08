CLASS.Name = "ERROR"

CLASS.Color = Color(200, 0, 0)
CLASS.ConsoleColor = Color(255, 90, 90)

if CLIENT then
	function CLASS:OnReceive(data)
		return string.format("<c=%s>Error: %s", self.Color, data.Text), string.format("<c=%s>Error: %s", self.ConsoleColor, data.Text)
	end
end

Chat.Register({Base = "ERROR", Name = "ERROR_IC", LogFiles = {"ic"}})
Chat.Register({Base = "ERROR", Name = "ERROR_OOC", LogFiles = {"ooc"}})
Chat.Register({Base = "ERROR", Name = "ERROR_ADMIN", LogFiles = {"admin"}})
