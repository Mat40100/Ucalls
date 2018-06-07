SLASH_BOOLCALL1 = "/Calls"

SlashCmdList["BOOLCALL"] = function(msg)
	if Uclass:ChangeOption(msg) == false then 
		if msg == "opt" then
			Uclass:ThrowOptions()
		else
			print("Cette option n'existe pas")
		end
	end
end
