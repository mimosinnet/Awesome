-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

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
    awesome.add_signal("debug::error", function (err)
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

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/mimosinnet/.config/awesome/themes/mimosinnet/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "File", "Mail", "Off", "FF", "Sys", "Oci", "Chro", "Net", "Aw" }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu

-- Definition of individual menus (JPT) {{{

Menu_File = {
	{"&1_vifm", "urxvtc -e vifm"},
	{"&2_Muntar usb", "urxvtc -e /usr/local/bin/Munta.sh usb" }
}

M_File = awful.menu (
	{items = Menu_File}
)

Menu_Mail = {
	{"&1_Mutt", "urxvtc -j -ss -e Correu.sh correu " },
	{"&2_OfflineImap", "urxvtc -j -ss -e offlineimap " },
	{"&3_MuttLineEditor", "xmessage -nearmouse -file ~/.fvwm/conf/MuttLineEditorKeys.txt" },
	{"&4_MuttPatternModifier", "xmessage -nearmouse -file ~/.fvwm/conf/MuttPatternModifier.txt" },
	{"&5_Telf UAB", "gvim ~/Dades/Documents/Personal/Directori/UAB.txt" }
}

M_Mail = awful.menu (
	{items = Menu_Mail}
)

Menu_Office = {
	{ "&1_loWriter", "lowriter" },
	{ "&2_loCalc", "localc" },
	{ "&3_loDraw", "lodraw" },
	{ "&4_loFromTemplate", "lofromtemplate" },
	{ "&5_loMath", "lomath" },
	{ "&6_loWeb", "loweb" },
	{ "&7_loImpress", "loimpress" },
	{ "&8_loBase", "lobase" },
	{ "&9_freemind", "freemind" },
	{ "&A_pdfedit", "pdfedit" },
	{ "&B_AcroRead", "acroread" }
}

M_Office = awful.menu (
	{items = Menu_Office}
)

Menu_Fox = {
	{ "&1_Firefox", "firefox"}
}

M_Fox = awful.menu (
	{items = Menu_Fox}
)

Menu_Sys = {
	{ "&1_Consola", "urxvtc" },
	{ "&2_ConsolRecov", "urxvtd -f" },
	{ "&3_LinuxHelp", "urxvtc -e vim ~/Dades/Documents/Linux/linux.txt" },
	{ "&4_Teclat es", " setxkbmap -model pc104 -layout es" },
	{ "&5_xterm", "xterm" },
	{ "&6_unetBootin", "unetbootin" },
	{ "&7_xkeycaps", "xkeycaps" },
	{ "&8_View Elogs", 'urxvtc -geometry 128x42 -e bash -c "su -c elogv"' },
	{ "&9_MouseNormal", 'xmodmap -e "pointer = 1 2 3 4 5"' }
}

M_Sys = awful.menu (
	{items = Menu_Sys}
)

Menu_Oci = {
	{ "&1_xBoard", "/usr/local/bin/Xboard_Crafty.sh" },
	{ "&2_Musica", "mocp -T transparent-background" },
	{ "&3_Llibres", "calibre" },
	{ "&4_MirarOno", "mplayer tv:// driver=v4l2:device=/dev/video0" },
	{ "&5_MirarTV", "mplayer tv:// driver=v4l2:device=/dev/video1" },
	{ "&6_Scid", "scid" },
	{ "&7_qGo", "qgo" },
	{ "&8_cGoban", "cgoban" },
	{ "&9_Eboard", "eboard" },
	{ "&A_TvTime", "tvtime" },
	{ "&B_WebCam", "LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so mplayer tv:// -tv driver=v4l:width=352:height=288:device=/dev/video0" },
	{ "&C_Moc", "urxvtc -e mocp" },
	{ "&D_Xv", "xv" },
	{ "&E_Feh", "feh" },
	{ "&F_Gimp", "gimp" },
	{ "&G_Inkscape", "inkscape" }
}

M_Oci = awful.menu (
	{items = Menu_Oci}
)


Menu_Chrome = {
	{ "&1_Chrome", "google-chrome" }
}

M_Chrome = awful.menu (
	{items = Menu_Chrome}
)


Menu_Xarxa = {
	{ "&1_Wicd", "wicd-gtk -n" },
	{ "&2_rssi", "urxvtc -e irssi" },
	{ "&3_Skype", "skype" },
	{ "&4_NXClient", "nxclient" },
	{ "&5_wpa_gui", "wpa_gui" },
	{ "&6_skype", "skype" },
	{ "&7_rtorrent", "urxvtc -e rtorrent" },
	{ "&8_vlc", "vlc" },
	{ "&9_DistccMon", 'urxvtc -e su -c "/usr/local/bin/Distcc.sh"' }
}

M_Xarxa = awful.menu (
	{items = Menu_Xarxa}
)


Menu_Awesome = {
	{ "&1_gVim", "gvim" },
	{ "&2_alsamixer", "urxvtc -e alsamixer" },
	{ "&3_xcalc", "xcalc" },
	{ "&4_Gcolor2", "gcolor2" },
	{ "&5_screenShot", "import ~/Dades/Imatges/ScreenShots/`date +%F_%R`.png" },
    { "&6_manual", terminal .. " -e man awesome" },
    { "&7_edit config", editor_cmd .. " " .. awesome.conffile },
    { "&8_restart", awesome.restart },
    { "&9_quit", awesome.quit }
}

M_Awesome = awful.menu (
	{items = Menu_Awesome}
)

-- }}}

