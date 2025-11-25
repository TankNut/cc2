CLASS.Base = "Radio"

CLASS.Name        = "Radio Yell"
CLASS.Description = "Yell something over your radio."

CLASS.Commands = {"radioyell", "ry"}

CLASS.Range        = 800
CLASS.MuffledRange = 400

CLASS.LocalName = "Yell"

CLASS.MessageFormat = "<c=%s><b>[%s] %s: %s"

if SERVER then
	function CLASS:WriteLog(data, ply)
		return string.format("[%s] [%s] %s: [YELL] %s", data.Channel, Language.Get(data.Lang).Name, ply:VisibleRPName(), data.Text), {
			Log.Character(ply),
			ChatType = "radio"
		}
	end
end
