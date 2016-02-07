-- Interface Panel
speedwalkingFrame.panel = CreateFrame("Frame", "SpeedwalkingPanel", UIParent);
speedwalkingFrame.panel.name = "Speedwalking";
speedwalkingFrame.panel.dropdowns = {};
speedwalkingFrame.panel.sliders = {};
speedwalkingFrame.panel.buttons = {};
speedwalkingFrame.panel.buttonText = {};

speedwalkingFrame.cmPanel = CreateFrame("Frame", "SpeedwalkingCMPanel", speedwalkingFrame.panel);
speedwalkingFrame.cmPanel.name = "Challenge Modes";
speedwalkingFrame.cmPanel.parent = speedwalkingFrame.panel.name;
speedwalkingFrame.cmPanel.buttons = {};
speedwalkingFrame.cmPanel.buttonText = {};

speedwalkingFrame.timewalkingPanel = CreateFrame("Frame", "SpeedwalkingTimewalkingPanel", speedwalkingFrame.panel);
speedwalkingFrame.timewalkingPanel.name = "Timewalking";
speedwalkingFrame.timewalkingPanel.parent = speedwalkingFrame.panel.name;
speedwalkingFrame.timewalkingPanel.buttons = {};
speedwalkingFrame.timewalkingPanel.buttonText = {};

speedwalkingFrame.panel.header = speedwalkingFrame.panel:CreateFontString(nil, "ARTWORK");
speedwalkingFrame.panel.header:SetFontObject(GameFontNormalLarge);
speedwalkingFrame.panel.header:SetJustifyH("LEFT");
speedwalkingFrame.panel.header:SetJustifyV("TOP");
speedwalkingFrame.panel.header:ClearAllPoints();
speedwalkingFrame.panel.header:SetPoint("TOPLEFT", 5, 0);
speedwalkingFrame.panel.header:SetText("Speedwalking Options");

speedwalkingFrame.cmPanel.header = speedwalkingFrame.cmPanel:CreateFontString(nil, "ARTWORK");
speedwalkingFrame.cmPanel.header:SetFontObject(GameFontNormalLarge);
speedwalkingFrame.cmPanel.header:SetJustifyH("LEFT");
speedwalkingFrame.cmPanel.header:SetJustifyV("TOP");
speedwalkingFrame.cmPanel.header:ClearAllPoints();
speedwalkingFrame.cmPanel.header:SetPoint("TOPLEFT", 5, 0);
speedwalkingFrame.cmPanel.header:SetText("Challenge Mode Options");

speedwalkingFrame.timewalkingPanel.header = speedwalkingFrame.timewalkingPanel:CreateFontString(nil, "ARTWORK");
speedwalkingFrame.timewalkingPanel.header:SetFontObject(GameFontNormalLarge);
speedwalkingFrame.timewalkingPanel.header:SetJustifyH("LEFT");
speedwalkingFrame.timewalkingPanel.header:SetJustifyV("TOP");
speedwalkingFrame.timewalkingPanel.header:ClearAllPoints();
speedwalkingFrame.timewalkingPanel.header:SetPoint("TOPLEFT", 5, 0);
speedwalkingFrame.timewalkingPanel.header:SetText("Timewalking Options");

-- Buttons
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

speedwalkingFrame.panel.buttonText["SpeedwalkingGoldTimerText"] = speedwalkingFrame.panel:CreateFontString(nil, "ARTWORK");
speedwalkingFrame.panel.buttonText["SpeedwalkingGoldTimerText"]:SetFontObject(GameFontWhite);
speedwalkingFrame.panel.buttonText["SpeedwalkingGoldTimerText"]:SetJustifyH("LEFT");
speedwalkingFrame.panel.buttonText["SpeedwalkingGoldTimerText"]:SetJustifyV("TOP");
speedwalkingFrame.panel.buttonText["SpeedwalkingGoldTimerText"]:ClearAllPoints();
speedwalkingFrame.panel.buttonText["SpeedwalkingGoldTimerText"]:SetPoint("TOPLEFT", speedwalkingFrame.panel, "TOPLEFT", 30, -70);
speedwalkingFrame.panel.buttonText["SpeedwalkingGoldTimerText"]:SetText("Gold Timer");

