-- this is our main menu, so we give nil for the first argument
local menu = freeswitch.IVRMenu(nil,
    "lua_demo_ivr",
    "phrase:demo_ivr_main_menu",
    "phrase:demo_ivr_main_menu_short", 
    "ivr/ivr-that_was_an_invalid_entry.wav", 
    "voicemail/vm-goodbye.wav", 
    nil,
    nil, 
    nil, 
    nil, 
    nil,
    -1,
    2000,
    4,
    10000,
    3,
    -1)

-- this is the submenu, so we give the menu we just instantiated as the first argument
local sub_menu = freeswitch.IVRMenu(menu,
    "lua_demo_ivr_submenu",
    "phrase:demo_ivr_sub_menu",
    "phrase:demo_ivr_sub_menu_short",
    "ivr/ivr-that_was_an_invalid_entry.wav",
    "voicemail/vm-goodbye.wav",
    nil,
    nil,
    nil,
    nil,
    nil,
    -1,
    2000,
    4,
    10000,
    3,
    -1)

-- here we are binding the same actions as in the FreeSWITCH™ demo IVR
menu:bindAction("menu-exec-app", "bridge sofia/$${domain}/888@conference.freeswitch.org", "1")
menu:bindAction("menu-exec-app", "transfer 9196 XML default", "2")
menu:bindAction("menu-exec-app", "transfer 9664 XML default", "3")
menu:bindAction("menu-exec-app", "transfer 9191 XML default", "4")
menu:bindAction("menu-exec-app", "transfer 1234*256 enum", "5")
menu:bindAction("menu-sub", "lua_demo_ivr_submenu", "6")
menu:bindAction("menu-exec-app", "transfer $1 XML default", "/^(10[01][0-9])$/")
menu:bindAction("menu-top", nil, "9")
menu:bindAction("menu-exit", nil, "*")

-- since we bound submenu to menu at its instantiation, pressing * will go back to menu
sub_menu:bindAction("menu-top", nil, "*")


-- answer the session
session:answer()

-- execute the menu on the session
menu:execute(session, "lua_demo_ivr")
