local BaseClass = inherit.Get("item", "base")

ITEM.Internal = true

ITEM.Rarity   = RARITY_COMMON
ITEM.Category = "Radio"

ITEM.Model = Model("models/Items/combine_rifle_cartridge01.mdl")

ITEM.EquipmentSlots = {"radio"}

ITEM.EquipTime   = 0.25
ITEM.UnequipTime = 0.25

ITEM.Actions = {}

ITEM.CanSetFrequency = false -- Determines whether a radio is restricted to presets
ITEM.CanEncrypt      = false -- Determines whether an encrpytion can be set

ITEM.RadioPresets = {} -- Organization radio channels like CCA_MAIN, NYPD, UNSC, etc
ITEM.RadioGroups  = {} -- Overarching radio groups; determines who receives a dispatch message

ITEM.RadioSettings = {} -- Channel-specific settings like frequency, enabled, etc

ITEM.Locked     = nil -- Set by player; determines whether the radio's configuration can be changed
ITEM.Encryption = nil -- Set by player; facilitated encrpyted traffic between radios
ITEM.Channel    = 1   -- Set by player; active index in RadioSettings

ITEM.Actions.OpenGUI = {
	Name       = "Configure Radio",
	ClientOnly = true,
	Priority   = ITEM_ACTION_OPTION - 1,

	CanRun = function(self, ply) return not self:IsLocked() end,
	Client = function(self, ply) ui.Open("Radio") end -- TODO: Add this GUI
}

ITEM.Actions.ToggleLocked = {
	Name     = "ADMIN: Toggle Locked",
	Priority = ITEM_ACTION_OPTION - 2,

	CanRun   = function(self, ply) return ply:IsAdmin() end,
	Client   = function(self, ply) self:ToggleLocked(ply) end,
	Callback = function(self, ply) self:ToggleLocked(ply) end
}

function ITEM:GetDescription()
	local description = BaseClass.GetDescription(self)

	if self:IsLocked() then
		description = description .. "\n\n<col=red>This radio's configuration is locked.</col>"
	end

	return description
end

function ITEM:IsLocked()
	return self.Locked or false
end

function ITEM:ToggleLocked(ply)
	local locked = not self:IsLocked()

	self.Locked = locked

	ply:SendChat("NOTICE", string.format("This radio has been %s!", locked and "locked" or "unlocked"))
end

function ITEM:SetEncryption(encryption)
	self.Encryption = encryption
end

function ITEM:SetChannel(channel)
	self.Channel = channel
end
