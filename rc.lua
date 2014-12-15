-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")
local lain = require("lain")
require("style")
require("keys")

--Vain
--local vain = require("vain")
--vain.widgets.terminal = "terminator"

lain.layout.termfair.nmaster = 2
lain.layout.termfair.ncol = 1

lain.layout.cascadetile.cascade_offset_x = 2
lain.layout.cascadetile.cascade_offset_y = 32
lain.layout.cascadetile.extra_padding = 5
lain.layout.cascadetile.nmaster = 5

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

--Overriding awesome quit function if awesome-gnome is used
_awesome_quit = awesome.quit
awesome.quit = function()
    if os.getenv("DESKTOP_SESSION") == "awesome-gnome" then
        os.execute("/usr/bin/gnome-session-quit")
    else
        _awesome_quit()
    end
end

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers

--{{---| Theme | -------------------------------------

-- Todo:  Please change the "ep" to your $USER
config_dir = ("/home/frans/.config/awesome/")
themes_dir = (config_dir .. "/powerarrowf")

beautiful.init(themes_dir .. "/theme.lua")

-- This is used later as the default terminal, browser and editor to run.
terminal = "termite"
terminal = "terminator -p awesome"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
browser = "firefox"
fileBrowser = "nautilus"

font = "Inconsolata 11"

-- {{ These are the power arrow dividers/separators }} --
--[[
arr1 = wibox.widget.imagebox()
arr1:set_image(beautiful.arr1)
arr2 = wibox.widget.imagebox()
arr2:set_image(beautiful.arr2)
arr3 = wibox.widget.imagebox()
arr3:set_image(beautiful.arr3)
arr4 = wibox.widget.imagebox()
arr4:set_image(beautiful.arr4)
arr5 = wibox.widget.imagebox()
arr5:set_image(beautiful.arr5)
arr6 = wibox.widget.imagebox()
arr6:set_image(beautiful.arr6)
arr7 = wibox.widget.imagebox()
arr7:set_image(beautiful.arr7)
arr8 = wibox.widget.imagebox()
arr8:set_image(beautiful.arr8)
arr9 = wibox.widget.imagebox()
arr9:set_image(beautiful.arr9)
]]--
arr1 = wibox.widget.imagebox()
arr1:set_image(style.arr1)
arr2 = wibox.widget.imagebox()
arr2:set_image(style.arr1)
arr3 = wibox.widget.imagebox()
arr3:set_image(style.arr1)
arr4 = wibox.widget.imagebox()
arr4:set_image(style.arr1)
arr5 = wibox.widget.imagebox()
arr5:set_image(style.arr1)
arr6 = wibox.widget.imagebox()
arr6:set_image(style.arr1)
arr7 = wibox.widget.imagebox()
arr7:set_image(style.arr1)
arr8 = wibox.widget.imagebox()
arr8:set_image(style.arr1)
arr9 = wibox.widget.imagebox()
arr9:set_image(style.arr1)

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
awful.util.spawn("setxkbmap -option caps:Mod4")
-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    --lain.layout.cascadetile,
    lain.layout.uselesstile,
    lain.layout.uselessfair,
    lain.layout.termfair,
    awful.layout.suit.tile
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5}, s, layouts[2])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
systemMenu = {
        {"Shutdown", function() os.execute("poweroff"); end},
        {"Reboot", function() os.execute("reboot"); end}
    }

myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit },
   --{ "shutdown", "shutdown"}
   --{ "Shutdown", function () os.execute("poweroff");end}
   { "system", systemMenu, beautiful.awesome_icon}
}

programMenu = {
    {"Browser", function() awful.util.spawn(browser) end},
    {"Files", function() awful.util.spawn(fileBrowser) end}
}
mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
menubar.menu_gen.all_menu_dirs = { "/usr/share/applications/", "/usr/local/share/applications", "~/.local/share/applications" }


-- }}}

