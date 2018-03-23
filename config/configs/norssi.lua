resetGlobalVarIndex = 5

-- X9D display is 212x64 pixels.  This setup puts RSSI on the right side and
-- other data on the left
local X9D_Layout = {
  columns = {82, 120, 168, 211};
  rows = {11, 24, 37, 50, 63};
  pad = 2;
  widgets = {
  {
    column = 0;
    row = 0;
    width = 2;
    height = 2;
    pad = 5;
    widget = LabelWidget({
    init_func = function()
      return model.getInfo().name
    end;
    label_flags = BOLD + MIDSIZE;
    })
  },
  {
    column = 0;
    row = 2;
    widget = TimerWidget(0, {
      label_flags = MIDSIZE;
      timer_flags = MIDSIZE;
    })
  },
  {
    column = 0;
    row = 3;
    widget = TimerWidget(1, {
      label_flags = MIDSIZE;
      timer_flags = MIDSIZE;
    })
  },
  {
    column = 0;
    row = 4;
    widget = TimerWidget(2, {
      label_flags = MIDSIZE;
      timer_flags = MIDSIZE;
    })
  },

  {
    column = 1;
    row = 0;
    widget = ValueWidget('tx-voltage', {label='TxV', decimals=1})
  },
  {
    column = 1;
    row = 1;
    widget = ValueWidget('RxBt', {label='RV', decimals=1})
  },
  {
    column = 1;
    row = 2;
    widget = ValueWidget('RxBt-', {label='RV-', decimals=1})
  },
  {
    column = 1;
    row = 4;
    pad = 3;
    widget = CurrentTimeWidget({})
  },


  {
    column = 2;
    row = 0;
    width = 2;
    widget = SwitchWidget('sd', {
    labels = {'Throttle Cut', 'Throttle Arm', 'Throttle Cut'},
    flags = {0, BLINK + INVERS, 0}
    })
  },
  {
    column = 2;
    row = 1;
    width = 2;
    widget = SwitchWidget('sc', {
    labels = {'High Rates', 'Low Rates', 'Low Rates'},
    flags = {0, INVERS, INVERS}
    })
  },
  {
    column = 2;
    row = 2;
    width = 2;
    widget = SwitchWidget('sa', {
    labels = {'No Flaps', 'Takeoff Flaps', 'Landing Flaps'},
    flags = {0, INVERS, INVERS}
    })
  },

  {
    column = 1;
    row = 3;
    widget = ValueWidget('Cel1', {decimals=2})
  },
  {
    column = 2;
    row = 3;
    widget = ValueWidget('Cel2', {decimals=2})
  },
  {
    column = 3;
    row = 3;
    widget = ValueWidget('Cel3', {decimals=2})
  },

  {
    column = 2;
    row = 4;
    widget = ValueWidget('RSSI', {func = getRSSI})
  },
  {
    column = 3;
    row = 4;
    widget = ValueWidget('RAS', {
    func = function()
      local ras = getRAS()
      if ras then
      return ras
      end
      return 'N/A'
    end
    })
  },

  {
    column = 0;
    row = 2;
    height = 0;
    width = 1;
    pad = 0;
    widget = LineWidget({})
  },
  {
    column = 1;
    row = 0;
    height = 5;
    width = 0;
    pad = 0;
    widget = LineWidget({})
  },
  {
    column = 2;
    row = 0;
    height = 3;
    width = 0;
    pad = 0;
    widget = LineWidget({})
  },
  {
    column = 2;
    row = 4;
    height = 1;
    width = 0;
    pad = 0;
    widget = LineWidget({})
  },
  {
    column = 1;
    row = 3;
    height = 0;
    width = 3;
    pad = 0;
    widget = LineWidget({})
  },
  {
    column = 1;
    row = 4;
    height = 0;
    width = 3;
    pad = 0;
    widget = LineWidget({})
  },
  };
}

local function chooseLayout()
  return X9D_Layout
end
