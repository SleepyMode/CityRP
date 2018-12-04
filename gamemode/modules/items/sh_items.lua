
local GM = GAMEMODE or GM

ITEM_DATABASE = {}

local baseItem = {
	name = "Base Item",
	desc = "Base item.",
	model = Model("models/error.mdl"),
	color = Color(125, 125, 125, 185),
	illegal = false,
	price = 10,

	OnUse = function(self, ply, data) end,
	OnDrop = function(self, ply, pos) end,
	OnPickup = function(self, ply, pos) end,
	OnSell = function(self, ply) end,
	OnBuy = function(self, ply) end
}

function GM:ItemExists(id)
	return (ITEM_DATABASE[id] != nil)
end

function GM:GetItemData(id)
	return ITEM_DATABASE[id]
end

--[[-------------------------------------------------------------------------
Item registration
---------------------------------------------------------------------------]]
function RegisterItem(itemData)
	local id = table.insert(ITEM_DATABASE, itemData)

	-- Debug;
	-- Remove before release!
	print(string.format("[CityRP] Registered item #%u \"%s\"", id, itemData.name))
end

local function registerItems()
	local files, folders = file.Find("gamemode/modules/items/items", "LUA")

	for k, v in pairs(files) do
		ITEM = table.Copy(baseItem)

		if (SERVER) then AddCSLuaFile("items/" .. v) end
		include("items/" .. v)

		RegisterItem(ITEM)

		ITEM = nil
	end
end

registerItems()