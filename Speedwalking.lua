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

speedwalkingFrame.formatTimeMS = function(time)
  if (time < 10) then
    time = string.format("0%.3f", time);
  else
    time = string.format("%.3f", time);
  end
  return time;
end
speedwalkingFrame.finalParse = function()
  local steps = speedwalkingFrame.currentTW["steps"];
  local name, curValue, finalValue;
  local string = "";
  for i = 1, steps do
    if (speedwalkingFrame.currentTW["curValues"][i] ~= speedwalkingFrame.currentTW["finalValues"][i]) then
      speedwalkingFrame.currentTW["curValues"][i] = speedwalkingFrame.currentTW["finalValues"][i];
      speedwalkingFrame.currentTW["objectiveTimes"][i] = string.format("|c%s%s|r", speedwalkingFrame.successColor, speedwalkingFrame.currentTW["time"]);
    end
    name = speedwalkingFrame.currentTW["bosses"][i];
    curValue = speedwalkingFrame.currentTW["curValues"][i];
    finalValue = speedwalkingFrame.currentTW["finalValues"][i];
    if (speedwalkingFrame.currentTW["objectiveTimes"][i]) then
      string = string .. string.format("%s - %d/%d - %s\n",  name, curValue, finalValue, speedwalkingFrame.currentTW["objectiveTimes"][i]);
    else
      string = string .. string.format("%s - %d/%d\n", name, curValue, finalValue);
    end
  end
  speedwalkingFrame.currentTW["string"] = string;
end

speedwalkingFrame.speedwalkingTimerText = function(currentZoneID)
  local string = "";
  if speedwalkingFrame.speedwalkingDungeonInfo[currentZoneID] and speedwalkingFrame.currentTW then
    local goldTimer = speedwalkingFrame.speedwalkingDungeonInfo[currentZoneID]["goldTimer"];
    local goldMin, goldSec = speedwalkingFrame.secondsToTime(goldTimer);
    if (speedwalkingFrame.currentTW["finalParse"] == true) then
      return speedwalkingFrame.currentTW["time"] .. " / " .. goldMin .. ":" .. speedwalkingFrame.formatTimeNoMS(goldSec);
    end
    local startTime = speedwalkingFrame.currentTW["startTime"];
    local startMin, startSec;
    -- Format Seconds
    goldSec = speedwalkingFrame.formatTimeNoMS(goldSec);
    -- Create String
    if (startTime) then
      local currentTime = GetTime();
      local secs = currentTime - startTime;
      startMin, startSec = speedwalkingFrame.secondsToTime(secs);
      if (speedwalkingFrame.trueTimer == true) then
        startMin = speedwalkingFrame.formatTimeNoMS(startMin);
        startSec = speedwalkingFrame.formatTimeMS(startSec);
      else
        startMin = speedwalkingFrame.formatTimeNoMS(startMin);
        startSec = speedwalkingFrame.formatTimeNoMS(startSec);
      end
    else
      startMin = "00";
      startSec = "00";
    end
    string = startMin .. ":" .. startSec;
    speedwalkingFrame.currentTW["time"] = string;
    string = string .. " / ";
    string = string .. goldMin .. ":" .. goldSec;
  end
  return string;
end

speedwalkingFrame.speedwalkingObjectiveText = function()
  local string = "";
  local name, status, curValue, finalValue, complete;
  if speedwalkingFrame.currentTW then
    local bosses = speedwalkingFrame.currentTW["bosses"];
    -- local enemies = speedwalkingFrame.speedwalkingDungeonInfo[currentZoneID]["enemies"];
    local steps = speedwalkingFrame.currentTW["steps"];
    for i = 1, steps do
      name, _, status, curValue, finalValue = C_Scenario.GetCriteriaInfo(i);
      if (finalValue == 0 or not finalValue) then
        -- Timewalker Complete
        if (speedwalkingFrame.currentTW["finalParse"] == false) then
          -- Add Last Time
          speedwalkingFrame.finalParse();
          speedwalkingFrame.currentTW["finalParse"] = true;
        end
        return speedwalkingFrame.currentTW["string"];
      end
      if (curValue ~= speedwalkingFrame.currentTW["curValues"][i]) then
        if (curValue == finalValue) then
          -- Objective Time!!!
          speedwalkingFrame.currentTW["objectiveTimes"][i] = string.format("|c%s%s|r", speedwalkingFrame.successColor, speedwalkingFrame.currentTW["time"]);
        end
      end
      name = speedwalkingFrame.currentTW["bosses"][i];
      speedwalkingFrame.currentTW["curValues"][i] = curValue;
      if (speedwalkingFrame.currentTW["objectiveTimes"][i]) then
        string = string .. string.format("%s - %d/%d - %s\n",  name, curValue, finalValue, speedwalkingFrame.currentTW["objectiveTimes"][i]);
      else
        string = string .. string.format("%s - %d/%d\n", name, curValue, finalValue);
      end
    end
    -- string = string .. "Enemies - " .. speedwalkingFrame.currentTW["enemies"] .. "/" .. enemies .. "\n";
  end
  speedwalkingFrame.currentTW["string"] = string;
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

