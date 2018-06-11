Uclass = {}

local SoundsRow = {
	"firstblood",
	"doublekill",
	"multikill",
	"megakill",
	"ultrakill",
	"monsterkill"
}
local SoundsKill = {
	killingspree = 5,
	rampage = 10,
	dominating = 15,
	unstoppable = 20,
	godlike = 30
}

killCounter = 0
local rowCounter = 0
local TimerCounter = 0
local TimerRow = 0


function Uclass:Call(eventParsed)
	Debug("Uclass","Uclass called",eventParsed)
	if Uclass:VarTest(eventParsed["sourceName"],eventParsed["destType"]) then
		Uclass:KillCounterInc()
		Uclass:RowCounterInc()
		Uclass:TimerReset()
		Uclass:SoundParser()
	end
end

function Uclass:VarTest(sourceName, destType)
		for k,v in pairs(Options) do
		--print(k..(" test"))
			if (string.find(destType, k) ~= nil) and Options[k] == true then
				Debug("Uclass","VarTest",true)
				return true
			else
				Debug("Uclass",k,false)
			end
		end
end

function Uclass:Timer()
	if rowCounter > 0 then
		TimerCounter = TimerCounter + 1
	end
	if TimerCounter > Options["CallTimer"] then
		Uclass:TimerReset()
		Uclass:RowCounterReset()
	end
end

function Uclass:TimerReset()
	TimerCounter = 0
end

function Uclass:KillCounterInc()
	killCounter = killCounter + 1
	offset = killCounter*22
	InnerFrame:SetWidth(offset)
	--Kills:SetText("Kills : "..killCounter)
	if killCounter > 30 then
		Uclass:KillCounterReset()
	end
end

function Uclass:KillCounterReset()
	--print("Counter has restarted")
	killCounter = 0
	--Kills:SetText("Kills : "..killCounter)
end

function Uclass:RowCounterReset()
	rowCounter = 0
	--Row:SetText("Row : "..rowCounter)
	--print("rowCounter :"..rowCounter)
end

function Uclass:RowCounterInc()
	rowCounter = rowCounter + 1
	--Row:SetText("Row : "..rowCounter)
end

function Uclass:SoundParser()
	local allreadyPlay = false
	for k, v in pairs(SoundsKill) do
		if (SoundsKill[k] == killCounter) and (killCounter < 31 ) then
			PlaySoundFile("Interface\\AddOns\\Ucall\\Calls\\"..k..".ogg", "Master")
			allreadyPlay = true
		end
	end
	if (rowCounter ~= 0) and (rowCounter < 7) and (allreadyPlay==false) then
		PlaySoundFile("Interface\\AddOns\\Ucall\\Calls\\"..SoundsRow[rowCounter]..".ogg", "Master")
	end
	allreadyPlay = false
end

function Uclass:ChangeTimer(timer)
	timer = math.floor(timer)
	Options["CallTimer"] = timer
	print("CallTimer is now "..Options["CallTimer"])
end
