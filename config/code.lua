-- Looking for configuration?  Search this file for CONFIG
--
-- RSSI Histogram and Simple Widget Implementation V1.0
--
-- The goal of this telemetry script is to provide a simple way to define
-- custom widgets, including graphs, for the Taranis X9D, QX& and close variants.
--
-- Disclaimer:
-- 
-- Although this script has been tested and OpenTX is designed to tolerate
-- LUA script bugs, it can not be guaranteed that this script is safe to use.
-- You assume all liability for any damage caused by the result of using
-- this script. Use this script at your own risk.

-- Please see the file README.md for usage documentation on widgets.  The
-- comments here focus on implementation details.

--
-- Utility Functions
--

local function MapSwitches()
  local _, radio = getVersion()
  if string.find(radio, 'x7') ~= nil then
	-- The QX7 has no SE switch.
	return {
	{'sa', 3},
	{'sb', 3},
	{'sc', 3},
	{'sd', 3},
	{'sf', 3},
	{'sg', 3},
	{'sh', 3},
	}
  end
  return {
  {'sa', 3},
  {'sb', 3},
  {'sc', 3},
  {'sd', 3},
  {'se', 3},
  {'sf', 3},
  {'sg', 3},
  {'sh', 3},
  }
end

local switch_pos_map = MapSwitches()

local function TwoDigit(v)
  if v < 10 then
    return "0" .. tostring(v)
  end
  return tostring(v)
end

-- == Widget Definitions ==
--
-- This is your library of "widgets" that you can select from in your telemetry screen.
-- Of course, you can also create your own.
--
-- Basic definition is
--  
--   widget = {
--     init = function(self) end;
--     bg = function(self) end;
--     draw = function(self, rx, ry, rw, rh) end;
--   }
--  
-- init: Called at start and if resetGlobalVarIndex GV is > 0
-- bg: Called priodically whether the telemetry screen is shown or not
-- draw: Called when the LCD is ready to be drawn to
-- 
-- init, bg, and draw are all optional can can be omitted if they are
-- not needed.

--
-- RSSI graph widget
--
local function RSSIHistogramWidget(options)
  local widget = {
  init = function(self)
    self.max_bucket = 0
    self.max_log_bucket = 0
    for i=0, 100
    do
    self.buckets[i] = 0
    end
  end;

  bg = function(self)
      local rssi = getRSSI()
      if options.throttle_chan then
		if (getValue(options.throttle_chan) < -900) and (rssi <= 0) then
          return
		end
	  elseif rssi <= 0 then
		return
	  end

      if rssi > 100 then
        -- sometimes RSSI can be > 100, but cap it here for graphing purposes
        rssi = 100
      end
    
      self.buckets[rssi] = self.buckets[rssi] + 1
    
      if self.buckets[rssi] > self.max_bucket then
        -- We have a new maximum.  Adjust y scaling.
        self.max_bucket = self.buckets[rssi]
        self.max_log_bucket = math.log(self.max_bucket)
      end
  end;

  draw = function(self, rx, ry, rw, rh)
    if rw < 100 then
      -- not enough space to draw
      return
    end
    
    -- center the graph
    rx = rx + (rw - 100) / 2
    
    -- bottom line is 4 pixels
    local by = ry + rh - 4
    local bh = by - ry
    
    -- draw the bottom axis
    lcd.drawLine(rx, by + 1, rx + 100, by + 1, SOLID, FORCE)
    
    -- draw pixel marks of varying lengths at each 5%, 10% and 50%
    for i=0, 100, 5 do
      local height = 2
      if i % 50 == 0 then
        height = 4
      elseif i % 10 == 0 then
        height = 3
      end
      lcd.drawLine(rx + i, by + 1, rx + i, by + 1 + height, SOLID, FORCE)
    end

    local rssi, _, alarm_crit = getRSSI()

    -- draw low and critical marks
    if options.greyscale then
      lcd.drawFilledRectangle(rx, ry, alarm_crit, by - ry + 1, GREY_DEFAULT)
    else
      lcd.drawLine(rx, by + 2, rx + alarm_crit, by + 2, SOLID, FORCE)
    end 

    -- draw each bucket
    for i = 0, 100 do
      local bval = self.buckets[i]
      if bval > 0 then
        local height = bh * math.log(bval) / self.max_log_bucket 
        local x = rx + i
        local y = by - height

        -- Draw the line differently if it's the current RSSI.  This gives
        -- a visual indicator of where RSSI currently is.
        if i == rssi and rssi > 0 then
          if options.greyscale then
            lcd.drawLine(x, y, x, by, SOLID, GREY_DEFAULT + FORCE)
          end
          lcd.drawPoint(x, y)
        else
          lcd.drawLine(x, y, x, by, SOLID, FORCE)
        end
      end
    end
  end,

  -- Local state maintained by this widget
  buckets = {},
  }

  return widget
