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
    if ((startTime and speedwalkingFrame.inTW == true) or (startTime and speedwalkingFrame.inCM == true and speedwalkingFrame.trueTimer == true)) then
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
    elseif ((not startTime or speedwalkingFrame.trueTimer == false) and speedwalkingFrame.inCM == true) then
      _, timeCM = GetWorldElapsedTime(1);
      startMin, startSec = speedwalkingFrame.secondsToTime(timeCM);
      startMin = speedwalkingFrame.formatTimeNoMS(startMin);
      startSec = speedwalkingFrame.formatTimeNoMS(startSec);
    else
      startMin = "00";
      startSec = "00";
    end
    string = startMin .. ":" .. startSec;
    speedwalkingFrame.currentTW["time"] = string;
    if (speedwalkingFrame.goldTimer == true) then
      string = string .. " / ";
      string = string .. goldMin .. ":" .. goldSec;
    end
  end
  return string;
end

speedwalkingFrame.speedwalkingObjectiveText = function()
  local enemies = "";
  local string = "";
  local name, status, curValue, finalValue, complete;
  if speedwalkingFrame.currentTW then
    local bosses = speedwalkingFrame.currentTW["bosses"];
    local steps = speedwalkingFrame.currentTW["steps"];
    if (speedwalkingFrame.competitive == true and speedwalkingFrame.inTW == true) then
      if (speedwalkingFrame.currentTW["enemiesTime"]) then
        enemies = string.format("%s - %d/%d - %s\n",  "Enemies", speedwalkingFrame.currentTW["enemies"], speedwalkingFrame.currentTW["totalEnemies"], speedwalkingFrame.currentTW["enemiesTime"]);
      else
        enemies = string.format("%s - %d/%d\n", "Enemies", speedwalkingFrame.currentTW["enemies"], speedwalkingFrame.currentTW["totalEnemies"]);
      end
    end
    for i = 1, steps do
      name, _, status, curValue, finalValue = C_Scenario.GetCriteriaInfo(i);
      if (finalValue == 0 or not finalValue) then
        -- Timewalker Complete
        if (speedwalkingFrame.currentTW["finalParse"] == false) then
          -- Add Last Time
          if (speedwalkingFrame.competitive == true and not speedwalkingFrame.currentTW["enemiesTime"] and speedwalkingFrame.inTW == true) then
            -- Just Don't Finish Yet!
            speedwalkingFrame.finalParse();
          else
            speedwalkingFrame.finalParse();
            --speedwalkingFrame.finalParse();
            speedwalkingFrame.currentTW["finalParse"] = true;
          end
        end
        return speedwalkingFrame.currentTW["string"] .. enemies;
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
  if (speedwalkingFrame.competitive == true and speedwalkingFrame.inTW == true) then
    string = string .. enemies;
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
  speedwalkingFrame.currentTW["firstUpdate"] = false;
  speedwalkingFrame.currentTW["finalParse"] = false;
  speedwalkingFrame.currentTW["lateStart"] = false;
  speedwalkingFrame.currentTW["enemies"] = 0;
  speedwalkingFrame.currentTW["totalEnemies"] = speedwalkingFrame.speedwalkingDungeonInfo[currentZoneID]["enemies"];
  speedwalkingFrame.currentTW["enemiesTime"] = nil;
  speedwalkingFrame.currentTW["enemyList"] = {};
  speedwalkingFrame.fillTables(steps);
end

speedwalkingFrame.checkPositions = function(currentZoneID)
  local isAnyoneOutside=false;
  isAnyoneOutside=isAnyoneOutside or speedwalkingFrame.checkUnitPosition(currentZoneID,"player");
  if (GetNumGroupMembers() ~= 0) then
  	for i=1,GetNumGroupMembers()-1--for i=1,GetNumGroupMembers(LE_PARTY_CATEGORY_INSTANCE)-1
  	do
      isAnyoneOutside=isAnyoneOutside or speedwalkingFrame.checkUnitPosition(currentZoneID,"party"..i)
    end
  end
  if isAnyoneOutside then
    --time to start timer
    speedwalkingFrame.currentTW["startTime"] = GetTime();
    speedwalkingFrame.currentTW["firstUpdate"] = true;
    return true;
  end
  return false;
end

speedwalkingFrame.checkUnitPosition = function(currentZoneID,unitName)
  if currentZoneID and unitName then
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
  return false;
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

