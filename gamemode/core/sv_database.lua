module("Database", package.seeall)

function Initialize(db)
	GAMEMODE.Database = db

	db:Query([[CREATE TABLE IF NOT EXISTS `rp_players` (
		`SteamID` VARCHAR(32) NOT NULL,
		PRIMARY KEY (`SteamID`)
	)]])

	db:Query([[CREATE TABLE IF NOT EXISTS `rp_characters` (
		`id` INT NOT NULL AUTO_INCREMENT,
		`SteamID` VARCHAR(32) NOT NULL,
		`Created_At` INT UNSIGNED NOT NULL,
		`Deleted_At` INT UNSIGNED,
		PRIMARY KEY(`id`),
		INDEX(`SteamID`),
		INDEX(`Deleted_At`)
	)]])

	db:Query([[CREATE TABLE IF NOT EXISTS `rp_items` (
		`id` INT NOT NULL AUTO_INCREMENT,
		`Class` VARCHAR(64) NOT NULL,
		`StoreType` INT,
		`StoreID` VARCHAR(64),
		`MapData` BLOB,
		`CustomData` BLOB,
		`Created_At` INT UNSIGNED NOT NULL,
		`Deleted_At` INT UNSIGNED,
		PRIMARY KEY(`id`),
		INDEX(`StoreType`, `StoreID`),
		INDEX(`Deleted_At`)
	)]])

	db:Query([[CREATE TABLE IF NOT EXISTS `rp_globals` (
		`Map` VARCHAR(32) NOT NULL,
		`Key` VARCHAR(64) NOT NULL,
		`Value` BLOB NOT NULL,
		`StoreID` VARCHAR(64),
		`MapData` BLOB,
		`CustomData` BLOB,
		PRIMARY KEY(`Map`, `Key`)
	)]])

	db:Query([[CREATE TABLE IF NOT EXISTS `rp_bans` (
		`SteamID` VARCHAR(32) NOT NULL,
		`Admin` VARCHAR(32) NOT NULL,
		`Timestamp` INT UNSIGNED NOT NULL,
		`Length` INT UNSIGNED NOT NULL,
		`Reason` VARCHAR(256) NOT NULL,
		PRIMARY KEY(`SteamID`)
	)]])

	db:Query([[CREATE TABLE IF NOT EXISTS `rp_logs` (
		`id` INT NOT NULL AUTO_INCREMENT,
		`Name` VARCHAR(64) NOT NULL,
		`Log` TEXT NOT NULL,
		`Timestamp` INT UNSIGNED NOT NULL,
		`Data` BLOB,
		PRIMARY KEY(`id`),
		INDEX(`Name`),
		INDEX(`Timestamp`)
	)]])

	db:Query([[CREATE TABLE IF NOT EXISTS `rp_log_data` (
		`id` INT NOT NULL,
		`Key` VARCHAR(64) NOT NULL,
		`Value` VARCHAR(512) NOT NULL,
		INDEX(`Key`, `Value`)
	)]])

	db:Query("ALTER TABLE `rp_log_data` ADD CONSTRAINT FOREIGN KEY (`id`) REFERENCES `rp_logs` (`id`) ON DELETE CASCADE")

	db:Query([[CREATE TABLE IF NOT EXISTS `rp_worldents` (
		`id` INT NOT NULL AUTO_INCREMENT,
		`Class` VARCHAR(64) NOT NULL,
		`Map` VARCHAR(32) NOT NULL,
		`MapData` BLOB,
		`CustomData` BLOB,
		PRIMARY KEY(`id`),
		INDEX(`Map`)
	)]])

	PopulateFromVars(db, "rp_players", PlayerVar.Vars)
	PopulateFromVars(db, "rp_characters", CharacterVar.Vars)

	-- Clean up bot characters
	db:Query("DELETE FROM rp_characters WHERE SteamID = 'BOT'")
end

function PopulateFromVars(db, tableName, vars)
	local columns = {}

	for _, column in pairs(db:Query(string.format("SHOW COLUMNS FROM `%s`", tableName))) do
		columns[column.Field] = string.upper(column.Type)
	end

	local fields = {}

	for name, data in pairs(vars) do
		local column = columns[data.Field]

		if not data.Persist or column == data.DataType then
			continue
		end

		if column == nil then
			table.insert(fields, string.format("ADD COLUMN `%s` %s", data.Field, data.DataType))
		else
			table.insert(fields, string.format("MODIFY COLUMN `%s` %s", data.Field, data.DataType))
		end
	end

	if #fields > 0 then
		db:Query(string.format("ALTER TABLE `%s` %s", tableName, table.concat(fields, ", ")))
	end
end

function GM:LoadDatabase()
	async.Start(function()
		local config = Config.Get("Database")

		Initialize(database.New(config.Host, config.Username, config.Password, config.Database, config.Port))

		Access.LoadBans()
		Item.LoadWorld()
		GlobalVar.Load()
		WorldEnts.LoadEntities()
	end)
end
