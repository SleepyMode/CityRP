
local GM = GAMEMODE or GM

-- Table holding the local player's inventory
GM.Inventory = {}


--[[-------------------------------------------------------------------------
Networking Receivers
---------------------------------------------------------------------------]]
net.Receive("cityrp_svcl_opencharcreation", function(len)
	-- TODO: Open character creation
end)

net.Receive("cityrp_svcl_notify", function(len)
	notification.AddLegacy(net.ReadString(), NOTIFY_GENERIC, 5)
end)

net.Receive("cityrp_svcl_updateinventory", function(len)
	GM.Inventory = net.ReadTable()
end)