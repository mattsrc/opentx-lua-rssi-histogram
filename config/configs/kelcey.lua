resetGlobalVarIndex = 5

-- QX7 display is 128x64 pixels.  This Setup uses the top for RSSI and a 3x2 grid underneath
local QX7_Layout = {
  columns = {42, 85, 127};
  rows = {43, 53, 63};
  pad = 2;
  widgets = {
  {
    column = 0;
    row = 0;
    width = 3;
    pad = 3;
    widget = RSSIHistogramWidget({})
  },
  {
    column = 0;
    row = 1;
    widget = ValueWidget('RS', {func=getRSSI})
  },
  {
    column = 1;
    row = 1;
	not_models = {'Combat1'};
    widget = ValueWidget('tx-voltage', {label='TxV', decimals=1})
  },
  {
    column = 1;
    row = 1;
    only_models = {'Combat1'};
    widget = ValueWidget('A2', {decimals=1})
  },
  {
    column = 2;
    row = 1;
    widget = SwitchWidget('sd', {
    labels = {'Cut', 'Arm', 'Cut'},
    flags = {0, BLINK + INVERS, 0}
    })
  },
  {
    column = 0;
    row = 2;
    widget = TimerWidget(0, {})
  },
  {
    column = 1;
    row = 2;
    widget = TimerWidget(1, {})
  },
  {
    column = 2;
    row = 2;
    widget = TimerWidget(2, {})
  },
  {
    column = 1;
    row = 1;
    height = 2;
    width = 0;
    pad = 0;
    widget = LineWidget({})
  },
  {
    column = 2;
    row = 1;
    height = 2;
    width = 0;
    pad = 0;
    widget = LineWidget({})
  },
  {
    column = 2;
    row = 2;
    height = 0;
    width = 1;
    pad = 0;
    widget = LineWidget({})
  },
  };
}

local function chooseLayout()
  return QX7_Layout
end
