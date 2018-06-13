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
        print("type :",type(varToTest))
        print("var :",varToTest)
    end

  end
end

function setContains(set, key)
    return set[key] ~= nil
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function getPlayersInGroup(UcallGroup)
  local InstantGroup= GetHomePartyInfo()
  if InstantGroup ~= nil then
    for Index,Name in pairs(InstantGroup) do
      if setContains(UcallGroup, Name) == false then
        UcallGroup[Name] ={
    			Counter = 2,
    			frame = nil
    		}
        UpdateInProgress = true
      end
    end
  end

  return UcallGroup
end

function UpdatePlayerInGroup(pName, UcallGroup)
  local InstantGroup= GetHomePartyInfo()
  --Si groupe vide
  if InstantGroup == nil then
    for k,v in pairs(UcallGroup) do
      --Debug("Controller","Table vide","")
     if (pName ~= k)  then
       UcallGroup = PlayerFrameHide(UcallGroup,k)
       UcallGroup[k]=nil
       UpdateInProgress = true
     end
    end
  elseif InstantGroup ~= nil then
    for Name,table in pairs(UcallGroup) do
      Debug("Controller","Maj table","")
        if setContains(InstantGroup, Name) == nil then
          UcallGroup[Name]=nil
          UpdateInProgress = true
        end
    end
  end
  -- Si joureur présent dans InstantGroup mais pas dans UcallGroup
  if InstantGroup ~= nil then
    for Name,table in pairs(UcallGroup) do
      for Index,Name in pairs(InstantGroup) do
        if setContains(UcallGroup, Name) == false then
          UcallGroup[Name] ={
            Counter = 2,
            frame = nil
          }
          UpdateInProgress = true
        end
      end
    end
  end
  return UcallGroup
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
