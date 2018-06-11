local CombatLogHandlers = {}
local PlayerLogHandlers = {}
local PlayerFrame = CreateFrame("Frame")
local CombatFrame = CreateFrame("Frame")
local RefreshFrame = CreateFrame("Frame")

	local RefreshTime = 1
	local Delta = 0

	Options ={
		Calls = true,
		Creature = true,
		Player = true,
		CallTimer = 13,
		Debug = "Parser"
	}
	petName = nil
	Modules ={
		"all",
		"none",
		"Controller",
		"Parser",
		"Tools",
		"Uclass",
		"EventParser",
		"Entity",
		"Dpsmeter"
	}

	PlayersArray ={}

function PlayerLogHandlers:PLAYER_ENTERING_WORLD(...)
	playerName = UnitName("player")
	ResetGroupVar()
	Debug("Entity","player's table",PlayersArray)
end

function PlayerLogHandlers:PLAYER_REGEN_DISABLED(...)
	--Combat Start--
	Debug("Controller","Combat","Start")

end

function PlayerLogHandlers:PLAYER_REGEN_ENABLED(...)
	--Combat End--
	Debug("Controller","Combat","End")
	for k,v in pairs(PlayersArray) do
		Debug("Dpsmeter",PlayersArray[k].Name,PlayersArray[k].Dmg)
	end
	ResetGroupVar()
end

function CombatLogHandlers.COMBAT_LOG_EVENT_UNFILTERED(...)
	local eventParsed= CombatEventParser(...)

	if (eventParsed["type"] == "PARTY_KILL") and (eventParsed["sourceName"] == playerName) then
		Debug("Uclass","Party_kill event",true)
		Uclass:Call(eventParsed)
	end
	--if eventParsed["sourceName"] == "Xper" and (strfind(eventParsed["type"],"DAMAGE") ~= nil) then print(eventParsed["spellName"],eventParsed["amount"]) end
	if setContains(PlayersArray,eventParsed["sourceName"]) then
		Debug("Controller","Event detected",eventParsed["sourceName"])
		if strfind(eventParsed["type"],"DAMAGE") then
			PlayersArray[eventParsed["sourceName"]]:DAMAGE(eventParsed)
		end
	end
end

function OnUpdate(elapsed)
	Delta = Delta + elapsed
	if (Delta > RefreshTime) then
		Uclass:Timer()
		Delta = 0
	end
end

-- HANDLERS --
for event , _ in pairs ( CombatLogHandlers ) do
	CombatFrame : RegisterEvent ( event )
end

for event , _ in pairs ( PlayerLogHandlers ) do
	PlayerFrame : RegisterEvent ( event )
end

CombatFrame : SetScript ("OnEvent", function ( self , event , ...)
	CombatLogHandlers [ event ](...)
end)

PlayerFrame : SetScript ("OnEvent", function ( self , event , ...)
	PlayerLogHandlers [ event ](...)
end)

RefreshFrame:SetScript("OnUpdate",function (self, elapsed)
	OnUpdate(elapsed)
end)
