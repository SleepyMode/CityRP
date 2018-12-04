
-- Displays a message with warning colors
function WarningMessage(message, ...)
	MsgC(Color(255, 100, 0), string.format(message, ...), "\n")
end