end

--
-- LabelWidget
--
local function LabelWidget(options)
  local label_flags = options.label_flags or 0
  local widget = {
    init = function(self)
      if options.init_func then
        self.label = options.init_func()
      else
        self.label = options.label
      end
    end;

    draw = function(self, rx, ry, rw, rh)
      lcd.drawText(rx, ry, self.label, label_flags)
    end
  }
  return widget
end


--
-- ValueWidget
--
local function ValueWidget(parm, options)
  local decimals = options.decimals or -1
  local label_flags = options.label_flags or 0
  local value_flags = options.value_flags or 0
  local label = options.label or parm
  value_flags = value_flags + RIGHT

  local func = function()
    local value = getValue(parm)
    if decimals >= 0 then
      local mult = 10^(decimals or 0)
      value = math.floor(value * mult + 0.5) / mult
    end
    return value
  end

  if options.func then
    func = options.func
  end

  local widget = {
    draw = function(self, rx, ry, rw, rh)
      lcd.drawText(rx, ry, label, label_flags)
      lcd.drawText(rx + rw, ry, func(), value_flags)
    end
  }
  return widget
end


--
-- SwitchWidget
--
local function SwitchWidget(switch, options)
  local switch_idx = 1
  local switch_positions = 0
  for _, keyval in ipairs(switch_pos_map) do
  key, val = keyval[1], keyval[2]
    if key == switch then
      switch_positions = val
      break
    end
    switch_idx = switch_idx + val
  end

  if switch_positions == 0 then
    -- unknown switch
    return {}
  end

  local widget = {
  draw = function(self, rx, ry, rw, rh)
    local switch_val = (getValue(switch) + 1024) * (switch_positions - 1) / 2048
    local flags = 0
    if options.flags then
    flags = options.flags[switch_val + 1]
    end
    lcd.drawSwitch(rx, ry, switch_idx + switch_val, flags)

    if not options.labels then
    return
    end

    flags = flags + RIGHT
    lcd.drawText(rx + rw, ry, options.labels[switch_val + 1], flags)
  end
  }
  return widget
end


--
-- TimerWidget
--
local function TimerWidget(timer_number, options)
  local label_flags = options.label_flags or 0
  local timer_flags = options.timer_flags or 0
  timer_flags = timer_flags + RIGHT
  local widget = {
  draw = function(self, rx, ry, rw, rh)
    local timer = model.getTimer(timer_number)
    lcd.drawText(rx, ry, "T" .. timer_number, label_flags)
    lcd.drawTimer(rx + rw + 3, ry, timer.value, timer_flags)
  end
  }
  return widget
end


--
-- CurrentTimeWidget
--
local function CurrentTimeWidget(options)
  local flags = options.flags or 0
  local flash = true
  if options.flash ~= nil then
	flash = options.flash
  end
  local show_seconds = options.show_seconds or false

  local widget = {
    draw = function(self, rx, ry, rw, rh)
      local t = getDateTime()
      local sep = ":"
      if flash and ((getTime() % 100) < 50) then
        sep = " "
      end
      local str = TwoDigit(t.hour) .. sep .. TwoDigit(t.min)
      if show_seconds then
        str = str .. sep .. TwoDigit(t.sec)
      end
      lcd.drawText(rx, ry, str, flags)
    end
  }
  return widget
end

