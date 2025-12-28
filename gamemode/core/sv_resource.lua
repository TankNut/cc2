local logger = log.Create("resource")

local whitelist = table.Lookup({
	"materials",
	"models",
	"particles",
	"resource",
	"sound"
})

if Loaded then
	return
end

for _, addon in ipairs(engine.GetAddons()) do
	if not addon.mounted or not addon.downloaded then
		continue
	end

	local _, folders = file.Find("*", addon.title)

	for _, folder in ipairs(folders) do
		if whitelist[folder] then
			logger:Info("Adding workshop item - %s (%s)", addon.title, addon.wsid)

			resource.AddWorkshop(addon.wsid)

			break
		end
	end
end