speedwalkingFrame.resizeFrame = function()
  local width;
  local minWidth = speedwalkingFrame.minWidth;
  local timerWidth = speedwalkingTimerFrame.font:GetStringWidth();
  local objectiveWidth = speedwalkingObjectiveFrame.font:GetStringWidth();
  if (minWidth >= timerWidth and minWidth >= objectiveWidth) then
    -- minWidth
    width = minWidth;
  elseif (timerWidth >= minWidth and timerWidth >= objectiveWidth) then
    -- Timer Width
    width = timerWidth;
  else
    -- Objective Width
    width = objectiveWidth
  end
  speedwalkingObjectiveFrame:SetWidth(width);
  speedwalkingTimerFrame:SetWidth(width);
  speedwalkingFrame:SetWidth(width);
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
    speedwalkingFrame.resizeFrame();
  end
end

speedwalkingFrame.toggleLock = function()
  -- Variable Toggle Goes Here
  local string = "";
  if (speedwalkingFrame.unlocked == true) then
    speedwalkingFrame.unlocked = false;
    speedwalkingFrame.panel.buttons["SpeedwalkingLockCheckButton"]:SetChecked(true);
    string = "Speedwalking - Frame Locked";
  else
    speedwalkingFrame.unlocked = true;
    speedwalkingFrame.panel.buttons["SpeedwalkingLockCheckButton"]:SetChecked(false);
    string = "Speedwalking - Frame Unlocked";
  end
  speedwalkingFrame:SetMovable(speedwalkingFrame.unlocked);
  speedwalkingFrame:EnableMouse(speedwalkingFrame.unlocked);
  -- print(string);
end

speedwalkingFrame.toggleCompetitive = function()
  if (speedwalkingFrame.competitive == true) then
    speedwalkingFrame.competitive = false;
  else
    speedwalkingFrame.competitive = true;
  end
  speedwalkingVars["competitive"] = speedwalkingFrame.competitive;
  speedwalkingFrame.panel.buttons["SpeedwalkingCompetitiveButton"]:SetChecked(speedwalkingFrame.competitive);
end

speedwalkingFrame.toggleTrueTimer = function()
  if (speedwalkingFrame.trueTimer == true) then
    speedwalkingFrame.trueTimer = false;
  else
    speedwalkingFrame.trueTimer = true;
  end
  speedwalkingVars["trueTimer"] = speedwalkingFrame.trueTimer;
  speedwalkingFrame.panel.buttons["SpeedwalkingTrueTimerButton"]:SetChecked(speedwalkingFrame.trueTimer);
end

speedwalkingFrame.toggleGoldTimer = function()
  if (speedwalkingFrame.goldTimer == true) then
    speedwalkingFrame.goldTimer = false;
  else
    speedwalkingFrame.goldTimer = true;
  end
  speedwalkingVars["goldTimer"] = speedwalkingFrame.goldTimer;
  speedwalkingFrame.panel.buttons["SpeedwalkingGoldTimerButton"]:SetChecked(speedwalkingFrame.goldTimer);
end

speedwalkingFrame.toggleCMTimer = function()
  if (speedwalkingFrame.cms == true) then
    speedwalkingFrame.cms = false;
    speedwalkingFrame.wipeCM();
  else
    speedwalkingFrame.cms = true;
    speedwalkingFrame.setupCM();
  end
  speedwalkingVars["cmTimer"] = speedwalkingFrame.cms;
  speedwalkingFrame.panel.buttons["SpeedwalkingCMTimerButton"]:SetChecked(speedwalkingFrame.cms);
end

speedwalkingFrame.toggleTimewalkingTimer = function()
  if (speedwalkingFrame.timewalking == true) then
    speedwalkingFrame.timewalking = false;
    speedwalkingFrame.wipeTW();
  else
    speedwalkingFrame.timewalking = true;
    -- speedwalkingFrame.setupCM();
    speedwalkingFrame.enableTW();
  end
  speedwalkingVars["timewalkingTimer"] = speedwalkingFrame.timewalking;
  speedwalkingFrame.panel.buttons["SpeedwalkingTimewalkingTimerButton"]:SetChecked(speedwalkingFrame.timewalking);
end

