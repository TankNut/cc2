ITEM.Category       = "Elite Armor"

ITEM.Name           = "Sangheili Major Armor"
ITEM.Description    = "Armor belonging to a Sangheili Major."

ITEM.Rarity         = RARITY_UNCOMMON

ITEM.Model          = Model("models/valk/h3/covenant/props/cortanabeacon/cortanabeacon.mdl")

ITEM.EquipmentSlots = {"elite"}

ItemDataFunc("PlayerColor")

ItemDataFunc("EliteModel", Model("models/halo_reach/players/elite_officer.mdl"))
ItemDataFunc("EliteSkin", 1)

if SERVER then
	function ITEM:GetModelData(ply, clothing)
		if not self:IsEquipped() then
			return
		end

		return {
			_base = {
				Model = self:GetEliteModel(),
				Skin = self:GetEliteSkin(),
				Color = self:GetPlayerColor()
			}
		}
	end
end
