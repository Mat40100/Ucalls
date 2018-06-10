SLASH_BOOLCALL1 = "/Calls"
SLASH_CALLTIMER1 = "/CallTimer"

SlashCmdList["BOOLCALL"] = function(msg)
	if ChangeOption(msg) == false then
		if msg == "opt" then
			ThrowOptions()
		elseif msg =="CallTimer" then
			print("This variable must be change via /CallTimer + X")
		else
			print("Cette option n'existe pas")
		end
	end
end

SlashCmdList["CALLTIMER"] = function(msg)
	ChangeTimer(msg)
end
