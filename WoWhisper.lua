-- ============================================================================
-- WoWhisper - Custom colored outbound chat messages
-- ============================================================================

local ADDON_NAME = "WoWhisper"
local playerName = UnitName("player")

-- Default gold color in RGB format (0-1 range)
local DEFAULT_COLOR = {r = 1, g = 0.843, b = 0}  -- FFD700

-- ============================================================================
-- Helper Functions
-- ============================================================================

-- Convert RGB (0-1 range) to hex string (RRGGBB)
local function RGBToHex(r, g, b)
    return string.format("%02X%02X%02X", r * 255, g * 255, b * 255)
end

-- Get color from SavedVariables or default
local function GetColor(colorType)
    if WoWhisperDB and WoWhisperDB.colors and WoWhisperDB.colors[colorType] then
        local c = WoWhisperDB.colors[colorType]
        return RGBToHex(c.r, c.g, c.b)
    end
    return RGBToHex(DEFAULT_COLOR.r, DEFAULT_COLOR.g, DEFAULT_COLOR.b)
end

-- ============================================================================
-- Chat Filter Functions
-- ============================================================================

-- Filter function for sent whispers
local function FilterWhisperInform(self, event, message, ...)
    local coloredMessage = "|cFF" .. GetColor("whisper") .. message .. "|r"
    return false, coloredMessage, ...
end

-- Filter function for sent BattleNet whispers
local function FilterBNetWhisperInform(self, event, message, ...)
    local coloredMessage = "|cFF" .. GetColor("bnet") .. message .. "|r"
    return false, coloredMessage, ...
end

-- Filter function for party chat
local function FilterParty(self, event, message, sender, ...)
    local senderName = sender:match("([^-]+)") or sender
    
    if senderName == playerName then
        local coloredMessage = "|cFF" .. GetColor("party") .. message .. "|r"
        return false, coloredMessage, sender, ...
    end
    return false, message, sender, ...
end

-- Filter function for guild chat
local function FilterGuild(self, event, message, sender, ...)
    local senderName = sender:match("([^-]+)") or sender
    
    if senderName == playerName then
        local coloredMessage = "|cFF" .. GetColor("guild") .. message .. "|r"
        return false, coloredMessage, sender, ...
    end
    return false, message, sender, ...
end

-- Filter function for public channels (/1, /2, /3)
local function FilterChannel(self, event, message, sender, language, channelName, ...)
    local senderName = sender:match("([^-]+)") or sender
    local channelNum = channelName and tonumber(channelName:match("^(%d+)"))
    
    if senderName == playerName and channelNum and channelNum >= 1 and channelNum <= 3 then
        local coloredMessage = "|cFF" .. GetColor("public") .. message .. "|r"
        return false, coloredMessage, sender, language, channelName, ...
    end
    return false, message, sender, language, channelName, ...
end

-- Register chat filters
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", FilterWhisperInform)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", FilterBNetWhisperInform)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", FilterParty)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", FilterParty)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", FilterGuild)
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", FilterChannel)

-- ============================================================================
-- Settings Frame
-- ============================================================================

local settingsFrame
local minimapButton
local colorSwatches = {}
local channelLabels = {}

-- Update swatch and label text colors
local function UpdateColorDisplay(colorType)
    if not WoWhisperDB or not WoWhisperDB.colors then return end
    
    local color = WoWhisperDB.colors[colorType]
    if colorSwatches[colorType] then
        colorSwatches[colorType]:SetColorTexture(color.r, color.g, color.b)
    end
    if channelLabels[colorType] then
        channelLabels[colorType]:SetTextColor(color.r, color.g, color.b)
    end
end

