# WoWhisper

A World of Warcraft Classic TBC add-on that improves chat readability by color-coding your outbound messages in whisper, party, and bnet channels.

## Features

- **Colored Whispers**: Your sent whispers display in VS Code Blue (#007ACC) for easy distinction from received messages
- **Colored Party Chat**: Your party messages display in Medium Green (#00CC00) to distinguish from other party members
- **Easy Customization**: Simple configuration section at the top of the script with color presets
- **Lightweight**: Minimal performance impact using efficient chat filters

## Installation

1. Download the WoWhisper folder
2. Copy the entire `WoWhisper` folder to your World of Warcraft add-ons directory:
   ```
   usually: C:\Program Files (x86)\World of Warcraft\_anniversary_\Interface\AddOns
   ```
3. Restart World of Warcraft (or reload UI with `/reload`)
4. The add-on will automatically activate - no configuration needed!

## Customizing Colors

To change the colors used for your outbound messages:

1. Open `WoWhisper.lua` in any text editor
2. Find the configuration section at the top of the file
3. Edit the hex color values:
   ```lua
   local WHISPER_COLOR = "007ACC"  -- Change this hex code
   local PARTY_COLOR = "00CC00"    -- Change this hex code
   ```
4. Save the file and `/reload` in-game

### Pre-configured Color Options

The script includes several alternative colors you can quickly swap in:
- **Matrix Green**: `00FF41`
- **Orange**: `FF8C00`
- **Cyan**: `00FFFF`
- **Light Green**: `90EE90`
- **Gold**: `FFD700`

Simply uncomment the color preset you want and comment out the current active color.

## Requirements

- World of Warcraft Classic TBC (Client version 2.5.5 or compatible)
- No dependencies - works standalone

## Author

Created by [@skymccrary](https://github.com/skymccrary)

## Version

1.0.0
