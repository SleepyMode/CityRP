
local GM = GAMEMODE or GM

GM.ChatTypes = {}

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

		if (type(data.canSee) != "function") then
			if (data.)
			end
		end

		if (type(data.onMessage) != "function") then
			if (data.inCharacter)
				data.onMessage = function(self, player, message)
					chat.AddText(team.GetColor(player:Team()), player:Name(), self.color or Color(234, 243, 255), ": ", message)
				end
			else
				data.onMessage = function(self, player, message)
					chat.AddText(team.GetColor(player:Team()), player:SteamName(), self.color or Color(234, 236, 240), ": ", message)
				end
			end
		end
	else
		WarningMessage("[CityRP] Attempted to register chat type duplicate %s!", name)
	end
end