-- Reset all colors to default gold
local function ResetColorsToDefault()
    WoWhisperDB.colors = {
        whisper = {r = DEFAULT_COLOR.r, g = DEFAULT_COLOR.g, b = DEFAULT_COLOR.b},
        party = {r = DEFAULT_COLOR.r, g = DEFAULT_COLOR.g, b = DEFAULT_COLOR.b},
        guild = {r = DEFAULT_COLOR.r, g = DEFAULT_COLOR.g, b = DEFAULT_COLOR.b},
        bnet = {r = DEFAULT_COLOR.r, g = DEFAULT_COLOR.g, b = DEFAULT_COLOR.b},
        public = {r = DEFAULT_COLOR.r, g = DEFAULT_COLOR.g, b = DEFAULT_COLOR.b}
    }
    UpdateColorDisplay("whisper")
    UpdateColorDisplay("party")
    UpdateColorDisplay("guild")
    UpdateColorDisplay("bnet")
    UpdateColorDisplay("public")
    print("|cFFFFD700WoWhisper:|r All colors reset to gold.")
end

-- Reset confirmation dialog
StaticPopupDialogs["WOWHISPER_RESET_CONFIRM"] = {
    text = "Reset all colors to gold?",
    button1 = "Accept",
    button2 = "Cancel",
    OnAccept = function()
        ResetColorsToDefault()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

-- Create color picker button (supports grid layout with x,y offsets)
local function CreateColorButton(parent, colorType, label, xOffset, yOffset)
    local row = CreateFrame("Frame", nil, parent)
    row:SetSize(140, 28)
    row:SetPoint("TOP", parent, "TOP", xOffset, yOffset)
    
    -- Label (right-aligned before swatch)
    local labelText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    labelText:SetPoint("RIGHT", row, "CENTER", -5, 0)
    labelText:SetText(label .. ":")
    channelLabels[colorType] = labelText
    
    -- Color swatch button (fixed position, left of center)
    local button = CreateFrame("Button", nil, row)
    button:SetSize(22, 22)
    button:SetPoint("LEFT", row, "CENTER", 5, 0)
    
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.2, 0.2, 0.2, 1)
    
    local colorTexture = button:CreateTexture(nil, "ARTWORK")
    colorTexture:SetPoint("TOPLEFT", 2, -2)
    colorTexture:SetPoint("BOTTOMRIGHT", -2, 2)
    colorSwatches[colorType] = colorTexture
    
    -- Click handler for color picker
    button:SetScript("OnClick", function()
        local color = WoWhisperDB.colors[colorType]
        local r, g, b = color.r, color.g, color.b
        
        local info = {
            swatchFunc = function()
                local newR, newG, newB = ColorPickerFrame:GetColorRGB()
                WoWhisperDB.colors[colorType] = {r = newR, g = newG, b = newB}
                UpdateColorDisplay(colorType)
            end,
            
            hasOpacity = false,
            
            opacityFunc = nil,
            
            cancelFunc = function()
                WoWhisperDB.colors[colorType] = {r = r, g = g, b = b}
                UpdateColorDisplay(colorType)
            end,
            
            r = r,
            g = g,
            b = b,
        }
        
        -- Use modern API if available, fall back to legacy
        if ColorPickerFrame.SetupColorPickerAndShow then
            ColorPickerFrame:SetupColorPickerAndShow(info)
        else
            -- Legacy API fallback
            ColorPickerFrame.func = info.swatchFunc
            ColorPickerFrame.cancelFunc = info.cancelFunc
            ColorPickerFrame.hasOpacity = info.hasOpacity
            ColorPickerFrame.opacity = info.opacity
            ColorPickerFrame:SetColorRGB(r, g, b)
            ColorPickerFrame:Show()
        end
    end)
    
    button:SetScript("OnEnter", function(self)
        bg:SetColorTexture(0.4, 0.4, 0.4, 1)
    end)
    
    button:SetScript("OnLeave", function(self)
        bg:SetColorTexture(0.2, 0.2, 0.2, 1)
    end)
    
    return row
end