-- {{{ Wibox

--{{-- Time and Date Widget }} --
tdwidget = wibox.widget.textbox()
local strf = '<span font="' .. font .. '" color="' .. style.foregroundMain .. '" background="' .. style.backgroundColor .. '">%b %d %H:%M</span>'
vicious.register(tdwidget, vicious.widgets.date, strf, 20)

clockicon = wibox.widget.imagebox()
clockicon:set_image(beautiful.clock)

--{{ Net Widget }} --
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net, function(widget, args)
    local interface = ""
    if args["{wlp2s0 carrier}"] == 1 then
        interface = "wlp2s0"
    elseif args["{enp0s25 carrier}"] == 1 then
        interface = "enp0s25"
    else
        return ""
    end
    return '<span background="' .. style.backgroundColor .. '" font="Inconsolata 11"> <span font ="Inconsolata 11" color="' .. style.foregroundMain .. '">'..args["{"..interface.." down_kb}"]..'kbps'..'</span></span>' end, 10)


---{{---| Wifi Signal Widget |-------
neticon = wibox.widget.imagebox()
vicious.register(neticon, vicious.widgets.wifi, function(widget, args)
    local sigstrength = tonumber(args["{link}"])
    if sigstrength > 69 then
        neticon:set_image(beautiful.nethigh)
    elseif sigstrength > 40 and sigstrength < 70 then
        neticon:set_image(beautiful.netmedium)
    else
        neticon:set_image(beautiful.netlow)
    end
end, 120, 'wlp2s0')


--{{ Battery Widget }} --
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.baticon)

batwidget = wibox.widget.textbox()
vicious.register( batwidget, vicious.widgets.bat, '<span background="' .. style.backgroundColor .. '" font="Inconsolata 11"><span font="Inconsolata 11" color="' .. style.foregroundMain .. '" background="' .. style.backgroundColor .. '">$1$2% </span></span>', 30, "BAT1" )

--{{---| File Size widget |-----
fswidget = wibox.widget.textbox()

vicious.register(fswidget, vicious.widgets.fs,
'<span background="' .. style.backgroundColor .. '" font="Inconsolata 11"> <span font="Inconsolata 11" color="' .. style.foregroundMain .. '">${/home used_gb}/${/home avail_gb} GB </span></span>', 
800)

fsicon = wibox.widget.imagebox()
fsicon:set_image(beautiful.fsicon)

----{{--| Volume / volume icon |----------
volume = wibox.widget.textbox()
vicious.register(volume, vicious.widgets.volume,
'<span background="' .. style.backgroundColor .. '" font="Inconsolata 11"><span font="Inconsolata 11" color="' .. style.foregroundMain .. '"> Vol:$1 </span></span>', 0.3, "Master")

volumeicon = wibox.widget.imagebox()
vicious.register(volumeicon, vicious.widgets.volume, function(widget, args)
    local paraone = tonumber(args[1])

    if args[2] == "♩" or paraone == 0 then
        volumeicon:set_image(beautiful.mute)
    elseif paraone >= 67 and paraone <= 100 then
        volumeicon:set_image(beautiful.volhi)
    elseif paraone >= 33 and paraone <= 66 then
        volumeicon:set_image(beautiful.volmed)
    else
        volumeicon:set_image(beautiful.vollow)
    end

end, 0.3, "Master")



--{{---| CPU / sensors widget |-----------
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu,
'<span background="' .. style.backgroundColor .. '" font="Inconsolata 11"> <span font="Inconsolata 11" color="' .. style.foregroundMain .. '">$2%<span color="' .. style.foregroundMain .. '">·</span>$3% </span></span>', 5)

cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.cpuicon)

--{{--| MEM widget |-----------------
memwidget = wibox.widget.textbox()

vicious.register(memwidget, vicious.widgets.mem, '<span background="' .. style.backgroundColor .. '" font="Inconsolata 11"> <span font="Inconsolata 11" color="' .. style.foregroundMain .. '" background="' .. style.backgroundColor .. '">$2MB </span></span>', 20)
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.mem)

--{{--| Mail widget |---------
mailicon = wibox.widget.imagebox()

vicious.register(mailicon, vicious.widgets.gmail, function(widget, args)
    local newMail = tonumber(args["{count}"])
    if newMail > 0 then
        mailicon:set_image(beautiful.mail)
    else
        mailicon:set_image(beautiful.mailopen)
    end
end, 15)

--keyboard layout
kbdLayoutWidget = wibox.widget.background();
kbdLayoutText = wibox.widget.textbox();
kbdLayoutWidget:set_widget(kbdLayoutText)
kbdLayoutWidget:set_fg(style.foregroundMain)
--kbdLayoutWidget:set_text('<span background="#777E76" font="Inconsolata 11"> <span font="Inconsolata 11" color="#EEEEEE" background="#777E76">$2MB </span></span>')
kbdLayoutText:set_text('us')

keyboardLayout = {}
keyboardLayout.cmd = "setxkbmap"
keyboardLayout.layouts = {"us", "se"}
keyboardLayout.current = 1
keyboardLayout.set = function(index)
        keyboardLayout.current = index
        os.execute(keyboardLayout.cmd .. " " .. keyboardLayout.layouts[index])
        
        kbdLayoutText:set_text(" " .. keyboardLayout.layouts[index] .. " ")
    end
keyboardLayout.cycle = function()
        nLayout = keyboardLayout.current + 1

        if(nLayout > #keyboardLayout.layouts) then
            nLayout = 1
        end

        os.execute(keyboardLayout.set(nLayout))
    end

keyboardLayout.set(1)


-- to make GMail pop upwesome wm display imageawesome wm display imageawesome
-- wm display imageawesome wm display image when pressed:
mailicon:buttons(awful.util.table.join(awful.button({ }, 1,
function () awful.util.spawn_with_shell(browser .. " gmail.com") end)))

--Brightness
brightnessWidget = wibox.widget.textbox();
brightnessBgWidget = wibox.widget.background();
brightnessBgWidget:set_bg(style.backgroundColor)
brightnessBgWidget:set_widget(brightnessWidget)
brightnessBgWidget:set_fg(style.foregroundMain)
brightnessIcon = wibox.widget.imagebox()
brightnessIcon:set_image(beautiful.brightness)

function getBrightness()
    --brightStr = os.execute("xbacklight")
    local handle = io.popen("xbacklight")
    local brightStr = handle:read("*a")
    handle:close()
    --Strip the decimals
    if(not brightVal == nil) then
        brightVal = math.ceil(tonumber(brightStr))
    end
    
    return brightVal
end
function updateBrightnessWidget()
    if(not getBrightness() == nil) then
        brightnessWidget:set_text("" .. getBrightness() .. " ");
    end
end
function changeBrightness(amount)
    flag = "-inc"
    if(amount < 0) then
        flag = "-dec"
    end

    --awful.util.spawn("xbacklight " .. flag .. " " .. math.abs(amount))
    os.execute("xbacklight " .. flag .. " " .. math.abs(amount))

    updateBrightnessWidget()
end

--changeBrightness(100)
updateBrightnessWidget()

--{{{ == CPU temp == }}}---
function getTemp()
    local cmd = "sensors | grep id | cut -d ' ' -f 5"
    local handle = io.popen("sensors | grep id | cut -d ' ' -f 5");
    local result = handle:read("*a")
    handle:close();

    --Strip the result
    --Remove the sign and other stuff
    result = result:sub(2, -7)

    result = result .. " °C"


    return result
end
tempWidget = wibox.widget.textbox()
tempBgWidget = wibox.widget.background()
tempBgWidget:set_widget(tempWidget)
--tempBgWidget:set_bg("#4B696D")
--tempBgWidget:set_fg("#DDDDDD")
tempBgWidget:set_bg(style.backgroundColor)
tempBgWidget:set_fg(style.foregroundMain)

function updateTempWidget()pp_folders = { "/usr/share/applications/", "~/.local/share/applications/" }
    tempWidget:set_text("" .. getTemp() .. " ")
end
updateTempWidget()

--Update loop for widgets
mytimer = timer({ timeout = 2 })
mytimer:connect_signal("timeout", function()
        updateTempWidget()
    end)
mytimer:start()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = "16" })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end

    right_layout:add(kbdLayoutWidget)
    --right_layout:add(arr9)
    --right_layout:add(mailicon)
    right_layout:add(arr8)
    --right_layout:add(memicon)
    right_layout:add(memwidget)
    right_layout:add(arr7)
    --right_layout:add(cpuicon)
    right_layout:add(cpuwidget)
    right_layout:add(tempBgWidget)
    right_layout:add(arr6)
    --right_layout:add(volumeicon)
    right_layout:add(volume)
    --right_layout:add(arr5)
    --right_layout:add(brightnessIcon)
    right_layout:add(brightnessBgWidget)
    right_layout:add(arr4)
    --right_layout:add(fsicon)
    --right_layout:add(fswidget)
    --right_layout:add(kbdcfg);
    --right_layout:add(baticon)
    right_layout:add(batwidget)
    right_layout:add(arr3)
    --right_layout:add(neticon)
    --right_layout:add(netwidget)
    --right_layout:add(arr2)
    --right_layout:add(clockicon)
    right_layout:add(tdwidget)
    right_layout:add(arr1)
    right_layout:add(mylayoutbox[s])

    
    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

--Binding the mousebuttons
root.buttons(awful.util.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end) --Right click menu,
))

--Also binding the right click menu to a key
globalkeys = awful.util.table.join(
    awful.key({"Control",}, "`", function() mymainmenu:toggle() end),
    awful.key({"Control",}, keys.openMenu, function() mymainmenu:toggle() end),
    
    --Vim like controlls
    awful.key({modkey, }, "l",
        function()
            awful.client.focus.bydirection("right")
            if(client.focus) then client.focus:raise() end
        end),
    awful.key({modkey, }, "h",
        function()
            awful.client.focus.bydirection("left")
            if(client.focus) then client.focus:raise() end
        end),
    awful.key({modkey, }, "j",
        function()
            awful.client.focus.bydirection("down")
            if(client.focus) then client.focus:raise() end
        end),
    awful.key({modkey, }, "k",
        function()
            awful.client.focus.bydirection("up")
            if(client.focus) then client.focus:raise() end
        end),

    awful.key({modkey}, "F1", function() awful.screen.focus(2) end),
    awful.key({modkey}, "F2", function() awful.screen.focus(1) end),

    --Run menu
    --awful.key({modkey}, "r", function() mypromptbox[mouse.screen]:run() end),
    awful.key({modkey}, "r", function() menubar.show() end),

    --Programs
    awful.key({modkey, }, "Return", function() awful.util.spawn(terminal) end),

    --Layout keys
    awful.key({"Control", }, "space", awful.client.floating.toggle),
    --Layout change
    awful.key({modkey,}, "o", function() awful.layout.inc(layouts, 1) end),
    awful.key({modkey,}, "p", function() awful.layout.inc(layouts, -1) end),

    
    --Keyboard layout change
    awful.key({modkey, "Shift"}, "space", keyboardLayout.cycle),

    --Volume control
    awful.key({}, "XF86AudioRaiseVolume", function() awful.util.spawn("amixer set Master 5%+", false) end),
    awful.key({}, "XF86AudioLowerVolume", function() awful.util.spawn("amixer set Master 5%-", false) end),
    awful.key({}, "XF86AudioMute", function() awful.util.spawn("amixer set Master toggle", false) end),


    --Brightness change
    awful.key({}, "XF86MonBrightnessDown", function()
            --awful.util.spawn("xbacklight -dec 15")
            changeBrightness(-15)
        end),
    awful.key({}, "XF86MonBrightnessUp", function()
            --awful.util.spawn("xbacklight -inc 15")
            changeBrightness(15)
        end),

    awful.key({}, "XF86AudioRaiseVolume", function()
        awful.util.spawn("amixer set master 5%+", false) 
    end),
    awful.key({}, "XF86AudioLowerVolume", function()
        awful.util.spawn("amixer set master 5%-", false) 
    end),


    --Window modification keys
    awful.key({modkey, "Shift"}, "j", function() awful.tag.incmwfact(-0.05) end),
    awful.key({modkey, "Shift"}, "k", function() awful.tag.incmwfact(-0.05) end)
)

for i=0, 9 do
    globalkeys = awful.util.table.join(
        globalkeys,
        awful.key({modkey,}, tostring(i), function()
            local scren = mouse.screen
            local tag = awful.tag.gettags(screen)[i]
            if(client.focus and tag) then
                awful.client.viewtoggle(tag)
             end
        end)
        )
end


--Keys for specific clients
clientkeys = awful.util.table.join(
    awful.key({modkey}, "q", function(c) c:kill() end),

    --Moving windows
    awful.key({modkey}, "w", function(c) awful.client.cycle(true) end),
    awful.key({modkey}, "b", function(c) awful.client.cycle(false) end)
)
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

-- battery warning
local function trim(s)
  return s:find'^%s*$' and '' or s:match'^%s*(.*%S)'
end

local function bat_notification()
    capFile = io.open("/sys/class/power_supply/BAT0/capacity", "r")
    statusFile = io.open("/sys/class/power_supply/BAT0/status", "r")

    if(capFile == nil or statusFile == nil) then
        --Making sure the file exists
        return
    end

	local f_capacity = capFile
    local f_status = statusFile
	local bat_capacity = tonumber(f_capacity:read("*all"))
	local bat_status = trim(f_status:read("*all"))

	if (bat_capacity <= 10 and bat_status == "Discharging") then
		naughty.notify({ title      = "Battery Warning"
		    , text       = "Battery low! " .. bat_capacity .."%" .. " left!"
		    , fg="#ffffff"
		    , bg="#C91C1C"
		    , timeout    = 15
		    , position   = "bottom_right"
		})
	end
end

battimer = timer({timeout = 60})
battimer:connect_signal("timeout", bat_notification)
battimer:start()

-- end here for battery warning



-- {{ Function to ensure that certain programs only have one
-- instance of themselves when i restart awesome

function run_once(cmd)
        findme = cmd
        firstspace = cmd:find(" ")
        if firstspace then
                findme = cmd:sub(0, firstspace-1)
        end
        awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

-- {{ I need redshift to save my eyes }} -
run_once("redshift -l 49.26:-123.23")
awful.util.spawn_with_shell("xmodmap ~/.speedswapper")

-- {{ Turns off the terminal bell }} --
awful.util.spawn_with_shell("/usr/bin/xset b off")

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