speedwalkingFrame.setupAddonPanel = function()
  speedwalkingFrame.panel.buttons["SpeedwalkingTrueTimerButton"]:SetChecked(speedwalkingVars["trueTimer"]);
  speedwalkingFrame.panel.buttons["SpeedwalkingCompetitiveButton"]:SetChecked(speedwalkingVars["competitive"]);
  speedwalkingFrame.panel.buttons["SpeedwalkingGoldTimerButton"]:SetChecked(speedwalkingVars["goldTimer"]);
  speedwalkingFrame.panel.buttons["SpeedwalkingCMTimerButton"]:SetChecked(speedwalkingVars["cmTimer"]);
  speedwalkingFrame.panel.buttons["SpeedwalkingTimewalkingTimerButton"]:SetChecked(speedwalkingVars["timewalkingTimer"]);
end

speedwalkingFrame.enableTW = function()
  local name, _, difficulty, difficultyName, _, _, _, currentZoneID = GetInstanceInfo();
  -- Difficulty 1 is Normal, 2 is Heroic, 8 is CM, 24 is Timewalker
  if (speedwalkingDungeonInfo[currentZoneID] and difficulty == speedwalkingFrame.twDifficulty) then
    speedwalkingFrame.wipeTables();
    speedwalkingFrame.setupTW(currentZoneID);
    speedwalkingFrame.currentTW["lateStart"] = speedwalkingFrame.currentTW["lateStart"] or speedwalkingFrame.inProgressScan(currentZoneID);
    -- Late Starts Don't Need An Update
    -- speedwalkingFrame.currentTW["firstUpdate"] = speedwalkingFrame.currentTW["lateStart"];
    speedwalkingFrame.showFrames();
    speedwalkingFrame.inTW = true;
    speedwalkingFrame.inCM = false;
    speedwalkingFrame.updateInfo();
  end
end

speedwalkingFrame.wipeTW = function()
  local name, _, difficulty, difficultyName, _, _, _, currentZoneID = GetInstanceInfo();
  if (speedwalkingDungeonInfo[currentZoneID] and difficulty == speedwalkingFrame.twDifficulty) then
    speedwalkingFrame.inTW = false;
    speedwalkingFrame.inCM = false;
    speedwalkingFrame.hideFrames();
  end
end

speedwalkingFrame.setupCM = function()
  local name, _, difficulty, difficultyName, _, _, _, currentZoneID = GetInstanceInfo();
  if (speedwalkingDungeonInfo[currentZoneID] and difficulty == 8) then
    speedwalkingFrame.wipeTables();
    speedwalkingFrame.setupTW(currentZoneID);
    ObjectiveTrackerFrame:SetScript("OnEvent", nil);
    ObjectiveTrackerFrame:Hide();
    speedwalkingFrame.showFrames();
    speedwalkingFrame.inTW = false;
    speedwalkingFrame.inCM = true;
    speedwalkingFrame.updateInfo();
  end
end

speedwalkingFrame.wipeCM = function()
  local name, _, difficulty, difficultyName, _, _, _, currentZoneID = GetInstanceInfo();
  if (speedwalkingDungeonInfo[currentZoneID] and difficulty == 8) then
    speedwalkingFrame.inTW = false;
    speedwalkingFrame.inCM = false;
    speedwalkingFrame.hideFrames();
  end
end

speedwalkingFrame.sendMob = function(guid)
  local msg = "Mob:" .. guid;
  SendAddonMessage(speedwalkingFrame.prefix, msg, "RAID");
end

speedwalkingFrame.sendCurrentTW = function()

end

speedwalkingFrame.addMobToList = function(destGUID)
  speedwalkingFrame.currentTW["enemies"] = speedwalkingFrame.currentTW["enemies"] + 1;
  speedwalkingFrame.currentTW["enemyList"][destGUID] = true;
  if (speedwalkingFrame.currentTW["enemies"] == speedwalkingFrame.currentTW["totalEnemies"]) then
    speedwalkingFrame.currentTW["enemiesTime"] = string.format("|c%s%s|r", speedwalkingFrame.successColor, speedwalkingFrame.currentTW["time"]);
  end
end