speedwalkingFrame.panel.buttons["SpeedwalkingGoldTimerButton"] = CreateFrame("CheckButton", "SpeedwalkingGoldTimerButton", speedwalkingFrame.panel, "OptionsCheckButtonTemplate");
speedwalkingFrame.panel.buttons["SpeedwalkingGoldTimerButton"]:SetPoint("TOPLEFT", speedwalkingFrame.panel, "TOPLEFT", 5, -60);
speedwalkingFrame.panel.buttons["SpeedwalkingGoldTimerButton"]:SetText("Gold Timer");
speedwalkingFrame.panel.buttons["SpeedwalkingGoldTimerButton"]:SetChecked(true);
speedwalkingFrame.panel.buttons["SpeedwalkingGoldTimerButton"]:SetScript("OnClick", function(self) speedwalkingFrame.toggleGoldTimer() end);

speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMTimerText"] = speedwalkingFrame.cmPanel:CreateFontString(nil, "ARTWORK");
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMTimerText"]:SetFontObject(GameFontWhite);
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMTimerText"]:SetJustifyH("LEFT");
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMTimerText"]:SetJustifyV("TOP");
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMTimerText"]:ClearAllPoints();
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMTimerText"]:SetPoint("TOPLEFT", speedwalkingFrame.cmPanel, "TOPLEFT", 30, -30);
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMTimerText"]:SetText("CM Timer");

speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMTimerButton"] = CreateFrame("CheckButton", "SpeedwalkingCMTimerButton", speedwalkingFrame.cmPanel, "OptionsCheckButtonTemplate");
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMTimerButton"]:SetPoint("TOPLEFT", speedwalkingFrame.cmPanel, "TOPLEFT", 5, -20);
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMTimerButton"]:SetText("CM Timer");
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMTimerButton"]:SetChecked(true);
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMTimerButton"]:SetScript("OnClick", function(self) speedwalkingFrame.toggleCMTimer() end);

speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoStartText"] = speedwalkingFrame.cmPanel:CreateFontString(nil, "ARTWORK");
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoStartText"]:SetFontObject(GameFontWhite);
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoStartText"]:SetJustifyH("LEFT");
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoStartText"]:SetJustifyV("TOP");
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoStartText"]:ClearAllPoints();
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoStartText"]:SetPoint("TOPLEFT", speedwalkingFrame.cmPanel, "TOPLEFT", 30, -50);
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoStartText"]:SetText("Auto Start CM");

speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoStartButton"] = CreateFrame("CheckButton", "SpeedwalkingCMAutoStartButton", speedwalkingFrame.cmPanel, "OptionsCheckButtonTemplate");
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoStartButton"]:SetPoint("TOPLEFT", speedwalkingFrame.cmPanel, "TOPLEFT", 5, -40);
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoStartButton"]:SetText("Auto Start CM");
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoStartButton"]:SetChecked(false);
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoStartButton"]:SetScript("OnClick", function(self) speedwalkingFrame.toggleCMAutoStart() end);

speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoLeaveText"] = speedwalkingFrame.cmPanel:CreateFontString(nil, "ARTWORK");
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoLeaveText"]:SetFontObject(GameFontWhite);
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoLeaveText"]:SetJustifyH("LEFT");
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoLeaveText"]:SetJustifyV("TOP");
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoLeaveText"]:ClearAllPoints();
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoLeaveText"]:SetPoint("TOPLEFT", speedwalkingFrame.cmPanel, "TOPLEFT", 30, -70);
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoLeaveText"]:SetText("Auto Leave Vehicle");

speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoLeaveButton"] = CreateFrame("CheckButton", "SpeedwalkingCMAutoLeaveButton", speedwalkingFrame.cmPanel, "OptionsCheckButtonTemplate");
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoLeaveButton"]:SetPoint("TOPLEFT", speedwalkingFrame.cmPanel, "TOPLEFT", 5, -60);
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoLeaveButton"]:SetText("Auto Leave Vehicle");
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoLeaveButton"]:SetChecked(false);
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoLeaveButton"]:SetScript("OnClick", function(self) speedwalkingFrame.toggleCMAutoLeave() end);

speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoKickText"] = speedwalkingFrame.cmPanel:CreateFontString(nil, "ARTWORK");
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoKickText"]:SetFontObject(GameFontWhite);
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoKickText"]:SetJustifyH("LEFT");
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoKickText"]:SetJustifyV("TOP");
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoKickText"]:ClearAllPoints();
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoKickText"]:SetPoint("TOPLEFT", speedwalkingFrame.cmPanel, "TOPLEFT", 30, -90);
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoKickText"]:SetText("Auto Kick From Vehicle");

speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoKickButton"] = CreateFrame("CheckButton", "SpeedwalkingCMAutoKickButton", speedwalkingFrame.cmPanel, "OptionsCheckButtonTemplate");
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoKickButton"]:SetPoint("TOPLEFT", speedwalkingFrame.cmPanel, "TOPLEFT", 5, -80);
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoKickButton"]:SetText("Auto Kick From Vehicle");
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoKickButton"]:SetChecked(false);
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoKickButton"]:SetScript("OnClick", function(self) speedwalkingFrame.toggleCMAutoKick() end);

speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoInviteText"] = speedwalkingFrame.cmPanel:CreateFontString(nil, "ARTWORK");
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoInviteText"]:SetFontObject(GameFontWhite);
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoInviteText"]:SetJustifyH("LEFT");
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoInviteText"]:SetJustifyV("TOP");
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoInviteText"]:ClearAllPoints();
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoInviteText"]:SetPoint("TOPLEFT", speedwalkingFrame.cmPanel, "TOPLEFT", 30, -110);
speedwalkingFrame.cmPanel.buttonText["SpeedwalkingCMAutoInviteText"]:SetText("Auto Invite After Member Leaves");

speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoInviteButton"] = CreateFrame("CheckButton", "SpeedwalkingCMAutoInviteButton", speedwalkingFrame.cmPanel, "OptionsCheckButtonTemplate");
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoInviteButton"]:SetPoint("TOPLEFT", speedwalkingFrame.cmPanel, "TOPLEFT", 5, -100);
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoInviteButton"]:SetText("Auto Invite After Member Leaves");
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoInviteButton"]:SetChecked(false);
speedwalkingFrame.cmPanel.buttons["SpeedwalkingCMAutoInviteButton"]:SetScript("OnClick", function(self) speedwalkingFrame.toggleCMAutoInvite() end);

speedwalkingFrame.timewalkingPanel.buttonText["SpeedwalkingTimewalkingTimerText"] = speedwalkingFrame.timewalkingPanel:CreateFontString(nil, "ARTWORK");
speedwalkingFrame.timewalkingPanel.buttonText["SpeedwalkingTimewalkingTimerText"]:SetFontObject(GameFontWhite);
speedwalkingFrame.timewalkingPanel.buttonText["SpeedwalkingTimewalkingTimerText"]:SetJustifyH("LEFT");
speedwalkingFrame.timewalkingPanel.buttonText["SpeedwalkingTimewalkingTimerText"]:SetJustifyV("TOP");
speedwalkingFrame.timewalkingPanel.buttonText["SpeedwalkingTimewalkingTimerText"]:ClearAllPoints();
speedwalkingFrame.timewalkingPanel.buttonText["SpeedwalkingTimewalkingTimerText"]:SetPoint("TOPLEFT", speedwalkingFrame.timewalkingPanel, "TOPLEFT", 30, -30);
speedwalkingFrame.timewalkingPanel.buttonText["SpeedwalkingTimewalkingTimerText"]:SetText("Timewalking Timer");

speedwalkingFrame.timewalkingPanel.buttons["SpeedwalkingTimewalkingTimerButton"] = CreateFrame("CheckButton", "SpeedwalkingTimewalkingTimerButton", speedwalkingFrame.timewalkingPanel, "OptionsCheckButtonTemplate");
speedwalkingFrame.timewalkingPanel.buttons["SpeedwalkingTimewalkingTimerButton"]:SetPoint("TOPLEFT", speedwalkingFrame.timewalkingPanel, "TOPLEFT", 5, -20);
speedwalkingFrame.timewalkingPanel.buttons["SpeedwalkingTimewalkingTimerButton"]:SetText("Timewalking Timer");
speedwalkingFrame.timewalkingPanel.buttons["SpeedwalkingTimewalkingTimerButton"]:SetChecked(true);
speedwalkingFrame.timewalkingPanel.buttons["SpeedwalkingTimewalkingTimerButton"]:SetScript("OnClick", function(self) speedwalkingFrame.toggleTimewalkingTimer() end);

speedwalkingFrame.timewalkingPanel.buttonText["SpeedwalkingCompetitiveText"] = speedwalkingFrame.timewalkingPanel:CreateFontString(nil, "ARTWORK");
speedwalkingFrame.timewalkingPanel.buttonText["SpeedwalkingCompetitiveText"]:SetFontObject(GameFontWhite);
speedwalkingFrame.timewalkingPanel.buttonText["SpeedwalkingCompetitiveText"]:SetJustifyH("LEFT");
speedwalkingFrame.timewalkingPanel.buttonText["SpeedwalkingCompetitiveText"]:SetJustifyV("TOP");
speedwalkingFrame.timewalkingPanel.buttonText["SpeedwalkingCompetitiveText"]:ClearAllPoints();
speedwalkingFrame.timewalkingPanel.buttonText["SpeedwalkingCompetitiveText"]:SetPoint("TOPLEFT", speedwalkingFrame.timewalkingPanel, "TOPLEFT", 30, -50);
speedwalkingFrame.timewalkingPanel.buttonText["SpeedwalkingCompetitiveText"]:SetText("Competitive Mode (Beta Feature)");

