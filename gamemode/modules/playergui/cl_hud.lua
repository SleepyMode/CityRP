
hook.Add("HUDShouldDraw", "cityrp.playergui.HUDShouldDraw", function(element)
	if (element == "CHudHealth" or element == "CHudBattery") then
		return false
	end
end)