local function eventHandler(self, event, ...)
  if event == "ADDON_LOADED" and ... == "Speedwalking" then
    if not speedwalkingVars then
      speedwalkingVars = {};
      speedwalkingVars["anchor"] = "RIGHT";
      speedwalkingVars["xOffset"] = 0;
      speedwalkingVars["yOffset"] = 0;
      speedwalkingVars["trueTimer"] = true;
      speedwalkingVars["competitive"] = false;
      speedwalkingVars["goldTimer"] = true;
      speedwalkingVars["cmTimer"] = true;
      speedwalkingVars["timewalkingTimer"] = true;
    end
    speedwalkingFrame:ClearAllPoints();
    speedwalkingFrame:SetPoint(speedwalkingVars["anchor"], speedwalkingVars["xOffset"], speedwalkingVars["yOffset"]);
    speedwalkingFrame.trueTimer = speedwalkingVars["trueTimer"];
    speedwalkingFrame.competitive = speedwalkingVars["competitive"];
    speedwalkingFrame.goldTimer = speedwalkingVars["goldTimer"];
    speedwalkingFrame.cms = speedwalkingVars["cmTimer"];
    speedwalkingFrame.timewalking = speedwalkingVars["timewalkingTimer"];
    speedwalkingFrame.setupAddonPanel();
    -- print(speedwalkingVars["anchor"] .. " " .. speedwalkingVars["xOffset"] .. " " .. speedwalkingVars["yOffset"]);
    -- speedwalkingFrame.hideFrames();
  elseif event == "CHAT_MSG_ADDON" then
    local prefix, message, distribution, sender = ...;
    -- print(prefix);
    if (prefix == speedwalkingFrame.prefix) then
      -- Parse message
      local msg = split(message, ":");
      if (msg[1] == "Mob") then
        if speedwalkingFrame.currentTW then
          if not speedwalkingFrame.currentTW["enemyList"][msg[2]] then
            speedwalkingFrame.addMobToList(msg[2]);
            -- print(message);
          end
        end
      end
    end
  elseif event == "PLAYER_ENTERING_WORLD" then
    local name, _, difficulty, difficultyName, _, _, _, currentZoneID = GetInstanceInfo();
    if (speedwalkingDungeonInfo and currentZoneID) then
      if (speedwalkingDungeonInfo[currentZoneID] and difficulty == speedwalkingFrame.twDifficulty and speedwalkingFrame.timewalking == true) then
        speedwalkingFrame.enableTW();
      elseif (speedwalkingDungeonInfo[currentZoneID] and difficulty == 8 and speedwalkingFrame.cms == true) then
        speedwalkingFrame.setupCM();
      else
        speedwalkingFrame.inTW = false;
        speedwalkingFrame.inCM = false;
        speedwalkingFrame.hideFrames();
      end
    end
  elseif event == "SCENARIO_POI_UPDATE" and speedwalkingFrame.inTW == true and speedwalkingFrame.currentTW and speedwalkingFrame.currentTW["firstUpdate"] == false then
    local _, _, steps = C_Scenario.GetStepInfo();
    speedwalkingFrame.currentTW["steps"] = steps;
    speedwalkingFrame.fillTables(steps);
    speedwalkingFrame.currentTW["lateStart"] = speedwalkingFrame.currentTW["lateStart"] or speedwalkingFrame.inProgressScan(currentZoneID);
    speedwalkingFrame.currentTW["firstUpdate"] = true;
  elseif event == "CHALLENGE_MODE_START" and speedwalkingFrame.cms == true and speedwalkingFrame.inCM == true then
    local name, _, difficulty, difficultyName, _, _, _, currentZoneID = GetInstanceInfo();
    speedwalkingFrame.wipeTables();
    speedwalkingFrame.setupTW(currentZoneID);
    speedwalkingFrame.updateInfo();
    if (speedwalkingFrame.trueTimer) then
      speedwalkingFrame.currentTW["startTime"] = GetTime();
    end
  elseif event == "CHALLENGE_MODE_RESET" and speedwalkingFrame.cms == true and speedwalkingFrame.inCM == true then
    local name, _, difficulty, difficultyName, _, _, _, currentZoneID = GetInstanceInfo();
    speedwalkingFrame.wipeTables();
    speedwalkingFrame.setupTW(currentZoneID);
    speedwalkingFrame.updateInfo();
  elseif event == "COMBAT_LOG_EVENT_UNFILTERED" and speedwalkingFrame.inTW == true and speedwalkingFrame.currentTW then
    if speedwalkingFrame.currentTW["enemies"] < speedwalkingFrame.currentTW["totalEnemies"] then
      local encounterID, msg, _, srcGUID, srcName, _, _, destGUID, destName, _, _, spellID, spellName = ...;
      if (msg == "UNIT_DIED" and speedwalkingDungeonInfo[speedwalkingFrame.currentTW["zoneID"]]["mobs"][split(destGUID,"\-")[6]] and not speedwalkingFrame.currentTW["enemyList"][destGUID]) then
        print(destGUID .. " - " .. destName);
        speedwalkingFrame.currentTW["enemies"] = speedwalkingFrame.currentTW["enemies"] + 1;
        speedwalkingFrame.currentTW["enemyList"][destGUID] = true;
        speedwalkingFrame.sendMob(destGUID);
      end
    end
  end
