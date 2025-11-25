CLASS.Base = "Radio"

CLASS.Name        = "Radio Whisper"
CLASS.Description = "Quietly whisper over your radio."

CLASS.Commands = {"radiowhisper", "rw"}

CLASS.Range = 150

CLASS.LocalName = "Whisper"

CLASS.MessageFormat = "<c=%s><i>[%s] %s: %s"

if SERVER then
	function CLASS:WriteLog(data, ply)
		return string.format("[%s] [%s] %s: [WHISPER] %s", data.Channel, Language.Get(data.Lang).Name, ply:VisibleRPName(), data.Text), {
			Log.Character(ply),
			ChatType = "radio"
		}
	end
end
