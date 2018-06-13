local CombatLogHandlers = {}
local CombatFrame = CreateFrame("Frame")

local PlayerLogHandlers = {}
local PlayerFrame = CreateFrame("Frame")


local RefreshFrame = CreateFrame("Frame")
local RefreshTime = 1
local Delta = 0

local UcallGroup = {}
local UcallGroupSize = 0
local MainUiIsLoaded = false
UpdateInProgress = false
MainUi = nil

Options ={
	Calls = true,
	Creature = true,
	Player = true,
	CallTimer = 13,
	Debug = "all"
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

	UcallPlayerName = UnitName("player")

	--Verifie que le joueur n'existe pas dans la table (pour les changement d'instance par exemple)--

	if setContains(UcallGroup,playerName) == false then
		UcallGroup[UcallPlayerName] = {
			Counter = 0,
			frame = nil
		}
		UpdateInProgress = true
	end

	UcallGroup = getPlayersInGroup(UcallGroup)
	UcallGroupSize = tablelength(UcallGroup)

	if MainUiIsLoaded then
		MainFrameResize(UcallGroupSize)
	else
		MainUi = LoadMainFrame(UcallGroupSize)
		MainUiIsLoaded = true
	end


	UcallGroup = LoadGroupFrames(UcallGroup,UcallGroupSize)

	Debug("Controller","Main debugger",UcallGroup)
end

function PlayerLogHandlers:PLAYER_REGEN_DISABLED(...)
	--Combat Start--
	Debug("Controller","Combat","Start")
end

function PlayerLogHandlers:PLAYER_REGEN_ENABLED(...)
	--Combat End--
	Debug("Controller","Combat","End")
end

function PlayerLogHandlers:GROUP_ROSTER_UPDATE(...)
	UcallGroup = UpdatePlayerInGroup(UcallPlayerName,UcallGroup)
	UcallGroupSize = tablelength(UcallGroup)
	Debug("Controller","Group Update",UcallGroup)
	Debug("Controller","Group Size",UcallGroupSize)
	MainUi = MainFrameResize(MainUi, UcallGroupSize)
	LoadGroupFrames(UcallGroup,UcallGroupSize)
end

function CombatLogHandlers.COMBAT_LOG_EVENT_UNFILTERED(...)
	local eventParsed= CombatEventParser(...)
		if (eventParsed["type"] == "PARTY_KILL") and (eventParsed["sourceName"] == UcallPlayerName) then
			Debug("Uclass","Party_kill event",true)
			Uclass:Call(eventParsed)
			UcallGroup[UcallPlayerName]["Counter"] = Uclass:GetKillCounter()
			Debug("Uclass","Return Counter test",UcallGroup[UcallPlayerName]["Counter"])
			UcallGroup = PlayerFrameResize(UcallPlayerName,UcallGroup)
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
	--OnUpdate(elapsed)
end)
