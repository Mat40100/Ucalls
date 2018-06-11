function Debug(module, name, varToTest)
  --[[ this tool allow player to debug module by module or all at the same time,
  the goal is not to flood chat ]]
  local IsDebugActive= false

  if Options["Debug"] == "all" then
    IsDebugActive = true
  end

  if Options["Debug"] == module then
    IsDebugActive = true
  end

  if IsDebugActive == true then
    -- check BTW if varToTest is function to iterate table --
    print("Debug Mod:",name)
    if(type(varToTest) == "table") then
      for k,v in pairs(varToTest) do
        print("__",k,v)
      end
    else
        print("var :",varToTest)
    end

  end
end

function setContains(set, key)
    return set[key] ~= nil
end

function ResetGroupVar()
  local hasUI, isHunterPet = HasPetUI();
  PlayersInGroup = GetHomePartyInfo()
  wipe(PlayersArray)
  PlayersArray ={
    [playerName] = PlayerEntity:new(playerName,UnitClass(playerName))
  }
  if HasPetSpells(UnitName("pet")) ~= nil then
    petName = UnitName("pet")
    PlayersArray ={
      [playerName] = PlayerEntity:new(playerName,UnitClass(playerName)),
      [petName] = PlayerEntity:new(petName,"Pet")
    }
  else
    PlayersArray ={
      [playerName] = PlayerEntity:new(playerName,UnitClass(playerName))
    }
  end
  if PlayersInGroup ~= nil then
    for k,v in pairs(PlayersInGroup) do
      print(k,v)
      table.insert(PlayersArray,PlayerEntity:new(v,UnitClass(v)))
    end
  end
end

--Usefull function to parse the Combat log event--
function CombatEventParser(...)
  local EventParsed ={}
  Debug("EventParser","Parser", true)


  EventParsed["type"] = select(2,...)
  EventParsed["sourceName"] = select(5,...)
  EventParsed["destType"] = select(8,...)

  if strfind(EventParsed["type"],"SWING") == nil then
    -- to BE sure to not hydrate var which not exists--
    Debug("EventParser","SPELL type :", false)
    EventParsed["spellId"] = select(12,...)
    EventParsed["spellName"] = select(13,...)
    EventParsed["spellSchool"] = select(14,...)
  end

  if strfind(EventParsed["type"],"SWING") ~= nil then
    -- to BE sure to not hydrate var which not exists--
    Debug("EventParser","SWING type :", true)
    EventParsed["amount"] = select(12,...)
    EventParsed["overkill"] = select(13,...)
    EventParsed["school"] = select(14,...)
    EventParsed["resisted"] = select(15,...)
    EventParsed["blocked"] = select(16,...)
    EventParsed["absorbed"] = select(17,...)
    EventParsed["critical"] = select(18,...)
    EventParsed["glancing"] = select(19,...)
    EventParsed["crushing"] = select(20,...)
    EventParsed["isOffHand"] = select(21 ,...)
  end

  if(strfind(EventParsed["type"],"DAMAGE") ~= nil)and(strfind(EventParsed["type"],"SWING") == nil) then
    -- IF it's DAMAGE after type we hydrate with damage only var --
    Debug("EventParser","DAMAGE type :", true)
    EventParsed["amount"] = select(15,...)
    EventParsed["overkill"] = select(16,...)
    EventParsed["school"] = select(17,...)
    EventParsed["resisted"] = select(18,...)
    EventParsed["blocked"] = select(19,...)
    EventParsed["absorbed"] = select(20,...)
    EventParsed["critical"] = select(21,...)
    EventParsed["glancing"] = select(22,...)
    EventParsed["crushing"] = select(23,...)
    EventParsed["isOffHand"] = select(24,...)
  elseif strfind(EventParsed["type"],"HEAL") ~= nil then
    -- IF it's HEAL after type we hydrate with heal only var --
    Debug("EventParser","HEAL type :", true)
    EventParsed["amount"] = select(15,...)
    EventParsed["overhealing"] = select(16,...)
    EventParsed["absorbed"] = select(17,...)
    EventParsed["critical"] = select(18,...)
  end

  return EventParsed
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
  Debug("Tools","Change option is called ", true)

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
		Debug("Tools","Option exist",true)
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
