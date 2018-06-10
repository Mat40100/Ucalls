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

local killCounter = 0
local rowCounter = 0
local TimerCounter = 0
local TimerRow = 0


function Uclass:Call(sourceName, destType)
	Debug("Uclass","Call function called",true)--print("Call ok")
	if Uclass:VarTest(sourceName, destType) then
		Debug("Uclass","VarTest passed",true)
		Uclass:KillCounterInc()
		Uclass:RowCounterInc()
		Uclass:TimerReset()
		Uclass:SoundParser()
	end
end

function Uclass:VarTest(sourceName, destType)
	if sourceName == playerName then
		Debug("Uclass","playerName test",true)

		for k,v in pairs(Options) do
		Debug("Uclass","Call function called",true)
			-- Chack 1 by 1 options with type to see if it must call --
			if (string.find(destType, k) ~= nil) and Options[k] == true then
				Debug("Uclass","Killed type",Options[k])
				return true
			else
				Debug("Uclass","Killed type",false)
			end

		end
	else
		Debug("Uclass","playerName test",false)
		return false
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
	Debug("Uclass","Killcounter",killCounter)
	if killCounter > 30 then
		Uclass:KillCounterReset()
		Debug("Uclass","Counter reset",true)
	end
end

function Uclass:KillCounterReset()
	--print("Counter has restarted")
	killCounter = 0
	Debug("Uclass","counter has been reset",killCounter)
end

function Uclass:RowCounterReset()
	rowCounter = 0
	Debug("Uclass","Row counter reset",rowCounter)
end

function Uclass:RowCounterInc()
	rowCounter = rowCounter + 1
	Debug("Uclass","row counter increase",rowCounter)
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