-- Create the main settings frame
local function CreateSettingsFrame()
    local frame = CreateFrame("Frame", "WoWhisperSettingsFrame", UIParent, "BackdropTemplate")
    frame:SetSize(280, 270)
    frame:SetPoint("CENTER")
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(100)
    frame:EnableMouse(true)
    frame:Hide()
    
    -- Backdrop
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = {left = 11, right = 12, top = 12, bottom = 11}
    })
    
    -- Title bar
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -15)
    title:SetText("WoWhisper")
    
    -- Close button
    local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", -5, -5)
    
    -- Color buttons (single column)
    CreateColorButton(frame, "whisper", "Whisper", 0, -45)
    CreateColorButton(frame, "party", "Party", 0, -75)
    CreateColorButton(frame, "guild", "Guild", 0, -105)
    CreateColorButton(frame, "bnet", "BNet", 0, -135)
    CreateColorButton(frame, "public", "Public /1/2/3", 0, -165)
    
    -- Match all to Whisper button (centered above bottom buttons)
    local matchButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    matchButton:SetSize(160, 24)
    matchButton:SetPoint("BOTTOM", frame, "BOTTOM", 0, 52)
    matchButton:SetText("Match all to Whisper")
    matchButton:SetScript("OnClick", function()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
        local whisperColor = WoWhisperDB.colors.whisper
        WoWhisperDB.colors.party = {r = whisperColor.r, g = whisperColor.g, b = whisperColor.b}
        WoWhisperDB.colors.guild = {r = whisperColor.r, g = whisperColor.g, b = whisperColor.b}
        WoWhisperDB.colors.bnet = {r = whisperColor.r, g = whisperColor.g, b = whisperColor.b}
        WoWhisperDB.colors.public = {r = whisperColor.r, g = whisperColor.g, b = whisperColor.b}
        UpdateColorDisplay("party")
        UpdateColorDisplay("guild")
        UpdateColorDisplay("bnet")
        UpdateColorDisplay("public")
    end)
    
    -- Reset button (bottom left)
    local resetButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    resetButton:SetSize(100, 24)
    resetButton:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 25, 18)
    resetButton:SetText("Reset to Gold")
    resetButton:SetScript("OnClick", function()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
        StaticPopup_Show("WOWHISPER_RESET_CONFIRM")
    end)
    
    -- Accept button (bottom right)
    local acceptButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    acceptButton:SetSize(100, 24)
    acceptButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -25, 18)
    acceptButton:SetText("Accept")
    acceptButton:SetScript("OnClick", function()
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
        frame:Hide()
    end)
    
    -- Always center on show
    frame:SetScript("OnShow", function(self)
        self:ClearAllPoints()
        self:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
        UpdateColorDisplay("whisper")
        UpdateColorDisplay("party")
        UpdateColorDisplay("guild")
        UpdateColorDisplay("bnet")
        UpdateColorDisplay("public")
    end)
    
    return frame
end

-- ============================================================================
-- Minimap Button
-- ============================================================================

local function CreateMinimapButton()
    local button = CreateFrame("Button", "WoWhisperMinimapButton", Minimap)
    button:SetSize(32, 32)
    button:SetFrameStrata("MEDIUM")
    button:SetFrameLevel(8)
    button:RegisterForClicks("AnyUp")
    button:RegisterForDrag("LeftButton")
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
    
    -- Icon
    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon:SetSize(20, 20)
    icon:SetPoint("CENTER", 0, 1)
    icon:SetTexture("Interface\\AddOns\\WoWhisper\\media\\WoWhisperLogo")
    
    -- Border
    local overlay = button:CreateTexture(nil, "OVERLAY")
    overlay:SetSize(52, 52)
    overlay:SetPoint("TOPLEFT", 0, 0)
    overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    
    -- Tooltip
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("WoWhisper", 1, 1, 1)
        GameTooltip:AddLine("Click to configure colors", 0.8, 0.8, 0.8)
        GameTooltip:Show()
    end)
    
    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)
    
    -- Click handler
    button:SetScript("OnClick", function(self, btn)
        if settingsFrame then
            if settingsFrame:IsShown() then
                settingsFrame:Hide()
            else
                settingsFrame:Show()
            end
        end
    end)
    
    -- Position based on angle
    local function UpdatePosition()
        local angle = math.rad(WoWhisperDB.minimapAngle or 300)
        local x = math.cos(angle) * 80
        local y = math.sin(angle) * 80
        button:SetPoint("CENTER", Minimap, "CENTER", x, y)
    end
    
    -- Drag handler
    button:SetScript("OnDragStart", function(self)
        self:LockHighlight()
        self:SetScript("OnUpdate", function(self)
            local mx, my = Minimap:GetCenter()
            local px, py = GetCursorPosition()
            local scale = Minimap:GetEffectiveScale()
            px, py = px / scale, py / scale
            
            local angle = math.deg(math.atan2(py - my, px - mx))
            WoWhisperDB.minimapAngle = angle
            UpdatePosition()
        end)
    end)
    
    button:SetScript("OnDragStop", function(self)
        self:UnlockHighlight()
        self:SetScript("OnUpdate", nil)
    end)
    
    UpdatePosition()
    button:Show()
    return button
