ITEM.Base = "base_unsc_headwear"

ITEM.Name        = "ECH252 Helmet"
ITEM.Description = "A variation of the standard CH252 combat helmet that can be fully enclosed and enviromentally sealed when combined with an A/X BDU. Comes packaged with a balaclava."

ITEM.Rarity      = RARITY_UNCOMMON
ITEM.Tags        = {"Marine"}

ITEM.ModelGroups = {"Marine"}

ITEM.HelmetIndex = 3

ITEM.Actions = {}

ItemCustomization(ITEM_ACTION_CUSTOMIZE + 3, "Toggle Helmet", "Helmet")
ItemCustomization(ITEM_ACTION_CUSTOMIZE + 2, "Toggle Visor", "Visor")

ItemCustomization(ITEM_ACTION_CUSTOMIZE - 1, "Toggle Balaclava", "Balaclava")

ITEM.Actions.CustomizeHelmet.Name = "Toggle Helmet"
ITEM.Actions.CustomizeHelmet.Context = table.Lookup({"EquipmentContext", "RightClick", "Examine"})

ITEM.Actions.CustomizeVisor.Name = "Toggle Visor"
ITEM.Actions.CustomizeVisor.Context = table.Lookup({"EquipmentContext", "RightClick", "Examine"})

if SERVER then
	function ITEM:GetModelData(ply, clothing)
		if not self:IsEquipped() then
			return
		end

		return {
			_base = {
				Bodygroups = {
					["Helmet&Hair"] = self:GetHelmet() and 0 or self.HelmetIndex,
					Face = self:GetBalaclava() and 1 or 0,
					Helmet_Visor = self:GetHelmet() and 0 or (self:GetVisor() and 5 or 3)
				}
			}
		}
	end
end