-- Definition of main menu {{{

mymainmenu = awful.menu(
	{ items = 
		{ 
			{ "&1_File", Menu_File },
			{ "&2_Mail", Menu_Mail },
			{ "&3_Office", Menu_Office },
			{ "&4_Fox", Menu_Fox },
			{ "&5_Sys", Menu_Sys },
			{ "&6_Oci", Menu_Oci},
			{ "&7_Chrome", Menu_Chrome },
			{ "&8_Xarxa", Menu_Xarxa },
			{ "&9_awesome", Menu_Awesome, beautiful.awesome_icon },
		}
	}
)

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}


-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

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
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
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
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings

-- {{{ Globalkeys
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

	-- Help (JPT)
    awful.key({}, "F1", function () awful.util.spawn( 
			"xmessage -nearmouse -file /home/mimosinnet/.config/awesome/keys_xmessage.txt", false) 
	end),

	-- Tecla Menu (JPT)
    awful.key({}         , "Menu", function () mymainmenu:show({keygrabber=true}) end),

    -- Screen Shot (JPT)
    awful.key({           }, "Print", function () awful.util.spawn( "Print_Screen window", false) end),
    awful.key({ modkey    }, "Print", function () awful.util.spawn( "Print_Screen delay" , false) end),
    awful.key({ "Shift"   }, "Print", function () awful.util.spawn( "Print_Screen area"  , false) end),
    awful.key({ "Control" }, "Print", function () awful.util.spawn( "Print_Screen root"  , false) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

--- }}}

-- ClientKeys {{{
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),

	-- Move Window to Workspace Left/Right (JPT) {{{
	-- http://awesome.naquadah.org/wiki/Move_Window_to_Workspace_Left/Right
	awful.key({ modkey, "Shift"   }, ",",
    function (c)
        local curidx = awful.tag.getidx(c:tags()[1])
        if curidx == 1 then
            c:tags({screen[mouse.screen]:tags()[9]})
        else
            c:tags({screen[mouse.screen]:tags()[curidx - 1]})
        end
    end),
	awful.key({ modkey, "Shift"   }, ".",
	  function (c)
			local curidx = awful.tag.getidx(c:tags()[1])
			if curidx == 9 then
				c:tags({screen[mouse.screen]:tags()[1]})
			else
				c:tags({screen[mouse.screen]:tags()[curidx + 1]})
			end
		end)
	-- }}}

)

--- }}}

-- Numeric pad (JPT) {{{
Numeric_Pad = { "KP_End", "KP_Down", "KP_Next", "KP_Left", "KP_Begin", "KP_Right", "KP_Home", "KP_Up", "KP_Prior" }
Menu_Table  = { M_File, M_Mail, M_Office, M_Fox, M_Sys, M_Oci, M_Chrome, M_Xarxa, M_Awesome }

for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
		-- Got to tag with numeric pad  
		awful.key({ }, Numeric_Pad[i], function () awful.tag.viewonly(tags[mouse.screen][i]) end),
		-- Go to tag and show menu with shift and numeric pad 
		awful.key({ "Shift" }, Numeric_Pad[i], function () 
				awful.tag.viewonly(tags[mouse.screen][i])
				Menu_Table[i]:show({keygrabber=true}) 
		end),
		-- Show menu with control and numeric pad
		awful.key({ "Control" }, Numeric_Pad[i], function () 
				Menu_Table[i]:show({keygrabber=true}) 
		end)

	)
end
-- }}}

-- Bind Numbers to tags {{{

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
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

-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { 
			  border_width = beautiful.border_width,
              border_color = beautiful.border_normal,
              focus = true,
              keys = clientkeys,
              buttons = clientbuttons } },
	{ rule_any = { class = { "URxvt", "Firefox", "Google-chrome", "Gvim" }},
		properties = {
			  maximized_vertical = true,
			  maximized_horizontal = true } },
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
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
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
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- vim: tabstop=4