end

-- ============================================================================
-- Initialization
-- ============================================================================

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")

eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        -- Initialize SavedVariables
        if not WoWhisperDB then
            WoWhisperDB = {}
        end
        
        if not WoWhisperDB.colors then
            WoWhisperDB.colors = {
                whisper = {r = DEFAULT_COLOR.r, g = DEFAULT_COLOR.g, b = DEFAULT_COLOR.b},
                party = {r = DEFAULT_COLOR.r, g = DEFAULT_COLOR.g, b = DEFAULT_COLOR.b},
                guild = {r = DEFAULT_COLOR.r, g = DEFAULT_COLOR.g, b = DEFAULT_COLOR.b},
                bnet = {r = DEFAULT_COLOR.r, g = DEFAULT_COLOR.g, b = DEFAULT_COLOR.b},
                public = {r = DEFAULT_COLOR.r, g = DEFAULT_COLOR.g, b = DEFAULT_COLOR.b}
            }
        end
        
        -- Ensure guild and public colors exist for existing users
        if not WoWhisperDB.colors.guild then
            WoWhisperDB.colors.guild = {r = DEFAULT_COLOR.r, g = DEFAULT_COLOR.g, b = DEFAULT_COLOR.b}
        end
        if not WoWhisperDB.colors.public then
            WoWhisperDB.colors.public = {r = DEFAULT_COLOR.r, g = DEFAULT_COLOR.g, b = DEFAULT_COLOR.b}
        end
        
        -- Set a default minimap position that is higher up (upper-left),
        -- but don't override players who have already dragged the button.
        if not WoWhisperDB.minimapAngle or WoWhisperDB.minimapAngle == 225 then
            WoWhisperDB.minimapAngle = 135  -- Upper left position
        end
        
        -- Create UI
        settingsFrame = CreateSettingsFrame()
        minimapButton = CreateMinimapButton()
        
        -- Add to UISpecialFrames for ESC key closing
        tinsert(UISpecialFrames, "WoWhisperSettingsFrame")
        
    elseif event == "PLAYER_LOGIN" then
        -- Welcome message
        print("|cFFFFD700WoWhisper|r has loaded! Use /ww or click the minimap button to configure colors.")
        
        -- Ensure minimap button is visible
        if minimapButton then
            minimapButton:Show()
        end
    end
end)

-- ============================================================================
-- Slash Commands
-- ============================================================================

SLASH_WOWHISPER1 = "/wowhisper"
SLASH_WOWHISPER2 = "/ww"
SlashCmdList["WOWHISPER"] = function(msg)
    if settingsFrame then
        if settingsFrame:IsShown() then
            settingsFrame:Hide()
            print("|cFFFFD700WoWhisper:|r Settings closed.")
        else
            settingsFrame:Show()
            print("|cFFFFD700WoWhisper:|r Settings opened.")
        end
    end
end
