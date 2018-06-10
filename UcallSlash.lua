SLASH_BOOLCALL1 = "/Calls"
SLASH_CALLTIMER1 = "/CallTimer"

SlashCmdList["BOOLCALL"] = function(msg)
	if ChangeOption(msg) == false then
		if msg == "opt" then
			ThrowOptions()
		else
			print("Cette option n'existe pas")
		end
	end
end

SlashCmdList["CALLTIMER"] = function(msg)
	ChangeTimer(msg)
end
