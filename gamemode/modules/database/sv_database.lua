
local GM = GAMEMODE or GM

-- DatabaseConnected Hook
-- Provided by GLua-MySQL-Wrapper (sv_mysql.lua)
--
-- NOTE: Maybe put this each in the specific module? (players for players, etc)
function GM:DatabaseConnected()
	-- Thanks for the idea helix
	local query

	query = mysql:Create("players")
		query:Create("id", "INT AUTO_INCREMENT NOT NULL")
		query:Create("steamid", "VARCHAR(20) NOT NULL")
		query:Create("steamname", "VARCHAR(32) NOT NULL")
		query:Create("firstname", "VARCHAR(32) NOT NULL")
		query:Create("lastname", "VARCHAR(32) NOT NULL")
		query:Create("ipaddress", "VARCHAR(15) NOT NULL")
		query:Create("firstjoin", "INT(11) UNSIGNED DEFAULT NULL")
		query:Create("lastjoin", "INT(11) UNSIGNED DEFAULT NULL")
		query:Create("playtime", "INT(11) UNSIGNED DEFAULT NULL")
		query:Create("gender", "TINYINT(1) NOT NULL")
		query:Create("face", "INT(4) NOT NULL")
		query:Create("clothing", "INT(4) NOT NULL")
		query:Create("inventory", "TEXT")
		query:Create("storage", "TEXT")
		query:Create("cash", "INT NOT NULL")
		query:Create("bank", "INT NOT NULL")
		query:PrimaryKey("id")
	query:Execute()

	query = mysql:Create("vehicles")
		query:Create("id", "INT AUTO_INCREMENT NOT NULL")
		query:Create("type", "INT NOT NULL")
		query:Create("owner", "INT NOT NULL")
		query:Create("trunk", "TEXT")
		query:Create("appearance", "TEXT")
		query:Create("tires", "TINYINT(1) NOY NULL")
		query:Create("damage", "INT NOT NULL")
		query:Create("fuel", "INT NOT NULL")
		query:PrimaryKey("id")
	query:Execute()
end

-- DatabaseConnectionFailed Hook
-- Provided by GLua-MySQL-Wrapper (sv_mysql.lua)
function GM:DatabaseConnectionFailed(errorMessage)
	WarningMessage("[CityRP] Failed to connect to database!\n\t\t%s", errorMessage)
end