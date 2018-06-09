PlayerEntity = {}

PlayerEntity:Name
PlayerEntity:Class
PlayerEntity:Dps
PlayerEntity:Heal
PlayerEntity:Kicks

function PlayerEntity:NewEntity(...)
  PlayersArray[sourceName] = PlayerEntity
  PlayersArray[sourceName][Name]=sourceName
    Debug("Entity","Nom entité",PlayersArray[sourceName][Name])
  PlayersArray[sourceName][Class]=sourceName
  PlayersArray[sourceName][Dps]=sourceName
  PlayersArray[sourceName][Heal]=sourceName
  PlayersArray[sourceName][Kicks]=sourceName
end

function PlayerEntity:UpdateEntity(...)

end
