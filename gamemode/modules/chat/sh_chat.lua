
local GM = GAMEMODE or GM

GM.ChatTypes = {}

--[[-------------------------------------------------------------------------
Functions
---------------------------------------------------------------------------]]
function GM:RegisterChatType(name, data)
	if (GM.ChatTypes[name] == nil) then
		if (type(data.canUse) != "function") then
			if (data.adminOnly) then
				data.canUse = function(self, player)
					return player:IsAdmin()
				end
			elseif (data.superadminOnly) then
				data.canUse = function(self, player)
					return player:IsSuperAdmin()
				end
			elseif (data.inCharacter) then
				data.canUse = function(self, player)
					return player:HasCharacter() and player:Alive()
				end
			else
				data.canUse = function(self, player)
					return true
				end
			end
		end

		if (data.canSee != nil) then
			if (type(data.canSee) == "number") then
				local dist = data.canSee * data.canSee

				data.canSee = function(self, listener, speaker)
					return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= dist
				end
			end
		else
			if (data.inCharacter) then
				data.canSee = function(self, listener, speaker)
					return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= 78400
				end
			else
				data.canSee = function(self, listener, speaker)
					return true
				end
			end
		end

		if (type(data.onMessage) != "function") then
			if (data.inCharacter) then
				data.onMessage = function(self, player, message)
					chat.AddText(team.GetColor(player:Team()), player:Name(), self.color or Color(234, 243, 255), ": ", message)
				end
			else
				data.onMessage = function(self, player, message)
					chat.AddText(team.GetColor(player:Team()), player:SteamName(), self.color or Color(234, 236, 240), ": ", message)
				end
			end
		end

		GM.ChatTypes[name] = data
	else
		WarningMessage("[CityRP] Attempted to register chat type duplicate %s!", name)
	end
end

function GM:ParseChatType(message)
	local chatType, msg

	for k, v in pairs(self.ChatTypes) do
		for _, prefix in (v.prefix) do
			if (string.sub(string.lower(message), 0, string.len(prefix)) == prefix) then
				chatType = k
				msg = string.sub(message, string.len(prefix))
			end
		end
	end

	if (!chatType) then
		chatType = "Local"
		msg = message
	end

	return chatType, msg
end

--[[-------------------------------------------------------------------------
Chat Type Registration
---------------------------------------------------------------------------]]
GM:RegisterChatType("Local", {
	prefix = {"/local"},
	canSee = 78400,
	inCharacter = true,
	color = Color(175, 200, 200)
})

GM:RegisterChatType("Yell", {
	prefix = {"/y"},
	canSee = 313600,
	inCharacter = true,
	color = Color(255, 120, 0)
})

GM:RegisterChatType("Whisper", {
	prefix = {"/w"},
	canSee = 4900,
	inCharacter = true,
	color = Color(53, 81, 92)
})

GM:RegisterChatType("OOC", {
	prefix = {"/ooc", "//"},
	color = Color(255, 255, 255)
})

GM:RegisterChatType("LOOC", {
	prefix = {"/looc"},
	canSee = 313600,
	color = Color(255, 255, 255)
})