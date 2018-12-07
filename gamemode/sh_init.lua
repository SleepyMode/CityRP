
-- Basic Gamemode Data
GM.Name = "CityRP"
GM.Author = "Zoephix & SleepyMode"

PLAYER = FindMetaTable("Player")
ENTITY = FindMetaTable("Entity")


--[[-------------------------------------------------------------------------
Module Library
---------------------------------------------------------------------------]]

local loadedModules = {}
local noLoadModules = {
	--["dev"] = true
}

-- Internally loads the module
local function loadModule(moduleName)
	-- Lower the name of the module
	-- Just in case one of us goes full on retard
	moduleName = moduleName:lower()

	-- Check if the module is already loaded
	-- or it it's on the no-load list
	if (loadedModules[moduleName] or noLoadModules[moduleName]) then
		-- Don't load the module (again)
		return
	end

	-- Get the shared module file
	local path = "cityrp/gamemode/modules/" .. moduleName .. "/sh_module.lua"

	-- If it exists, include it and send it to the client
	if (file.Exists("cityrp/gamemode/" .. path, "LUA")) then
		AddCSLuaFile(path)
		include(path)

		loadedModules[moduleName] = true
	end
end

-- Load a module
function LoadModule(moduleName)
	-- Simply call the internal function for now
	-- This function will add additional checks and features in the future
	loadModule(moduleName)
end

-- Loads all modules
function LoadModules()
	local files, folders = file.Find("cityrp/gamemode/modules/", "LUA")

	for k, v in pairs(files) do
		LoadModule(v)
	end
end

--
--
--
--
--
LoadModule("core")
LoadModule("database")
LoadModule("playercore")
LoadModules()
