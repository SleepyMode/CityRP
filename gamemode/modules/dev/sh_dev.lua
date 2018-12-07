

-- General warning that the module is active
WarningMessage("[CityRP] The development module is still active!")


--[[-------------------------------------------------------------------------
Functions
---------------------------------------------------------------------------]]
function DebugMessage(msg, ...)
	MsgC(Color(70, 150, 255), "[CityRP] DEBUG: ", string.format(msg, ...), "\n")
end