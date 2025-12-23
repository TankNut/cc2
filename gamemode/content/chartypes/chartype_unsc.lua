CLASS.Name = "UNSC Enlisted"
CLASS.SortOrder = 1

CLASS.Default = true

CLASS.Models = Config.Get("BaseModels")

CLASS.OptionalLanguages = {
	"rus", "spa", "chi",
	"hin", "por", "rus",
	"ger", "jpn", "fra",
	"kor", "hun", "swa"
}

CLASS.Fields = {
	Languages = Language.GetDefaultLanguages()
}

CLASS.Pages = {
	{Name = "Basic Information", Options = {"Name", "Description"}},
	{Name = "Appearance", Options = {"Model", "Height"}},
	{Name = "Options", Options = {"Language"}}
}

CLASS.Options = {
	Name = {
		Name = "Name", Panel = "CC_CharCreate_Name",
		Description = "Your text here!\nAnd here!",
		Field = "CharacterName",
		Args = {
			"English/Masculine",
			"English/Feminine",
			"English/Unisex"
		}
	},
	Description = {
		Name = "Description", Panel = "CC_CharCreate_Multiline",
		Field = "CharacterDescription",
	},
	Model = {
		Name = "Model", Panel = "CC_CharCreate_Model",
		Field = "CharacterModel",
		Args = CLASS.Models
	},
	Height = {
		Name = "Height", Panel = "CC_CharCreate_Slider",
		Field = "CharacterScale",
		Args = {
			Min = 0.95,
			Max = 1.05,
			Notches = 16,
			Decimals = 3,
			Default = 1,
			TranslateLabel = function(val)
				local remap = math.ClampedRemap(val, 0.95, 1.05, 60, 76)

				return string.format("%scm (%s'%s)",
					math.floor(remap * 2.54),
					math.floor(remap / 12),
					math.floor(remap % 12))
			end
		}
	},
	Language = {
		Name = "Extra Language", Panel = "CC_CharCreate_Dropdown",
		Args = table.Add({
			{Name = "None", Value = nil},
		}, table.Map(CLASS.OptionalLanguages, function(lang)
			return {Name = Language.Get(lang).Name, Value = lang}
		end))
	}
}

CLASS.Validate = {
	Name = Config.Get("CharacterNameRules"),
	Description = Config.Get("CharacterDescriptionRules"),
	Model = {
		validate.Required(),
		validate.String(),
		validate.InList(CLASS.Models)
	},
	Height = {
		validate.Required(),
		validate.Number(),
		validate.Min(0.95),
		validate.Max(1.05),
	},
	Language = {
		validate.String(),
		validate.InList(CLASS.OptionalLanguages)
	}
}

if CLIENT then
	local updateFields = table.Lookup({"Model"})

	function CLASS:GetAppearance(options, key)
		if key and not updateFields[key] then
			return
		end

		return {_base = {
			Model = options.Model or self.Models[1]
		}}
	end
else
	function CLASS:PreCreateCharacter(ply, fields, options)
		options.Description = string.Escape(options.Description)

		if options.Language then
			fields.Languages[options.Language] = true
		end

		if options.Height then
			options.Height = math.Round(options.Height, 2)
		end
	end

	function CLASS:PostCreateCharacter(ply, options)
		ply:GiveItem("undersuit_marine_brown"):SetEquipmentSlot("unsc_undersuit")
		ply:GiveItem("armor_marine"):SetEquipmentSlot("unsc_armor")
		ply:GiveItem("helmet_marine"):SetEquipmentSlot("unsc_headwear")
		ply:GiveItem("weapon_ma37"):SetEquipmentSlot("primary")

		local bag = ply:GiveItem("bag_unsc_light")
		bag:SetEquipmentSlot("unsc_back")

		local inventory = bag.Contents

		for _, class in ipairs({"grenade_frag", "grenade_smoke", "grenade_flashbang"}) do
			local item = Item.Create(class, 3)
			item:SetInventory(inventory)
		end
	end
end
