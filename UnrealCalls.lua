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
			if (string.find(destType, k) ~= nil) and Options[k] == true then
				Debug("Uclass","Killed type",Options[k])
				return true
			else
				Debug("Uclass","Killed type",false)
			end
		end
	else
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

function Uclass:ThrowOptions()
	print("==== Options =====")
	for k,v in pairs(Options) do
		print(k,Options[k])
	end
	print("================")
end
function Uclass:getOption(option)
	return Options[option]
end

function Uclass:setOption(option)
	if Options[option] then
		Options[option] = false
	else
		Options[option] = true
	end
	print(option, Options[option])
end

function Uclass:ChangeTimer(timer)
	timer = math.floor(timer)
	Options["CallTimer"] = timer
	print("CallTimer is now "..Options["CallTimer"])
end

function Uclass:ChangeOption(option)
	local exists = false
	if option == "CallTimer" then
	else
		for k,v in pairs(Options) do
			if k == option then
			exists = true
			end
		end
	end
	if exists == true then
		Debug("Uclass","Option exist",true)
		Uclass:setOption(option)
		return true
	elseif exists == false then
		return false
	end
end
