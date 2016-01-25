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
      --ask for start time here
      startMin, startSec = speedwalkingFrame.secondsToTime(timeCM);
      startMin = speedwalkingFrame.formatTimeNoMS(startMin);
      startSec = speedwalkingFrame.formatTimeNoMS(startSec);
    else
      startMin = "00";
      startSec = "00";
    end
    string = startMin .. ":" .. startSec;
    speedwalkingFrame.currentTW["time"] = string;
    string = string .. " ";
    if (speedwalkingFrame.goldTimer == true) then
      string = string .. "/ ";
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
  if speedwalkingFrame.inCM and speedwalkingFrame.quickStartEnabled then
    SelectGossipOption(1);
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
  speedwalkingFrame.timewalkingPanel.buttons["SpeedwalkingCompetitiveButton"]:SetChecked(speedwalkingFrame.competitive);
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
  speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMTimerButton"]:SetChecked(speedwalkingFrame.cms);
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
  speedwalkingFrame.timewalkingPanel.buttons["SpeedwalkingTimewalkingTimerButton"]:SetChecked(speedwalkingFrame.timewalking);
end

speedwalkingFrame.toggleCMAutoStart = function()
  if (speedwalkingFrame.quickStartEnabled == true) then
    speedwalkingFrame.quickStartEnabled = false;
  else
    speedwalkingFrame.quickStartEnabled = true;
  end
  speedwalkingVars["quickStart"] = speedwalkingFrame.quickStartEnabled;
  speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoStartButton"]:SetChecked(speedwalkingFrame.quickStartEnabled);
end

speedwalkingFrame.toggleCMAutoLeave = function()
  if (speedwalkingFrame.quickLeaveEnabled == true) then
    speedwalkingFrame.quickLeaveEnabled = false;
  else
    speedwalkingFrame.quickLeaveEnabled = true;
  end
  speedwalkingVars["quickLeave"] = speedwalkingFrame.quickLeaveEnabled;
  speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoLeaveButton"]:SetChecked(speedwalkingFrame.quickLeaveEnabled);
end

speedwalkingFrame.toggleCMAutoKick = function()
  if (speedwalkingFrame.quickKickEnabled == true) then
    speedwalkingFrame.quickKickEnabled = false;
  else
    speedwalkingFrame.quickKickEnabled = true;
  end
  speedwalkingVars["quickKick"] = speedwalkingFrame.quickKickEnabled;
  speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoKickButton"]:SetChecked(speedwalkingFrame.quickKickEnabled);
end

speedwalkingFrame.toggleCMAutoInvite = function()
  if (speedwalkingFrame.quickInviteEnabled == true) then
    speedwalkingFrame.quickInviteEnabled = false;
  else
    speedwalkingFrame.quickInviteEnabled = true;
  end
  speedwalkingVars["quickInvite"] = speedwalkingFrame.quickInviteEnabled;
  speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoInviteButton"]:SetChecked(speedwalkingFrame.quickInviteEnabled);
end

speedwalkingFrame.setupAddonPanel = function()
  speedwalkingFrame.panel.buttons["SpeedwalkingTrueTimerButton"]:SetChecked(speedwalkingFrame.trueTimer);
  speedwalkingFrame.timewalkingPanel.buttons["SpeedwalkingCompetitiveButton"]:SetChecked(speedwalkingFrame.competitive);
  speedwalkingFrame.panel.buttons["SpeedwalkingGoldTimerButton"]:SetChecked(speedwalkingFrame.goldTimer);
  speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMTimerButton"]:SetChecked(speedwalkingFrame.cms);
  speedwalkingFrame.timewalkingPanel.buttons["SpeedwalkingTimewalkingTimerButton"]:SetChecked(speedwalkingFrame.timewalking);
  speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoStartButton"]:SetChecked(speedwalkingFrame.quickStartEnabled);
  speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoLeaveButton"]:SetChecked(speedwalkingFrame.quickLeaveEnabled);
  speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoKickButton"]:SetChecked(speedwalkingFrame.quickKickEnabled);
  speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoInviteButton"]:SetChecked(speedwalkingFrame.quickInviteEnabled);
