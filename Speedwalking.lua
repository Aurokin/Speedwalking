-- Register Frames
speedwalkingFrame = CreateFrame("Frame", "SpeedwalkingFrame", UIParent);
speedwalkingTimerFrame = CreateFrame("Frame", "SpeedwalkingTimerFrame", speedwalkingFrame);
speedwalkingObjectiveFrame = CreateFrame("Frame", "speedwalkingObjectiveFrame", speedwalkingFrame);

speedwalkingFrame.secondsToTime = function(seconds)
  local min = math.floor(seconds/60);
  local sec = seconds - (min * 60);
  return min, sec;
end

speedwalkingFrame.formatTimeNoMS = function(time)
  if (time < 10) then
    time = string.format("0%d", time);
  else
    time = string.format("%d", time);
  end
  return time;
end

speedwalkingFrame.speedwalkingTimerText = function(currentZoneID)
  local string = "";
  if speedwalkingFrame.speedwalkingDungeonInfo[currentZoneID] then
    local goldTimer = speedwalkingFrame.speedwalkingDungeonInfo[currentZoneID]["goldTimer"];
    local startTime = speedwalkingFrame.currentTW["startTime"];
    local startMin, startSec;
    local goldMin, goldSec = speedwalkingFrame.secondsToTime(goldTimer);
    -- Format Seconds
    goldSec = speedwalkingFrame.formatTimeNoMS(goldSec);
    -- Create String
    if (startTime) then
      local currentTime = GetTime();
      local secs = currentTime - startTime;
      startMin, startSec = speedwalkingFrame.secondsToTime(secs);
      startMin = speedwalkingFrame.formatTimeNoMS(startMin);
      startSec = speedwalkingFrame.formatTimeNoMS(startSec);
    else
      startMin = "00";
      startSec = "00";
    end
    string = startMin .. ":" .. startSec;
    string = string .. " / ";
    string = string .. goldMin .. ":" .. goldSec;
  end
  return string;
end

speedwalkingFrame.speedwalkingObjectiveText = function(currentZoneID)
  local string = "";
  if speedwalkingFrame.speedwalkingDungeonInfo[currentZoneID] then
    local bosses = speedwalkingFrame.speedwalkingDungeonInfo[currentZoneID]["bosses"];
    local enemies = speedwalkingFrame.speedwalkingDungeonInfo[currentZoneID]["enemies"];
    for k, v in pairs(bosses) do
      string = string .. k .. " - " .. speedwalkingFrame.currentTW["bosses"][k] .."/1\n";
    end
    string = string .. "Enemies - " .. speedwalkingFrame.currentTW["enemies"] .. "/" .. enemies .. "\n";
  end
  return string;
end

speedwalkingFrame.showFrames = function()
  speedwalkingFrame:Show();
  speedwalkingTimerFrame:Show();
  speedwalkingObjectiveFrame:Show();
end

speedwalkingFrame.hideFrames = function()
  speedwalkingFrame:Hide();
  speedwalkingTimerFrame:Hide();
  speedwalkingObjectiveFrame:Hide();
end

speedwalkingFrame.setupTW = function(currentZoneID)
  local bosses = speedwalkingFrame.speedwalkingDungeonInfo[currentZoneID]["bosses"];
  local enemies = speedwalkingFrame.speedwalkingDungeonInfo[currentZoneID]["enemies"];
  speedwalkingFrame.currentTW = nil;
  speedwalkingFrame.currentTW = {};
  speedwalkingFrame.currentTW["zoneID"] = currentZoneID;
  speedwalkingFrame.currentTW["startTime"] = nil;
  speedwalkingFrame.currentTW["endTime"] = nil;
  speedwalkingFrame.currentTW["bosses"] = {};
  for k, v in pairs(bosses) do
    speedwalkingFrame.currentTW["bosses"][k] = 0;
  end
  speedwalkingFrame.currentTW["enemies"] = 0;
end

speedwalkingFrame.checkPositions = function(currentZoneID)
  local dx, dy, distance;
  -- http://wow.gamepedia.com/API_UnitPosition
  local posX, posY, posZ, terrainMapID = UnitPosition("player");
  local startX = speedwalkingFrame.speedwalkingDungeonInfo[currentZoneID]["startingArea"]["x"];
  local startY = speedwalkingFrame.speedwalkingDungeonInfo[currentZoneID]["startingArea"]["y"];
  local safeZone = speedwalkingFrame.speedwalkingDungeonInfo[currentZoneID]["startingArea"]["safeZone"];
  if (terrainMapID == currentZoneID) then
    dx = startX - posX;
    dy = startY - posY;
    distance = math.sqrt((dx * dx) + (dy * dy));
    if (distance > safeZone) then
      -- Player Has Left Safe Zone, Start Timer
      speedwalkingFrame.currentTW["startTime"] = GetTime();
    end
  end
end

speedwalkingFrame.updateInfo = function()
  if (speedwalkingFrame.inTW == true) then
    local startTime = speedwalkingFrame.currentTW["startTime"];
    local currentZoneID = speedwalkingFrame.currentTW["zoneID"];
    if (not startTime) then
      speedwalkingFrame.checkPositions(currentZoneID);
    end
    -- Timer Text
    local timerText = speedwalkingFrame.speedwalkingTimerText(currentZoneID);
    speedwalkingTimerFrame.font:SetText(timerText);
    -- Objective Text
    local objectiveText = speedwalkingFrame.speedwalkingObjectiveText(currentZoneID);
    speedwalkingObjectiveFrame.font:SetText(objectiveText);
  end
end

