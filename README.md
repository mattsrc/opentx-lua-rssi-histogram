# opentx-lua-rssi-histogram
LUA telemetry script for OpenTX that provides an RSSI histogram.  It can be
customized to show other status information as well.  Tested and used on a QX7
and X9D with Open TX 2.2

## Getting Started

    * Copy the script SCRIPTS/TELEMETRY/widget.lua to SCRIPTS/TELEMETRY/ on
      your SD card
    * Either in Companion, or your Radio choose a model to configure and go to
      the "Telemetry Screens" page
    * Select "widget.lua" for one of the pages
    * If in Companion start the simulator.  If on a real radio, go to the main
      screen
    * Hold the "Page" button to see telemetry screens, then press the "Page"
      button to switch between screens.

## Customization

You can customize the layout and content of the telemetry sceen to show other
telemetry values, times, switch states and more.

There are two ways to do this:

    * Edit SCRIPTS/TELEMETRY/widget.lua, search for "CONFIG START", and start
      hacking in new values.
    * Create (or copy) a new file in config/configs.  This file contains only
      the configuration data and no code.  You can then combine the data and
      code using the provided python script in config.  For example:
      _python combine.py configs/myconfig.lua_

The second method involves extra steps but it will be easier to run with the
latest version of the code.  You can also manage multiple configuration more
easily with this method.  But it's up to you - starting simple might be the best
way to start as you can easily change your mind later.

### Format

### Layout

Widget layout is via a flexible grid system.  This section explains what a
flexible grid is and how to use it. If you are familiar with the concept, feel
free to skip or skip this section.

We'll start with an analogy that is nearly idential, a spreadsheet.  Here is a
spreadsheet that contains our model name, a couple of switch states, a couple
timers, some voltages, and the RSSI graph:

![Basic Example](./images/layout_example_1.png)

The first improvement is to make the title and graph extend to take more than
one cell:

![Combining Rows and Columns](./images/layout_example_2.png)

Next, we can resize rows and columns as needed to make better use of the space:

![Resizing Rows and Columns](./images/layout_example_3.png)

As a final touch, we add lines to visually group the data.

![Grouping With Lines](./images/layout_example_4.png)

With the above in mind, we are realy to understand the layout system.  To start,
we provide a layout structura in luae:

    layout = {
      -- stuff goes here
    }

Next we add a definition for rows and columns.  The numbers are pixel offsets.
The QX7 has a screen resolution of 128x64 so the maximum sensible column offset
is 127 and the maximum sensible row offset is 63.  The X9D has a reolution of
212x64.  Let's proceed with the X9D, trying to make something that looks like
the spreadsheet example.

    layout = {
      columns = {52, 105, 158, 211};
      rows = {20, 41, 52, 63};
    }

Note that the "0" row and columns are assumed and not put into the definition.
So by the aboive definition:

    * Cell 0, 0 has a width of 52 pixels and a height of 20 pixels.  
    * Cell 2, 2 has a width of (158 - 105) = 53 pixels and a height of
      (52 - 41) = 11 pixels.
    * Cell 3, 2 has a width of (211 - 158) = 53 pixels and a height of
      (52 - 41) = 11 pixels.
      
and so on.

There is also the concept of padding.  Padding puts a bit of space around
widgets, which usually looks nicer:

    layout = {
      columns = {52, 105, 158, 211};
      rows = {11, 24, 37, 50, 63};
      pad = 2;
    }

Let's start adding widgets:

    layout = {
      columns = {52, 105, 158, 211};
      rows = {11, 24, 37, 50, 63};
      pad = 2;
      widgets = {
        -- list them here
      }
    }

First, the model title:

    layout = {
      columns = {52, 105, 158, 211};
      rows = {11, 24, 37, 50, 63};
      pad = 2;
      widgets = {
        {
          column = 0;
          row = 0;
          width = 2;
          widget = LabelWidget({label = "FunFly"});
        }
      }
    }

Let's looks at some of the new details.  The values _column_ and _row_ tell
where to put the widget.  The _width_ paramter is used here to specify the
column span of 2.  If the span was 1, you could omit _width_.  This is why there
is no _height_, the default of 1 is what we want anyway.

Finally, the widget itself.  We are using a very simple _LabelWidget_.  It's too
simple, really.  Better would be to have the current model name as reported by
OpenTX.  That is absolutly possible, but I'll defer the details until the
"widgets" section below.

Let's add one more widget, the histogram, to complete the example.  To fully
reproduce the spreadsheet, we would need to add many more but this would expose
details that I feel are best explained in the Widgets section below.  The
focus of this section is understanding how rows, columns, widths, and heights
work:


    layout = {
      columns = {52, 105, 158, 211};
      rows = {11, 24, 37, 50, 63};
      pad = 2;
      widgets = {
        {
          column = 0;
          row = 0;
          width = 2;
          widget = LabelWidget({label = "FunFly"});
        },
        {
          column = 2;
          row = 0;
          width = 2;
          height = 3;
          widget = RSSIHistogramWidget()
        }
      }
    }

## Widget Basics


## Widget Reference


### Per Radio and Per Model Customization

To support multiple radios and models, you have two options:

#### Static Config

  * Create a separate config for each model you have.  These are best
    placed in _config/configs_
  * Use _configs/combine.py_ to make a lua for each model.  Example usage is
    _python combine.py configs/edg540.lua_
  * In the telemetry page for each model, choose the corresponding lua file.

This approach has downsides if you have many models - especially since models
tend to be similar.  Below you can learn to do it with one config.

#### Dynamic Config - Per model widgets

There are two additional widget fields: *not_models* and *only_models* which can
be used as filters.  Each takes a list.

For example, say you have the following layout:

    layout = {
      columns = {52, 105, 158, 211};
      rows = {11, 24, 37, 50, 63};
      pad = 2;
      widgets = {
      }
        -- stuff...
        {
          column = 1;
          row = 2;
          only_models = {'Mustang', 'Beaver'};
          widget = SwitchWidget('sa', {
          labels = {'NoFlp', 'Flap1', 'Flap2'},
          flags = {0, INVERS, INVERS}
          })
        },
        {
          column = 1;
          row = 2;
          not_models = {'Mustang', 'Beaver'};
          widget = ValueWidget('tx-voltage', {label='TxV', decimals=1})
        },
        -- more stuff...
    }

In the example above, we show a "Flaps" status for the 'Mustang' and 'Beaver'
models while showing TX voltage for everyone else.  The idea is that other
models we own don't have flaps and it would be better to use the space for
something else.

#### Dynamic Config - Per radio (or model) layouts

The function *chooseSetup* returns the layout config.  This can simply return a
set config or can optionaly contain any sort of logic you want.  Here is a
simple script that returns a different config depending on radio model:

  local QX7_Layout = {
    -- stuff
  }

  local X9D_Layout = {
    -- stuff
  }

  local function chooseSetup()
    local _, radio = getVersion()
  
  
    if string.find(radio, 'x9D') ~= nil then
      return X9D_Layout
    end

    return QX7_Layout
  end

### Resetting

You may want to reset the telemetry graph when resetting a flight, or when a
switch is toggled.  This can be done with a global variable.

To start, choose a global variable index to use.  Then set this in your config
to that index:

  resetGlobalVarIndex = 5  -- choose GV6

Now, any time you want to reset the telemetry, write a non-zero value to that
variable.  A basic setup is to create a special function that changes the
variable.
