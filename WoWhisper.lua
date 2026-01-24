-- ============================================================================
-- WoWhisper Configuration
-- ============================================================================
-- Edit the color values below to customize your outbound chat message colors
-- Colors are in hex format (RRGGBB)

-- Alternative Color Presets, or find your own custom Hex color: https://tinyurl.com/3363ese7
-- "00FF41"  -- Matrix Green
-- "FF8C00"  -- Orange
-- "00FFFF"  -- Cyan
-- "90EE90"  -- Light Green

-- Active Channel Colors
local WHISPER_COLOR = "FFD700"  -- Gold: FFD700 (default)
local PARTY_COLOR = "FFD700"    -- Gold: FFD700 (default)
local BNET_WHISPER_COLOR = "FFD700"  -- Gold: FFD700 (default)



-- ============================================================================
-- Core
-- ============================================================================

-- Get player's character name for identifying outbound messages
local playerName = UnitName("player")

-- Filter function for sent whispers
local function FilterWhisperInform(self, event, message, ...)
    -- Apply color to outbound whisper messages
    local coloredMessage = "|cFF" .. WHISPER_COLOR .. message .. "|r"
    return false, coloredMessage, ...
end

-- Filter function for sent BattleNet whispers
local function FilterBNetWhisperInform(self, event, message, ...)
    -- Apply color to outbound BattleNet whisper messages
    local coloredMessage = "|cFF" .. BNET_WHISPER_COLOR .. message .. "|r"
    return false, coloredMessage, ...
end

-- Filter function for party chat
local function FilterParty(self, event, message, sender, ...)
    -- Strip realm name from sender for comparison (handles cross-realm scenarios)
    local senderName = sender:match("([^-]+)") or sender
    
    -- Only color messages sent by the player
    if senderName == playerName then
        local coloredMessage = "|cFF" .. PARTY_COLOR .. message .. "|r"
        return false, coloredMessage, sender, ...
    end
    return false, message, sender, ...
end

-- Register chat filters
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", FilterWhisperInform)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", FilterBNetWhisperInform)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", FilterParty)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", FilterParty)