local function eventHandler(self, event, ...)
  if event == "ADDON_LOADED" then
    speedwalkingFrame.hideFrames();
  elseif event == "ZONE_CHANGED_NEW_AREA" then
    local name, _, difficulty, difficultyName, _, _, _, currentZoneID = GetInstanceInfo();
    if (speedwalkingDungeonInfo and currentZoneID) then
      if (speedwalkingDungeonInfo[currentZoneID]) then
        speedwalkingFrame.setupTW(currentZoneID);
        print("Welcome To " .. speedwalkingDungeonInfo[currentZoneID]["name"]);
        speedwalkingFrame.showFrames();
        speedwalkingFrame.inTW = true;
        speedwalkingFrame.updateInfo();
      else
        speedwalkingFrame.inTW = false;
        speedwalkingFrame.hideFrames();
      end
    end
  end
end



-- Global Variables (Most likely saved later)
speedwalkingFrame.inTW = false;
speedwalkingDungeonInfo = {};
speedwalkingDungeonInfo[670] = {};
speedwalkingDungeonInfo[670]["name"] = "Grim Batol";
-- Key Is Unit Name In Game, Value Is Display Name
speedwalkingDungeonInfo[670]["bosses"] = {};
speedwalkingDungeonInfo[670]["bosses"]["General Umbriss"] = "General Umbriss";
speedwalkingDungeonInfo[670]["bosses"]["Forgemaster Throngus"] = "Forgemaster Throngus";
speedwalkingDungeonInfo[670]["bosses"]["Drahga Shadowburner"] = "Drahga Shadowburner";
speedwalkingDungeonInfo[670]["bosses"]["Erudax, the Duke of Below"] = "Erudax, the Duke of Below";
speedwalkingDungeonInfo[670]["enemies"] = 69;
-- Timer Is Stored In Seconds
speedwalkingDungeonInfo[670]["goldTimer"] = 1200;
-- Currently Table Is For Mobs Not To Be Counted
-- It May Be Better To Store Mobs That Should Be Counted
speedwalkingDungeonInfo[670]["padMobs"] = {};
speedwalkingDungeonInfo[670]["padMobs"]["Trogg Dweller"] = true;
speedwalkingDungeonInfo[670]["startingArea"] = {};
speedwalkingDungeonInfo[670]["startingArea"]["x"] = -624.20001220703;
speedwalkingDungeonInfo[670]["startingArea"]["y"] = -189.40000915527;
speedwalkingDungeonInfo[670]["startingArea"]["safeZone"] = 20;
speedwalkingFrame.speedwalkingDungeonInfo = speedwalkingDungeonInfo;

-- Register Textures
speedwalkingFrame.texture = speedwalkingFrame:CreateTexture(nil,"BACKGROUND");
speedwalkingTimerFrame.texture = speedwalkingTimerFrame:CreateTexture(nil, "BACKGROUND");
speedwalkingObjectiveFrame.texture = speedwalkingObjectiveFrame:CreateTexture(nil, "BACKGROUND");
-- Register Fonts
speedwalkingTimerFrame.font = speedwalkingTimerFrame:CreateFontString(nil, "OVERLAY");
speedwalkingObjectiveFrame.font = speedwalkingObjectiveFrame:CreateFontString(nil, "OVERLAY");
-- Register Events
speedwalkingFrame:RegisterEvent("ADDON_LOADED");
speedwalkingFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");

-- Set Frame Height/Width
speedwalkingFrame:SetHeight(300);
speedwalkingFrame:SetWidth(300);
speedwalkingFrame:SetPoint("CENTER", 0, 0);
speedwalkingTimerFrame:SetHeight(100);
speedwalkingTimerFrame:SetWidth(300);
speedwalkingTimerFrame:SetPoint("TOP", 0, 0);
speedwalkingObjectiveFrame:SetHeight(200);
speedwalkingObjectiveFrame:SetWidth(300);
speedwalkingObjectiveFrame:SetPoint("TOP", 0, -100);

-- Set Font Settings
speedwalkingTimerFrame.font:SetAllPoints(true);
speedwalkingTimerFrame.font:SetJustifyH("LEFT");
speedwalkingTimerFrame.font:SetJustifyV("TOP");
speedwalkingTimerFrame.font:SetFont("Fonts\\FRIZQT__.TTF", 24);
speedwalkingTimerFrame.font:SetTextColor(0, 0, 0, 1);

speedwalkingObjectiveFrame.font:SetAllPoints(true);
speedwalkingObjectiveFrame.font:SetJustifyH("LEFT");
speedwalkingObjectiveFrame.font:SetJustifyV("TOP");
speedwalkingObjectiveFrame.font:SetFont("Fonts\\FRIZQT__.TTF", 18);
speedwalkingObjectiveFrame.font:SetTextColor(0, 0, 0, 1);

-- frame:SetHeight(pbMainHeight);
-- frame:SetWidth(pbMainWidth);

-- Give Frame Background
speedwalkingFrame.texture:SetAllPoints(speedwalkingFrame);
speedwalkingFrame.texture:SetTexture(0.5, 0.5, 0.5, 0.5);
speedwalkingTimerFrame.texture:SetAllPoints(speedwalkingTimerFrame);
speedwalkingTimerFrame.texture:SetTexture(1, 0, 0, 0.6);
speedwalkingObjectiveFrame.texture:SetAllPoints(speedwalkingObjectiveFrame);
speedwalkingObjectiveFrame.texture:SetTexture(0, 1, 0, 0.6);
--frame.texture:SetAllPoints(frame)
--frame.texture:SetTexture(0.5, 0.5, 0.5, 0.5);

-- Manage Events
speedwalkingFrame:SetScript("OnEvent", eventHandler);
speedwalkingFrame:SetScript("OnUpdate", speedwalkingFrame.updateInfo);

-- Show Main Container Frame
print("Hello World");
--frame:SetPoint("CENTER", 0, 0);
--frame:Show();
print("Hello World2");