end

-- Global Variables (Most likely saved later)
speedwalkingFrame.inTW = false;
speedwalkingFrame.inCM = false;
speedwalkingFrame.successColor = "000ff000";
speedwalkingFrame.trueTimer = true;
speedwalkingFrame.goldTimer = true;
speedwalkingFrame.competitive = true;
speedwalkingFrame.timewalking = true;
speedwalkingFrame.cms = false;
speedwalkingFrame.unlocked = false;
speedwalkingFrame.minWidth = 200;
speedwalkingFrame.twDifficulty = 1;
speedwalkingFrame.prefix = "SPEEDWALKING";

speedwalkingFrame.speedwalkingDungeonInfo = speedwalkingDungeonInfo;

-- Register Textures
speedwalkingFrame.texture = speedwalkingFrame:CreateTexture(nil,"BACKGROUND");
speedwalkingTimerFrame.texture = speedwalkingTimerFrame:CreateTexture(nil, "BACKGROUND");
speedwalkingObjectiveFrame.texture = speedwalkingObjectiveFrame:CreateTexture(nil, "BACKGROUND");
-- Register Fonts
speedwalkingTimerFrame.font = speedwalkingTimerFrame:CreateFontString(nil, "OVERLAY");
speedwalkingObjectiveFrame.font = speedwalkingObjectiveFrame:CreateFontString(nil, "OVERLAY");

RegisterAddonMessagePrefix(speedwalkingFrame.prefix);
-- Register Events
speedwalkingFrame:RegisterEvent("ADDON_LOADED");
speedwalkingFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
speedwalkingFrame:RegisterEvent("SCENARIO_POI_UPDATE");
speedwalkingFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
speedwalkingFrame:RegisterEvent("CHALLENGE_MODE_START");
speedwalkingFrame:RegisterEvent("CHALLENGE_MODE_RESET");
speedwalkingFrame:RegisterEvent("CHAT_MSG_ADDON");

-- Set Frame Height/Width
speedwalkingFrame:SetHeight(240);
speedwalkingFrame:SetWidth(speedwalkingFrame.minWidth);
speedwalkingFrame:SetPoint("RIGHT", 0, 0);
speedwalkingTimerFrame:SetHeight(40);
speedwalkingTimerFrame:SetWidth(speedwalkingFrame.minWidth);
speedwalkingTimerFrame:SetPoint("TOP", 0, 0);
speedwalkingObjectiveFrame:SetHeight(200);
speedwalkingObjectiveFrame:SetWidth(speedwalkingFrame.minWidth);
speedwalkingObjectiveFrame:SetPoint("TOP", 0, -40);
speedwalkingFrame:SetMovable(speedwalkingFrame.unlocked);
speedwalkingFrame:EnableMouse(speedwalkingFrame.unlocked);

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
   point, relativeTo, relativePoint, xOffset, yOffset = speedwalkingFrame:GetPoint(1);
   speedwalkingVars["anchor"] = point;
   speedwalkingVars["xOffset"] = xOffset;
   speedwalkingVars["yOffset"] = yOffset;
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
speedwalkingTimerFrame.font:SetJustifyH("CENTER");
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

-- Interface Panel
speedwalkingFrame.panel = CreateFrame("Frame", "SpeedwalkingPanel", UIParent);
speedwalkingFrame.panel.name = "Speedwalking";
speedwalkingFrame.panel.buttons = {};
speedwalkingFrame.panel.buttonText = {};

