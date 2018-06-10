PlayerEntity = {
  ["Name"] = nil,
  ["Class"] = nil,
  ["Dmg"] = 0,
  ["Heal"] = 0,
  ["Kicks"] = 0
}

function PlayerEntity:NewEntity(name)
  self["Name"]= name
  self["Class"] = UnitClass(name)
  self["Dmg"] = 0
  self["Heal"] = 0
  self["Kicks"] = 0
end

function PlayerEntity:UpdateEntity(parsedEvent)
  if  strfind(parsedEvent["type"],"DAMAGE") ~= nil then
        self:DAMAGE(parsedEvent)
  end
  if  strfind(parsedEvent["type"],"HEAL") ~= nil then
        self:HEAL(parsedEvent)
  end
end

function PlayerEntity:DAMAGE(parsedEvent)
  self["dmg"] = self["dmg"] + parsedEvent["amount"]

  Debug("PlayerEntity","Damage update",self["dmg"])
end

function PlayerEntity:HEAL(parsedEvent)
  self["Heal"] = self["Heal"] + parsedEvent["amount"]

  Debug("PlayerEntity","Heal update",self["Heal"])
end
--[[
parsedEvent["sourceName"]
parsedEvent["destType"]
EventParsed["spellId"]
EventParsed["spellName"]
EventParsed["spellSchool"]
EventParsed["amount"]
EventParsed["overkill"]
EventParsed["school"]
EventParsed["resisted"]
EventParsed["blocked"]
EventParsed["absorbed"]
EventParsed["critical"]
EventParsed["glancing"]
EventParsed["crushing"]
EventParsed["isOffHand"]]
