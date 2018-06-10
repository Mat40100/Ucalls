SLASH_BOOLCALL1 = "/Calls"
SLASH_CALLTIMER1 = "/CallTimer"
SLASH_CALLDEBUG1 = "/CallDebug"

SlashCmdList["BOOLCALL"] = function(msg)
	if ChangeOption(msg) == false then
		if msg == "opt" then
			ThrowOptions()
		elseif msg =="CallTimer" or msg =="Debug" then
			print("This variable must be change in other way")
		else
			print("Cette option n'existe pas")
		end
	end
end

SlashCmdList["CALLTIMER"] = function(msg)
	ChangeTimer(msg)
end

SlashCmdList["CALLDEBUG"] = function(msg)
	if ChangeDebugger(msg) then
		print("Debugger :",Options["Debug"])
	else
		print("Ce module n'existe pas")
	end
end