end

speedwalkingFrame.enableTW = function()
  local name, _, difficulty, difficultyName, _, _, _, currentZoneID = GetInstanceInfo();
  -- Difficulty 1 is Normal, 2 is Heroic, 8 is CM, 24 is Timewalker
  if (speedwalkingDungeonInfo[currentZoneID] and difficulty == speedwalkingFrame.twDifficulty) then
    speedwalkingFrame.wipeTables();
    speedwalkingFrame.setupTW(currentZoneID);
    speedwalkingFrame.currentTW["lateStart"] = speedwalkingFrame.currentTW["lateStart"] or speedwalkingFrame.inProgressScan(currentZoneID);
    speedwalkingFrame.waitingForKillcount=false;
    if speedwalkingFrame.currentTW["lateStart"] then
      speedwalkingFrame.waitingForKillcount=true;
      SendAddonMessage(speedwalkingFrame.prefix, "KillcountRequest", "RAID");
    end
    -- Late Starts Don't Need An Update
    -- speedwalkingFrame.currentTW["firstUpdate"] = speedwalkingFrame.currentTW["lateStart"];
    speedwalkingFrame.showFrames();
    speedwalkingFrame.inTW = true;
    speedwalkingFrame.inCM = false;
    speedwalkingFrame.updateInfo();
  end
  speedwalkingFrame.resyncTable={};
end

speedwalkingFrame.wipeTW = function()
  local name, _, difficulty, difficultyName, _, _, _, currentZoneID = GetInstanceInfo();
  if (speedwalkingDungeonInfo[currentZoneID] and difficulty == speedwalkingFrame.twDifficulty) then
    speedwalkingFrame.inTW = false;
    speedwalkingFrame.inCM = false;
    speedwalkingFrame.hideFrames();
  end
  speedwalkingFrame.resyncTable={};
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
  speedwalkingFrame.resyncTable={};
end

speedwalkingFrame.wipeCM = function()
  local name, _, difficulty, difficultyName, _, _, _, currentZoneID = GetInstanceInfo();
  if (speedwalkingDungeonInfo[currentZoneID] and difficulty == 8) then
    speedwalkingFrame.inTW = false;
    speedwalkingFrame.inCM = false;
    speedwalkingFrame.hideFrames();
  end
  speedwalkingFrame.resyncTable={};
end

speedwalkingFrame.sendMob = function(guid)
  if speedwalkingFrame.currentTW["lateStart"] then
    local msg = "Mob:" .. guid;
    SendAddonMessage(speedwalkingFrame.prefix, msg, "RAID");
  else
    local msg = "MobTimestamp:" .. guid..":"..GetTime()-speedwalkingFrame.currentTW["startTime"];
    SendAddonMessage(speedwalkingFrame.prefix, msg, "RAID");
  end

end

speedwalkingFrame.sendCurrentTW = function()

end

