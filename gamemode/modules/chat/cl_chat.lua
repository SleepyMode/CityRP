
local GM = GAMEMODE or GM


--[[-------------------------------------------------------------------------
Networking
---------------------------------------------------------------------------]]
net.Receive("cityrp_chat", function(len)
	local sender	= net.ReadEntity()
	local chatType	= net.ReadString()
	local message	= net.ReadString()

	if (GM.ChatTypes[chatType]) then
		GM.ChatTypes[chatType]:onMessage(sender, message)
	else
		WarningMessage("[CityRP] Received \"cityrp_chat\" with an invalid chatType %s", chatType);
	end
end)