speedwalkingFrame.timewalkingPanel.buttons["SpeedwalkingCompetitiveButton"] = CreateFrame("CheckButton", "SpeedwalkingCompetitiveButton", speedwalkingFrame.timewalkingPanel, "OptionsCheckButtonTemplate");
speedwalkingFrame.timewalkingPanel.buttons["SpeedwalkingCompetitiveButton"]:SetPoint("TOPLEFT", speedwalkingFrame.timewalkingPanel, "TOPLEFT", 5, -40);
speedwalkingFrame.timewalkingPanel.buttons["SpeedwalkingCompetitiveButton"]:SetText("Competitive Mode (Beta Feature)");
speedwalkingFrame.timewalkingPanel.buttons["SpeedwalkingCompetitiveButton"]:SetChecked(false);
speedwalkingFrame.timewalkingPanel.buttons["SpeedwalkingCompetitiveButton"]:SetScript("OnClick", function(self) speedwalkingFrame.toggleCompetitive() end);

-- Sliders
speedwalkingFrame.createSlider = function(name, panel, width, height, orientation, point, xOffset, yOffset, min, max, text, defaultValue, step, type, frame, fName)
  speedwalkingFrame.panel.sliders[name] = CreateFrame("Slider", name, panel, "OptionsSliderTemplate");
  local currentSlider = speedwalkingFrame.panel.sliders[name];
  currentSlider.labelText = text;
  currentSlider:SetWidth(width);
  currentSlider:SetHeight(height);
  currentSlider:SetOrientation(orientation);
  currentSlider:SetPoint(point, xOffset, yOffset);
  currentSlider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal");
  _G[currentSlider:GetName() .. 'Low']:SetText(min);
  _G[currentSlider:GetName()  .. 'High']:SetText(max);
  _G[currentSlider:GetName()  .. 'Text']:SetText(text .. " : 0");
  currentSlider:SetMinMaxValues(min, max);
  currentSlider:SetValue(defaultValue);
  currentSlider:SetValueStep(step);

  if (type == "FRAME") then
    currentSlider:SetScript("OnValueChanged", function(self, value)
      self:SetValue(value)
      _G[self:GetName()  .. 'Text']:SetText(self.labelText .. " : " .. self:GetValue());
      speedwalkingVars[string.gsub(self:GetName(), "Slider", "")] = self:GetValue();
      frame:ClearAllPoints();
      frame:SetPoint(speedwalkingVars["Speedwalking" .. fName .. "Point"], speedwalkingVars["Speedwalking" .. fName .. "XOffset"], speedwalkingVars["Speedwalking" .. fName .. "YOffset"]);
    end);
  elseif (type == "FONT") then
    currentSlider:SetScript("OnValueChanged", function(self, value)
      self:SetValue(value)
      _G[self:GetName()  .. 'Text']:SetText(self.labelText .. " : " .. self:GetValue());
      speedwalkingVars[string.gsub(self:GetName(), "Slider", "")] = self:GetValue();
      frame.font:SetFont("Interface\\Addons\\Speedwalking\\MyriadCondensedWeb.ttf", speedwalkingVars[string.gsub(self:GetName(), "Slider", "")], "OUTLINE");
    end);
  end

  currentSlider:Show();
  currentSlider:Enable();
end