speedwalkingFrame.addMobToList = function(destGUID)
  speedwalkingFrame.currentTW["enemies"] = speedwalkingFrame.currentTW["enemies"] + 1;
  speedwalkingFrame.currentTW["enemyList"][destGUID] = true;
  if (speedwalkingFrame.currentTW["enemies"] == speedwalkingFrame.currentTW["totalEnemies"]) then
    speedwalkingFrame.currentTW["enemiesTime"] = string.format("|c%s%s|r", speedwalkingFrame.successColor, speedwalkingFrame.currentTW["time"]);
  end
  if speedwalkingFrame.currentTW["lateStart"] then
	speedwalkingFrame.resyncTable[destGUID]=GetTime();
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
      speedwalkingVars["quickStart"] = false;
      speedwalkingVars["quickLeave"] = false;
      speedwalkingVars["quickKick"] = false;
      speedwalkingVars["quickInvite"] = false;
    end
    speedwalkingFrame:ClearAllPoints();
    speedwalkingFrame:SetPoint(speedwalkingVars["anchor"], speedwalkingVars["xOffset"], speedwalkingVars["yOffset"]);
    speedwalkingFrame.trueTimer = speedwalkingVars["trueTimer"];
    speedwalkingFrame.competitive = speedwalkingVars["competitive"];
    speedwalkingFrame.goldTimer = speedwalkingVars["goldTimer"];
    speedwalkingFrame.cms = speedwalkingVars["cmTimer"];
    speedwalkingFrame.timewalking = speedwalkingVars["timewalkingTimer"];
    speedwalkingFrame.killCountIDs = killCountIDs or {};
    speedwalkingFrame.quickStartEnabled = speedwalkingVars["quickStart"] or false;
    speedwalkingFrame.quickLeaveEnabled = speedwalkingVars["quickLeave"] or false;
    speedwalkingFrame.quickKickEnabled = speedwalkingVars["quickKick"] or false;
    speedwalkingFrame.quickInviteEnabled = speedwalkingVars["quickInvite"] or false;
    speedwalkingFrame.setupAddonPanel();
    -- print(speedwalkingVars["anchor"] .. " " .. speedwalkingVars["xOffset"] .. " " .. speedwalkingVars["yOffset"]);
    -- speedwalkingFrame.hideFrames();
  elseif event == "CHAT_MSG_ADDON" then
    local prefix, message, distribution, sender = ...;
    -- print(prefix);
    if (prefix == speedwalkingFrame.prefix) then
      -- Parse message
      local msg = split(message, ":");
      if (msg[1] == "Mob") or (msg[1] == "MobTimestamp") then
        if speedwalkingFrame.currentTW then
          if not speedwalkingFrame.currentTW["enemyList"][msg[2]] and string.format("%d", speedwalkingFrame.currentTW["zoneID"]) == split(msg[2],"\-")[4] then
            speedwalkingFrame.addMobToList(msg[2]);
            -- print(message);
          end
        end
      end
      if (msg[1] == "MobTimestamp") then
        if speedwalkingFrame.currentTW then
          if speedwalkingFrame.resyncTable[msg[2]] then
            local timerSnapshot = tonumber(msg[3]);
            local newOffset = speedwalkingFrame.resyncTable[msg[2]]-timerSnapshot;
            speedwalkingFrame.currentTW["startTime"]=newOffset;
            speedwalkingFrame.currentTW["lateStart"]=false;
            speedwalkingFrame.resyncTable={};
          end
        end
      end
      if speedwalkingFrame.currentTW then
        if (msg[1] == "KillcountRequest") and (not SpeedwalkingFrame.currentTW["lateStart"]) then
          local response = "KillcountResponse:"..speedwalkingFrame.currentTW["enemies"];
          SendAddonMessage(speedwalkingFrame.prefix, response, "RAID");
        end
        if (msg[1] == "KillcountResponse") and speedwalkingFrame.waitingForKillcount then
          speedwalkingFrame.waitingForKillcount=false;
          speedwalkingFrame.currentTW["enemies"]=tonumber(msg[2]);
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
      if ((msg == "UNIT_DIED" or msg == "PARTY_KILL") and speedwalkingDungeonInfo[speedwalkingFrame.currentTW["zoneID"]]["mobs"][split(destGUID,"\-")[6]] and not speedwalkingFrame.currentTW["enemyList"][destGUID]) then
        print(destGUID .. " - " .. destName);
        speedwalkingFrame.addMobToList(destGUID);
        speedwalkingFrame.sendMob(destGUID);
      end
    end
  elseif event == "GROUP_ROSTER_UPDATE" then
    local newHistory={};
    for i=1,GetNumGroupMembers()-1 do
      table.insert(newHistory,GetUnitName("party"..i , true));
    end
    local toonToInvite = ""
    local groupDifferenceCount=0
    for k,v in pairs(speedwalkingFrame.groupHistory) do
      if (not table.contains(newHistory,v)) then
        groupDifferenceCount=groupDifferenceCount+1;
        toonToInvite=v;
      end
      
    end
    if groupDifferenceCount == 1 and speedwalkingFrame.quickInviteEnabled then
      if #speedwalkingFrame.groupHistory == 1 then
        if GetUnitName("player").."-"..GetRealmName()<toonToInvite then
          InviteUnit(toonToInvite);
        end
      else
        InviteUnit(toonToInvite);
      end
    end
    speedwalkingFrame.groupHistory=newHistory;
  elseif event == "UNIT_ENTERED_VEHICLE" then
    if CanExitVehicle() and speedwalkingFrame.quickLeaveEnabled then
      VehicleExit();
    end
  elseif event == "VEHICLE_PASSENGERS_CHANGED" or event == "VEHICLE_UPDATE" then
    if CanEjectPassengerFromSeat(1) and speedwalkingFrame.quickKickEnabled then
      EjectPassengerFromSeat(1)
    end
    if CanEjectPassengerFromSeat(2) and speedwalkingFrame.quickKickEnabled then
      EjectPassengerFromSeat(2)
    end
  end
