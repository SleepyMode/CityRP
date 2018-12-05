
-- Displays a message with warning colors
function WarningMessage(message, ...)
	MsgC(Color(255, 100, 0), string.format(message, ...), "\n")
end

-- By Mitch McMabers
-- https://stackoverflow.com/questions/12394841/safely-remove-items-from-an-array-table-while-iterating/12397571
function ArrayRemove(t, fnKeep)
	local j, n = 1, #t;

	for i=1, n do
			if (fnKeep(t, i, j)) then
					-- Move i's kept value to j's position, if it's not already there.
					if (i != j) then
							t[j] = t[i];
							t[i] = nil;
					end
					j = j + 1; -- Increment position of where we'll place the next kept value.
			else
					t[i] = nil;
			end
	end

	return t;
end