
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
	-- IMPORTANT:
	-- Uncomment the dev module once server is released
	-- as it disables join access for most people!
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

	Msg("Loading module \"" .. moduleName .. "\" - ")

	-- Module initialization path
	local path = "cityrp/gamemode/modules/" .. moduleName .. "/sh_module.lua"

	-- If it exists, include it and send it to the client
	if (file.Exists(path, "LUA")) then
		AddCSLuaFile(path)
		include(path)

		loadedModules[moduleName] = true
	end

	MsgC(Color(0, 255, 0), "Done!\n")
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
LoadModule("chat")
LoadModule("dev")
LoadModule("inventorygui")
LoadModule("items")
LoadModule("playerfunctions")
LoadModule("playergui")
LoadModules()