speedwalkingFrame.panel.header = speedwalkingFrame.panel:CreateFontString(nil, "ARTWORK");
speedwalkingFrame.panel.header:SetFontObject(GameFontNormalLarge);
speedwalkingFrame.panel.header:SetJustifyH("LEFT");
speedwalkingFrame.panel.header:SetJustifyV("TOP");
speedwalkingFrame.panel.header:ClearAllPoints();
speedwalkingFrame.panel.header:SetPoint("TOPLEFT", 5, 0);
speedwalkingFrame.panel.header:SetText("Speedwalking");

speedwalkingFrame.panel.buttonText["SpeedwalkingLockText"] = speedwalkingFrame.panel:CreateFontString(nil, "ARTWORK");
speedwalkingFrame.panel.buttonText["SpeedwalkingLockText"]:SetFontObject(GameFontWhite);
speedwalkingFrame.panel.buttonText["SpeedwalkingLockText"]:SetJustifyH("LEFT");
speedwalkingFrame.panel.buttonText["SpeedwalkingLockText"]:SetJustifyV("TOP");
speedwalkingFrame.panel.buttonText["SpeedwalkingLockText"]:ClearAllPoints();
speedwalkingFrame.panel.buttonText["SpeedwalkingLockText"]:SetPoint("TOPLEFT", speedwalkingFrame.panel, "TOPLEFT", 30, -30);
speedwalkingFrame.panel.buttonText["SpeedwalkingLockText"]:SetText("Lock");

speedwalkingFrame.panel.buttons["SpeedwalkingLockCheckButton"] = CreateFrame("CheckButton", "SpeedwalkingLockCheckButton", speedwalkingFrame.panel, "OptionsCheckButtonTemplate");
speedwalkingFrame.panel.buttons["SpeedwalkingLockCheckButton"]:SetPoint("TOPLEFT", speedwalkingFrame.panel, "TOPLEFT", 5, -20);
speedwalkingFrame.panel.buttons["SpeedwalkingLockCheckButton"]:SetText("Lock");
speedwalkingFrame.panel.buttons["SpeedwalkingLockCheckButton"]:SetChecked(true);
speedwalkingFrame.panel.buttons["SpeedwalkingLockCheckButton"]:SetScript("OnClick", function(self) speedwalkingFrame.toggleLock() end);

speedwalkingFrame.panel.buttonText["SpeedwalkingTrueTimerText"] = speedwalkingFrame.panel:CreateFontString(nil, "ARTWORK");
speedwalkingFrame.panel.buttonText["SpeedwalkingTrueTimerText"]:SetFontObject(GameFontWhite);
speedwalkingFrame.panel.buttonText["SpeedwalkingTrueTimerText"]:SetJustifyH("LEFT");
speedwalkingFrame.panel.buttonText["SpeedwalkingTrueTimerText"]:SetJustifyV("TOP");
speedwalkingFrame.panel.buttonText["SpeedwalkingTrueTimerText"]:ClearAllPoints();
speedwalkingFrame.panel.buttonText["SpeedwalkingTrueTimerText"]:SetPoint("TOPLEFT", speedwalkingFrame.panel, "TOPLEFT", 30, -50);
speedwalkingFrame.panel.buttonText["SpeedwalkingTrueTimerText"]:SetText("True Timer (MS Display and more accurate CM Timer)");

speedwalkingFrame.panel.buttons["SpeedwalkingTrueTimerButton"] = CreateFrame("CheckButton", "SpeedwalkingTrueTimerButton", speedwalkingFrame.panel, "OptionsCheckButtonTemplate");
speedwalkingFrame.panel.buttons["SpeedwalkingTrueTimerButton"]:SetPoint("TOPLEFT", speedwalkingFrame.panel, "TOPLEFT", 5, -40);
speedwalkingFrame.panel.buttons["SpeedwalkingTrueTimerButton"]:SetText("True Timer (MS Display and more accurate CM Timer)");
speedwalkingFrame.panel.buttons["SpeedwalkingTrueTimerButton"]:SetChecked(true);
speedwalkingFrame.panel.buttons["SpeedwalkingTrueTimerButton"]:SetScript("OnClick", function(self) speedwalkingFrame.toggleTrueTimer() end);

