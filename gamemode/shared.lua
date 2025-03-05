-- 5/25/2013

DeriveGamemode("sandbox")

GM.Name = "CombineControl: TnB"
GM.Author = "Taco N Banana"
GM.Website = "http://taconbanana.com"
GM.Email = "gangleider@taconbanana.com"

function GM:GetGameDescription()
	return self.Name
end

local ENTITY = FindMetaTable("Entity")

function ENTITY:IsDoor()
	if self:GetClass() == "prop_door_rotating" then return true end
	if self:GetClass() == "func_door_rotating" then return true end
	if self:GetClass() == "func_door" then return true end

	return false
end

function GM:GetHandTrace(ply, len)
	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * (len or 50)
	trace.filter = ply

	return util.TraceLine(trace)
end

-- Maps a yaw to 0 -> 360
function math.AngleToHeading(yaw)
	return (-yaw % 360) + 360 % 360
end

-- Takes a heading and returns the compass direction
function GM:GetHeading(heading)
	local northSouth = (heading < 67.5 or heading > 292.5) and "N" or
		(heading > 112.5 and heading < 247.5) and "S" or ""

	local eastWest = (heading > 22.5 and heading < 157.5) and "E" or
		(heading > 202.5 and heading < 337.5) and "W" or ""

	return northSouth .. eastWest
end
