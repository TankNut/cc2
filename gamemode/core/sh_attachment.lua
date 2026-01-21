local ENTITY = FindMetaTable("Entity")

local function createAttachment(data, parent)
	if isstring(data) then
		data = {Model = data}
	end

	local ent = CLIENT and ents.CreateClientside("cc_attachment") or ents.Create("cc_attachment")
	ent:ApplyModel(data)

	if not parent.Attachments then
		parent.Attachments = {}
	end

	table.insert(parent.Attachments, ent)

	if CLIENT then
		parent:CallOnRemove("ClearAttachments", ENTITY.ClearAttachments)
	end

	return ent
end

function ENTITY:AddBonemerge(data)
	local ent = createAttachment(data, self)

	ent:SetParent(self)
	ent:SetTransmitWithParent(true)
	ent:AddEffects(EF_BONEMERGE + EF_PARENT_ANIMATES)

	ent:Spawn()

	return ent
end

function ENTITY:AddAttachmentFollower(data, id, pos, ang)
	local ent = createAttachment(data, self)

	ent:SetParent(self, id)
	ent:SetTransmitWithParent(true)
	ent:AddEffects(EF_PARENT_ANIMATES)

	ent:SetAttachmentID(id)

	ent:SetLocalPos(pos or vector_origin)
	ent:SetLocalAngles(ang or angle_zero)

	ent:Spawn()

	return ent
end

function ENTITY:AddBoneFollower(data, id, pos, ang)
	local ent = createAttachment(data, self)

	ent:FollowBone(self, id)
	ent:SetTransmitWithParent(true)
	ent:AddEffects(EF_PARENT_ANIMATES)

	ent:SetAttachmentID(id)

	ent:SetLocalPos(pos or vector_origin)
	ent:SetLocalAngles(ang or angle_zero)

	ent:Spawn()

	return ent
end

function ENTITY:CopyAttachments(to)
	-- Not using self.Attachments here because that's only relevant for deletion (ragdoll issues)
	for _, child in ipairs(self:GetChildren()) do
		if child:GetClass() != "cc_attachment" then
			continue
		end

		local attach = child:GetType()
		local data = child:CopyModel()


		if attach == ATTACH_FOLLOW then
			to:AddAttachmentFollower(data, child:GetAttachmentID(), child:GetLocalPos(), child:GetLocalAngles())
		elseif attach == ATTACH_FOLLOW_BONE then
			PrintTable(child:GetTable())
			to:AddBoneFollower(data, child:GetAttachmentID(), child:GetLocalPos(), child:GetLocalAngles())
		elseif attach == ATTACH_BONEMERGE then
			to:AddBonemerge(data)
		end
	end
end

function ENTITY:ClearAttachments()
	if not self.Attachments then
		return
	end

	for _, child in ipairs(self.Attachments) do
		if IsValid(child) then
			child:Remove()
		end
	end

	self.Attachments = nil
end
