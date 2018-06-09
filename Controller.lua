local PlayerEventHandlers = {}
local CombatLogHandlers = {}
local StatutFrame = CreateFrame("Frame")
local CombatFrame = CreateFrame("Frame")
local RefreshFrame = CreateFrame("Frame")

local RefreshTime = 1
local Delta = 0

Options ={
	Calls = true,
	Creature = true,
	Player = true,
	CallTimer = 13,
	Debug = true
}

function CombatLogHandlers.PLAYER_ENTERING_WORLD(...)
	playerName = UnitName("player")
	PlayersArray = {
		[playerName] = PlayerEntity
	}
	PlayersArray[playerName]:NewEntity(playerName)

	Debug("Controller","Nom entité",function(
		for k,v in pairs(PlayersArray[playerName]) do
			print(k,v)
		end
	))
end

function CombatLogHandlers.COMBAT_LOG_EVENT_UNFILTERED(...)
	local eventType = select(2, ...)
	local sourceName = select(5,...)
	local destType = select(8,...)

	local parsedEvent = CombatEventParser(...)

	Debug("Controller","Combat parser:", function(
		for k,v in pairs(ParserTest) do
			print(k,v)
		end
	))

	if eventType == "PARTY_KILL" then
		--if event is PARTY_KILL we call the Unreal class--
		Uclass:Call(sourceName,destType)
	end

	if tContains(PlayersArray,sourceName) then
		PlayerEntity[sourceName]:UpdateEntity(parsedEvent)
	end
end

function PlayerEventHandlers.PLAYER_REGEN_DISABLE(...)
	--Combat Start--
	--Register events to track when entering in combat --
	for event , _ in pairs ( CombatLogHandlers ) do
		CombatFrame : RegisterEvent ( event )
	end
end

function PlayerEventHandlers.PLAYER_REGEN_ENABLE(...)
	--Combat End--
	-- Unregister events when leaving combat--
	for event , _ in pairs ( CombatLogHandlers ) do
		CombatFrame : UnregisterEvent ( event )
	end
	--After the code and sent to screen--
	wipe(PlayersArray)
end

function PlayerEventHandlers.GROUP_ROSTER_UPDATE(...)
	PlayersInGroup = GetHomePartyInfo()
end


function OnUpdate(elapsed)
	Delta = Delta + elapsed
	if (Delta > RefreshTime) then
		Uclass:Timer()
		Delta = 0
	end
end

-- HANDLERS --

CombatFrame : SetScript ("OnEvent", function ( self , event , ...)
	CombatLogHandlers [ event ](...)
end)

RefreshFrame:SetScript("OnUpdate",function (self, elapsed)
	OnUpdate(elapsed)
end)
