resetGlobalVarIndex = 5

-- X9D display is 212x64 pixels.  This setup puts RSSI on the right side and
-- other data on the left
--
local X9D_Layout = {
  columns = {105, 211};
  rows = {15, 31, 47, 63};
  pad = 2;
  widgets = {
  {
    column = 0;
    row = 0;
    widget = LabelWidget({
    init_func = function()
      return model.getInfo().name
    end;
    label_flags = MIDSIZE + BOLD;
    })
  },
  {
    column = 0;
    row = 1;
    widget = TimerWidget(0, {
	  timer_flags = MIDSIZE,
	  label_flags = MIDSIZE
	})
  },
  {
    column = 0;
    row = 2;
    widget = TimerWidget(1, {
	  timer_flags = MIDSIZE,
	  label_flags = MIDSIZE
	})
  },
  {
    column = 0;
    row = 3;
    widget = ValueWidget('tx-voltage', {
	  label='Tx Voltage';
	  decimals=1;
	  label_flags = MIDSIZE,
	  value_flags = MIDSIZE
	})
  },
  {
    column = 1;
    row = 0;
    widget = SwitchWidget('sd', {
    labels = {'Cut', 'Arm', 'Cut'},
    flags = {MIDSIZE, MIDSIZE + BLINK + INVERS, MIDSIZE}
    })
  },
  {
    column = 1;
    row = 1;
    widget = SwitchWidget('sf', {
    labels = {'Cut', 'Arm', 'Arm'},
    flags = {MIDSIZE, MIDSIZE + BLINK + INVERS, MIDSIZE + BLINK + INVERS}
    })
  },
  {
    column = 1;
    row = 2;
    widget = ValueWidget('Tail Gyro', {
      func = function()
		return math.floor(getValue('ch5') * 100 / 1024 + 0.5)
	  end;
	  label_flags = MIDSIZE,
	  value_flags = MIDSIZE
	})
  },
  {
    column = 1;
    row = 3;
    widget = SwitchWidget('sc', {
    labels = {'Idle1', 'Idle2', 'Linear'},
    flags = {MIDSIZE, MIDSIZE + INVERS, MIDSIZE + INVERS}
    })
  },
  {
    column = 0;
    row = 1;
    height = 0;
    width = 1;
    pad = 0;
    widget = LineWidget({})
  },
  {
    column = 0;
    row = 3;
    height = 0;
    width = 1;
    pad = 0;
    widget = LineWidget({})
  },
  {
    column = 1;
    row = 0;
    height = 4;
    width = 0;
    pad = 0;
    widget = LineWidget({})
  },
  {
    column = 1;
    row = 2;
    height = 0;
    width = 1;
    pad = 0;
    widget = LineWidget({})
  },
  };
}

local function chooseLayout()
  return X9D_Layout
end