speedwalkingFrame.createDropDownMenu = function(name, panel, width, height, point, xOffset, yOffset, defaultID, font)
  speedwalkingFrame.panel.dropdowns[name] = CreateFrame("Button", name, panel, "UIDropDownMenuTemplate");
  local currentDropDown = speedwalkingFrame.panel.dropdowns[name];
  currentDropDown:SetPoint(point, xOffset, yOffset);
  local items = {
    "LEFT",
    "CENTER",
    "RIGHT",
  }

  local function OnClick(self)
    UIDropDownMenu_SetSelectedID(currentDropDown, self:GetID());
    speedwalkingVars["SpeedwalkingTimerAlign"] = self.value;
    font:SetJustifyH(speedwalkingVars["SpeedwalkingTimerAlign"]);
    -- Click Needs To Set Position
    -- Then Save To Account Variable
    -- Then Realign
    -- http://wowprogramming.com/snippets/Create_UI-styled_dropdown_menu_10
  end

  local function initialize(self, level)
    local info = UIDropDownMenu_CreateInfo()
    for k,v in pairs(items) do
      info = UIDropDownMenu_CreateInfo();
      info.text = v;
      info.value = v;
      info.func = OnClick;
      UIDropDownMenu_AddButton(info, 1);
    end
  end

  UIDropDownMenu_Initialize(currentDropDown, initialize);
  UIDropDownMenu_SetSelectedID(currentDropDown, defaultID);
  UIDropDownMenu_JustifyText(currentDropDown, "LEFT");
  UIDropDownMenu_SetWidth(currentDropDown, width);
  UIDropDownMenu_SetButtonWidth(currentDropDown, width + 25);
end

speedwalkingFrame.createSlider("SpeedwalkingTimerXOffsetSlider", speedwalkingFrame.panel, 175, 20, "HORIZONTAL", "TOPLEFT", 5, -140, -100, 100, "xOffset", 0, 1, "FRAME", speedwalkingTimerFrame, "Timer");
speedwalkingFrame.createSlider("SpeedwalkingTimerYOffsetSlider", speedwalkingFrame.panel, 175, 20, "HORIZONTAL", "TOPLEFT", 205, -140, -100, 100, "yOffset", 0, 1, "FRAME", speedwalkingTimerFrame, "Timer");
speedwalkingFrame.createSlider("SpeedwalkingTimerFontSizeSlider", speedwalkingFrame.panel, 175, 20, "HORIZONTAL", "TOPLEFT", 405, -140, 10, 32, "Font Size", 29, 1, "FONT", speedwalkingTimerFrame);

speedwalkingFrame.createDropDownMenu("SpeedwalkingTimerAlign", speedwalkingFrame.panel, 100, 50, "TOPLEFT", -15, -180, 2, speedwalkingTimerFrame.font);

speedwalkingFrame.panel.timerHeader = speedwalkingFrame.panel:CreateFontString(nil, "ARTWORK");
local currentHeader = speedwalkingFrame.panel.timerHeader;
currentHeader:SetFontObject(GameFontNormalLarge);
currentHeader:SetJustifyH("LEFT");
currentHeader:SetJustifyV("TOP");
currentHeader:ClearAllPoints();
currentHeader:SetPoint("TOPLEFT", 5, -100);
currentHeader:SetText("Timer Options");

speedwalkingFrame.createSlider("SpeedwalkingObjectiveXOffsetSlider", speedwalkingFrame.panel, 175, 20, "HORIZONTAL", "TOPLEFT", 5, -260, -100, 100, "xOffset", 0, 1, "FRAME", speedwalkingObjectiveFrame, "Objective");
speedwalkingFrame.createSlider("SpeedwalkingObjectiveYOffsetSlider", speedwalkingFrame.panel, 175, 20, "HORIZONTAL", "TOPLEFT", 205, -260, -100, 100, "yOffset", -40, 1, "FRAME", speedwalkingObjectiveFrame, "Objective");
speedwalkingFrame.createSlider("SpeedwalkingObjectiveFontSizeSlider", speedwalkingFrame.panel, 175, 20, "HORIZONTAL", "TOPLEFT", 405, -260, 10, 32, "Font Size", 29, 1, "FONT", speedwalkingObjectiveFrame);

speedwalkingFrame.createDropDownMenu("SpeedwalkingObjectiveAlign", speedwalkingFrame.panel, 100, 50, "TOPLEFT", -15, -300, 1, speedwalkingObjectiveFrame.font);

speedwalkingFrame.panel.objectiveHeader = speedwalkingFrame.panel:CreateFontString(nil, "ARTWORK");
local currentHeader = speedwalkingFrame.panel.objectiveHeader;
currentHeader:SetFontObject(GameFontNormalLarge);
currentHeader:SetJustifyH("LEFT");
currentHeader:SetJustifyV("TOP");
currentHeader:ClearAllPoints();
currentHeader:SetPoint("TOPLEFT", 5, -220);
currentHeader:SetText("Objective Options");


InterfaceOptions_AddCategory(speedwalkingFrame.panel);
InterfaceOptions_AddCategory(speedwalkingFrame.cmPanel);
InterfaceOptions_AddCategory(speedwalkingFrame.timewalkingPanel);
