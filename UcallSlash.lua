SLASH_BOOLCALL1 = "/Calls"
SLASH_CALLTIMER1 = "/CallTimer"
SLASH_CALLDEBUG1 = "/Debug"


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
	Uclass:ChangeTimer(msg)
end

SlashCmdList["CALLDEBUG"] = function(msg)
	if ChangeDebugger(msg) then
		print("Debugger :",Options["Debug"])
	else
		print("Ce module n'existe pas")
	end
end