speedwalkingFrame.panel.buttonText["SpeedwalkingCompetitiveText"] = speedwalkingFrame.panel:CreateFontString(nil, "ARTWORK");
speedwalkingFrame.panel.buttonText["SpeedwalkingCompetitiveText"]:SetFontObject(GameFontWhite);
speedwalkingFrame.panel.buttonText["SpeedwalkingCompetitiveText"]:SetJustifyH("LEFT");
speedwalkingFrame.panel.buttonText["SpeedwalkingCompetitiveText"]:SetJustifyV("TOP");
speedwalkingFrame.panel.buttonText["SpeedwalkingCompetitiveText"]:ClearAllPoints();
speedwalkingFrame.panel.buttonText["SpeedwalkingCompetitiveText"]:SetPoint("TOPLEFT", speedwalkingFrame.panel, "TOPLEFT", 30, -70);
speedwalkingFrame.panel.buttonText["SpeedwalkingCompetitiveText"]:SetText("Competitive Mode (Beta Feature)");

speedwalkingFrame.panel.buttons["SpeedwalkingCompetitiveButton"] = CreateFrame("CheckButton", "SpeedwalkingCompetitiveButton", speedwalkingFrame.panel, "OptionsCheckButtonTemplate");
speedwalkingFrame.panel.buttons["SpeedwalkingCompetitiveButton"]:SetPoint("TOPLEFT", speedwalkingFrame.panel, "TOPLEFT", 5, -60);
speedwalkingFrame.panel.buttons["SpeedwalkingCompetitiveButton"]:SetText("Competitive Mode (Beta Feature)");
speedwalkingFrame.panel.buttons["SpeedwalkingCompetitiveButton"]:SetChecked(false);
speedwalkingFrame.panel.buttons["SpeedwalkingCompetitiveButton"]:SetScript("OnClick", function(self) speedwalkingFrame.toggleCompetitive() end);

speedwalkingFrame.panel.buttonText["SpeedwalkingGoldTimerText"] = speedwalkingFrame.panel:CreateFontString(nil, "ARTWORK");
speedwalkingFrame.panel.buttonText["SpeedwalkingGoldTimerText"]:SetFontObject(GameFontWhite);
speedwalkingFrame.panel.buttonText["SpeedwalkingGoldTimerText"]:SetJustifyH("LEFT");
speedwalkingFrame.panel.buttonText["SpeedwalkingGoldTimerText"]:SetJustifyV("TOP");
speedwalkingFrame.panel.buttonText["SpeedwalkingGoldTimerText"]:ClearAllPoints();
speedwalkingFrame.panel.buttonText["SpeedwalkingGoldTimerText"]:SetPoint("TOPLEFT", speedwalkingFrame.panel, "TOPLEFT", 30, -90);
speedwalkingFrame.panel.buttonText["SpeedwalkingGoldTimerText"]:SetText("Gold Timer");

speedwalkingFrame.panel.buttons["SpeedwalkingGoldTimerButton"] = CreateFrame("CheckButton", "SpeedwalkingGoldTimerButton", speedwalkingFrame.panel, "OptionsCheckButtonTemplate");
speedwalkingFrame.panel.buttons["SpeedwalkingGoldTimerButton"]:SetPoint("TOPLEFT", speedwalkingFrame.panel, "TOPLEFT", 5, -80);
speedwalkingFrame.panel.buttons["SpeedwalkingGoldTimerButton"]:SetText("Gold Timer");
speedwalkingFrame.panel.buttons["SpeedwalkingGoldTimerButton"]:SetChecked(true);
speedwalkingFrame.panel.buttons["SpeedwalkingGoldTimerButton"]:SetScript("OnClick", function(self) speedwalkingFrame.toggleGoldTimer() end);

speedwalkingFrame.panel.buttonText["SpeedwalkingCMTimerText"] = speedwalkingFrame.panel:CreateFontString(nil, "ARTWORK");
speedwalkingFrame.panel.buttonText["SpeedwalkingCMTimerText"]:SetFontObject(GameFontWhite);
speedwalkingFrame.panel.buttonText["SpeedwalkingCMTimerText"]:SetJustifyH("LEFT");
speedwalkingFrame.panel.buttonText["SpeedwalkingCMTimerText"]:SetJustifyV("TOP");
speedwalkingFrame.panel.buttonText["SpeedwalkingCMTimerText"]:ClearAllPoints();
speedwalkingFrame.panel.buttonText["SpeedwalkingCMTimerText"]:SetPoint("TOPLEFT", speedwalkingFrame.panel, "TOPLEFT", 30, -110);
speedwalkingFrame.panel.buttonText["SpeedwalkingCMTimerText"]:SetText("CM Timer");