speedwalkingFrame.fillTables = function(steps)
  for i = 1, steps do
    local name, _, status, curValue, finalValue = C_Scenario.GetCriteriaInfo(i);
    name = string.gsub(name, " defeated", "");
    speedwalkingFrame.currentTW["curValues"][i] = curValue;
    speedwalkingFrame.currentTW["finalValues"][i] = finalValue;
    speedwalkingFrame.currentTW["bosses"][i] = name;
  end
end

speedwalkingFrame.wipeTables = function()
  if (speedwalkingFrame.currentTW) then
    speedwalkingFrame.currentTW = table.wipe(speedwalkingFrame.currentTW);
  end
end

speedwalkingFrame.setupTW = function(currentZoneID)
  -- local enemies = speedwalkingFrame.speedwalkingDungeonInfo[currentZoneID]["enemies"];
  local _, _, steps = C_Scenario.GetStepInfo();
  speedwalkingFrame.currentTW = nil;
  speedwalkingFrame.currentTW = {};
  speedwalkingFrame.currentTW["zoneID"] = currentZoneID;
  speedwalkingFrame.currentTW["startTime"] = nil;
  speedwalkingFrame.currentTW["endTime"] = nil;
  speedwalkingFrame.currentTW["steps"] = steps;
  speedwalkingFrame.currentTW["bosses"] = {};
  speedwalkingFrame.currentTW["curValues"] = {};
  speedwalkingFrame.currentTW["finalValues"] = {};
  speedwalkingFrame.currentTW["objectiveTimes"] = {};
  speedwalkingFrame.currentTW["string"] = nil;
  speedwalkingFrame.currentTW["time"] = nil;
  speedwalkingFrame.currentTW["finalParse"] = false;
  speedwalkingFrame.currentTW["lateStart"] = false;
  -- speedwalkingFrame.currentTW["enemies"] = 0;
  speedwalkingFrame.fillTables(steps);
end

speedwalkingFrame.checkPositions = function(currentZoneID)
  local isAnyoneOutside=false;
  isAnyoneOutside=isAnyoneOutside or speedwalkingFrame.checkUnitPosition(currentZoneID,"player");
	for i=1,GetNumGroupMembers()-1--for i=1,GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE)-1
	do
    isAnyoneOutside=isAnyoneOutside or speedwalkingFrame.checkUnitPosition(currentZoneID,"party"..i)
  end
  if isAnyoneOutside then
    --time to start timer
    speedwalkingFrame.currentTW["startTime"] = GetTime();
    return true;
  end
  return false;
end

speedwalkingFrame.checkUnitPosition = function(currentZoneID,unitName)
  local dx, dy, distance;
  local posX, posY, posZ, terrainMapID = UnitPosition(unitName);
  local startX = speedwalkingFrame.speedwalkingDungeonInfo[currentZoneID]["startingArea"]["x"];
  local startY = speedwalkingFrame.speedwalkingDungeonInfo[currentZoneID]["startingArea"]["y"];
  local safeZone = speedwalkingFrame.speedwalkingDungeonInfo[currentZoneID]["startingArea"]["safeZone"];

  dx = startX - posX;
  dy = startY - posY;
  distance = math.sqrt((dx * dx) + (dy * dy));

  return currentZoneID==terrainMapID and distance > safeZone;
end

speedwalkingFrame.inProgressScan = function(currentZoneID)
  if (speedwalkingFrame.currentTW) then
    -- If objective is anything but unmodified then it is
    local curValues = speedwalkingFrame.currentTW["curValues"];
    local steps = speedwalkingFrame.currentTW["steps"];
    for i = 1, steps do
      if curValues[i] ~= 0 then
        return true;
      end
    end
    -- Check Positions
    return speedwalkingFrame.checkPositions(currentZoneID);
  end
end

speedwalkingFrame.updateInfo = function()
  if (speedwalkingFrame.currentTW) then
    local startTime = speedwalkingFrame.currentTW["startTime"];
    local currentZoneID = speedwalkingFrame.currentTW["zoneID"];
    if (not startTime and speedwalkingFrame.inTW == true) then
      speedwalkingFrame.checkPositions(currentZoneID);
    end
    -- Timer Text
    local timerText = speedwalkingFrame.speedwalkingTimerText(currentZoneID);
    if speedwalkingFrame.currentTW["lateStart"] then
      speedwalkingTimerFrame.font:SetText("|cffff0000"..timerText.."|r");
    else
      speedwalkingTimerFrame.font:SetText(timerText);
    end
    -- Objective Text
    local objectiveText = speedwalkingFrame.speedwalkingObjectiveText();
    speedwalkingObjectiveFrame.font:SetText(objectiveText);
  end
