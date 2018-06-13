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
	--Uclass:ChangeTimer(msg)
end

SlashCmdList["CALLDEBUG"] = function(msg)
	if ChangeDebugger(msg) then
		print("Debugger :",Options["Debug"])
	else
		print("Ce module n'existe pas")
	end
end

function ThrowOptions()
	print("==== Options =====")
	for k,v in pairs(Options) do
		print(k,Options[k])
	end
	print("================")
end

function setOption(option)
  -- Invert the option thrown in this function --
	if Options[option] then
		Options[option] = false
	else
		Options[option] = true
	end
	print(option, Options[option])
end

function ChangeOption(option)
  -- Check first if someone is tryng to change CallTimer via this way --
  --Debug("Tools","Change option is called ", true)
	local exists = false
	if option == "CallTimer" or option == "Debug" then
	else
		for k,v in pairs(Options) do
			if k == option then
			exists = true
			end
		end
	end
	if exists == true then
		--Debug("Tools","Option exist",true)
	  setOption(option)
		return true
	elseif exists == false then
		return false
	end
end

function ChangeDebugger(string)
  if type(string) == "string" then
    if tContains(Modules,string) then
      Options["Debug"] = string
      return true
    else
      return false
    end
  else
    return false
  end
end