speedwalkingFrame.panel.buttons["SpeedwalkingCMTimerButton"] = CreateFrame("CheckButton", "SpeedwalkingCMTimerButton", speedwalkingFrame.panel, "OptionsCheckButtonTemplate");
speedwalkingFrame.panel.buttons["SpeedwalkingCMTimerButton"]:SetPoint("TOPLEFT", speedwalkingFrame.panel, "TOPLEFT", 5, -100);
speedwalkingFrame.panel.buttons["SpeedwalkingCMTimerButton"]:SetText("CM Timer");
speedwalkingFrame.panel.buttons["SpeedwalkingCMTimerButton"]:SetChecked(true);
speedwalkingFrame.panel.buttons["SpeedwalkingCMTimerButton"]:SetScript("OnClick", function(self) speedwalkingFrame.toggleCMTimer() end);

speedwalkingFrame.panel.buttonText["SpeedwalkingTimewalkingTimerText"] = speedwalkingFrame.panel:CreateFontString(nil, "ARTWORK");
speedwalkingFrame.panel.buttonText["SpeedwalkingTimewalkingTimerText"]:SetFontObject(GameFontWhite);
speedwalkingFrame.panel.buttonText["SpeedwalkingTimewalkingTimerText"]:SetJustifyH("LEFT");
speedwalkingFrame.panel.buttonText["SpeedwalkingTimewalkingTimerText"]:SetJustifyV("TOP");
speedwalkingFrame.panel.buttonText["SpeedwalkingTimewalkingTimerText"]:ClearAllPoints();
speedwalkingFrame.panel.buttonText["SpeedwalkingTimewalkingTimerText"]:SetPoint("TOPLEFT", speedwalkingFrame.panel, "TOPLEFT", 30, -130);
speedwalkingFrame.panel.buttonText["SpeedwalkingTimewalkingTimerText"]:SetText("Timewalking Timer");

speedwalkingFrame.panel.buttons["SpeedwalkingTimewalkingTimerButton"] = CreateFrame("CheckButton", "SpeedwalkingTimewalkingTimerButton", speedwalkingFrame.panel, "OptionsCheckButtonTemplate");
speedwalkingFrame.panel.buttons["SpeedwalkingTimewalkingTimerButton"]:SetPoint("TOPLEFT", speedwalkingFrame.panel, "TOPLEFT", 5, -120);
speedwalkingFrame.panel.buttons["SpeedwalkingTimewalkingTimerButton"]:SetText("Timewalking Timer");
speedwalkingFrame.panel.buttons["SpeedwalkingTimewalkingTimerButton"]:SetChecked(true);
speedwalkingFrame.panel.buttons["SpeedwalkingTimewalkingTimerButton"]:SetScript("OnClick", function(self) speedwalkingFrame.toggleTimewalkingTimer() end);

InterfaceOptions_AddCategory(speedwalkingFrame.panel);

-- Manage Events
speedwalkingFrame:SetScript("OnEvent", eventHandler);
speedwalkingFrame:SetScript("OnUpdate", speedwalkingFrame.updateInfo);

-- Slash Command Setup
SLASH_SPEEDWALKING1, SLASH_SPEEDWALKING2 = '/speedwalking', '/sw';
local function handler(msg, editbox)
  if (msg == "reset") then
    speedwalkingVars["anchor"] = "RIGHT";
    speedwalkingVars["xOffset"] = 0;
    speedwalkingVars["yOffset"] = 0;
    speedwalkingVars["trueTimer"] = true;
    speedwalkingVars["competitive"] = false;
    speedwalkingVars["goldTimer"] = true;
    speedwalkingVars["cmTimer"] = true;
    speedwalkingVars["timewalkingTimer"] = true;
    speedwalkingFrame:ClearAllPoints();
    speedwalkingFrame:SetPoint("RIGHT", 0, 0);
    print("Speedwalking - Frame Position Reset");
  else
    print("Speedwalking - For Your Go Fast Timewalking Needs");
    print("Reset Frame Position - /sw reset");
    -- Workaround to make it open to this panel on the first time
    InterfaceOptionsFrame_OpenToCategory(speedwalkingFrame.panel);
    InterfaceOptionsFrame_OpenToCategory(speedwalkingFrame.panel);
  end
end
SlashCmdList["SPEEDWALKING"] = handler;

function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end
