local PlayerFramesLoaded = 0
local PlayerFrameHeight = 15


function LoadMainFrame(UcallGroupSize)
  local MainTrackFrame
  local SizePerPlayer = UcallGroupSize * PlayerFrameHeight

  MainTrackFrame = CreateFrame("frame","MyAddonFrame")
  MainTrackFrame:SetBackdrop({
        bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
        tile=1, tileSize=32, edgeSize=1,
        insets={left=0, right=0, top=0, bottom=0}
  })
  MainTrackFrame:SetWidth(200)
  MainTrackFrame:SetHeight(SizePerPlayer)
  MainTrackFrame:SetPoint("LEFT",UIParent)
  MainTrackFrame:EnableMouse(true)
  MainTrackFrame:SetMovable(true)
  MainTrackFrame:RegisterForDrag("LeftButton")
  MainTrackFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
  MainTrackFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
  MainTrackFrame:SetFrameStrata("FULLSCREEN_DIALOG")
  return MainTrackFrame
end

function CreatePlayerFrame()
  local OffsetTop = PlayerFrameHeight * PlayerFramesLoaded * (-1)
  local InnerFrame = nil

  InnerFrame = CreateFrame("frame", MainUi)
  InnerFrame:SetBackdrop({
        bgFile="Interface/Tooltips/UI-Tooltip-Background",
        edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
        tile=1, tileSize=32, edgeSize=1,
        insets={left=0, right=0, top=0, bottom=0}
  })
  InnerFrame:SetHeight(PlayerFrameHeight)
  InnerFrame:SetWidth(0)
  --obj:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy);
  InnerFrame:SetPoint("TOPLEFT", MainUi,"TOPLEFT", 0, OffsetTop)

  return InnerFrame
end

function MainFrameResize(MainUi, UcallGroupSize)
  local SizePerPlayer = UcallGroupSize * PlayerFrameHeight
    MainUi:SetHeight(SizePerPlayer)
  return MainUi
end

function PlayerFrameResize(name,UcallGroup)
    local Counter = UcallGroup[name]["Counter"]
    if Counter > 10 then Counter = 10 end

    local Size = Counter * 20
    if Counter > 8 then UcallGroup[name]["frame"]:SetBackdropColor(117,0,0) end
    UcallGroup[name]["frame"]:SetWidth(Size)

  return UcallGroup
end

function PlayerFrameHide(UcallGroup,name)
  PlayerFramesLoaded = PlayerFramesLoaded -1
  Debug("FrameController","Frames load",PlayerFramesLoaded)
  UcallGroup[name]["frame"]:Hide()

  return UcallGroup
end

function LoadGroupFrames(UcallGroup, UcallGroupSize)
  if UpdateInProgress == true then
    for k,v in pairs(UcallGroup) do
      if UcallGroup[k]["frame"]== nil then
        UcallGroup[k]["frame"] = CreatePlayerFrame()
        PlayerFrameResize(k,UcallGroup)
        PlayerFramesLoaded = PlayerFramesLoaded + 1
        Debug("FrameController","Frames load",PlayerFramesLoaded)
      end
    end
    UpdateInProgress = false
  end
  return UcallGroup
end
