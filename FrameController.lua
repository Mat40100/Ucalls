function LoadMainFrame(GroupSize)
  local SizePerPlayer = GroupSize * 20
  MainTrackFrame = CreateFrame("frame","MyAddonFrame")
  MainTrackFrame:SetBackdrop({
        bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
        tile=1, tileSize=32, edgeSize=1,
        insets={left=1, right=1, top=1, bottom=1}
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
end

function CreatePlayerFrame(Ucall_Name)
local InnerFrame = nil
  InnerFrame = CreateFrame("frame",Ucall_Name, MainTrackFrame)
  InnerFrame:SetBackdrop({
        bgFile="Interface/Tooltips/UI-Tooltip-Background",
        edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
        tile=1, tileSize=32, edgeSize=1,
        insets={left=1, right=1, top=1, bottom=1}
  })
  InnerFrame:SetHeight(20)
  InnerFrame:SetWidth(0)
  --obj:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy);
  InnerFrame:SetPoint("TOPLEFT", MainTrackFrame)

  return InnerFrame
end

function CreatetitleFrame(Ucall_Name)
local InnerFrame = nil
  InnerFrame = CreateFrame("font",Ucall_Name, MainTrackFrame)
  InnerFrame:SetBackdrop({
        bgFile="Interface/Tooltips/UI-Tooltip-Background",
        edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
        tile=1, tileSize=32, edgeSize=1,
        insets={left=1, right=1, top=1, bottom=1}
  })
  InnerFrame:SetHeight(20)
  InnerFrame:SetWidth(0)
  --obj:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy);
  InnerFrame:SetPoint("TOPLEFT", MainTrackFrame)

  return InnerFrame
end

function FrameResize(Counter,name,Group)
  --if Counter == 0 then Group[name]["frame"]:Hide() end
  if Counter > 10 then Counter = 10 end
  local Size = Counter * 20
  if Counter > 8 then Group[name]["frame"]:SetBackdropColor(117,0,0) end
  Group[name]["frame"]:SetWidth(Size)
end
