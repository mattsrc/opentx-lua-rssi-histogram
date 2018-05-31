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
    not_models = {'Combat1', 'UMX Timber'};
    widget = ValueWidget('tx-voltage', {label='TxV', decimals=1})
  },
  {
    column = 1;
    row = 1;
    only_models = {'Combat1'};
    widget = ValueWidget('A2', {decimals=1})
  },
  {
    column = 1;
    row = 1;
    only_models = {'UMX Timber'};
    widget = SwitchWidget('sb', {
    labels = {'NoFlp', 'Flap1', 'Flap2'},
    flags = {0, INVERS, INVERS}
    })
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
    not_models = {'Nano QX 3D'};
    widget = TimerWidget(2, {})
  },
  {
    column = 2;
    row = 2;
    only_models = {'Nano QX 3D'};
    widget = SwitchWidget('sc', {
    labels = {'T40', 'T25', 'LIN'},
    flags = {0, INVERS, INVERS}
    })
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
    not_models = {'Nano QX 3D'};
    widget = LineWidget({})
  },
  };
}

-- X9D display is 212x64 pixels.  This setup puts RSSI on the right side and
-- other data on the left
--
local X9D_Layout = {
  columns = {52, 105, 158, 211};
  rows = {11, 24, 37, 50, 63};
  pad = 2;
  widgets = {
  {
    column = 0;
    row = 0;
    width = 2;
    widget = LabelWidget({
    init_func = function()
      return model.getInfo().name
    end;
    label_flags = BOLD;
    })
  },
  {
    column = 2;
    row = 0;
    width = 2;
    height = 4;
    widget = RSSIHistogramWidget({greyscale = true})
  },
  {
    column = 0;
    row = 1;
    widget = SwitchWidget('sd', {
    labels = {'Cut', 'Arm', 'Cut'},
    flags = {0, BLINK + INVERS, 0}
    })
  },
  {
    column = 1;
    row = 1;
    widget = SwitchWidget('sc', {
    labels = {'High', 'Low', 'Low'},
    flags = {0, INVERS, INVERS}
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
    only_models = {'Queen Bee'};
    widget = SwitchWidget('sa', {
    labels = {'NoFlp', 'Flap1', 'Flap2'},
    flags = {0, INVERS, INVERS}
    })
  },
  {
    column = 1;
    row = 2;
    not_models = {'Queen Bee'};
    widget = ValueWidget('tx-voltage', {label='TxV', decimals=1})
  },
  {
    column = 0;
    row = 3;
    widget = TimerWidget(1, {})
  },
  {
    column = 1;
    row = 3;
    only_models = {'Queen Bee'};
    widget = SwitchWidget('sb', {
    labels = {'Rud40', 'Rd100', 'NoRud'},
    flags = {0, INVERS, INVERS}
    })
  },
  {
    column = 1;
    row = 3;
    only_models = {'FM Edge', 'Skywing 50e'};
    widget = ValueWidget('CelL', {label='CeL', decimals=2})
  },
  {
    column = 1;
    row = 3;
    only_models = {'SU-29'};
    widget = ValueWidget('A2', {decimals=1})
  },
  {
    column = 1;
    row = 3;
    not_models = {'Queen Bee', 'FM Edge', 'SU-29', 'Skywing 50e'};
    widget = ValueWidget('RxBt', {label='RV', decimals=1})
  },
  {
    column = 0;
    row = 4;
    widget = TimerWidget(2, {})
  },
  {
    column = 1;
    row = 4;
    not_models = {'Queen Bee', 'FM Edge'};
    widget = ValueWidget('RxBt-', {label='RV-', decimals=1})
  },
  {
    column = 1;
    row = 4;
    only_models = {'Queen Bee'};
    widget = ValueWidget('CelL', {label='CeL', decimals=2})
  },
  {
    column = 1;
    row = 4;
    only_models = {'FM Edge'};
    widget = ValueWidget('Gyr', {
      func = function()
		if getValue('ch10') > 750 then
		  return 'OFF'
		end
		return math.floor(getValue('ch9') * 100 / 1024 + 0.5)
	  end
	})
  },
  {
    column = 2;
    row = 4;
    widget = ValueWidget('RS', {func = getRSSI})
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
    row = 1;
    height = 0;
    width = 2;
    pad = 0;
    widget = LineWidget({})
  },
  {
    column = 0;
    row = 2;
    height = 0;
    width = 1;
    pad = 0;
    only_models = {'Queen Bee'};
    widget = LineWidget({})
  },
  {
    column = 0;
    row = 2;
    height = 0;
    width = 2;
    pad = 0;
    not_models = {'Queen Bee'};
    widget = LineWidget({})
  },
  {
    column = 1;
    row = 2;
    height = 3;
    width = 0;
    pad = 0;
    widget = LineWidget({})
  },
  {
    column = 1;
    row = 4;
    height = 0;
    width = 1;
    pad = 0;
    only_models = {'Queen Bee'};
    widget = LineWidget({})
  },
  {
    column = 2;
    row = 0;
    height = 5;
    width = 0;
    pad = 0;
    widget = LineWidget({})
  },
  };
}

local function chooseLayout()
  local _, radio = getVersion()

  if string.find(radio, 'x9d') ~= nil then
    return X9D_Layout
  end

  return QX7_Layout
end