--
-- CurrentDateWidget
--
local function CurrentDateWidget(options)
  local separator = options.separator or "-"
  local flags = options.flags or 0

  local widget = {
    draw = function(self, rx, ry, rw, rh)
      local t = getDateTime()
      local str = t.year .. separator .. t.mon .. separator .. t.day
      lcd.drawText(rx, ry, str, flags)
    end
  }
  return widget
end


--
-- LineWidget
--
local function LineWidget(options)
  local pattern = options.pattern or SOLID
  local flags = options.flags or FORCE
  local widget = {
  draw = function(self, rx, ry, rw, rh)
    lcd.drawLine(rx, ry, rx + rw, ry + rh, pattern, flags)
  end
  }
  return widget
end

--
-- Static Config
--
-- Optionally move these under CONFIG_START (or redefine them)
-- if you want to change the values.

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

--
-- CONFIG START
--

-- A basic placeholder config

resetGlobalVarIndex = -1

local genericSetup = {
  columns = {127};
  rows = {63};
  pad = 2;
  widgets = {
  {
    column = 0;
    row = 0;
    pad = 3;
    widget = RSSIHistogramWidget({})
  }}
}


local function chooseLayout()
  return genericSetup
end

--
-- CONFIG END
--

local Setup = nil

-- == Support Code ==

local function filterWidgets(widgets)
  local name = model.getInfo().name
  local filtered = {}
  for _, w in ipairs(widgets) do
  local include = true

  if include and w.only_models then
    include = false
    for _, mname in ipairs(w.only_models) do
    if name == mname then
      include = true
    end
    end
  end

  if include and w.not_models then
    for _, mname in ipairs(w.not_models) do
    if name == mname then
      include = false
    end
    end
  end

  if include then
    filtered[#filtered + 1] = w
  end
  end

  return filtered
end

local function filterLayout(setup)
  filtered = {}
  for key, val in pairs(setup) do
  if key == 'widgets' then
    filtered.widgets = filterWidgets(val)
  else
    filtered[key] = val
  end
  end
  return filtered
end

local function initFunc()
  Setup = filterLayout(chooseLayout())

  for _, w in ipairs(Setup.widgets) do
  if w.widget.init then
    w.widget:init()
  end
  end

  if resetGlobalVarIndex >= 0 then
    -- Set only for flight mode zero.  See if anyone cares?
    model.setGlobalVariable(resetGlobalVarIndex, 0, 0)
  end
end


local function isThrottled(throttle)
  local t_ms = getTime() * 10

  if t_ms < throttle.next_ms then
  return true
  end

  throttle.next_ms = t_ms + throttle.freq_ms
  return false
end


local function BGFunc()
  if isThrottled(BG_THROTTLE) then
    return
  end

  if resetGlobalVarIndex >= 0 then
    if model.getGlobalVariable(resetGlobalVarIndex, 0) ~= 0 then
      initFunc()
    end
  end
  
  -- Call each registered bg function
  for _, w in ipairs(Setup.widgets) do
  if w.widget.bg then
    w.widget:bg()
  end
  end
end

-- Return bounding box in pixels
local function getBoundingBox(widget)
  local rx = 0
  if widget.column > 0 then
  rx = Setup.columns[widget.column]
  end

  local ry = 0
  if widget.row > 0 then
  ry = Setup.rows[widget.row]
  end

  local cellw = widget.width or 1
  local rw = Setup.columns[widget.column + cellw] - rx

  local cellh = widget.height or 1
  local rh = Setup.rows[widget.row + cellh] - ry

  local pad = widget.pad or Setup.pad

  return rx + pad, ry + pad , rw - (pad * 2) , rh - (pad * 2)
end

local function runFunc(event)
  if isThrottled(RUN_THROTTLE) then
  return
  end

  lcd.clear()

  -- Call each registered draw function
  for _, w in ipairs(Setup.widgets) do
    if w.widget.draw then
      local rx, ry, rw, rh = getBoundingBox(w)
      w.widget:draw(rx, ry, rw, rh)
    end
  end
end


-- Return handlers
return { init=initFunc, background=BGFunc, run=runFunc }
