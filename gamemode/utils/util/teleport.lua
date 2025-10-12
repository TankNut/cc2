-- Copied from ULX, seems to work fine

local function spiralGrid(rings)
	local grid = {}
	local col, row

	for ring = 1, rings do -- For each ring...
		row = ring

		for col2 = 1 - ring, ring do -- Walk right across top row
			table.insert(grid, {col2, row})
		end

		col = ring

		for row2 = ring - 1, -ring, -1 do -- Walk down right-most column
			table.insert(grid, {col, row2})
		end

		row = -ring

		for col2 = ring - 1, -ring, -1 do -- Walk left across bottom row
			table.insert(grid, {col2, row})
		end

		col = -ring

		for row2 = 1 - ring, ring do -- Walk up left-most column
			table.insert(grid, {col, row2})
		end
	end

	return grid
end

local grid = spiralGrid(24)

function util.TeleportPlayers(target, players)
	if not istable(players) then
		players = {players}
	end

	local ignore = table.Copy(players)
	local pos, ang

	if isvector(target) then
		pos = target
		ang = Angle(0, math.random(0, 359), 0)
	else
		pos = target:IsInNoClip() and target:EyePos() or target:GetPos()
		ang = Angle(0, target:EyeAngles().y, 0)

		table.insert(ignore, target)
	end

	pos:Add(Vector(0, 0, 32))

	local queue = table.Copy(players)
	local cellSize = 40

	local tr = {}
	local trace = {
		start = pos,
		filter = ignore,
		mask = MASK_PLAYERSOLID,
		output = tr
	}

	for i = 1, #grid do
		local current = table.remove(queue)

		if not IsValid(current) then
			break
		end

		local column = grid[i][1]
		local row = grid[i][2]

		local offset = Vector(row * cellSize, column * cellSize)
		offset:Rotate(ang)

		trace.endpos = trace.start + offset

		util.TraceEntity(trace, current)

		if tr.Hit then
			table.insert(queue, current)
		else
			current:SetPos(tr.HitPos)
			current:SetLocalVelocity(vector_origin)
			current:DropToFloor()
		end
	end
end
