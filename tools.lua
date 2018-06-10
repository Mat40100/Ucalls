function Debug(module, name, varToTest)
  --[[ this tool allow player to debug module by module or all at the same time,
  the goal is not to flood chat ]]
  local IsDebugActive= false
  if Options["Debug"] == "all" then
    IsDebugActive == true
  elseif Options["Debug"] == "module" then
    IsDebugActive == true
  end
  if IsDebugActive == true then
    print("Debug Mod var:",name)
    print("Value :",varToTest)
  end
end

--Usefull function to parse the Combat log event--
function CombatEventParser(...)
  local EventParsed ={}

  EventParsed["type"] = select(2,...)
  EventParsed["sourceName"] = select(5,...)
  EventParsed["destType"] = select(8,...)

  if strfind(EventParsed["type"],"DAMAGE") ~= nil then
    -- IF it's DAMAGE after type we hydrate with damage only var --
    EventParsed["amount"] = select(15,...)
    EventParsed["overkill"] = select(16,...)
    EventParsed["school"] = select(17,...)
    EventParsed["resisted"] = select(18,...)
    EventParsed["blocked"] = select(18,...)
    EventParsed["absorbed"] = select(19,...)
    EventParsed["critical"] = select(20,...)
    EventParsed["glancing"] = select(21,...)
    EventParsed["crushing"] = select(22,...)
    EventParsed["isOffHand"] = select(23,...)
  elseif strfind(EventParsed["type"],"HEAL") ~= nil then
    -- IF it's HEAL after type we hydrate with heal only var --
    EventParsed["amount"] = select(15,...)
    EventParsed["overhealing"] = select(16,...)
    EventParsed["absorbed"] = select(17,...)
    EventParsed["critical"] = select(18,...)
  end

  if strfind(EventParsed["type"],"SWING") == nil then
    -- to BE sure to not hydrate var which not exists--
    EventParsed["spellId"] = select(12,...)
    EventParsed["spellName"] = select(13,...)
    EventParsed["spellSchool"] = select(14,...)
  end

  return EventParsed
end

-- OPTION FUNCTIONS --
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

function ChangeTimer(timer)
  --[[ we check that timer arg is a number,
   in that way players can't send wrong var ]]

	timer = math.floor(timer)
	Options["CallTimer"] = timer
	print("CallTimer is now "..Options["CallTimer"])
end

function ChangeOption(option)
  -- Check first if someone is tryng to change CallTimer via this way --
	local exists = false
	if option == "CallTimer" then
	else
		for k,v in pairs(Options) do
			if k == option then
			exists = true
			end
		end
	end
	if exists == true then
		Debug("Uclass","Option exist",true)
	  setOption(option)
		return true
	elseif exists == false then
		return false
	end
end
