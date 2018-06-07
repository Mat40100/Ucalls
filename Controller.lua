local AllEventHandlers = {}
local CombatLogHandlers = {}
local StatutFrame = CreateFrame("Frame")
local CombatFrame = CreateFrame("Frame")
local RefreshFrame = CreateFrame("Frame")

	local RefreshTime = 1
	local Delta = 0

function CombatLogHandlers.PLAYER_ENTERING_WORLD(...)
	playerName = UnitName("player")
end	
	
function CombatLogHandlers.COMBAT_LOG_EVENT_UNFILTERED(...)
	local eventType = select(2, ...)
	local sourceName = select(5,...)
	local destType = select(8,...)
	
	if eventType == "PARTY_KILL" then
		Uclass:Call(sourceName,destType)
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

CombatFrame : SetScript ("OnEvent", function ( self , event , ...)
	CombatLogHandlers [ event ](...)
end)

RefreshFrame:SetScript("OnUpdate",function (self, elapsed)
	OnUpdate(elapsed)
end)