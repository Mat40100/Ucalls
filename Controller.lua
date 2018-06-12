local CombatLogHandlers = {}
local PlayerLogHandlers = {}
local PlayerFrame = CreateFrame("Frame")
local CombatFrame = CreateFrame("Frame")
local RefreshFrame = CreateFrame("Frame")

	local RefreshTime = 1
	local Delta = 0
	local Group = {}
	local GroupSize = 0

	Options ={
		Calls = true,
		Creature = true,
		Player = true,
		CallTimer = 13,
		Debug = "Parser"
	}
	petName = nil

	PlayerFrames = {

	}

	Modules ={
		"all",
		"none",
		"Controller",
		"Parser",
		"Tools",
		"Uclass",
		"EventParser",
		"Entity",
		"Dpsmeter",
		"Ucall_Kills"
	}

function PlayerLogHandlers:PLAYER_ENTERING_WORLD(...)
	local GroupSize = 0

	playerName = UnitName("player")
	--Send Message to guild to add him in array, and get return --


	-- Add Player Array to Group array --
	UcallGroup = getPlayersInGroup()

	UcallGroup[playerName] = {
		Ucall_Name="Ucall_"..playerName,
		frame = nil
	}

	GroupSize = tablelength(UcallGroup)
	Debug("Ucall_Kills","Group size",GroupSize)
	Debug("Ucall_Kills","player's table",UcallGroup[playerName])

	LoadMainFrame(GroupSize)
	for k,v in pairs(UcallGroup) do
		local f = CreatePlayerFrame(UcallGroup[k]["Ucall_Name"])
		UcallGroup[k]["frame"] = f
	end
	FrameResize(Uclass:GetKillCounter(),playerName,UcallGroup)
--	PlayerFrames[playerName]["frame"]:SetWidth(100)
end

function PlayerLogHandlers:PLAYER_REGEN_DISABLED(...)
	--Combat Start--
	Debug("Controller","Combat","Start")
end

function PlayerLogHandlers:PLAYER_REGEN_ENABLED(...)
	--Combat End--
	Debug("Controller","Combat","End")
end

function CombatLogHandlers.COMBAT_LOG_EVENT_UNFILTERED(...)
	local eventParsed= CombatEventParser(...)
	local Ucall_Name = nil
	local Counter = 0

	if (eventParsed["type"] == "PARTY_KILL") and (eventParsed["sourceName"] == playerName) then
		Debug("Uclass","Party_kill event",true)
		Uclass:Call(eventParsed)
		Counter = Uclass:GetKillCounter()
		Debug("Ucall_Kills","Return Counter test",Counter)
		FrameResize(Counter,playerName,UcallGroup)
	end
end

function CombatLogHandlers.PLAYER_DEAD(...)
	local Counter = 0
	Uclass:PlayerDied()
	FrameResize(0,playerName,UcallGroup)
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
