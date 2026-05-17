local COMMAND = CustomMetaTable("ConsoleCommand")

function COMMAND:SetCategory(category)
	self.Category = category
end

function COMMAND:SetChatAlias(alias)
	Chat.AddConsoleCommand(alias, self.Name)
end

function console.PrintMessage(ply, str, ...)
	console.Feedback(ply, "NOTICE", str, ...)
end

function console.PrintError(ply, str, ...)
	console.Feedback(ply, "ERROR", str, ...)
end

function console.Feedback(ply, messageType, str, ...)
	local class = assert(Chat.List[messageType], "Invalid message type")

	if not IsValid(ply) then
		-- Strip any tags out because the server console doesn't have scribe
		MsgC(class.ConsoleColor or class.Color, console.FormatMessage(str:gsub("(<[^>]+.)", ""):Unescape(), ...), "\n")

		return
	end

	if CLIENT then
		lp:SendChat(messageType, console.FormatMessage(str, ...))
	elseif istable(ply) then
		local formattedMessage = console.FormatMessage(str, ...)

		for _, v in ipairs(ply) do
			v:SendChat(messageType, formattedMessage)
		end
	else
		ply:SendChat(messageType, console.FormatMessage(str, ...))
	end
end

function console.IsAdmin(ply) return ply:IsAdmin() end
function console.IsSuperAdmin(ply) return ply:IsSuperAdmin() end
function console.IsDeveloper(ply) return ply:IsDeveloper() end

function console.RPName(ply)
	return IsValid(ply) and ply:VisibleRPName() or "CONSOLE"
end

function console.FindPlayer(ply, str, options)
	if not str or #str < 1 then
		return false, "No target found"
	end

	local isConsole = not IsValid(ply)

	str = string.lower(str)

	local found

	if str == "^" then -- Target self
		if isConsole then
			return false, "The server console cannot target itself"
		end

		if options.NoSelfTarget then
			return false, "You cannot target yourself"
		end

		found = ply
	elseif str == "-" then -- Target look-at
		if isConsole then
			return false, "The server console cannot target what they're looking at"
		end

		local ent = ply:GetEyeTrace().Entity

		if IsValid(ent) and ent:IsPlayer() then
			found = ent
		end
	else -- Target by name
		local targets = {}
		local priv = isConsole or ply:IsAdmin()

		for _, target in player.Iterator() do
			if target:HasCharacter() and string.find(string.lower(target:VisibleRPName()), str, 1, not multi) then
				table.insert(targets, target)

				continue
			end

			if priv and string.find(string.lower(target:Nick()), str, 1, not multi) then
				table.insert(targets, target)

				continue
			end

			if priv and string.lower(target:SteamID()) == str then
				table.insert(targets, target)

				continue
			end
		end

		if #targets > 1 then
			return false, "Multiple targets found"
		end

		found = targets[1]
	end

	if not found then
		return false, "No target found"
	end

	if options.CheckImmunity and not isConsole and not ply:CanTarget(found) then
		return false, "You cannot target that person"
	end

	if options.StrictImmunity and not isConsole and not ply:CanTarget(found, true) then
		return false, "You cannot target that person"
	end

	if options.NoAdmins and found:IsAdmin() then
		return false, "You cannot target admins"
	end

	if options.NoSelfTarget and found == ply then
		return false, "You cannot target yourself"
	end

	return true, found
end

console.Parser("Player", function(ply, args, last, options)
	return console.FindPlayer(ply, console.ReadArg(args, last), options)
end)

-- Does not work for non-admins atm because of limitations built into FindPlayer
console.Parser("SteamID", function(ply, args, last, options)
	local val = console.ReadArg(args, last)

	if util.IsValidSteamID(val) and not options.Online and not player.GetBySteamID(val) then
		if IsValid(ply) and (options.CheckImmunity or options.StrictImmunity) and not ply:CanTargetUserGroup(Data.Player.UserGroup(val), options.StrictImmunity) then
			return false, "You cannot target this person"
		end

		return true, val
	end

	local ok, target = console.FindPlayer(ply, val, options)

	-- Target will be an error message if ok is false
	return ok, ok and target:SteamID() or target
end)

if CLIENT then
	local col = Color(200, 200, 200)

	local function printItemList(name)
		if name then
			MsgC(col, string.format("ITEM LIST: (FILTER \"%s\")\n", name))
		else
			MsgC(col, "ITEM LIST:\n")
		end

		for class, item in SortedPairs(Item.Find(lp, name)) do
			local rarity = Item.Rarities[item.Rarity]

			MsgC(color_white, string.format("%-25s - ", class), rarity.Color, item.Name, "\n")
		end
	end

	netstream.Hook("ItemList", printItemList)
end

console.Parser("Item", function(ply, args, last, options)
	local itemList = function(name)
		if name == "" then
			name = nil
		end

		if CLIENT then
			printItemList(name)
		else
			netstream.Send(ply, "ItemList", name)
		end
	end

	local val = console.ReadArg(args, last)
	local items = Item.Find(ply, val)

	if table.Count(items) == 1 then
		return true, table.GetKeys(items)[1]
	end

	itemList(val)

	return true, nil
end)

console.Parser("Language", function(ply, args, last, options)
	local val = console.ReadArg(args, last)

	if not val or #val < 1 or not Language.Get(val) then
		return false, "Must be a valid language"
	end

	return true, val
end)

console.Parser("Badge", function(ply, args, last, options)
	local val = console.ReadArg(args, last)

	if not val or #val < 1 then
		return false, "Must be a valid badge"
	end

	local badge = Badge.Get(val)

	if not badge or badge.Automatic then
		return false, "Must be a valid badge"
	end

	return true, val
end)

console.Parser("CharacterFlag", function(ply, args, last, options)
	local val = console.ReadArg(args, last)

	if not val or #val < 1 or not CharacterFlag.Exists(val) then
		return false, "Must be a valid character flag"
	end

	return true, val
end)

console.Parser("Team", function(ply, args, last, options)
	local val = console.ReadArg(args, last)

	if not val or #val < 1 then
		return false, "Must be a valid team"
	end

	for index, data in ipairs(Team.List) do
		if data.ID == val then
			return true, index
		end
	end

	return false, "Must be a valid team"
end)

console.Parser("Permission", function(ply, args, last, options)
	local val = console.ReadArg(args, last)

	if not val or #val < 1 then
		return false, "Must be a valid permission"
	end

	local define = Permissions.List[val]

	if not define then
		return false, "Must be a valid permission"
	end

	if options.Assignable and define.Callback then
		return false, "This permission cannot be assigned manually"
	end

	return true, define
end)

console.Parser("CharacterGen", function(ply, args, last, options)
	local val = console.ReadArg(args, last)

	if not val or #val < 1 then
		return false, "Must be a valid character type"
	end

	local define = CharacterGen.List[val]

	if define then
		if IsValid(ply) and not ply:CanUseCharacterGenerator(define.ID) then
			return false, "You cannot use this character type"
		end

		return true, define
	else
		return false, "Must be a valid character type"
	end
end)