end

-- Global Variables (Most likely saved later)
speedwalkingFrame.inTW = false;
speedwalkingFrame.inCM = true;
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
speedwalkingFrame.resyncTable = {};
speedwalkingFrame.waitingForKillcount=false;
speedwalkingFrame.speedwalkingDungeonInfo = speedwalkingDungeonInfo;
speedwalkingFrame.killCountIDs = {};
speedwalkingFrame.groupHistory = {};
speedwalkingFrame.quickStartEnabled = false;
speedwalkingFrame.quickLeaveEnabled = false;
speedwalkingFrame.quickKickEnabled = false;
speedwalkingFrame.quickInviteEnabled = false;

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
speedwalkingFrame:RegisterEvent("GROUP_ROSTER_UPDATE");
speedwalkingFrame:RegisterEvent("UNIT_ENTERED_VEHICLE");
speedwalkingFrame:RegisterEvent("VEHICLE_PASSENGERS_CHANGED");
speedwalkingFrame:RegisterEvent("VEHICLE_UPDATE");

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
    speedwalkingVars["quickStart"] = false;
    speedwalkingVars["quickLeave"] = false;
    speedwalkingVars["quickKick"] = false;
    speedwalkingVars["quickInvite"] = false;
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

local b_64='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

-- encoding
function enc_64(data)
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

-- decoding
function dec_64(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

speedwalkingFrame.addIDToTable = function()
    local name = UnitName("target");
    local guid = split(UnitGUID("target"),"-")[6];
    print(name .. ": " .. guid);
    if (not speedwalkingFrame.killCountIDs["count"]) then
      speedwalkingFrame.killCountIDs["count"] = 0;
    end
    speedwalkingFrame.killCountIDs[guid] = name;
    speedwalkingFrame.killCountIDs["count"] = speedwalkingFrame.killCountIDs["count"] + 1;
end
speedwalkingFrame.removeIDFromTable = function()
    local name = UnitName("target");
    local guid = split(UnitGUID("target"),"-")[6];
    print("Removed "..name .. ": " .. guid);
    speedwalkingFrame.killCountIDs[guid] = nil;
end

speedwalkingFrame.clearIDTable = function()
  speedwalkingFrame.killCountIDs = table.wipe(speedwalkingFrame.killCountIDs);
  print("Wiped ID Table");
end

speedwalkingFrame.saveIDTable = function()
  killCountIDs = speedwalkingFrame.killCountIDs;
  print("Saved ID Table");
end