end

local function eventHandler(self, event, ...)
  if event == "ADDON_LOADED" then
    -- speedwalkingFrame.hideFrames();
  elseif event == "PLAYER_ENTERING_WORLD" then
    local name, _, difficulty, difficultyName, _, _, _, currentZoneID = GetInstanceInfo();
    if (speedwalkingDungeonInfo and currentZoneID) then
      if (speedwalkingDungeonInfo[currentZoneID]) then
        speedwalkingFrame.wipeTables();
        speedwalkingFrame.setupTW(currentZoneID);
        speedwalkingFrame.currentTW["lateStart"] = speedwalkingFrame.inProgressScan(currentZoneID);
        print("Welcome To " .. speedwalkingDungeonInfo[currentZoneID]["name"]);
        print(speedwalkingFrame.currentTW["lateStart"]);
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
speedwalkingFrame.successColor = "000ff000";
speedwalkingFrame.trueTimer = true;
speedwalkingFrame.unlocked=true;
speedwalkingDungeonInfo = {};
speedwalkingDungeonInfo[670] = {};
speedwalkingDungeonInfo[670]["name"] = "Grim Batol";
-- Key Is Unit Name In Game, Value Is Display Name
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
speedwalkingFrame:RegisterEvent("PLAYER_ENTERING_WORLD");

-- Set Frame Height/Width
speedwalkingFrame:SetHeight(240);
speedwalkingFrame:SetWidth(400);
speedwalkingFrame:SetPoint("RIGHT", 0, 0);
speedwalkingTimerFrame:SetHeight(40);
speedwalkingTimerFrame:SetWidth(400);
speedwalkingTimerFrame:SetPoint("TOP", 0, 0);
speedwalkingObjectiveFrame:SetHeight(200);
speedwalkingObjectiveFrame:SetWidth(400);
speedwalkingObjectiveFrame:SetPoint("TOP", 0, -40);
speedwalkingFrame:SetMovable(true);
speedwalkingFrame:EnableMouse(true);

speedwalkingFrame:SetScript("OnMouseDown", function(self, button)
  if speedwalkingFrame.unlocked and button == "LeftButton" and not self.isMoving then
   self:StartMoving();
   self.isMoving = true;
  end
end);
speedwalkingFrame:SetScript("OnMouseUp", function(self, button)
  if button == "LeftButton" and self.isMoving then
   self:StopMovingOrSizing();
   self.isMoving = false;
  end
end);
speedwalkingFrame:SetScript("OnHide", function(self)
  if ( self.isMoving ) then
   self:StopMovingOrSizing();
   self.isMoving = false;
  end
end);

-- Set Font Settings
speedwalkingTimerFrame.font:SetAllPoints(true);
speedwalkingTimerFrame.font:SetJustifyH("LEFT");
speedwalkingTimerFrame.font:SetJustifyV("BOTTOM");
speedwalkingTimerFrame.font:SetFont("Interface\\Addons\\Speedwalking\\MyriadCondensedWeb.ttf", 29, "OUTLINE");
speedwalkingTimerFrame.font:SetTextColor(1, 1, 1, 1);

speedwalkingObjectiveFrame.font:SetAllPoints(true);
speedwalkingObjectiveFrame.font:SetJustifyH("LEFT");
speedwalkingObjectiveFrame.font:SetJustifyV("TOP");
speedwalkingObjectiveFrame.font:SetFont("Interface\\Addons\\Speedwalking\\MyriadCondensedWeb.ttf", 21, "OUTLINE");
speedwalkingObjectiveFrame.font:SetTextColor(1, 1, 1, 1);

-- frame:SetHeight(pbMainHeight);
-- frame:SetWidth(pbMainWidth);

-- Give Frame Background
speedwalkingFrame.texture:SetAllPoints(speedwalkingFrame);
speedwalkingFrame.texture:SetTexture(0.5, 0.5, 0.5, 0);
speedwalkingTimerFrame.texture:SetAllPoints(speedwalkingTimerFrame);
speedwalkingTimerFrame.texture:SetTexture(1, 0, 0, 0);
speedwalkingObjectiveFrame.texture:SetAllPoints(speedwalkingObjectiveFrame);
speedwalkingObjectiveFrame.texture:SetTexture(0, 1, 0, 0);
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
