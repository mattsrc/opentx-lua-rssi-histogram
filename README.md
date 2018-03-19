# opentx-lua-rssi-histogram
LUA telemetry script for OpenTX that provides an RSSI histogram.  It can be customized to show other status information as well.  Tested and used on a QX7 and X9D with Open TX 2.2

## Getting Started

    * Copy the script SCRIPTS/TELEMETRY/widget.lua to SCRIPTS/TELEMETRY/ on your SD card
    * Either in Companion, or your Radio choose a model to configure and go to the "Telemetry Screens" page
    * Select "widget.lua" for one of the pages
    * If in Companion start the simulator.  If on a real radio, go to the main screen
    * Hold the "Page" button to see telemetry screens, then press the "Page" button to switch between screens.

## Customization

You can customize the layout and content of the telemetry sceen to show other telemetry values, times, switch states and more.

You do this by editing the SCRIPTS/TELEMETRY/widget.lua file in a text editor.  I suggest taking small steps, making one change and verifying the results until the file format becomes comfortable.

Start by searching for the word "CONFIG".  This will take you to the start of the configuration section.  This configuration has two lists - one for the X9D and a separate list for the QX7.  Go to the list you are interested in.

Here is the list for the QX7


### Format

### Layout

--   Widget layout is based on flexible grid.  e.g. Say we want
--
--   +---+--+-+
--   |   |  | |
--   +   +--+-+
--   |   |  | |
--   +---+--+-+
--
-- The above is an example for illustration.  In the example, say that '-' is
-- 10 pixels wide and '|' is ten pixels high.  This makes the overall grid
-- 60x20 pixels.  The grid has a cell dimension of 3x2.  Note that the left
-- "large" cell is treated by the system as a multicell of 1x2 cell dimension
-- (30x20 pixels).
--
-- We would define the cells above as:
--
-- columns = {30, 40, 50}
-- rows = {10, 20}
--
-- This gives
--
--   +---+--+-+
--   |   |  | |
--   +---+--+-+
--   |   |  | |
--   +---+--+-+
--
-- We then turn the left cell into a multicell (as shown originally), by
-- specifying a height of 2 cells when the widget is created, for example:
--
-- widgets = {
--   {
--     column = 0;
--     row = 1;
--     height = 2;
--     widget = RSSIHistogramWidget({})
--   },
--   {
--     column = 1;
--     row = 0;
--     pad = 5;  -- optional override of pad for this widget
--     widget = ValueWidget('RSSI')
--   }
--   ... and so on
-- }
--
-- Note that width and height are optional and assumed == 1 if omitted.

### Collection and Display

-- Specifies how often you want data to be collected.
-- Units are in ms.
local BG_THROTTLE = {
  freq_ms = 100,  -- collect every 100ms (ten times a second)
  next_ms = 0
}

-- Specifies how often you want data to be displayed.  This should probably
-- be >= BG_THROTTLE to avoid pointless refreshes of identical data.
local RUN_THROTTLE = {
  freq_ms = 100,  -- display every 100ms
  next_ms = 0
}

### Resetting

-- Set this to 0 for GV1, 1 for GV2, etc
-- If >= 0, this can be used to signal the telemetry script to reset itself.
-- The idea is that you would create a special function that "Adjusts Global Variable",
-- Setting the global variable to any non-zero value.
resetGlobalVarIndex = -1

### Per Model Customization

## Current Widget List

###
