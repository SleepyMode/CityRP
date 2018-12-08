
local GM = GAMEMODE or GM

util.AddNetworkString("cityrp_chat")


function GM:PlayerSay(sender, text, teamChat)
	local chatType, msg = self:ParseChatType(text)
	local cType = self.ChatTypes[chatType]
	local receivers = {}

	if (cType:canUse(sender)) then
		for k, v in pairs(player.GetAll()) do
			if (cType:canSee(v, sender)) then
				table.insert(receivers, v)
			end
		end
	else
		sender:Notify("You may not use this chat type right now.")
	end

	for k, v in pairs(receivers) do
		net.Start("cityrp_chat")
			net.WriteEntity(sender)
			net.WriteString(chatType)
			net.WriteString(msg)
		net.Send(v)
	end
end

function GM:PlayerCanSeePlayersChat(text, bTeam, listener, speaker)
	local chatType, msg = GM:ParseChatType(text)
end